(* Programming Languages, Dan Grossman *)
(* Section 3: Lexical Scope *)

(* 1 *) val x = 1
        (* x maps to 1 *)
(* 2 *) fun f y = x + y
        (* f maps to a function that adds 1 (bc x=1) to its arg *)
(* 3 *) val x = 2
        (* x maps to 2 (shadowing) *)
(* 4 *) val y = 3
        (* y maps to 3 *)
(* 5 *) val z = f (x + y)
        (* call f(2 + 3) or f(5) *)
        (* returns 6 *)
