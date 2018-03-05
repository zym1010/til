# scope of environment variables.

run `export A=5 && ./2.sh &&  A=3 ./1.sh && A=4 ./2.sh && ./1.sh` under `env_var_scope`. You should see

~~~
2 5
1 3
2 4
1 5
~~~

(after you reopen a terminal), run `A=5 && ./2.sh &&  A=3 ./1.sh && A=4 ./2.sh && ./1.sh`. You should see

~~~
2
1 3
2 4
1
~~~

Basically, `export XXX=YYY` will apply to processes opened inside this session, `XXX=YYY` won't. If you append some `XXX=YYY` in front of some command, that assignment will only affect that command and will not cross boundary of `&&`.
