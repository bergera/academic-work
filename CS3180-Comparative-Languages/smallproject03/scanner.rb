##
# Andrew Berger
# SmallProject03
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

module SmallProject03
  module Scanner

    class Value
      attr_reader :value
      def initialize(value); @value = value; end
      def to_str; @value.to_s; end
      alias_method :to_s, :to_str
      def to_f; to_str.to_f; end
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
        ADD:        /\A(\+)/,
        MULTIPLY:   /\A(\*)/,
        LPAREN:     /\A(\()/,
        RPAREN:     /\A(\))/,
        ERROR:      /\A(.+)/
      }

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
      def last_token_symbol
        @tokens.last[0] unless @tokens.empty?
      end

      ##
      # Scans for the next token.
      def next_token
        skip_whitespace
        return last_token_symbol if number_token
        return last_token_symbol if add_token
        return last_token_symbol if multiply_token
        return last_token_symbol if lparen_token
        return last_token_symbol if rparen_token
        return last_token_symbol if error_token
      end

      ##
      # Discards any leading whitespace matching +/\s+/m+ while advancing the scanner.
      def skip_whitespace
        match_token(:WHITESPACE) do
          # throw away whitespace
        end
      end

      ##
      # Matches EOF
      def eof_token; match_token(:EOF); end

      ##
      # Matches NUMBERs
      def number_token
        match_token(:NUMBER) do |match|
          value_token(:NUMBER, Float(match.to_s))
        end
      end

      ##
      # Matches OPERATORs
      def add_token; match_value_token(:ADD); end
      def multiply_token; match_value_token(:MULTIPLY); end

      ##
      # Matches PARENs
      def lparen_token; match_value_token(:LPAREN); end
      def rparen_token; match_value_token(:RPAREN); end
      
      ##
      # Matches anything that wasn't matched, i.e. ERRORs.
      def error_token
        match_value_token(:ERROR) do
          @error = true
        end
      end

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