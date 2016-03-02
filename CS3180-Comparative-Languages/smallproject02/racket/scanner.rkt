#lang racket

; SmallProject02
; Andrew Berger
; CS 3180
; Spring 2016

(require parser-tools/lex)
(require (prefix-in : parser-tools/lex-sre))

(define-tokens value-tokens (NUMBER SYMBOL PAREN COMMENT ERROR OPERATOR))
(define-empty-tokens punct-tokens (EOF))

(define-lex-abbrev digit (:/ #\0 #\9))
(define-lex-abbrev letter (:/ #\a #\z #\A #\Z))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; get-token is a lexer which matches tokens from the following grammar:
;;
;; - a number is
;;      one or more digits |
;;      zero of more digits followed by a decimal point followed by one or more digits |
;;      one or more digits followed by a decimal point followed by zero or more digits
;; - a symbol is
;;      one or more characters from the set [_A-Za-z] followed by zero or more characters from the set [_A-Za-z0-9]
;; - a comment is
;;      the literal string "//" followed by zero or more characters until the end of the line
;; - an arithmetic operator is
;;      + |
;;      - |
;;      * |
;;      /  
;; - a parenthesis is 
;;      ( |
;;      )
;; - EOF is 
;;    the literal end of input
(define get-token
  (lexer-src-pos
    ; end of input
    [(eof) (token-EOF)]

    ; skip whitespace
    [whitespace (return-without-pos (get-token input-port))]

    ; match COMMENTs
    [(:: "//" (:* (:~ #\newline))) (token-COMMENT lexeme)]

    ; match NUMBERs
    [(:+ digit) (token-NUMBER (string->number lexeme))]
    [(:: (:* digit) #\. (:+ digit)) (token-NUMBER (string->number lexeme))]
    [(:: (:+ digit) #\. (:* digit)) (token-NUMBER (string->number lexeme))]

    ; match SYMBOLS
    [
      (::
        (:+ (:or #\_ letter))
        (:* (:or #\_ letter digit))
      )
      (token-SYMBOL lexeme)
    ]

    ; match OPERATORs
    [(:or #\+ #\- #\*) (token-OPERATOR lexeme)]

    ; match PARENs
    [(:or #\( #\)) (token-PAREN lexeme)]

    ; everything else is an ERROR
    [any-char (token-ERROR lexeme)]
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Returns a list of all tokens found read from in-port. 
;;
;; Borrowed from instructor's provided code. Modified to fail fast on ERROR tokens.
(define (build-token-list a-pos-token in-port)
  (cond
    [(eq? 'ERROR (token-name (position-token-token a-pos-token)))
       (list a-pos-token)
    ]
    [(eq? 'EOF (token-name (position-token-token a-pos-token)))
       (list a-pos-token)
    ]
    [else (cons a-pos-token (build-token-list (get-token in-port) in-port))]
  )
)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Displays all tokens in a a-token-list
;;
;; Borrowed from instructor's provided code.
(define (display-it a-token-list)
  (cond
     [(empty? a-token-list) (void)]
     [else
        (begin
          (display (token-name (position-token-token (car a-token-list))))
          (display " = ")
          (displayln (token-value (position-token-token (car a-token-list))))
          (display-it (cdr a-token-list))
        )
      ]
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Configure input-port to count lines, build a list of all tokens read from
;; and input-port, and then parse the list of tokens indicate of whether the
;; tokens are accepted by the BNF grammar
;;
;; Borrowed from instructor's provided code.
(define (start-it input-port)
  (begin
    (port-count-lines! input-port)
    (display-it (build-token-list (get-token input-port) input-port))
  )
)

(provide
  get-token
  start-it
)
