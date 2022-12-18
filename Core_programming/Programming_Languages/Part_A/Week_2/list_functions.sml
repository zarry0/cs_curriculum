
(* int list -> int
    produces the sum of all the integers in the list *)
fun sum_list (xs : int list) =
    if null (xs)
    then 0
    else hd(xs) + sum_list (tl(xs))
(* tail recursive version 
    sum is the current answer (result so far accumulator)
    call the function with sum = 0 *)
fun sum_list_tr (xs : int list, sum : int) = 
    if null(xs)
    then sum
    else sum_list_tr(tl(xs), hd(xs) + sum)

(* int -> int list 
    produces a list of ints from n to 0 *)
fun countdown (n : int) =
    if n <= 0
    then [] 
    else n::countdown(n-1)
(* tail recursive version 
    rsf is the result list so far
    call function with rsf = [] *)
fun countdown_tr (n : int, rsf : int list) = 
    if n <= 0
    then rsf
    else countdown_tr (n-1, n::rsf)

(* int list * int list -> int list 
    appends the second list onto the end of the first *)
    (*  lst1 lst2
        []   []  -> []
        []   [b] -> [b] 
        [a]  [b] -> [a, b] *)
fun append (lst1 : int list, lst2 : int list) =
    if null (lst1)
    then lst2
    else hd(lst1) :: append (tl(lst1), lst2)
(*  tail recursive version 
    rsf is a response fo far accumulator 
    call function with rsf = [] *)
fun append_tr (lst1 : int list, lst2 : int list, rsf : int list) = 
    if null (lst2)
    then hd(lst1)::rsf
    else if null (lst1)
    then append_tr (hd(lst2)::lst1, tl(lst2), rsf)
    else append_tr (tl(lst1), lst2, hd(lst1) :: rsf)

(* functions over pairs of lists *)

(* (int * int) list -> int 
    produces the sum of all the sums of pairs in the list 
    sum_pair_list([(3,4),(5,6)]) -> 18 *)
fun sum_pair_list (xs : (int * int) list) =
    if null (xs)
    then 0
    else (#1 (hd(xs))) + (#2 (hd(xs))) + sum_pair_list(tl(xs))
    
(* (int * int) list -> int list 
    produces a list with every first value of the pairs 
    firsts([(3,4),(5,6)]) -> [3,5] *)
fun firsts (xs : (int * int) list) = 
    if null (xs)
    then []
    else (#1 (hd xs)) :: firsts (tl xs)

(* (int * int) list -> int list 
    produces a list with every second value of the pairs 
    seconds([(3,4),(5,6)]) -> [4,6] *)
fun seconds (xs : (int * int) list) = 
    if null (xs)
    then []
    else (#2 (hd xs)) :: seconds (tl xs)

(* (int * int) -> int 
    produces the sum of all the values in the pairs 
    using only previously defined functions
    sum_pair_list2 ([(3,4),(5,6)]) -> 18 *)
fun sum_pair_list2 (xs : (int * int) list) = 
    sum_list ( append (firsts (xs), seconds (xs)))

(* int list -> int
    produces the product of all the numbers on the list
    list_product [] -> 1
    list_product [5] -> 5
    list_product [2,4,2] -> 16 *)
fun list_product (xs : int list) = 
    if null (xs)
    then 1
    else (hd xs) * list_product (tl xs)
(* tail recursive version 
    ans is the result so far accumulator 
    call function with ans = 1 *)
fun list_product_tr (xs : int list, ans : int) = 
    if null (xs)
    then ans
    else list_product_tr (tl xs, (hd xs)*ans)