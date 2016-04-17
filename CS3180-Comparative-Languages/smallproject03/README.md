# SmallProject03
A simple parse for the following grammar:

```
<expr> ::= <term> ADD <expr>
       | <term>

<term> ::= <factor> MULTIPLY <term>
       | <factor>

<factor> ::= LPAREN <expr> RPAREN
         | NUM
```

## CLI
A simple interface can be run with `main.rb`. If the input is valid, the first line will be a post-order traversal of
the resulting parse tree (ie reverse Polish notation), and the second line will be the result of evaluating the parse tree. 
If the input is invalid, a parse error will be reported.

```
$ ruby main.rb
SmallProject03> 2
2.0
=> 2.0
SmallProject03> 2 + 2
2.0 2.0 +
=> 4.0
SmallProject03> $
=> parse error
```

## Tests
Tests can be run with `$ ruby test.rb`.

## Requirements
To recompile `parser.rb` from `grammar.y`, [Racc](https://github.com/tenderlove/racc) is required.

```
$ racc -o parser.rb grammar.y
```
