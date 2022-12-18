(* (int * bool) -> (bool * int) 
   produces a pair where the given pair values are swapped*)
fun swap (pr : int*bool) = 
    (#2 pr, #1 pr)

(* (int * int) * (int * int) -> int 
    produces the sum of the values from the two input pairs *)
fun sum_two_pairs (p1 : int*int, p2 : int*int) = 
    (#1 p1) + (#1 p2) + (#2 p1) + (#2 p2)

(*  int * int -> (int * int)
    produces a pair with the result of dividing x by y and the remainder of the operation *)
fun div_mod (x : int, y : int) = 
    (x div y, x mod y)

(*  (int * int) -> (int * int)
    produces a pair with sorted elements in ascending order *)
fun sort_pair (pr : int*int) = 
    if (#1 pr) > (#2 pr)
    then (#2 pr, #1 pr)
    else pr