(* Programming Languages, Dan Grossman *)
(* Section 1: Some Errors *)

(* This program has several errors in it so we can try to debug them. *)

val x = 34

(* y = x + 1 *)
val y = x + 1

(* val z = if y then 34 else x < 4 *)
val z = if y > 0 then false else x < 4

(* val q = if y > 0 then 0 *)
val q = if y > 0 then 0 else 42

(* val a = -5 *)
val a = ~5  (* ~ is the negation of the argument *)

val w = 0

(* val fun = 34 *)
val funny = 34

(* val v = x / w *)
val v = x div (w + 1) (* division for integers (/ is for reals) *)

(* val fourteen = 7 - 7 *)
val fourteen = 7 + 7