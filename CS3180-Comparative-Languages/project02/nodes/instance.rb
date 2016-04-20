##
# Andrew Berger
# Project02
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

require "pry"
require "pry-byebug"

require "./extensions"
# require "./scope"

module Project02

  class Instance < Node

    attr_accessor :klass, :scope

    def initialize(klass, values)
      super(value: "Instance", type: :Instance)
      @klass = klass

      # to make deep_dup easier, we provide a way to get a clean Instance
      if !@klass.nil?
        @scope_chain = @klass.scope_chain.deep_dup
        @scope = @scope_chain.tail

        # binding.pry

        # inject correct _this
        @scope_chain.overwrite(:_this, self)

        # _super is just a trick of  which causes Procs.InstanceMemberAccess_proc
        # to move up the scope_chain before accessing something
        @scope_chain.overwrite(:_super, self)

        # tediously set the correct scope_chain on all the functions in the scope_chain
        # because they're still pointing at the klass's scope_chain
        # populate_members
        correct_member_scope_chains(@scope_chain.tail)

        # check constructor arity vs argument number
        # binding.pry
        if @klass.creator.nil?
          # if we have a super_klass, call its constructor
          creator = nil
          if !@klass.super_klass.nil?
            # creator = @klass.super_klass.resolve_creator
          end
        else
          creator = @scope_chain.access(:_creator) # we want OUR creator

          # @scope_chain.describe

          # binding.pry

          values = [*values]

          if values.length != creator.params.length
            raise StandardError, "wrong number of arguments (given #{values.length}, expected #{creator.params.length})"
          end

          if creator.params.length > 0
            # inject the initial values into the creator and evaluate it
            # binding.pry
            creator.body.type = :FunctionBody
            creator.body.children[1] = values
            creator.body.evaluate
          end
        end
      end
    end

    def populate_members
      # puts "::populate_members"
      @klass.members.each do |symbol, function|
        # binding.pry
        puts ":: populate_members #{symbol}"
        function.scope_chain = @scope_chain
        
        @scope_chain.assign_local(symbol, function)
      end
    end

    def correct_member_scope_chains(scope)
      scope.locals.each do |key, val|
        if val.instance_of?(Function)
          val.scope_chain = @scope_chain
        end
      end

      if scope != scope.parent
        correct_member_scope_chains(scope.parent)
      end
    end

    def deep_dup
      self
    end

  end # end Instance

  class Procs
    ##
    #
    def self.Instance_proc
      self.Self_proc
    end

    ##
    #
    def self.InstanceMemberAccess_proc
      lambda do |node|
        instance = node.children[0].evaluate

        # binding.pry

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
    #
    def self.InstanceMemberAssignment_proc
      lambda do |node|
      # puts "::instance_member_assignment_proc"
        instance = node.children[0].evaluate

        # binding.pry

        if !instance.instance_of?(Instance)
          raise StandardError, "wrong type (expected Instance)"
        end

        # set the proper scope_chain if the rvalue is a function, so that we can add new member functions
        if node.children[1].instance_of?(Function)
          node.children[1].scope_chain = instance.scope_chain
        end

        # instance.scope_chain.describe
        # binding.pry

        # puts "::instance_member_assignment_proc"
        # instance.scope_chain.describe


        instance.scope.assign_local(node.value, node.children[1].evaluate)

        # puts "::instance_member_assignment_proc"
        # instance.scope_chain.describe

      end
    end

  end # end Procs

end # end module
