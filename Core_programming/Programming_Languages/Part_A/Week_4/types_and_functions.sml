
(*  ('a -> 'a) * int * 'a -> 'a
    abstract function for aplying f() to x, n times *)
fun n_times (f,n,x) = 
    if n=0
    then x
    else f(n_times(f,n,x))

(* int -> int *)
fun increment x = x+1

(* int -> int *)
fun double x = 2*x 

val x1 = n_times(increment,4,7)      (* instantiates 'a with int *)
val x2 = n_times(double,4,7)         (* instantiates 'a with int *)
val x3 = n_times(tl,3,[4,8,14,16])   (* instantiates 'a with int list *)

(* higher-order functions are often polymorphic but not always *)
(* NOTE: a tail-recursive version would be a better implementation *)

(*  (int -> int) * int -> int
    abstract function for adding 1 until x becomes 0 by aplying f() to it 
    in other words, how many times we have to call f (f ( f( ... f (x)))) until x becomes 0*)
fun times_until_zero (f,x) =
    if x=0 then 0 else 1 + times_until_zero(f, f x)

(* conversely, some polymorphic functions are not higher-order *)
(*  'a list -> int
    produces the length of the given list *)
fun len [] = 0
|   len _::xs = 1 + len(xs)