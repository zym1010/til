# Rebase

March 14, 2016  
Yimeng Zhang

Rebase is a way to modify history.

<https://git-scm.com/book/en/v2/Git-Branching-Rebasing> explains basic rebase very well. Notice that rebase has three arguments, in the form of `git rebase --onto A B C`.

First, commits unique to branch C relative to branch B (those shown by `git log B..C`) will be recorded, then and these commits will be replayed on A, and after that, C will be set downstream to A.

* if `C` is not given, it's the current branch.
* if `A` is not given, it's B.

I think there's also a default value for `B`, but probably that's rarely used.

Notice that when rebasing, all merge commits are ignored, since merge commits don't have actual content. They just signify the combination of two commits. As rebasing gives you a flat history, there's no need for merge commits.

<https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History> talk about `git rebase -i`, which is extremely helpful.

## Committer vs author

After rebasing, the author and committer of a commit can be different. The person who makes the changes in the code is the author, and the person makes the rebase is the committer. See <http://stackoverflow.com/questions/6755824/what-is-the-difference-between-author-and-committer-in-git>

## References

* [Git - Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)
* [Git - Rewriting History](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History)
* [github - What is the difference between author and committer in Git? - Stack Overflow](http://stackoverflow.com/questions/6755824/what-is-the-difference-between-author-and-committer-in-git)

