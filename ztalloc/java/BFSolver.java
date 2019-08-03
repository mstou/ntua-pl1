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

public class BFSolver implements Solver {
  @Override
  public State solve (State initial) {
    Set<State> seen = new HashSet<>();
    Queue<State> remaining = new ArrayDeque<>();
    remaining.add(initial);
    seen.add(initial);

    while (!remaining.isEmpty()) {
      State s = remaining.remove();
      if (s.isFinal()) return s;

      for (State n : s.next())
        if (!seen.contains(n) && !n.isBad()){
          if (n.isFinal()) return n;          
          remaining.add(n);
          seen.add(n);
        }
    }
    return null;
  }
}
