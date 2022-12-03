;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname merge-sort) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require racket/list)
;; merge-sort

;; (listof Number) -> (listof Number)
;; produces a sorted list in ascending order using merge sort
(check-expect (merge-sort empty) empty)
(check-expect (merge-sort (list 2)) (list 2))
(check-expect (merge-sort (list 1 2)) (list 1 2))
(check-expect (merge-sort (list 4 3)) (list 3 4))
(check-expect (merge-sort (list 6 5 3 1 8 7 2 4)) (list 1 2 3 4 5 6 7 8))

;; template according to generative recursion

(define (merge-sort lon)
  (cond [(empty? lon) empty]
        [(empty? (rest lon)) lon]
        [else
         (merge (merge-sort (take lon (quotient (length lon) 2)))
                (merge-sort (drop lon (quotient (length lon) 2))))]))

;; (listof Number) (listof Number) -> (listof Number)
;; produces a list that is the merger of the input lists sorted in ascending order
;; ASSUME: lon1 and lon2 are already sorted
(check-expect (merge empty empty) empty)
(check-expect (merge (list 1) empty) (list 1))
(check-expect (merge empty (list 1)) (list 1))
(check-expect (merge (list 1 3 5 6) (list 2 4 7 8)) (list 1 2 3 4 5 6 7 8))

;; 2 one of table
;;
;;                                 lon2
;;                        ┌─────────┬──────────────────────────────────┐
;;                        │  empty  │         (cons Number LON)        │
;;     ┌──────────────────┼─────────┼──────────────────────────────────┤
;;    l│     empty        │         │               lon2               │
;;    o├──────────────────┼  lon1   ┼──────────────────────────────────┤
;;    n│(cons Number LON) │         │(if (first lon1) < (first lon2)   │
;;    1│                  │         │     (cons (firsts lon1 lon2)     │
;;     │                  │         │                    (merge rests))│
;;     │                  │         │     (cons (firsts lon2 lon1)     │
;;     │                  │         │                    (merge rests))│
;;     └──────────────────┴─────────┴──────────────────────────────────┘

(define (merge lon1 lon2)
  (cond [(empty? lon2) lon1]
        [(empty? lon1) lon2]
        [else
         (if (< (first lon1) (first lon2))
             (cons (first lon1) (merge (rest lon1) lon2))
             (cons (first lon2) (merge lon1 (rest lon2))))]))

; ;; (listof Number) Natural -> (listof Number)
; ;; produces a list with the elements of lon from index 0 to index n
; ;; ASSUME: lon has at least n elements
; (check-expect (take empty 0) empty)
; (check-expect (take (list 1 2 3 4) 0) empty)
; (check-expect (take (list 1 2 3 4) 2) (list 1 2))
;
; (define (take lon n) empty)
;
; ;; (listof Number) Natural -> (listof Number)
; ;; produces a list with the elements of lon from index n to the end of the list
; ;; ASSUME: lon has at least n elements
; (check-expect (drop empty 0) empty)
; (check-expect (drop (list 1 2 3 4) 0) (list 1 2 3 4))
; (check-expect (drop (list 1 2 3 4) 2) (list 3 4))
;
; (define (drop lon n) empty)

