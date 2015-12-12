open List;;
open Pervasives;;

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal
;;

let convert_grammar = function
  | a, b ->
    a, fun n -> map (function | x, y -> y) (filter (function | x, y -> x == n) b)
;;

(* returns Some [ (derivation, frag), (derivation, frag)...] or Some [] *)
let reduce arr = (* array of Some [ (derivation, frag), (derivation, frag)...] *)
  fold_left (fun acc some ->
    match acc, some with
    | None, None -> Some []
    | Some aa, Some sa -> Some (aa @ sa)
    | _, None -> acc
    | None, _ -> some
  ) (Some []) arr
;;

let convert some =
  match some with
  | Some [] -> None
  | _ -> some
;;

(* some = Some (der, frag) *)
(* sym = N Term... *)
(* pair = (der, frag) *)

(* returns Some [ (derivation, frag), (derivation, frag)...] or None *)
let rec derive_symbol grammar sym pair =
  let finder = snd grammar in
  match pair with
  | _, [] -> None
  | der, head::tail ->
    match sym with
    | T t -> if t = head then Some [(der, tail)] else None
    | N n -> (
      convert (
        reduce (
          map (fun r -> derive_rule grammar (n, r) pair) (finder n)
        )
      )
    )
(* returns Some [ (derivation, frag), (derivation, frag)...] or None *)
and derive_rule grammar rule pair =
  match pair with
  | _, [] -> None
  | der, frg ->
    convert (
      fold_left (fun acc sym ->
        match acc with
        | None -> Some []
        | Some pairs ->
          reduce (
            map (fun p -> derive_symbol grammar sym p) pairs
          )
      ) (
        Some [der @ [rule], frg]
      ) (
        snd rule
      )
    )
;;

let parse_prefix grammar acceptor frag =
  let start, finder = grammar in
  let some = reduce (
    map (fun r -> derive_rule grammar (start, r) ([], frag)) (finder start)
  ) in
  let ders = match some with Some [] | None -> [] | Some a -> a in
  let mders = map (fun pair ->
    let der, frg = pair in
    acceptor der frg
  ) ders in
  try find (fun mder ->
    match mder with Some _ -> true | _ -> false
  ) mders with _ -> None
;;
