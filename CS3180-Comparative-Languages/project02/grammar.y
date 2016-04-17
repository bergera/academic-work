##
# Andrew Berger
# Project02
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

class Parser

token NUMBER SYMBOL STRING 
token WHILE PRINT IF ELSE FUNCTION
token DESCRIBE

prechigh
  left "*" "/"
  left "+" "-"
  left "<" ">"
  left "?"
  right "="
preclow

expect 12 # our Expr's produce potential conflicts, but don't really matter

rule

  Program:
    Expr                             { result = val[0] }
  | StatementList                    { result = val[0] }
  ;

  StatementList:
    Statement                        { result = Node.new(children: val[0], proc: Node::Procs::statementlist_proc, type: "StatementList") }
  | StatementList Statement          { val[0].add_child(val[1]); result = val[0] }
  ;

  Statement:
    ";"                              { result = Node.new }
  | Expr ";"                         { result = val[0] }
  | While                            { result = val[0] }
  | Conditional
  | Block                            { result = val[0] }
  ;

  Block:
    "{" "}"                          { result = Node.new }
  | "{" StatementList "}"            { result = Node.new(children: val[1], proc: Node::Procs.block_proc, type: "Block") }
  ;

  While:
    WHILE Expr Block                 { result = Node.new(children: [val[1], val[2]], proc: Node::Procs.while_proc, type: "While") }
  ;

  Conditional:
    IF Expr Block                    { result = Node.new(children: [val[1], val[2]], proc: Node::Procs.conditional_proc, type: "Conditional") }
  | IF Expr Block ELSE Block         { result = Node.new(children: [val[1], val[2], val[4]], proc: Node::Procs.conditional_proc, type: "Conditional") }
  ;

  Expr:
    Expr "*" Expr                    { result = Node.new(value: val[1], children: [val[0], val[2]], proc: Node::Procs.operation_proc, type:"Operation") }
  | Expr "/" Expr                    { result = Node.new(value: val[1], children: [val[0], val[2]], proc: Node::Procs.operation_proc, type:"Operation") }
  | Expr "+" Expr                    { result = Node.new(value: val[1], children: [val[0], val[2]], proc: Node::Procs.operation_proc, type:"Operation") }
  | Expr "-" Expr                    { result = Node.new(value: val[1], children: [val[0], val[2]], proc: Node::Procs.operation_proc, type:"Operation") }
  | Expr "<" Expr                    { result = Node.new(value: val[1], children: [val[0], val[2]], proc: Node::Procs.operation_proc, type:"Operation") }
  | Expr ">" Expr                    { result = Node.new(value: val[1], children: [val[0], val[2]], proc: Node::Procs.operation_proc, type:"Operation") }
  | Print                            { result = val[0] }
  | Assignment                       { result = val[0] }
  | Value                            { result = val[0] }
  | DESCRIBE { result = Node.new(type:"DescribeScope", proc: lambda { |node| node.scope_chain.tail.describe(0) }) }
  ; 

  Print:
   PRINT Expr                        { result = Node.new(children: val[1], proc: Node::Procs.print_proc, type: "Print") }
  ;

  Assignment:
    SYMBOL "=" Expr                  { result = Node.new(value: val[0].value, children: val[2], proc: Node::Procs.symbol_assign_proc, type: "SymbolAssignment") }
  | SYMBOL "=" Ternary               { result = Node.new(value: val[0].value, children: val[2], proc: Node::Procs.symbol_assign_proc, type: "SymbolAssignment") }
  ;

  Ternary:
    Expr "?" Expr ":" Expr           { result = Node.new(children: [val[0], val[2], val[4]], proc: Node::Procs.conditional_proc, type: "TernaryConditional") }
  ;

  Value:
    "(" Expr ")"                     { result = val[1] }
  | Function                         { result = val[0] }
  | Invocation                       { result = val[0] }
  | NUMBER                           { result = Node.new(value: val[0].value, type: "NumberValue") }
  | STRING                           { result = Node.new(value: val[0].value, type: "StringValue") }
  | SYMBOL                           { result = Node.new(value: val[0].value, proc: Node::Procs.symbol_access_proc, type: "SymbolAccess") }
  ;

  Invocation:
    Value "[" "]"                   { result = Node.new(children: val[0], proc: Node::Procs.function_invocation_proc, type: "FunctionInvocation") }
  | Value "[" ExprList "]"          { result = Node.new(children: [val[0], val[2]], proc: Node::Procs.function_invocation_proc, type: "FunctionInvocation") }
  ;

  Function:
    FUNCTION Block                   { result = Function.new(body: val[1]) }
  | FUNCTION "[" "]" Block           { result = Function.new(body: val[3]) }
  | FUNCTION "[" ExprList "]" Block  { result = Function.new(body: val[4], params: val[2]) }
  ;

  ExprList:
    Expr                           { result = [val[0]] }
  | ExprList "," Expr              { result = val[0] << val[2] }
  ;

  # ClassDef:
  #   CLASS SYMBOL
  # | CLASS SYMBOL "[" SYMBOL "]"
  # ;

end

---- header
##
# Andrew Berger
# Project02
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

require "./scanner"
require "./nodes"

module Project02

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
