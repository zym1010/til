# Merging

March 14, 2016  
Yimeng Zhang

When there's conflict on merge, and you only want to use files from one side either because you really want to do so, or because the files with conflict are binary so there's no combined diff files generated for the file.

You can use `git checkout --theirs -- path/to/conflicted-file.txt` and `git checkout --ours -- path/to/conflicted-file.txt` to resolve choose one side.

## Upstream

People always say you have to set tracking branch for a local branch. But why?

1. It can save you some typing for `git pull`
2. Under certain config for git, it can also save some typing for `git merge` and `git push`. 

See <http://stackoverflow.com/questions/16223561/no-commit-specified-and-merge-defaulttoupstream-not-set> and <http://stackoverflow.com/questions/6089294/why-do-i-need-to-do-set-upstream-all-the-time> and <http://stackoverflow.com/questions/948354/default-behavior-of-git-push-without-a-branch-specified> for more detail. But personally, I always prefer **explicitly** setting the branches when running these commands.

## References

* [Default behavior of &quot;git push&quot; without a branch specified - Stack Overflow](http://stackoverflow.com/questions/948354/default-behavior-of-git-push-without-a-branch-specified)
* [git - Why do I need to do `--set-upstream` all the time? - Stack Overflow](http://stackoverflow.com/questions/6089294/why-do-i-need-to-do-set-upstream-all-the-time)
* [git - &quot;No commit specified and merge.defaultToUpstream not set&quot; - Stack Overflow](http://stackoverflow.com/questions/16223561/no-commit-specified-and-merge-defaulttoupstream-not-set)