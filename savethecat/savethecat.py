from collections import deque
import sys

inputFile = open(sys.argv[1])
map = inputFile.read().split('\n')[:-1]
N = len(map)
M = len(map[0])

waterPumps = []
flooded = [[-1 for j in range(M)] for i in range(N)]
catMoves = [[-1 for j in range(M)] for i in range(N)]
parent = [[[-1,-1] for j in range(M)] for i in range(N)]


for i in range(N):
    for j in range(M):
        if map[i][j] == 'W':
            waterPumps.append([i,j])
            flooded[i][j] = 0

        elif map[i][j] == 'A':
            cat = [i,j]
            catMoves[i][j] = 0

def findNeighbors(v):
    result = []
    x = v[0]
    y = v[1]

    # D
    if x+1 <= N-1 and map[x+1][y]!='X':
        result.append([x+1,y])

    # L
    if y-1 >= 0 and map[x][y-1]!='X':
        result.append([x,y-1])

    # R
    if y+1 <= M-1 and map[x][y+1]!='X':
        result.append([x,y+1])

    # U
    if x-1 >= 0 and map[x-1][y]!='X':
        result.append([x-1,y])

    return result

def isPositionGreater(a,b):
    # returns a > b
    if a[0] > b[0]:
        return True
    elif a[0] == b[0] and a[1] > b[1]:
        return True
    return False

def findMove(x1,y1,x2,y2):
    if y1==y2:
        if x2==x1+1:
            return "D"
        return "U"
    else:
        if y2==y1+1:
            return "R"
        return "L"

def getPath(finalPos):
    currVertex = finalPos;
    previous = [-1,-1]
    result = []

    while(True):
        previous = parent[currVertex[0]][currVertex[1]]
        if previous == [-1,-1]:
            break
        result.append(findMove(previous[0],previous[1],currVertex[0],currVertex[1]))
        currVertex[0] = previous[0]
        currVertex[1] = previous[1]

    result.reverse()

    return ''.join(result)


def print2DMap(a):
    for i in range(len(a)):
        for j in range(len(a[0])):
            print(a[i][j],end=" ")
        print("")

# Water BFS
Q = deque(waterPumps)

while(len(Q)!=0):
    front = Q.popleft()
    floodingTime = flooded[front[0]][front[1]]
    neighbors = findNeighbors(front)

    for v in neighbors:
        if flooded[v[0]][v[1]] == -1:
            flooded[v[0]][v[1]] = floodingTime + 1
            Q.append(v)

# Cat BFS
Q = deque([cat])

catIsSage = False
time = -1
finalPosition = [N,M]

while(len(Q)!=0):
    u = Q.popleft()
    movingTime = catMoves[u[0]][u[1]]
    neighbors = findNeighbors(u)

    if flooded[u[0]][u[1]]!=-1 and movingTime >= flooded[u[0]][u[1]]:
        continue

    # Update best position:
    i = u[0]
    j = u[1]

    if flooded[i][j]==-1:
        catIsSage=True
        if isPositionGreater(finalPosition,[i,j]):
            finalPosition = [i,j]
    elif (not catIsSage) and (flooded[i][j] >= time) and (movingTime < flooded[i][j]):
        if time < flooded[i][j] or isPositionGreater(finalPosition,[i,j]):
            finalPosition = [i,j]
            time = flooded[i][j]

    # Push neighbors in queue
    for v in neighbors:
        if catMoves[v[0]][v[1]] == -1:
            catMoves[v[0]][v[1]] = movingTime + 1
            parent[v[0]][v[1]] = u
            Q.append(v)

# catIsSage = False
# time = -1
# finalPosition = [N,M]

# Find best position
# for i in range(N):
#     for j in range(M):
#         if catMoves[i][j]==-1:
#             continue
#
#         if flooded[i][j]==-1:
#             catIsSage=True
#             if isPositionGreater(finalPosition,[i,j]):
#                 finalPosition = [i,j]
#         elif (not catIsSage) and (flooded[i][j] >= time) and (catMoves[i][j] < flooded[i][j]):
#             if time < flooded[i][j] or isPositionGreater(finalPosition,[i,j]):
#                 finalPosition = [i,j]
#                 time = flooded[i][j]

if catIsSage:
    print("infinity")
else:
    print(time-1)

if finalPosition == cat:
    print("stay")
else:
    print(getPath(finalPosition))
