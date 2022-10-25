;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname fold-dir) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; fold-dir-starter.rkt

;
; In this exercise you will be need to remember the following DDs 
; for an image organizer.
;

; =================
;; Data definitions:

(define-struct dir (name sub-dirs images))
;; Dir is (make-dir String ListOfDir ListOfImage)
;; interp. An directory in the organizer, with a name, a list
;;         of sub-dirs and a list of images.

;; ListOfDir is one of:
;;  - empty
;;  - (cons Dir ListOfDir)
;; interp. A list of directories, this represents the sub-directories of
;;         a directory.

;; ListOfImage is one of:
;;  - empty
;;  - (cons Image ListOfImage)
;; interp. a list of images, this represents the sub-images of a directory.
;; NOTE: Image is a primitive type, but ListOfImage is not.

(define I1 (square 10 "solid" "red"))
(define I2 (square 12 "solid" "green"))
(define I3 (rectangle 13 14 "solid" "blue"))
(define D4 (make-dir "D4" empty (list I1 I2)))
(define D5 (make-dir "D5" empty (list I3)))
(define D6 (make-dir "D6" (list D4 D5) empty))

;; =================
;; Functions:

;
; PROBLEM A:
;
; Design an abstract fold function for Dir called fold-dir. 
;

;; Dir X (String Y Z -> X) (X Y -> Y) ((listof Image) -> Z) Z -> X
;; an abstract fold function for dir
(check-expect (local [(define (make-loi b loi) (identity loi))]
                (fold-dir D6 empty make-dir cons make-loi empty)) D6)
(check-expect (local [(define (c1 name sub-dir-count img-count) (+ sub-dir-count img-count))
                      (define (count-img b loi) (length loi))]
                (fold-dir D6 0 c1 + count-img 0)) 3)

(define (fold-dir dir base c1 c2 fn-for-loi base-img)
  (local [;; Dir -> X
          (define (fn-for-dir--dir d)
            (c1 (dir-name d)
                (fn-for-dir--lod (dir-sub-dirs d))
                (fn-for-loi base-img (dir-images d)))) ; Z (listof Image) -> Z
          ;; (listof Dir) -> Y
          (define (fn-for-dir--lod lod)
            (cond [(empty? lod) base]
                  [else
                   (c2 (fn-for-dir--dir (first lod))
                       (fn-for-dir--lod (rest lod)))]))]
    (fn-for-dir--dir dir)))


;
; PROBLEM B:
;
; Design a function that consumes a Dir and produces the number of 
; images in the directory and its sub-directories. 
; Use the fold-dir abstract function.
;

;; Dir -> Number
;; produces the number of images in the directory and its sub-dirs
(check-expect (count-img D5) 1)
(check-expect (count-img D6) 3)

;(define (count-img d) 0)  ;stub

(define (count-img d)
  (local [;; String Natural Natural -> Natural 
          (define (c1 name sub-dir-count img-count) (+ sub-dir-count img-count))
          ;; Natural (listof Image) -> Natural
          (define (count-img b loi) (length loi))]
    ;; Dir Natural (String Natural Natural -> Natural)  (Natural Natural -> Natural) (Image -> Natural) Natural -> Natural
    (fold-dir d 0 c1 + count-img 0)))

;
; PROBLEM C:
;
; Design a function that consumes a Dir and a String. The function looks in
; dir and all its sub-directories for a directory with the given name. If it
; finds such a directory it should produce true, if not it should produce false. 
; Use the fold-dir abstract function.
;

;; Dir String -> Boolean
;; produces true if it finds a dir with the given name in the given dir and its sub-dirs
(check-expect (find-dir D5 "D5") true)
(check-expect (find-dir D4 "D10") false)
(check-expect (find-dir D6 "D4") true)

;(define (find-dir dir name) false)  ;stub

(define (find-dir dir name)
  (local [;; String Boolean Image -> Boolean
          (define (c1 n r i) (or (string=? name n) r))
          ;; Boolean Boolean -> Boolean
          (define (c2 f r) (or f r))
          ;; Dummy func.
          (define (fn-for-loi b loi) 0)]
    ;; Dir X (String Y Z -> X) (X Y -> Y) (Z (listof Image) -> Z) Z -> X
    (fold-dir dir false c1 c2 fn-for-loi 0)))

;
; PROBLEM D:
;
; Is fold-dir really the best way to code the function from part C? Why or 
; why not?
;

;; No. Abstract functions are helpful in refactoring repetitive code,
;; but in the case of fold-dir, the cases are too broad,
;; which makes the function cumbersome to work with, and it ends up being simpler to code
;; an ad-hoc solution than trying to adapt the abstract fucntion

