% Predicates that read the input
% https://courses.softlab.ntua.gr/pl1/2019a/Exercises/read_colors_SWI.pl

read_input(File, N, K, C) :-
    open(File, read, Stream),
    read_line(Stream, [N, K]),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

% findNewStart(Start,FreqMap,Colors,NewStart,NewFreqMap)
findNewStart(Start,FreqMap,Colors,NewStart,NewFreqMap) :-
  get_assoc(Start,Colors,ColorAtStart),
  get_assoc(ColorAtStart,FreqMap,ColorFreq),
  (
    ColorFreq > 1 ->
      NewFreq is ColorFreq - 1,
      Start_ is Start + 1,
      put_assoc(ColorAtStart,FreqMap,NewFreq,FreqMap_),
      findNewStart(Start_,FreqMap_,Colors,NewStart,NewFreqMap)
      ;
      NewStart is Start,
      NewFreqMap = FreqMap
  ).

% loop(Start,End,Colors,FreqMap,ColorsUsed,K,N,PreviousBest,Answer)
loop(_,End,_,_,_,_,N,BestResult,Answer) :-
  End =:= N - 1,
  Answer is BestResult.

loop(_,_,_,_,_,1,N,_,Answer) :-
  N >= 1,
  Answer is 1.

loop(-1,-1,Colors,FreqMap,ColorsUsed,AllColors,N,BestRes,Answer) :-
  get_assoc(0,Colors,FirstColor),
  put_assoc(FirstColor,FreqMap,1,NewFreqMap),
  NewColorsUsed is ColorsUsed + 1,
  loop(0,0,Colors,NewFreqMap,NewColorsUsed,AllColors,N,BestRes,Answer).

% When starting the predicate, we know the best result for all the
% windows ending up to (and including) End.
loop(Start,End,Colors,FreqMap,ColorsUsed,AllColors,N,BestRes,Answer) :-
  NewEnd is End + 1,
  get_assoc(NewEnd,Colors,NewColor),
  (
    get_assoc(NewColor,FreqMap,EndFreq) ->
      NewColorsUsed is ColorsUsed,
      NewEndFreq is EndFreq +1,
      put_assoc(NewColor,FreqMap,NewEndFreq,FreqMap_)
      ;
      NewColorsUsed is ColorsUsed + 1,
      put_assoc(NewColor,FreqMap,1,FreqMap_)
  ),
  findNewStart(Start,FreqMap_,Colors,NewStart,NewFreqMap),
  (
    NewColorsUsed =:= AllColors ->
      NewBestRes is min(BestRes,NewEnd-NewStart+1)
      ;
      NewBestRes is BestRes
  ),
  loop(NewStart,NewEnd,Colors,NewFreqMap,NewColorsUsed,AllColors,N,NewBestRes,Answer).

listToAssoc(L,X) :-
  empty_assoc(Y),
  listToAssoc(L,0,Y,X).

listToAssoc([],_,X,Y) :- X = Y.

listToAssoc([H|L],N,X,Y) :-
  put_assoc(N,X,H,X1),
  NewIndex is N+1,
  listToAssoc(L,NewIndex,X1,Y).

colors(File,Answer) :-
  read_input(File,N,K,C),
  BestResult is N+1,
  listToAssoc(C,X),
  empty_assoc(Y),
  loop(-1,-1,X,Y,0,K,N,BestResult,Ans),
  (
    Ans =:= BestResult ->
      Answer is 0
      ;
      Answer is Ans
  ).
