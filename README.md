# Programming Languages I, ECE NTUA

In this course we explore and compare the different types of programming:

* Functional (Standard ML)
* Logical (Prolog)
* Imperative (C++, Python, Java)
* Object Oriented (Java)
* Scripting (Python)

As a lab assignment we are given 4 algorithmic problems to be solved with various languages, so we can compare the different programming styles.

## Problems

### Colors

[Definition in Greek](exerc19-1.pdf)

We are given K colors (integers from 1 to K) and an array of N colors. We must find the smallest continuous subarray that contains all the K colors.

This is a simple problem with 2 pointers : We keep 2 pointers
`start` and `end` that denote the start and end indexes of the
subarray we are examining. In each iteration we increment `end`
(we test all the ending positions) and we also check if the
`start` pointer can be moved without disgarding any colors. We
also keep track of all colors present in our subarray with a
frequency table. If all colors are present we compare the
subarray's length with our best answer so far.

This problem is solved in [Standard ML](colors/colors.sml),
[Prolog](colors/colors.pl) and [C++](colors/colors.cpp)

[Public Testcases](colors/testcases)

### Save the cat!

[Definition in Greek](exerc19-2.pdf)

We are given a 2D map with some broken water pumps (`W`), some
obstacles (`X`) and a cat (`A`). As time passed by, water from
the flooded cells floods neighboring cells! We must navigate the
cat to the cell that floods as late as possible.

We first calculate how much time it takes water to flood each
cell. To achieve this, we run a BFS algorithm with our initial
queue containing all the broken water pumps. Then we run a BFS
algorithm from the cat's position and search for a cell that
floods as late as possible and is accessible by the cat.

This problem is solved in [Standard ML](savethecat/savethecat.sml), [C++](savethecat/savethecat.cpp), [Python](savethecat/savethecat.py) and [Java](savethecat/java)

[Public testcases](savethecat/testcases)
