# unix/linux 常用法

    Advanced Bash-Scripting Guide https://tldp.org/LDP/abs/html/index.html

## 常用脚本收集

目录 shell_script 下是写的不错的脚本示例

    https://github.com/jacyl4/de_GWD
    https://github.com/acmesh-official/acme.sh

```shell
#!/usr/bin/env python3  # 按照PATH寻找第一个python3程序来执行
#!/bin/bash
#
# 参考:
# https://zhuanlan.zhihu.com/p/123989641

# Bach脚本测试框架 https://github.com/bach-sh/bach/blob/master/README-cn.md
# source path/to/bach.sh

####################################################################
# 此部分作为普通脚本的默认头部内容，便于调测运行。
#
#
# -x ： 在执行每一个命令之前把经过变量展开之后的命令打印出来。
# -e ： 遇到一个命令失败（返回码非零）时，立即退出。
# -u ：试图使用未定义的变量，就立即退出。
# -o pipefail ： 只要管道中的一个子命令失败，整个管道命令就失败。
set -xeuo pipefail

# 防止重叠运行
exec 123<>lock_myscript   # 把lock_myscript打开为文件描述符123
flock  --wait 5  123 || { echo 'cannot get lock, exit'; exit 1; }

# 意外退出时杀掉所有子进程
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

# timeout 限制运行时间
timeout 600s  some_command arg1 arg2

# 连续管道时，考虑使用 tee 将中间结果落盘，以便查问题
cmd1 | tee out1.dat | cmd2 | tee out2.dat | cmd3 > out3.dat

####################################################################
#
# 文字颜色生成模板 http://ciembor.github.io/4bit
#

# 一个颜色文字的例子
red='\033[0;31m'
green="\033[0;32m"
plain='\033[0m'

[ -z "$res" ] && ngstatus="${red}已停止${plain}" || ngstatus="${green}正在运行${plain}"
echo -e " nginx运行状态：${ngstatus}"

RED="31m"      # Error message
YELLOW="33m"   # Warning message
colorEcho(){
    echo -e "\033[${1}${@:2}\033[0m" 1>& 2
}
colorEcho ${RED} "ERROR: This script has been DISCARDED"
colorEcho ${YELLOW} "USE: https://github.com/"

####################################################################
#
# python 颜色字符串
#
import platform
from colorama import Fore, Back, Style

text = "Ok, let's go!"

def print_color(color, message=""):
    v_system = platform.system()
        if v_system == 'Linux':
            print(color+message)

# 将前景设为红色，背景默认是黑色
print(Fore.RED + text)
# 将背景设为白色，前景沿用之前的红色，并且在显示完之后将格式复位
print(Back.WHITE + text + Style.RESET_ALL)
print(text)
# 将前景设为黑色，背景设为白色
print(Fore.BLACK + Back.WHITE + text + Style.RESET_ALL)
print(Style.RESET_ALL)
print('back to normal now')

####################################################################

```

## 后台执行

### nohup

    nohup sleep 3600 &

### 后知后觉发现一个命令要执行很久，半路让它改成后台执行

如果程序的输出无所谓，你只要程序能继续执行下去就好，
——典型的例子是你压缩一个文件或者编译一个大软件，中途发现需要花很长时间.

按下 Ctrl-z，让程序进入suspend（这个词中文是——挂起？）状态。这个时候你应该会看到：

    [1]+  Stopped                 xxxx 这样的输出。

上面那个 [] 里的数字，我们记为n，然后执行：

    # 让暂时停掉的进程在后台运行起来
    bg %n

    # 让暂时停掉的进程在前台运行起来
    fg %n

执行之前，如果不放心，想确认一下，可以用 jobs 命令看看被suspend的任务列表
（严格地说，jobs看的不仅仅是suspend的任务，所以，如果你有其他后台任务，也会列出来。）

然后再解除你现在的shell跟刚才这个进程的所属关系

    disown

这个时候再执行jobs，就看不到那个进程了，用 ps -ef 可以看到哦。现在就可以关掉终端，下班回家了。

实例

    bash-3.2$ sleep 3600  # 要执行很久的命令
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

### 使用 tmux

tmux用一个守护进程打开多个终端窗口实现了一直在后台运行，详见 <gun_tools.md> 的 tmux 章节。
