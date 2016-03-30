##
# Andrew Berger
# SmallProject03
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

class Parser

token ADD MULTIPLY
token LPAREN RPAREN
token NUMBER

prechigh
  left MULTIPLY
  left ADD
preclow

expect 0

rule

  Expr:
    Term ADD Expr           { result = OperationNode.new(:+, [val[0], val[2]]) }
  | Term                    { result = val[0] }
  ; 

  Term:
    Factor MULTIPLY Term    { result = OperationNode.new(:*, [val[0], val[2]]) }
  | Factor                  { result = val[0] }
  ;

  Factor:
    LPAREN Expr RPAREN      { result = val[1] }
  | NUMBER                  { result = ValueNode.new(val[0].value) }
  ;

end

---- header
##
# Andrew Berger
# SmallProject03
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

require "./scanner"
require "./nodes"

module SmallProject03

---- inner

  def parse(code)
    @yydebug = true
    @tokens = Scanner::Tokenizer.new.tokenize(code)
    do_parse
  end

  # Retrieve the next token from the list.
  def next_token
    @tokens.shift
  end

---- footer
end
