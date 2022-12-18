
(*This is a comment. This is our first program.*)

val x = 34;        
(* static environment: x : int *)         
(* dynamic environment: x --> 34 *)

val y = 17;   
(* static environment: x : int, y : int *)              
(* dynamic environment: x --> 34, y --> 17 *)

val z = (x + y) + (y + 2);  
(* static environment: x : int, y : int, z : int *)
(* dynamic environment: x --> 34, y --> 17, z --> 70 *)

val q = z + 1;
(* static environment: x : int, y : int, z : int, q : int *)             
(* dynamic environment: x --> 34, y --> 17, z --> 70, q --> 71 *)

val abs_of_z = if z < 0 then 0 - z else z;
(* static environment: ..., abs_of_z : int *)
(* dynamic environment: ..., abs_of_z --> 70*)

val abs_of_z_simpler = abs(z);

(*
Syntax, type-checking rules, and evaluation rules for less-than comparisons?

Syntax:
        e1 < e2
    where e1 and e2 are subexpresions

Type-checking:
    e1 and e2 must be type int and the type of the expression is bool

Evaluation rules:
    first evaluate e1 to v1
    then evlauate e2 to v2
    finally if v1 < v2 the result is true
         of if v1 > v2 the result is false
*)