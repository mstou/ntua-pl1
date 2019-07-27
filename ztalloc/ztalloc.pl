% Some predicates to read the input.
% A modified version of the code available here:
% https://courses.softlab.ntua.gr/pl1/2019a/Exercises/read_colors_SWI.pl

read_input(File, N, Q) :-
    open(File, read, Stream),
    read_line(Stream, [N]),
    read_querries(Stream, N, Q, []).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

read_querries(_,0,Q,Acc) :-
    reverse(Q,Acc).

read_querries(Stream,N,Q,Acc) :-
    read_line(Stream, L),
    QuerriesLeft is N-1,
    read_querries(Stream,QuerriesLeft,Q,[L|Acc]).

isValid(X) :-
  X >= 0,
  X =< 999999.

isNodeValid(L,R) :-
  isValid(L),
  isValid(R).

nodeNotVisited(L,R,Parent) :-
  isNodeValid(L,R),
  \+ get_assoc((L,R),Parent,_).

% [L,R] is the current node
% Parent is the association list we use to keep track of
% visited nodes and their parents
findNeighbors(L,R,Parent,Neighbors,NewParent) :-
  L1 is 3*L+1,
  R1 is 3*R+1,
  (
    nodeNotVisited(L1,R1,Parent) ->
      Res1 = [(L1,R1)],
      put_assoc((L1,R1),Parent,("t",L,R),Parent_)
      ;
      Res1 = [],
      Parent_ = Parent
  ),
  L2 is L div 2,
  R2 is R div 2,
  (
    nodeNotVisited(L2,R2,Parent_) ->
      Neighbors = [(L2,R2)|Res1],
      put_assoc((L2,R2),Parent_,("h",L,R),NewParent)
      ;
      Neighbors = Res1,
      NewParent = Parent_
  ).
