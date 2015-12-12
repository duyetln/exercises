let my_uniq_test0 = uniq [] = []
let my_uniq_test1 = uniq [1;2;1;3;1;4] = [1;2;3;4]
let my_uniq_test2 = uniq [1;1;1;1;1] = [1]

let my_subset_test0 = subset [] []
let my_subset_test1 = subset [] [1;3;5;8]
let my_subset_test2 = subset [1;1;3] [1;3;5;8;1]
let my_subset_test3 = not (subset [1;1;3;13] [1;3;5;8;8])
let my_subset_test4 = not (subset [1;3;5] [])

let my_equal_sets_test0 = equal_sets [] []
let my_equal_sets_test1 = equal_sets [1;5;3] [3;1;5;5]
let my_equal_sets_test2 = equal_sets [1;1;1] [1]
let my_equal_sets_test3 = not (equal_sets [] [1;3;5;8])
let my_equal_sets_test4 = not (equal_sets [1;3;5;8] [])

let my_set_union_test0 = set_union [] [] = []
let my_set_union_test1 = set_union [1;3;5] [] = [1;3;5]
let my_set_union_test2 = set_union [] [1;3;5] = [1;3;5]
let my_set_union_test3 = set_union [1;1;3;5] [8;13;13;21] = [1;3;5;8;13;21]
let my_set_union_test4 = not (set_union [1;1;3;5] [8;13;13;21] = [1;1;3;5;8;13;13;21])

let my_set_intersection_test0 = set_intersection [] [] = []
let my_set_intersection_test1 = set_intersection [] [1;3;5;8] = []
let my_set_intersection_test2 = set_intersection [1;1;3;5] [1;5;5;8;13] = [1;5]
let my_set_intersection_test3 = not (set_intersection [1;1;3;5] [1;5;5;8;13] = [1;1;1;5;5])
let my_set_intersection_test4 = not (set_intersection [1;1;3;5] [1;5;5;8;13] = [5;1])

let my_set_diff_test0 = set_diff [] [1;1;3;5] = []
let my_set_diff_test1 = set_diff [1;1;3;5] [] = [1;3;5]
let my_set_diff_test2 = set_diff [1;1;3;5] [5;8;8;13] = [1;3]
let my_set_diff_test3 = not (set_diff [1;1;3;5] [5;8;8;13] = [8])

let my_computed_fixed_point_test0 = computed_fixed_point (=) (fun x -> x / 2) 1000000000 = 0
let my_computed_fixed_point_test1 = computed_fixed_point (=) (fun x -> x *. 2.) 1. = infinity
let my_computed_fixed_point_test2 = computed_fixed_point (=) (fun x -> x ** 2. -. x *. 3. +. 4.) 2. = 2.
let my_computed_fixed_point_test3 = computed_fixed_point (=) sqrt 10. = 1.

let my_computed_periodic_point_test0 = computed_periodic_point (=) (fun x -> x / 2) 0 (-1) = -1
let my_computed_periodic_point_test1 = computed_periodic_point (=) (fun x -> x *. x -. 1.) 2 0.5 = -1.

type giant_nonterminals =
  | Conversation | Sentence | Grunt | Snore | Shout | Quiet

let giant_grammar =
  Conversation,
  [Grunt, [T"khrgh"];
    Snore, [T"ZZZ"];
    Quiet, [];
    Shout, [T"aooogah!"];
    Sentence, [N Quiet];
    Sentence, [N Grunt];
    Sentence, [N Shout];
    Conversation, [N Snore];
    Conversation, [N Sentence; T","; N Conversation]]

let my_giant_test0 =
  filter_blind_alleys giant_grammar = giant_grammar

let my_giant_test1 =
  filter_blind_alleys (Sentence, List.tl (snd giant_grammar)) =
    (Sentence,
      [Snore, [T "ZZZ"]; Quiet, []; Shout, [T "aooogah!"];
        Sentence, [N Quiet]; Sentence, [N Shout];
        Conversation, [N Snore];
        Conversation, [N Sentence; T","; N Conversation]])

let my_giant_test2 =
  filter_blind_alleys (Sentence, List.tl (List.tl (snd giant_grammar))) =
    (Sentence,
      [Quiet, []; Shout, [T "aooogah!"];
        Sentence, [N Quiet]; Sentence, [N Shout]])




