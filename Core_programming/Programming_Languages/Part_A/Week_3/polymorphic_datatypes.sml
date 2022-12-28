
datatype 'a optional = NONE | SOME of 'a

datatype 'a listof = empty | cons of ('a * 'a listof)

(*  'a list * 'a list -> 'a list
     abstract function for appending two lists *)
fun append (l1, l2)  = 
    case l1 of
        []         => l2
    |   head::tail => head :: append(tail, l2)   

datatype ('a, 'b) tree = leaf of 'b | node of ('a * ('a,'b) tree * ('a,'b) tree)

(*  (int, int) tree -> int 
    produces the sum of all the leafs *)
fun sum_tree (t : (int, int) tree) : int =
    case t of
        leaf i        => i
    |   node(i,lt,rt) => i + sum_tree(lt) + sum_tree(rt)

(*  ('a, int) tree -> int 
    produces the sum of the values at the leaves *)
fun sum_leaves (tr : ('a,int) tree) : int =
    case tr of 
        leaf i        => i
    |   node(i,lt,rt) => sum_leaves(lt) + sum_leaves(rt)

(*  ('a,'b) tree -> int
    produces the count of all the leaves in the tree *)
fun count_leaves (tr : ('a,'b) tree): int =
    case tr of
        leaf i        => 1
    |   node(i,lt,rt) => count_leaves(lt) + count_leaves(rt)


