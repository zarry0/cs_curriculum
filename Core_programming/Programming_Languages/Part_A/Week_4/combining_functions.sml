
(* ('a -> 'c) * ('b -> 'a) -> ('b -> 'c) *)
fun compose (f,g) = fn x => f(g x)

(* int -> real *)
fun sqrt_of_abs_v1 i = Math.sqrt (Real.fromInt (abs i))
fun sqrt_of_abs_v2 i = (Math.sqrt o Real.fromInt o abs) i
val sqrt_of_abs_v3 = Math.sqrt o Real.fromInt o abs

(* |> !> *)
infix |>
fun x |> f = f x
fun sqrt_of_abs i = i |> abs |> Real.fromInt |> Math.sqrt

(* ('a -> 'b option) * ('a -> 'b) -> ('a -> 'b) *)
fun backup1 (f,g) = fn x => case f x of 
                                NONE => g x
                            |   SOME y => y

(* ('a -> 'b) * ('a -> 'b) -> ('a -> 'b) *)
fun backup2 (f,g) = fn x => f x handle _ => g x