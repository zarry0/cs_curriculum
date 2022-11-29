;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname sum-tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; sum-tr-starter.rkt

;
; PROBLEM:
;
; (A) Consider the following function that consumes a list of numbers and produces
;     the sum of all the numbers in the list. Use the stepper to analyze the behavior 
;     of this function as the list gets larger and larger. 
;    
; (B) Use an accumulator to design a tail-recursive version of sum.
;

; ;; (listof Number) -> Number
; ;; produce sum of all elements of lon
; (check-expect (sum empty) 0)
; (check-expect (sum (list 2 4 5)) 11)
;
; (define (sum lon)
;   (cond [(empty? lon) 0]
;         [else
;          (+ (first lon)
;             (sum (rest lon)))]))

;; Course solution

;; (listof Number) -> Number
;; produce sum of all elements of lon
(check-expect (sum empty) 0)
(check-expect (sum (list 2 4 5)) 11)

(define (sum lon0)
  ;; acc: Natural; the sum of the elements seen so far
  ;; (sum (list 2 4 5))  ; outer call
  ;;
  ;; (sum (list 2 4 5)  0)  ; inner call
  ;; (sum (list   4 5)  2)
  ;; (sum (list     5)  6)
  ;; (sum (list      ) 11)  ; base case
  (local [(define (sum lon acc)
            (cond [(empty? lon) acc]
                  [else
                   ;(... (... acc)
                   ;     (first lon)
                        (sum (rest lon) (+ (first lon) acc))]))]
    (sum lon0 0)))

;; My implemetation of tail recursive sum

;; (listof Number) -> Number
;; produce sum of all elements of lon
(check-expect (sum. empty) 0)
(check-expect (sum. (list 2 4 5)) 11)

(define (sum. lon0)
  (local [(define (sum. lon acc)
            (cond [(empty? lon) acc]
                  [else
                   (sum. (rest lon) (+ (first lon) acc))]))]
    (sum. lon0 0)))