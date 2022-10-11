;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname render-bst-w-lines-faster) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; render-bst-w-lines-faster-starter.rkt

(require 2htdp/image)


; PROBLEM STATEMENT IS AT THE END OF THIS FILE. 


;; Constants

(define TEXT-SIZE  14)
(define TEXT-COLOR "BLACK")

(define KEY-VAL-SEPARATOR ":")

(define MTTREE (rectangle 20 1 "solid" "white"))



;; Data definitions:

(define-struct node (key val l r))
;; A BST (Binary Search Tree) is one of:
;;  - false
;;  - (make-node Integer String BST BST)
;; interp. false means no BST, or empty BST
;;         key is the node key
;;         val is the node val
;;         l and r are left and right subtrees
;; INVARIANT: for a given node:
;;     key is > all keys in its l(eft)  child
;;     key is < all keys in its r(ight) child
;;     the same key never appears twice in the tree
;
;                10:why
;                 /  \
;                /    \
;               /      \
;              /        \
;             /          \
;            /            \
;           /              \
;          /                \
;        3:ilk            42:ily
;         / \               / \
;        /   \             /   \
;       /     \           /     \
;     1:abc 4:dcj     27:wit   50:dug
;              \        /
;             7:ruf  14:olp
;

(define BST0 false)
(define BST1 (make-node 1 "abc" false false))
(define BST7 (make-node 7 "ruf" false false)) 
(define BST4 (make-node 4 "dcj" false (make-node 7 "ruf" false false)))
(define BST3 (make-node 3 "ilk" BST1 BST4))
(define BST42 
  (make-node 42 "ily"
             (make-node 27 "wit" (make-node 14 "olp" false false) false)
             (make-node 50 "dug" false false)))
(define BST10
  (make-node 10 "why" BST3 BST42))
(define BST100 
  (make-node 100 "large" BST10 false))
#;
(define (fn-for-bst t)
  (cond [(false? t) (...)]
        [else
         (... (node-key t)    ;Integer
              (node-val t)    ;String
              (fn-for-bst (node-l t))
              (fn-for-bst (node-r t)))]))

;; Template rules used:
;;  - one of: 2 cases
;;  - atomic-distinct: false
;;  - compound: (make-node Integer String BST BST)
;;  - self reference: (node-l t) has type BST
;;  - self reference: (node-r t) has type BST

;; Functions:

;
; PROBLEM:
;
; Design a function that consumes a bst and produces a SIMPLE 
; rendering of that bst including lines between nodes and their 
; subnodes.
;

;; BST -> Image
;; produce SIMPLE rendering of bst
;; ASSUME BST is relatively well balanced
(check-expect (render-bst false) MTTREE)

(define (render-bst bst)
  (local [(define (render-bst bst)
            (cond [(false? bst) MTTREE]
                  [else
                   (above (render-key-val (node-key bst) (node-val bst))
                          (local [(define left-subtree (render-bst (node-l bst)))
                                  (define right-subtree (render-bst (node-r bst)))]
                            (above (lines (image-width left-subtree)
                                          (image-width right-subtree))
                                   (beside left-subtree
                                           right-subtree))))]))

          ;; Integer String -> Image
          ;; render key and value to form the body of a node
          (define (render-key-val k v)
            (text (string-append (number->string k)
                                 KEY-VAL-SEPARATOR
                                 v)
                  TEXT-SIZE
                  TEXT-COLOR))

          ;; Natural Natural -> Image
          ;; produce lines to l/r subtrees based on width of those subtrees
          (define (lines lw rw)
            (add-line (add-line (rectangle (+ lw rw) (/ (+ lw rw) 4) "solid" "white")  ;background
                                (/ (+ lw rw) 2)  0
                                (/ lw 2)         (/ (+ lw rw) 4)
                                "black")
                      (/ (+ lw rw) 2)  0
                      (+ lw (/ rw 2))  (/ (+ lw rw) 4)
                      "black"))]
    (render-bst bst)))


;
; PROBLEM:
;
; Uncomment out the definitions and expressions below, and then
; construct a simple graph with the size of the tree on the
; x-axis and the time it takes to render it on the y-axis. How
; does the time it takes to render increase as a function of
; the size of the tree? If you can, improve the performance of  
; render-bst.
;
; There is also at least one other good way to use local in this 
; program. Try it. 
;


;; These trees are NOT legal binary SEARCH trees.
;; But for tests on rendering speed that won't matter.
;; Just don't try searching in them!

(define BSTA (make-node 100 "A" BST10 BST10))  ;19 nodes
(define BSTB (make-node 101 "B" BSTA BSTA))    ;39 nodes
(define BSTC (make-node 102 "C" BSTB BSTB))    ;79 nodes
(define BSTD (make-node 103 "D" BSTC BSTC))    ;159 nodes
(define BSTE (make-node 104 "E" BSTD BSTD))    ;319 nodes
(define BSTF (make-node 104 "E" BSTE BSTE))    ;639 nodes

;;                                      Original            After refactoring
(time (rest (list (render-bst BSTA))))  ;22    ms               4  ms
(time (rest (list (render-bst BSTB))))  ;86    ms               4  ms
(time (rest (list (render-bst BSTC))))  ;252   ms               8  ms
(time (rest (list (render-bst BSTD))))  ;1538  ms               20 ms
(time (rest (list (render-bst BSTE))))  ;4248  ms               46 ms
(time (rest (list (render-bst BSTF))))  ;17465 ms               73 ms
;
;                                   Original
;  18000 +------------------------------------------------------------------+
;        |         +        +         +        +         +        +         |
;  16000 |-+                                                           *  +-|
;        |                                                                  |
;  14000 |-+                                                              +-|
;        |                                                                  |
;        |                                                                  |
;  12000 |-+                                                              +-|
;        |                                                                  |
;  10000 |-+                                                              +-|
;        |                                                                  |
;   8000 |-+                                                              +-|
;        |                                                                  |
;   6000 |-+                                                              +-|
;        |                                                                  |
;        |                              *                                   |
;   4000 |-+                                                              +-|
;        |                                                                  |
;   2000 |-+            *                                                 +-|
;        |         +        +         +        +         +        +         |
;      0 +------------------------------------------------------------------+
;        0        100      200       300      400       500      600       700
;

;                                 After refactoring
;
;  80 +---------------------------------------------------------------------+
;     |         +         +         +         +         +         +         |
;  70 |-+                                                             **  +-|
;     |                                                                     |
;     |                                                                     |
;  60 |-+                                                                 +-|
;     |                                                                     |
;  50 |-+                                                                 +-|
;     |                               *                                     |
;     |                                                                     |
;  40 |-+                                                                 +-|
;     |                                                                     |
;  30 |-+                                                                 +-|
;     |                                                                     |
;     |                                                                     |
;  20 |-+             *                                                   +-|
;     |                                                                     |
;  10 |-+                                                                 +-|
;     |       *                                                             |
;     | * *     +         +         +         +         +         +         |
;   0 +---------------------------------------------------------------------+
;     0        100       200       300       400       500       600       700

