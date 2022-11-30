;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname championship-bracket) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; championship-bracket-starter.rkt 

;
; The weekend of October 17-20, 2013, USA Ultimate held its annual national
; championships tournament in Frisco, Texas.  In this problem, you will
; represent and operate on information about the results of the women's 
; competition. Here is a diagram of the results:
;
;
;    ┌───────────────┐
;    │ Fury       (w)│
;   A├───────────────┼──┐
;    │ Nova       (l)│  ├───────────────┐
;    └───────────────┘  │ Fury       (w)│
;                      I├───────────────┼─┐
;    ┌───────────────┐  │Brute Squad (l)│ │
;    │ Heist      (l)│  ├───────────────┘ │
;   B├───────────────┼──┘                 │
;    │Brute Squad (w)│                    ├───────────────┐
;    └───────────────┘                    │ Fury       (w)│
;                                        M├───────────────┼─┐
;    ┌───────────────┐                    │ Showdown   (l)│ │
;    │ Showdown   (w)│                    ├───────────────┘ │
;   C├───────────────┼──┐                 │                 │
;    │ Bent       (l)│  ├───────────────┐ │                 │
;    └───────────────┘  │ Showdown   (w)│ │                 │
;                      J├───────────────┼─┘                 │
;    ┌───────────────┐  │ Nightlock  (l)│                   │
;    │Molly Brown (l)│  ├───────────────┘                   │
;   D├───────────────┼──┘                                   │
;    │ Nightlock  (w)│                                      ├───────────────┐
;    └───────────────┘                                      │ Fury       (l)│
;                                                          O├───────────────┤
;    ┌───────────────┐                                      │ Scandal    (w)│
;    │ Riot       (w)│                                      ├───────────────┘
;   E├───────────────┼──┐                                   │
;    │ Schwa      (l)│  ├───────────────┐                   │
;    └───────────────┘  │ Riot       (w)│                   │
;                      K├───────────────┼─┐                 │
;    ┌───────────────┐  │ Nemesis    (l)│ │                 │
;    │ Ozone      (l)│  ├───────────────┘ │                 │
;   F├───────────────┼──┘                 │                 │
;    │ Nemesis    (w)│                    ├───────────────┐ │
;    └───────────────┘                    │ Riot       (l)│ │
;                                        N├───────────────┼─┘
;    ┌───────────────┐                    │ Scandal    (w)│
;    │ Scandal    (w)│                    ├───────────────┘
;   G├───────────────┼──┐                 │
;    │ Phoenix    (l)│  ├───────────────┐ │
;    └───────────────┘  │ Scandal    (w)│ │
;                      L├───────────────┼─┘
;    ┌───────────────┐  │ Capitals   (l)│
;    │ Traffic    (l)│  ├───────────────┘
;   H├───────────────┼──┘
;    │ Capitals   (w)│
;    └───────────────┘
;
;
; (Taken from http://scores.usaultimate.org/scores/#womens/tournament/13774)
; See http://en.wikipedia.org/wiki/Bracket_(tournament) for an explanation of
; tournament brackets.
;

;
; Here is a simple data definition for representing a completed game play
; bracket. For simplicity, it does not represent the scores of the games:
; it only includes the teams, their match-ups, and who won (w) and
; lost (l).
;
; To make sure you understand this data definition, we recommend that you
; copy the types comment and template into their own file, print it out,
; and draw the proper reference arrows.
;

(define-struct bracket (team-won team-lost br-won br-lost))
;; Bracket is one of:
;; - false
;; - (make-bracket String String Bracket Bracket)
;; interp.  A tournament competition bracket.
;;    false indicates an empty bracket.
;;    (make-bracket t1 t2 br1 br2) means that 
;;    - team t1 beat team t2, and
;;    - br1 represents team t1's bracket leading up to this match.
;;    - br2 represents team t2's bracket leading up to this match.
  
(define B0 false)  ; an empty tournament bracket, 

;
; PROBLEM 1:
; We have intentionally left out definitions for 3 of the brackets that make up
; bracket BN. Give definitions for those 3 brackets below. If you run the file
; you'll see which definitions are missing.
;

;; Real bracket examples are named using the bracket letter from the figure.

(define BE                                         ; 1st round match-up:
  (make-bracket "Riot" "Schwa" false false))       ; - Riot defeat Schwa

(define BF                                         ; 1st round match-up:
  (make-bracket "Nemesis" "Ozone" false false))    ; - Nemesis defeat Ozone

(define BG                                         ; 1st round match-up:
  (make-bracket "Scandal" "Phoenix" false false))  ; - Scandal defeat Phoenix

(define BH                                         ; 1st round match-up:
  (make-bracket "Capitals" "Traffic" false false)) ; - Capitals defeat Traffic

(define BL                                         ; 2nd round match-up:
  (make-bracket "Scandal" "Capitals" BG BH))       ; - Scandal defeat Capitals

(define BK                                         ; 2nd round match-up:
  (make-bracket "Riot" "Nemesis" BE BF))           ; - Riot defeat Nemesis

(define BN                                         ; 3rd round match-up:
  (make-bracket "Scandal" "Riot" BL BK))           ; -  Scandal defeat Riot


#;
(define (fn-for-bracket br)
  (cond [(false? br) (...)]
        [else
         (... (bracket-team-won br)
              (bracket-team-lost br)
              (fn-for-bracket (bracket-br-won br))
              (fn-for-bracket (bracket-br-lost br)))]))
  
  
;; ListOfTeam is one of:
;; - empty
;; - (cons String ListOfTeam)
;; interp. A list of team names
(define T0 empty)  ; no teams
(define T2 (list "Scandal" "Traffic"))
#;
(define (fn-for-lot lot)
  (cond [(empty? lot) (...)]
        [else
         (... (first lot)
              (fn-for-lot (rest lot)))]))

;
; SIDE NOTE: we use false to represent an empty bracket so that you cannot
; confuse an empty bracket with an empty list of teams, which is represented
; using empty.
;

;
; PROBLEM 2:
;
; Once a tournament is over, it can be hard to remember even some of the teams
; that your favorite team defeated and the order in which your team played them.
;
; Design a function that takes a bracket and a list of teams and checks whether 
; or not the winner of the bracket beat those teams in reverse order on the way to 
; winning the current round. Not all of the teams that the victor played need to
; be listed, but the victor must have played the teams listed, and those teams must
; be listed in order from the most recent (latest round) win to least recent win 
; (earliest round of tournament play).
;
; For instance, if we just consider Fury's semifinal bracket, then we know that
; Fury beat Showdown in the semifinals and beat Nova in the first round, so
; (list "Showdown" "Nova") is a good list of ordered wins for the semifinals,
; and so is just (list "Showdown").  (list "Traffic" "Nova") is not a good list
; because Fury didn't play Traffic, and (list "Nova" "Brute Squad") is not good
; because the order of wins is wrong.
;
; You must include a properly formed cross-product of types comment table in your
; solution.  You must render it as text in a comment box. It should come after
; the purpose.  You may find it helpful to draw your cross-product on paper for
; your design and then use a tool like http://www.asciiflow.com/#Draw to help you
; render it.  As part of the simplification, number each subclass that produces
; different answers.  For each cell in the cross-product table, label them with
; the appropriate subclass number. In your final function, number each case of
; your cond with a comment to show which subclass it corresponds to in the table.
;

;; Bracket ListOfTeams -> Boolean
;; produces true if the winner of the bracket (b) beaten the teams in the list (l)
;; from most recent to least recent (last win ... first win)

;;                                 brkt
;;                        ┌─────────┬──────────────────────────────────────┐
;;                        │  false  │       (make-bracket t1 t2 br1 br2)   │
;;     ┌──────────────────┼─────────┼──────────────────────────────────────┤
;;    l│     empty        │  true   │                   true               │
;;    s├──────────────────┼─────────┼──────────────────────────────────────┤
;;    t│(cons String LOT) │  true   │(and (or (str=? (first lst) (brkt-t2))│
;;     │                  │         │         (check in br1))              │
;;     │                  │         │     (beaten-teams? br1 (rest lst)))  │
;;     └──────────────────┴─────────┴──────────────────────────────────────┘
;;
;;  SIMPLIFICATION
;;
;;                                 brkt
;;                        ┌─────────┬───────────────────────────────────────┐
;;                        │  false  │       (make-bracket t1 t2 br1 br2)    │
;;     ┌──────────────────┼─────────┼───────────────────────────────────────┤
;;    l│     empty        │         │                true (2)               │
;;    s├──────────────────┼         ┼───────────────────────────────────────┤
;;    t│(cons String LOT) │ true(1) │(and (or (str=? (first lst) (brkt-t2)) │
;;     │                  │         │         (check in br1))               │
;;     │                  │         │     (beaten-teams? br1 (rest lst)))(3)│
;;     └──────────────────┴─────────┴───────────────────────────────────────┘

(check-expect (beaten-teams? false empty) true)
(check-expect (beaten-teams? false (list "Nova")) true)
(check-expect (beaten-teams? BN empty) true)
(check-expect (beaten-teams? BN (list "Riot")) true)
(check-expect (beaten-teams? BN (list "Riot" "Phoenix")) true)
(check-expect (beaten-teams? BN (list "Riot" "Traffic")) false)
(check-expect (beaten-teams? BN (list "Capitals" "Riot")) false)

;(define (beaten-teams? brkt lst) false)  ;stub

(define (beaten-teams? brkt lst)
  (cond [(false? brkt) true]                                          ;1
        [(empty? lst)  true]                                          ;2
        [else                                                         ;3
         (and (or (string=? (first lst) (bracket-team-lost brkt))
                  (beaten-team? (bracket-br-won brkt) (first lst)))
              (beaten-teams? (bracket-br-won brkt) (rest lst)))]))

;; Bracket Team -> Boolean
;; produces true if the given team lost against the winner of the given bracket
(check-expect (beaten-team? false "Ozone") false)
(check-expect (beaten-team? BN "Riot") true)
(check-expect (beaten-team? BN "Capitals") true)
(check-expect (beaten-team? BL "Riot") false)

;(define (beaten-team? brkt t) false)  ;stub

(define (beaten-team? brkt t)
  (cond [(false? brkt) false]
        [else
         (or (string=? t (bracket-team-lost brkt))
             (beaten-team? (bracket-br-won brkt) t))]))
