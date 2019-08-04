import java.util.*;

public class CatState {
  private int i,j;
  private CatState previous;
  private int time;

  public CatState(int i, int j, int time, CatState previous){
    this.i = i;
    this.j = j;
    this.time = time;
    this.previous = previous;
  }

  public boolean isBad(char[][] map, int N, int M, int[][] waterTime){
    return i < 0
      || i >= N
      || j < 0
      || j >= M
      || map[i][j] == 'X'
      || (waterTime[i][j] != -1 && time >= waterTime[i][j]);
  }

  public Collection<CatState> next(){
    Collection<CatState> states = new ArrayList<>();
    states.add(new CatState(i+1,j,time+1,this));
    states.add(new CatState(i,j-1,time+1,this));
    states.add(new CatState(i,j+1,time+1,this));
    states.add(new CatState(i-1,j,time+1,this));
    return states;
  }

  public int getX(){
    return i;
  }

  public int getY(){
    return j;
  }

  public int getTime(){
    return time;
  }

  public CatState getPrevious(){
    return previous;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    CatState other = (CatState) o;
    return i == other.i && j == other.j;
  }

  @Override
  public int hashCode(){
    return Objects.hash(i,j);
  }
}
