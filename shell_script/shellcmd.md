# unix/linux 常用 shell 编程

shell 命令文档见章节 [Linux 常用命令行工具](gnu_tools.sh)。

非常好用的 shell 语句分析器，输入语句就能给出说明

    https://explainshell.com/explain?cmd=join+-1+1+-2+5++%3C%28file+*+%7C+sed+%27s%2F%5B%3A%2C%5D%2F%2Fg%27%29+%3C%28ls+--full-time+-h+%7C+awk+%27%7Bprint+%245%22+%22%246%22+%22%247%22+%22%248%22+%22%249%7D%27%29+%7C+column+-t

参考

    bash 内置命令    `man command`

    bash 语法        `man bash`

    条件测试语句的用法  `man test`

    GNU Bash 官方文档

        https://www.gnu.org/software/bash/manual/bash.html

        Debian 把常用的脚本命令都介绍了 https://www.debian.org/doc/manuals/debian-reference/index.zh-cn.html

    bash 系列教程 https://www.junmajinlong.com/shell/index/

    Advanced Bash-Scripting Guide

        https://tldp.org/LDP/abs/html/index.html

    Bash scripting cheatsheet

        https://devhints.io/bash

    https://zwischenzugs.com/2018/01/06/ten-things-i-wish-id-known-about-bash/

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
    bash：function 在 bash 中为关键字
    dash：dash 中没有 function 这个关键字

    2. select var in list; do command; done
    bash：支持
    dash：不支持, 替代方法: 采用 while + read + case 来实现

    3. echo {0..10}
    bash：支持 {n..m} 展开
    dash：不支持，替代方法, 采用 seq 外部命令

    4. here string
    bash：支持 here string
    dash：不支持, 替代方法：可采用 here documents

    5. >&word 重定向标准输出和标准错误
    bash：当 word 为非数字时，>&word 变成重定向标准错误和标准输出到文件 word
    dash：>&word, word 不支持非数字, 替代方法: >word 2>&1;
          bash 常见用法 `your_cmd &>/dev/null` 改写为更兼容的写法 `your_cmd >/dev/null 2>&1`

    6. 数组
    bash：支持数组, bash4 支持关联数组
    dash：不支持数组，替代方法, 采用 “变量名+序号” 来实现类似的效果

    7. 子字符串扩展
    bash：支持 parameter:offset:length,parameter:offset:length,{parameter:offset}
    dash：不支持，替代方法:采用 expr 或 cut 外部命令代替

    8. 大小写转换
    bash：支持 parameterpattern,parameterpattern,{parameter^^pattern},parameter,pattern,parameter,pattern,{parameter,,pattern}
    dash：不支持，替代方法：采用 tr/sed/awk 等外部命令转换

    9. 进程替换 <(command),>(command)
    bash：支持进程替换
    dash：不支持, 替代方法, 通过临时文件中转

    10. [ string1 = string2 ] 和 [ string1 == string2 ]
    bash：支持两者
    dash：只支持=

    11. [[ ]] 加强版test
    bash：支持 [[ ]], 可实现正则匹配等强大功能
    dash：不支持 [[ ]], 替代方法，采用外部命令

    12. for (( expr1 ; expr2 ; expr3 )) ; do list ; done
    bash：支持 C 语言格式的 for 循环
    dash：不支持该格式的 for, 替代方法，用 while+((expression)) 实现

    13.let 命令 和 ((expression))
    bash：有内置命令 let,也支持 ((expression)) 方式
    dash：不支持，替代方法，采用 ((expression)) 实现

    13. $((expression))
    bash：支持 id++,id–,++id,–id 这样到表达式
    dash：不支持 ++,–，替代方法：id+=1,id-=1, id=id+1,id=id-1

    14. 其它常用命令
    bash：支持 echo -e，支持 declare
    dash：不支持。

## bash 常见符号用法

    https://www.runoob.com/w3cnote/linux-shell-brackets-features.html

    https://linux.cn/article-5657-1.html

    http://c.biancheng.net/view/743.html
    https://www.jb51.net/article/123081.htm

    引号和转义 https://www.cnblogs.com/cn-leoblog/p/15415841.html

用完后记得清除变量，防止大规模脚本中容易发生的变量名污染

    unset variable_name

    如果是在函数中使用局部变量，用 `local var="hell"` 来定义

Linux 命令行参数一个杠，俩杠，没杠，参见章节 [压缩解压缩] 中 tar 的说明，或 `man tar` 或 `info tar`。

| 管道操作，命令参数中文件名的位置使用 bash 的特殊符号 -（减号），代表标准输出/标准输入, 视命令而定

    管道前的 - 表示输出到标准输入流，管道后的 - 表示输入为标准输出流，主要用于该命令需要用参数指定输入文件的情况下，如果该命令自带支持管道流，则命令前用管道符号即可。

    # 把 /home 目录打包，输出到标准输入流，管道后面的命令是从标准输出流读取数据解包
    tar cf - /home |tar -xf -

重定向操作符（> 或 >|）用于将命令的输出重定向到文件或其他命令

    对于 >，它会先关闭当前的输出文件描述符，然后再打开文件进行写入。

    而对于 >|，则不会关闭当前的输出文件描述符，而是直接在原有文件描述符上进行写入操作。

把语句放到()中包围可以减小变量影响范围：

    (umask 077; ssh-agent >| "$env")

单引号包围不解释变量，双引号包围的解释变量

    var="hello"
    var1='say $var'
    var2="say $var"

反引号``和$()的作用相同，用于命令替换（command substitution），即完成引用的命令的执行，将其结果替换出来

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

    $ url="abcdefgh"
    $ echo ${url: 2: 5}
    cdefg

    $ myurl='http://www.example.com/long/path/to/example/file.ext'
    $ echo ${myurl##*/}
    file.ext

字符串替换

    $ gaddr='https://github.com/jindaxiang/akshare.git'
    $ echo ${gaddr//https:\/\/github.com\//git@github.com:}
    git@github.com:jindaxiang/akshare.git

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

[[ ]] 是 test 的升级版，不需要对变量名加双引号，比较运算直接用 =、> 等更直观
[[ ]] 注意两边留空格

    https://www.cnblogs.com/aaron-agu/p/5700650.html

    bash把双中括号中的表达式看作一个单独的元素，并返回一个退出状态码

    [ ... ]为shell命令，所以在其中的表达式应是它的命令行参数，所以串比较操作符">" 与"<"必须转义，在[[]]中"<"与">"不需转义

    [[ ... ]]进行算术扩展，而[ ... ]不做

    [[ ... && ... && ...  ]] 和 [ ... -a ... -a ...] 不一样，[[ ]] 是逻辑短路操作，而 [ ] 不会进行逻辑短路

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

字符串判断用 [[ ]]

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
    if $(command -v vcgencmd >/dev/null 2>&1) ; then vcgencmd measure_temp; fi
    # 等价
    command -v vcgencmd >/dev/null 2>&1 && vcgencmd measure_temp

    # 如果命令不存在则退出
    command -v vcgencmd >/dev/null 2>&1 || return 0

    # 如果执行命令的结果是失败，则打印
    if ! $(command -v vcgencmd >/dev/null 2>&1) ; then printf "%s" 'error cmd'; fi

    command -v vcgencmd >/dev/null 2>&1 || echo "不是树莓派，exit,终止执行之后的语句"

    # 执行命令，如果成功则执行xxx，否则执行yyy
    $(lscpu |grep -q arm) && echo "xxx" || echo "yyy"

使用逻辑运算符将多个 [[ ]] 连接起来依然是可以的，这是 Shell 本身提供的功能，跟 [[ ]] 或者 test 没有关系，如下所示：

    [[ -z $str1 ]] || [[ -z $str2 ]]

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

        变量展开的用法示例见下面 ${变量名[@]}

不想有任何输出，或只想测试命令的退出码而不想有任何输出时

    cat $filename >/dev/null 2>/dev/null

想让函数返回字符串，无法使用 return int 的方式

    fff()
    {echo 'abc'}

    print fff

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

## 常用 bash 技巧

    https://plantegg.github.io/2017/01/01/top_linux_commands/

很多命令支持逐级的自动完成提示，输入命令后多按 tab 试试

    $ ls /usr/share/bash-completion/completions

rm 之前先 ls 试试，所谓 dry-run

    ls to_be*

    确认列出的是要删除的文件，然后再做删除

    rm to_be*

清空或创建一个文件

    > file.txt

    touch file.txt

回到上次的目录

    cd -

以 sudo 运行上条命令

    $ vi /etc/hosts
    $ sudo !!

    通常出现的情况是，敲完命令执行后报错才发现忘了 sudo，这个用法比较实用。

带环境变量执行某个命令，常用于程序需要以不同的环境参数执行

    # env 可省
    $ env QT_QPA_PLATFORM=xcb your_command your_param

    # UNIX 写法：
    $ QT_QPA_PLATFORM=xcb;your_command your_param

替换上一条命令中的一个短语

    $ ^foo^bar^

    把上一条命令当中的foo替换成bar。

    $ !!:gs/foo/bar
    重复执行上一条命令，并用 :gs/foo/bar 进行替换操作

在需要重复运行调试一道长长的命令，需要测试某个参数时候，用这个命令会比较实用

大括号展开多个字符串组合

    $ mkdir -p -v /home/user/tmp/{dir1,anotherdir,similardir}

    # 快速备份一个文件
    $ cp filename{,.bak}
    这道命令把 filename 文件拷贝成 filename.bak，我常用 cp -a my{.txt,.txt.2001.1.1}

    # 如果参数 $1 未被提供，那么默认值是 .（当前目录）
    target=${1:-.}
    后续引用变量添加双引号 "$target" 来确保如果 target 包含空格或其他特殊字符时，命令能够正确执行。

重置终端的显示环境，比 `clear` 清的更干净

    如果你试过不小心cat了某个二进制文件，很可能整个终端模拟器就傻掉了，可能不会换行，没法回显，大堆乱码之类的，这时候敲入 reset 回车，不管命令有没有显示，就能回复正常了。

    reset

在一个子shell中运行一个命令

    (cd /tmp && ls)

    好处就是不会改变当前shell的目录，以及如果命令中涉及环境变量，也不会对当前shell有任何更改。

在 bash 中使用以下语法打开 TCP / UDP套接字

    # https://www.xmodulo.com/tcp-udp-socket-bash-shell.html
    # exec {file-descriptor}<>/dev/{protocol}/{host}/{port}

    打开一个双向端口
    $ exec 3<>/dev/tcp/xmodulo.com/80

    关闭输入端口
    $ exec {file-descriptor}<&-

    关闭输出端口
    $ exec {file-descriptor}>&-

用 diff 对比远程文件跟本地文件

    ssh user@host 'cat /path/to/remotefile' |diff /path/to/localfile -

diff 通常的用法是从参数读入两个文件，而命令里面的-则是指从stdin读入了

查找当前shell下是否可以找到某个命令，支持 alias、shell 函数等

    command -v ls  # 这个用法的兼容性最好

    type ls   # 会把 shell 函数的内容也显示出来，方便调试

    which ls  # Debian 下不支持显示 shell 函数的内容

## bash 内建命令

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

    tail -f 的时候冻结、解冻终端界面
    ^s（ctrl + s）将通过执行流量控制命令 XOFF 来停止终端输出内容，这会对 PuTTY 会话和桌面终端窗口产生影响。如果误输入了这个命令，可以使用 ^q（ctrl + q）让终端重新响应。所以只需要记住 ^q 这个组合键就可以了，毕竟这种情况并不多见。

## 环境变量的说明

分系统级生效或用户级，shell 或 gui 各有不同

    https://wiki.archlinux.org/title/Environment_variables

执行 `set` 可以查看当前shell的环境变量和函数设置，便于调试。

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

## Linux 目录和分区

Linux 的目录，有些个是固定用途的，有些是文件系统挂载在这个目录上，有官方的 “文件系统层次结构标准” --- Filesystem Hierarchy Standard(FHS)

    https://www.debian.org/releases/stable/amd64/apcs02.zh-cn.html

    https://refspecs.linuxfoundation.org/fhs.shtml
        https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html

    https://www.freedesktop.org/software/systemd/man/file-hierarchy.html

    https://zhuanlan.zhihu.com/p/107263805

桌面环境也有官方标准，见章节 [Linux 桌面的基本目录规范 XDG（X Desktop Group）](gnu_tools.md)。

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

/boot: 操作系统启动区

/dev：以文件的形式保存 Linux 所有的设备及接口设备

    Linux 里的设备 https://www.debian.org/releases/stable/amd64/apds01.zh-cn.html
    Linux 的许多特殊文件可以在 /dev 目录下找到。这些文件称为设备文件，其行为与普通文件不同。大多数设备文件的类型是块设备和字符设备。这些文件是访问硬件的驱动程序(Linux 内核的一部分)的接口。另外一些，不那么常见的类型，是命名管道(pipe)。下表中列出了最重要的设备文件。

    sda    主板第一个硬盘接口上的硬盘
    sdb    主板第二个硬盘接口上的硬盘
    sda1    第一块硬盘上的第一个分区
    sdb7    第二块硬盘上的第七个分区
    sr0    第一个 CD-ROM
    sr1    第二个 CD-ROM
    ttyS0    串口 0，即 MS-DOS 下的 COM1
    ttyS1    串口 1，即 MS-DOS 下的 COM2
    psaux    PS/2 鼠标设备
    gpmdata    伪设备，中转从 GPM（鼠标）服务传来的数据
    cdrom    指向光驱的符号链接
    mouse    指向鼠标设备文件的符号链接
    null    所有写入该设备的东西都会消失
    zero    可以从该设备永无休止地读出零

    /dev/shm 现在的大多数发行版都会在启动后生成一个内存目录，使用虚拟内存文件系统 tmpfs，挂载在 /dev/shm，用户可以直接使用。tmpfs 在内存不足时会使用 swap 空间，如果安全要求高不允许数据写入持久化存储，不要使用这个目录，也不要使用 tmpfs 文件系统的分区，使用 ramfs 代替它，详见章节 [映射内存目录](init_a_server think)。

/sys：这个目录是一个虚拟文件系统，主要记录与内核相关的信息，与 /proc 目录十分相似

/ 根文件系统，下面内容是根文件系统的一级子目录介绍

    /proc：这个目录是一个虚拟文件系统，它放置的数据都是在内存当中，例如进程、外部设备状态、网络状态等。

    /srv：该目录放置与网络服务相关的文件数据

    /media：放置可删除的设备。

    /mnt：用于暂时挂载某些额外设备。

    /sbin：该目录下放置开机过程中需要的命令，包括开机、修复、还原系统等，软链接到 /usr/sbin。

    /bin：放置执行文件/命令的目录，尤其是放置在单用户维护模式下还能够被操作执行的命令，软链接到 /usr/bin。

    /lib：主要放置系统开机使用的、/bin 和 /sbin 目录下的命令使用的库函数。

    /etc: 系统级配置文件

    /home：系统默认的普通用户的主文件夹。

    /root：root 用户的主目录。

    /usr：发行版的内容基本都在这里，可以理解为 C:/Windows/。

        /usr/man, /usr/info, /usr/doc：手册页、GNU信息文档和各种其他文档文件。

        /usr/include：C编程语言的头文件.为了一致性这实际上应该在/usr/lib 目录下，但传统上支持这个名字.

        /usr/lib：编程用的库(library)保存在这里，理解为 C:/Windows/System32。包含各应用软件的函数库、目标文件，以及一些不被用户惯用的执行文件。除了程序或子系统使用的不变的数据文件，还包括一些 site-wide 配置文件。

        /usr/sbin：根文件系统不必须的系统管理命令，例如大多数服务程序。

        /usr/bin：可执行程序基本都在这里，其它安装到各种路径下(/usr/local/bin) 的软件，也在这里做个软链接，或把程序启动引导脚本程序放置在这里，只要 PATH 变量有这个路径，用户使用该命令时就很方便，不需要指明程序的安装路径。

        /usr/local：这里主要存放那些手动安装的软件，即不是通过 apt 安装的发行版软件。比如，用户自己编译的软件应该安装到这个目录下，用户自行下载的脚本等也应该保存在此处。它和 /usr 目录具有相类似的目录结构。让软件包管理器来管理 /usr 目录，而把自定义的脚本(scripts)放到 /usr/local 目录下面。

            /usr/local/bin：自编译安装的软件的可执行部分在这里

            /usr/local/share：自编译安装的软件的配置文件部分在这里

        /usr/share：放置用户间可以共享使用的数据

            /usr/share/man：联机帮助文件

            /usr/share/doc：软件杂项的文件说明

            /usr/share/zoneinfo：与时区有关的时区档案

    /var 主要放置常态化变动的文件，例如缓存、登录日志文件、软件运行产生的文件等。

        /var/mail/：放置个人电子邮件的目录。

        /var/cache/：应用程序运行过程中产生的暂存文件。

        /var/catman
        当要求格式化时的man页的cache.man页的源文件一般存在/usr/man/man* 中；有些man页可能有预格式化的版本，存在/usr/man/cat* 中.而其他的man页在第一次看时需要格式化，格式化完的版本存在/var/man 中，这样其他人再看相同的页时就无须等待格式化了. (/var/catman 经常被清除，就象清除临时目录一样.)

        /var/spool：放置一些队列数据，包括等待收寄的电子邮件、cron 任务等。每个不同的队列数据在/var/spool 下建立自己的子目录，例如，用户的邮箱在/var/spool/mail 中.

        /var/tmp
        比/tmp 允许的大或需要存在较长时间的临时文件. (虽然系统管理员可能不允许/var/tmp 有很旧的文件.)

        /var/lock/：某些设备或文件要求使用时具有排他性，即上锁，该目录存放锁定文件。许多程序遵循在/var/lock 中产生一个锁定文件的约定，以支持他们正在使用某个特定的设备或文件.其他程序注意到这个锁定文件，将不试图使用这个设备或文件。

        /var/run：到下次引导前有效的关于系统的信息文件。例如，某些程序或者是服务启动后，将它们的 PID 记录在这个目录下，/var/run/utmp 包含当前登录的用户的信息.

        /var/lib：应用程序运行过程中，需要使用到的数据文件放置的目录。

        /var/log：应用程序运行过程中，生成的日志文件，特别是login  (/var/log/wtmp 所有到系统的登录和注销) 和syslog (/var/log/messages) 里存储所有核心和系统程序信息. /var/log 里的文件经常不确定地增长，应该定期清除.

        /var/local：手动安装的程序（位于/usr/local）的可变数据(即系统管理员安装的程序)。如果必要，即使本地安装的程序也会使用其他 /var 目录，例如/var/lock 等。

    /opt 第三方软件放置的目录。

        用来安装附加软件包，是用户级的程序目录，可以理解为 D:/Software。

        安装到 /opt 目录下的程序，它所有的数据、库文件等等都是放在同个目录下面。

        opt 有可选的意思，这里可以用于放置第三方大型软件（或游戏），当你不需要时，直接 rm -rf掉即可。

        在硬盘容量不够时，也可将 /opt 单独挂载到其他磁盘上使用。

查看目录结构

    $ tree /opt
    /opt
    └── vc
        ├── bin
        │   ├── containers_check_frame_int
        │   ├── containers_datagram_receiver
        │   ├── vchiq_test
        │   ├── vcmailbox
        │   └── vcsmem
        ├── include
        |

在 Linux 系统里，“分区partition” 被称作 “挂载点mount point”。“挂载点” 意思就是：把一部分硬盘容量，分配到一个目录的形式，这个文件夹的名字，就叫做：“挂载点”。硬盘分区这种对硬盘空间逻辑上进行的划分，主要好处是：1、冗余性高，文件系统损坏只影响本分区数据丢失。2、方便程序区分用途，而且如果有一个程序因为故障写满了某个分区，其它分区不会受影响。所以，我们根据 fhs 方案的目录划分，结合自己的实际情况，对硬盘进行分区和划分挂载点。划分过多分区也不好，分区空间被限制死了，如果出现浪费和不足，各分区间重新调整大小比较繁琐。

    理论上只需要根目录一个挂载点就能运行操作系统 <https://www.debian.org/releases/stable/amd64/apcs01.zh-cn.html>。

    为保证操作系统可以正常启动，不要挂载 /etc 和 /usr 为独立分区

    如果你要安装大量的非发行版软件，最好把 /usr/local 挂载为独立分区

Fedora 的分区方案

        http://39.105.43.122/?p=4200

        https://view.inews.qq.com/k/20200504A0F5TT00?web_channel=wap&openApp=false

        使用 LVM 扩展卷空间 https://zhuanlan.zhihu.com/p/316063702

        Btrfs 使用心得及布局管理 https://aquarium39.moe/posts/about-btrfs/

    /boot – 至少 500MB

        /boot 分区必须设置在RAID阵列存储设备以外的地方，比如将 /boot 放在一块单独的硬盘中。

        /boot 不能放置在 LVM 逻辑卷中，也不能放置在 Btrfs 子卷中。请使用标准分区（即 Standard Partition）来对 /boot 进行分区。

    EFI 系统分区 – 至少 200MB

        GRUB2 引导程序可以安装在 MBR 类型或 GPT 类型的硬盘中。二十几年前，BIOS 最大操作一个1024柱面的硬盘，需要在磁盘前端分出一个小分区专门来存储启动文件。

        主板BIOS设置为 “传统 BIOS(Leagcy)” 模式、（兼容传统(Leagcy)模式）：如果主板使用 “UEFI CSM” 模式，你可以把硬盘格式化为 GPT 类型，并且在硬盘上需要为 Linux 创建一个大小为 1MB 的 “BIOS Boot” 分区。如果主板使用 “传统 BIOS(Leagcy)” 模式，则无需创建这样的特定分区，但这样只能把硬盘格式化为 MBR 类型，最大只支持 2TB 硬盘，所以现代计算机没有这样使用的了。

        主板 BIOS 设置为原生 UEFI 模式：仅支持 GPT 方式，需要一个空间的 EFI 分区（至少 200MB）。

    / – 根目录至少 5G，推荐 10G

        默认情况下，所有文件数据都会被写到根目录中。一般都是单独设置其下的 /boot、/home 分别挂载为独立的分区。

    /home – 至少 10G，推荐 50G

        为了让用户数据与系统数据分离开，建议为 /home 单独创建一个分区。用户数据与系统数据分离，有一个最大的好处在于，你无需删除用户数据，就可以重装或者升级你的 Fedora 系统。

        按 Debian 的推荐分区方案， /var 和 /tmp 也都单独创建分区 <https://www.debian.org/releases/stable/amd64/apcs01.zh-cn.html>。


    Swap – 根据你的计算机参数而定，不建议开启休眠

        Swap 分区支持虚拟内存（virtual memory），当系统正在处理的数据已经耗尽了内存空间时，多余的数据就会被写入 Swap 中，作为一种性能平衡。当内存耗尽，而且 Swap 分区的容量也被耗尽时，内核便会开始强制终止一些进程。

        如果你为 Swap 分区设置了过大的空间，经常让这个空间处于空闲状态，会造成资源的浪费，而且也会掩盖内存泄露的现象。

        一般情况下，内存小于 2G swap x2；内存 2~8G swap x1；内存 8~64G swap x0.5；内存大于 64G swap 视系统承载的业务量而定。

        现在一般用 Swapfile 作为创建交换分区的一种替代方案，方便创建和删除、也便于动态变更大小。

        Fedora 等新版 Linux 操作系统，默认使用 zram 虚拟压缩内存技术替代交换分区 <https://fedoraproject.org/wiki/Changes/SwapOnZRAM> <https://wiki.debian.org/ZRam> <https://zhuanlan.zhihu.com/p/472097491>。

            $ swapon -s
            Filename            Type            Size    Used    Priority
            /dev/zram0         partition        102396  0       100

### x86_64 Linux 文件名最长为 255 个字节

    https://www.cnblogs.com/qjfoidnh/p/12248643.html

在 x86_64 Linux 下，文件名的最大长度是255个字符(characters)，文件路径的最大长度是 4096 字符(characters)， 即可以包含 16 级的最大文件长度的路径。

在 <limits.h> 头文件中，有定义

    #define NAME_MAX 255

一个字符 = N个字节(bytes)，取决与编码类型，utf-8 编码采用1-4个字节来编码，可以覆盖世界上所有的语言种类。

utf-8 编码下一个汉字在 Windows 上是占两个字节，而在 Linux 上占三个字节。

所以，x86_64 Linux 下纯汉字文件的最大长度：

    最长汉字文件名 85 个汉字

    全路径长度最大 1365 个汉字

最近在使用 Python 的 wget 包下载文件时遭遇 OSError: filename too long 的异常，经检查下载的文件名确实很长，于是去查询 Linux x86_64 架构下最长文件名支持是多少。写了一个Python脚本验证一下：

```python
import os

if __name__ == '__main__':
    addname = '我'
    basename = ''
    while True:
        basename += addname
        try:
            with open(basename, 'w') as f:
                os.remove(basename)
        except Exception as e:
            print('length %d failed' % len(basename))
            break
```

输出为 86，并不是 256。而考虑到大多数汉字的 utf-8 编码一般占 3 字节，显然 Linux 对目录名长度 255 的限制是字节数而不是字符数。出问题的文件名因为含有大量中日文，其用 bytes(str, encode='utf-8') 转换为字节格式后长度已经超过 255，尝试将文件名删减到 255 字节以下后成功保存。

结论：x86_64 Linux 下文件名最长为 255 个字节，具体是多少个字符要看字符的 utf-8 编码，一般英文会比较长，中文和特殊符号等等比较短。

## 常用 shell 脚本代码片段

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

```bash

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
# declare -p PS1 打印指定变量的定义
# set 显示当前所有内置变量和函数定义
#
# -x ： 在执行每一个命令之前把经过变量展开之后的命令打印出来。
# -e ： 遇到一个命令失败（返回码非零）时，立即退出。
# -u ：试图使用未定义的变量，就立即退出。
# -o pipefail ： 只要管道中的一个子命令失败，整个管道命令就失败，这样可以捕获到其退出代码
set -xeuo pipefail

# 防止重复运行
exec 123<>lock_myscript   # 把lock_myscript打开为文件描述符123
flock --wait 5  123 || { echo 'cannot get lock, exit'; exit 1; }

# 意外退出时杀掉所有子进程
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT
#或
trap "pkill -f $(basename $0);exit 1" SIGINT SIGTERM EXIT ERR
trap "echo 'signal_handled:';kill 0" SIGINT SIGTERM

# timeout 限制运行时间
timeout 600s  some_command arg1 arg2

# 连续管道时，考虑使用 tee 将中间结果落盘，以便查问题
cmd1 | tee out1.dat | cmd2 | tee out2.dat | cmd3 > out3.dat

DATE_TIME() {
    date +"%m-%d %H:%M:%S"
}

####################################################################
#
# 文字颜色生成模板 https://ciembor.github.io/4bit
# 详见章节 [终端模拟器和软件的真彩色设置](gnu_tools.md)

# 给文字加颜色
#   echo -e "${green}All done!${plain}"
Color_red='\033[0;31m'
Color_green="\033[0;32m"
Color_yellow="\033[0;33m"
Color_plain='\033[0m'

# 输出信息
# 调用时注意区别，是否使用变量替换
#   $ aaaa='1111111111111'
#   $ show_error "aaaa is ${aaaa}"
#   21 11:25:35 [ERROR] aaaa is 1111111111111
#   $ show_error 'aaaa is ${aaaa}'
#   03/21 11:25:39 [ERROR] aaaa is ${aaaa}
show_info() {
    echo && echo -e "$(DATE_TIME) [${Color_green}INFO${Color_plain}] ${1}"
}

show_warn() {
    echo && echo -e "$(DATE_TIME) [${Color_yellow}WARN${Color_plain}] ${1}"
}

show_error() {
    echo && echo -e "$(DATE_TIME) [${Color_red}ERROR${Color_plain}] ${1}"
}

# 设置变量
ARIA2_CONF=${1:-aria2.conf}
DOWNLOADER="curl -fsSL --connect-timeout 3 --max-time 3 --retry 2"

# 包装判断语句
is_ipv4_address() {
    [ $(grep -Ec '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' <<<"$1") -ne 0 ]
}

# 判断返回值
[ -z "$res" ] && ngstatus="${Color_red}已停止${Color_plain}" || ngstatus="${Color_green}正在运行${Color_plain}"
echo -e " nginx运行状态：${ngstatus}"

# 更简洁的判断执行结果
[ $(command -v curl) ] || {
    show_error "curl is not installed."
    exit 1
}

# 判断端口是否存在，否则打印
[[ ${RPC_PORT} ]] || {
    echo && echo -e "$(DATE_TIME) ${Color_red} Aria2 configuration file incomplete.{Color_plain}"
    exit 1
}

# 字符串比较，用 [[]] 更方便
if [[ $(systemctl is-active 'nginx') = "active" ]]; then
    echo -e "nginx     [ ✓ ]"
fi

# 尝试多个指令，成功一个即可
TRACKER=$(
    wget $url1 ||wget $url2 ||wget $url3
)

# 按格式打印
ECHO_TRACKERS() {
    echo -e "
--------------------[BitTorrent Trackers]--------------------
${TRACKER}
--------------------[BitTorrent Trackers]--------------------
"
}

#############################################
# 一条命令取结果赋值给变量，并判断返回值决定是否命令不存在
# 主要用于 无命令报错，退出，有命令，直接取值，避免多运行一次。
_pp_branch_name=$(git symbolic-ref --short -q HEAD 2>/dev/null)
exitcode="$?"

if [ $exitcode -eq 0 ]; then
    printf "%s" $_pp_branch_name
fi

if [ $exitcode -eq 1 ]; then

    headhash="$(git rev-parse HEAD)"
    printf "%s" "#${headhash}"

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

for fn in $(ls *.pyi |grep -v __init__); do
    echo "import $fn as $(basename $fn .pyi)"
done

# 拼接命令行参数
IGNITION_CONFIG="/path/to/example.ign"
IGNITION_DEVICE_ARG=(--disk path="${IGNITION_CONFIG}",format=raw,readonly=on,serial=ignition,startup_policy=optional)

virt-install --name="${VM_NAME}" --os-variant="fedora-coreos-$STREAM" \
        --import --graphics=none \
        --network bridge=virbr0 "${IGNITION_DEVICE_ARG[@]}"
#################################################

# 判断当前操作系统环境

case "$OSTYPE" in
    solaris*) echo "SOLARIS" ;;
    darwin*)  echo "OSX" ;;
    linux*)   echo "LINUX" ;;
    bsd*)     echo "BSD" ;;
    msys*)    echo "WINDOWS" ;;
    *)        echo "unknown: $OSTYPE" ;;
esac

OS="`uname`"
case $OS in
  'Linux')
    OS='Linux'
    alias ls='ls --color=auto'
    ;;
  'FreeBSD')
    OS='FreeBSD'
    alias ls='ls -G'
    ;;
  # MSYS_NT
  'WindowsNT')
    OS='Windows'
    ;;
  'Darwin')
    OS='Mac'
    ;;
  'SunOS')
    OS='Solaris'
    ;;
  'AIX') ;;
  *) ;;
esac

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

## 查看 io 情况

    系统的逐个讲解cpu、内存、网络的排查方法 《Linux性能优化实战》

        https://www.cnblogs.com/fiab13/p/14394274.html

        https://blog.csdn.net/hehuyi_in/category_8883889.html

    Linux 自带的性能分析工具汇总 https://zhuanlan.zhihu.com/p/409237909

    大量网络、数据库、操作系统底层、cup 分析案例 https://plantegg.github.io/

    60 秒 Linux 性能分析 https://zhuanlan.zhihu.com/p/346630811

    linux查看磁盘io使用情况 https://blog.csdn.net/sumengnan/article/details/109462795

    25 个 Linux 性能监控工具 https://zhuanlan.zhihu.com/p/432854684

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

    $ sudo apt install sysstat

    # 启用数据收集功能
    $ sudo vi /etc/default/sysstat　　# 把false修改为true

    # 重新启动 sysstat 服务
    $ sudo systemctl restart sysstat

sysstat 包含了许多商用 Unix 通用的各种工具，用于监视系统性能和活动情况：

    iostat      统计设备和分区的CPU信息以及IO信息

    mpstat      统计处理器相关的信息

    vmstat      统计系统总体的虚拟内存、上下文切换情况

        pidstat     每个进程、线程的详细信息：同 vmstat

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

        使用 iostat https://www.redhat.com/sysadmin/io-reporting-linux

        https://blog.csdn.net/yiyeguzhou100/article/details/88019509

    $ iostat -dx 2
    Linux 6.8.9-100.fc38.x86_64 (yourhost.local)   17/05/2024      _x86_64_        (8 CPU)

    Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await
    dareq-sz     f/s f_await  aqu-sz  %util

    nvme0n1          0.12      2.97     0.00   0.00    0.07    24.24    0.00      0.00     0.00   0.00    0.33     0.08    0.00      0.00     0.00   0.00    0.00
        0.00    0.00    0.40    0.00   0.00

    sda              0.13      2.73     0.00   0.82   83.44    21.67    0.91    130.35     0.00   0.17    1.56   142.79    0.00      0.00     0.00   0.00    0.00
        0.00    0.00    0.00    0.01   0.75

    $ iostat -mxz 2
    Linux 6.8.9-100.fc38.x86_64 (yourhost.local)   17/05/2024      _x86_64_        (8 CPU)

    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            5.46    0.02    2.64    0.68    0.00   91.21

    Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dMB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util

    nvme0n1          0.12      0.00     0.00   0.00    0.07    24.24    0.00      0.00     0.00   0.00    0.33     0.08    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.40    0.00   0.00

    sda              0.12      0.00     0.00   0.82   83.44    21.67    0.90      0.13     0.00   0.17    1.56   142.79    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.01   0.74

持续查看磁盘

        https://jrs-s.net/2019/06/04/continuously-updated-iostat/

    # 去除 -s 参数显示更多的列
    $ iostat -xys --human 1

    # 显示高亮对比数据变动部分
    $ watch -n 1 -d 'iostat -xys --human 1 1'

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

看 tcp 流量情况

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

#### 磁盘繁忙程度高会导致程序响应慢

    https://zhuanlan.zhihu.com/p/458276937

    https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/performance_tuning_guide/sect-red_hat_enterprise_linux-performance_tuning_guide-performance_monitoring_tools-iostat

先看 cpu 的 %iowait 是否很高，`top` 看到 load 虚高，实际利用率很低，cpu 并不热，进程的 wa 非常高，说明 cpu 一直在等 io

然后看磁盘，用 `iostat -mxz 1` 也可以看到 %util 利用率非常高

综合看，用 `nmon` ，按 c d，可以直观的看到 cpu 和 disk 相关统计中，cpu 高 wait，磁盘高 Busy，其实读写速率并不高

出现这种情况，一般是磁盘或接口快坏了。。。

不放心的话，详细看看到底是谁在干嘛：

    先看进程，用 `pidstat -d  1` 看当前哪个进程在频繁读写磁盘，记录进程号

    然后看线程，用 `pidstat -dt -p 进程号 1` 分析应用程序中哪一个线程占用的io比较高，记录线程号

    分析这个线程在干什么？ `perf trace -t 线程号 -o /tmp/tmp_aa.pstrace`，看 write() 调用可知：目前这个线程在写入多个文件，fd为文件句柄，文件句柄号有64、159

    查看这个文件句柄是什么 `lsof -p 进程号|grep 159u; lsof -p 73739|grep 64u`，可以看到具体的文件位置了。

假设是 mysql 进程高磁盘占用，需要分析 sql 语句：

    查看当前的会话列表

        mysql> select * from information_schema.processlist where command !='sleep';

    可知：目前这个sql已经执行了67s，且此sql使用了group by和order by，必然会产生io

    通过线程号查询会话

        mysql> select * from threads where thread_os_id=74770\G;

    可知：通过查询threads表可以进行验证，该线程在频繁创建临时表的原因就来源于此sql

    查看该sql语句的执行计划，进行进一步认证

        mysql> explain select SQL_NO_CACHE b.id,a.k from sbtest_a a left join sbtest_b b on a

    可知：该sql的执行计划用到了临时表及临时文件，符合

    查看全局状态进一步进行确认

        mysql> show global status like '%tmp%';

    多执行几次，可以看出tmp_files和tmp_disk_tables的值在增长，证明在大量的创建临时文件及磁盘临时表，符合该线程的行为

    分析出来，目前sda磁盘的io使用率最高，且mysqld程序占用的最多，通过排查有一个线程在频繁的创建临时表或临时文件且通过登录mysql排查会话及线程视图可以找到是由某一个慢sql导致的，查看此慢sql的执行计划也会创建临时表和临时文件符合我们之前排查的预期。 此时我们就需要针对此慢sql进行优化，优化步骤由DBA进行处理，此处进行忽略。慢sql优化完成后可以进行io的继续观察，看io是否有下降

调试下它的代码

    我们可以使用pstack进行跟踪线程号，获取当前的线程堆栈信息。切记pstack会调用gdb进行debug调试

        shell> pstack 74770 >/tmp/74770.pstack

#### 查找上下文切换过多导致高CPU占用

    https://blog.csdn.net/Hehuyi_In/article/details/108439078

主要使用两个命令：vmstat pidstat

系统总体的上下文切换情况

    $ vmstat -w 5
    procs -----------------------memory---------------------- ---swap-- -----io---- -system-- --------cpu--------
    r  b         swpd         free         buff        cache   si   so    bi    bo   in   cs  us  sy  id  wa  st
    0  0            0      2679572       144608       868176    0    0     0     0    2    1   3   4  94   0   0
    0  0            0      2679092       144608       868176    0    0     0     0 1956 3518   3   3  94   0   0
    0  0            0      2679100       144608       868176    0    0     0     0 1293 3757   3   3  93   0   0
    0  0            0      2679172       144608       868176    0    0     0     0  585 3912   3   5  92   0   0
    1  0            0      2679504       144608       868176    0    0     0     0  585 3911   4   4  92   0   0

主要关注的列：

    us（user）和 sy（system）列：这两列是 CPU 使用率

    对上下文切换而言需要特别关注的四列内容：

        cs（context switch）是每秒上下文切换的次数。

        in（interrupt）则是每秒中断的次数。

        r（Running or Runnable）是就绪队列的长度，也就是正在运行和等待 CPU 的进程数。比如，就绪队列的长度 8，远远超过了系统 CPU 的个数 2，所以肯定会有大量的 CPU 竞争。

        b（Blocked）则是处于不可中断睡眠状态的进程数。

查看每个进程的上下文切换情况

    $ pidstat  -w 3
    14:25:02      UID      TGID       TID   cswch/s nvcswch/s  Command
    14:25:03        0       846         -      1.85      0.00  watchdog
    14:25:03        0         -       846      1.85      0.00  |__watchdog
    14:25:03     1000      2044         -     20.37   1355.56  tmux: server
    14:25:03     1000         -      2044     20.37   1355.56  |__tmux: server
    14:25:03        0      2055         -    743.52      0.93  kworker/u8:1-events_unbound
    14:25:03        0         -      2055    743.52      0.93  |__kworker/u8:1-events_unbound

    注意这里的进程上下文切换不是自己的线程切换次数的累加，在这里看不出线程的问题：

    cswch ，表示每秒自愿上下文切换（voluntary context switches）的次数。是指进程无法获取所需资源，导致的上下文切换。比如说，I/O、内存等系统资源不足时，就会发生自愿上下文切换。

    nvcswch ，表示每秒非自愿上下文切换（non voluntary context switches）的次数。是指进程由于时间片已到等原因，被系统强制调度，进而发生的上下文切换。比如说，大量进程都在争抢 CPU 时，就容易发生非自愿上下文切换。

按线程查看上下文切换次数，可指定 cpu 占用过高的那个进程

    $ pidstat -p 14039 -wt 1
    14:38:27      UID      TGID       TID   cswch/s nvcswch/s  Command
    14:38:32        0     14039         -   1097.80      0.00  kworker/u8:0-events_unbound
    14:38:32        0         -     14039   1097.80      0.00  |__kworker/u8:0-events_unbound

    14:38:32      UID      TGID       TID   cswch/s nvcswch/s  Command
    14:38:37        0     14039         -    542.80      0.00  kworker/u8:0-events_unbound
    14:38:37        0         -     14039    542.80      0.00  |__kworker/u8:0-events_unbound

每秒上下文切换多少次才算正常
这个数值其实取决于系统本身的 CPU 性能。如果系统的上下文切换次数比较稳定，那么从数百到一万以内，都应该算是正常的。但当上下文切换次数超过一万次，或者切换次数出现数量级的增长时，就很可能已经出现了性能问题。

这时，你还需要根据上下文切换的类型，再做具体分析。比方说：

自愿上下文切换变多了，说明进程都在等待资源，有可能发生了 I/O 等其他问题；
非自愿上下文切换变多了，说明进程都在被强制调度，也就是都在争抢 CPU，说明 CPU的确成了瓶颈；
中断次数变多了，说明 CPU 被中断处理程序占用，还需要通过查看 /proc/interrupts文件来分析具体的中断类型。

##### 查看中断次数过高

接上文，除了上下文切换频率骤然升高，中断次数也上升到了 1 万，需要查看 /proc/interrupts 系统提供的中断使用情况文件。

因为该文件实时刷新，所以我们使用 `watch -d` 来高亮显示变化的区域

    watch -d cat /proc/interrupts

            CPU0       CPU1
    ...
    RES:    2450431    5279697   Rescheduling interrupts
    ...

观察一段时间可以发现，变化速度最快的是重调度中断（RES），它表示唤醒空闲状态的 CPU 来调度新的任务运行。这是多处理器系统中，调度器用来分散任务到不同 CPU 的机制，通常也被称为处理器间中断（Inter-Processor Interrupts，IPI）。所以，这里的中断升高还是因为过多任务的调度问题，跟前面上下文切换次数的分析结果是一致的。

#### 可显示指定日期指定项目的信息

    # 网络
    sar -n DEV -f /var/log/sysstat/sa27 | less

#### 看内存占用

    内存泄漏定位思路和方法
        https://blog.csdn.net/xqjcool/article/details/105151549

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

Perf 是 Linux kernel 自带的系统性能优化工具。

    # 注意跟当前操作系统的内核版本匹配
    # sudo apt install linux-perf  # apt show 发现是 4.x，而当前已经是5.x了
    # sudo apt install linux-tools

    # 用 apt search 看看是否有这个版本的
    $ sudo apt install linux-doc-"$(uname -r)"
    $ sudo apt install linux-tools-"$(uname -r)"

#### 火焰图辅助分析

火焰图是一种剖析软件运行状态的工具，它能够快速的将频繁执行的代码路径以图式的形式展现给用户。

    https://blog.csdn.net/Hehuyi_In/article/details/108910584

    Linux Perf 性能分析工具及火焰图浅析 https://zhuanlan.zhihu.com/p/54276509

从 perf record 记录生成火焰图的工具

    https://github.com/brendangregg/FlameGraph

要生成火焰图，其实主要需要三个步骤：

    执行 perf script ，将 perf record 的记录转换成可读的采样记录；
    执行 stackcollapse-perf.pl 脚本，合并调用栈信息；
    执行 flamegraph.pl 脚本，生成火焰图

在 Linux 中，我们可以使用管道，来简化这三个步骤的执行过程。假设刚才用 perf record 生成的文件路径为 /root/perf.data，执行下面的命令，你就可以直接生成火焰图：

    git clone --depth=1 https://github.com/brendangregg/FlameGraph

    cd FlameGraph

    perf script -i /root/perf.data | ./stackcollapse-perf.pl --all |  ./flamegraph.pl > ksoftirqd.svg

执行成功后，使用浏览器打开 ksoftirqd.svg ，你就可以看到生成的火焰图了。

### 使用 nmon 工具包

跨平台的查看系统时实性能状态信息，比 top/btop 命令多了当前磁盘繁忙程度的指标，非常实用

    https://nmon.sourceforge.io/pmwiki.php
    https://nmon.sourceforge.net/pmwiki.php

    https://www.redhat.com/sysadmin/monitor-linux-performance-nmon

    https://www.ibm.com/docs/en/aix/7.2?topic=n-nmon-command

    https://www.kclouder.cn/posts/35478.html

图形化显示字符界面，感觉平时监控用 btop + nmon 就可掌握基本的 cpu 和 磁盘使用情况了。

各大发行版都要这个软件包，安装后直接输入 nmon 命令即可启动。

通过各种快捷键就可以启动不同的监控项目，比如按键 c 可以查看 CPU 相关信息、按键 d 可以查看磁盘信息、按键 t 可以查看系统的进程信息、m 对应内存、n 对应网络等等。再按一次为退出。

按键 h 查看完整的快捷键。所有信息均为每隔2秒刷新一次，所以系统时实性能状态信息一目了然。

采集监控数据

如果我们要抓取或分析一段时间内的系统性能，可以使用nmon进行数据收集并生成图表报告。

    mkdir -p ~/nmon # 创建一个保存报告文件的目录

    nmon -s2 -c150 -f -m ~/nmon

        -s2     每隔2秒采集一次数据

        -c150   采集150次，即为采集5分钟的数据

        -f      按标准格式生成的数据文件（包含主机名和时间）

        -m      生成的数据文件的存放目录

数据收集完成，将生成的文件转换为csv格式

    sort 源文件 > 目标文件

用 Nmonchart 生成 web 页报告，调用了 Google Chart 等 js 包，如果你的网页显示不正常，找 cdn 吧

    https://nmon.sourceforge.net/pmwiki.php?n=Site.Nmonchart

    默认生成同名的 .html 文件，通过指定文件名可以把.html直接放到你的网站上

        nmonchart blue_150508_0800.nmon blue_150508_0800.html

使用 nmon Analyser 生成 Excel 报告（需要安装 MS Office Excel）

    https://nmon.sourceforge.net/pmwiki.php?n=Site.Nmon-Analyser
        https://developer.ibm.com/articles/au-nmon_analyser/

将 csv 文件拷贝出来，打开 nmon analyser，点击”Analyze nmon data” 导入csv文件，在图表报告中有详细的分类，例如系统详细信息、CPU利用率、内存利用率、磁盘写性能、磁盘读性能等等。

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

命令 file 可以查看文件类型的说明 (sudo dnf install file)

    $ file .git/*
    .git/branches:       directory
    .git/COMMIT_EDITMSG: ASCII text
    .git/config:         ASCII text
    .git/description:    ASCII text
    .git/HEAD:           ASCII text
    .git/hooks:          directory
    .git/index:          Git index, version 2, 1 entries
    .git/info:           directory
    .git/logs:           directory
    .git/objects:        directory
    .git/refs:           directory

命令 stat 可以查看更详细的文件说明。

lsof 查看指定进程号打开的文件（sudo apt install lsof）

    $ sudo lsof -p 28987
    COMMAND   PID USER   FD   TYPE     DEVICE SIZE/OFF    NODE NAME
    nginx   28987 root  cwd    DIR      179,2     4096       2 /
    nginx   28987 root  rtd    DIR      179,2     4096       2 /
    nginx   28987 root  txt    REG      179,2   931072   46275 /usr/sbin/nginx
    nginx   28987 root  mem    REG      179,2   130696  129293 /usr/lib/nginx/modules/ngx_stream_module.so
    nginx   28987 root  mem    REG      179,2    82872  129283 /usr/lib/nginx/modules/ngx_mail_module.so
    ...

    $ sudo lsof | grep deleted
    这个命令经常用于查找已经删除但仍被程序使用的文件，这些文件因为 Linux 文件系统索引和数据分离的工作方式，即使删除了系统也仍旧没有释放磁盘空间，所以有 unlink 命令，慎用。

    也可以查看端口占用
    $ lsof -i :3389
    COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    remmina 6130   uu   53u  IPv4  89457      0t0  TCP fedws:48870->192.168.100.215:ms-wbt-server (ESTABLISHED)

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

fuser 查看占用文件的进程号（sudo apt install psmisc）

    $ sudo fuser /usr/lib/nginx/modules/ngx_mail_module.so
    /usr/lib/nginx/modules/ngx_mail_module.so: 28987m 28988m 28989m 28990m 28991m

lsof 列出使用了TCP 或 UDP 协议的文件（sudo apt install lsof），即当前对外监听的端口

    $ sudo lsof -i -P -n|grep LISTEN
    sshd      7131     uu   11u  IPv4 276030011      0t0  TCP *:22 (LISTEN)
    sshd     31856     uu   11u  IPv6 276013854      0t0  TCP *:22 (LISTEN)
    nginx    15882   root    6u  IPv4 275158656      0t0  TCP *:80 (LISTEN)
    nginx    15882   root   10u  IPv4 275158660      0t0  TCP *:443 (LISTEN)

## 替换正在运行的文件

利用Linux 文件系统索引和数据分离的特点，可以实现在线升级

    https://unix.stackexchange.com/questions/138214/how-is-it-possible-to-do-a-live-update-while-a-program-is-running

策略1：直接写入内容会报错文件被占用

    echo 'new content' >somefile

    其实重定向有个特殊用法，不先关闭文件而是利用已有句柄追加写入 `echo 'new content' >|somefile`

策略2：删除文件再写入，原文件在进程中存在，其实 somefile 的 inode 不释放，供打开它的进程使用

    rm somefile
    echo 'new content' >somefile

策略3：新建文件然后用 mv 命令，这样原文件和新文件会在进程中同时存在，这样的兼容性最好

    echo 'new content' >somefile.new
    mv somefile.new somefile

对可执行文件来说，采取策略2和策略3 都可以完美替换，原进程继续运行，杀掉原进程重启就会用新的可执行文件了。

对应用程序升级来说，动态链接库和配置文件变化，可能对原进程有影响。

## 监视文件或目录变动

安装使用 fswatch 软件包

    https://github.com/emcrisostomo/fswatch

列出当前可用的内核监视器

    $ fswatch -M
    inotify_monitor
    poll_monitor

监视目录

    fswatch ~/mycode 可多写

有变动就会输出该目录或文件名

## 查看日志

    https://ivanzz1001.github.io/records/post/linuxops/2018/04/10/linux-restart-log

    https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/monitoring-and-automation/Viewing_and_Managing_Log_Files/

    https://docs.fedoraproject.org/en-US/quick-docs/viewing-logs/

查看关机、重启、死机记录

    # 执行等级的改变的时间点，初步排查问题
    $ last

    $ last| grep -E -i "crash|down|reboot"
    pi       pts/0        192.168.0.106    Tue Aug  2 17:09 - crash (-19206+09:08)
    pi       pts/5        tmux(2151).%5    Tue Aug  2 04:29 - crash (-19205+20:29)
    pi       pts/4        tmux(2151).%4    Tue Aug  2 04:29 - crash (-19205+20:29)
    pi       pts/3        tmux(2151).%3    Tue Aug  2 04:29 - crash (-19205+20:29)
    pi       pts/2        tmux(2151).%0    Tue Aug  2 04:29 - crash (-19205+20:29)
    pi       pts/1        192.168.0.106    Tue Aug  2 04:09 - crash (-19205+20:09)

查看所有日志(systemd)

    https://docs.fedoraproject.org/en-US/quick-docs/viewing-logs/

journalctl 查看 error 及以上级别的错误日志，或在 cocokpit 中 web 页查看

    $ journalctl --no-tail --since=-24hours --priority=err --reverse

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

### 查看系统启动时的刷屏信息

kernel 会将开机信息存储在 ring buffer 中。您若是开机时来不及查看信息，用命令 dmesg 来查看。

    dmesg | less

查看操作系统日志有没有报错

    tail /var/log/kern.log

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
