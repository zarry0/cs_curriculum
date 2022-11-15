;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname triangle-solitaire) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; triangle-solitaire-starter.rkt
(require racket/list)
(require 2htdp/image)

;
; PROBLEM:
;
; The game of triangular peg solitaire is described at a number of web sites,
; including http://www.mathsisfun.com/games/triangle-peg-solitaire/#. 
;
; We would like you to design a program to solve triangular peg solitaire
; boards. Your program should include a function called solve that consumes
; a board and produces a solution for it, or false if the board is not
; solvable. Read the rest of this problem box VERY CAREFULLY, it contains
; both hints and additional constraints on your solution.
;
; The key elements of the game are:
;
;   - there is a BOARD with 15 cells, each of which can either
;     be empty or contain a peg (empty or full).
;    
;   - a potential JUMP whenever there are 3 holes in a row
;   
;   - a VALID JUMP  whenever from and over positions contain
;     a peg (are full) and the to position is empty
;    
;   - the game starts with a board that has a single empty
;     position
;    
;   - the game ends when there is only one peg left - a single
;     full cell                                                       
;    
; Here is one sample sequence of play, in which the player miraculously does
; not make a single incorrect move. (A move they have to backtrack from.) No
; one is actually that lucky!
;
;     ◯           ◉           ◉           ◯           ◯
;    ◉ ◉         ◯ ◉         ◯ ◉         ◯ ◯         ◉ ◯ 
;   ◉ ◉ ◉       ◯ ◉ ◉       ◉ ◯ ◯       ◉ ◯ ◉       ◯ ◯ ◉
;  ◉ ◉ ◉ ◉     ◉ ◉ ◉ ◉     ◉ ◉ ◉ ◉     ◉ ◉ ◉ ◉     ◯ ◉ ◉ ◉
; ◉ ◉ ◉ ◉ ◉   ◉ ◉ ◉ ◉ ◉   ◉ ◉ ◉ ◉ ◉   ◉ ◉ ◉ ◉ ◉   ◉ ◉ ◉ ◉ ◉
;
;     ◯           ◯           ◯           ◯           ◯
;    ◉ ◉         ◉ ◉         ◉ ◉         ◯ ◉         ◯ ◯ 
;   ◯ ◯ ◯       ◯ ◉ ◯       ◯ ◉ ◉       ◯ ◯ ◉       ◯ ◯ ◯
;  ◯ ◉ ◉ ◯     ◯ ◯ ◉ ◯     ◯ ◯ ◯ ◯     ◯ ◯ ◉ ◯     ◯ ◯ ◉ ◉
; ◉ ◉ ◉ ◉ ◉   ◉ ◯ ◉ ◉ ◉   ◉ ◯ ◯ ◉ ◉   ◉ ◯ ◯ ◉ ◉   ◉ ◯ ◯ ◉ ◉
;
;     ◯           ◯           ◯           ◯   
;    ◯ ◯         ◯ ◯         ◯ ◯         ◯ ◯   
;   ◯ ◯ ◉       ◯ ◯ ◯       ◯ ◯ ◯       ◯ ◯ ◯  
;  ◯ ◯ ◉ ◯     ◯ ◯ ◯ ◯     ◯ ◯ ◯ ◯     ◯ ◯ ◯ ◯  
; ◉ ◯ ◯ ◉ ◯   ◉ ◯ ◉ ◉ ◯   ◉ ◉ ◯ ◯ ◯   ◯ ◯ ◉ ◯ ◯  
;


;; Constants
(define ◉ true)
(define ◯ false)
(define CELL-RAD 10)
(define HOLE (circle CELL-RAD "outline" "blue"))
(define PEG (overlay (circle CELL-RAD "outline" "blue")
                     (circle (* CELL-RAD .8) "solid" "blue")))

;; Data Definitions

;; Cell is one of:
;;  - true
;;  - false
;; interp. true means there is a peg the cell (closed)
;;         false means the cell is empty      (open)

(define-struct board (bd prev))
;; Board is one of:
;;  - false
;;  - (make-board (listof Cell) Board)
;; interp. bd is a list 15 cells long that represents the state of the game
;;         prev is a reference to the previous move on the board
;;              or false if the board has no previous moves
;; <examples after board helpers definitions>

;; Pos is Natural[0, 15)
;; interp. the index of a cell in the board
(define INDEXES (list      0
                           1 2
                           3 4 5
                           6 7 8 9
                           10 11 12 13 14))

;; Unit is (listof Pos)
;; interp. the indexes of that form a diagonal or a row

(define DR1 (list 0 1 3 6 10))
(define DR2 (list 2 4 7 11))
(define DR3 (list 5 8 12))
(define DR4 (list 9 13))

(define DL1 (list 0 2 5 9 14))
(define DL2 (list 1 4 8 13))
(define DL3 (list 3 7 12))
(define DL4 (list 6 11))

(define DIAGONALS (list DR1 DR2 DR3 DR4 DL1 DL2 DL3 DL4))

(define R0 (list 0))
(define R1 (list 1 2))
(define R2 (list 3 4 5))
(define R3 (list 6 7 8 9))
(define R4 (list 10 11 12 13 14))

(define ROWS (list R2 R3 R4))
;; ** no horizontal jumps can be made with R1 and R2

(define UNITS (append ROWS DIAGONALS))

;; Jump is (listof Pos)
;; interp. a list of 3 cell positions adjacent to each other in either a row or a diagonal
(define J1 (list 3 4 5))
(define J2 (list 2 4 7))
(define J3 (list 1 4 8))

;; Board helper functions

;; (listof Cell) Cell Pos -> (listof Cell)
;; produces a list of cells with the new value c at position p
(check-expect (fill-cell (board-bd BD1) ◯ 3) (append (sublist (board-bd BD1) 0 3) (list ◯) (sublist (board-bd BD1) 4 15)))
(check-expect (fill-cell (board-bd BD1) ◉ 0) (cons ◉ (rest (board-bd BD1))))

;(define (fill-cell loc c p) loc)  ;stub

(define (fill-cell loc c p)
  (append (sublist loc 0 p)
          (list c)
          (sublist loc (add1 p) (length loc))))

;; (listof X) Natural Natural -> (listof X)
;; produces a sublist from index a to b (non inclusive)
;; ASSUME a <= b
(check-expect (sublist (list "a" "b" "c" "d" "e") 2 4) (list "c" "d"))

(define (sublist lox a b)
  (build-list (- b a) (lambda (n) (list-ref lox (+ n a)))))

;; Examples

(define B0 (build-list 15 (lambda (n) ◉)))

(define BD1 (make-board (fill-cell B0 ◯ 0) false)) ;no previous moves, top spot open
(define BD2 (make-board (fill-cell (fill-cell B0 ◯ 3) ◯ 1) BD1))
(define BD3 (make-board (fill-cell (fill-cell (fill-cell (board-bd BD2) ◉ 3) ◯ 4) ◯ 5) BD2))
(define BD4 (make-board (fill-cell (fill-cell (fill-cell (board-bd BD3) ◉ 5) ◯ 2) ◯ 0) BD3))
(define BD5 (make-board (fill-cell (fill-cell (fill-cell (board-bd BD4) ◉ 1) ◯ 3) ◯ 6) BD4))
(define BD6 (make-board (fill-cell (fill-cell (fill-cell (board-bd BD5) ◉ 2) ◯ 5) ◯ 9) BD5))
(define BD7 (make-board (fill-cell (fill-cell (fill-cell (board-bd BD6) ◉ 4) ◯ 7) ◯ 11) BD6))
(define BD8 (make-board (fill-cell (fill-cell (fill-cell (board-bd BD7) ◉ 5) ◯ 8) ◯ 12) BD7))
(define BD9 (make-board (fill-cell (fill-cell (fill-cell (board-bd BD8) ◉ 8) ◯ 4) ◯ 1) BD8))
(define BD10 (make-board (fill-cell (fill-cell (fill-cell (board-bd BD9) ◉ 9) ◯ 5) ◯ 2) BD9))
(define BD11 (make-board (fill-cell (fill-cell (fill-cell (board-bd BD10) ◉ 5) ◯ 9) ◯ 14) BD10))
(define BD12 (make-board (fill-cell (fill-cell (fill-cell (board-bd BD11) ◉ 12) ◯ 8) ◯ 5) BD11))
(define BD13 (make-board (fill-cell (fill-cell (fill-cell (board-bd BD12) ◉ 11) ◯ 12) ◯ 13) BD12))
(define BD14 (make-board (fill-cell (fill-cell (fill-cell (board-bd BD13) ◉ 12) ◯ 10) ◯ 11) BD13))

(define BDx (make-board (fill-cell (fill-cell (board-bd BD13) ◉ 14) ◯ 11) BD3)) ;no solution


;; Functions

;; Board -> Board or false
;; produces the board that it's the solution to the puzzle, and holds a reference to
;; to each step in the solution
(check-expect (solve BD1) BD14)
(check-expect (solve BDx) false)

;(define (solve bd) false)  ;stub

(define (solve bd)
  (local [;; Board -> Board | false
          ;; (listof Board) -> Board | false
          ;; produces the solution board with the sequence of steps that lead to it
          (define (solve--bd bd)
            (cond [(solved? (board-bd bd)) bd]
                  [else (solve--lobd (next-boards bd))]))

          (define (solve--lobd lobd)
            (cond [(empty? lobd) false]
                  [else
                   (local [(define try (solve--bd (first lobd)))] 
                     (if (not (false? try))
                         try
                         (solve--lobd (rest lobd))))]))]
    (solve--bd bd)))

;; (listof Cell) -> Boolean
;; produces true if there is only one peg in the board
(check-expect (solved? (board-bd BD8)) false)
(check-expect (solved? (board-bd BD14)) true)

;(define (solved? loc) false)  ;stub

(define (solved? loc)
  (local [;; (listof Cell) -> Natural[0, 15]
          ;; produces the number of pegs (false) in the board
          (define (count-pegs loc)
            (foldr (lambda (cell count)
                     (if (not (false? cell))
                         (add1 count)
                         count)) 0 loc))]
    (= 1 (count-pegs loc))))

;; Board -> (listof Board)
;; produces a list of the possible moves from the current board
(check-expect (next-boards BD14) empty)
(check-expect (next-boards BDx) empty) ; no more moves
(check-expect (next-boards BD12) (list (make-board (board-bd BD13) BD12)
                                       (make-board (fill-cell (fill-cell (fill-cell (board-bd BD12) ◯ 12) ◯ 13) ◉ 14) BD12)))
(check-expect (next-boards BD1) (list BD2
                                      (make-board (fill-cell (fill-cell (fill-cell (board-bd BD1) ◯ 2) ◯ 5) ◉ 0) BD1)))

;(define (next-boards bd) empty)  ;stub

(define (next-boards bd)
  (build-boards (next-moves (board-bd bd)) bd))

;; (listof Cell) -> (listof (listof Cell))
;; produces a list of cells with the next possible moves
(check-expect (next-moves (board-bd BDx)) empty)
(check-expect (next-moves (board-bd BD1)) (list (board-bd BD2)
                                                (fill-cell (fill-cell (fill-cell (board-bd BD1) ◯ 2) ◯ 5) ◉ 0)))

;(define (next-moves loc) empty)  ;stub

(define (next-moves loc)
  (local [;; Pos -> (listof (listof Cell))
          ;; for each pos in the board produces a list of the possible moves
          (define (traverse-board n)
            (cond [(>= n 15) empty]
                  [else (append (make-moves loc n)
                                (traverse-board (add1 n)))]))]
    (filter (lambda (b) (not (empty? b))) (traverse-board 0))))

;; (listof Cell) Pos -> (listof (listof Cell))
;; produces a list of possible moves at that position
(check-expect (make-moves (board-bd BD1) 0) empty)
(check-expect (make-moves (board-bd BD1) 1) (list (board-bd BD2)))
(check-expect (make-moves (board-bd BD8) 4) (list (fill-cell (fill-cell (fill-cell (board-bd BD8) ◯ 4) ◯ 5) ◉ 3)
                                                  (fill-cell (fill-cell (fill-cell (board-bd BD8) ◯ 4) ◯ 2) ◉ 7)
                                                  (fill-cell (fill-cell (fill-cell (board-bd BD8) ◯ 4) ◯ 1) ◉ 8)))

;(define (make-moves loc p) empty)  ;stub

(define (make-moves loc p)
  (if (peg? loc p)
      (make-jumps loc (get-jumps p))
      empty))

;; (listof Cell) Pos -> Boolean
;; produce true if the cell at position p is a peg (true)
(check-expect (peg? (board-bd BD1) 0) false)
(check-expect (peg? (board-bd BD1) 1) true)

;(define (peg? loc p) false)  ;stub

(define (peg? loc p)
  (not (false? (list-ref loc p))))

;; Pos -> (listof Jump)
;; produces a list of possible jups at that position
(check-expect (get-jumps 4) (list J1 J2 J3))

;(define (get-jumps p) empty)  ;stub

(define (get-jumps p)
  (local [(define lou (filter-units p))]
    (map (lambda (unit)
           (local [(define i (index-of unit p))]
             (sublist unit (sub1 i) (+ i 2))))
         lou)))

;; Pos -> (listof Unit)
;; produces the units that contain positions that can be jumped over
;; a position can be jumped over if is a peg and has two other cells arround it in either a row or a diagonal
(check-expect (filter-units 4) (list R2 DR2 DL2))
(check-expect (filter-units 1) (list DR1))

;(define (filter-units i) empty)  ;stub

(define (filter-units i)
  (filter (lambda (lop) (and (not (= i (list-ref lop 0)))
                             (not (= i (list-ref lop (sub1 (length lop)))))
                             (foldr (lambda (pos Y) (or (= i pos) Y)) false lop))) UNITS))

 
;; (listof Cell) (listof Jump) -> (listof (listof Cell))
;; produces a list of cells with a new possible move
(check-expect (make-jumps (board-bd BD1) (get-jumps 0)) empty)
(check-expect (make-jumps (board-bd BD1) (get-jumps 1)) (list (board-bd BD2)))

;(define (make-jumps loc loj) empty)  ;stub

(define (make-jumps loc loj)
  (cond [(empty? loj) empty]
        [else (map (lambda (j) (make-jump j loc)) loj)]))

;; Jump (listof Cell) -> (listof Cell)
;; if the jump is valid, produces the board after the jump
(check-expect (make-jump (list 0 1 3) (board-bd BD2)) empty)
(check-expect (make-jump (list 0 1 3) (board-bd BD1)) (board-bd BD2))

;(define (make-jump j loc) empty)  ;stub

(define (make-jump j loc)
  (local [(define from (list-ref loc (list-ref j 0)))
          (define over (list-ref loc (list-ref j 1)))
          (define to (list-ref loc (list-ref j 2)))
          (define jump-pos (list from over to))]
    
    (if (valid-jump? jump-pos loc)
        (fill-cell
         (fill-cell
          (fill-cell loc (not from) (list-ref j 0))
          (not over) (list-ref j 1))
         (not to)   (list-ref j 2))
        empty)))

;; (listof Cell) (listof Cell) -> Boolean
;; produces true if the jump is valid
;; a valid jump is one peg surrounded by another peg and a hole

;(define (valid-jump? j loc) true)  ;stub

(define (valid-jump? j loc)
  (local [(define from (list-ref j 0))
          (define over (list-ref j 1))
          (define to (list-ref j 2))]
    (cond [(and (false? from) (not (false? over)) (not (false? to))) true]
          [(and (not (false? from)) (not (false? over)) (false? to)) true]
          [else false])))

;; (listof (listof Cell)) Board -> (listof Board)
;; produces a list of boards from loloc and with bd as their parent
(check-expect (build-boards (make-moves (board-bd BD8) 4) false)
              (map (lambda (x) (make-board x false)) (make-moves (board-bd BD8) 4)))

;(define (build-boards loloc bd) empty)  ;stub

(define (build-boards loloc bd)
  (map (lambda (loc) (make-board loc bd)) loloc))

;; Board -> Image
;; produces an image of the board
(check-expect (render BD1) (above HOLE
                                  (beside PEG PEG)
                                  (beside PEG PEG PEG)
                                  (beside PEG PEG PEG PEG)
                                  (beside PEG PEG PEG PEG PEG)))


(define (render bd)
  (local [(define ROW-INDEX (list 0 1 3 6 10))
          (define cells (board-bd bd))
          ;; Cell -> Image
          ;; produces the right render of a single cell
          (define (choose-cell c) (if (false? c) HOLE PEG))
          
          ;; Board Natural[0,4] -> Image
          ;; produces a render of the row n
          (define (render-row bd n)
            (local [(define a (list-ref ROW-INDEX n))]
              (foldr (lambda (x y) (beside (choose-cell x) y)) empty-image (sublist bd a (+ a n 1)))))

          ;; Board -> Image
          ;; produces the render of the board
          (define (render-board bd n)
            (cond [(>= n 4) (render-row bd 4)]
                  [else (above (render-row bd n)
                               (render-board bd (add1 n)))]))]
    (render-board cells 0)))

;; Board -> (listof Image)
;; produces a list of the renders of the board and its parents
(check-expect (render-steps BD2) (list (render BD2) (render BD1)))

;(define (render-steps bd) empty)  ;stub

(define (render-steps bd)
  (local [(define (list-render bd)
            (cond [(false? bd) empty]
                  [else (cons (render bd)
                              (render-steps (board-prev bd)))]))]
    (list-render bd)))

;; Board -> (listof Image)di
;; produces a render of the solution steps
(check-expect (render-solution (make-board (board-bd BD13) false)) (list (render BD13) (render BD14)))

(define (render-solution bd)
  (reverse (render-steps (solve bd))))
