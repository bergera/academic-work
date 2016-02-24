#lang racket

;; Unit tests for SmallProject00
;; Andrew Berger
;; CS 3180
;; Spring 2016
;; Due 1/29/16

(require rackunit "egs.rkt")
(require rackunit/text-ui)

(define smallproject00-tests
  (test-suite
    "SmallProject00"
    (test-suite
      "the max function"
      (test-equal? "given one number, should return that number" (max 1) 1)
      (test-equal? "should return the greatest of two numbers" (max 1 2) 2)
      (test-equal? "should return the greatest of three numbers, given in increasing order" (max 1 2 3) 3)
      (test-equal? "should return the greatest of three numbers, given in decreasing order" (max 3 2 1) 3)
    )
    (test-suite
      "the before-in-list? function"
      (test-false "should return #f given an empty list" (before-in-list? null 'a 'b))
      (test-false "should return #f when arguments a and b are not in the list" (before-in-list? '(c d) 'a 'b))
      (test-false "should return #f when b is before a in the list" (before-in-list? '(b a) 'a 'b))
      (test-true "should return #t when a is before b in the list" (before-in-list? '(a b) 'a 'b))
    )
    (test-suite
      "the odd function"
      (test-equal? "should return an empty list when given an empty list" (odd null) null)
      (test-equal? "should return the first item in a single-item list" (odd '(1)) '(1))
      (test-equal? "should return the first item in a two-item list" (odd '(1 2)) '(1))
      (test-equal? "should return the first and third items in a three-item list" (odd '(1 2 3)) '(1 3))
    )
    (test-suite
      "the even function"
      (test-equal? "should return an empty list when given an empty list" (even null) null)
      (test-equal? "should return an empty list given a single-item list" (even '(1)) null)
      (test-equal? "should return the second item in a two-item list" (even '(1 2)) '(2))
      (test-equal? "should return the second item in a three-item list" (even '(1 2 3)) '(2))
      (test-equal? "should return the second and fourth items in a three-item list" (even '(1 2 3 4)) '(2 4))
    )
    (test-suite
      "the duplicate function"
      (test-equal? "should return an empty list when given an empty list" (duplicate null) null)
      (test-equal? "should duplicate an element which is not a list" (duplicate '(0)) '(0 0))
      (test-equal? "should duplicate an element within a nested list" (duplicate '((0))) '((0 0)))
      (test-equal? "should duplicate an element within a double-nested list" (duplicate '(((0)))) '(((0 0))))
      (test-equal? "should duplicate both elements in a two-element list" (duplicate '(0 1)) '(0 0 1 1))
      (test-equal? "should duplicate both a non-list element and a list element in a two-element list" (duplicate '(0 (1))) '(0 0 (1 1)))
    )
    (test-suite
      "the validate-number-list function"
      (test-false "should return #f when vA and vB are of different lengths" (validate-number-list '(0) '(0 1)))
      (test-false "should return #f when vA contains an element which isn't a number" (validate-number-list '(a) '(0)))
      (test-false "should return #f when vB contains an element which isn't a number" (validate-number-list '(0) '(a)))
      (test-true "should return #t when vA and vB are of the same length and contain only numbers" (validate-number-list '(0) '(1)))
    )
    (test-suite
      "the dotProduct function"
      (test-equal? "should return *incompatible* when validate-number-list would return #f" (dotProduct '(a) '(0)) "*incompatible*")
      (test-equal? "should return the dot product of vA and vB when they each contain one item" (dotProduct '(2) '(3)) 6)
      (test-equal? "should return the dot product of vA and vB when they each contain more than one item" (dotProduct '(2 3) '(4 5)) 23)
    )
    (test-suite
      "the typer function"
      (test-equal? "should return null given an empty list" (typer null) null)
      (test-equal? "should replace a symbol with s" (typer '(a)) '(s))
      (test-equal? "should replace a number with n" (typer '(0)) '(n))
      (test-equal? "should recurse on a nested list" (typer '((0))) '((n)))
      (test-equal? "should not replace strings" (typer '("foo")) '("foo"))
      (test-equal? "should replace numbers with n, symbols with s, recurse into lists, and pass strings" (typer '(0 (a) "foo")) '(n (s) "foo"))
    )
  )
)

(run-tests smallproject00-tests)
