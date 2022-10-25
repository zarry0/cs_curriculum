;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname wide-only) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; wide-only-starter.rkt

;
; PROBLEM:
;
; Use the built in version of filter to design a function called wide-only 
; that consumes a list of images and produces a list containing only those 
; images that are wider than they are tall.
;


(define I1 (rectangle 10 20 "solid" "red"))
(define I2 (rectangle 30 20 "solid" "yellow"))
(define I3 (rectangle 40 50 "solid" "green"))
(define I4 (rectangle 60 50 "solid" "blue"))
(define I5 (rectangle 90 90 "solid" "orange"))

(define LOI1 (list I1 I2 I3 I4 I5))

;; (listof Image) -> (listof Image)
;; produces a list with only wide images
;; (a wide image is an image that is wider than it's tall)
(check-expect (wide-only (list I1 I3 I5)) empty)
(check-expect (wide-only (list I1 I2 I3 I4 I5)) (list I2 I4))
(check-expect (wide-only (list I2 I4)) (list I2 I4))

;(define (wide-only loi) empty)  ;stub

(define (wide-only loi)
  (local [(define (wide? i) (> (image-width i) (image-height i)))]
    (filter wide? loi)))