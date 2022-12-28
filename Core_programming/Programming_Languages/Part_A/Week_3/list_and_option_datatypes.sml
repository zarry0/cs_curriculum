
(* (list of int) is
     - empty
     - (cons int (listof int))
    interp. a list of ints
*)
datatype my_int_list = empty
                     | Cons of (int * my_int_list) 

val L1 = empty
val L2 = Cons(1, empty)
val L3 = Cons(1, Cons(2, Cons(3, Cons(4, Cons(5, empty)))))

fun append_my_int_list(l1 : my_int_list, l2 : my_int_list) : my_int_list = 
    case l1 of 
        empty => l2
    |   Cons(first, rest) => Cons(first, append_my_int_list(rest, l2)) 


(* Using case to catch optional values *)

(* int option -> int
   if the option  has a value, increaces it by 1, 0 otherwise *)
fun inc_or_zero (intoption : int option) : int =
    case intoption of
        NONE => 0
    |   SOME i => i + 1 

(* Using case instead of hd, tl or null *)

(*  int list -> int
    produces the sum of all the ints in the list *)
fun sum_list (xs : int list) : int =
    case xs of
        []          => 0
    |   first::rest => first + sum_list(rest)

(*  int list * int list -> int list
    produces a list that's the result of appending l2 onto l1 *)
fun append (l1 : int list, l2 : int list) : int list = 
    case l1 of
        []          => l2
    |   first::rest => first :: append(rest, l2)