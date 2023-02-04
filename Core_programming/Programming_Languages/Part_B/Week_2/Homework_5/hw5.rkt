;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs but /is/ a MUPL value; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1

;; A MUPL list is
;;  - (aunit)
;;  - (apair e1 MUPLlist)

;; Racket list -> MUPL list
;; produces a MUPLlist from the values of the given Racket list (preserving order)
(define (racketlist->mupllist rlst)
  (if (null? rlst)
      (aunit)
      (apair (car rlst) (racketlist->mupllist (cdr rlst)))))

;; MUPL list -> Racket list
;; produces a Racket list from the values of the given MUPLlist (preserving order)
(define (mupllist->racketlist mlst)
  (if (aunit? mlst)
      null
      (cons (apair-e1 mlst) (mupllist->racketlist (apair-e2 mlst)))))

;; Problem 2

;; lookup a variable in an environment
;; Do NOT change this function
;; env string -> value
;; produces the value mapped to the given variable name
;;          an error if the variable is not in the env
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) (envlookup env (var-string e))]
        [(int? e) e]        
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]        
        [(ifgreater? e)
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)])
           (if (and (int? v1) (int? v2))
               (if (> (int-num v1) (int-num v2))
                   (eval-under-env (ifgreater-e3 e) env)
                   (eval-under-env (ifgreater-e4 e) env))
               (error "MUPL ifgreater applied to non-number")))]        
        [(fun? e) (closure env e)]
        [(call? e)
         (let ([fn-closure (eval-under-env (call-funexp e) env)]
               [arg        (eval-under-env (call-actual e) env)])
           (if (closure? fn-closure)
               (let* ([fn       (closure-fun fn-closure)]
                      [fn-name  (fun-nameopt fn)]
                      [fn-body  (fun-body fn)]
                      [new-env  (cons (cons (fun-formal fn) arg) (closure-env fn-closure))])
                 (if fn-name
                     (eval-under-env fn-body (cons (cons fn-name fn-closure) new-env))
                     (eval-under-env fn-body new-env)))
               (error "call expression is not a clossure")))]        
        [(mlet? e)
         (let ([v (eval-under-env (mlet-e e) env)])
           (eval-under-env (mlet-body e) (cons (cons (mlet-var e) v) env)))]
        [(apair? e)
         (let ([v1 (eval-under-env (apair-e1 e) env)]
               [v2 (eval-under-env (apair-e2 e) env)])
           (apair v1 v2))]
        [(fst? e)
         (let ([v (eval-under-env (fst-e e) env)])
           (if (apair? v)
               (apair-e1 v)
               (error "fst expected a pair, given something else")))]
        [(snd? e)
         (let ([v (eval-under-env (snd-e e) env)])
           (if (apair? v)
               (apair-e2 v)
               (error "snd expected a pair, given something else")))]
        [(aunit? e) e]
        [(isaunit? e)
         (if (aunit? (eval-under-env (isaunit-e e) env))
             (int 1)
             (int 0))]
        [(closure? e) e]
        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3

;; MUPL exp * MUPL exp * MUPL exp -> MUPL exp
;; produces e2 if e1 is (aunit), e3 otherwise
(define (ifaunit e1 e2 e3)
  (ifgreater (isaunit e1) (int 0) e2 e3))

;; Racket (listof '(string * MUPL exp)) * MUPL exp -> MUPL exp
;; produces a MUPL exp so that every MUPL binding in lstlst is on the scope of e2
(define (mlet* lstlst e2)
  (if (null? lstlst)
      e2
      (mlet (caar lstlst) (cdar lstlst)
            (mlet* (cdr lstlst) e2))))

;; MUPL exp * MUPL exp * MUPL exp * MUPL exp -> MUPL exp
;; produces e3 if e1 = e2, e4 otherwise
;; NOTE: e1 and e2 are only evaluated once
(define (ifeq e1 e2 e3 e4)
  (mlet* (list (cons "_x" e1) (cons "_y" e2))
         (ifgreater (var "_x") (var "_y")
                    e4
                    (ifgreater (var "_y") (var "_x")
                               e4
                               e3))))

;; Problem 4

;; (MUPL exp -> MUPL exp) -> (MUPL list -> MUPL list)
;; an abstract map function for MUPL lists (curried)
(define mupl-map
  (fun #f "g"
       (fun "inner-map" "xs"
            (ifaunit (var "xs")
                     (aunit)
                     (apair (call (var "g") (fst (var "xs")))
                            (call (var "inner-map") (snd (var "xs"))))))))

;; MUPL int -> (MUPL int list -> MUPL int list) 
;; produces a function that takes a list of MUPL ints
;; and returns a MUPL list with every int plus i
(define mupl-mapAddN 
  (mlet "map" mupl-map
        (fun #f "i"
             (call (var "map") (fun #f "x" (add (var "x") (var "i")))))))

;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
;; MUPL exp -> MUPL exp
;; produces an equivalent expression using fun-challenge instead of fun
(define (compute-free-vars e)
  (cond [(fun? e) (fun-challenge (fun-nameopt e)
                                 (fun-formal e)
                                 (compute-free-vars (fun-body e))
                                 (get-free-vars e))]
        [(add? e) (add (compute-free-vars (add-e1 e))
                       (compute-free-vars (add-e2 e)))]
        [(ifgreater? e) (ifgreater (compute-free-vars (ifgreater-e1 e))
                                   (compute-free-vars (ifgreater-e2 e))
                                   (compute-free-vars (ifgreater-e3 e))
                                   (compute-free-vars (ifgreater-e4 e)))]
        [(call? e) (call (compute-free-vars (call-funexp e))
                         (compute-free-vars (call-actual e)))]
        [(mlet? e) (mlet (mlet-var e)
                         (compute-free-vars (mlet-e e))
                         (compute-free-vars (mlet-body e)))]
        [(apair? e) (apair (compute-free-vars (apair-e1 e))
                           (compute-free-vars (apair-e2 e)))]
        [(fst? e) (fst (compute-free-vars (fst-e e)))]
        [(snd? e) (snd (compute-free-vars (snd-e e)))]
        [(isaunit? e) (isaunit (compute-free-vars (isaunit-e e)))]
        [else e]))

;; MUPL fun -> Racket string set
;; produces a set that contains the free variables in the function body
(define (get-free-vars e)
  (set-subtract (get-vars (fun-body e))
                (get-defined-vars e)))

;; MUPL exp -> Racket string set
;; produces a set with all the variables in the expression
(define (get-vars e)
  (cond [(var? e) (set (var-string e))]
        [(add? e) (set-union (get-vars (add-e1 e))
                             (get-vars (add-e2 e)))]
        [(ifgreater? e) (set-union (get-vars (ifgreater-e1 e))
                                   (get-vars (ifgreater-e2 e))
                                   (get-vars (ifgreater-e3 e))
                                   (get-vars (ifgreater-e4 e)))]
        [(fun? e) (get-free-vars e)]
        [(call? e) (set-union (get-vars (call-funexp e))
                              (get-vars (call-actual e)))]
        [(mlet? e) (set-union (get-vars (mlet-e e))
                              (get-vars (mlet-body e)))]
        [(apair? e) (set-union (get-vars (apair-e1 e))
                               (get-vars (apair-e2 e)))]
        [(fst? e) (get-vars (fst-e e))]
        [(snd? e) (get-vars (snd-e e))]
        [(isaunit? e) (get-vars (isaunit-e e))]
        [else (set)]))

;; MUPL exp -> Racket string set
;; produces a set containing every variable defined within the given exp
(define (get-defined-vars e)
  (cond [(fun? e) (set-union (set (fun-formal e))
                             (get-defined-vars (fun-body e)))] 
        [(mlet? e) (set-union (set (mlet-var e))
                              (get-defined-vars (mlet-e e))
                              (get-defined-vars (mlet-body e)))]
        [else (set)]))

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env)
  (cond [(var? e) (envlookup env (var-string e))]
        [(int? e) e]        
        [(add? e) 
         (let ([v1 (eval-under-env-c (add-e1 e) env)]
               [v2 (eval-under-env-c (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]        
        [(ifgreater? e)
         (let ([v1 (eval-under-env-c (ifgreater-e1 e) env)]
               [v2 (eval-under-env-c (ifgreater-e2 e) env)])
           (if (and (int? v1) (int? v2))
               (if (> (int-num v1) (int-num v2))
                   (eval-under-env-c (ifgreater-e3 e) env)
                   (eval-under-env-c (ifgreater-e4 e) env))
               (error "MUPL ifgreater applied to non-number")))]        
        [(fun-challenge? e) (closure (reduced-env e env) e)]
        [(call? e)
         (let ([fn-closure (eval-under-env-c (call-funexp e) env)]
               [arg        (eval-under-env-c (call-actual e) env)])
           (if (closure? fn-closure)
               (let* ([fn       (closure-fun fn-closure)]
                      [fn-name  (fun-challenge-nameopt fn)]
                      [fn-body  (fun-challenge-body fn)]
                      [new-env  (cons (cons (fun-challenge-formal fn) arg) (closure-env fn-closure))])
                 (if fn-name
                     (eval-under-env-c fn-body (cons (cons fn-name fn-closure) new-env))
                     (eval-under-env-c fn-body new-env)))
               (error "call expression is not a clossure")))]        
        [(mlet? e)
         (let ([v (eval-under-env-c (mlet-e e) env)])
           (eval-under-env-c (mlet-body e) (cons (cons (mlet-var e) v) env)))]
        [(apair? e)
         (let ([v1 (eval-under-env-c (apair-e1 e) env)]
               [v2 (eval-under-env-c (apair-e2 e) env)])
           (apair v1 v2))]
        [(fst? e)
         (let ([v (eval-under-env-c (fst-e e) env)])
           (if (apair? v)
               (apair-e1 v)
               (error "fst expected a pair, given something else")))]
        [(snd? e)
         (let ([v (eval-under-env-c (snd-e e) env)])
           (if (apair? v)
               (apair-e2 v)
               (error "snd expected a pair, given something else")))]
        [(aunit? e) e]
        [(isaunit? e)
         (if (aunit? (eval-under-env-c (isaunit-e e) env))
             (int 1)
             (int 0))]
        [(closure? e) e]
        [#t (error (format "bad MUPL expression: ~v" e))]))

;; MUPL fun-challenge * MUPL env -> MUPL env
;; produces a reduced environment holding only the freevars bindings
(define (reduced-env e env)
  (foldr (lambda (v ans)
           (let ([v1 (assoc v env)])
             (if v1
                 (cons v1 ans)
                 ans)))
         null (set->list(fun-challenge-freevars e))))

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))
