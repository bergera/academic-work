##
# Andrew Berger
# SmallProject03
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

require "./parser"

module SmallProject03
  loop do
    # get some input, exit on empty
    print "SmallProject03> "
    input = gets.chomp
    break if input.empty?

    begin
      # parse the input
      root_node = Parser.new.parse(input)

      # print a post-order traversal
      puts root_node.describe_tree
      
      # evalute and print the parse tree
      print "=> "
      puts root_node.evaluate
    rescue Racc::ParseError => e
      STDERR.puts "=> parse error"
    end
  end
end
