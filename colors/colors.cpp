#include <iostream>
#include <fstream>

#define MAX_N 1000005
#define MAX_K 100005

using namespace std;

int a[MAX_N];
int colorsInWindow[MAX_K];
int colorsUsed;
int N,K;

inline int min(int x, int y){ return (x<y) ? x:y; }

int main(int argc, char *argv[]){
  ifstream inputFile;
  inputFile.open(argv[1]);

  inputFile >> N >> K;
  for(int i=0; i<N; i++) {
    inputFile >> a[i];
    colorsUsed = colorsUsed + (int) (colorsInWindow[a[i]] == 0);
    colorsInWindow[a[i]]++;
  }

  if( colorsUsed != K ) {
    cout<<"0\n";
  }
  else {
    int start = 0, end = 0;
    colorsUsed = 0;
    int result = N;

    for(int i=1;i<=K;i++) colorsInWindow[i]=0;

    for( end=0; end<N; end++){
      if(colorsInWindow[a[end]] == 0) {
        colorsUsed++;
      }

      colorsInWindow[a[end]]++;

      while(colorsInWindow[a[start]] > 1){
        colorsInWindow[a[start]]--;
        start++;
      }

      if(colorsUsed==K){
        result = min(result,end-start+1);
      }
    }

    cout<<result<<endl;

  }
}
