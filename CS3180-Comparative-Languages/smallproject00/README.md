# Assignment
[1 point] Complete "Real Exercize" 17.5 at http://www.eecs.berkeley.edu/~bh/ssch17/lists.html

[1 point] Complete "Real Exercize" 17.11 at http://www.eecs.berkeley.edu/~bh/ssch17/lists.html

[1 point] Write functions `odd` and `even` which take a list of symbols `L`, and produces a sublist of `L` containing symbols located at odd and even positions repectively. E.g., 

```racket
(odd '(a b c d))   ; = (a c) 
(even '(a b c d))  ; = (b d) 
(odd '(a))         ; = (a) 
(even '(a))        ; = ()
```

[1 point] Write a function `duplicate` which takes a nested list of symbols and numbers `L`, and produces a nested list of symbols and numbers by "immediately duplicating" each atom (symbol or number) at all levels. E.g.,

```racket
(duplicate '(a 1 b 2 c 3))      ; = (a a 1 1 b b 2 2 c c 3 3)
(duplicate '( (a 1) b ((c)) 2)  ; = ( (a a 1 1) b b ((c c)) 2 2)
```

[1 point] Write a function `dotProduct` which takes two lists of numbers representing vectors, and produces their dot product (or reports their incompatibility). E.g.,

```racket
(dotProduct '(1 2) '(3 4) )     ; = 11
(dotProduct '(1 2 3) '(4 5 6))  ; = 32
(dotProduct '(1 2 3) '(4 5))    ; = *incompatible*
```

[1 point **extra**] Write a function `lastLess`, which takes a nested list of symbols `L` and a symbol `S`, and produces another nested list which resembles `L` except for the elimination of the last occurrence of the symbol `S`. E.g.,

```racket
(lastLess '(a b a (c e) d) 'e) ; = (a b a (c) d)
```

[1 point **extra**] Write a function `typer` which takes a nested list `nl`, and replaces all occurrences of a number with `n` and all occurrences of a symbol with `s`. E.g.,

```racket
(typer '(2 (abc () (#t f) "abc"))) ; = (n (s () (#t s) "abc"))
```
