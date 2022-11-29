;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname replicate-elm) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; replicate-elm-starter.rkt

;
; PROBLEM:
;
; Design a function that consumes a list of elements and a natural n, and produces 
; a list where each element is replicated n times. 
;
; (replicate-elm (list "a" "b" "c") 2) should produce (list "a" "a" "b" "b" "c" "c")
;


;; (listof X) Natural -> (listof X)
;; produces a list where each element of the original is repeated n times
(check-expect (replicate-elm (list 1 2 3 4 5) 1) (list 1 2 3 4 5))
(check-expect (replicate-elm (list "a" "b" "c") 2) (list "a" "a" "b" "b" "c" "c"))

;(define (replicate-elm lox n) empty)  ;stub

(define (replicate-elm lox0 n)
  ;; rsf is (listof X);  the result so far
  ;; (replicate-elm (list "a" "b" "c") 2)  ;outer call
  ;;
  ;; (replicate-elm (list "a" "b" "c") empty)                 ;inner call
  ;; (replicate-elm (list     "b" "c") (list "a" "a"))
  ;; (replicate-elm (list         "c") (list "a" "a" "b" "b"))
  ;; (replicate-elm (list            ) (list "a" "a" "b" "b" "c" "c"))
  (local [(define (replicate-elm lox rsf)
            (cond [(empty? lox) rsf]
                  [else
                   (replicate-elm (rest lox) (append rsf (build-list n (lambda (x) (identity (first lox))))))]))]
    
    (replicate-elm lox0 empty)))


; alt-solution
#;
(define (replicate-elm lox0 n)
  ;; acc is Natural[0, n]; the number of times an element has been repeated
  ;; rsf is (listof X);    the result so far
  ;; (replicate-elm (list "a" "b" "c") 2)  ;outer call
  ;;
  ;; (replicate-elm (list "a" "b" "c") empty 0)                 ;inner call
  ;; (replicate-elm (list "a" "b" "c") (list "a") 1)
  ;; (replicate-elm (list "a" "b" "c") (list "a" "a") 2)  
  ;; (replicate-elm (list     "b" "c") (list "a" "a") 0)
  ;; (replicate-elm (list     "b" "c") (list "a" "a" "b") 1)
  ;; (replicate-elm (list     "b" "c") (list "a" "a" "b" "b") 2)
  ;; (replicate-elm (list         "c") (list "a" "a" "b" "b") 0)
  ;; (replicate-elm (list         "c") (list "a" "a" "b" "b" "c") 1)
  ;; (replicate-elm (list         "c") (list "a" "a" "b" "b" "c" "c") 2)
  ;; (replicate-elm (list            ) (list "a" "a" "b" "b" "c" "c") 0)
  (local [(define (replicate-elm lox rsf acc)
            (cond [(empty? lox) rsf]
                  [else
                   (replicate-elm (if (= acc (sub1 n)) (rest lox) lox) (append rsf (list (first lox))) (modulo (add1 acc) n))]))]
    
    (replicate-elm lox0 empty 0)))


; non tail-resursive solution
#;
(define (replicate-elm lox0 n)
  ;; acc is Natural[0, n]; the number of times an element has been repeated
  ;; (replicate-elm (list "a" "b" "c") 2)  ;outer call
  ;;
  ;; (replicate-elm (list "a" "b" "c") 0)                 ;inner call
  ;; (replicate-elm (list "a" "b" "c") 1)
  ;; (replicate-elm (list "a" "b" "c") 2)  
  ;; (replicate-elm (list     "b" "c") 0)
  ;; (replicate-elm (list     "b" "c") 1)
  ;; (replicate-elm (list     "b" "c") 2)
  ;; (replicate-elm (list         "c") 0)
  ;; (replicate-elm (list         "c") 1)
  ;; (replicate-elm (list         "c") 2)
  ;; (replicate-elm (list            ) )
  (local [(define (replicate-elm lox acc)
            (cond [(empty? lox) empty]
                  [else
                   (if (not (= acc n))
                        (cons (first lox) (replicate-elm lox (modulo (add1 acc) (add1 n))))
                        (replicate-elm (rest lox) (modulo (add1 acc) (add1 n))))]))]
    
    (replicate-elm lox0 0)))
