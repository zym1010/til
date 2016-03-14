# Sync with remote repo


March 14, 2016  
Yimeng Zhang

Usually this can be done by `git merge origin/master`.

In case somebody screwed up the remote repo by rebasing, so merging would give you screwed up result, you can first save your new work some where in a branch, and then `git reset --hard origin/master` to completely sync your local `master` with the remote one, and then do things like rebase to apply your own work.

## References

[git - Reset local repository branch to be just like remote repository HEAD - Stack Overflow](http://stackoverflow.com/questions/1628088/reset-local-repository-branch-to-be-just-like-remote-repository-head)