
(* int -> int list
    produces a list with all the integers from 1 to x 
    countup_from1(5) -> [1,2,3,4,5] *)
fun countup_from1(x : int) =
    (* int  -> int list 
        produces a list of the integers between the given int and x 
        count(3) -> [3,4,5,6] {with x = 6} *)
    let
        fun count (from : int) = 
            if from >= x
            then x :: []
            else from :: count(from+1)
    in
        count(1)
    end