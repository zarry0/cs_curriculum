;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname average-tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; average-starter.rkt

;
; PROBLEM:
;
; Design a function called average that consumes (listof Number) and produces the
; average of the numbers in the list.
;

;; (listof Number) -> Number
;; produces the avergae of the numbers in the list
(check-expect (average empty) 0)
(check-expect (average (list 1 2 3 4 5 6 7 8)) 4.5)

;(define (average lon) 0)  ;stub

(define (average lon0)
  ;; sum is Number;     the current sum of the numbers
  ;; count is Natural;  the current amout of numbers seen so far
  (local [(define (average lon sum count)
            (cond [(empty? lon) (/ sum (if (zero? count) 1 count))]
                  [else
                   (average (rest lon) (+ (first lon) sum) (add1 count))]))]
    (average lon0 0 0)))