
fun hd xs =
    case xs of
        [] => raise List.Empty
    |   x::_ => x

exception MyUndesirableCondition (* Exceptions have type exn *)

exception MyOtherException of int * int

fun mydiv (x,y) =
    if y=0
    then raise MyUndesirableCondition
    else x div y

fun mymod (x,y) =
if y=0
then raise MyOtherException(x,y)
else x mod y

(* int list * exn -> int *)
fun maxlist (xs, ex) = 
    case xs of
        [] => raise ex
    |   x::[] => x
    |   x::xs => Int.max(x, maxlist(xs, ex))

val w = maxlist ([3,4,5], MyUndesirableCondition)

val x = maxlist ([3,4,5], MyUndesirableCondition)
        handle MyUndesirableCondition => 42

val z = maxlist ([], MyUndesirableCondition)
        handle MyUndesirableCondition => 42