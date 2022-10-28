;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname cantor) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; cantor-starter.rkt

;
; PROBLEM:
;
; A Cantor Set is another fractal with a nice simple geometry.
; The idea of a Cantor set is to have a bar (or rectangle) of
; a certain width w, then below that are two recursive calls each
; of 1/3 the width, separated by a whitespace of 1/3 the width.
;
; So this means that the
;   width of the whitespace   wc  is  (/ w 3)
;   width of recursive calls  wr  is  (/ (- w wc) 2)
;  
; To make it look better a little extra whitespace is put between
; the bars.
;
;
; Here are a couple of examples (assuming a reasonable CUTOFF)
;
; (cantor CUTOFF) produces:
; 
; █
;
; (cantor (* CUTOFF 3)) produces:
;
; ███ 
; █ █
;
; And that keeps building up to something like the following. So
; as it goes it gets wider and taller of course.
;
;
; ███████████████████████████
; ███████████████████████████
; █████████         █████████
; ███   ███         ███   ███
; █ █   █ █         █ █   █ █ 

;; CONSTANTS

(define CUTOFF 5)
(define HEIGHT (* 2 CUTOFF))
(define V-SPACE (/ HEIGHT 3))

;
; PROBLEM A:
;
; Design a function that consumes a width and produces a cantor set of 
; the given width.
;

;; Number -> Image
;; produces a cantor set of the given width
(check-expect (cantor-basic CUTOFF) (rectangle CUTOFF HEIGHT "solid" "blue"))
(check-expect (cantor-basic (* 3 CUTOFF)) (above (rectangle (* 3 CUTOFF) HEIGHT "solid" "blue")
                                                 (rectangle (* 3 CUTOFF) V-SPACE "solid" "white")
                                                 (beside (rectangle CUTOFF HEIGHT "solid" "blue")
                                                         (rectangle CUTOFF HEIGHT "solid" "white")
                                                         (rectangle CUTOFF HEIGHT "solid" "blue"))))

;(define (cantor-basic w) empty-image)  ;stub

(define (cantor-basic w)
  (cond [(<= w CUTOFF) (rectangle w HEIGHT "solid" "blue")]
        [else
         (local [(define sub (cantor-basic (/ w 3)))
                 (define H-SPACE (rectangle (/ w 3) HEIGHT "solid" "white"))]
           (above (rectangle w HEIGHT "solid" "blue")
                  (rectangle w V-SPACE "solid" "white")
                  (beside sub H-SPACE sub)))]))

;
; PROBLEM B:
;
; Add a second parameter to your function that controls the percentage 
; of the recursive call that is white each time. Calling your new function
; with a second argument of 1/3 would produce the same images as the old 
; function.
;

;;Number Number[0, 1] -> Image
;; produces a cantor set of the given width and the given whitespace percentage
(check-expect (cantor CUTOFF .5) (rectangle CUTOFF HEIGHT "solid" "blue"))
(check-expect (cantor (* 3 CUTOFF) (/ 1 3)) (above (rectangle (* 3 CUTOFF) HEIGHT "solid" "blue")
                                                   (rectangle (* 3 CUTOFF) V-SPACE "solid" "white")
                                                   (beside (rectangle CUTOFF HEIGHT "solid" "blue")
                                                           (rectangle CUTOFF HEIGHT "solid" "white")
                                                           (rectangle CUTOFF HEIGHT "solid" "blue"))))
(check-expect (cantor (* 3 CUTOFF) 0.5) (above (rectangle (* 3 CUTOFF) HEIGHT "solid" "blue")
                                               (rectangle (* 3 CUTOFF) V-SPACE "solid" "white")
                                               (beside (rectangle (/ (- (* 3 CUTOFF) (* (* 3 CUTOFF) .5)) 2) HEIGHT "solid" "blue")
                                                       (rectangle (* (* 3 CUTOFF) .5) HEIGHT "solid" "white")
                                                       (rectangle (/ (- (* 3 CUTOFF) (* (* 3 CUTOFF) .5)) 2) HEIGHT "solid" "blue"))))
(check-expect (cantor (* 3 CUTOFF) 1) (above (rectangle (* 3 CUTOFF) HEIGHT "solid" "blue")
                                             (rectangle (* 3 CUTOFF) V-SPACE "solid" "white")
                                             (beside (rectangle (/ (- (* 3 CUTOFF) (* (* 3 CUTOFF) 1)) 2) HEIGHT "solid" "blue")
                                                     (rectangle (* (* 3 CUTOFF) 1) HEIGHT "solid" "white")
                                                     (rectangle (/ (- (* 3 CUTOFF) (* (* 3 CUTOFF) 1)) 2) HEIGHT "solid" "blue"))))


;(define (cantor w wc%) empty-image) ;stub

(define (cantor w %)
  (cond [(<= w CUTOFF) (rectangle w HEIGHT "solid" "blue")]
        [else
         (local [(define wc (* w %))
                 (define wr (/ (- w wc) 2))
                 (define sub (cantor wr %))
                 (define H-SPACE (rectangle wc HEIGHT "solid" "white"))]
           
           (above (rectangle w HEIGHT "solid" "blue")
                  (rectangle w V-SPACE "solid" "white")
                  (beside sub H-SPACE sub)))]))

;; Termination argument:

;; Base case: (<= w CUTOFF)

;; Reduction step (next problem): (/ (- w wc) 2)

;; Argument that repeated application of reduction step will eventually 
;; reach the base case:
;;   for each recursive call, we divide the width according to the given percentage,
;;   thus making it smaller until it reaches the base case

;
; PROBLEM C:
;
; Now you can make a fun world program that works this way:
;   The world state should simply be the most recent x coordinate of the mouse.
;  
;   The to-draw handler should just call your new cantor function with the
;   width of your MTS as its first argument and the last x coordinate of
;   the mouse divided by that width as its second argument.
;  

(require 2htdp/universe)

;; A cantor set visualizer
;; =================
;; Constants:

(define WORLD-H 500)
(define WORLD-W (* 2 WORLD-H))
(define BG (empty-scene WORLD-W WORLD-H))

;; WS is ... (give WS a better name)

;; =================
;; Functions:
;; Number -> Number
;; start the world with (main 0)
;; no tests for main
(define (main ws)
  (big-bang ws
    (to-draw render)
    (on-mouse  handle-mouse)))

;; Number -> Image
;; render the cantor set on the scene
(check-expect (render 500) (cantor WORLD-W (/ 500 WORLD-W)))
(check-expect (render 82) (cantor WORLD-W (/ 82 WORLD-W)))

(define (render ws) (cantor WORLD-W (/ ws WORLD-W)))

;; Number Integer Integer MouseEvent -> Number[0, WORLD-W]
;; produces the mouse x coordinate constrained to [0, WORLD-W]
(check-expect (handle-mouse 10 403 89 "button-up") (modulo 403 (add1 WORLD-W)))
(check-expect (handle-mouse 810 623 75 "drag") (modulo 623 (add1 WORLD-W)))

(define (handle-mouse ws x y me) (modulo x (add1 WORLD-W)))