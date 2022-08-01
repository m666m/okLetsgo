# unix/linux 常用shell操作

    Advanced Bash-Scripting Guide https://tldp.org/LDP/abs/html/index.html

    非常好用的shell语句分析解释 https://explainshell.com/explain?cmd=join+-1+1+-2+5++%3C%28file+*+%7C+sed+%27s%2F%5B%3A%2C%5D%2F%2Fg%27%29+%3C%28ls+--full-time+-h+%7C+awk+%27%7Bprint+%245%22+%22%246%22+%22%247%22+%22%248%22+%22%249%7D%27%29+%7C+column+-t

## 常见符号用法

    http://c.biancheng.net/view/743.html

用完后记得清除变量，防止大规模脚本使用容易发生的变量名污染
unset variable_name
或在函数中使用 local var="hell"来定义局部变量

把语句放到()中包围可以减小变量影响范围：
(umask 077; ssh-agent >| "$env")

单引号包围不解释变量，双引号包围的解释变量
var="hello"
var1='say $var'
var2="say $var"

反引号和$()的作用相同，用于命令替换(command substitution)，即完成引用的命令的执行，将其结果替换出来
echo `date '--date=1 hour ago' +%Y-%m-%d-%H`
echo $(date '--date=1 hour ago' +%Y-%m-%d-%H)
$()中只需要使用一个反斜杠进行转义，下列复制给var变量字符串 $HOME
var2=`echo \\$HOME`
var3=$(echo \$HOME)

${}用于明确界定变量，与$var并没有区别，但是界定更清晰。
A="to"
echo $AB 不如 echo ${A}B

字符串截取
url="abcdefgh"
echo ${url: 2: 5}
显示 cdefg

将数学运算表达式放在((和))之间，在 (( )) 中使用变量无需加上$前缀
((b=a-15)) 将 a-15 的运算结果赋值给变量 c。
c=$((a+b)) 需要立即输出表达式的运算结果时，可以在 (( )) 前面加$符号
echo $((a+b))
((a>7 && b==c)) 也可以做逻辑运算
((a=3+5, b=a+10)) 以最后一个表达式的值作为整个 (( )) 命令的执行结果

let 命令和双小括号 (( )) 的用法是类似的，对于多个表达式之间的分隔符，let 和 (( )) 是有区别的：
let 命令以空格来分隔多个表达式；
(( )) 以逗号,来分隔多个表达式。

当你在 test 命令中使用变量时，强烈建议将变量用双引号""包围起来，这样能避免变量为空值时导致的很多奇葩问题。
test支持3类检测：文件、数值、字符串.
test 和 [] 是等价的，注意两边留空格
[ -z "$str1" -o -z "$str2" ]
[ -z "$str1" ] || [ -z "$str2" ]

注意两边留空格
if [[ -z $str1 ]] || [[ -z $str2 ]]  #不需要对变量名加双引号
then
    echo "字符串不能为空"
elif [[ $str1 < $str2 ]]  #不需要也不能对 < 进行转义
then
    echo "str1 < str2"
else
    echo "str1 >= str2"
fi

如果条件成立则执行，否则不执行的一个流行写法：
[[ -n $envname ]] && printf "conda:%s" $envname

使用逻辑运算符将多个 [[ ]] 连接起来依然是可以的，因为这是 Shell 本身提供的功能，跟 [[ ]] 或者 test 没有关系，如下所示：
[[ -z $str1 ]] || [[ -z $str2 ]]

 -（减号） 的作用是代表标准输出/标准输入, 视命令而定

    # 把 /home 目录压缩，输出到标准输入流，管道后面的命令是从标准输出流读取数据解压
    tar -cvf - /home | tar -xvf -

## Bash Shell 内建命令

    命令            说明

    :           扩展参数列表，执行重定向操作
    .           读取并执行指定文件中的命令（在当前 shell 环境中）
    alias       为指定命令定义一个别名
    bg          将作业以后台模式运行
    bind        将键盘序列绑定到一个 readline 函数或宏
    break       退出 for、while、select 或 until 循环
    builtin     执行指定的 shell 内建命令
    caller      返回活动子函数调用的上下文
    cd          将当前目录切换为指定的目录
    command     执行指定的命令，无需进行通常的 shell 查找
    compgen     为指定单词生成可能的补全匹配
    complete    显示指定的单词是如何补全的
    compopt     修改指定单词的补全选项
    continue    继续执行 for、while、select 或 until 循环的下一次迭代
    declare     声明一个变量或变量类型。
    dirs        显示当前存储目录的列表
    disown      从进程作业表中刪除指定的作业
    echo        将指定字符串输出到 STDOUT
    enable      启用或禁用指定的内建shell命令
    eval        将指定的参数拼接成一个命令，然后执行该命令
    exec        用指定命令替换 shell 进程
    exit        强制 shell 以指定的退出状态码退出
    export      设置子 shell 进程可用的变量
    fc          从历史记录中选择命令列表
    fg          将作业以前台模式运行
    getopts     分析指定的位置参数
    hash        查找并记住指定命令的全路径名
    help        显示帮助文件
    history     显示命令历史记录
    jobs        列出活动作业
    kill        向指定的进程 ID(PID) 发送一个系统信号
    let         计算一个数学表达式中的每个参数
    local       在函数中创建一个作用域受限的变量
    logout      退出登录 shell
    mapfile     从 STDIN 读取数据行，并将其加入索引数组
    popd        从目录栈中删除记录
    printf      使用格式化字符串显示文本
    pushd       向目录栈添加一个目录
    pwd         显示当前工作目录的路径名
    read        从 STDIN 读取一行数据并将其赋给一个变量
    readarray   从 STDIN 读取数据行并将其放入索引数组
    readonly    从 STDIN 读取一行数据并将其赋给一个不可修改的变量
    return      强制函数以某个值退出，这个值可以被调用脚本提取
    set         设置并显示环境变量的值和 shell 属性
    shift       将位置参数依次向下降一个位置
    shopt       打开/关闭控制 shell 可选行为的变量值
    source      读取并执行指定文件中的命令（在当前 shell 环境中）
    suspend     暂停 Shell 的执行，直到收到一个 SIGCONT 信号
    test        基于指定条件返回退出状态码 0 或 1
    times       显示累计的用户和系统时间
    trap        如果收到了指定的系统信号，执行指定的命令
    type        显示指定的单词如果作为命令将会如何被解释
    typeset     声明一个变量或变量类型。
    ulimit      为系统用户设置指定的资源的上限
    umask       为新建的文件和目录设置默认权限
    unalias     刪除指定的别名
    unset       刪除指定的环境变量或 shell 属性
    wait        等待指定的进程完成，并返回退出状态码

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

显示cpu占用情况

    top 按 1 显示各个核的占用，按 A 按资源使用情况排序

    uptime 开机以来的平均负载统计

    w 显示用户名下的进程

cpu属性值说明：

    %user：用于表示用户模式下消耗的 CPU 时间的比例；

    %nice：通过 nice 改变了进程调度优先级的进程，在用户模式下消耗的 CPU 时间的比例；

    %system：系统模式下消耗的 CPU 时间的比例；

    %iowait：CPU 等待磁盘 I/O 导致空闲状态消耗的时间比例；

    %steal：利用 Xen 等操作系统虚拟化技术，等待其它虚拟 CPU 计算占用的时间比例；

    %idle：CPU 空闲时间比例。

备注：

    如果%iowait的值过高，表示硬盘存在I/O瓶颈，导致cpu等待的时间太长

    如果%idle值高，表示CPU较空闲

    如果%idle值高但系统响应慢时，可能是CPU等待分配内存，应检查内存和缓存的使用情况。

    如果%idle值持续低于cpu核数，表明CPU处理能力相对较低，系统中最需要解决的资源是CPU。

### 当前系统进程树

    # 注意伯克利写法的参数不用减号，跟用减号的有区别，详见man ps
    # ps -ef 和 ps aux 类似
    # ps axuf 显示cpu和内存占用
    $ ps axjf
    PPID   PID  PGID   SID TTY      TPGID STAT   UID   TIME COMMAND
        0     2     0     0 ?           -1 S        0   0:00 [kthreadd]
        2     3     0     0 ?           -1 I<       0   0:00  \_ [rcu_gp]
        2     4     0     0 ?           -1 I<       0   0:00  \_ [rcu_par_gp]
        2     8     0     0 ?           -1 I<       0   0:00  \_ [mm_percpu_wq]
        2     9     0     0 ?           -1 S        0   0:00  \_ [rcu_tasks_rude_]
        2    10     0     0 ?           -1 S        0   0:00  \_ [rcu_tasks_trace]
        1  1033  1033  1033 ?           -1 Ss    1000   0:45 tmux
    1033  1034  1034  1034 pts/1    27015 Ss    1000   0:00  \_ -bash
    1034 27015 27015  1034 pts/1    27015 S+    1000   1:27  |   \_ watch -n1 (date '+%T'; vcgencmd measure_temp) |tr '\n' ' ' |figlet -f future.tlf -w 80
    1033  1054  1054  1054 pts/2    28982 Ss    1000   0:00  \_ -bash
    1054 23597 23597  1054 pts/2    28982 S     1000   0:00  |   \_ /bin/bash
    23597 23598 23598 23598 ?           -1 Ss    1000   0:00  |       \_ ssh-agent /bin/bash
    23597 28982 28982  1054 pts/2    28982 S+       0   0:00  |       \_ sudo rngd -r /dev/urandom -o /dev/random -f -t 1
    28982 28983 28982  1054 pts/2    28982 SLl+     0   0:02  |           \_ rngd -r /dev/urandom -o /dev/random -f -t 1

或安装 pstree 工具

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

## 查看io情况

    https://zhuanlan.zhihu.com/p/346630811

    https://blog.csdn.net/sumengnan/article/details/109462795

top 命令

    看 wa 字段，值是cpu等待io的百分比。

vmstat 命令 提供当前CPU、IO、进程和内存使用率的快照

    $ vmstat 3
    procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
    r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
    1  0      0 3554964  24828 247788    0    0     0     0  155  177  1  1 98  0  0
    0  0      0 3554980  24828 247788    0    0     0     0  138  137  0  1 99  0  0
    0  0      0 3555256  24828 247788    0    0     0     0  167  163  0  1 98  0  0

free 命令 显示主内存和交换空间的内存统计数据，默认情况下是以KB为单位的

    $ free -s 5
                total        used        free      shared  buff/cache   available
    Mem:        3930868      103812     3554440        8660      272616     3688032
    Swap:        102396           0      102396

                total        used        free      shared  buff/cache   available
    Mem:        3930868      103584     3554652        8660      272632     3688260
    Swap:        102396           0      102396

### 使用 sysstat 工具包

    https://github.com/sysstat/sysstat

安装及启用

    sudo apt install sysstat

    # 启用数据收集功能
    sudo vi /etc/default/sysstat　　# 把false修改为true

    # 重新启动 sysstat 服务
    sudo systemctl restart sysstat

sysstat 包含了许多商用 Unix 通用的各种工具，用于监视系统性能和活动情况：

    iostat      统计设备和分区的CPU信息以及IO信息

    mpstat      统计处理器相关的信息

    pidstat     统计Linux进程的相关信息：IO、CPU、内存等

    tapstat     统计磁盘驱动器的相关信息

    cifsiostat  统计CIFS信息

sysstat 还包含使用 cron 或 systemd 执行定时任务的工具，用来收集历史性能和活动数据：

    sar     统计并保存系统活动信息，sadc 是 sar 的后端，是系统活动数据的收集器

    sa1     收集二进制数据并将其存储在系统活动每日数据文件中，是使用 cron或 systemd 运行的 sar 前端

    sa2     汇总日常系统活动，是使用 cron 或 systemd 运行的 sar 前端

    sadf    以多种格式显示 sar 收集的数据，如CSV、XML、JSON等，并可以用来与其他程序进行数据交换。

其中的 sar 收集的系统统计信息包括：

    输入/输出和传输速率统计信息

    CPU统计信息，包括对虚拟化体系结构的支持

    内存、交换空间利用率的统计信息

    虚拟内存、分页和故障统计

    进程创建活动信息

    中断信息统计，包括APIC中断，硬件中断，软件中断

    网络统计信息，包括网络接口活动，网络设备故障，IP、TCP、UDP、ICMP协议的流量统计，支持IPv6

    光纤通道流量统计

    基于软件的网络统计信息

    NFS服务器和客户端活动

    套接字统计

    运行队列和系统负载统计

    内核利用率统计信息

    交换统计

    TTY设备活动

    电源管理统计信息

    USB设备事件

    文件系统利用率（节点和块）

    失速信息统计

sar命令选项    功能

    -A    显示系统所有资源设备（CPU、内存、磁盘）的运行状况。

    -u    显示系统所有 CPU 在采样时间内的负载状态。

    -P    显示当前系统中指定 CPU 的使用情况。

    -d    显示系统所有硬盘设备在采样时间内的使用状态。

    -r    显示系统内存在采样时间内的使用情况。

    -b    显示缓冲区在采样时间内的使用情况。

    -v    显示 inode 节点、文件和其他内核表的统计信息。

    -n    显示网络运行状态，此选项后可跟 DEV（显示网络接口信息）、EDEV（显示网络错误的统计数据）、SOCK（显示套接字信息）和 FULL（等同于使用 DEV、EDEV和SOCK）等，有关更多的选项，可通过执行 man sar 命令查看。

    -q    显示运行列表中的进程数、进程大小、系统平均负载等。

    -R    显示进程在采样时的活动情况。

    -y    显示终端设备在采样时间的活动情况。

    -w    显示系统交换活动在采样时间内的状态。

#### 先找 sys 或 iowait 字段的值高的

按cpu查看

    $ sar -P ALL 5 3
    Linux 5.10.103-v7l+ (your_host)     27/07/22        _armv7l_        (4 CPU)

    18:47:10        CPU     %user     %nice   %system   %iowait    %steal     %idle
    18:47:14        all      0.25      0.00      1.31      0.00      0.00     98.44
    18:47:14          0      0.75      0.00      0.75      0.00      0.00     98.49
    18:47:14          1      0.00      0.00      1.99      0.00      0.00     98.01
    18:47:14          2      0.00      0.00      1.26      0.00      0.00     98.74
    18:47:14          3      0.25      0.00      1.25      0.00      0.00     98.50

    Average:        CPU     %user     %nice   %system   %iowait    %steal     %idle
    Average:        all      0.30      0.00      1.10      0.00      0.00     98.60
    Average:          0      0.00      0.00      1.01      0.00      0.00     98.99
    Average:          1      0.20      0.00      1.20      0.00      0.00     98.60
    Average:          2      0.60      0.00      1.00      0.00      0.00     98.40
    Average:          3      0.40      0.00      1.20      0.00      0.00     98.40

    $ mpstat -P ALL 5 3
    Linux 5.10.103-v7l+ (your_host)     27/07/22        _armv7l_        (4 CPU)

    18:28:58     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
    18:29:03     all    0.40    0.00    1.35    0.00    0.00    0.00    0.00    0.00    0.00   98.25
    18:29:03       0    0.40    0.00    1.40    0.00    0.00    0.00    0.00    0.00    0.00   98.20
    18:29:03       1    0.40    0.00    1.20    0.00    0.00    0.00    0.00    0.00    0.00   98.40
    18:29:03       2    0.60    0.00    1.81    0.00    0.00    0.00    0.00    0.00    0.00   97.59
    18:29:03       3    0.20    0.00    1.00    0.00    0.00    0.00    0.00    0.00    0.00   98.80

按执行的进程查看

    $ pidstat -u 5 3
    Linux 5.10.103-v7l+ (your_host)     27/07/22        _armv7l_        (4 CPU)

    18:29:59      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command
    18:30:04     1000      1033    0.20    0.20    0.00    0.00    0.40     2  tmux: server
    18:30:04        0      6738    0.00    0.20    0.00    0.00    0.20     3  kworker/3:2-events
    18:30:04        0      9559    0.00    0.20    0.00    0.00    0.20     1  kworker/1:2-events
    18:30:04        0     17923    0.20    0.00    0.00    0.00    0.20     0  kworker/0:1-mm_percpu_wq
    18:30:04        0     18227    0.00    0.20    0.00    0.20    0.20     2  kworker/2:3-events
    18:30:04     1000     21584    0.59    0.79    0.00    0.00    1.39     2  pidstat
    18:30:04     1000     27015    0.20    0.20    0.00    0.00    0.40     1  watch
    18:30:04     1000     27157    0.00    0.40    0.00    0.00    0.40     2  top
    18:30:04     1000     29113    0.59    0.20    0.00    0.00    0.79     2  watch

#### 再找io流量高的

属性值说明:

    tps：每秒从物理磁盘 I/O 的次数。注意，多个逻辑请求会被合并为一个 I/O 磁盘请求，一次传输的大小是不确定的；

    kB_read/s：每秒从设备（drive expressed）读取的数据量；

    kB_wrtn/s：每秒向设备（drive expressed）写入的数据量；

    kB_read：  读取的总数据量；

    kB_wrtn：写入的总数量数据量；

    rd_sec/s：每秒读扇区的次数；

    wr_sec/s：每秒写扇区的次数；

    avgrq-sz：平均每次设备 I/O 操作的数据大小（扇区）；

    avgqu-sz：磁盘请求队列的平均长度；

    await：从请求磁盘操作到系统完成处理，每次请求的平均消耗时间，包括请求队列等待时间，单位是毫秒（1 秒=1000 毫秒）；

    svctm：系统处理每次请求的平均时间，不包括在请求队列中消耗的时间；

    %util：I/O 请求占 CPU 的百分比，比率越大，说明越饱和。

按硬盘

    $ sar -d 2 5
    Linux 5.10.103-v7l+ (your_host)     28/07/22        _armv7l_        (4 CPU)

    19:03:12          DEV       tps     rkB/s     wkB/s   areq-sz    aqu-sz     await     svctm     %util
    19:03:14     dev179-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    19:03:16     dev179-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    19:03:18     dev179-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    19:03:20     dev179-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    19:03:22     dev179-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    Average:     dev179-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

按磁盘

    $ iostat -d 2
    Linux 5.10.103-v7l+ (your_host)     27/07/22        _armv7l_        (4 CPU)

    Device             tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
    mmcblk0           0.11         3.15         0.76     291600      70233

    Device             tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
    mmcblk0           0.00         0.00         0.00          0          0

    Device             tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
    mmcblk0           0.00         0.00         0.00          0          0

看网络，按设备

    $ sar -n DEV 5 3
    Linux 5.10.103-v7l+ (jn-zh)     31/07/22        _armv7l_        (4 CPU)

    15:00:42        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
    15:00:47           lo      0.40      0.40      0.05      0.05      0.00      0.00      0.00      0.00
    15:00:47         eth0      0.60      0.20      0.04      0.04      0.00      0.00      0.00      0.00
    15:00:47        wlan0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    15:00:47      docker0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

    Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
    Average:           lo      5.27      5.27      0.71      0.71      0.00      0.00      0.00      0.00
    Average:         eth0      1.73      1.40      0.12      0.48      0.00      0.00      0.00      0.00
    Average:        wlan0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    Average:      docker0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

看tcp流量情况

    $ sar -n TCP,ETCP 1
    Linux 5.10.103-v7l+ (your_host)     28/07/22        _armv7l_        (4 CPU)


    19:04:05     active/s passive/s    iseg/s    oseg/s
    19:04:06         0.00      0.00      9.00      7.00

    19:04:05     atmptf/s  estres/s retrans/s isegerr/s   orsts/s
    19:04:06         0.00      0.00      0.00      0.00      0.00

    19:04:06     active/s passive/s    iseg/s    oseg/s
    19:04:07         0.00      0.00      8.00      8.00

    19:04:06     atmptf/s  estres/s retrans/s isegerr/s   orsts/s
    19:04:07         0.00      0.00      0.00      0.00      0.00

    19:04:07     active/s passive/s    iseg/s    oseg/s
    19:04:08         0.00      0.00      5.00      5.00

    19:04:07     atmptf/s  estres/s retrans/s isegerr/s   orsts/s
    19:04:08         0.00      0.00      0.00      0.00      0.00

#### 可显示指定日期指定项目的信息

    # 网络
    sar -n DEV -f /var/log/sysstat/sa27 | less

#### 看内存占用

    $ pmap -d 1033
    1033:   tmux
    Address   Kbytes Mode  Offset           Device    Mapping
    00010000     416 r-x-- 0000000000000000 0b3:00002 tmux
    00087000       4 r---- 0000000000067000 0b3:00002 tmux
    00088000       4 rw--- 0000000000068000 0b3:00002 tmux
    00089000      16 rw--- 0000000000000000 000:00000   [ anon ]
    01a8a000     132 rw--- 0000000000000000 000:00000   [ anon ]
    01aab000     904 rw--- 0000000000000000 000:00000   [ anon ]
    b67d5000      36 r-x-- 0000000000000000 0b3:00002 libnss_files-2.28.so
    b67de000      64 ----- 0000000000009000 0b3:00002 libnss_files-2.28.so
    b67ee000       4 r---- 0000000000009000 0b3:00002 libnss_files-2.28.so
    b67ef000       4 rw--- 000000000000a000 0b3:00002 libnss_files-2.28.so
    ffff0000       4 r-x-- 0000000000000000 000:00000   [ anon ]
    mapped: 9160K    writeable/private: 1296K    shared: 28K

最后一行非常重要：

    mapped: 9160K 映射到文件的内存量
    writeable/private: 1296K 私有地址空间
    shared: 28K 此进程与其他进程共享的地址空间

## 查看端口占用

使用 ss 命令，比 netstat 命令看的信息更多

    # ss -aw 查看raw端口
    # ss -au 查看udp端口
    # 查看tcp端口
    ss -at

    # 已经建立连接的http端口
    ss -o state established '( dport = :http or sport = :http )'

state FILTER-NAME-HERE, Where FILTER-NAME-HERE can be any one of the following

    established
    syn-sent
    syn-recv
    fin-wait-1
    fin-wait-2
    time-wait
    closed
    close-wait
    last-ack
    listen
    closing
    all : All of the above states
    connected : All the states except for listen and closed
    synchronized : All the connected states except for syn-sent
    bucket : Show states, which are maintained as minisockets, i.e. time-wait and syn-recv.
    big : Opposite to bucket state.

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

    https://www.ruanyifeng.com/blog/2016/02/linux-daemon.html

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
