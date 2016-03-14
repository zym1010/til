# Hash collision in git

March 14, 2016  
Yimeng Zhang

What if two files (or two directories, whose hash might be derived from the files), have the same SHA1 hash? According to <http://stackoverflow.com/questions/9392365/how-would-git-handle-a-sha-1-collision-on-a-blob>, this is not a problem, due to the following two reasons.

1. Highly unlikely, so that it has lower probability than things that probably you should care more, such as all your team member got attacked and killed by wolves in the same night.
2. Even if it happens, you should notice it very quickly, since new object won't get committed due to having same SHA1 as the old object.


## References

[How would git handle a SHA-1 collision on a blob? - Stack Overflow](http://stackoverflow.com/questions/9392365/how-would-git-handle-a-sha-1-collision-on-a-blob) (check answer from VonC)

