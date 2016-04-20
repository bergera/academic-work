##
# Andrew Berger
# Project02
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0

# require "pry"
# require "pry-byebug"

require "./scanner"
require "./nodes"
require "./parser"

module Project02

  initial_input = ARGV.length > 0 ? ARGF.read : nil 

  loop do
    # get some input, exit on empty
    if initial_input
      input = initial_input
    else
      print "Project02> "
      input = STDIN.gets.chomp

      # if "pry" == input
      #   binding.pry
      # end

    end
    
    break if input.empty?

    begin
      # tokens = Scanner::Tokenizer.new.tokenize(input)
      # puts tokens

      # parse the input
      root_node = Parser.new.parse(input)
      
      # puts "\n##### PARSE TREE"
      # root_node.describe(0)
      # print "\n"

      # evalute the tree
      # byebug
      result = root_node.evaluate

      # if we parsed an input file, let people know what got defined
      if !initial_input.nil?
        root_scope = root_node.scope_chain.tail
        while root_scope != root_scope.parent
          root_scope = root_scope.parent
        end

        puts ":: defined:"
        root_scope.locals.each do |k, v|
          puts "::   #{k} => #{v} (#{v.object_id})"
        end
      end
      
      # print the result
      if initial_input.nil?
        puts "=> #{result}"
      end
    rescue ParseError => e
      STDERR.puts "=> #{e.to_s.strip}"
    rescue StandardError => e
      STDERR.puts e.to_s.strip
      STDERR.puts e.backtrace
    end

    initial_input = nil
  end
end
