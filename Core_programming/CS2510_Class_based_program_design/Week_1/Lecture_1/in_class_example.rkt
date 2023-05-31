#lang racket

;; A number representing the temperature in degrees Farenheit
(define outside-temp 75)

;; Some examples...
(define hot-day (+ outside-temp 50))
;(define bad-day (+ "75 degrees" 50))

; If we type that whole program into DrRacket, what will happen?
; Error: + works with numbers not strings

; Why couldn’t DrRacket warn us about our mistake as soon as we wrote it?
; Racket uses dynamic typing, meaning type checking is done at run-time