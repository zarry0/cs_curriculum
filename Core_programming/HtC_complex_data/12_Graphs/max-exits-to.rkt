;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname max-exits-to) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; max-exits-to-starter.rkt

;
; PROBLEM:
;
; Using the following data definition, design a function that produces the room to which the greatest 
; number of other rooms have exits (in the case of a tie you can produce any of the rooms in the tie).
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

;; Room -> Room
;; produces the room to which the greatest number of other rooms have exits
;; ASSUME: the given house will have at least 1 room with at least 1 exit
(check-expect (max-exits-to H1) (first (room-exits H1)))
(check-expect (max-exits-to H2) H2)
(check-expect (max-exits-to H3) (shared [(-A- (make-room "A" (list -B-)))
                                         (-B- (make-room "B" (list -C-)))
                                         (-C- (make-room "C" (list -A-)))] -A-))
(check-expect (max-exits-to H4) (shared [(-A- (make-room "A" (list -B- -D-)))
                                         (-B- (make-room "B" (list -C- -E-)))
                                         (-C- (make-room "C" (list -B-)))
                                         (-D- (make-room "D" (list -E-)))
                                         (-E- (make-room "E" (list -F- -A-)))
                                         (-F- (make-room "F" empty))]      -E-))

;(define (max-exits-to r) r)  ;stub

(define (max-exits-to r0)
  ;; Auxiliar Data definition:
  ;;   ExitCount is (list Room Natural)
  ;;   interp. a list with a room and the number of exits leading to that room 
          
  ;; todo      is (listof Room)      ; a worklist accumulator
  ;; visited   is (listof String)    ; names of rooms already visited
  ;; counts    is (listof ExitCount) ; a list of all the reachable rooms
  ;;                                   and the number of times it has appeared as another room's exit
  (local [(define (fn-room r todo visited counts)
            (cond [(member (room-name r) visited) (fn-lor todo visited counts)]
                  [else
                   (fn-lor (append (room-exits r) todo)
                           (cons (room-name r) visited)
                           (foldl count-exits counts (room-exits r)))]))

          (define (fn-lor todo visited counts)
            (cond [(empty? todo) (max-exits counts)]
                  [else
                   (fn-room (first todo) (rest todo) visited counts)]))

          ;; Room (listof ExitCount) -> (listof ExitCount)
          ;; adds or updates the list of rooms and the number of times it has appeared as another room's exit
          (define (count-exits r count0)
            ;; prevs is (listof Exits-Count); the already seen items in count
            (local [(define (fn count prevs)
                      (cond [(empty? count) (cons (list r 1) count0)]
                            [(string=? (room-name (first (first count))) (room-name r))
                             (append prevs
                                     (list (list r (add1 (second (first count)))))
                                     (rest count))]
                            [else
                             (fn (rest count) (cons (first count) prevs))]))]
              (fn count0 empty)))

          ;; (listof ExitCount) -> Room
          ;; produces the room with the highest count
          ;; ASSUME: the list of counts will not be empty
          (define (max-exits count0)
            (local [(define (max-exits count max) 
                      (cond [(empty? count) (first max)]
                            [(> (second (first count)) (second max)) (max-exits (rest count) (first count))]
                            [else
                             (max-exits (rest count) max)]))]
              (max-exits count0 (first count0))))]
    
    (fn-room r0 empty empty empty)))