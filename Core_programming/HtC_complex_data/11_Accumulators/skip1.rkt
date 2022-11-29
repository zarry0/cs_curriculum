;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname skip1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; skip1-starter.rkt

;
; PROBLEM:
;
; Design a function that consumes a list of elements and produces the list
; consisting of only the 1st, 3rd, 5th and so on elements of its input. 
;
;    (skip1 (list "a" "b" "c" "d")) should produce (list "a" "c")
;

;; Course solution:

;; (listof X) -> (listof X)
;; produce list consisting of only the 1st, 3rd, 5th and so on elements of its input
(check-expect (skip1 empty) empty)
(check-expect (skip1 (list "a" "b" "c" "d")) (list "a" "c"))
(check-expect (skip1 (list 1 2 3 4 5 6)) (list 1 3 5))

;(define (skip1 lox) empty)  ;stub

; Template for list
#;
(define (skip lox)
  (cond [(empty? lox) empty]
        [else
         (if (odd? POSITION-OF-FIRST-LOX)
             (cons (first lox) (skip1 (rest lox)))
             (skip1 (rest lox)))]))

;Template modified to include an accumulator to preserve context
#; 
(define (skip1 lox0)
  ;; acc: Natural; 1-based position of (first lox) in lox0
  ;; (skip1 (list "a" "b" "c") 1)
  ;; (skip1 (list     "b" "c") 2)
  ;; (skip1 (list         "c") 3)
  (local [(define (skip lox acc)
            (cond [(empty? lox) (... acc)]
                  [else
                   (... acc
                        (first lox)
                        (skip1 (rest lox) (... acc)))]))]
    (skip1 lox0 ...)))

(define (skip1 lox0)
  ;; acc: Natural; 1-based position of (first lox) in lox0
  ;; (skip1 (list "a" "b" "c") 1)
  ;; (skip1 (list     "b" "c") 2)
  ;; (skip1 (list         "c") 3)
  (local [(define (skip1 lox acc)
            (cond [(empty? lox) empty]
                  [else
                   (if (odd? acc)
                       (cons (first lox) (skip1 (rest lox) (add1 acc)))
                       (skip1 (rest lox) (add1 acc)))]))]
    (skip1 lox0 1))) 



;; My implementation:

;; (listof X) -> (listof X)
;; produces a list with only the odd elements of the input list
(check-expect (skip1. (list "a" "b" "c" "d")) (list "a" "c"))

;(define (skip1. lox) empty)  ;stub

(define (skip1. lox)
  (local [;; (listof X) Natural -> (listof X)
          (define (fn lox n)
            (cond [(>= n (length lox)) empty]
                  [else
                   (if (odd? n)
                       (cons (list-ref lox (sub1 n)) (fn lox (add1 n)))
                       (fn lox (add1 n)))]))]
    (fn lox 1)))