;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname Problem1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; Problem 1
;; Suppose you are working on a research paper, and you have gathered a set of documents together
;; for your bibliography: books and Wikipedia articles. 
;; Every document has an author, a title, and a bibliography of documents; 
;; additionally, books have publishers, and wiki articles have URLs.
;; 
;;     -  Since you know that wiki articles are not necessarily authoritative sources[citation needed], 
;;        you want to produce a bibliography containing just the authors and titles of the books you’ve found, 
;;        either directly or transitively through the bibliographies of other documents.
;;        Format the entries as “Last name, First name. "Title".”
;; 
;;     -  Since bibliographies must be alphabetized, sort the bibliography by the authors’ last names.
;; 
;;     -  Documents may be referenced more than once, but should only appear in the bibliography once. 
;;        Remove any duplicates (defined as the same author name and the same title)
;; 

;;=========================
;; Data definitions

;; Bib is one of:
;;  - Book
;;  - Wiki
;; interp. a document that forms a bibliography

(define-struct book (author title refs pub))
;; Book is (make-book Author String (listof Bib) String)
;; interp. a book with an author, title, list of references, and a publisher

(define-struct wiki (author title refs url))
;; Wiki is (make-wiki Author String (listof Bib) String)
;; interp. a wiki with an author, title, list of references, and a url

(define-struct author (first last))
;; Author is (make-author String String)
;; interp. an author with first name and last name

;; Examples
(define matt (make-author "Matthias" "Felleisen"))
(define herman (make-author "Herman" "Melville"))
(define yuval (make-author "Yuval" "Harari"))
(define doyle (make-author "Arthur" "Doyle"))
(define jane (make-author "Jane" "Doe"))
(define john (make-author "John" "Doe"))
(define zill (make-author "William" "Zill"))
(define appleseed (make-author "John" "Appleseed"))

(define htdp (make-book matt "HtDP" empty "NEU"))
(define mdRef (list htdp))
(define mobyDick (make-book herman "Moby Dick" mdRef "MIT"))
(define sapRef (list htdp mobyDick))
(define sapiens (make-book yuval "Sapiens" sapRef "MIT"))
(define sherlock (make-book doyle "Sherlock Holmes" empty "MIT"))

(define w1Ref (list mobyDick sherlock))
(define wiki1 (make-wiki appleseed "Classic Books" w1Ref "http://..."))
(define w2Ref (list sapiens))
(define wiki2 (make-wiki jane "Evolution" w2Ref "http://..."))
(define w3Ref (list sapiens sapiens wiki2))
(define wiki3 (make-wiki zill "Science" w3Ref "http://..."))
(define wiki4 (make-wiki zill "Some article" empty "http://..."))

(define csRef (list htdp wiki3 wiki1))
(define cs (make-book john "CS Fundamentals" csRef "Harvard"))

;; ========================
;; Function definitions

;; Bib -> (listof String)
;; produces a bibliography wih just the title and authors info
;; only form books (either directly or transitively) in the format: "Last name, first name. 'Title'"
(check-expect (get-bibliography wiki4) empty)
(check-expect (get-bibliography htdp) (list "Felleisen, Matthias. 'HtDP'"))
(check-expect (get-bibliography mobyDick) (list "Felleisen, Matthias. 'HtDP'"
                                                "Melville, Herman. 'Moby Dick'"))
(check-expect (get-bibliography wiki1) (list "Doyle, Arthur. 'Sherlock Holmes'"
                                             "Felleisen, Matthias. 'HtDP'"
                                             "Melville, Herman. 'Moby Dick'"))
(check-expect (get-bibliography cs) (list "Doe, John. 'CS Fundamentals'"
                                          "Doyle, Arthur. 'Sherlock Holmes'"
                                          "Felleisen, Matthias. 'HtDP'"
                                          "Harari, Yuval. 'Sapiens'"
                                          "Melville, Herman. 'Moby Dick'"))


(define (get-bibliography bib)
  (format-lobib (filter-duplicates (sort-by-last-name (get-book-references bib)))))

;; Bib -> (listof Bib)
;; produces a list of only the books (directly or transitively) of bib
(check-expect (get-book-references wiki4) empty)
(check-expect (get-book-references htdp) (list htdp))
(check-expect (get-book-references mobyDick) (list mobyDick htdp))
(check-expect (get-book-references sapiens) (list sapiens htdp mobyDick htdp))
(check-expect (get-book-references wiki1) (list mobyDick htdp sherlock))
(check-expect (get-book-references wiki3) (list sapiens htdp mobyDick htdp sapiens htdp mobyDick htdp sapiens htdp mobyDick htdp))

(define (get-book-references bib)
  (local (;; (listof Bib) -> (listof Bib)
          ;; produces a list of only the books (directly or transitively) of lobib 
          #;
          (define (get-book-refs-list lobib)
            (cond [(empty? lobib) empty]
                  [else (append (get-book-references (first lobib))
                                (get-book-refs-list (rest lobib)))]))

          (define (get-book-refs-list lobib)
            (foldr (lambda (bib ans)
                     (append (get-book-references bib) ans)) empty lobib)))
    
    (cond [(book? bib) (cons bib (get-book-refs-list (book-refs bib)))]
          [(wiki? bib)(get-book-refs-list (wiki-refs bib))])))

;; (listof Bib) -> (listof Bib)
;; produces a list sorted by the author's last name
(check-expect (sort-by-last-name empty) empty)
(check-expect (sort-by-last-name mdRef) mdRef)
(check-expect (sort-by-last-name sapRef) sapRef)
(check-expect (sort-by-last-name w1Ref) (list sherlock mobyDick))
(check-expect (sort-by-last-name w3Ref) (list wiki2 sapiens sapiens))

(define (sort-by-last-name lobib)
  (local (;; Bib * (listof Bib) -> (listof Bib)
          ;; inserts bib into the given list at the correct place
          ;; ASSUME: th given list is already sorted
          (define (insert bib lobib)
            (cond [(empty? lobib) (cons bib empty)]
                  [else (if (is-bigger-than? (first lobib) bib)
                            (cons bib lobib)
                            (cons (first lobib) (insert bib (rest lobib))))])))
    
    (cond [(empty? lobib) empty]
          [else (insert (first lobib)
                        (sort-by-last-name (rest lobib)))])))

;; Bib * Bib -> boolean
;; produces true if bib1 author's last name is bigger (alphabetically) than bib2 author's last name
(check-expect (is-bigger-than? htdp htdp) false)
(check-expect (is-bigger-than? htdp sherlock) true)
(check-expect (is-bigger-than? htdp sapiens) false)
(check-expect (is-bigger-than? htdp wiki1) false)
(check-expect (is-bigger-than? htdp wiki3) false)
(check-expect (is-bigger-than? cs wiki2) false)
(check-expect (is-bigger-than? wiki1 wiki3) false)
(check-expect (is-bigger-than? wiki3 wiki1) true)
(check-expect (is-bigger-than? wiki2 wiki2) false)

(define (is-bigger-than? bib1 bib2)
  (local (;; Author * Author -> boolean
          ;; produces true if a1 is alphabetically smaller than a2 (ignore case)
          (define (last-name-is-bigger-than? a1 a2)
            (string>? (string-downcase (author-last a1))
                      (string-downcase (author-last a2)))))
    
    (cond [(and (book? bib1) (wiki? bib2)) false]
          [(and (book? bib2) (wiki? bib1)) false]
          [(and (book? bib1) (book? bib2)) (last-name-is-bigger-than? (book-author bib1) (book-author bib2))]
          [(and (wiki? bib1) (wiki? bib2)) (last-name-is-bigger-than? (wiki-author bib1) (wiki-author bib2))])))

;; (listof Bib) -> (listof Bib)
;; produces a list without repeated elements
;; ASSUME: the list is sorted
(check-expect (filter-duplicates empty) empty)
(check-expect (filter-duplicates mdRef) mdRef)
(check-expect (filter-duplicates sapRef) sapRef)
(check-expect (filter-duplicates (sort-by-last-name w3Ref)) (list wiki2 sapiens))

(define (filter-duplicates lobib)
  (local (;; Bib * Bib -> boolean
          (define (same-bib? b1 b2)
            (cond [(and (book? b1) (wiki? b2)) false]
                  [(and (book? b2) (wiki? b1)) false]
                  [(and (book? b1) (book? b2)) (same? (list (book-title b1) (book-author b1))
                                                      (list (book-title b2) (book-author b2)))]
                  [(and (wiki? b1) (wiki? b2)) (same? (list (wiki-title b1) (wiki-author b1))
                                                      (list (wiki-title b2) (wiki-author b2)))]))

          ;; (string * author) * (string * author) -> boolean  
          (define (same? b1 b2)
            (and (string=? (first b1) (first b2))
                 (string=? (author-first (second b1)) (author-first (second b2)))
                 (string=? (author-last (second b1)) (author-last (second b2))))))
    
    (cond [(empty? lobib) empty]
          [(empty? (rest lobib)) lobib]
          [else (if (same-bib? (first lobib) (first (rest lobib)))
                    (filter-duplicates (rest lobib))
                    (cons (first lobib) (filter-duplicates (rest lobib))))])))

;; (listof Bib) -> (listof String)
;; produces a list in which every element is a string with each title and authors information
(check-expect (format-lobib empty) empty)
(check-expect (format-lobib mdRef) (list "Felleisen, Matthias. 'HtDP'"))
(check-expect (format-lobib sapRef) (list "Felleisen, Matthias. 'HtDP'" "Melville, Herman. 'Moby Dick'"))

(define (format-lobib lobib)
  (local ((define (format-bib bib)
            (cond [(book? bib) (string-append (author-last (book-author bib)) ", "
                                              (author-first (book-author bib)) ". "
                                              "'" (book-title bib) "'")]
                  [(wiki? bib) (string-append (author-last (wiki-author bib)) ", "
                                              (author-first (wiki-author bib)) ". "
                                              "'" (wiki-title bib) "'")])))
    (map format-bib lobib)))
