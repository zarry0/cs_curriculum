;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname all-reachable) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; all-reachable-starter.rkt

;
; PROBLEM:
;
; Using the following data definition:
;
; a) Design a function that consumes a room and produces a list of the names of
;    all the rooms reachable from that room.
;
; b) Revise your function from (a) so that it produces a list of the rooms
;    not the room names
;

;; Data Definitions: 

(define-struct room (name exits))
;; Room is (make-room String (listof Room))
;; interp. the room's name, and list of rooms that the exits lead to

;;  A ──► B

(define H1 (make-room "A" (list (make-room "B" empty))))

;;  ┌─────┐   
;;  ▼     │ 
;;  A ──► B

(define H2
  (shared [(-0- (make-room "A" (list (make-room "B" (list -0-)))))]
    -0-))
        
;;  A ───► B  
;;  ▲      │  
;;  └─ C ◄─┘

(define H3
  (shared [(-A- (make-room "A" (list -B-)))
           (-B- (make-room "B" (list -C-)))
           (-C- (make-room "C" (list -A-)))]
    -A-))

;;
;;           ┌─────┐
;;           ▼     │
;;  ┌► A ──► B ──► C
;;  │  │     │
;;  │  │     └─────┐
;;  │  │           ▼
;;  │  └───► D ──► E ──► F
;;  │              │
;;  └──────────────┘

(define H4
  (shared [(-A- (make-room "A" (list -B- -D-)))
           (-B- (make-room "B" (list -C- -E-)))
           (-C- (make-room "C" (list -B-)))
           (-D- (make-room "D" (list -E-)))
           (-E- (make-room "E" (list -F- -A-)))
           (-F- (make-room "F" empty))]
    -A-))

(define H4F
  (shared [(-A- (make-room "A" (list -B- -D-)))
           (-B- (make-room "B" (list -C- -E-)))
           (-C- (make-room "C" (list -B-)))
           (-D- (make-room "D" (list -E-)))
           (-E- (make-room "E" (list -F- -A-)))
           (-F- (make-room "F" empty))]
    -F-))

;; template: structural recursion, encapsulate w/ local, 
;;           context-preserving accumulator what rooms traversed on this path
#;
(define (fn-for-house r0)
  ;; path is (listof String); context preserving accumulator, names of rooms
  (local [(define (fn-for-room r  path) 
            (if (member (room-name r) path)
                (... path)
                (fn-for-lor (room-exits r) 
                            (cons (room-name r) path)))) 
          (define (fn-for-lor lor path)
            (cond [(empty? lor) (...)]
                  [else
                   (... (fn-for-room (first lor) path)
                        (fn-for-lor (rest lor) path))]))]
    (fn-for-room r0 empty)))

;; template: structural recursion, encapsulate w/ local, tail-recursive w/ worklist, 
;;           context-preserving accumulator what rooms have we already visited

(define (fn-for-house r0)
  ;; todo is (listof Room); a worklist accumulator
  ;; visited is (listof String); context preserving accumulator, names of rooms already visited
  (local [(define (fn-for-room r todo visited) 
            (if (member (room-name r) visited)
                (fn-for-lor todo visited)
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited)))) ; (... (room-name r))
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) (...)]
                  [else
                   (fn-for-room (first todo) 
                                (rest todo)
                                visited)]))]
    (fn-for-room r0 empty empty))) 


;; Room -> (listof String)
;; produces a list of all the room names reachable from r
(check-expect (all-reachable H1) (list "A" "B"))
(check-expect (all-reachable (first (room-exits H1))) (list "B"))
(check-expect (all-reachable (first (room-exits H2))) (list "B" "A"))
(check-expect (all-reachable H2) (list "A" "B"))
(check-expect (all-reachable H3) (list "A" "B" "C"))
(check-expect (all-reachable H4) (list "A" "B" "C" "E" "F" "D"))
(check-expect (all-reachable H4F) (list "F"))

;(define (all-reachable r) empty)  ;stub

(define (all-reachable r0)
  ;; todo    is (listof Room);   a worklist accumulator
  ;; visited is (listof String); context preserving accumulator, names of rooms already visited
  (local [(define (fn-for-room r todo visited)
            (cond [(member (room-name r) visited) (fn-for-lor todo visited)]
                  [else
                   (fn-for-lor (append (room-exits r) todo)
                               (append visited (list (room-name r))))]))

          (define (fn-for-lor todo visited)
            (cond [(empty? todo) visited]
                  [else
                   (fn-for-room (first todo) (rest todo) visited)]))]
    (fn-for-room r0 empty empty)))


;; Room -> (listof Room)
;; produces a list of all the rooms reachable from r
(check-expect (all-reachable-rooms H1) (shared [(-A- (make-room "A" (list -B-)))
                                                (-B- (make-room "B" empty))]
                                         (list -A- -B-)))
(check-expect (all-reachable-rooms H2) (shared [(-A- (make-room "A" (list -B-)))
                                                (-B- (make-room "B" (list -A-)))]
                                         (list -A- -B-)))
(check-expect (all-reachable-rooms H3) (shared [(-A- (make-room "A" (list -B-)))
                                                (-B- (make-room "B" (list -C-)))
                                                (-C- (make-room "C" (list -A-)))]
                                         (list -A- -B- -C-)))
(check-expect (all-reachable-rooms H4) (shared [(-A- (make-room "A" (list -B- -D-)))
                                                (-B- (make-room "B" (list -C- -E-)))
                                                (-C- (make-room "C" (list -B-)))
                                                (-D- (make-room "D" (list -E-)))
                                                (-E- (make-room "E" (list -F- -A-)))
                                                (-F- (make-room "F" empty))]
                                         (list -A- -B- -C- -E- -F- -D-)))
(check-expect (all-reachable-rooms H4F) (shared [(-F- (make-room "F" empty))]
                                          (list -F-)))

;(define (all-reachable-rooms r) empty)  ;stub

(define (all-reachable-rooms r0)
  ;; todo    is (listof Room); a worklist accumulator
  ;; visited is (listof Room); the list of all the rooms already visited
  (local [(define (fn-for-room r todo visited)
            (cond [(member r visited) (fn-for-lor todo visited)]
                  [else
                   (fn-for-lor (append (room-exits r) todo)
                               (append visited (list r)))]))

          (define (fn-for-lor todo visited)
            (cond [(empty? todo) visited]
                  [else
                   (fn-for-room (first todo) (rest todo) visited)]))]
    
    (fn-for-room r0 empty empty)))