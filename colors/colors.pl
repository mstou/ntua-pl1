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

% findNewStart(Start,FreqMap,Colors,NewStart,NewFreqMap,DroppedColors)
findNewStart(Start,FreqMap,[_],NewStart,NewFreqMap,DroppedColors) :-
  NewStart = Start,
  NewFreqMap = FreqMap,
  DroppedColors = [].

findNewStart(Start,FreqMap,[H1|L],NewStart,NewFreqMap,DroppedColors) :-
  get_assoc(H1,FreqMap,HeadFrequency),
  (
    HeadFrequency > 1 ->
      NewFreq is HeadFrequency - 1,
      Start_ is Start + 1,
      put_assoc(H1,FreqMap,NewFreq,FreqMap_),
      findNewStart(Start_,FreqMap_,L,NewStart,NewFreqMap,RestDropped),
      append([H1],RestDropped,DroppedColors)
      ;

      NewStart is Start,
      NewFreqMap = FreqMap,
      DroppedColors = []
  ).

  % findStart test:
  % empty_assoc(X),
  % put_assoc(1,X,4,X1),
  % put_assoc(4,X1,2,X2),
  % put_assoc(3,X2,2,X3),
  % put_assoc(2,X3,1,X4),
  % findNewStart(0,X4,[1,1,1,4,3,1,3,2,4],NewStart,NewFreqMap,DroppedColors).

% loop(Start,End,WindowColors,ColorsAfter,FreqMap,ColorsUsed,K,PreviousBest,BestResult)

% loop(Start,End,[H1|L],[],Freq,ColorsUsed,AllColors,BestRes,Answer) :-
%   findStart(Start,Freq,[H1|L],NewStart,_,_),
%   (
%     ColorsUsed =:= AllColors ->
%       Answer is min(BestRes,End-NewStart+1)
%       ;
%       Answer is BestRes
%   ).

loop(_,_,_,[],_,_,_,BestResult,Answer) :-
  Answer is BestResult,
  !.

loop(_,_,_,[_|_],_,_,1,_,Answer) :-
  Answer is 1.

loop(Start,End,[],[H2|L2],FreqMap,ColorsUsed,AllColors,BestRes,Answer) :-
  NewEnd is End + 1,
  put_assoc(H2,FreqMap,1,NewFreqMap),
  NewColorsUsed is ColorsUsed + 1,
  loop(Start,NewEnd,[H2],L2,NewFreqMap,NewColorsUsed,AllColors,BestRes,Answer).

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

% loop test
% empty_assoc(X),
% loop(0,0,[],[1,3,1,3,1,3,3,2,2,1],X3,0,3,11,Answer).
