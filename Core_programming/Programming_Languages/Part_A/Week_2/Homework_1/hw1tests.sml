use "hw1.sml";

(* Passed tests should evaluate to true
   Run with "sml <hw1tests.sml" to exit the REPL at the end *)

(* ---------------------------------- *)
print "\n Tests for #1 is_older() function \n";
val is_older_t1 = is_older ( (2022,12,17), (2021,12,17) ) = false;
val is_older_t2 = is_older ( (2022,12,17), (2022,12,18) ) = true;
val is_older_t3 = is_older ( (2022,12,17), (2022,12,16) ) = false;
val is_older_t4 = is_older ( (2022,12,17), (2022,11,18) ) = false;
val is_older_t5 = is_older ( (2022,12,17), (2022,12,17) ) = false;
val is_older_t6 = is_older ( (1999,1,20),  (2022,12,17) ) = true;
val is_older_t7 = is_older ( (1752,3,15),  (1984,8,5)   ) = true;
val is_older_t8 = is_older ( (1945,10,4),  (1945,10,5)  ) = true;
val is_older_t9 = is_older ( (1945,9,4),   (1945,10,4)  ) = true;
print " ---------------------------------- \n";

(* ---------------------------------- *)
print "\n Tests for #2 number_in_month() function \n";
val number_in_month_t1 = number_in_month([], 1) = 0;
val number_in_month_t2 = number_in_month([(2000,10,1)], 1) = 0;
val number_in_month_t3 = number_in_month([(2000,6,1)], 6) = 1;
val number_in_month_t4 = number_in_month([(2000,6,1), (1809,4,8)], 6) = 1;
val number_in_month_t5 = number_in_month([(2000,6,1), (1809,4,8), (2,4,30)], 4) = 2;
val number_in_month_t6 = number_in_month([(2000,6,1), (1809,4,8), (2,4,30)], 10) = 0;
print "---------------------------------- \n";

(* ---------------------------------- *)
print "\n Tests for #3 number_in_months() function \n";
val number_in_months_t1 = number_in_months([], []) = 0;
val number_in_months_t2 = number_in_months([], [1,2]) = 0;
val number_in_months_t3 = number_in_months([(2000,6,1), (1809,4,8)], []) = 0;
val number_in_months_t4 = number_in_months([(2000,6,1), (1809,4,8)], [5,6,7]) = 1;
val number_in_months_t5 = number_in_months([(2000,6,1), (1809,4,8), (2,4,30)], [5,7]) = 0;
val number_in_months_t6 = number_in_months([(2000,6,1), (1809,4,8), (2,4,30)], [4,5]) = 2;
val number_in_months_t7 = number_in_months([(2000,6,1), (1809,4,8), (2,4,30)], [4,5,6]) = 3;
print " ----------------------------------  \n";

(* ---------------------------------- *)
print "\n Tests for #4 dates_in_month() function \n";
val dates_in_month_t1 = dates_in_month([], 1) = [];
val dates_in_month_t2 = dates_in_month([(2000,6,1), (1809,4,8), (2,4,30)], 1) = [];
val dates_in_month_t3 = dates_in_month([(2000,6,1), (1809,4,8), (2,4,30)], 6) = [(2000,6,1)];
val dates_in_month_t3 = dates_in_month([(2000,6,1), (1809,4,8), (2,4,30)], 4) = [(1809,4,8), (2,4,30)];
print " ----------------------------------  \n";

print "\n Tests for #5 dates_in_months() function \n";
val dates_in_months_t1 = dates_in_months([], []) = [];
val dates_in_months_t2 = dates_in_months([], [2,3]) = [];
val dates_in_months_t3 = dates_in_months([(2000,6,1), (1809,4,8), (2,4,30)], []) = [];
val dates_in_months_t4 = dates_in_months([(2000,6,1), (1809,4,8), (2,4,30)], [1,3]) = [];
val dates_in_months_t5 = dates_in_months([(2000,6,1), (1809,4,8), (2,4,30)], [1,6]) = [(2000,6,1)];
val dates_in_months_t6 = dates_in_months([(2000,6,1), (1809,4,8), (2,4,30)], [1,4]) = [(1809,4,8), (2,4,30)];
val dates_in_months_t7 = dates_in_months([(2000,6,1), (1809,4,8), (2,4,30)], [5,4,6]) = [(2000,6,1), (1809,4,8), (2,4,30)]; (* !!! *)
val dates_in_months_t8 = dates_in_months([(2000,6,1), (1809,4,8), (2,4,30)], [5,6,4]) = [(2000,6,1), (1809,4,8), (2,4,30)];
print " ----------------------------------  \n";

print "\n Tests for #6 get_nth() function \n";
val get_nth_t1 =  get_nth(["a"], 1) = "a";
val get_nth_t2 =  get_nth(["a", "b", "c", "d"], 1) = "a";
val get_nth_t3 =  get_nth(["a", "b", "c", "d"], 3) = "c";
val get_nth_t4 =  get_nth(["a", "b", "c", "d"], 4) = "d";
print " ----------------------------------  \n";

print "\n Tests for #7 date_to_string() function \n";
val date_to_string_t1 = date_to_string((1999,1,20)) = "January 20, 1999";
val date_to_string_t1 = date_to_string((1736,8,14)) = "August 14, 1736";
print " ----------------------------------  \n";

print "\n Tests for #8 number_before_sum() function \n";
val number_before_reaching_sum_t1 = number_before_reaching_sum(8, [1,2,3,4,5,6,7]) = 3;
val number_before_reaching_sum_t2 = number_before_reaching_sum(5, [1,20,4,5]) = 1;
val number_before_reaching_sum_t3 = number_before_reaching_sum(30, [1,18,2,8,15]) = 4;
val number_before_reaching_sum_t4 = number_before_reaching_sum(2, [2,18,2,8,15]) = 0; 
print " ----------------------------------  \n";

print "\n Tests for #9 what_month() function \n";
val what_month_t1 = what_month(80) = 3;
val what_month_t1 = what_month(300) = 10;
val what_month_t1 = what_month(150) = 5;
val what_month_t1 = what_month(1) = 1;
print " ----------------------------------  \n";

print "\n Tests for #10 month_range() function \n";
val month_range_t1 = month_range(10, 8) = [];
val month_range_t2 = month_range(10, 10) = [1];
val month_range_t3 = month_range(1, 10) = [1,1,1,1,1,1,1,1,1,1];
val month_range_t4 = month_range(59, 65) = [2,3,3,3,3,3,3];
print " ----------------------------------  \n";

print "\n Tests for #11 oldest() function \n";
val oldest_t1 = oldest([]) = NONE;
val oldest_t2 = oldest([(1,2,3)]) = SOME (1,2,3);
val oldest_t3 = oldest([(2022,12,18), (3050,3,10), (1,2,3), (2023,8,20), (2022,12,24)]) = SOME (1,2,3);
print " ----------------------------------  \n";

print "\n Tests for #12 CHALLENGE \n";
print "\n A)  \n";
val number_in_months_challenge_t1 = number_in_months_challenge([], []) = 0;
val number_in_months_challenge_t2 = number_in_months_challenge([], [1,2,2]) = 0;
val number_in_months_challenge_t3 = number_in_months_challenge([(2000,6,1), (1809,4,8)], []) = 0;
val number_in_months_challenge_t4 = number_in_months_challenge([(2000,6,1), (1809,4,8)], [5,6,6,7,7]) = 1;
val number_in_months_challenge_t5 = number_in_months_challenge([(2000,6,1), (1809,4,8), (2,4,30)], [5,7,7]) = 0;
val number_in_months_challenge_t6 = number_in_months_challenge([(2000,6,1), (1809,4,8), (2,4,30)], [4,4,5]) = 2;
val number_in_months_challenge_t7 = number_in_months_challenge([(2000,6,1), (1809,4,8), (2,4,30)], [4,4,5,6,6]) = 3;

print "\n B)  \n";
val dates_in_months_challenge_t1 = dates_in_months_challenge([], []) = [];
val dates_in_months_challenge_t2 = dates_in_months_challenge([], [2,3,3]) = [];
val dates_in_months_challenge_t3 = dates_in_months_challenge([(2000,6,1), (1809,4,8), (2,4,30)], []) = [];
val dates_in_months_challenge_t4 = dates_in_months_challenge([(2000,6,1), (1809,4,8), (2,4,30)], [1,1,3]) = [];
val dates_in_months_challenge_t5 = dates_in_months_challenge([(2000,6,1), (1809,4,8), (2,4,30)], [1,6,6]) = [(2000,6,1)];
val dates_in_months_challenge_t6 = dates_in_months_challenge([(2000,6,1), (1809,4,8), (2,4,30)], [1,1,4,4]) = [(1809,4,8), (2,4,30)];
val dates_in_months_challenge_t7 = dates_in_months_challenge([(2000,6,1), (1809,4,8), (2,4,30)], [5,5,6,6,4,4]) = [(2000,6,1), (1809,4,8), (2,4,30)];
print " ----------------------------------  \n";

print "\n Tests for #13 CHALLENGE \n";
val reasonable_date_t1 = reasonable_date(1,2,3) = true;
val reasonable_date_t2 = reasonable_date(0,2,3) = false;
val reasonable_date_t3 = reasonable_date(~100,2,3) = false;
val reasonable_date_t4 = reasonable_date(2022,11,15) = true;
val reasonable_date_t5 = reasonable_date(2022,11,31) = false;
val reasonable_date_t6 = reasonable_date(2000,7,31) = true;
val reasonable_date_t7 = reasonable_date(2020,2,29) = true;
val reasonable_date_t8 = reasonable_date(2021,2,29) = false;
val reasonable_date_t9 = reasonable_date(2021,2,28) = true;
print " ----------------------------------  \n";

print "\n Tests for HELPERS \n";
print "\n filter_repeated() \n";
val filter_repeated_t1 = filter_repeated([]) = [];
val filter_repeated_t2 = filter_repeated([1,2,3]) = [1,2,3];
val filter_repeated_t3 = filter_repeated([1,2,3,3]) = [1,2,3];
val filter_repeated_t4 = filter_repeated([1,1,2,2,3,3,3]) = [1,2,3];

print "\n is_member() \n";
val is_member_t1 = is_member(1, []) = false;
val is_member_t2 = is_member(1, [2,3]) = false;
val is_member_t3 = is_member(1, [2,3,1]) = true;
print " ----------------------------------  \n";