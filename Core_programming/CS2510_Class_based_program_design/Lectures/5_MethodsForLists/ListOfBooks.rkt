;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname ListOfBooks) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; ---------------------------------------------------------------------------------------
;; Data definitions
;; ---------------------------------------------------------------------------------------

(define-struct book (title author year price))
;; Book is (make-book String String Number Number)
;; interp. a Book with title, author, year of publication and price
(define htdp (make-book "HtDP" "MF" 2001 60))
(define lpp (make-book "LPP" "STX" 1942 25))
(define ll (make-book "LL" "FF" 1986 10))

;; listOf Book is one of:
;;  - empty
;;  - (list Book listOfBook)
;; interp. a list of Books
(define mtlist empty)
(define lista (list lpp))
(define listb (list htdp))
(define listc (cons lpp (cons ll listb)))
(define listd (cons ll  (cons lpp (cons htdp mtlist))))

;; ---------------------------------------------------------------------------------------
;; Functions
;; ---------------------------------------------------------------------------------------

;; (listOf Book) -> Number
;; produces the number of Books in the list
(check-expect (count mtlist) 0)
(check-expect (count lista) 1)
(check-expect (count listc) 3)

(define (count lob)
  (cond [(empty? lob) 0]
        [else (+ 1 (count (rest lob)))]))

;; (listOf Book) *  Number -> Number
;; produces the total sale price of all books in the given list for the given discount
(check-expect (sale-price mtlist 0) 0)
(check-expect (sale-price lista 0) 25)
(check-expect (sale-price listc 0) 95)
(check-expect (sale-price lista 50) 12.5)
(check-expect (sale-price listc 50) 47.5)

(define (sale-price lob discount)
  (cond [(empty? lob) 0]
        [else (+ (apply-sale discount (first lob))
                 (sale-price (rest lob) discount))]))

;; Number * Book -> Number
;; produces the price after the discount
(check-expect (apply-sale 0 htdp) 60)
(check-expect (apply-sale 50 htdp) 30)
(check-expect (apply-sale 50 lpp) 12.5)

(define (apply-sale discount book)
  (* (- 1 (/ discount 100)) (book-price book)))

;; (listOf Book) *  Number -> (listOf Book)
;; produces a list with all books from the given list published before the given year
(check-expect (all-before mtlist 0) empty)
(check-expect (all-before lista 2000) lista)
(check-expect (all-before listb 2000) empty)
(check-expect (all-before listc 2000) (list lpp ll))

(define (all-before lob year)
  (cond [(empty? lob) empty]
        [else (if (pub-before? (first lob) year)
                  (cons (first lob) (all-before (rest lob) year))
                  (all-before (rest lob) year))]))

;; Book * Number -> Boolean
;; produces true if the given book was published before the given year
(check-expect (pub-before?  htdp 2000) false)
(check-expect (pub-before?  htdp 2010) true)

(define (pub-before? book year)
  (< (book-year book) year))
