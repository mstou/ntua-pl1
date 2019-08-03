/*
  The Solver Interface was written in class
  https://courses.softlab.ntua.gr/pl1/2019a/Labs/goat.tgz
*/


/* A generic interface for a solver that explores a state space,
 * starting from some initial space, aiming to reach some desired
 * final state.
 */
public interface Solver {
  // Returns the solution or null if there is none.
  public State solve (State initial);
}
