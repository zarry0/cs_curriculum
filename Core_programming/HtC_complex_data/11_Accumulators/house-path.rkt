;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname house-path) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; house-path-starter.rkt

; Consider the following house diagram:
;
; ┌───  ──┬──────────┐
; │Porch  │ Living   │
; │          room    │
; │       │          │
; ├───────┤          │
; │Dining │          │
; │room              │
; │       ┌─  ┌──────┤
; │       │   │ Study│
; │       │          │
; │       │H  │      │
; ├─   ───┤a  ├──────┤
; │Kitchen│l  │ Bed- │
; │       │l    room │
; │       │   │      │
; │       │   ├──────┤
; │           │Bath- │
; │       │    room  │
; │       │   │      │
; └───────┴───┴──────┘
;
;
; Starting from the porch, there are many paths through the house that you can
; follow without retracing your steps.  If we represent these paths as lists:
; (list 
;  (list "Porch")
;  (list "Porch" "Living Room")
;  (list "Porch" "Living Room" "Hall")
;  ...)
;
; you can see that a lot of these paths start with the same sequence of rooms.
; We can represent these paths, and capture their shared initial parts, by using
; a tree:
;
;                              Porch
;                                │
;                                │
;                          Living Room
;                                │
;                      ┌─────────┴────────┐
;                      │                  │
;                Dining Room            Hall
;                      │                  │
;             ┌────────┘      ┌───────┬───┴───┬─────────┐
;             │               │       │       │         │
;             │            Kitchen  Study  Bedroom  Bathroom
;           Kitchen           │
;             │               │
;             │          Dining Room
;            Hall
;             │
;     ┌───────┼─────────┐
;     │       │         │
;   Study  Bedroom  Bathroom
;
;
; The following data definition does exactly this.
;
(define-struct path (room nexts))
;; Path is (make-path String (listof Path))
;; interp. An arbitrary-arity tree of paths.
;;  - (make-path room nexts) represents all the paths downward from room
(define P0 (make-path "A" empty)) ; a room from which there are no paths

(define PH 
  (make-path "Porch"
             (list 
              (make-path "Living Room"
                         (list (make-path "Dining Room"
                                          (list (make-path"Kitchen"
                                                          (list (make-path "Hall"
                                                                           (list (make-path "Study" (list))
                                                                                 (make-path "Bedroom" (list))
                                                                                 (make-path "Bathroom" (list))))))))
                               (make-path "Hall"
                                          (list (make-path "Kitchen"
                                                           (list (make-path "Dining Room" (list))))
                                                (make-path "Study" (list))
                                                (make-path "Bedroom" (list))
                                                (make-path "Bathroom" (list)))))))))
   
#;
(define (fn-for-path p)
  (local [(define (fn-for-path p)
            (... (path-room p)
                 (fn-for-lop (path-nexts p))))
          (define (fn-for-lop lop)
            (cond [(empty? lop) (...)]
                  [else
                   (... (fn-for-path (first lop))
                        (fn-for-lop (rest lop)))]))]
    (fn-for-path p)))



;; The problems below also make use of the following data definition and function:

;; Result is one of:
;; - Boolean
;; - "never"
;; interp. three possible answers to a question
(define R0 true)
(define R1 false)
(define R2 "never")

#;
(define (fn-for-result r)
  (cond 
    [(boolean? r) (... r)]
    [else (...)]))

;; Result Result -> Result
;; produce the logical combination of two results

; Cross Product of Types Table:
;
; ╔════════════════╦═══════════════╦══════════════╗
; ║                ║               ║              ║
; ║            r0  ║   Boolean     ║   "never"    ║
; ║                ║               ║              ║
; ║    r1          ║               ║              ║
; ╠════════════════╬═══════════════╬══════════════╣
; ║                ║               ║              ║
; ║   Boolean      ║ (and r0 r1)   ║              ║
; ║                ║               ║              ║
; ╠════════════════╬═══════════════╣  r1          ║
; ║                ║               ║              ║
; ║   "never"      ║  r0           ║              ║
; ║                ║               ║              ║
; ╚════════════════╩═══════════════╩══════════════╝
;

(check-expect (and-result false false) false)
(check-expect (and-result false true) false)
(check-expect (and-result false "never") false)
(check-expect (and-result true false) false)
(check-expect (and-result true true) true)
(check-expect (and-result true "never") true)
(check-expect (and-result "never" true) true)
(check-expect (and-result "never" false) false)
(check-expect (and-result "never" "never") "never")

(define (and-result r0 r1)
  (cond [(and (boolean? r0) (boolean? r1)) (and r0 r1)]
        [(string? r0) r1]
        [else r0]))

(define (or-result r0 r1)
  (cond [(and (boolean? r0) (boolean? r1)) (or r0 r1)]
        [(string? r0) r1]
        [else r0]))

;
; PROBLEM 1:   
;
; Design a function called always-before that takes a path tree p and two room
; names b and c, and determines whether starting from p:
;  1) you must pass through room b to get to room c (produce true),
;  2) you can get to room c without passing through room b (produce false), or
;  3) you just can't get to room c (produce "never").
;
; Note that if b and c are the same room, you should produce false since you don't
; need to pass through the room to get there.
;

;; Path String String -> Result
;; starting from p, produces:
;;  - true if you must pass through b to get to c
;;  - false if you can get to c without passing b or if b and c are the same room
;;  - "never" if you can't get to c
(check-expect (always-before PH "Porch" "Living Room") true)
(check-expect (always-before PH "Dining Room" "Bedroom") true)
(check-expect (always-before PH "Hall" "Porch") false)
(check-expect (always-before PH "Hall" "Kitchen") true)
(check-expect (always-before PH "Kitchen" "Hall") true)
(check-expect (always-before PH "Dining Room" "Hall") true)
(check-expect (always-before PH "Hall" "Dining Room") true)
(check-expect (always-before PH "Dining Room" "Porch") false)
(check-expect (always-before PH "Dining Room" "Dining Room") false)
(check-expect (always-before PH "Dining Room" "Bathroom") true)
(check-expect (always-before PH "Living Room" "Bathroom") true)
(check-expect (always-before PH "Bedroom" "Bathroom") false)
(check-expect (always-before PH "Porch" "Guest Room") "never")

;(define (always-before p b c) false)  ;stub

(define (always-before p b c)
  ;; flag is Boolean; true if it has passed through b, false otherwise
  (local [(define (fn-for-path p flag)
            (cond [(string=? (path-room p) c) flag]
                  [else
                   (fn-for-lop (path-nexts p) (or (string=? (path-room p) b) flag))]))

          (define (fn-for-lop lop flag)
            (cond [(empty? lop) "never"]
                  [else
                   (or-result (fn-for-path (first lop) flag)
                              (fn-for-lop  (rest lop)  flag))]))]

    (fn-for-path p false)))

;
; OPTIONAL EXTRA PRACTICE PROBLEM:
;
; Once you have always-before working, make a copy of it, rename the copy to
; always-before-tr, and then modify the function to be tail recursive.
;

(check-expect (always-before-tr PH "Porch" "Living Room") true)
(check-expect (always-before-tr PH "Dining Room" "Bedroom") true)
(check-expect (always-before-tr PH "Hall" "Porch") false)
(check-expect (always-before-tr PH "Hall" "Kitchen") true)
(check-expect (always-before-tr PH "Kitchen" "Hall") true)
(check-expect (always-before-tr PH "Dining Room" "Hall") true)
(check-expect (always-before-tr PH "Hall" "Dining Room") true)
(check-expect (always-before-tr PH "Dining Room" "Porch") false)
(check-expect (always-before-tr PH "Dining Room" "Dining Room") false)
(check-expect (always-before-tr PH "Dining Room" "Bathroom") true)
(check-expect (always-before-tr PH "Living Room" "Bathroom") true)
(check-expect (always-before-tr PH "Bedroom" "Bathroom") false)
(check-expect (always-before-tr PH "Porch" "Guest Room") "never")

;(define (always-before-tr p b c) false)  ;stub

(define (always-before-tr p b c)
  ;;  todo is (listof (listof Path & Boolean)); the next nodes to visit.
  ;;   - (first (first todo)) is the Path and (second (first todo)) indicates whether room b has been passed

  ;; flag is Boolean; indicates whether room b has been passed
  ;; rsf is Result; the result so far

  ;; Description:
  ;; Performs a Depth-first search on the tree.
  ;;
  ;; Given a path, if it's room c the result will depend on whether room b has been passed;
  ;; in either case, it will check the rest of the nodes in the worklist accumulator and
  ;; will set the result-so-far (rsf) to be "(or-result flag rsf)"
  ;; this way true will have the highest priority, followed by false and then "never."
  ;;
  ;; If the current path is not room c, it adds the path's children to the todo accumulator,
  ;; and for each child, it adds a "flag" parameter that indicates if room b has been found up until that node.
  ;;
  ;; And for each of the nodes in todo, we check if it is room c, and based on that node's flag, we determine the result.
  (local [(define (fn-for-path p todo flag rsf)
            (cond [(string=? (path-room p) c) (fn-for-lop todo (or-result flag rsf))]
                  [(string=? (path-room p) b)
                   (fn-for-lop (append (map (lambda (x) (list x true)) (path-nexts p)) todo) rsf)]
                  [else
                   (fn-for-lop (append (map (lambda (x) (list x flag)) (path-nexts p)) todo) rsf)]))

          (define (fn-for-lop todo rsf)
            (cond [(empty? todo) rsf]
                  [else
                   (fn-for-path (first (first todo)) (rest todo) (second (first todo)) rsf)]))]
    

    (fn-for-path p empty false "never")))


