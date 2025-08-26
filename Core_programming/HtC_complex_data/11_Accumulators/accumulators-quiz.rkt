;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname accumulators-quiz) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;
; PROBLEM 1:
; 
; Assuming the use of at least one accumulator, design a function that consumes a list of strings,
; and produces the length of the longest string in the list. 
; 

;; (listof String) -> Natural
;; produces the length of the longest string in the list
(check-expect (longest-str empty) 0)
(check-expect (longest-str (list "a")) 1)
(check-expect (longest-str (list "abc" "f" "gh" "12345" "" )) 5)

;(define (longest-str los) 0)  ;stub
#;
(define (longest-str los0)
  ;; longest is Natural; the length of the longest string so far
  (local [(define (longest-str los longest)
            (cond [(empty? los) longest]
                  [else
                   (if (>= (string-length (first los)) longest)
                       (longest-str (rest los) (string-length (first los)))
                       (longest-str (rest los) longest))]))]
    (longest-str los0 0)))

;alt version
(define (longest-str los0)
  ;; longest is Natural; the length of the longest string so far
  (local [(define (longest-str los longest)
            (cond [(empty? los) longest]
                  [else
                   (local [(define len (max (string-length (first los)) longest))]
                     (longest-str (rest los) len))]))]
    (longest-str los0 0)))

;
; PROBLEM 2:
;  ;; produces true if the sequence obeys the fibonacci rule: fib(n) = fib(n-2) + fib(n-1)
;; ASSUME: the list will be at least 2 items long
(check-expect (fib? (list 1 2)) true)
(check-expect (fib? (list 4 5)) true)
(check-expect (fib? (list 1 1 2 3 5 8 13)) true)
(check-expect (fib? (list 4 5 9 14 23)) true)
(check-expect (fib? (list 4 5 6 14 23)) false)
(check-expect (fib? (list 0 1 1 2 5 8 13)) false)
(check-expect (fib? (list 0 1 2 3)) false)

;(define (fib? lon) false)  ;stub
#;
(define (fib? lon0)
  ;; i is Natural; the 0-based index in the sequence
  (local [(define (fib? lon i)
            (cond [(<= i 1) true]
                  [else
                   (if (= (list-ref lon i) (+ (list-ref lon (- i 2)) (list-ref lon (- i 1))))
                       (fib? lon (sub1 i))
                       false)]))]
    
    (fib? lon0 (sub1 (length lon0)))))
;; alt v.1
#;
(define (fib? lon0)
  ;; i is Natural; the 0-based index of the sequence
  ;; fib-1 is Number; the previous element to (first lon)
  ;; fib-2 is Number; the previous element to fib-1
  (local [(define (fib? lon i fib-2 fib-1)
            (cond [(empty? lon) true]
                  [else
                   (if (<= i 1) 
                       (fib? (rest lon) (add1 i) fib-1 (first lon))
                       (if (= (first lon) (+ fib-2 fib-1))
                           (fib? (rest lon) (add1 i) fib-1 (first lon))
                           false))]))]
    
    (fib? lon0 0 0 (first lon))))

;; alt v.2
#;
(define (fib? lon0)
  ;; fib-1 is Number; the previous element to (first lon)
  ;; fib-2 is Number; the previous element to fib-1
  (local [(define (fib? lon fib-2 fib-1)
            (cond [(empty? lon) true]
                  [else
                   (if (= (first lon) (+ fib-2 fib-1))
                       (fib? (rest lon) fib-1 (first lon))
                       false)]))]
    (fib? (rest (rest lon0)) (first lon0) (second lon0))))

;; alt v.3 (tail-recursive version)
(define (fib? lon0)
  ;; fib-1 is Number; the previous element to (first lon)
  ;; fib-2 is Number; the previous element to fib-1
  ;; rsf is Boolean;  true if the sequence obeys the rule so far 
  (local [(define (fib? lon fib-2 fib-1 rsf)
            (cond [(empty? lon) rsf]
                  [else
                   (fib? (rest lon) fib-1 (first lon) (and (= (first lon) (+ fib-2 fib-1)) rsf))]))]
    
    (fib? (rest (rest lon0)) (first lon0) (second lon0) true)))

;
; PROBLEM 3:
; 
; Refactor the function below to make it tail recursive.  
; 

;; Natural -> Natural
;; produces the factorial of the given number
(check-expect (fact 0) 1)
(check-expect (fact 3) 6)
(check-expect (fact 5) 120)

#;
(define (fact n)
  (cond [(zero? n) 1]
        [else 
         (* n (fact (sub1 n)))]))
#;
(define (fact n0)
  ;; i is Natural; the 1-based index of the sequence up to n
  ;; rsf is Natural; the result so far
  (local [(define (fact i rsf)
            (cond [(> i n0) rsf]
                  [else
                   (fact (add1 i) (* i rsf))]))]
    (fact 1 1)))

;; alt version
(define (fact n0)
  ;; rsf is Natural; the result so far
  (local [(define (fact n rsf)
            (cond [(zero? n) rsf]
                  [else
                   (fact (sub1 n) (* n rsf))]))]
    (fact n0 1)))

;
; PROBLEM 4:
; 
; Recall the data definition for Region from the Abstraction Quiz. Use a worklist 
; accumulator to design a tail recursive function that counts the number of regions 
; within and including a given region. 
; So (count-regions CANADA) should produce 7
;


(define-struct region (name type subregions))
;; Region is (make-region String Type (listof Region))
;; interp. a geographical region

;; Type is one of:
;; - "Continent"
;; - "Country"
;; - "Province"
;; - "State"
;; - "City"
;; interp. categories of geographical regions

(define VANCOUVER (make-region "Vancouver" "City" empty))
(define VICTORIA (make-region "Victoria" "City" empty))
(define BC (make-region "British Columbia" "Province" (list VANCOUVER VICTORIA)))
(define CALGARY (make-region "Calgary" "City" empty))
(define EDMONTON (make-region "Edmonton" "City" empty))
(define ALBERTA (make-region "Alberta" "Province" (list CALGARY EDMONTON)))
(define CANADA (make-region "Canada" "Country" (list BC ALBERTA)))

;;                    CANADA
;;                      │
;;           ┌──────────┴───────────┐
;;           │                      │
;;           BC                  ALBERTA
;;           │                      │
;;     ┌─────┴──────┐          ┌────┴─────┐
;;     │            │          │          │
;; VANCOUVER    VICTORIA    CALGARY   EDMONTON


#;
(define (fn-for-region r)
  (local [(define (fn-for-region r)
            (... (region-name r)
                 (fn-for-type (region-type r))
                 (fn-for-lor (region-subregions r))))
          
          (define (fn-for-type t)
            (cond [(string=? t "Continent") (...)]
                  [(string=? t "Country") (...)]
                  [(string=? t "Province") (...)]
                  [(string=? t "State") (...)]
                  [(string=? t "City") (...)]))
          
          (define (fn-for-lor lor)
            (cond [(empty? lor) (...)]
                  [else 
                   (... (fn-for-region (first lor))
                        (fn-for-lor (rest lor)))]))]
    (fn-for-region r)))

;; Region -> Natural
;; produces the number of Regions within and including the given region
(check-expect (count-regions CANADA) 7)
(check-expect (count-regions ALBERTA) 3)
(check-expect (count-regions VANCOUVER) 1)

;(define (count-regions r) 0)  ;stub

(define (count-regions r0)
  ;; count is Natural;        the Regions counted so far
  ;; todo is (listof Region); the uncounted Regions yet
  ;; (count-regions CANADA)  ;outer call
  ;;
  ;; (count-region CANADA 0 empty)
  ;; (count-subregions (list BC ALBERTA) 1)
  ;;
  ;; (count-region BC 1 (list ALBERTA))
  ;; (count-subregions (list VANCOUVER VICTORIA ALBERTA) 2)
  ;;
  ;; (count-region VANCOUVER 2 (list VICTORIA ALBERTA))
  ;; (count-subregions (list VICTORIA ALBERTA) 3)
  ;;
  ;; (count-region VICTORIA 3 (list ALBERTA))
  ;; (count-subregions (list ALBERTA) 4)
  ;;
  ;; (count-region ALBERTA 4 empty)
  ;; (count-subregions (list CALGARY EDMONTON) 5)
  ;;
  ;; (count-region CALGARY 5 (list EDMONTON))
  ;; (count-subregions (list EDMONTON) 6)
  ;;
  ;; (count-region EDMONTON 6 empty)
  ;; (count-subregions empty 7)      ; returns 7
  ;;
  (local [;; Region Natural (listof Region) -> Natural
          ;;        (listof Region) Natural -> Natural
          (define (count-region r count todo)
            (count-subregions (append (region-subregions r) todo) (add1 count)))

          (define (count-subregions todo count)
            (cond [(empty? todo) count]
                  [else
                   (count-region (first todo) count (rest todo))]))]
    
    (count-region r0 0 empty)))