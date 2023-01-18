
(*  ('a -> 'a) * int * 'a -> 'a
    abstract function for aplying f() to x, n times *)
fun n_times (f,n,x) = 
    if n=0
    then x
    else f(n_times(f,n,x))

fun nth_tail1(n,xs) = n_times((fn y => tl y),n,xs) (* poor style *)
fun nth_tail2(n,xs) = n_times(tl,n,xs)             (* better *)