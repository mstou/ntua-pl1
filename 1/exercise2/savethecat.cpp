#include <iostream>
#include <fstream>
#include <vector>
#include <cstdio>
#include <queue>
#include <algorithm>

#define MAX_N 1005
#define MAX_M 1005

using namespace std;

string map[MAX_N];
int flooded[MAX_N][MAX_M];//flooded[i][j] = time in which [i,j] will be flooded
int catMoves[MAX_N][MAX_M]; //catMoves[i][j] = time in which the cat can reach [i,j]
vector< pair<int,int> > waterPumps,neighbors;
pair<int,int> father[MAX_N][MAX_M]; // previous coord in cat's shortest path to [i,j]
pair<int,int> cat;
int M,N;

bool operator > (pair<int,int> a, pair<int,int> b){
  if(a.first > b.first) return true;
  if(a.first == b.first && a.second > b.second) return true;
  return false;
}

string findMove(int x1,int y1, int x2, int y2){
  if( y1 == y2 ){
    if(x2==x1+1){
      return "D";
    }
    return "U";
  }
  else{
    if( y2 == y1 + 1){
      return "R";
    }
    return "L";
  }
}

string getPath(pair<int,int> endVertex){
  int currX=endVertex.first,currY=endVertex.second;
  pair<int,int> previous;
  string result;

  while(73){
    previous = father[currX][currY];
    if( previous == make_pair(-1,-1) ) break;
    result = result + findMove(previous.first,previous.second,currX,currY);
    currX = previous.first;
    currY = previous.second;
  }

  reverse(result.begin(),result.end());
  sort(result.begin(),result.end());

  return result;
}

vector< pair<int,int> > findNeighbors(pair<int,int> u){
  vector< pair<int,int> > result;
  int x = u.first, y = u.second;

  if(x-1 >= 0 && map[x-1][y] != 'X'){ // U
    result.push_back(make_pair(x-1,y));
  }

  if(x+1 <= N-1 && map[x+1][y] != 'X'){ // D
    result.push_back(make_pair(x+1,y));
  }

  if(y-1 >= 0 && map[x][y-1] != 'X'){ // L
    result.push_back(make_pair(x,y-1));
  }

  if(y+1 <= M-1 && map[x][y+1] != 'X'){ // R
    result.push_back(make_pair(x,y+1));
  }

  return result;
}


int main(int argc, char *argv[]) {

  ifstream inputFile;
  inputFile.open(argv[1]);

  int lines=0;
  while(getline(inputFile,map[lines++]));
  lines--;

  N = lines;
  M = map[0].size();

  for(int i=0; i<N; i++){
    for(int j=0; j<M; j++){
      if(map[i][j]=='W'){
        waterPumps.push_back(make_pair(i,j));
      }
      else if(map[i][j]=='A'){
        cat.first = i;
        cat.second = j;
      }
    }
  }

  // init flooded matrix
  for(int i=0; i<N; i++){
    for(int j=0; j<M; j++){
      flooded[i][j]=-1;
      catMoves[i][j]=-1;
    }
  }

  // bfs from water pumps

  queue< pair<int,int> > q;
  for( int i=0; i<waterPumps.size(); i++){
    q.push(waterPumps[i]);
    flooded[waterPumps[i].first][waterPumps[i].second] = 0;
  }

  while(!q.empty()){
    pair<int,int> v = q.front();
    q.pop();

    neighbors = findNeighbors(v);

    for(int i=0; i<neighbors.size(); i++){
      int x = neighbors[i].first, y = neighbors[i].second;
      if(flooded[x][y] == -1){
        flooded[x][y] = flooded[v.first][v.second] + 1;
        q.push(neighbors[i]);
      }
    }
  }

  // BFS for cat moves - save distances and fathers
  q.push(cat);
  catMoves[cat.first][cat.second] = 0;
  father[cat.first][cat.second] = make_pair(-1,-1);

  while(!q.empty()){
    pair<int,int> v = q.front();
    q.pop();

    neighbors = findNeighbors(v);
    for(int i=0; i<neighbors.size(); i++){
      int x = neighbors[i].first, y = neighbors[i].second;
      if(catMoves[x][y]==-1){
        catMoves[x][y] = catMoves[v.first][v.second] + 1;
        q.push(neighbors[i]);
        father[x][y] = v;
      }
    }
  }

  pair<int,int> finalPosition = make_pair(N,M);
  int time=-1;
  bool catIsSafe = false;

  for(int i=0;i<N;i++){
    for(int j=0;j<M;j++){
      if(catMoves[i][j]==-1) continue;

      if(flooded[i][j]==-1 && map[i][j]!='X'){
        catIsSafe = true;
        if(finalPosition > make_pair(i,j)) finalPosition = make_pair(i,j);
      }
      else if(!catIsSafe && flooded[i][j]>=time && catMoves[i][j]<flooded[i][j]){
        if( time < flooded[i][j] || finalPosition > make_pair(i,j) ){
          finalPosition = make_pair(i,j);
          time = flooded[i][j];
        }
      }
    }
  }


  if(catIsSafe){
    cout<<"infinity\n";
  }
  if(finalPosition == cat){
    cout<<"stay\n";
  }
  else{
    string path = getPath(finalPosition);
    if(!catIsSafe) cout<<path.size()<<endl;
    cout<<path<<endl;
  }

  // for(int i=0;i<waterPumps.size();i++){
  //   printf("%d %d\n",waterPumps[i].first,waterPumps[i].second);
  // }


  // for(int i=0;i<N;i++){
  //   for(int j=0;j<M;j++){
  //     printf("%d ",flooded[i][j]);
  //   }
  //   printf("\n");
  // }
  //
  // printf("\nCat moves:\n");
  //
  // for(int i=0;i<N;i++){
  //   for(int j=0;j<M;j++){
  //     printf("%d ",catMoves[i][j]);
  //   }
  //   printf("\n");
  // }

}
