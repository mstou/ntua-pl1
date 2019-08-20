% Some predicates to read the input.
% A modified version of the code available here:
% https://courses.softlab.ntua.gr/pl1/2019a/Exercises/read_colors_SWI.pl

read_input(File, K, N, Q, Tickets, Winning) :-
    open(File, read, Stream),
    read_line(Stream, [K, N, Q]),
    read_tickets(Stream, [], N, Tickets),
    read_tickets(Stream, [], Q, Winning).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

read_ticket(Stream, T) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atom_chars(Atom, Chars),
    maplist(atom_number, Chars, L),
    reverse(L,T). % we store the ticket in reverse

% read_tickets(Stream, Acc, N, Tickets)
read_tickets(_, Acc, 0, Tickets) :-
    % reverse(Acc,Tickets).
    Tickets = Acc.
    % The tickets and querries are stored in reverse order
    % They will be reversed again when running the querries

read_tickets(Stream, Acc, N, Tickets) :-
    N > 0,
    read_ticket(Stream, T),
    TicketsLeft is N-1,
    read_tickets(Stream, [T|Acc], TicketsLeft, Tickets).


% datatype trie = empty | trie(node, children, tickets)
%
% children is an association list with key the children's node
% and value a tuple with ticketsHanging from the children and the trie
% rooted at the children.

% insert(T,L,Tfinal)
insert(T1,[],T2) :- T2 = T1.

insert(empty, [X], T2) :-
  empty_assoc(Y),
  T2 = trie(X,Y,1).

insert(empty,[X1,X2|L],T) :-
  insert(empty,[X2|L],Child),
  empty_assoc(Z),
  put_assoc(X2,Z,(1,Child),Map),
  T = trie(X1,Map,1).

insert(trie(X,Map,N), [H|L], T2) :-
  (
    get_assoc(H,Map,Val) ->
      (Tickets,ChildTrie) = Val,
      insert(ChildTrie,L,NewChild),
      !,
      NewTickets is Tickets + 1,
      put_assoc(H,Map,(NewTickets,NewChild),NewMap)

      ;

      insert(empty,[H|L],NewChild),
      !,
      put_assoc(H,Map,(1,NewChild),NewMap)
  ),
  NewN is N+1,
  T2 = trie(X,NewMap,NewN).

insertList(T1,[],T) :-
  T = T1.

insertList(T1,[H|L],T) :-
  insert(T1,H,T2),
  !,
  insertList(T2,L,T).

query(empty,_,_,(Tickets,Money)) :-
  Tickets is 0,
  Money is 0.

query(trie(_,_,N),[],M,(Tickets,Money)) :-
  Tickets is N,
  Money is (N * (((2 ** M) - 1) mod 1000000007)) mod 1000000007.

query(trie(_,Map,N),[H|L],M,(Tickets,Money)) :-
  (
    get_assoc(H,Map,Val) ->
      (ChildTickets,ChildTrie) = Val,
      NewM is M+1,
      query(ChildTrie,L,NewM,(_,ChildMoney)),
      !,
      RemainingTickets is N - ChildTickets
      ;

      RemainingTickets is N,
      ChildMoney is 0,
      ChildTickets is 0
  ),
  !,
  (
    M =:= 0 ->
      Tickets is ChildTickets
      ;
      Tickets is N
  ),
  CurrNodeMoney is (RemainingTickets * (((2 ** M) - 1) mod 1000000007)) mod 1000000007,
  Money is (CurrNodeMoney + ChildMoney) mod 1000000007.

runQuerries(_,[],Results,Acc) :-
  Results = Acc.

runQuerries(T,[H|L],Results,Acc) :-
  query(T,H,0,(Tickets,Money)),
  !,
  runQuerries(T,L,Results,[[Tickets,Money]|Acc]).

lottery(File,L) :-
  read_input(File,_,_,_,Tickets,Winning),
  !,
  insertList(trie(-1,t,0),Tickets,Trie),
  !,
  runQuerries(Trie,Winning,L,[]),
  !.

% ========== Runing Testcases ==========
% read_results(File,N,L) :-
%   open(File, read, Stream),
%   read_result(Stream,N,L,[]).
%
% read_result(_,0,L,Acc) :-
%   reverse(L,Acc).
%
% read_result(Stream,N,L,Acc) :-
%   read_line(Stream, R),
%   Remaining is N-1,
%   read_result(Stream,Remaining,L,[R|Acc]).
%
% listEqual([],[]).
% listEqual([[T1,M1]],[[T2,M2]]) :-
%   T1 =:= T2,
%   M1 =:= M2.
% listEqual([[T1,M1]|L1],[[T2,M2]|L2]) :-
%   T1 =:= T2,
%   M1 =:= M2,
%   listEqual(L1,L2).
%
% evaluate_testcase(TestNum,Result) :-
%   string_concat("testcases/lottery.in",TestNum,InputFile),
%   string_concat("testcases/lottery.out",TestNum,OutputFile),
%   read_input(InputFile,_,_,Q,Tickets,Winning),
%   insertList(trie(-1,t,0),Tickets,Trie),
%   runQuerries(Trie,Winning,L,[]),
%   read_results(OutputFile,Q,R),
%   (
%     listEqual(L,R) ->
%       Result = "+++ OK!"
%       ;
%       Result = "--- Testcase Failed!"
%   ),
%   !.
