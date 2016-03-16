##
# Andrew Berger
# SmallProject02
# CS 3180
# Spring 2016
#
# Tested with Ruby v2.3.0
#
# INSTRUCTIONS: Invoke this file from the command line either by
# passing an input filename as an argument or by piping input to it:
#
# $ ruby main.rb inputFile.txt
# $ cat inputFile.txt | ruby main.rb
# $ echo -e "some input" | ruby main.rb

require "./scanner"

input = ARGF.read

tokens = Scanner::Tokenizer.new.tokenize(input)

tokens.each { |token| puts token }
