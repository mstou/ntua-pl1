import java.util.*;

public class ZtallocState {
  private int L, R;
  private int Ltarget, Rtarget;
  private ZtallocState previous;

  public ZtallocState(int Lin, int Rin, int Lout, int Rout, ZtallocState p){
    L = Lin;
    R = Rin;
    Ltarget = Lout;
    Rtarget = Rout;
    previous = p;
  }

  public boolean isFinal(){
    return (L >= Ltarget) && (R <= Rtarget);
  }

  public boolean isBad() {
    return L < 0
      || L > 999999
      || R < 0
      || R > 999999;
  }

  public Collection<ZtallocState> next(){
    Collection<ZtallocState> states = new ArrayList<>();
    states.add(new ZtallocState(L/2,R/2,Ltarget,Rtarget,this));
    states.add(new ZtallocState(3*L+1,3*R+1,Ltarget,Rtarget,this));

    return states;
  }

  public ZtallocState getPrevious(){
    return previous;
  }

  public int getL(){
    return L;
  }

  public int getR(){
    return R;
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
