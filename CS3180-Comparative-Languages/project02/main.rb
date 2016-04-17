##
# Andrew Berger
# Project02
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

require "./scanner"
require "./nodes"
require "./parser"

module Project02

  loop do
    # get some input, exit on empty
    print "Project02> "
    input = gets.chomp
    break if input.empty?

    begin
      # tokens = Scanner::Tokenizer.new.tokenize(input)
      # puts tokens

      # parse the input
      root_node = Parser.new.parse(input)
      
      # puts "\n##### PARSE TREE"
      # root_node.describe(0)
      # print "\n"

      # evalute and print the parse tree
      result = root_node.evaluate
      puts "=> #{result}"
    rescue ParseError => e
      STDERR.puts "=> #{e.to_s.strip}"
    rescue StandardError => e
      STDERR.puts e.to_s.strip
      STDERR.puts e.backtrace
    end
  end
end
