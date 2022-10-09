;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname zip) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; zip-starter.rkt

;
; Problem:
;
; Given the data definition below, design a function called zip that consumes two
; lists of numbers and produces a list of Entry, formed from the corresponding 
; elements of the two lists.
;
; (zip (list 1 2 ...) (list 11 12 ...)) should produce:
;
; (list (make-entry 1 11) (make-entry 2 12) ...)
;
; Your design should assume that the two lists have the same length.
;

;; =================
;; Data Definitions:

(define-struct entry (k v))
;; Entry is (make-entry Number Number)
;; Interp. an entry maps a key to a value
(define E1 (make-entry 3 12))

;; ListOfEntry is one of:
;;  - empty
;;  - (cons Entry ListOfEntry)
;; interp. a list of key value entries
(define LOE1 (list E1 (make-entry 1 11)))

;; ListOfNumber is one of:
;;  - empty
;;  - (cons Number ListOfNumber)
;; interp. a list of numbers
(define LON1 (list 1 2 3))

;; ==========
;; Functions:

;; Cross product (4 cases):

;;                                  l1
;;                         |  empty  |  (cons Number LON)
;;     --------------------|---------|----------------------
;; l         empty         |  empty  |         x
;; 2   --------------------|---------|----------------------
;;      (cons Number LON)  |    x    |  (cons Entry LOE)

;; SIMPLIFICTION: there are only 2 cases since the lists must be the same size

;;     l1    |   l2    |  
;;  ---------|---------|------------------
;;         empty       |      empty
;;  ---------|---------|------------------
;;   (cons Number LON) | (cons Entry LOE)


;; ListOfNumber ListOfNumber -> ListOfEntry
;; produces a list of Entry formed from the corresponding 
;; elements of the two lists.
(check-expect (zip empty empty) empty)
(check-expect (zip (list 0) (list 84)) (list (make-entry 0 84)))
(check-expect (zip (list 0 1 2 3) (list 84 4 69 420)) (list (make-entry 0 84)
                                                            (make-entry 1 4)
                                                            (make-entry 2 69)
                                                            (make-entry 3 420)))

;(define (zip l1 l2) empty)  ;stub

(define (zip l1 l2)
  (cond [(empty? l1) empty]
        [else
         (cons (make-entry (first l1) (first l2))
               (zip (rest l1) (rest l2)))]))