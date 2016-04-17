require "./extensions"

module Project02

  ##
  # A Hash-based hierarchical symbol table.
  class Scope

    attr_accessor :locals, :parent

    def initialize(parent)
      @locals = Hash.new
      @parent = parent || self
    end

    ##
    # Deeply duplicates this Scope by deeply duplicating up the list of parent Scopes.
    def deep_dup
      scope = nil

      if @parent == self
        scope = Scope.new(nil)
      else
        scope = Scope.new(parent.deep_dup)
      end

      scope.locals = @locals.deep_dup

      return scope
    end

    ##
    # For debugging, prints a nice indented tree of Scopes.
    def describe(depth)
      if depth == 0
        puts "\n##### SCOPE CHAIN (tail first)"
      end

      prefix = ""
      depth.times { prefix += " " }
      puts "#{prefix}#{self}: #{@locals.keys}"

      parent.describe(depth + 1) unless self == @parent
    end

    ##
    # Determines the scope of +symbol+. Returns nil if the symbol is undefined,
    # or a reference to the symbol Hash in the scope chain where the symbol is defined.
    def resolve(symbol)
      symbol = symbol.to_sym
      if @locals.has_key?(symbol)
        return self
      elsif @parent != self
        return @parent.resolve(symbol)
      else
        return nil
      end
    end

    ##
    # If +symbol+ can be resolved, returns the value associated with that symbol.
    # If it can't be resolved, raises an +UndefinedSymbolError+.
    def access(symbol)
      symbol = symbol.to_sym
      scope = resolve(symbol)

      if scope.nil?
        raise KeyError, "undefined symbol `#{symbol}'"
      else
        return scope.locals[symbol]
      end
    end

    ##
    # Assigns symbol locally, regardless of whether it is defined elsewhere.
    def assign_local(symbol, value)
      @locals[symbol.to_sym] = value
    end

    ##
    # If +symbol+ can be resolved, overwrites its existing value with +value+, regardless
    # of where in the scope chain that symbol is defined. If it can't be resolved, creates
    # a new symbol in the current scope.
    def assign(symbol, value)
      symbol = symbol.to_sym
      scope = resolve(symbol)

      if scope.nil?
        self.assign_local(symbol, value)
      else
        scope.assign_local(symbol, value)
      end

      return value
    end
  end

  ##
  # A convenience class for managing a linked list of Scopes.
  class ScopeChain

    attr_accessor :tail

    def initialize(scope)
      @tail = scope || Scope.new(nil)
    end

    ##
    # Pushes a new Scope onto the tail of the list.
    def push
      @tail = Scope.new(@tail)
    end

    ##
    # Pops and returns the tail of the list.
    def pop
      popped = @tail
      @tail = @tail.parent
      return popped
    end

    ##
    # Resolve a symbol starting from the tail.
    def resolve(symbol)
      @tail.resolve(symbol)
    end

    ##
    # Access a symbol starting from the tail.
    def access(symbol)
      @tail.access(symbol)
    end

    ##
    # Assign a symbol starting from the tail.
    def assign(symbol, value)
      @tail.assign(symbol, value)
    end

    ##
    # Describe the list starting from the tail.
    def describe
      @tail.describe(0)
    end

    ##
    # Deeply duplicate this ScopeChain.
    def deep_dup
      return ScopeChain.new(@tail.deep_dup)
    end
  end

end