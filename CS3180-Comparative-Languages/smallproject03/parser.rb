#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.14
# from Racc grammer file "".
#

require 'racc/parser.rb'

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

class Parser < Racc::Parser

module_eval(<<'...end grammar.y/module_eval...', 'grammar.y', 56)

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
     4,     4,     5,     5,     4,     4,     5,     5,     6,     7,
     8,    10,    13 ]

racc_action_check = [
     0,     4,     0,     4,     7,     8,     7,     8,     1,     2,
     3,     6,     9 ]

racc_action_pointer = [
    -4,     8,     7,     7,    -3,   nil,    11,     0,     1,     7,
   nil,   nil,   nil,   nil ]

racc_action_default = [
    -7,    -7,    -2,    -4,    -7,    -6,    -7,    -7,    -7,    -7,
    14,    -1,    -3,    -5 ]

racc_goto_table = [
     1,    12,   nil,   nil,     9,   nil,   nil,    11 ]

racc_goto_check = [
     1,     2,   nil,   nil,     1,   nil,   nil,     1 ]

racc_goto_pointer = [
   nil,     0,    -7,   nil ]

racc_goto_default = [
   nil,   nil,     2,     3 ]

racc_reduce_table = [
  0, 0, :racc_error,
  3, 8, :_reduce_1,
  1, 8, :_reduce_2,
  3, 9, :_reduce_3,
  1, 9, :_reduce_4,
  3, 10, :_reduce_5,
  1, 10, :_reduce_6 ]

racc_reduce_n = 7

racc_shift_n = 14

racc_token_table = {
  false => 0,
  :error => 1,
  :ADD => 2,
  :MULTIPLY => 3,
  :LPAREN => 4,
  :RPAREN => 5,
  :NUMBER => 6 }

racc_nt_base = 7

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
  "ADD",
  "MULTIPLY",
  "LPAREN",
  "RPAREN",
  "NUMBER",
  "$start",
  "Expr",
  "Term",
  "Factor" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'grammar.y', 24)
  def _reduce_1(val, _values, result)
     result = OperationNode.new(:+, [val[0], val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 25)
  def _reduce_2(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 29)
  def _reduce_3(val, _values, result)
     result = OperationNode.new(:*, [val[0], val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 30)
  def _reduce_4(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 34)
  def _reduce_5(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 35)
  def _reduce_6(val, _values, result)
     result = ValueNode.new(val[0].value) 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class Parser

end
