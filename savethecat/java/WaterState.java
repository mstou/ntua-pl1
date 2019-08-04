import java.util.*;

public class WaterState {
  private int i,j;
  private WaterState previous;

  public WaterState(int i, int j, WaterState previous){
    this.i = i;
    this.j = j;
    this.previous = previous;
  }

  public boolean isFinal(){
    return false; // we want to explore the whole map
  }

  public boolean isBad(char[][] map, int N, int M){
    return i<0
      || i>=N
      || j<0
      || j>=M
      || map[i][j]=='X';
  }

  public Collection<WaterState> next(){
    Collection<WaterState> states = new ArrayList<>();
    states.add(new WaterState(i+1,j,this));
    states.add(new WaterState(i,j-1,this));
    states.add(new WaterState(i,j+1,this));
    states.add(new WaterState(i-1,j,this));
    return states;
  }

  public int getX(){
    return i;
  }

  public int getY(){
    return j;
  }

  public WaterState getPrevious(){
    return previous;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    WaterState other = (WaterState) o;
    return i == other.i && j == other.j;
  }

  @Override
  public int hashCode(){
    return Objects.hash(i,j);
  }
}
