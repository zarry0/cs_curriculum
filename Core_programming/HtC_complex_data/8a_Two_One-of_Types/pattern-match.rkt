;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname pattern-match) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; pattern-match-starter.rkt

;
; Problem:
;
; It is often useful to be able to tell whether the first part of a sequence of 
; characters matches a given pattern. In this problem you will design a (somewhat 
; limited) way of doing this.
;
; Assume the following type comments and examples:
;

;; =================
;; Data Definitions:

;; 1String is String
;; interp. these are strings only 1 character long
(define 1SA "x")
(define 1SB "2")

;; Pattern is one of:
;;  - empty
;;  - (cons "A" Pattern)
;;  - (cons "N" Pattern)
;; interp.
;;   A pattern describing certain ListOf1String. 
;;  "A" means the corresponding letter must be alphabetic.
;;  "N" means it must be numeric.  For example:
;;      (list "A" "N" "A" "N" "A" "N")
;;   describes Canadian postal codes like:
;;      (list "V" "6" "T" "1" "Z" "4")
(define PATTERN1 (list "A" "N" "A" "N" "A" "N"))

;; ListOf1String is one of:
;;  - empty
;;  - (cons 1String ListOf1String)
;; interp. a list of strings each 1 long
(define LOS1 (list "V" "6" "T" "1" "Z" "4"))


;
; Now design a function that consumes Pattern and ListOf1String and produces true 
; if the pattern matches the ListOf1String. For example,
;
; (pattern-match? (list "A" "N" "A" "N" "A" "N")
;                (list "V" "6" "T" "1" "Z" "4"))
;
; should produce true. If the ListOf1String is longer than the pattern, but the 
; first part matches the whole pattern produce true. If the ListOf1String is 
; shorter than the Pattern you should produce false.       
;
; Treat this as the design of a function operating on 2 complex data. After your 
; signature and purpose, you should write out a cross product of type comments 
; table. You should reduce the number of cases in your cond to 4 using the table, 
; and you should also simplify the cond questions using the table.
;
; You should use the following helper functions in your solution:
;


;; ==========
;; Functions:

;; 1String -> Boolean
;; produce true if 1s is alphabetic/numeric
(check-expect (alphabetic? " ") false)
(check-expect (alphabetic? "1") false)
(check-expect (alphabetic? "a") true)
(check-expect (numeric? " ") false)
(check-expect (numeric? "1") true)
(check-expect (numeric? "a") false)

(define (alphabetic? 1s) (char-alphabetic? (string-ref 1s 0)))
(define (numeric?    1s) (char-numeric?    (string-ref 1s 0)))


;; Pattern ListOf1String -> Boolean
;; produces true if the pattern matches the ListOf1String
;; if the list is longer than the patter but it matches the first part, return true
;; if the pattern is shorter than the list, return false

;; Cross product (6 cases)

;;                                                              P
;;    +----------------------------------------------------------------------------------------------------------
;;    |                     |  empty  |           (cons "A" P)              |            (cons "N" P)
;; l  |---------------------+---------+-------------------------------------+------------------------------------
;; o  |        empty        |  true   |                false                |                false 
;; 1  |---------------------+---------+-------------------------------------+------------------------------------
;; s  | (cons 1String LO1S) |  true   |  (and (alphabetic? (first lo1s))    | (and (numeric? (first lo1s))
;;    |                     |         |       (pattern-match? (rest p)      |      (pattern-match? (rest p) 
;;    |                     |         |                       (rest lo1s))) |                      (rest lo1s)))
;;    +----------------------------------------------------------------------------------------------------------

;; SIMPLIFICATION: if P is empty return true, if lo1s is empty return false (4 cases)

;;                                                              P
;;    +----------------------------------------------------------------------------------------------------------
;;    |                     |  empty  |           (cons "A" P)              |            (cons "N" P)
;; l  |---------------------+---------+-------------------------------------|------------------------------------
;; o  |        empty        |         |                                   false                
;; 1  |---------------------|  true   |-------------------------------------|------------------------------------
;; s  | (cons 1String LO1S) |         |  (and (alphabetic? (first lo1s))    | (and (numeric? (first lo1s))
;;    |                     |         |       (pattern-match? (rest p)      |      (pattern-match? (rest p) 
;;    |                     |         |                       (rest lo1s))) |                      (rest lo1s)))
;;    +----------------------------------------------------------------------------------------------------------

(check-expect (pattern-match? empty empty) true)
(check-expect (pattern-match? empty (list "a")) true)
(check-expect (pattern-match? (list "A") empty) false)
(check-expect (pattern-match? (list "N") empty) false)
(check-expect (pattern-match? (list "A") (list "b")) true)
(check-expect (pattern-match? (list "N") (list "1")) true)
(check-expect (pattern-match? (list "A") (list "1")) false)
(check-expect (pattern-match? (list "N") (list "a")) false)
(check-expect (pattern-match? (list "A" "A" "N") (list "b" "x" "5")) true)
(check-expect (pattern-match? (list "A" "A" "N") (list "b" "x" "a")) false)
(check-expect (pattern-match? (list "N" "A") (list "1" "x" "5")) true)
(check-expect (pattern-match? (list "N" "A") (list "a" "x" "5")) false)
(check-expect (pattern-match? (list "N" "A" "N") (list "1" "x")) false)
(check-expect (pattern-match? (list "N" "A" "N") (list "a" "x")) false)

;(define (pattern-match? p lo1s) false)  ;stub

(define (pattern-match? p lo1s)
  (cond [(empty? p) true]
        [(empty? lo1s) false]
        [(string=? "A" (first p))
         (and (alphabetic? (first lo1s))
              (pattern-match? (rest p) (rest lo1s)))]
        [(string=? "N" (first p))
         (and (numeric? (first lo1s))
              (pattern-match? (rest p) (rest lo1s)))]))
