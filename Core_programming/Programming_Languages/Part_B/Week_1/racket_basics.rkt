#lang racket

;; used to export the definitions in the file and be able to use them
;; in a separate file
(provide (all-defined-out))

;; basic definitions
(define s "hello")

(define x 3) ; val x = 3
(define y (+ x 2))  ; + is a function

;; int -> int
;; produces the cube of the given number
(define cube1
  (lambda (x)
    (* x (* x x)))) ; val cube = fn x => x * x * x

(define cube2
  (lambda (x) (* x x x)))

(define (cube3 x)
  (* x x x))

;; int int -> int
;; produces x to the y power
;; ASSUME: y >= 0
(define (pow1 x y)
  (if (= y 0)
      1
      (* x (pow1 x (- y 1)))))

(define pow2
  (lambda (x)
    (lambda (y)
      (pow1 x y)))) ; currying

(define pow3
  (lambda (x)
    (lambda (y)
      (if (= y 0)
          1
          (* x ((pow3 x) (- y 1))))))) ; currying
;; to call a curried function call each param in a paren ((pow3 x) y)

(define three-to-the (pow2 3)) ; partial application


(define ((pow4 x)y)  ; syntactic sugar for defining curried functions
  (if (= y 0)
      1
      (* x ((pow4 x) (- y 1)))))