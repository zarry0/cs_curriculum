;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname sum-odds-tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; sum-odds-tr-starter.rkt

;
; PROBLEM:
;
; Consider the following function that consumes a list of numbers and produces the sum of 
; all the odd numbers in the list.
;
; Use an accumulator to design a tail-recursive version of sum-odds.
;

;; (listof Number) -> Number
;; produce sum of all odd numbers of lon
(check-expect (sum-odds empty) 0) 
(check-expect (sum-odds (list 1 2 5 6 11)) 17) 

(define (sum-odds1 lon)
  (cond [(empty? lon) 0]
        [else
         (if (odd? (first lon))
             (+ (first lon)
                (sum-odds (rest lon)))
             (sum-odds (rest lon)))]))

(define (sum-odds lon0)
  ;; sum is Natural; the current sum
  (local [(define (sum-odds lon sum)
            (cond [(empty? lon) sum]
                  [else
                   (sum-odds (rest lon) (if (odd? (first lon)) (+ sum (first lon)) sum))]))]
    (sum-odds lon0 0)))
