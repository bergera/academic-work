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
  # Procs for Node Semantics. Lambdas are used so we can have explicit returns.
  class Procs
    
    ##
    #
    def self.Describe_proc
      lambda do |node|
        if node.children.length > 0
          value = node.children[0].evaluate
          
          if value.respond_to?(:scope_chain)
            value.scope_chain.describe
          else
            puts value
          end
        else
          node.scope_chain.describe
        end
      end
    end

    ##
    # Evaluates each child and returns the result of evaluating the last child.
    def self.StatementList_proc
      lambda do |node|
        # puts ":: entering statementlist_proc"
        result = nil
        node.children.each { |child| result = child.evaluate }
        return result
      end
    end

    def self.Self_proc
      lambda { |node| node }
    end

    ##
    # Returns the node's value.
    def self.Value_proc
      lambda do |node|
        return node.value
      end
    end

    ##
    # Within a new Scope, evaluates the StatementList at children[0] and returns the result.
    def self.Block_proc
      lambda do |node|
        result = nil

        scope = node.scope_chain.push

        # children[1] is a list of [symbol, value] pairs to inject into the block's Scope (to support function arguments)

        # binding.pry

        if :FunctionBody == node.type && node.children[1].length > 0
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
    def self.Operation_proc
      lambda do |node|
        # evaluate each child, then reduce using the given operation
        node.children.map(&:evaluate).reduce(node.value.to_sym)
      end
    end

    ##
    # While children[0] evaluates truthy, evaluates children[1], returning the result of the last
    # evaluation of children[1], or nil if children[0] never evalutes truthy.
    def self.While_proc
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
    def self.Print_proc
      lambda do |node|
        result = node.children[0].evaluate
        puts result
        return result
      end
    end

    ##
    # Attempts to access a symbol defined by the node's value starting from the tail of the ScopeChain.
    def self.SymbolAccess_proc
      lambda do |node|
        # binding.pry
        node.scope_chain.access(node.value.to_sym)
      end
    end

    ##
    # Attempts to assign a symbol defined by the node's value with the evaluation of children[0]. If
    # the symbol is not defined, defines in it in ScopeChain's tail.
    def self.SymbolAssignment_proc
      lambda do |node|
        node.scope_chain.assign(node.value.to_sym, node.children[0].evaluate)
      end
    end

    ##
    # If children[0] evaluates truthy, returns the result of evaluating children[1], if falsey, returns
    # the result of evaluating children[2] (which may be nil, evaluating to nil).
    def self.Conditional_proc
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
    # Attempts to invoke a Function or Klass stored within the variable given by the symbol children[0].
    def self.Invocation_proc
      lambda do |node|
        # binding.pry

        # resolve children[0], which is either a SymbolAccess node or an Expr which
        # must return a Function or Klass
        thing = node.children[0].evaluate

        if !thing.respond_to?(:invoke)
          raise StandardError, "wrong type, cannot invoke an object of type #{thing.class}"
        end

        # binding.pry

        thing.invoke(node.children[1])

        # if thing.instance_of?(Function)

        #   # if there is a parameter list, inject it into the function body
        #   if thing.children[1].length > 0
        #     if node.children[1].nil?
        #       raise StandardError, "wrong number of arguments (given 0, expected #{thing.children[1].length})"
        #     else
        #       thing.children[0].children[1] = node.children[1]
        #     end
        #   end

        #   # invoke the function body block
        #   return thing.children[0].evaluate
        
        # elsif thing.instance_of?(Klass)

        #   # create the instance
        #   return Instance.new(thing, [*node.children[1]])

        # else
        #   raise StandardError, "wrong type, cannot invoke an object of type #{thing.class}"
        # end

      end
    end

  end # end Procs

end # end module
