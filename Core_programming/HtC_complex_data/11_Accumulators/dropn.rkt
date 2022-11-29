;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname dropn) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; dropn-starter.rkt

;
; PROBLEM:
;
; Design a function that consumes a list of elements lox and a natural number
; n and produces the list formed by dropping every nth element from lox.
;
; (dropn (list 1 2 3 4 5 6 7) 2) should produce (list 1 2 4 5 7)
;

;; (listof X) Natural -> (listof X)
;; produces a list formed by dropìng every nth element from lox
(check-expect (dropn empty 0) empty)
(check-expect (dropn (list 1 2 3 4 5 6 7 8 9 10) 2) (list 1 2 4 5 7 8 10))
(check-expect (dropn (list 1 2 3 4 5 6 7 8 9 10) 1) (list 1 3 5 7 9))

;(define (dropn lox n) empty)  ;stub

(define (dropn lox0 n)
  ;; acc is Natural[0, 2]; the numberof elements since the last drop
  ;; (dropn (list 1 2 3 4 5 6 7 8 9 10) 2)  ; outer call
  ;;
  ;; (dropn (list 1 2 3 4 5 6 7 8 9 10) 0)  ; inner call
  ;; (dropn (list   2 3 4 5 6 7 8 9 10) 1)
  ;; (dropn (list     3 4 5 6 7 8 9 10) 2)  ; drop
  ;; (dropn (list       4 5 6 7 8 9 10) 0)
  ;; (dropn (list         5 6 7 8 9 10) 1)
  ;; (dropn (list           6 7 8 9 10) 2)  ;drop
  ;; (dropn (list             7 8 9 10) 0)
  ;; (dropn (list               8 9 10) 1)
  ;; (dropn (list                 9 10) 2)  ;drop
  ;; (dropn (list                   10) 0)
  ;; (dropn (list                     ) 1)  ;base case
  (local [(define (dropn lox acc)
            (cond [(empty? lox) empty]
                  [else
                   (if  (>= acc n)
                        (dropn (rest lox) (modulo (add1 acc) (add1 n)))
                        (cons (first lox)
                              (dropn (rest lox) (modulo (add1 acc) (add1 n)))))]))]
    (dropn lox0 0)))

;; Tail recursive version

(check-expect (dropn-tr empty 0) empty)
(check-expect (dropn-tr (list 1 2 3 4 5 6 7 8 9 10) 2) (list 1 2 4 5 7 8 10))
(check-expect (dropn-tr (list 1 2 3 4 5 6 7 8 9 10) 1) (list 1 3 5 7 9))


(define (dropn-tr lox0 n)
  ;; acc is Natural[0, 2]; the numberof elements since the last drop
  ;; rsf is (listof X);    the result so far
  ;; (dropn (list 1 2 3 4 5 6 7 8 9 10) 2)  ; outer call
  ;;
  ;; (dropn (list 1 2 3 4 5 6 7 8 9 10) 0 empty)  ; inner call
  ;; (dropn (list   2 3 4 5 6 7 8 9 10) 1 (list 1))
  ;; (dropn (list     3 4 5 6 7 8 9 10) 2 (list 1 2))             ; don't include first
  ;; (dropn (list       4 5 6 7 8 9 10) 0 (list 1 2))
  ;; (dropn (list         5 6 7 8 9 10) 1 (list 1 2 4))
  ;; (dropn (list           6 7 8 9 10) 2 (list 1 2 4 5))         ; don't include first
  ;; (dropn (list             7 8 9 10) 0 (list 1 2 4 5))
  ;; (dropn (list               8 9 10) 1 (list 1 2 4 5 7))
  ;; (dropn (list                 9 10) 2 (list 1 2 4 5 7 8))     ; don't include first
  ;; (dropn (list                   10) 0 (list 1 2 4 5 7 8))
  ;; (dropn (list                     )   (list 1 2 4 5 7 8 10))
  (local [(define (dropn lox acc rsf)
            (cond [(empty? lox) rsf]
                  [else
                   (dropn (rest lox) (modulo (add1 acc) (add1 n)) (if (>= acc n)
                                                                      rsf
                                                                      (append rsf (list (first lox)))))]))]
    (dropn lox0 0 empty)))