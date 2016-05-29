##
# Andrew Berger
# Project03
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

module Project03

  class Instance < Node

    attr_accessor :klass, :scope

    def initialize(klass, values)
      super(value: "Instance", type: :Instance)
      @klass = klass

      # to make deep_dup easier, we provide a way to get a clean Instance
      if !@klass.nil?
        @scope_chain = @klass.scope_chain.deep_dup
        @scope = @scope_chain.tail

        # inject correct _this
        @scope_chain.overwrite(:_this, self)

        # _super is just a trick of  which causes Procs.InstanceMemberAccess_proc
        # to move up the scope_chain before accessing something
        @scope_chain.overwrite(:_super, self)

        # tediously set the correct scope_chain on all the functions in the scope_chain
        # because they're still pointing at the klass's scope_chain
        correct_member_scope_chains

        if !@klass.creator.nil?
          creator = @scope_chain.access(:_creator) # we want OUR creator

          values = [*values]

          # check constructor arity vs argument number
          if values.length != creator.params.length
            raise StandardError, "wrong number of arguments (given #{values.length}, expected #{creator.params.length})"
          end

          # inject the initial values into the creator
          if creator.params && creator.params.length > 0
            creator.body.children[1] = values
          end

          # evaluate the creator
          creator.body.type = :FunctionBody
          creator.body.evaluate
        end
      end
    end

    ##
    # Ensure all the member Functions in our scope_chain have the correct scope_chain set,
    # so that we can be sure, for example, they have the correct _this and _class and _super.
    def correct_member_scope_chains(scope=@scope_chain.tail)
      scope.locals.each do |key, val|
        if val.instance_of?(Function)
          val.scope_chain = @scope_chain
        end
      end

      if scope != scope.parent
        correct_member_scope_chains(scope.parent)
      end
    end

    ##
    # Instances cannot be deeply duplicated. Just cuz.
    def deep_dup
      self
    end

  end # end Instance

  class Procs

    ##
    # Evaluating an Instance returns the Instance.
    def self.Instance_proc
      self.Self_proc
    end

    ##
    # Used to access a symbol defined on an Instance. E.g. _this.name, foo.bar, etc.
    def self.InstanceMemberAccess_proc
      lambda do |node|
        instance = node.children[0].evaluate

        if !instance.instance_of?(Instance)
          raise StandardError, "wrong type (given #{instance.class}, expected Instance)"
        end

        scope  = instance.scope

        # if we're trying to execute a superklass method, navigate one up the chain
        if :_super == node.children[0].value
          scope = scope.parent
        end

        scope.access(node.value)
      end
    end

    ##
    # Used to assign a symbol defined on an Instance. E.g. _this.name="foo", foo.bar=function{}, etc.
    def self.InstanceMemberAssignment_proc
      lambda do |node|
        instance = node.children[0].evaluate

        if !instance.instance_of?(Instance)
          raise StandardError, "wrong type (expected Instance)"
        end

        # set the proper scope_chain if the rvalue is a function, so that we can add new member functions
        if node.children[1].instance_of?(Function)
          node.children[1].scope_chain = instance.scope_chain
        end

        instance.scope.assign_local(node.value, node.children[1].evaluate)
      end
    end

  end # end Procs

end # end module
