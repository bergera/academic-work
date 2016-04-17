##
# Andrew Berger
# Project02
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

require "./extensions"
require "./scope"

module Project02

  ##
  # A parse tree node with support for interpretation.
  class Node

    attr_accessor :value, :children, :proc, :parent, :type

    # Initialize with global scope
    @@scope_chain = ScopeChain.new(nil)

    def initialize(type: "Empty", value: nil, children: nil, proc: Procs.value_proc, scope_chain: nil)
      @type = type
      @value = value
      @parent = nil
      @proc = proc

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
      Node.new(value: @value.deep_dup, children: @children.map(&:deep_dup), proc: @proc.deep_dup, scope_chain: scope_chain)
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

          if node.type == "FunctionBody"
            node.scope_chain = node.scope_chain.deep_dup
          end

          scope = node.scope_chain.push

          # children[1] is a list of [symbol, value] pairs to inject into the block's Scope (to support function arguments)
          if node.children[1]
            arguments = func.make_argument_list(node.children[1])
            arguments.each { |argument| scope.assign_local(argument[0], argument[1]) }
          end

          begin
            result = node.children[0].evaluate
          rescue StandardError => e
            # nobody likes a leak
            node.scope_chain.pop
            raise e
          end
          
          popped = node.scope_chain.pop

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
          print result
          return result
        end
      end

      ##
      # Attempts to access a symbol defined by the node's value starting from the tail of the ScopeChain.
      def self.symbol_access_proc
        lambda do |node|
          parenttype = node.parent.nil? ? node.type : node.parent.type
          puts ":: accessing #{node.value.to_sym} from #{parenttype} #{node.scope_chain.resolve(node.value.to_sym)}"
          node.scope_chain.describe

          node.scope_chain.access(node.value.to_sym)
        end
      end

      ##
      # Attempts to assign a symbol defined by the node's value with the evaluation of children[0]. If
      # the symbol is not defined, defines in it in ScopeChain's tail.
      def self.symbol_assign_proc
        lambda do |node|
          value = node.children[0].evaluate

          parenttype = node.parent.nil? ? node.type : node.parent.type
          puts ":: assigning #{node.value.to_sym} within #{parenttype} #{node.scope_chain}"
          # scope = node.scope_chain.resolve(node.value.to_sym)
          # scope = scope.nil? ?
          # puts ":: assigning #{node.value.to_sym} to #{scope.nil? ? node.scope_chain.tail : scope}"
          node.scope_chain.assign(node.value.to_sym, value)

          puts ":: after assignment:"
          node.scope_chain.describe
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
      # Attempts to invoke a function stored within the variable given by the symbol children[0].
      def self.function_invocation_proc
        lambda do |node|
          func = node.children[0].evaluate
          unless func.instance_of?(Function)
            raise StandardError, "#{node.children[0]} is not a Function"
          end

          # if there is a parameter list, inject it into the function body
          if func.children[1].length > 0
            if node.children[1].nil?
              raise StandardError, "wrong number of arguments (given 0, expected #{func.children[1].length})"
            else
              # func.children[0].children << func.make_argument_list(node.children[1])
            end
          end

          # invoke the function
          func.children[0].evaluate
        end
      end

    end # end Procs

  end # end Node

###################################################################################################
###################################################################################################

  ##
  # Functions all day.
  class Function < Node

    attr_reader :body, :params

    def initialize(body: nil, params: nil)
      super(value: "Function", children: [body, [*params]], type: "FunctionDefinition")

      # check that all the params are symbols
      @children[1].each do |param|
        if !param.value.is_a?(Symbol)
          raise StandardError, "wrong type (Function parameters must be symbols)"
        end
      end

      @proc = lambda do |node|
        # giving the body block a special @type lets us generate closures in Procs::block_proc.
        node.children[0].type = "FunctionBody"
        node
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

  end # end Function

end # end module
