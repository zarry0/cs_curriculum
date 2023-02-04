#lang racket

(require "hw5.rkt")

(require rackunit)

(define MUPLfun (fun "double" "x" (add (var "x") (var "x"))))
(define MUPLfun-rec (fun "length" "xs"
                         (ifgreater (isaunit (var "xs")) (int 0)
                                    (int 0)
                                    (add (int 1) (call (var "length") (snd (var "xs")))))))
(define MUPLlist (apair (int 1) (apair (int 2) (apair (int 3) (apair (int 4) (apair (int 5) (aunit)))))))

(define tests
  (test-suite
   "Sample tests for Assignment 5"
   
   (check-equal? (racketlist->mupllist (list)) (aunit)                       "racketlist->mupllist #1")
   (check-equal? (racketlist->mupllist (list (int 1) (int 2) (int 3)))
                 (apair (int 1) (apair (int 2) (apair (int 3) (aunit))))     "racketlist->mupllist #2")
   (check-equal? (racketlist->mupllist (list (int 1) (var "a") (var "b")))
                 (apair (int 1) (apair (var "a") (apair (var "b") (aunit)))) "racketlist->mupllist #3")

    (check-equal? (mupllist->racketlist (aunit)) null                        "mupllist->racketlist #1")
    (check-equal? (mupllist->racketlist (apair (int 1) (apair (int 2) (apair (int 3) (aunit)))))
                  (list (int 1) (int 2) (int 3))                             "mupllist->racketlist #2")
    (check-equal? (mupllist->racketlist (apair (int 1) (apair (var "a") (apair (var "b") (aunit)))))
                  (list (int 1) (var "a") (var "b"))                         "mupllist->racketlist #3")

    (check-equal? (eval-exp (add (int 1) (mlet "a" (int 5) (var "a")))) (int 6) "eval-exp #1 (add)")
   ;(check-equal? (eval-exp (add (int 1) (aunit))) "error"                     "eval-exp #2 (add)")
    (check-equal? (eval-exp (ifgreater (int 1)   (int 2) (aunit) (apair (int 1) (int 3)))) (apair (int 1) (int 3)) "eval-exp #3 (ifgreater)")
    (check-equal? (eval-exp (ifgreater (int 2)   (int 2) (aunit) (apair (int 1) (int 3)))) (apair (int 1) (int 3)) "eval-exp #4 (ifgreater)")
    (check-equal? (eval-exp (ifgreater (int 3)   (int 2) (aunit) (apair (int 1) (int 3)))) (aunit)                 "eval-exp #5 (ifgreater)")
   ;(check-equal? (eval-exp (ifgreater (var "a") (int 2) (aunit) (apair (int 1) (int 3)))) "error"                 "eval-exp #6 (ifgreater)")
   ;(check-equal? (eval-exp (ifgreater (int 2)   (aunit) (aunit) (apair (int 1) (int 3)))) "error"                 "eval-exp #7 (ifgreater)")
    (check-equal? (eval-exp MUPLfun)     (closure null MUPLfun)     "eval-exp #8 (fun)")
    (check-equal? (eval-exp MUPLfun-rec) (closure null MUPLfun-rec) "eval-exp #9 (fun)")
    (check-equal? (eval-exp (call (closure null MUPLfun)     (int 2) )) (int 4) "eval-exp #10 (call)")
    (check-equal? (eval-exp (call (closure null MUPLfun-rec) MUPLlist)) (int 5) "eval-exp #11 (call)")
    (check-equal? (eval-exp (mlet "a" (int 4) (var "a")))                                      (int 4) "eval-exp #12 (mlet)")
    (check-equal? (eval-exp (mlet "a" (int 4) (mlet "b" (var "a") (add (var "a") (var "b"))))) (int 8) "eval-exp #13 (mlet)")
    (check-equal? (eval-exp (apair (int 1) (int 5))) (apair (int 1) (int 5)) "eval-exp #14 (apair)")
    (check-equal? (eval-exp (mlet "a" (int 4) (mlet "b" (int 5) (apair (int 3) (apair (var "a") (apair (var "b") (aunit)))))))
                  (apair (int 3) (apair (int 4) (apair (int 5) (aunit))))    "eval-exp #15 (apair)")
   (check-equal? (eval-exp (fst MUPLlist)) (int 1) "eval-exp #16 (fst)")
   (check-equal? (eval-exp (snd MUPLlist)) (apair (int 2) (apair (int 3) (apair (int 4) (apair (int 5) (aunit))))) "eval-exp #17 (snd)")
   (check-equal? (eval-exp (aunit)) (aunit) "eval-exp #18 (aunit)")
   (check-equal? (eval-exp (isaunit (int 2))) (int 0) "eval-exp #19 (isaunit)")
   (check-equal? (eval-exp (isaunit (aunit))) (int 1) "eval-exp #20 (isaunit)")

   (check-equal? (ifaunit (aunit) (int 1) (int 2)) (ifgreater (isaunit (aunit)) (int 0) (int 1) (int 2)) "ifaunit #1")
   (check-equal? (ifaunit (int 0) (int 1) (int 2)) (ifgreater (isaunit (int 0)) (int 0) (int 1) (int 2)) "ifaunit #2")

   (check-equal? (mlet* null (add (int 1) (int 2))) (add (int 1) (int 2)) "mlet #1")
   (check-equal? (mlet* (list (cons "a" (int 1)) (cons "b" (add (int 1) (var "a"))) (cons "c" (var "b"))) (add (int 10) (var "c")))
                 (mlet "a" (int 1)
                       (mlet "b" (add (int 1) (var "a"))
                             (mlet "c" (var "b") (add (int 10) (var "c"))))) "mlet #2")

   (check-equal? (ifeq (int 1) (int 2) (int 1) (int 0)) (mlet* (list (cons "_x" (int 1)) (cons "_y" (int 2)))
                                                               (ifgreater (var "_x") (var "_y")
                                                                   (int 0)
                                                                   (ifgreater (var "_y") (var "_x")
                                                                              (int 0)
                                                                              (int 1)))) "ifeq #1")
   (check-equal? (ifeq (int 2) (int 2) (int 1) (int 0)) (mlet* (list (cons "_x" (int 2)) (cons "_y" (int 2)))
                                                               (ifgreater (var "_x") (var "_y")
                                                                   (int 0)
                                                                   (ifgreater (var "_y") (var "_x")
                                                                              (int 0)
                                                                              (int 1)))) "ifeq #2")

   (check-equal? (eval-exp (call (call mupl-map (fun #f "x" (add (var "x") (int 1)))) (aunit))) (aunit) "mupl-map #1")
   (check-equal? (eval-exp (call (call mupl-map (fun #f "x" (add (var "x") (int 1)))) (racketlist->mupllist (list (int 0) (int 1) (int 2) (int 3)))))
                           (racketlist->mupllist (list (int 1) (int 2) (int 3) (int 4))) "mupl-map #2")
   (check-equal? (eval-exp (call (call mupl-map MUPLfun) (racketlist->mupllist (list (int 0) (int 1) (int 2) (int 3)))))
                 (racketlist->mupllist (list (int 0) (int 2) (int 4) (int 6))))

   (check-equal? (eval-exp (call (call mupl-mapAddN (int 1)) (aunit))) (aunit)  "mupl-AddN #1")
   (check-equal? (eval-exp (call (call mupl-mapAddN (int 1)) (racketlist->mupllist (list (int 0) (int 1) (int 2) (int 3)))))
                  (racketlist->mupllist (list (int 1) (int 2) (int 3) (int 4))) "mupl-AddN #2")

   ))

(require rackunit/text-ui)
;; runs the test
(run-tests tests)