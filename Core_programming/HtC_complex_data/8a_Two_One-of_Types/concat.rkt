;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname concat) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; concat-starter.rkt

;
; Problem:
;
; Given the data definition below, design a function called concat that
; consumes two ListOfString and produces a single list with all the elements 
; of lsta preceding lstb.
;
; (concat (list "a" "b" ...) (list "x" "y" ...)) should produce:
;
; (list "a" "b" ... "x" "y" ...)
;
; You are basically going to design the function append using a cross product 
; of type comments table. Be sure to simplify your design as much as possible. 
;
; Hint: Think carefully about the values of both lists. You might see a way to 
; change a cell's content so that 2 cells have the same value.
;

;; =================
;; Data Definitions:

;; ListOfString is one of:
;;  - empty
;;  - (cons String ListOfString)
;; interp. a list of strings
(define LOS1 empty)
(define LOS2 (cons "a" (cons "b" empty)))

;; ==========
;; Functions:

;; Cross Product (4 cases):

;;       lstA v \ lstB >        |      empty   |  (cons String ListOfString)
;; -----------------------------|--------------|-----------------------------
;;            empty             |  empty (any) |            lstB
;; -----------------------------|--------------|-----------------------------
;;  (cons String ListOfString)  |     lstA     |        lstA + lstB


;; SIMPLIFICATION: If lstA is empty it doesn't matter the contents of lstB, just return lstB
;; 3 cases:

;;       lstA v \ lstB >        |   empty  |  (cons String ListOfString)
;; -----------------------------|----------|-----------------------------
;;            empty             |         lstB
;; -----------------------------|----------|-----------------------------
;;  (cons String ListOfString)  |   lstA   |         lstA + lstB


;; ListOfString ListOfString -> ListOfString
;; produces a list of the form 
(check-expect (concat empty empty) empty)
(check-expect (concat (list "x") empty) (list "x"))
(check-expect (concat empty (list "x")) (list "x"))
(check-expect (concat (list "x") (list "y")) (list "x" "y"))
(check-expect (concat (list "x" "y") (list "a" "b")) (list "x" "y" "a" "b"))

;(define (concat lstA lstB) empty)  ;stub

(define (concat lstA lstB)
  (cond [(empty? lstA) lstB]
        [(empty? lstB) lstA]
        [else
         (cons (first lstA)
               (concat (rest lstA) lstB))]))
