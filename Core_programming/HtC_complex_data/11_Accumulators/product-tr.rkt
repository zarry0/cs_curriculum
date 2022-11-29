;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname product-tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; product-tr-starter.rkt

;
; PROBLEM:
;
; (A) Consider the following function that consumes a list of numbers and produces
;     the product of all the numbers in the list. Use the stepper to analyze the behavior 
;     of this function as the list gets larger and larger. 
;    
; (B) Use an accumulator to design a tail-recursive version of product.
;

;; (listof Number) -> Number
;; produce product of all elements of lon
(check-expect (product empty) 1)
(check-expect (product (list 2 3 4)) 24)
#;
(define (product lon)
  (cond [(empty? lon) 1]
        [else
         (* (first lon)
            (product (rest lon)))]))

(define (product lon0)
  ;; rsf is Number; the result so far
  (local [(define (product lon rsf)
            (cond [(empty? lon) rsf]
                  [else
                   (product (rest lon) (* (first lon) rsf))]))]
    (product lon0 1)))