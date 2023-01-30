#lang racket

;; int -> int
;; produces the factorial of n
(define (fact n) (if (= n 0) 1 (* n (fact (- n 1)))))

; Errors
;(define (fact n) (if (= n 0) (1) (* n (fact (- n 1))))) ; 2
;(define (fact n) (if = n 0 1 (* n (fact (- n 1)))))     ; 3
;(define fact (n) (if (= n 0) 1 (* n (fact (- n 1)))))   ; 4
;(define (fact n) (if (= n 0) 1 (* n fact (- n 1))))     ; 5
;(define (fact n) (if (= n 0) 1 (* n ((fact) (- n 1))))) ; 6
;(define (fact n) (if (= n 0) 1 (n * (fact (- n 1)))))   ; 7