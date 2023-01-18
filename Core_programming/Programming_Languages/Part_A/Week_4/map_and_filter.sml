

(*  ('a -> 'b) * 'a list -> 'b list
    given f() and [x1, x2, ..., xn] produces [f(x1), f(x2), ..., f(xn)] *)
fun map (f,xs) =
    case xs of
        [] => []
    |   x::xs => f(x)::map(f,xs)

val x1 = map((fn x => x+1),[4,8,12,16]) (* [5.9,13,16] *)
val x2 = map(hd,[[1,2],[3,4],[5,6,7]])  (* [1,3,5] *)

(*  ('a -> bool) * 'a list -> 'a list 
    produces a list for which each element f(x) = true *)
fun filter (f,xs) =
    case xs of 
        [] => []
    |   x::xs => if f(x) then x::filter(f,xs) else filter(f,xs) 

(*  int -> bool
    produces true if the number is even, false otherwise *)
fun is_even v = v mod 2 = 0

(*  int list -> int list
    produces a list of only even numbers *)
fun all_even (xs) = filter(is_even, xs)

(*  (int * int) list -> (int * int) list
    produces a list of pairs for which the second element of each pair is even *)
fun all_even_snd (xs) = filter((fn (_,v) => is_even(v)), xs)