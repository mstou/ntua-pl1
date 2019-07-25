from collections import deque
import sys

inputFile = open(sys.argv[1])
input = inputFile.read().split('\n')[:-1]
N = int(input[0])
parseLine = lambda l: list(map(int,l.split(' ')))
Q = list(map(parseLine,input[1:]))
