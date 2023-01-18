
(* int -> (int -> (int -> bool)) *)
fun sorted3 x y z = z >= y andalso y >= x

(* ('a * 'b -> 'a) -> ('a -> ('b list -> 'a)) *)
fun fold f acc xs =
    case xs of
        []    => acc
    |   x::xs => fold f (f(acc,x)) xs

(*  if a curried function is applied to "too few" arguments, that
    returns, which is often useful.
    A powerful idiom (no new semantics) *)

(* int -> bool *)
val is_nonnegative = sorted3 0 0

(* int list -> int *)
val sum = fold (fn (x,y) => x+y) 0

(*  In fact, not doing this is often a harder-to-notice version of
    unnecessary function wrapping, as in these inferior versions *)

fun is_nonnegative_inferior x = sorted3 0 0 x

fun sum_inferior xs = fold (fn (x,y) => x+y) 0 xs

(* another example *)

(* int -> (int -> int list) *)
fun range i j = if i > j then [] else i :: range (i+1) j
(* fun r i = fn j => if i > j then [] else i :: r(i+1) j *)

(* int -> int list *)
val countup = range 1

fun countup_inferior x = range 1 x

(*  common style is to curry higher-order functions with function arguments
    first to enable convenient partial aplication *)

(* ('a -> bool) -> ('a list -> bool) *)
fun exists predicate xs =
    case xs of
        [] => false
    |   x::xs => predicate x orelse exists predicate xs

val no = exists (fn x => x=7) [4,11,23] (* false *)

(* int list -> bool *)
val hasZero = exists (fn x => x=0)

(* int list -> int list *)
val incrementAll = List.map (fn x => x + 1)

(* Library functions foldl, List.filter, etc also curried *)

(* int list -> int list *)
val removeZeros = List.filter (fn x => x <> 0)

(*  but if you get a strange message about "value restriction",
    put back in the actually-necessary wrapping or an explicit 
    non-polymorphic type *)

(* doesn't work for reasons we won't explain here (more later) *)
(* (only an issue with polymorphic functions) *)

(* 'a list -> ('a * int) list *)
val pairWithOne = List.map (fn x => (x,1))

(* workarrounds: *)

(* no longer innecessary function wrapping *)
(* 'a list -> ('a * int) list *)
fun pairWithOne xs = List.map (fn x => (x,1)) xs

val pairWithOne : string list -> (string * int) list = List.map (fn x => (x,1))

(* this function works fine because result is not polymorphic *)
(* itn list -> (int * int) list *)
val incrementAndPairWithOne = List.map (fn x => (x+1,1))

