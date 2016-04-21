##
# Andrew Berger
# Project03
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

module Project03

  ##
  # A Class definition node.
  class Klass < Node

    attr_accessor :body, :members, :super_klass, :creator

    def initialize(body: Node.new, super_klass: nil)
      super(value: "Class", children: body, type: :KlassDefinition)
      @body = body
      @members = {}
      @creator = nil
      @super_klass = super_klass
    end

    ##
    # Invoking a Klass results in its instantiation with the given arguments passed to the _creator function.
    def invoke(arguments)
      Instance.new(self, arguments)
    end

  end # end

  ##
  # Klass semantics.
  class Procs

    def self.KlassDefinition_proc
      lambda do |node|
        # classes get a new ScopeChain which copied from their super_klass
        scope = nil
        if node.super_klass.nil?
          node.scope_chain = ScopeChain.new
          scope = node.scope_chain.tail
        else
          klass = node.super_klass.evaluate
          if klass.type != :KlassDefinition
            raise StandardError, "wrong type (given #{klass.type}, expected Class)"
          end

          node.scope_chain = klass.scope_chain.deep_dup
          scope = node.scope_chain.push

          # _super is just a trick which causes Procs.InstanceMemberAccess_proc
          # to move up the scope_chain before accessing something
          scope.assign_local(:_super, nil)
        end

        # inject _this with nil so we can overwrite it on instantiation (after duping the scope_chain)
        scope.assign_local(:_class, node)
        scope.assign_local(:_this, nil)

        # check out the children
        for child in node.children[0].children
          [:_this, :_class, :_super].each do |reserved|
            raise StandardError, "`#{reserved.to_s}' is a reserved symbol within Class body" if reserved == child.value
          end

          value = child.children[0]
          if :FunctionDefinition != value.type
            value = child.children[0].evaluate
            raise StandardError, "only Functions can be assigned within Class body" if :FunctionDefinition != value.type
          end

          if :_creator == child.value
            node.creator = value
          end

          scope.assign_local(child.value, value)
        end

        node
      end
    end # end KlassDefinition_proc

  end # end Procs

end # end module
