
(* Data definitions: *)

type date = (int * int * int)
(*  Date is (int * int * int)
    interp. a date in the format: (year, month, day) 
            a reasonable date has 
                - a positive year
                - a month between 1 and 12
                - and a day between 1 and 31 (depends on the month)
    NOTE: functions operating on Dates should not check for unreasonable Dates
    
    DayOfYear is int[1, 365]
    interp. a day of the year, stating with 1: (01/jan) to 365 (31/dec)
    for example 33 is February 2
    NOTE: we ignore leap years unless specified otherwise *)


(* 1.
    date * date -> bool
    produces true if the first date comes before the second
             false otherwise or if the two dates are the same  *)
    fun is_older (d1 : date, d2 : date) : bool = 
        (#1 d1 < #1 d2) orelse
        (#1 d1 = #1 d2) andalso 
        (#2 d1 < #2 d2) orelse (#2 d1 = #2 d2) andalso (#3 d1 < #3 d2) 

(* 2.
     date list * int -> int 
     produces the number of dates that have the given month *)
    fun number_in_month (dates : date list, month : int) : int =
        if null (dates)
        then 0
        else if (#2 (hd dates)) = month
        then 1 + number_in_month(tl dates, month)
        else number_in_month(tl dates, month)
    
(* 3.
     date list * int list -> int
     produces the number of dates that have any of the moths in the list
     ASSUME: the list of months has no repeated elements *)
    fun number_in_months (dates : date list, months : int list) : int =
        if null (months)
        then 0
        else number_in_month(dates, hd months) + number_in_months (dates, tl months)

(* 4.
     date list * int -> date list 
     produces a list of the given dates that have the given month
     NOTE: the relative order of the dates must be preserved *)
    fun dates_in_month (ds: date list, m : int) : date list =
        if null (ds)
        then []
        else if (#2 (hd ds)) = m
        then (hd ds) :: dates_in_month(tl ds, m)
        else dates_in_month(tl ds, m) 

(* 5.
    date list * int list -> date list
    produces a list of the dates from the argument that have any of the monts in the list
    ASSUME: there are no repeated elements in the list of months *)
    fun dates_in_months (ds : date list, ms : int list) : date list =
        if null ms
        then []
        else dates_in_month(ds, hd ms) @ dates_in_months(ds, tl ms)

(* 6.
     string list * int -> string 
     produces the nth string on the list
     NOTE: the head of the list is 1 
     ASSUME: n will be in the interval [1, strs length] *)
    fun get_nth (strs : string list, n : int) : string =
        if n = 1
        then hd strs
        else get_nth(tl strs, n-1)

(* 7.
     date -> string
     produces the given date in string form in the form: January 20, 2013 *)
    fun date_to_string (d : date) : string =
        let val month_names = [ "January ", "February ", "March ", "April ", "May ", "June ", 
                                "July ", "August ", "September ", "October ", "November ", "December "];
        in get_nth(month_names, #2 d) ^  Int.toString((#3 d)) ^ ", " ^ Int.toString((#1 d))
        end

(* 8.
     int * int list -> int
     produces the 1-based index of the list for which the sum of the numbers up that point
     adds up to less than the given sum, but adding the next index results in sum or higher 
     ASSUME: both sum and the numbers in the list are positive 
             and the entire list sums to more than the given sum *)
    fun number_before_reaching_sum (sum : int, nums : int list) : int =
        if (hd nums) >= sum
        then 0
        else 1 + number_before_reaching_sum(sum-(hd nums), tl nums) (* keep subtracting numbers in the list to sum and count 1 each time *)

(* 9.
    int -> int
    produces the moth given the day of the year [1, 365] *)
    fun what_month (day : int) : int =
        1 + number_before_reaching_sum(day, [31,28,31,30,31,30,31,31,30,31,30,31])

(* 10.
    int * int -> int list 
    produces a list of the month numbers [m1, m2, ..., mn] where:
    m1 is the month of day1, m2, is the month of day1+1, ..., and mn is the month of day2 *)
    fun month_range (d1 : int, d2 : int) : int list =
        if d1 > d2
        then []
        else what_month(d1) :: month_range(d1+1,d2)

(* 11.
    date list -> date option 
    produces the oldest date in the list, NONE if the list has no dates *)
    fun oldest (ds : date list) : date option =
        if null (ds)
        then NONE
        else 
            let val rest = oldest(tl ds)
            in 
                if isSome(rest) andalso not(is_older(hd ds, valOf(rest)))
                then rest
                else SOME (hd ds) 
            end

(* 12. 
    same as in 3. and 5. but the list of months can have repeated elements without afecting the output *)

(* HELPER FUNCTIONS *)
(* int * int list -> bool
    produces true if x is in xs, false otherwise *)
    fun is_member (x: int, xs : int list) : bool =
        if null(xs)
        then false
        else (x = (hd xs)) orelse is_member(x, tl xs)
        
(* int list -> int list 
   produces the input list without repeated elements *)
   fun filter_repeated (xs : int list) : int list =
        if null(xs)
        then []
        else if is_member(hd xs, tl xs)
        then filter_repeated(tl xs)
        else (hd xs) :: filter_repeated(tl xs)

(* (a) *)
    fun number_in_months_challenge (ds: date list, ms : int list) : int =
        number_in_months(ds, filter_repeated(ms))

(* (b) *)
    fun dates_in_months_challenge (ds : date list, ms : int list) : date list =
        dates_in_months(ds, filter_repeated(ms))

(* 13. 
    date -> bool
    produces true if the date is a reasonable date
    A reasonable date is one with a year > 0, a 1 <= month <= 12, and an apropiate day for the given month *)
    fun reasonable_date (d : date) : bool =
        let
            val month_days : int list = if (((#1 d) mod 400) = 0) orelse 
                                        (((#1 d) mod 4 = 0) andalso ((#1 d) mod 100 <> 0))
                                        then [31,29,31,30,31,30,31,31,30,31,30,31]
                                        else [31,28,31,30,31,30,31,31,30,31,30,31]
            (* int list * int -> int
                produces the mth element in the list *)
            fun get_days (days : int list, m : int) : int =
                if m = 1
                then hd days
                else get_days(tl days, m-1)
        in
        ((#1 d) > 0) andalso
        ((1 <= (#2 d)) andalso ((#2 d) <= 12)) andalso 
        (1 <= (#3 d) andalso (#3 d) <= get_days(month_days, #2 d))
        end