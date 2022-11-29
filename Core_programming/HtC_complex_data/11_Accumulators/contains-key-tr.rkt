;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname contains-key-tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; bt-contains-tr-starter.rkt

;
; Problem:
;
; Starting with the following data definition for a binary tree (not a binary search tree) 
; design a tail-recursive function called contains? that consumes a key and a binary tree 
; and produces true if the tree contains the key.
;

(define-struct node (k v l r))
;; BT is one of:
;;  - false
;;  - (make-node Integer String BT BT)
;; Interp. A binary tree, each node has a key, value and 2 children
(define BT1 false)
(define BT2 (make-node 1 "a"
                       (make-node 6 "f"
                                  (make-node 4 "d" false false)
                                  false)
                       (make-node 7 "g" false false)))

;;       1:"a"
;;      /    \
;;    6:"f"  7:"g"
;;   /    
;; 4:"d"


;; Integer BT -> Boolean
;; produces true if the tree contains the key
(check-expect (contains? 1 false) false)
(check-expect (contains? 7 BT2) true)
(check-expect (contains? 4 BT2) true)
(check-expect (contains? 2 BT2) false)

;(define (contains? k bt) false)  ;stub
#; ;non tail-recursive version
(define (contains? k bt)
  (cond [(false? bt) false]
        [(= (node-k bt) k) true]
        [else
         (or (contains? k (node-l bt))
             (contains? k (node-r bt)))]))

(define (contains? k bt0)
  ;; todo is (listof Node); holds the unvisited nodes, performing a Dept-first search
  ;; (contains? 7 BT2)  ;outer call
  ;;
  ;;  (contains? {1:"a"} empty)
  ;;  (contains?-lon     (list {6:"f"} {7:"g"}) empty)
  
  ;;  (contains? {6:"f"} (list {7:"g"}))
  ;;  (contains?-lon     (list {4:"d"} {false} {7:"g"}))
  
  ;;  (contains? {4:"d"} (list {false} {7:"g"}))
  ;;  (contains?-lon     (list {false} {false} {false} {7:"g"}))
  
  ;;  (contains? {false} (list {false} {false} {7:"g"}))
  ;;  (contains?-lon     (list {false} {false} {7:"g"}))

  ;;  (contains? {false} (list {false} {7:"g"}))
  ;;  (contains?-lon     (list {false} {7:"g"}))

  ;;  (contains? {false} (list {7:"g"}))
  ;;  (contains?-lon     (list {7:"g"}))

  ;;  (contains? {7:"g"} empty)    ;found the right key
  (local [(define (contains? bt todo)
            (cond [(false? bt) (contains?-lon todo)]
                  [(= (node-k bt) k) true]
                  [else
                   (contains?-lon (append (list (node-l bt) (node-r bt)) todo))]))

          (define (contains?-lon todo)
            (cond [(empty? todo) false]
                  [else
                   (contains? (first todo) (rest todo))]))]
    
    (contains? bt0 empty)))