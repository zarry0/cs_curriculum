
(* first example *)
val x = 1

(* int -> (int -> int) *)
fun f y =
    let val x = y+1
    in
        fn z => x+y+z (* (y+1+y+z) = 2y + z + 1 *)
    end

val x = 3      (* 3 *)
val g = f 4    (* (int -> int) fn z => 5+4+z *)
val y = 5      
val z = g 6    (* 5+4+6 = 15 *)

(* second example *)

(* (int -> 'a) -> 'a *)
fun f g =
    let val x = 3
    in g 2
    end

val x = 4
fun h y = x + y (* (int -> int) x will always be 4 in h *)
val z = f h     (* h(2) = 4 + 2 = 6 *)