% Common
value(Square, R-C, Value) :-
  nth(R, Square, Row),
  nth(C, Row, Value).

values([], []).
values([Row|Rows], Values) :-
  append(Row, RowsValues, Values),
  values(Rows, RowsValues).

slice([], [], []).
slice([[]|Tail], HTail, TTail) :-
  slice(Tail, HTail, TTail).
slice([[H|T]|Tail], [H|HTail], [T|TTail]) :-
  slice(Tail, HTail, TTail).


% Plain KenKen implementation
pl_multlist([E], E).
pl_multlist([H|L], E) :-
  pl_multlist(L, P),
  E is H * P.

pl_sumlist(L, S) :-
  sum_list(L, S).

pl_satisfy(_, +(_, [])) :- !.
pl_satisfy(Square, +(S, [H|L])) :-
  maplist(value(Square), [H|L], SquareValues),
  pl_sumlist(SquareValues, S).

pl_satisfy(_, *(_, [])) :- !.
pl_satisfy(Square, *(P, [H|L])) :-
  maplist(value(Square), [H|L], SquareValues),
  pl_multlist(SquareValues, P).

pl_satisfy(Square, -(D, J, K)) :-
  value(Square, J, JV),
  value(Square, K, KV),
  D is JV - KV.
pl_satisfy(Square, -(D, J, K)) :-
  value(Square, J, JV),
  value(Square, K, KV),
  D is KV - JV.

pl_satisfy(Square, /(D, J, K)) :-
  value(Square, J, JV),
  value(Square, K, KV),
  D is JV // KV.
pl_satisfy(Square, /(D, J, K)) :-
  value(Square, J, JV),
  value(Square, K, KV),
  D is KV // JV.

pl_nonoverlapping([], _) :- !.
pl_nonoverlapping([H|T], Rows) :-
  slice(Rows, RowsHead, RowsTail),
  \+(memberchk(H, RowsHead)),
  pl_nonoverlapping(T, RowsTail).

pl_row(0, []).
pl_row(ColCount, [ColCount|Row]) :-
  ColCount > 0,
  NextColCount is ColCount - 1,
  pl_row(NextColCount, Row).

pl_kenken_shape(0, _, []).
pl_kenken_shape(RowCount, ColCount, [Row|Rows]) :-
  RowCount > 0,
  NextRowCount is RowCount - 1,
  pl_row(ColCount, InitialRow),
  pl_kenken_shape(NextRowCount, ColCount, Rows),
  permutation(InitialRow, Row),
  pl_nonoverlapping(Row, Rows).


% FD KenKen implementation
fd_multlist([E], E).
fd_multlist([H|L], E) :-
  fd_multlist(L, P),
  E #= H * P.

fd_sumlist([E], E).
fd_sumlist([H|L], E) :-
  fd_sumlist(L, S),
  E #= H + S.

fd_satisfy(_, +(_, [])) :- !.
fd_satisfy(Square, +(S, [H|L])) :-
  maplist(value(Square), [H|L], SquareValues),
  fd_sumlist(SquareValues, S).

fd_satisfy(_, *(_, [])) :- !.
fd_satisfy(Square, *(P, [H|L])) :-
  maplist(value(Square), [H|L], SquareValues),
  fd_multlist(SquareValues, P).

fd_satisfy(Square, -(D, J, K)) :-
  value(Square, J, JV),
  value(Square, K, KV),
  D #= JV - KV.
fd_satisfy(Square, -(D, J, K)) :-
  value(Square, J, JV),
  value(Square, K, KV),
  D #= KV - JV.

fd_satisfy(Square, /(D, J, K)) :-
  value(Square, J, JV),
  value(Square, K, KV),
  D #= JV / KV.
fd_satisfy(Square, /(D, J, K)) :-
  value(Square, J, JV),
  value(Square, K, KV),
  D #= KV / JV.

fd_rows_different([]) :- !.
fd_rows_different([Row|Rows]) :-
  fd_all_different(Row),
  fd_rows_different(Rows).

fd_cols_different([]) :- !.
fd_cols_different(Rows) :-
  slice(Rows, RowsHead, RowsTail),
  fd_all_different(RowsHead),
  fd_cols_different(RowsTail).

fd_row(0, _, []).
fd_row(ColCount, Max, [FDV|Rows]) :-
  ColCount > 0,
  NextColCount is ColCount - 1,
  fd_domain(FDV, 1, Max),
  fd_row(NextColCount, Max, Rows).

fd_kenken_shape(0, _, _, []).
fd_kenken_shape(RowCount, ColCount, Max, [Row|Rows]) :-
  RowCount > 0,
  NextRowCount is RowCount - 1,
  fd_row(ColCount, Max, Row),
  fd_kenken_shape(NextRowCount, ColCount, Max, Rows),
  fd_rows_different([Row|Rows]),
  fd_cols_different([Row|Rows]).


% KenKen predicates
plain_kenken(N, C, Square) :-
  pl_kenken_shape(N, N, Square),
  maplist(pl_satisfy(Square), C).

kenken(N, C, Square) :-
  fd_kenken_shape(N, N, N, Square),
  maplist(fd_satisfy(Square), C),
  values(Square, Values),
  fd_labeling(Values).

% Test cases
% The time indicates how long it takes for each version to arrive at its first solution.
% This does not equal total time it takes to evaluate all possible solutions.

% kenken: 1ms, plain_kenken: 42791ms.
kenken_testcase1(
  5,
  [
    *(240, [1-1, 1-2, 1-3, 2-2]),
    -(2, 1-4, 2-4),
    *(40, [1-5, 2-5, 3-5]),
    +(5, [2-1, 3-1]),
    *(5, [2-3, 3-3, 3-2]),
    -(3, 3-4, 4-4),
    +(10, [4-1, 5-1, 5-2]),
    *(12, [4-2, 4-3, 5-3]),
    +(8, [4-5, 5-5, 5-4])
  ]
).

% kenken: 1ms, plain_kenken: 14531ms.
kenken_testcase2(
  5,
  [
    *(6, [1-1, 1-2]),
    +(13, [1-3, 1-4, 1-5, 2-5]),
    -(2, 2-1, 3-1),
    -(1, 2-2, 2-3),
    -(3, 2-4, 3-4),
    /(2, 3-2, 3-3),
    +(7, [3-5, 4-5, 5-5]),
    *(20, [4-1, 4-2]),
    -(2, 4-3, 5-3),
    *(3, [4-4, 5-4]),
    /(2, 5-1, 5-2)
  ]
).

% kenken: 1ms, plain_kenken: 12ms.
kenken_testcase3(
  4,
  [
    *(12, [1-1, 1-2]),
    *(4, [1-3, 2-3]),
    /(2, 1-4, 2-4),
    /(2, 2-1, 3-1),
    -(1, 2-2, 3-2),
    -(1, 3-3, 4-3),
    -(1, 3-4, 4-4),
    +(5, [4-1, 4-2])
  ]
).

% kenken: 1ms, plain_kenken: 23ms.
kenken_testcase4(
  4,
  [
    *(12, [1-1, 1-2]),
    /(2, 1-3, 2-3),
    /(2, 1-4, 2-4),
    +(5, [2-1, 2-2, 3-1]),
    -(2, 3-2, 3-3),
    -(2, 3-4, 4-4),
    *(24, [4-1, 4-2, 4-3])
  ]
).

% kenken: 1ms, plain_kenken: too long.
kenken_testcase5(
  6,
  [
   +(11, [1-1, 2-1]),
   /(2, 1-2, 1-3),
   *(20, [1-4, 2-4]),
   *(6, [1-5, 1-6, 2-6, 3-6]),
   -(3, 2-2, 2-3),
   /(3, 2-5, 3-5),
   *(240, [3-1, 3-2, 4-1, 4-2]),
   *(6, [3-3, 3-4]),
   *(6, [4-3, 5-3]),
   +(7, [4-4, 5-4, 5-5]),
   *(30, [4-5, 4-6]),
   *(6, [5-1, 5-2]),
   +(9, [5-6, 6-6]),
   +(8, [6-1, 6-2, 6-3]),
   /(2, 6-4, 6-5)
  ]
).

% The no op KenKen solver can have an API similar as the normal KenKen solver above:
%
%   no_op_kenken(N, C, S, NC)
%
% where:
%   - N is a nonnegative number specifying the size of the KenKen square.
%   - C is the list of numeric case constraints. Each element in C has the form (target_number, list_of_squares).
%     Notice there is no symbol indicating the operation, unlike the constraints of normal KenKen solver.
%   - S is the list of list of integers, which is the numeric solution of the KenKen square.
%   - NC is the updated list of constraints where each constraint has the forms specified in the normal KenKen solver.
%     The purpose of this is to conveniently fetch NC to the normal KenKen solver to cross check the result of no op KenKen solver.
