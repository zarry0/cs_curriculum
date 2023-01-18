
(* int * int -> int 
   silly: computes n+x *)
fun increment_n_times_lame (n,x) = 
    if n=0
    then x
    else 1 + increment_n_times_lame(n-1,x)

(*  int * int -> int 
    silly: computes 2^n*x *)
fun double_n_times_lame (n,x) =
    if n=0
    then x
    else 2 * double_n_times_lame(n-1,x)

(*  int * a' list -> a' list 
    produces the last nth elements of the list *)
fun nth_tail_lame (n,xs) = (* example 3, [4,8,12,16] -> [16] *)
    if n=0
    then xs
    else tl (nth_tail_lame(n-1, xs))

(*  ('a -> 'a) * int * 'a -> 'a
    abstract function for aplying f() to x, n times *)
fun n_times (f,n,x) = 
    if n=0
    then x
    else f(n_times(f,n,x))

fun increment x = x+1
fun double x = 2*x 

val x1 = n_times(increment,4,7)
val x2 = n_times(double,4,7)
val x3 = n_times(tl,3,[4,8,14,16])

(* better versions of the three original ones *)
fun addition (n,x) = n_times(increment,n,x)
fun double_n_times (n,x) = n_times(double,n,x)
fun nth_tail(n,x) = n_times(tl,n,x)