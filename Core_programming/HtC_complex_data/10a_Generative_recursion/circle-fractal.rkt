;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname circle-fractal) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; circle-fractal-starter.rkt

;
; PROBLEM :
;
; Design a function that will create the following fractal:
;        
;
; Each circle is surrounded by circles that are two-fifths smaller. 
;
; You can build these images using the convenient beside and above functions
; if you make your actual recursive function be one that just produces the
; top leaf shape. You can then rotate that to produce the other three shapes.
;
; You don't have to use this structure if you are prepared to use more
; complex place-image functions and do some arithmetic. But the approach
; where you use the helper is simpler.
;
; Include a termination argument for your design.
;

; =================
;; Constants:

(define STEP (/ 2 5))
(define TRIVIAL-SIZE 5)

;; Number -> Image
;; produces a circle fractal od the given radius
(check-expect (fractal TRIVIAL-SIZE) (circle TRIVIAL-SIZE "solid" "blue"))
(check-expect (fractal (* 2.5 TRIVIAL-SIZE)) (above (circle TRIVIAL-SIZE "solid" "blue")
                                                    (beside (circle TRIVIAL-SIZE "solid" "blue")
                                                            (circle (* 2.5 TRIVIAL-SIZE) "solid" "blue")
                                                            (circle TRIVIAL-SIZE "solid" "blue"))
                                                    (circle TRIVIAL-SIZE "solid" "blue")))
(check-expect (fractal (* 6.25 TRIVIAL-SIZE)) (local [(define max (circle (* 6.25 TRIVIAL-SIZE) "solid" "blue"))
                                                      (define sub (circle (* 2.5 TRIVIAL-SIZE) "solid" "blue"))
                                                      (define min (circle TRIVIAL-SIZE "solid" "blue"))
                                                      (define base (above min (beside min sub min)))]
                                                (above base
                                                       (beside (rotate 90 base)
                                                               max
                                                               (rotate 270 base))
                                                       (rotate 180 base))))

;(define (fractal s) empty-image)  ;stub

(define (fractal s)         
  (cond [(<= s TRIVIAL-SIZE) (circle s "solid" "blue")]
        [else (local [(define (f1 s)
                        (cond [(<= s TRIVIAL-SIZE) (circle s "solid" "blue")]
                              [else (local [(define sub (f1 (* s STEP)))
                                            (define main (circle s "solid" "blue"))]
                                      (above sub (beside (rotate 90 sub) main (rotate 270 sub))))]))]
                (above (f1 s) (rotate 180 (f1 (* s STEP)))))]))


;; Termination argument

;; Base case: (<= s TRIVIAL-SIZE)
;; Reduction step (next problem): (* s STEP)     
;; Argument that repeated application of reduction step will eventually 
;; reach the base case:

;; As long as s > 0, multiplying s by 2/5 will keep on reducing s until it reaches TRIVIAL-SIZE