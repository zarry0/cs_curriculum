;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname count-odd-even-tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; count-odd-even-starter.rkt

;
; PROBLEM:
;
; Previously we have written functions to count the number of elements in a list. In this 
; problem we want a function that produces separate counts of the number of odd and even 
; numbers in a list, and we only want to traverse the list once to produce that result.
;
; Design a tail recursive function that produces the Counts for a given list of numbers.
; Your function should produce Counts, as defined by the data definition below.
;
; There are two ways to code this function, one with 2 accumulators and one with a single
; accumulator. You should provide both solutions.
;

(define-struct counts (odds evens))
;; Counts is (make-counts Natural Natural)
;; interp. describes the number of even and odd numbers in a list

(define C1 (make-counts 0 0)) ;describes an empty list
(define C2 (make-counts 3 2)) ;describes (list 1 2 3 4 5))

;; (listof Number) -> Counts
;; produces the count of odds and even numbers in the list
(check-expect (count-odd-even empty) (make-counts 0 0))
(check-expect (count-odd-even (list 1 2 3 4 5 6 7 8 9)) (make-counts 5 4))

;(define (count-odd-even lon) C1)  ;stub

; Version with one accumulator 
#;
(define (count-odd-even lon0)
  ;; cnts is Counts; the current count
  (local [(define (count-odd-even lon cnts)
            (cond [(empty? lon) cnts]
                  [else
                   (count-odd-even (rest lon) (if (odd? (first lon))
                                                  (make-counts (add1 (counts-odds cnts)) (counts-evens cnts))
                                                  (make-counts (counts-odds cnts) (add1 (counts-evens cnts)))))]))]
    (count-odd-even lon0 C1)))

;; Version with two accumulators

(define (count-odd-even lon0)
  ;; odds  is Natural; the current odd count
  ;; evens is Natural; the current even count
  (local [(define (count-odd-even lon odds evens)
            (cond [(empty? lon) (make-counts odds evens)]
                  [(odd? (first lon)) (count-odd-even (rest lon) (add1 odds) evens)]
                  [else
                   (count-odd-even (rest lon) odds (add1 evens))]))]
    (count-odd-even lon0 0 0)))