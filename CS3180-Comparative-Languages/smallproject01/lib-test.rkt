#lang racket

; Andrew Berger
; SmallProject01
; CS 3180 Spring 2016
; 2016-02-01

(require rackunit "lib.rkt")
(require rackunit/text-ui)

(define smallproject01-tests
  (test-suite
    "SmallProject01"
    (test-suite
      "is-aeio?"
      (test-true "should return #t for a" (is-aeio? #\a))
      (test-true "should return #t for A" (is-aeio? #\A))
      (test-true "should return #t for e" (is-aeio? #\e))
      (test-true "should return #t for E" (is-aeio? #\E))
      (test-true "should return #t for i" (is-aeio? #\i))
      (test-true "should return #t for I" (is-aeio? #\I))
      (test-true "should return #t for o" (is-aeio? #\o))
      (test-true "should return #t for O" (is-aeio? #\O))
      (test-false "should return #f for u" (is-aeio? #\u))
      (test-false "should return #f for a number" (is-aeio? '0))
      (test-false "should return #f for an empty list" (is-aeio? null))
    )
    (test-suite
      "contains-aeio?"
      (test-true "should return #t for at" (contains-aeio? "at"))
      (test-true "should return #t for At" (contains-aeio? "At"))
      (test-true "should return #t for enter" (contains-aeio? "enter"))
      (test-true "should return #t for Enter" (contains-aeio? "Enter"))
      (test-true "should return #t for is" (contains-aeio? "is"))
      (test-true "should return #t for Is" (contains-aeio? "Is"))
      (test-true "should return #t for of" (contains-aeio? "of"))
      (test-true "should return #t for Of" (contains-aeio? "Of"))
      (test-true "should return #t for aeio" (contains-aeio? "aeiou"))
      (test-false "should return #f for up" (contains-aeio? "up"))
      (test-false "should return #f for a number" (contains-aeio? '0))
      (test-false "should return #f for an empty list" (contains-aeio? null))
    )
    (test-suite
      "without-aeio"
      (test-equal? "should return null given null" (without-aeio null) null)
      (test-equal? "should return an empty list given words with aeio" (without-aeio '("at" "enter" "is" "of" "aieou")) '())
      (test-equal? "should return the given list which contains no aeio" (without-aeio '("up" "cut" "run")) '("up" "cut" "run"))
      (test-equal? "should return a list with words containing aeio removed" (without-aeio '("on" "around" "under" "us" "you" "uncut")) '("us" "uncut"))
    )
    (test-suite
      "count-u-chars"
      (test-equal? "should return 0 given null" (count-u-chars null) 0)
      (test-equal? "should return 0 given no u or U" (count-u-chars (string->list "abcdefghi")) 0)
      (test-equal? "should return 1 given u" (count-u-chars (string->list "u")) 1)
      (test-equal? "should return 1 given U" (count-u-chars (string->list "U")) 1)
      (test-equal? "should return 2 given Uu" (count-u-chars (string->list "Uu")) 2)
      (test-equal? "should return 1 given aeiou" (count-u-chars (string->list "aeiou")) 1)
      (test-equal? "should return 3 given unctuous" (count-u-chars (string->list "unctuous")) 3)
    )
    (test-suite
      "count-u-strings"
      (test-equal? "should return 0 given null" (count-u-strings null) 0)
      (test-equal? "should return 0 given a word with no [uU]" (count-u-strings '("aeio")) 0)
      (test-equal? "should return 0 given two words with no [uU]" (count-u-strings '("aeio" "frontage")) 0)
      (test-equal? "should return 1 given a word with u" (count-u-strings '("out")) 1)
      (test-equal? "should return 1 given two words, one with U" (count-u-strings '("Utter" "aeio")) 1)
      (test-equal? "should return 2 given two words with [uU]" (count-u-strings '("Put" "Under")) 2)
      (test-equal? "should return 4 given (found nothing unconcious)" (count-u-strings '("found" "nothing" "unconcious")) 3)
    )
  )
)

(run-tests smallproject01-tests)
