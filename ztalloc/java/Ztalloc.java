import java.util.*;
import java.io.*;

public class Ztalloc {

  public static void main(String args[]) {
    try {
      Scanner scanner = new Scanner(new File(args[0]));
      int N = scanner.nextInt();

      for(int i = 0; i < N; i++ ){
        int Lin = scanner.nextInt();
        int Rin = scanner.nextInt();
        int Lout = scanner.nextInt();
        int Rout = scanner.nextInt();

        BFSolver solver = new BFSolver();
        ZtallocState initial = new ZtallocState(Lin,Rin,Lout,Rout,null);
        ZtallocState result = solver.solve(initial);

        if(result == initial){
          System.out.println("EMPTY");
        } else if (result == null){
          System.out.println("IMPOSSIBLE");
        } else {
          System.out.println(getSolution(result));
        }
      }
    }
    catch (FileNotFoundException e){
      System.out.println("Please provide an input file.");
    }
  }

  private static String getSolution(ZtallocState s){
    ZtallocState previous = s.getPrevious();
    ZtallocState current = s;
    ArrayList<Character> result = new ArrayList<Character>();

    while(previous != null){
      Character move;
      if(current.getL() == previous.getL()/2) {
        move = 'h';
      } else {
        move = 't';
      }

      result.add(move);
      current = previous;
      previous = current.getPrevious();
    }

    StringBuilder builder = new StringBuilder();
    for( int i = result.size()-1; i >= 0; i--){
      builder.append(result.get(i));
    }
    return builder.toString();
  }

}
