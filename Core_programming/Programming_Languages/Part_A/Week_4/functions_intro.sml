
fun double x = 2 * x
fun incr x = x + 1

(* (int -> int) * (int -> int) * int *)
val a_tuple = (double, incr, double(incr 7))

(* int *)      (* int -> int *)
val eighteen = (#1 a_tuple) 9