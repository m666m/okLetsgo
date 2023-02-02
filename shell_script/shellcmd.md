# unix/linux 常用 shell 编程

非常好用的 shell 语句分析器，输入语句就能给出说明

    https://explainshell.com/explain?cmd=join+-1+1+-2+5++%3C%28file+*+%7C+sed+%27s%2F%5B%3A%2C%5D%2F%2Fg%27%29+%3C%28ls+--full-time+-h+%7C+awk+%27%7Bprint+%245%22+%22%246%22+%22%247%22+%22%248%22+%22%249%7D%27%29+%7C+column+-t

参考

    Debian 参考手册

        https://www.debian.org/doc/manuals/debian-reference/index.zh-cn.html

    Advanced Bash-Scripting Guide

        https://tldp.org/LDP/abs/html/index.html

    Bash scripting cheatsheet

        https://devhints.io/bash

    Bash脚本指南

        https://linux.die.net/abs-guide/
            https://linux.die.net/

    Bash 使用技巧
        https://github.com/jlevy/the-art-of-command-line

        $ curl -sL https://github.com/jlevy/the-art-of-command-line/raw/master/README.md|egrep -o '`\w+`'|tr -d '`'|cowsay -W70
        _______________________________________________________________________
        / apt yum dnf pacman pip brew nano vi man apropos help jobs fg bg kill  \
        | ssh ls less head tail ln chown chmod du df mount fdisk mkfs lsblk ip  |
        | ls tail awk sed gawk gsed perl sw_vers wmic ping ipconfig tracert     |
        \ netstat Rundll32 mintty cygstart regtool cygpath                      /
        -----------------------------------------------------------------------
                \   ^__^
                \   (oo)\_______
                    (__)\       )\/\
                        ||----w |
                        ||     ||

## dash 和 bash

    https://www.cnblogs.com/macrored/p/11548347.html

GNU/Linux 操作系统中的 /bin/sh 是 bash（Bourne-Again Shell）的符号链接，但鉴于 bash 过于复杂，有人把 ash 从 NetBSD 移植到 Linux 并更名为 dash（Debian Almquist Shell），并建议将 /bin/sh 指向它，以获得更快的脚本执行速度。

在 Debian 和 Ubuntu 中，/bin/sh 默认指向 dash。如需要更换，执行命令 `sudo dpkg-reconfigure dash` 即可。

按照惯例（以及很多写脚本的规范），标记为 “#!/bin/sh” 的脚本不应使用任何 POSIX 没有规定的特性，这样的脚本用 dash 执行是没问题的。使用 bash 特性的脚本要使用 “#!/bin/bash”。

在理论上，这样应该没有任何副作用。但是现实中，Linux 下的很多（不规范的）脚本有所谓 bashism，却在文件头标记为“#!/bin/sh”，导致 dash 去执行该脚本而报错。有人把脚本失败归咎于 Ubuntu 而不是自己的脚本，这是不公平的：或者把你的脚本首行 shebang 改为 “#!/bin/bash”，或者命令行执行指定解释器 `bash you_script.sh` 。

dash 和 bash 语法上的主要的区别有:

    1. 定义函数
    bash: function在bash中为关键字
    dash: dash中没有function这个关键字

    2. select var in list; do command; done
    bash:支持
    dash:不支持, 替代方法:采用while+read+case来实现

    3. echo {0..10}
    bash:支持{n..m}展开
    dash:不支持，替代方法, 采用seq外部命令

    4. here string
    bash:支持here string
    dash:不支持, 替代方法:可采用here documents

    5. >&word重定向标准输出和标准错误
    bash: 当word为非数字时，>&word变成重定向标准错误和标准输出到文件word
    dash: >&word, word不支持非数字, 替代方法: >word 2>&1;
          bash 常见用法 `your_cmd &>/dev/null` 改写为更兼容的写法 `your_cmd >/dev/null 2>&1`

    6. 数组
    bash: 支持数组, bash4支持关联数组
    dash: 不支持数组，替代方法, 采用变量名+序号来实现类似的效果

    7. 子字符串扩展
    bash: 支持parameter:offset:length,parameter:offset:length,{parameter:offset}
    dash: 不支持， 替代方法:采用expr或cut外部命令代替

    8. 大小写转换
    bash: 支持parameterpattern,parameterpattern,{parameter^^pattern},parameter,pattern,parameter,pattern,{parameter,,pattern}
    dash: 不支持，替代方法:采用tr/sed/awk等外部命令转换

    9. 进程替换<(command), >(command)
    bash: 支持进程替换
    dash: 不支持, 替代方法, 通过临时文件中转

    10. [ string1 = string2 ] 和 [ string1 == string2 ]
    bash: 支持两者
    dash: 只支持=

    11. [[ 加强版test
    bash: 支持[[ ]], 可实现正则匹配等强大功能
    dash: 不支持[[ ]], 替代方法，采用外部命令

    12. for (( expr1 ; expr2 ; expr3 )) ; do list ; done
    bash: 支持C语言格式的for循环
    dash: 不支持该格式的for, 替代方法，用while+((expression))实现13.let命令和((expression))bash:有内置命令let,也支持((expression))方式dash:不支持，替代方法，采用((expression))实现13.let命令和((expression))bash:有内置命令let,也支持((expression))方式dash:不支持，替代方法，采用((expression))或者外部命令做计算

    13. $((expression))
    bash: 支持id++,id–,++id,–id这样到表达式
    dash: 不支持++,–, 替代方法:id+=1,id-=1, id=id+1,id=id-1

    14. 其它常用命令
    bash: 支持 echo -e, 支持 declare
    dash: 不支持。

## bash 常见符号用法

    https://linux.cn/article-5657-1.html

    http://c.biancheng.net/view/743.html
    https://www.jb51.net/article/123081.htm

用完后记得清除变量，防止大规模脚本中容易发生的变量名污染

    unset variable_name

或在函数中使用 local var="hell"来定义局部变量

把语句放到()中包围可以减小变量影响范围：

    (umask 077; ssh-agent >| "$env")

单引号包围不解释变量，双引号包围的解释变量

    var="hello"
    var1='say $var'
    var2="say $var"

反引号``和$()的作用相同，用于命令替换(command substitution)，即完成引用的命令的执行，将其结果替换出来

    echo `date '--date=1 hour ago' +%Y-%m-%d-%H`
    echo $(date '--date=1 hour ago' +%Y-%m-%d-%H)

$()中只需要使用一个反斜杠进行转义，下列语句表示给var变量赋值，字符串$HOME，只是字符串，不是变量HOME的值

    var2=`echo \\$HOME`
    var3=$(echo \$HOME)

${var}用于明确界定变量，与$var并没有区别，但是界定更清晰

    A="to"
    echo $AB 不如 echo ${A}B

变量 ZSH_CUSTOM 有值就用，没有就用后面的，这个用法是zsh的

    # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
    echo ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

字符串截取

    url="abcdefgh"
    echo ${url: 2: 5}

    显示 cdefg

将整数运算表达式放在((和))之间，在 (( )) 中使用变量无需加$前缀

    ((b=a-15))  # 将 a-15 的运算结果赋值给变量 b

需要输出表达式的运算结果时，需在 (( )) 前面加$符号

    c=$((a+b))
    echo $((a+b))
    ((a>7 && b==c))  # 也可以做逻辑运算
    ((a=3+5, b=a+10))  # 以最后一个表达式的值作为整个 (( )) 命令的执行结果

    # 这种用法bash报错，仅zsh支持
    if (( $#SSH_CONNECATION )); then echo 'remote'; fi

let 命令和双小括号 (( )) 的用法是类似的，对于多个表达式之间的分隔符，let 和 (( )) 是有区别的：
let 命令以空格来分隔多个表达式；
(( )) 以逗号,来分隔多个表达式。

test支持3类检测：文件、数值、字符串.
判断 expression 成立时，退出状态为 0，否则为非 0 值。
当你在 test 命令中使用变量时，强烈建议将变量用双引号""包围起来，这样能避免变量为空值时导致的很多奇葩问题。

test 和 [] 是等价的，[] 注意两边留空格

    [ -z "$str1" -o -z "$str2" ]

    [ -z "$str1" ] || [ -z "$str2" ]

能做字符串比较的时候，不要用数值比较。

    不好 [ "$a" -eq 7 ] 如果变量a为空则语句执行会报错
    好   [ "$a" = "7" ]

    最安全：当变量可能为空的时候，强烈建议在变量的基础上加上其他辅助字符串，参见 /etc/init.d/ 下的脚本

    [ "a$a" = "a7" ]   # 判断a是否为7

    [ "a$a" = "a" ]    # 判断a是否为空

    [ ! -z "$a" -a "a$a" = "a7" ]  # a不为空且a=7时才为真

[[ ]] 是 test 的升级版
[[ ]] 注意两边留空格

    # 不需要对变量名加双引号
    if [[ -z $str1 ]] || [[ -z $str2 ]]; then
        echo "字符串不能为空"

    elif [[ $str1 < $str2 ]]  # 不需要也不能对 < 进行转义
    then
        echo "str1 < str2"

    else
        echo "str1 >= str2"
    fi

    # 判断命令执行结果的字符串比较
    if [[ $(systemctl is-active 'nginx') = "active" ]]; then
        echo -e "nginx     [ ✓ ]"
    fi

组合使用 && 、 || 可以实现简单的 if ...else...

    # 数值判断用 (( ))
    (($LOAD_AVG_THLOD > 10)) && echo "greater than" || echo "not..."

    # 字符串判断用 [[ ]]

    # 如果是判断字符串是否有值，则 -n 可以省略
    [[ $envname ]] && printf "conda:%s" $envname || echo "not..."

    如果变量存在则执行，否则不执行
    [[ -n $conda_env_exist ]] && printf "conda:%s" $envname

如果条件测试成功则执行

    [ -r /etc/default/cron ] && . /etc/default/cron

如果条件测试成功则执行，否则执行另一个

    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

如果条件测试失败则执行，否则不执行

    test -f $DAEMON || echo "文件不存在，退出，不再执行下面的语句了"

从本质上讲，if 检测的是命令的退出状态，下面的判断跳转就无法使用 test 命令（或许 zsh 支持）

    # 如果命令存在则执行
    if $(which vcgencmd >/dev/null 2>&1) ; then vcgencmd measure_temp; fi
    # 等价
    which vcgencmd >/dev/null 2>&1 && vcgencmd measure_temp

    # 如果命令不存在则退出
    which vcgencmd >/dev/null 2>&1 || return 0

    # 如果执行命令的结果是失败，则打印
    if ! $(which vcgencmd >/dev/null 2>&1) ; then printf "%s" 'error cmd'; fi

    which vcgencmd >/dev/null 2>&1 || echo "不是树莓派，exit,终止执行之后的语句"

    # 执行命令，如果成功则执行xxx，否则执行yyy
    $(lscpu |grep -q arm) && echo "xxx" || echo "yyy"

使用逻辑运算符将多个 [[ ]] 连接起来依然是可以的，因为这是 Shell 本身提供的功能，跟 [[ ]] 或者 test 没有关系，如下所示：

    [[ -z $str1 ]] || [[ -z $str2 ]]

 -（减号） 的作用是代表标准输出/标准输入, 视命令而定

    # 把 /home 目录压缩，输出到标准输入流，管道后面的命令是从标准输出流读取数据解压
    tar -cvf - /home | tar -xvf -

大括号拓展

    $ ls {ex1,ex2}.sh
    ex1.sh ex2.sh

    $ ls {ex{1..3},ex4}.sh
    ex1.sh ex2.sh ex3.sh ex4.sh

    $ ls {ex[1-3],ex4}.sh
    ex1.sh ex2.sh ex3.sh ex4.sh

数组用法

    A="a b c def"   # 定义字符串
    A=(a b c def)   # 定义字符数组

    命令    解释    结果
    ${A[@]}    返回数组全部元素    a b c def
    ${A[*]}    同上    a b c def
    ${A[0]}    返回数组第一个元素    a
    ${#A[@]}    返回数组元素总个数    4
    ${#A[*]}    同上    4
    ${#A[3]}    返回第四个元素的长度，即def的长度    3
    A[3]=xzy    则是将第四个组数重新定义为 xyz

    变量展开的用法见下面 ${变量名[@]}

不想有任何输出，或只想测试命令的退出码而不想有任何输出时

    cat $filename >/dev/null 2>/dev/null

想让函数返回值

    fff()
    {echo 'abc'}

    print fff

## Bash内建命令

用 `set` 显示当前所有变量的定义，以及 `source xxx` 等执行后的函数里的变量和函数定义

用 `type 命令` 来判断这个命令到底是可执行文件、shell 内置命令还是别名

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

## bash 快捷键

linux下shell终端里有行编辑功能，在命令提示符下默认可以像 emacs 一样编辑输入的命令。

可改为 vi 模式

    # 命令行开启 vi 模式，按esc后用vi中的上下键选择历史命令
    set -o vi

    # 使用默认的 emacs 模式
    set -o emacs

执行 `man readline` 可以查看 Bash 中的默认快捷键，emacs 模式

    Tab 键    自动补全命令

    按住ctrl按x再按e    在编辑器中打开命令行，如果是vi模式则是同时按 esc 和 v

    Ctrl+c    中断，终结一个前台作业。
    Ctrl+Z    暂停一个前台的作业，详见章节 [后知后觉发现一个命令要执行很久，半路让它改成后台执行]

    Ctrl+d    “EOF” (文件结尾：end of file)。它用于表示标准输入（stdin）的结束。在控制台或xterm 窗口输入文本时，CTRL-D 删除在光标下的字符。从一个shell中退出 (类似于exit)。如果没有字符存在，CTRL-D 则会登出该会话。在一个xterm窗口中，则会产生关闭此窗口的效果。

    Ctrl+r    回溯搜索(Backwards search)history缓冲区内的文本（在命令行下）。注意：按下之后，提示符会变成(reverse-i-search)”:输入的搜索内容出现在单引号内，同时冒号后面出现最近最匹配的历史命令。重复按下 ctrl-r 会向后查找匹配项，按下 Enter 键会执行当前匹配的命令，而按下右方向键会将匹配项放入当前行中，不会直接执行，以便做出修改
    Ctrl+s    向前搜索历史记录
    Alt+r     撤销对从历史记录中带来的命令的修改

    Ctrl+p    显示上一条命令
    Ctrl+n    显示下一条命令

    Ctrl+a    移动光标到行首
    Ctrl+e    移动光标到行尾

    Ctrl+b    光标后退一个字符
    Ctrl+f    光标前进一个字符

    Alt+b     光标往回跳一个词
    Alt+f     光标往前跳一个词

    Ctrl+h    擦除(Rubout)(破坏性的退格)。在光标往回移动的时候，同时擦除光标前的一个字符。
    Ctrl+u    擦除光标前的所有字符
    Ctrl+k    删除光标后的所有字符
    Ctrl+w    删除光标前的一个单词
    Ctrl+y    将之前已经清除的文本粘贴回来（主要针对CTRL-U或CTRL-W）。

    Ctrl+/    撤消操作，Undo。

    Ctrl+l     清空屏幕并重新显示当前行，比用 clear 命令更方便。

## 常用脚本收集

目录 shell_script 下是写的不错的脚本示例

    https://github.com/jacyl4/de_GWD
    https://github.com/acmesh-official/acme.sh

当前shell脚本解释器

    $  cat /etc/shells
    # /etc/shells: valid login shells
    /bin/sh
    /bin/bash
    /usr/bin/bash
    /bin/rbash
    /usr/bin/rbash
    /bin/dash
    /usr/bin/dash
    /usr/bin/tmux
    /usr/bin/screen

系统级默认/bin/sh，用户登陆默认/bin/bash，一般写脚本文件应该明确用哪个解释器执行，在第一行： #!/bin/bash 。

```shell
#!/usr/bin/env python3  # 按照PATH寻找第一个python3程序来执行
#!/bin/bash 注意：在#!和/bin/bash间不要有空格，有些Linux系统遇到空格就不会执行后面的/bin/bash了，但是不会提示使用了默认的 $SHELL，而两种解释器之间细微的语法区别，偶尔会出现让人摸不到头脑的报错，要尽量避免这个麻烦
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
# 文字颜色生成模板 https://ciembor.github.io/4bit
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


#############################################
#
# cat 生成一段代码到文件，文本当中带有变量也会被解析，除非结束符用单引号包围 'EOFA'
# EOFA 必须顶行写，前面不能有制表符或者空格，结束输入还得 ctrl+d
# https://askubuntu.com/questions/858238/eof-in-cat-and-less
cat >/etc/network/if-pre-up.d/restore_my_iptables_rule << EOFA
#!/bin/sh
iptables -F
iptables-restore < /etc/iptables/rules.v4
EOFA

# 除非用 <<-
if [ -e ~/.bash_profile ]; then
    cat >abc.txt <<- EOF
        ABC
        DEF
        G
        EOF
fi

#############################################
#
# 打印多行命令并执行，注意 ${变量名[@]} 的用法
readonly IPV6_RESERVED_IPADDRS=(
    ::/128
    ::1/128
    ::ffff:0:0/96
    ::ffff:0:0:0/96
    64:ff9b::/96
    100::/64
    2001::/32
    2001:20::/28
    2001:db8::/32
    2002::/16
    fc00::/7
    fe80::/10
    ff00::/8
)
for private_addr in "${IPV6_RESERVED_IPADDRS[@]}" ; do $(ip6tables -t mangle -A VVTAB -d $private_addr -j RETURN); done

#################################################
#
# 判断语句包装
is_ipv4_address() {
    [ $(grep -Ec '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' <<<"$1") -ne 0 ]
}

#################################################
# case
case "$platform" in
  'darwin arm64');;
  'darwin x86_64');;
  'linux aarch64');;
  'linux armv6l');;
  'linux armv7l');;
  'linux armv8l');;
  'linux x86_64');;
  'linux i686');;
  *)
    >&2 'printf' '\033[33mz4h\033[0m: sorry, unsupported platform: \033[31m%s\033[0m\n' "$platform"
    'exit' '1'
  ;;
esac

```

## 环境变量文件的说明

系统级

    /etc/profile
        --> /etc/bash.bashrc
        --> /etc/profile.d

用户级

    ~/.profile 或 ~/.bash_profile
        --> $HOME/.bashrc
                --> /etc/bashrc

Bash 的命令提示符、ls 和 grep 命令的默认彩色显示在 ~/.bashrc 的代码中进行了设置

```shell

if [ -x /usr/bin/dircolors ]; then

    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

```

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

## 当前shell和嵌套层数

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

## 用户切换和提权：su 和 sudo

    https://blog.csdn.net/mutou990/article/details/107724302

su 是 switch user 切换用户的简写，需要校验密码。一般使用 `su - username`，还有个 `su username`。

`su - username` 是 `su --login username` 或 `su -l` 的简写，执行用户的配置文件，等同于该用户登陆shell：切换用户，同时切换到新用户的环境，变更工作目录，以及HOME，SHELL，USER，LOGNAME，也会变更PATH变量。比如从 root 用户切换到数据库用户，就可以使用数据库管理工具进行数据库维护了。如果 `su -` 不指定用户，则默认转换到 root 用户。

`su   username` 仅切换用户，不执行用户的配置文件，不改变原用户的工作目录，及其他环境变量目录，使用后会进入一个新shell。如果是两个普通权限的用户切换，注意切换后的目录下未必有权限，因为这个目录是切换前那个用户可以操作的路径。这个命令的使用场景一般是普通用户提权，比如数据库用户使用中需要修改系统配置，提权到 root 用户，但是保留数据库用户的环境，以便可以继续使用数据库工具等。

sudo 是一种权限管理机制，依赖于/etc/sudoers，其授权某些普通用户，能够以管理员的身份执行命令。有 sudo 权限的用户，临时提权到 root 用户，用于为了频繁的执行某些只有超级用户才能执行的权限，而不用每次输入密码。一般用法是 `sudo command`，下面的两个用法可以直接切换 shell 环境的用户：

`sudo -i` 是 `sudo --login` 的简写，执行 root 用户的配置文件，等同于该用户登陆shell：执行该命令后提示符变为“#”而不是“$”。运行结果 PWD=/root 。另有 `sudo su -` 切换root身份，执行 root 用户配置文件。效果等同于`sudo -i`。

`sudo su` 表示前用户暂时申请root权限，所以输入的不是root用户密码，而是当前用户的密码。不执行 root 用户的配置文件，运行结果 PWD=/home/用户名（当前用户主目录） 。

以上用法，都是在shell环境下切换用户，要返回上一个用户时，执行退出命令 `exit` 或 `logout` 或 Ctrl+d 即可。

查看区别

    $ cd
    some_user@yourhost:~$

    $ sudo su
    root@your_host:/home/some_user# exit

    $  sudo su -
    root@your_host:~# exit

    $ sudo -i
    root@your_host:~# exit

有 sudo 权限的用户免密码切换到其它用户

    user@your_server:~ $ sudo su
    root@your_server:/home/user# su - git
    git@your_server:~ $

## 查看操作系统信息

hostnamectl 查看主机名及操作系统信息 (依赖安装了 systemd)

    $ hostnamectl
    Static hostname: vmsos-1.localdomain
            Icon name: computer-vm
            Chassis: vm
            Machine ID: xxxxxxxxx
            Boot ID: xxxxxxxxx
        Virtualization: kvm
    Operating System: CentOS Linux 7 (Core)
        CPE OS Name: cpe:/o:centos:centos:7
                Kernel: Linux 5.6.11-1.el7.elrepo.x86_64
        Architecture: x86-64

    $ hostnamectl
    Static hostname: hxxxxcom
            Icon name: computer-vm
            Chassis: vm
            Machine ID: xxxxxxxxx
            Boot ID: xxxxxxxxx
        Virtualization: kvm
    Operating System: Debian GNU/Linux 10 (buster)
                Kernel: Linux 4.19.0-20-amd64
        Architecture: x86-64

    $ hostnamectl
    Static hostname: yourpi
            Icon name: computer
            Machine ID: xxxxxxxxx
            Boot ID: xxxxxxxxx
    Operating System: Raspbian GNU/Linux 10 (buster)
                Kernel: Linux 5.10.103-v7l+
        Architecture: arm

内核信息

    $ cat /proc/version
    Linux version 5.6.11-1.el7.elrepo.x86_64 (mockbuild@Build64R7) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-39) (GCC)) #1 SMP Mon May 4 19:40:21 EDT 2020

仅基本的cpu和内核信息

    $ uname -a
    Linux yourhostname 5.6.11-1.el7.elrepo.x86_64 #1 SMP Mon May 4 19:40:21 EDT 2020 x86_64 x86_64 x86_64 GNU/Linux

发行版信息：仅 debian 系

    $ cat /etc/issue
    Debian GNU/Linux 10 \n \l

    $ lsb_release -a
    No LSB modules are available.
    Distributor ID: Debian
    Description:    Debian GNU/Linux 10 (buster)
    Release:        10
    Codename:       buster

发行版信息：仅 RedHat 系

    $ cat /etc/redhat-release
    CentOS Linux release 7.8.2003 (Core)

查看系统信息命令，另参见章节 [Bash内建命令]

    https://blog.csdn.net/qq_31278903/article/details/83146031

    uptime                          查看系统运行时间、用户数、负载

    cat /proc/uptime| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("系统已运行：%d天%d时%d分%d秒",run_days,run_hour,run_minute,run_second)}' 中文显示运行时间

    date -d "$(awk -F. '{print $1}' /proc/uptime) second ago" +"%Y-%m-%d %H:%M:%S"  反算开机时间点

    uname -a                        查看内核/操作系统/CPU信息
    head -n 1 /etc/issue            查看操作系统版本
    getconf LONG_BIT                查看当前操作系统是64还是32位
    lscpu                           查看CPU信息
    cat /proc/cpuinfo               分核查看CPU信息
    hostname                        查看计算机名
    lspci -tv                       列出所有PCI设备
    lsusb -tv                       列出所有USB设备
    lsmod                           列出加载的内核模块
    env                             查看环境变量资源

    crontab -l                      查看当前用户的计划任务服务

    chkconfig –list                 列出所有系统服务
    chkconfig –list | grep on       列出所有启动的系统服务程序
    rpm -qa                         redhat查看所有安装的软件包
    apt list --installed            debian查看所有安装的软件包

    free -m                         查看内存使用量和交换区使用量
    grep MemTotal /proc/meminfo     查看内存总量
    grep MemFree /proc/meminfo      查看空闲内存量

    df -h                           查看各硬盘分区使用情况
    du -sh <目录名>                  查看指定目录的大小
    cat /proc/loadavg               查看系统负载磁盘和分区
    mount | column -t               查看挂接的分区状态
    fdisk -l                        查看所有分区
    swapon -s                       查看所有交换分区
    lsblk                           查看磁盘信息 - 列出所有可用块设备的信息及依赖关系
    hdparm -i /dev/hda              查看磁盘参数(仅适用于IDE设备)
    dmesg | grep IDE                查看启动时IDE设备检测状况网络

    ifconfig                        查看所有网络接口的属性
    iptables -L                     查看防火墙设置
    route -n                        查看路由表
    netstat -lntp                   查看所有监听端口
    netstat -antp                   查看所有已经建立的连接
    netstat -s                      查看网络统计信息进程

    ps -ef                          查看所有进程
    top                             实时显示进程状态用户

    w                               查看活动用户
    id <用户名>                      查看指定用户信息
    last                            查看用户登录日志
    lastb                           查看用户登录失败日志
    cut -d: -f1 /etc/passwd         查看系统所有用户
    cut -d: -f1 /etc/group          查看系统所有组

### /proc目录详解

1./proc目录
Linux 内核提供了一种通过 /proc 文件系统，在运行时访问内核内部数据结构、改变内核设置的机制。proc文件系统是一个伪文件系统，它只存在内存当中，而不占用外存空间。它以文件系统的方式为访问系统内核数据的操作提供接口。

用户和应用程序可以通过proc得到系统的信息，并可以改变内核的某些参数。由于系统的信息，如进程，是动态改变的，所以用户或应用程序读取proc文件时，proc文件系统是动态从系统内核读出所需信息并提交的。下面列出的这些文件或子文件夹，并不是都是在你的系统中存在，这取决于你的内核配置和装载的模块。

2./proc目录的子文件或子文件夹

子目录Sys是可写的，可以通过它来访问或修改内核的参数，而net和scsi则依赖于内核配置。例如，如果系统不支持scsi，则scsi 目录不存在。

    /proc/buddyinfo 每个内存区中的每个order有多少块可用，和内存碎片问题有关
    /proc/cmdline 启动时传递给kernel的参数信息
    /proc/cpuinfo cpu的信息
    /proc/crypto 内核使用的所有已安装的加密密码及细节
    /proc/devices 已经加载的设备并分类
    /proc/dma 已注册使用的ISA DMA频道列表
    /proc/execdomains Linux内核当前支持的execution domains
    /proc/fb 帧缓冲设备列表，包括数量和控制它的驱动
    /proc/filesystems 内核当前支持的文件系统类型
    /proc/interrupts x86架构中的每个IRQ中断数
    /proc/iomem 每个物理设备当前在系统内存中的映射
    /proc/ioports 一个设备的输入输出所使用的注册端口范围
    /proc/kcore 代表系统的物理内存，存储为核心文件格式，里边显示的是字节数，等于RAM大小加上4kb
    /proc/kmsg 记录内核生成的信息，可以通过/sbin/klogd或/bin/dmesg来处理
    /proc/loadavg 根据过去一段时间内CPU和IO的状态得出的负载状态，与uptime命令有关
    /proc/locks 内核锁住的文件列表
    /proc/mdstat 多硬盘，RAID配置信息(md=multiple disks)
    /proc/meminfo RAM使用的相关信息
    /proc/misc 其他的主要设备(设备号为10)上注册的驱动
    /proc/modules 所有加载到内核的模块列表
    /proc/mounts 系统中使用的所有挂载
    /proc/mtrr 系统使用的Memory Type Range Registers (MTRRs)
    /proc/partitions 分区中的块分配信息
    /proc/pci 系统中的PCI设备列表
    /proc/slabinfo 系统中所有活动的 slab 缓存信息
    /proc/stat 所有的CPU活动信息
    /proc/sysrq-trigger 使用echo命令来写这个文件的时候，远程root用户可以执行大多数的系统请求关键命令，就好像在本地终端执行一样。要写入这个文件，需要把/proc/sys/kernel/sysrq不能设置为0。这个文件对root也是不可读的
    /proc/uptime 系统已经运行了多久
    /proc/swaps 交换空间的使用情况
    /proc/version Linux内核版本和gcc版本
    /proc/bus 系统总线(Bus)信息，例如pci/usb等
    /proc/driver 驱动信息
    /proc/fs 文件系统信息
    /proc/ide ide设备信息
    /proc/irq 中断请求设备信息
    /proc/net 网卡设备信息
    /proc/scsi scsi设备信息
    /proc/tty tty设备信息
    /proc/net/dev 显示网络适配器及统计信息
    /proc/vmstat 虚拟内存统计信息
    /proc/vmcore 内核panic时的内存映像
    /proc/diskstats 取得磁盘信息
    /proc/schedstat kernel调度器的统计信息
    /proc/zoneinfo 显示内存空间的统计信息，对分析虚拟内存行为很有用

以下是/proc目录中进程N的信息

    /proc/N pid为N的进程信息
    /proc/N/cmdline 进程启动命令
    /proc/N/cwd 链接到进程当前工作目录
    /proc/N/environ 进程环境变量列表
    /proc/N/exe 链接到进程的执行命令文件
    /proc/N/fd 包含进程相关的所有的文件描述符
    /proc/N/maps 与进程相关的内存映射信息
    /proc/N/mem 指代进程持有的内存，不可读
    /proc/N/root 链接到进程的根目录
    /proc/N/stat 进程的状态
    /proc/N/statm 进程使用的内存的状态
    /proc/N/status 进程状态信息，比stat/statm更具可读性
    /proc/self 链接到当前正在运行的进程

## 进程查看

显示cpu占用情况

    top 按 1 显示各个核的占用，按 P 高亮活动进程，按 A 按资源使用情况排序

    安装 htop 图形化查看cpu占用,可以横向或者纵向滚动浏览进程列表，以便看到所有的进程和完整的命令行

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

ps 命令，注意伯克利写法的参数不用减号，与我们通常用减号的写法有区别，详见 man ps

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
    23597 23598 23598 23598 ?           -1 Ss    1000   0:00 |       \_ ssh-agent /bin/bash
    23597 28982 28982  1054 pts/2    28982 S+       0   0:00 |       \_ sudo rngd -r /dev/urandom -o /dev/random -f -t 1
    28982 28983 28982  1054 pts/2    28982 SLl+     0   0:02 |           \_ rngd -r /dev/urandom -o /dev/random -f -t 1

    # 进程信息，用x显示归属
    $ ps -efx
    PID TTY      STAT   TIME COMMAND
    26577 ?        S      0:06 sshd: pi@pts/0
    26578 pts/0    Ss     0:00  \_ -bash USER=pi LOGNAME=pi HOME=/home/pi PATH=/usr/local/bin:/usr/bin:/bin:/usr/games MAIL=/var/mail/pi SHE
    12445 pts/0    R+     0:00      \_ ps -efx SHELL=/bin/bash NO_AT_BRIDGE=1 PWD=/home/pi LOGNAME=pi XDG_SESSION_TYPE=tty HOME=/home/pi LAN
    10615 ?        Ss    89:40 tmux SHELL=/bin/bash NO_AT_BRIDGE=1 PWD=/home/pi LOGNAME=pi XDG_SESSION_TYPE=tty HOME=/home/pi LANG=en_GB.UTF
    10819 pts/8    Ss     0:00  \_ -bash HOME=/home/pi LANG=en_GB.UTF-8 LOGNAME=pi LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:
    26848 pts/8    S      0:00  |   \_ /bin/bash SHELL=/bin/bash TMUX=/tmp/tmux-1000/default,10615,1 NO_AT_BRIDGE=1 PWD=/home/pi LOGNAME=pi
    26849 ?        Ss     0:00  |       \_ ssh-agent /bin/bash
    26974 pts/8    S+     0:00  |       \_ /usr/lib/autossh/autossh -M ...
    26977 pts/8    S+     0:00  |           \_ /usr/bin/ssh -L ...
    21772 pts/3    Ss+    0:00  \_ -bash HOME=/home/pi LANG=en_GB.UTF-8 LOGNAME=pi LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:
    9901 ?        Ss      0:00 /lib/systemd/systemd --user LANG=en_GB.UTF-8 PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bi
    9902 ?        S       0:00  \_ (sd-pam)

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

    # 显示pid和命令行
    $ pstree -pa
    systemd,1
    ├─agetty,575 -o -p -- \\u --keep-baud 115200,38400,9600 ttyS0 vt220
    ├─agetty,576 -o -p -- \\u --noclear tty1 linux
    ├─alsactl,385 -E HOME=/run/alsa -s -n 19 -c rdaemon
    ├─avahi-daemon,378
    │   └─avahi-daemon,398
    ├─bluetoothd,515
    ├─cron,369 -f
    ├─dbus-daemon,395 --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
    ├─dhcpcd,567 -q -w
    ├─hciattach,508 /dev/serial1 bcm43xx 3000000 flow -
    ├─polkitd,10843 --no-debug
    │   ├─{polkitd},10844
    │   └─{polkitd},10846
    ├─rngd,380 -r /dev/hwrng
    │   ├─{rngd},381
    │   ├─{rngd},382
    │   └─{rngd},383
    ├─rsyslogd,375 -n -iNONE
    │   ├─{rsyslogd},417
    │   ├─{rsyslogd},418
    │   └─{rsyslogd},419

    # 展示指定用户的进程树
    $ pstree pi
    sshd───bash───zsh───tmux: client

    systemd─┬─(sd-pam)
            └─powerline-daemo

    tmux: server─┬─2*[bash───watch]
                ├─bash───htop
                ├─bash───journalctl
                ├─2*[bash───bash─┬─autossh───ssh]
                │                └─ssh-agent]
                ├─bash───cmatrix
                ├─2*[bash]
                ├─bash───zsh───pstree
                └─bash───zsh

    zsh───gitstatusd-linu───8*[{gitstatusd-linu}]

## 查看 io 情况

    Linux 性能分析工具汇总 https://zhuanlan.zhihu.com/p/409237909

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

sar 命令选项    功能

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

用法: sar [ 选项 ] [ <时间间隔> [ <次数> ] ]

    # 统计5秒间隔的所有信息，执行1次
    sar -A 5 1

#### 可视化 sar 数据

    本地文件分析 https://github.com/vlsi/ksar

    在线 https://github.com/sargraph/sargraph.github.io

#### 先找 sys 或 iowait 字段的值高的

按cpu查看

    $ sar -P ALL 5 3
    Linux 5.10.103-v7l+ (your_host)     27/07/22        _armv7l_        (4 CPU)

    18:47:10        CPU     %user     %nice   %system   %iowait    %steal     %idle
    18:47:14        all      0.25      0.00      1.31      0.00      0.00     98.44
    18:47:14          0      0.75      0.00      0.75      0.00      0.00     98.49
    18:47:14          1      0.00      0.00      1.99      0.00      0.00     98.01

    Average:        CPU     %user     %nice   %system   %iowait    %steal     %idle
    Average:        all      0.30      0.00      1.10      0.00      0.00     98.60
    Average:          0      0.00      0.00      1.01      0.00      0.00     98.99
    Average:          1      0.20      0.00      1.20      0.00      0.00     98.60

    $ mpstat -P ALL 5 3
    Linux 5.10.103-v7l+ (your_host)     27/07/22        _armv7l_        (4 CPU)

    18:28:58     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
    18:29:03     all    0.40    0.00    1.35    0.00    0.00    0.00    0.00    0.00    0.00   98.25
    18:29:03       0    0.40    0.00    1.40    0.00    0.00    0.00    0.00    0.00    0.00   98.20
    18:29:03       1    0.40    0.00    1.20    0.00    0.00    0.00    0.00    0.00    0.00   98.40

按执行的进程查看

    $ pidstat -u 5 3
    Linux 5.10.103-v7l+ (your_host)     27/07/22        _armv7l_        (4 CPU)

    18:29:59      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command
    18:30:04     1000      1033    0.20    0.20    0.00    0.00    0.40     2  tmux: server
    18:30:04        0      9559    0.00    0.20    0.00    0.00    0.20     1  kworker/1:2-events
    18:30:04        0     17923    0.20    0.00    0.00    0.00    0.20     0  kworker/0:1-mm_percpu_wq
    18:30:04     1000     21584    0.59    0.79    0.00    0.00    1.39     2  pidstat
    18:30:04     1000     27157    0.00    0.40    0.00    0.00    0.40     2  top

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

    $ iostat -mxz 15
    Linux 5.10.103-v7l+ (jn-zh)     31/10/22        _armv7l_        (4 CPU)

    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            2.72    0.00    3.90    0.05    0.00   93.33

    Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
    mmcblk0          0.01    0.10      0.00      0.00     0.01     0.14  45.41  57.09    9.18  251.38   0.03    37.24    31.96  22.27   0.25

    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            2.39    0.00    3.45    0.02    0.00   94.14

    Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
    mmcblk0          0.00    0.47      0.00      0.00     0.00     0.13   0.00  22.22    0.00    8.43   0.00     0.00     5.14   4.29   0.20

按进程

    $ pidstat -d 1
    Linux 5.10.103-v7l+ (jn-zh)     30/11/22        _armv7l_        (4 CPU)

    11:47:40      UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s iodelay  Command
    11:47:41      UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s iodelay  Command
    11:47:42      UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s iodelay  Command
    11:48:05      UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s iodelay  Command
    11:48:06      UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s iodelay  Command
    11:48:07        0        93     -1.00     -1.00     -1.00       1  jbd2/mmcblk0p2-
    11:48:08      UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s iodelay  Command

    ^C

    Average:      UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s iodelay  Command
    Average:        0        93     -1.00     -1.00     -1.00       0  jbd2/mmcblk0p2-

看网络，按设备

    $ sar -n DEV 5 3
    Linux 5.10.103-v7l+ (your_host)     31/07/22        _armv7l_        (4 CPU)

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

#### 可显示指定日期指定项目的信息

    # 网络
    sar -n DEV -f /var/log/sysstat/sa27 | less

#### 看内存占用

    $ pmap -d 1033
    1033:   tmux
    Address   Kbytes Mode  Offset           Device    Mapping
    00010000     416 r-x-- 0000000000000000 0b3:00002 tmux
    00087000       4 r---- 0000000000067000 0b3:00002 tmux
    01aab000     904 rw--- 0000000000000000 000:00000   [ anon ]
    b67d5000      36 r-x-- 0000000000000000 0b3:00002 libnss_files-2.28.so
    b67de000      64 ----- 0000000000009000 0b3:00002 libnss_files-2.28.so
    ffff0000       4 r-x-- 0000000000000000 000:00000   [ anon ]
    mapped: 9160K    writeable/private: 1296K    shared: 28K

最后一行非常重要：

    mapped: 9160K 映射到文件的内存量
    writeable/private: 1296K 私有地址空间
    shared: 28K 此进程与其他进程共享的地址空间

### 使用 linux-perf 工具包

    https://github.com/brendangregg/perf-tools

    https://developer.aliyun.com/article/65255

    Linux Perf 性能分析工具及火焰图浅析 https://zhuanlan.zhihu.com/p/54276509

Perf 是 Linux kernel 自带的系统性能优化工具。

    # 注意跟当前操作系统的内核版本匹配
    # sudo apt install linux-perf  # apt show 发现是 4.x，而当前已经是5.x了
    # sudo apt install linux-tools

    # 用 apt search 看看是否有这个版本的
    sudo apt install linux-doc-"$(uname -r)"
    sudo apt install linux-tools-"$(uname -r)"

### 火焰图辅助分析

火焰图是一种剖析软件运行状态的工具，它能够快速的将频繁执行的代码路径以图式的形式展现给用户。

    https://zhuanlan.zhihu.com/p/54276509

## 查看文件占用

file 查看文件是shell类型、二进制类型，文本类型等

    $ file .profile
    .profile: UTF-8 Unicode text

    $ file .
    .: directory

    $ file /etc/os-release
    /etc/os-release: symbolic link to ../usr/lib/os-release

    $ file /dev/null
    /dev/null: character special (1/3)

    # cat 查看有很多内容
    $ file /proc/cpuinfo
    /proc/cpuinfo: empty

无论设备、端口、内存句柄等等，一切皆文件。

lsof 查看指定进程号打开的文件（sudo apt install lsof）

    $ sudo lsof -p 28987
    COMMAND   PID USER   FD   TYPE     DEVICE SIZE/OFF    NODE NAME
    nginx   28987 root  cwd    DIR      179,2     4096       2 /
    nginx   28987 root  rtd    DIR      179,2     4096       2 /
    nginx   28987 root  txt    REG      179,2   931072   46275 /usr/sbin/nginx
    nginx   28987 root  mem    REG      179,2   130696  129293 /usr/lib/nginx/modules/ngx_stream_module.so
    nginx   28987 root  mem    REG      179,2    82872  129283 /usr/lib/nginx/modules/ngx_mail_module.so
    ...

stat 查看文件的 inode 情况

    $ stat showimg
    File: ‘showimg’
    Size: 1038            Blocks: 8          IO Block: 4096   regular file
    Device: 802h/2050d      Inode: 291577      Links: 1
    Access: (0664/-rw-rw-r--)  Uid: ( 1000/      uu)   Gid: ( 1000/      uu)
    Access: 2022-11-25 02:00:21.824163803 +0800
    Modify: 2022-11-25 02:00:21.824163803 +0800
    Change: 2022-11-25 02:00:21.824163803 +0800
    Birth: -

df 查看磁盘占用

    # 查看各个文件系统的空间占用情况，主要关注 Avail 段的可用空间
    $ df -h

    Filesystem                    Size  Used Avail Use% Mounted on
    /dev/mapper/dev01-root         75G   58G   14G  82% /
    udev                          2.0G  4.0K  2.0G   1% /dev
    tmpfs                         396M  292K  396M   1% /run
    none                          5.0M     0  5.0M   0% /run/lock
    none                          2.0G  4.0K  2.0G   1% /run/shm
    /dev/sda1                     228M  149M   68M  69% /boot

    # 查看 inode 占用情况，如果小文件过多会看到 IFree 段 为 0，会导致该文件系统上无法新建文件
    $ df -i

    Filesystem                    Inodes   IUsed  IFree IUse% Mounted on
    /dev/mapper/dev01-root       4964352 4964352      0  100% /
    udev                          503779     440 503339    1% /dev
    tmpfs                         506183     353 505830    1% /run
    none                          506183       5 506178    1% /run/lock
    none                          506183       2 506181    1% /run/shm
    /dev/sda1                     124496     255 124241    1% /boot

fuser 查看占用文件的进程号（sudo apt install psmisc）

    $ sudo fuser /usr/lib/nginx/modules/ngx_mail_module.so
    /usr/lib/nginx/modules/ngx_mail_module.so: 28987m 28988m 28989m 28990m 28991m

lsof 列出使用了TCP 或 UDP 协议的文件（sudo apt install lsof）

    $ sudo lsof -i
    COMMAND     PID     USER   FD   TYPE  DEVICE SIZE/OFF NODE NAME
    avahi-dae   371    avahi   12u  IPv4   13904      0t0  UDP *:mdns
    avahi-dae   371    avahi   13u  IPv6   13905      0t0  UDP *:mdns
    avahi-dae   371    avahi   14u  IPv4   13906      0t0  UDP *:57630
    avahi-dae   371    avahi   15u  IPv6   13907      0t0  UDP *:47663
    dhcpcd      556     root   10u  IPv4   13950      0t0  UDP *:bootpc
    dhcpcd      556     root   15u  IPv6 1702269      0t0  UDP *:dhcpv6-client
    sshd        566     root    3u  IPv4   17230      0t0  TCP *:ssh (LISTEN)
    sshd        566     root    4u  IPv6   17240      0t0  TCP *:ssh (LISTEN)
    nginx     28987     root    6u  IPv4 1891872      0t0  TCP *:http (LISTEN)
    nginx     28987     root    7u  IPv6 1891873      0t0  TCP *:http (LISTEN)
    nginx     28988 www-data    6u  IPv4 1891872      0t0  TCP *:http (LISTEN)
    nginx     28989 www-data    7u  IPv6 1891873      0t0  TCP *:http (LISTEN)

## 网络故障排查

    https://www.debian.org/doc/manuals/debian-reference/ch05.zh-cn.html

iproute2 软件包 代替了 net-tools 软件包，详见章节 [iproute2 软件包](init_a_server.md think)。

网卡基本信息查看

    # 代替 ifconfig
    ip a

端口是否可用

    curl -vvv 127.0.0.1:443

    wget 127.0.0.1:443

    ssh -vvv -p 443 127.0.0.1

    telnet 127.0.0.1 443

ss 命令（sudo apt install iproute2），比 netstat 命令看的信息更多

    # 127.0.0.1 只对本机开放
    # 0.0.0.0   外来连接也开放

    # ss -aw 查看raw端口
    # ss -au 查看udp端口

    # 查看tcp端口 等效 `netstat -ant`
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

查看ssh连接数，指定端口号即可

    ss -at | grep -i ':22'

    sudo lsof -i :22

icmp测试网络连通情况

    ping -t 192.168.0.1

    # apt install dnsutils
    whois
    dig/nslookup

    $ nslookup baidu.com
    Non-authoritative answer:
    Server:  192.168.0.1
    Address:  192.168.0.1

    Name:    baidu.com
    Addresses:  220.181.38.148
            220.181.38.251

traceroute 查看路由节点

    # apt install iputils
    $ traceroute www.bing.com
    traceroute to www.bing.com (204.79.197.200), 30 hops max, 60 byte packets
    1  * * *
    2  96.44.162.49.static.quadranet.com (96.44.162.49)  0.852 ms  0.896 ms  0.855 ms
    3  lax1-fatpipe-1.it7.net (69.12.70.232)  1.818 ms lax1-fatpipe-1.it7.net (69.12.70.234)  0.327 ms lax1-fatpipe-1.it7.net (69.12.70.232)  1.711 ms
    4  69.12.69.1 (69.12.69.1)  9.722 ms microsoft.as8075.any2ix.coresite.com (206.72.210.143)  2.802 ms 69.12.69.1 (69.12.69.1)  9.714 ms
    5  * 206.72.211.94.any2ix.coresite.com (206.72.211.94)  1.325 ms *
    6  * * *
    7  * * *
    8  * * *

    # Windows: tracert www.bing.com

查看网关

    $ route -n
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    0.0.0.0         192.168.0.1     0.0.0.0         UG    202    0        0 eth0
    172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
    192.168.0.0     0.0.0.0         255.255.255.0   U     202    0        0 eth0

查看 mtu

    $ sudo apt install iputils-tracepath

    $ tracepath www.baidu.com
    1?: [LOCALHOST]                      pmtu 1500
    1:  192.168.0.1                                           0.554ms
    1:  192.168.0.1                                           0.670ms
    2:  192.168.1.1                                           1.232ms
    3:  192.168.1.1                                           1.182ms pmtu 1492
    3:  39.71.56.1                                            3.526ms
    4:  112.232.166.9                                         3.512ms
    29:  no reply
    30:  no reply
    Too many hops: pmtu 1492
    Resume: pmtu 1492

查看网卡统计信息

    $ ethtool -S eth0
    NIC statistics:
        rx_packets: 1174939
        tx_packets: 2813892
        rx_bytes: 217844784
        tx_bytes: 952958558
        rx_errors: 0
        tx_errors: 0
        rx_dropped: 0
        tx_dropped: 0

网络抓包

tcpdump、wireshark 的常见命令

    https://plantegg.github.io/2022/01/01/%E7%BD%91%E7%BB%9C%E6%8A%93%E5%8C%85%E5%B8%B8%E7%94%A8%E5%91%BD%E4%BB%A4/

用 tcpdump 抓包

    https://zhuanlan.zhihu.com/p/74812069

## 查看日志

    https://ivanzz1001.github.io/records/post/linuxops/2018/04/10/linux-restart-log

查看关机、重启、死机记录

    # 执行等级的改变的时间点，初步排查问题
    $ lastx

    $ last| grep -E -i "crash|down|reboot"
    pi       pts/0        192.168.0.106    Tue Aug  2 17:09 - crash (-19206+09:08)
    pi       pts/5        tmux(2151).%5    Tue Aug  2 04:29 - crash (-19205+20:29)
    pi       pts/4        tmux(2151).%4    Tue Aug  2 04:29 - crash (-19205+20:29)
    pi       pts/3        tmux(2151).%3    Tue Aug  2 04:29 - crash (-19205+20:29)
    pi       pts/2        tmux(2151).%0    Tue Aug  2 04:29 - crash (-19205+20:29)
    pi       pts/1        192.168.0.106    Tue Aug  2 04:09 - crash (-19205+20:09)

查看系统日志，查找内存溢出oom-kill导致的死机

    # cat /var/log/syslog |less
    # cat /var/log/kern.log | less
    grep -i kill /var/log/messages*

    Aug  2 04:51:11 your_host kernel: [ 4683.267560] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/,task=bash,pid=9626,uid=1000
    Aug  2 04:51:11 your_host kernel: [ 4683.269942] oom_reaper: reaped process 9626 (bash), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
    Aug  2 04:51:11 your_host rsyslogd: imuxsock: Acquired UNIX socket '/run/systemd/journal/syslog' (fd 3) from systemd.  [v8.1901.0]
    Aug  2 04:51:11 your_host rsyslogd:  [origin software="rsyslogd" swVersion="8.1901.0" x-pid="19826" x-info="https://www.rsyslog.com"] start
    Aug  2 14:47:31 your_host kernel: [    0.000000] Booting Linux on physical CPU 0x0
    Aug  2 14:47:31 your_host kernel: [    0.000000] Linux version 5.10.103-v7l+ (dom@buildbot) (arm-linux-gnueabihf-gcc-8 (Ubuntu/Linaro 8.4.0-3ubuntu1) 8.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #1529 SMP Tue Mar 8 12:24:00 GMT 2022

查看守护进程的日志，这个在oom死机也有输出

    cat /var/log/daemon.log

对空指针异常的内核死机，暂未找到详细记录的位置 `ls /var/crash`。

对看门狗引发的重启，暂未找到记录日志的位置。

### 手工重启内核SysRq

    https://www.cnblogs.com/ylan2009/articles/2322950.html

    https://www.cnblogs.com/klb561/p/11013746.html

    https://wiki.ubuntu.com/Kernel/CrashdumpRecipe

先要激活内核 sysrq 功能

    # 修改 /etc/sysctl.conf 文件，设置 kernel.sysrq = 1
    echo "1" > /proc/sys/kernel/sysrq

键：Print Screen/SysRq

系统异常时依次按下 alt+sysrq+{reisub} ，然后系统会自动重启。括号内的英文字母需要依次顺序按下，而且每次按下字母后需要间隔 5-10s 再执行下一个动作。（如 alt + SysRq + R，间隔10s 后再按 alt + SysRq + E，以此类推）切记不可快速按下 R-E-I-S-U-B ，否则后果和 扣电池拔电源线无异！

使用 SysRq 重启计算机的方法：

全尺寸键盘

    Alt + SysRq + [R-E-I-S-U-B]

笔记本键盘

    Fn + Alt + SysRq + [R-E-I-S-U-B]

reisub各个序列，需要留出执行时间：

    unRaw – 把键盘设置为 ASCII 模式，使按键可以穿透 x server 捕捉传递给内核

    tErminate – 向除 init 外进程发送 SIGTERM 信号，让其自行结束

    kIll - 向除 init 以外所有进程发送 SIGKILL 信号，强制结束进程

    Sync – 同步缓冲区数据到硬盘，避免数据丢失

    Unmount – 将所有已经挂载的文件系统 重新挂载为只读

    reBoot - 立即重启计算机

拓展：

    # 立即重新启动计算机
    echo "b" > /proc/sysrq-trigger

    # 立即关闭计算机
    echo "o" > /proc/sysrq-trigger

    # 导出内存分配的信息 （可以用/var/log/message 查看）
    echo "m" > /proc/sysrq-trigger

    # 导出当前CPU寄存器信息和标志位的信息
    echo "p" > /proc/sysrq-trigger

    # 导出线程状态信息
    echo "t" > /proc/sysrq-trigger

    # 故意让系统溃
    echo "c" > /proc/sysrq-trigger

    # 立即重新挂载所有的文件系统
    echo "s" > /proc/sysrq-trigger

    # 立即重新挂载所有的文件系统为只读
    echo "u" > /proc/sysrq-trigger

## 后台执行

### nohup

    nohup sleep 3600 &

一般情况下，后台任务不希望出现屏幕打印，需要把程序的输出和异常信息都重定向一下

    nohup [需要执行的命令] >/dev/null 2>&1 &

### 后知后觉发现一个命令要执行很久，半路让它改成后台执行

tmux用一个守护进程打开多个终端窗口实现了一直在后台运行，详见 <gun_tools.md> 的 tmux 章节。

    https://www.ruanyifeng.com/blog/2016/02/linux-daemon.html

如果程序的输出无所谓，你只要程序能继续执行下去就好，典型的例子是你压缩一个文件或者编译一个大软件，中途发现需要花很长时间.

按下 Ctrl-z，让程序进入 suspend 挂起状态。这个时候你应该会回到shell下，看到提示：

    [1]+  Stopped                 xxxx 这样的输出。

上面那个 [] 里的数字，我们记为 n，然后执行：

    # 让暂时停掉的进程在后台运行
    bg %n

    # 后悔了，让暂时停掉的进程在前台运行
    fg %n  # 这样会把我们从shell带回到该程序的界面

执行之前，如果不放心，想确认一下，可以用 jobs 命令看看被 suspend 的任务列表。严格地说，jobs 看的不仅仅是 suspend 的任务，所以，如果你有其他后台任务，也会列出来。

然后再解除你现在的shell跟刚才这个进程的所属关系

    disown

这个时候再执行jobs，就看不到那个进程了，用 ps -ef 可以看到哦。现在就可以关掉终端，下班回家了。

实例

    # 要执行很久的命令，不等了，按下 Ctrl+z 切换回 shell 的命令提示符下
    bash-3.2$ sleep 3600
    ^Z
    [1]+  Stopped                 sleep 3600
    bash-3.2$

    bash-3.2$ jobs
    [1]+  Stopped                 sleep 3600

    # 让后台任务继续运行
    bash-3.2$ bg %1
    [1]+ sleep 3600 &

    bash-3.2$ jobs
    [1]+  Running                 sleep 3600 &

    # 解除当前会话跟后台任务的归属
    bash-3.2$ disown

    # 当前会话没有后台任务了
    bash-3.2$ jobs

    # 其实那个任务还在执行
    bash-3.2$ ps -ef | grep sleep
    501 30787 30419   0  6:00PM ttys000    0:00.00 sleep 3600
    501 33681 30419   0  6:02PM ttys000    0:00.00 grep sleep

    # 退出会话，后台任务不会再跟随关闭了
    bash-3.2$ exit

如果后续又想把这个任务调回前台，需要安装 reptyr

    比 screenify 好用 https://github.com/nelhage/reptyr

最好在 tmux 里执行，这样以后就不用担心遇到这种尴尬了

    reptyr PID
