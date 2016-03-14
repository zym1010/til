# Line ending and `gitattributes` in `git`

Yimeng Zhang  
March 13, 2016



There are two ways to deal with line ending conversion in git.

In the git official documentation <http://git-scm.com/docs/gitattributes>, as well as this document, "repository" refers to the blob objects saved in the git mini database, and "working directory" (WD) refers to the actual set of files obtained by running `git checkout` and other similar commands. "check in" means updating repository with files in WD, and "check out" means the reverse.

## core.autocrlf

This is referred to as "the old system" in <http://adaptivepatchwork.com/2012/03/01/mind-the-end-of-your-line/>. It can be set by typing `git config --global core.autocrlf XXX`, where `XXX` can be

1. `true` makes sure that CRLF files in WD are converted to LF when checking in (to the repository), and LF files are converted to CRLF when checking out.
2. `false` default. don't care about line ending conversion at all.
3. `input` CRLF files in WD are converted to LF when checking in, but nothing done for checking out.

Usually, it's recommended Linux and Mac use `input`, and Windows use `true`. See <http://gitimmersion.com/lab_01.html> and <https://help.github.com/articles/dealing-with-line-endings/> for some references.

### core.safecrlf

`core.safecrlf` per se is not part of the old system, as it can affect the new system later described as well. It is related to whether line conversion can convert files between CRLF and LF without loss. It can be set by typing `git config --global core.safecrlf XXX`, where `XXX` can be

1. `true` makes sure that committing a (text, thus amenable to line ending conversion) file and then checking out will give back the original file. If this is not the case given the current line-ending setting (based on `core.autocrlf` or the new system), abort the commit.
2. `warn` issue warning for lossy conversion instead of aborting the program.
3. Don't set this value. By default, no warning or abort for lossy conversion.

When setting this to `true`, this means we can't commit LF file in Windows with `core.autocrlf=true`, and commit CRLF file in Linux and Mac with `core.autocrlf=input`, since there will be difference between the file before committing and after checking out. Instead, we need to do the conversion manually. Similar conditions (should, as far as I tried) apply when using the new system as well.

## `.gitattributes`

The modern way is not specifying `core.autocrlf` (or using it as a default), and set line ending settings in a `.gitattributes` file in WD. This makes sure that line ending settings are (more) consistent over different global git settings, since they are specified already in the WD already. Check <http://git-scm.com/docs/gitattributes> for more detail. The most important attribute is `text`.

1. When set for a file (a line like `XXX text`), it means converting to LF when checking in, and converting to `core.eol` (or CRLF if `core.autocrlf=true` when checking out.
1. When set for a file (a line like `XXX -text`), it means doing nothing about line conversion.
2. When set as `auto`, it means adding `text` and `-text` heuristically.
3. When nothing is set, use the old system, when the file is heuristically  recognized as a text file.

In addition, separate files can override `core.eol` with `eol` attribute. For example `*.tm eol=crlf` can set all timing files in CORTEX to have CRLF endings no matter what.

I recommend at least having a `.gitattributes` with `* text=auto` as the only line. This makes line ending conversion mandatory, regardless what `core.autocrlf` there is. Even better, we can add some more specific rules after this "baseline". WHY after? Because according to <http://git-scm.com/docs/gitattributes>:

> When more than one pattern matches the path, a later line overrides an earlier line.

<http://git-scm.com/docs/gitattributes> tells why even `* text=auto` is better than setting `core.autocrlf`, apart from consistency over different global git settings. Basically, `core.autocrlf` only works when checking in and out the files, and `* text=auto` makes sure that existing files in the repository have normalized line-endings as well. For example, given a CRLF file in the repository, setting `* text=auto` would mark that file as modified (probably after clearing the index, see <http://git-scm.com/docs/gitattributes>, "Note: When `text=auto` normalization is enabled in an existing repository, any text files containing CRLFs should be normalized. blabla"), yet with `core.autocrlf=true`, this file in the repository won't be changed (maybe will be changed after another round of check out and check in?). Anyway, using `.gitattributes` seems more consistent, and `core.autocrlf` should be a fallback option.

### `diff` and `binary`

As mentioned in <http://git-scm.com/docs/gitattributes>, `diff` determines how `git diff` treats files and `binary` is a shortcut for `-text -diff`, which make sense for binary files.

## References

* [Dealing with line endings](https://help.github.com/articles/dealing-with-line-endings/)
* [Lab 1 - Git Immersion - Brought to you by Neo](http://gitimmersion.com/lab_01.html)
* [Mind the End of Your Line](http://adaptivepatchwork.com/2012/03/01/mind-the-end-of-your-line/)
* [Git - gitattributes Documentation](http://git-scm.com/docs/gitattributes)