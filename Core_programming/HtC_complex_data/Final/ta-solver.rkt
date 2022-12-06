;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname ta-solver) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; ta-solver-starter.rkt



;  PROBLEM 1:
;
;  Consider a social network similar to Twitter called Chirper. Each user has a name, a note about
;  whether or not they are a verified user, and follows some number of people.
;
;  Design a data definition for Chirper, including a template that is tail recursive and avoids
;  cycles.
;
;  Then design a function called most-followers which determines which user in a Chirper Network is
;  followed by the most people.
;

(define-struct user (name verified? follows))
;; User is (make-user String Boolean (listof User))
;; interp. an user with a name, a verified status, and a list of the users that he/she follows
(define U1 (make-user "U1" false empty))
(define N1 (make-user "U2" true (list U1 (make-user "U3" true (list U1)))))
(define N2 (shared [(-U1- (make-user "U1" true (list -U2- -U3-)))
                    (-U2- (make-user "U2" false (list -U4-)))
                    (-U3- (make-user "U3" false (list -U1- -U2-)))
                    (-U4- (make-user "U4" true (list -U2-)))]
             -U3-))

;; template for mutualy referential data wraped in local
;;          with a worklist accumulator to have tail-recursion,
;;          and a context preserving accumulator to avoid cycles
#;
(define (fn-for-user u0)
  ;; todo    is (listof User); a worklist accumulator
  ;; visited is (listof String); a list of the user names already seen
  (local [(define (fn-for-user u todo visited)
            ;; (... (user-name u)
            ;;      (user-verified? u)
            (cond [(member? (user-name u) visited) (fn-for-lou todo visited)]
                  [else
                   (fn-for-lou (append (user-follows u) todo)
                               (cons (user-name u) visited))]))

          (define (fn-for-lou todo visited)
            (cond [(empty? todo) (...)]
                  [else
                   (fn-for-user (first todo) (rest todo) visited)]))]
    (fn-for-user u0 empty empty)))

;; User -> User
;; produces the user with the most followers in the network (in case of a tie produce either one)
;; ASSUME there will be at least 2 users in the network in which at least 1 of them has at least 1 follower
(check-expect (most-followers N1) U1)
(check-expect (most-followers N2) (shared [(-U2- (make-user "U2" false (list -U4-)))
                                           (-U4- (make-user "U4" true (list -U2-)))] -U2-))

(define (most-followers u0)
  ;; Auxiliar data definition:
  ;;  FollowerCount is (list User Natural)
  ;;  interp. a list with the users and their follower count
  
  ;; todo    is (listof User);          a worklist accumulator
  ;; visited is (listof String);        a list of the user names already seen
  ;; count   is (listof FollowerCount); a list of every user in the network and their number of followers
  (local [(define (fn-for-user u todo visited count)
            (cond [(member? (user-name u) visited) (fn-for-lou todo visited count)]
                  [else
                   (fn-for-lou (append (user-follows u) todo)
                               (cons (user-name u) visited)
                               (foldl update-followers count (user-follows u)))]))

          (define (fn-for-lou todo visited count)
            (cond [(empty? todo) (max-count count)]
                  [else
                   (fn-for-user (first todo) (rest todo) visited count)]))

          ;; User (listof FollowerCount) -> (listof FollowerCount)
          ;; given a user, if it's already on the list it adds 1 to their follower count
          ;;               if the user is not on the list, adds the user to the list with count 1
          (define (update-followers u lofc0)
            ;; prevs is (listof FollowerCount); the already seen elements of lofc
            (local [(define (update-followers lofc prevs)
                      (cond [(empty? lofc) (cons (list u 1) lofc0)]
                            [(string=? (user-name u) (user-name (first (first lofc))))
                             (append prevs
                                     (list (list u (add1 (second (first lofc)))))
                                     (rest lofc))]
                            [else
                             (update-followers (rest lofc) (cons (first lofc) prevs))]))]
              (update-followers lofc0 empty)))

          ;; (listof FollowerCount) -> User
          ;; produces the user with the most followers
          ;; ASSUME: the list will not be empty
          (define (max-count lofc0)
            ;; winner is FollowerCount
            (local [(define (max-count lofc winner)
                      (cond [(empty? lofc) (first winner)]
                            [(> (second (first lofc)) (second winner)) (max-count (rest lofc) (first lofc))]
                            [else
                             (max-count (rest lofc) winner)]))]
              (max-count lofc0 (first lofc0))))]
    
    (fn-for-user u0 empty empty empty)))

;  PROBLEM 2:
;
;  In UBC's version of How to Code, there are often more than 800 students taking
;  the course in any given semester, meaning there are often over 40 Teaching Assistants.
;
;  Designing a schedule for them by hand is hard work - luckily we've learned enough now to write
;  a program to do it for us!
;
;  Below are some data definitions for a simplified version of a TA schedule. There are some
;  number of slots that must be filled, each represented by a natural number. Each TA is
;  available for some of these slots, and has a maximum number of shifts they can work.
;
;  Design a search program that consumes a list of TAs and a list of Slots, and produces one
;  valid schedule where each Slot is assigned to a TA, and no TA is working more than their
;  maximum shifts. If no such schedules exist, produce false.
;
;  You should supplement the given check-expects and remember to follow the recipe!



;; Slot is Natural
;; interp. each TA slot has a number, is the same length, and none overlap

(define-struct ta (name max avail))
;; TA is (make-ta String Natural (listof Slot))
;; interp. the TA's name, number of slots they can work, and slots they're available for

(define SOBA (make-ta "Soba" 2 (list 1 3)))
(define UDON (make-ta "Udon" 1 (list 3 4)))
(define RAMEN (make-ta "Ramen" 1 (list 2)))

(define NOODLE-TAs (list SOBA UDON RAMEN))


(define-struct assignment (ta slot))
;; Assignment is (make-assignment TA Slot)
;; interp. the TA is assigned to work the slot

;; Schedule is (listof Assignment)


;; ============================= FUNCTIONS


;; (listof TA) (listof Slot) -> Schedule or false
;; produce valid schedule given TAs and Slots; false if impossible

(check-expect (schedule-tas empty empty) empty)
(check-expect (schedule-tas empty (list 1 2)) false)
(check-expect (schedule-tas (list SOBA) empty) empty)

(check-expect (schedule-tas (list SOBA) (list 1)) (list (make-assignment SOBA 1)))
(check-expect (schedule-tas (list SOBA) (list 2)) false)
(check-expect (schedule-tas (list SOBA) (list 1 3)) (list (make-assignment SOBA 3)
                                                          (make-assignment SOBA 1)))

(check-expect (schedule-tas NOODLE-TAs (list 1 2 3 4))
              (list
               (make-assignment UDON 4)
               (make-assignment SOBA 3)
               (make-assignment RAMEN 2)
               (make-assignment SOBA 1)))

(check-expect (schedule-tas NOODLE-TAs (list 1 2 3 4 5)) false)
(check-expect (schedule-tas (list UDON) (list 3 4)) false)

;(define (schedule-tas tas slots) empty) ;stub

;; 2 one of table
;;
;;                                 slots
;;                        ┌─────────┬─────────────────┐
;;                        │  empty  │ (cons Slot LOS) │
;;     ┌──────────────────┼─────────┼─────────────────┤
;;    t│     empty        │         │      false      │
;;    a├──────────────────┼  empty  ┼─────────────────┤
;;    s│  (cons ta LOTA)  │         │  produce nexts  │
;;     └──────────────────┴─────────┴─────────────────┘

(define (schedule-tas tas0 slots0)
  ;; skd is Schedule; the schedule so far
  (local [;; Auxiliar data definition:
          ;;  Sched is (list Schedule (listof TA))
          ;;  interp. a Schedule and the TA that remain available after they were assigned

          ;; (listof TA) (listof Slot) Schedule -> Schedule or false
          ;; (listof Sched) (listof Slot) -> Schedule or false
          (define (solve-schedule tas slots skd)
            (cond [(empty? slots) skd]
                  [(empty? tas) false]
                  [else    
                   (solve-sched (next-schedules skd tas (first slots)) (rest slots))]))

          (define (solve-sched scheds slots)
            (cond [(empty? scheds) false]
                  [else
                   (local [(define schedule (first  (first scheds)))         ;Schedule
                           (define tas      (second (first scheds)))         ;(listof TA)
                           (define try (solve-schedule tas slots schedule))] ;Schedule or false
                     (if (not (false? try))
                         try
                         (solve-sched (rest scheds) slots)))]))]
    (solve-schedule tas0 slots0 empty)))

;; Schedule (listof TA) Slot -> (listof Sched)
;; produces all  possible schedules with the given slot and the current list of TAs
;; each element in the list is a list where:
;;   - first  is the Schedule
;;   - second is a new (listof TA) updated after the corresponding schedule
;; ASSUME: the (listof TA) will not be empty
(check-expect (next-schedules empty (list SOBA) 1) (list (list (list (make-assignment SOBA 1)) (list SOBA))))
(check-expect (next-schedules empty (list SOBA) 2) empty)
(check-expect (next-schedules (list (make-assignment SOBA 3)) (list SOBA) 1) (list (list (list (make-assignment SOBA 1)
                                                                                               (make-assignment SOBA 3)) empty)))
(check-expect (next-schedules (list (make-assignment SOBA 1)) (list SOBA UDON) 3) (list
                                                                                   (list (list (make-assignment UDON 3)
                                                                                               (make-assignment SOBA 1)) (list SOBA))
                                                                                   (list (list (make-assignment SOBA 3)
                                                                                               (make-assignment SOBA 1)) (list UDON))))

;(define (next-schedules skd tas slot) empty)  ;stub

(define (next-schedules skd tas slot)
  (map (lambda (schedule) (list schedule (update-tas tas schedule))) 
       (map (lambda (asgmt) (cons asgmt skd)) 
            (possible-assignments tas slot))))

;; (listof TA) Slot -> (listof Assignment)
;; produces a list of all the possible assignments with the given slot and the current (listof TA)
;; ASSUME: (listof TA) will not be empty
(check-expect (possible-assignments (list SOBA) 1) (list (make-assignment SOBA 1)))
(check-expect (possible-assignments (list SOBA) 2) empty)
(check-expect (possible-assignments NOODLE-TAs 3) (list (make-assignment UDON 3)
                                                        (make-assignment SOBA 3)))

;(define (possible-assignments tas slot) empty)  ;stub

(define (possible-assignments tas slot)
  (foldl (lambda (ta lst) (if (member slot (ta-avail ta))
                              (cons (make-assignment ta slot) lst)
                              lst)) empty tas))

;; (listof TA) Schedule -> (listof TA)
;; produces an updated (listof TA) with only tas that haven't reached their max number of shifts in the schedule
;; ASSUME: (listof TA) will not be empty
(check-expect (update-tas (list SOBA) empty) (list SOBA))
(check-expect (update-tas (list SOBA) (list (make-assignment SOBA 1))) (list SOBA))
(check-expect (update-tas (list SOBA RAMEN) (list (make-assignment SOBA 1)
                                                  (make-assignment SOBA 3))) (list RAMEN))
(check-expect (update-tas (list SOBA RAMEN UDON) (list (make-assignment SOBA 1)
                                                       (make-assignment UDON 3))) (list SOBA RAMEN))

;(define (update-tas tas sch) tas)  ;stub

(define (update-tas tas sch)
  (local [;; String Schedule Natural -> Natural
          ;; produces the amount of times the given ta appears in the schedule
          (define (get-count tan skd count)
            (cond [(empty? skd) count]
                  [else
                   (if (string=? tan (ta-name (assignment-ta (first skd))))
                       (get-count tan (rest skd) (add1 count))
                       (get-count tan (rest skd) count))]))]
    (filter (lambda (ta)
              (< (get-count (ta-name ta) sch 0) (ta-max ta))) tas)))



;; Quiz question 3
;; Supose you have 9 TAs, as shown in the table below, who are available to work 1 or 2 of 12 possible shifts.
;;      ┌───────────┬────────────┬──────────────┐
;;      │   Name    │ #of Shifts │ Availability │
;;      ├───────────┼────────────┼──────────────┤
;;      │  Erika    │      1     │ 1,3,7,9      │
;;      ├───────────┼────────────┼──────────────┤
;;      │  Ryan     │      1     │ 1,8,10       │
;;      ├───────────┼────────────┼──────────────┤
;;      │  Reece    │      1     │ 5,6          │
;;      ├───────────┼────────────┼──────────────┤
;;      │  Gordon   │      2     │ 2,3,9        │
;;      ├───────────┼────────────┼──────────────┤
;;      │  David    │      2     │ 2,8,9        │
;;      ├───────────┼────────────┼──────────────┤
;;      │  Katie    │      1     │ 4,6          │
;;      ├───────────┼────────────┼──────────────┤
;;      │  Aashish  │      2     │ 1,10         │
;;      ├───────────┼────────────┼──────────────┤
;;      │  Grant    │      2     │ 1,11         │
;;      ├───────────┼────────────┼──────────────┤
;;      │  Raeanne  │      2     │ 1,11,12      │
;;      └───────────┴────────────┴──────────────┘

(define Erika   (make-ta "Erika"   1 (list 1 3 7 9)))
(define Ryan    (make-ta "Ryan"    1 (list 1 8 10)))
(define Reece   (make-ta "Reece"   1 (list 5 6)))
(define Gordon  (make-ta "Gordon"  2 (list 2 3 9)))
(define David   (make-ta "David"   2 (list 2 8 9)))
(define Katie   (make-ta "Katie"   1 (list 4 6)))
(define Aashish (make-ta "Aashish" 2 (list 1 10)))
(define Grant   (make-ta "Grant"   2 (list 1 11)))
(define Raeanne (make-ta "Raeanne" 2 (list 1 11 12)))

(define TAs (list Erika Ryan Reece Gordon David Katie Aashish Grant Raeanne))

(schedule-tas TAs (list 1 2 3 4 5 6 7 8 9 10 11 12))  ; produces false

;; Quiz question 4
;; Suppose you add a 10th TA, Alex who is only available to work shift 7
;; Can you fill every shift to make a schedule using the 9 TAs above plus Alex?

(define Alex (make-ta "Alex" 1 (list 7)))

(schedule-tas (append TAs (list Alex)) (list 1 2 3 4 5 6 7 8 9 10 11 12))  ; produces false

;; Quiz question 5
;; Suppose instead of Alex, you add a 10th TA, Erin who is only available to work shift 4
;; Can you fill every shift to make a schedule using the 9 TAs above plus Erin?

(define Erin (make-ta "Erin" 1 (list 4)))

(schedule-tas (append TAs (list Erin)) (list 1 2 3 4 5 6 7 8 9 10 11 12))  ; Can fill all 10 shifts
;; produces:
;; (list
;;   (make-assignment (make-ta "Raeanne" 2 (list 1 11 12)) 12)
;;   (make-assignment (make-ta "Grant"   2 (list 1 11))    11)
;;   (make-assignment (make-ta "Aashish" 2 (list 1 10))    10)
;;   (make-assignment (make-ta "Gordon"  2 (list 2 3 9))    9)
;;   (make-assignment (make-ta "David"   2 (list 2 8 9))    8)
;;   (make-assignment (make-ta "Erika"   1 (list 1 3 7 9))  7)
;;   (make-assignment (make-ta "Katie"   1 (list 4 6))      6)
;;   (make-assignment (make-ta "Reece"   1 (list 5 6))      5)
;;   (make-assignment (make-ta "Erin"    1 (list 4))        4)
;;   (make-assignment (make-ta "Gordon"  2 (list 2 3 9))    3)
;;   (make-assignment (make-ta "David"   2 (list 2 8 9))    2)
;;   (make-assignment (make-ta "Raeanne" 2 (list 1 11 12))  1))

