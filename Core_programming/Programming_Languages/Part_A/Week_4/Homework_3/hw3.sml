
exception NoAnswer

(* 1)
    string list -> string list
    produces a list of only strings that start with uppercase
    ASSUME: all strings have at least 1 character *)
val only_capitals = List.filter (fn s => Char.isUpper(String.sub(s,0))) 

(* 2)
    string list -> string
    produces the longest string in the list
    if the list is empty produce ""
    if there is a tie, produce the string closest to the list head *)
val longest_string1 = List.foldl (fn (s1, s2) => if String.size(s1) > String.size(s2) then s1 else s2) "" 

(* 3)
    string list -> string
    produces the longest string in the list
    if the list is empty produce ""
    if there is a tie, produce the string closest to the list tail *)
val longest_string2 = List.foldl (fn (s1, s2) => if String.size(s1) >= String.size(s2) then s1 else s2) ""

(* 4a)
    (int * int -> bool) -> string list -> string
    produces the longest string in the list, "" if empty
    in case of a tie, depends on the behavior of f()  *)
fun longest_string_helper f lst = 
    List.foldl (fn (s1,s2) => if f(String.size s1,String.size s2) then s1 else s2) "" lst

(* 4b)
    string list -> string
    produces the longest string in the list
    if the list is empty produce ""
    if there is a tie, produce the string closest to the list head *)
val longest_string3 = longest_string_helper (fn (x,y) => x > y)

(* 4c)
    string list -> string
    produces the longest string in the list
    if the list is empty produce ""
    if there is a tie, produce the string closest to the list tail *)
val longest_string4 = longest_string_helper (fn (x,y) => x >= y)

(* 5)
    string list -> string
    produces the longest string that begins with uppercase, 
    produces "" if can't find any capitalized string *)
val longest_capitalized = longest_string1 o only_capitals

(* 6)
    string -> string
    produces the string reversed *)
val rev_string = String.implode o List.rev o String.explode

(* 7)
    ('a -> 'b option) -> ('a list -> 'b)
    produces the first element v of lst for which f(v) produces SOME v
    raise NoAnswer exception if all elements of lst produce NONE when passed to f *)
fun first_answer f lst =
    case lst of
        [] => raise NoAnswer
    |   hd::tl => case f(hd) of 
                NONE => first_answer f tl
            |   SOME v => v

(* 8)
    ('a -> 'b list option) -> ('a list -> 'b list option)
    produces NONE if any element v of lst produces NONE when passed to f
    produces SOME lst, where lst is the result of every call f(v) appended together
    NOTE: all_answers f [] should produce SOME []  *)
fun all_answers f lst = 
    let fun aux ([], acc) = SOME acc
        |   aux (hd::tl, acc) = 
                case f(hd) of
                    NONE => NONE
                |   SOME xs => aux (tl, acc @ xs)
    in
        aux(lst,[])
    end

(******** Datatype definitions for the rest of the problems ********)

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

(* (unit -> int) -> ((string -> int) -> (pattern -> int))  *)
fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end



(* 9a) 
    pattern -> int
    produces the number of Wildcards in the pattern *)
val count_wildcards = g (fn () => 1) (fn _ => 0)

(* 9b)
    pattern -> int
    produces the number of Wildcards plus the length of all Variable name string in t he pattern *)
val count_wild_and_variable_lengths = g (fn () => 1) (fn s => String.size s) 

(* 9c)
    string * pattern -> int
    produces the number of times str appears as a Variable int he pattern *)
fun count_some_var (str, p) = g (fn () => 0) (fn s => if s = str then 1 else 0) p

(* 10)
    pattern -> bool
    produces true iff all the variables have diferent names *)
fun check_pat (p) =
    let (*  pattern * string list -> string list
            produces a list whit all the variable names in the pattern *)
        fun get_variable_names (Variable s, acc) = s::acc
        |   get_variable_names (TupleP ps, acc) = List.foldl (fn (x,y) => get_variable_names(x,y)) acc ps 
        |   get_variable_names (ConstructorP(_,p), acc) = get_variable_names(p, acc)
        |   get_variable_names (_, acc) = acc

        (*  string list -> bool
            produces true if there are no repeated strings in the list *)
        fun has_no_repeats ([]) = true
        |   has_no_repeats (hd::tl) = not(List.exists (fn s: string => s = hd) tl) andalso has_no_repeats(tl)
    in
        has_no_repeats (get_variable_names(p,[]))
    end

(* 11)
    valu * pattern -> (string * valu) list option 
    produces NONE if the pattern does not match the valu
    produces SOME lst  of all the bindings if the pattern matches *)
fun match (v,p) =
    case (v,p) of
        (_, Wildcard) => SOME []
    |   (Unit, UnitP) => SOME []
    |   (_, Variable s) => SOME [(s,v)]
    |   (Const i, ConstP j) => if i = j then SOME [] else NONE
    |   (Constructor(s1,v), ConstructorP(s2,p)) => if s1 = s2 then match(v,p) else NONE
    |   (Tuple vs, TupleP ps) => 
            if List.length(vs) <> List.length(ps) 
            then NONE 
            else all_answers match (ListPair.zip(vs,ps))      
    |   (_,_) => NONE

(* 12)
    valu -> (pattern list -> (string * valu) list option)
    produces NONE if no pattern in the list matches 
    produces SOME lst, where lst is the list of bindings for the first pattern that matches *)
fun first_match v ps =
    SOME (first_answer (fn p => match (v,p)) ps) handle NoAnswer => NONE
    

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(* Challenge problem *)
(*  (string * string * typ) list * (pattern list) -> typ option
    produces a type (t) for the first argument that matches all the pattern in the list *)
fun typecheck_patterns (_,[]) = NONE
|   typecheck_patterns (ds,ps) = 
    let (*  (typ option) list * typ list -> (typ list) option 
            produces NONE if some element in the list is NONE
                     SOME lst where lst is made from every type on the given list *)
        fun check_list ([],acc) = SOME acc
        |   check_list (t::ts, acc) =
                case t of
                    NONE => NONE
                |   SOME x => check_list(ts, x::acc)

        (*  typ * typ -> typ option
            produces the most lenient type, NONE if the types are not compatible *)
        fun most_lenient (t1,t2) =
            case (t1,t2) of
                (Anything, t) => SOME t
            |   (t, Anything) => SOME t
            |   (UnitT,UnitT) => SOME UnitT
            |   (IntT,IntT)   => SOME IntT
            |   (Datatype s1,Datatype s2) => if s1 = s2 then SOME(Datatype s1) else NONE
            |   (TupleT xs,TupleT ys) => 
                    if List.length xs <> List.length ys 
                    then NONE 
                    else
                        let val tuple_list_option = List.map most_lenient (ListPair.zipEq(xs,ys))
                            val tuple_list = check_list(tuple_list_option,[])
                        in case tuple_list of
                                NONE => NONE
                            |   SOME lst => SOME (TupleT (List.rev lst))
                        end
            |   (_,_) => NONE

        (*  (string * string * typ) list * pattern -> typ option
            produces SOME typ if the pattern mathces some type t
                     NONE if nothing matches *)
        fun pattern_to_type (p) =
                    case p of
                        UnitP => SOME UnitT
                    |   ConstP _ => SOME IntT
                    |   TupleP xs => 
                            let val pattern_list = List.map (fn (x) => pattern_to_type(x)) xs
                                val type_list = check_list (pattern_list, [])
                            in case type_list of 
                                    NONE => NONE
                                |   SOME lst => SOME (TupleT (List.rev lst))
                            end
                    |   ConstructorP (s,p) => 
                            (case ( List.find (fn (s1,_,_) => s1 = s) ds, pattern_to_type(p)) of
                                (NONE,_) => NONE
                            |   (_,NONE) => NONE
                            |   (SOME(_,dn,t1),SOME t2) => 
                                    (case most_lenient(t1,t2) of
                                        NONE => NONE
                                    |   SOME _ => SOME (Datatype dn)))
                    |   _ => SOME Anything

        (*  pattern list -> typ list option
            produces a list of every type of each pattern in ps *)
        fun get_types (ps) = check_list ((List.map (fn (p) => pattern_to_type(p)) ps), [])

        (*  typ list * typ -> typ option
            produces SOME t where t is the least general type that is compatible with all the types in the list
                     NONE if there is no compatible type
            ans is a result so far accumulator, call func with acc = Anything *)
        fun get_type ([], ans) = SOME ans 
        |   get_type (t::ts, ans) = 
                case most_lenient(ans, t) of
                    NONE => NONE
                |   SOME t => get_type(ts, t)
    in
       case get_types(ps) of
            NONE => NONE
        |   SOME ts => get_type(ts, Anything)
    end
