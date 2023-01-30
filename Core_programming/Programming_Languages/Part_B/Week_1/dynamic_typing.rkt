#lang racket

;; X is one of:
;;  - int
;;  - (listof X)
(define x1 3)
(define x2 (listof x1))
(define x3 (listof x2))

;; listof X
(define xs (list 4 5 6))                                                             ; 15
(define ys (list (list 4 5) 6 7 (list 8) 9 2 3 (list 0 1)))                          ; 45
(define zs (list (list 4 5) 6 7 (list 8 (list 10 2 (list 2 4 8))) 9 2 3 (list 0 1))) ; 71

;; (listof X) -> int
;; produces the sum of all the numbers in the list, no matter the level of nesting
(define (sum1 xs)
  (if (null? xs)
      0
      (if (list? (car xs))
          (+ (sum1 (car xs)) (sum1 (cdr xs)))
          (+ (car xs) (sum1 (cdr xs))))))

(define (sum2 xs)
  (cond [(null? xs) 0]
        [(list? (car xs)) (+ (sum2 (car xs)) (sum2 (cdr xs)))]
        [else (+ (car xs) (sum2 (cdr xs)))]))

;; ignores non integer elements insted of throwing an error
(define (sum3 xs)
  (if (null? xs)
      0
      (if (number? (car xs))
          (+ (car xs) (sum3 (cdr xs)))
          (if (list? (car xs))
              (+ (sum3 (car xs)) (sum3 (cdr xs)))
              (sum3 (cdr xs))))))

(define (sum4 xs)
  (cond [(null? xs) 0]
        [(number? (car xs)) (+ (car xs) (sum4 (cdr xs)))]
        [(list? (car xs)) (+ (sum4 (car xs)) (sum4 (cdr xs)))]
        [#t (sum4 (cdr xs))]))

