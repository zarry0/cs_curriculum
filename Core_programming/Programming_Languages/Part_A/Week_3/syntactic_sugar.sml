
val a_pair = (3+4, 2+5)

val a_record = {first = 3+4, second = 2+5}

val another_pair = {1 = 6, 2 = 5} (* has type (int *  int) instead of {1 : int, 2 : int} *)
val another_record = {1 = 6, 3 = 5} (* has type {1 : int, 3 : int} *)