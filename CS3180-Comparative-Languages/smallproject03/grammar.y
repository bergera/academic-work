class Parser

token ADD MULTIPLY
token LPAREN RPAREN
token NUM

prechigh
  left MULTIPLY
  left ADD
preclow

# expect

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
  | NUM                     { result = val[2] }
  ;

end

---- header
module SmallProject03

---- inner

  def parse(code)
    # Uncomment the following line to enable grammar debugging, in combination
    # with the -g flag in the Rake build task.
    # @yydebug = true
    @tokens = Scanner.new.tokenize(code)
    do_parse
  end

  # Retrieve the next token from the list.
  def next_token
    @tokens.shift.to_a
  end

  # Raise a custom error class that knows about line numbers.
  # def on_error(error_token_id, error_value, value_stack)
  #   raise ParseError.new(token_to_str(error_token_id), error_value, value_stack)
  # end

---- footer
end
