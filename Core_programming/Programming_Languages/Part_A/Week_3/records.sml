(* Records *)

(* {bar : (int * bool), baz : (bool * int), foo : int} *)
val x = {bar = (1+2, true andalso true),
         foo = 3+4,
         baz = (false, 9)}

(* {name : string, id : int} *)
val person =  {name = "Amelia", id = 41123-12}
val id_person = #id person (* 41111 *)
val name_person = #name person (* "Amelia" *)