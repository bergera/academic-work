##
# Andrew Berger
# Project03
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0
#
# Requires Racc to build.
# https://github.com/tenderlove/racc

class Parser

token NUMBER SYMBOL STRING
token WHILE PRINT IF ELSE FUNCTION CLASS
token DESCRIBE

prechigh
  left "*" "/"
  left "+" "-"
  left "<" ">"
  left "?"
  right "="
preclow

expect 14 # our Expr's produce potential conflicts, but don't really matter

rule

  Program:
    Expr                             { result = val[0] }
  | StatementList                    { result = val[0] }
  ;

  StatementList:
    Statement                        { result = Node.new(children: val[0], type: :StatementList) }
  | StatementList Statement          { val[0].add_child(val[1]); result = val[0] }
  ;

  Statement:
    ";"                              { result = Node.new }
  | Expr ";"                         { result = val[0] }
  | While                            { result = val[0] }
  | Conditional                      { result = val[0] }
  | Block                            { result = val[0] }
  ;

  Block:
    "{" "}"                          { result = Node.new(children: Node.new) }
  | "{" StatementList "}"            { result = Node.new(children: val[1], type: :Block) }
  ;

  While:
    WHILE Expr Block                 { result = Node.new(children: [val[1], val[2]], type: :While) }
  ;

  Conditional:
    IF Expr Block                    { result = Node.new(children: [val[1], val[2]], type: :Conditional) }
  | IF Expr Block ELSE Block         { result = Node.new(children: [val[1], val[2], val[4]], type: :Conditional) }
  ;

  Expr:
    Expr "*" Expr                    { result = Node.new(value: val[1], children: [val[0], val[2]], type: :Operation) }
  | Expr "/" Expr                    { result = Node.new(value: val[1], children: [val[0], val[2]], type: :Operation) }
  | Expr "+" Expr                    { result = Node.new(value: val[1], children: [val[0], val[2]], type: :Operation) }
  | Expr "-" Expr                    { result = Node.new(value: val[1], children: [val[0], val[2]], type: :Operation) }
  | Expr "<" Expr                    { result = Node.new(value: val[1], children: [val[0], val[2]], type: :Operation) }
  | Expr ">" Expr                    { result = Node.new(value: val[1], children: [val[0], val[2]], type: :Operation) }
  | Ternary                          { result = val[0] }
  | Print                            { result = val[0] }
  | Assignment                       { result = val[0] }
  | Value                            { result = val[0] }
  | Describe                         { result = val[0] }
  ; 

  Describe:
    DESCRIBE                         { result = Node.new(type: :Describe) }
  | DESCRIBE Value                   { result = Node.new(children: val[1], type: :Describe) }
  ;

  Print:
   PRINT Expr                        { result = Node.new(children: val[1], type: :Print) }
  ;

  Assignment:
    SYMBOL "=" Expr                  { result = Node.new(value: val[0].value, children: val[2], type: :SymbolAssignment) }
  | InstanceMemberAssignment         { result = val[0] }
  ;

  Ternary:
    Expr "?" Expr ":" Expr           { result = Node.new(children: [val[0], val[2], val[4]], type: :Conditional) }
  ;

  Value:
    "(" Expr ")"                     { result = val[1] }
  | Function                         { result = val[0] }
  | Invocation                       { result = val[0] }
  | InstanceMemberAccess             { result = val[0] }
  | ClassDef                         { result = val[0] }
  | NUMBER                           { result = Node.new(value: val[0].value, type: :NumberValue) }
  | STRING                           { result = Node.new(value: val[0].value, type: :StringValue) }
  | SYMBOL                           { result = Node.new(value: val[0].value, type: :SymbolAccess) }
  ;

  Invocation:
    Value "[" "]"                   { result = Node.new(children: val[0], type: :Invocation) }
  | Value "[" ExprList "]"          { result = Node.new(children: [val[0], val[2]], type: :Invocation) }
  ;

  Function:
    FUNCTION Block                   { val[1].type = :FunctionBody; result = Function.new(body: val[1]) }
  | FUNCTION "[" "]" Block           { val[3].type = :FunctionBody; result = Function.new(body: val[3]) }
  | FUNCTION "[" ExprList "]" Block  { val[4].type = :FunctionBody; result = Function.new(body: val[4], params: val[2]) }
  ;

  ExprList:
    Expr                           { result = [val[0]] }
  | ExprList "," Expr              { result = val[0] << val[2] }
  ;

  ClassDef:
    CLASS "{" "}"                          { result = Klass.new }
  | CLASS "{" ClassBlock "}"               { result = Klass.new(body: val[2]) }
  | CLASS "[" Value "]" "{" ClassBlock "}" { result = Klass.new(body: val[5], super_klass: val[2]) }
  ;

  ClassBlock:
    Assignment ";"                         { result = Node.new(children: val[0], type: :StatementList) }
  | ClassBlock Assignment ";"              { val[0].add_child(val[1]); result = val[0] }
  ;

  InstanceMemberAccess:
    Value "." SYMBOL                       { result = Node.new(value: val[2], children: val[0], type: :InstanceMemberAccess)}
  ;

  InstanceMemberAssignment:
    Value "." SYMBOL "=" Expr              { result = Node.new(value: val[2], children: [val[0], val[4]], type: :InstanceMemberAssignment) }
  ;

end

---- header
##
# Andrew Berger
# Project03
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

require "./lib/scanner"
require "./lib/nodes"

module Project03

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
