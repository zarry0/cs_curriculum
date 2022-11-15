;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname genrec-quiz) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;
; PROBLEM 1:
; 
; In the lecture videos we designed a function to make a Sierpinski triangle fractal. 
; 
; Here is another geometric fractal that is made of circles rather than triangles:
;
;
;            #     #   
;       #              #
;    #                    #
;   #   *  *        *  *   #
;  # *        *  *        * #
;  #*          **          *#
;  #*          **          *#
;  # *        *  *        * #
;   #   *  *        *  *   #
;    #                    #
;       #              #
;            #     #   
;
; Design a function to create this circle fractal of size n and colour c.
; 

(define CUT-OFF 5)

;; Natural String -> Image
;; produce a circle fractal of size n and colour c
(check-expect (circle-fractal CUT-OFF "black") (overlay (circle CUT-OFF "outline" "black")
                                                        (beside (circle (/ CUT-OFF 2) "outline" "black")
                                                                (circle (/ CUT-OFF 2) "outline" "black"))))
(check-expect (circle-fractal (* 2 CUT-OFF) "black") (overlay (circle (* 2 CUT-OFF) "outline" "black")
                                                              (beside (circle-fractal CUT-OFF "black")
                                                                      (circle-fractal CUT-OFF "black"))))

(define (circle-fractal n c)
  (cond [(<= n CUT-OFF) (overlay (circle n "outline" c)
                                 (beside (circle (/ n 2) "outline" c)
                                         (circle (/ n 2) "outline" c)))]
        [else
         (local [(define sub (circle-fractal (/ n 2) c))]
           (overlay (circle n "outline" c)
                    (beside sub sub)))]))




;
; PROBLEM 2:
; 
; Below you will find some data definitions for a tic-tac-toe solver. 
; 
; In this problem we want you to design a function that produces all 
; possible filled boards that are reachable from the current board. 
; 
; In actual tic-tac-toe, O and X alternate playing. For this problem
; you can disregard that. You can also assume that the players keep 
; placing Xs and Os after someone has won. This means that boards that 
; are completely filled with X, for example, are valid.
; 
; Note: As we are looking for all possible boards, rather than a winning 
; board, your function will look slightly different than the solve function 
; you saw for Sudoku in the videos, or the one for tic-tac-toe in the 
; lecture questions. 
; 

;; Value is one of:
;; - false
;; - "X"
;; - "O"
;; interp. a square is either empty (represented by false) or has and "X" or an "O"
#;
(define (fn-for-value v)
  (cond [(false? v) (...)]
        [(string=? v "X") (...)]
        [(string=? v "O") (...)]))

;; Board is (listof Value)
;; a board is a list of 9 Values
(define B0 (list false false false
                 false false false
                 false false false))

(define B1 (list false "X"   "O"   ; a partly finished board
                 "O"   "X"   "O"
                 false false "X")) 

(define B2 (list "X"  "X"  "O"     ; a board where X will win
                 "O"  "X"  "O"
                 "X" false "X"))

(define B3 (list "X" "O" "X"       ; a board where Y will win
                 "O" "O" false
                 "X" "X" false))
#;
(define (fn-for-board b)
  (cond [(empty? b) (...)]
        [else 
         (... (fn-for-value (first b))
              (fn-for-board (rest b)))]))

;; Board helpers

;; Board Value Pos -> Board
;; produces a Board with val at position p
(check-expect (fill B0 "X" 4) (append (sublist B0 0 4) (list "X") (sublist B0 5 9)))

;(define (fill-sqr bd sq p) bd)  ;stub

(define (fill bd val p)
  (append (sublist bd 0 p)
          (list val)
          (sublist bd (add1 p) (length bd))))

;; (listof X) Natural Natural -> (listof X)
;; produces a sublist from index a to b (non inclusive)
;; ASSUME a <= b
(check-expect (sublist (list "a" "b" "c" "d" "e") 2 4) (list "c" "d"))

(define (sublist lox a b)
  (local [(define (fn n) (list-ref lox (+ n a)))]
    (build-list (- b a) fn)))

;; Board -> (listof Board)
;; produces a list of all possible filled boards that are reachable from the current board
(check-expect (next-boards B2) (list (fill B2 "X" 7) (fill B2 "O" 7)))
(check-expect (next-boards B3) (list (fill (fill B3 "X" 5) "X" 8) (fill (fill B3 "X" 5) "O" 8)
                                     (fill (fill B3 "O" 5) "X" 8) (fill (fill B3 "O" 5) "O" 8)))


;(define (next-boards bd) empty)  ;stub

(define (next-boards bd)
  (local [;; Board Natural[0,9) -> (listof Board)
          ;; (listof Board) Natural[0,9) -> (listof Board)
          ;; generates an arb-arity tree while filling the empty squares it finds until it fills out the board
          (define (fn--bd bd n)
            (cond [(>= n 9) (list bd)]
                  [(false? (list-ref bd n)) (fn--lobd (list (fill bd "X" n)
                                                            (fill bd "O" n)) n)]
                  [else (fn--bd bd (add1 n))]))

          (define (fn--lobd lobd n)
            (cond [(empty? lobd) empty]
                  [else (append (fn--bd (first lobd) n)
                                (fn--lobd (rest lobd) n))]))] 
    (fn--bd bd 0))) 



;; Board -> Image
;; produces a render of the game
(define (render bd)
  (local [(define E (square 15 "outline" "black"))
          ;; Board -> Image
          (define (render-rows bd i)
            (cond [(>= i 3) empty-image]
                  [else (above (foldr render-row empty-image (sublist bd (* i 3) (* (add1 i) 3)))
                               (render-rows bd (add1 i)))]))
          ;; Value Image -> Image
          (define (render-row v img)
            (beside (if (false? v)
                        E (overlay E (text v 12 "black"))) img))]
    (render-rows bd 0)))

;
; PROBLEM 3:
; 
; Now adapt your solution to filter out the boards that are impossible if 
; X and O are alternating turns. You can continue to assume that they keep 
; filling the board after someone has won though. 
; 
; You can assume X plays first, so all valid boards will have 5 Xs and 4 Os.
; 
; NOTE: make sure you keep a copy of your solution from problem 2 to answer 
; the questions on edX.
; 

;; (listof Board) -> (listof Board)
;; produces a lobd with only valid boards
;; a valid board is one in which the players play in alternating turns
;; ASSUME: X plays first, so a valid board has 5 Xs and 4 Os
(check-expect (filter-boards (list (fill (fill B3 "X" 5) "X" 8) (fill (fill B3 "X" 5) "O" 8)
                                   (fill (fill B3 "O" 5) "X" 8) (fill (fill B3 "O" 5) "O" 8))) (list  (fill (fill B3 "X" 5) "O" 8)
                                                                                                      (fill (fill B3 "O" 5) "X" 8)))

;(define (filter-boards lobd) empty)  ;stub

(define (filter-boards lobd)
  (local [;; Board -> Boolean
          ;; produces true if there are 5 Xs and 4 Os
          ;; ASSUME: the boards will be full
          (define (valid-board? bd)
            (= (foldr count 0 bd) 5))

          ;; Value Natural -> Natural
          ;; Adds 1 to the count if Value is "X"
          (define (count sq c)
            (+ (if (string=? sq "X") 1 0) c))]
    
    (filter valid-board? lobd)))
