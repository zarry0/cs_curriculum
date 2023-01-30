#lang racket

(require "hw4.rkt")
(require rackunit)

; Helpers
(define (stream-maker fn arg)
  (letrec ([f (lambda (x) 
                (cons x (lambda () (f (fn x arg)))))])
    (lambda () (f arg))))

(define tests
  (test-suite
   "Sample tests for Assignment 4"

   (check-equal? (sequence 3 2 1)   null             "sequence test #1")
   (check-equal? (sequence 3 3 1)  (list 3)          "sequence test #2")
   (check-equal? (sequence 3 3 2)  (list 3)          "sequence test #3")
   (check-equal? (sequence 3 8 3)  (list 3 6)        "sequence test #4")
   (check-equal? (sequence 3 11 2) (list 3 5 7 9 11) "sequence test #5")
   (check-equal? (sequence 1 5 2)  (list 1 3 5)      "sequence test #6")
   (check-equal? (sequence 1 5 3)  (list 1 4)        "sequence test #7")
   (check-equal? (sequence 0 5 2)  (list 0 2 4)      "sequence test #8")
   (check-equal? (sequence 1 5 1)  (list 1 2 3 4 5)  "sequence test #9")

   (check-equal? (string-append-map null "")                null                  "string-append-map #1")
   (check-equal? (string-append-map (list "a" "b" "c") "")  (list "a" "b" "c")    "string-append-map #2")
   (check-equal? (string-append-map (list "a" "b" "c") "A") (list "aA" "bA" "cA") "string-append-map #3")

   ;(check-equal? (list-nth-mod null 2) "error" "list-nth-mod #1")
   ;(check-equal? (list-nth-mod (list 0 1 2 3 4) -1) "error" "list-nth-mod #2")
   (check-equal? (list-nth-mod (list 0 1 2 3 4) 1) 1 "list-nth-mod #1")
   (check-equal? (list-nth-mod (list 0 1 2 3 4) 4) 4 "list-nth-mod #2")
   (check-equal? (list-nth-mod (list 0 1 2 3 4) 5) 0 "list-nth-mod #3")
   (check-equal? (list-nth-mod (list "a" "b" "c") 17) "c" "list-nth-mod #4")

   (check-equal? (stream-for-n-steps (stream-maker + 1) 0) null               "stream-for-n-steps #1")
   (check-equal? (stream-for-n-steps (stream-maker + 1) 1) (list 1)           "stream-for-n-steps #2")
   (check-equal? (stream-for-n-steps (stream-maker + 1) 5) (list 1 2 3 4 5)   "stream-for-n-steps #3")
   (check-equal? (stream-for-n-steps (stream-maker * 2) 5) (list 2 4 8 16 32) "stream-for-n-steps #4")
   
   (check-equal? (stream-for-n-steps funny-number-stream 4)  (list 1 2 3 4)                   "funny-number-stream #1")
   (check-equal? (stream-for-n-steps funny-number-stream 5)  (list 1 2 3 4 -5)                "funny-number-stream #2")
   (check-equal? (stream-for-n-steps funny-number-stream 11) (list 1 2 3 4 -5 6 7 8 9 -10 11) "funny-number-stream #3")

   (check-equal? (stream-for-n-steps dan-then-dog 1)  (list "dan.jpg")                     "dan-then-dog #1")
   (check-equal? (stream-for-n-steps dan-then-dog 2)  (list "dan.jpg" "dog.jpg")           "dan-then-dog #2")
   (check-equal? (stream-for-n-steps dan-then-dog 3)  (list "dan.jpg" "dog.jpg" "dan.jpg") "dan-then-dog #3")

   (check-equal? (stream-for-n-steps (stream-add-zero funny-number-stream) 5) (list '(0 . 1)
                                                                                    '(0 . 2)
                                                                                    '(0 . 3)
                                                                                    '(0 . 4)
                                                                                    '(0 . -5)) "stream-add-zero #1")
   (check-equal? (stream-for-n-steps (stream-add-zero dan-then-dog) 4) (list '(0 . "dan.jpg")
                                                                             '(0 . "dog.jpg")
                                                                             '(0 . "dan.jpg")
                                                                             '(0 . "dog.jpg")) "stream-add-zero #2")

   (check-equal? (stream-for-n-steps (cycle-lists (list 1 2 3) (list "a" "b")) 6)
                 (list '(1 . "a") '(2 . "b") '(3 . "a") '(1 . "b") '(2 . "a") '(3 . "b")) "cycle-lists #1")
   (check-equal? (stream-for-n-steps (cycle-lists (list 1 2) (list 3 4)) 6)
                 (list '(1 . 3) '(2 . 4) '(1 . 3) '(2 . 4) '(1 . 3) '(2 . 4))             "cycle-lists #2")
   (check-equal? (stream-for-n-steps (cycle-lists (list "a") (list "d" "c")) 3)
                 (list '("a" . "d") '("a" . "c") '("a" . "d"))                            "cycle-lists #3")

   (check-equal? (vector-assoc   4 #())                                                    #f "vector-assoc #1")
   (check-equal? (vector-assoc   4 #(1 2 3 4))                                             #f "vector-assoc #2")
   (check-equal? (vector-assoc   4 #((2 . 4) (1 . 2) ("a" . 6) (4 . 5) (4 . "c")))   '(4 . 5) "vector-assoc #3")
   (check-equal? (vector-assoc "a" #((2 . 4) (1 . 2) ("a" . 6) (4 . 5) (4 . "c"))) '("a" . 6) "vector-assoc #4")
   (check-equal? (vector-assoc   5 #((2 . 4) (1 . 2) ("a" . 6) (4 . 5) (4 . "c")))         #f "vector-assoc #5")
   (check-equal? (vector-assoc   5 #((2 . 4) (1 . 2) ("a" . 6) (4 . 5) 5 (4 . "c")))       #f "vector-assoc #6")

   (check-equal? ((cached-assoc null 3) 3)                                 #f "cached-assoc #1")
   (check-equal? ((cached-assoc (list (cons 1 2) (cons 3 4)) 3) 2)         #f "cached-assoc #2")
   (check-equal? ((cached-assoc (list (cons 1 2) (cons 3 4)) 3) 3) (cons 3 4) "cached-assoc #3")
   ))


(require rackunit/text-ui)
;; runs the test
(run-tests tests)