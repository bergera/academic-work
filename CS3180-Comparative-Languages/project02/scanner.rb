##
# Andrew Berger
# Project02
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

module Project02
  module Scanner

    class Value
      attr_reader :value
      def initialize(value); @value = value; end
      def to_str; @value.to_s; end
      alias_method :to_s, :to_str
      def to_sym; @value.to_sym; end
    end

    ##
    # This class takes a string and tokenizes it for the following grammar. (Note:
    # fails fast with an +ERROR+ token in the event no match is found.)
    # 
    # Note: this grammar avoids left recursion
    # making it easier to support LL recursive descent parsing.
    #
    # <expr> ::= <term> ADD <expr>
    #          | <term>
    #
    # <term> ::= <factor> MULTIPLY <term>
    #          | <factor>
    #
    # <factor> ::= LPAREN <expr> RPAREN
    #            | NUM
    #
    class Tokenizer

      ##
      # A +Hash+ which maps token symbols to +RegExp+ which matches those symbols.
      REGEXP = {
        EOF:        /\A\z/,
        WHITESPACE: /\A(\s+)/,
        NUMBER:     /\A(\d*\.\d+|\d+\.\d*|\d+)/,
        SYMBOL:     /\A([_A-Za-z]+[_A-Za-z0-9]*)/,
        COMMENT:    /\A(\/\/.*)$/,
        STRING:     /\A(""|''|"(.*?)[^\\]"|'(.*?)[^\\]')/,
        LITERAL:    /\A(.)/
      }

      KEYWORDS = ["while", "print", "if", "else", "function", "describe", "class", "create"]
      # LITERALS = [";", "(", ")", "{", "}", "+", "-", "*", "/", "<", ">", "=", "?", ":"]

      attr_reader :tokens

      ##
      # Returns an +Array+ of +Scanner::Token+ extracted from +input+.
      def tokenize(input)
        @input = input
        @i = 0
        @tokens = []
        @error = false

        while @i < @input.length
          next_token
          return @tokens if @error
        end

        # eof_token

        @tokens
      end

      private

      ##
      # Returns the symbol of the last token matched or nil if no tokens have been matched.
      def last_token
        @tokens.last[0] unless @tokens.empty?
      end

      ##
      # Scans for the next token.
      def next_token
        skip_whitespace
        skip_comment
        return last_token if keyword_token
        return last_token if number_token
        return last_token if symbol_token
        return last_token if string_token
        return last_token if literal_token
      end

      def error_token
        @error = true
        puts "Syntax error: `#{@input[@i]}'"
      end

      ##
      # Discards any leading whitespace matching +/\s+/m+ while advancing the scanner.
      def skip_whitespace
        match_token(:WHITESPACE) do
          # throw away whitespace
        end
      end

      ##
      # Discards comments.
      def skip_comment
        match_token(:COMMENT) do
          # throw away comments
        end
      end

      ##
      # Matches SYMBOLs
      def symbol_token
        match_token(:SYMBOL) do |match|
          value_token(:SYMBOL, match.to_s.to_sym)
        end
      end

      ##
      # Matches NUMBERs
      def number_token
        match_token(:NUMBER) do |match|
          value_token(:NUMBER, Float(match.to_s))
        end
      end

      ##
      # Matches STRINGs
      def string_token
        match_token(:STRING) do |match|
          value_token(:STRING, match.to_s[1..-2]) # strip the quotes off
        end
      end

      ##
      # Matches KEYWORDs
      def keyword_token
        KEYWORDS.each do |keyword|
          return true if match_literal(keyword)
        end
        return false
      end


      ##
      # Matches LITERALs
      def literal_token
        match_token(:LITERAL) do |match|
          value_token(match.to_s, match.to_s)
        end
      end
      # def literal_token
      #   LITERALS.each do |literal|
      #     return true if match_literal(literal) do |match|
      #       literal = match.to_s
      #       value_token(literal, literal)
      #     end
      #   end
      #   return false
      # end

      ##
      # Attempts to match +symbol+. If a match is found, passes the match to
      # a block if one is given or records a Token if no block is given, and
      # returns true. Otherwise, returns false.
      def match_token(symbol)
        return false unless REGEXP[symbol].match(@input[@i..-1]) do |match|
          if block_given?
            yield match
          else
            token(symbol)
          end

          @i += match.to_s.length
          return true
        end
      end

      def match_literal(literal)
        return false unless /\A(#{Regexp.quote(literal)})/.match(@input[@i..-1]) do |match|
          if block_given?
            yield match
          else
            token(literal.upcase.to_sym)
          end

          @i += match.to_s.length
          return true
        end
      end

      ##
      # Attempts to match +symbol+. If a match is found, records a ValueToken
      # with the match, and returns true. Otherwise, returns false.
      def match_value_token(symbol)
        match_token(symbol) do |match|
          value_token(symbol, match.to_s)
          yield match if block_given?
        end
      end

      ##
      # Records a token whose symbol is +symbol+.
      def token(symbol)
        @tokens << [symbol, Value.new(nil)]
      end

      ##
      # Records a token whose symbol is +symbol+ and value is +value+.
      def value_token(symbol, value)
        @tokens << [symbol, Value.new(value)]
      end
    end
  end
end