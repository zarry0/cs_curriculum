datatype suit = Club | Diamond | Heart | Spade

datatype rank = Jack | Queen | King | Ace | Num of int

type card = suit * rank

datatype id = StudentNum of int 
            | Name of string * (string option) * string

datatype exp = Constant of int 
             | Negate of exp 
             | Add of exp * exp
             | Multiply of exp * exp

fun eval e =
    case e of
        Constant i => i
      | Negate e2  => ~ (eval e2)
      | Add(e1,e2) => (eval e1) + (eval e2)
      | Multiply(e1,e2) => (eval e1) * (eval e2)

fun number_of_adds e =
    case e of
        Constant i      => 0
      | Negate e2       => number_of_adds e2
      | Add(e1,e2)      => 1 + number_of_adds e1 + number_of_adds e2
      | Multiply(e1,e2) => number_of_adds e1 + number_of_adds e2

val example_exp = Add (Constant 19, Negate (Constant 4))

val example_ans = eval example_exp

val example_addcount = number_of_adds (Multiply(example_exp,example_exp))

(*  exp -> int
    produces the max constant in the expression *)
fun max_constant (e : exp) : int = 

    let (* exp * exp -> int
           produces tha max constant of the two inputs *)
        fun max_of_two(e1 : exp, e2: exp) : int =
            let val max1 = max_constant(e1)
                val max2 = max_constant(e2)
            in if max1 > max2 then max1 else max2 end
    in
        case e of
              Constant i => i
            | Negate e1 => max_constant e1
            | Add(e1,e2) => max_of_two(e1, e2)
            | Multiply(e1,e2) => max_of_two(e1, e2)
    end

fun max_constant_alt (e : exp) : int =
    case e of
      Constant i       => i 
    | Negate   e1      => max_constant_alt(e1) 
    | Add     (e1, e2) => Int.max(max_constant_alt e1, max_constant_alt e2) 
    | Multiply(e1, e2) => Int.max(max_constant_alt e1, max_constant_alt e2)

val max_constant_t = max_constant(Multiply(Add(Constant 5, Negate(Constant 1000)), Negate(Constant(~25))))
val nineteen = max_constant(Add(Constant 19, Negate(Constant 4)))

val max_constant_t_alt = max_constant_alt(Multiply(Add(Constant 5, Negate(Constant 1000)), Negate(Constant(~25))))
val nineteen_alt = max_constant_alt(Add(Constant 19, Negate(Constant 4)))

(* Tree is one of:
	- empty
	- Tree with a key, a value, and left and right childs *)
datatype Tree = empty
			  | Node of {Key : int, 
						 Val : string,
						 Left : Tree, 
						 Right : Tree}

(*  Tree * int -> string option
	produces the string associated to that key *)
fun find (tree : Tree, key : int) : string option =
	case tree of
		  empty => NONE
		| Node{Key, Val, Left, Right} =>  if Key = key
                                          then SOME (Val)
                                          else if Key > key
                                          then find(Left, key)
                                          else find(Right, key)


(*      3:c
       /  \
      /    \
     /      \
    1:a     5:e
     \     /   \
     2:b  4:d  6:f *)
val t1 = Node {Key=3, Val="c", 
               Left= Node{Key=1, Val="a",
                         Left=empty,
                         Right=Node{Key=2, Val="b", Left=empty, Right=empty}}, 
               Right=Node{Key=5, Val="e",
                         Left=Node{Key=4, Val="d", Left=empty, Right=empty},
                         Right=Node{Key=6, Val="f", Left=empty, Right=empty}}}

val find_d = find(t1, 4) (* SOME "d" *)
val find_b = find(t1, 2) (* SOME "b" *)
val find_x = find(t1, 7) (* NONE *)