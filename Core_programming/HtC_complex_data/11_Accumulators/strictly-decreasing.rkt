;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname strictly-decreasing) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; strictly-decreasing-starter.rkt

;
; PROBLEM:
;
; Design a function that consumes a list of numbers and produces true if the 
; numbers in lon are strictly decreasing. You may assume that the list has at 
; least two elements.
;

;; (listof Number) -> Boolean
;; produces true if the numbers in lon are strictly decreasing
;; ASSUME: the list has at leat 2 items
(check-expect (strictly-dec? (list 1 2)) false)
(check-expect (strictly-dec? (list 1 1)) false)
(check-expect (strictly-dec? (list 3 2 1 0)) true)

;(define (strictly-dec? lon) false)  ;stub

(define (strictly-dec? lon0)
  ;; prev is Natural; the previous element in the list
  (local [(define (strictly-dec? lon prev)
            (cond [(empty? lon) true]
                  [else
                   (and (< (first lon) prev)
                       (strictly-dec? (rest lon) (first lon)))]))]
    
    (strictly-dec? lon0 (* (first lon0) 1000))))

; tail-recursive version

(check-expect (strictly-dec?-tr (list 1 2)) false)
(check-expect (strictly-dec?-tr (list 1 1)) false)
(check-expect (strictly-dec?-tr (list 3 2 1 0)) true)

(define (strictly-dec?-tr lon0)
  ;; prev is Natural; the previous element in the list
  ;; rsf is Boolean; the result so far
  (local [(define (strictly-dec? lon prev rsf)
            (cond [(empty? lon) rsf]
                  [else
                   (strictly-dec? (rest lon) (first lon) (and (< (first lon) prev) rsf))]))]
    (strictly-dec? lon0 (* (first lon0) 1000) true)))