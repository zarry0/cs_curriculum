;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname fs) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; fs-starter.rkt (type comments and examples)

;; Data definitions:

(define-struct elt (name data subs))
;; Element is (make-elt String Integer ListOfElement)
;; interp. An element in the file system, with name, and EITHER data or subs.
;;         If data is 0, then subs is considered to be list of sub elements.
;;         If data is not 0, then subs is ignored.

;; ListOfElement is one of:
;;  - empty
;;  - (cons Element ListOfElement)
;; interp. A list of file system Elements

(define F1 (make-elt "F1" 1 empty))
(define F2 (make-elt "F2" 2 empty))
(define F3 (make-elt "F3" 3 empty))
(define D4 (make-elt "D4" 0 (list F1 F2)))
(define D5 (make-elt "D5" 0 (list F3)))
(define D6 (make-elt "D6" 0 (list D4 D5)))
;        D6
;       /  \
;      /    \
;     D4    D5
;    /  \   | 
;   F1  F2  F3

#;
(define (fn-for-element e)
  (local [(define (fn-for-element e)
            (... (elt-name e)    ;String
                 (elt-data e)    ;Integer
                 (fn-for-loe (elt-subs e))))

          (define (fn-for-loe loe)
            (cond [(empty? loe) (...)]
                  [else
                   (... (fn-for-element (first loe))
                        (fn-for-loe (rest loe)))]))]
    (fn-for-element e)))


;; Functions:

; 
;  PROBLEM 1
;
;  Design a function that consumes Element and produces the sum of all the file data in 
;  the tree.
;

;; Element -> Integer
;; produces the sum of all the file data in the tree
(check-expect (sum-data F1) 1)
(check-expect (sum-data F3) 3)
(check-expect (sum-data D4) (+ (sum-data F1) (sum-data F2)))
(check-expect (sum-data D6) (+ (sum-data D4) (sum-data D5)))

(define (sum-data e)
  (local [(define (sum-data--element e)
            (if (zero? (elt-data e)) 
                (sum-data--loe (elt-subs e))
                (elt-data e)))
          (define (sum-data--loe loe)
            (cond [(empty? loe) 0]
                  [else
                   (+ (sum-data--element (first loe))
                      (sum-data--loe (rest loe)))]))]
    (sum-data--element e)))


;
;  PROBLEM 2
;
;  Design a function that consumes Element and produces a list of the names of all the elements in 
;  the tree. 
;

;; Element       -> ListOfString
;; produces a list of all the element names in the tree
(check-expect (list-names F1) (list "F1"))
(check-expect (list-names D5) (list "D5" "F3"))
(check-expect (list-names D4) (list "D4" "F1" "F2"))

(define (list-names e)
  (local [(define (list-names--element e)
            (cons (elt-name e)
                  (list-names--loe (elt-subs e))))

          (define (list-names--loe loe)
            (cond [(empty? loe) empty]
                  [else
                   (append (list-names--element (first loe))
                           (list-names--loe (rest loe)))]))]
    (list-names--element e)))

;
;  PROBLEM 3
;
;  Design a function that consumes String and Element and looks for a data element with the given 
;  name. If it finds that element it produces the data, otherwise it produces false.
;

;; String Element -> Integer or false
;; search the given tree for an element with the given name, produce data if found; false otherwise
(check-expect (find "F1" F2) false)
(check-expect (find "F1" F1) 1)
(check-expect (find "F3" D4) false)
(check-expect (find "F1" D4) 1)
(check-expect (find "F2" D4) 2)
(check-expect (find "D4" D4) 0)
(check-expect (find "F3" D6) 3)

(define (find n e)
  (local [(define (find--element n e)
            (if (string=? n (elt-name e))      
                (elt-data e)                   
                (find--loe n (elt-subs e))))   

          (define (find--loe n loe)
            (cond [(empty? loe) false]
                  [else
                   (if (false? (find--element n (first loe)))  
                       (find--loe n (rest loe))                
                       (find--element n (first loe)))]))]
    (find--element n e)))

;
;  PROBLEM 4
;
;  Design a function that consumes Element and produces a rendering of the tree. For example: 
;
;  (render-tree D6) should produce something like the following.
;
;        D6
;       /  \
;      /    \
;     D4    D5
;    /  \   | 
;   F1  F2  F3
;
;   HINTS:
;    - This function is not very different than the first two functions above.
;    - Keep it simple! Start with a not very fancy rendering like the one above.
;      Once that works you can make it more elaborate if you want to.
;    - And... be sure to USE the recipe. Not just follow it, but let it help you.
;      For example, work out a number of examples BEFORE you try to code the function. 
;    

(require 2htdp/image)

;; Constants
(define FONT-COLOR "black")
(define FONT-SIZE 14)
(define TREE-H .7)

;; Element -> Image
;; produces a rendering of the given tree
(check-expect (render F1) (text "F1" FONT-SIZE FONT-COLOR))
(check-expect (render D5) (above (text "D5" FONT-SIZE FONT-COLOR)
                                 (add-line (rectangle (image-width (text "F3" FONT-SIZE FONT-COLOR))
                                                      (* (image-width (text "F3" FONT-SIZE FONT-COLOR)) TREE-H)
                                                      "solid"
                                                      "white")
                                           (/ (image-width (text "F3" FONT-SIZE FONT-COLOR)) 2) ;x1
                                           0;y1
                                           (/ (image-width (text "F3" FONT-SIZE FONT-COLOR)) 2);x2
                                           (* (image-width (text "F3" FONT-SIZE FONT-COLOR)) TREE-H);y2
                                           FONT-COLOR)
                                 (text "F3" FONT-SIZE FONT-COLOR)))
(check-expect (render D4) (above (text "D4" FONT-SIZE FONT-COLOR)
                                 (add-line (add-line (rectangle (+ (image-width (text "F1" FONT-SIZE FONT-COLOR))
                                                                   (image-width (text "F2" FONT-SIZE FONT-COLOR)))
                                                                (* (+ (image-width (text "F1" FONT-SIZE FONT-COLOR))
                                                                      (image-width (text "F2" FONT-SIZE FONT-COLOR))) TREE-H)
                                                                "solid"
                                                                "white")
                                                     (/ (+ (image-width (text "F1" FONT-SIZE FONT-COLOR))
                                                           (image-width (text "F2" FONT-SIZE FONT-COLOR))) 2);x1
                                                     0;y1
                                                     (/ (image-width (text "F1" FONT-SIZE FONT-COLOR)) 2);x2
                                                     (* (+ (image-width (text "F1" FONT-SIZE FONT-COLOR))
                                                           (image-width (text "F2" FONT-SIZE FONT-COLOR))) TREE-H);y2
                                                     FONT-COLOR)
                                           (/ (+ (image-width (text "F1" FONT-SIZE FONT-COLOR))
                                                 (image-width (text "F2" FONT-SIZE FONT-COLOR))) 2);x1
                                           0;y1
                                           (+ (image-width (text "F1" FONT-SIZE FONT-COLOR))
                                              (/ (image-width (text "F2" FONT-SIZE FONT-COLOR)) 2));x2
                                           (* (+ (image-width (text "F1" FONT-SIZE FONT-COLOR))
                                                 (image-width (text "F2" FONT-SIZE FONT-COLOR))) TREE-H);y2
                                           FONT-COLOR)
                                 (beside/align "top" (text "F1" FONT-SIZE FONT-COLOR)
                                               (text "F2" FONT-SIZE FONT-COLOR))))


(define (render e)
  (local [(define (render--element e)
            (above (text (elt-name e) FONT-SIZE FONT-COLOR)
                   (render-lines (elt-subs e) (render--loe (elt-subs e)))
                   (render--loe (elt-subs e))))

          (define (render--loe loe)
            (cond [(empty? loe) empty-image]
                  [else
                   (beside/align "top"
                                 (render--element (first loe))
                                 (render--loe (rest loe)))]))

          (define (render-lines loe i)
            (cond [(empty? loe) empty-image]
                  [(empty? (rest loe)) (render-line loe (rectangle (image-width i) (* (image-width i) TREE-H)"solid" "white"))]
                  [else
                   (render-line loe (render-lines (rest loe) i))]))

          (define (render-line loe img)
            (add-line img
                      (/ (image-width img) 2)       ;x1
                      0                             ;y1
                      (+ (/ (image-width (render--element (first loe))) 2)
                         (offset img loe))        ;x2
                      (* (image-width img) TREE-H)  ;y2
                      FONT-COLOR))

          (define (offset img loe)
            (- (image-width img)
               (image-width (render--loe (rest loe)))
               (image-width (render--element (first loe)))))]
    
    (render--element e)))