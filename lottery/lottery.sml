(* The function 'parse' is based on the one publicly available here:
https://courses.softlab.ntua.gr/pl1/2013a/Exercises/countries.sml *)

fun parse file =
    let
  	    (* A function to read an integer from specified input. *)
        fun readInt input =
  	     Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

  	    (* Open input file. *)
      	val inStream = TextIO.openIn file

        (* Read K,N,Q and consume newline. *)
  	    val k = readInt inStream
        val n = readInt inStream
        val q = readInt inStream
        val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
      	fun readLines 0 acc = rev acc
      	  | readLines i acc =
                  readLines
                    (i - 1)
                    (explode (valOf (TextIO.inputLine inStream)) :: acc)

        (*Takes a list of lists of chars and returns a list of lists of integers*)
        fun charListToIntList l =
            map
              (fn x => foldl     (* we use foldl to also reverse the tickets *)
                        (fn (c,acc) =>
                            if c = #"\n"
                            then acc
                            else (Char.ord c - Char.ord #"0") :: acc)
                        []
                        x
              )
              l
        val tickets = charListToIntList (readLines n [])
        val querries = charListToIntList ( readLines q [])

    in
   	    (k, n, q, tickets, querries)
end;

(* === Helping functions === *)
val p = 1000000007;

(* computes a ^ n mod p. The result should fit in an int *)
fun pow a n =
  Int.fromLarge (IntInf.pow(a,n) mod (Int.toLarge p))
(* ========================= *)

structure S = BinaryMapFn(
  struct
    type ord_key = int
    val compare = Int.compare
  end
);

datatype trie = empty | node of int * ( (int*trie) S.map ) * int
(* node ( nodeValue, childrenMap, ticketsHanging ) *)
(* childrenMap:  childrenValue => (ticketsHanging, trie) *)

val root = node(~1,S.empty,0);

(* insert a ticket (given as a list of ints) in the trie t *)
fun insert t [] = t
  | insert empty (x::[]) = node (x,S.empty,1)
  | insert empty (x1::x2::xs) =
    let
      val kid = insert empty (x2::xs)
      val kidMap = S.insert(S.empty,x2,(1,kid))
    in
      node (x1,kidMap,1)
    end
  | insert (node (a, s, n)) (x::xs)=
    let
        val findChild = S.find(s,x);

        val nodesChild =
          if (isSome findChild)
          then #1(valOf findChild)
          else 0

        val childTree =
          if (isSome findChild)
          then #2(valOf findChild)
          else empty

        val newChild =
          if (isSome findChild)
          then insert childTree xs
          else insert childTree (x::xs)

        val newMap = S.insert(s,x,(nodesChild+1,newChild))
    in
      node (a, newMap, n+1)
    end;

(* insert a list of tickets in a trie *)
fun insertTickets t l =
  foldl
    (fn (x,acc) => insert acc x)
    t
    l

(* A function to get the ChildMap of a trie node *)
fun extractMap empty = S.empty
  | extractMap (node(_,s,_)) = s

(* returns the sub-trie with root value x and the amount of tickets hanging*)
fun findChild empty _ = (0,empty)
  | findChild (node(_,s,_)) x =
    let
      val child = S.find(s,x);
    in
      if isSome child
      then valOf child
      else (0,empty)
    end

(* query the trie for a winning ticket *)
(* return the number of tickets winning & the total amount *)

fun query empty _ _ = (0,0)
  | query (node(_,_,n)) [] m =
    let
      val term1 = Int.toLarge((pow 2 m) - 1)
      val term2 = Int.toLarge(n)
      val termMod = (term1 * term2) mod (Int.toLarge p)
    in
      (n,Int.fromLarge termMod)
    end
  | query (node(currNode,s,n)) (x::xs) m =
    let
      val child = S.find(s,x)

      val childQuerry =
        if isSome child
        then (query (#2 (valOf child)) xs (m+1))
        else (0,0)

      val remainingTickets = (n - (#1 childQuerry))
      val remLarge = Int.toLarge(remainingTickets) * Int.toLarge((pow 2 m) - 1)
      val remModulo = remLarge mod (Int.toLarge p)
      val allMoneyLarge = (remModulo + Int.toLarge(#2 childQuerry)) mod (Int.toLarge p)

      val money =
        Int.fromLarge(allMoneyLarge)

      val returningTickets =
        if m = 0 (*if we are at trie's root*)
        then #1 (childQuerry)
        else n
    in
      (returningTickets,money)
    end

fun calculateQuerries t q =
  map (fn x => query t x 0) q

fun lottery file =
  let
    val a = parse file;
    val k = #1 a;
    val n = #2 a;
    val q = #3 a;
    val tickets = #4 a;
    val querries = #5 a;

    val fullTrie = insertTickets root tickets;
    val results = calculateQuerries fullTrie querries;

  in
    map
      (fn x =>
          let
            val resString = Int.toString(#1 x) ^ " " ^ Int.toString(#2 x) ^ "\n";
          in
            print resString;
            x
          end
      )
      results
  end;

  (* fun parseOutputFile file numOfLines =
      let
          fun readInt input =
    	     Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

        	val inStream = TextIO.openIn file

        	fun readInts 0 acc = rev acc
        	  | readInts i acc =
              readInts
                (i - 1)
                ( ((readInt inStream),(readInt inStream)) :: acc )
      in
     	    readInts numOfLines []
  end;

  fun runTestcase n =
    let
      val inputFile = "testcases/lottery.in" ^ Int.toString(n)
      val outputFile = "testcases/lottery.out" ^ Int.toString(n)

      val numberOfQuerries = #3 (parse inputFile)

      val producedResult = lottery inputFile
      val expectedResult = parseOutputFile outputFile numberOfQuerries
    in
      producedResult = expectedResult
    end;

val testcases = [1,2,3,6,8,11,14,20,23]

val passedAllTestcases =
  foldl
    (fn (t,acc) =>
      let
        val bestNumber = 73;
      in
        print ("Running testcase " ^ Int.toString(t) ^ "...\n");
        if acc then (runTestcase t) else false
      end
    )
    true
    testcases; *)
