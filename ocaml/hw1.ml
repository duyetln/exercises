open List;;
open Pervasives;;

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal;;

(* remove duplicates from a list; tail recursive *)
let uniq a =
  let rec tail_uniq x l =
    match x with
    | [] -> l
    | h::t -> if mem h l then tail_uniq t l else tail_uniq t (l @ [h])
  in tail_uniq a [];;

(* a is a subset of b iff all elements of a are member of b *)
let subset a b = for_all (fun x -> mem x b) a;;

(* two sets are equal iff they are both subsets of each other *)
let equal_sets a b = (subset a b) && (subset b a);;

(* combine two sets and remove duplicates *)
let set_union a b = uniq (a @ b);;

(* compute the union of two sets and select elements that are both member of two sets *)
let set_intersection a b = filter (fun x -> (mem x a) && (mem x b)) (set_union a b);;

(* compute the union of two sets and select elements that are member of one set but not the other *)
let set_diff a b = filter (fun x -> (mem x a) && not (mem x b)) (set_union a b);;

(* use anonymous function to apply f to x p times then compare the result; tail recursive *)
let rec computed_periodic_point eq f p x =
  let rec apply fn c v = if c <= 0 then v else apply fn (c - 1) (fn v)
  and fx = f x in
  if eq (apply f p x) x then x else computed_periodic_point eq f p fx;;

(* use computed_period_point with p = 1 *)
let computed_fixed_point eq f x = computed_periodic_point eq f 1 x;;

(* a rule is productive if from its derivation there is a way to reach a terminal *)
let rec productive r rls =
  let rrls = set_diff rls [r] in (* remaining rules *)
  for_all
    (fun s -> match s with
      | T t -> true
      | N n -> exists
        (fun x -> productive x rrls)
        (filter (fun x -> fst x = n) rrls)
    )
    (snd r);;

(* select productive rules only *)
let filter_blind_alleys g =
  let rls = snd g and n = fst g in
  (n, filter (fun r -> productive r rls) rls);;
