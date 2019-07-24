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
