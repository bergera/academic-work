# Project03
Racc (Ruby YACC) BNF grammar can be found at `lib/grammar.y`. This project can be run without external depencies. To recompile `parser.rb` from `grammar.y`, [Racc](https://github.com/tenderlove/racc) is required.

## Running
Basic crappy interactive console:
```
$ ruby main.rb
```

Input file, opening basic crappy interactive console after evaluation:
```
$ ruby main.rb test_script.txt
```

## Rebuilding after grammar modifications
```
$ racc -v -o lib/parser.rb lib/grammar.y
```
