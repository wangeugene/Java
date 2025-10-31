[course](https://www.coursera.org/learn/algorithms-divide-conquer/lecture/NtFU9/merge-sort-pseudocode)

# Reasons to learn it

It was invented in the 1940s, still a relatively efficient sorting algorithm by now.
Other simple sorting algorithms (selection/insertion/bubble), Big Notation Complexity is quadratic, not efficient.

### Characteristics

N elements of an array to sort:
It's a concept of divide & conquer.
It uses two parallel recursions of two sub sorting methods.
Efficiency: logarithm of n roughly.
Rough running time of Merge <= 6n*log2(n) + 6n = 6n*(log2(n)+1) = work per level * count of levels (the recursion tree)
operations to sort n numbers.
It can be depicted using a recursion tree, which is a binary tree.

### Pseudocode for Merge

~~~text
C = output array [length = n]
A = 1st sorted array [length = n/2] ; index i = 1
B = 2nd sorted array [length = n/2] ; index j = 1
for k= 1 to n 
    if A(i) < B(j)
        C(k) = A(i)
        i++
    else if B(j) < A(i)
        C(k) = B(j)
        j++
end 
~~~