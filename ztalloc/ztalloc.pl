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
