;; hw4.rkt
#lang racket

(provide (all-defined-out))

;; 1)
;; int int int -> (listof int)
;; produces a list of numbers from low to high separated by strd
;; ASSUME: strd (stride) is positive
(define (sequence low high strd)
  (if (> low high)
      null
      (cons low (sequence (+ low strd) high strd))))

;; 2)
;; (listof string) string -> (listof string)
;; produces a list of strings each appended to the given suffix (suff)
(define (string-append-map xs suff)
  (map (lambda (str) (string-append str suff)) xs))

;; 3)
;; (listof x) int -> x 
;; produces the ith element of the list (0-based indexing)
;; where i is n % list_length
;; ASSUME: n will be possitive and the list won't be empty
(define (list-nth-mod xs n)
  (cond [(< n 0)    (error "list-nth-mod: negative number")]
        [(null? xs) (error "list-nth-mod: empty list")]
        [else (car (list-tail xs (remainder n (length xs))))]))

;; 4)
;; (streamof x) int -> (listof x)
;; produces a list with the first n values of the stream
(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (let ([next (s)])
        (cons (car next) (stream-for-n-steps (cdr next) (- n 1))))))

;; 5)
;; (streamof int)
;; a stream of natural numbers, where numbers divisible by 5 are negated
(define funny-number-stream
  (letrec ([f (lambda (x)
                (cons (if (= (remainder x 5) 0) (* x -1) x)
                      (lambda () (f(+ x 1)))))])
    (lambda () (f 1))))

;; 6)
;; (streamof string)
;; a stream os strings that alternates between "dan.jpg" and "dog.jpg"
(define dan-then-dog
  (letrec ([f (lambda(x) (cons (if x "dan.jpg" "dog.jpg")
                               (lambda () (f (not x)))))])
    (lambda () (f #t))))

;; 7)
;; (streamof x) -> (streamof '(0 . x))
;; produces a stream where its ith element is '(0 . v)
;; and v is the ith element of the stream s
(define (stream-add-zero s)
  (lambda ()
    (let ([next (s)])
      (cons (cons 0 (car next)) (stream-add-zero (cdr next))))))

;; 8)
;; (listof x) (listof y) -> (streamof '(xs_i . ys_i))
;; produces a stream of pairs where each element of the pair
;; is the ith element of xs and the ith element of ys
;; and the stream cycles forever through the lists
;; ASSUME: both lists are non-empty
(define (cycle-lists xs ys)
  (letrec (;; int -> (streamof '(xs_i . ys_i))
           ;; produces the cycle stream
           [f (lambda (n) (cons (cons (list-nth-mod xs n)
                                      (list-nth-mod ys n))
                                (lambda () (f (+ n 1)))))])
    (lambda () (f 0))))

;; 9)
;; x (vectorof y) -> y | #f
;; produces the first pair in the vector whose car is equal to v
;;          #f otherwise
(define (vector-assoc v vec)
  ;; ASSUME: vector wont be empty
  (define (loop i)
    (let ([vec_i (vector-ref vec i)])
      (cond [(and (pair? vec_i) (equal? v (car vec_i))) vec_i]
            [(< (+ i 1) (vector-length vec)) (loop (+ i 1))]
            [else #f])))
  (if (= 0 (vector-length vec)) #f (loop 0)))

;; 10)
;; (listof x) int -> (y -> x | #f)
;; produces a function that behaves as (assoc v vs) would
;; but uses an n-sized cache to improve the speed
;; ASSUME: n is possitive
;; NOTES about or & and:
;; (or a b)  produces a if a = #t, b otherwise
;; (and a b) produces a if a = #f, b otherwise
(define (cached-assoc xs n)
  (define cache (make-vector n #f))
  (define i 0)
  (lambda (v)
    (or (vector-assoc v cache)
        (let ([ans (assoc v xs)])
          (and ans (begin (vector-set! cache i ans)
                          (set! i (remainder (+ i 1) n))
                          ans))))))

;; 11) Challenge Problem
;; macro use: (while-less e1 do e2)
;; where e1 and e2 are expresions that produce numbers
;; evaluates e2 while e1 > e2
(define-syntax while-less
  (syntax-rules (do)
    [(while-less e1 do e2)
     (letrec ([e1_ans e1]
              [loop (lambda ()
                      (if (<= e1_ans e2)
                          #t
                          (loop)))])
       (loop))]))

