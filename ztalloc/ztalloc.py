from collections import deque
import sys

inputFile = open(sys.argv[1])
input = inputFile.read().split('\n')[:-1]
N = int(input[0])
parseLine = lambda l: list(map(int,l.split(' ')))
Q = list(map(parseLine,input[1:]))

h = lambda x : x//2
t = lambda x : 3*x+1
valid = lambda x : x >= 0 and x<=MAX_NUM
key = lambda x,y: str(x) + "," + str(y)

MAX_NUM = 999999
father = {}

def findNeighbors(state):
    global visited
    global father

    result = []
    [L,R] = state

    # Check h move
    L1 = h(L)
    R1 = h(R)
    key1 = key(L1,R1)
    if valid(L1) and valid(R1) and key1 not in father:
        father[key1] = ["h",L,R]
        result.append([L1,R1])

    # Check t move
    L2 = t(L)
    R2 = t(R)
    key2 = key(L2,R2)
    if valid(L2) and valid(R2) and key2 not in father:
        father[key2] = ["t",L,R]
        result.append([L2,R2])

    return result

def constructPath(v):
    result = ""
    [x,y] = v
    [move,previousX,previousY] = father[key(x,y)]

    if move == "start":
        return "Empty"

    while True:
        if move == "start":
            return result[::-1]

        result = result + move
        x,y = previousX,previousY
        [move,previousX,previousY] = father[key(x,y)]


def query(Q):
    global visited
    global father
    father = {}

    Lin,Rin,Lout,Rout = Q

    key = str(Lin) + "," + str(Rin)

    father[key] = ["start",-73,-73]

    if Lin >= Lout and Rin <= Rout:
        return "EMPTY"

    Q = deque([[Lin,Rin]])

    # Run BFS
    while(len(Q)!=0):
        front = Q.popleft()
        neighbors = findNeighbors(front)

        for v in neighbors:
            [L,R] = v
            if L >= Lout and R <= Rout:
                return constructPath(v)
            Q.append(v)

    return "IMPOSSIBLE"


for q in Q:
    print(query(q),end='\n')
