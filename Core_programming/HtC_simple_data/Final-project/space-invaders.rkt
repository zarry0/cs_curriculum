;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders

;; ================
;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define INVADER-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 80)

(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define SCORE-BOARD (rectangle WIDTH 50 "solid" "black"))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT (image-height TANK))
(define TANK-HEIGHT/2 (/ (image-height TANK) 2))
(define TANK-WIDTH/2  (/ (image-width  TANK) 2))
(define TANK-Y (- HEIGHT TANK-HEIGHT/2))

(define INVADER-WIDTH/2 (/ (image-width INVADER) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))
(define MISSILE-Y0 (+ TANK-HEIGHT 10))

(define FONT-SIZE 14)
(define FONT-SIZE-SMALL 12)
(define FONT-COLOR "white")



;; ====================
;; Data Definitions:


(define-struct game (invaders missiles tank score status))
;; Game is (make-game  (listof Invader) (listof Missile) Tank Natural Status)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles, tank position, current score and game status

;; Game constants defined below Status data definition

#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))
       (game-score s)
       (fn-for-status (game-status s))))



(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))



(define-struct invader (x y dir))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         dir means right if is +1 of left if -1

(define I1 (make-invader 150 100 +1))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -1))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) +1)) ;> landed, moving right


#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dir invader)))


(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                       ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))



;; Status is one of:
;;  - false
;;  - "playing"
;;  - "game over"
;; interp. the current status of the game, where:
;;         false       means the game is yet to begin
;;         "playing"   means the player is playing the game
;;         "game over" means the player lost the game

;; <examples are redundant for enumerations>
#;
(define (fn-for-status s)
  (cond [(false? s) (...)]
        [(string=? "playing" s) (...)]
        [(string=? "game over" s) (...)]))



(define G0 (make-game empty empty T0 0 false))
(define G1 (make-game empty empty T1 0 "playing"))
(define G2 (make-game (list I1) (list M1) T1 5 "playing"))
(define G3 (make-game (list I1 I2) (list M1 M2) T1 12 "game over"))

(define START-GAME (make-game empty empty T0 0 "playing"))



;; =================
;; Functions:


;; Game -> Game
;; start the world with (main (make-game empty empty T0 0 false))
;; <no tests for main>

(define (main g)
  (big-bang g               ; Game
    (on-tick tock)          ; Game -> Game
    (to-draw render)        ; Game -> Image
    (on-key  handle-key)))  ; Game KeyEvent -> Game


;; ==============
;; Tock function
;; ==============

;; Game -> Game
;; produce the next game state if the game status is "playing" 
(check-expect (tock (make-game empty empty T0 0 false)) (make-game empty empty T0 0 false))                     ; game not started
(check-expect (tock (make-game (list I1) (list M1) T1 50 false)) (make-game (list I1) (list M1) T1 50 false))   ; game not started

;<no tests for "playing" status, each procedure is tested individualy in their respective function>

(check-expect (tock (make-game empty empty T0 0 "game over")) (make-game empty empty T0 0 "game over"))                                ;game over
(check-expect (tock (make-game (list I1) (list M1) T1 50 "game over")) (make-game (list I1) (list M1) T1 50 "game over"))              ;game over
(check-expect (tock (make-game (list I1 I2) (list M1 M2) T1 12 "game over")) (make-game (list I1 I2) (list M1 M2) T1 12 "game over"))  ;game over

;(define (tock g) g)  ;stub

(define (tock g)
  (cond [(false?   (game-status g))               g]
        [(string=? (game-status g)  "game over" ) g]
        [else
         (make-game (control-invaders g)
                    (manage-missiles g)
                    (move-tank (game-tank g))
                    (keep-score g)
                    (change-status g))]))


;; Game -> ListOfInvader
;; handles the invader spawning, movement and collisions
(check-random (control-invaders (make-game empty empty T0 0 "playing")) (if (= (random INVADE-RATE) 10)
                                                                            (list (make-invader (random WIDTH) 0 +1))
                                                                            empty))
(check-random (control-invaders (make-game (list I1) empty T0 0 "playing")) (if (= (random INVADE-RATE) 10)
                                                                                (list (make-invader (random WIDTH) 0 +1)
                                                                                      (make-invader (+ 150 (* INVADER-SPEED +1))
                                                                                                    (+ 100 INVADER-SPEED) +1))
                                                                                (list (make-invader (+ 150 (* INVADER-SPEED +1))
                                                                                                    (+ 100 INVADER-SPEED) +1))))
(check-random (control-invaders (make-game (list (make-invader WIDTH 50 +1))
                                           empty T0 0 "playing")) (if (= (random INVADE-RATE) 10)
                                                                      (list (make-invader (random WIDTH) 0 +1)
                                                                            (make-invader WIDTH 50 -1))
                                                                      (list (make-invader WIDTH 50 -1)))) ;bounce right
(check-random (control-invaders (make-game (list (make-invader 0 50 -1))
                                           empty T0 0 "playing")) (if (= (random INVADE-RATE) 10)
                                                                      (list (make-invader (random WIDTH) 0 1)
                                                                            (make-invader 0 50 1))
                                                                      (list (make-invader 0 50 1))))      ;bounce left
;<test for collisions in it's own function>

;(define (control-invaders g) empty)  ;stub 

(define (control-invaders g) 
  (spawn-invaders (move-invaders (destroy-invaders (game-invaders g) (game-missiles g)))))
  

;; ListOfInvader -> ListOfInvader
;; creates a new invader randomly at a random place on the top of the screen
(check-random (spawn-invaders empty) (if (= (random INVADE-RATE) 10)
                                         (list (make-invader (random WIDTH) 0 1))
                                         empty))
(check-random (spawn-invaders (list I1)) (if (= (random INVADE-RATE) 10)
                                             (list (make-invader (random WIDTH) 0 1) I1)
                                             (list I1)))

;(define (spawn-invaders loi) loi)  ;stub

(define (spawn-invaders loi)
  (if (= (random INVADE-RATE) 10)
      (cons (make-invader (random WIDTH) 0 +1) loi)
      loi)) 

;; ListOfInvader -> ListOfInvader
;; moves the invaders at 45 degrees downwards, if they hit a wall, bounce them
(check-expect (move-invaders empty) empty)
(check-expect (move-invaders (list I1)) (list (make-invader (+ 150 (* INVADER-SPEED +1)) (+ 100 INVADER-SPEED) +1)))
(check-expect (move-invaders (list (make-invader WIDTH 50 +1))) (list (make-invader WIDTH 50 -1)))
(check-expect (move-invaders (list (make-invader WIDTH 50 -1))) (list (make-invader (+ WIDTH (* INVADER-SPEED -1)) (+ 50 INVADER-SPEED) -1)))
(check-expect (move-invaders (list (make-invader 0 50 -1))) (list (make-invader 0 50 +1)))
(check-expect (move-invaders (list (make-invader 0 50 +1))) (list (make-invader (+ 0 INVADER-SPEED) (+ 50 INVADER-SPEED) +1)))

;(define (move-invaders loi) loi)  ;stub

(define (move-invaders loi)
  (cond [(empty? loi) empty]
        [else
         (cons (move-invader (first loi))
               (move-invaders (rest loi)))]))

;; Invader -> Invader
;; produces the same invader but moved at 45º at INVADER-SPEED
;; if it hits a wall changes it's x direction
(check-expect (move-invader I1) (make-invader (+ 150 (* INVADER-SPEED +1)) (+ 100 INVADER-SPEED) +1))
(check-expect (move-invader (make-invader WIDTH 50 +1)) (make-invader WIDTH 50 -1))
(check-expect (move-invader (make-invader WIDTH 50 -1)) (make-invader (+ WIDTH (* INVADER-SPEED -1)) (+ 50 INVADER-SPEED) -1))
(check-expect (move-invader (make-invader 0 50 -1)) (make-invader 0 50 +1))
(check-expect (move-invader (make-invader 0 50 +1)) (make-invader (+ 0 INVADER-SPEED) (+ 50 INVADER-SPEED) +1))
 
;(define (move-invader i) i)  ;stub

(define (move-invader i)
  (cond [(and (<= (invader-x i)     0) (= (invader-dir i) -1)) (make-invader     0 (invader-y i) +1)]
        [(and (>= (invader-x i) WIDTH) (= (invader-dir i) +1)) (make-invader WIDTH (invader-y i) -1)]
        [else
         (make-invader (+ (invader-x i) (* (invader-dir i) INVADER-SPEED))
                       (+ (invader-y i) INVADER-SPEED)
                       (invader-dir i))]))

;; ListOfInvader ListOfMissile -> ListOfInvader
;; checks for collisions and removes the invaders that where hit
;; a collision occurs  when a missile (x, y) is within +-HIT-RANGE pixels from an invader (x,y)
(check-expect (destroy-invaders empty empty) empty)
(check-expect (destroy-invaders empty (list M1)) empty)
(check-expect (destroy-invaders (list I1) empty) (list I1))
(check-expect (destroy-invaders (list I1) (list M1)) (list I1))
(check-expect (destroy-invaders (list I1 (make-invader 50 360 +1)) (list M1 (make-missile 50 360))) (list I1))
(check-expect (destroy-invaders (list I1 (make-invader 50 360 +1)) (list M1 (make-missile 49 359))) (list I1))
(check-expect (destroy-invaders (list I1 (make-invader 50 360 +1)) (list M1 (make-missile 59 369))) (list I1))
(check-expect (destroy-invaders (list I1 (make-invader 50 360 +1)) (list M1 (make-missile 45 355))) (list I1))
(check-expect (destroy-invaders (list I1 (make-invader 50 360 +1)) (list M1 (make-missile 55 365))) (list I1))

;(define (destroy-invaders loi lom) loi)  ;stub

(define (destroy-invaders loi lom)
  (cond [(empty? loi) empty]
        [else
         (if (invader-hit? (first loi) lom)
             (destroy-invaders (rest loi) lom)
             (cons (first loi) (destroy-invaders (rest loi) lom)))]))

;; Invader ListOfMissile -> Boolean
;; produces true if the invader were hit by any of the missiles on the list
;; a collision occurs  when a missile (x, y) is within +-HIT-RANGE pixels from an invader (x,y)
(check-expect (invader-hit? I1 empty) false)
(check-expect (invader-hit? I1 (list M1)) false)
(check-expect (invader-hit? (make-invader 50 360 +1) (list M1 (make-missile 50 360))) true)
(check-expect (invader-hit? (make-invader 50 360 +1) (list M1 (make-missile 49 359))) true)
(check-expect (invader-hit? (make-invader 50 360 +1) (list M1 (make-missile 59 369))) true)
(check-expect (invader-hit? (make-invader 50 360 +1) (list M1 (make-missile 45 355))) true)
(check-expect (invader-hit? (make-invader 50 360 +1) (list M1 (make-missile 55 365))) true)

;(define (invader-hit? i lom) false)  ;stub

(define (invader-hit? i lom)
  (cond [(empty? lom) false]
        [else
         (if (in-range? (first lom) i)
             true
             (invader-hit? i (rest lom)))]))


;; Tank -> Tank
;; moves the tank in the correct direction at TANK-SPEED
(check-expect (move-tank T1) (make-tank (+ 50 (*  1 TANK-SPEED)) 1))
(check-expect (move-tank T2) (make-tank (+ 50 (* -1 TANK-SPEED)) -1))
(check-expect (move-tank (make-tank (- WIDTH TANK-WIDTH/2) 1)) (make-tank (- WIDTH TANK-WIDTH/2) 1))
(check-expect (move-tank (make-tank TANK-WIDTH/2 -1)) (make-tank TANK-WIDTH/2 -1))

;(define (move-tank t) t)  ;stub

(define (move-tank t)
  (make-tank (contain-tank (tank-x t) (tank-dir t))
             (tank-dir t)))

;; Number[TANK-WIDTH/2, (WIDTH - TANK-WIDTH/2)] Integer[1, -1] -> Number[TANK-WIDTH/2, (WIDTH - TANK-WIDTH/2)]
;; updates the x coord of the tank by TANK-SPEED and checks that the tank remains onscreen at all times
(check-expect (contain-tank 50  1) (+ 50 (*  1 TANK-SPEED)))
(check-expect (contain-tank 50 -1) (+ 50 (* -1 TANK-SPEED)))
(check-expect (contain-tank (- WIDTH TANK-WIDTH/2) 1) (- WIDTH TANK-WIDTH/2))
(check-expect (contain-tank TANK-WIDTH/2 -1) TANK-WIDTH/2)

;(define (contain-tank x dir) x)  ;stub

(define (contain-tank x dir)
  (cond [(and (>= x (- WIDTH TANK-WIDTH/2)) (= dir  1)) (- WIDTH TANK-WIDTH/2)]
        [(and (<= x TANK-WIDTH/2)           (= dir -1)) TANK-WIDTH/2]
        [else (+ x (* dir TANK-SPEED))]))


;; Game -> ListOfMissile
;; moves each missile up and removes missiles out of the screen and missiles that hit an invader
(check-expect (manage-missiles G1) empty)
(check-expect (manage-missiles (make-game empty (list (make-missile 100 354)) T1 5 "playing")) (list (make-missile 100 (- 354 MISSILE-SPEED))))
(check-expect (manage-missiles (make-game empty (list (make-missile 100 354)
                                                      (make-missile 65 480)) T1 5 "playing")) (list (make-missile 100 (- 354 MISSILE-SPEED))
                                                                                                    (make-missile 65 (- 480 MISSILE-SPEED))))
(check-expect (manage-missiles (make-game empty (list (make-missile 100 354)
                                                      (make-missile 65 0)) T1 5 "playing")) (list (make-missile 100 (- 354 MISSILE-SPEED))))
;<test for collisions in it's own function>

;(define (manage-missiles g) empty)  ;stub

(define (manage-missiles g)
  (filter-missiles (move-missiles (remove-collisions (game-invaders g) (game-missiles g)))))
  
;; ListOfMissile -> ListOfMissile
;; decreases each missile y coord by MISSILE-SPEED
(check-expect (move-missiles empty) empty)
(check-expect (move-missiles (list (make-missile 100 354))) (list (make-missile 100 (- 354 MISSILE-SPEED))))
(check-expect (move-missiles (list (make-missile 100 354)
                                   (make-missile 65 480))) (list (make-missile 100 (- 354 MISSILE-SPEED))
                                                                 (make-missile 65 (- 480 MISSILE-SPEED))))
(check-expect (move-missiles (list (make-missile 100 354)
                                   (make-missile 65 0))) (list (make-missile 100 (- 354  MISSILE-SPEED))
                                                               (make-missile  65 (- 0 MISSILE-SPEED))))

;(define (move-missiles lom) lom)  ;stub

(define (move-missiles lom)
  (cond [(empty? lom) empty]
        [else
         (cons (move-missile (first lom))
               (move-missiles (rest lom)))]))

;; Missile -> Missile
;; decreases missile y coord by MISSILE-SPEED
(check-expect (move-missile (make-missile 10 30)) (make-missile 10 (- 30 MISSILE-SPEED)))

;(define (move-missile m) m)  ;stub

(define (move-missile m)
  (make-missile (missile-x m)
                (- (missile-y m) MISSILE-SPEED)))

;; ListOfInvader ListOfMissile -> ListOfMissile
;; deletes every missile that collides with an invader
;; a collision occurs  when a missile (x, y) is within +-HIT-RANGE pixels from an invader (x,y)
(check-expect (remove-collisions empty empty) empty)
(check-expect (remove-collisions (list I1) empty) empty)
(check-expect (remove-collisions empty (list M1)) (list M1))
(check-expect (remove-collisions (list I1) (list M1)) (list M1))
(check-expect (remove-collisions (list I1 (make-invader 50 360 +1)) (list M1 (make-missile 50 360))) (list M1))
(check-expect (remove-collisions (list I1 (make-invader 50 360 +1)) (list M1 (make-missile 49 359))) (list M1))
(check-expect (remove-collisions (list I1 (make-invader 50 360 +1)) (list M1 (make-missile 59 369))) (list M1))
(check-expect (remove-collisions (list I1 (make-invader 50 360 +1)) (list M1 (make-missile 45 355))) (list M1))
(check-expect (remove-collisions (list I1 (make-invader 50 360 +1)) (list M1 (make-missile 55 365))) (list M1))


;(define (remove-collisions loi lom) lom)  ;stub

(define (remove-collisions loi lom)
  (cond [(empty? lom) empty]
        [else
         (if (missile-hit? (first lom) loi)
             (remove-collisions loi (rest lom))
             (cons (first lom) (remove-collisions loi (rest lom))))]))

;; Missile ListOfInvader -> Boolean
;; produces true if the missile hit any of the invaders on the list
;; a collision occurs  when a missile (x, y) is within +-HIT-RANGE pixels from an invader (x,y)
(check-expect (missile-hit? M1 empty) false)
(check-expect (missile-hit? M1 (list I1)) false)
(check-expect (missile-hit? (make-missile 50 360) (list I1 (make-invader 50 360 +1))) true)
(check-expect (missile-hit? (make-missile 49 359) (list I1 (make-invader 50 360 +1))) true)
(check-expect (missile-hit? (make-missile 59 369) (list I1 (make-invader 50 360 +1))) true)
(check-expect (missile-hit? (make-missile 45 355) (list I1 (make-invader 50 360 +1))) true)
(check-expect (missile-hit? (make-missile 55 365) (list I1 (make-invader 50 360 +1))) true)

;(define (missile-hit? m loi) false)  ;stub

(define (missile-hit? m loi)
  (cond [(empty? loi) false]
        [else
         (if (in-range? m (first loi))
             true
             (missile-hit? m (rest loi)))]))

;; Missile Invader -> Boolean
;; produces true if the missile hit the invader
;; to be in range means that the missile (x,y) is within +-HIT-RANGE pixels from the invader (x,y)
(check-expect (in-range? (make-missile 10 30) (make-invader 100 300 +1)) false)  ; out of range
(check-expect (in-range? (make-missile 10 30) (make-invader  21  31 +1)) false)  ; barely out of range
(check-expect (in-range? (make-missile 10 30) (make-invader  20  40 -1))  true)  ; barely in range
(check-expect (in-range? (make-missile 10 30) (make-invader   0  20 -1))  true)  ; barely in range
(check-expect (in-range? (make-missile 10 30) (make-invader  15  25 +1))  true)  ; in range
(check-expect (in-range? (make-missile 10 30) (make-invader   5  35 +1))  true)  ; in range
(check-expect (in-range? (make-missile 10 30) (make-invader  10  30 -1))  true)  ; in range

;(define (in-range? m i) false)  ;stub

(define (in-range? m i)
  (and (<= (abs (- (invader-x i) (missile-x m))) HIT-RANGE)
       (<= (abs (- (invader-y i) (missile-y m))) HIT-RANGE)))

;; ListOfMissile -> ListOfMissile
;; removes every missile that gets out of the screen (y <= 0)
(check-expect (filter-missiles empty) empty)
(check-expect (filter-missiles (list (make-missile 52 480))) (list (make-missile 52 480)))
(check-expect (filter-missiles (list (make-missile 285 320) (make-missile 150 0))) (list (make-missile 285 320)))
(check-expect (filter-missiles (list (make-missile 187 68) (make-missile 89 -3))) (list (make-missile 187 68)))

;(define (filter-missiles lom) lom)  ;stub

(define (filter-missiles lom)
  (cond [(empty? lom) empty]
        [else
         (if (on-screen? (first lom))
             (cons (first lom) (filter-missiles (rest lom)))
             (filter-missiles (rest lom)))]))

;; Missile -> Boolean
;; produces true if y > 0
(check-expect (on-screen? (make-missile 50 50)) true)
(check-expect (on-screen? (make-missile 62 0)) false)
(check-expect (on-screen? (make-missile 95 -5)) false)

;(define (on-screen? m) false)  ;stub

(define (on-screen? m)
  (> (missile-y m) 0))

;; Game -> Status
;; checks if any invader landed and if so, produces "game over"
(check-expect (change-status (make-game empty empty T0 0 "playing")) "playing")
(check-expect (change-status (make-game (list I1) (list M1) T0 0 "playing")) "playing")
(check-expect (change-status (make-game (list I2) (list M1 M2) T0 0 "playing")) "game over")
(check-expect (change-status (make-game (list I1 I3) (list M1 M2) T0 0 "playing")) "game over")

;(define (change-status g) "playing")  ;stub

(define (change-status g)
  (if (game-over? (game-invaders g))
      "game over"
      (game-status g)))

;; ListOfInvader -> Boolean
;; produces true if any of the invaders landed
(check-expect (game-over? empty) false)
(check-expect (game-over? (list I1)) false)
(check-expect (game-over? (list I1 I2)) true)
(check-expect (game-over? (list I3 I1)) true)

;(define (game-over? loi) false)  ;stub

(define (game-over? loi)
  (cond [(empty? loi) false]
        [else
         (if (landed? (first loi))
             true
             (game-over? (rest loi)))]))

;; Invader -> Boolean
;; produces true if the invader landed (y >= HEIGHT)
(check-expect (landed? I1) false)
(check-expect (landed? I2) true)
(check-expect (landed? I3) true)

;(define (landed? i) false)  ;stub

(define (landed? i)
  (>= (invader-y i) HEIGHT))

;; Game -> Natural
;; increases the score by 1 each time a invader is destroyed
(check-expect (keep-score (make-game empty empty T0 0 "playing")) 0)
(check-expect (keep-score (make-game (list I1) (list M1) T0 5 "playing")) 5)
(check-expect (keep-score (make-game (list I1) (list M1 M2) T0 5 "playing")) 6)

;(define (keep-score g) 0)  ;stub

(define (keep-score g)
  (+ (count-collisions (game-invaders g) (game-missiles g)) (game-score g)))

;; ListOfInvader ListOfMissile -> Natural
;; counts how many missiles hit an invader
(check-expect (count-collisions empty empty) 0)
(check-expect (count-collisions empty (list M1)) 0)
(check-expect (count-collisions (list I1) empty) 0)
(check-expect (count-collisions (list I1) (list M1)) 0)
(check-expect (count-collisions (list I1) (list M2)) 1)
(check-expect (count-collisions (list I1 (make-invader 50 50 1)) (list M1 (make-missile 55 50) M2)) 2)

;(define (count-collisions loi lom) 0)  ;stub

(define (count-collisions loi lom)
  (cond [(empty? lom) 0]
        [else
         (if (missile-hit? (first lom) loi)
             (add1 (count-collisions loi (rest lom)))
             (count-collisions loi (rest lom)))]))

;; ==============
;; Render function
;; ==============

;; Game -> Image
;; render the game scene onscreen, and the score board on the top of the screen
(check-expect (render G0) (above (render-score-board G0)
                                 (place-image TANK (tank-x T0) TANK-Y BACKGROUND)))
(check-expect (render G1) (above (render-score-board G1)
                                 (place-image TANK (tank-x T1) TANK-Y BACKGROUND)))
(check-expect (render G2) (above (render-score-board G2)
                                 (place-image INVADER 150 100
                                              (place-image MISSILE 150 300
                                                           (place-image TANK (tank-x T1) TANK-Y BACKGROUND)))))
(check-expect (render G3) (above (render-score-board G3)
                                 (place-image INVADER 150 100
                                              (place-image INVADER 150 HEIGHT 
                                                           (place-image MISSILE 150 300
                                                                        (place-image MISSILE (invader-x I1) (+ (invader-y I1) 10)
                                                                                     (place-image TANK (tank-x T1) TANK-Y BACKGROUND)))))))

;(define (render g) empty-image)  ;stub

(define (render g)
  (above (render-score-board g)
         (render-scene g)))

;; Game -> Image
;; renders the current score and the game status
(check-expect (render-score-board G0) (overlay (text "Press space to play" FONT-SIZE FONT-COLOR) SCORE-BOARD))
(check-expect (render-score-board G1) (overlay (text "0" FONT-SIZE FONT-COLOR) SCORE-BOARD))
(check-expect (render-score-board G2) (overlay (text "5" FONT-SIZE FONT-COLOR) SCORE-BOARD))
(check-expect (render-score-board G3) (overlay (above (text "Game Over. You scored 12" FONT-SIZE FONT-COLOR)
                                                      (text "Press space to play again" FONT-SIZE-SMALL FONT-COLOR)) SCORE-BOARD))


;(define (render-score-board g) SCORE-BOARD)  ;stub

(define (render-score-board g)
  (overlay (render-text (game-status g) (game-score g))
           SCORE-BOARD))

;; Status Natural -> Image
;; produces the text for the scoreboard in accordance with the game status and score
(check-expect (render-text false 0) (text "Press space to play" FONT-SIZE FONT-COLOR))
(check-expect (render-text "playing" 8) (text "8" FONT-SIZE FONT-COLOR))
(check-expect (render-text "game over" 15) (above (text "Game Over. You scored 15" FONT-SIZE FONT-COLOR)
                                                  (text "Press space to play again" FONT-SIZE-SMALL FONT-COLOR)))

;(define (render-text s g) empty-image)  ;stub

(define (render-text s g)
  (cond [(false? s) (text "Press space to play" FONT-SIZE FONT-COLOR)]
        [(string=? "playing" s) (text (number->string g) FONT-SIZE FONT-COLOR)]
        [else
         (above (text (string-append "Game Over. You scored " (number->string g)) FONT-SIZE FONT-COLOR)
                (text "Press space to play again" FONT-SIZE-SMALL FONT-COLOR))]))

;; Game -> Image
;; renders the tank, missiles and invaders
(check-expect (render-scene G0) (place-image TANK (tank-x T0) TANK-Y BACKGROUND))
(check-expect (render-scene G1) (place-image TANK (tank-x T1) TANK-Y BACKGROUND))
(check-expect (render-scene G2) (place-image INVADER 150 100
                                             (place-image MISSILE 150 300
                                                          (place-image TANK (tank-x T1) TANK-Y BACKGROUND))))
(check-expect (render-scene G3) (place-image INVADER 150 100
                                             (place-image INVADER 150 HEIGHT 
                                                          (place-image MISSILE 150 300
                                                                       (place-image MISSILE (invader-x I1) (+ (invader-y I1) 10)
                                                                                    (place-image TANK (tank-x T1) TANK-Y BACKGROUND))))))

;(define (render-scene g) empty-image)  ;stub

(define (render-scene g)
  (place-invaders (game-invaders g)
                  (place-missiles (game-missiles g)
                                  (place-image TANK (tank-x (game-tank g)) TANK-Y BACKGROUND))))

;; ListOfInvader Image -> Image
;; renders the invaders at their correct possition on img
(check-expect (place-invaders empty BACKGROUND) BACKGROUND)
(check-expect (place-invaders (list I1) BACKGROUND) (place-image INVADER 150 100 BACKGROUND))
(check-expect (place-invaders (list I1 I2) BACKGROUND) (place-image INVADER 150 HEIGHT
                                                                    (place-image INVADER 150 100 BACKGROUND)))

;(define (place-invaders loi img) img)  ;stub

(define (place-invaders loi img)
  (cond [(empty? loi) img]
        [else
         (place-image INVADER
                      (invader-x (first loi))
                      (invader-y (first loi))
                      (place-invaders (rest loi) img))]))

;; ListOfMissile Image -> Image
;; renders the missiles at their correct possition on img
(check-expect (place-missiles empty BACKGROUND) BACKGROUND)
(check-expect (place-missiles (list M1) BACKGROUND) (place-image MISSILE 150 300 BACKGROUND))
(check-expect (place-missiles (list M1 M2) BACKGROUND) (place-image MISSILE (invader-x I1) (+ (invader-y I1) 10)
                                                                    (place-image MISSILE 150 300 BACKGROUND)))

;(define (place-missiles lom img) img)  ;stub

(define (place-missiles lom img)
  (cond [(empty? lom) img]
        [else
         (place-image MISSILE
                      (missile-x (first lom))
                      (missile-y (first lom))
                      (place-missiles (rest lom) img))]))

;; =====================
;; Handle-key function
;; =====================

;; Game KeyEvent -> Game
;; changes the game screen depending on the game status:
;;         if Status is:
;;          - false       : space key starts the game
;;          - "playing"   : arrow keys change tank direction and space key shoots missiles
;;          - "game over" : space key restarts the game
(check-expect (handle-key (make-game empty empty T0 0 false)  "left")  (make-game empty empty T0 0  false))
(check-expect (handle-key (make-game (list I1) empty T0 12 false) "right") (make-game (list I1) empty T0 12 false))
(check-expect (handle-key (make-game empty (list M1) T1 5 false)  "a")     (make-game empty (list M1) T1 5  false))
(check-expect (handle-key (make-game (list I1) (list M1) T1 99 false) " ") START-GAME)

(check-expect (handle-key (make-game empty (list M2) (make-tank 10 -1) 0 "playing") "left") (make-game empty (list M2) (make-tank 10 -1) 0 "playing"))
(check-expect (handle-key (make-game (list I1) (list M1) (make-tank 15 1) 0 "playing") "left")  (make-game (list I1) (list M1)
                                                                                                           (make-tank 15 -1) 0 "playing"))
(check-expect (handle-key (make-game (list I2) empty (make-tank 201 -1) 0 "playing") "right") (make-game (list I2) empty (make-tank 201 1) 0 "playing"))
(check-expect (handle-key (make-game (list I1) (list M1) (make-tank 150 1) 0 "playing") "right")  (make-game (list I1) (list M1)
                                                                                                             (make-tank 150 1) 0 "playing"))
(check-expect (handle-key (make-game empty (list M1) (make-tank 100 1) 0 "playing") "b")  (make-game empty (list M1) (make-tank 100 1) 0 "playing"))
(check-expect (handle-key (make-game empty empty (make-tank 84 -1) 0 "playing") "a")  (make-game empty empty (make-tank 84 -1) 0 "playing"))
(check-expect (handle-key (make-game empty empty T0 0 "playing") " ") (make-game empty (list (make-missile (tank-x T0)
                                                                                                           (- HEIGHT MISSILE-Y0))) T0 0 "playing"))
(check-expect (handle-key (make-game empty (list M1) T1 5 "playing") " ") (make-game empty (list (make-missile (tank-x T1)
                                                                                                               (- HEIGHT MISSILE-Y0)) M1) T1 5 "playing"))

(check-expect (handle-key (make-game empty empty T0 0 "game over")  "left")  (make-game empty empty T0 0  "game over"))
(check-expect (handle-key (make-game (list I1) empty T0 12 "game over") "right") (make-game (list I1) empty T0 12 "game over"))
(check-expect (handle-key (make-game empty (list M1) T1 5 "game over")  "a")     (make-game empty (list M1) T1 5  "game over"))
(check-expect (handle-key (make-game (list I1) (list M1) T1 99 "game over") " ")     START-GAME)

;(define (handle-key g ke) g)  ;stub

(define (handle-key g ke)
  (cond [(or (false? (game-status g)) (string=? "game over" (game-status g)))
         (if (key=? ke " ") START-GAME g)]
        [else
         (cond [(key=? ke "left")  (turn-tank g -1)]
               [(key=? ke "right") (turn-tank g +1)]
               [(key=? ke " ")     (fire-missile g)]
               [else                   g])]))


;; Game Integer[-1, 1] -> Game
;; produces the same game with the tank direction uptated
(check-expect (turn-tank (make-game empty empty (make-tank 50  1) 0 "playing") -1) (make-game empty empty (make-tank 50 -1) 0 "playing"))
(check-expect (turn-tank (make-game empty empty (make-tank 50  1) 0 "playing")  1) (make-game empty empty (make-tank 50  1) 0 "playing"))
(check-expect (turn-tank (make-game empty empty (make-tank 89 -1) 0 "playing") -1) (make-game empty empty (make-tank 89 -1) 0 "playing"))
(check-expect (turn-tank (make-game empty empty (make-tank 89 -1) 0 "playing")  1) (make-game empty empty (make-tank 89  1) 0 "playing"))

;(define (turn-tank g dir) g)  ;stub

(define (turn-tank g dir)
  (make-game (game-invaders g)
             (game-missiles g)
             (make-tank (tank-x (game-tank g)) dir)
             (game-score g)
             (game-status g)))

;; Game -> Game
;; produces a game with a new missile added
(check-expect (fire-missile G1) (make-game empty (list (make-missile 50 (- HEIGHT MISSILE-Y0)))  T1 0 "playing"))
(check-expect (fire-missile G2) (make-game (game-invaders G2) (cons (make-missile 50 (- HEIGHT MISSILE-Y0)) (game-missiles G2)) T1 5 "playing"))

;(define (fire-missile g) g)  ;stub

(define (fire-missile g)
  (make-game (game-invaders g)
             (add-missile g)
             (game-tank g)
             (game-score g)
             (game-status g)))

;; Game -> ListOfMissile
;; adds one missile to the list of missiles at the current tank's x coord
(check-expect (add-missile G1) (cons (make-missile (tank-x T1) (- HEIGHT MISSILE-Y0)) (game-missiles G1)))
(check-expect (add-missile G2) (cons (make-missile (tank-x T1) (- HEIGHT MISSILE-Y0)) (game-missiles G2)))

;(define (add-missile g) empty)  ;stub

(define (add-missile g)
  (cons (make-missile (tank-x (game-tank g))
                      (- HEIGHT MISSILE-Y0)) (game-missiles g)))