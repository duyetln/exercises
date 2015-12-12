type awksub_nonterminals =
  | Expr | Term | Lvalue | Incrop | Binop | Num

let awkish_grammar =
  (Expr,
   function
     | Expr ->
         [[N Term; N Binop; N Expr];
          [N Term]]
     | Term ->
   [[N Num];
    [N Lvalue];
    [N Incrop; N Lvalue];
    [N Lvalue; N Incrop];
    [T"("; N Expr; T")"]]
     | Lvalue ->
   [[T"$"; N Expr]]
     | Incrop ->
   [[T"++"];
    [T"--"]]
     | Binop ->
   [[T"+"];
    [T"-"]]
     | Num ->
   [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
    [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]])

let accept_partial_match derivation frag =
  match frag with
  | [] -> None
  | _ -> Some (derivation, frag)

let test_1 = (derive_rule awkish_grammar (Expr,[N Term; N Binop; N Expr]) ([], ["1";"+";"$";"5";"-";"3"]) =
  Some
   [([(Expr, [N Term; N Binop; N Expr]); (Term, [N Num]); (Num, [T "1"]);
      (Binop, [T "+"]); (Expr, [N Term; N Binop; N Expr]);
      (Term, [N Lvalue]); (Lvalue, [T "$"; N Expr]); (Expr, [N Term]);
      (Term, [N Num]); (Num, [T "5"]); (Binop, [T "-"]); (Expr, [N Term]);
      (Term, [N Num]); (Num, [T "3"])],
     []);
    ([(Expr, [N Term; N Binop; N Expr]); (Term, [N Num]); (Num, [T "1"]);
      (Binop, [T "+"]); (Expr, [N Term]); (Term, [N Lvalue]);
      (Lvalue, [T "$"; N Expr]); (Expr, [N Term; N Binop; N Expr]);
      (Term, [N Num]); (Num, [T "5"]); (Binop, [T "-"]); (Expr, [N Term]);
      (Term, [N Num]); (Num, [T "3"])],
     []);
    ([(Expr, [N Term; N Binop; N Expr]); (Term, [N Num]); (Num, [T "1"]);
      (Binop, [T "+"]); (Expr, [N Term]); (Term, [N Lvalue]);
      (Lvalue, [T "$"; N Expr]); (Expr, [N Term]); (Term, [N Num]);
      (Num, [T "5"])],
     ["-"; "3"])])
let test_2 = (derive_symbol awkish_grammar (N Expr) ([], ["$";"1";"+";"(";"2";"+";"3";")";"$"]) =
  Some
   [([(Expr, [N Term; N Binop; N Expr]); (Term, [N Lvalue]);
      (Lvalue, [T "$"; N Expr]); (Expr, [N Term]); (Term, [N Num]);
      (Num, [T "1"]); (Binop, [T "+"]); (Expr, [N Term]);
      (Term, [T "("; N Expr; T ")"]); (Expr, [N Term; N Binop; N Expr]);
      (Term, [N Num]); (Num, [T "2"]); (Binop, [T "+"]); (Expr, [N Term]);
      (Term, [N Num]); (Num, [T "3"])],
     ["$"]);
    ([(Expr, [N Term]); (Term, [N Lvalue]); (Lvalue, [T "$"; N Expr]);
      (Expr, [N Term; N Binop; N Expr]); (Term, [N Num]); (Num, [T "1"]);
      (Binop, [T "+"]); (Expr, [N Term]); (Term, [T "("; N Expr; T ")"]);
      (Expr, [N Term; N Binop; N Expr]); (Term, [N Num]); (Num, [T "2"]);
      (Binop, [T "+"]); (Expr, [N Term]); (Term, [N Num]); (Num, [T "3"])],
     ["$"]);
    ([(Expr, [N Term]); (Term, [N Lvalue]); (Lvalue, [T "$"; N Expr]);
      (Expr, [N Term]); (Term, [N Num]); (Num, [T "1"])],
     ["+"; "("; "2"; "+"; "3"; ")"; "$"])])
let test_3 = (derive_symbol awkish_grammar (N Num) ([], ["2";"-"]) = Some [([(Num, [T "2"])], ["-"])])
let test_4 = (derive_symbol awkish_grammar (N Lvalue) ([], ["2";"+";"3"]) = None)
let test_5 = (parse_prefix awkish_grammar accept_partial_match ["1"] = None)
let test_6 = (parse_prefix awkish_grammar accept_partial_match ["$";"1";"+";"(";"2";"+";"3";")";"$"] =
 Some
  ([(Expr, [N Term; N Binop; N Expr]); (Term, [N Lvalue]);
    (Lvalue, [T "$"; N Expr]); (Expr, [N Term]); (Term, [N Num]);
    (Num, [T "1"]); (Binop, [T "+"]); (Expr, [N Term]);
    (Term, [T "("; N Expr; T ")"]); (Expr, [N Term; N Binop; N Expr]);
    (Term, [N Num]); (Num, [T "2"]); (Binop, [T "+"]); (Expr, [N Term]);
    (Term, [N Num]); (Num, [T "3"])],
   ["$"]))


type number_nonterminals =
  Number | Digit

let number_grammar =
  (Number,
   function
     | Number ->
         [[N Digit; N Number];
          [N Digit]]
     | Digit ->
   [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
    [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]])

let test_7 = (derive_symbol number_grammar (N Digit) ([], ["1";"2";"3"]) = Some [([(Digit, [T "1"])], ["2"; "3"])])
let test_8 = (derive_symbol number_grammar (N Number) ([], ["1";"2";"3"]) =
  Some
   [([(Number, [N Digit; N Number]); (Digit, [T "1"]);
      (Number, [N Digit; N Number]); (Digit, [T "2"]); (Number, [N Digit]);
      (Digit, [T "3"])],
     []);
    ([(Number, [N Digit; N Number]); (Digit, [T "1"]); (Number, [N Digit]);
      (Digit, [T "2"])],
     ["3"]);
    ([(Number, [N Digit]); (Digit, [T "1"])], ["2"; "3"])])
let test_9 = (parse_prefix number_grammar (fun d -> function | "3"::t -> Some (d,"3"::t) | _ -> None) ["1";"2";"3"] =
  Some
   ([(Number, [N Digit; N Number]); (Digit, [T "1"]); (Number, [N Digit]);
     (Digit, [T "2"])],
    ["3"]))
let test_10 = (parse_prefix number_grammar (fun d -> function | [] -> Some (d, []) | _ -> None) ["1";"2";"3"] =
  Some
   ([(Number, [N Digit; N Number]); (Digit, [T "1"]);
     (Number, [N Digit; N Number]); (Digit, [T "2"]); (Number, [N Digit]);
     (Digit, [T "3"])],
    []))
