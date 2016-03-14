# Typical `.gitconfig`

March 14, 2016  
Yimeng Zhang

## Name and email

These two must be set before you can commit anything. The email must be used by GitHub as well so that GitHub can make associations.

```
git config --global user.name "Your Name"
git config --global user.email "your_email@whatever.com"
```


## Line ending

This sets the fallback line ending setting. (check [here](./line-ending-and-gitattributes.md) for new system of line ending.

For Mac / Linux

```
git config --global core.autocrlf input
git config --global core.safecrlf true
```


For Windows

```
git config --global core.autocrlf true
git config --global core.safecrlf true
```

## global gitignore

Usually, there should be a global gitignore to ignore some OS-generated files. You can set global ignore file as `~/.gitignore_global` by 

```
git config --global core.excludesfile ~/.gitignore_global
```

The content is usually OS-generated files. In my case, it's

```
# OS generated files #
######################
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
```

## References 

* [Lab 1 - Git Immersion - Brought to you by Neo](gitimmersion.com/lab_01.html)
* [Dealing with line endings - User Documentation](https://help.github.com/articles/dealing-with-line-endings/)
* [Setting your username in Git - User Documentation](https://help.github.com/articles/setting-your-username-in-git/)
* [Setting your username in Git - User Documentation](https://help.github.com/articles/setting-your-email-in-git/)
* [Ignoring files - User Documentation](https://help.github.com/articles/ignoring-files/)
* [Some common .gitignore configurations](https://gist.github.com/octocat/9257657)