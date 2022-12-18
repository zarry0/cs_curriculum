(* Examples to demonstrate shadowing *)

val a = 10
(* a : int
   a -> 10 *)

val b = a * 2
(* a -> 10
   b -> 20 *)

val a = 5    (* this is not an assignment statement *)  
(* b -> 20
   a -> 5 *)

val c = b
(* a -> 5
   b -> 20
   c -> 20 *)

val d = a
(* a -> 5
   b -> 20
   c -> 20 
   d -> 5 *)

val a = a + 1
(* a -> 6
   b -> 20
   c -> 20 
   d -> 5 *)   

(* val g = f - 3 *) (* can't do a forward reference, bc at this point f doesn't exist in the dynamic env. *)

val f = a * 2
(* a -> 6
   b -> 20
   c -> 20 
   d -> 5
   f -> 12 *)