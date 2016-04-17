#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.14
# from Racc grammer file "".
#

require 'racc/parser.rb'

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

class Parser < Racc::Parser

module_eval(<<'...end grammar.y/module_eval...', 'grammar.y', 132)

  def parse(code)
    @yydebug = true
    @tokens = Scanner::Tokenizer.new.tokenize(code)
    do_parse
  end

  # Retrieve the next token from the list.
  def next_token
    @tokens.shift
  end

...end grammar.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    21,    17,    22,    24,    16,    26,    27,    23,    15,    21,
    17,    22,    38,    16,     9,    40,    23,    15,    44,    43,
    62,    18,    26,    27,    55,    26,    27,    28,    29,     9,
    18,    63,    64,    60,    21,    17,    22,    10,    16,    11,
     9,    23,    15,    67,    64,     9,    21,    17,    22,   nil,
    16,     5,     9,    23,    15,    18,    21,    17,    22,    10,
    16,    11,   nil,    23,    15,   nil,   nil,    18,    21,    17,
    22,   nil,    16,     5,     9,    23,    15,    18,    21,    17,
    22,    10,    16,    11,   nil,    23,    15,   nil,   nil,    18,
    26,    27,    28,    29,   nil,     5,     9,    35,   nil,    18,
    21,    17,    22,   nil,    16,   nil,   nil,    23,    15,    21,
    17,    22,   nil,    16,   nil,   nil,    23,    15,    21,    17,
    22,    18,    16,   nil,   nil,    23,    15,    21,    17,    22,
    18,    16,   nil,   nil,    23,    15,    21,    17,    22,    18,
    16,   nil,   nil,    23,    15,    21,    17,    22,    18,    16,
   nil,   nil,    23,    15,    21,    17,    22,    18,    16,   nil,
   nil,    23,    15,    21,    17,    22,    18,    16,   nil,   nil,
    23,    15,   nil,   nil,   nil,    18,   nil,   nil,    21,    17,
    22,    10,    16,    11,    18,    23,    15,    26,    27,    28,
    29,    30,    31,   nil,   nil,     5,     9,    51,    72,    18,
    21,    17,    22,   nil,    16,   nil,   nil,    23,    15,    21,
    17,    22,   nil,    16,   nil,   nil,    23,    15,    21,    17,
    22,    18,    16,   nil,   nil,    23,    15,    21,    17,    22,
    18,    16,   nil,   nil,    23,    15,   nil,   nil,   nil,    18,
    26,    27,    28,    29,    30,    31,   nil,   nil,    18,   nil,
   nil,   nil,   nil,    59,    26,    27,    28,    29,    30,    31,
   nil,   nil,   nil,     9,    26,    27,    28,    29,    30,    31,
   nil,   nil,   nil,     9,    26,    27,    28,    29,    30,    31,
   nil,   nil,    25,    26,    27,    28,    29,    30,    31,   nil,
   nil,    25,    26,    27,    28,    29,    30,    31,    65,    26,
    27,    28,    29,    30,    31,    26,    27,    28,    29,    30,
    31,    26,    27,    28,    29,    30,    31,    26,    27,    28,
    29,    30,    31 ]

racc_action_check = [
    38,    38,    38,     1,    38,    47,    47,    38,    38,    43,
    43,    43,    14,    43,    23,    17,    43,    43,    24,    23,
    53,    38,    48,    48,    38,    49,    49,    49,    49,    60,
    43,    56,    56,    43,     0,     0,     0,     0,     0,     0,
    62,     0,     0,    61,    61,    67,    10,    10,    10,   nil,
    10,     0,     0,    10,    10,     0,     3,     3,     3,     3,
     3,     3,   nil,     3,     3,   nil,   nil,    10,    11,    11,
    11,   nil,    11,     3,     3,    11,    11,     3,     9,     9,
     9,     9,     9,     9,   nil,     9,     9,   nil,   nil,    11,
    50,    50,    50,    50,   nil,     9,     9,     9,   nil,     9,
    16,    16,    16,   nil,    16,   nil,   nil,    16,    16,    18,
    18,    18,   nil,    18,   nil,   nil,    18,    18,    26,    26,
    26,    16,    26,   nil,   nil,    26,    26,    27,    27,    27,
    18,    27,   nil,   nil,    27,    27,    28,    28,    28,    26,
    28,   nil,   nil,    28,    28,    29,    29,    29,    27,    29,
   nil,   nil,    29,    29,    30,    30,    30,    28,    30,   nil,
   nil,    30,    30,    31,    31,    31,    29,    31,   nil,   nil,
    31,    31,   nil,   nil,   nil,    30,   nil,   nil,    34,    34,
    34,    34,    34,    34,    31,    34,    34,    70,    70,    70,
    70,    70,    70,   nil,   nil,    34,    34,    34,    70,    34,
    40,    40,    40,   nil,    40,   nil,   nil,    40,    40,    64,
    64,    64,   nil,    64,   nil,   nil,    64,    64,    65,    65,
    65,    40,    65,   nil,   nil,    65,    65,    72,    72,    72,
    64,    72,   nil,   nil,    72,    72,   nil,   nil,   nil,    65,
    41,    41,    41,    41,    41,    41,   nil,   nil,    72,   nil,
   nil,   nil,   nil,    41,    36,    36,    36,    36,    36,    36,
   nil,   nil,   nil,    36,    37,    37,    37,    37,    37,    37,
   nil,   nil,   nil,    37,     2,     2,     2,     2,     2,     2,
   nil,   nil,     2,    33,    33,    33,    33,    33,    33,   nil,
   nil,    33,    57,    57,    57,    57,    57,    57,    57,    39,
    39,    39,    39,    39,    39,    54,    54,    54,    54,    54,
    54,    69,    69,    69,    69,    69,    69,    73,    73,    73,
    73,    73,    73 ]

racc_action_pointer = [
    32,     3,   263,    54,   nil,   nil,   nil,   nil,   nil,    76,
    44,    66,   nil,   nil,   -13,   nil,    98,    -3,   107,   nil,
   nil,   nil,   nil,    -6,    18,   nil,   116,   125,   134,   143,
   152,   161,   nil,   272,   176,   nil,   243,   253,    -2,   288,
   198,   229,   nil,     7,   nil,   nil,   nil,    -6,    11,    14,
    79,   nil,   nil,    12,   294,   nil,     5,   281,   nil,   nil,
     9,    17,    20,   nil,   207,   216,   nil,    25,   nil,   300,
   176,   nil,   225,   306 ]

racc_action_default = [
   -42,   -42,    -1,    -2,    -3,    -5,    -7,    -8,    -9,   -42,
   -42,   -42,   -21,   -22,   -23,   -24,   -42,   -34,   -42,   -30,
   -31,   -32,   -33,   -42,   -42,    -6,   -42,   -42,   -42,   -42,
   -42,   -42,    -4,   -42,   -42,   -10,   -42,   -42,   -42,   -25,
   -42,   -42,   -37,   -42,    74,   -15,   -16,   -17,   -18,   -19,
   -20,   -11,   -12,   -13,   -40,   -35,   -42,   -26,   -27,   -29,
   -42,   -42,   -42,   -36,   -42,   -42,   -38,   -42,   -14,   -41,
   -42,   -39,   -42,   -28 ]

racc_goto_table = [
     2,    32,     1,     3,    56,    58,   nil,    42,   nil,    61,
    36,    37,    34,   nil,   nil,   nil,    39,   nil,    41,   nil,
    52,    53,   nil,   nil,   nil,   nil,    45,    46,    47,    48,
    49,    50,    32,   nil,   nil,   nil,   nil,   nil,    54,   nil,
    57,   nil,   nil,    54,    66,   nil,    68,   nil,   nil,   nil,
   nil,    71,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,    69,    70,   nil,   nil,   nil,   nil,
   nil,   nil,    73 ]

racc_goto_check = [
     2,     4,     1,     3,    14,    11,   nil,     7,   nil,    14,
     2,     2,     3,   nil,   nil,   nil,     2,   nil,     2,   nil,
     7,     7,   nil,   nil,   nil,   nil,     2,     2,     2,     2,
     2,     2,     4,   nil,   nil,   nil,   nil,   nil,     2,   nil,
     2,   nil,   nil,     2,     7,   nil,     7,   nil,   nil,   nil,
   nil,     7,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,     2,     2,   nil,   nil,   nil,   nil,
   nil,   nil,     2 ]

racc_goto_pointer = [
   nil,     2,     0,     3,    -2,   nil,   nil,   -16,   nil,   nil,
   nil,   -35,   nil,   nil,   -34 ]

racc_goto_default = [
   nil,   nil,    33,   nil,     4,     6,     7,     8,    12,    13,
    14,   nil,    19,    20,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 29, :_reduce_1,
  1, 29, :_reduce_2,
  1, 31, :_reduce_3,
  2, 31, :_reduce_4,
  1, 32, :_reduce_5,
  2, 32, :_reduce_6,
  1, 32, :_reduce_7,
  1, 32, :_reduce_none,
  1, 32, :_reduce_9,
  2, 35, :_reduce_10,
  3, 35, :_reduce_11,
  3, 33, :_reduce_12,
  3, 34, :_reduce_13,
  5, 34, :_reduce_14,
  3, 30, :_reduce_15,
  3, 30, :_reduce_16,
  3, 30, :_reduce_17,
  3, 30, :_reduce_18,
  3, 30, :_reduce_19,
  3, 30, :_reduce_20,
  1, 30, :_reduce_21,
  1, 30, :_reduce_22,
  1, 30, :_reduce_23,
  1, 30, :_reduce_24,
  2, 36, :_reduce_25,
  3, 37, :_reduce_26,
  3, 37, :_reduce_27,
  5, 39, :_reduce_28,
  3, 38, :_reduce_29,
  1, 38, :_reduce_30,
  1, 38, :_reduce_31,
  1, 38, :_reduce_32,
  1, 38, :_reduce_33,
  1, 38, :_reduce_34,
  3, 41, :_reduce_35,
  4, 41, :_reduce_36,
  2, 40, :_reduce_37,
  4, 40, :_reduce_38,
  5, 40, :_reduce_39,
  1, 42, :_reduce_40,
  3, 42, :_reduce_41 ]

racc_reduce_n = 42

racc_shift_n = 74

racc_token_table = {
  false => 0,
  :error => 1,
  :NUMBER => 2,
  :SYMBOL => 3,
  :STRING => 4,
  :WHILE => 5,
  :PRINT => 6,
  :IF => 7,
  :ELSE => 8,
  :FUNCTION => 9,
  :DESCRIBE => 10,
  "*" => 11,
  "/" => 12,
  "+" => 13,
  "-" => 14,
  "<" => 15,
  ">" => 16,
  "?" => 17,
  "=" => 18,
  ";" => 19,
  "{" => 20,
  "}" => 21,
  ":" => 22,
  "(" => 23,
  ")" => 24,
  "[" => 25,
  "]" => 26,
  "," => 27 }

racc_nt_base = 28

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "NUMBER",
  "SYMBOL",
  "STRING",
  "WHILE",
  "PRINT",
  "IF",
  "ELSE",
  "FUNCTION",
  "DESCRIBE",
  "\"*\"",
  "\"/\"",
  "\"+\"",
  "\"-\"",
  "\"<\"",
  "\">\"",
  "\"?\"",
  "\"=\"",
  "\";\"",
  "\"{\"",
  "\"}\"",
  "\":\"",
  "\"(\"",
  "\")\"",
  "\"[\"",
  "\"]\"",
  "\",\"",
  "$start",
  "Program",
  "Expr",
  "StatementList",
  "Statement",
  "While",
  "Conditional",
  "Block",
  "Print",
  "Assignment",
  "Value",
  "Ternary",
  "Function",
  "Invocation",
  "ExprList" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'grammar.y', 27)
  def _reduce_1(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 28)
  def _reduce_2(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 32)
  def _reduce_3(val, _values, result)
     result = Node.new(children: val[0], proc: Node::Procs::statementlist_proc, type: "StatementList") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 33)
  def _reduce_4(val, _values, result)
     val[0].add_child(val[1]); result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 37)
  def _reduce_5(val, _values, result)
     result = Node.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 38)
  def _reduce_6(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 39)
  def _reduce_7(val, _values, result)
     result = val[0] 
    result
  end
.,.,

# reduce 8 omitted

module_eval(<<'.,.,', 'grammar.y', 41)
  def _reduce_9(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 45)
  def _reduce_10(val, _values, result)
     result = Node.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 46)
  def _reduce_11(val, _values, result)
     result = Node.new(children: val[1], proc: Node::Procs.block_proc, type: "Block") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 50)
  def _reduce_12(val, _values, result)
     result = Node.new(children: [val[1], val[2]], proc: Node::Procs.while_proc, type: "While") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 54)
  def _reduce_13(val, _values, result)
     result = Node.new(children: [val[1], val[2]], proc: Node::Procs.conditional_proc, type: "Conditional") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 55)
  def _reduce_14(val, _values, result)
     result = Node.new(children: [val[1], val[2], val[4]], proc: Node::Procs.conditional_proc, type: "Conditional") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 59)
  def _reduce_15(val, _values, result)
     result = Node.new(value: val[1], children: [val[0], val[2]], proc: Node::Procs.operation_proc, type:"Operation") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 60)
  def _reduce_16(val, _values, result)
     result = Node.new(value: val[1], children: [val[0], val[2]], proc: Node::Procs.operation_proc, type:"Operation") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 61)
  def _reduce_17(val, _values, result)
     result = Node.new(value: val[1], children: [val[0], val[2]], proc: Node::Procs.operation_proc, type:"Operation") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 62)
  def _reduce_18(val, _values, result)
     result = Node.new(value: val[1], children: [val[0], val[2]], proc: Node::Procs.operation_proc, type:"Operation") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 63)
  def _reduce_19(val, _values, result)
     result = Node.new(value: val[1], children: [val[0], val[2]], proc: Node::Procs.operation_proc, type:"Operation") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 64)
  def _reduce_20(val, _values, result)
     result = Node.new(value: val[1], children: [val[0], val[2]], proc: Node::Procs.operation_proc, type:"Operation") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 65)
  def _reduce_21(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 66)
  def _reduce_22(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 67)
  def _reduce_23(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 68)
  def _reduce_24(val, _values, result)
     result = Node.new(type:"DescribeScope", proc: lambda { |node| node.scope_chain.tail.describe(0) }) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 72)
  def _reduce_25(val, _values, result)
     result = Node.new(children: val[1], proc: Node::Procs.print_proc, type: "Print") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 76)
  def _reduce_26(val, _values, result)
     result = Node.new(value: val[0].value, children: val[2], proc: Node::Procs.symbol_assign_proc, type: "SymbolAssignment") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 77)
  def _reduce_27(val, _values, result)
     result = Node.new(value: val[0].value, children: val[2], proc: Node::Procs.symbol_assign_proc, type: "SymbolAssignment") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 81)
  def _reduce_28(val, _values, result)
     result = Node.new(children: [val[0], val[2], val[4]], proc: Node::Procs.conditional_proc, type: "TernaryConditional") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 85)
  def _reduce_29(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 86)
  def _reduce_30(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 87)
  def _reduce_31(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 88)
  def _reduce_32(val, _values, result)
     result = Node.new(value: val[0].value, type: "NumberValue") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 89)
  def _reduce_33(val, _values, result)
     result = Node.new(value: val[0].value, type: "StringValue") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 90)
  def _reduce_34(val, _values, result)
     result = Node.new(value: val[0].value, proc: Node::Procs.symbol_access_proc, type: "SymbolAccess") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 94)
  def _reduce_35(val, _values, result)
     result = Node.new(children: val[0], proc: Node::Procs.function_invocation_proc, type: "FunctionInvocation") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 95)
  def _reduce_36(val, _values, result)
     result = Node.new(children: [val[0], val[2]], proc: Node::Procs.function_invocation_proc, type: "FunctionInvocation") 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 99)
  def _reduce_37(val, _values, result)
     result = Function.new(body: val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 100)
  def _reduce_38(val, _values, result)
     result = Function.new(body: val[3]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 101)
  def _reduce_39(val, _values, result)
     result = Function.new(body: val[4], params: val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 105)
  def _reduce_40(val, _values, result)
     result = [val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 106)
  def _reduce_41(val, _values, result)
     result = val[0] << val[2] 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class Parser

end