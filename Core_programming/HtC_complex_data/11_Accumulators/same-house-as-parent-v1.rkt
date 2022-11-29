;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname same-house-as-parent-v1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; same-house-as-parent-v1.rkt

;
; PROBLEM:
;
; In the Harry Potter movies, it is very important which of the four houses a
; wizard is placed in when they are at Hogwarts. This is so important that in 
; most families multiple generations of wizards are all placed in the same family. 
;
; Design a representation of wizard family trees that includes, for each wizard,
; their name, the house they were placed in at Hogwarts and their children. We
; encourage you to get real information for wizard families from: 
;    http://harrypotter.wikia.com/wiki/Main_Page
;
; The reason we do this is that designing programs often involves collection
; domain information from a variety of sources and representing it in the program
; as constants of some form. So this problem illustrates a fairly common scenario.
;
; That said, for reasons having to do entirely with making things fit on the
; screen in later videos, we are going to use the following wizard family tree,
; in which wizards and houses both have 1 letter names. (Sigh)
;


;; Data Definitions

(define-struct wiz (name house kids))
;; Wizard is (make-wiz String String (listof Wizard))
;; interp. A Wizard family tree with their name, house and children

(define JAMES (make-wiz "James Potter II"      "Gryffindor" empty))
(define ALBUS (make-wiz "Albus Severus Potter" "Slytherin"  empty))
(define LILY  (make-wiz "Lily Luna Potter"     "Gryffindor" empty))
(define HARRY (make-wiz "Harry Potter"         "Gryffindor" (list JAMES ALBUS LILY)))

(define Wa (make-wiz "A" "S" empty))
(define Wb (make-wiz "B" "G" empty))
(define Wc (make-wiz "C" "R" empty))
(define Wd (make-wiz "D" "H" empty))
(define We (make-wiz "E" "R" empty))
(define Wf (make-wiz "F" "R" (list Wb)))
(define Wg (make-wiz "G" "S" (list Wa)))
(define Wh (make-wiz "H" "S" (list Wc Wd)))
(define Wi (make-wiz "I" "H" empty))
(define Wj (make-wiz "J" "R" (list We Wf Wg)))
(define Wk (make-wiz "K" "G" (list Wh Wi Wj)))


;; template, arb-arity tree
#;
(define (fn-for-wiz w)
  (local [;; Wizard -> X
          ;; (listof Wizard) -> X
          (define (fn-for-wiz--wiz w)
            (... (wiz-name w)
                 (wiz-house w)
                 (fn-for-wiz--low (wiz-kids w))))

          (define (fn-for-wiz--low low)
            (cond [(empty? low) (...)]
                  [else
                   (... (fn-for-wiz--wiz (first low))
                        (fn-for-wiz--low (rest low)))]))]
    (fn-for-wiz--wiz w)))


;
; PROBLEM:
;
; Design a function that consumes a wizard and produces the names of every 
; wizard in the tree that was placed in the same house as their immediate
; parent. 
;

;; Wizard -> (listof Wizard)
;; produces the names of every wizard that with the same house as their parent
(check-expect (same-house-as-parent. We) empty)
(check-expect (same-house-as-parent. Wh) empty)
(check-expect (same-house-as-parent. Wg) (list "A"))
(check-expect (same-house-as-parent. Wk) (list "E" "F" "A"))

;(define (same-house-as-parent. w) empty)  ;stub

(define (same-house-as-parent. w)
  ;; acc: String; the house of the node parent ("" for root  of tree)
  ;; (same-house-as-parent Wg)  ;outer call
  ;;
  ;; (fn-for-wiz (make-wiz "G" "S" (list (make-wiz "A" "S" empty)) "")  ;inner call
  ;; (fn-for-low                   (list (make-wiz "A" "S" empty) "S")
  ;; (fn-for-wiz                         (make-wiz "A" "S" empty) "S")
  ;; (fn-for-low                                            empty "S")   
  (local [;; Wizard -> (listof Wizard)
          ;; (listof Wizard) -> (listof Wizard)
          (define (fn-for-wiz w acc)
            (if (string=? (wiz-house w) acc)
                (cons (wiz-name w) (fn-for-low (wiz-kids w) (wiz-house w)))
                (fn-for-low (wiz-kids w) (wiz-house w))))

          (define (fn-for-low low acc)
            (cond [(empty? low) empty]
                  [else
                   (append (fn-for-wiz (first low) acc)
                           (fn-for-low (rest low) acc))]))]
    (fn-for-wiz w "")))

;
; PROBLEM:
;
; Design a new function definition for same-house-as-parent that is tail 
; recursive. You will need a worklist accumulator.
;

;; Wizard -> (listof Wizard)
;; produces the names of every wizard that with the same house as their parent
(check-expect (same-house-as-parent We) empty)
(check-expect (same-house-as-parent Wh) empty)
(check-expect (same-house-as-parent Wg) (list "A"))
(check-expect (same-house-as-parent Wk) (list "A" "F" "E"))

;(define (same-house-as-parent w) empty)  ;stub

;template from wizard + worklist accumulator for tail recursion

(define (same-house-as-parent w)
  ;; todo is (listof ...);    a worklist accumulator
  ;; rsf  is (listof String); a result so far accumulator
  (local [(define-struct wle (w ph))
          ;; WLE (worklist entry) is (make-wle Wizard String)
          ;; interp. a wizard and their inmediate parent's house
          
          (define (fn-for-wiz todo w ph rsf)
            (fn-for-low (append (map (lambda (wiz) (make-wle wiz (wiz-house w))) (wiz-kids w))
                                todo)
                        (if (string=? (wiz-house w) ph)
                            (cons (wiz-name w) rsf)
                            rsf)))

          (define (fn-for-low todo rsf)
            (cond [(empty? todo) rsf]
                  [else
                   (fn-for-wiz (rest todo)
                               (wle-w (first todo))
                               (wle-ph (first todo))
                               rsf)]))]
    
    (fn-for-wiz empty w "" empty)))

;
; PROBLEM:
;
; Design a function that consumes a wizard and produces the number of wizards 
; in that tree (including the root). Your function should be tail recursive.
;

;; Wizard -> Natural
;; produces  the number of wizards in the tree (including the root)
(check-expect (count Wa) 1)
(check-expect (count Wk) 11 )

;(define (count w) 0);  stub
; template from Wizard, add an accumulator for tail recursion
(define (count w)
  ;; rsf is Natural; the numer of wizards seen so far
  ;; todo is (listof Wizard); wizards we still need to visit with fn-for-wiz
  (local [;; Wizard -> Natural
          ;; (listof Wizard) -> Natural
          (define (fn-for-wiz w todo rsf)  
            (fn-for-low (append (wiz-kids w) todo) (add1 rsf)));)

          (define (fn-for-low todo rsf)
            (cond [(empty? todo) rsf]
                  [else
                   (fn-for-wiz (first todo) (rest todo) rsf)]))]
          
    (fn-for-wiz w empty 0)))

