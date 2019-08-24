import java.io.*;
import java.util.*;

public class SaveTheCat {

  public static void main(String args[]){
    char[][] map = new char[1000][1000];
    int N,M;
    ArrayList<WaterState> waterPumps = new ArrayList<WaterState>();
    CatState initial = new CatState(0,0,0,null);

    try {
      File input = new File(args[0]);
      BufferedReader br = new BufferedReader(new FileReader(input));

      String temp;
      int lines = 0;
      while((temp = br.readLine()) != null){
        map[lines] = temp.toCharArray();
        lines++;
      }

      N = lines;
      M = map[0].length;

      for(int i=0;i<N;i++){
        for(int j=0;j<M;j++){
          if(map[i][j]=='W'){
            waterPumps.add(new WaterState(i,j,null));
          }
          if(map[i][j]=='A'){
            initial = new CatState(i,j,0,null);
          }
        }
      }

      int[][] waterTime = flood(map,N,M,waterPumps);

      System.out.println(save(map,N,M,initial,waterTime));
    }
    catch(FileNotFoundException e){}
    catch(IOException e) {}
  }

  public static int[][] flood(char[][] map, int N, int M, ArrayList<WaterState> initialStates){
    int[][] time = new int[N][M];
    Set<WaterState> seen = new HashSet<>();
    Queue<WaterState> remaining = new ArrayDeque<>();

    // initialize time array
    for(int i=0;i<N;i++){
      for(int j=0;j<M;j++){
        time[i][j] = -1;
      }
    }

    for(WaterState w : initialStates){
      remaining.add(w);
      seen.add(w);
      time[w.getX()][w.getY()] = 0;
    }

    while (!remaining.isEmpty()) {
      WaterState s = remaining.remove();

      for (WaterState n : s.next()){
        if (!seen.contains(n) && !n.isBad(map,N,M)){
          remaining.add(n);
          seen.add(n);
          time[n.getX()][n.getY()] = time[s.getX()][s.getY()] + 1;
        }
      }

    }
    return time;
  }

  public static String save(char[][] map, int N, int M, CatState initial, int[][] waterTime){
    Set<CatState> seen = new HashSet<>();
    Queue<CatState> remaining = new ArrayDeque<>();
    CatState result = initial;
    int resultTime = -1;
    boolean catIsSafe = false;

    remaining.add(initial);
    seen.add(initial);

    while (!remaining.isEmpty()) {
      CatState s = remaining.remove();

      // update result
      int i = s.getX(), j = s.getY(), time = s.getTime();
      if(catIsSafe && waterTime[i][j]==-1){
        result = min(result,s);
      }
      else if (waterTime[i][j]==-1){
        catIsSafe = true;
        result = s;
      }
      else if (!catIsSafe && waterTime[i][j] > resultTime){
        resultTime = waterTime[i][j];
        result = s;
      }
      else if (!catIsSafe && waterTime[i][j] == resultTime){
        result = min(result,s);
      }

      // find neighbors
      for (CatState n : s.next()){
        if (!seen.contains(n) && !n.isBad(map,N,M,waterTime)){
          remaining.add(n);
          seen.add(n);
        }
      }
    }

    String timeString;
    if (catIsSafe) {
      timeString = "infinity";
    }
    else {
      timeString = String.valueOf(resultTime-1);
    }

    String path;
    if (result == initial){
      path = "stay";
    }
    else {
      path = findPath(result);
    }

    return timeString + "\n" + path;
  }

  private static CatState min(CatState a, CatState b){
    if (a.getX() > b.getX()) return b;
    if (a.getX() == b.getX() && a.getY() > b.getY()) return b;
    return a;
  }

  private static String findPath(CatState a){
    CatState previous = a.getPrevious();
    CatState current = a;
    ArrayList<Character> result = new ArrayList<Character>();

    while(previous != null){
      result.add(findMove(previous,current));
      current = previous;
      previous = current.getPrevious();
    }

    StringBuilder builder = new StringBuilder();
    for( int i = result.size()-1; i >= 0; i--){
      builder.append(result.get(i));
    }
    return builder.toString();
  }

  private static char findMove(CatState a, CatState b){
    int x1 = a.getX(), y1 = a.getY();
    int x2 = b.getX(), y2 = b.getY();
    if(y1 == y2){
      if (x2 == x1+1){
        return 'D';
      }
      return 'U';
    }
    else {
      if(y2 == y1+1){
        return 'R';
      }
      return 'L';
    }
  }

}
