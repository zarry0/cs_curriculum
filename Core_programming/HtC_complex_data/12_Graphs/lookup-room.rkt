;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname lookup-room) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; lookup-room-starter.rkt

;
; PROBLEM:
;
; Using the following data definition, design a function that consumes a room and a room 
; name and tries to find a room with the given name starting at the given room.
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


;; Room String -> Room or false
;; produces the room with the given name, false if the room can't be reached
(check-expect (find-room H1 "B") (make-room "B" empty))
(check-expect (find-room H1 "A") (make-room "A" (list (make-room "B" empty))))
(check-expect (find-room H1 "C") false)
(check-expect (find-room H2 "C") false)
(check-expect (find-room H3 "C") (shared [(-A- (make-room "A" (list -B-)))
                                          (-B- (make-room "B" (list -C-)))
                                          (-C- (make-room "C" (list -A-)))] -C-))
(check-expect (find-room H4 "D") (shared [(-A- (make-room "A" (list -B- -D-)))
                                          (-B- (make-room "B" (list -C- -E-)))
                                          (-C- (make-room "C" (list -B-)))
                                          (-D- (make-room "D" (list -E-)))
                                          (-E- (make-room "E" (list -F- -A-)))
                                          (-F- (make-room "F" empty))] -D-))
(check-expect (find-room H4F "A") false)

;(define (find-room r n) false)  ;stub

(define (find-room r0 n)
  ;; todo    is (listof Room);   a worklist accumulator
  ;; visited is (listof String); the names of the visited rooms
  (local [(define (fn-room r todo visited)
            (cond [(string=? (room-name r) n) r]
                  [(member (room-name r) visited) (fn-lor todo visited)]
                  [else
                   (fn-lor (append (room-exits r) todo)
                           (cons (room-name r) visited))]))

          (define (fn-lor todo visited)
            (cond [(empty? todo) false]
                  [else
                   (fn-room (first todo) (rest todo) visited)]))]
    
    (fn-room r0 empty empty)))
