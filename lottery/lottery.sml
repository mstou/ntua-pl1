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
              (fn x => foldr
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

(* A function to get the ChildMap of a trie node *)
fun extractMap empty = S.empty
  | extractMap (node(_,s,_)) = s


val a = parse "testcases/lottery.in2";
