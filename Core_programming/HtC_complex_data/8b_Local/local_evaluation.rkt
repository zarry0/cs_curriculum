;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname local_evaluation) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (foo x)
  (local [(define (bar y) (+ x y))]
    (+ x (bar (* 2 x)))))

(list (foo 2) (foo 3))

;; Evaluation

(list (local [(define (bar y) (+ 2 y))]
        (+ 2 (bar (* 2 2))))
      (foo 3))

(list (local [(define (bar_0 y) (+ 2 y))]   ;renaming
        (+ 2 (bar_0 (* 2 2))))
      (foo 3))

(define (bar_0 y) (+ 2 y))                  ;lift

(list (local []
        (+ 2 (bar_0 (* 2 2))))
      (foo 3))

(list (+ 2 (bar_0 (* 2 2)))                 ;replace with body
      (foo 3))

(list (+ 2 (+ 2 (* 2 2)))
      (foo 3))

(list (+ 2 (+ 2 4))
      (foo 3))

(list (+ 2 6)
      (foo 3))

(list 8 (foo 3))

;; Complete the evaluation for (list 8 (foo 3))

(list 8 (local [(define (bar y) (+ 3 y))]
          (+ 3 (bar (* 2 3)))))

(list 8 (local [(define (bar_1 y) (+ 3 y))]  ;renaming
          (+ 3 (bar_1 (* 2 3)))))

(define (bar_1 y) (+ 3 y))                   ;lift

(list 8 (local []
          (+ 3 (bar_1 (* 2 3)))))

(list 8 (+ 3 (bar_1 (* 2 3))))               ;replace with body

(list 8 (+ 3 (+ 3 (* 2 3))))

(list 8 (+ 3 (+ 3 6)))

(list 8 (+ 3 9))

(list 8 12)
