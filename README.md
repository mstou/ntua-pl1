# Programming Languages I

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

[Definition in Greek](exerc19-1.pdf)

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

### Lottery

[Definition in Greek](exerc19-2.pdf)

We are given `N` lottery tickets that were bought from people,
where each ticket is a number `X` with `K` digits. For the `N`
tickets that are bought we have to answer `Q` querries. Each
querry is a winning lottery ticket `Y` and we have to calculate
the total amount of money won by all the people. Every
ticket `X` that has its `M` last digits same with `Y` wins `2^M -
1`.

To solve this problem efficiently, we construct a custom __trie__ where we hang all the `N` tickets bought and in each node we also keep track of the number of tickets hanging from it. To calculate each querry we just have to make a simple trie traversal.

This problem is solved in [Standard ML](lottery/lottery.sml) and [Prolog](lottery/lottery.pl)

[Public testcases](lottery/testcases)

### Ztalloc

We suppose there exists a computer with 6-digit registers (it can only store numbers between 0 and 999999) that is capable of performing only 2 calculations:

* `h` : `x -> x // 2`
* `t` : `x -> 3 * x + 1`

For every querry in the form of `Lin, Rin, Lout, Rout` we have to output a sequence of calculations with which every number in the interval `[Lin, Rin]` is mapped to `[Lout, Rout]`.


We notice that both calculations (functions) are monotonic (and in fact strictly increasing). This means that the interval `[L, R]` will always be mapped exaclty to `[L/2, R/2]` through `h`. The same holds for `t` (`[L, R]` -> `[3*L+1, 3*R+1]`).

So we declare a state `[A,B]` and we perform a BFS traversal of all states starting from `[Lin,Rin]`, to find the smallest path from `[Lin,Rin]` to `[Lout,Rout]`. It is guaranteed that we will have to visited at most ~10^6 states.

This problem is solved in [Prolog](ztalloc/ztalloc.pl), [Python](ztalloc/ztalloc.py) and [Java](ztalloc/java).

[Public testcases](ztalloc/testcases)
