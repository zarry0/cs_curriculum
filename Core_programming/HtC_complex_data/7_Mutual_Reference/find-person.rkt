;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname find-person) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; find-person-starter.rkt

;
; The following program implements an arbitrary-arity descendant family 
; tree in which each person can have any number of children.
;
; PROBLEM A:
;
; Decorate the type comments with reference arrows and establish a clear 
; correspondence between template function calls in the templates and 
; arrows in the type comments.
;

;; Data definitions:

(define-struct person (name age kids))

;; Person is (make-person String Natural ListOfPerson)
;; interp. A person, with first name, age and their children
(define P1 (make-person "N1" 5 empty))
(define P2 (make-person "N2" 25 (list P1)))
(define P3 (make-person "N3" 15 empty))
(define P4 (make-person "N4" 45 (list P3 P2)))
#;
(define (fn-for-person p)
  (... (person-name p)			;String
       (person-age p)			;Natural  
       (fn-for-lop (person-kids p))))   ;reference to ListOfPerson (MUTUAL-REFERENCE)


;; ListOfPerson is one of:
;;  - empty
;;  - (cons Person ListOfPerson)
;; interp. a list of persons
#;
(define (fn-for-lop lop)
  (cond [(empty? lop) (...)]
        [else
         (... (fn-for-person (first lop))  ; reference to Person (MUTUAL-REFERENCE)  
              (fn-for-lop (rest lop)))]))  ; reference to ListOfPerson (SELF-REFERENCE)


;; Person & ListOfPerson form a Mutal Reference cycle:
;;   * Person references ListOfPerson -> (person-kids p) is ListOfPerson
;;   * ListOfPerson references Person -> (first lop) is Person

;; Functions:

;
; PROBLEM B:
;
; Design a function that consumes a Person and a String. The function
; should search the entire tree looking for a person with the given 
; name. If found the function should produce the person's age. If not 
; found the function should produce false.
; 

;; Person String -> Natural or false
;; ListOfPerson String -> Natural or false 
;; produces the age if the person's name can be found in the tree, false otherwise
(check-expect (find-person--lop empty "N1") false)
(check-expect (find-person--person P1 "N2") false)
(check-expect (find-person--person P1 "N1") 5)
(check-expect (find-person--person P2 "N1") 5)
(check-expect (find-person--lop (list P2 P3) "N3") 15)
(check-expect (find-person--lop (list P2 P3) "N4") false)
(check-expect (find-person--person P4 "N1") 5)

;(define (find-person--person p name) false)  ;stubs
;(define (find-person--lop lop name) false)

(define (find-person--person p name)
  (if (string=? (person-name p) name)			
      (person-age p)			  
      (find-person--lop (person-kids p) name)))

(define (find-person--lop lop name)
  (cond [(empty? lop) false]
        [else
         (if  (not (false? (find-person--person (first lop) name)))
              (find-person--person (first lop) name)
              (find-person--lop (rest lop) name))]))