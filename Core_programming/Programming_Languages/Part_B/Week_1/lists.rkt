#lang racket

; list processing: null, cons, null?, car, cdr

;; int list -> int
;; produces the sum of all the elements in the list
(define sum1
  (lambda (xs)
    (if (null? xs)
        0
        (+ (car xs) (sum1 (cdr xs))))))

(define (sum2 xs)
  (if (null? xs)
      0
      (+ (first xs) (sum2 (rest xs)))))


;; (listof x) (listof x) -> (listof x)
;; appends the second list onto the first one
(define (my-append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (my-append (cdr xs) ys))))

;; ('a -> 'b) ('a list) -> ('b list)
;; given (list x1, x2, ..., xn) and f() produces (list f(x1), f(x2), ..., f(xn))
(define (my-map f xs)
  (if (null? xs)
      null
      (cons (f (car xs))
            (my-map f (cdr xs)))))