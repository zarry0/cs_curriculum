;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname names-under-20) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Encapsulate the functions names-under-20--person and names-under-20--lop using local.

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

;; Person -> ListOfString
;; produce a list of the names of the persons under 20

(check-expect (names-under-20 P1) (list "N1"))
(check-expect (names-under-20 P2) (list "N1"))
(check-expect (names-under-20 P4) (list "N1" "N3"))

(define (names-under-20 p)
  (local [(define (names-under-20--person p)
            (if (< (person-age p) 20)
                (cons (person-name p)
                      (names-under-20--lop (person-children p)))
                (names-under-20--lop (person-children p))))
      
          (define (names-under-20--lop lop)
            (cond [(empty? lop) empty]
                  [else
                   (append (names-under-20--person (first lop))
                           (names-under-20--lop (rest lop)))]))]
    (names-under-20--person p)))