# Reset

March 14, 2016  
Yimeng Zhang

First function of `git reset` is changing the position of HEAD in the current branch by `git reset [--op] REF`, where `REF` refers to a commit, either as a SHA1, or some relative reference, like `HEAD~`.

* `op=soft`, only repository is changed.
* `op=mixed` (the default), repository and index are restored to `REF`.
* `op=hard`. repository, index, and working directory are all changed to `REF`.

Another function is unstaging files, by `git reset REF filename`. This command won't change any HEAD pointer, but will restore the file `filename` in the index with `filename` from `REF`. Usually, `REF` is HEAD when doing unstaging, but it can be anything else.


## References

[Git - Reset Demystified](https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified)