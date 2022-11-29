;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname sum-n-tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; sum-n-tr-starter.rkt

;
; PROBLEM:
;
; Consider the following function that consumes Natural number n and produces the sum 
; of all the naturals in [0, n].
;    
; Use an accumulator to design a tail-recursive version of sum-n.
;

;; Natural -> Natural
;; produce sum of Natural[0, n]

(check-expect (sum-n 0) 0)
(check-expect (sum-n 1) 1)
(check-expect (sum-n 3) (+ 3 2 1 0))

;(define (sum-n n) 0) ;0
#;
(define (sum-n n)
  (cond [(zero? n) 0]
        [else
         (+ n
            (sum-n (sub1 n)))]))

(define (sum-n n0)
  ;; acc is Natural; the current number in the progression [0, n]
  ;; sum is Natural; the current sum
  (local [(define (sum-n acc sum)
            (cond [(<= n0 acc) (+ acc sum)]
                  [else
                   (sum-n (add1 acc) (+ acc sum))]))]
    (sum-n 0 0)))

;; alt-solution
(check-expect (sum-n2 0) 0)
(check-expect (sum-n2 1) 1)
(check-expect (sum-n2 3) (+ 3 2 1 0))

(define (sum-n2 n0)
  (local [(define (sum-n n sum)
            (cond [(zero? n) sum]
                  [else (sum-n (sub1 n) (+ n sum))]))]
    (sum-n n0 0)))