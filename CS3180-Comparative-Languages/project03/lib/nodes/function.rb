##
# Andrew Berger
# Project03
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

module Project03

  ##
  # Functions all day.
  class Function < Node

    attr_accessor :body, :params

    def initialize(body: nil, params: nil)
      super(value: "Function", children: [body, [*params]], type: :FunctionDefinition)

      @body = body
      @params = [*params]

      # check that all the params are symbols
      @children[1].each do |param|
        if !param.value.is_a?(Symbol)
          raise StandardError, "wrong type (Function parameters must be symbols)"
        end
      end
    end

    ##
    # Takes an array of potential arguments to this function. Verifies that the number of args is correct.
    # If the number is correct, returns an array of [param, argument] pairs.
    def make_argument_list(arguments)
      arguments = [*arguments]
      return @children[1].map.with_index { |param, i| [param.value, arguments[i].evaluate] }
    end
 
    def invoke(arguments)
      arguments = [*arguments]

      if @params.length != arguments.length
        raise StandardError, "wrong number of arguments (given #{arguments.length}, expected #{@params.length})"
      end

      @children[0].children[1] = arguments

      # invoke the function body block
      return @children[0].evaluate
    end

    def deep_dup
      Function.new(body: @body.deep_dup, params: @params.deep_dup)
    end

  end # end Function

  ##
  # Function semantics.
  class Procs

    def self.FunctionDefinition_proc
      lambda do |node|
        # giving the body block a special @type lets us generate closures in Procs::block_proc.
        node.children[0].type = :FunctionBody

        # duplicate the body block's @scope_chain (aka create a Closure)
        node.children[0].scope_chain = node.children[0].scope_chain.deep_dup

        return node
      end
    end

    def self.FunctionBody_proc
      self.Block_proc
    end

  end # end Procs

end # end module
