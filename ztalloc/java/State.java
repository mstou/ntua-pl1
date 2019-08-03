/*
  The State Interface was written in class
  https://courses.softlab.ntua.gr/pl1/2019a/Labs/goat.tgz
*/

import java.util.Collection;

/* A generic interface for a problem state that will be used by solvers.
 */
public interface State {
  // Returns whether the state is final, i.e. the goal of the search.
  public boolean isFinal();
  // Returns whether the state is illegal and should not be explored.
  public boolean isBad();
  // Returns a collection of the states that can be reached by making
  // all possible moves.  Some of these states may be bad.
  public Collection<State> next();
  // Returns the previous state, i.e. the one that led to this one.
  public State getPrevious();

  // Note #1: If states are to be placed in containers that will be
  // searched, they must implement equality --- they must override
  // method Object.equals.

  // Note #2: If states are to be placed in containers implemented as
  // hash tables (e.g. HashSet), they must implement a valid hash
  // function --- they must override method Object.hashCode.
}
