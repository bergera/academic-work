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

  ##
  # A parse tree node with support for interpretation.
  class Node

    attr_accessor :value, :children, :proc, :parent, :type

    # Initialize with global scope
    @@scope_chain = ScopeChain.new(nil)

    def initialize(type: "Empty", value: nil, children: nil, proc: nil, scope_chain: nil)
      @type = type
      @value = value
      @parent = nil
      @proc = proc || Procs.value_proc

      self.children = [*children]

      self.scope_chain = scope_chain || @@scope_chain
    end

    ##
    # When assigning a list of children, make sure they get handled correctly.
    def children=(children)
      @children = []
      children.each { |child| add_child(child) }
    end

    ##
    # Adds a child to @children, making sure its @parent is set to this Node.
    def add_child(child)
      if child.is_a?(Array)
        child.each { |inner_child| inner_child.parent = self }
      else
        child.parent = self
      end
      @children << child
    end

    ##
    # For debugging, prints a nice indented tree.
    def describe(depth)
      prefix = ""
      depth.times { prefix += " " }
      puts "#{prefix}#{@type}: #{@value}"
      children.each do |child|
        if child.is_a?(Array)
          child.each { |inner_child| inner_child.describe(depth + 1) }
        else
          child.describe(depth + 1)
        end
      end
    end

    ##
    # To deeply duplicate a Node, deeply duplicate all its properties except the @scope_chain, which is duplicated as
    # part of the closure-generating Procs::block_proc.
    def deep_dup(scope_chain: @scope_chain)
      Node.new(value: @value.deep_dup, children: @children.map(&:deep_dup), proc: @proc.deep_dup, scope_chain: scope_chain, type: @type)
    end

    ##
    # Overwrite default to_str and to_s
    def to_str
      @value.to_s
    end
    alias_method :to_s, :to_str

    ##
    # Evaluates this node by calling its +proc+ or returning its +value+ if no +proc+ is set.
    def evaluate
      return @proc.call(self)
    end

    ##
    # We want to get the right @scope_chain when we need to.
    def scope_chain
      if @scope_chain.nil?
        if @parent.nil?
          @@scope_chain
        else
          parent.scope_chain
        end
      else
        @scope_chain
      end
    end

    ##
    # When setting a new @scope_chain, ensure all our @children get the new @scope_chain as well.
    def scope_chain=(scope_chain)
      @scope_chain = scope_chain
      @children.each do |child|
        if child.is_a?(Array)
          child.each { |inner_child| inner_child.scope_chain = scope_chain }
        else
          child.scope_chain = scope_chain
        end
      end
    end

###################################################################################################
###################################################################################################

    ##
    # Procs for Node Semantics. Lambdas are used so we can have explicit returns.
    class Procs
      
      ##
      # Evaluates each child and returns the result of evaluating the last child.
      def self.statementlist_proc
        lambda do |node|
          # puts ":: entering statementlist_proc"
          result = nil
          node.children.each { |child| result = child.evaluate }
          return result
        end
      end

      def self.self_proc
        lambda { |node| node }
      end

      ##
      # Returns the node's value.
      def self.value_proc
        lambda do |node|
          return node.value
        end
      end

      ##
      # Within a new Scope, evaluates the StatementList at children[0] and returns the result.
      def self.block_proc
        lambda do |node|
          result = nil

          scope = node.scope_chain.push

          # children[1] is a list of [symbol, value] pairs to inject into the block's Scope (to support function arguments)

          # binding.pry

          if "FunctionBody" == node.type && node.children[1]
            node.parent.make_argument_list(node.children[1]).each { |argument| scope.assign_local(argument[0], argument[1]) }
          end

          begin
            result = node.children[0].evaluate
            node.scope_chain.pop
          rescue StandardError => e
            # nobody likes a leak
            node.scope_chain.pop 
            raise e # we can't use an ensure block because we're re-raising the error
          end

          return result
        end
      end

      ##
      # Evaluates each child then left-reduces children using the node's value as the reducing function.
      def self.operation_proc
        lambda do |node|
          # evaluate each child, then reduce using the given operation
          node.children.map(&:evaluate).reduce(node.value.to_sym)
        end
      end

      ##
      # While children[0] evaluates truthy, evaluates children[1], returning the result of the last
      # evaluation of children[1], or nil if children[0] never evalutes truthy.
      def self.while_proc
        lambda do |node|
          result = nil
          loop do
            condition = node.children[0].evaluate
            if condition == false || condition == nil || condition == 0
              break
            end
            result = node.children[1].evaluate
          end
          return result
        end
      end

      ##
      # Evaluate children[0] and print the result.
      def self.print_proc
        lambda do |node|
          result = node.children[0].evaluate
          puts result
          return result
        end
      end

      ##
      # Attempts to access a symbol defined by the node's value starting from the tail of the ScopeChain.
      def self.symbol_access_proc
        lambda do |node|
          # binding.pry
          node.scope_chain.access(node.value.to_sym)
        end
      end

      ##
      # Attempts to assign a symbol defined by the node's value with the evaluation of children[0]. If
      # the symbol is not defined, defines in it in ScopeChain's tail.
      def self.symbol_assign_proc
        lambda do |node|
          node.scope_chain.assign(node.value.to_sym, node.children[0].evaluate)
        end
      end

      ##
      # If children[0] evaluates truthy, returns the result of evaluating children[1], if falsey, returns
      # the result of evaluating children[2] (which may be nil, evaluating to nil).
      def self.conditional_proc
        lambda do |node|
          condition = node.children[0].evaluate
          if condition != false && condition != nil && condition != 0
            return node.children[1].evaluate
          else
            return node.children[2] && node.children[2].evaluate
          end
        end
      end

      ##
      # Attempts to invoke a Function or ClassDef stored within the variable given by the symbol children[0].
      def self.invocation_proc
        lambda do |node|
          # binding.pry

          # resolve children[0], which is either a SymbolAccess node or an Expr which
          # must return a Function or ClassDef
          thing = node.children[0].evaluate

          if thing.instance_of?(Function)

            # if there is a parameter list, inject it into the function body
            if thing.children[1].length > 0
              if node.children[1].nil?
                raise StandardError, "wrong number of arguments (given 0, expected #{thing.children[1].length})"
              else
                thing.children[0].children[1] = node.children[1]
              end
            end

            # invoke the function body block
            return thing.children[0].evaluate
          
          elsif thing.instance_of?(ClassDef)

            # create the instance
            return Instance.new(thing, [*node.children[1]])

          else
            raise StandardError, "wrong type, cannot invoke an object of type #{thing.class}"
          end

        end
      end

      ##
      #
      def self.class_def_proc
        lambda do |node|
          # classes get a new ScopeChain which copied from their super_class
          if node.super_class.nil?
            node.scope_chain = ScopeChain.new
          else
            klass = node.super_class.evaluate
            if klass.type != "ClassDefinition"
              raise StandardError, "wrong type (given #{klass.type}, expected Class)"
            end

            node.scope_chain = ScopeChain.new(klass.scope_chain)
            node.scope_chain.tail.assign_local(:_super, klass)
          end

          # inject _this with nil so we can overwrite it later on instance create
          node.scope_chain.tail.assign_local(:_class, self)
          node.scope_chain.tail.assign_local(:_this, nil)

          # check out the children
          for child in node.children[0].children
            # binding.pry
            raise StandardError, "`_this' is a reserved symbol within Class body" if :_this == child.value
            raise StandardError, "`_class' is a reserved symbol within Class body" if :_class == child.value
            raise StandardError, "`_super' is a reserved symbol within Class body" if :_super == child.value

            value = child.children[0]
            if "FunctionDefinition" != value.type
              value = child.children[0].evaluate
              raise StandardError, "only Functions can be assigned within Class body" if "FunctionDefinition" != value.type
            end

            if :_creator == child.value
              node.creator = value
            end

            node.members[child.value] = value
          end


            # puts ":: class_def_proc"
            # node.scope_chain.describe

          node
        end
      end

      ##
      #
      def self.instance_member_access_proc
        lambda do |node|
          instance = node.children[0].evaluate

          # binding.pry

          if !instance.instance_of?(Instance)
            raise StandardError, "wrong type (given #{instance.class}, expected Instance)"
          end

          # puts "::instance_member_access_proc"
          # instance.scope_chain.describe

          instance.scope.access(node.value)
        end
      end

      ##
      #
      def self.instance_member_assignment_proc
        lambda do |node|
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

  end # end Node

###################################################################################################
###################################################################################################

  ##
  # Functions all day.
  class Function < Node

    attr_accessor :body, :params

    def initialize(body: nil, params: nil)
      super(value: "Function", children: [body, [*params]], type: "FunctionDefinition")

      @body = body
      @params = [*params]

      # check that all the params are symbols
      @children[1].each do |param|
        if !param.value.is_a?(Symbol)
          raise StandardError, "wrong type (Function parameters must be symbols)"
        end
      end

      @proc = lambda do |node|
        # giving the body block a special @type lets us generate closures in Procs::block_proc.
        node.children[0].type = "FunctionBody"

        # duplicate the body block's @scope_chain (aka create a Closure)
        node.children[0].scope_chain = node.children[0].scope_chain.deep_dup

        return node
      end
    end

    ##
    # Takes an array of potential arguments to this function. Verifies that the number of args is correct.
    # If the number is correct, returns an array of [param, argument] pairs.
    def make_argument_list(arguments)
      arguments = [*arguments]
      if arguments.length != @children[1].length
        raise StandardError, "wrong number of arguments (given #{arguments.size}, expected #{@children[1].size})"
      end

      return @children[1].map.with_index { |param, i| [param.value, arguments[i].evaluate] }
    end

    ##
    #
    def deep_dup
      Function.new(body: @body.deep_dup, params: @params.deep_dup)
    end

  end # end Function

###################################################################################################
###################################################################################################

  class ClassDef < Node

    attr_accessor :body, :members, :super_class, :creator

    def initialize(body: Node.new, super_class: nil)
      super(value: "Class", children: body, type: "ClassDefinition", proc: Node::Procs.class_def_proc)
      @body = body
      @members = {}
      @super_class = super_class
      @creator = nil
    end

    def resolve_creator
      if @creator.nil?
        if @super_class.nil?
          return nil
        else
          return @super_class.resolve_creator
        end
      else
        return @creator
      end
    end

  end # end

#####

  class Instance < Node

    attr_accessor :klass, :scope

    def initialize(klass, values=nil)
      super(value: "Instance", type: "Instance", proc: Node::Procs.self_proc)
      @klass = klass

      # to make deep_dup easier, we provide a way to get a clean Instance
      if !@klass.nil?
        self.scope_chain = @klass.scope_chain.deep_dup
        @scope = @scope_chain.tail

        # inject correct _this
        @scope_chain.assign(:_this, self)

        # tediously set the correct scope_chain on all the functions in the scope_chain
        # because they're still pointing at the klass's scope_chain
        populate_members

        # check constructor arity vs argument number
        # binding.pry
        if @klass.creator.nil?
          # if we have a super_class, call its constructor
          creator = nil
          if !@klass.super_class.nil?
            creator = @klass.super_class.resolve_creator
          end
        else
          creator = @scope_chain.access(:_creator) # we want OUR creator

          # @scope_chain.describe

          values = [*values]

          if values.length != creator.params.length
            raise StandardError, "wrong number of arguments (given #{values.length}, expected #{creator.params.length})"
          end

          if creator.params.length > 0
            # inject the initial values into the creator and evaluate it
            # binding.pry
            creator.body.type = "FunctionBody"
            creator.body.children[1] = values
            creator.body.evaluate
          end
        end
      end
    end

    def populate_members
      puts "::populate_members"
      @klass.members.each do |symbol, function|
        # binding.pry
        function.scope_chain = @scope_chain
        @scope_chain.tail.assign_local(symbol, function)
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

end # end module
