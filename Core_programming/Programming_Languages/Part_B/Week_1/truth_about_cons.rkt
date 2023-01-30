#lang racket

(define pr (cons 1 (cons #t "hi")))                ; in ML (1, (true, "hi"))
(define lst (cons 1 (cons #t (cons "hi" null))))
(define hi (cdr (cdr pr)))                         ; "hi"
(define hi-again (car (cdr (cdr lst))))            ; "hi"
(define hi-again-shorter (caddr lst))              ; (define (caddr x) (car (cdr (cdr x))))
(define no (list? pr))
(define yes (pair? pr))
(define of-course (and (list? lst) (pair? lst)))
; (define do-not-do-this (length pr))