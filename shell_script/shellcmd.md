# unix/linux 常用shell操作

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

## 环境变量文件的说明

系统级

    $  cat /etc/profile
    # /etc/profile: system-wide .profile file for the Bourne shell (sh(1))
    # and Bourne compatible shells (bash(1), ksh(1), ash(1), ...).

    if [ "`id -u`" -eq 0 ]; then
      PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    else
      PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
    fi
    export PATH

    if [ "${PS1-}" ]; then
      if [ "${BASH-}" ] && [ "$BASH" != "/bin/sh" ]; then
        # The file bash.bashrc already sets the default PS1.
        # PS1='\h:\w\$ '
        if [ -f /etc/bash.bashrc ]; then
          . /etc/bash.bashrc
        fi
      else
        if [ "`id -u`" -eq 0 ]; then
          PS1='# '
        else
          PS1='$ '
        fi
      fi
    fi

    if [ -d /etc/profile.d ]; then
      for i in /etc/profile.d/*.sh; do
        if [ -r $i ]; then
          . $i
        fi
      done
      unset i
    fi

用户级

    $ cat ~/.profile
    # ~/.profile: executed by the command interpreter for login shells.
    # This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
    # exists.
    # see /usr/share/doc/bash/examples/startup-files for examples.
    # the files are located in the bash-doc package.

    # the default umask is set in /etc/profile; for setting the umask
    # for ssh logins, install and configure the libpam-umask package.
    #umask 022

    # if running bash
    if [ -n "$BASH_VERSION" ]; then
        # include .bashrc if it exists
        if [ -f "$HOME/.bashrc" ]; then
            . "$HOME/.bashrc"
        fi
    fi

    # set PATH so it includes user's private bin if it exists
    if [ -d "$HOME/bin" ] ; then
        PATH="$HOME/bin:$PATH"
    fi

    # set PATH so it includes user's private bin if it exists
    if [ -d "$HOME/.local/bin" ] ; then
        PATH="$HOME/.local/bin:$PATH"
    fi

## 目录结构

linux的目录，有几个固定用途的，有些是文件系统挂载在这个目录上

    $ df -h
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/root        29G  1.6G   26G   6% /
    devtmpfs        1.8G     0  1.8G   0% /dev
    tmpfs           1.9G     0  1.9G   0% /dev/shm
    tmpfs           1.9G  8.5M  1.9G   1% /run
    tmpfs           5.0M  4.0K  5.0M   1% /run/lock
    tmpfs           1.9G     0  1.9G   0% /sys/fs/cgroup
    /dev/mmcblk0p1  253M   49M  204M  20% /boot
    tmpfs           384M     0  384M   0% /run/user/1000

/ 根文件系统

/etc : 系统级配置文件

/bin：软链接到 /usr/bin。

/usr：发行版的内容基本都在这里，可以理解为 C:/Windows/。

    /usr/bin：各种可执行程序在这里，安装到各种路径下的软件，一般把启动引导命令行程序放置在这里，只要PATH变量有这个路径，用户使用该命令时就很方便，不需要指明程序的安装路径。有些命令在/bin 或/usr/local/bin 中，也在这里做个软链接。

    /usr/sbin：根文件系统不必须的系统管理命令，例如多数服务程序。

    /usr/man, /usr/info, /usr/doc：手册页、GNU信息文档和各种其他文档文件。

    /usr/include：C编程语言的头文件.为了一致性这实际上应该在/usr/lib 下，但传统上支持这个名字.

    /usr/lib：理解为 C:/Windows/System32。编程的原始库存在/usr/lib 里，所谓库(library) 。程序或子系统的不变的数据文件，包括一些site-wide配置文件。

    /usr/local：用户级的程序目录，可以理解为 C:/Progrem Files/。用户自己编译的软件默认会安装到这个目录下。这里主要存放那些手动安装的软件，即不是通过“新立得”或 apt 安装的软件。它和 /usr 目录具有相类似的目录结构。让软件包管理器来管理 /usr 目录，而把自定义的脚本(scripts)放到 /usr/local 目录下面。
        /usr/local/bin：自编译安装的软件的可执行部分在这里

    /usr/share：一些共享数据，
        /usr/share/man：联机帮助文件
        /usr/share/doc：软件杂项的文件说明
        /usr/share/zoneinfo：与时区有关的时区档案

/var 系统一般运行时要改变的数据.每个系统是特定的，即不通过网络与其他计算机共享.

    /var/log
    各种程序的Log文件，特别是login  (/var/log/wtmp log所有到系统的登录和注销) 和syslog (/var/log/messages 里存储所有核心和系统程序信息. /var/log 里的文件经常不确定地增长，应该定期清除.

    /var/spool
    mail, news, 打印队列和其他队列工作的目录.每个不同的spool在/var/spool 下有自己的子目录，例如，用户的邮箱在/var/spool/mail 中.

    /var/tmp
    比/tmp 允许的大或需要存在较长时间的临时文件. (虽然系统管理员可能不允许/var/tmp 有很旧的文件.)

    /var/catman
    当要求格式化时的man页的cache.man页的源文件一般存在/usr/man/man* 中；有些man页可能有预格式化的版本，存在/usr/man/cat* 中.而其他的man页在第一次看时需要格式化，格式化完的版本存在/var/man 中，这样其他人再看相同的页时就无须等待格式化了. (/var/catman 经常被清除，就象清除临时目录一样.)

    /var/lib
    系统正常运行时要改变的文件.

    /var/local
    /usr/local 中安装的程序的可变数据(即系统管理员安装的程序).注意，如果必要，即使本地安装的程序也会使用其他/var 目录，例如/var/lock .

    /var/lock
    锁定文件.许多程序遵循在/var/lock 中产生一个锁定文件的约定，以支持他们正在使用某个特定的设备或文件.其他程序注意到这个锁定文件，将不试图使用这个设备或文件.

    /var/run
    保存到下次引导前有效的关于系统的信息文件.例如， /var/run/utmp 包含当前登录的用户的信息.

/opt 目录

    用来安装附加软件包，是用户级的程序目录，可以理解为 D:/Software。安装到 /opt 目录下的程序，它所有的数据、库文件等等都是放在同个目录下面。opt 有可选的意思，这里可以用于放置第三方大型软件（或游戏），当你不需要时，直接 rm -rf掉即可。在硬盘容量不够时，也可将 /opt 单独挂载到其他磁盘上使用。

查看目录结构

    $ tree /opt
    /opt
    └── vc
        ├── bin
        │   ├── containers_check_frame_int
        │   ├── containers_datagram_receiver
        │   ├── containers_datagram_sender
        │   ├── containers_dump_pktfile
        │   ├── containers_rtp_decoder
        │   ├── containers_stream_client
        │   ├── containers_stream_server
        │   ├── containers_test
        │   ├── containers_test_bits
        │   ├── containers_test_uri
        │   ├── containers_uri_pipe
        │   ├── dtmerge
        │   ├── dtoverlay
        │   ├── dtoverlay-post
        │   ├── dtoverlay-pre
        │   ├── dtparam -> dtoverlay
        │   ├── edidparser
        │   ├── mmal_vc_diag
        │   ├── raspistill
        │   ├── raspivid
        │   ├── raspividyuv
        │   ├── raspiyuv
        │   ├── tvservice
        │   ├── vcdbg
        │   ├── vcgencmd
        │   ├── vchiq_test
        │   ├── vcmailbox
        │   └── vcsmem
        ├── include
        |

## 当前shell

查看当前所使用的shell程序

    $ echo $0
    -bash

不要被一个叫做 $SHELL 的单独的环境变量所迷惑，它被设置为你的默认 shell 的完整路径。因此，这个变量并不一定指向你当前使用的 shell。你在终端中调用不同的 shell，$SHELL 是保持不变的。

    $ echo $SHELL
    /bin/bash

当前shell的嵌套层数

    $ echo $SHLVL
    1

    $ bash

    $ echo $SHLVL
    2

    $ exit
    exit

    echo $SHLVL
    1

组命令、管道、命令替换这几种写法都会进入子 Shell

    $ echo "$SHLVL  $BASH_SUBSHELL"
    1  0

    $ (echo "$SHLVL  $BASH_SUBSHELL") # 组命令
    1  1

    $ echo "hello" | { echo "$SHLVL  $BASH_SUBSHELL"; }  # 管道
    1  1

    $ var=$(echo "$SHLVL  $BASH_SUBSHELL");echo $var  #命令替换
    1 1

    $ ( ( ( (echo "$SHLVL  $BASH_SUBSHELL") ) ) )  #四层组命令
    1  4

## 进程查看

当前系统进程树，带命令行显示

    $ pstree -a
    systemd
    ├─agetty -o -p -- \\u --keep-baud 115200,38400,9600 ttyS0 vt220
    ├─agetty -o -p -- \\u --noclear tty1 linux
    ├─alsactl -E HOME=/run/alsa -s -n 19 -c rdaemon
    ├─avahi-daemon
    │   └─avahi-daemon
    ├─bluetoothd
    ├─cron -f
    ├─tmux: server
    │   ├─bash
    │   │   └─cmatrix -ba
    │   ├─bash
    │   │   └─watch -n1 date '+%D%n%T'|figlet -k
    │   ├─bash
    │   ├─bash
    │   │   └─top
    │   ├─bash
    │   │   └─bash
    │   │       ├─autossh -M ...
    │   │       │   └─ssh -L ...
    │   │       └─ssh-agent /bin/bash
    │   └─bash
    ├─wpa_supplicant -u -s -O /run/wpa_supplicant
    └─wpa_supplicant -B -c/etc/wpa_supplicant/wpa_supplicant.conf -iwlan0 -Dnl80211,wext

展示指定用户的进程树

    $ pstree pi
    sshd───bash───pstree

    systemd───(sd-pam)

    tmux: server─┬─bash───cmatrix
                ├─bash───watch
                ├─2*[bash]
                ├─bash───top
                └─bash───bash─┬─autossh───ssh
                            └─ssh-agent

进程信息，用x显示归属

    $ ps -efx
    PID TTY      STAT   TIME COMMAND
    26577 ?        S      0:06 sshd: pi@pts/0
    26578 pts/0    Ss     0:00  \_ -bash USER=pi LOGNAME=pi HOME=/home/pi PATH=/usr/local/bin:/usr/bin:/bin:/usr/games MAIL=/var/mail/pi SHE
    12445 pts/0    R+     0:00      \_ ps -efx SHELL=/bin/bash NO_AT_BRIDGE=1 PWD=/home/pi LOGNAME=pi XDG_SESSION_TYPE=tty HOME=/home/pi LAN
    10615 ?        Ss    89:40 tmux SHELL=/bin/bash NO_AT_BRIDGE=1 PWD=/home/pi LOGNAME=pi XDG_SESSION_TYPE=tty HOME=/home/pi LANG=en_GB.UTF
    10616 pts/1    Ss     0:00  \_ -bash HOME=/home/pi LANG=en_GB.UTF-8 LOGNAME=pi LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:
    10759 pts/1    S+    73:00  |   \_ cmatrix -ba SHELL=/bin/bash TMUX=/tmp/tmux-1000/default,10615,0 NO_AT_BRIDGE=1 PWD=/home/pi LOGNAME=p
    10660 pts/2    Ss     0:00  \_ -bash HOME=/home/pi LANG=en_GB.UTF-8 LOGNAME=pi LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:
    10837 pts/2    S+     4:47  |   \_ watch -n1 date '+%D%n%T'|figlet -k SHELL=/bin/bash TMUX=/tmp/tmux-1000/default,10615,1 NO_AT_BRIDGE=1
    10741 pts/6    Ss+    0:00  \_ -bash HOME=/home/pi LANG=en_GB.UTF-8 LOGNAME=pi LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:
    10781 pts/7    Ss     0:00  \_ -bash HOME=/home/pi LANG=en_GB.UTF-8 LOGNAME=pi LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:
    21814 pts/7    S+     7:21  |   \_ top SHELL=/bin/bash TMUX=/tmp/tmux-1000/default,10615,0 NO_AT_BRIDGE=1 PWD=/home/pi LOGNAME=pi XDG_SE
    10819 pts/8    Ss     0:00  \_ -bash HOME=/home/pi LANG=en_GB.UTF-8 LOGNAME=pi LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:
    26848 pts/8    S      0:00  |   \_ /bin/bash SHELL=/bin/bash TMUX=/tmp/tmux-1000/default,10615,1 NO_AT_BRIDGE=1 PWD=/home/pi LOGNAME=pi
    26849 ?        Ss     0:00  |       \_ ssh-agent /bin/bash
    26974 pts/8    S+     0:00  |       \_ /usr/lib/autossh/autossh -M ...
    26977 pts/8    S+     0:00  |           \_ /usr/bin/ssh -L ...
    21772 pts/3    Ss+    0:00  \_ -bash HOME=/home/pi LANG=en_GB.UTF-8 LOGNAME=pi LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:
    9901 ?        Ss     0:00 /lib/systemd/systemd --user LANG=en_GB.UTF-8 PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bi
    9902 ?        S      0:00  \_ (sd-pam)

显示cpu占用情况

    top

按键切换不同的显示，c显示命令行，1显示每个cpu占用，h显示帮助信息

## 文件信息

可以看文件是shell类型、二进制类型，文本类型等

    $ file .profile
    .profile: UTF-8 Unicode text

    $ file .
    .: directory

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
