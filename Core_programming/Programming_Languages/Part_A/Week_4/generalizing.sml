

(* Returning a function *)
(*  (int -> bool) -> (int -> int)
    produces a function to double if f(7) is true,
    otherwise produces a function to triple  *)
fun double_or_triple f =
    if f 7
    then fn x => 2*x
    else fn x => 3*x

val double = double_or_triple(fn x => x-3 = 4)
val triple = double_or_triple(fn x => x-3 = 4)
val nine = double_or_triple(fn x => false) (3)

(* Higher-order functions over our own datatype bindings *)

datatype exp = Constant of int
            |  Negate of exp
            |  Add of exp * exp
            |  Multiply of exp * exp

(* given an exp, is every constant in it an even number? *)

(* Traditional solution: *)
(*  exp -> bool
    produces true if every constant is an even number *)
fun all_even_v1 (e) = 
    case e of
        Constant i => i mod 2 = 0
    |   Negate e1 => all_even_v1(e1)
    |   Add(e1,e2) => all_even_v1(e1) andalso all_even_v1(e2)
    |   Multiply(e1,e2) => all_even_v1(e1) andalso all_even_v1(e2)

(* Abstract solution *)
(*  (int -> bool) * exp -> bool 
    produces true if all the constants in e return true for f() *)
fun true_of_all_constants (f,e) =
    case e of
        Constant i => f(e)
    |   Negate e1 => true_of_all_constants(f,e1)
    |   Add(e1,e2) => true_of_all_constants(f,e1) andalso true_of_all_constants(f,e2)
    |   Multiply(e1,e2) => true_of_all_constants(f,e1) andalso true_of_all_constants(f,e2)

fun all_even_v2 e = true_of_all_constants((fn i => i mod 2 = 0), e)