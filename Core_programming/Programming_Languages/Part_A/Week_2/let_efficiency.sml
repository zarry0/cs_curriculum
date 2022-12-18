
(* badly named: evaluates to 0 on empty list *)
fun bad_max (xs : int list) =
    if null xs
    then 0 (* note: bad style; raise exception instead *)
    else if null (tl xs)
    then hd xs
    else if hd xs > bad_max(tl xs)
    then hd xs
    else bad_max(tl xs)

(* int list -> int 
    produces the largest integer on the list
    my_max ([1,10,3,4,6,8,20,7]) -> 20
    my_max ([]) -> 0 *)
fun good_max (xs : int list) =
    if null (xs)
    then 0
    else 
        let
            val first = hd xs
            val rest_max = good_max(tl xs) 
        in
            if first > rest_max
            then first
            else rest_max
        end

(* int * int -> int
    produces a list of the form [from, from+1, ..., to] *)
fun countup (from : int, to : int) =
    if from = to
    then to :: []
    else from :: countup(from+1, to)

(* int * int -> int
    produces a list of the form [from, from-1, ..., to] *)
fun countdown (from : int, to : int) =
    if from = to
    then to :: []
    else from :: countdown(from-1, to)