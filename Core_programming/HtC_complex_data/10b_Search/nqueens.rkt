;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname nqueens) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require racket/list)

;; nqueens-starter.rkt

;
; This project involves the design of a program to solve the n queens puzzle.
;
; This starter file explains the problem and provides a few hints you can use
; to help with the solution.
;
; The key to solving this problem is to follow the recipes! It is a challenging
; problem, but if you understand how the recipes lead to the design of a Sudoku
; solver then you can follow the recipes to get to the design for this program.
;  
;
; The n queens problem consists of finding a way to place n chess queens
; on a n by n chess board while making sure that none of the queens attack each
; other. 
;
; The BOARD consists of n^2 individual SQUARES arranged in 4 rows of 4 columns.
; The colour of the squares does not matter. Each square can either be empty
; or can contain a queen.
;
; A POSITION on the board refers to a specific square.
;
; A queen ATTACKS every square in its row, its column, and both of its diagonals.
;
; A board is VALID if none of the queens placed on it attack each other.
;
; A valid board is SOLVED if it contains n queens.
;
;
; There are many strategies for solving nqueens, but you should use the following:
;  
;   - Use a backtracking search over a generated arb-arity tree that
;     is trying to add 1 queen at a time to the board. If you find a
;     valid board with 4 queens produce that result.
;
;   - You should design a function that consumes a natural - N - and
;     tries to find a solution.
;    
;    
;    
; NOTE 1: You can tell whether two queens are on the same diagonal by comparing
; the slope of the line between them. If one queen is at row and column (r1, c1)
; and another queen is at row and column (r2, c2) then the slope of the line
; between them is: (/ (- r2 r1) (- c2 c1)).  If that slope is 1 or -1 then the
; queens are on the same diagonal.
;

;; Constants
(define Q true)
(define SQR-LEN 20)
(define SQR (square SQR-LEN "outline" "black"))
(define QUEEN (overlay (text "Q" (* .8 SQR-LEN) "black") SQR))

;; Data Definitions

;; Square is one of:
;;  - true
;;  - false
;; interp. true is a square with a queen in it
;;         false is an empty square
(define S1 true)
(define S2 false)

;; Board is (listof Square)
;; interp. a plain list of n^2 Squares representing a grid of n by n Squares
(define B0 (build-list 16 (lambda (x) false))) ; Empty 4 by 4 board
;; <the other examples after board helpers>

;; Pos is Natural[0, n*n)
;; interp. the index of a square in the Board
;; and for any given p:
;;    - the row    is (quotient p n)
;;    - the column is (remainder p n)

(define-struct coord (r c))
;; Coord is (make-coord Natural[0, n) Natural[0, n))
;; interp. the 0-based coordinate of a square (row, column)
(define C1 (make-coord 0 1)) ; row 0, col 1
(define C2 (make-coord 3 2)) ; row 3, col 2

;; Coord Natural -> Pos
;; Convert Coord to Pos
(define (coord->pos c n) (+ (* (coord-r c) n) (coord-c c)))

;; Pos Natural -> Coord
;; Convert Pos to Coord
(define (pos->coord p n) (make-coord (quotient p n) (remainder p n)))

;; Coord Coord -> Number
;; produces the slope between the two points
;; ASSUME: p1 & p2 are valid points in the same board
(define (slope p1 p2)
  (/ (- (coord-c p2) (coord-c p1)) (- (coord-r p2) (coord-r p1))))

;; Board helpers

;; Board Square Pos -> Board
;; produces a Board with sq at position p
(check-expect (fill-sqr B0 true 4) (append (sublist B0 0 4) (list true) (sublist B0 5 16)))

;(define (fill-sqr bd sq p) bd)  ;stub

(define (fill-sqr bd sq p)
  (append (sublist bd 0 p)
          (list sq)
          (sublist bd (add1 p) (length bd))))

;; (listof X) Natural Natural -> (listof X)
;; produces a sublist from index a to b (non inclusive)
;; ASSUME a <= b
(check-expect (sublist (list "a" "b" "c" "d" "e") 2 4) (list "c" "d"))

(define (sublist lox a b)
  (build-list (- b a) (lambda (n) (list-ref lox (+ n a)))))

;; Examples
(define B1 (fill-sqr B0 Q 1))
(define B2 (fill-sqr B1 Q 7))
(define B3 (fill-sqr B2 Q 8))
(define B4 (fill-sqr B3 Q 14))

;; Functions

;; Natural -> Board or false
;; produces a valid nxn Board with n queens
(check-expect (solve 4) B4)

;(define (solve n) empty)  ;stub

(define (solve n)
  (local [;; Natural -> Board
          ;; produces a nxn empty Board
          (define (build-board n) (build-list (* n n) (lambda (x) false)))

          ;; Board -> Board or false
          ;; (listof Board) -> Board or false
          (define (solve--bd bd)
            (cond [(solved? bd n) bd]
                  [else (solve--lob (next-queens bd n))]))

          (define (solve--lob lob)
            (cond [(empty? lob) false]
                  [else
                   (local [(define try (solve--bd (first lob)))]
                     (if (not (false? try))
                         try
                         (solve--lob (rest lob))))]))]
    (solve--bd (build-board n))))

;; Board -> Boolean
;; produce true if the Board (nxn) has n queens in valid positions
(check-expect (solved? B0 4) false)
(check-expect (solved? B2 4) false)
(check-expect (solved? B4 4) true)

;(define (solved? bd n) false)  ;stub

(define (solved? bd n)
  (local [;; (listof Coords) -> Boolean
          ;; produces true if the list has n valid queens
          (define (validate-queens loc)
            (and (= (length loc) n)
                 (valid-coords? loc coord-r)
                 (valid-coords? loc coord-c)
                 (valid-diagonals? loc)))]
    
    (validate-queens (get-queens bd 0 n))))


;; Board Natural[0, (length Board)) Natural -> (listof Coords)
;; produces a list with the coords of each queen in the board
(define (get-queens bd i n)
  (cond [(>= i (* n n)) empty]
        [(queen? (list-ref bd i)) (cons (pos->coord i n) (get-queens bd (add1 i) n))]
        [else (get-queens bd (add1 i) n)]))

;; (listof Coord) (Coord -> Natural) -> Boolean
;; produces true if all the coords have different <coord-param>
(define (valid-coords? loc coord-param)
  (cond [(empty? loc) true]
        [else (and (valid-coord? (coord-param (first loc)) (rest loc) coord-param)
                   (valid-coords? (rest loc) coord-param))]))
          
;; Coord (listof Coord) (Coord -> Natural) -> Boolean
;; produces true if n is different than the rest of <coord-param> 
(define (valid-coord? n loc coord-param)
  (cond [(empty? loc) true]
        [else (and (not (= n (coord-param (first loc))))
                   (valid-coord? n (rest loc) coord-param))]))
          
;; (listof Coords) -> Boolean
;; produces true if all the coords are in different diagonals
(define (valid-diagonals? loc)
  (cond [(empty? loc) true]
        [else (and (valid-diagonal? (first loc) (rest loc))
                   (valid-diagonals? (rest loc)))]))

;; Coord (listof Coord)
;; produces true if c has slopes different than +-1 with the rest of the coords
(define (valid-diagonal? c loc)
  (cond [(empty? loc) true]
        [else (and (not (= (abs (slope c (first loc))) 1))
                   (valid-diagonal? c (rest loc)))]))

;; Board -> (listof Board)
;; produces a list of boards with new queens on valid positions
;; ASSUME: bd is not solved
(check-expect (next-queens B0 4) (list (fill-sqr B0 true 0)
                                       (fill-sqr B0 true 1)
                                       (fill-sqr B0 true 2)
                                       (fill-sqr B0 true 3)))
(check-expect (next-queens B1 4) (list (fill-sqr B1 true 7)))

;(define (next-queens bd n) empty)  ;stub

(define (next-queens bd n)
  (local [(define curr-queens (get-queens bd 0 n))
          (define last-queen (if (zero? (length curr-queens))
                                 (make-coord -1 0)
                                 (first (reverse curr-queens))))
          (define next-row (add1 (coord-r last-queen)))]
    (filter (lambda (b) (valid-queens? b n)) (build-boards bd next-row n))))

;; Board Natural[0,n) Natural -> (listof Board)
;; produce a list of boards each with a queen on a different col in row r
(check-expect (build-boards B0 0 4) (list (fill-sqr B0 true 0)
                                          (fill-sqr B0 true 1)
                                          (fill-sqr B0 true 2)
                                          (fill-sqr B0 true 3)))
(check-expect (build-boards B1 1 4) (list (fill-sqr B1 true 4)
                                          (fill-sqr B1 true 5)
                                          (fill-sqr B1 true 6)
                                          (fill-sqr B1 true 7)))

;(define (build-boards bd r n) empty)  ;stub

(define (build-boards bd r n)
  (build-list n (lambda (c) (fill-sqr bd Q (coord->pos (make-coord r c) n)))))

;; Board Natural -> Boolean
;; produces true if the board contains queens only in valid positions
;; ASSUME: the board has at least 1 queen
(check-expect (valid-queens? B1 4) true)
(check-expect (valid-queens? (fill-sqr B1 true 2) 4) false)
(check-expect (valid-queens? (fill-sqr B1 true 4) 4) false)
(check-expect (valid-queens? (fill-sqr B1 true 9) 4) false)
(check-expect (valid-queens? (fill-sqr B1 true 7) 4) true)

;(define (valid-queens? bd n) false)  ;stub

(define (valid-queens? bd n)
  (local [(define queens (get-queens bd 0 n))]
    (and (valid-coords? queens coord-r)
         (valid-coords? queens coord-c)
         (valid-diagonals? queens))))

;; Square -> Boolean
;; produces true if the Square contains a Queen
(define (queen? sq) (not (false? sq)))

;; Board -> Image
;; produces a render of the board
(check-expect (render B4) (above (beside SQR QUEEN SQR SQR)
                                 (beside SQR SQR SQR QUEEN)
                                 (beside QUEEN SQR SQR SQR)
                                 (beside SQR SQR QUEEN SQR)))

;(define (render bd) empty-image)   ;stub

(define (render bd)
  (local [(define LEN (length bd))
          (define N (sqrt LEN)) ;board side length
          ;; Square -> Image
          ;; produces the right rendering for the given square
          (define (choose-sqr sq) (if (false? sq) SQR QUEEN))

          ;; Board Natural -> Image
          ;; produces a render of row n [0 ... N)
          (define (render-row bd n)
            (foldr (lambda (sq img)
                     (beside (choose-sqr sq) img)) empty-image (sublist bd (* n N) (+ (* n N) N))))]
    
    (foldr above empty-image (build-list N (lambda (n) (render-row bd n))))))
