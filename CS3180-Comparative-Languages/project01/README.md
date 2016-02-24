# Assignment

Write a word search program twice: Once in Dr Racket and once in Python. You may use Python 2 or Python 3.

In Dr. Racket, set the language to `#lang racket`, and implement the following function:

```racket
; CONTRACT: find-words : width length letters -> List
; PURPOSE: Returns a list of dictionary words 4 letters or longer
; that can be found in a matrix of letters that has dimensions width
; by length. Widths and length are natural numbers.
; CODE:
(define (find-words width length letters)
   '() ; Put your implementation here instead of returning an empty list
)
```

`letters` will be a list of `width` many literal strings of characters. Each literal string of characters has length `length`. e.g. The following is a possible definition of `letters` with `width` 4 and `length` 7.

```racket
'("abcdefg"
  "abdefg"
  "abcdefg"
  "abcdefg")
```

In Python, implement the following function:

```python
def find_words(width, length, letters):
   '''
   CONTRACT: find-words : width, length, letters -> List
   PURPOSE: Returns a list of dictionary words 4 letters or longer
   that can be found in a matrix of letters that has dimensions width
   by length. Width and length are natural numbers.
   '''
   pass // Put your implementation here instead of pass
)
```

`letters` will be a tuple of `width` many literal strings of characters. Each literal string of characters has length `length`. e.g. The following is a possible definition of `letters` with `width` 4 and `length` 7.

```python
("pbcdefg",
 "aedofgb",
 "abcgefg",
 "abcsesg")
```

Both `find-words` in Racket and `find_words` in Python must return a list of words at least four characters long found within http://www.cs.duke.edu/~ola/ap/linuxwords that are also found in the letters provided in the `letters` argument. You can download linuxwords to a local file. You don't need to access it over the network from within your functions. A word is only found if the word can be composed of consecutive letters in order within a single row, single column, or single diagonal in the letters matrix. Letter case does not matter. e.g. The following matrix contains the word "dogs" vertically and the word "pegs" diagonally. It also contains the words "golf" and "flog" horizontally.

```
("Pbcdefg",
 "aecdofg",
 "flogefg",
 "abcSssg")
```

The matrix used by the grader to test your functions may be large. Your functions must return comprehensive lists of all dictionary worlds 4 characters or longer that are found in the matrix. If either of your functions does not complete within 30 seconds, you will receive zero credit. Chose a sensible algorithm.

## Grading

[3 Points] The Racket version finds at least one dictionary word that is 4 characters or longer.

[3 Points] The Python version finds at least one dictionary word that is 4 characters or longer.

[3 Points] The Racket version finds all the dictionary words that is 4 characters or longer.

[3 Points] The Python version finds all the dictionary words that is 4 characters or longer.

[3 Points] Both of your implementations provide excellent comments and test cases to verify correct operation.
