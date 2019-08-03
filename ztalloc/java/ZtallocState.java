import java.util.*;

public class ZtallocState implements State {
  private int L, R;
  private int Ltarget, Rtarget;
  private ZtallocState previous;

  public ZtallocState(int Lin, int Rin, int Lout, int Rout, ZtallocState p){
    L = LeftLimit;
    R = RightLimit;
    Ltarget = Lout;
    Rtarget = Rout;
    previous = p;
  }

  @Override
  public boolean isFinal(){
    return (L >= Ltarget) && (R <= Rtarget);
  }

  @Override
  public boolean isBad() {
    return L < 0
      || L > 999999
      || R < 0
      || R > 999999;
  }

  @Override
  public Collection<State> next(){
    Collection<State> states = new ArrayList<>();
    states.add(new ZtallocState(L/2,R/2,this));
    states.add(new ZtallocState(3*L+1,3*R+1,this));

    return states;
  }

  @Override
  public State getPrevious(){
    return previous;
  }

  // Two states are equal if their ends are the same
  @Override
  public boolean equals(Object o){
    if (this == o) return true;
    if(o == null || getClass() != o.getClass()) return false;

    ZtallocState other = (ZtallocState) o;
    return other.L == L && other.R == R;
  }

  // Hashing: consider only the interval ends
  @Override
  public int hashCode() {
    return Objects.hash(L,R);
  }

}
