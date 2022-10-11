;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname local) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; definitions only valid inside local
(local [(define a 1)   
        (define b 2)]  ;definitions
  (+ a b))             ;body

(define A "hello ")
(local [(define p "accio ")
        (define (fetch n) (string-append A p n))]
  (fetch "portkey"))

;; Lexical scoping
(define a 1)
(define b 2)
(+ a
   (local [(define b 3)]
     (+ a b))
   b)   ;7

;; Evaluation rules:
;;  - renaming
;;  - lifting
;;  - replace with body
(define x 1)
(+ x
   (local [(define x 2)]
     (* x x))
   x)  ; 1 + (2*2) + 1 = 6

(+ 1
   (local [(define x 2)]
     (* x x))
   x)
(+ 1
   (local [(define x_0 2)]  ;renaming
     (* x_0 x_0))
   x)

(define x_0 2)
(+ 1
   (local []                ;lifting
     (* x_0 x_0))
   x)

(+ 1
   (* x_0 x_0)             ;replace with body
   x)

(+ 1
   (* 2 2)             
   x)

(+ 1
   4             
   x)

(+ 1
   4             
   1)

6