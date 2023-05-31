;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname Book) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#lang racket

;; to represent a book in a bookstore
;; A Book is (make-book String String Number)
(define-struct book (title author price))
 
;; Examples:
(define htdp (make-book "HtDP" "FFFK" 60))
(define beaches (make-book "Beaches" "PC" 20))

;; template for book
(define (fn-for-book abook)
  (... (book-title abook)
       (book-author abook)
       (book-price abook)))


;; compute the sale price of a book for the given discount
;; sale-price: Book Num -> Num
(check-expect (sale-price htdp 30) 42)
(check-expect (sale-price beaches 20) 16)

(define (sale-price abook discount)
  (- (book-price abook) (/ (* (book-price abook) discount) 100)))
 
