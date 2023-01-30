#lang racket

(define mpair (mcons 1 (mcons #t "hi")))
;(car mpair)  ; this won't work
;(cdr mpair)  ; this won't work

(mcar mpair)  ; 1
(mcdr mpair)  ; (mcons #t "hi")
(set-mcar! mpair 2)  ; mpair = (mcons 2 (mcons t# "hi"))
(set-mcdr! mpair 47) ; mpair = (mcons 2 47)
(set-mcdr! mpair (mcons #t 47)) ; mpair = (mcons 2 (mcons #t 47))