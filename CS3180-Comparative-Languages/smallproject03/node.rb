module Project03

  class Node
    attr_accessor :scope, :value, :proc, :children

    def initialize(value: nil, children: [])
      @value = value
      @scope = scope
      @proc = proc
      @children = children
    end

    def describe_tree
      result = ""
      
      for child in children do
        result += child.describe_tree
        result += " "
      end
      
      result += value.to_s

      result
    end

    def evaluate
      @proc.call(self) unless @proc.nil?
    end
  end

  class OperationNode < Node
    attr_reader :operation
    def initialize(operation, children)
      super(operation.to_s, children)

      @operation = operation

      @proc = Proc.new |node| do
        node.children.reduce(operation.to_sym)
      end
    end
  end

end
