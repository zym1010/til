# Some trick parts in `.gitignore` file.

Yimeng Zhang  
March 1, 2016

Suppose you want to ignore folder ``bin`` under root directory, you can write `/bin`, `/bin/`, `/bin/*`, or `/bin/**`. What's the difference?

Well if you only want to ignore everything under `/bin` then there's no difference. However, things become more interesting when using `!` later to override some rules.

Consider a repo with following files

~~~
./bin1
./bin1/foo
./bin1/foo/bar
./bin2
./bin2/.DS_Store
./bin2/foo
./bin3
./bin3/foo
./bin3/foo/bar
./bin4
./bin4/foo
./bin4/foo/bar
./bin5
./bin5/foo
./bin5/foo1
./bin5/foo1/bar
~~~

and the following gitignore file.

~~~
/bin1/foo
/bin2/foo/
/bin3/**
!/bin3/foo
/bin4/*
!/bin4/foo
/bin5
!/bin5/foo
~~~

The result is that only `bin2/foo` and `bin4/foo/bar` are included.

* For `bin1`, it's easy to understand. `/bin1/foo` is ignored, so are its contents.
* For `bin2`, you can see that `foo/` only ignores a directory, but not both file and directory as `foo` does in `bin1`.
* For `bin3`, `!/bin3/foo` has no use because `/bin3/**` matches arbitrarily deep, so `/bin3/**` excludes `/bin3/foo/bar` and `!/bin3/foo` only negates the folder itself, which is always ignored by git, and the `bar` file still gets ignored.
* For `bin4`, since `/bin4/*` only matches one level deep, so `/bin4/foo/bar` doesn't match `/bin4/*`. `/bin4/foo/bar`  would get ignored as well if there's no `!/bin4/foo` because the following statement in the doc for gitignore. (<https://git-scm.com/docs/gitignore>, PATTERN FORMAT)
    
    > It is not possible to re-include a file if a parent directory of that file is excluded.

    Thus `/bin4/foo/bar` got ignored not (directly) due to `/bin4/*`, but due to `/bin4/foo` being ignored. Thus by getting back `foo`, `bar` gets back.
    
* For `bin5`, negation doesn't work become `/bin5` matches `bin5` itself, rather than its contents as in `bin3` and `bin4`. By the above quote, negation doesn't work since there's still some parent directory that is ignored.

## Best practice
Suppose you want to keep some structure of empty folders, then it's best IMO to use `**` plus negating subfolders and empty `.gitignore` files as in the following example. (part of <https://github.com/zym1010/RSA_research/blob/master/.gitignore>)

~~~
# results
/results/**
# just for creating folders.
!/results/params
!/results/params/.gitignore
!/results/features
!/results/features/.gitignore
!/results/feature_tables
!/results/feature_tables/.gitignore
!/results/rdm_tables
!/results/rdm_tables/.gitignore
!/results/plots
!/results/plots/.gitignore
!/results/datasets
!/results/datasets/.gitignore
!/results/models
!/results/models/.gitignore
!/results/analysis_tables
!/results/analysis_tables/.gitignore
!/results/stats
!/results/stats/.gitignore
!/results/neuron_fitting
!/results/neuron_fitting/.gitignore
~~~

## References

* [.gitignore Syntax: bin vs bin/ vs. bin/* vs. bin/**](http://stackoverflow.com/questions/8783093/gitignore-syntax-bin-vs-bin-vs-bin-vs-bin)
* [gitignore - Specifies intentionally untracked files to ignore](https://git-scm.com/docs/gitignore)
