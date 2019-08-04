import java.io.*;
import java.util.*;

public class SaveTheCat {

  public static void main(String args[]){
    char[][] map = new char[1000][1000];
    int N,M;
    ArrayList<WaterState> waterPumps = new ArrayList<WaterState>();

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
        }
      }

      int[][] waterTime = flood(map,N,M,waterPumps);

    }
    catch(FileNotFoundException e){}
    catch(IOException e) {}
  }

  public static int[][] flood(char[][] map, int N, int M, ArrayList<WaterState> initialStates){
    int[][] time = new int[N][M];
    Set<WaterState> seen = new HashSet<>();
    Queue<WaterState> remaining = new ArrayDeque<>();

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
}
