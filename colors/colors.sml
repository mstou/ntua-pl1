
(* The function 'parse' is based on the one publicly available here:
https://courses.softlab.ntua.gr/pl1/2013a/Exercises/countries.sml *)

fun parse file =
    let
  	    (* A function to read an integer from specified input. *)
        fun readInt input =
  	     Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

  	    (* Open input file. *)
      	val inStream = TextIO.openIn file

        (* Read N,K and consume newline. *)
  	    val n = readInt inStream
        val k = readInt inStream
        val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
      	fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
      	  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	    (n, k, readInts n [])
end;

fun first (x,_,_) = x
fun firstFrom2 (x,_) = x

fun second (_,x,_) = x
fun secondFrom2 (_,x) = x

fun third (_,_,x) = x

fun min x y =
  if x < y
  then x
  else y

structure S = BinaryMapFn(
  struct
    type ord_key = int
    val compare = Int.compare
  end
);


fun insertList t l =
  let
    fun insertList_ t [] _ = t
      | insertList_ t (x::xs) i = insertList_ (S.insert (t,i,x)) xs (i+1)
  in
    insertList_ t l 0
end;

fun removeFromStart (s,colorsInWindow,t) =
  let
    val startColor = valOf (S.find (t,s))
    val startColorFreq = valOf (S.find (colorsInWindow,startColor))

    val newColorsWindow =
      if startColorFreq > 1
      then (S.insert (colorsInWindow,startColor,startColorFreq-1))
      else colorsInWindow

    val newStart =
      if startColorFreq > 1
      then (s+1)
      else s
  in
    if newStart = s
    then (newStart,newColorsWindow)
    else removeFromStart (newStart,newColorsWindow,t)
end;

fun incrementEnd (e,colorsUsed,colorsInWindow,t) =
  let
    val endColor = valOf (S.find (t,e))
    val endColorFreq = S.find (colorsInWindow,endColor) (* returns option *)
    val newColorsUsed =
      if endColorFreq = NONE
      then (colorsUsed+1)
      else (colorsUsed)

    val newColorsWin =
      if endColorFreq = NONE
      then (S.insert (colorsInWindow,endColor,1))
      else (S.insert (colorsInWindow,endColor,(valOf (endColorFreq))+1))
  in
    (e+1,newColorsUsed,newColorsWin)
end;

fun solve n k l =
  let
    val colorsInTree = insertList (S.empty) l

    fun innerSolve (s,e,colorsUsed,colorsInWindow,t,currResult) =
      let
        val outputTuple1 = incrementEnd(e,colorsUsed,colorsInWindow,t)

        val newEnd = first outputTuple1
        val newColorsUsed = second outputTuple1
        val colorsInWindow1 = third outputTuple1

        val outputTuple2 = removeFromStart(s,colorsInWindow1,t)
        val newStart = firstFrom2 outputTuple2
        val newColorsWindow = secondFrom2 outputTuple2

        val newResult =
          if newColorsUsed = k
          then (min currResult (e-s+1))
          else currResult
      in
        if newEnd = n
        then newResult
        else innerSolve(newStart,newEnd,newColorsUsed,newColorsWindow,t,newResult)
      end;

    val result =  innerSolve (0,0,0,S.empty,colorsInTree,n+1)
  in
    if result = n+1
    then 0
    else result
end;

fun colors inputFile =
  let
    val inputTuple = parse inputFile;
    val n = first inputTuple
    val k = second inputTuple
    val colorsInList = third inputTuple
    val result = solve n k colorsInList;
  in
    print(Int.toString(result) ^ "\n")
end;
