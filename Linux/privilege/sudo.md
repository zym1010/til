# `sudo` and `su`

Yimeng Zhang  
March 1, 2016

There are multiple commands related to getting root privilege.

* `su`
* `sudo`
* `sudo -i`
* `sudo -s`

Here are the differences.

* `su` switches users. By default, it will switch to root, and you enter root's password and get a shell with root privilege.
* `sudo` run programs as root. You enter your own password, and what you can run depends on the `/etc/sudoers` file.
* `sudo -s` runs a particular program: **your** shell (as defined in password file), or the `SHELL` environment variable. This shell has nothing to do with root's actual login shell.
* `sudo -i` run a particular program: (by default if no user is supplied) **root's** shell, and also it tries to simulate the root's environment as well as possible.

While some options look similar (`su`, `sudo bash`, `sudo -s`, `sudo -i`), they are different in some details such as home folder, environment variables, etc. A comparison is given below, extracted from <http://ubuntuforums.org/showthread.php?t=983645&p=6188826#post6188826>

```
				                     corrupted by user's 
		HOME=/root	uses root's PATH     env vars
sudo -i		Y		Y[2]                 N
sudo -s		N		Y[2]                 Y
sudo bash	N		Y[2]                 Y
sudo su		Y		N[1]                 Y


[1] PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
    probably set by /etc/environment
[2] PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/X11R6/bin
```

I think it's only important to know that there are some minor differences of these commands, as this comparison may not apply to all Linux distributions (see <http://stackoverflow.com/questions/257616/sudo-changes-path-why>, seems that Ubuntu and Fedora treat PATH differently when doing sudo).

## `gksudo`

In addition, there's a `gksudo` that's claimed to be useful for running GUI programs as root. seems that its difference with the above commands are only in terms of some environment variables and home folder, by <http://superuser.com/questions/202676/sudo-vs-gksudo-difference/726249#726249>.

## References

* [What are the differences between “su”, “sudo -s”, “sudo -i”, “sudo su”?](http://askubuntu.com/questions/70534/what-are-the-differences-between-su-sudo-s-sudo-i-sudo-su)
* [Difference between sudo su and sudo -s](http://ubuntuforums.org/showthread.php?t=983645&p=6188826#post6188826)
* [sudo changes PATH - why?](http://stackoverflow.com/questions/257616/sudo-changes-path-why)
* [sudo vs gksudo. difference?](http://superuser.com/questions/202676/sudo-vs-gksudo-difference/726249#726249)