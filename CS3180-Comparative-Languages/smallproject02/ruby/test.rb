##
# Andrew Berger
# SmallProject02
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

require "minitest/autorun"
require "./scanner"

class TokenizerTest < MiniTest::Unit::TestCase
  include Scanner

  def setup
    @tokenizer = Tokenizer.new
  end

  def test_that_it_matches_numbers
    assert_includes @tokenizer.tokenize("1"), ValueToken.new(:NUMBER, "1")
    assert_includes @tokenizer.tokenize("23"), ValueToken.new(:NUMBER, "23")
    assert_includes @tokenizer.tokenize("4567890"), ValueToken.new(:NUMBER, "4567890")
    assert_includes @tokenizer.tokenize(".0"), ValueToken.new(:NUMBER, ".0")
    assert_includes @tokenizer.tokenize(".123"), ValueToken.new(:NUMBER, ".123")
    assert_includes @tokenizer.tokenize("9.0"), ValueToken.new(:NUMBER, "9.0") 
    assert_includes @tokenizer.tokenize("78.24"), ValueToken.new(:NUMBER, "78.24")
    assert_includes @tokenizer.tokenize("56327.583716"), ValueToken.new(:NUMBER, "56327.583716")   
  end

  def test_that_it_matches_symbols
    assert_includes @tokenizer.tokenize("_"), ValueToken.new(:SYMBOL, "_")
    assert_includes @tokenizer.tokenize("a"), ValueToken.new(:SYMBOL, "a")
    assert_includes @tokenizer.tokenize("z"), ValueToken.new(:SYMBOL, "z")
    assert_includes @tokenizer.tokenize("A"), ValueToken.new(:SYMBOL, "A")
    assert_includes @tokenizer.tokenize("Z"), ValueToken.new(:SYMBOL, "Z")
    assert_includes @tokenizer.tokenize("_m"), ValueToken.new(:SYMBOL, "_m")
    assert_includes @tokenizer.tokenize("a0"), ValueToken.new(:SYMBOL, "a0")
    assert_includes @tokenizer.tokenize("_Z9"), ValueToken.new(:SYMBOL, "_Z9")
    assert_includes @tokenizer.tokenize("lmn567WXY"), ValueToken.new(:SYMBOL, "lmn567WXY")
  end

  def test_that_it_matches_comments
    assert_includes @tokenizer.tokenize("//"), ValueToken.new(:COMMENT, "//")
    assert_includes @tokenizer.tokenize("//nospace"), ValueToken.new(:COMMENT, "//nospace")
    assert_includes @tokenizer.tokenize("// space"), ValueToken.new(:COMMENT, "// space")
    assert_includes @tokenizer.tokenize("a // 0 .1 5. 89.76"), ValueToken.new(:COMMENT, "// 0 .1 5. 89.76")
    assert_includes @tokenizer.tokenize("5.2 // _ a z A Z _56 abcDEF908"), ValueToken.new(:COMMENT, "// _ a z A Z _56 abcDEF908")
    assert_includes @tokenizer.tokenize("()//()()"), ValueToken.new(:COMMENT, "//()()")
    assert_includes @tokenizer.tokenize("// + - *"), ValueToken.new(:COMMENT, "// + - *")
    assert_includes @tokenizer.tokenize("//!@#$%^&*"), ValueToken.new(:COMMENT, "//!@#$%^&*")
    assert_includes @tokenizer.tokenize("// commentception // whoaaa "), ValueToken.new(:COMMENT, "// commentception // whoaaa ")
  end

  def test_that_it_matches_parens
    assert_includes @tokenizer.tokenize("("), ValueToken.new(:PAREN, "(")
    assert_includes @tokenizer.tokenize(")"), ValueToken.new(:PAREN, ")")
  end

  def test_that_it_matches_operators
    assert_includes @tokenizer.tokenize("+"), ValueToken.new(:OPERATOR, "+")
    assert_includes @tokenizer.tokenize("-"), ValueToken.new(:OPERATOR, "-")
    assert_includes @tokenizer.tokenize("*"), ValueToken.new(:OPERATOR, "*")
  end

  def test_that_it_matches_errors
    assert_includes @tokenizer.tokenize("!"), ValueToken.new(:ERROR, "!")
    assert_includes @tokenizer.tokenize("@abc"), ValueToken.new(:ERROR, "@abc")
    assert_includes @tokenizer.tokenize("#0.5"), ValueToken.new(:ERROR, "#0.5")
  end

  def test_that_it_matches_multiple_numbers
    tokens = @tokenizer.tokenize("123 .56\n89.01 567.")
    assert_includes tokens, ValueToken.new(:NUMBER, "123")
    assert_includes tokens, ValueToken.new(:NUMBER, ".56")
    assert_includes tokens, ValueToken.new(:NUMBER, "89.01")
    assert_includes tokens, ValueToken.new(:NUMBER, "567.")
  end

  def test_that_it_matches_multiple_symbols
    tokens = @tokenizer.tokenize("_ Z a0\t_Z9\n\nlmn567WXY\n")
    assert_includes tokens, ValueToken.new(:SYMBOL, "_")
    assert_includes tokens, ValueToken.new(:SYMBOL, "Z")
    assert_includes tokens, ValueToken.new(:SYMBOL, "a0")
    assert_includes tokens, ValueToken.new(:SYMBOL, "_Z9")
    assert_includes tokens, ValueToken.new(:SYMBOL, "lmn567WXY")
  end

  def test_that_it_matches_multiple_comments
    tokens = @tokenizer.tokenize("// foo\n//bar //baz\nabc 123 +-()// now a comment")
    assert_includes tokens, ValueToken.new(:COMMENT, "// foo")
    assert_includes tokens, ValueToken.new(:COMMENT, "//bar //baz")
    assert_includes tokens, ValueToken.new(:COMMENT, "// now a comment")
  end

  def test_that_it_matches_multiple_parens
    tokens = @tokenizer.tokenize("() )\n(")
    assert_equal ValueToken.new(:PAREN, "("), tokens.shift
    assert_equal ValueToken.new(:PAREN, ")"), tokens.shift
    assert_equal ValueToken.new(:PAREN, ")"), tokens.shift
    assert_equal ValueToken.new(:PAREN, "("), tokens.shift
  end

  def test_that_it_matches_multiple_operators
    tokens = @tokenizer.tokenize("++ *\n-")
    assert_equal ValueToken.new(:OPERATOR, "+"), tokens.shift
    assert_equal ValueToken.new(:OPERATOR, "+"), tokens.shift
    assert_equal ValueToken.new(:OPERATOR, "*"), tokens.shift
    assert_equal ValueToken.new(:OPERATOR, "-"), tokens.shift
  end

  def test_that_it_matches_eofs
    assert_equal Token.new(:EOF), @tokenizer.tokenize("").shift
    assert_equal Token.new(:EOF), @tokenizer.tokenize(" \n ").shift
    assert_equal Token.new(:EOF), @tokenizer.tokenize("abc 123 ()").pop
    assert_equal Token.new(:EOF), @tokenizer.tokenize("// comment\n").pop
  end

  def test_that_it_matches_a_complex_input
    tokens = @tokenizer.tokenize("0+2. _ab90(foo - .69)//whoa\n// nelly\n")
    assert_equal ValueToken.new(:NUMBER, "0"), tokens.shift
    assert_equal ValueToken.new(:OPERATOR, "+"), tokens.shift
    assert_equal ValueToken.new(:NUMBER, "2."), tokens.shift
    assert_equal ValueToken.new(:SYMBOL, "_ab90"), tokens.shift
    assert_equal ValueToken.new(:PAREN, "("), tokens.shift
    assert_equal ValueToken.new(:SYMBOL, "foo"), tokens.shift
    assert_equal ValueToken.new(:OPERATOR, "-"), tokens.shift
    assert_equal ValueToken.new(:NUMBER, ".69"), tokens.shift
    assert_equal ValueToken.new(:PAREN, ")"), tokens.shift
    assert_equal ValueToken.new(:COMMENT, "//whoa"), tokens.shift
    assert_equal ValueToken.new(:COMMENT, "// nelly"), tokens.shift
    assert_equal Token.new(:EOF), tokens.shift
    assert_empty tokens
  end

  def test_that_it_fails_fast
    assert_equal ValueToken.new(:ERROR, "^"), @tokenizer.tokenize("^").pop
    assert_equal ValueToken.new(:ERROR, "@error 89"), @tokenizer.tokenize("valid@error 89").pop
    assert_equal ValueToken.new(:ERROR, "&//foo 89"), @tokenizer.tokenize("_a+ 5 &//foo 89").pop
  end

end
