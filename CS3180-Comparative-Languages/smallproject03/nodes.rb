##
# Andrew Berger
# SmallProject03
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

module SmallProject03

  ##
  # A parse tree node with support for outputting to reverse Polish notation
  # and interpretation.
  class Node
    attr_accessor :value, :children, :proc

    def initialize(value, children)
      @value = value
      @children = children
      @proc = nil
    end

    ##
    # Outputs a String representing the +value+ of each node in a post-order traversal.
    def describe_tree
      result = ""
      
      for child in children do
        result += child.describe_tree
        result += " "
      end
      
      result += value.to_s

      result
    end

    def to_str
      @value.to_s
    end
    alias_method :to_s, :to_str


    ##
    # Evaluates this node by calling its +proc+ or returning its +value+ if no +proc+ is set.
    def evaluate
      if @proc.nil?
        return @value
      else
        return @proc.call(self)
      end
    end

  end

  ##
  # Syntactic sugar for a node with no children, i.e. only a value.
  class ValueNode < Node
    def initialize(value)
      super(value, [])
    end
  end

  ##
  # A node which performs a left-associative operation on its children.
  class OperationNode < Node
    attr_reader :operation

    ##
    # Initialize with +operation.to_s+ as the +value+ of the node.
    def initialize(operation, children)
      super(operation.to_s, children)

      @operation = operation

      @proc = Proc.new do |node|
        # evaluate each child, then reduce using the given operation
        node.children.map(&:evaluate).reduce(operation.to_sym)
      end
    end
  end

end
