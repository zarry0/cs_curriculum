;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname list-operations) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


;; ListOfAny -> ListOfAny
;; reverses the given list
(check-expect (reverse-list empty) empty)
(check-expect (reverse-list (cons "a" empty)) (cons "a" empty))
(check-expect (reverse-list (cons "a" (cons "b" (cons "c" empty)))) (cons "c" (cons "b" (cons "a" empty))))

;(define (reverse-list lox) lox)  ;stub

(define (reverse-list lox)
  (cond [(empty? lox) empty]
        [else
         (append-to (first lox) (reverse-list (rest lox)))]))

;; Any ListOfAny -> ListOfAny
;; appends the item x to the end of the list
(check-expect (append-to "a" empty) (cons "a" empty))
(check-expect (append-to 2 (cons 1 empty)) (cons 1 (cons 2 empty)))

;(define (append-to x lox) lox)  ;stub

(define (append-to x lox)
  (cond [(empty? lox) (cons x empty)]
        [else
         (cons (first lox) (append-to x (rest lox)))]))