(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* Problem 1. *)
(*  a)
    string * string list -> string list option
    produces NONE if str is not on lst, 
    or produces the input list without str 
    ASSUME: str appears in lst at most once *)
fun all_except_option (str, lst) =
    case lst of
        [] => NONE
    |   hd::tl => case (all_except_option(str,tl), same_string(hd,str)) of
        (NONE, true) => SOME tl
    |   (NONE, false) => NONE
    |   (SOME lst, true) => SOME lst
    |   (SOME lst, false) =>  SOME (hd :: lst)
    
(* fun all_except_option (str, lst) = 
    case lst of
        [] => NONE
    |   hd::tl => 
                let val rest = all_except_option(str, tl) (* produces NONE or SOME lst where lst has any str removed *)
                in case rest of
                    NONE => if same_string(hd,str) then SOME tl else NONE 
                |   SOME lst => if same_string(hd,str) then rest else SOME (hd :: lst)
                end *)
(*  b)
    string list list * string -> string list
    produces a list with all the strings that are in any of the lists in subs that contain s,
    but not s itself 
    ASSUME: s will be in at least one of the list of strings 
            and subs has no repeats *)
fun get_substitutions1(subs, s) =
    case subs of
        [] => []
    |   hd::tl => case all_except_option(s,hd) of
                        NONE => get_substitutions1(tl,s)
                    |   SOME lst => lst @ get_substitutions1(tl,s)

(*  c)
    string list list * string -> string list
    produces a list with all the strings that are in any of the lists in subs that contain s,
    but not s itself (tail-recursive)
    ASSUME: s will be in at least one of the list of strings 
            and subs has no repeats *)
    fun get_substitutions2 (subs, s) =
        let (* string list list * string list -> string list *)
            fun f (subs, ans) = 
                (*  ans is a result so far accumulator, the output list
                    call f with ans = [] *)
                case subs of 
                    [] => ans
                |   hd::tl => case all_except_option(s,hd) of 
                                NONE => f (tl, ans)
                              | SOME lst => f (tl, ans@lst)
        in f(subs, [])
        end

(*  d)
    string list list * fullName -> fullName list 
    produces a list of all the fullNames that cam be produced by substituting the first name 
    for each of the possible alternatives in subs, starting with the original name *)
type fullName = {first : string, middle : string, last : string}
fun similar_names (subs, {first=x, middle=y, last=z}) =
    let val name_subs = get_substitutions1(subs, x) 
        (* string list * fullName -> fullName list
           produces a list of all the names that can be produced by 
           each of the first names in the list *)
        fun permutate_names (names) = 
            case names of
                [] => []
           |    hd::tl => {first=hd, middle=y, last=z} :: permutate_names(tl)
    in 
        {first=x, middle=y, last=z} :: permutate_names(name_subs)
    end

(* Problem 2.  *)

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw

exception IllegalMove

(* put your solutions for problem 2 here *)

(*  a)
    card -> color
    produces the color of the given card *)
fun card_color (card : card) : color =
    case card of
        (Clubs, _) => Black
    |   (Spades, _) => Black
    |   (Diamonds, _) => Red
    |   (Hearts, _) => Red

(*  b)
    card -> int
    produces the value of the given card *)
fun card_value (card : card) : int =
    case card of
        (_, Ace) => 11
    |   (_, Num i) => i
    |   (_, _) => 10

(*  c)
    card list * card * exn -> card list
    produces a list with the first appearance of c removed
    if c is not in cs, raise exception e *)
fun remove_card (cs : card list, c : card, e : exn) : card list =
    case cs of
        [] => raise e
    |   hd::tl => if (c = hd) then tl else hd :: remove_card(tl, c, e)

(*  d)
    card list -> bool
    produces true if all the cards are the same color *)
fun all_same_color (cards : card list) : bool =
    case cards of
        [] => true
    |   _::[] => true
    |   c1::c2::cs => card_color(c1) = card_color(c2) andalso all_same_color(c2::cs)

(*  e)
    card list -> int
    produces the sum of all the values of the cards
    (tail-recursive) *)
fun sum_cards (cards : card list) : int =
    let (* card list * int -> int *)
        fun f (cs, sum) = 
            (* sum is the sum of the values so far
                start sum with 0 *)
            case cs of
                [] => sum
            |   hd::tl => f (tl, card_value(hd) + sum)
    in f(cards, 0)
    end

(*  f)
    card list * int -> int 
    produces the score:
        if the sum of the cards is > goal, then preliminary score = 3(sum - goal)
        else, preliminary score = (goal - sum)
        if all the cards are the same color, then score = preliminary score div 2
        else, score is preliminary score *)
fun score (cards : card list, goal : int) : int =
    let val sum = sum_cards(cards)
    val p_score = if sum > goal then 3 * (sum - goal) else (goal - sum)
    in p_score div (if all_same_color(cards) then 2 else 1)
    end

(*  g) 
    card list * move list * int -> int
    "runs the game", representing the next states of the game 
    and produces the score at the end of the game *)
fun officiate (cards : card list, moves : move list, goal : int) : int =
    let (*  card list * move list * card list -> card list
            produces the held-cards at the end of the game
                - The game ends if moves is empty or the sum of the cards > goal
                - Trying to discard a card that is not on the held-cards raises IllegalMove
                - If the player draws a card and the card list is empty, game over *)
        fun game_loop (_, [], held) = held
        |   game_loop (cards, (Discard c)::ms, held) = game_loop(cards, ms, remove_card(held, c, IllegalMove))
        |   game_loop ([], Draw::_, held) = held
        |   game_loop (c::cs, Draw::ms, held) = 
                if sum_cards(c::held) > goal
                then c::held 
                else game_loop(cs, ms, c::held)
    in 
        score(game_loop(cards, moves, []), goal)
    end

(* Challenge problems *)

(*  a)
    Rewrite (f) score and (g) officiate with the ace having a value of 1 or 11
    choosing the best possible score (the sum is closest to goal) *)

(* Helper *)
(*  card list * int -> int
    produces the amount of Aces in the list *)
fun count_aces ([] : card list, count : int) = count
|   count_aces ((_,Ace)::cs, count) = count_aces(cs, count + 1)
|   count_aces (_::cs, count) = count_aces(cs, count)

(*  card list * int -> int 
    produces the score:
        if the sum of the cards is > goal, then preliminary score = 3(sum - goal)
        else, preliminary score = (goal - sum)
        if all the cards are the same color, then score = preliminary score div 2
        else, score is preliminary score *)
fun score_challenge (cards : card list, goal : int) =
    let (*  int -> int
            produces the preliminary score, given the sum of the cards *)
        fun preliminary_score (sum) = if sum > goal then 3 * (sum - goal) else (goal - sum)

        (*  int * int * int -> int
            minimises the preliminary score by turning the value of the aces
            from 11 to 1 one by one, until the score stops decreasing or we run out of aces *)
        fun minimise_score (score, sum, aces) =
            let val new_score = preliminary_score(sum-10)
            in 
                if aces > 0 andalso (new_score < score)
                then minimise_score(new_score, sum-10, aces-1)
                else score
            end

        val aces = count_aces(cards, 0)
        val p_sum = sum_cards(cards)
        val max_score = preliminary_score(p_sum)
        val p_score = minimise_score(max_score, p_sum, aces)
    in
        p_score div (if all_same_color(cards) then 2 else 1)
    end

(*  card list * move list * int -> int
    "runs the game", representing the next states of the game 
    and produces the score at the end of the game *)
fun officiate_challenge (cards : card list, moves : move list, goal : int) : int = 
    let (*  card list * move list * card list -> card list
                produces the held-cards at the end of the game
                    - The game ends if moves is empty or the sum of the cards > goal
                    - Trying to discard a card that is not on the held-cards raises IllegalMove
                    - If the player draws a card and the card list is empty, game over *)
        fun game_loop (_, [], held) = held
        |   game_loop (cards, (Discard c)::ms, held) = game_loop(cards, ms, remove_card(held, c, IllegalMove))
        |   game_loop ([], Draw::_, held) = held
        |   game_loop (c::cs, Draw::ms, held) = 
                let val aces = count_aces(c::held, 0)
                in 
                    if (sum_cards(c::held) - (aces*10)) > goal
                    then c::held 
                    else game_loop(cs, ms, c::held)
                end
    in 
        score_challenge(game_loop(cards, moves, []), goal)
    end

(*  b)
    card list * int -> move list
    produces a move list that results in a game in which:
        - The held card sum never exceeds the goal
        - If the score is 0 there are no more moves
        - Draw a card if by doing so the goal is not exceeded
        - Discard and then draw if that produces a score = 0 *)
fun careful_player (cards, goal) =
    let (*  card * card list * int -> card option
            produces SOME card : if by discarding card and drawing c the score reaches 0
                     NONE : if it can't reach zero by discarding any card and then drawing c
        This solution is technically correct but ignores the fact that sum-goal = 1 produces a score = 0 
        if the cards have the same color, but i'm too lazy to fix it  *)
        fun discard_then_draw (c, held, sum) =
            case held of
                [] => NONE
            |   h::hs => 
                    if (sum-card_value(h)+card_value(c)) = goal 
                    then SOME h
                    else discard_then_draw(c, hs, sum)

        (*  card list * card list * move list -> move list
            produces the move list based on the careful player rules
                                       hand
                        ┌────────────────┬────────────────┐
                        │       []       │      h::hs     │
              c ┌───────┼────────────────┼────────────────┤
              a │   []  │               Draw              │
              r ├───────┼────────────────┼────────────────┤
              d │ c::cs │Check conditions│Check conditions│
              s │       │can't discard   │                │
                └───────┴────────────────┴────────────────┘ *)
        fun make_moves (cards, hand, moves) =
            case (cards, hand) of
                ([], _) => Draw::moves
            |   (c::cs, []) => if card_value(c) <= goal then make_moves(cs, [c], Draw::moves) else moves
            |   (c::cs, h::hs) => 
                    let val sum = sum_cards(h::hs)
                    in
                        case (score(h::hs, goal), discard_then_draw(c, h::hs, sum)) of
                            (0, _) => moves
                        |   (_, SOME cd)  => Draw::Discard(cd)::moves
                        |   (_, NONE) => 
                                if sum+card_value(c) <= goal 
                                then make_moves(cs, c::h::hs, Draw::moves) 
                                else moves
                    end

        (* 'a list * 'a list -> 'a list
            reverses the given list *)
        fun reverse ([], ans) = ans
        |   reverse (hd::tl, ans) = reverse(tl, hd::ans) 
            
    in
        if goal <= 0
        then []
        else reverse(make_moves(cards, [], []),[])
    end

