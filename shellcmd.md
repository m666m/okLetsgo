# unix/linux 常用法

## 后台执行

### nohup

    nohup sleep 3600 &

### tmux

### 后知后觉发现一个命令要执行很久，半路让它改成后台执行

如果程序的输出无所谓，你只要程序能继续执行下去就好，
——典型的例子是你压缩一个文件或者编译一个大软件，中途发现需要花很长时间.

按下Ctrl-z，让程序进入suspend（这个词中文是——挂起？）状态。这个时候你应该会看到：

    [1]+  Stopped                 xxxx 这样的输出。

上面那个 [] 里的数字，我们记为n，然后执行：

    bg %n  # 让暂时停掉的进程在后台运行起来。

    # fg %n  # 让暂时停掉的进程在前台运行起来。

执行之前，如果不放心，想确认一下，可以用 jobs 命令看看被suspend的任务列表
（严格地说，jobs看的不仅仅是suspend的任务，所以，如果你有其他后台任务，也会列出来。）

然后再执行 disown ，解除你现在的shell跟刚才这个进程的所属关系。

这个时候再执行jobs，就看不到那个进程了。现在就可以关掉终端，下班回家了。

实例

    bash-3.2$ sleep 3600                                            # 要执行很久的命令
    ^Z
    [1]+  Stopped                 sleep 3600

    bash-3.2$ jobs
    [1]+  Stopped                 sleep 3600

    bash-3.2$ bg %1
    [1]+ sleep 3600 &

    bash-3.2$ jobs
    [1]+  Running                 sleep 3600 &

    bash-3.2$ disown

    bash-3.2$ jobs

    bash-3.2$ ps -ef | grep sleep                                    # 此处输出可知，那个命令还在执行
    501 30787 30419   0  6:00PM ttys000    0:00.00 sleep 3600
    501 33681 30419   0  6:02PM ttys000    0:00.00 grep sleep

    bash-3.2$ exit
