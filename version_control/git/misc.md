# Miscellaneous commands

##  get the remote repo's URL

`git ls-remote --get-url origin` should do 99.99999% of the time (unless your remote is not called `origin`)

[github - How can I determine the URL that a local Git repository was originally cloned from? - Stack Overflow](http://stackoverflow.com/questions/4089430/how-can-i-determine-the-url-that-a-local-git-repository-was-originally-cloned-fr)

## Get only SHA1 of last commit

`git rev-parse --verify HEAD` should do.

[How to retrieve the hash for the current commit in Git? - Stack Overflow](http://stackoverflow.com/questions/949314/how-to-retrieve-the-hash-for-the-current-commit-in-git)

## Check repo is completely clean

`git status --porcelain` should do. the repo is completely clean when this command returns no output.

[git - How to check if there&#39;s nothing to be committed in the current branch? - Stack Overflow](http://stackoverflow.com/questions/5139290/how-to-check-if-theres-nothing-to-be-committed-in-the-current-branch)