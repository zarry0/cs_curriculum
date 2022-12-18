
val w = 34

fun silly (z : int) =
    let
      val x = if z > 0 then z else w
      val y = x + z + 9
    in
      if x > y then x * 2 else y * y
    end

fun silly2 () =
    let
        val x = 1
    in
        (let val x = 2 in x+1 end) + (let val y = x+2 in y+1 end)  (* produces 7 *)
    end