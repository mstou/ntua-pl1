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
    Q = Acc.

read_querries(Stream,N,Q,Acc) :-
    read_line(Stream, L),
    QuerriesLeft is N-1,
    read_querries(Stream,QuerriesLeft,Q,[L|Acc]).

% FIFO Queue implementation
fifo_empty(Q) :-
  empty_assoc(X),
  Q = (-1,-1,X).

% fifo_insert(Q1,X,Q2)
% Makes a new FIFO Queue Q2, which is Q1 with X inserted
fifo_insert((-1,-1,A),X,Q2) :-
  put_assoc(0,A,X,NewTree),
  Q2 = (0,1,NewTree),
  !.

fifo_insert((Head,Tail,T),X,Q2) :-
  NewTail is Tail + 1,
  put_assoc(Tail,T,X,NewT),
  Q2 = (Head,NewTail,NewT),
  !.

% fifo_insertList(Q1,L,Q2)
fifo_insertList(Q1,[],Q2) :-
  Q2 = Q1.

fifo_insertList(Q1,[H|L],Q2) :-
  fifo_insert(Q1,H,Q_),
  !,
  fifo_insertList(Q_,L,Q2).

% fifo_pop(Q1,X,Q2)
% Pops an item from Q1.
% X is the item popped and Q2 is the remaining queue
% Returns false if Q1 is empty
fifo_pop((Head,Tail,T),X,Q2) :-
  Head =\= Tail,
  del_assoc(Head,T,X,NewT),
  NewHead is Head + 1,
  Q2 = (NewHead,Tail,NewT),
  !.

% fifo_isEmpty(Q)
% Is true if Q is empty
fifo_isEmpty((Head,Tail,_)) :-
  Head =:= Tail.

% =========================
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
      put_assoc((L1,R1),Parent,('t',L,R),Parent_)
      ;
      Res1 = [],
      Parent_ = Parent
  ),
  L2 is L div 2,
  R2 is R div 2,
  (
    nodeNotVisited(L2,R2,Parent_) ->
      Neighbors = [(L2,R2)|Res1],
      put_assoc((L2,R2),Parent_,('h',L,R),NewParent)
      ;
      Neighbors = Res1,
      NewParent = Parent_
  ).

checkForAnswer([],_,Ans,A) :-
  A = -1,
  Ans = (-73,-73).

checkForAnswer([H|L],(Lout,Rout),Ans,A) :-
  (L1,R1) = H,
  (
    isAnswer(L1,R1,Lout,Rout) ->
      Ans = H,
      A = 1
      ;
      checkForAnswer(L,(Lout,Rout),Ans,A)
  ).

isAnswer(Lin,Rin,Lout,Rout) :-
  Lin >= Lout,
  Rin =< Rout.

findPath((-73,-73),_,Acc,Answer) :-
  atomic_list_concat(Acc,Answer).

findPath((L,R),Parent,Acc,Answer) :-
  get_assoc((L,R),Parent,(Move,ParentL,ParentR)),
  (
    ParentL =:= -73 ->
      findPath((-73,-73),Parent,Acc,Answer)
      ;
      findPath((ParentL,ParentR),Parent,[Move|Acc],Answer)
  ).

bfs(Lin,Rin,Lout,Rout,Answer) :-
  (
    isAnswer(Lin,Rin,Lout,Rout) ->
      Answer = 'EMPTY'
      ;
      empty_assoc(X),
      put_assoc((Lin,Rin),X,('start',-73,-73),Parent),
      fifo_empty(Q),
      fifo_insert(Q,(Lin,Rin),Q1),
      bfsLoop(Q1,(Lout,Rout),Parent,Answer)
  ).

bfsLoop(Q,_,_,Answer) :-
  fifo_isEmpty(Q),
  Answer = 'IMPOSSIBLE'.

bfsLoop(Q,(Lout,Rout),Parent,Answer) :-
  fifo_pop(Q,(L,R),Q_),
  findNeighbors(L,R,Parent,Neighbors,NewParent),
  checkForAnswer(Neighbors,(Lout,Rout),Node,FoundAnswer),
  (
    FoundAnswer =:= 1 ->
      findPath(Node,NewParent,[],Answer)
      ;
      fifo_insertList(Q_,Neighbors,NewQueue),
      !,
      bfsLoop(NewQueue,(Lout,Rout),NewParent,Answer)
  ).

runQuerries([],Acc,Answer) :-
  Answer = Acc.

runQuerries([H|L],Acc,Answer) :-
  [Lin,Rin,Lout,Rout] = H,
  bfs(Lin,Rin,Lout,Rout,Ans),
  !,
  runQuerries(L,[Ans|Acc],Answer).

ztalloc(File,Answer) :-
  read_input(File,_,Q),
  runQuerries(Q,[],Answer),
  !.

% % ================ Tests ================
% read_test_output(File,N,Answers) :-
%   open(File,read,Stream),
%   read_output_lines(Stream,N,[],Answers).
%
% read_output_line(Stream,L) :-
%   read_line_to_codes(Stream,Line),
%   atom_codes(L,Line).
%
% read_output_lines(_,0,Acc,Answers) :-
%   reverse(Acc,Answers).
%
% read_output_lines(Stream,N,Acc,Answers) :-
%   Remaining is N-1,
%   read_output_line(Stream,L),
%   read_output_lines(Stream,Remaining,[L|Acc],Answers).
%
% listEqual([],[]).
% listEqual([H1|L1],[H2|L2]) :-
%   (
%    H1 = H2 ->
%      H1 = H2
%      ;
%      writeln(H1),
%      writeln(H2)
%   ),
%   listEqual(L1,L2).
%
% evaluate_testcase(TestNum) :-
%   string_concat("testcases/ztalloc.in",TestNum,InputFile),
%   string_concat("testcases/ztalloc.out",TestNum,OutputFile),
%   read_input(InputFile,N,Q),
%   statistics(walltime, [ _ | [_]]),
%   runQuerries(Q,[],Answer),
%   statistics(walltime, [ _ | [ExecutionTime]]),
%   read_test_output(OutputFile,N,ExpectedAnswer),
%   (
%     listEqual(Answer,ExpectedAnswer) ->
%       writeln("+++ OK!")
%       ;
%       writeln("--- Testcase Failed!")
%   ),
%   write('Execution took '),
%   write(ExecutionTime),
%   writeln(' ms.'),
%   !.
% % =======================================
