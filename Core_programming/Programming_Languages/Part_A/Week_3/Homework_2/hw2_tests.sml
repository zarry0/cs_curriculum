
use "hw2.sml";

(* Passed tests should evaluate to true
   Run with "sml <hw2_tests.sml" to exit the REPL at the end *)

(* ---------------------------------- *)
print "\n Tests for problem #1 \n";
print "\n Tests for (a) all_except_option() \n";
val all_except_option_t1 = all_except_option("hello", []) = NONE;
val all_except_option_t2 = all_except_option("hello", ["Hello", "world"]) = NONE;
val all_except_option_t3 = all_except_option("hello", ["hello"]) = SOME [];
val all_except_option_t4 = all_except_option("hello", ["hello", "world", "Hello"]) = SOME ["world", "Hello"];
val all_except_option_t5 = all_except_option("world", ["hello", "Hello", "world"]) = SOME ["hello", "Hello"];
print " ---------------------------------- \n";

print "\n Tests for (b) get_substitutions1() \n";
val get_substitutions1_t1 = get_substitutions1([["foo", "bar"], ["world"]], "world") = [];
val get_substitutions1_t2 = get_substitutions1([["foo", "bar"], ["hello", "world"]], "world") = ["hello"];
val get_substitutions1_t3 = get_substitutions1([["Fred","Fredrick"],
                                                ["Elizabeth","Betty"],
                                                ["Freddie","Fred","F"]], "Fred") = ["Fredrick","Freddie","F"];
val get_substitutions1_t4 = get_substitutions1([["Fred","Fredrick"],
                                                ["Jeff","Jeffrey"],
                                                ["Geoff","Jeff","Jeffrey"]], "Jeff") = ["Jeffrey","Geoff","Jeffrey"];
print " ---------------------------------- \n";

print "\n Tests for (c) get_substitutions2() \n";
val get_substitutions2_t1 = get_substitutions2([["foo", "bar"], ["world"]], "world") = [];
val get_substitutions2_t2 = get_substitutions2([["foo", "bar"], ["hello", "world"]], "world") = ["hello"];
val get_substitutions2_t3 = get_substitutions2([["Fred","Fredrick"],
                                                ["Elizabeth","Betty"],
                                                ["Freddie","Fred","F"]], "Fred") = ["Fredrick","Freddie","F"];
val get_substitutions2_t4 = get_substitutions2([["Fred","Fredrick"],
                                                ["Jeff","Jeffrey"],
                                                ["Geoff","Jeff","Jeffrey"]], "Jeff") = ["Jeffrey","Geoff","Jeffrey"];
print " ---------------------------------- \n";

print "\n Tests for (d) similar_names() \n";
val similar_names_t1 = similar_names([["A", "a", "å"], ["B", "b"]], {first="a", middle="b", last="W"}) =
                                    [{first="a", middle="b", last="W"},
                                     {first="A", middle="b", last="W"},
                                     {first="å", middle="b", last="W"}];
val similar_names_t2 = similar_names([["Fred","Fredrick"],
                                      ["Elizabeth","Betty"],
                                      ["Freddie","Fred","F"]], 
                                      {first="Fred", middle="W", last="Smith"}) = 
                                    [{first="Fred", last="Smith", middle="W"},
                                     {first="Fredrick", last="Smith", middle="W"},
                                     {first="Freddie", last="Smith", middle="W"},
                                     {first="F", last="Smith", middle="W"}];
print " ---------------------------------- \n";

print "\n Tests for problem #2 \n";
print "\n Tests for (a) card_color() \n";
val card_color_t1 = card_color(Clubs, Jack) = Black;
val card_color_t2 = card_color(Hearts, King) = Red;
val card_color_t3 = card_color(Spades, Num 10) = Black;
val card_color_t4 = card_color(Diamonds, Ace) = Red; 
print " ---------------------------------- \n";

print "\n Tests for (b) card_value() \n";
val card_value_t1 = card_value(Clubs, Jack) = 10;
val card_value_t2 = card_value(Hearts, King) = 10;
val card_value_t3 = card_value(Spades, Num 10) = 10;
val card_value_t4 = card_value(Diamonds, Ace) = 11; 
val card_value_t5 = card_value(Diamonds, Num 8) = 8; 
print " ---------------------------------- \n";

print "\n Tests for (c) remove_card() \n";
val remove_card_t1 = remove_card([(Clubs, Jack),(Hearts, Num 4),(Spades, Ace)], (Hearts, Num 4), IllegalMove) = 
                                    [(Clubs, Jack), (Spades, Ace)];
val remove_card_t2 = remove_card([(Clubs, Jack),(Hearts, Num 4),(Spades, Ace),(Hearts, Num 4)], (Hearts, Num 4), IllegalMove) = 
                                    [(Clubs, Jack), (Spades, Ace),(Hearts, Num 4)];
val remove_card_t3 = remove_card([(Clubs, Jack),(Hearts, Num 4),(Spades, Ace),(Hearts, Num 10)], (Hearts, Num 10), IllegalMove) = 
                                    [(Clubs, Jack), (Hearts, Num 4), (Spades, Ace)];
val remove_card_t4 = remove_card([(Clubs, Jack),(Hearts, Num 4),(Spades, Ace),(Hearts, Num 10)], (Spades, Num 10), IllegalMove)
                        handle IllegalMove => []; 
print " ---------------------------------- \n";

print "\n Tests for (d) all_same_color() \n";
val all_same_color_t1 = all_same_color ([(Clubs, Jack)]) = true;
val all_same_color_t2 = all_same_color ([(Clubs, Jack),(Hearts, Num 4),(Spades, Ace),(Hearts, Num 10)]) = false;
val all_same_color_t3 = all_same_color ([(Clubs, Jack),(Spades, Num 4),(Spades, Ace),(Clubs, Num 10)]) = true;
val all_same_color_t4 = all_same_color ([(Diamonds, Jack),(Hearts, Num 4),(Spades, Ace),(Hearts, Num 10)]) = false;
val all_same_color_t5 = all_same_color ([(Diamonds, Jack),(Hearts, Num 4),(Hearts, Ace),(Hearts, Num 10)]) = true;
print " ---------------------------------- \n";

print "\n Tests for (e) sum_cards() \n";
val sum_cards_t1 = sum_cards([(Diamonds, Ace)]) = 11;
val sum_cards_t2 = sum_cards([(Clubs, Jack),(Spades, Num 4),(Spades, Ace),(Clubs, Num 10)]) = 35;
val sum_cards_t3 = sum_cards([(Clubs, Ace),(Spades, Num 3),(Spades, Num 5)]) = 19;
val sum_cards_t4 = sum_cards([(Hearts, Queen),(Diamonds, Num 8),(Clubs, Num 10)]) = 28;
print " ---------------------------------- \n";

print "\n Tests for (f) score() \n";
val score_t1 = score([(Diamonds, Ace)], 10) = 3 div 2;
val score_t2 = score([(Clubs, Jack),(Spades, Num 4),(Spades, Ace),(Hearts, Num 10)], 15) = 60;
val score_t3 = score([(Hearts, Queen),(Diamonds, Num 8),(Hearts, Num 10)], 30) = 2 div 2;
print " ---------------------------------- \n";

print "\n Tests for (g) officiate() \n";
val officiate_t1 = officiate([(Hearts, Jack), (Clubs, Num 8), (Spades, King)], [Draw, Discard (Hearts, Jack), Draw, Draw], 15) = 
                                                                                        score([(Clubs, Num 8), (Spades, King)], 15);
val officiate_t2 = officiate([(Hearts, Jack), (Clubs, Num 8), (Spades, King)], [Draw, Discard (Hearts, Jack), Draw], 15) = 
                                                                                        score([(Clubs, Num 8)], 15);
val officiate_t3 = officiate([(Hearts, Jack)], [Draw, Draw], 15) = score([(Hearts, Jack)], 15);
val officiate_t4 = officiate([(Hearts, Jack)], [Draw, Discard(Clubs, Jack)], 15)
                    handle IllegalMove => 0;
print " ---------------------------------- \n";

print "\n Tests for Challenge problems \n";
print "\n (a) Tests for score_challenge() \n";
val score_challenge_t1 = score_challenge([(Diamonds, Ace)], 10) = 3 div 2;
val score_challenge_t2 = score_challenge([(Diamonds, Ace)], 2) = 1 div 2;
val score_challenge_t3 = score_challenge([(Hearts, Ace), (Clubs, Num 7)], 15) = 7;
val score_challenge_t4 = score_challenge([(Clubs, Jack),(Spades, Num 4),(Spades, Ace),(Hearts, Num 10)], 15) = 30;
val score_challenge_t5 = score_challenge([(Hearts, Ace), (Clubs, Ace)], 15) = 3;
print " ---------------------------------- \n";

print "\n (a) Tests for officiate_challenge() \n";
val officiate_challenge_t1 = officiate_challenge([(Hearts, Jack), (Clubs, Num 8), (Spades, King)], [Draw, Discard (Hearts, Jack), Draw, Draw], 15) = 
                                                                                    score_challenge([(Clubs, Num 8), (Spades, King)], 15);
val officiate_challenge_t2 = officiate_challenge([(Hearts, Jack), (Clubs, Num 8), (Spades, Ace)], [Draw, Discard (Hearts, Jack), Draw, Draw], 15) = 
                                                                                    score_challenge([(Clubs, Num 8), (Spades, Ace)], 15);
val officiate_challenge_t3 = officiate_challenge([(Hearts, Jack)], [Draw, Draw], 15) = score_challenge([(Hearts, Jack)], 15);
print " ---------------------------------- \n";

print "\n (b) Tests for careful_player() \n";
val careful_player_t1 = careful_player([(Hearts, Jack), (Clubs, Num 8), (Spades, Ace), (Diamonds, Num 5)], 15) = [Draw];
val careful_player_t2 = careful_player([(Hearts, Jack), (Clubs, Num 8), (Spades, Ace), (Diamonds, Num 5)], 8) = [];
val careful_player_t3 = careful_player([(Hearts, Jack), (Spades, Ace), (Diamonds, Num 5)], 21) = [Draw, Draw];
val careful_player_t4 = careful_player([(Hearts, Jack), (Diamonds, Num 5)], 16) = [Draw, Draw, Draw];
val careful_player_t2 = careful_player([(Hearts, Jack), (Clubs, Num 8), (Spades, Ace), (Diamonds, Num 5)], 21) = 
                                                                           [Draw, Draw, Discard(Clubs, Num 8), Draw];
print " ---------------------------------- \n";