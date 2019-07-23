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

  % findStart test:
  % empty_assoc(X),
  % put_assoc(1,X,4,X1),
  % put_assoc(4,X1,2,X2),
  % put_assoc(3,X2,2,X3),
  % put_assoc(2,X3,1,X4),
  % findNewStart(0,X4,[1,1,1,4,3,1,3,2,4],NewStart,NewFreqMap,DroppedColors).

% loop(Start,End,WindowColors,ColorsAfter,FreqMap,ColorsUsed,K,PreviousBest,BestResult)
loop(_,_,_,[],_,_,_,BestResult,Answer) :-
  Answer is BestResult,
  !.

loop(_,_,_,[_|_],_,_,1,_,Answer) :-
  Answer is 1.

loop(Start,End,[],[H2|L2],FreqMap,ColorsUsed,AllColors,BestRes,Answer) :-
  put_assoc(H2,FreqMap,1,NewFreqMap),
  NewColorsUsed is ColorsUsed + 1,
  loop(Start,End,[H2],L2,NewFreqMap,NewColorsUsed,AllColors,BestRes,Answer).

% When starting the predicate, End is exaclty at the last element of L1
% When exiting it is at H2
loop(Start,End,[H1|L1],[H2|L2],FreqMap,ColorsUsed,AllColors,BestRes,Answer) :-
  (
    get_assoc(H2,FreqMap,EndFreq) ->
      NewColorsUsed is ColorsUsed,
      NewEndFreq is EndFreq +1,
      put_assoc(H2,FreqMap,NewEndFreq,FreqMap_)
      ;
      NewColorsUsed is ColorsUsed + 1,
      put_assoc(H2,FreqMap,1,FreqMap_)
  ),
  NewEnd is End + 1,
  append([H1|L1],[H2],WindowColors),
  findNewStart(Start,FreqMap_,WindowColors,NewStart,NewFreqMap,DroppedColors),
  append(DroppedColors,NewWindowColors,WindowColors),
  (
    NewColorsUsed =:= AllColors ->
      NewBestRes is min(BestRes,NewEnd-NewStart+1)
      ;
      NewBestRes is BestRes
  ),
  loop(NewStart,NewEnd,NewWindowColors,L2,NewFreqMap,NewColorsUsed,AllColors,NewBestRes,Answer).

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
  empty_assoc(X),
  loop(0,0,[],C,X,0,K,BestResult,Ans),
  (
    Ans =:= BestResult ->
      Answer is 0
      ;
      Answer is Ans
  ).
