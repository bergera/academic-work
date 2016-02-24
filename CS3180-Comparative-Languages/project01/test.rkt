#lang racket

;; Project01
;; Andrew Berger
;; CS 3180
;; Spring 2016

(require (file "main.rkt"))
(require rackunit "main.rkt")
(require rackunit/text-ui)

(define testmatrix 
  '(
    "catss"
    "dogst"
    "flogo"
    "zlzpp"
    "fling"
  )
)

(define testmatrix-large
  '(
    "catsscatsscatsscatsscatsscatsscatsscatss"
    "dogstdogstdogstdogstdogstdogstdogstdogst"
    "flogoflogoflogoflogoflogoflogoflogoflogo"
    "zlzppzlzppzlzppzlzppzlzppzlzppzlzppzlzpp"
    "flingflingflingflingflingflingflingfling"
    "catsscatsscatsscatsscatsscatsscatsscatss"
    "dogstdogstdogstdogstdogstdogstdogstdogst"
    "flogoflogoflogoflogoflogoflogoflogoflogo"
    "zlzppzlzppzlzppzlzppzlzppzlzppzlzppzlzpp"
    "flingflingflingflingflingflingflingfling"
    "catsscatsscatsscatsscatsscatsscatsscatss"
    "dogstdogstdogstdogstdogstdogstdogstdogst"
    "flogoflogoflogoflogoflogoflogoflogoflogo"
    "zlzppzlzppzlzppzlzppzlzppzlzppzlzppzlzpp"
    "flingflingflingflingflingngstatesmanlike"
  )
)

(define project01-tests
  (test-suite
    "Project01"
    (test-suite
      "row->pairs"
      (test-equal? "returns null for empty row" (row->pairs 0 0 null) null)
      (test-equal? "returns correct pair for single item" (row->pairs 0 0 '(a)) '(((0 . 0) . a)))
      (test-equal? "returns correct pair for single item" (row->pairs 0 1 '(a)) '(((0 . 1) . a)))
      (test-equal? "returns correct pair for single item" (row->pairs 1 0 '(a)) '(((1 . 0) . a)))
      (test-equal? "returns correct pair for multiple items"
        (row->pairs 0 0 '(a b))
        '(((0 . 0) . a) ((0 . 1) . b))
      )
    )
    (test-suite
      "matrix->pairs"
      (test-equal? "returns null for empty matrix" (matrix->pairs 0 null) null)
      (test-equal? "returns correct pair for single row" (matrix->pairs 0 '((a))) '(((0 . 0) . a)))
      (test-equal? "returns correct pair for single row" (matrix->pairs 1 '((a))) '(((1 . 0) . a)))
      (test-equal? "returns correct pair for multiple rows with single item"
        (matrix->pairs 0 '((a) (b)))
        '(((0 . 0) . a) ((1 . 0) . b))
      )
      (test-equal? "returns correct pair for multiple rows with multiple items"
        (matrix->pairs 0 '((a b) (c d)))
        '(((0 . 0) . a) ((0 . 1) . b) ((1 . 0) . c) ((1 . 1) . d))
      )
    )
    (test-suite
      "word-at-pos?"
      #:before (lambda () (populate-hash-tables testmatrix))
      (test-true "a null word is present by definition" (word-at-pos? null null null null))
      (test-false "not present word" (word-at-pos? (string->list "foobar") '(0 . 0) 0 1))
      (test-false "present word at incorrect pos" (word-at-pos? (string->list "cats") '(0 . 1) 0 1))
      (test-false "present word in wrong direction" (word-at-pos? (string->list "cats") '(0 . 1) 1 1))
      (test-true "present word at correct pos going east" (word-at-pos? (string->list "cats") '(0 . 0) 0 1))
      (test-true "present word at correct pos going west" (word-at-pos? (string->list "golf") '(2 . 3) 0 -1))
      (test-true "present word at correct pos going north" (word-at-pos? (string->list "pots") '(3 . 4) -1 0))
      (test-true "present word at correct pos going south" (word-at-pos? (string->list "stop") '(0 . 4) 1 0))
      (test-true "present word at correct pos going north-east" (word-at-pos? (string->list "floss") '(4 . 0) -1 1))
      (test-true "present word at correct pos going south-east" (word-at-pos? (string->list "coop") '(0 . 0) 1 1))
      (test-true "present word at correct pos going south-west" (word-at-pos? (string->list "ssolf") '(0 . 4) 1 -1))
      (test-true "present word at correct pos going north-west" (word-at-pos? (string->list "poo") '(3 . 3) -1 -1))
    )
    (test-suite
      "word-in-matrix?"
      #:before (lambda () (populate-hash-tables testmatrix))
      (test-false "null word" (word-in-matrix? null))
      (test-false "not present word" (word-in-matrix? (string->list "foobar")))
      (test-true "present word" (word-in-matrix? (string->list "golf")))
    )
    (test-suite
      "find-words"
      (test-equal? "finds the right words"
        (find-words 5 5 testmatrix)
        '("cats" "coop" "dogs" "fling" "flog" "floss" "golf" "logo" "loss" "pots" "stop")
      )
      (test-equal? "finds the right words in large matrix"
        (find-words 40 40 testmatrix-large)
        '("cats" "coop" "dogs" "fling" "flog" "floss" "golf" "like" "list" "logo" "loss" "pots" "state" "states" "statesman" "statesmanlike" "stop" "tate")
      )
    )
  )
)

(run-tests project01-tests)
