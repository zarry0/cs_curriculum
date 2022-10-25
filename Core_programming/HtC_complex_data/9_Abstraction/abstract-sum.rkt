;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname abstract-sum) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; abstract-sum-starter.rkt

;
; PROBLEM A:
;
; Design an abstract function (including signature, purpose, and tests) to 
; simplify the two sum-of functions. 
;

;; (listof Number) -> Number
;; produce the sum of the squares of the numbers in lon
(check-expect (sum-of-squares empty) 0)
(check-expect (sum-of-squares (list 2 4)) (+ 4 16))
#;
(define (sum-of-squares lon)
  (cond [(empty? lon) 0]
        [else
         (+ (sqr (first lon))
            (sum-of-squares (rest lon)))]))

;; (listof String) -> Number
;; produce the sum of the lengths of the strings in los
(check-expect (sum-of-lengths empty) 0)
(check-expect (sum-of-lengths (list "a" "bc")) 3)
#;
(define (sum-of-lengths los)
  (cond [(empty? los) 0]
        [else
         (+ (string-length (first los))
            (sum-of-lengths (rest los)))]))


;; (X -> Number) (listof X) -> Number
;; given fn and (list x-1 ... x-n), produces (+ (fn x-1) ... (fn x-n))
(check-expect (sum-of-x sqr (list 2 4)) (+ 4 16))
(check-expect (sum-of-x string-length (list "a" "bc")) 3)

(define (sum-of-x fn lox)
  (cond [(empty? lox) 0]
        [else
         (+ (fn (first lox))
            (sum-of-x fn (rest lox)))]))


;
; PROBLEM B:
;
; Now re-define the original functions to use abstract-sum. 
;
; Remember, the signature and tests should not change from the original 
; functions.
;

(define (sum-of-squares lon) (sum-of-x sqr lon))


(define (sum-of-lengths los) (sum-of-x string-length los))
