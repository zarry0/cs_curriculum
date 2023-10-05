;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname AT) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; Data definitions

(define-struct person (name yob isMale mom dad))
;; Person is (make-person String Number Boolean AT AT)
;; interp. a person with a name,
;;                         year of birth,
;;                         whether this person is Male,
;;                         an AT for the mother
;;                         and an AT for the father


;; Ancestor Tree (AT) is one of:
;;  - empty (Unknown)
;;  - (make-person String Number Boolean AT AT)
;; interp. an ancestor tree

(define enid (make-person "Enid" 1904 false empty empty))
(define edward (make-person "Edward" 1902 true empty empty))
(define emma (make-person "Emma" 1906 false empty empty))
(define eustace (make-person "Eustace" 1907 true empty empty))
 
(define david (make-person "David" 1925 true empty edward))
(define daisy (make-person "Daisy" 1927 false empty empty))
(define dana (make-person "Dana" 1933 false empty empty))
(define darcy (make-person "Darcy" 1930 false emma eustace))
(define darren (make-person "Darren" 1935 true enid empty))
(define dixon (make-person "Dixon" 1936 true empty empty))
 
(define clyde (make-person "Clyde" 1955 true daisy david))
(define candace (make-person "Candace" 1960 false dana darren))
(define cameron (make-person "Cameron" 1959 true empty dixon))
(define claire (make-person "Claire" 1956 false darcy empty))
 
(define bill (make-person "Bill" 1980 true candace clyde))
(define bree (make-person "Bree" 1981 false claire cameron))
 
(define andrew (make-person "Andrew" 2001 true bree bill))

(define badly-formed1 (make-person "Jon" 1974 true empty bree))
(define badly-formed2 (make-person "Jon" 1974 true clyde bree))
(define badly-formed3 (make-person "Jon" 1910 true david darcy))

;
;
;
;                                                  ┌─────────┐
;                                                  │Andrew(M)│
;                                                  │(2001)   │
;                                                  └────┬────┘
;                                                       │
;                               ┌───────────────────────┴──────────────────────────┐
;                               │                                                  │
;                           ┌───┴───┐                                          ┌───┴───┐
;                           │Bree(F)│                                          │Bill(M)│
;                           │(1981) │                                          │(1980) │
;                           └───┬───┘                                          └───┬───┘
;                               │                                                  │
;                      ┌────────┴─────────┐                          ┌─────────────┴───────────────┐
;                      │                  │                          │                             │
;                 ┌────┴────┐        ┌────┴─────┐               ┌────┴─────┐                   ┌───┴────┐
;                 │Claire(F)│        │Cameron(M)│               │Candace(F)│                   │Clyde(M)│
;                 │(1956)   │        │(1959)    │               │(1960)    │                   │(1955)  │
;                 └────┬────┘        └────┬─────┘               └────┬─────┘                   └───┬────┘
;                      │                  │                          │                             │
;              ┌───────┴───────┐    ┌─────┴─────┐            ┌───────┴────────┐             ┌──────┴───────┐
;              │               │    │           │            │                │             │              │
;          ┌───┴────┐         ┌┴┐  ┌┴┐      ┌───┴────┐   ┌───┴───┐       ┌────┴────┐    ┌───┴────┐    ┌────┴───┐
;          │Darcy(F)│         │x│  │x│      │Dixon(M)│   │Dana(F)│       │Darren(M)│    │Daisy(F)│    │David(M)│
;          │(1930)  │         └─┘  └─┘      │(1936)  │   │(1933) │       │(1935)   │    │(1927)  │    │(1925)  │
;          └───┬────┘                       └───┬────┘   └───┬───┘       └────┬────┘    └───┬────┘    └───┬────┘
;              │                                │            │                │             │             │
;       ┌──────┴──────┐                     ┌───┴───┐    ┌───┴───┐       ┌────┴────┐    ┌───┴────┐    ┌───┴────┐
;       │             │                     │       │    │       │       │         │    │        │    │        │
;   ┌───┴───┐    ┌────┴─────┐              ┌┴┐     ┌┴┐  ┌┴┐     ┌┴┐  ┌───┴───┐    ┌┴┐  ┌┴┐      ┌┴┐  ┌┴┐  ┌────┴────┐
;   │Emma(F)│    │Eustace(M)│              │x│     │x│  │x│     │x│  │Enid(F)│    │x│  │x│      │x│  │x│  │Edward(M)│
;   │(1906) │    │(1907)    │              └─┘     └─┘  └─┘     └─┘  │(1904) │    └─┘  └─┘      └─┘  └─┘  │(1902)   │
;   └───┬───┘    └────┬─────┘                                        └───┬───┘                            └────┬────┘
;       │             │                                                  │                                     │
;   ┌───┴───┐     ┌───┴───┐                                          ┌───┴───┐                             ┌───┴───┐
;   │       │     │       │                                          │       │                             │       │
;  ┌┴┐     ┌┴┐   ┌┴┐     ┌┴┐                                        ┌┴┐     ┌┴┐                           ┌┴┐     ┌┴┐
;  │x│     │x│   │x│     │x│                                        │x│     │x│                           │x│     │x│
;  └─┘     └─┘   └─┘     └─┘                                        └─┘     └─┘                           └─┘     └─┘
;
;

;; Auxiliar Data definition

;; (listof String) is one of:
;;  - empty
;;  - (cons String listofString)
;; interp. a list of strings

;; Functions

;; AT -> Number
;; produces the number of ancestors in the given tree
;; (excluding the given node)
(check-expect (count empty) 0)
(check-expect (count enid) 0)
(check-expect (count david) 1)
(check-expect (count darcy) 2)
(check-expect (count andrew) 16)

(define (count at)
  (local [(define (aux at)
            (cond [(empty? at) 0]
                  [else (+ 1
                           (aux (person-mom at))
                           (aux (person-dad at)))]))]
    (cond [(empty? at) 0]
          [else (- (aux at) 1)])))

;; AT -> Number
;; produces the number of ancestors of the given tree (excluding the root node)
;; that are women older than 40 (in 2022)
(check-expect (females-over-40 empty) 0)
(check-expect (females-over-40 enid) 0)
(check-expect (females-over-40 darcy) 1)
(check-expect (females-over-40 bree) 3)
(check-expect (females-over-40 andrew) 8)

(define (females-over-40 at)
  (local [(define current-year 2022)
          ;; AT -> Number
          ;; produces the number of female ancestors over 40 (in the current-year)
          ;; (including the root of the given tree)
          (define (aux at)
            (cond [(empty? at) 0]
                  [else (+ (if (female-over-40? at) 1 0)
                           (aux (person-mom at))
                           (aux (person-dad at)))]))
          ;; Person -> Boolean
          ;; produces true if the given person is female and over 40 (in the current-year)
          (define (female-over-40? p)
            (and (not (person-isMale p))
                 (> (- current-year 40) (person-yob p))))]
    (cond [(empty? at) 0]
          [else (+ (aux (person-mom at))
                   (aux (person-dad at)))])))

;; AT -> Number
;; produces the number of generations that are completely known (including the root of the tree)
(check-expect (num-total-gens empty) 0)
(check-expect (num-total-gens enid) 1)
(check-expect (num-total-gens clyde) 2)
(check-expect (num-total-gens bill) 3)
(check-expect (num-total-gens andrew) 3)

(define (num-total-gens at)
  (cond [(empty? at) 0]
        [else (+ 1 (min (num-total-gens (person-mom at))
                        (num-total-gens (person-dad at))))]))

;; AT -> Number
;; produces the number of generations that are at least partialy known (including the root of the tree)
(check-expect (num-partial-gens empty) 0)
(check-expect (num-partial-gens enid) 1)
(check-expect (num-partial-gens clyde) 3)
(check-expect (num-partial-gens bill) 4)
(check-expect (num-partial-gens andrew) 5)

(define (num-partial-gens at)
  (cond [(empty? at) 0]
        [else (+ 1 (max (num-partial-gens (person-mom at))
                        (num-partial-gens (person-dad at))))]))

;; AT -> Boolean
;; produces true if the tree is well formed
;; a well formed tree is one in which every person is younger than its parents
(check-expect (well-formed empty) true)
(check-expect (well-formed andrew) true)
(check-expect (well-formed badly-formed1) false)
(check-expect (well-formed badly-formed2) false)
(check-expect (well-formed badly-formed3) false)

(define (well-formed_v1 at)
  (cond [(empty? at) true]
        [else (and (younger? at (person-mom at))
                   (younger? at (person-dad at))
                   (well-formed (person-mom at))
                   (well-formed (person-dad at)))]))

;; Version 2 of well-formed
(define (well-formed at)
  (local [;; AT * Number -> Boolean
          ;; produces true if the node is older than the given child
          ;; and if the parents are well formed
          (define (well-formed-helper at child-yob)
            ;; child-yob is a contex preserving accumulator
            ;; it represents the age of any given node's descendant
            (cond [(empty? at) true]
                  [else (and (< (person-yob at) child-yob)
                             (well-formed-helper (person-mom at) (person-yob at))
                             (well-formed-helper (person-dad at) (person-yob at)))]))]
    (cond [(empty? at) true]
          [else (and (well-formed-helper (person-mom at) (person-yob at))
                     (well-formed-helper (person-dad at) (person-yob at)))])))

;; Person * (Person | empty) -> Boolean
;; produces true if p1 is younger than p2
;; ASSUME: p1 wont be empty
(check-expect (younger? andrew empty) true)
(check-expect (younger? andrew bree) true)
(check-expect (younger? enid andrew) false)

(define (younger? p1 p2)
  (cond [(empty? p2) true]
        [else (> (person-yob p1)
                 (person-yob p2))]))

;; AT -> (listof String)
;; produces a list with all the names of all ancestors in the tree
;; (including the tree root)
(check-expect (anc-names empty) empty)
(check-expect (anc-names enid) (list "Enid"))
(check-expect (anc-names darcy) (list "Darcy" "Emma" "Eustace"))
;#;
(define (anc-names at)
  (cond [(empty? at) empty]
        [else (cons (person-name at)
                    (append (anc-names (person-mom at))
                            (anc-names (person-dad at))))]))

;; AT -> AT
;; produces the youngest grandparent of the given tree
(check-expect (youngest-grandparent empty) empty)
(check-expect (youngest-grandparent enid) empty)
(check-expect (youngest-grandparent darcy) empty)
(check-expect (youngest-grandparent bree) dixon)
(check-expect (youngest-grandparent bill) darren)
(check-expect (youngest-grandparent andrew) candace)

#;
(define (youngest-grandparent at)
  (cond [(empty? at) empty]
        [else (youngest (youngest-parent (person-mom at))
                        (youngest-parent (person-dad at)))]))

;; alt version
(define (youngest-grandparent at)
  (youngest-anc at 2))

;; AT * AT -> AT
;; produces the youngest of the two given trees
(check-expect (youngest empty empty) empty)
(check-expect (youngest enid empty) enid)
(check-expect (youngest empty enid) enid)
(check-expect (youngest andrew enid) andrew)

(define (youngest at1 at2)
  (cond [(empty? at1) at2]
        [(empty? at2) at1]
        [else (if (> (person-yob at1)
                     (person-yob at2))
                  at1
                  at2)]))

;; AT -> AT
;; produces the youngest parent of the given AT
(check-expect (youngest-parent empty) empty)
(check-expect (youngest-parent enid) empty)
(check-expect (youngest-parent david) edward)
(check-expect (youngest-parent bree) cameron)

(define (youngest-parent at)
  (cond [(empty? at) empty]
        [else (youngest (person-mom at)
                        (person-dad at))]))

;; AT * Number -> AT
;; produces the youngest parent of the given AT, n generations behind
(check-expect (youngest-anc empty 0) empty)
(check-expect (youngest-anc edward 0) edward)
(check-expect (youngest-anc edward 1) empty)
(check-expect (youngest-anc david 1) edward)
(check-expect (youngest-anc bill 2) darren)
(check-expect (youngest-anc andrew 3) dixon)
#;
(define (youngest-anc at n)
  (cond [(or (zero? n) (empty? at)) at]
        [else (youngest (youngest-anc (person-mom at) (- n 1))
                        (youngest-anc (person-dad at) (- n 1)))]))

(define (youngest-anc at n)
  (cond [(empty? at) at]
        [else (if (zero? n)
                  at
                  (youngest (youngest-anc (person-mom at) (- n 1))
                            (youngest-anc (person-dad at) (- n 1))))])) 
