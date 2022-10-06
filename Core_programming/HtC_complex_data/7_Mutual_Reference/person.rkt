;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname person) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Data definitions

(define-struct person (name age children))
;; Person is (make-person String Natural ListOfPerson)
;; interp. a person with first name, age and a list of their children
#;
(define (fn-for-person p)
  (... (person-name p)   ;String
       (person-age p)    ;Natural
       (fn-for-lop (person-children p))))

;; ListOfPerson is one of:
;;  - empty
;;  - (cons Person ListOfPerson)
;; interp. alist of persons
#;
(define (fn-for-lop lop)
  (cond [(empty? lop) (...)]
        [else
         (... (fn-for-person (first lop))
              (fn-for-lop    (rest lop)))]))

(define P1 (make-person "N1" 5 empty))
(define P2 (make-person "N2" 25 (list P1)))
(define P3 (make-person "N3" 15 empty))
(define P4 (make-person "N4" 45 (list P2 P3)))

;      P4(45)
;     /     \
;    /       \
; P2(25)    P3(15)
;   |
; P1(5)

; PROBLEM
; Design a function that consumes a person and produces a list of the names
; of all the people in the tree under 20 ("in the tree" includes the original person).

;; Person -> ListOfString
;; ListOfPerson -> ListOfString
;; produce a list of the names of the persons under 20

(check-expect (names-under-20--person P1) (list "N1"))
(check-expect (names-under-20--lop empty) empty)
(check-expect (names-under-20--person P2) (list "N1"))
(check-expect (names-under-20--lop (list P3 P2)) (append (list "N3") (list "N1")))
(check-expect (names-under-20--person P4) (list "N1" "N3"))

;(define (names-under-20--person p) empty)  ;stubs
;(define (names-under-20--lop lop) empty)


;; Person -> ListOfString
;; if the person's age is under 20, produces a list that contains that person's name and
;;                                  their children's names (that also are under 20)
;; otherwise                        produces a list that contains that person children's names that
;;                                  have an age under 20
(define (names-under-20--person p)
  (if (< (person-age p) 20)
      (cons (person-name p) (names-under-20--lop (person-children p)))
      (names-under-20--lop (person-children p))))


;; ListOfPerson -> ListOfString
;; produces a list of names from every person in the list and their children that are under 20
(define (names-under-20--lop lop)
  (cond [(empty? lop) empty]
        [else
         (append (names-under-20--person (first lop))
                 (names-under-20--lop    (rest lop)))]))
