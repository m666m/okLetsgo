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
