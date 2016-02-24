#lang racket

;; SmallProject00
;; Andrew Berger
;; CS 3180
;; Spring 2016
;; Due 1/29/16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; A procedure that takes two numeric arguments and returns the largest of them.
;; CONTRACT: max2 : a b -> { number }
;; PURPOSE:  See description
;; CODE:
(define (max2 a b) (if (> b a) b a))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; A procedure that takes one or more numeric arguments and returns the largest
;; of them.
;; CONTRACT: max : number ... -> { number }
;; PURPOSE:  See description
;; CODE:
(define (max number . rest-of-numbers)
  (cond
    [(null? rest-of-numbers) number]
    [(equal? number (max2 number (apply max rest-of-numbers))) number]
    [else (apply max rest-of-numbers)]
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; A procedure which takes a list and two elements of the list. It returns #t
;; if the second argument appears in the list argument before the third argument.
;; CONTRACT: before-in-list? : lst a b -> { #f, #t }
;; PURPOSE:  See description
;; CODE:
(define (before-in-list? lst a b)
  (cond
    [(null? lst) #f]
    [(eq? b (first lst)) #f]
    [(eq? a (first lst)) #t]
    [else (before-in-list? (rest lst) a b)]
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; A procedure which returns a list containing elements located at odd-numbered
;; positions in the original list.
;; CONTRACT: odd : lst -> { list, null }
;; PURPOSE:  See description
;; CODE:
(define (odd lst)
  (cond
    [(null? lst) null]
    [(null? (rest lst)) lst]
    [else (cons (first lst) (odd (rest (rest lst))))]
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; A procedure which returns a list containing elements located at even-numbered
;; positions in the original list.
;; CONTRACT: even : lst -> { list, null }
;; PURPOSE:  See description
;; CODE:
(define (even lst)
  (cond
    [(null? lst) null]
    [(null? (rest lst)) null]
    [else (cons (first (rest lst)) (even (rest (rest lst))))]
  )  
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; takes a nested list of symbols and numbers L, and produces a nested list of
;; symbols and numbers by "immediately duplicating" each atom (symbol or number)
;; at all levels.
;; CONTRACT: duplicate : lst -> { list, null }
;; PURPOSE:  See description
;; CODE:
(define (duplicate lst)
  (cond
    [(null? lst) null]
    [(list? (first lst)) (cons (duplicate (first lst)) (duplicate (rest lst)))]
    [else (cons (first lst) (cons (first lst) (duplicate (rest lst))))]
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; validate-number-list returns #t if vA and vB contain the same number of
;; elements and all elements are numbers. validate-number-list returns #f
;; otherwise.
;; CONTRACT: validate-number-list : vA vB -> { #t, #f }
;; PURPOSE:  See description
;; CODE:
(define (validate-number-list vA vB)
  (and
    (eq? (length vA) (length vB))
    (not (null? (filter (lambda (x) (number? x)) vA)))
    (not (null? (filter (lambda (x) (number? x)) vB)))
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; The dotProduct function takes two lists of numbers representing vectors, and
;; produces their dot product (or reports their incompatibility). 
;; CONTRACT: dotProduct : vA vB  -> { "*incompatible*", number }
;; PURPOSE:  See description
;; CODE:
(define (dotProduct vA vB)
  (cond
    [(validate-number-list vA vB)                ; lists are valid
       (apply + (map (lambda (a b) (* a b)) vA vB))
    ]
    [else "*incompatible*"]                      ; lists are invalid
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; Takes a nested list nl, and replaces all occurrences of a number with n and
;; all occurrences of a symbol with s.
;; CONTRACT: typer : nl -> { list, null }
;; PURPOSE:  See description
;; CODE:
(define (typer nl)
  (cond
    [(null? nl) null]
    [else
      (map 
        (lambda (x)
          (cond
            [(list? x) (typer x)]
            [(number? x) 'n]
            [(symbol? x) 's]
            [else x]
          )
        )
        nl
      )
    ]
  )
)

;; Export the functions defined here.
(provide
  max
  before-in-list?
  odd
  even
  duplicate
  validate-number-list
  dotProduct
  typer
)
