;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname Problem2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; Problem 2

;; Variant A
;; 
;; Suppose you are given a list of integers. Your task is to determine if this list contains:
;;      - A number that is even
;;      - A number that is positive and odd
;;      - A number between 5 and 10, inclusive
;; The order in which you find numbers in the list satisfying these requirements does not matter. 
;; The list could have many more numbers than you need. Any number in the list may satisfy multiple requirements. 
;; For example, the list (in Racket notation) (list 6 5) satisfies all three requirements, while the list (list 4 3) does not.
;; 
;; 
;; Variant B
;; 
;; Again, the list must contain numbers satisfying the three requirements above. 
;; Again, order does not matter. This time, a given number in the list may only be used to satisfy a single requirement;
;; however, duplicate numbers are permitted to satisfy multiple requirements. 
;; So, (list 6 5) does not meet all the criteria for this variant, but (list 6 5 6) does.
;; 
;; 
;; Variant C 
;; 
;; Again, the list must contain numbers satisfying the three requirements above. 
;; Again, order does not matter. Again, a given number in the list may only be used to satisfy a single requirement.
;; This time, however, the list may not contain any extraneous numbers. 
;; So, (list 6 5 6) satisfies all our criteria for this variant, but (list 6 5 42 6) does not.

;; Variant Z
;; (Very open-ended)
;;
;; There is something distinctly unsatisfying about designing these solutions to work for precisely three requirements:
;; why not four, or five, or an arbitrary number? Design functions in DrRacket to solve the preceding three problems again, 
;; this time supporting an arbitrary number of requirements to be checked on the elements of the list. 
;; What essential features of Racket are you using, that we do not yet have in Java?
;; 
;; Answer:
;; In Racket, we can abstract the process of checking each number for requirements by designing a generic function that 
;; goes through the list and returns an answer based on several requirements (flags) and a function that evaluates 
;; a single number for those requirements.
;; We achieve this thanks to the use of higher-order functions.


;; ========================
;; Data Definitions

;; (listof Int) is one of
;;  - empty
;;  - (cons Int (listof Int))
;; interp. a list of ints

;; Examples
(define l1 (list 4 3))
(define l2 (list 6 5))
(define l3 (list -1 4))
(define l4 (list 6 5 6))
(define l5 (list 4 3 6))
(define l6 (list 6 5 42 6))

;; ========================
;; Functions

;; (listof Int) -> bool
;; produces true if the list contains an even integer
;;                                    an integer that is odd and positive and
;;                                    an integer between 5 and 10 inclusive
(check-expect (check-variant-A empty) false)
(check-expect (check-variant-A l1) false)
(check-expect (check-variant-A l2) true)
(check-expect (check-variant-A l3) false)
(check-expect (check-variant-A l4) true)
(check-expect (check-variant-A l5) true)
(check-expect (check-variant-A l6) true)

(define (check-variant-A loi)
  (check-abstract variant-A (list false false false) loi))

;; (listof Int) -> bool
;; produces true if the list contains an even integer
;;                                    an integer that is odd and positive and
;;                                    an integer between 5 and 10 inclusive
;; Note: a single number can only satisfy a single requirement, 
;;       but duplicates are allowed to satisfy different requirements
(check-expect (check-variant-B empty) false)
(check-expect (check-variant-B l1) false)
(check-expect (check-variant-B l2) false)
(check-expect (check-variant-B l3) false)
(check-expect (check-variant-B l4) true)
(check-expect (check-variant-B l5) true)
(check-expect (check-variant-B l6) true)

(define (check-variant-B loi)
  (check-abstract variant-B (list false false false) loi))

;; (listof Int) -> bool
;; produces true if the list contains an even integer
;;                                    an integer that is odd and positive and
;;                                    an integer between 5 and 10 inclusive
;;          also the list must not contain any extraneous numbers
;; ASSUME: a extraneous number is one that is outside of the range [5, 10]
;; Note: a single number can only satisfy a single requirement, 
;;       but duplicates are allowed to satisfy different requirements
(check-expect (check-variant-C empty) false)
(check-expect (check-variant-C l1) false)
(check-expect (check-variant-C l2) false)
(check-expect (check-variant-C l3) false)
(check-expect (check-variant-C l4) true)
(check-expect (check-variant-C l5) false)
(check-expect (check-variant-C l6) false)
(check-expect (check-variant-C (list 42 6 5 6)) false)

(define (check-variant-C loi)
  (check-abstract variant-C (list false false false true) loi))

;; (int * (listof bool) -> (listof bool)) * (listof Int) -> bool
;; given a function that checks if a given int satisfies n requirements, and a list of integers
;; produces true if the list has numbers that satisfy the requirements
(define (check-abstract fn flags loi)
  (andmap (lambda (b) (not (false? b))) (foldl fn flags loi)))

;; int * (bool bool bool) -> (bool bool bool)
;; given a number and a list of 3 flags, produces a list of flags with the requirements it satisfies
;; a number can satisfy multiple requirements
(define (variant-A n flags)
  (list (or (first flags)  (even? n))
        (or (second flags) (and (odd? n) (positive? n)))
        (or (third flags)  (and (>= n 5) (<= n 10)))))

;; int * (bool bool bool) -> (bool bool bool)
;; given a number and a list of 3 flags, produces a list of flags with the requirements it satisfies
;; a number can satisfy only one requirement at the time
(define (variant-B n flags)
  (cond [(and (not (first flags))  (even? n))                    (list true          (second flags) (third flags))]
        [(and (not (second flags)) (and (odd? n) (positive? n))) (list (first flags) true           (third flags))]
        [(and (not (third flags))  (and (>= n 5) (<= n 10)))     (list (first flags) (second flags) true)]
        [else flags]))

;; int * (bool bool bool bool) -> (bool bool bool bool)
;; given a number and a list of 4 flags, produces a list of flags with the requirements it satisfies
;; a number can satisfy only one requirement at the time and it can't be any extraneous numbers
(define (variant-C n flags)
  (cond [(or (< n 5) (> n 10)) (list false false false false)]
        [(and (not (first flags))  (even? n))                    (list true          (second flags) (third flags) (fourth flags))]
        [(and (not (second flags)) (and (odd? n) (positive? n))) (list (first flags) true           (third flags) (fourth flags))]
        [(and (not (third flags))  (and (>= n 5) (<= n 10)))     (list (first flags) (second flags) true (fourth flags))]
        [else flags]))