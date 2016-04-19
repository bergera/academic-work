##
# Andrew Berger
# Project02
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

class Parser

token NUMBER SYMBOL STRING 
token WHILE PRINT IF ELSE FUNCTION CLASS CREATE
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
    Statement                        { result = Node.new(children: val[0], proc: Node::Procs::statementlist_proc, type: "StatementList") }
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
  # | InstanceCreate                   { result = val[0] }
  | Ternary                          { result = val[0] }
  | Print                            { result = val[0] }
  | Assignment                       { result = val[0] }
  | Value                            { result = val[0] }
  # | ClassDef                         { result = val[0] }
  | DESCRIBE { result = Node.new(type:"DescribeScope", proc: lambda { |node| node.scope_chain.describe(0) }) }
  ; 

  Print:
   PRINT Expr                        { result = Node.new(children: val[1], proc: Node::Procs.print_proc, type: "Print") }
  ;

  Assignment:
    SYMBOL "=" Expr                  { result = Node.new(value: val[0].value, children: val[2], proc: Node::Procs.symbol_assign_proc, type: "SymbolAssignment") }
  | InstanceMemberAssignment         { result = val[0] }
  ;

  Ternary:
    Expr "?" Expr ":" Expr           { result = Node.new(children: [val[0], val[2], val[4]], proc: Node::Procs.conditional_proc, type: "TernaryConditional") }
  ;

  Value:
    "(" Expr ")"                     { result = val[1] }
  | Function                         { result = val[0] }
  | Invocation                       { result = val[0] }
  | InstanceMemberAccess             { result = val[0] }
  | ClassDef                         { result = val[0] }
  | NUMBER                           { result = Node.new(value: val[0].value, type: "NumberValue") }
  | STRING                           { result = Node.new(value: val[0].value, type: "StringValue") }
  | SYMBOL                           { result = Node.new(value: val[0].value, proc: Node::Procs.symbol_access_proc, type: "SymbolAccess") }
  ;

  Invocation:
    Value "[" "]"                   { result = Node.new(children: val[0], proc: Node::Procs.invocation_proc, type: "Invocation") }
  | Value "[" ExprList "]"          { result = Node.new(children: [val[0], val[2]], proc: Node::Procs.invocation_proc, type: "Invocation") }
  ;

  Function:
    FUNCTION Block                   { val[1].type = "FunctionBody"; result = Function.new(body: val[1]) }
  | FUNCTION "[" "]" Block           { val[3].type = "FunctionBody"; result = Function.new(body: val[3]) }
  | FUNCTION "[" ExprList "]" Block  { val[4].type = "FunctionBody"; result = Function.new(body: val[4], params: val[2]) }
  ;

  ExprList:
    Expr                           { result = [val[0]] }
  | ExprList "," Expr              { result = val[0] << val[2] }
  ;

  ClassDef:
    CLASS "{" "}"                          { result = ClassDef.new }
  | CLASS "{" ClassBlock "}"               { result = ClassDef.new(body: val[2]) }
  | CLASS "[" Value "]" "{" ClassBlock "}" { result = ClassDef.new(body: val[5], super_class: val[2]) }
  ;

  ClassBlock:
    Assignment ";"                         { result = Node.new(children: val[0], proc: Node::Procs.statementlist_proc, type: "StatementList") }
  | ClassBlock Assignment ";"              { val[0].add_child(val[1]); result = val[0] }
  ;

  # InstanceCreate:
  #   CREATE Invocation                      { result = Node.new(children: val[1], proc: Node::Procs.instance_create_proc, type: "InstanceCreate") }
  # ;

  InstanceMemberAccess:
    Value "." SYMBOL                       { result = Node.new(value: val[2], children: val[0], proc: Node::Procs.instance_member_access_proc, type: "InstanceMemberAccess")}
  ;

  InstanceMemberAssignment:
    Value "." SYMBOL "=" Expr              { result = Node.new(value: val[2], children: [val[0], val[4]], proc: Node::Procs.instance_member_assignment_proc, type: "InstanceMemberAssignment") }
  ;

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
