##
# Andrew Berger
# SmallProject03
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

require "minitest/autorun"
require "./parser"

module SmallProject03
  class ParserTest < MiniTest::Unit::TestCase

    def setup
      @parser = Parser.new
    end

    def parse(code)
      @parser.parse(code)
    end

    def evaluate(code)
      parse(code).evaluate
    end

    def describe(code)
      parse(code).describe_tree
    end

    def test_raises_parseerror
      assert_raises(Racc::ParseError) { parse("%") }
    end

    def test_evaluates_Factor
      assert_equal 1.0, evaluate("1")
      assert_equal 1.0, evaluate("(1)")
    end

    def test_evaluates_Term
      assert_equal 25.0, evaluate("5 * 5")
      assert_equal 30.0, evaluate("(2 * 3) * 5")
    end

    def test_evaluates_Expr
      assert_equal 3.0, evaluate("1 + 2")
      assert_equal 5.0, evaluate("2 * 2 + 1")
      assert_equal 5.0, evaluate("1 + 2 * 2")
      assert_equal 64.0, evaluate("(5 + 3) * 8")
      assert_equal 29.0, evaluate("5 + 3 * 8")
    end

    def test_describe_tree
      assert_equal "5.0 3.0 + 8.0 *", describe("(5 + 3) * 8")
      assert_equal "5.0 3.0 8.0 * +", describe("5 + 3 * 8")
    end
  end
end