;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname maze-2w) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;
; In this problem set you will design a program to check whether a given simple maze is
; solvable.  Note that you are operating on VERY SIMPLE mazes, specifically:
;
;    - all of your mazes will be square
;    - the maze always starts in the upper left corner and ends in the lower right corner
;    - at each move, you can only move down or right
;
; Design a representation for mazes, and then design a function that consumes a maze and
; produces true if the maze is solvable, false otherwise.
;
; Solvable means that it is possible to start at the upper left, and make it all the way to
; the lower right.  Your final path can only move down or right one square at a time. BUT, it
; is permissible to backtrack if you reach a dead end.
;
; For example, the first three mazes below are solvable.  Note that the fourth is not solvable
; because it would require moving left. In this solver you only need to support moving down
; and right! Moving in all four directions introduces complications we are not yet ready for.
;
;    ▒ █ █ █ █   ▒ ▒ ▒ ▒ ▒   ▒ ▒ ▒ ▒ ▒   ▒ ▒ ▒ ▒ ▒
;    ▒ ▒ █ ▒ ▒   ▒ █ █ █ ▒   ▒ █ █ █ █   ▒ █ █ █ ▒
;    █ ▒ █ █ █   ▒ █ █ █ ▒   ▒ █ █ █ █   ▒ █ ▒ ▒ ▒
;    ▒ ▒ █ █ █   ▒ █ █ █ ▒   ▒ █ █ █ █   ▒ █ ▒ █ █
;    ▒ ▒ ▒ ▒ ▒   ▒ █ █ █ ▒   ▒ ▒ ▒ ▒ ▒   █ █ ▒ ▒ ▒
;
;
; Your function will of course have a number of helpers. Use everything you have learned so far
; this term to design this program. 
;
; One big hint. Remember that we avoid using an image based representation of information unless
; we have to. So the above are RENDERINGs of mazes. You should design a data definition that
; represents such mazes, but don't use images as your representation.
;
; For extra fun, once you are done, design a function that consumes a maze and produces a
; rendering of it, similar to the above images.
;

;; Solve simple square mazes

;; Constants:
(define █ 0)
(define ▒ 1)
(define UNIT-SIZE 20)
(define ░ (square UNIT-SIZE "solid" "grey"))
(define ▓ (square UNIT-SIZE "solid" "black"))

;; Data definitions:

;; Path is one of:
;;  - 0
;;  - 1
;; interp. 0 means closed path (there is no path)
;;         1 means open path (there is a path)
;; <examples are redundant for enumerations>

(define M1 (list ▒ █ █ █ █   
                 ▒ ▒ █ ▒ ▒  
                 █ ▒ █ █ █  
                 ▒ ▒ █ █ █  
                 ▒ ▒ ▒ ▒ ▒))

(define M2 (list ▒ ▒ ▒ ▒ ▒  
                 ▒ █ █ █ ▒  
                 ▒ █ █ █ ▒  
                 ▒ █ █ █ ▒   
                 ▒ █ █ █ ▒))

(define M3 (list ▒ ▒ ▒ ▒ ▒   
                 ▒ █ █ █ █  
                 ▒ █ █ █ █  
                 ▒ █ █ █ █  
                 ▒ ▒ ▒ ▒ ▒))

(define M4 (list ▒ ▒ ▒ ▒ ▒
                 ▒ █ █ █ ▒
                 ▒ █ ▒ ▒ ▒
                 ▒ █ ▒ █ █
                 █ █ ▒ ▒ ▒))

(define-struct maze (mz p))
;; Maze is (make-maze (listof Path) Pos)
;; interp. a maze with
;;   - mz: A grid of nxn Paths that represents the open and closed paths
;;         that connect the top left corner with the bottom right corner.
;;         It is represented by a plain list of n^2 elements
;;   - p:  the current position on the maze

(define MZ1 (make-maze M1 0))
(define MZ2 (make-maze M2 0))
(define MZ3 (make-maze M3 0))
(define MZ4 (make-maze M4 0))  ;non-solvable maze
(define MZ5 (make-maze M1 15)) ;at row 3, column 0
(define MZ6 (make-maze M2 4))  ;at row 0, column 4
(define MZ7 (make-maze M3 20)) ;at row 4, column 0
(define MZ8 (make-maze M2 20)) ;at row 4, column 0  ; no more posible moves
(define MZ9 (make-maze M1 24)) ;at maze end 

;; Pos is Natural[0, n)
;; interp. the position on the maze, where
;;    - n          is (length maze) 
;; and for any given p:
;;    - the row    is (quotient p n)
;;    - the column is (remainder p n)

;; Functions:

;; Maze -> Boolean
;; produces true if the maze is solvable
;; solvable means that there is an open path from the top left corner to the bottom right
;; and the path can be traversed by only moving down and/or right
;; ASSUME: position 0 (start) will always be an open Path
;; ASSUME: maze is square
(check-expect (solvable? MZ1) true)
(check-expect (solvable? MZ2) true)
(check-expect (solvable? MZ3) true)
(check-expect (solvable? MZ4) false)

;(define (solvable? mz) false)  ;stub

(define (solvable? mz)
  (local [;; Maze -> Boolean
          ;; (listof Maze) -> Boolean
          ;; produce true if p = (- (length maze) 1);
          ;; false if there are no more valid places to move         (right path = 0 and down path = 0)
          (define (solvable?--maze mz)
            (cond [(maze-end? mz) true]                ;trivial case
                  [else
                   (solvable?--lom (next-mazes mz))])) ;generative recursion

          (define (solvable?--lom lom)
            (cond [(empty? lom) false]
                  [else
                   (local [(define try (solvable?--maze (first lom)))]
                     (if (not (false? try))
                         try
                         (solvable?--lom  (rest lom))))]))]

    (solvable?--maze mz)))

;; Maze -> Boolean
;; produces true if the current pos is at (- (length mz) 1)
;; ASSUME: p is a valid Pos
(check-expect (maze-end? MZ1) false)
(check-expect (maze-end? MZ5) false)
(check-expect (maze-end? MZ9) true)

;(define (maze-end? mz) false)  ;stub

(define (maze-end? mz)
  (= (maze-p mz) (- (length (maze-mz mz)) 1)))

;; Maze -> (listof Maze)
;; produces a list of all the next valid moves
;; a valid move is a right or down turn at an open path
(check-expect (next-mazes MZ1) (list (make-maze M1 5)))
(check-expect (next-mazes MZ5) (list (make-maze M1 16) (make-maze M1 20)))
(check-expect (next-mazes MZ8) empty)
  
;(define (next-mazes mz) empty)  ;stub

(define (next-mazes mz)
  (filter-moves (next-moves mz)))

;; Maze -> (listof mazes)
;; produces a list of up to 2 mazes with new positions to the right and down directions
(check-expect (next-moves MZ5) (list (make-maze M1 16) (make-maze M1 20)))
(check-expect (next-moves MZ6) (list (make-maze M2 9)))
(check-expect (next-moves MZ7) (list (make-maze M3 21)))
(check-expect (next-moves MZ8) (list (make-maze M2 21)))

;(define (next-moves mz) empty)  ;stub

(define (next-moves mz)
  (local [(define n (sqrt (length (maze-mz mz))))
          (define (col-n? p) (= (remainder p n) (- n 1))) ; true if p at last col
          (define (row-n? p) (= (quotient p n) (- n 1)))] ; true if p at last row
    (cond [(col-n? (maze-p mz)) (list (move mz n))]   ;move down
          [(row-n? (maze-p mz)) (list (move mz 1))]   ;move right
          [else (list (move mz 1) (move mz n))])))    ;(list move right, move down)

;; Maze Natural -> Maze
;; produces a maze with a new position given by (+ p n)
(check-expect (move MZ1 5) (make-maze M1 5))
(check-expect (move MZ1 1) (make-maze M1 1))

;(define (move mz n) mz)  ;stub

(define (move mz n)
  (make-maze (maze-mz mz) (+ (maze-p mz) n)))

;; (listof Maze) -> (listof Maze)
;; produces a list of mazes with only valid positions
(check-expect (filter-moves (list (make-maze M2 21) (make-maze M3 21))) (list (make-maze M3 21)))

;(define (filter-moves lom) lom)  ;stub

(define (filter-moves lom)
  (filter valid-maze? lom))

;; Maze -> Boolean
;; produces true if the current position on the maze is at an open path
(check-expect (valid-maze? (make-maze M2 21)) false)
(check-expect (valid-maze? (make-maze M3 21)) true)

;(define (valid-maze? mz) false)  ;stub

(define (valid-maze? mz)
  (= 1 (list-ref (maze-mz mz) (maze-p mz))))

;; Maze -> Image
;; produces a rendering of the given maze
(check-expect (render MZ1) (above (beside ░ ▓ ▓ ▓ ▓)
                                  (beside ░ ░ ▓ ░ ░)
                                  (beside ▓ ░ ▓ ▓ ▓)
                                  (beside ░ ░ ▓ ▓ ▓)
                                  (beside ░ ░ ░ ░ ░)))

;(define (render mz) empty-image)  ;stub

(define (render mz)
  (local [(define N (sqrt (length (maze-mz mz))))
          
          ;; Path -> Image
          ;; selects the right color square to be render based ont the type of path
          (define (choose-box p) (if (= p 1) ░ ▓))
          
          ;; (listof Path) -> Image
          ;; produces a rendering of each path on the list next to each other
          (define (render-row lop)
            (cond [(empty? lop) empty-image]
                  [else (beside (choose-box (first lop))
                                (render-row (rest lop)))]))

          ;; (listof X) Natural Natural -> (listof X)
          ;; produces a sublist of n elements starting from index i
          (define (sublist lox i n)
            (build-list n (lambda (m) (list-ref lox (+ m i)))))

          ;; (listof Path) Natural -> Image
          ;; produces the rendering of the maze
          ;; i is the index of the first box of a row; so starting at 0,
          ;; prints from 0 to n-1, then from n to 2n-1 and so on til n*n-1
          (define (render-maze lop i)
            (cond [(= i (length lop)) empty-image]
                  [else (above (render-row (sublist lop i N))
                               (render-maze lop (+ i N)))]))]
    
    (render-maze (maze-mz mz) 0)))