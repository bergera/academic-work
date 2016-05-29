##
# Andrew Berger
# Project03
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

require "./lib/scope"

module Project03

  ##
  # A parse tree node with support for interpretation.
  class Node

    attr_accessor :value, :children, :proc, :parent, :type

    # Initialize with a global scope
    @@scope_chain = ScopeChain.new

    def initialize(value: nil, children: nil, scope_chain: nil, type: :Empty)
      @value = value
      @parent = nil

      self.type = type
      self.children = [*children]
      self.scope_chain = scope_chain || @@scope_chain
    end

    ##
    # If a Proc is defined for the given type, sets as @proc, otherwise sets Procs.Value_proc as @proc.
    def type=(type)
      @type = type

      if Procs.respond_to?("#{type}_proc")
        @proc = Procs.send "#{type}_proc"
      else
        @proc = Procs.Value_proc
      end
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
      Node.new(value: @value.deep_dup, children: @children.map(&:deep_dup), scope_chain: scope_chain, type: @type)
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

  end # end Node

end # end module
