;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname count-rooms) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; count-rooms-starter.rkt

;
; PROBLEM:
;
; Using the following data definition, design a function that consumes a room and produces 
; the total number of rooms reachable from the given room. Include the starting room itself. 
; Your function should be tail recursive, but you should not use the primitive length function.
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
;;  └──C◄──┘
(define H3
  (shared [(-0- (make-room "A"
                           (list (make-room "B"
                                            (list (make-room "C" (list -0-)))))))]
    -0-))

(define H3.
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

;; template: structural recursion, encapsulate w/ local, tail-recursive w/ worklist, 
;;           context-preserving accumulator what rooms have we already visited
#;
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

;; Room -> Natural
;; produces the number of rooms reachable from the given room (inclusive)
(check-expect (count-rooms H1) 2)
(check-expect (count-rooms H2) 2)
(check-expect (count-rooms H3) 3)
(check-expect (count-rooms H4) 6)
(check-expect (count-rooms H4F) 1)

;(define (count-rooms r) 0)  ;stub

(define (count-rooms r0)
  ;; todo    is (listof Room);   a worklist accumulator
  ;; visited is (listof String); the names of the rooms already visited
  ;; count   is Natural;         the amount of rooms visited
  (local [(define (count-room r todo visited count)
            (cond [(member (room-name r) visited) (count-exits todo visited count)]
                  [else
                   (count-exits (append (room-exits r) todo)
                                (cons (room-name r) visited)
                                (add1 count))]))

          (define (count-exits todo visited count)
            (cond [(empty? todo) count]
                  [else
                   (count-room (first todo) (rest todo) visited count)]))]
    
    (count-room r0 empty empty 0)))