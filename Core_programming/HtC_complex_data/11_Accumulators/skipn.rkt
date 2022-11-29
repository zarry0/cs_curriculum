;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname skipn) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; skipn-starter.rkt

;
; PROBLEM:
;
; Design a function that consumes a list of elements lox and a natural number
; n and produces the list formed by including the first element of lox, then 
; skipping the next n elements, including an element, skipping the next n 
; and so on.
;
;   (skipn (list "a" "b" "c" "d" "e" "f") 2) should produce (list "a" "d")
;

;; My solution

;; (listof X) Natural -> (listof X)
;; produces the list formed by including the first element of lox, then skipping the next n elements
(check-expect (skipn empty 2) empty)
(check-expect (skipn (list "a" "b" "c" "d" "e" "f") 2) (list "a" "d"))
(check-expect (skipn (list 1 2 3 4 5 6 7 8 9 10) 1) (list 1 3 5 7 9))
(check-expect (skipn (list 1 2 3 4 5 6 7 8 9 10) 3) (list 1 5 9))

;(define (skipn lox n) empty)  ;stub

(define (skipn lox0 n)
  ;; acc: Natural; 1-based index for (first lox) in lox0
  (local [(define (skipn lox acc)
            (cond [(empty? lox) empty]
                  [else
                   (if (= acc (add1 n))
                       (cons (first lox) (skipn (rest lox) 1))
                       (skipn (rest lox) (add1 acc)))]))]
    (cond [(empty? lox0) empty]
          [else (cons (first lox0) (skipn (rest lox0) 1))])))


;; Course solution

;; Count down version of the accumulator
;; (listof X) Natural -> (listof X)
;; produce list containing 1st element of lox, then skip next n, then include...
(check-expect (skipn. empty 2) empty)
(check-expect (skipn. (list "a" "b" "c" "d" "e" "f") 0) (list "a" "b" "c" "d" "e" "f"))
(check-expect (skipn. (list "a" "b" "c" "d" "e" "f") 1) (list "a" "c" "e"))
(check-expect (skipn. (list "a" "b" "c" "d" "e" "f") 2) (list "a" "d"))

;(define (skipn. lox n) empty)  ;stub

(define (skipn. lox0 n)
  ;; acc: Natural; the number of elements to skip before including the next one
  ;; (skipn. (list "a" "b" "c" "d") 2)  ;outer call
  ;;                                    ;inner call
  ;; (skipn. (list "a" "b" "c" "d")  0) ; include
  ;; (skipn. (list     "b" "c" "d")  2) ; don't include
  ;; (skipn. (list         "c" "d")  1) ; don't include
  ;; (skipn. (list             "d")  0) ; include
  ;; (skipn. (list                )  2) ; (base case)
  (local [(define (skipn. lox acc)
            (cond [(empty? lox) empty]
                  [else
                   (if (zero? acc)
                       (cons (first lox)
                             (skipn. (rest lox) n))
                       (skipn. (rest lox) (sub1 acc)))]))]
    (skipn. lox0 0)))

;; Count up version of the accumulator

(check-expect (skipn-up empty 2) empty)
(check-expect (skipn-up (list "a" "b" "c" "d" "e" "f") 0) (list "a" "b" "c" "d" "e" "f"))
(check-expect (skipn-up (list "a" "b" "c" "d" "e" "f") 1) (list "a" "c" "e"))
(check-expect (skipn-up (list "a" "b" "c" "d" "e" "f") 2) (list "a" "d"))

(define (skipn-up lox0 n)
  ;; acc: Natural; the number of elements that have just been skipped
  ;; (skipn-up (list "a" "b" "c" "d") 2)  ;outer call
  ;;                                        ;inner call
  ;; (skipn (list "a" "b" "c" "d") 0)       ; include
  ;; (skipn (list     "b" "c" "d") 1)       ; don't include
  ;; (skipn (list         "c" "d") 2)       ; don't include
  ;; (skipn (list             "d") 0)       ; include
  ;; (skipn (list                ) 1)       ; (base case)
  (local [(define (skipn lox acc)
            (cond [(empty? lox) empty]
                  [(zero? acc) (cons (first lox)
                                     (skipn (rest lox) (if (= acc n) 0 (add1 acc))))]
                  [else
                   (skipn (rest lox) (if (= acc n) 0 (add1 acc)))]))]
    (skipn lox0 0)))

;; Count up version with modulo

(check-expect (skipm empty 2) empty)
(check-expect (skipm (list "a" "b" "c" "d" "e" "f") 0) (list "a" "b" "c" "d" "e" "f"))
(check-expect (skipm (list "a" "b" "c" "d" "e" "f") 1) (list "a" "c" "e"))
(check-expect (skipm (list "a" "b" "c" "d" "e" "f") 2) (list "a" "d"))

;(define (skipm lox n) empty)  ;stub

(define (skipm lox0 n)
    ;; acc: Natural; the number of elements that have just been skipped
  ;; (skipm (list "a" "b" "c" "d") 2)  ;outer call
  ;;                                        ;inner call
  ;; (skipn (list "a" "b" "c" "d") 0)       ; include
  ;; (skipn (list     "b" "c" "d") 1)       ; don't include
  ;; (skipn (list         "c" "d") 2)       ; don't include
  ;; (skipn (list             "d") 0)       ; include
  ;; (skipn (list                ) 1)       ; (base case)
  (local [(define (skipn lox acc)
            (cond [(empty? lox) empty]
                  [else
                   (if (zero? acc)
                       (cons (first lox)
                             (skipn (rest lox) (modulo (add1 acc) (add1 n))))
                       (skipn (rest lox) (modulo (add1 acc) (add1 n))))]))]
    (skipn lox0 0)))

