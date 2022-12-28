
(*  int * int * int -> int
    produces the sum of the triple *)

fun sum_triple_v1 (t) : int =
    case t of (x,y,z) => x + y + z

fun sum_triple_v2 (t) : int =
    let val (x,y,z) = t
    in x + y + z end

fun sum_triple_v3 (x,y,z) : int =
    x + y + z


(*  {first : string, middle : string, last : string} -> string
    produces the full name of the person in the form of a string *)

fun full_name_v1 (r) : string =
    case r of 
        {first=x, middle=y, last=z} => x ^ " " ^ y ^ " " ^ z 

fun full_name_v2 (r) : string = 
    let val {first=x, middle=y, last=z} = r
    in  x ^ " " ^ y ^ " " ^ z  end

fun full_name_v3 {first=x, middle=y, last=z} : string = 
    x ^ " " ^ y ^ " " ^ z