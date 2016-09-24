# Remove stale branches

May 4, 2016  
Yimeng Zhang

To remove stale remote branches (branches in remote cache of your computer, but no longer on GitHub), use

~~~
git remote prune origin
~~~

For local branches, do
~~~
git branch -d XXX
~~~
For each of your **merged** branch `XXX` (otherwise it will complain). I don't think there would be too many of them, so it's not very time-consuming, although not automatic.

## References


* [How to prune local tracking branches that do not exist on remote anymore](http://stackoverflow.com/questions/13064613/how-to-prune-local-tracking-branches-that-do-not-exist-on-remote-anymore)
* ['git branch -av' showing remote branch that no longer exists](http://stackoverflow.com/questions/8766525/git-branch-av-showing-remote-branch-that-no-longer-exists)
