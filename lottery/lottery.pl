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
    reverse(Acc,Tickets).

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
      NewTickets is Tickets + 1,
      put_assoc(H,Map,(NewTickets,NewChild),NewMap)

      ;

      insert(empty,[H|L],NewChild),
      put_assoc(H,Map,(1,NewChild),NewMap)
  ),
  NewN is N+1,
  T2 = trie(X,NewMap,NewN).
