;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname max-exits-from) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; max-exits-from-starter.rkt

;
; PROBLEM:
;
; Using the following data definition, design a function that produces the room with the most exits 
; (in the case of a tie you can produce any of the rooms in the tie).
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

;; Room -> Room
;; produces the room with the most exits
(check-expect (max-exits-from H1) H1)
(check-expect (max-exits-from H2) (shared [(-A- (make-room "A" (list -B-)))
                                           (-B- (make-room "B" (list -A-)))]    -B-))
(check-expect (max-exits-from H3) (shared [(-A- (make-room "A" (list -B-)))
                                           (-B- (make-room "B" (list -C-)))
                                           (-C- (make-room "C" (list -A-)))]    -C-))
(check-expect (max-exits-from H4) (shared [(-A- (make-room "A" (list -B- -D-)))
                                           (-B- (make-room "B" (list -C- -E-)))
                                           (-C- (make-room "C" (list -B-)))
                                           (-D- (make-room "D" (list -E-)))
                                           (-E- (make-room "E" (list -F- -A-)))
                                           (-F- (make-room "F" empty))]         -E-))

;(define (max-exits-from r) r)  ;stub

(define (max-exits-from r0)
  ;; todo    is (listof Room);       a worklist accumulator
  ;; visited is (listof String);     context preserving accumulator, names of rooms already visited
  ;; winner  is (list Room Natural); a list with the room with the most exits so far, and its number of exits
  (local [(define (fn-room r todo visited winner)
            (cond [(member (room-name r) visited) (fn-lor todo visited winner)]
                  [(<= (second winner) (length (room-exits r))) (fn-lor (append (room-exits r) todo)
                                                                        (cons (room-name r) visited)
                                                                        (list r (length (room-exits r))))]
                  [else
                   (fn-lor (append (room-exits r) todo)
                           (cons (room-name r) visited)
                           winner)]))

          (define (fn-lor todo visited winner)
            (cond [(empty? todo) (first winner)]
                  [else
                   (fn-room (first todo) (rest todo) visited winner)]))]
    
    (fn-room r0 empty empty (list r0 (length (room-exits r0))))))