
(*  ('a -> 'a) * int * 'a -> 'a
    abstract function for aplying f() to x, n times *)
fun n_times (f,n,x) = 
    if n=0
    then x
    else f(n_times(f,n,x))

(*  int -> int
    produces the input times 3 *)
fun triple y = 3*y

(*  int * int -> int
    produces 3*x n times *)
fun triple_n_times_v1 (n,x) = n_times(triple,n,x)

fun triple_n_times_v2 (n,x) = 
    let fun triple y = 3*y
    in n_times(triple,n,x)
    end

fun triple_n_times_v3 (n,x) = 
    n_times(let fun triple y = 3*y in triple end, n, x)
    
fun triple_n_times_v4 (n,x) = n_times((fn y => 3*y), n,x)

(* poor style *)
val triple_n_times_v5 = fn (n, x) => n_times((fn y => 3*y),n,x)