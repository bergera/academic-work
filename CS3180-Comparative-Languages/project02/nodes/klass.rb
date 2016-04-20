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
require "./scope"

module Project02

  class Klass < Node

    attr_accessor :body, :members, :super_klass, :creator

    def initialize(body: Node.new, super_klass: nil)
      super(value: "Class", children: body, type: :KlassDefinition)
      @body = body
      @members = {}
      @creator = nil
      @super_klass = super_klass
    end

    def resolve_creator
      if @creator.nil?
        if @super_klass.nil?
          return nil
        else
          return @super_klass.resolve_creator
        end
      else
        return @creator
      end
    end

    def access_member(symbol)
      return @members[symbol] if @members.has_key?(symbol)
      return @super_klass.access_member(symbol) if !@super_klass.nil?
      raise StandardError, "undefined member symbol `#{symbol}'"
    end

    ##
    #
    def invoke(arguments)
      Instance.new(self, arguments)
    end

  end # end

  class Procs
    ##
    #
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
          # node.scope_chain = ScopeChain.new(klass.scope_chain.tail)
          scope = node.scope_chain.push

          # _super is just a trick of  which causes Procs.InstanceMemberAccess_proc
          # to move up the scope_chain before accessing something
          scope.assign_local(:_super, nil)
        end

        # inject _this with nil so we can overwrite it later on instance create
        scope.assign_local(:_class, node)
        scope.assign_local(:_this, nil)

        # check out the children
        for child in node.children[0].children
          # binding.pry
          raise StandardError, "`_this' is a reserved symbol within Class body" if :_this == child.value
          raise StandardError, "`_class' is a reserved symbol within Class body" if :_class == child.value
          raise StandardError, "`_super' is a reserved symbol within Class body" if :_super == child.value

          value = child.children[0]
          if :FunctionDefinition != value.type
            value = child.children[0].evaluate
            raise StandardError, "only Functions can be assigned within Class body" if :FunctionDefinition != value.type
          end

          if :_creator == child.value
            node.creator = value
          end

          node.members[child.value] = value

          scope.assign_local(child.value, value)
        end


          # puts ":: class_def_proc"
          # node.scope_chain.describe

        node
      end
    end
  end

###################################################################################################
###################################################################################################

  # class Instance < Node

  #   attr_accessor :klass, :scope

  #   def initialize(klass, values=nil)
  #     super(value: "Instance", type: :Instance)
  #     @klass = klass

  #     # to make deep_dup easier, we provide a way to get a clean Instance
  #     if !@klass.nil?
  #       self.scope_chain = @klass.scope_chain.deep_dup
  #       @scope = @scope_chain.tail

  #       # inject correct _this
  #       @scope_chain.overwrite(:_this, self)

  #       # _super is just a trick of  which causes Procs.InstanceMemberAccess_proc
  #       # to move up the scope_chain before accessing something
  #       @scope_chain.overwrite(:_super, self)

  #       # tediously set the correct scope_chain on all the functions in the scope_chain
  #       # because they're still pointing at the klass's scope_chain
  #       populate_members

  #       # check constructor arity vs argument number
  #       # binding.pry
  #       if @klass.creator.nil?
  #         # if we have a super_klass, call its constructor
  #         creator = nil
  #         if !@klass.super_klass.nil?
  #           # creator = @klass.super_klass.resolve_creator
  #         end
  #       else
  #         creator = @scope_chain.access(:_creator) # we want OUR creator

  #         # @scope_chain.describe

  #         values = [*values]

  #         if values.length != creator.params.length
  #           raise StandardError, "wrong number of arguments (given #{values.length}, expected #{creator.params.length})"
  #         end

  #         if creator.params.length > 0
  #           # inject the initial values into the creator and evaluate it
  #           # binding.pry
  #           creator.body.type = :FunctionBody
  #           creator.body.children[1] = values
  #           creator.body.evaluate
  #         end
  #       end
  #     end
  #   end

  #   def populate_members
  #     # puts "::populate_members"
  #     @klass.members.each do |symbol, function|
  #       # binding.pry
  #       puts ":: populate_members #{symbol}"
  #       function.scope_chain = @scope_chain

  #       @scope_chain.assign_local(symbol, function)
  #     end
  #   end

  #   def correct_member_scope_chains(scope)
  #     scope.locals.each do |key, val|
  #       if val.instance_of?(Function)
  #         val.scope_chain = @scope_chain
  #       end
  #     end

  #     if scope != scope.parent
  #       correct_member_scope_chains(scope.parent)
  #     end
  #   end

  #   def deep_dup
  #     self
  #   end

  # end # end Instance

end # end module
