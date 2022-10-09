;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname merge) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; merge-starter.rkt

;
; Problem:
;
; Design the function merge. It consumes two lists of numbers, which it assumes are 
; each sorted in ascending order. It produces a single list of all the numbers, 
; also sorted in ascending order. 
;
; Your solution should explicitly show the cross product of type comments table, 
; filled in with the values in each case. Your final function should have a cond 
; with 3 cases. You can do this simplification using the cross product table by 
; recognizing that there are subtly equal answers. 
;
; Hint: Think carefully about the values of both lists. You might see a way to 
; change a cell content so that 2 cells have the same value.
;


;; =====================
;; Data definitions


;; ListOfNumber is one of:
;;  - empty
;;  - (cons Number ListOfNumber)
;; interp. a list of numbers
(define LON0 empty)
(define LON1 (list 1 2 3 4 5))


;; ==============
;; Functions:

;; Cross Product (4 cases):

;;                                      lstB
;;                         |     empty    |      (cons Number LON)
;; l   --------------------|--------------|-----------------------------
;; s         empty         |  empty (any) |            lstB
;; t   --------------------|--------------|-----------------------------
;; A    (cons Number LON)  |     lstA     |    lstA + lstB (in order)

;; SIMPLIFICATION: If lstB is empty, just return lstA (3 cases)

;;                                      lstB
;;                         |     empty    |      (cons Number LON)
;; l   --------------------|--------------|-----------------------------
;; s         empty         |              |            lstB
;; t   --------------------|     lstA     |-----------------------------
;; A    (cons Number LON)  |              |    lstA + lstB (in order)


;; ListOfNumber ListOfNumber -> ListOfNumber
;; produces a list with all the numbers in lstA and lstB that is sorted in assending order
;; ASSUME: lstA and lstB are already in ascending order
(check-expect (merge empty empty) empty)
(check-expect (merge empty (list 1 2)) (list 1 2))
(check-expect (merge (list 1 2) empty) (list 1 2))
(check-expect (merge (list 1 2) (list 3 4 5)) (list 1 2 3 4 5))
(check-expect (merge (list 8 15) (list 1 7 9 10 25 30)) (list 1 7 8 9 10 15 25 30))

;(define (merge lstA lstB) empty)  ;stub

(define (merge lstA lstB)
  (cond [(empty? lstB) lstA]
        [(empty? lstA) lstB]
        [else
         (if (< (first lstA) (first lstB))
             (cons (first lstA) (merge (rest lstA) lstB))
             (cons (first lstB) (merge lstA (rest lstB))))]))

