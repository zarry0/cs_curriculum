
(* int list -> int 
    produces the largest integer on the list
    my_max ([1,10,3,4,6,8,20,7]) -> 20
    my_max ([]) -> 0 *)
fun old_max (xs : int list) =
    if null (xs)
    then 0 (* bad style *)
    else 
        let
            val first = hd xs
            val rest_max = old_max(tl xs) 
        in
            if first > rest_max
            then first
            else rest_max
        end

(* better: return an int option *)

(* int list -> int option
    produces the largest integer on the list
    my_max ([1,10,3,4,6,8,20,7]) -> 20
    my_max ([]) -> NONE *)
fun max1 (xs : int list) =
    if null (xs)
    then NONE
    else 
        let
            val first = hd xs
            val rest_max = max1(tl xs) 
        in
            if (isSome rest_max) andalso valOf rest_max > first
            then rest_max
            else SOME (first)
        end

(* int list -> int option
    produces the largest integer on the list
    my_max ([1,10,3,4,6,8,20,7]) -> 20
    my_max ([]) -> NONE *)
fun max2 (xs : int list) =
    if null (xs)
    then NONE
    else
        let (* at this point the list is not empty *)
            (* int list -> int 
               produces the maximum integer in the list
               ASSUME: the list wont be empty *)
            fun max_nonempty (xs : int list) =
                if null (tl xs)
                then hd xs
                else 
                    let
                        val first = (hd xs)
                        val rest = max_nonempty(tl xs)
                    in
                        if first > rest
                        then first
                        else rest
                    end
        in
            SOME (max_nonempty xs)
        end
