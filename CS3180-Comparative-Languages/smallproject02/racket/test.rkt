#lang racket

; SmallProject02
; Andrew Berger
; CS 3180
; Spring 2016

(require rackunit "scanner.rkt")
(require rackunit/text-ui)
(require parser-tools/lex)

;; Helper function to pass get-token an input-port from a string
;; and extract the resulting token.
(define (get-token-test-helper input-string)
  (position-token-token (get-token (open-input-string input-string)))
)

;; Helper struct to encapsulate an expected token name/value.
(struct test-token (name value))

;; Binary check to compare an actual position-token with its expected name/value.
(define-binary-check (correct-token? actual expected)
  (and
    (equal? (token-name actual) (test-token-name expected))
    (equal? (token-value actual) (test-token-value expected))
  )
)

(define smallproject02-tests
  (test-suite
    "SmallProject02"
    (test-suite
      "get-token"
      (test-suite
        "NUMBERs"
        (correct-token? (get-token-test-helper "0") (test-token 'NUMBER 0))
        (correct-token? (get-token-test-helper "12") (test-token 'NUMBER 12))
        (correct-token? (get-token-test-helper "3.") (test-token 'NUMBER 3.0))
        (correct-token? (get-token-test-helper "45.") (test-token 'NUMBER 45.0))
        (correct-token? (get-token-test-helper ".0") (test-token 'NUMBER 0.0))
        (correct-token? (get-token-test-helper ".78") (test-token 'NUMBER 0.78))
        (correct-token? (get-token-test-helper "6.5") (test-token 'NUMBER 6.5))
        (correct-token? (get-token-test-helper "12.84") (test-token 'NUMBER 12.84))
      )
      (test-suite
        "SYMBOLs"
        (correct-token? (get-token-test-helper "_") (test-token 'SYMBOL "_"))        
        (correct-token? (get-token-test-helper "a") (test-token 'SYMBOL "a"))        
        (correct-token? (get-token-test-helper "B") (test-token 'SYMBOL "B"))        
        (correct-token? (get-token-test-helper "_m") (test-token 'SYMBOL "_m"))        
        (correct-token? (get-token-test-helper "a0") (test-token 'SYMBOL "a0"))        
        (correct-token? (get-token-test-helper "_Z9") (test-token 'SYMBOL "_Z9"))        
        (correct-token? (get-token-test-helper "lmn456FOO") (test-token 'SYMBOL "lmn456FOO"))        
      )
      (test-suite
        "OPERATORs"
        (correct-token? (get-token-test-helper "+") (test-token 'OPERATOR "+"))                
        (correct-token? (get-token-test-helper "-") (test-token 'OPERATOR "-"))                
        (correct-token? (get-token-test-helper "*") (test-token 'OPERATOR "*"))                
      )
      (test-suite
        "PARENs"
        (correct-token? (get-token-test-helper "(") (test-token 'PAREN "("))                
        (correct-token? (get-token-test-helper ")") (test-token 'PAREN ")"))
      )
      (test-suite
        "COMMENTs"
        (correct-token? (get-token-test-helper "//") (test-token 'COMMENT "//"))
        (correct-token? (get-token-test-helper "//nospace") (test-token 'COMMENT "//nospace"))
        (correct-token? (get-token-test-helper "// space") (test-token 'COMMENT "// space"))
        (correct-token? (get-token-test-helper "// 0 .1 5. 89.76") (test-token 'COMMENT "// 0 .1 5. 89.76"))
        (correct-token? (get-token-test-helper "// _ a z A Z _56 abcDEF908") (test-token 'COMMENT "// _ a z A Z _56 abcDEF908"))
        (correct-token? (get-token-test-helper "//()()") (test-token 'COMMENT "//()()"))
        (correct-token? (get-token-test-helper "// + - *") (test-token 'COMMENT "// + - *"))
        (correct-token? (get-token-test-helper "//!@#$%^&*") (test-token 'COMMENT "//!@#$%^&*"))
        (correct-token? (get-token-test-helper "// commentception // whoaaa ") (test-token 'COMMENT "// commentception // whoaaa "))
      )
      (test-suite
        "EOF"
        (check-equal? (token-name (get-token-test-helper "")) 'EOF)
        (check-equal? (token-name (get-token-test-helper " \n ")) 'EOF)
      )
      (test-suite
        "ERRORs"
        (correct-token? (get-token-test-helper "^") (test-token 'ERROR "^"))
        (correct-token? (get-token-test-helper "@err valid") (test-token 'ERROR "@"))
        (correct-token? (get-token-test-helper "&//comment") (test-token 'ERROR "&"))
      )
    )
  )
)

(run-tests smallproject02-tests)
