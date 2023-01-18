use "hw3.sml";

(*  Passed tests should evaluate to true
    Run with "sml <hw2_tests.sml" to exit the REPL at the end *)

(* ---------------------------------- *)

print "\n Tests for #1 only_capitals() \n";
val only_capitals_t1  = only_capitals([]) = [];
val only_capitals_t2  = only_capitals(["A"]) = ["A"];
val only_capitals_t3  = only_capitals(["a", "b"]) = [];
val only_capitals_t4  = only_capitals(["a", "b", "CV"]) = ["CV"];
val only_capitals_t5  = only_capitals(["a", "b", "Cv", "d"]) = ["Cv"];
val only_capitals_t6  = only_capitals(["A", "b", "Cv", "d"]) = ["A", "Cv"];
val only_capitals_t7  = only_capitals(["A", "b", "Cv", "dCxst"]) = ["A", "Cv"];
val only_capitals_t8  = only_capitals(["A", "bCDE", "Cv", "dCxst"]) = ["A", "Cv"];
val only_capitals_t9  = only_capitals(["A", "B", "C", "D"]) = ["A", "B", "C", "D"];
val only_capitals_t10 = only_capitals(["Ab", "Bc", "Cd", "De"]) = ["Ab", "Bc", "Cd", "De"];
print " ---------------------------------- \n";

print "\n Tests for #2 longest_string1() \n";
val longest_string1_t1 = longest_string1([]) = ""; 
val longest_string1_t2 = longest_string1(["a"]) = "a"; 
val longest_string1_t3 = longest_string1(["a", "bc"]) = "bc"; 
val longest_string1_t4 = longest_string1(["a", "bb", "d"]) = "bb"; 
val longest_string1_t5 = longest_string1(["a", "bc", "dd"]) = "bc"; 
val longest_string1_t6 = longest_string1(["aa", "bc", "dd"]) = "aa"; 
val longest_string1_t7 = longest_string1(["aa", "bc", "dd", "abcd"]) = "abcd"; 
val longest_string1_t8 = longest_string1(["aa", "bc", "dd", "abcd", "efgh"]) = "abcd"; 
print " ---------------------------------- \n";

print "\n Tests for #3 longest_string2() \n";
val longest_string2_t1 = longest_string2([]) = ""; 
val longest_string2_t2 = longest_string2(["a"]) = "a"; 
val longest_string2_t3 = longest_string2(["a", "bc"]) = "bc"; 
val longest_string2_t4 = longest_string2(["a", "bb", "d"]) = "bb"; 
val longest_string2_t5 = longest_string2(["a", "bc", "dd"]) = "dd"; 
val longest_string2_t6 = longest_string2(["aa", "bc", "dd"]) = "dd"; 
val longest_string2_t7 = longest_string2(["aa", "bc", "dd", "abcd"]) = "abcd"; 
val longest_string2_t8 = longest_string2(["aa", "bc", "dd", "abcd", "efgh"]) = "efgh"; 
print " ---------------------------------- \n";

print "\n Tests for #4b longest_string3() \n";
val longest_string3_t1 = longest_string3([]) = ""; 
val longest_string3_t2 = longest_string3(["a"]) = "a"; 
val longest_string3_t3 = longest_string3(["a", "bc"]) = "bc"; 
val longest_string3_t4 = longest_string3(["a", "bb", "d"]) = "bb"; 
val longest_string3_t5 = longest_string3(["a", "bc", "dd"]) = "bc"; 
val longest_string3_t6 = longest_string3(["aa", "bc", "dd"]) = "aa"; 
val longest_string3_t7 = longest_string3(["aa", "bc", "dd", "abcd"]) = "abcd"; 
val longest_string3_t8 = longest_string3(["aa", "bc", "dd", "abcd", "efgh"]) = "abcd"; 

print "\n Tests for #4c longest_string4() \n";
val longest_string4_t1 = longest_string4([]) = ""; 
val longest_string4_t2 = longest_string4(["a"]) = "a"; 
val longest_string4_t3 = longest_string4(["a", "bc"]) = "bc"; 
val longest_string4_t4 = longest_string4(["a", "bb", "d"]) = "bb"; 
val longest_string4_t5 = longest_string4(["a", "bc", "dd"]) = "dd"; 
val longest_string4_t6 = longest_string4(["aa", "bc", "dd"]) = "dd"; 
val longest_string4_t7 = longest_string4(["aa", "bc", "dd", "abcd"]) = "abcd"; 
val longest_string4_t8 = longest_string4(["aa", "bc", "dd", "abcd", "efgh"]) = "efgh"; 
print " ---------------------------------- \n";

print "\n Tests for #5 longest_capitalized() \n";
val longest_capitalized_t1 = longest_capitalized([]) = "";
val longest_capitalized_t2 = longest_capitalized(["abdfv"]) = "";
val longest_capitalized_t3 = longest_capitalized(["abdfv", "A"]) = "A";
val longest_capitalized_t4 = longest_capitalized(["abdfv", "A", "B"]) = "A";
val longest_capitalized_t5 = longest_capitalized(["abdfv", "A", "Bc"]) = "Bc";
val longest_capitalized_t6 = longest_capitalized(["Abdfv", "A", "Bc"]) = "Abdfv";
val longest_capitalized_t7 = longest_capitalized(["aBdfv", "Ad", "Bc"]) = "Ad";
print " ---------------------------------- \n";

print "\n Tests for #6 rev_string() \n";
val rev_string_t1 = rev_string("") = "";
val rev_string_t2 = rev_string("a") = "a";
val rev_string_t3 = rev_string("ab") = "ba";
val rev_string_t4 = rev_string("abcde") = "edcba";
print " ---------------------------------- \n";

print "\n Tests for #7 first_answer() \n";
val first_answer_t1 = first_answer (fn x => if x mod 2 = 0 then SOME x else NONE) [1,2,3,4] = 2; 
val first_answer_t2 = first_answer (fn x => if x mod 2 = 0 then SOME x else NONE) [1,3,4] = 4; 
val first_answer_t3 = first_answer (fn x => if x < 0 then SOME x else NONE) [1,3,4, 0, ~1, ~8] = ~1; 
val first_answer_t4 = ((first_answer (fn x => if x < 0 then SOME x else NONE) [1,3,4, 0])
                                                    handle NoAnswer => 0) = 0;
print " ---------------------------------- \n";

print "\n Tests for #8 all_answers() \n";
val all_answers_t1 = all_answers (fn x => SOME [x]) [] = SOME [];
val all_answers_t2 = all_answers (fn x => if x > 2 then SOME [x] else NONE) [1,2,3,4,5,2,6] = NONE;
val all_answers_t3 = all_answers (fn x => if x > 2 then SOME [x] else NONE) [3,4,5,2,6] = NONE;
val all_answers_t4 = all_answers (fn x => if x > 2 then SOME [x] else NONE) [3,4,5,6,7] = SOME [3,4,5,6,7];
print " ---------------------------------- \n";

print "\n Tests for #9 \n";
print "\n Tests for #9a count_wildcards() \n";
val count_wildcards_t1 = count_wildcards Wildcard = 1;
val count_wildcards_t2 = count_wildcards (Variable "") = 0;
val count_wildcards_t3 = count_wildcards (TupleP [ConstP 10, Wildcard, ConstructorP ("", Wildcard)]) = 2;

print "\n Tests for #9b count_wild_and_variable_lengths() \n";
val count_wild_and_variable_lengths_t1 = count_wild_and_variable_lengths Wildcard = 1;
val count_wild_and_variable_lengths_t2 = count_wild_and_variable_lengths (Variable "abc") = 3;
val count_wild_and_variable_lengths_t3 = count_wild_and_variable_lengths (TupleP [ConstP 10, Variable "cd", Wildcard, ConstructorP ("Const", Wildcard)]) = 4;

print "\n Tests for #9c count_some_var() \n";
val count_some_var_t1 = count_some_var ("a", Wildcard) = 0;
val count_some_var_t2 = count_some_var ("abc", (Variable "ab")) = 0;
val count_some_var_t3 = count_some_var ("abc", (Variable "abc")) = 1;
val count_some_var_t4 = count_some_var ("abc", (TupleP [ConstP 10, Variable "abc", Variable "cde", ConstructorP ("Const", Variable "abc")])) = 2;
print " ---------------------------------- \n";

print "\n Tests for #10 check_pat() \n";
val check_pat_t1 = check_pat (Wildcard) = true;
val check_pat_t2 = check_pat (Variable "ab") = true;
val check_pat_t3 = check_pat (TupleP [Variable "abc", Variable "abc"]) = false;
val check_pat_t4 = check_pat (TupleP [Variable "abc", Variable "ab"]) = true;
val check_pat_t5 = check_pat (TupleP [ConstP 10, Variable "abc", Variable "cde", ConstructorP ("abc", Variable "1234"), TupleP [Variable "c"]]) = true;
val check_pat_t6 = check_pat (TupleP [ConstP 10, Variable "abc", Variable "cde", ConstructorP ("abc", Variable "1234"), TupleP [Variable "cde"]]) = false;
print " ---------------------------------- \n";

print "\n Tests for #11 match() \n";
val match_t1 = match (Const 12, Wildcard) = SOME [];
val match_t2 = match (Unit, Wildcard) = SOME [];
val match_t3 = match (Tuple [Const 3], Wildcard) = SOME [];
val match_t4 = match (Constructor("",Unit), Wildcard) = SOME [];

val match_t5 = match (Const 12, Variable "s") = SOME [("s",Const 12)];
val match_t6 = match (Unit, Variable "s") = SOME [("s",Unit)];
val match_t7 = match (Tuple [Const 3], Variable "s") = SOME [("s",Tuple [Const 3])];
val match_t8 = match (Constructor("",Unit), Variable "s") = SOME [("s",Constructor("",Unit))];

val match_t9 = match (Const 12, UnitP) = NONE;
val match_t10 = match (Unit, UnitP) = SOME [];

val match_t11 = match (Const 17, TupleP [UnitP]) = NONE;
val match_t12 = match (Const 17, ConstP 13) = NONE;
val match_t13 = match (Const 17, ConstP 17) = SOME [];

val match_t14 = match (Tuple [Unit], ConstructorP("a",UnitP)) = NONE;
val match_t15 = match (Tuple [Unit], TupleP [UnitP, ConstP 1]) = NONE;
val match_t16 = match (Tuple [Const 4], TupleP [ConstP 4]) = SOME [];
val match_t17 = match (Tuple [Const 4, Const 3], TupleP [ConstP 4, UnitP]) = NONE;
val match_t18 = match (Tuple [Const 4, Unit], TupleP [ConstP 4, UnitP]) = SOME [];
val match_t19 = match (Tuple [Const 4, Unit], TupleP [ConstP 4, Variable "a"]) = SOME [("a", Unit)];
val match_t20 = match (Tuple [Const 4, Unit, Constructor("s",Unit)], TupleP [ConstP 4, Variable "a", Wildcard]) = SOME [("a", Unit)];
val match_t21 = match (Tuple [Const 4, Unit, Constructor("s",Unit)], TupleP [ConstP 4, UnitP, ConstructorP("a",UnitP)]) = NONE;
val match_t22 = match (Tuple [Const 4, Unit, Constructor("s",Unit)], TupleP [ConstP 4, UnitP, ConstructorP("s",UnitP)]) = SOME [];

val match_t23 = match (Constructor("a", Unit), ConstP 12) = NONE;
val match_t24 = match (Constructor("a", Unit), ConstructorP("b", UnitP)) = NONE;
val match_t25 = match (Constructor("a", Unit), ConstructorP("a", ConstP 12)) = NONE;
val match_t26 = match (Constructor("a", Unit), ConstructorP("a", UnitP)) = SOME [];
val match_t27 = match (Constructor("a", Tuple [Unit]), ConstructorP("a", Wildcard)) = SOME [];
val match_t28 = match (Constructor("a", Tuple [Unit]), ConstructorP("a", Variable "b")) = SOME [("b", Tuple [Unit])];
print " ---------------------------------- \n";

print "\n Tests for #12 first_match() \n";
val first_match_t1 = first_match Unit [ConstP 2] = NONE;
val first_match_t2 = first_match Unit [UnitP] = SOME [];
val first_match_t3 = first_match Unit [TupleP [UnitP], UnitP] = SOME [];
val first_match_t4 = first_match Unit [TupleP [UnitP], ConstP 3] = NONE;
val first_match_t5 = first_match (Const 4) [TupleP [UnitP], ConstP 4, ConstP 4, UnitP] = SOME [];
val first_match_t6 = first_match (Const 4) [TupleP [UnitP], Variable "x", Wildcard, UnitP] = SOME [("x", Const 4)];
val first_match_t7 = first_match (Const 4) [TupleP [UnitP], Variable "y", Variable "x", Wildcard, UnitP] = SOME [("y", Const 4)];
val first_match_t8 = first_match (Const 4) [TupleP [UnitP], Wildcard, Variable "x", Wildcard, UnitP] = SOME [];
print " ---------------------------------- \n";

print "\n Tests for challenge problem typecheck_patterns() \n";
val input_01 = ([],[]);                                                                 (* NONE *)
val input_02 = ([("a","b",Anything)],[]);                                               (* NONE *)
val input_03 = ([],[Wildcard]);                                                         (* Anything *)
val input_04 = ([],[ConstP 10, Variable "a"]);                                          (* IntT *)
val input_05 = ([],[ConstP 10, ConstructorP("SOME", Variable "x"), Variable "a"]);      (* NONE *)
val input_06 = ([],[TupleP[Variable "a", ConstP 10, Wildcard],                          
                    TupleP[Variable "b", Wildcard, ConstP 11], Wildcard]);              (* TupleT[Anything, IntT, IntT] *)
val input_07 = ([("Red",   "color", UnitT),
                 ("Green", "color", UnitT),
                 ("Blue",  "color", UnitT)],
                [ConstructorP("Red",UnitP), Wildcard]);                                 (* Datatype "color" *)
val input_08 = ([("Sedan", "auto", Datatype "color"),
                 ("Truck", "auto", TupleT[IntT,Datatype "color"]),
                 ("SUV",   "auto", UnitT)],
                [ConstructorP("Sedan",Variable "a"),
                 ConstructorP("Truck",TupleP[Variable "b", Wildcard]), Wildcard]);      (* Datatype "auto" *) 
val input_09 = ([("Empty", "list", UnitT),
                 ("List",  "list", TupleT[Anything,Datatype "list"])],
                [ConstructorP("Empty",UnitP),
                 ConstructorP("List", TupleP[ConstP 10,ConstructorP("Empty", UnitP)]),
                    Wildcard]);                                                        (* Datatype "list" *)                        
val input_10 = ([("Empty", "list", UnitT),
                 ("List",  "list", TupleT[Anything,Datatype "list"])],
                [ConstructorP("Empty",UnitP),
                 ConstructorP("List", TupleP[Variable "K", Wildcard])]);               (* Datatype "list" *)                        
val input_11 = ([("Empty", "list", UnitT),
                 ("List",  "list", TupleT[Anything,Datatype "list"])],
                [ConstructorP("Empty",UnitP),
                 ConstructorP("List", TupleP[ConstructorP("Sedan", Variable "c"), 
                                                                    Wildcard])]);      (* Datatype "list" *)                        
val input_12 = ([],[TupleP[Variable "x", Variable "y"],
                    TupleP[Wildcard, Wildcard]]);                                      (* TupleT[Anything, Anything] *)                        
val input_13 = ([],[TupleP[Wildcard, Wildcard],
                    TupleP[Wildcard, TupleP[Wildcard, Wildcard]]]);                    (* TupleT[Anything, TupleT[Anything, Anything]] *)

val typecheck_patterns_t01 = typecheck_patterns input_01 = NONE;                        
val typecheck_patterns_t02 = typecheck_patterns input_02 = NONE;                        
val typecheck_patterns_t03 = typecheck_patterns input_03 = SOME Anything;                        
val typecheck_patterns_t04 = typecheck_patterns input_04 = SOME IntT;                        
val typecheck_patterns_t05 = typecheck_patterns input_05 = NONE;                        
val typecheck_patterns_t06 = typecheck_patterns input_06 = SOME (TupleT[Anything, IntT, IntT]);                        
val typecheck_patterns_t07 = typecheck_patterns input_07 = SOME (Datatype "color");                        
val typecheck_patterns_t08 = typecheck_patterns input_08 = SOME (Datatype "auto");                        
val typecheck_patterns_t09 = typecheck_patterns input_09 = SOME (Datatype "list");                        
val typecheck_patterns_t10 = typecheck_patterns input_10 = SOME (Datatype "list");                        
val typecheck_patterns_t11 = typecheck_patterns input_11 = NONE                        
val typecheck_patterns_t12 = typecheck_patterns input_12 = SOME (TupleT[Anything, Anything]);                        
val typecheck_patterns_t13 = typecheck_patterns input_13 = SOME (TupleT[Anything, TupleT[Anything, Anything]]);                        
print " ---------------------------------- \n";