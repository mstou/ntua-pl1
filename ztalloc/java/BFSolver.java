import java.util.*;

/*
  The BFSolver Class was written in class
  https://courses.softlab.ntua.gr/pl1/2019a/Labs/goat.tgz
*/

/* A class that implements a solver that explores the search space
 * using breadth-first search (BFS).  This leads to a solution that
 * is optimal in the number of moves from the initial to the final
 * state.
 */

public class BFSolver {

  public ZtallocState solve (ZtallocState initial) {
    Set<ZtallocState> seen = new HashSet<>();
    Queue<ZtallocState> remaining = new ArrayDeque<>();
    remaining.add(initial);
    seen.add(initial);

    while (!remaining.isEmpty()) {
      ZtallocState s = remaining.remove();
      if (s.isFinal()) return s;

      for (ZtallocState n : s.next())
        if (!seen.contains(n) && !n.isBad()){
          if (n.isFinal()) return n;
          remaining.add(n);
          seen.add(n);
        }
    }
    return null;
  }
}
