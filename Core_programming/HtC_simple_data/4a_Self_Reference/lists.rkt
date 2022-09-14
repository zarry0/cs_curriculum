;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname lists) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define L0 empty)                             ; empty list
(define L1 (cons "1" empty))                  ; a list of 1 element
(define L2 (cons "1" (cons "2" empty)))       ; a list of 2 elements
(define L3 (cons 10 (cons 9 (cons 8 empty)))) ; a list of 3 elements

(first L1) ;produces the first element of the list
(rest L1)  ;produces the rest of the list

(first L3)
(rest L3)

(first (rest L3))        ;Second element
(first (rest (rest L3))) ;Third element

(empty? empty)  ;check if a list is empty
(empty? L1)