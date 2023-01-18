
(* old way to get multiple arguments *)

(* int * int * int -> bool *)
fun sorted3_tupled (x,y,z) = z >= y andalso y >= x
val t1 = sorted3_tupled(7,9,11)

(* new way: currying *)

(* int -> (int -> (int -> bool)) *)
val sorted3 = fn x => fn y => fn z => z >= y andalso y >= x
(* fun sorted3 x = fn y => fn z => ... *)

val t2 = (sorted3 7) (9) (11)
val t3 = sorted3 8 9 10

(* 
val wrong1 = sorted3_tupled 7 9 11
val wrong1 = sorted3 (7,9,11)
*)

fun sorted3_nicer x y z = z >= y andalso y >= x
val t4 = sorted3_nicer 7 9 11

(* a more useful example *)
fun fold f acc xs =
    case xs of
        []    => acc
    |   x::xs => fold f (f(acc,x)) xs

(* a call to curried fold: will improve this call next *)
fun sum xs = fold (fn (x,y) => x+y) 0 xs