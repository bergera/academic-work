#lang racket

; Andrew Berger
; SmallProject01
; CS 3180 Spring 2016
; 2016-02-01

(require 2htdp/batch-io)
(require (file "lib.rkt"))

;; Assumes an ASCII file named linuxwords is available in whatever directory read-lines
;; defaults to. On my machine, read-lines reads from ~/ by default.
(let ([linuxwords (read-lines "linuxwords")])
  ;; Output all six letter words that do not contain the letters a, e, i, o, without
  ;; respect to case, on a single line, delimited by commas, with no quotation marks.
  (display (string-join (without-aeio (filter (lambda (word) (equal? 6 (string-length word))) linuxwords)) ", "))
  (display #\newline)

  ;; Output a count of total number of letter u found in the entire file without
  ;; respect to case or word length.
  (display (count-u-strings linuxwords))
)
