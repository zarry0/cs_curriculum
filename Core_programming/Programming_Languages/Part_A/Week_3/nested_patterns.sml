(* Programming Languages, Dan Grossman *)
(* Section 2: Nested Patterns *)

exception ListLengthMismatch

(* don't do this *)
fun old_zip3 (l1,l2,l3) = 
    if null l1 andalso null l2 andalso null l3
    then []
    else if null l1 orelse null l2 orelse null l3
    then raise ListLengthMismatch
    else (hd l1, hd l2, hd l3) :: old_zip3(tl l1, tl l2, tl l3)

(* don't do this *)
fun shallow_zip3 (l1,l2,l3) =
    case l1 of
	[] => 
	(case l2 of 
	     [] => (case l3 of
			[] => []
		      | _ => raise ListLengthMismatch)
	   | _ => raise ListLengthMismatch)
      | hd1::tl1 => 
	(case l2 of
	     [] => raise ListLengthMismatch
	   | hd2::tl2 => (case l3 of
			      [] => raise ListLengthMismatch
			    | hd3::tl3 => 
			      (hd1,hd2,hd3)::shallow_zip3(tl1,tl2,tl3)))

(* do this *)
fun zip3 list_triple =
    case list_triple of 
	([],[],[]) => []
      | (hd1::tl1,hd2::tl2,hd3::tl3) => (hd1,hd2,hd3)::zip3(tl1,tl2,tl3)
      | _ => raise ListLengthMismatch

(* and the inverse *)
fun unzip3 lst =
    case lst of
	[] => ([],[],[])
      | (a,b,c)::tl => let val (l1,l2,l3) = unzip3 tl
		       in
			   (a::l1,b::l2,c::l3)
		       end

(*  int list -> bool
    produces true if the list has no numbers in decreasing order *)
fun nondecreasing (xs) =
    case xs of
        []         => true
    |   _::[]      => true
    |   x::(y::xs) => x<=y andalso nondecreasing(y::xs)

datatype sng = P | N | Z

(*  int * int -> sng
    produces the resulting sign of the multiplication  *)
fun multsign (x1, x2) =
    let fun sign x = if x=0 then Z else if x>0 then P else N
    in 
    case (sign x1, sign x2) of
        (Z,_) => Z
    |   (_,Z) => Z
    |   (N,N) => P
    |   (P,P) => P
    |   _     => N
    end

(*  'a list -> int
    produces the lenght of the given list *)
fun len (xs) =
    case xs of 
        [] => 0
    |   _::xs => 1 + len(xs)

