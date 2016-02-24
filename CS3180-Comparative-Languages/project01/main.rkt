#lang racket

;; Project01
;; Andrew Berger
;; CS 3180
;; Spring 2016

(require 2htdp/batch-io)

;; char2pos is a hash table whose keys are ASCII chars and values are lists of (row . col) pairs
;; indicating where that char can be found in a matrix.
(define char2pos (make-hash))

;; pos2char is a hash table mapping (row . col) pairs to ASCII chars.
(define pos2char (make-hash))

;; DESCRIPTION:
;; Converts a matrix row to a list of pairs where the first item in each pair is a
;; position pair (row . col) and the second item is the value at that position.
;; EXAMPLE: (row->pairs 0 0 '(#\a #\b)) => '(((0 . 0) . #\a) ((0 . 1) . #\b))
;; CONTRACT: row->pairs : rowNum colNum row -> list[pair]
(define (row->pairs rowNum colNum row)
  (cond
    [(null? row) null]
    [else (cons (cons (cons rowNum colNum) (first row)) (row->pairs rowNum (+ 1 colNum) (rest row)))]
  )
)

;; DESCRIPTION:
;; Converts a matrix to a list of pairs where the first item in each pair is a
;; position pair (row . col) and the second item is the value at that position.
;; EXAMPLE: see example for row->pair
;; CONTRACT: matrix->pairs : rowNum rows -> list[pair]
(define (matrix->pairs rowNum rows)
  (cond
    [(null? rows) null]
    [else (append (row->pairs rowNum 0 (first rows)) (matrix->pairs (+ 1 rowNum) (rest rows)))]
  )
)

;; DESCRIPTION:
;; Returns true if word is found in the input matrix at position pos in the direction
;; specified by delta-row and delta-col.
;; PRECONDITION: char2pos and pos2char are populated for the input matrix (probably by find-words)
;; INPUT: pos is a (row . col) position pair
;; CONTRACT: word-at-pos? : word pos delta-row delta-col -> boolean
(define (word-at-pos? word pos delta-row delta-col)
  (cond
    [(null? word) #t] ; must have matched all the chars! woo!
    [ ; if the letter at pos matches the current letter, continue searching
      (equal? (first word) (hash-ref pos2char pos null))
      (word-at-pos? (rest word) (cons (+ delta-row (car pos)) (+ delta-col (cdr pos))) delta-row delta-col)
    ]
    [else #f] ; found non-matching char
  )
)

;; DESCRIPTION:
;; Returns true if word can be found in the input matrix starting at any of the positions
;; in the list start-positions. Checks in all eight directions (ie N S E W NE SE SW NW).
;; PRECONDITION: char2pos and pos2char are populated for the input matrix (probably by find-words)
;; INPUT: start-positions is a list of (row . col) position pairs
;; CONTRACT: word-at-positions? : word start-positions -> boolean
(define (word-at-positions? word start-positions)
  (cond
    [(null? start-positions) #f]
    [(or
        (word-at-pos? word (first start-positions) 0 1)   ; E
        (word-at-pos? word (first start-positions) 0 -1)  ; W
        (word-at-pos? word (first start-positions) 1 0)   ; S
        (word-at-pos? word (first start-positions) -1 0)  ; N
        (word-at-pos? word (first start-positions) 1 1)   ; SE
        (word-at-pos? word (first start-positions) 1 -1)  ; SW
        (word-at-pos? word (first start-positions) -1 1)  ; NE
        (word-at-pos? word (first start-positions) -1 -1) ; NW
       )
      #t
    ]
    [else (word-at-positions? word (rest start-positions))]
  )
)

;; DESCRIPTION:
;; Returns true if word can be found in the input matrix along horizontals, verticals, and diagonals
;; both forwards and backward.
;; PRECONDITIONS: char2pos and pos2char are populated for the input matrix (probably by find-words)
;; CONTRACT: word-in-matrix? : word -> boolean
(define (word-in-matrix? word)
  (cond
    [(null? word) #f]
    [else
      (let ([start-positions (hash-ref char2pos (first word) #f)])
        (if (not start-positions)
          #f ; the first letter isn't in the matrix
          (word-at-positions? word start-positions)
        )
      )
    ]
  )
)

;; DESCRIPTION:
;; Populates the hash tables pos2char and char2pos with mtx. pos2char maps (row . col) pairs to values
;; found at that position in the matrix. char2pos maps ASCII characters to (row . col) pairs where they
;; can be found in the matrix.
;; PRECONDITIONS: pos2char and char2pos are defined to be hash tables
;; CONTRACT: populate-hash-tables : mtx -> none
(define (populate-hash-tables mtx)
  (map 
    (lambda (p) 
      (begin
        (hash-set! pos2char (car p) (cdr p))
        (hash-set! char2pos (cdr p) (append (list (car p)) (hash-ref char2pos (cdr p) null)))
      )
    )
    (matrix->pairs 0 (map (compose string->list string-downcase) mtx))
  )
)

;; DESCRIPTION:
;; Returns a list of words at least four characters long found within
;; http://www.cs.duke.edu/~ola/ap/linuxwords that are also found in the letters provided in the letters argument.
;; A word is only found if the word can be composed of consecutive letters in order within a single row,
;; single column, or single diagonal in the letters matrix either forwards or backwards.
;; PRECONDITION: a local text file named `linuxwords` exists in the local directory
;; CONTRACT: find-words : width length letters -> list
(define (find-words width length letters)
  (begin
    ; populate the hash tables for the letters matrix
    (populate-hash-tables letters)
    ; filter the input set to exclude too-short or too-long words, then feed it to the beast
    (map
      list->string
      (filter
        word-in-matrix? ; the mighty maw of the beast
        (map 
          (compose string->list string-downcase)
          (filter
            (lambda (line) (and (<= 4 (string-length line)) (>= (max width length) (string-length line))))
            (read-lines "linuxwords")
          )
        )
      )
    )
  )
)

(provide
  row->pairs
  matrix->pairs
  word-at-pos?
  word-at-positions?
  word-in-matrix?
  populate-hash-tables
  find-words
)
