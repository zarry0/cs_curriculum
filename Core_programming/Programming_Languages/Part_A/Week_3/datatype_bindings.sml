
datatype mytype = TwoInts of int * int
                | Str of string
                | Pizza

val a = Str "hi" (* a : mytype *)
val b = Str      (* b : string -> mytype *)
val c = Pizza    (* c : mytype *)
val d = a        (* d : mytype *)