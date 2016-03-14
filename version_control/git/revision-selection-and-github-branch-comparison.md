# Revision Selection, GitHub branch comparison

March 14, 2016  
Yimeng Zhang

There are many ways to refer to a commit apart from using the SHA. 

## Relative selection

In particular, `~n` and `^n` (both `n` are 1 if omitted) are useful, and first is for specifying first parent n levels before, and second for specifying the nth immediate parent. <https://git-scm.com/docs/git-rev-parse> give very good illustration.

~~~
G   H   I   J
 \ /     \ /
  D   E   F
   \  |  / \
    \ | /   |
     \|/    |
      B     C
       \   /
        \ /
         A
A =      = A^0
B = A^   = A^1     = A~1
C = A^2  = A^2
D = A^^  = A^1^1   = A~2
E = B^2  = A^^2
F = B^3  = A^^3
G = A^^^ = A^1^1^1 = A~3
H = D^2  = B^^2    = A^^^2  = A~2^2
I = F^   = B^3^    = A^^3^
J = F^2  = B^3^2   = A^^3^2
~~~


## Range selection

There are two dots and three dots version when specifying a range in `git log`.

* `A..B` This means showing all commits in B diff (diff in the sense of set theory) the all commits in A. That is, all commits in B not in A.
* `A...B` This means showing the union of A and B's commits minus the intersection of their commits. That is, their unique parts combined.

However, it's somehow reversed for `git diff`. Two dots give you the common diff you like to see, and three dots give you the difference between B and A and B's best common ancestor (which is not always easy to compute in some tricky cases). For GitHub's pull request and branch comparison, three dot version is used. See <http://stackoverflow.com/questions/24517820/github-compare-view-for-current-versions-of-branches>. Seems that the two dot version is used in `git log` by GitHub to show which commits are unique to the new branch, and three dot version is used in `git diff` to show the difference! 

In any case, know that GitHub's comparison (branch comparison and pull request) is **asymmetric**. In GitHub, there is the concept of ahead and behind commits. These refer to the commits uniquely belonging to one branch and another. See <http://stackoverflow.com/questions/6643415/meaning-of-github-ahead-behind-metrics>.

<http://stackoverflow.com/questions/462974/what-are-the-differences-between-double-dot-and-triple-dot-in-git-com> and <http://stackoverflow.com/questions/7251477/what-are-the-differences-between-double-dot-and-triple-dot-in-git-dif> show these very clearly.

Also, with `--left-right` with triple dot, you can show the origin of commit.


## References

* [What are the differences between double-dot &quot;..&quot; and triple-dot &quot;...&quot; in Git diff commit ranges? - Stack Overflow](http://stackoverflow.com/questions/7251477/what-are-the-differences-between-double-dot-and-triple-dot-in-git-dif)
* [git diff - What are the differences between double-dot &quot;..&quot; and triple-dot &quot;...&quot; in Git commit ranges? - Stack Overflow](http://stackoverflow.com/questions/462974/what-are-the-differences-between-double-dot-and-triple-dot-in-git-com)
* [git - GitHub compare view for current versions of branches - Stack Overflow](http://stackoverflow.com/questions/24517820/github-compare-view-for-current-versions-of-branches)
* [repository - Meaning of Github Ahead/Behind Metrics - Stack Overflow](http://stackoverflow.com/questions/6643415/meaning-of-github-ahead-behind-metrics)

