val emptyList = [];
val list1 = [1,2,3,4,5];
val list2 = [(3+4), 5+5, 8];
val booleanList = [true, true, false, true, false, false];
(* val bad_list = [1, 2, true] *)

(* cons notation, e1::e2 *) (* (cons v (listof v)) *)
val list3 = [1,2,3,4];
val list4 = 24::list3;
val x = [7,8,9];
val list5 = 6::5::x
(* val bad_cons = [6]::x     left part must be a value and not a list *)
val good_cons = [6]::[[1], [2,3], [4,5,7]]

val isNull = null [] (* true *)
val notNull = null x (* false *)

val first_of_x = hd x (* 7 *)
val rest_of_x = tl x (* [8,9] *)

