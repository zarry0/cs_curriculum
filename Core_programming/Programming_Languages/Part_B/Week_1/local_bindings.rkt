#lang racket


;; (listof int) -> int
;; produces the max number in the list
;; ASSUME: the list wont be empty
(define (max-of-list xs)
  (cond [(null? xs) (error "max-of-list given empty list")]
        [(null?  (cdr xs)) (car xs)]
        [#t (let ([max-rest (max-of-list (cdr xs))])
              (if (> (car xs) max-rest)
                  (car xs)
                  max-rest))]))



;; int -> int
;; produces 2*x
;; using let
(define (silly-double x)
  (let ([x (+ x 3)]    ; x refers to the function parameter
        [y (+ x 2)])   ; x refers to the function parameter also
    (+ x y -5)))       ; x & y refers to the bindings inside the let
                       ; = (+ (+ x 3) (+ x 2) -5) = (+ x x 5 -5)



;; using let*
(define (silly-double2 x)
  (let* ([x (+ x 3)]   ; x refers to the function paramenter
         [y (+ x 2)])  ; x refers to the previous x inside let* (x1 = x0 + 3)
    (+ x y -8)))       ; = (+ (+ x 3) (+ (+ x 3) 2) -8) = (+ x x 8 -8)


;; int -> int
;; produces x % 2
;; using letrec
(define (mod2_1 x)
  (letrec ([even? (lambda (x) (if (zero? x) #t (odd?  (- x 1))))]
           [odd?  (lambda (x) (if (zero? x) #f (even? (- x 1))))])
    (if (even? x) 0 1)))


;; using local define
(define (mod2_2 x)
  (define even? (lambda (x) (if (zero? x) #t (odd?  (- x 1)))))
  (define odd?  (lambda (x) (if (zero? x) #f (even? (- x 1)))))
  (if (even? x) 0 1))