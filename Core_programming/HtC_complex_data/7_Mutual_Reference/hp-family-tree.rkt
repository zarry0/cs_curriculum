;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname hp-family-tree) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp")) #f)))

;; hp-family-tree-starter.rkt

;
; In this problem set you will represent information about descendant family 
; trees from Harry Potter and design functions that operate on those trees.
;
; To make your task much easier we suggest two things:
;   - you only need a DESCENDANT family tree
;   - read through this entire problem set carefully to see what information 
;     the functions below are going to need. Design your data definitions to
;     only represent that information.
;   - you can find all the information you need by looking at the individual 
;     character pages like the one we point you to for Arthur Weasley.
;


;
; PROBLEM 1:
;
; Design a data definition that represents a family tree from the Harry Potter 
; wiki, which contains all necessary information for the other problems.  You 
; will use this data definition throughout the rest of the homework.
;

;; Family tree must include:
;;  - Only include descendants
;;  - include name
;;  - represent missing info as "" (empty string)
;;  - include a patronus
;;  - include wand material

;; Include definitions for ListOf (ListOfString) and ListOfString

;; __________________
;; Data definitions

(define-struct person (name patronus wand children))
;; Person is (make-person String String String ListOfPerson)
;; interp. a person with his/her name, patronus shape and wand material
;;                               NOTE: for any of these fields, the data might be an "" (empty string)
;;                                     representing that the information is missing
;;                           and children represents one generation of descendants

;; ListOfPerson is one of:
;;  - empty
;;  - (cons Person ListOfPerson)
;; interp. a list of persons.
;; In the context of the Person data type a this list represent the children of that person

#;
(define (fn-for-person p)
  (... (person-name p)          ;String
       (person-patronus p)      ;String
       (person-wand p)          ;Stirng
       (fn-for-lop (person-children p))))
#;
(define (fn-for-lop lop)
  (cond [(empty? lop) (...)]
        [else
         (... (fn-for-person (first lop))  
              (fn-for-lop (rest lop)))]))


;; ListOfString is one of:
;;  - empty
;;  - (cons String ListOfString)
;; interp. a list of strings
(define LOS0 empty)
(define LOS1 (list "A" "B"))
#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else
         (... (first los)
              (fn-for-los (rest los)))]))

;; ListOf (ListOfString) is one of:
;;  - empty
;;  - (cons ListOfString ListOf (ListOfString))
;; interp. a list of lists of String
(define LOLOS0 empty)
(define LOLOS1 (list empty))
(define LOLOS2 (list (list "A" "B")))
(define LOLOS3 (list (list "A" "B")
                     (list "1" "2")))
#;
(define (fn-for-lolos lolos)
  (cond [(empty? lolos) (...)]
        [else
         (... (fn-for-los (first los))
              (fn-for-lolos (rest los)))]))

;
; PROBLEM 2: 
;
; Define a constant named ARTHUR that represents the descendant family tree for 
; Arthur Weasley. You can find all the infomation you need by starting 
; at: http://harrypotter.wikia.com/wiki/Arthur_Weasley.
;
; You must include all of Arthur's children and these grandchildren: Lily, 
; Victoire, Albus, James.
;
;
; Note that on the Potter wiki you will find a lot of information. But for some 
; people some of the information may be missing. Enter that information with a 
; special value of "" (the empty string) meaning it is not present. Don't forget
; this special value when writing your interp.
;

(define VICTOIRE  (make-person "Victoire Weasley"  "" "" empty))
(define DOMINIQUE (make-person "Dominique Weasley" "" "" empty))
(define LOUIS     (make-person "Louis Weasley"     "" "" empty))

(define MOLLY_II (make-person "Molly Weasley II" "" "" empty))
(define LUCY     (make-person "Lucy Weasley"     "" "" empty))

(define FRED_II (make-person "Fred Weasley II" "" "" empty))
(define ROXANNE (make-person "Roxanne Weasley" "" "" empty))

(define ROSE (make-person "Rose Granger-Weasley" "" "" empty))
(define HUGO (make-person "Hugo Granger-Weasley" "" "" empty))

(define JAMES (make-person "James Potter II"      "" ""       empty))
(define ALBUS (make-person "Albus Severus Potter" "" "Cherry" empty))
(define LILY  (make-person "Lily Luna Potter"     "" ""       empty))

(define WILLIAM (make-person "William Weasley" "non-corporeal"        ""         (list VICTOIRE DOMINIQUE LOUIS)))
(define CHARLES (make-person "Charles Weasley" "non-corporeal"        ""         empty))
(define PERCY   (make-person "Percy Weasley"   "non-corporeal"        ""         (list MOLLY_II LUCY)))
(define FRED    (make-person "Fred Weasley"    "Magpie"               ""         empty))
(define GEORGE  (make-person "George Weasley"  "Magpie"               ""         (list FRED_II ROXANNE)))
(define RONALD  (make-person "Ronald Weasley"  "Jack Russell terrier" "Chestnut" (list ROSE HUGO)))
(define GINNY   (make-person "Ginevra Potter"  "Horse"                "Yew"      (list JAMES ALBUS LILY)))

(define ARTHUR  (make-person "Arthur Weasley" "Weasel" "" (list WILLIAM CHARLES PERCY FRED GEORGE RONALD GINNY)))

;; __________________
;; Functions

;
; PROBLEM 3:
;
; Design a function that produces a pair list (i.e. list of two-element lists)
; of every person in the tree and his or her patronus. For example, assuming 
; that HARRY is a tree representing Harry Potter and that he has no children
; (even though we know he does) the result would be: (list (list "Harry" "Stag")).
;
; You must use ARTHUR as one of your examples.
;

;; Person -> ListOf (ListOfString)
;; ListOfPerson -> ListOf (ListOfString) 
;; produces a pair list (lsit of two element lists) of every person in the tree and their patronus
(check-expect (get-patronus--lop empty) empty)
(check-expect (get-patronus--person FRED) (list (list "Fred Weasley" "Magpie")))
(check-expect (get-patronus--lop (list VICTOIRE DOMINIQUE LOUIS)) (list (list "Victoire Weasley" "")
                                                                        (list "Dominique Weasley" "")
                                                                        (list "Louis Weasley" "")))
(check-expect (get-patronus--person WILLIAM) (append (list (list "William Weasley" "non-corporeal"))
                                                     (get-patronus--lop (list VICTOIRE DOMINIQUE LOUIS))))
(check-expect (get-patronus--person ARTHUR) (append (list (list "Arthur Weasley" "Weasel"))
                                                    (get-patronus--lop (list WILLIAM CHARLES PERCY FRED GEORGE RONALD GINNY))))

;(define (get-patronus--person p) empty)  ;stubs
;(define (get-patronus--lop lop) empty)

(define (get-patronus--person p)
  (append (list (list (person-name p) (person-patronus p)))             
          (get-patronus--lop (person-children p))))

(define (get-patronus--lop lop)
  (cond [(empty? lop) empty]
        [else
         (append (get-patronus--person (first lop))  
                 (get-patronus--lop (rest lop)))]))

;
; PROBLEM 4:
;
; Design a function that produces the names of every person in a given tree 
; whose wands are made of a given material. 
;
; You must use ARTHUR as one of your examples.
;

;; Person String -> ListOfPerson
;; ListOfPerson String -> ListOfPerson ??
;; produces a list with the names of all the persons in the tree that have a wand of the given material
(check-expect (get-wand-owners--lop empty "Cherry") empty)
(check-expect (get-wand-owners--person FRED "Yew") empty)
(check-expect (get-wand-owners--lop (list JAMES ALBUS LILY) "") (list "James Potter II"
                                                                      "Lily Luna Potter"))
(check-expect (get-wand-owners--lop (list JAMES ALBUS LILY) "Cherry") (list "Albus Severus Potter"))
(check-expect (get-wand-owners--lop (list JAMES ALBUS LILY) "Yew") empty)
(check-expect (get-wand-owners--person ARTHUR "Yew") (list "Ginevra Potter"))
(check-expect (get-wand-owners--person ARTHUR "Cherry") (list "Albus Severus Potter"))
(check-expect (get-wand-owners--person ARTHUR "") (append (list "Arthur Weasley")
                                                          (get-wand-owners--lop
                                                           (list WILLIAM CHARLES PERCY FRED GEORGE RONALD GINNY) "")))

;(define (get-wand-owners--person p mat) empty)  ;stubs
;(define (get-wand-owners--lop lop mat) empty)

(define (get-wand-owners--person p mat)
  (if (string=? (person-wand p) mat)
      (append (list (person-name p))
              (get-wand-owners--lop (person-children p) mat))   
      (get-wand-owners--lop (person-children p) mat)))

(define (get-wand-owners--lop lop mat)
  (cond [(empty? lop) empty]
        [else
         (append (get-wand-owners--person (first lop) mat)  
                 (get-wand-owners--lop (rest lop) mat))]))