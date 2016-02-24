#lang racket

; Andrew Berger
; SmallProject01
; CS 3180 Spring 2016
; 2016-02-01

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; is-aeio? returns #t if ltr is a char and is equal to one of [AaEeIiOo], #f otherwise.
;; CONTRACT: is-aeio? : char -> boolean
(define (is-aeio? ltr)
  (cond
    [(not (char? ltr)) #f]
    [(eqv? #\a ltr) #t]
    [(eqv? #\A ltr) #t]
    [(eqv? #\e ltr) #t]
    [(eqv? #\E ltr) #t]
    [(eqv? #\i ltr) #t]
    [(eqv? #\I ltr) #t]
    [(eqv? #\o ltr) #t]
    [(eqv? #\O ltr) #t]
    [else #f]
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; contains-aeio? returns #t if word is a string and contains one of [AaEeIiOo], #f otherwise.
;; CONTRACT: contains-aeio? : string -> boolean
(define (contains-aeio? word)
  (cond
    [(not (string? word)) #f]
    [else (ormap is-aeio? (string->list word))]
  )  
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; without-aeio takes a list of strings and returns a new list containing only
;; those strings which do not contain one of [AaEeIiOo].
;; CONTRACT: without-aeio : list -> list
(define (without-aeio lst)
  (filter (compose not contains-aeio?) lst)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; count-u-word takes a list of chars and returns the total number of occurrences
;; of the letter U without respect to case.
;; CONTRACT: count-u-chars : list[char] -> number
(define (count-u-chars chars)
  (cond
    [(null? chars) 0]
    [(eqv? #\u (first chars)) (+ 1 (count-u-chars (rest chars)))]
    [(eqv? #\U (first chars)) (+ 1 (count-u-chars (rest chars)))]
    [else (count-u-chars (rest chars))]
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION:
;; count-u-strings takes a list of strings and returns the total number of occurrences
;; of the letter U without respect to case.
;; CONTRACT: count-u : list -> number
(define (count-u-strings lst)
  (apply + (map (compose count-u-chars string->list) lst))
)

;; Exports
(provide
  is-aeio?
  contains-aeio?
  without-aeio
  count-u-chars
  count-u-strings
)
