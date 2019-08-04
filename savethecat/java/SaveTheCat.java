import java.io.*;

public class SaveTheCat {

  public static void main(String args[]){
    char[][] map = new char[1000][1000];
    int N,M;

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
    }
    catch(FileNotFoundException e){}
    catch(IOException e) {}
  }
}
