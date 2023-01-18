
(* generic functions to switch how/whether currying is used *)
(* in each case, the type tell you a lot *)

(* example *)

(* ('a * 'b -> 'c) -> ('a -> ('b -> 'c)) *)
fun curry f = fn x => fn y => f(x,y)

(* ('a -> ('b -> 'c)) -> ('a * 'b -> 'c)   *)
fun uncurry f (x,y) = f x y

(* ('a -> ('b -> 'c)) -> ('b -> ('a -> 'c)) *)
fun other_curry f x y = f y x

(* tupled but we wish it were curried *)
(* int * int -> int list *)
fun range (i,j) = if i > j then [] else i :: range(i+1, j)

(* int -> int list *)
val countup = curry range 1

val xs = countup 7 (* [1,2,3,4,5,6,7] *)