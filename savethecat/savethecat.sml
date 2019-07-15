(* The function 'parse' is based on the one publicly available here:
https://courses.softlab.ntua.gr/pl1/2013a/Exercises/countries.sml *)

fun parse file =
    let
  	    (* Open input file. *)
      	val inStream = TextIO.openIn file

        (* Reads lines until EOF and puts them in a list as char lists *)
        fun readLines acc =
          let
            val newLineOption = TextIO.inputLine inStream
          in
            if newLineOption = NONE
            then (rev acc)
            else ( readLines ( explode (valOf newLineOption ) :: acc ))
        end;

        val plane = readLines []
        val M = length (hd plane) - 1
        val N = length plane
    in
   	    (N,M,plane)
end;

fun tupleCompare ((x1,y1), (x2,y2)) =
  let
    val firstComp = Int.compare (x1,x2)
    val secondComp = Int.compare (y1,y2)
  in
    if (firstComp = EQUAL)
    then secondComp
    else firstComp
  end;

fun min (x1,y1) (x2,y2) =
  if x1<x2
  then (x1,y1)
  else if (x1 = x2 andalso y1<y2)
  then (x1,y1)
  else (x2,y2)


structure S = BinaryMapFn(
  struct
    type ord_key = int * int
    val compare = tupleCompare
  end
)

fun insertList t l row =
  let
    fun insertList_ t [] _ = t
      | insertList_ t [_] _ = t
      | insertList_ t (x::xs) i = insertList_ (S.insert (t,(row,i),x)) xs (i+1)
  in
    insertList_ t l 0
end;

fun insert2DList t p =
  let
    fun insert2DList_ t [] _ = t
      | insert2DList_ t (x::xs) i = insert2DList_ (insertList t x i) xs (i+1)
  in
    insert2DList_ t p 0
  end;

fun findNeighbors t (x,y) N M visited =
  let
    val down = (x+1,y)
    val left = (x,y-1)
    val right = (x,y+1)
    val up = (x-1,y)

    val result1 =
    if ( (#1 up) >= 0 ) andalso ((valOf (S.find (t,up))) <> #"X")  andalso (S.find(visited,up) = NONE)
    then [up]
    else []

    val result2 =
    if ( (#2 right) < M ) andalso ((valOf (S.find (t,right))) <> #"X") andalso (S.find(visited,right) = NONE)
    then right::result1
    else result1

    val result3 =
    if ( (#2 left) >= 0 ) andalso ((valOf (S.find (t,left))) <> #"X") andalso (S.find(visited,left) = NONE)
    then left::result2
    else result2

    val result4 =
    if ( (#1 down) < N ) andalso ((valOf (S.find (t,down))) <> #"X") andalso (S.find(visited,down) = NONE)
    then down::result3
    else result3
  in
    result4
end;

fun insertListInFifo [] value q = 1
  | insertListInFifo (x::xs) value q  =
    let
      val unused = Queue.enqueue(q,(x,value))
    in
      insertListInFifo xs value q
    end;

fun insertListinTree [] t _ = t
    | insertListinTree (x::xs) t v = insertListinTree xs (S.insert (t,x,v)) v


fun bfs t N M startingPoints =
  let
    val q = Queue.mkQueue(): ((int * int) * int) Queue.queue
    val unused = insertListInFifo startingPoints 0 q
    val resultTree = insertListinTree startingPoints S.empty (0,(~1,~1))

    fun bfsLoop tree true = tree
      | bfsLoop tree isQueueEmpty =
        let
          val NodeAndTime = Queue.dequeue(q)
          val currentNode = (#1 NodeAndTime)
          val time = (#2 NodeAndTime)
          val neighbors = findNeighbors t currentNode N M tree
          val unused2 = insertListInFifo neighbors (time+1) q
          val newResultTree = insertListinTree neighbors tree (time+1,currentNode)

        in
          bfsLoop newResultTree  (Queue.isEmpty (q))
    end;

  in
    bfsLoop resultTree  (Queue.isEmpty (q))
  end;


fun CatBFS t N M cat (waterTree: (int * (int * int)) S.map) =
  let
    val q = Queue.mkQueue(): ((int * int) * int) Queue.queue
    val unused = Queue.enqueue(q,(cat,0))

    val initialTree = S.insert(S.empty,cat,(0,(~1,~1)))

    fun updateResult (finalPos,time) catTime waterTime (i,j) =
      if (waterTime = NONE) andalso (time = ~1) (*cat is safe => time = -1*)
      then ((min finalPos (i,j)),~1)

      else if waterTime = NONE
      then ((i,j),~1)

      else if (waterTime <> NONE) andalso (time = ~1)
      then (finalPos,time)

      else if ((valOf waterTime) <= (valOf catTime))
      then (finalPos,time)

      else if ((valOf waterTime) > time)
      then ((i,j),valOf waterTime)

      else if ((valOf waterTime) = time)
      then ((min finalPos (i,j)),time)

      else (finalPos,time)


    fun bfsLoop tree true result = (tree,result)
      | bfsLoop tree isQueueEmpty result =
        let
          val NodeAndTime = Queue.dequeue(q)
          val currentNode = (#1 NodeAndTime)
          val time = (#2 NodeAndTime)

          val waterCell = S.find (waterTree,currentNode)
          val waterTime =
          if waterCell = NONE
          then NONE
          else SOME ((#1(valOf waterCell)))

          val notContinuing = waterTime <> NONE andalso (valOf waterTime) <= time


          val neighbors =
          if notContinuing
          then []
          else findNeighbors t currentNode N M tree

          val unused2 =
          if notContinuing
          then 73
          else insertListInFifo neighbors (time+1) q

          val newTree =
          if notContinuing
          then tree
          else insertListinTree neighbors tree (time+1,currentNode)

          val newResult = updateResult result (SOME time) waterTime currentNode

        in
          bfsLoop newTree (Queue.isEmpty (q)) newResult
    end;

  in
    bfsLoop initialTree  (Queue.isEmpty (q)) ((N,M),~2)
  end;

fun findMove (x1,y1) (x2,y2) =
  case (x2-x1) of
    1 => "D"
  | ~1  => "U"
  |  0  => case (y2-y1) of
              1 => "R"
            | ~1 => "L"

fun getPath node (catTree: (int * (int * int)) S.map) acc =
    let
      val father = #2 (valOf (S.find (catTree, node)))
    in
      if father = (~1,~1)
      then acc
      else  getPath father catTree ( (valOf (Char.fromString(findMove father node))) :: acc )
end;

fun findWatersAndCat map N M =
  let
    fun loop ~1 ~1 acc = acc
      | loop i j (cat,waterPumps) =
        let
          val cellValue = valOf (S.find (map, (i,j)))

          val newCat =
            if cellValue = #"A"
            then (i,j)
            else cat

          val newWaterPumps =
            if cellValue = #"W"
            then ((i,j) :: waterPumps)
            else  waterPumps

          val nextIter =
            if j = M-1 andalso i <> N-1
            then (i+1,0)
            else if j = M-1 andalso i = N-1
            then (~1,~1)
            else (i,j+1)
        in
          loop (#1 nextIter) (#2 nextIter) (newCat,newWaterPumps)
        end;
  in
    loop 0 0 ((~1,~1),[])
  end;


fun  savethecat file =
  let
    val out = parse file;
    val tree = insert2DList (S.empty) (#3 out)
    val N = #1 out;
    val M = #2 out;

    val points = findWatersAndCat tree N M;
    val catPos = #1 points;
    val waterPos = #2 points;

    val waterTree = bfs tree N M waterPos;
    val (catTree,result) = CatBFS tree N M catPos waterTree;

    (* val result = findResult catTree waterTree N M; *)
    val node = #1 result
    val time = #2 result

    val path = getPath node catTree []

    val pathInString =
      if path = []
      then "stay"
      else implode path

    val timeInString =
      if time = ~1
      then "infinity"
      else Int.toString(time-1)
  in
    print (timeInString ^ "\n" ^ pathInString ^ "\n")
  end;
