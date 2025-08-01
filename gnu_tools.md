# GNU/Linux 常用工具

    GNU 收录软件，可查手册 https://www.gnu.org/software/software.html

    Linux 命令速查

        https://man7.org/linux/man-pages/index.html

        这个老点 https://linux.die.net/man/

    各种linux帮助手册速查 https://manned.org/

    内核相关工具和使用手册 https://docs.kernel.org/

## Linux 字符终端

很多终端工具都是跨平台的，参见章节 [其他终端模拟器]。

### 终端的历史演进

    https://devblogs.microsoft.com/commandline/windows-command-line-introducing-the-windows-pseudo-console-conpty/#in-the-beginning-was-the-tty

    https://zhuanlan.zhihu.com/p/99963508

    TTY 是什么 https://zhuanlan.zhihu.com/p/447014333

    TTY 里程碑 https://vt100.net/

在 80 年代个人计算机出现前，电子计算机都是多用户大型机，程序在大型机上运行，一般称 “主机 MainFrame“。

主机有一个给管理员提供交互式操作的工作台，称为 “控制台 console”。用户连接主机进行操作称为 “用户登录控制台(console login)”。

    登录 login

在计算机技术发展初期，跟计算机的交互很简陋，用户想执行命令要在一条纸带上打孔，打孔按规律进行编码，用户在控制台上把纸带输入给计算机。计算机识别这些编码，处理后在另一条纸带上打孔输出执行结果，用户按打孔规律解读

              输入纸带 -->
    user --->             console <---> 主机
              输出纸带 <--

统一实现字符输入输出，利用了 1930 年代出现的 “电传打字机（Teletype, tty）”，用户在电传打字机上打字作为输入，主机把执行结果用字符作为输出，被电传打字机打印在纸上

               键盘  -->
             /
    user --->             tty  <---> console <---> 主机
             \
               打印纸 <--

tty 的这种以字符跟主机进行交互的方式，称为 “控制台模式（console mode）”。也叫 “命令行模式（command mode）”。

使用主机的各个用户，一般都是利用具备 tty 功能的设备连接到主机跟操作系统交互。

因为 tty 设备可以输出不同的显示规格的字符，比如字体、大小、行宽、列宽等，所以终端设备输出时也需要对此进行适配。

直到现在，unix、Linux 操作系统仍然用 tty 来表示使用字符的输入输出设备。

随着电子技术的发展，tty 功能的输出设备从打字机的纸带发展到到不同分辨率的电子显示屏，种类繁多。具备 tty 功能，给用户提供字符输入和显示输出结果的设备，被称为 “终端 Terminal”。

               键盘  -->
             /
    user --->           终端  <---> console --- 主机
             \
               显示器 <--

终端设备用来接收用户界面的输入传递给主机，接收主机的输出展现在用户界面，在这个过程中需要对字符进行编码转换以便人与主机互相 “理解”。字符的编码标准，从 1970 年代 ANSI 标准沿用至今，主流计算机都保持对此标准的兼容。

作为主机的大型机也逐渐演变为小型机或 PC 服务器等多种形态，用户通过数据线，使用各种终端设备连接到主机，我们把主机统一称为 Host。从 1980 年代 IBM PC 开始计算机进入微型化时代，称 “微机”（台式机），后来又出现了 “笔记本电脑”、“平板电脑”。

用户连接主机称为 “用户登录（user login）”，用户的终端设备相对于主机，称为 “客户机 Client”。对现代互联网来说，网络上的主机称为 Server，用户使用的客户端设备称为 Client，注意区分概念。

现在不在需要专门的终端设备了，客户端设备一般是通用设备如台式机或笔记本电脑，通过网线、串行端口电缆等连接主机，用户在客户端设备上运行终端模拟软件进行 “用户登录”，然后就可以操作主机了。

而 “用户登录控制台”，仍用于操作主机管理界面，比如 Unix、Linux 类的操作系统，可以使用一台通用计算机连接主机的串行端口，或在主机的图形界面使用特殊的命令组合如 ctrl+alt+F2，进入一个命令行界面，在这里即相当于连接到了主机的控制台，用户可以执行对计算机进行管理维护的底层操作命令。

#### TTY 设备

    https://zhuanlan.zhihu.com/p/613534348

    https://zhuanlan.zhihu.com/p/97018747

在今天，类 unix 操作系统如 Linux/MacOS 还是在利用 tty 设备作为主机与用户之间使用字符操作交互的桥梁，主机上运行的程序，输入输出默认指向一个 tty 设备。

    用户使用终端软件如 ssh 登录服务器，由服务器分配一个 tty 设备才能进行命令行操作（ssh 支持设置不给连接用户分配 tty 设备以提高安全性）。

    桌面用户使用终端模拟器，由主机分配一个 tty 设备给终端模拟器，连接操作主机。

为便于理解，查看以下示例：

命令 `who` 可以显示当前用户打开的全部 TTY 设备，而命令 `tty` 则可以显示当前窗口所用的 TTY 设备。因为 Linux 的设备都是用文件的方式映射的，所以利用这两个命令获取的信息，我们把文本写入 tty 设备，可以实现在一个 session 中向另一个 session 发送消息：

    # 当前有哪些终端
    $ who
    pi       pts/0        2023-03-14 11:50 (::1)
    pi       pts/1        2023-02-07 22:52 (tmux(2044).%0)
    pi       pts/2        2023-02-07 22:52 (tmux(2044).%1)

    # 当前用的哪个终端
    $ tty
    /dev/pts/0

    # 对方的命令行输入处会出现该文本的内容
    $ echo "message from 0 to 2" >/dev/pts/2

    至于为何显示 pts 而不是 pty，因为 pty（见下面章节[终端模拟器（Terminal Emulator）]）由两部分构成，pts 是 slave 端，ptmx 是 master 端，对用户空间的程序来说，操作 pts 就是操作 pty 设备。从 pty 设备内部来看，pts 的一端连接的是用户空间的应用程序，如 sshd、tmux 等，pts 的另一端连接的是 ptmx。而 ptmx 连接的是内核的终端模拟器，它和终端模拟器都只是负责维护会话和转发数据包；内核终端模拟器的另一端连接的是具体的硬件，如键盘和显示器。

当用户退出终端（手动退出或者因为网络波动断网而退出）时，发送了什么：

    系统给运行中的程序发送了 hangup 信号，如果程序不处理将被终止。

    系统关闭了这个终端对应的 TTY 设备。而这个 TTY 设备是程序默认的输入、输出来源。此时，当程序尝试输入、输出时，就会遇到错误。

因此，`nohup` 的工作原理也非常简单，通过 `man nohup` 就可以看到：nohup - run a command immune to hangups, with output to a non-tty。简单来说，nohup 让程序能够不受 hangup 信号的影响，并且将输入输出转移到一个非 TTY 的文件上，从而避免程序被关闭。

在 tmux 中开启的 session，也不会受到当前终端退出的影响。这是因为 tmux 中开启的每个 session 都有自己的 TTY 设备，当前用户退出时操作系统并不会删除 tmux 的那些 tty 设备。

当我们使用 `docker exec` 或者 `kubectl exec` 等命令连接到某个容器时，经常会加上 -it 参数。其中的 -t 的含义，就是分配一个TTY设备：-t,--tty[=false] Allocate a pseudo-TTY。于是，执行完这些命令后，就启动了一个 TTY 设备连接，可以当做一个正常的 terminal 来使用。大家也可以试试去掉 -t 参数，这时就像一个普通程序一样，你输入一个命令，它输出相应内容，没有 tab 补全，也没有各种显示与颜色。

tty 设备的未来

    https://www.reddit.com/r/linux/comments/8yox3f/what_ever_happened_to_systemdconsoled_and_the/

wayland 等基于图形化的框架成熟后，Linux 内核的 VT 子系统转为使用一个用户空间的窗口系统，该系统能够运行多个终端仿真器以及其他客户端，在它们之间切换，并执行基本的 WM 操作，例如最大化输出上的窗口。

#### 终端模拟器（Terminal Emulator）

80年代通用计算机发展以来，主要的连接方式是用户使用通用计算机，通过串行电缆连接主机，利用通用计算机的显示器和键盘与主机交互，在主机上使用命令行界面进行操作。

随着处理器能力发展强大，GUI 图形化操作系统的发展，带来了一个新的使用问题：如果用户使用图形化窗口的 Terminal，需要与本机上运行的另一个命令行应用程序交互，那么本机的程序需要营造出一个物理终端设备的仿真环境，就像登录了控制台一样的操作，以便通过命令行跟主机进行交互，即所谓终端模拟器（Terminal Emulator）。

这种连接本机控制台的终端称为终端模拟器，或称软件进入 “console mode”。

UNIX/Linux 内核使用伪终端（pseudo tty，缩写为 pty）设备的概念，实现这个伪终端功能的程序即可把自己模拟成主机的终端。我们现在说的终端，不再是真实的硬件设备，一般都是指软件终端模拟器。目前流行的字符终端模拟器有 mintty、xterm、putty（远程）等，图形终端模拟器有使用 vnc、rdp 协议的 tiger vnc/Remmina/mstsc 等。在使用字符终端模拟器的时候，如果不清楚主机类型，终端类型可选择最常见的 xterm。

随着计算机网络的发展，网络上的服务器（Server）作为主机，客户机（Client）通过网络连接主机。主机和客户机间可以使用各种不同类型的协议进行连接，比如 ssh/telnet/ftp 等都有对应的命令行程序。远程连接使用的通信协议主要采用非对称密钥加密算法，一般利用 ssh 建立通信隧道。上述终端模拟器中，xterm 连接本机，通过 ssh 等程序连接网络上的主机。putty 主要用于 ssh 协议连接网络上的主机，通过 ssh 的方式也可连接本机（需要本机运行 sshd 服务），也支持模拟 rs232 串口方式连接本机操作系统 console。

在 shell 下对终端进行控制的常用命令

    tput 命令查询或创建交互性的、专业性强的屏幕输出，如移动或更改光标、更改文本属性，以及清除终端屏幕的特定区域

    reset 重置终端的显示，适用于 cat 了一个二进制命令，导致终端显示混乱的情况下。

    ncurses 库被用于在 Linux 下生成基于文本的用户界面，你的终端模拟器必须被它内置的 terminfo 数据库接受，才能在 tty 下正常显示文本，一般都会把自己模拟成 xterm。

#### 登录控制台 tty login

虽然都是输入用户名和密码，本地登录不需要 sshd 服务，二者不是一回事。

现代操作系统中，本地使用主机的场景，一般都支持从控制台登录的功能，这样用户在主机前接个键盘显示器即可维护基本的操作系统，当然也可以设置开机引导到图形界面登录。

    对主机来说，由本地主机分配一个 tty 设备操作主机，用户最终在命令行界面里获得一个 login shell。类似但是跟普通的 ssh 登录是不一样的，控制台登录不依赖 sshd 服务，而且也不需要你安装什么终端模拟器，这是操作系统自带的一个终端界面。

    这样的登录方式一般会提供多个控制台，按下 Alt+Fn 键可切换各个控制台。各 Unix 系统和 Linux 发行版有区别，挨个试试即可。

目前常用的登录控制台的方式：

1、本地主机外接显示器和键盘鼠标，开机启动后 [本地登录切换图形模式或控制台登录]，获得 login shell。

2、本地桌面环境下，支持命令行下的键盘快捷键，来即时切换到各个控制台 console：

    CTRL + ALT + F1 – 锁屏
    CTRL + ALT + F2 – TTY2，如果有用户登录桌面，则切换到对应的桌面环境
    CTRL + ALT + F3 – TTY3，如果有第2个用户登录桌面，则切换到对应的桌面环境，以下类推
    CTRL + ALT + F4 – TTY4
    CTRL + ALT + F5 – TTY5
    CTRL + ALT + F6 – TTY6

稍微等一会儿就切换过去了，当前桌面会保持。

这是真正的控制台噢，跟图形界面下的那些终端模拟器比如 Gnome Terminal 之类的没关系。

各发行版的定义可能不大一样，所以我都是暴力切换：左手按住 ctl+alt，右手食指从 F3 一溜划到 F10，随便谁出来。。。

3、无头模式(Headless)开机直接串口登录控制台

主机没有连接显示器和键盘称为无头模式(Headless)，一般只能用另一台笔记本电脑等设备，通过串口连接到该主机，获得一个 login shell。

    从品牌服务器到树莓派等单板设备，都支持由本地主机分配一个 tty 设备给串口，最终在连接串口的终端模拟器里可以获得一个 login shell。

    这个 Serial Console(UART) 方式叫做 serial tty login，在 Linux 里执行登录的程序名一般是 getty。示例参见章节 [通过ttl串口登录树莓派](raspberry-pi think)。

    使用虚拟机软件安装操作系统时，虚拟机软件提供的显示界面其实就是模拟的本地的控制台登录。利用本地控制台登录，即使远程连接故障，也可以连接操作你的虚拟机。

另见章节 [给控制台console设置中文字体]。

### 交互式登录 shell

    https://www.cnblogs.com/pigwan7/p/9593540.html

shell 是终端下用户与操作系统进行交互的媒介，bash 是目前 Linux 系统中最常用的 shell。

可以从两个不同维度来划分 shell：是否交互式、是否登录。

一、交互式 shell 和非交互式 shell

    交互式模式（interactive）：在终端上执行，shell 等待你的输入，并且立即执行你提交的命令。这种模式被称作交互式是因为 shell 与用户进行交互。这种模式也是大多数用户非常熟悉的：登录、执行一些命令、退出。当你退出后，shell也终止了。

    非交互式模式（non-interactive）：以 shell script 方式执行。在这种模式 下，shell 不与你进行交互，而是读取存放在脚本文件中的命令,并且执行它们。当它读到文件的结尾 EOF，shell 也就终止了。在管道中执行的脚本就属于非交互模式。

可以通过打印 “$-” 变量的值（代表着当前shell的选项标志），查看其中是否有字母 “i” (interactive shel) 来区分交互式与非交互式 shell。

    $ echo $-
    himBHs

    $ [[ $- != *i* ]] && echo 'non-interactive' || echo 'interactive'

用户在本地使用终端模拟器和 ssh 登录远程服务器，使用的 shell 都属于交互式。

二、登录 shell 和非登录 shell

    登录 shell（login）：需要用户名、密码登录后才能进入的 shell，或者命令 `bash --login` 或 -l 选项生成的 shell

    非登录shell（non-login）：不需要输入用户名和密码即可打开的 Shell，例如：直接命令 `bash` 就是打开一个新的非登录shell

> 读取登录脚本文件的区别

登录 shell：

    系统级：
    /etc/profile
        --> /etc/bash.bashrc
        --> /etc/profile.d

            用户级：
            --> ~/.bash_profile
            --> ~/.bash_login
            --> ~/.profile

                --> $HOME/.bashrc -> /etc/bashrc
                    --> ~/.bash_logout

    特殊的，.profile(由 Bourne Shell 和 Korn Shell 使用) 和 .bash_login (由 C Shell 使用)两个文件是 .bash_profile 的同义词，目的是为了兼容其它 Shell。目前 Debian 系使用 .profile，RHEL 系使用 .bash_profile。

    .bash_profile 中一般会执行 .bashrc，Bash 默认的命令提示符、ls 和 grep 命令的彩色显示在 ~/.bashrc 的代码中进行了设置

非登录 shell： $HOME/.bashrc -> /etc/bashrc

> 运行时区别

    登录 shell，其 bash 进程名为 "-bash"

    非登录 shell，其 bash 进程名为 "bash"

    退出一个登录  shell 的命令：exit 或者 logout，
    退出一个非登录 shell 的命令：只能 exit。

现在大多数终端模拟器，包括 Gnome 或 KDE 等桌面环境下打开的系统自带的 “终端”（terminal）窗口程序，默认都启动非登录 shell，即不会执行你的 ~/.bash_profile 文件。

三、讲人话

登录本地终端：

    需要在你的终端模拟器软件中开启设置，才能在登录时执行你的 ~/.bash_profile 文件：

        指定执行命令 `/bin/bash -l`

        或勾选 'Use Login Shell'

    否则只能在进入 shell 后手动执行 `source ~/.bash_profile`。

ssh 登录远程服务器：

    属于登录 shell，ssh 会自动执行远程服务器用户的 ~/.bash_profile 文件，除非在 ssh 命令行指定不执行登录脚本文件。

四、crontab 中执行 shell，既不是交互式 shell，也不是登录 shell，不会执行上述的配置文件，有如下两种处理方法：

    把 shebang 改为 `#!/bin/bash -l` 让脚本用登录 Shell 来解释执行，这个时候，执行脚本要采用路径执行的方式

    调用 Bash 解释器，加 -l 参数，即 /bin/bash -l script

### 字符终端的区域、编码、语言

    https://perlgeek.de/en/article/set-up-a-clean-utf8-environment

用命令 locale 查看，变量依赖从大到小的顺序是：LC_ALL, LC_CTYPE, LANG

    $ locale
    LANG=en_US.UTF-8
    LANGUAGE=en_US.UTF-8
    LC_CTYPE="en_US.UTF-8"
    LC_NUMERIC="en_US.UTF-8"
    LC_TIME="en_US.UTF-8"
    LC_COLLATE="en_US.UTF-8"
    LC_MONETARY="en_US.UTF-8"
    LC_MESSAGES="en_US.UTF-8"
    LC_PAPER="en_US.UTF-8"
    LC_NAME="en_US.UTF-8"
    LC_ADDRESS="en_US.UTF-8"
    LC_TELEPHONE="en_US.UTF-8"
    LC_MEASUREMENT="en_US.UTF-8"
    LC_IDENTIFICATION="en_US.UTF-8"
    LC_ALL=en_US.UTF-8

    未添加语言包时操作系统只支持比较少的几个 POSIX 标准
    $ locale -a
    C
    C.utf8
    POSIX

在 env 设置，如

    LC_CTYPE=zh_CN.gbk; export LC_CTYPE

中文 Windows 使用 ansi gbk 编码，设置变量：Locale、Charset

    Locale=zh_CN
    Charset=GB18030

shell中的命令显示中文（如果支持的话）就设置 LANG

    export LANG=zh_CN.UTF-8

> stty 命令设置终端参数

    https://www.cnblogs.com/goloving/p/15170646.html

进程和终端间的数据传输和数据处理是由终端设备驱动程序来负责的，终端驱动程序是内核的一部分，stty 命令可以修改终端驱动程序里面的设置

    $ stty -a
    speed 38400 baud; rows 42; columns 176; line = 0;
    intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>; eol2 = <undef>; swtch = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R; werase = ^W; lnext = ^V;
    discard = ^O; min = 1; time = 0;
    -parenb -parodd -cmspar cs8 -hupcl -cstopb cread -clocal -crtscts
    -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr icrnl ixon -ixoff -iuclc -ixany -imaxbel iutf8
    opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
    isig icanon iexten echo echoe echok -echonl -noflsh -xcase -tostop -echoprt echoctl echoke -flusho -extproc

tostop 属性控制后台任务是否能写终端

stty 命令不带参数可以打印终端行设置，加上 -a 参数可以打印得更详细些。

　　stty size ：可以显示终端的大小，即行数和列数。

　　stty 命令还可以更改终端行的设置，格式如下：stty SETTING CHAR

　　其中，SETTING可以是如下：

        eof : 输入结束，文件结束，默认为Ctrl+D。比如：用cat >file来创建文件时，按Ctrl+D来结束输入。

        erase : 向后删除字符，擦除最后一个输入字符，默认为Ctrl+?。注意默认情况下退格键Backspace不是删除字符。

        intr : 中断当前程序，默认为Ctrl+C。

        kill : 删除整条命令，删除整行，默认为Ctrl+U。

        quit :退出当前程序，默认为Ctrl+\或Ctrl+|。

        start : 启动屏幕输出，默认为Ctrl+Q。

        stop :停止屏幕输出，默认为Ctrl+S。

        susp : terminal stop当前程序，默认为Ctrl+Z。这样当前进程就会变成后台进程了。

        werase：删除最后一个单词，默认为Ctrl+W。

stty 命令还有一些其他用法，如：stty -echo 关闭回显（比如在脚本中用于输入密码时），然后再用 stty echo 打开回显。

    #在命令行下，禁止输出大写的方法：
    stty iuclc     #开启
    stty -iuclc    #恢复

    #在命令行下禁止输出小写：
    stty olcuc    #开启
    stty -olcuc   #恢复

    #打印出终端的行数和列数：
    stty size

    #改变Ctrl+D的方法:
    stty eof "string"
    #系统默认是Ctrl+D来表示文件的结束，而通过这种方法，可以改变！

    #屏蔽显示：
    stty -echo   #禁止回显
    stty echo    #打开回显
    #测试方法:
    stty -echo;read;stty echo;read

    #忽略回车符：
    stty igncr     #开启
    stty -igncr    #恢复

> 设置退格键 Backspace 的删除行为

　　在默认情况下，我们按退格键 Backspace时，会在屏幕上回显^H，而不是把前一个字符删除。比如使用 sftp/ftp/sqlplus/ij 等命令时，就会碰到这种情况。我们可以使用stty命令把退格键 Backspace 的行为变成删除前一个字符

    sftp> get abc^H^H^H^H

    #修改删除行为
    [root@web ~]# stty erase ^H

> 终止后台进程写入输出

我们在终端当中，默认是允许进程往终端当中进行输出的，但是当我们使用命令 stty tostop 之后，如果还有后台进程往终端当中进行输出，那么这个进程就会收到一个 SIGTTOU 信号。

### 终端模拟器和软件的真彩色设置

    https://github.com/mintty/mintty/wiki/CtrlSeqs

    历史介绍见 https://zhuanlan.zhihu.com/p/566797565

自 1978 年的 VT100 以来，Unix/Linux 一直通用 [ANSI escape codes 彩色字符方案](http://en.wikipedia.org/wiki/ANSI_escape_code)：使用固定的文本代码作为控制命令，对字符终端的文本进行修饰，由终端模拟器和软件解释并呈现对应的色彩。

因为终端都是本地使用的，就是 Linux/Unix 服务器开机时进入的命令行模式，如果我们在登录后的命令行变量 $TERM 设置终端类型，终端模拟器会读取该变量自动模拟为指定类型的终端，一般默认 xterm。

在使用 ssh 命令行远程连接 Linux/Unix 服务器时，也是同样处理的。

最古老的基本颜色板（basic colour palette），前景色和背景色分别有 8 种，合计16种如下

    https://blog.csdn.net/Dreamhai/article/details/103432525

    https://zhuanlan.zhihu.com/p/570148970

    色彩      黑    红    绿    黄    蓝    洋红    青    白
    前景色    30    31    32    33   34    35    36    37
    背景色    40    41    42    43   44    45    46    47

所以目前通用的前景颜色代码就是16种（基本8种、加亮8种），在 bash 下用如下字符表示：

```bash

# 修饰文本的颜色代码用 \033[0 开头

plain="\033[0m"

black="\033[0;30m"
dark_gray="\033[1;30m"

red="\033[0;31m"
light_red="\033[1;31m"

green="\033[0;32m"
light_green="\033[1;32m"

yellow="\033[0;33m"
light_yellow="\033[1;33m"

blue="\033[0;34m"
light_blue="\033[1;34m"

# 也有叫 purple 的
magenta="\033[0;35m"
light_magenta="\033[1;35m"

cyan="\033[0;36m"
light_cyan="\033[1;36m"

white="\033[0;37m"
light_gray="\033[1;37m"

# 验证
echo -e "${red}Are you ${plain} ok?"

```

输出特效格式控制：

```bash
\033[0m 关闭所有属性
\033[1m 设置高亮度
\03[4m 下划线
\033[5m 闪烁
\033[7m 反显
\033[8m 消隐
\033[30m -- \033[37m 设置前景色
\033[40m -- \033[47m 设置背景色
```

光标位置等的格式控制：

```bash
\033[nA 光标上移n行
\03[nB 光标下移n行
\033[nC 光标右移n行
\033[nD 光标左移n行
\033[y;xH设置光标位置
\033[2J 清屏
\033[K 清除从光标到行尾的内容
\033[s 保存光标位置
\033[u 恢复光标位置
\033[?25l 隐藏光标
\33[?25h 显示光标
```

如果你的终端模拟器支持彩色等效果，那么在 bash 下输入如下代码，会看到输出红色的文字

    # ascii表中 \e 或 \033 或 \x1b
    # 使用16色代码表 基本颜色板
    $ echo -en "\033[0;31m I am red\033[0m\n"

    # 使用256色代码表
    $ echo -en "\033[38:5:88m I am red\033[0m\n"

    # 使用RGB真彩色
    $ echo -en "\033[38:2:168:28:38m I am red\033[0m\n"

    #凑数的，vscode语法高亮往下匹配了，太乱]]]]]]

更多应用示例参见 (shellcmd.md) 中终端登录脚本中颜色设置的代码。

所以，要能看到彩色的文本，终端模拟器应该至少在选项设置中设置为 xterm 类型。若终端工具能支持24位真彩色、开启透明选项，则显示的效果更好。

为防止终端模拟器软件中未设置终端类型，或软件默认使用的终端类型比较保守，一般可以在用户登录脚本 .bash_profile 中设置环境变量，起到相同的效果

    # 显式设置终端启用256color，防止终端工具未设置。若终端工具能支持24位真彩色、开启透明选项，则显示的效果更好
    export TERM="xterm-256color"

如果终端模拟器支持真彩色，还可以对16色代码表的实际展现效果进行自定义设置，从 65536 种颜色中选取：比如把红色代码 31 的实际展现效果定义为 RGB(168,28,38)。这样做的目的是兼容性：绝大多数的 shell 脚本对文字进行颜色修饰都通用 16 色代码，除非脚本的代码改造为 RGB(x,x,x) 的形式才能呈现更丰富的色彩。所以，不需要修改脚本的折衷办法是，由用户设置自己的终端模拟器把这 16 种颜色解释为更丰富的颜色。

基本颜色板的自定义，详见各终端模拟器的设置。

如果需要确定当前终端模拟器是否支持真彩色，参见下面网址中的真彩色检测代码

    https://github.com/termstandard/colors
        https://gist.github.com/XVilka/8346728

终端模拟器即使开启了 24 位真彩，出于兼容性考虑，默认的色彩主题，对16种颜色代码也只会选用 16/256 色中的颜色，导致看不出更好看的效果。所以，为了能看到更丰富的颜色，应该自定义设置，选择颜色更丰富的其它主题，或自定义这16种颜色代码的实际展现颜色，详见各终端模拟器的设置。

#### 测试终端模拟器支持色彩的情况

使用不同终端模拟器（mintty bash、putty、Windows Terminal bash）, 用 ssh 登录同一个服务器， 分别进入 bash/zsh+powerlevel10k 、tmux 环境

查看终端设置是否配置好了基本的变量

    $ echo $TERM
    xterm-256color

    $ tput colors
    256

使用 vim 查看代码文件，在 vim 里执行 `:terminal` 进入新的终端，各种情况的组合测试：

观察彩色文字的颜色、状态栏色条：如果彩色文字的颜色深且明亮、状态栏工具的色条颜色过渡断裂，说明只支持 256color。

        -    bash+vim   zsh+powerlevel10k+vim   tmux+bash+vim     tmux+zsh+powerlevel10k+vim
    ----------------------------------------------------------------------------------------
    mintty

    putty

    Windows Terminal

基本 16 色测试脚本

    行为文字颜色(前景色16色)，列为背景颜色（8色），在 bash 下执行即可

        # curl -fsSL https://github.com/pablopunk/colortest/raw/master/colortest |bash

        ```bash

        T='gYw' # The test text

        echo -e "\n                 40m     41m     42m     43m\
             44m     45m     46m     47m";

        for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
                   '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
                   '  36m' '1;36m' '  37m' '1;37m';
          do FG=${FGs// /}
          echo -en " $FGs \033[$FG  $T  "
          for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
            do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
          done
          echo;
        done
        echo

        ```

    16 色，前景和背景

        curl -fsSL https://github.com/mintty/utils/raw/master/colourscheme |bash

    16 色，前景和背景，加上文字粗体闪烁等效果

        curl -fsSL https://github.com/robertknight/konsole/raw/master/tests/colortest.sh |bash

    跟上面的代码功能相同的一个简单脚本实现

    ```bash
    # https://github.com/msys2/MSYS2-packages/issues/1684#issuecomment-570793998
    for x in {0..8}; do for i in {30..37}; do for a in {40..47}; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo ""
    ```

256 color 测试脚本

    256色展示，按每种颜色组织

        curl -fsSL https://github.com/robertknight/konsole/raw/master/tests/color-spaces.pl |perl

True color(24bit) 色条测试脚本，如果色条出现明显的条带分隔，那说明只支持 256 color

    简单在 bash 下执行即可

    ```bash

    awk 'BEGIN{
        printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n";

        s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
        for (colnum = 0; colnum<77; colnum++) {
            r = 255-(colnum*255/76);
            g = (colnum*510/76);
            b = (colnum*255/76);
            if (g>255) g = 510-g;
            printf "\033[48;2;%d;%d;%dm", r,g,b;
            printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
            printf "%s\033[0m", substr(s,colnum+1,1);
        }
        printf "\n";
    }'

    ```

    连续过渡的颜色色条

        # 如果在 putty、Windows Terminal 下无输出，换 mintty 试试
        curl -fsSL https://github.com/bitcrazed/24bit-color/raw/master/24-bit-color.sh |sh

    zsh 脚本

        for code ({000..255}) print -P -- "$code: %F{$code}最左侧三位数字即颜色值Text Color%f"

True color(24bit) 综合测试 terminal-testdrive.sh

    把真彩色和各种文字效果都测试了，兼容性好，在 mintty、putty、Windows Terminal 下都可以正常显示

    需要先安装 `apt install bc` 或手工修改代码 `cols=24`

        # https://gist.github.com/hellricer/e514d9615d02838244d8de74d0ab18b3
            https://hellricer.github.io/2019/10/05/test-drive-your-terminal.html

        curl -fsSL https://gist.github.com/hellricer/e514d9615d02838244d8de74d0ab18b3/raw/7e5be20969b7274d64a550b9132fee5268cff2d8/terminal-testdrive.sh |sh

    ```sh
    #!/bin/sh

    echo "# 24-bit (true-color)"
    # based on: https://gist.github.com/XVilka/8346728
    term_cols="$(tput cols || echo 80)"
    cols=$(echo "2^((l($term_cols)/l(2))-1)" | bc -l 2> /dev/null)
    rows=$(( cols / 2 ))
    awk -v cols="$cols" -v rows="$rows" 'BEGIN{
        s="  ";
        m=cols+rows;
        for (row = 0; row<rows; row++) {
            for (col = 0; col<cols; col++) {
                i = row+col;
                r = 255-(i*255/m);
                g = (i*510/m);
                b = (i*255/m);
                if (g>255) g = 510-g;
                printf "\033[48;2;%d;%d;%dm", r,g,b;
                printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
                printf "%s\033[0m", substr(s,(col+row)%2+1,1);
            }
            printf "\n";
        }
        printf "\n\n";
    }'

    echo "# text decorations"
    printf '\e[1mbold\e[22m\n'
    printf '\e[2mdim\e[22m\n'
    printf '\e[3mitalic\e[23m\n'
    printf '\e[4munderline\e[24m\n'
    printf '\e[4:1mthis is also underline\e[24m\n'
    printf '\e[21mdouble underline\e[24m\n'
    printf '\e[4:2mthis is also double underline\e[24m\n'
    printf '\e[4:3mcurly underline\e[24m\n'
    printf '\e[58;5;10;4mcolored underline\e[59;24m\n'
    printf '\e[5mblink\e[25m\n'
    printf '\e[7mreverse\e[27m\n'
    printf '\e[8minvisible\e[28m <- invisible (but copy-pasteable)\n'
    printf '\e[9mstrikethrough\e[29m\n'
    printf '\e[53moverline\e[55m\n'
    echo

    echo "# magic string (see https://en.wikipedia.org/wiki/Unicode#Web)"
    echo "é Δ Й ק م ๗ あ 叶 葉 말"
    echo

    echo "# emojis"
    echo "😃😱😵"
    echo

    echo "# right-to-left ('w' symbol should be at right side)"
    echo "שרה"
    echo

    echo "# sixel graphics"
    printf '\eP0;0;0q"1;1;64;64#0;2;0;0;0#1;2;100;100;100#1~{wo_!11?@FN^!34~^NB
    @?_ow{~$#0?BFN^!11~}wo_!34?_o{}~^NFB-#1!5~}{o_!12?BF^!25~^NB@??ow{!6~$#0!5?
    @BN^!12~{w_!25?_o{}~~NFB-#1!10~}w_!12?@BN^!15~^NFB@?_w{}!10~$#0!10?@F^!12~}
    {o_!15?_ow{}~^FB@-#1!14~}{o_!11?@BF^!7~^FB??_ow}!15~$#0!14?@BN^!11~}{w_!7?_
    w{~~^NF@-#1!18~}{wo!11?_r^FB@??ow}!20~$#0!18?@BFN!11~^K_w{}~~NF@-#1!23~M!4?
    _oWMF@!6?BN^!21~$#0!23?p!4~^Nfpw}!6~{o_-#1!18~^NB@?_ow{}~wo!12?@BFN!17~$#0!
    18?_o{}~^NFB@?FN!12~}{wo-#1!13~^NB@??_w{}!9~}{w_!12?BFN^!12~$#0!13?_o{}~~^F
    B@!9?@BF^!12~{wo_-#1!8~^NFB@?_w{}!19~{wo_!11?@BN^!8~$#0!8?_ow{}~^FB@!19?BFN
    ^!11~}{o_-#1!4~^NB@?_ow{!28~}{o_!12?BF^!4~$#0!4?_o{}~^NFB!28?@BN^!12~{w_-#1
    NB@???GM!38NMG!13?@BN$#0?KMNNNF@!38?@F!13NMK-\e\'

    ```

我的测试结果

    mintty 所有验证条件都完美呈现。

    putty 可以通过真彩测试，但对块状字符的渲染方式有问题：zsh+powerlevel10k 命令提示符颜色过渡明显断裂，tmux 状态栏颜色也如此。terminal-testdrive.sh 测试不支持：文字闪烁、sixel 图像。

    Windows Terminal 可以通过真彩测试，但对块状字符的渲染方式有问题：zsh+powerlevel10k 命令提示符颜色过渡明显断裂，tmux 状态栏颜色也如此。terminal-testdrive.sh 测试：不支持 sixel 图像，少了几个文字修饰效果。

如果要测试刷新速度

    ```bash

    # 看谁刷的快 https://github.com/alacritty/alacritty/issues/289#issuecomment-340283908%29
    for i in {1..400000}; do
        echo -e '\r'
        echo -e '\033[0K\033[1mBold\033[0m \033[7mInvert\033[0m \033[4mUnderline\033[0m'
        echo -e '\033[0K\033[1m\033[7m\033[4mBold & Invert & Underline\033[0m'
        echo
        echo -e '\033[0K\033[31m Red \033[32m Green \033[33m Yellow \033[34m Blue \033[35m Magenta \033[36m Cyan \033[0m'
        echo -e '\033[0K\033[1m\033[4m\033[31m Red \033[32m Green \033[33m Yellow \033[34m Blue \033[35m Magenta \033[36m Cyan \033[0m'
        echo
        echo -e '\033[0K\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
        echo -e '\033[0K\033[1m\033[4m\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
        echo
        echo -e '\033[0K\033[30m\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
        echo -e '\033[0K\033[30m\033[1m\033[4m\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
    done

    ```

#### shell内置命令的颜色方案 dir_colors

终端模拟器定义的颜色方案，影响的是 shell 下 16 种基本颜色的显示，如 ls、grep、systemctl 等命令输出标准的 16 色文字修饰代码。

但各命令对自己的输出使用何种颜色，有自己的方案，如 ls 命令对子目录显示蓝色，可执行 .sh 文件显示绿色，对特定类型的文件用不同的颜色显示，都可以设置为方案：这些命令通过变量 $LS_COLORS 获取颜色值，由命令所在的服务器端的 dir_colors 文件设置，参见 `man dir_colors`。如果你发现登录不同的 Linux 主机后，使用 ls 等命令对特定类型的文件显示颜色有差别，就是 dir_colors 方案不同导致的，并不是你的终端模拟器设置的 16 种基本颜色有问题。

    $ dircolors | tr ":" "\n"
    LS_COLORS='rs=0
    di=01;34
    ln=01;36
    mh=00
    pi=40;33
    ex=01;32
    *.tar=01;31
    *.tgz=01;31
    *.arc=01;31

dir_colors 颜色方案推荐使用 Nord 北极，可影响 ls、tree 等命令

    https://www.nordtheme.com/docs/ports/dircolors/type-support
        https://github.com/arcticicestudio/nord-dircolors

    curl -fsSLo ~/.dir_colors https://github.com/arcticicestudio/nord-dircolors/raw/develop/src/dir_colors

注意这些颜色方案虽然统一，但整体仍然受终端模拟器对 16 种基本颜色的设置控制，也就是说，在终端模拟器中使用颜色方案，可以覆盖 dir_colors ，比如 dir_colors 定义 .tar 文件为红色，但终端根据 16 种颜色方案来呈现具体何种红色。

有些软件支持自定义颜色方案，色彩效果超越终端模拟器设置：

    比如，tmux、vim 有自己的色彩方案设置。

    要开启这些软件自己的 256color 和 RGB 真彩色两个选项，最好两个选项都开启，否则在使用这两个软件时，还是无法呈现真彩色。

详见下面章节中的各软件自己的配置文件样例，可参考 <https://lotabout.me/2018/true-color-for-tmux-and-vim/>。

而且，基于跟前面章节所述同样的原因，不要使用 tmux、vim 默认的主题颜色，应该自定义设置，选用颜色更丰富的其它主题，这样才能看出来真彩效果。

#### base16 颜色方案

    https://github.com/chriskempson/base16

base16 是语法高亮时的定义，但是也可以直接给终端模拟器的16色方案使用

    # https://github.com/chriskempson/base16/blob/main/styling.md
    base00 - Default Background
    base01 - Lighter Background (Used for status bars, line number and folding marks)
    base02 - Selection Background
    base03 - Comments, Invisibles, Line Highlighting
    base04 - Dark Foreground (Used for status bars)
    base05 - Default Foreground, Caret, Delimiters, Operators
    base06 - Light Foreground (Not often used)
    base07 - Light Background (Not often used)
    base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A - Classes, Markup Bold, Search Text Background
    base0B - Strings, Inherited Class, Markup Code, Diff Inserted
    base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D - Functions, Methods, Attribute IDs, Headings
    base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>

#### 配色方案：支持终端模拟器和命令行软件的主题 Nord theme 等

强烈推荐 Nord theme，支持的软件众多，详见各软件介绍的美化相关章节即可。至少使用在章节 [命令行软件支持真彩色 dir_colors]、[mintty 美化]、[vim 扩展插件]的颜色主题、[Linux 桌面下的终端模拟器]的主题设置。

Nord theme

    https://www.nordtheme.com/ports/
        https://github.com/arcticicestudio/

Dracula theme

    https://draculatheme.com/
        https://github.com/dracula/dracula-theme/tree/master/themes

支持  Gnome Terminal, Pantheon Terminal, Tilix, and XFCE4 Terminal 的彩色方案

    https://gogh-co.github.io/Gogh/

可以使用 pywal 让终端的文字颜色自动适配你的桌面图片，详见章节 [根据图片生成相同风格的配色方案]。

颜色方案：

10进制

    # https://github.com/arcticicestudio/nord-mintty/blob/develop/src/nord.minttyrc
    # https://github.com/arcticicestudio/nord-konsole/blob/develop/src/nord.colorscheme
    BackgroundColour=46,52,64
    ForegroundColour=216,222,233
    CursorColour=216,222,233
    Black=59,66,82
    BoldBlack=76,86,106
    Red=191,97,106
    BoldRed=191,97,106
    Green=163,190,140
    BoldGreen=163,190,140
    Yellow=235,203,139
    BoldYellow=235,203,139
    Blue=129,161,193
    BoldBlue=129,161,193
    Magenta=180,142,173
    BoldMagenta=180,142,173
    Cyan=136,192,208
    BoldCyan=143,188,187
    White=229,233,240
    BoldWhite=236,239,244

16进制

    # https://github.com/arcticicestudio/nord-termite/blob/develop/src/config
    # https://github.com/arcticicestudio/nord-terminator/blob/develop/src/config

    [colors]
    cursor = #d8dee9
    cursor_foreground = #2e3440

    foreground = #d8dee9
    foreground_bold = #d8dee9
    background = #2e3440
    感觉太亮可以改为 #282C34，对应 RGB=40,44,52

    highlight = #4c566a

    这里是标准的8种颜色
    color0  = #3b4252
    color1  = #bf616a
    color2  = #a3be8c
    color3  = #ebcb8b
    color4  = #81a1c1
    color5  = #b48ead
    color6  = #88c0d0
    color7  = #e5e9f0

    这里是上面8种颜色对应的 Bold 或 bright
    color8  = #4c566a
    color9  = #bf616a
    color10 = #a3be8c
    color11 = #ebcb8b
    color12 = #81a1c1
    color13 = #b48ead
    color14 = #8fbcbb
    color15 = #eceff4

三种模式

    # https://github.com/arcticicestudio/nord-alacritty/blob/main/src/nord.yml

    colors:
    primary:
        background: '#2e3440'
        foreground: '#d8dee9'
        dim_foreground: '#a5abb6'
    cursor:
        text: '#2e3440'
        cursor: '#d8dee9'
    vi_mode_cursor:
        text: '#2e3440'
        cursor: '#d8dee9'
    selection:
        text: CellForeground
        background: '#4c566a'
    search:
        matches:
        foreground: CellBackground
        background: '#88c0d0'
        bar:
        background: '#434c5e'
        foreground: '#d8dee9'

    这里是标准的8种颜色
    normal:
        black: '#3b4252'
        red: '#bf616a'
        green: '#a3be8c'
        yellow: '#ebcb8b'
        blue: '#81a1c1'
        magenta: '#b48ead'
        cyan: '#88c0d0'
        white: '#e5e9f0'

    这里是上面8种颜色对应的 Bold 或 bright
    bright:
        black: '#4c566a'
        red: '#bf616a'
        green: '#a3be8c'
        yellow: '#ebcb8b'
        blue: '#81a1c1'
        magenta: '#b48ead'
        cyan: '#8fbcbb'
        white: '#eceff4'

    这里是一个暗淡风格的 nord theme，其它地方未见
    dim:
        black: '#373e4d'
        red: '#94545d'
        green: '#809575'
        yellow: '#b29e75'
        blue: '#68809a'
        magenta: '#8c738c'
        cyan: '#6d96a5'
        white: '#aeb3bb'

##### 根据图片生成相同风格的配色方案

1、 pywal 一条命令实现根据指定图片自动调整你的终端模拟器的颜色方案

    https://itsfoss.com/pywal/

支持多种终端模拟器，支持多种风格和主题，当前打开的终端即时生效，极其方便

    # 默认你的Linux自带 python3
    $ pip install pywal

    $ wal -i /path/to/wallpaper_file

只是在我的 Fedora 38 下没能自动设置为桌面背景。

使新打开的终端也可以生效，把如下语句加入 .bashrc 登录脚本即可：

```bash
# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh
```

计算机重启后使用上次的颜色方案

    wal -R

2、schemer2 可以用读取指定的图片，生成该图片用色风格的 base16 配色方案

    https://github.com/thefryscorer/schemer2

    # 普通使用生成 colors 即可，格式对应上面的 base16 在语法高亮时的定义
    schemer2 -format img::colors -in 111dark2.jpg -out colors.txt

给终端模拟器使用，转换为 mintty 的颜色方案使用如下 python 代码

```python

# https://github.com/thefryscorer/schemer2
#   schemer2 -format img::colors -in 111dark2.jpg -out colors.txt
#   python3 colors_to_mintty.py
# 查看整体效果 curl -fsSL https://github.com/mintty/utils/raw/master/colourscheme |bash

mintty_template=(
    'Black=',
    'BoldBlack=',
    'Red=',
    'BoldRed=',
    'Green=',
    'BoldGreen=',
    'Yellow=',
    'BoldYellow=',
    'Blue=',
    'BoldBlue=',
    'Magenta=',
    'BoldMagenta=',
    'Cyan=',
    'BoldCyan=',
    'White=',
    'BoldWhite='
)

with open('./colors.txt', encoding="utf-8") as f:
    colorStringHex = f.readlines()

print('\nPut below into your .minttyrc file:\n')

for m in range(16):

    # From https://stackoverflow.com/questions/29643352/converting-hex-to-rgb-value-in-python
    rgb = tuple(str(int(colorStringHex[m].strip('#')[i:i+2], 16)) for i in (0, 2, 4))
    #print(rgb)

    mintty_rgb = mintty_template[m] + ','.join(rgb)
    print(mintty_rgb)

print('''\n
Then restart mintty to take effect, you can run

    `curl -fsSL https://github.com/mintty/utils/raw/master/colourscheme |bash`

to see the color scheme.''')

```

### bash 命令提示符美化

bash 下文字显示彩色有依赖，详见章节 [终端模拟器和软件的真彩色设置]。

使用 powerline 可实现在命令提示符显示各种状态，参见章节 [状态栏工具 powerline]

    # 发行版安装的在 /usr/share 下，如果是 pip 安装的用 `pip show powerline-status` 查看路径
    source /usr/share/powerline/bindings/bash/powerline.sh

bash 内置命令和快捷键见 (shellcmd.md) 的相关章节。

#### bash 命令行提示符显示 python 环境名

自行实现的在命令行提示符显示 conda/virtualenv 环境名，见 [bash_profile.sh] 中双行彩色命令行提示符，显示当前路径、git分支、python环境名部分的代码段落。

    https://zhuanlan.zhihu.com/p/572716915

Anaconda 在安装时会配置你的 bash，当你进入命令行提示符即自动执行 `conda activate` 到默认的[base]环境，可以关掉这个特性：

    $ conda config --set auto_activate_base false

    以后进入环境手动执行 `conda activate` 即可。

使用 conda 命令激活环境时，默认会修改命令行提示符，比较丑，Windows cmd 下还好，只是增加个前缀 (base) C:\>，在 mintty bash 下是个两行的怪物，而且默认不支持 utf-8。

    仅供参考，bash 下使用 conda 自定义 PS1 变量的尝试过程：

        bash 使用 conda 自定义 PS1

            $ conda env config vars set PS1='($CONDA_DEFAULT_ENV)[\u@\h:\W]$'

        这样设置后，进入 bash 后使用 conda 的效果如下：

        1、如果先执行 conda activate，会导致激活其它环境的嵌套显示

            ┌─[your_bash_PS1]
            └──$ conda activate
            (base)[user_name@host_name:current_dir]$

        再激活其它环境，会有俩环境名

            (base)[user_name@host_name:current_dir]$conda activate p37
            (p37) (p37)[user_name@host_name:current_dir]$

        退出环境时也需要执行两遍 conda deactivate

        2、如果不先执行 conda activate ，直接激活指定的环境，这样前缀了一个环境名，但是换行了。。。

            ┌─[your_bash_PS1]
            └──$ conda activate p37
            (p37)
            ����[16:32:37 user_name@host_name:current_dir]
            ������$

        3、太丑了，还是取消 conda 设置的命令行提示符吧

            # 需要进入 conda 环境再执行
            conda env config vars unset PS1

最终方案：用 bash 自定义 PS1 变量显示 conda 环境名

1、把 conda 的自定义 PS1 变量关掉

    自定义 conda 的环境名格式，需要先修改 conda 的默认设置，不允许 conda 命令修改 PS1 变量

    在 Anaconda cmd 命令行下执行（或者cmd下手工激活base环境，执行命令 `conda activate`）做如下的设置，只做一次即可

        让 Anaconda 可以 hook 到 .bash_profile

            $ conda init bash

            会自动在 ~/.bashrc 或 .bash_profile.sh 文件添加如下内容：
                eval "$(/home/uu/anaconda3/bin/conda shell.bash hook)"

        禁止 conda 修改命令行提示符，以防止修改 PS1 变量

            $ conda config --set changeps1 False

        禁止 conda 进入命令行提示符时自动激活base环境，以方便检测 $CONDA_DEFAULT_ENV 变量

            $ conda config --set auto_activate_base false

    在 ~/.condarc 文件中可以看到设置生效：

        changeps1: false
        auto_activate_base: false

    这样在用户登录进入bash环境后，执行 `conda activate` 后读取 $CONDA_DEFAULT_ENV 变量即可获取到当前环境名。

2、virtualenv 的处理类似 conda

    先禁止 virtualenv 环境中的 activate 命令在 PS1 变量添加环境名称

        export VIRTUAL_ENV_DISABLE_PROMPT=1

    这样在用户登录进入bash环境后，执行 `source activate` 后读取 $VIRTUAL_ENV 变量即可获取到当前环境名。

3、在 PS1 变量的设置代码中读取二者的环境名变量，具体实现详见 [bash_profile.sh] 中的 PS1conda-env-name 和 PS1virtualenv-env-name 代码段落。

### 状态栏工具 powerline

bash 下文字显示彩色有依赖，详见章节 [终端模拟器和软件的真彩色设置]。

Powerline 最初是一款 Vim statusline 的插件，后来发展到支持 bash、vim、tmux 等众多工具及插件，安装 powerline 后都可适配进行状态栏显示。

    https://github.com/powerline/powerline/

    配置说明 https://powerline.readthedocs.io/en/master/configuration/reference.html

powerline 最大的优点是它使用图标字体图形化的显示文件夹、电池、git状态、进度等，插件制度非常灵活。这些字体需要单独安装，详见章节[图标字体]。

powerline 的缺点是它的代码 python2、3 混杂，安装和使用都很难配置，所以现在有些插件不使用它了。

最简单的安装方法是用发行版自带的，一步到位，默认的安装到 /usr/share/powerline/ 目录下了

    $ sudo apt install powerline

手工安装最新版，需要先确定你当前操作系统的命令 `python` 指向的是 python2 还是 python3，我的 Debian 10 默认是 python2。如果从 github 安装最新版的 powerline 只支持 python3，所以得改设置

    # https://askubuntu.com/questions/283908/how-can-i-install-and-use-powerline-plugin
    # https://powerline.readthedocs.io/en/latest/installation.html
    #
    # 最好别用pip安装，我折腾了一上午都搞不定最终起效的设置
    # https://powerline.readthedocs.io/en/latest/installation.html
    # pip install powerline-status 这个是python2的一堆坑
    # python3 -m pip install --user git+https://github.com/powerline/powerline
    #

安装后有个后台进程

    # 由 systemd 调度管理 /etc/systemd/user/default.target.wants/powerline-daemon.service
    $ ps -ef|grep powerline
    00:00:00 /usr/bin/python3 /usr/bin/powerline-daemon --foreground

    TODO: 研究下用 python 实现的 select()

你使用的终端工具的 Terminal 相关参数设置中设置 xterm-256color，防止用户登录脚本未设置变量 $TERM，以保证命令行显示的颜色更丰富

    # 显式设置终端启用256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
    export TERM="xterm-256color"

#### 使用 powerline-config 命令行安装为各软件的状态栏插件

    $ powerline-config -h
    usage: powerline-config [-h] [-p PATH] {tmux,shell} ...

    Script used to obtain powerline configuration.

    positional arguments:
    {tmux,shell}
        tmux                Tmux-specific commands
        shell               Shell-specific commands

tmux:

    $ powerline-config tmux

其它的shell，我没弄出来效果呢？

    $ powerline-config shell -s bash uses prompt

    $ powerline-config shell -s zsh uses prompt

#### 手工配置各软件的绑定

先查看你安装 powerline 的位置，找到bindings目录

    # 如果是 pip 安装的查看路径用 pip show powerline-status
    . /usr/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh

    # 如果是用 apt 安装的 powerline
    $ ls /usr/share/powerline/bindings
    awesome  bar  bash  fish  i3  lemonbar  qtile  rc  shell  tcsh  tmux  zsh

然后在各软件的配置文件中设置插件，指向这个bindings目录下的脚本即可，详见各软件的说明。

bash

    source /usr/share/powerline/bindings/bash/powerline.sh

zsh:

    source /usr/share/powerline/bindings/zsh/powerline.zsh

#### 定制 powerline 状态栏显示的段Segment

编辑文件

    # 如果是 pip 安装的查看路径用 pip show powerline-status
    /usr/share/powerline/config_files/themes/相关软件名/xxx.json

替换自己喜欢的函数即可

    官方函数说明 https://powerline.readthedocs.io/en/master/configuration/segments.html

想自己做个状态栏工具，参考下这个

    https://github.com/agnoster/agnoster-zsh-theme

#### 竞品 starship

starship 通用的状态栏工具，支持 bash、zsh、PowerShell、cmd 等 shell

    https://starship.rs/zh-CN/
        https://github.com/starship/starship

    https://sspai.com/post/72888

zsh 下推荐使用 powerlevle10k，这个状态栏工具的兼容性和显示效果直接起飞，见章节 [推荐主题powerlevel10k]。

### 图标字体

    https://juejin.cn/post/6844904054322102285

    Font Awesome 图标字体工具 给字体添加图标的工具

        https://fontawesome.com/v5/cheatsheet

    无图标字体的显示效果，在这里查看

        https://coding-fonts.pages.dev/fonts/fira-code/

        https://www.programmingfonts.org/#meslo

作为程序员，使用终端模拟器跟命令行打交道，设置一个赏心悦目的命令行提示符 bash prompt 或 vim、tmux 的状态栏主题就很有必要了，一般这些漂亮的主题都会用到一些图标字符（glyphs），比如 pythone 环境的小蛇，系统温度的温度计等。

而主流操作系统（Windows/Linux）中内置的普通字体，很多特殊字符不支持导致显示不正确，这也是很多人在安装一些主题后，显示效果不理想的原因。

所以，编程爱好者自行给流行的字体打补丁，补齐了图标字符（glyphs），称为 patch 字体。

最流行的有 Powerline fonts 或者 Nerd fonts 这些字体集，他们对大量的流行字体（尤其是编程用的等宽类）打了 patch，新增很多图标字符。

只有你的操作系统安装了这些补丁字体，然后设置你的终端模拟器程序使用该补丁字体，那些漂亮的主题效果才会完美呈现出来。

补丁字体要安装到你本地使用的计算机上，然后设置你的终端模拟器或编辑器使用该字体

    不要把字体安装到远程服务器

    你在 Windows 下使用 putty 或 mintty 等终端工具，则补丁字体要安装到你的 Windows 系统中

    你在 Linux 下使用 Gnome 等桌面环境，则补丁字体要安装到你的 Linux 系统中

    你在 MacOS 下使用 iTerm2 终端工具，则要在你的苹果电脑上安装这些补丁字体

这些补丁字体都是优化的英文和数字符号的显示，对中文字符会回落到当前系统的默认中文字体，详见 [设置中文字体]。

简单测试几个 unicode 字符看看能否显示为正确的图标

    $ echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
     ±  ➦ ✘ ⚡ ⚙

目前很多终端模拟器或文本编辑器，都内置支持 powerline glyphs。所以，如果显示的图标跟你的字体效果不符，一般是因为它们自行实现了字符效果，而会忽略你选择字体的字符效果。

#### Powerline fonts

Nerd fonts 是 Powerline fonts 的超集，建议直接使用 Nerd font，参见下面章节 [Nerd font]。

    https://github.com/powerline/fonts

Powerline 在 bash 时期非常流行，为了显示各种好看的图标使用了特殊的 icon 字符。powerline fonts 就是给 Powerline 配套的字体集，本质是对一些现有的字体打 patch，把 powerline icon 字符添加到这些现有的字体里去，目前对非常多的编程字体打了 patch。

Powerline fonts 对打过 patch 的字体做了重命名，后面都加上了 for Powerline 的后缀，比如 Source Code Pro 打完 patch 后名字改为了 Source Code Pro for Powerline。

很多 Linux 发行版如 Debian 都带 powerline 字体

    # Debian 等发行版自带
    $ sudo apt install fonts-powerline
    $ sudo apt install ttf-ancient-fonts

手动安装最新版

    $ git clone --depth=1 https://github.com/powerline/fonts.git

    $ cd fonts
    $ ./install.sh

    $ cd ..
    $ rm -rf fonts/

#### Nerd font

    https://www.nerdfonts.com/font-downloads
        https://github.com/ryanoasis/nerd-fonts

Nerd font 是 Powerline fonts 的超集，他几乎把目前市面上主流的 icon 字符全打进去了，包括上面提到的 powerline icon 字符以及 Font Awesome 等几千个 icon 字符。

字体名称在 patch 后对加了后缀 NF 以示区别，比如 Source Code Font 会修改为 Sauce Code Nerd Font (Sauce Code 并非 typo，故意为之)，Fira Code 改名为 Fira Code NF。

> Meslo LG-S NF 字体，用于终端模拟器，如果你的终端模拟器还支持透明效果，显示效果直接起飞。

这个是 Powerlevel10k 推荐的字体

    https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k

    发布版
        https://github.com/ryanoasis/nerd-fonts/releases 找 Meslo.tar.xz

    开发版
        https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo/S

选 S 的原因是要行间距小的，在终端显示的时候正好，如果需要增大行间距，不建议换字体，在终端模拟器或你的编辑器设置行距更好。

逐个目录选择文件名最短的下载，即选 MesloLGSNerdFont-*.ttf，不下载 Mono 和 Propo 类型的

    文件名加 Mono 字样的是等宽变形，显示时太挤了

    文件名加 Propo 字样的是多行连线优化，普通场景不需要

上游来源字体

    Meslo  https://github.com/andreberg/Meslo-Font
        Apple’s Menlo-Regular
            Bitstream Vera Sans Mono

> FiraCode NF 字体，用于代码编辑器，该字体支持连字符，Windows 用户找带 Windows 字样的下载即可

    发布版
        https://github.com/ryanoasis/nerd-fonts/releases 找 FiraCode.tar.xz

    开发版
        https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode

文件名加 Mono 字样的是等宽变形不包含连字。

上游来源字体

    FiraCode https://github.com/tonsky/FiraCode

#### Fedora(SELinux) 下安装下载的字体

因为发行版的存储库没有 nerd font，只能手动安装，只是安装方法有点复杂：

    https://docs.fedoraproject.org/en-US/quick-docs/fonts/#system-fonts
        https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/desktop_migration_and_administration_guide/configure-fonts#add-extra-fonts

先下载并解压上述两个字体文件

        $ curl -fsSLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.tar.xz
        $ curl -fsSLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.tar.xz

        $ xz -d Meslo.tar.xz
        $ xz -d FiraCode.tar.xz

        $ tar xf Meslo.tar
        $ tar xf FiraCode.tar

方法一：适合批量安装字体，保存在系统目录 /usr/share/fonts/，全局生效

```bash

sudo su

mkdir -p /usr/share/fonts/MesloLGSNF
mkdir -p /usr/share/fonts/FiraCodeNF

cp MesloLGSNerdFont-*.ttf /usr/share/fonts/MesloLGSNF/
cp FiraCodeNerdFont-*.ttf /usr/share/fonts/FiraCodeNF/

# Set permissions and update SELinux labels
chown -R root: /usr/share/fonts/MesloLGSNF
chmod 755 /usr/share/fonts/MesloLGSNF/
chmod 644 /usr/share/fonts/MesloLGSNF/*
restorecon -vFr /usr/share/fonts/MesloLGSNF

chown -R root: /usr/share/fonts/FiraCodeNF
chmod 755 /usr/share/fonts/FiraCodeNF/
chmod 644 /usr/share/fonts/FiraCodeNF/*
restorecon -vFr /usr/share/fonts/FiraCodeNF

# Update the font cache
fc-cache -v

```

方法二：放在用户目录，仅当前用户生效

Gnome 桌面环境下双击字体文件，会调用 gnome-font-viewer 图形化程序，选择安装后会自动保存在

    # /usr/local/share/fonts/ 这个目录没有被 SELinux 配置默认规则，RHEL 系不会生效。
    $HOME/.local/share/fonts/ 或 $HOME/.font/

确认下字体文件设置权限

    /usr/share/fonts/ 下的目录是 755，字体文件是 644

    $HOME/.local/share/fonts 下的字体文件是 644

gnome-font-viewer 图形化程序有个 bug 至今未改，字体安装不提示完成，总是 installing...，蒙着等一阵关了它就行。。。

验证：简单测试几个 unicode 扩展 NF 字符

    $ echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699 \u2743 \uf70f \ue20a \ue350 \uf2c8"
     ±  ➦ ✘ ⚡ ⚙ ❃    

### 使用 zsh

单纯的 zsh 并不慢，只要别装 ohmyzsh，没有任何功能性插件的使用场景依赖这个 ohmyzsh。

    zsh 手册 https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html

    https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH

    https://www.zhihu.com/question/21418449/answer/300879747

从语法上来说，zsh 和 bash 是不兼容的；但是 zsh 有一个仿真模式，可以支持对 bash/sh 语法的仿真（也有对 csh 的仿真，但是支持不完善，不建议使用）：

    $ emulate bash
    或
    $ emulate sh

安装

    $ sudo dnf install zsh zsh-autosuggestions zsh-syntax-highlighting
    $ sudo apt install zsh zsh-autosuggestions zsh-syntax-highlighting

如果是用 apt install 安装的发行版，位置在 /usr/share/zsh

zsh 默认使用的用户插件位置，在 ~/.zsh/plugin/

可设置当前用户默认登录使用 zsh

    先看下当前系统的各个shell的位置
    $ cat /etc/shells

    # 当前用户修改自己的登录 shell
    $ sudo chsh -s /bin/zsh

    # 修改指定用户的登录shell
    $ sudo usermod -s /bin/zsh username

    重启后登录生效

插件和主题太多了容易搞乱环境，保守点的用法

    登录环境默认还是用 bash，登录后手动执行 `exec zsh` 切换到zsh

    如果执行 `zsh` 则在 bash 的基础上进入 zsh，执行 exit 退出时会先退出到 bash，然后再次 exit 才是断开连接

如果是安装后初次运行 zsh，有个引导程序设置 zsh 的配置文 ~/.zshrc 文件，也可以手动调用

    $ zsh

    $ autoload -Uz zsh-newuser-install

    $ zsh-newuser-install -f

如果之前使用 bash，在 ~/.zshrc 文件中加上 `source ~/.bash_profile`，可以继承执行 bash 的配置文件。

有些插件和主题依赖 python 和 git，注意提前安装好。

zsh 命令提示符默认使用简洁的 pure 主题

    https://github.com/sindresorhus/pure

    想要花哨的，安装 powerlevel10k 足够了，参见章节[推荐状态栏工具 powerlevel10k]，它也可设置为 pure 风格。

zsh 自带功能

    命令和目录智能补全：相对于 bash，两次 TAB 键只能用于提示目录，在 zsh 中输入长命令，输入开头字母后连续敲击两次 TAB 键 zsh 给你一个可能的列表，用tab或方向键选择，回车确认。比如已经输入了 svn commit，但是有一个 commit 的参数我忘记了，我只记得两个减号开头的，在svn commit -- 后面按两次TAB，会列出所有命令。

    快速跳转：输入 cd - 按 TAB，会列出历史路径清单供选择。

#### 安装常用的插件

下面的几个常用插件挨个装太复杂了，想无脑安装参见章节 [开箱即用一步到位的软件包 -- zsh4humans]。

除了 powerline 外，其它的插件都要进入 zsh 后再执行安装

    powerline：见章节[状态栏工具 powerline]，建议使用替代品见章节 [推荐状态栏工具 powerlevel10k]。

    命令自动完成：输入完 “tar”命令，后面就用灰色给你提示 tar 命令的参数，而且是随着你动态输入完每一个字母不断修正变化，tar -c 还是 tar -x 跟随你的输入不断提示可用参数，这个命令提示是基于你的历史命令数据库进行分析的。按 TAB 键快速进入下一级，或直接按右方向键确认该提示。最方便的用法是按 alt+m 或 alt+l(vi的右方向键)自动接受结果，回车即执行，更方便。

        $ sudo dnf install zsh-autosuggestions
        $ sudo apt install zsh-autosuggestions

        # 不使用发行版仓库收录的版本，也可自行安装
        # git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions

    命令语法高亮：根据你输入的命令是否正确的色彩高亮，比如输入date查看时间，错为data，字体的颜色会跟随你的输入一个字母一个字母的变化，错误会直接变红。

        $ sudo dnf install zsh-syntax-highlighting
        $ sudo apt install zsh-syntax-highlighting

        # 不使用发行版仓库收录的版本，也可自行安装
        # git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting

        竞品 https://github.com/zdharma-continuum/fast-syntax-highlighting

    命令模糊查找：输入错的也没关系，给你候选命令的提示，vi模式改良为按上下键进入搜索，直接输入关键字即可

        # https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh
        $ sudo apt install fzf

    快速进入目录 zoxide

        # https://github.com/ajeetdsouza/zoxide
        $ sudo apt install zoxide  # Debian 更新太慢，官方建议直接运行源代码的 install.sh 进行安装

简单启用插件就直接在 ~/.zshrc 文件里使用 source 命令即可，完整示例见章节 [.zshrc 配置文件样例]

    # 显式设置终端启用256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
    export TERM="xterm-256color"

    # 有插件管理这俩设置不需要
    # 启用彩色提示符
    # autoload -U colors && colors
    # 每次命令行刷新提示符
    # setopt prompt_subst

    # 如果是用 apt install 安装的发行版插件，位置在 /usr/share/ 目录
    # 手动安装的插件，位置在 ~/.zsh/plugins/ 目录

    # 启用插件：状态栏工具
    # 如果是pip安装的查看路径用 pip show powerline-status
    source /usr/share/powerline/bindings/zsh/powerline.zsh

    # 启用插件：命令自动完成
    # source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    # 启用插件：命令语法高亮
    # 官网提示要在配置文件的最后一行
    # source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    # 命令自动完成的颜色太暗  # ,bg=cyan
    # https://github.com/zsh-users/zsh-autosuggestions#suggestion-highlight-style
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#006799,bold"

zsh下，如果想研究哪个插件过慢导致命令行反应让人不爽，有专门搞测量的 zsh-bench

    https://github.com/romkatv/zsh-bench#conclusions

它的建议是状态栏工具使用主题 powerlevle10k，如果还需要自动完成啥的那几个插件，就直接安装 zsh4humans，这些都带了而且有优化。

自己简单测试下加载zsh的速度

    $ for i in $(seq 1 5); do /usr/bin/time /bin/zsh -i -c exit; done
    ...

#### 状态栏工具 powerlevel10k

zsh 命令行提示符工具，这个主题可以完全替代状态栏工具 powerline ，而且更简单、更好看

    https://github.com/romkatv/powerlevel10k

参考图片![powerlevel10k](https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/prompt-styles-high-contrast.png)

可先在docker中试用下

    docker run -e TERM -e COLORTERM -e LC_ALL=C.UTF-8 -it --rm alpine sh -uec '
        apk add git zsh nano vim
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
        echo "source ~/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
        cd ~/powerlevel10k
        exec zsh'

要在字符界面显示炫酷的图标，需要在你使用终端模拟器的计算机上安装 MesloLGS NF 字体，详见章节[图标字体]。

终端模拟器最好明确设置 $TERM 变量，这样各个插件会自动使用更丰富的颜色

    # 或者在你的用户登录脚本 .bash_profile 中显式设置
    # 显式设置终端启用 256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
    export TERM="xterm-256color"

依赖多彩色设置，详见章节 [终端模拟器和软件的真彩色设置]。

如果你的终端模拟器不支持透明效果，且未使用 MesloLGS NF 字体的话，显示风格会有差别，这是设计者做了兼容性考虑，以防止显示不正常。

然后从 github 安装 powerlevel10k

    # https://github.com/romkatv/powerlevel10k#manual
    $ git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

    $ echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

再次进入 `zsh` 就可以起飞了。

初次进入zsh后会自动提示设置使用习惯，之后可以执行命令 `p10k configure` 再次设置。

这个主题自带一堆状态插件包括 git、virtualenv 等，非常好用。如果之前在 zsh 的 plugin 里配置下载了 git 等插件，可以删除他们。

自定义启用它自带的哪些插件，编辑配置文件，用 `echo $POWERLEVEL9K_CONFIG_FILE` 查看，一般是 ~/.p10k.zsh，搜索 `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=` 即可。

##### 自定义状态栏提示段，监控树莓派温度

可运行命令查看帮助说明

    p10k help segment

编辑 ~/.p10k.zsh 文件，搜索 prompt_example，先看说明

1、在状态栏提示段 POWERLEVEL9K_LEFT_PROMPT_ELEMENTS 新增一个处理函数

```shell

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    raspi_thermal_warn      # raspberry pi cpu temperature
    os_icon                 # os identifier
    ...
)

```

2、在函数 prompt_example() 后面追加个新的函数：

``` shell

  function prompt_raspi_thermal_warn() {
    which vcgencmd >/dev/null 2>&1 || return 0

    local CPUTEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

    if [ "$CPUTEMP" -gt  "55000" ] && [ "$CPUTEMP" -lt  "65000" ]; then
      p10k segment -b yellow -f blue -i ''

    elif [ "$CPUTEMP" -gt  "65000" ] && [ "$CPUTEMP" -lt  "70000" ]; then
      local CPUTEMP_WARN="CPU `vcgencmd measure_temp`!"
      p10k segment -b yellow -f blue -i '' -t "$CPUTEMP_WARN"

    elif [ "$CPUTEMP" -gt  "70000" ];  then
      local CPUTEMP_WARN="CPU TOO HOT!`vcgencmd measure_temp`"
      p10k segment -b black -f red -i '' -t "$CPUTEMP_WARN"
    fi
  }

```

如果担心 instant-prompt 功能会在出现 y/n 提示的时候提前输入y，酌情关掉这个功能，编辑 ~/.zshrc 注释掉该文件最前面的几行

    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

#### 开箱即用的软件包 -- zsh4humans

目前不知道哪个功能，经常在你打字的时候加点字符，这个没法用啊

    https://github.com/romkatv/zsh4humans

开箱即用，最常用的几个插件都配置好了：状态栏工具、自动完成、语法高亮、命令模糊查找，而且作者还专门为速度进行了优化

    powerlevel10k
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf

能跨主机记忆命令历史，比如你在本机ssh某个主机后执行的命令，在本机或另一个ssh主机上的命令历史里都可以被回忆到，方便！

    https://github.com/romkatv/zsh4humans/blob/master/tips.md#ssh

注意：该功能的实现方法是套壳 ssh 命令，当你初次ssh连接新的远程主机，会自动在远程主机上安装 zsh4human 等软件包，然后传递自己本地的命令历史。对你的 ssh 配置 ~/.ssh/config 也有要求

    # https://github.com/romkatv/zsh4humans/blob/master/tips.md#ssh-config
    Host *
        ServerAliveInterval 60
        ConnectTimeout 10
        AddKeysToAgent yes
        EscapeChar `
        ControlMaster auto
        ControlPersist 72000
        ControlPath ~/.ssh/s/%C

这个功能有点安全隐患，默认是关闭的，可设置白名单模式指定开启，如对自己内网的计算机

    # Disable SSH teleportation by default.
    zstyle ':z4h:ssh:*'                   enable no

    # Enable SSH teleportation for specific hosts.
    zstyle ':z4h:ssh:example-hostname1'   enable yes
    zstyle ':z4h:ssh:*.example-hostname2' enable yes

如果非常不喜欢这个功能，编辑 ~/.zshrc 搜索“ssh”字样，找到相应代码去掉它即可。

设置技巧，有些设置都是插件里的，注意区别

    https://github.com/romkatv/zsh4humans/blob/master/tips.md

安装过程需要注意看看设置是否符合自己的实际需求

    ┌─[14:58:59 user@yourhost:~]
    └──$ if command -v curl >/dev/null 2>&1; then   sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"; else   sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"; fi
    Greetings, Human!

    What kind of keyboard are you using?

    (1)  Mac. It has Option key(s) and does not have Backspace.
    (2)  PC.  It has Backspace key(s) and does not have Option.
    (q)  Quit and do nothing.

    Choice [12q]: 2

    What keybindings do you prefer?

    (1)  Standard. I delete characters with Backspace key.
    (2)  Like in vi. I delete characters with X key in command mode.
    (q)  Quit and do nothing.

    Choice [12q]: 1

    提示是否在 tmux 里一直使用 zsh，我选的 No。
    Do you want zsh to always run in tmux?

    (y)  Yes.
    (n)  No.
    (q)  Quit and do nothing.

    Choice [ynq]: n

    Do you use direnv?

    (y)  Yes.
    (n)  No.
    (q)  Quit and do nothing.

    Choice [ynq]: n

    Settings up Zsh For Humans...

    z4h: fetching z4h.zsh from github.com/romkatv/zsh4humans
    z4h: generating ~/.zshenv
    z4h: generating ~/.zshrc
    z4h: bootstrapping zsh environment
    z4h: installing zsh4humans
    z4h: cannot find usable zsh
    z4h: fetching zsh 5.8 installer

    选择把 zsh 安装到home下，而且不作为默认登录shell
    Choose installation directory for Zsh 5.8:

    (1)  /usr/local        <= uses sudo (recommended)
    (2)  ~/.local          <= does not need sudo
    (3)  Custom directory.
    (q)  Quit and do nothing.

    Choice [123q]: 2

    ===> installing Zsh 5.8 to /home/user/.local
    ===> fetching zsh-5.8-linux-x86_64.tar.gz
    ===> verifying archive integrity
    ===> sha256 signature matches
    ===> md5 signature matches
    ===> extracting files

    Add /home/user/.local/bin/zsh to /etc/shells?

    This will allow you to use it as a login shell.

    (y)  Yes. Recommended.
    (n)  No.
    (q)  Quit and do nothing.

    Choice [ynq]: n

    Installed Zsh 5.8 to /home/user/.local

    To start Zsh, type:

    zsh

    z4h: login shell isn't the same as this shell

    user         user
    login shell  /bin/bash
    this shell   /home/user/.local/bin/zsh

    Change login shell of user to /home/user/.local/bin/zsh?

    (y)  Yes. Recommended.
    (n)  No.

    Won't ask again unless $Z4H/stickycache/no-chsh is deleted.
    z4h: installing systemd completions
    z4h: installing zsh-history-substring-search
    z4h: installing zsh-autosuggestions
    z4h: installing zsh-completions
    z4h: installing zsh-syntax-highlighting
    z4h: installing terminfo
    z4h: installing fzf
    z4h: fetching fzf binary
    z4h: installing ohmyzsh/ohmyzsh
    z4h: installing powerlevel10k
    z4h: fetching gitstatus binary
    z4h: initializing zsh

    Zsh For Humans installed successfully!

    Next steps:

    - Your new personal Zsh config is in ~/.zshrc. Edit this file to export
        environment variables, define aliases, etc. There are plenty of examples and
        comments to get you started.

    - Zsh does not read startup files used by Bash. You might want to copy bits
        and pieces from them to ~/.zshrc. Here are the files:

        ~/.profile
        ~/.bash_profile
        ~/.bashrc

    - Prompt config from Powerlevel10k is in ~/.p10k.zsh. To customize prompt, you
        can either manually edit this file or generate a new version through the
        wizard:

        p10k configure

    Enjoy Zsh For Humans!

安装完成后记得挑选 Bash 配置文件的部分设置到 ~/.zshrc

      ~/.profile
      ~/.bashrc

#### zsh插件管理器

简单使用不需要插件管理器，安装 zsh4humans 足够了。

antigen

    不更新了2019
        https://github.com/zsh-users/antigen
        https://github.com/zsh-users/antigen/wiki/Installation

    sudo apt install zsh-antigen

    这个是接班的 https://github.com/mattmc3/antidote

zinit（原 zplugin）插件管理器

    https://github.com/zdharma-continuum/zinit
    https://gist.github.com/laggardkernel/4a4c4986ccdcaf47b91e8227f9868ded
    https://zhuanlan.zhihu.com/p/98450570

    这个插件管理器在 ~/.zshrc 文件中的加载设置如下

        # Load powerlevel10k theme
        zinit ice depth"1" # git clone depth
        zinit light romkatv/powerlevel10k

#### 自带插件管理器，内置超多插件和主题的 ohmyzsh

    如果只是简单使用 zsh + powerlevel10k + 自动完成等几个插件，不需要安装ohmyzsh，这货太慢，而且经常自动升级，你进入 zsh 时会等半天它更新才给出提示行...

ohmyzsh 是在 zsh 的基础上增加了更多的花样的shell封装、主题管理等。

    https://ohmyz.sh/
        https://github.com/ohmyzsh/ohmyzsh

先在你使用的终端模拟器的计算机上安装 MesloLGS NF 字体，详见章节[图标字体]。

ohmyzsh 目前是从 github 安装

    # wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

    # 或 sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

在 ~/.zshrc 里设置主题，默认 robbyrussell

    ZSH_THEME=”robbyrussell”

启用插件，编辑 ~/.zshrc 文件，找到 plugins= 的段落填写插件名，空格或回车分隔

    plugins=(git
        conda
        # other plugins...
        zsh-autosuggestions
        # 官网介绍要放到最后
        zsh-syntax-highlighting
    )

下载主题

    https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#overriding-and-adding-themes

    内置主题 https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

    更多的主题
        https://github.com/ohmyzsh/ohmyzsh/wiki/External-themes
            https://github.com/unixorn/awesome-zsh-plugins

内置主题 bira 比较简洁，可手工修改添加时间提示 `RPROMPT="[%*]%B${return_code}%b"` 图例 ![bira](https://user-images.githubusercontent.com/49100982/108254762-7a77a480-716c-11eb-8665-b4f459fd8920.jpg)。

额外主题 [Bullet train](https://github.com/caiogondim/bullet-train.zsh)，可手工修改主机名字段颜色`BULLETTRAIN_CONTEXT_BG=magenta` 。

内置插件在 $ZSH/plugins/ 目录下（默认 ~/.oh-my-zsh/plugins/），兼容zsh插件。

ohmyzsh自带很多主题和插件，用户自己下载定制主题和插件的位置 $ZSH_CUSTOM 目录下（默认 ~/.oh-my-zsh/custom）

    $ZSH_CUSTOM
    ├── plugins
    └── themes
        └── my_awesome_theme.zsh-theme

 ~/.zshrc 文件已经被 ohmyzsh 接管了，插件不需要用 source 运行，改为 plugins=(...) 的形式。

    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

如果你想用自己安装的插件，也可以继续 source xxx 。

ohmyzsh的插件管理机制更智能，还会提示更新，建议用这种方式配置，不再用 ~/.zshrc 文件里逐个 source xxxx 的方式。

#### .zshrc 配置文件样例

安装 powerlevle10k、ohmyzsh(可选) 等几个插件后的配置

```zsh

####################################################################
# powerlevel10k 自动生成的首行，不用动
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

####################################################################
# zsh 自己的内容，不用动
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/uu/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

####################################################################
# 如果安装了 ohmyzsh 会自动生成一堆设置，不用管他
# ...
# ...
# ohmyzsh 自带插件管理，在 plugin=() 段落启用内置插件，可以在这里加载那些 source xxx 的插件

####################################################################
# Zsh：加载插件或小工具
#
# 如果是用 apt install 安装的发行版插件，位置在 /usr/share/ 目录
# 手动安装的插件，位置在 ~/.zsh/plugins/ 目录

# 加载插件：状态栏工具 powerline
# 如果是pip安装的查看路径用 pip show powerline-status
# source /usr/share/powerline/bindings/zsh/powerline.zsh

# 加载插件：命令自动完成。如果是安装的发行版自带的，不需要在这里加载
# source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 加载插件：命令语法高亮。如果是安装的发行版自带的，不需要在这里加载
# 官网提示要在配置文件的最后一行
# source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#################################
# Zsh：手动配置插件

# zsh 执行 cd xxx 命令后自动执行 ls 列出当前文件
chpwd() ls -A
chpwd

# 命令自动完成的颜色太暗  # ,bg=cyan,bold,underline
# zsh 手册的字符高亮部分：`man zshzle`
# https://github.com/zsh-users/zsh-autosuggestions#suggestion-highlight-style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#006799,bold"

####################################################################

# 如果有 .bash_profile，执行之
[[ -f ~/.bash_profile ]] && source ~/.bash_profile

# powerlevel10k 安装程序自动添加的，不用动
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

```

### Linux 桌面下的终端模拟器

有些终端模拟器是跨平台的，见章节 [其他终端模拟器]。

一些使用习惯的变化

    新建的会话默认不执行 .bash_profile，需要设置执行登录脚本 `/bin/bash -l`。

    新建标签会继承前一个标签的会话环境和路径。比如当前标签进入了 toolbox 容器，这时点击新建的标签打开就是进入 toolbox 容器的环境。切换到默认没进入容器的标签，点击新建标签进入的环境就跟当前标签的环境一致。

    目前的终端模拟器的选择即复制功能细分了：鼠标选择的自动复制只是内部剪贴板可用，粘贴热键 shift+ins 或鼠标中键。选择文字后，右键菜单里的复制选项才会到系统剪贴板，然后在其它软件的可以粘贴。粘贴操作系统剪切板的内容需要用鼠标右键菜单的“粘贴”选项才可以。在 tmux 中需要按住 shift 键点右键才弹菜单出来。

    手动打开光标闪动，设置缓存屏幕内容 10000 行。

一般情况下使用桌面内置的终端模拟器足够了，因为我的 Fedora 自带的 Gnome Terminal 不支持背景图片，所以自行安装了 kitty Terminal，兼容性和稳定性最好的是 Konsole，可惜速度太慢。

KDE 桌面自带 Konsole，可订制选项丰富，支持背景图片：

    显示刷新的速度有点慢，按住回车键看看就知道了。但是兼容性最好，没有功能性问题。

    建议用 dnf 安装，图形界面的 Gnome 软件里的 fedora 仓库和 flatpak 仓库的版本更新不及时。

    主题配色方案建议使用 Nord theme，参见 [配色方案：支持终端模拟器和命令行软件的主题 Nord theme 等]

        $ cd ~/your_github_dir/

        $ git clone --depth=1 git@github.com:arcticicestudio/nord-konsole

        $ cd nord-konsole

        $ export XDG_DATA_HOME=$HOME/.local/share; ./install.sh

        如果是 flatpak 安装的 Konsole，建议用 fedora 官方仓库的版本：

            $ export XDG_DATA_HOME=$HOME/.var/app/org.kde.konsole/data

            $ mkdir -p $XDG_DATA_HOME/konsole

            $ cp src/nord.colorscheme $XDG_DATA_HOME/konsole

    窗口主菜单栏选择 Setting-->Configure Konsole：

        ->General，取消勾选 “Remember Window Size”，勾选 “Remove windonw title bar and frame”，这样你的屏幕可用面积扩大了一行。

        ->Profiles，选New新建 然后点击ok确定。

        然后Edit编辑刚刚新建的Profile1：

            -->General Settings->command: /bin/bash -l，这样设置会话执行登录脚本，并取消勾选“Start in same directory as current session”，这样新建标签的会话不会自动进入之前的工作目录。

            -->Appearance，颜色方案选 Nord 即可。还可以选 Edit 该颜色方案，一般把背景透明度设为 10%，壁纸透明度设为 50%（根据你选择的背景图片调整）即可。

            -->Scrolling，给 Scrollback 设置到 10000 行，防止看不全输出内容。

            -->Mouse，如果需要鼠标选择即复制到操作系统剪切板的老习惯，勾选“Copy on select”即可。鼠标右键菜单的复制和粘贴都是到操作系统剪切板。

                其它很多终端模拟器软件使用自己的私有剪切板，鼠标选择默认到私有剪切板，shift+ins 热键也是从私有剪切板粘贴，只有使用鼠标右键菜单的复制和粘贴才是到操作系统剪切板。

        别忘记给新建的Profile1的选择“Set as Default”，这样才会生效。

    窗口主菜单栏选择 “Setting”，取消勾选 “Show Menubar”，这时主菜单成为窗口右上角的一个三个横线的图标，点击才显示主菜单栏，这样你的屏幕可用面积又扩大了一行。

Xfce 桌面自带 Xfce Terminal，支持背景图片：

    主题配色方案建议使用 Nord theme，参见 [配色方案：支持终端模拟器和命令行软件的主题 Nord theme 等]

        $ cd ~/your_github_dir/

        $ git clone --depth=1 git@github.com:arcticicestudio/nord-xfce-terminal

        $ cd nord-xfce-terminal/

        $ ./install.sh

    或可以手动把文件 `nord.theme` 拷贝到本地的配置目录 `~/.local/share/xfce4/terminal/colorschemes` 下即可。

    窗口菜单选 Edit->Preference:

        -->Colors->Presets，选择 Nord 颜色方案。

        -->General-->Command，勾选 `Run command as login shell` 以设置会话执行登录脚本

        -->Appeaerance-->Background，设置背景图片，目前不支持透明，只支持图片调明暗
                      -->Open New Windows，只勾选 `Display toolbar ...`，这样打开的窗口不会有标题栏和菜单栏

Ptyxis 以容器为中心的终端模拟器，原名 Prompt，显示刷新速度快

    Fedora 41 用它代替了 Gnome Terminal

    它的特色是有一个小型的 ptyxis-agent 后台进程来管理 PTY、PID 跟踪和容器监控。
    而且，即使在 Flatpak 中，它也支持本机“用户会话”，以及 Podman、Toolbox、Distrobox 和 JHBuild。

    主题配色方案内置了 Nord theme，但是不支持背景图片，已经内置在 Fedora 41。

    目前对 tmux 的支持不好，鼠标不听话。

    目前只能使用 dconf 设置窗口透明度

        $ dconf read /org/gnome/Ptyxis/default-profile-uuid
        'ddb03e60e8d36dec96ef51fb67345f90'

        $ dconf write /org/gnome/Ptyxis/Profiles/ddb03e60e8d36dec96ef51fb67345f90/opacity 0.95

Gnome Terminal，不支持背景图片：

    Gnome 桌面自带 Xterm，自 Fedora 41 开始被 Ptyxis 替换

    主题配色方案建议使用 Nord theme，参见 [配色方案：支持终端模拟器和命令行软件的主题 Nord theme 等]

        $ cd ~/your_github_dir/

        $ git clone --depth=1 https://github.com/nordtheme/gnome-terminal.git gnome-terminal-nordtheme

        $ cd gnome-terminal-nordtheme/src; ./nord.sh

        执行后新建终端窗口时就多了个 Nord 的配置文件，设为默认即可

    窗口菜单选 Profile，选 Nord，设为默认即可，其它选项点击右侧项：

        -->command 勾选 Run command as a login shell 以设置会话执行登录脚本

        -->color：不再支持设置背景图片，但仍可设置窗口透明度。

kitty 使用 gpu 进行显示加速的本地终端模拟器，只能在 Linux/MacOS 桌面下使用

    kitty 的系统资源占用最少，基本功能全有
        https://sw.kovidgoyal.net/kitty/performance/#energy-usage

        https://github.com/kovidgoyal/kitty
            https://www.linuxshelltips.com/kitty-terminal-emulator-linux/

    已知问题：关闭 kitty 后干扰中文输入法在其它软件中打不上字，需要再打开 kitty

    配置说明

        https://sw.kovidgoyal.net/kitty/conf/

    常用插件挺好用 https://sw.kovidgoyal.net/kitty/kittens_intro/

    设置 kitty 使用颜色主题，运行命令 `kitty +kitten themes`，会进入字符GUI界面，根据提示操作即可，推荐使用内置 Nord 主题。

    复制和粘贴：因为没有右键菜单，所以只能用热键

        ctrl+shift+c 复制到操作系统剪切板
        ctrl+shift+v 从操作系统剪切板粘贴

        shift+insert 从你鼠标选择的内容粘贴

        如果需要鼠标选择的内容自动复制到操作系统剪切板的老习惯，配置文件中开启“Copy on select”即可

    滚动窗口内容：

        鼠标滚轮，右侧出现的滚动条只显示进度但不支持拖动

        触摸板手势，双指上下滑动：等效于鼠标滚轮

        向上/下滚动：Ctrl+Shift+Up Ctrl+Shift+Down

        向上/下翻页：Ctrl+Shift+Page_Up Ctrl+Shift+Page_Down

        快速滚动到顶/底部：Ctrl+Shift+Home Ctrl+Shift+End

        滚动到前一个/下一个shell命令的输出: ctrl+shift+x, ctrl+shift+z

    查找窗口中的文字：

        按下 ctrl+shift+h，会默认使用 `less` 打开滚动缓冲区（scrollback buffer），出现 : 提示符

            按下 / 键后再输入要搜索的内容，按下回车键即可进行正向搜索

            按下 ? 键后输入内容则进行反向搜索

            按下 n 键或 N 键来向前或向后逐个查找匹配项

            按下回车键重新进入 : 提示符号，进行新的搜索

        也可安装插件 [kitty-search](https://github.com/trygveaa/kitty-kitten-search)

    选项卡操作：每个选项卡对应一个窗口

        新建选项卡：Ctrl+Shift+T，窗口最下一行就变成选项卡的标题栏了，鼠标点击即可切换

        切换到前一个/后一个选项卡：Ctrl+Shift+Left Ctrl+Shift+Right

        当前选项卡左移/右移：ctrl+shift+, ctrl+shift+.

        Close Tab：Ctrl+Shift+Q

    窗口操作：每个选项卡下的窗口还可以拆分为多个窗口

        纵向拆分窗口： Ctrl+Shift+Enter

        在不同窗口之间切换：鼠标点击窗口或 Ctrl+Shift+[ 或 Ctrl+Shift+]

        窗口排列为多种布局： Ctrl+Shift+L

        关闭窗口： Ctrl+Shift+w

    shell 集成：鼠标点击命令行文字即可移动光标到此等

        https://sw.kovidgoyal.net/kitty/shell-integration/#shell-integration

    ssh问题：有时 ssh 连接到远程计算机时，可能会报错终端未知或打开终端失败。是因为 Kitty terminfo 文件（curses 库中处理特定终端功能的一组例程）在远程服务器上不可用。

        alias sshk="kitty +kitten ssh" 以后使用 ssh 执行 `sshk user@host` 即可

    扩展插件

        https://sw.kovidgoyal.net/kitty/integrations

        列出插件

            $  kitty +kitten
            。。。

        在配置文件中把插件设置为热键调用

            map ctrl+shift+/ launch --type=overlay --allow-remote-control kitty +kitten scrollback

    我使用的 $HOME$/.config/kitty/kitty.conf 配置文件如下：

        #################################
        # 恢复默认配置 `cp /usr/share/doc/kitty/kitty.conf ~/.config/kitty/kitty.conf`

        # `kitty +kitten themes`
        # BEGIN_KITTY_THEME
        # Nord
        include current-theme.conf
        # END_KITTY_THEME

        # `kitten choose-fonts`
        # BEGIN_KITTY_FONTS
        font_family      family="MesloLGS Nerd Font"
        bold_font        auto
        italic_font      auto
        bold_italic_font auto
        font_size 12.0
        # END_KITTY_FONTS

        # 鼠标选择即复制到操作系统剪切板
        copy_on_select clipboard

        # 选项卡相关设置
        tab_bar_edge top
        tab_bar_style powerline
        tab_powerline_style round

        # 新开窗口执行 shell 登录脚本
        shell /bin/bash --login

        # 窗口内容保留的多些方便查看
        scrollback_lines 10000

        # for use with quake mode drop-down window extension
        remember_window_size no

        # 壁纸
        background_image /home/user/Pictures/125103.jpg
        background_image_layout scaled
        # background_opacity 0.9
        # background_blur 64

        # 光标闪动
        cursor_blink_rate 500

        # 关掉 shell_integration 设置光标形状
        shell_integration no-cursor
        cursor_shape block

        # shell_integration 功能可以实现定位每个命令输出的开始位置
        map f1 scroll_to_prompt -1  # jump to previous
        map f2 scroll_to_prompt 1   # jump to next
        map f3 scroll_to_prompt 0   # jump to last visited

gtk 桌面自带 terminator，纯 python 的一个实现，封装了 Gnome Terminal。

Enlightenment 桌面自带 Terminology。

sway 窗口管理器自带 foot。

guake 仿效游戏 Quake 的下拉式终端窗口，纯 python 的一个实现，封装了 Gnome Terminal。不用安装这个，gnome 桌面有扩展实现该功能，参见章节 [使用 gnome 扩展] 的 quake-mode。

tilix 基于 gtk3 开发的一个平铺式终端模拟器，效果类似 tmux，但是支持各面板的自定义拖曳。

cool-retro-term 显示效果是 CRT 显示器。

terminology 使用 EFL（不支持Wayland） 的终端仿真器，尽可能地模仿 Xterm。

Warp 号称比 iTerm2 顺滑，半开源，只能在 MacOS 桌面下使用

    https://www.warp.dev/
        https://github.com/warpdotdev/Warp
        主题 https://github.com/warpdotdev/themes

#### i3 窗口管理器自带 urxvt(rxvt-unicode)

配置复杂，不整了

    https://segmentfault.com/a/1190000020859490
    https://wiki.archlinux.org/title/Rxvt-unicode

支持设置背景图片

    $ sudo dnf install rxvt-unicode

urxvt 受 Xresources 控制:

    编辑配置文件
    $ vim ~/.Xresources

    加载文件，使配置生效
    $ xrdb ~/.Xresources

    $ urxvt

terminfo 文件在 /usr/share/terminfo/r/rxvt-unicode，拷贝到远程主机的 ~/.terminfo/r/rxvt-unicode 下即可解决终端特殊字符无法识别报错的问题。

.Xresources配置文件示例，太麻烦了，暂时还没配置利索，不弄了：

```conf
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! https://segmentfault.com/a/1190000020859490
! https://wiki.archlinux.org/title/Rxvt-unicode

Xft.dpi: 96
!抗锯齿
Xft.antialias: true
Xft.rgba: rgb
Xft.hinting: true
Xft.hintstyle: hintslight

! do not scroll with output
URxvt*scrollTtyOutput: false

! scroll in relation to buffer (with mouse scroll or Shift+Page Up)
URxvt*scrollWithBuffer: true

! scroll back to the bottom on keypress
URxvt*scrollTtyKeypress: true

!pager
URxvt.secondaryScreen: 1
URxvt.secondaryScroll: 0
URxvt.secondaryWheel: 1

URxvt.font: xft:MesloLGS Nerd Font:size=11
URxvt.letterSpace: -1

!作为登录 shell 启动
URxvt.loginShell: true
!使用的输入法框架名称，这样才可以输入中文
URxvt.inputMethod:IBus
!窗口大小：按字符数的列x行
URxvt.geometry: 110x30
URxvt.depth: 32

!标签式窗口
URxvt.perl-ext-common: tabbed

!URxvt.perl-ext-common:  ...,selection-to-clipboard,...
URxvt.clipboard.autocopy: true
URxvt.keysym.M-c: perl:clipboard:copy
URxvt.keysym.M-v: perl:clipboard:paste

!URxvt.keysym.F11: perl:fullscreen:switch
URxvt.multichar_encoding:gb #汉字编码
URxvt.boldFont:-*-SimHei-* #粗字体
URxvt.mfont: -*-simsun-medium-r-normal-*-14-*-*-*-c-*-gb*-* #汉字字体

URxvt.cursorBlink: true

URxvt.scrollstyle:rxvt
URxvt.scrollBar:True
URxvt.scrollBar_right:True

!屏幕缓冲1万行，足够了
URxvt.saveLines:10000

!背景 参见源代码 /usr/lib64/urxvt/perl/background
URxvt.background.expr: scale keep { load "/home/uu/Pictures/3eleph.png" }
!控制背景透明，变暗（0..99），变亮（101..200)，100 表示没有阴影
URxvt.transparent: true
URxvt.shading: 150

URxvt.background: #2E3440
URxvt.foreground: rgb:d8/de/e9

!可重新定义 xterm color0~15
URxvt.color12: rgb:5c/5c/ff

```

## 常用 shell 编程

shell 命令文档见章节 [man/info 查看帮助信息]。

非常好用的 shell 语句分析器，输入语句就能给出说明

    https://explainshell.com/explain?cmd=join+-1+1+-2+5++%3C%28file+*+%7C+sed+%27s%2F%5B%3A%2C%5D%2F%2Fg%27%29+%3C%28ls+--full-time+-h+%7C+awk+%27%7Bprint+%245%22+%22%246%22+%22%247%22+%22%248%22+%22%249%7D%27%29+%7C+column+-t

参考

    bash 内置命令    `man command`

    bash 语法        `man bash`

    条件测试语句的用法  `man test`

    POSIX Shell 规范

        https://pubs.opengroup.org/onlinepubs/9799919799/
            https://ieeexplore.ieee.org/document/10555529

        左栏上部点击 'Shell & Utilities'，然后点击左栏下部出现的页面中的 '2. Shell Command Language'，内容呈现在右栏。

    GNU Bash 官方文档

        https://www.gnu.org/software/bash/manual/bash.html

        Debian 把常用的脚本命令都介绍了 https://www.debian.org/doc/manuals/debian-reference/index.zh-cn.html

        Linux命令大全搜索 https://github.com/jaywcjlove/linux-command

    zsh 官方文档

        https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html

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

### dash 和 bash

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

### bash 常见符号用法

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

反引号``和$()的作用相同，用于命令替换（command substitution），即完成引用的命令的执行，将其结果替换出来，这个是在子shell的进程中执行的。

    echo `date '--date=1 hour ago' +%Y-%m-%d-%H`
    echo $(date '--date=1 hour ago' +%Y-%m-%d-%H)

$()中只需要使用一个反斜杠进行转义，下列语句表示给var变量赋值，字符串$HOME，只是字符串，不是变量HOME的值

    var2=`echo \\$HOME`
    var3=$(echo \$HOME)

用命令组语法 {...} 将多个命令组合成一个代码块，而不是 (...)，这样可以防止命令替换：

    与 ( ... ) 不同，{ ...; } 不会启动子 Shell，所有命令在当前 Shell 环境中执行，速度更快（无进程创建）。

    特性            ( )                                    { }
    执行环境    子Shell（会继承变量但修改不传回父Shell）    当前Shell（变量修改直接影响父Shell）
    适用场景        需要隔离环境的操作                      需要共享变量的操作

    注意：大括号两侧要留空格 { command1; command2; }，且 { } 内最后一个命令必须用 ; 结尾。

    { ...; } 将一组命令作为一个整体执行（类似于单行命令的复合操作）。

        if { command1 && command2; } || { command3 || command4; }; then
            echo "条件成立"
        fi

        if {
            check_dependency &&
            validate_input &&
            prepare_environment
        }; then
            run_main_task
        fi

${var}用于明确界定变量，与$var并没有区别，但是界定更清晰

    A="to"
    echo $AB 不如 echo ${A}B

变量 ZSH_CUSTOM 有值就用，没有就用后面的，这个用法是zsh的

    # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
    echo ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

字符串截取

    $ url="www.baidu.com"
    $ echo ${url%%.*}  # 显示 www，用于取代 basename 用法，截取前缀
    $ echo ${url##*.}  # 显示 com，用于取代 cut -d. -f2 用法，截取后缀

    从字符串的左边开始计数，那么截取字符串的具体格式如下：

        ${string: start :length}

    $ url="abcdefgh"
    $ echo ${url: 2: 5}
    cdefg

    $ myurl='http://www.example.com/long/path/to/example/file.ext'
    $ echo ${myurl##*/}
    file.ext

    $ url="www.baidu.com"
    $ echo ${url:4:5}
    结果为：baidu     从下标为4开始，截取5个字符。

    $ url="www.baidu.com"
    $ echo ${url: 0-9:5}  # 如果想从字符串的右边开始计数，前面加个 0-
    结果为：baidu    从右边数，b是第9个字符

    $ url="www.baidu.com"
    $ echo ${url:0-9}  # 省略 length，直接截取到字符串末尾
    结果为：baidu.com

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

    [ "x$a" = "x7" ]   # 判断a是否为7

    [ "x$a" = "x" ]    # 判断a是否为空

    [ ! -z "$a" -a "x$a" = "x7" ]  # a不为空且a=7时才为真

[[ ]] 是 test 的升级版，不需要对变量名加双引号，比较运算直接用 =、> 等更直观
[[ ]] 注意两边留空格

    https://www.cnblogs.com/aaron-agu/p/5700650.html

    bash 把双中括号中的表达式看作一个单独的元素，并返回一个退出状态码

    [ ... ] 为shell命令，所以在其中的表达式应是它的命令行参数，所以串比较操作符">" 与"<"必须转义，在 [[]] 中"<"与">"不需转义

    [[ ... ]] 进行算术扩展，而 [ ... ] 不做

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

NOTE: 慎重使用链式逻辑运算

    shell 解释执行是从左向右的，但是逻辑运算符优先级和短路求值会导致你没有料到的结果，特别是在使用如 curl | tee 这类管道操作，建议命令分组或拆分为多步或使用临时文件

        $ true || echo "A" && echo "B"
        B  <--- 这里短路求值跳过了 echo "A" && echo "B" 但是会因为 true 而执行 echo "B"

        $ true || { echo "A" && echo "B"; } && echo "C"
        C <--- 验证上面语句的观点

    所以，尽量别连写逻辑运算，要用分组 ( ) 或 { } 来包裹，使得逻辑运算符的结果符合你的直观预期，以上两句的改写：

        $ true || { echo "A" && echo "B"; }

        $ true || ({ echo "A" && echo "B"; } && echo "C")

    如果不用 ( ) 或 { } 来包裹，猜猜下面的输出结果是不是你想要的，或者再加长点呢：

        $ true || echo "A" || echo "B"

        $ false || echo "A" || echo "B"
        A

        $ false || false || echo "B"
        B

字符串判断用 [[ ]]

    # 如果是判断字符串是否有值，则 -n 可以省略
    [[ $envname ]] && printf "conda:%s" $envname || echo "not..."

    如果变量存在则执行，否则不执行
    [[ -n $conda_env_exist ]] && printf "conda:%s" $envname

    如果变量不等于字符串 running，则返回
    [[ ! "$VM_STATE" = "running" ]] && return

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

    [[ $(command -v vcgencmd >/dev/null 2>&1; echo $?) = "0" ]] || return
    等效 $(command -v vcgencmd >/dev/null 2>&1) ||return

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

### bash避坑

    变量赋值别习惯性的加空格

    在 Fedora 下 # 号写注释，不要用变量引用的那个货币符号，会进行解释，不知道为啥

### 常用 bash 技巧

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

生成临时文件或目录

    tfile=$(mktemp)

    tdir=$(mktemp -d)

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

### bash 内建命令

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

### bash 快捷键

命令智能和目录补全：输入命令或目录时，不需要完整输入，给出开头字母后，按两次 TAB 键有提示和自动完成功能。

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

### 常用 shell 脚本代码片段

目录 shell_script 下是写的不错的脚本示例

    https://github.com/jacyl4/de_GWD
    https://github.com/acmesh-official/acme.sh

> 环境变量

    分系统级生效或用户级，shell 或 gui 各有不同

        https://wiki.archlinux.org/title/Environment_variables

    执行 `set` 可以查看当前 shell 的环境变量和函数设置，便于调试。

> 当前shell和嵌套层数

查看当前所使用的shell程序

    $ echo $0
    -bash

你在终端中调用不同的 shell，$SHELL 是保持不变的：不要被一个叫做 $SHELL 的单独的环境变量所迷惑，它被设置为你的默认 shell 的完整路径。因此，这个变量并不一定指向你当前使用的 shell。
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

查看下当前的系统有哪些 shell 脚本解释器

    $ cat /etc/shells
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

系统级默认/bin/sh，用户登录默认/bin/bash，一般写脚本文件应该明确用哪个解释器执行，在第一行： `#!/bin/bash`。

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

## Linux 常用命令行工具

    Linux 命令速查

        https://man7.org/linux/man-pages/index.html

        GNU 按用途分类介绍
            https://www.gnu.org/software/coreutils/manual/html_node/index.html#SEC_Contents

        常用工具 coreutils 包清单
            https://manpages.debian.org/unstable/coreutils/index.html

        按内容搜索包
            https://www.debian.org/distrib/packages#search_contents

    Linux 内核工具包一般发行版都内置了

      https://www.kernel.org/pub/linux/utils/util-linux/

    GNU 按软件包分类

        https://www.gnu.org/manual/manual.html

    简易 GNU 软件列表

        https://www.gnu.org/software/software.en.html#allgnupkgs

    带说明的 GUN 软件列表

        https://directory.fsf.org/wiki/GNU

    debian 手册

        https://manpages.debian.org/bullseye/procps/ps.1.en.html

        https://www.debian.org/doc/

        https://wiki.debian.org/ManualPage

        其它各linux帮助手册 https://manpages.debian.org/about.html

    有很多常用工具介绍

        https://lindevs.com/category/embedded-system/raspberry-pi?page=1

    python 的一行命令

        https://wiki.python.org/moin/Powerful%20Python%20One-Liners

### man/info 查看帮助信息

    https://www.redhat.com/sysadmin/linux-command-documentation

先把基础命令的 man 章节安装完整，参见章节 [安装完整的 man 手册](init_a_server.md think)。

命令的 man 的内容可能存在于多个节中，一般归类分为以下几节：

    用户命令（第 1 节）
    系统调用（第 2 节）
    C 库函数（第 3 节）
    设备和特殊文件（第 4 节）
    文件格式和约定（第 5 节）
    游戏（第6节）
    杂项（第7节）
    系统管理工具和守护程序（第 8 节）

    章节    名称                        描述

    1   Standard commands(标准命令)    Executable programs or shell commands, 普通的命令

    2   System calls(系统调用)          System calls (functions provided by the kernel)系统调用,如open,write之类的(通过这个，至少可以很方便的查到调用这个函数，需要加什么头文件)

    3   Libraryfunctions(库函数)        Library calls (functions within program libraries), 库函数,如printf,fread

    4   Specialdevices(设备说明)        Special files (usually found in /dev), 特殊文件,也就是/dev下的各种设备文件

    5   File formats(文件格式)          File formats and conventions eg /etc/passwd, 指文件的格式,比如passwd, 就会说明这个文件中各个字段的含义

    6   Games andtoys(游戏和娱乐)       给游戏留的,由各个游戏自己定义

    7   Miscellaneous(杂项)             Miscellaneous (including macro packages and conventions), e.g. man(7), groff(7),附件还有一些变量,比如 environ 这种全局变量在这里就有说明

    8   AdministrativeCommands(管理员命令)  System administration commands (usually only for root), 系统管理用的命令,这些命令只能由root使用,如ifconfig

    Kernel routines [Non standard]

man 查看命令的默认章节

    man signal

man 查看指定章节后缀用.数字即可

    man 7 signal

    man signal.7

应用程序可能还提供了一些配置文件样例等，一般都跟 man 的内容保存在同一个目录下

    /usr/share/doc

用 `apropos` 命令来查找相关联的帮助

    $ apropos sysctl
    _sysctl (2)          - read/write system parameters
    sysctl (2)           - read/write system parameters
    sysctl (8)           - configure kernel parameters at runtime
    sysctl.conf (5)      - sysctl preload/configuration file
    sysctl.d (5)         - Configure kernel parameters at boot
    systemd-sysctl (8)   - Configure kernel parameters at boot
    systemd-sysctl.service (8) - Configure kernel parameters at boot

info 命令倾向于可读性和更深入的解释。信息页系统还支持文档之间的基本链接，以便于交叉引用。这提供了一个更有条理和可读性的文档集。

    info ls

    如果没有 info 内容，会转为 man 的内容，有提示 'Info: (*manpages*)ssh, 684 lines --Top'

        info ssh

### Vim 和 nano

    https://vim-jp.org/vimdoc-en/scroll.html

    https://vimcdoc.sourceforge.net/doc/help.html

最基础的版本是类似 vi 的 vim tinny 版本，不支持语法高亮、窗口拆分等各种高级功能。

vim 安装见章节 [使用状态栏等扩展插件的先决条件]。

> 如果 vim 的默认颜色方案太丑

    输入命令 :color 后回车查看当前的颜色主题。

    输入命令 :colorscheme slate ，即可设置当前vim实例的颜色主题为 slate。

    :syntax enable  启用语法高亮

    :syntax clear   关闭语法高亮

> vim 解决汉字乱码

如果你的 vim 打开汉字出现乱码的话，那么在 $HOME 目录(~)下，新建 .vimrc 文件

    $ nano ~/.vimrc

添加内容如下：

    set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
    set enc=utf8
    set fencs=utf8,gbk,gb2312,gb18030

#### nano 用法

常用编辑命令在底部都有提示，适合不会用 vi 的用户。

光标控制

    移动光标：使用用方向键移动。
    选择文字：按住鼠标左键拖动。

复制、剪贴和粘贴

    复制一整行：Alt+6
    剪贴一整行：Ctrl+K
    粘贴：Ctrl+U

如果需要复制/剪贴多行或者一行中的一部分，先将光标移动到需要复制/剪贴的文本的开头，按Ctrl+6（或者Alt+A）做标记，然后移动光标到 待复制/剪贴的文本末尾。这时选定的文本会反白，用Alt+6来复制，Ctrl+K来剪贴。若在选择文本过程中要取消，只需要再按一次Ctrl+6。

搜索

按Ctrl+W，然后输入你要搜索的关键字，回车确定。这将会定位到第一个匹配的文本，接着可以用Alt+W来定位到下一个匹配的文本。

翻页

    Ctrl+Y到上一页
    Ctrl+V到下一页

保存

    Ctrl+O

退出

    Ctrl+X

如果你修改了文件，下面会询问你是否需要保存修改。输入Y确认保存，输入N不保存，按Ctrl+C取消返回。如果输入了Y，下一步会让你输入想要保存的文件名。如果不需要修改文件名直接回车就行；若想要保存成别的名字（也就是另存为）则输入新名称然后确 定。这个时候也可用Ctrl+C来取消返回。

#### vim 扩展插件

    https://vimhelp.org/starting.txt.html#vimrc

插件大全，Vundle等插件管理器支持简写

    https://github.com/vim-scripts/

插件管理器见下面相关章节

颜色方案

    推荐北极，作为插件安装即可 https://www.nordtheme.com/ports/vim

    推荐 papercolor， vim-airline 和 lightline 都内置的一个养眼又清晰的主题

        papercolor https://github.com/NLKNguyen/papercolor-theme

    material https://github.com/material-theme/vsc-material-theme

    夜猫子 https://github.com/sdras/night-owl-vscode-theme

插件大全列表

    https://vimawesome.com/

##### 使用状态栏等扩展插件的先决条件

检查 vim 的版本，执行命令 `vi --version` 或 进入 vim 执行命令 :version

    Small version without GUI.

    Tiny version without GUI.

如果出现上述字样，说明当前系统只安装了兼容 vi 模式的精简版 vim.tiny，不支持彩色语法高亮、切分窗口等高级功能（vim 内置插件）

Debian 重装增强版:

    确认版本

        $ vi --version
        Small version without GUI.

        $ apt list --installed |grep vi
        vim-common/stable,now 2:8.2.2434-3+deb11u1 all [installed]
        vim-tiny/stable,now 2:8.2.2434-3+deb11u1 armhf [installed]

        $ apt show vim.tiny

    先删除 vim.tiny

        $ sudo apt remove vim-common
        The following packages will be REMOVED:
            vim-common vim-tiny

    然后安装 vim 的增强版

        # https://askubuntu.com/questions/284957/vi-getting-multiple-sorry-the-command-is-not-available-in-this-version-af
        # 不用装 vim-gui-common 这个是 Linux 桌面版的vim，不如桌面自带的记事本或vscode好用
        $ sudo apt install vim
        The following NEW packages will be installed:
            vim vim-common vim-runtime

        # 安装个文档
        suodu apt install vim-doc

        # 可选安装各种脚本 https://github.com/vim-scripts
        sudo apt install vim-scripts

Fedora 重装增强版:

    确认版本

        $ vi --version
        Tiny version without GUI.

        $ dnf list --installed | grep vi
        vim-data.noarch
        vim-minimal.x86_64

        $ dnf info vim-minimal

    先删除 vim-minimal

        $ sudo dnf remove vim-minimal

    然后安装 vim 的增强版

        $ sudo dnf install -y vim-enhanced vim-common

        $ cd /usr/bin; sudo ln -s vim vi

    检查 vim 的版本，执行命令 `vi --version` 或 进入 vim 执行命令 :version

        Huge version without GUI.

确认如上字样即可。

要启用彩色语法高亮、状态栏彩色，包括tmux中vim使用彩色，需要编辑 ~/.vimrc 文件，添加如下行

```python

" 如果终端工具已经设置了变量 export TERM=xterm-256color，那么这个参数可有可无
" 如果在 tmux 下使用 vim ，防止 tmux 默认设置 TERM=screen，应该保留此设置
" https://www.codenong.com/15375992/
"if &term =~? 'mlterm\|xterm'
if &term =="screen"
    set t_Co=256
endif
" 真彩色
" https://github.com/tmux/tmux/issues/1246
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    lset termguicolors
endif

```

光 vim 自己设置真彩色还不够，需要终端工具也支持，详见章节 [终端模拟器和软件的真彩色设置]。

##### 配置扩展插件

下面的这些原理看看得了，vim 各个版本的配置目录变化太多，还是用插件管理器最省事，参见章节 [推荐：插件管理器 vim-plug]。

vim 配置文件在 ~/.vimrc 或 /etc/vim/vimrc

各种扩展插件使用的目录

    https://vimhelp.org/options.txt.html#%27runtimepath%27

使用命令 `:set rtp` 查看当前加载扩展的路径

    runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim81,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after

1、如果是 `apt install xxx` 的方式安装发行版插件，会自动安装插件管理器 vim-addon-manager，以便统一管理插件，位置在 /usr/share/vim/addons/

   自定义插件  /usr/share/vim/addons/plugin/
   使用时加载  /usr/share/vim/addons/autoload/

   vim 自带插件        /usr/share/vim/vim81/plugin/
   vim 自带使用时加载   /usr/share/vim/vim81/autoload/

2、如果是用户自定义安装的插件，保存在 ~/.vim/ 下，vim 默认会查找该目录进行加载

   插件        ~/.vim/plugin/
   使用时加载   ~/.vim/autoload/

~/.vim/ 下的目录介绍

    ~/.vim/autoload/ 它是一个非常重要的目录，尽管听起来比实际复杂。简而言之，它里面放置的是当你真正需要的时候才被自动加载运行的文件，而不是在vim启动时就加载。

    ~/.vim/colors/ 是用来存放vim配色方案的。

    ~/.vim/plugin/ 存放的是每次启动vim都会被运行一次的插件，也就是说只要你想在vim启动时就运行的插件就放在这个目录下。我们可以放从vim-plug官方下载下来的插件.vim

    ~/.vim/syntax/ 语法描述脚本。我们放有关文本（比如c语言）语法相关的插件

    ~/.vim/doc/ 为插件放置文档的地方。例如:help的时候可以用到。

    ~/.vim/ftdetect/ 中的文件同样也会在vim启动时就运行。有些时候可能没有这个目录。ftdetect代表的是“filetype detection（文件类型检测）”。此目录中的文件应该用自动命令（autocommands）来检测和设置文件的类型，除此之外并无其他。也就是说，它们只该有一两行而已。

    ~/.vim/ftplugin/ 此目录中的文件有些不同。当vim给缓冲区的filetype设置一个值时，vim将会在~/.vim/ftplugin/ 目录下来查找和filetype相同名字的文件。例如你运行set filetype=derp这条命令后，vim将查找~/.vim/ftplugin/derp.vim此文件，如果存在就运行它。不仅如此，它还会运行ftplugin下相同名字的子目录中的所有文件，如~/.vim/ftplugin/derp/这个文件夹下的文件都会被运行。每次启用时，应该为不同的文件类型设置局部缓冲选项，如果设置为全局缓冲选项的话，将会覆盖所有打开的缓冲区。

    ~/.vim/indent/ 这里面的文件和ftplugin中的很像，它们也是根据它们的名字来加载的。它放置了相关文件类型的缩进。例如python应该怎么缩进，java应该怎么缩进等等。其实放在ftplugin中也可以，但单独列出来只是为了方便文件管理和理解。

    ~/.vim/compiler/ 和indent很像，它放的是相应文件类型应该如何编译的选项。

    ~/.vim/after/ 这里面的文件也会在vim每次启动的时候加载，不过是等待~/.vim/plugin/加载完成之后才加载after里的内容，所以叫做after。

    ~/.vim/spell/ 拼写检查脚本。

###### 推荐：插件管理器 vim-plug

Vundle不更新了，这个项目取代之，用法神似，只需要编辑 ~/.vimrc，便于用户自定义，安装使用 github 来源的插件非常简单

    https://github.com/junegunn/vim-plug

先从 github 下载

    # vim 使用时加载     ~/.vim/autoload/
    # vim-plug 存放插件  ~/.vim/plugged/

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

然后修改  ~/.vimrc，

然后重新加载配置文件 `:source ~/.vimrc`，命令行执行 `:PlugInstall` 按提示操作即可安装插件。

常用命令

然后进入vim，运行命令安装插件，会新建拆分窗口根据你编辑的 .vimrc 文件内容列出可选操作

    :PlugInstall

卸载插件只需编辑 .vimrc 配置文件中删除欲卸载插件的配置，保存，然后在Vim中执行下述命令即可完成卸载

    :PlugClean

更新插件

    :PlugUpdate

列出当前插件

    :PlugList

搜索插件，选择一个你想要安装的插件，并敲击键盘 i 来安装这个插件，完成后选中这个插件的名称，并粘贴到 .vimrc 文件中去

    :PlugSearch colorscheme

###### 插件管理器 vim-addon-manager

    https://github.com/MarcWeber/vim-addon-manager

命令的方式对插件进行管理，不需要配置文件，适合安装发行版自带的插件。

在 Debian 使用 `apt install vim-airline` 安装插件的时候，会自动安装 vim-addon-manager

    apt install vim-addon-manager

使用目录

    # apt install 安装
    /usr/share/vim/addons/

    # 自定义安装
    ~/.vim/addons/

用法

    $ vim-addons -h
    Usage:
    vim-addons [OPTION ...] [COMMAND [ADDON ...]]

    Commands:
    list, status (default command), install, remove, disable, enable, files, show

    Options:
    -h, --help          show this usage message and exit
    -q, --query         be quiet and make the output more parseable
    -r, --registry-dir  set the registry directory
                            (default: /usr/share/vim/registry)
    -s, --source-dir    set the addons source directory
                            (default: /usr/share/vim/addons)
    -t, --target-dir    set the addons target directory
                            (default: $HOME/.vim)
    -v, --verbose       increase verbosity
    -z, --silent        silent mode: suppress most of the output
    -y, --system-dir    set the system-wide target directory
                            (default: /var/lib/vim/addons)
    -w, --system-wide   set target directory to the system-wide one
                            (overrides -t setting)

    $ vim-addons status
    # Name                     User Status  System Status
    airline                     removed       installed
    airline-themes              removed       installed
    editexisting                removed       removed
    justify                     removed       removed
    matchit                     removed       removed
    nginx                       removed       removed
    powerline                   removed       removed

    vim-addons install xxx

    vim-addons remove xxx

    vim-addons show xxx

###### 插件管理器 Vundle

优点是只需要编辑 ~/.vimrc，便于用户自定义，可惜自2019年之后不更新了

    https://github.com/VundleVim/Vundle.vim

先git安装 (会在子目录 autoload、ftplugin等增加内容)

    # Vundle使用    ~/.vim/bundle/
    # 自定义插件    ~/.vim/bundle/对应的插件/plugin/
    # 使用时加载    ~/.vim/bundle/对应的插件/autoload/

    git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

然后修改  ~/.vimrc 如下

```python

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VundleVim 插件管理器官方配置

set nocompatible              " be iMproved, required，这个应该是关闭兼容vi模式，就用vim
filetype off                  " required

" airline 安装后可屏蔽原配置的 powerline
" set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim/
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"
"插件在Github仓库中
"Plugin 'scrooloose/nerdtree'
"
"插件在 https://github.com/vim-scripts 用户仓库中
"Plugin 'YankRing.vim'
"
"插件在非Github的Git仓库中
"Plugin 'git://git.wincent.com/command-t.git'
"
"插件在本地
"Plugin 'file:///home/gmarik/path/to/plugin'

" 自己要添加的插件在这里配置
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'scrooloose/nerdtree'

" 在侧边显示git修改状态
Plug 'airblade/vim-gitgutter'

" 显示 vim 寄存器的内容
Plug 'junegunn/vim-peekaboo'

" 颜色主题 https://www.nordtheme.com/ports/vim
Plugin 'arcticicestudio/nord-vim'

" 颜色主题 https://github.com/NLKNguyen/papercolor-theme
" Plugin 'NLKNguyen/papercolor-theme'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 在下面增加自己的设置
```

然后进入vim，运行命令安装插件

    :PluginInstall

卸载插件只需在.vimrc配置文件中删除欲卸载插件的插件地址配置，保存退出配置文件 .vimrc 后
然后在Vim中执行下述命令即可完成卸载

    :PluginClean

更新插件

    :PluginUpdate

列出当前插件

    :PluginList

搜索插件，选择一个你想要安装的插件，并敲击键盘 i 来安装这个插件，完成后选中这个插件的名称，并粘贴到 .vimrc 文件中去

    :PluginSearch colorscheme

##### 不推荐 vim 状态栏插件 powerline

状态栏工具 powerline 有供 vim 使用的插件，但是不推荐使用

    推荐使用替代品 vim-airline，状态栏和标签栏都有，而且可以配合很多知名插件的显示

powerline 介绍，参见章节 [状态栏工具 powerline]。

使用 powerline 在 vim 下的插件需要 Vim 在编译时添加 python 支持，而一般的用于嵌入式设备的操作系统如树莓派自带的是 vim 精简版 vim.tinny，这个版本是无法使用该插件的，如何解决见章节 [使用状态栏等扩展插件的先决条件]。

powerline 为保证多样性，使用 python 实现的。现在的问题是操作系统自带的 python 指的 python2 还是 python3 版本

    搞清 操作系统安装的包 python-pip 和 python3-pip 的使用区别
    搞清 powerline 有 python 和 python3 两个发行版本
    搞清 操作系统默认的 python 环境是 python 还是 python3
    搞清 你安装的 powerline 到底是用 python 还是 python3 执行的？如果是用 apt install 安装的是使用发行版环境的。
    搞清 所有的 powerline 的插件，安装前都要先看看到底支持哪个python版本？
    搞清 前面这堆 python 到底是指 python2 还是 python3 ？如果是python3，最低要求 3.6 还是 3.7 ？
    这个比较难受：搞清在 virtualenv/conda 下使用 vim 会否影响其使用 python 的插件？折腾半天装上了激活个 python 环境就废了？

    不是迫不得已，更不要自行编译 vim，尽量用发行版自带的。

    建议安装 debian 发行版自带的 powerline，用 `sudo apt install powerline`即可

        如果，你在 Debian 10 用 `pip install powerline-status`，那么安装的应该是 python 2.7 版本的 powerline-status。

        新版用 pypi 安装 `python3 -m pip install powerline-status`

        最新版用 github 安装 `python3 -m pip install --user git+git://github.com/powerline/powerline`

        然后继续，所有的 powerline 的插件，安装前都要先看看到底支持哪个python版本？

如果确定你的 vim 可以使用 powerline，做如下设置：

    先查看 powerline 的安装位置，找到 bindings 目录

        如果是用 pip 安装的 powerline，就是如下这种的路径

            # pip show powerline-status
            # /usr/lib/python3/dist-packages/powerline/bindings/vim/
            /usr/local/lib/python2.7/site-packages/powerline/bindings/vim/

        如果是用 apt 安装的 powerline，就是这种路径

            /usr/share/powerline/bindings/vim/

    将上述路径添加到配置文件 ~/.vimrc 或 /etc/vim/vimrc 中

        set rtp+=/usr/share/powerline/bindings/vim/

        " Always show statusline
        set laststatus=2

        " Always show tabline
        set showtabline=2

        " Use 256 colours (Use this setting only if your terminal supports 256 colours)
        set t_Co=256

##### 推荐 vim 状态栏插件 vim-airline

完美替换掉 powerline

    https://github.com/vim-airline/vim-airline

开箱即用，不仅是状态栏和标签栏，而且能配合很多常用插件如 nerdtree 目录树的显示，普通字体也可以正常显示。

没使用 python 代码，都用 vim script 写的，速度和兼容性都有保证。

直接配置到插件管理器 vim-plug 里加载是最省事的，否则：

    Debian 发行版自带，会自动安装依赖的插件管理器 vim-addon-manager，然后把自己安装到其插件目录中

        $ sudo apt install vim-airline

        $ sudo apt install vim-airline-themes

    Fedora 发行版只带一个，另一个需要手动，还是得依赖插件管理器

        $ sudo dnf install vim-airline

注意 vim.tinny 版无法使用该插件的，如何解决见章节 [使用状态栏等扩展插件的先决条件]。

查看帮助

    :help airline

Airline 扩展支持适配 tabline、nerdtree 等插件的颜色方案，在 ~/.vimrc 中配置

```vim

" 内置扩展的挨个说明使用命令 :help airline 或 https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt
" 内置扩展保存在：
" apt install [vim-addon-manager] /usr/share/vim/addons/autoload/airline/extensions/ 下
" [Vundle]   ~/.vim/bundle/vim-airline/autoload/airline/extensions/ 下
" [vim-plug] ~/.vim/plugged/ 下
" 自定义 ~/.vim/autoload/ 和 ~/.vim/plugin/
" 命令 :AirlineExtensions 查看当前自动启用的内置插件

" 需要启用 powerline 的字体，状态栏显示的效果才能起飞
let g:airline_powerline_fonts = 1

" 启用 airline 内置扩展：标签式显示多个打开的文件的状态栏
" 在说明文件中搜 airline-tabline
let g:airline#extensions#tabline#enabled = 1

" 启用 airline 内置扩展：nerdtree插件左侧显示文件树内容的状态栏效果
let g:airline#extensions#nerdtree_statusline = 1

```

AirlineTheme 自有主题，在 ~/.vimrc 中配置

```vim

" AirlineTheme 需要启用 powerline 的字体才能起飞
let g:airline_powerline_fonts = 1

" airline_theme内置的插件主题大部分都只是状态栏的，居然不同步设置语法高亮
" 建议自行安装vim插件 PaperColor 或 nord，状态栏和语法高亮颜色都有了,不需要用 airline_theme 内置的同名主题
" https://github.com/vim-airline/vim-airline-themes/tree/master/autoload/airline/themes
" 列表见 https://github.com/vim-airline/vim-airline/wiki/Screenshots
" 保存在 ~/.vim/bundle/vim-airline-themes/autoload/airline/themes
" 使用说明 ~/.vim/bundle/vim-airline-themes/README.md
" 在vi中切换主题 :AirlineTheme night_owl
let g:airline_theme='papercolor'

```

##### 更简洁的 vim 状态栏插件 lightline.vim

    https://github.com/itchyny/lightline.vim

如果你想只安装个干净的工具栏，其它插件自己配置自己玩的话，状态栏工具用这个 lightline.vim 就足够了。

Why yet another clone of powerline?

    https://github.com/Lokaltog/vim-powerline is a nice plugin, but deprecated.

    powerline is a nice plugin, but difficult to configure.

    vim-airline is a nice plugin, but it uses too many functions of other plugins, which should be done by users in .vimrc.

这个比较简洁，只有状态栏工具和颜色方案。也是不使用 python 代码，都用 vim script 写的，速度和兼容性都有保证。

vim.tinny 版是无法使用该插件的，如何解决见章节 [使用状态栏等扩展插件的先决条件]。

配置主题

    let g:lightline = { 'colorscheme': 'PaperColor' }

##### 使用 vim 内置的树形文件夹插件 netrw

    https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/

netrw 是 vim 自带的插件, 不需要额外安装, 其提供的功能非常强大, 相比与 nerdtree 这些第三方插件来说速度更快, 体量更轻, 设计更简洁。

默认情况下，netrw 将在当前窗口中打开目录树列表，选择文件后回车即可在当前窗口打开文件。

在 vim 中打开 netrw 窗口

    :E       全屏进入 netrw, 全称是 :Explorer 或 :Ex
    :Se      水平分割进入 netrw
    :Ve      垂直分割进入 netrw

    拆分窗口的切换，使用 vim 多窗口操作的前导键 ctrl+w，参见章节 [多窗口(Window)操作]

退出

    :q  关闭 netrw 窗口（保持回车打开文件的窗口），如果 netrw 是唯一打开的窗口，那么将同时退出Vim。

    :bd 我们可以将 netrw 理解为，使用编辑命令对于目录进行操作的特殊缓冲区。也就是说，我们可以使用 :bdelete 命令，来关闭 netrw 打开的缓冲区，但不会退出 Vim。

可设置打开文件的方式

        let g:netrw_browse_split = n

    其中，参数 n 的值可以为以下四种

        1   在目录树列表窗口，水平拆分新窗口打开文件
        2   在目录树列表窗口，垂直拆分新窗口打开文件
        3   用新建标签页打开文件
        4   用前一个窗口打开文件

几个设置命令，可放到 .vimrc 配置文件中

```vim

" 设置 netrw 的显示风格
"let g:netrw_hide = 1 " 设置默认隐藏
"let g:netrw_banner = 0  " 隐藏 netrw 顶端的横幅（Banner）
let g:netrw_browse_split = 4  " 用前一个窗口打开文件
let g:netrw_liststyle = 3  " 目录树的显示风格，可以用 i 键来回切换
let g:netrw_winsize = 25  " 设置 netrw 窗口宽度占比 25%
"let g:netrw_altv = 1 " 控制垂直拆分的窗口位于右边

```

netrw窗口内的操作快捷键

    <F1>      在 netrw 界面弹出帮助信息
    I         显示/隐藏顶部 banner

    o         在目录树列表窗口，水平拆分新窗口打开文件
    v         在目录树列表窗口，垂直拆分新窗口打开文件

    t         新 tab 中打开当前光标所在的文件

    p         预览当前文件(光标保持不动)
    qf        显示当前文件详细信息
    <C-w>z    关闭预览窗口
    P         打开文件, 会在上一个使用的窗口一侧的第一个窗口打开文件

    %         在当前目录下新建一个文件并编辑

    <C-l>     更新 netrw 列表内容
    i         文件列表的风格：在 thin, long, wide, tree listings 状态之间切换

    gh        快速隐藏/取消隐藏.开头的文件或目录，如.vim
    s         切换文件的排序，在 name, time 和 file size 之间轮换
    r         翻转文件的排序方式

    gn        使光标下的目录作为目录树最顶部, 在 tree style 下与 <CR> 是不同的
    cd        change 工作目录到当前路径
    -         进入上一级目录
    u         跳到之前访问过的目录
    U         跳到之后访问过的目录

    d         创建文件夹
    D         移除文件/夹
    R         重命名文件/文件夹

    qb        列出书签目录和历史目录
    mb        添加当前目录到书签
    mB        取消当前目录作为书签
    gb        跳转到书签目录（3gb跳转到第3个书签）

    u         跳转到上一次浏览的目录
    x         使用系统中与之关联的程序打开光标下文件
    X         执行光标下的文件

###### nerdtree 树形文件夹插件

如果不想 [使用 vim 内置的树形文件夹插件 netrw]，可以安装插件 nerdtree 以在当前窗口的左侧垂直新建窗口的方式，树形展示当前路径下的文件列表，方便用户操作。

所以，在左侧目录树窗口和右侧文件窗口间切换使用 vim 的窗口切换热键

    前导 ctrl + w ，然后方向键左或 h 光标跳到左侧树形目录
    前导 ctrl + w ，然后方向键右或 l 光标跳到右侧文件显示窗口

窗口操作详见章节 [多窗口(Window)操作]。

自定义个 vim 中的热键 Ctrl-n，方便切换显示目录树，在 ~/.vimrc 配置文件中定义

    " NERDTree
    map <C-n> :NERDTreeToggle<CR>
    let NERDTreeShowHidden=1 "在打开时默认显示隐藏文件
    " map 是快捷键映射命令
    " <C-n> 定义了快捷键，表示 Ctrl-n
    " 后面是对应的命令以及回车键 <CR>

nerdtree 在左侧树形目录中的热键

    ?   切换是否显示 nerdtree 的快捷帮助

    回车 打开的的文件默认是vim的多个文件模式，即添加到缓冲中
    o   在已有窗口中打开文件、目录或书签，并跳到该窗口，或命令 :NERDTree-o
    go  在已有窗口中打开文件、目录或书签，但不跳到该窗口，或命令 :NERDTree-go

    缓冲区列表需要用命令 :ls 来显示， :b<编号> 切换。详见章节[理解vim的多文件操作（缓冲buffer）]。

    i   水平切割一个新窗口打开选中文件，并跳到该窗口，或命令 :NERDTree-i
    gi  水平分割一个新窗口打开选中文件，但不跳到该窗口，或命令 :NERDTree-gi

    s   垂直分割一个新窗口打开选中文件，并跳到该窗口，或命令 :NERDTree-s
    gs  垂直分割一个新窗口打开选中文件，但不跳到该窗口，或命令 :NERDTree-gs

    t   在新 Tab 中打开选中文件/书签，并跳到新 Tab，或命令 :NERDTree-t
    T   在新 Tab 中打开选中文件/书签，但不跳到新 Tab，或命令 :NERDTree-T

    切换 tab 的热键详见章节 [多标签页(Tab)操作]

    e   在目录树上按e，则在右侧窗口显示目录内容，光标键进行选择操作即可，再次按e退出

    K   跳到当前目录下同级的第一个结点
    J   跳到当前目录下同级的最后一个结点

    !   执行当前文件，或命令 :NERDTree-!

一般再搭配个显示每个文件 git 状态的插件

    https://github.com/Xuyuanp/nerdtree-git-plugin

    在 .vimrc 中配置用 plug 安装几个nerdtree配合的常用插件

        Plug 'preservim/nerdtree' |
                \ Plug 'Xuyuanp/nerdtree-git-plugin' |
                \ Plug 'ryanoasis/vim-devicons'

    还可以搭配比较醒目的图标

        " nerdtree-git-plugin 启用带图标的字体
        let g:NERDTreeGitStatusUseNerdFonts = 1 " you should install nerdfonts by yourself. default: 0

        let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "✭",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✔︎",
            \ "Unknown"   : "?"
            \ }

##### .vimrc 配置文件样例

结合我自己使用的插件和 airline 的配置，vim 编辑后无需退出，运行命令 `:source ~/.vimrc` 重新加载即可。

``` vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim 的默认设置
"   全局配置文件 /etc/vim/vimrc
"   启动脚本 /usr/share/vim/vim81/default.vim
"   基础设置 https://www.zhihu.com/question/271926659/answer/2875834932
"
" 迁移到 vim 9.0 + 的格式类似 python 脚本 https://www.baeldung.com/linux/vim-script-upgrade https://vimhelp.org/version9.txt.html#new-9
"
" 查看当前设置值 :verbose set showcmd?

" 如果终端工具已经设置了变量 export TERM=xterm-256color，那么这个参数可有可无
" 如果在 tmux 下使用 vim ，防止 tmux 默认设置 TERM=screen，应该保留此设置
" https://www.codenong.com/15375992/
"if &term =~? 'mlterm\|xterm'
if &term =="screen"
  set t_Co=256
endif
" 真彩色
" https://github.com/tmux/tmux/issues/1246
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" 打开文件自动定位到上次离开的位置，从vim默认的配置里摘出来的
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" 退出 vi 后恢复方块光标闪烁
"if has("autocmd")
"  au VimLeave * :silent !echo -e "\033[?12h\033[1 q" && tput cnorm && stty sane
"endif

" 显示行号 :set nonumber
set number

" 显示正在输入的命令按键
set showcmd

" 使用 vim-airline 并开启 tabline 设置后，就不需要这两个设置了
"set laststatus=2   " 始终显示状态栏
"set showtabline=2  " 始终显示标签页
set noshowmode      " 状态栏工具显示当前模式更明晰，不使用vim的了

" 设置 netrw 的显示风格
"let g:netrw_hide = 1 " 设置默认隐藏
"let g:netrw_banner = 0  " 隐藏 netrw 顶端的横幅（Banner）
let g:netrw_browse_split = 4  " 用前一个窗口打开文件
let g:netrw_liststyle = 3  " 目录树的显示风格，可以用 i 键来回切换
let g:netrw_winsize = 25  " 设置 netrw 窗口宽度占比 25%
"let g:netrw_altv = 1 " 控制垂直拆分的窗口位于右边

" 用鼠标滚轮滚屏
set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" 设置前导键为空格键，需要利用转义符“\”，这个前导键在后面的 airline 设置用到了
" 这个前导键跟tmux不同，可以按住然后按其它键
let mapleader="\<space>"

 " 删除行尾空格，普通模式下连续按3次空格
 nmap <leader><Space><Space> :%s/\s\+$//<cr>

" 开启了自动注释和自动缩进对粘帖代码不方便
"set fo-=r  "关闭自动注释
"set smartindent "识别花括号、c语言格式的自动缩进
"set noautoindent  "关闭自动缩进（新增加的行和前一行使用相同的缩进，这个对C/C++代码好像无效） :set autoindent
"set nocindent  "关闭C语言缩进  :set cindent
"
" 粘贴的代码（shift+insert）会自动缩进，导致格式非常混乱
" 输入命令 ：set paste 再进行粘贴，就不会乱码了，自动缩进也没了，所以在粘贴之后输入 ：set nopaste，恢复缩进模式。
" 把<F2>就设置为改变paste模式的快捷键
"nnoremap <F2> :set invpaste paste?<CR>  " 按下后提示当前paset的状态，使用了状态栏工具无需用此
set pastetoggle=<F2>

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 加载插件 vim-airline vim-airline-themes nerdtree 等
"
" 插件管理器二选一：
"
"   见章节 [插件管理器 vim-addon-manager]，用命令的方式对插件进行管理，不需要配置文件
"   来自章节 [插件管理器 vim-plug] 里的示例配置

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug 插件管理器官方配置
"
" 不需要设置rtp，因为引导程序plug.vim放到autoload目录里了

" airline 安装后可屏蔽原配置的 powerline
" set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim/

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Unmanaged plugin (manually installed and updated)
" Debian: 加载发行版安装的
"Plug '/usr/share/vim/addons/plugin/vim-airline'
"Plug '/usr/share/vim/addons/plugin/vim-airline-themes'
"Fedora: 发行版安装的不需要显式加载 /usr/share/vim/vimfiles/plugin/vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" On-demand loading
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" 在侧边显示git修改状态
Plug 'airblade/vim-gitgutter',

" 显示 vim 寄存器的内容
" 在 vis mode 有点小问题 https://github.com/junegunn/vim-peekaboo/issues/22
" Peekaboo extends " and @ in normal mode and <CTRL-R> in insert mode so you can see the contents of the registers.
Plug 'junegunn/vim-peekaboo'

" 注意这里只是加载颜色主题，启用主题要使用命令 colorscheme xxx，见下
" 颜色主题 https://www.nordtheme.com/ports/vim
Plug 'arcticicestudio/nord-vim'
" 颜色主题 https://github.com/NLKNguyen/papercolor-theme
Plug 'NLKNguyen/papercolor-theme'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 在下面增加自己的设置

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件设置：vim-airline 内置扩展设置
"
" 内置扩展的挨个说明使用命令 :help airline 或 https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt
" 内置扩展保存在：
"   apt install [vim-addon-manager] /usr/share/vim/addons/autoload/airline/extensions/ 下
"   [Vundle]   ~/.vim/bundle/vim-airline/autoload/airline/extensions/ 下
"   [vim-plug] ~/.vim/plugged/ 下
"   自定义 ~/.vim/autoload/ 和 ~/.vim/plugin/
" 命令 :AirlineExtensions 查看当前自动启用的内置插件

" an empty list disables all extensions
"let g:airline_extensions = []
" or only load what you want
"let g:airline_extensions = ['branch', 'tabline']

" 启用 powerline 的字体，状态栏显示的效果才能起飞
let g:airline_powerline_fonts = 1

" 启用 airline 内置扩展：标签式显示多个tab、window或缓冲区里的文件
" 在说明文件中搜 airline-tabline 查看具体功能说明
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline#extensions#tabline#show_tab_nr = 1

let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#buffer_nr_show = 0  " 有一个就够了
let g:airline#extensions#tabline#fnametruncate = 16
let g:airline#extensions#tabline#fnamecollapse = 2

" 使用 airline 自带功能进行标签之间的切换
let g:airline#extensions#tabline#buffer_idx_mode = 1

" 定义切换标签的快捷键
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>0 <Plug>AirlineSelectTab0
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab

" 启用 airline 内置扩展：左侧显示nerdtree插件文件树内容的状态栏效果
let g:airline#extensions#nerdtree_statusline = 1

" airline 启用内置主题：只影响状态栏颜色，没有配套的 colorscheme
" 如果再指定 colorscheme 方案，就可以使用不同的语法高亮和状态栏的色彩
let g:airline_theme='papercolor'

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 语法高亮的彩色方案设置

" 防止某次关闭了语法高亮，下次打开vi则自动再打开
if !exists('g:syntax_on')
  syntax enable
endif

" 内置方案 https://github.com/vim/colorschemes
" 不使用自定义的 colorscheme 会使 vim 背景跟随终端模拟器背景图片
" 使用下载的主题插件自带的语法高亮的色彩方案
colorscheme PaperColor  " 支持设置背景色
"colorscheme nord

" 设置背景色(需要主题支持)，切换语法颜色方案使用亮色还是暗色，PaperColor 支持该切换
"set background=dark
"set background=light

" 如果终端工具设置了背景图片，而你的colorscheme背景色挡住了图片，开启这个设置强制透明，比如 PaperColor
"hi Normal guibg=#111111 ctermbg=black
"hi Normal guibg=NONE ctermbg=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件设置：：NERDTree

" NERDTree 显示隐藏文件
let NERDTreeShowHidden=1

" 切换目录树显示的热键定义为 Ctrl-n
" map 是 vim 的快捷键映射命令
" <C-n> 定义了快捷键，表示 Ctrl-n
" 后面是对应的命令以及回车键 <CR>
map <C-n> :NERDTreeToggle<CR>

```

#### vim 快捷键

    Esc 退出当前的模式，或终止当前命令，回到默认的普通模式

经常遇到的一个情况是字母太多按乱顺序了，养成习惯输完命令执行后随手多按几次 Esc 保平安

多看帮助

    :help Visual-mode

如果在 tmux 中使用 vim，热键冲突时优先响应 tmux，即 vim 热键可能会失效。

##### 文本输入模式（编辑模式/插入模式）insert mode

在普通模式下输入插入命令i、附加命令a、打开命令o、修改命令c、取代命令r或替换命令s都可以进入文本输入模式。

在该模式下，用户输入的任何字符都被 vi 当做文件内容缓存起来，并将其显示在屏幕上。

在文本输入过程中，若想回到普通模式下，按下 Esc 键即可。

##### 普通模式 normal mode

命令键可以组合使用，比如输入 2dd 是执行2次删除当前行(dd)操作，dG 就是从当前行删除到文件末尾， "0p 粘贴复制寄存器的内容。

翻页

    ctrl-y   向上移动页面，光标保持原位
    ctrl-e   向下移动页面，光标保持原位

    z + Enter   滚动屏幕，使当前光标所在行处于屏幕第一行；
    z + .       滚动屏幕，使当前光标所在行处于屏幕中间行；
    z + -       滚动屏幕，使当前光标所在行处于屏幕最后一行；

    ctrl-f   上翻一页
    ctrl-b   下翻一页
    ctrl-u   上翻半页
    ctrl-d   下翻半页

移动光标

    h,j,k,l  上，下，左，右

    w    跳到下一个字首，按标点或单词分割
    W    跳到下一个字首，长跳，如end-of-line被认为是一个字

    e    跳到下一个字尾
    E    跳到下一个字尾，长跳

    b    跳到上一个字
    B    跳到上一个字，长跳

    3+Space 光标位置右跳本行3个字符的位置

    0    跳至行首，不管有无缩进，就是跳到第0个字符
    ^    跳至行首的第一个字符

    $    跳至行尾

    gg   跳至文首，或 1g 跳到第一行，默认是在行首
    G    跳至文尾

    5gg     跳至第5行，或 5G

    ctrl+g  显示当前行位置

    {}、[]、[[、]]  正反向按文本对象移动一个段落、句子、小节

    ma      创建一个书签 a， 则 mb 创建一个书签 b，以此类推，如果书签名称是大写字母，那么这是一个全局书签。
    `a      跳转到书签a的精确位置（行和列），以此类推
    'a      调整到书签a所在行的起始位置，以此类推

    :delmarks a  删除书签a
    :marks       显示所有标签

查找替换

    /   向后搜索，会在命令行下面进入输入模式，输入匹配模式 pattern 后回车即可
    ?   向前搜索（同上）

        如果想用 p 粘贴寄存器 "0 的内容，使用热键 <C-r>，然后输入 0p，该内容即出现在 / 后面了

      :set ic   忽略大小写，或 :set ignorecase，或在上面的搜索匹配模式后缀 \c
      :set noic 大小写敏感，或 :set noignorecase，或在上面的搜索匹配模式后缀 \C

      n   下一个匹配(如果是 / 搜索，则是向下的下一个匹配，? 搜索则是向上的下一个匹配)
      N   上一个匹配(同上)

    fx  在当前行中找x字符，找到了就跳转至该字符
    ;   重复上一个f命令，而不用重复的输入 fx

    *   查找光标所在处的单词，向下查找，重复按就是查找下一个匹配项
    #   查找光标所在处的单词，向上查找，重复按就是查找下一个匹配项

    :%s/old/new/g   替换，搜索整个文件，将所有的 old 替换为 new
    :%s/old/new/gc  替换，搜索整个文件，将所有的 old 替换为 new，每次都要你确认是否替换，可根据提示选择a=all

删除复制粘贴

    J     删除行尾的换行，将下一行和当前行连接为一行，中间用空格分隔，不添加空格使用命令 gJ。

    x     删除当前字符
    X     删除前一个字符

    dd    删除光标所在行
    dw    删除一个字(word)

    d$    删除到行末，或 D
    d^    删除到行首

    NOTE: vim的删除操作其实是剪切，详见下面章节 [vim寄存器--删除是剪切操作]

    yy    复制一行， 或 Y
    yw    复制一个字
    y$    复制到行末
    y^    复制到行首

    p     粘贴剪贴板的内容到当前行的下面
    P     粘贴剪贴板的内容到当前行的上面

编辑

    i     插入，从当前光标处进入编辑模式
    a     追加，在当前光标之后进入编辑模式

    I     进入编辑模式，并置光标于行首
    A     进入编辑模式，置光标于行末

    o     进入编辑模式，在当前行之下新加一行，光标位于新加行
    O     进入编辑模式，在当前行之上新加一行，光标位于新加行

    s     删除当前字符并进入编辑模式，省去按 x   i 两个快捷键
    S     删除光标所在行并进入编辑模式，省去按 dd i 两个快捷键

    cc    删除当前行并进入编辑模式
    cw    删除当前词，并进入编辑模式
    c$    擦除从当前位置至行末的内容，并进入编辑模式
    c^    擦除从当前位置至行首的内容，并进入编辑模式

    xp    交换当前字符和下一个字符

    u       撤销
    ctrl+r  重做

    ~     切换大小写，当前字符
    >>    将当前行右移一个单位(一个tab符)
    <<    将当前行左移一个单位(一个tab符)
    ==    自动缩进当前行

##### 替换模式 replace mode

    r   单字符替换模式，此时新输入的字符将替代光标之下的当前字符，然后自动返回到普通模式。

        在r命令中增加数字前缀，可以一次性替换多个字符。例如，将光标定位到“||”字符处，然后执行2r&命令，可以将其替换为“&&”。

    R   进入替换模式（屏幕底部显示“--REPLACE--”）。此时新输入的文本将直接替代/覆盖已经存在的内容，直至点击ESC键返回普通模式。

    gR 进入虚拟替换模式（virtual replace mode）（屏幕底部显示“--VREPLACE--”），其与替换模式最主要的区别在于，对<Tab>键和换行符的不同处理方式

        虚拟替换模式（VREPLACE）则将<Tab>键拆分为多个独立的空格来分别处理

        虚拟替换模式（VREPLACE）下，输入<Enter>回车键将用新行替代当前行内容（即清空当前行）

        gr命令，可以进入单字符虚拟替换模式。在替换光标下的当前字符之后，将自动返回到常规模式。

##### 可视模式(列块操作) visual mode

普通模式下按下列键进入可视模式

    按 v 键，然后加方向键（h、j、k、l）或者另外的四个方向键移动光标，从光标位置开始进逐字符的行多选，然后可以执行删除复制粘贴合并行等普通模式下的命令操作

    按 shift + v 键(即V)，是按行选择的多行模式，操作同上。

    按 Ctrl + v /Ctrl + q 键，从光标位置开始进逐字符的列多选，操作同上。

示例

    删除列

        1.光标定位到要操作的地方。
        2.CTRL + v 进入“可视 块”模式，移动光标选取这一列操作多少行。
        3.按 d 键删除。

    插入列

        1.光标定位到要操作的地方。
        2.CTRL + v 进入“可视 块”模式，选取这一列操作多少行。
        3.SHIFT + i (I) 输入要插入的内容。
        4.按 Esc 键两次，会在每行的选定的区域出现插入的内容

    用 `c` 将删除高亮选中的文本并进入插入模式，在你输入文本并按 Esc 键返回之后，输入的文本将插入到块选中的每一行里。

    用 `C` 会删除从选中文本到行尾的所有字符并进入插入状态。

    用 `A` 然后输入字符，所有的字符会添加到文本块后面。

    对高亮显示的文本块，我们可以用 `~` 进行大小写转换，用 `r` 替换单个字符，用 `>` 增加缩进，或用 `<` 减少缩进。

    对高亮显示的文本块，可以用 `o` 或 `O` 在块内移动光标，方便后续操作执行后光标的起始定位。

##### 命令行模式 command mode

在普通模式下，用户按冒号 : 键即可进入命令行模式下，此时 vi 会在显示窗口的最后一行（通常也是屏幕的最后一行）显示一个 : 作为命令行模式的说明符，等待用户输入命令。多数文件管理命令都是在此模式下执行的（如把编辑缓冲区的内容写到文件中等）。

命令行命令执行完后，vi 自动回到普通模式。

在 vim 中输入的命令，也可编辑 ~/.vimrc 文件配置。

退出编辑器

    即使缓冲区打开了多个文件，一次 q 就会全部退出，不需要挨个退出。

    如果有多个标签页或窗口，需要挨个执行q退出

    :w      将缓冲区写入文件，即保存修改
    :wq     保存修改并退出
    :x      保存修改并退出
    :q      退出，如果对缓冲区进行过修改，则会提示
    :q!     强制退出，放弃修改

##### 自定义快捷键

重新定义快捷键，放到 ~/.vimrc 文件中即可：

```vim

" 切换目录树显示的热键定义为 Ctrl-n
" map 是 vim 的快捷键映射命令
" <C-n> 定义了快捷键，表示 Ctrl-n
" 后面是对应的命令以及回车键 <CR>
map <C-n> :NERDTreeToggle<CR>

```

map noremap 的区别：

nore “ 非递归 ”表示映射仅展开一次，并且应用/执行该结果。

    nmap K H
    nnoremap H G
    nnoremap G gg

以上三行设置，使 K 扩展为 H ，然后 H 扩展为 G 并停止。因为 nnoremap 会立即扩展和停止。 将执行G的含义（即“跳到最后一行”）。 最多只有一个非递归映射将应用于扩展链（这将是最后一次扩展）。

前缀 i v n 等可以约束生效范围

    inoremap 只在 insert 模式下生效

    vnoremap 只在 visual 模式下生效

    nnoremap 就在 normal 模式下生效

前导键

为解决 vim 中快捷键太多不够用的问题，又引入了前导键，即按住一个热键然后再按其它键，对应新的命令。也可以像 tmux 依次按键的用法。

前导键默认为“\”，可以定义为其它的：

    " 前导键定义为 逗号
    let mapleader=","

    " 利用转义符“\”将前导键定义为空格键
    let mapleader = "\<space>"

    "后续的热键定义使用前导键只需要用 <leader> 声明即可
    map <Leader>bn :bn<CR>

多窗口操作也有自己的前导键 ctrl+w，注意区别。

##### 重复上步操作

vim中有五种基本的重复类型，分别是：

    重复类型        重复操作符    回退操作符
    文本改变重复      .             u
    行内查找重复      ;             ,
    全文查找重复      n             N
    文本替换重复      &             u
    宏重复           @[寄存器]      u

##### 查看命令历史

命令行模式下：

    :history 查看所有命令行模式下输入的命令历史，按q退出

    :history search或 / 或？ 查看搜索历史

普通模式下：

    q:  查看命令行历史

    q/  查看使用/输入的搜索历史
    q?  查看使用？输入的搜索历史

##### 插件有自己的快捷键

内置插件 netrw 的快捷键，参见章节 [vim 内置的树形文件夹插件 netrw]

文件夹树形展示插件 nerdtree 的快捷键，参见章节 [nerdtree 树形文件夹插件]。

小技巧：

vim /etc 内的文件，等保存时才发现没权限。曲线方法是先保存个临时文件，退出后再 sudo cp 回去。

实际上在 vim 里面可以直接完成这个过程的

    :w !sudo tee %

:w !{cmd}，让 vim 执行一个外部命令 {cmd}，然后把当前缓冲区的内容从 stdin 传入。tee 是一个把 stdin 保存到文件的小工具。%，是 vim 当中一个只读寄存器的名字，总保存着当前编辑文件的文件路径。

#### 理解vim的多文件操作（缓冲buffer）

    https://www.cnblogs.com/standardzero/p/10720922.html

vim 的缓冲区是内存中打开的文件。当你用 `:e filename` 打开一个文件时，Vim 就会创建一个缓冲区。你可以同时打开多个缓冲区，但同一时间只有一个缓冲区是活动的（即当前正在编辑的）。

文件的展示跟 Windows 不同，vim 的当前窗口显示某个缓冲区即某个文件，用户只能在该窗口切换不同的缓冲区即切换显示不同的文件，不存在像 Windows 似的切换窗口来实现切换文件。

vim 打开多个文件，每个文件都会加载到不同的缓冲区

    $ vim file1 file2 ... 同时打开多个文件，当前窗口只显示一个文件（缓冲区）

    :next 切换到下个缓冲区，即显示下个文件
    :prev 切换到下个缓冲区，即显示前个文件

    :next! 不保存当前缓冲区（文件的修改）并切换到下个文件
    :prev! 不保存当前缓冲区（文件的修改）并切换到上个文件

    :wnext 保存当前缓冲区（文件的修改）并切换到下个文件
    :wprev 保存当前缓冲区（文件的修改）并切换到上个文件

    :ls         展示缓冲区列表，即 vim 打开的文件列表
                NOTE:vi 缓冲区中的文件编号不是1，2，3的顺序分布。

    :b num      切换缓冲区（其中 num 为 buffer list 中的编号）即切换显示文件

    :bn         切换显示下一个文件
    :bp         切换显示上一个文件

    Ctrl+6      在普通模式下的热键，切换到下一个文件

                对于用 split 在多个窗口中打开的文件，切换缓冲区的命令只会在当前窗口中切换不同的文件。

    :bd         关闭当前打开的缓冲区，即清除当前文件的内容，单一窗口下也不会退出vim，或 :bdelete 。

    :q          退出vim，即关闭全部缓冲区并退出，如果有修改未保存会提示。
                如果是 tab 标签页或 window 分割窗口打开的文件，则会关闭当前标签页或窗口。

    :wq         保存修改并退出vim

    :q!         丢弃当前缓冲区退出vim，即你的文件修改不会被保存
    :qa!        丢弃所有缓冲区退出vim，即所有的文件修改不会被保存

    :e xxxx     在当前窗口打开文件
    :e          重新把当前文件加载到缓冲区，丢弃修改

    :close      关闭当前窗口
    :only       只显示当前窗口, 关闭所有其他的窗口

buffer状态

    - （非活动的缓冲区）
    a （当前被激活缓冲区）
    h （隐藏的缓冲区）
    % （当前的缓冲区）
    # （交换缓冲区）
    = （只读缓冲区）
    + （已经更改的缓冲区）

传统 vim 默认使用一个窗口显示文件，所以只能来回切换缓冲区以展示不同的文件。

后来的版本支持分屏多窗口展示不同的文件。

新版的 vim 支持使用多标签tab，即用标签页实现多窗口的一组，这时当前窗口展现的某个内缓冲区，关闭当前窗口可能会切换到其他标签页的窗口。

##### 分屏多窗口(Window)操作

在 vim 术语中，窗口是缓冲区的显示区域，窗口与缓冲区(文件)并非一一对应的关系：既可以打开多个窗口，在这些窗口中显示同一个缓冲区(文件)，也可以在每个窗口里载入不同的缓冲区(文件)。即窗口只是展示某个文件，关闭文件不对应关闭窗口。切换显示文件都是在同一个窗口内，切换的是缓冲区而不是窗口。

    :sp   当前窗口水平切分为两个窗口，或 :split
    :vs   当前窗口垂直切分为两个窗口，或 :vsp :vsplit
    上述两个命令后跟文件名会在新窗口打开该文件

    前导 Ctrl+w，然后 方向键        切换到前/下/上/后一个窗口
    前导 Ctrl+w，然后  h/j/k/l     同上
    前导 Ctrl+w，然后  w           依次向后切换到下一个窗口中

    :q      关闭当前窗口

    :qall    对所有窗口执行 :q  操作
    :qall!   对所有窗口执行 :q! 操作
    :wall    对所有窗口执行 :w  操作
    :wqall   对所有窗口执行 :wq 操作

##### 多标签页(Tab)操作

在 Windows 的文本编辑器中，一个标签页对应一个窗口也就对应了一个文件，多个标签页对应的是多个窗口也就对应了多个文件。在 Vim 中，标签页本质是窗口布局的容器（类似工作区）。Vim 中实现的标签页用于像现代编辑器一样用标签（TAB）来管理多个窗口，进而对应显示多个文件，理解成一个标签页是一组窗口。其实 vim 的不同标签页仍可以共享同一个缓冲区，例如在两个标签页中的窗口查看同一文件。

把 vim 的每个标签页理解为一个 vim 的实例即可

    :tabn       移动到下一个标签页 或 普通模式直接输入 gt
    :tabp       移动到上一个标签页 或 普通模式直接输入 gT

    :tabfirst   移动到第一个标签页
    :tablast    移动到最后一个标签页

    :help tab-page-intro 标签页使用的帮助信息

    :tabnew          新建标签页
    :tabe filename   用标签页打开文件
    :tabnew filename 用标签页打开文件

    :tabs       显示已打开标签页的列表
    :tabc       关闭当前标签页，功能等同于 :q
    :tabo       关闭所有标签页
    :tabm 0/1/2 将当前标签页移动到第1/2/3个页面位置

注意：

    理论上，每打开一个文件就应该建立一个标签页对应一个窗口。但是现在 vim 打开多个文件并不会默认建立多个标签页，而是都在同一个标签页中，即保持 vi 历史习惯，多个文件公用的缓冲区在一个窗口内显示。

    新建标签页相当于多了至少一个窗口，使用时要先考虑当前窗口对应的哪个标签页，切换标签页时窗口也是切换的，其加载的缓冲区可能是不同的。

###### 使用 alt+数字键 来切换 tab 标签页

前导键使用 alt 容易跟桌面终端模拟器热键冲突，我使用 vim-airline 自带的标签页功能的自定义前导键进行切换，详见章节 [.vimrc配置文件样例]。

根据下面这个文章我自定义热键用 Alt 总是设置不上，用的 Ctrl+w 解决了，不知道咋回事，待研究

    https://blog.csdn.net/ghostyusheng/article/details/77893780

或自定义

用 gt, gT 来一个个切换有点不方便, 如果用 :tabnext {count}, 又按键太多.

可以用 alt + n 来切换tab标签, 比如按 alt + 1 切换到第一个 tab，按 alt + 2 切换到第二个 tab。

把以下代码加到你的 .vimrc 文件, 或者存为 .vim 文件，然后放到 plugin 目录

```vim

function ! TabPos_ActivateBuffer(num)
     let  s:count = a:num
     exe  "tabfirst"
     exe  "tabnext"  s:count
endfunction

function ! TabPos_Initialize()
for  i  in  range(1, 9)
         exe  "map <M-"  . i .  "> :call TabPos_ActivateBuffer(" . i .  ")<CR>"
     endfor
     exe  "map <M-0> :call TabPos_ActivateBuffer(10)<CR>"
endfunction

autocmd VimEnter * call TabPos_Initialize()

```

上面的看上去太复杂了，来个简单的

```vim

    " 用 alt + n 来切换tab标签
    :nn <M-1> 1gt
    :nn <M-2> 2gt
    :nn <M-3> 3gt
    :nn <M-4> 4gt
    :nn <M-5> 5gt
    :nn <M-6> 6gt
    :nn <M-7> 7gt
    :nn <M-8> 8gt
    :nn <M-9> 9gt
    :nn <M-0> :tablast<CR>

```

#### vim 执行shell命令

简单的shell，切换回 vim 需要在 shell 下输入文字

    在普通模式下输入 ":sh"，可以运行一个shell，想回到vim编辑器中用`exit`或`ctrl+D`返回vim编辑器，该shell消失

    在普通模式下输入 ":!xxx"，在当前目录下运行指定的命令xxx，运行结束后自动回到 vim 编辑器中

    用 "Ctrl+Z" 回到启动 vim 的 shell，用 `fg` 返回 vim 编辑器中

新建拆分窗口，内嵌 terminal 这个新加的功能更直观：

写完代码想测试一下，有几个方法：保存并退出vim，然后运行，或执行章节 [命令行模式] 中介绍的“执行shell命令”的几个方法，都太繁琐不直观。

自从vim 8.1版本后，支持了一个新的命令 :ter 或 :terminal，在vim中拆分窗口打开一个shell，所以使用切换拆分窗口的快捷键来在你的文本窗口和终端窗口中切换即可。

详细内容参看

    :help terminal

暂时关闭/隐藏这个terminal窗口，而不希望shell中的工作被杀死，或者一些东西消失（就比如当前进入的某个及其深的目录，或者activate的某个conda环境）

    按 Ctrl+w 并输入 :hide 。注意 Ctrl+w 后直接输入命令，不要切换到文本窗口输入命令

要恢复这个隐藏了的窗口，需要先知道它在哪个 buffer。在文本窗口输入命令

    :ls

然后使用 :buffer 命令切换，因为这个命令会在当前窗口打开buffer，所以要提前split或vsplit一个新的窗口，然后根据buffer的序号，比如2，输入命令

    :buffer 2

关闭这个terminal

    [Ctrl+w]:quit!

要加!，因为vim认为这个工作没有结束，不能这么轻易地关了。

以特定高度/行数打开

    :ter ++rows=2

#### vim 使用鼠标

鼠标右键不能粘贴而是进入了 visual 模式

解决方法一

    # 禁用鼠标
    :set mouse-=a

    # 或编辑 ~/.vimrc 文件，加入如下代码：
    if has('mouse')
        set mouse-=a
    endif

解决方法二

    鼠标选择后使用快捷键 p 粘贴

鼠标模式 :

    set mouse= 设置在何种模式下进入鼠标模式

    n   普通模式
    v   可视模式
    i   插入模式
    c   命令行模式
    h   在帮助文件里，以上所有模式
    a   以上所有模式
    r   跳过|lit-enter|提示
    A   在可视模式下自动选择

缺省值为空，即不进入鼠标模式，这时的鼠标响应:用鼠标在 vim 中选择，会进入可视模式，但点击右键会触发终端工具的右键菜单操作，而不是触发vim自己的热键操作。也就是说，默认情况下点击拖动鼠标进入的这个可视模式，vim 不会响应热键做y复制、d删除等操作。

如果进行了设置，则在对应的模式下点击拖动鼠标后，你可以使用vim热键了。

    # 等价于 mouse=nvich
    :set mouse=a

    # 关闭鼠标功能
    :set mouse-=a
    或
    :set mouse=""

    # 设置鼠标在普通模式和可视模式下工作
    :set mouse=nv

鼠标能否在可视模式或者选择模式下开始选择，决定于 "selectmode" 选项包不包括"mouse"。

所以，如果你开启了鼠标功能，则在鼠标选择进入的可视模式下复制/粘贴，操作模式如下

    在文本的第一个字符上按鼠标左键，拖动鼠标到文本的最后一个字母，然后释放左键。这会启动可视模式并高亮选择区域。

    按 "y" 抽出可视文本到 vim 无名寄存器里。

    移动光标到要插入的位置，或按鼠标左键选择插入位置，光标在此处闪动。

    按鼠标中键（滚轮），或按 p 键粘贴。

自定义鼠标滚轮的操作，也需要开启鼠标模式才能有效设置。

    " 用鼠标滚轮滚屏
    set mouse=a
    map <ScrollWheelUp> <C-Y>
    map <ScrollWheelDown> <C-E>

不要使用模仿 Windows 鼠标习惯的一个 mswin.vim， 如“Ctrl + A”全选、 “Ctrl + C”复制、 “Ctrl + V”粘贴等等， 这些快捷键与vim本身的快捷键有不少是冲突的：部分原有的快捷键映射成了别的键， 例如把“Ctrl + V”(矩形块选择)改成了粘贴， 而原有的“Ctrl + V”改成了“Ctrl + Q”； 还有部分快捷键就彻底没有了， 如原有的“Ctrl + A”(将当前光标所在的数字加 1)改成了全选， 而原有的相应功能就找不到了

    :behave mswin

##### 服务器vim复制到本地剪贴板

当通过终端工具用 ssh 连接到 linux 服务器上使用 vim 时，使用热键y只能复制到vim的寄存器，无法复制到用户终端所在的本地操作系统的剪贴板。

简单的方法

一般终端工具，在命令行时的默认行为是 x-Window 下的，鼠标选择即复制，中键（或右键或 shift+ins）粘贴，这个是操作系统剪贴板。

在 vim 中，用鼠标选择，默认会进入可视模式进行多选，然后按右键，在终端工具的弹出菜单选：复制，这样即可复制到系统剪贴板。然后可以在文本编辑模式下，用 shift+ins 来粘贴了，这个也是读取的系统剪贴板。

复杂的方法

cmd + c

用鼠标选中文字cmd + c复制（windows下ctrl + c复制），cmd + v粘贴到本地。这个方法是最自然的，但是想要用这个方法有几个前提：

vim配置中开启鼠标支持，.vimrc文件中加上

    set mouse=a

终端工具关闭mouse reporting选项，否则鼠标点击vim界面会进入visual模式。

如果使用tmux，tmux需要配置支持鼠标滚轮，否则最多只能复制当前页面的内容

冷门点的解决办法：本地 vim 通过 scp 编辑远程文件

使用本地vim(要求本机是linux)通过scp直接编辑远程文件。这样就可以使用本地寄存器"+y"复制了。这种方法对远程vim配置没有要求。

    vim scp://remoteuser@server.com//absolute/path/to/file

注意 com 和 absolute 间是两个反斜杠//并不是敲错了。

#### vim寄存器--删除是剪切操作

    vim中没有删除，实际上都是剪切，黑洞寄存器除外

你以为用 x、dw、dd 这种热键是删除内容，其实该内容会替换到最近的无名寄存器。

    如果复制了内容想替换，直接 ctrl+v 进入可视模式，选好了之后直接按 p 粘贴即可覆盖原内容。

测试文件

    echo abc > test.txt
    echo xyz >> test.txt

比如，你复制了"abc"，想替换文件中的"xyz"。

如果你的操作是

    先 v y 复制"abc"，然后 dw 删除"xyz"，然后按 p 粘贴，你会发现粘贴的还是"xyz"

原因是

    你执行的 yy 命令 其实是 ""yy，不指定就是默认的无名寄存器

    然后执行 dd 命令时，vim 把删除的内容放到无名寄存器，覆盖了之前复制的内容

    最终执行 p 命令时，默认粘贴的是无名寄存器的内容，而这已经不是 yy 命令复制的那个内容了

所以，在 vim 中删除然后粘贴的操作是有顺序依赖的

    先 dw 删除"xyz"，然后 v 选择"abc"然后 y 复制，然后按 p 粘贴，你才能粘贴上"abc“

或者粘贴的时候，指定 "0复制寄存器，然后粘贴操作即可

    "0p 粘贴复制寄存器的内容

系统寄存器列表

    :reg

    Name       Content
    ""       x、s、d{motion}、c{motion} 和 y{motion} 指令都会覆盖无名寄存器中的内容，按p会粘贴回去
    "0       保存 y{motion} 指令复制的内容
    "1       104.188^J，复制寄存器1
    "2       4.117^J，复制寄存器2
    ......
    "-       上一次删除的文本
    ".       上一次插入的文本
    "*       系统剪贴板
    "%       当前文件的名字
    "/       上一次查找的字符串
    ":       上次执行的命令

普通模式下使用寄存器，直接使用 "开头的寄存器名称加命令 操作即可

    "0p    从0号寄存器粘贴内容

    "+y    将内容复制到系统剪切板中，供其他程序使用

    使用系统剪贴板粘贴还是先进入文本模式，然后按 shift + Ins

    这里说的系统剪贴板，通过终端工具，使用的是用户操作系统的剪贴板。

插入模式下使用寄存器，比如：在文本输入模式，使用寄存器里的内容

    使用前导键 <C-r> 即可: <C-r>0  从0号寄存器粘贴内容

用 / 输入搜索内容 或 : 命令行模式 都可用这个方法使用寄存器里的内容。

也可以设置 vim 默认使用系统剪贴板 <https://www.cnblogs.com/huahuayu/p/12235242.html>

    确定vim支持 +clipboard后，如果想 y/p 直接和系统剪贴板打通，可以在~/.vimrc中加上以下配置）：

        set clipboard^=unnamed,unnamedplus

    其中unnamed代表 *寄存器，unnamedplus 代表 +寄存器。在mac系统中，两者都一样；一般在linux系统中+和*是不同的，+对应ctrl + c,ctrl + v的桌面系统剪贴板，*对应x桌面系统的剪贴板（用鼠标选择复制，用鼠标中键粘贴）。

建议给 vim 安装个插件，在按到热键 " 时显式寄存器内容，便于使用

    https://github.com/junegunn/vim-peekaboo

### tmux 不怕断连的多窗口命令行

tmux 可以保持多个会话 session，每次在命令行运行 `tmux` 就会新建一个会话，新建会话默认有一个窗口 window 一个面板 pane，面板会自动运行一个 shell。

可以在一个会话里添加多个窗口，tmux 状态栏显示的就是 "会话号/窗口0/窗口1/窗口2/..." 的形式。

每个窗口又可以拆分成多个面板，在屏幕上是横线或竖线分隔显示的，面板可以在窗口中有多种排列，每个面板都运行一个shell。

只要不主动退出当前面板的 shell，或重启计算机，任何时候都可以通过连接的方式回到你的 tmux 操作界面。

任意的非 tmux shell 都可以连接 attach 到已有会话，支持多人同时连接到同一个会话，互相的输入可见，相当于共享屏幕的多人编程。

    tmux的使用方法和个性化配置 http://mingxinglai.com/cn/2012/09/tmux/

    Tmux使用手册 http://louiszhai.github.io/2017/09/30/tmux/

    http://man.openbsd.org/OpenBSD-current/man1/tmux.1

如果感觉 tmux/screen 用起来比较麻烦，有个前端替代品（后端调用 tmux 进程）

    https://github.com/dustinkirkland/byobu

    Zellij 是 rust 实现的竞品 https://github.com/zellij-org/zellij

> 如果遇到提示无法打开 display:0 的错误

常见于 ssh -X 连接远程

    https://github.com/lljbash/tmux-update-display

如果是 tmux 下执行命令 `glxinfo` 提示该错误，退回到普通的终端下重新执行 `glxinfo` 即可。

> tmux 在 OSX 下水土不服

    https://www.economyofeffort.com/2013/07/29/reattach-to-user-namespace-the-fix-for-your-tmux-in-os-x-woes/

#### 安装

1.操作系统仓库安装

    sudo apt install tmux

2.源代码编译安装

    git clone --depth=1 https://github.com/tmux/tmux.git
    cd tmux
    sh autogen.sh
    ./configure && make

有个好心人提取的 Msys2 里的 tmux，可在 git for Widnows 环境下使用

    https://github.com/hongwenjun/tmux_for_windows

#### 常用命令

    按完前导 ctrl+B 后，再按冒号：进入命令行模式

这些命令在 tmux 的 : 命令行模式一样可以使用

    tmux

        新建一个会话，并连接到该会话

    tmux ls

        列出当前的会话（tmux session），下面表示0号有2个窗口

            0: 2 windows (created Tue Apr 13 17:28:34 2021)

    tmux new -s mydevelop

        创建一个新会话名为 mydevelop，并连接到该会话

    tmux new -s share_with -t mydevelop

        创建组的方法是在创建第二个session的时候用 -t target-session 将前一个session指定为新session的目标session，这样也是进入双人共用模式，但是可以分别查看不同的窗口。<https://www.cnblogs.com/bamanzi/p/tmux-share-windows-between-sessions.html>

    #  ssh -t localhost tmux  a
    tmux new-session -s username -d

        新建一个 tmux 会话 ，在开机脚本（Service等）中调度也不会关闭
        https://stackoverflow.com/questions/25207909/tmux-open-terminal-failed-not-a-terminal

    tmux a

        进入tmux，直接连接到上次退出前的那个会话的那个窗口的那个面板

    tmux a -t mydevelop

        进入tmux，连接到名为 mydevelop 的会话，如果有人已经连接，则进入双人共用模式，互相操作可见

    tmux a -t 3

        进入tmux，连接到3号会话

    tmux kill-session -t mydevelop

        不用的会话可能有很多窗口，挨个退出很麻烦，直接杀掉会话，mydevelop 是要杀掉的会话名称

    tmux rename -t old_session_name new_session_name

        重命名会话

    # 列出所有快捷键，及其对应的 Tmux 命令
    tmux list-keys

    # 列出所有 Tmux 命令及其参数
    tmux list-commands

    # 列出当前所有 Tmux 的信息
    tmux info

    # 重新加载当前的 Tmux 配置而无需重启 tmux 进程
    tmux source-file ~/.tmux.conf

如果 tmux 显示的内容乱了，用 `reset` 命令也处理不了，退出所有的会话，包括后台进程 tmux server

    $ tmux kill-server

    然后重新执行 tmux 命令即可

使用 `tmux kill-server` 命令后，再次执行 tmux 命令出现 `server exited unexpectedly` 的错误

    https://github.com/tmux/tmux/wiki/FAQ#tmux-exited-with-server-exited-unexpectedly-or-lost-server-what-does-this-mean

    $ cd /tmp
    $ rm -rf tmux-$(id -u)

    然后重新执行 tmux 命令即可

tmux 进程正在运行，但是无法连接 “failed to connect to server: Connection refused”

    $ kill -s USR1 <tmux进程id>
    $ tmux ls

#### 快捷键

    https://ruanyifeng.com/blog/2019/10/tmux.html

    MacOS 下可以做映射
        https://www.joshmedeski.com/posts/macos-keyboard-shortcuts-for-tmux/

前导键是个组合键 ctrl+b，松开后再按其它键：

会话（Session）

    ?       显示所有快捷键，使用 pgup 和 pgdown 翻页，按 q 退出(其实是在 vim 里显示的，命令用 vim 的)

    :       进入命令行模式，可输入命令如：

                source-file ~/.tmux.conf
                show-options -g  # 显示所有选项设置的参数，使用 pgup 和 pgdown 翻页，按 q 退出
                set-option -g display-time 5000 # 提示信息的持续时间；设置足够的时间以避免看不清提示，单位为毫秒

    s       列出当前会话，通过上、下键切换，回车确认切换到该会话的默认窗口

            下面表示 0 号会话有 2 个窗口，是当前连接，1 号会话有 1 个窗口
                (0) + 0: 2 windows (attached)
                (1) + 1: 1 windows

    w       列出当前会话的所有窗口，通过上、下键切换，回车确认连接到该窗口。

            新版tmux按树图列出所有会话的所有窗口，切换更方便，不需要先s选择会话了

    $       重命名当前会话；这样便于识别

    左中括号  copy-mode 模式，查看屏幕历史，使用 pgup 和 pgdown 翻页，按 q 退出

    d       脱离当前会话返回你的 shell，tmux 里面的所有会话在后台继续运行，会话里面的程序不会退出。
            如果 ssh 突然断连，也是相同的效果，下次登录后在命令行运行 `tmux a` 就能重新连接到之前的会话

窗口（Window）

    c       创建新窗口，状态栏会显示窗口编号

    w       列出当前会话的所有窗口，通过上、下键切换，回车确认切换到该窗口。

            新版的按树图列出所有会话的所有窗口，切换更方便

    数字0-9  切换到指定窗口

    n       切换到下一个窗口
    p       切换到上一个窗口

    ,       重命名当前窗口；这样便于识别
    .       修改当前窗口编号；相当于窗口重新排序

面板（pane）

窗口可以拆分为面板，默认情况下在一个窗口中只有一个面板，占满整个窗口区域。

每个面板都运行一个shell，面板是用户界面切分的最小单位。

    "       在当前窗口新建面板，向下拆分
    %       在当前窗口新建面板，向右拆分

    空格     当前窗口的多个面板在各种布局方式间切换

    o       选择下一面板
    方向键   在相邻两个面板中切换

    {       当前面板与上一个面板交换位置
    }       当前面板与下一个面板交换位置

    !       将当前面板拆分为一个独立窗口

    z       当前面板全屏显示，再使用一次会变回原来大小

    q       显示面板编号

    Ctrl + 方向键     以1个单元格为单位移动边缘以调整当前面板大小
    Alt + 方向键      以5个单元格为单位移动边缘以调整当前面板大小

    t       在当前面板显示一个时钟，等于在当前面板的shell里执行命令 `tmux clock`，按 q 退出。

如果在 shell 中执行命令 exit 或按 ctrl+d 退出当前 shell，关闭的顺序如下：

    先退出当前面板，返回到当前窗口的上一个面板，

    如果没有面板可用，则退出当前窗口，返回到当前会话的上一个窗口的某个面板，

    如果当前会话的所有窗口都退出了，当前的会话就会被关闭并退出 tmux，但 tmux 的其他会话在后台继续运行。

    x       关闭当前面板，并自动切换到下一个，
            操作之后会给出是否关闭的提示，按 y 确认即关闭。
            等同于在当前的 shell 下执行 exit 命令。

    &       关闭当前窗口，并自动切换到下一个，
            操作之后会给出是否关闭的提示，按 y 确认即关闭。
            等同于当前所有面板的 shell 下执行 exit 命令。

#### tmux 的 copy 模式 -鼠标或光标选择

查看历史输入时的翻页、移动光标、切换选择窗口等方向键绑定使用 vi 模式，原默认是 emacs 模式

    set-window-option -g mode-keys vi

前导键 + [ 进入 tmux 的 copy-mode，默认按键使用 Emacs 模式

    按空格键进入选择模式，然后移动光标进行选择，再按回车键复制并退出，按 q 不复制并退出

    不会复制到系统剪贴板，由 tmux 自行管理，在命令行执行 `tmux show-buffer` 显示复制的内容

    前导键 + ] 粘贴复制的内容

在 tmux 里运行 vim 复制到 Windows 剪贴板

    直接用鼠标选择的时候，是由 vim 处理的，需要按住 shift 进行选择，才会复制到系统剪贴板

    后来用vnc连server发现在vim中也是同样适用的。

##### 建议开启鼠标功能

    set-option -g mouse on

开启鼠标后：

可以用鼠标在 tumx 状态栏点击切换窗口。

可以用鼠标点击窗口的切分面板，自动把用户输入的焦点切换到该面板，即获得了该面板的光标。

可以用滚轮方便的查看当前面板的历史输出，按 q 退出。

右键单击 tmux 面板进行标记，该面板的边框会加粗显示，脚本里可以引用该标记面板，界面操作无感，状态栏对应的窗口名会出现 M 字样。

tmux 中开启鼠标后，在终端工具中常用的鼠标右键粘贴等就不能用了，需要换个操作方式：

    鼠标选择前，按住 Shift 键，然后点击鼠标左键拖动选择，即可复制到系统剪贴板，熟悉的中键操作又回来了。

    在文本输入模式，用 Shift+Insert 可将系统剪切板中的内容输入 tmux 中。

相对于 tmux 原生的选择模式（不加 shift 键），使用系统选择有个缺陷，即当一行内存在多个面板时，无法选择单个面板中的内容，这时就必须使用 tmux 自带的复制粘贴系统了 ctrl+shift+c/v。

#### tmux 开机自启动脚本

示例脚本，开机自动启动tmux服务，运行指定的程序。

```shell

#!/bin/bash
# https://github.com/Louiszhai/tmux/blob/master/init.sh
# 该脚本用于开机初始化tmux服务

# 后台创建一个名称为init的会话
tmux new -s init -d

# 重命名init会话的第一个窗口名称为service
tmux rename-window -t "init:1" service

# 切换到指定目录并运行python服务
tmux send -t "init:service" "cd ~/workspace/language/python/;python2.7 server.py" Enter

# 默认上下分屏
tmux split-window -t "init:service"

# 切换到指定目录并运行node服务
tmux send -t "init:service" 'cd ~/data/louiszhai/node-webserver/;npm start' Enter

# 新建一个名称为tool的窗口，neww等同于new window
tmux neww -a -n tool -t init

# 运行weinre调试工具
tmux send -t "init:tool" "weinre --httpPort 8881 --boundHost -all-" Enter

# 水平分屏
tmux split-window -h -t "init:tool"

# 切换到指定目录并启用aria2 web管理后台
tmux send -t "init:tool" "cd ~/data/tools/AriaNg/dist/;python -m SimpleHTTPServer 10108" Enter

```

#### tmux 扩展插件

插件大全

    https://github.com/tmux-plugins/list

要设置 tmux 界面使用彩色，比如 tmux 的状态栏彩色，以及在 tmux 下使用 vim 能够支持它的插件的彩色显示，需要编辑 ~/.tmux.conf 文件，添加如下行

    # 设置状态栏工具显示256彩色
    # 如果终端工具已经设置了变量 export TERM="xterm-256color"，那么这个参数可有可无
    set -g default-terminal screen-256color
    # 真彩色
    # https://github.com/tmux/tmux/wiki/FAQ#how-do-i-use-rgb-colour
    #   https://github.com/tmux/tmux/raw/master/tools/24-bit-color.sh
    #set -as terminal-features ",xterm-256color:RGB"  # tmux 3.2+
    set -as terminal-overrides ",xterm-256color:RGB"

多彩色设置的其它依赖项，详见章节 [终端模拟器和软件的真彩色设置]。

> 插件管理

    感觉 tmux 需要的插件不多，就不用安装插件管理器了

    插件管理器

        https://github.com/tmux-plugins/tpm

    插件大全

        https://github.com/tmux-plugins/list

##### 状态栏显示使用 powerline

powerline 过时了，推荐 nord 主题的状态栏，参见下面章节 [状态栏显示不使用 powerline]。

    https://bobbyhadz.com/blog/tmux-powerline-ubuntu

先安装 powerline，见章节 [状态栏工具 powerline]。

tmux 状态栏使用 powerline，编辑 ~/.tmux.conf 文件，添加如下行

    run-shell 'powerline-config tmux setup'

然后就可以自由发挥了。

###### 定制 powerline 的段 Segment

powerline 有插件用于 tmux 状态栏显示，定制显示的内容可编辑 powerline 的配置文件

    # 如果是pip安装的查看路径用 pip show powerline-status
    /usr/share/powerline/config_files/themes/tmux/default.json

替换自己喜欢的函数即可

    官方函数说明 https://powerline.readthedocs.io/en/master/configuration/segments.html

```json
{
    "segments": {
        "right": [
            {
                    "function": "powerline.segments.common.sys.uptime",
                    "priority": 50
            },
            {
                    "function": "powerline.segments.common.sys.system_load",
                    "priority": 50
            },
            {
                    "function": "powerline.segments.common.time.date"
            },
            {
                    "function": "powerline.segments.common.time.date",
                    "name": "time",
                    "args": {
                            "format": "%H:%M",
                            "istime": true
                    }
            },
            {
                    "function": "powerline.segments.common.net.hostname"
            }
        ]
    }
}
```

##### 状态栏显示不使用 powerline

你的计算机需要安装图标字体，这样使用终端模拟器登录远程服务器时才能显示 tmux 上的特殊字符，参见章节 [Nerd font]。

> 安装 nord 状态栏主题插件

使用这个插件的好处是它支持 <https://github.com/tmux-plugins> 的所有插件，可以在状态栏显示图标字符，启动速度也比 powerline 快。

最好终端工具也启用 nord 主题，否则颜色方案会不一致

    https://www.nordtheme.com/ports/tmux
        https://github.com/arcticicestudio/nord-tmux

不使用插件管理器的安装步骤：

先从 github 下载

    git clone --depth=1 https://github.com/arcticicestudio/nord-tmux ~/.tmux/themes/nord-tmux

将下述命令添加到.tmux.conf文件中

    run-shell "~/.tmux/themes/nord-tmux/nord.tmux"

重新加载配置文件

    tmux source-file ~/.tmux.conf

> 安装 tmux-powerline 状态栏主题插件

这个只使用 bash 脚本实现，保持你的环境更干净

    https://github.com/erikw/tmux-powerline

##### 保存 tmux 会话

如果 tmux 开启的会话较多，希望重启后能一次性恢复

    https://github.com/tmux-plugins/tmux-resurrect

    竞品 https://github.com/tmux-python/tmuxp

安装

    # 注意目录名是 resurrect 可以保存到本目录下而不是 .local/share/，方便
    $ git clone --depth=1 https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/resurrect

    编辑 ~/.tmux.conf 文件

        # 保存会话
        run-shell "~/.tmux/resurrect/resurrect.tmux"

    重载配置文件使之生效

        tmux source-file ~/.tmux.conf

操作快捷键

    建议先给会话命名以便查找， ctrl + b 然后 $ 输入会话的名称即可

    关闭 tmux 前手动保存当前会话

        前导键 ctrl + b，然后 ctrl + s，会在左下角 tmux 状态栏会显示 saving ... 字样 ， 完毕后会提示 Tmux environment saved 字样

        会将 Tmux 会话的详细信息以文本文件形式保存到 ~/.tmux/resurrect 目录。

    打开 tmux 后手动还原tmux会话

        前导键 ctrl + b，然后 ctrl + r，会在状态栏闪现提示恢复完成的消息

默认只恢复面板布局和指定的程序，想恢复更多的程序要再进行设置

    详见下面章节 [.tmux.conf 配置文件样例]

这个扩展插件的代码功能实现的不好，而且跟说明文档对不上，复杂点的使用需要自行分析源代码

    https://github.com/tmux-plugins/tmux-resurrect/blob/master/docs/restoring_programs.md

    https://github.com/jimeh/tmuxifier
    https://github.com/tmuxinator/tmuxinator

    https://blog.csdn.net/u013670453/article/details/116296687

保存的会话配置文件位于

    # 源代码目录下的 scripts/helper.sh 分析得到
    $HOME/.tmux/resurrect 或 "${XDG_DATA_HOME:-$HOME/.local/share}"/tmux/resurrect

    last 文件指向最后一次保存的面板布局和程序

    pane_contents.tar.gz 是最后一次保存的面板内容

或者使用脚本自行恢复

```bash

#!/bin/bash

SESSIONNAME="monitor"

# $1:SESSIONNAME
function UUDF_TMUX_ATTACH_SESSION {

    tmux has-session -t $1 &> /dev/null

    if [ $? != 0 ]
    then
        tmux new-session -s $1 -n script -d
    fi

    tmux attach -t $1
}

# $1:SESSIONNAME
function UUDF_TMUX_SEND_TO_SESSION {

    tmux send-keys -t $1 "~/bin/script" C-m

}

# select-window -t :=0 \; select-pane \; send-keys -X

```

> 每隔 15 分钟自动备份一次会话 tmux-continuum

感觉没必要用这个插件

    https://github.com/tmux-plugins/tmux-continuum

安装

        $ git clone --depth=1 https://github.com/tmux-plugins/tmux-continuum ~/.tmux/tmux-continuum

    编辑 ~/.tmux.conf 文件

        run-shell ~/.tmux/tmux-continuum/continuum.tmux

        # Tmux Continuum 默认每隔 15 分钟备份一次，如果你频率过高，可以设置为 1 小时一次：
        set -g @continuum-save-interval '60'

    重载配置文件使之生效

        tmux source-file ~/.tmux.conf

##### 冻结本地 tmux 热键

如果在 tmux 里使用 ssh 连接远程服务器，在 ssh 里运行 tmux 会导致热键冲突，这个插件可以冻结本地的 tmux 响应热键

    https://github.com/MunifTanjim/tmux-suspend

安装：

    $ git clone --depth=1 https://github.com/MunifTanjim/tmux-suspend.git ~/.tmux/tmux-suspend

    编辑 ~/.tmux.conf 文件

        run-shell ~/.tmux/tmux-suspend/suspend.tmux

    重载配置文件使之生效

        tmux source-file ~/.tmux.conf

使用：

    按 F12 将冻结本地的 tmux 响应热键，这样当前面板 pane 里的远程 ssh 连接中的 tmux 就可以接收到你的热键了，再次按 F12 将取消冻结。

##### 显示前导键

在 tmux 时间栏显示你按下了引导键

    https://github.com/tmux-plugins/tmux-prefix-highlight

先从 github 下载

    $ git clone --depth=1 https://github.com/tmux-plugins/tmux-prefix-highlight.git ~/.tmux/tmux-prefix-highlight

将下述命令添加到.tmux.conf文件中

    run-shell ~/.tmux/tmux-prefix-highlight//prefix_highlight.tmux

##### .tmux.conf 配置文件样例

```conf
# 可参考一个非常流行的配置 https://github.com/gpakosz/.tmux
#
# 按完前导 ctrl+B 后，再按冒号即可进入命令行模式
# 下列命令在 tmux 的命令行模式一样可以使用

# 窗口保存的历史内容行数
set-option -g history-limit 20000

# 把前导键从 ctrl+b 改成 ctrl+x， M-a是Alt+a
# set-option -g prefix C-x unbind-key C-b bind-key C-x send-prefix

# 查看历史输入时的翻页、移动光标、切换选择窗口等方向键绑定使用 vi 模式，原默认是 emacs 模式
set-window-option -g mode-keys vi

# 开启鼠标滚屏，鼠标点选当前面板，切换窗口。如不设置，默认是终端工具下发的滚轮选择历史命令，实在无用。
#set-option -g mouse on # v2.1 之前的老版本 set-option -g mode-mouse on
set -g mouse on

# 设置状态栏工具显示256彩色
# 如果终端工具已经设置了变量 export TERM="xterm-256color"，那么这个参数可有可无
set -g default-terminal screen-256color
# 真彩色
# https://github.com/tmux/tmux/wiki/FAQ#how-do-i-use-rgb-colour
#   https://github.com/tmux/tmux/raw/master/tools/24-bit-color.sh
set -as terminal-features ",xterm-256color:RGB"  # tmux 3.2+
#set -as terminal-overrides ",gnome*:Tc"

# 退出 tmux 后恢复方块光标闪烁，未实现。手工执行 `reset` 规避吧
#set-hook -g client-detached 'run-shell "tput cnorm; echo -e \"\\033[?12h\\033[1 q\""'
#set-hook -g session-closed  'run-shell "tput cnorm; echo -e \"\\033[?12h\\033[1 q\""'
# 上面两个无法影响父shell，干脆禁用光标修改
#set -ga terminal-overrides ",xterm-256color:Tc:smcup@:rmcup@"

# 状态栏使用 nord 主题，替换掉 powerline
# run-shell 'powerline-config tmux setup'
run-shell "~/.tmux/themes/nord-tmux/nord.tmux"

# 显示前导键
run-shell "~/.tmux/tmux-prefix-highlight/prefix_highlight.tmux"

# 冻结本地 tmux 热键，使用于 ssh 连接到远程使用 tmux 的场合，按 F12 切换
run-shell ~/.tmux/tmux-suspend/suspend.tmux

# 保存会话
run-shell "~/.tmux/resurrect/resurrect.tmux"
# 恢复会话中运行的程序
set -g @resurrect-processes 'btop nmon watch "journalctl -f" "cmatrix -ba" "podman container stats"'
# 恢复会话中面板的内容
set -g @resurrect-capture-pane-contents 'on'

```

重新加载配置文件

    $ tmux source-file ~/.tmux.conf

#### 竞品 screen/Zellij

    https://www.cnblogs.com/bamanzi/p/switch-tmux-to-gnu-screen.html

    竞品 Zellij

        https://zellij.dev/
            https://github.com/zellij-org/zellij

        https://zhuanlan.zhihu.com/p/600682580

特殊功能

    Screen 支持 Zmodem 协议，也就是说，你可以用 rz、sz 命令方便的传输文件 <https://adammonsen.com/post/256/>。

    Screen 可以通过串行连接进行连接，如运行命令 `screen 9600 /dev/ttyUSB0` 连接 usb 端口调试，通过按键绑定可以方便地发出 XON 和 XOFF 信号，Windows 下的 putty 也支持连接 COM 口登录。

安装发行版的即可

    sudo apt install screen

在Screen环境下，所有的会话都独立的运行，并拥有各自的编号、输入、输出和窗口缓存。

用户可以通过快捷键在不同的窗口下切换，并可以自由的重定向各个窗口的输入和输出。GNU Screen的窗口与区域关系更接近Emacs里面buffer与window的关系：

    gnu screen 里面的 region 相当于 tmux 里面的 pane，而 screen 的 window 更类似于跑在 tmux pane 里面的程序；与 tmux 不同的是，一般情况下程序/窗口是隐藏的，每次只把一个程序/窗口切换到当前 region 来（tmux 里面一般情况下所有程序都会在某个 window 的某个 pane 里面显示者，除非有其它 pane 被最大化导致当前 pane 被隐藏了）

    GNU Screen 里面没有 tmux 里面的 window 那样的东西，它的 layout 倒是 跟 tmux 的 window 有点像，虽然我们可以从一个 layout 切换到另外一个 layout，但 layout 只是 region 的容器，而不是 window 的容器，两个 layout 里面是可以查看同一个应用(window)的．

Screen 实现了基本的文本操作，如复制粘贴等；还提供了类似滚动条的功能，可以查看窗口状况的历史记录。窗口还可以被分区和命名，还可以监视后台窗口的活动。

命令行操作：

列出当前存在的会话列表

    $ screen -ls
    There are screens on:
            # 会话名格式 [[pid.]tty[.host]]
            335.pts-4.jn-zh (08/07/22 17:56:22)     (Detached)
            29396.pts-4.jn-zh       (08/07/22 17:47:42)     (Detached)
    2 Sockets in /run/screen/S-pi.

连接到已有的会话，用上面看到的系统给出的默认会话名或pid即可。

    $ screen -r 29396

创建一个名字为lamp的会话并连接到该会话

    $ screen -S lamp

连接到会话以后就可以执行操作了，在此期间，可以随时关闭SSH,或自己的电脑，会话中的程序不会关闭，仍在运行。

特殊：如果你在另一台机器上没有分离一个Screen会话，就无从再次连接这个会话。

    $ screen -d <作业名称> 　将指定的screen会话离线。

    $ screen -m <作业名称> 　即使目前已在作业中的screen作业，仍强制建立新的screen会话。

    $ screen -R <作业名称> 　先试图恢复离线的会话。若找不到离线的作业，即建立新的screen会话。

    $ screen -wipe 　检查目前所有的screen作业，并删除已经无法使用的screen作业。

GNU Screen 的默认前导键是 Ctrl+A。

常用快捷键，先按引导键 Ctrl+a，然后按

    d      退出当前的screen界面回到初始的shell，当前运行的会话进程不关闭，其中的程序会继续运行

    c     在当前screen会话中创建窗口

    w         数字显示窗口列表
    "         上下光标键可选择的窗口列表
    C-a       在两个最近使用的 window 间切换
    [Space]   由视窗0循序切换到视窗9
    0-9       在第0个窗口和第9个窗口之间切换
    n         下一个窗口
    p         上一个窗口

    x      锁屏(需要你有该Linux登录用户的登录密码才能解锁，否则，当前的会话终端算是废了，你需要重新打开一个终端才行)(锁屏后，重新登录一个设置过密码的 Screen 会话，你需要输入2次密码，第一次是输入Linux系统的登录密码，第二次是输入该 Screen 会话的密码)

    S    屏幕水平分割
    |    屏幕垂直分割
    [tab] 在各个区块间切换，每一区块上需要再次用 Ctrl+a c 创建窗口。
    X     关闭当前焦点所在的屏幕区块,关闭的区块中的窗口并不会关闭，还可以通过窗口切换找到它。
    Q     关闭除当前区块之外其他的所有区块,关闭的区块中的窗口并不会关闭，还可以通过窗口切换找到它。

比如：当需要退出当前的 Screen 界面回到初始的shell，可以用快捷键 Ctrl+a d，即按住Ctrl按a,然后可以松手去按d，会话中的程序不会关闭，仍在运行。

关闭 Screen 会话中的窗口

    # 在 Screen 会话里的shell执行 或热键 Ctrl+a k
    $ exit

如果一个 Screen 会话中最后一个窗口被关闭了，那么整个 Screen 会话也就退出了，screen 进程会被终止。

会话共享

会话共享：Screen 可以让一个或多个用户从不同终端多次连接到同一个会话，并共享会话的所有特性（比如可以看到完全相同的输出）。它同时提供了窗口访问权限的机制，可以对窗口进行密码保护。

假设你在和朋友在不同地点以相同用户登录一台机器，然后你创建一个 Screen 会话，你朋友可以在他的终端上命令：

    $ screen -x

这个命令会将你朋友的终端 Attach 到你的 Screen 会话上，并且你的终端不会被 Detach。这样你就可以和朋友共享同一个会话了，如果你们当前又处于同一个窗口，那就相当于坐在同一个显示器前面，你的操作会同步演示给你朋友，你朋友的操作也会同步演示给你。当然，如果你们切换到这个会话的不同窗口中去，那还是可以分别进行不同的操作的。

### 进程守护工具 Supervisor

使用 python 实现的进程监控和启动管理工具，不过目前都转向用 systemd 管理进程了

    http://supervisord.org/

    https://zhuanlan.zhihu.com/p/52233518

各大发行版都支持了

    $ apt install supervisor

可以直接通过pip来安装

    $ pip install supervisor

目前所知缺陷：

    1.Supervisor 管理的进程必须由 supervisord 启动，即已启动的程序是无法使用 supervisord 进行管理的。

    2.Supervisor 要求管理的程序是非后台式的程序(not daemon program)，因为 Supervisord 会自动帮你将要管理的进程转为后台进程，如果原本就是后台进程就存在问题，比如要使用 Supervisor 管理 nginx，nginx 就需要在配置文件中添加 daemon off 让 nginx 以非后台运行形式启动。

    3.Supervisor不支持windows，只支持类UNIX系统，如Centos、Ubuntu、MacOS

一个类似的监控工具：Monit

    Monit 可以对系统状态、进程、文件、目录和设备进行监控，适用于 Linux 平台，可以自动重启已挂掉的程序，比较适合监控系统的关键进程和资源，如 nginx、apache、mysql 和 cpu 占有率等。

### 后台执行

后台执行的原理是利用 linux 命令行程序连接 tty 设备，参见章节 [Linux 的 TTY 设备]。

当我们登录服务器的时候就会产生一个会话，我们使用一些远程登录软件的时候通常会看到 session 的字样们就是表示会话。在任一时刻，会话中的其中一个进程组会成为终端的前台进程组，其他进程组会成为后台进程组。

只有前台进程组中的进程才能从控制终端中读取输入。当用户在控制终端中输入其中一个信号生成终端字符之后，该信号会被发送到前台进程组中的所有成员。这些字符包括生成 SIGINT 的中断字符（通常是 Control-C）、生成 SIGQUIT 的退出字符（通常是 Control-\）、生成 SIGSTP 的挂起字符（通常是 Control-Z）。

    程序正常结束，比如你在终端输入 ls 命令，执行完成之后他就正常结束了。

    当我们按下中断字符（ctrl + c）的时候，所有的前台进程都会收到一个 SIGINT 信号。
    当我们按下退出字符（ctrl + \）的时候，所有的前台进程都会收到一个 SIGQUIT 信号。
    当我们按下挂起字符（ctrl + Z）的时候，所有的前台进程都会收到一个 SIGTSTP 信号。

    当 shell 进程被杀掉退出的时候，内核会发送 SIGHUP 给所有的前台进程。

    当我们退出终端的时候，shell 会给所有的前台进程组发送 SIGHUP 信号，而且也会给所有的后台进程组发送 SIGHUP 信号

#### nohup

正常的程序是没有处理这个 SIGHUP 信号的，因此当我们退出终端之后所有的后台进程都会收到这个信号，然后终止执行。nohup 命令的作用就是让程序忽略 SIGHUP 这个信号，让你的程序继续在后台运行

    https://juejin.cn/post/7172811446739271694

使用时的形式如下，nohup 让 sleep 在后台继续执行，命令最后的 &，让前面的那些字符命令在后台执行

    nohup sleep 3600 &

一般情况下，后台任务不希望出现屏幕打印，需要把程序的输出和异常信息都重定向一下

    nohup [需要执行的命令] >/dev/null 2>&1 &

如果不这样把输出重定向了，nohup 命令默认会持续把后台任务的标准输出写到当前目录的 nohup.out 下面，服务器长时间运行的情况下可能造成磁盘写满。

#### 后知后觉发现一个命令要执行很久，半路让它改成后台执行

    https://www.ruanyifeng.com/blog/2016/02/linux-daemon.html

ssh 连接到服务器，后知后觉发现一个命令要执行很久，到点下班了怎么办？后悔没在 tmux 里执行好尴尬。

如果程序的输出无所谓，你只要程序能继续执行下去就好，典型的例子是你压缩一个文件或者编译一个大软件，中途发现需要花很长时间。

按下 Ctrl-z，让程序进入 suspend 挂起状态。这个时候你应该会回到 shell 下，看到提示：

    [1]+  Stopped                 xxxx

上面那个 [] 里的数字，是任务的序号，由 `bg`、`fg` 命令用到，执行：

    # 让暂时停掉的进程在后台运行
    $ bg %1

    # 如果后悔了，让暂时停掉的进程在前台运行
    $ fg %1  # 这样会把我们从shell带回到该程序的界面

执行之前，如果不放心，想确认一下，看看被 suspend 的任务列表

    $ jobs

严格地说，jobs 看的不仅仅是 suspend 的任务，所以，如果你有其他后台任务，也会列出来。

然后再解除你现在的shell跟刚才这个进程的所属关系

    $ disown

这个时候再执行 `jobs`，就看不到那个进程了，用 `ps -ef` 可以看到哦。现在就可以关掉终端，下班回家了。

实例

    # 要执行很久的命令，不等了，按下 ctrl+z 切换回 shell 的命令提示符下
    $ sleep 3600
    ^Z
    [1]+  Stopped                 sleep 3600

    # 查看当前后台任务，可以看到一个挂起的
    $ jobs
    [1]+  Stopped                 sleep 3600

    # 让后台任务继续运行
    $ bg %1
    [1]+ sleep 3600 &

    # 查看当前后台任务，可以看到之前被挂起的任务现在是正常运行了
    $ jobs
    [1]+  Running                 sleep 3600 &

    # 解除当前会话跟后台任务的归属
    $ disown

    # 当前会话没有后台任务了
    $ jobs

    # 其实那个任务还在执行，只是不归属当前会话了
    $ ps -ef | grep sleep
    501 30787 30419   0  6:00PM ttys000    0:00.00 sleep 3600
    501 33681 30419   0  6:02PM ttys000    0:00.00 grep sleep

    # 退出会话，后台任务不会再跟随关闭了
    $ exit

#### 后知后觉发现一个命令要执行很久，reptyr 通过 pid 切换进程的 tty 到 tmux

ssh 连接到服务器，后知后觉发现一个命令要执行很久，到点下班了怎么办？后悔没在 tmux 里执行好尴尬。

不需要改后台执行，把它切换到 tmux 里

    # https://github.com/nelhage/reptyr
    $ sudo apt install reptyr

在 tmux 里执行 reptyr，这样就把该进程切换到当前的 tmux 面板里执行了

    $ reptyr <pid>

然后就可以愉快的断开 ssh 关机回家了。

#### 避免后台执行

    https://www.cnblogs.com/f-ck-need-u/p/8661501.html

shell 脚本中的一个"疑难杂症"，CTRL+C 中止了脚本进程，这个脚本却还在后台不断运行，且时不时地输出点信息到终端(我这里是循环中的echo命令输出的)，只能手动 ps 列表自己找出来 kill。

这是因为 shell 脚本中有一些后台任务会直接挂靠在 init/systemd 进程下，而不会随着脚本退出而停止。

例如：

    $ cat test1.sh
    #!/bin/bash
    echo $BASHPID
    sleep 50 &

    $ ps -elf | grep slee[p]
    0 S root      10806      1  0  80   0 - 26973 hrtime 19:26 pts/1    00:00:00 sleep 50

脚本退出后，sleep进程的父进程变为了1，也就是挂在了 init/systemd 进程下。

可以在脚本中直接使用 kill 命令杀掉 sleep 进程。

    $ cat test1.sh
    #!/bin/bash
    echo $BASHPID
    sleep 50 &
    kill $!

但是，如果这个 sleep 进程是在循环中(for、while、until均可)，那就麻烦了。

例如下面的例子，直接将循环放入后台，杀掉sleep、或者exit、或者杀掉脚本自身进程、或者让脚本自动退出、甚至exec退出当前脚本shell都是无效的。

    $ cat test1.sh
    #!/bin/bash
    echo $BASHPID

    while true;do
        sleep 50
        echo 1
    done &

    $ killall sleep
    $ kill $BASHPID

究其原因，是因为 while/for/until 等是 bash 内置命令，它们的特殊性在于 bash 进程。bash 进程对能直接执行的内置命令都不会创建新进程，它们直接在当前 bash 进程内部调用执行，所以我们用 ps/top 等进程查看工具是捕捉不到 cd、let、expr 等等内置命令的。

不止 bash 内置命令，还有几个比较特殊的关键字：while、for、until、if、case 等，它们无法直接执行，需要结合其他关键字(如 do/done/then 等)才能执行。非后台情况下，bash 进程会直接带它们执行，但当它们放进后台后，它们必须先连接到一个父进程提供执行环境：

    如果是在当前 shell 中放进后台，则父进程是新生成的 bash 进程。这个新的 bash 进程只负责一件事，就是提供后台运行的 bash 环境。

    如果是在 .sh 脚本中放进后台，则父进程就是脚本进程。脚本进程也算是 bash 进程的特殊变体，也相当于一个新的 bash 进程。

    无论父进程是脚本进程还是新的 bash 进程，它们都是当前 shell 下的子 shell。如果某个子 shell 中有后台进程，当杀掉子 shell，意味着杀掉了其下运行进程的父进程。

举个例子说明下，目前 bash 进程信息为：

    [root@xuexi ~]# pstree -p | grep bash
            |-sshd(1142)-+-sshd(5396)---bash(5398)---mysql(5659)
            |            `-sshd(7006)-+-bash(7008)
            |                         `-bash(12280)-+-grep(13294)

将 for、unitl、while、case、if 等语句放进后台

    [root@xuexi ~]# if true;then sleep 10;fi &

然后再查 bash 进程信息：

    [root@xuexi ~]# pstree -p | grep bash
            |-sshd(1142)-+-sshd(5396)---bash(5398)---mysql(5659)
            |            `-sshd(7006)-+-bash(7008)---bash(13295)---sleep(13296)
            |                         `-bash(12280)-+-grep(13298)

对非内置 bash 命令来说，运行后不依赖于 bash 提供进程，而是直接挂在系统的 init/systemd 下，而 bash 内置命令会依赖其父进程，所以在杀掉 bash 进程(上面pid=7008)的时候，内置命令的父进程(pid=13295)会立即带着它下面的进程(sleep)挂在 init/systemd 下，此时该父进程和终端无关，即使你退出了当前连接，也会被系统新建一个 bash 继续运行。

解决方案

```bash

#!/bin/bash

trap "pkill -f $(basename $0);exit 1" SIGINT SIGTERM EXIT ERR

while true;do
    sleep 1
    echo "hello world!"
done &

# do something
sleep 60

```

更方便更精确的自杀手段 `man kill`。在该手册中解释了，如果 kill 的 pid 值为0，表示发送信号给当前进程组中所有进程，对 shell 脚本来说这意味着杀掉脚本中产生的所有进程。方案如下：

```bash

#!/bin/bash

trap "echo 'signal_handled:';kill 0" SIGINT SIGTERM

while true;do
    sleep 5
    echo "hello world! hello world!"
done &
sleep 60

```

### 记录命令执行的输出 script

执行

    script -a --t=your_time_log your_script_log -q

会进入新的 shell 环境，这里执行你的命令行操作，都会被记录，连 vi 操作都能记录，然后执行 exit 退出shell即可。

回放操作

    scriptreplay --timing=your_time_log your_script_log

### 现代化的查看文件列表 exa

各大发行版都有提供名为 exa 的软件包，使用时加参数才出效果

    $ exa -lhgia
    inode Permissions Size User Group Date Modified Name
    3767 drwxr-xr-x@    - uu   uu     3 Jun 04:59  .git
    110635 .rw-r--r--@   18 uu   uu     3 Jun 00:09  1.txt
    110627 .rw-r--r--@   16 uu   uu     3 Jun 00:09  a.txt

### 终端下的文件资源管理器 ranger / Midnight Commander

Terminal File Browser 很多，自己慢慢研究吧。

nnn

    https://github.com/jarun/nnn

    vi 键位操作，用方向键或 vi 的方向键在各个列表项移动，空格即选择，p 是粘贴。

ranger 使用热键操作，自动预览文本文件，还支持打开其它类型的文件，非常方便

    https://ranger.github.io/
        https://github.com/ranger/ranger

    左中右三屏：中间屏幕保持显示当前目录，左屏显示上一级的目录树，右屏显示下一级的目录列表或文件预览，用方向键或 vi 的方向键在各个窗口中移动

    操作都是在中间屏幕上的，对文本类型的文件会在右屏预览，如果回车选择该文件会自动调用对应的编辑器打开，非常方便。如果ranger不知道如何处理该文件，则会显示该文件的信息，按 q 键退出。

    操作热键

        按 ? 显示快捷键，然后根据屏幕提示按键选择即可

        按 ctl+h 切换是否显示隐藏文件

        用空格选择文件，按 y 复制它，然后导航到目标目录再按 p 粘贴

        按 delete 键删除当前被选中的文件

    这 ranger 我用它选择了几个文件复制到别处，居然复制了其它文件，按删除还没反应，不敢用了。

Midnight Commander 命令行下使用两个面板来处理文件和目录

     https://midnight-commander.org/
        https://github.com/MidnightCommander/mc
        https://sourceforge.net/projects/mcwin32/files/

    中文说明

        https://www.debian.org/doc/manuals/debian-reference/ch01.zh-cn.html#_midnight_commander_mc

    sudo apt install mc

Far Manager for Windows 类似 mc，命令行下使用两个面板来处理文件和目录

    https://conemu.github.io/en/FarManager.html

Vifm 使用 vi 快捷键的操作的文件管理器

    https://vifm.info/
        https://github.com/vifm/vifm

### 基于文本的用户界面（TUI）库 whiptail

newt 库的 whiptail 在命令行环境下，不需要桌面图形界面即可显示简单的图形界面

    https://www.redhat.com/sysadmin/use-whiptail

    https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/6.2_technical_notes/newt

显示的内容采用基于文本的用户界面（TUI）格式，并使用 Tab 键进行导航，使用空格键选择。如树莓派的 raspi-config 配置程序就是用 whiptail 实现的。

### 按内容查找文件：find + grep + xargs 组合

如果单纯的查找文件名，用 `locate` 命令最快，缺点是它每天定时更新一次数据库，最新的文件可能找不到，但特别适合查找系统的库文件的位置，比如：

    目前都符号链接指向 plocate 了，其配置文件在  /etc/updatedb.conf `man updatedb`

    # apt install plocate
    $ locate libgcc

在 $PATH 查找你的命令

    $ which -a pwd

在  $PATH 和 $MANPATH 查找匹配的文件名

    $ whereis -l pwd

列出所有文件

    $ find 目录名

    $ tree 目录名

查找指定文件

    find ./ -name 2.sql

    对当前目录下找到的所有文件，生成校验码
    find . -type f -exec sha256sum \{\} \; > checksum-file

    查找文件并打印 “文件名:内容”
    find /sys/module -name refcnt -printf '\n%p: ' -exec cat {} \;

组合执行 grep 命令查找文件内容：

    # 养成好习惯，先列出来看看，到底操作了哪些文件
    $ find ./ -name '*.mp4' -exec echo {} \;

显示内容，但是带目录了

    find ./ -name "*" -exec grep "gitee" {} \;

显示内容，排除目录

    find ./ -name "*" -type f -exec grep -in "gitee" {} \;

显示内容，显示文件名和行号，排除目录

    find ./ -name "*" -type f |xargs grep -in 'gitee'

在 jar 包中查找指定的类名，显示 jar 包名称和文件名称

    find ./ -name "*.jar" |xargs -I{} bash -c "unzip -l {} |grep LicenseUtil && echo {}"

普通的移动文件命令，不支持文件名带特殊字符

    find ./ -name '*.mp4' -exec mv {} /mnt/movies/ \;

移动指定文件，文件名可以是 'abc [def] :xyz.mp4' 这样特殊字符

    find . -type f -name "*.mp4" -print0 | xargs -0 -I {} sh -c 'mv "$1" /mnt/movies/' _ {}

xargs 命令是给其他命令传递参数的一个过滤器，常作为组合多个命令的一个工具。它主要用于将标准输入数据转换成命令行参数，xargs 能够处理管道或者标准输入并将其转换成特定命令的命令参数。也就是说 find 的结果经过 xargs 后，其实将 find 找出来的文件名逐个传递给 grep 做参数，grep 再在这些文件内容中查找关键字 test。

    ls *.txt | xargs -t -I{} cp {} /tmp/{}

        -t ： 打印内容，去掉\n之后的字符串

        -I : 定义占位符

    定义占位符{}后，命令行后面的命令可以多次使用该占位符，一般是字符串处理 awk sed cut tr wc 等

find 命令本身就提供了 -exec 选项来对找到的文件执行命令，这让人不禁疑惑为什么还要使用 xargs。实际上，-exec 在每次找到匹配的文件时都会启动一个新的进程来执行命令，而 xargs 会尽可能地将多个文件名作为参数传递给一个命令，从而减少了进程的创建。因此，在处理大量文件时，使用 xargs 会更有效率。

遍历目录中的文件逐个处理，如果文件名有空格会导致处理的命令出现问题，解决办法：

    # 这个用法最好 while read...
    find your_dir -type f |while read fname; do
        sha256sum "$fname" >>sums.txt
    done

    # 这个会把allsum.txt也带上
    find . -type f -exec sha256sum "{}" >>allsum.txt \;

    find . -name '*.txt' -exec ls -l "{}" \;

    # Don't do this
    # 下面这个用法使用命令缓冲区保存所有文件名，相当于 x=$(find . -name"*.txt")
    # 文件特别多的时候会溢出丢数
    for file in $(find . -name "*.txt")
    do
        …code using"$file"
    done

grep -n 显示要找的字符串所在的行号 -i 忽略大小写

    $ grep -in 'apt-get' README.rst
    20:     sudo apt-get install fonts-powerline

grep -w 匹配单词，用于搜索结果中类似字母组合太多的情况。

grep -e 可以多个连写，如 `grep -e abc -e def` 查找 abc 或 def 。

grep 用如下参数替代了 egrep 和 fgrep 命令

    egrep with grep -E

    fgrep with grep -F

ripgrep 替代 grep，解决了不带文件名挂住的问题，rg 会默认查找所有文件。更推荐 ack，参见章节 [ackg 给终端输出的自定义关键字加颜色]。

从当前目录及子目录列出所有目录名和文件名，排除目录 .git 和 __pycache__，逐个文件的查找文件内容包含字符串 “logg” 的行，列出文件名、行号、内容

    # 查找当前目录及子目录所有文件，列出包含指定内容的的行，如 `grepf logg`
    # find 没法加 -type f，否则没法过滤指定目录，在后面用 -d 让 grep 跳过目录即可
    find . \( -name ".git" -o -name "__pycache__" \) -prune -o -print |xargs grep --color=auto -d skip -in logg

### 字符增删改 tr cut awk sed

对常用的 . / 等分隔符的字符串进行截取。

截取字符串的前面部分

    $ dirname http://www.example.com/long/path/to/example/file.ext
    http://www.example.com/long/path/to/example

截取字符串的后面部分

    $ basename http://www.example.com/long/path/to/example/file.ext
    file.ext

指定分隔符

    $ basename -s '.gz' abc.txt.gz
    abc.txt

tr 功能1 -- 替换字符

    $ dircolors | tr ":" "\n"
    LS_COLORS='rs=0
    ln=01;36
    so=01;35
    *.tar=01;31
    *.tgz=01;31
    *.arc=01;31

tr 功能2 -- 删除字符，主要用于截取字符串

    $ echo "throttled=50.0"| tr -d "throttled="
    50.0

cut 按分隔符打印指定的字段

    $ cat /etc/passwd| cut -d ':' -f7
    /bin/bash
    /usr/sbin/nologin
    /bin/sync
    /usr/sbin/nologin

复杂点的正则表达式的字符串截取和替换，可以使用 bash 内置功能：echo ${url   }，详见 [bash 常见符号用法](shellcmd.md)。

awk 指定分隔符，可以用简单的语句组合字段

删除重复行

    # 匹配相邻的重复行
    awk '!a[$0]++' test.txt

    # 文件顺序会乱
    sort old_file | uniq > new_file

sed 删除、替换文件中的字符串

    选项与参数：

        -n ：使用安静(silent)模式。在一般 sed 的用法中，所有来自 STDIN 的数据一般都会被列出到终端上。但如果加上 -n 参数后，则只显示那些被改变的行。

        -e ：直接在命令列模式上进行 sed 的动作编辑；

        -f ：直接将 sed 的动作写在一个文件内， -f filename 则可以运行 filename 内的 sed 动作；

        -r ：sed 的动作支持的是延伸型正规表示法的语法。(默认是基础正规表示法语法)

        -i ：直接修改读取的文件内容，而不是输出到终端。

    动作说明： [n1[,n2]]function

        n1, n2 ：不见得会存在，一般代表『选择进行动作的行数』，举例来说，如果我的动作是需要在 10 到 20 行之间进行的，则『 10,20[动作行为] 』

    function：

        a ：新增， a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)～
        c ：取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
        d ：删除，因为是删除啊，所以 d 后面通常不接任何咚咚；
        i ：插入， i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)；
        p ：列印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行～
        s ：取代，可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正规表示法！例如 1,20s/old/new/g

sed 的正则表达式能玩出花来

    https://www.gnu.org/software/sed/manual/html_node/Regexp-Addresses.html#Regexp-Addresses

        https://www.gnu.org/software/sed/manual/html_node/BRE-syntax.html#BRE-syntax

        https://www.gnu.org/software/sed/manual/html_node/ERE-syntax.html#ERE-syntax

示例：

打印文件内容，跳过第一行标题行

    cat xxx.txt |sed 1d

    cat xxx.txt |sed -n '2,$p'

给所有没有#开头的行改为#开头

    # sed '/[^#]/ s/^[^#]/#&/' /etc/dhcpcd.conf
    sed 's/^[^#]/#&/' /etc/dhcpcd.conf

    在文件的匹配行前面加上#注释
    # 前面的两个斜线 // 是sed的模式匹配，可匹配文字中的空格，后面的 s// 替换操作是在前面模式匹配到的行中做
    #     s       替换
    #     ^       开头匹配
    #     [^#]    匹配非#
    #     #&      用&来原封不动引用前面匹配到的行内容，在其前面加上#号
    #     g       全部（只匹配特定行不加g）

        sed '/^static domain_name_servers=8.8.8.8/ s/^[^#].*domain_name_servers.*/#&/g' /etc/dhcpcd.conf

    在文件的匹配行前面取消#注释
    # 前面的两个斜线 // 是sed的模式匹配，可匹配文字中的空格，后面的 s// 替换操作是在前面模式匹配到的行中做
    #     s       替换，后面没有g则只做一次
    #     ^#      开头的#
    #     //      替换内容为空，即删除

        sed '/^#static domain_name_servers=192.168.1.1/ s/^#//' /etc/dhcpcd.conf

模式匹配简写，替换满足条件行的回车为逗号

    sed 'H;1h;$!d;x;y/\n/,/'

把字符串 'bt-tracker=' 后面的内容替换为变量 $TRACKER 的值

    # 正则表达式应用：括号为正则表达式的模式匹配，@是模式区和操作区的分隔符
    # \1表示第一个括号中的内容，${TRACKER}引用变量的内容
    sed -i "s@^\(bt-tracker=\).*@\1${TRACKER}@" btconfig.txt

    sed -i.bak xxx abc.txt 会备份文件到abc.txt.bak

范围删除匹配模式行，只显示删除后的结果

    sed -n '/start_line/,/end_line/!p' your_file

范围删除匹配模式行，直接修改到文件

    sed -i '/start_line/,/end_line/d' your_file

多行范围匹配替换

    sed 是按行扫描处理的，源内容按行进行处理
        https://www.itbaoku.cn/post/313727/sed-or-awk-multiline-replace
        https://www.itbaoku.cn/post/2761173.html
        https://www.itbaoku.cn/post/2760950.html

    不过其模式匹配支持范围选择：
        sed -i "/start_pattern/,/end_pattern/ s/pattern_to_replace/replacement_text/g" filename

        sed '/^why$/ {N; s/\<why\>\n\<huh\>/yo/g}' test.txt

    sed 还有N是把下一行加入到当前的hold space模式空间里，还有循环功能 --- :a和ta是配套使用，实现跳转功能。t是test测试的意思。:a和ba的配套使用方式，也可以实现跳转功能。b是branch分支的意思。

        https://blog.csdn.net/u011729865/article/details/71773840
        https://blog.csdn.net/lovebyz/article/details/89377966

        # 删除换行
        sed ":a;N;s/\n//g;ba" a.txt     # while(1) { N; s/\n//g; }

        sed ":a;N;s/\n//g;$!ba" a.txt   # $的意思是最后一行，不跳转到标记a处，即退出命令循环

        sed ":a;N;s/\n//g;ta" a.txt

    awk 'match($0, start_pattern) {start=1; next} start==1 && match($0, end_pattern) {start=0; next} start==1 {gsub(pattern_to_replace, replacement_text)} 1' filename > temp && mv temp filename

    gawk 'BEGIN{
        RS="*/"
        replace="<span style=\"color:#aaaaaa; font-weight:bold;\">"
        }
        /\/\* +TODO/{
            gsub(/\/\* +TODO/,replace" /* TODO")
            RT=RT "</span>"
        }
        { print $0RT}
        ' file

    perl -i -0 -pe '
        s/type pulse.*PulseAudio Sound Server\)/  type plug\n    slave.pcm hw/s
        ' file

### 终端输出字符的后处理工具

wc -l 计算文本文件的行数，用于 vi 打开大文件之前先评估

    wc -l README.rst

tee 对程序的输出同时打印到文件和屏幕

    ls -al | tee -a file.txt

    更高级的用法是限制 root 权限命令的使用范围，比如下载文件后把文件内容更新到系统目录的文件：

        $ curl xxx | sudo tee /etc/xxx.cfg

column 把文本表格整齐化，也用于有些程序的输出太宽字符被省略的强制展开

    openssl ciphers -V |column -t

fold 按字母拆分行

    fold -w 9

watch 对固定刷新屏幕的文本，可以高亮出变化的部分，非常适合监控

    watch -d cat /proc/interrupts

    watch -n 5 -d '/bin/free -m'

tail 持续输出文件内容，适合监视程序日志的输出

    tail -f 命令是根据文件的 inode 来追踪文件更新的。如果文件删除后再生成一个新的文件，新生成的同名文件的 inode 已经发生了变化，所以导致tail -f命令失效。

    tail -F 在文件不可以打开的时候，会重试打开该文件，也就是删除旧文件，创建新文件的过程中，tail 短暂性失去了对文件的访问权限，加上 -F 选项后，tail 在文件恢复访问后可以重新对文件实施跟踪。

#### ackg 给终端输出的自定义关键字加颜色

hhighlighter 执行时调用 h()，太容易混淆了，我给他改名 ackg 了。

hhighlighter 给终端输出的自定义字符串加颜色，支持多种颜色输出，替代 grep 给自定义字符串加颜色，非常适合监控日志输出调试程序使用

    https://github.com/paoloantinori/hhighlighter

    主要封装的是 ack --passthru 的透传和着色

        https://linux.die.net/man/1/ack
            https://beyondgrep.com/
                https://github.com/beyondgrep/ack3/

    竞品 https://github.com/Scopart/colorex/

    https://www.cnblogs.com/bamanzi/p/colorful-shell.html

需要先安装软件包 ack，非常好的 grep 的替代品，使用 perl 正则表达式的语法

    https://beyondgrep.com/

    命令使用简介 https://wangchujiang.com/linux-command/c/ack.html

    sudo apt install ack

hhighlighter 属于对 ack 的封装，但脚本名和函数名都太简单了，都换成不易混淆的 ackg 吧

    # curl -fsSLo ackg.sh https://github.com/paoloantinori/hhighlighter/raw/master/h.sh
    # sed -i 's/h()/ackg()/' ackg.sh
    # sudo mv ./ackg.sh /usr/local/bin/
    curl -fsSL https://github.com/paoloantinori/hhighlighter/raw/master/h.sh |sed 's/h()/ackg()/' |sudo tee /usr/local/bin/ackg.sh

然后测试你感兴趣的文字，支持 -i 忽略大小写，支持 perl 形式的正则表达式

    https://perldoc.perl.org/perlre
    https://www.runoob.com/perl/perl-regular-expressions.html

    https://www.cnblogs.com/dancheblog/p/3528000.html

    perl中的单引号和双引号总结： 一、双中有双，单中有单都需要转义。 二、双中有单或单中有双均不需要转义。 三、单引号直接了当，引号内是什么就显示什么，双引号则需要考虑转义或变量替换等

    # 先 source 一下就可以在 shell 下使用它导出的同名函数了
    source ackg.sh

    # 等效 echo abc | ack --flush --passthru --color --color-match=red a | ack --flush --passthru --color --color-match=yellow b
    echo "abcdefghijklmnopqrstuvxywz" |ackg a b c d e f g h i j k l

    ps -ef |ackg 'root|ssh' "$(whoami)"  '\d{2}:\d{2}:\d{2}'

    # 使用 \b 是 perl 正则表达式的单词限定符
    dmesg |ackg -i "Fail|Error|\bNot\b|\bNo\b|Invalid|Disabled|denied" "\bOk\b|Success|Good|Done|Finish|Enabled" "Warn|Timeout|\bDown\b|Unknown|Disconnect|Restart"

### 读写配置文件 jq crudini yq

> jq

jq 功能非常强大，支持更复杂的操作如映射、过滤、字符串操作等。可以通过 man jq 或 jq --help 查看完整文档。

    $ sudo apt install jq

格式化 JSON 数据，并彩色显示，如果格式错误会没有输出

    $ cat config.json |jq

常用于查看 json 输出的参数配置

    $ lsblk --json | jq -c '.blockdevices[]|[.name,.size]'

1、读取 JSON 数据

    读取整个文件
    $ jq '.' file.json

    读取特定字段
    $ jq '.key' file.json

    读取嵌套字段
    $ jq '.parent.child' file.json

    读取数组元素
    $ jq '.array[0]' file.json
    $ jq '.array[]' file.json  # 所有元素

    读取多个字段
    $ jq '{name: .name, age: .age}' file.json

    条件查询
    $ jq 'select(.age > 30)' file.json

2、修改 JSON 数据

    修改字段值 (不改变原文件)
    $ jq '.key = "new value"' file.json

    添加新字段
    $ jq '.newKey = "value"' file.json

    删除字段
    $ jq 'del(.key)' file.json

    修改数组元素
    $ jq '.array[0] = "new value"' file.json

    向数组添加元素
    $ jq '.array += ["new item"]' file.json

3、写入文件

    使用 > 重定向或 --output/-o 选项保存修改：
    $ jq '.key = "new value"' file.json > temp.json && mv temp.json file.json

    或者使用 -i/--in-place 直接修改原文件（某些版本支持）：
    $ jq -i '.key = "new value"' file.json

示例，假设有 data.json 文件内容如下：

    {
      "name": "Alice",
      "age": 30,
      "hobbies": ["reading", "hiking"],
      "address": {
        "city": "New York",
        "zip": "10001"
      }
    }

获取姓名：

    $ jq '.name' data.json
    # 输出: "Alice"

修改年龄并保存：

    $ jq '.age = 31' data.json > new_data.json

添加新字段：

    $ jq '.country = "USA"' data.json

获取所有爱好：

    $ jq '.hobbies[]' data.json
    # 输出:
    # "reading"
    # "hiking"

修改嵌套字段：

    $ jq '.address.city = "Boston"' data.json

删除字段：

    $ jq 'del(.address.zip)' data.json

> crudini 读写 ini 格式的配置文件

    语法格式：crudini [参数] 文件名

    常用参数：

        --del 删除变量
        --existing 指定文件已存在
        --format 设置输出格式
        --get 显示变量值
        --inplace 锁定并写入文件
        --list 更新一个列表的值
        --list-sep 设置自定义间隔符
        --output 将输出内容写入指定文件
        --set 增加或修改变量
        --verbose 显示执行过程详细信息

>yq (jq 的 YAML 版本)读写 YAML 的处理工具，语法类似于 jq

    # 读取值
    yq '.key.subkey' file.yaml

    # 设置值
    yq -i '.key.subkey = "new value"' file.yaml

    # 添加新字段
    yq -i '.newKey = "value"' file.yaml

### 比较文件差异 diff

比较两个文件，用 vim 结合 diff 的命令看高亮的差异对比，更加直观

    $ vimdiff file1.txt file2.txt

比较两个目录

方法一：使用 diff

    diff -r directory1 directory2

但是 diff 会对每个文件中的每一行都做比较，所以文件较多或者文件较大的时候会非常慢。请谨慎使用。

方法二：使用 diff 结合 tree

    $ diff <(tree -Ci --noreport ./tea) <(tree -Ci --noreport ./tea_hot)
    1c1
    < ./tea
    ---
    > ./tea_hot
    8d7
    < cad.sh
    14d12
    < lxhb.md
    17,19d14
    < newhot.txt
    < nljson.cpp
    < zhyc.txt

说明：

    tree 的 -C 选项是输出颜色，如果只是看一下目录的不同，可以使用该选项，但在结合其他命令使用的时候建议不要使用该选项，因为颜色也会转换为对应的编码而输出；
    -i 是不缩进，建议不要省略 -i，否则 diff 的结果很难看，也不好继续后续的文件操作；
    --noreport 是不输出报告结果，建议不要省略该选项。

该方法效率很高。

方法三：find 结合 diff

    find directory1 -printf "%P\n" | sort > file1
    find directory2 -printf "%P\n" | sort | diff file1 -
    2d1
    < 1.png
    4a4
    > 4.png
说明：

    < 代表的行是 directory1 中有而 directory2 没有的文件，
    > 则相反，是 directory2 中有而directory1中没有。

    不要省略 -printf "%P\n"，此处的%P表示find的结果中去掉前缀路径，详细内容 `man find`。

    例如，find /root/ -printf "%P\n"的结果中将显示 /root/a/xyz.txt 中去掉 /root/ 后的结果：a/xyz.txt。

效率很高，输出也简洁。

#### 文件补丁 patch

基于两个文件的差异生成补丁

    # 注意两文件顺序：源文件 根据源文件修改后的文件
    diff a.c b.c > test.diff

在其它的机器上对 a.c 文件应用补丁

    patch a.c <tes.diff

这样 a.c 的内容就变成了 b.c 的内容了。

### 写入即时文件 cat

    https://www.gnu.org/software/bash/manual/bash.html#Here-Documents

输入内容，输出到文件

    $ cat <<EOF >/my/new/file
    Line1
    Line2
    A $VARIABLE
    EOF

输入内容，完成编辑后按 Ctrl+D 结束，输出到文件

    cat > file

有几个限制：

    cat 生成一段代码到文件，文本当中的符号 $、\ 和 ` 也会被解析，需要前缀 \ 进行转义才能保持原样。

    如果同一个内容中有多处 EOF 会混乱，所以每段 cat 用不同的 EOFX 来做结束标志。

    EOFA 必须顶行写，前面不能有制表符或者空格，结束输入对应前面的 EOFA 或按 ctrl+d。

在我们使用 `cat <<EOF` 时，下面的文本内容必须顶行写，前面不能有制表符或者空格。

```bash

cat <<EOFA >/etc/network/if-pre-up.d/restore_my_iptables_rule
#!/bin/sh
iptables -F
iptables-restore < /etc/iptables/rules.v4
EOFA

```

如果重定向的操作符是<<-，那么分界符（EOF）所在行的开头部分的制表符（Tab）都将被去除。这可以解决由于脚本中的自然缩进产生的制表符。

    https://askubuntu.com/questions/858238/eof-in-cat-and-less

```bash

if [ -e ~/.bash_profile ]; then
    cat <<-EOF >abc.txt
        ABC
        DEF
        G
        EOF
fi

```

在某文件的基础上追加内容，写入的新文件直接重定向作为 xxx 命令的参数内容

    $ xxx -config <(cat /etc/ssl/openssl.cnf - <<- EOF
    [notice]
    explicitText = "UTF8:Notice An use of this Certificate "
    EOF
    )

ssh写入远程主机文件

```bash
cat <<EOF | ssh user@host "cat > /home/user/${HOSTNAME%%.*}_said.txt"
# hi
there.
EOF

```

在远程主机输入文件内容 `cat >config.php <<EOF`，可以直接粘贴内容，但是

    1、cat 会转义特殊符号，得提前编辑要粘贴的内容，防止粘贴内容不一致

        注意有 3 个特殊符号必须前缀 \ 转义： $ ` \

        也就是说，原文是 $abc 的要改为 \$abc，不然那个 $ 会被 cat 命令吃掉

    2、然后才可以在远程主机执行粘贴操作

        $ cat > config.php << EOF

        粘贴你修改的内容

        EOF

如果要粘贴的内容没有单引号，可以用 `echo 'xxx' |tee` 的形式，用单引号包围的内容，可以不被转义，如：

以下内容，直接复制

```bash
#comment line
print \no "aaaaaaa" \number $HOSTNAME
exec `man pwd`
```

在远程主机执行粘贴操作

    $ echo '粘贴你的内容
    多行也没关系
    ' |tee your_bash

### 写入文件 dd

dd 命令是基于块（block）的复制，“裸读写”（越过文件系统直接读写物理设备）用途很多，比如备份/恢复硬盘主引导扇区，克隆硬盘或分区。

    https://wiki.archlinux.org/title/Dd

从裸设备读取，或写入到裸设备，只能用 dd，比如克隆硬盘、从镜像文件制作 U 盘、特定数据写入硬盘分区表 /dev/sdX 或 /dev/sdxx。

大多数从文件读取或写入到文件的场景，用 dd 过时了

        https://www.vidarholen.net/contents/blog/?p=479

    从文件读取或写入到文件的场景，用命令 `cat` 或 `cp` 就足够了，除非该设备不支持 one-byte write。

    如果要限制字节数，组合 `head -c` 处理即可，除了指明必须用 dd 按块大小写入等场合，尽量避免用 dd。

        https://unix.stackexchange.com/questions/224277/is-it-better-to-use-cat-dd-pv-or-another-procedure-to-copy-a-cd-dvd/224314#224314

dd 常用选项

    bs=比特数   一次读取和写入都使用该数值，覆盖 ibs/obs 参数的设置。克隆硬盘等大范围读写本地硬盘的场景下调大可以提速，比如设置为 4M 匹配物理硬盘的物理扇区尺寸 4096 的整数倍，如果是固态硬盘物理扇区是 512，可以设置成 10G。详见下面章节 [大范围写入使用最佳块大小]。

    conv=fsync 写入时提速，类似利用缓存，不是每个写操作都写文件系统数据，而是在 dd 执行完成之前再写入

输入：

    ibs=比特数                            一次读取的比特数(默认：512)

    skip=块数                             跳过第零个扇区，从第一个扇区开始读取

    iflag=flag                           使用iflag来控制输入(读取数据)时的行为特征。

        dsync       读写数据采用同步IO

        fullblock   见子章节 [只要指定了 count 就必须用 iflag=fullblock]

输出：

    obs=比特数                            一次写入指定比特数(默认：512)

    seek=1                              跳过第零个扇区，从第一个扇区开始写入

    bs=512                              写入块大小为512字节（一般使用一个扇区的大小，用 sudo gdisk -l 查看）

    count=1                             写入多少个块，这里只写入一个块

    oflag=flag                          使用oflag来控制输出(写入数据)时的行为特征。

设备级互拷：将本地的 /dev/hdb 整盘备份到 /dev/hdd

    # 这种场景没法用 `cp /dev/sda /dev/sdb` 或 `cat /dev/sda >/dev/sdb`
    $ sudo dd if=/dev/hdb of=/dev/hdd

    克隆硬盘的操作，详见章节 [使用 dd 克隆硬盘](init_a_server think)。

设备到文件：将 /dev/hdb 全盘数据备份到指定路径的 image 文件

    # 这种场景没法用 `cat /dev/hdb >/root/image`
    $ sudo dd if=/dev/hdb of=/root/image

    # 备份的同时压缩
    # 这种场景没法用 `cat /dev/hdb |gzip >/root/image.gz`
    $ sudo dd if=/dev/hdb |gzip >/root/image.gz

    # 拷贝内存到磁盘上的文件
    # 这种场景没法用 `cat /dev/mem >/root/mem.bin`
    $ sudo dd if=/dev/mem of=/root/mem.bin bs=1024

    # 拷贝光盘内容到指定文件夹，并保存为 cd.iso 文件
    # 这种场景没法用 `cat /dev/cdrom(hdc) >/root/cd.iso`
    $ sudo dd if=/dev/cdrom(hdc) of=/root/cd.iso

文件到设备：将备份文件恢复到指定盘

    # 这种场景没法用 `cat /root/image >/dev/hdb`
    $ sudo dd if=/root/image of=/dev/hdb

    # 解压并恢复备份文件到指定盘
    # 这种场景没法用 `gzip -dc /root/image.gz >/dev/hdb`
    $ gzip -dc /root/image.gz |sudo dd of=/dev/hdb

备份与恢复 MBR：利用 dd 时顺序读写的特点，从磁盘设备的开头开始，恰好就是启动扇区

    # 备份磁盘开始的 512 个字节大小的 MBR 信息到指定文件
    # 这种场景没法用 `head -c 512 /dev/hda >/root/boot.image`
    $ sudo dd if=/dev/hda of=/root/image bs=512 count=1 iflag=fullblock

    # 用 boot.img 制作启动盘
    # 这种场景没法用 `cat boot.img >/dev/fd0`
    $ sudo dd if=boot.img of=/dev/fd0 bs=1440k

    恢复：

    # 将上面备份的MBR信息写到磁盘开始部分
    # 这种场景没法用 `cat /root/image >/dev/had`
    $ sudo dd if=/root/image of=/dev/had

    备份软盘
    # 这种场景没法用 `head -c 1440K /dev/fd0 >disk.img`
    $ sudo dd if=/dev/fd0 of=disk.img bs=1440k count=1 iflag=fullblock

读取挂载在存储设备上的 iso 文件，进行 gpg 校验

    # 注意使用了管道操作默认的标准输入和标准输出，gpg 最后用的 -
    # 这种场景没法用 `cat /dev/sdb`
    $ sudo dd if=/dev/sdb |gpg --keyid-format 0xlong --verify my_signature.sig -

#### dd 命令查看进度

只有 gnu 版的 dd 命令可以使用参数 status=progress 显示进度。普通版本的 `dd` 命令没有信息输出，只有最终结束时才显示出时间、拷贝速度。

解决办法：dd 支持发信号的方式输出进度信息。

为了查看 `dd` 的进度，可以在另一个终端执行如下命令

    # killall 加参数是发送一个指定的信号到指定的进程
    $ sudo watch -n 5 killall -USR1 dd

不要关闭该终端窗口。

之后，就能在执行 `dd` 的终端看到进度数据的输出了

    1473905+0 records  in
    1473905+0 records out
    6037114880 bytes (6.0 GB, 5.6 GiB) copied, 28.8377 s, 209 MB/s
    ...
    976754646+0 records in
    976754646+0 records out
    4000787030016 bytes (4.0 TB, 3.6 TiB) copied, 26870.7 s, 149 MB/s

另一个方法是在命令中调用管道查看器 pv，然后把 pv 命令和 dd 命令结合在一起：

    $ sudo apt install pv

    $ sudo dd if=/dev/sdb |pv |of=/dev/sda
    4,14MB 0:00:05 [ 98kB/s] ==>

经验证，秒退，暂未研究哪里错了。

#### 大范围写入磁盘使用最佳块大小

适用于克隆硬盘、克隆分区，拷贝大文件等顺序读写的场景，用参数 bs 设置读写块大小

    https://wiki.archlinux.org/title/Dd#Disk_cloning_and_restore

大文件读写尽可能提速，测试推荐的最优选择如下：

    普通的 7200转 硬盘 on btrfs：bs=4M

    固态硬盘 Sumsung 960 pro on btrfs: bs=512K，不用缓存(oflag=sync)：bs=1G

    简单点，不管啥硬盘都用 bs=4M，这样的参数下固态硬盘的速度也不慢

参数 bs 最少要设置为硬盘的一个物理扇区大小的整数倍:

    查看硬盘的物理扇区尺寸

    $ sudo fdisk -l /dev/sda | grep "Sector size"
    Sector size (logical/physical): 512 bytes / 4096 bytes

    $ sudo fdisk -l /dev/sdb | grep "Sector size"
    Sector size (logical/physical): 512 bytes / 4096 bytes

一般来说，普通硬盘扇区的物理大小是 4096 bytes，固态硬盘是 512 bytes。在两个硬盘对拷的时候，因为磁盘完全是顺序读写，你不会听到任何磁头来回移动炒豆子的声音，两个硬盘会非常安静的全速读写数据。如果两个硬盘的物理扇区大小不一致，则用参数 ibs 和 obs 分别指定。

如果硬盘的传输速度不一样，会按照低的那个速度传

    7200 转服务器级别的 SATA 硬盘如西数HC320/希捷银河 7E10 的传输速度约 220MB/s，大约就是 2.5G 网口的速度

    5400 转家用 NAS 盘传输速度 160MB/s，待机听不到电机声音

> 测试固态硬盘最优 bs 参数

逐个运行以下语句，看输出结果，有速率信息

    $ sudo su

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches  # 执行前要清理缓存
    # dd if=/dev/zero bs=512 count=8388608 of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 24.3043 s, 177 MB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=1024 count=4194304 of=./4GB.big status=progress
    2015528960 bytes (2.0 GB, 1.9 GiB) copied, 6 s, 336 MB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=4096 count=1048576  of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 3.27255 s, 1.3 GB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=16k count=262144  of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 1.99471 s, 2.2 GB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=32k count=131072  of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 1.46653 s, 2.9 GB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=64K  count=65536  of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 1.33339 s, 3.2 GB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=128K  count=32768  of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 1.27792 s, 3.4 GB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=256K  count=16384  of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 1.23632 s, 3.5 GB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=512K count=8192 of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 1.22599 s, 3.5 GB/s
    加上 oflag=sync：156 MB/s

    固态硬盘物理扇区大小 512 bytes，用缓存的的峰值就选 512k 吧，这样好记

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=1M  count=4096  of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 1.28943 s, 3.3 GB/s
    加上 oflag=sync：283 MB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=4M  count=1024  of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 1.48231 s, 2.9 GB/s
    加上 oflag=sync：721 MB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=16M  count=256  of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 1.61058 s, 2.7 GB/s
    加上 oflag=sync：1.3 GB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=512M  count=8  of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 1.81945 s, 2.4 GB/s
    加上 oflag=sync：1.6 GB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=1G  count=4  of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 1.81385 s, 2.4 GB/s
    加上 oflag=sync：1.7 GB/s

    固态硬盘物无缓存的的峰值就选 1G，这样好记

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=2G  count=2  of=./4GB.big status=progress
    dd: warning: partial read (2147479552 bytes); suggest iflag=fullblock
    0+2 records in
    0+2 records out
    4294959104 bytes (4.3 GB, 4.0 GiB) copied, 1.97324 s, 2.2 GB/s
    加上 oflag=sync：1.5 GB/s

    到这里操作系统提供 /dev/zero 的速度跟不上固态硬盘了，开始提示数据丢失了。根据章节 [给random()增加熵，提升系统加密的速度](init_a_server think) 里的测试，我的 /dev/zero 生成速度在 2.7 GB/s。

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=4G  count=3  of=./12GB.big status=progress
    2147479552 bytes (2.1 GB, 2.0 GiB) copied, 1 s, 1.9 GB/s
    dd: warning: partial read (2147479552 bytes); suggest iflag=fullblock
    4294959104 bytes (4.3 GB, 4.0 GiB) copied, 2 s, 2.1 GB/s
    0+3 records in
    0+3 records out
    6442438656 bytes (6.4 GB, 6.0 GiB) copied, 2.93817 s, 2.2 GB/s
    加上 oflag=sync：1.6 GB/s

    # rm -f 12GB.big

> 测试普通硬盘最优 bs 参数

    $ sudo su

用 dd 从 /dev/zero 写入 4TB 文件是瞬间完成的，关闭硬盘的缓存都不管用

    # hdparm -W /dev/sda

    /dev/sda:
    write-caching =  1 (on)

    # hdparm -W 0 /dev/sda

    /dev/sda:
    setting drive write-caching to 0 (off)
    write-caching =  0 (off)

没办法，在我的固态硬盘上生成一个 4GB 的文件，内容用随机数填充，让你没法优化

    # cd /root/tmp
    # dd if=/dev/urandom bs=512K  count=8192  of=./4GB.big status=progress

测试用 dd 从固态硬盘拷贝该文件到普通硬盘，还是秒完成，看来不是这个原因。

只能添加 oflag=sync 选项进行测试了，逐个运行以下语句，看输出结果，有速率信息

    # cd /mnt/common1

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=512k count=8192 oflag=sync of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 44.9049 s, 95.6 MB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=1M count=4096 oflag=sync of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 29.415 s, 146 MB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=4M count=1024 oflag=sync of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 22.5178 s, 191 MB/s

    普通硬盘物理扇区大小 4096 bytes，无缓冲写入的峰值就选 4M 吧，这样好记

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=8M count=512 oflag=sync of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 21.719 s, 198 MB/s

    # rm -f 4GB.big
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=/dev/zero bs=16M count=256 oflag=sync of=./4GB.big status=progress
    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 25.5028 s, 168 MB/s

> hdparm 可用于测试磁盘和磁盘缓存读取速度

查看磁盘信息：

    fdisk -l /dev/sdX

    hdparm /dev/sdX

评估磁盘读取速度：

    hdparm -t /dev/sdX

评估磁盘缓存读取速度：

    hdparm -T /dev/sdX

直接测试硬盘的读性能(绕过内核页缓存)：

    hdparm -tT --direct /dev/sdX

顺序写测试：

    time -p  bash -c "dd if=/dev/urandom of=./dd.log bs=1M count=50000"

随机写测试(使用direct标识，绕过页缓存)：

    fio -filename=randw-singlethread -fallocate=none -direct=1 -iodepth 1 -thread -rw=randwrite -ioengine=libaio -bs=32k -size=1000M -runtime=30s -numjobs=1 -name=hdparm-randwsinglethread

#### Partial read:只要指定了 count 就必须用 iflag=fullblock

    https://wiki.archlinux.org/title/Dd#Partial_read:_copied_data_is_smaller_than_requested

        https://unix.stackexchange.com/questions/556016/cat-dd-pipe-causes-partial-reads-without-iflag-fullblock-why-truncated-to-128

        https://unix.stackexchange.com/questions/12532/dd-vs-cat-is-dd-still-relevant-these-days/12538#12538

        https://unix.stackexchange.com/questions/17295/when-is-dd-suitable-for-copying-data-or-when-are-read-and-write-partial

NOTE: dd 的块式读写有个毛病，系统调用函数 read() 在管道操作后会静默的跳过某些字节数，特别是输入数据的缓冲不足的情况下，会不等数据直接写入数据块。最常见的场景是用 dd 接收来自管道的数据，或者使用系统设备 /dev/random 而系统的熵不足的时候，所以只要指定了 count，那就必须用 iflag=fullblock 确保数据够了再写入

    dd 丢数据，看看你的文件字节数是不是 10M
    $ yes |dd of=dd_miss.txt bs=1024k count=10

    $ yes |head -c 10M >head_ok1.txt
    $ head -c 10M /dev/zero >head_ok2.txt

所以必须添加 iflag=fullblock

    $ yes |dd of=dd_ok.txt bs=1024k count=10 iflag=fullblock

实在不想加，就绕一层

    $ LC_ALL=C tr -dc '[:alnum:]' </dev/urandom | dd of=passtext-5m.txt bs=4k count=1280

如果添加 `iflag=fullblock` 选项后部分I/O块计数仍大于1，这意味着部分I/O发生了多次

    $ yes 'x' | dd bs=4096 count=512400B | dd ibs=1 count=512200 status=none >/dev/null
    125+1 records in  <---- 加号表示发生部分 IO 的块的个数
    125+1 records out
    512400 bytes (512 kB, 500 KiB) copied, 10.7137 s, 47.8 kB/s

这种错误多发于网络连接不良，或读取光盘等场景，应该使用 `ddrescue` 多次重复读取，参见章节 [使用 dd_rescue 克隆故障硬盘](think)。

### 快速清理文件和快速建立文件

指定大小，用全零填充，速度慢

    # 换成 /dev/urandom 随机值填充，速度更慢
    # dd if=/dev/zero of=fs.img bs=1M count=1M seek=1024
    $ head -c 1024M /dev/zero >fs.img

指定大小，用 truncate 命令更快，文件是空的，瞬间建成

    $ truncate --size 10G test.db.bak

    预创建块文件，有个更快的命令

        $ fallocate -l 10G test_file2.img

快速清理文件

    # truncate -s 0 /var/log/yum.log
    # echo '' >your_big.log
    > your_big.log

删除大量文件

    删除数量巨大的文件， rm * 报错，用 find 命令遍历目录挨个传参数的办法删除，虽然慢但是能做，注意用后台命令，不然挂好久

        $ find /tmp -type f -exec rm {} \; &

        $ find /home -type f -size 0 -exec rm {} \;

    最快方法

        https://web.archive.org/web/20130929001850/

        http://linuxnote.net/jianingy/en/linux/a-fast-way-to-remove-huge-number-of-files.html

        $ mkdir empty && rsync -r --delete empty/ some-dir && rmdir some-dir

### 压缩解压缩 tar gz bz2 tbz lzo

    tar [选项] [选项参数] [生成文件名] [源文件1 源文件2 ...]

tar 命令的选项及参数有几种写法，注意区别

    传统写法：没有 -，多个单字母选项合起来写在第一个选项位

        tar vcf a.tar /tmp

    UNIX 写法：用 -选项1 选项1自己的参数 -选项2 选项2自己的参数

        tar -f a.tar -c -v /tmp

        # 没有参数的选项可以合写
        tar -f a.tar -vc /tmp

            # 选项 f 也可以合写，但是要放在最后，以便后面紧跟自己的参数，然后才是整个命令的参数
            tar -vcf a.tar /tmp

            # 这种写法常见，如 def.sh 是 o 的参数，连写了，就要紧跟
            curl -fsSLo def.sh https://github.com/.../abc.sh

    GUN 写法：用 -- 或 -，连写用一个 -

        # --选项 后面紧跟空格参数
        tar --verbose --create --file a.tar /tmp

        # -- 也可以用单字母选项连写，但是要保证没有歧义
        # -- 选项用=连接参数，中间没有空格。可选参数必须始终使用这种方法
        tar --verb --cre --file=a.tar /tmp

tar 最初只是个打包工具，把给定的文件和目录统一打包生成 .tar 文件。

    # 只打包，生成 .tar 文件，加参数 v 显示明细

    tar cf myarch.tar dir1 dir2 file2.txt

        # 解包
        tar xf myarch.tar

大文件打包后，应该做个事后校验，如果目录或子目录的文件有变化，都会提示

    $ tar df arc.tar.gz
    dir1/file1: Mod time differs
    dir1/file1: Contents differ
    file2: Mod time differs
    file2: Contents differ

但是我们最常用的是打包然后再压缩，所以 tar 扩展支持 .gz 和 .bz2(.tbz)，实质是调用现有的 gzip 程序把自己打包好的文件再压缩，但是节省了用户在命令行的输入。

最常用的 .tar.gz 文件

    # 用 c 打包并 z 压缩，v 是显示明细，生成 .tar.gz 文件，源可以是多个文件或目录名
    tar vczf arc.tar.gz file1 file2

    # 把 z 换成 j 就是压缩为 .bz2(.tbz) 文件，而不是 .gz 文件了
    tar vcjf arc.tar.bz2 file1 file2

    # 解包并解压缩
    # 把 x 换成 t 就是只查看文件列表而不真正解压
    tar vxzf arc.tar.gz
    tar vxjf xx.tar.bz2

tar 支持管道操作，在命令参数中文件名的位置使用 bash 的特殊符号 -（减号），代表标准输出/标准输入。
下面的例子中不少示例，酌情参考。

    # 把 /home 目录打包，输出到标准输入流，管道后面的命令是从标准输出流读取数据解包
    tar cf - /home |tar -xf -

    # curl 下载默认输出是标准输入流，管道后面的命令是 tar 从标准输出流读取数据解压到指定的目录下
    curl -fsSL https://go.dev/dl/go1.19.5.linux-armv6l.tar.gz |sudo tar -C /usr/local -xzf -

    # 打包并 gpg 加密
    tar cjf - dir1 dir2 file2 node.exe |gpg --output backup.tar.bz2.gpg --cipher-algo AES-256 -c -

        # 解密并解包
        # dd if=backup.tar.bz2.gpg |gpg -d - |tar xjf -
        gpg -d backup.tar.bz2.gpg |tar xjf -

    # 打包并 openssl 加密
    # 将当前目录下的 files 文件夹打包压缩，提示输入密码
    tar czf - files |openssl enc -aes-256-cbc -pbkdf2 -out files.tar.gz.bin

        # 解密并解包
        # 将当前目录下的files.tar.gz进行解密解压拆包
        openssl enc -aes-256-cbc -pbkdf2 -d -in files.tar.gz.bin |tar xzf -

    # 不覆盖文件，提取文件权限信息
    tar -vkpf a.tar /tmp

    # 把本地目录打包并直接用 ssh 传送远程服务器，注意这种用法无校验只适合于内网环境
    tar --create --directory /home/josevnz/tmp/ --file - *| \
        ssh raspberrypi "tar --directory /home/josevnz \
        --verbose --list --file -"

.gz 文件

    # 压缩，生成同名文件，后缀.gz，原文件默认删除，除非使用 -k 参数保留
    gzip FileName

    # 列出指定文件列表并压缩
    ls |grep -v GNUmakefile |xargs gzip

    # 解压缩
    # gunzip FileName.gz
    gzip -d FileName.gz

    # 查看内容
    zcat usermod.8.gz

.zip 文件

    # 压缩文件，生成新文件，并添加 .zip 后缀的文件
    zip arc file1.txt file2.txt ...

    # 打包压缩目录
    zip -r arc.zip foo1/ foo2/

    # 解压缩zip
    unzip arc.zip -d your_unzip_dir

    # 查找匹配的 c 语言文件并打包压缩
    find . -name "*.[ch]" -print | zip source_code -@

    # 把当前目录打包到tar，用 zip 压缩
    tar cf - . | zip backup -

    # 只查看文件列表
    unzip -l arc.zip

    # 分卷压缩，把目录 win_font 打包为 wf.zip, wf.z01, wf.z01,... 的 10mb大小的包
    $ zip -r -s 10m wf.zip win_font/

        # 解压分卷文件，需要先合并出一个大zip文件
        $ zip -F wf.zip --out win_font.zip
        $ unzip win_font.zip

        Windows 下的 7zip 分卷压缩后是 wf.zip.001, wf.zip.002,...的包
        # 解压分卷文件，也是需要先拼合再解压，但不需要专门的命令，直接拼接写文件即可
        $ cat wf.zip.* >wf.zip
        $ unzip wf.zip

对压缩过的文件进行查看等操作，使用 zless、zmore、zcat 和 zgrep 等。

.xz 文件

    # 把 foo.tar.xz 解压缩为 foo.tar
    xz -d foo.tar.xz

    # 把文件 foo 压缩为 foo.xz
    xz foo

    # 并行压缩 `man xz`
    find . -type f \! -name '*.xz' -print0 \
        | xargs -0r -P4 -n16 xz -T1

    # 占用最小内存的压缩用法
    xz --check=crc32 --lzma2=preset=6e,dict=64KiB foo

.rar 文件

    # 解压缩开源程序各大发行版都有
    $ unrar x your.rar

    # 压缩不是开源的
    $ rar a your_dir_file

.lzo 文件压缩，解压

    $ sudo apt install lzop

    lzop命令基本操作命令

    $ lzop -v test # 创建test.lzo压缩文件，输出详细信息，保留test文件不变

    $ lzop -Uv test # 创建test.lzo压缩文件，输出详细信息，删除test文件

    $ lzop -t test.lzo # 测试test.lzo压缩文件的完整性

    $ lzop –info test.lzo # 列出test.lzo中各个文件的文件头

    $ lzop -l test.lzo # 列出test.lzo中各个文件的压缩信息

    $ lzop –ls test.lzo # 列出test.lzo文件的内容，同ls -l功能

    $ cat test | lzop > t.lzo # 压缩标准输入并定向到标准输出

    $ lzop -dv test.lzo # 解压test.lzo得到test文件，输出详细信息，保留test.lzo不变

### 文件链接 ln

ln 命令默认生成硬链接，但是我们通常使用软连接

    # 主要是给出链接的目标文件，可以多个，最后的是保存软链接的文件目录
    # 如果省略最后的目录，默认就是当前目录保存，软连接文件名默认跟目标文件同名
    # 如果最后的目录给出的是一个文件名，则就是在当前目录下建立软链接文件
    ln -s /tmp/cmd_1 /tmp/cmd_2 /usr/bin/

### 计算器 bc

Linux bash shell 中使用双括号即可简单的进行整数计算

    $ ADD=$(( 1 + 2 ))
    $ echo $ADD
    3

    $ MUL=$(( $ADD * 5 ))
    $ echo $MUL
    15

使用 expr 命令，也是进行简单的整数计算

    $ expr 3 + 5

    $ expr 5 – 3

    $ expr 5 * 3

    $ expr 20 / 4

    $ expr 15 % 4  这个是取余数
    3

expr 还支持比较操作，当表达式求值为 false 时，expr 将打印值0，否则打印1。

    $ expr 5 = 3
    0

    $ expr 5 = 5
    1

    $ expr 8 != 5

    $ expr 8 > 5

    $ expr 8 < 5

    $ expr 8 <= 5

支持浮点运算的计算器 bc - An arbitrary precision calculator language

    # sudo apt install bc
    $ echo '1 / 6' |bc -l
    .16666666666666666666

可以直接传算式给 bc

    $ echo '3+5' | bc

    $ echo '15 % 2' | bc

    $ echo '15 / 2' | bc

    $ echo '(6 * 2) - 5' | bc

还可以用 awk

    $ awk 'BEGIN { a = 6; b = 3; print "(a + b) = ", (a + b) }'
    (a + b) =  9

### 生成二维码 qrencode

需要安装软件包 qrencode。

生成二维码到终端模拟器

    $ echo abcd1234 | qrencode -t ANSIUTF8

    $ qrencode -t ANSIUTF8 < your_config.cfg

`-t ANSIUTF8` 表示生成的类型是文本字符画，这样在任何终端或文本编辑器里都可以正常显示。

添加 -o 生成到文件

    $ qrencode -t ansiutf8 -o kk.txt < your_config.cfg

### 文件完整性校验 sha256sum

Linux 下，每个算法都是单独的程序：cksum md5sum sha1sum sha256sum sha512sum

直接传递文件名操作即可

生成

    # 生成 crc 校验和以及字节数
    $ cksum test.json
    1758862648 4855 test.json

    # 生成 sha256 校验文件
    $ sha256sum file > file.sha256

    # 生成多个文件的sha256校验
    $ sha256sum a.txt b.txt > checksums.sha256
    $ more checksums.sha256
    17e682f060b5f8e47ea04c5c4855908b0a5ad612022260fe50e11ecb0cc0ab76  a.txt
    3cf9a1a81f6bdeaf08a343c1e1c73e89cf44c06ac2427a892382cae825e7c9c1  b.txt

    # 生成 BSD-style 的校验
    $ sha256sum --tag colortest.sh  bing.jpg
    SHA256 (colortest.sh) = b855d0ce40d7b578c41c2f199692570e627fb4501b3098de0c8e507f133c08c0
    SHA256 (bing.jpg) = 90f9a057885b0d72ecca5d6708ca3e9c69419eb6dd46bc5071a4e17e31ed6178

    对当前目录下找到的所有文件，生成校验码
    find . -type f -exec sha256sum \{\} \; >SHA256SUMS.txt

校验

    # 根据校验和文件进行校验
    $ sha256sum -c checksums.sha256
    a.txt: OK
    b.txt: OK

    # 只下载了一个文件，从校验和文件中抽出单个文件进行校验
    $ sha256sum -c <(grep ubuntu-20.04.4-desktop-amd64.iso SHA256SUMS.txt)
    # 或
    $ sha256sum --ignore-missing -c SHA256SUMS.txt

使用 OpenSSL 验证

    # 主要用于数据摘要，可指定各种算法查看 openssl dgst -list
    $ openssl dgst -sha256 Release.unsigned
    SHA256(Release.unsigned)= f6edd059408744b50edc911111111113eeef30dc5fea0

    # 跟校验和文件比对数值
    $ grep f6edd059408744b50edc911111111113eeef30dc5fea0 *dgst
    SHA256= f6edd059408744b50edc911111111113eeef30dc5fea0

Windows 自带工具，支持校验MD5 SHA1 SHA256类型文件，cmd调出命令行

    certutil -hashfile  <文件名>  <hash类型>

如

    certutil -hashfile cn_windows_7.iso MD5
    certutil -hashfile cn_windows_7.iso SHA1
    certutil -hashfile cn_windows_7.iso SHA256

### 字符串免转义就用 base64

    Base32 编码每任意八位字节序列，生成全大写字母

    Base64 编码每任意八位字节序列，生成区分大写字母和小写字母

对脚本文件、复杂的正则表达式、含特殊字符的字符串等，先用 base32/base64 编码后再传递参数，使你的脚本更简洁

    $ echo "${variable}" | base64 -w 0

### 生成随机数做密码

在 Linux 中，有两类用于生成随机数的设备，分别是 /dev/random 以及 /dev/urandom ，其中前者可能会导致阻塞，而读取 /dev/urandom 不会堵塞，不过此时 urandom 的随机性弱于 random。 urandom 是 unblocked random 的简称，会重用内部池中的数据以产生伪随机数据，可用于非密钥数据的生成。

    https://huataihuang.gitbooks.io/cloud-atlas/content/os/linux/device/random_number_generator.html

在 Linux 中生成强密码的不同方法有很多

    https://ostechnix.com/4-easy-ways-to-generate-a-strong-password-in-linux/

    # 生成16个字符的强密码
    $ cat /dev/random |tr -dc '!@#$%^&*()-+=0-9a-zA-Z' | head -c16
    etGemrXR*sq=Yf&7

    # 对随机数只取字符和数字，取前12个
    # 等效 cat /dev/random |tr -dc 'a-zA-Z0-9' |head -c 12
    # 等效 cat /dev/random |tr -cd 'a-zA-Z0-9' |fold -w 12 |head -n 1
    $ cat /dev/random |tr -cd '[:alnum:]' |head -c 12
    wS481zVrIjXH

    以上生成的密码过短，强度未必够，多运行几次，挑一个大小写和数字都有的最杂乱的使用即可。
    如果换成 /dev/urandom 特别明显，所以短密码还是尽量用 /dev/random 生成

    ######################################################################
    # 生成 32 字节的随机数据作为密钥文件
    # dd if=/dev/random bs=1 count=32
    $ head -c 32 /dev/random >symmetric_keyfile.key

    # 生成随机数据，过滤掉回车字符，只取 64 字节作为密钥文件
    $ cat /dev/random |tr -d '\n' |head -c 64 >symmetric_keyfile.key

    # 生成 256 字节的随机数据作为密钥文件
    $ openssl rand 256 >symmetric_keyfile.key

    ######################################################################
    # 对随机数取哈希，用 cksum 取 crc 校验和，还可以用 sha256sum、md5sum 等
    $ head /dev/random |cksum
    3768469767 1971

    # 对随机数转化为16进制2字节一组，取第一行
    $ cat /dev/random |od  -An -x |head -n 1
    0637 34d5 16f5 f393 250e a2eb aac0 27c3

    # 对随机数使用 base64 编码，取第一行，76个字符
    $ cat /dev/random |base64 |head -n 1
    79lGC+/glAJl7u84xJSY3ukXtPmr9pJGssocTebvC7B2z5ObA/eSJ9ws9Ur8gDSsnpcdy7v7r2RS

    # 22个 ascii 字符，注意这里的后面两个是base64的3字节规范填充了等号
    $ gpg --armor --gen-random 2 16
    1uR4Fpo/oTxez0C+ljapaA==

    # 16 进制编码的 40 个字符
    $ openssl rand -hex 20
    f231202787c01502287c420a8a05e960ec8f5129

    # 使用 base64 编码，注意确保字节数可被 3 整除以避免填充
    # 如果字节参数 9，则 base64 编码生成 12 个字符
    $ openssl rand -base64 9
    BhE3zmV1ki6D

    # 生成一个 uuid，这个也是随机的
    $ cat /proc/sys/kernel/random/uuid
    6ab4ef55-2501-4ace-b069-139855bea8dc

    # 这个 shuf 不知道是否伪随机
    # 把数字 5-12 直接乱序排序，每行一个数字，输出1行
    $ shuf -i5-12 -n1
    9

使用 cracklib 软件包检查口令的复杂度

    $ echo 123654 |cracklib-check
    123654: it is too simplistic/systematic

    $ echo 4aoqemo |cracklib-check
    4aoqemo: OK

使用 apg 软件包生成可发音的单词组合口令

    $ apg -l
    liwimthoa lima-india-whiskey-india-mike-tango-hotel-oscar-alfa
    NadCuenUc November-alfa-delta-Charlie-uniform-echo-november-Uniform-charlie
    clojyufdyt charlie-lima-oscar-juliett-yankee-uniform-foxtrot-delta-yankee-tango
    ReutDybIj Romeo-echo-uniform-tango-Delta-yankee-bravo-India-juliett
    OkAufwudAp Oscar-kilo-Alfa-uniform-foxtrot-whiskey-uniform-delta-Alfa-papa
    fiworews? foxtrot-india-whiskey-oscar-romeo-echo-whiskey-sierra-QUESTION_MARK

补充熵池

随机数生成的这些工具，通过 /dev/random 依赖系统的熵池，而服务器在运行时，既没有键盘事件，也没有鼠标事件，那么就会导致噪声源减少。很多发行版本中存在一个 rngd 程序，用来增加系统的熵池（用 urandom 给 random 灌数据），详见章节 [给random()增加熵](init_a_server think)。

#### 生成通用的 Unix 格式的密码hash

在 Linux 中密码不是明文保存的，而是只保存它的 hash 值和盐，校验过程发生在用户输入密码后，由验证程序计算并与保存的 hash 值比对。

格式

    $1$...$ 段的内容是加密算法和盐salt，后面的才是该密码的 hash 值

> 使用 mkpasswd 工具

    # sudo dnf install mkpasswd
    # sudo apt install whois

    $ mkpasswd --method=SHA-512 --rounds=4096
    Password: 123
    $6$rounds=4096$qEZgm6JVSHwGTlZk$N9lWSeGJ/cFA2gZth8KZus2afjoA2wvbxvwN6OOLAy4SaBlwlGgMcx2ByqvuCf5PV46HK.GguJTN/5JFFjIdt0

输入你的密码如 123，输出给出的是加密之后 Linux 可以识别格式的hash值

> 使用 openssl

    `openssl help passwd`

使用 `openssl passwd <你的密码>` 命令，生成形如 `$5$your_salt$the_hashed_result` 的密码哈希格式，这是基于 Unix 系统的 crypt() 函数的密码哈希格式。这种格式通常用于 Unix/Linux 系统的密码存储，并且被多种应用程序和服务所支持，包括 Apache HTTP 服务器和 Nginx。

具体组成部分如下：

    $5$：这是一个固定的前缀，表示使用 SHA-256 加密算法。数字 5 是 crypt() 函数中用于 SHA-256 的标识符。

    your_salt：这是盐值（salt），它是一个随机字符串，用于与密码一起哈希，以增加密码的复杂度和安全性。盐值可以防止使用彩虹表（预先计算好的哈希表）进行攻击。盐值的长度通常为 8 个字符。

    the_hashed_result：这是密码和盐值经过 SHA-256 哈希算法处理后的结果。这个结果是一个 43 个字符的十六进制字符串。

这种格式的优点是：

    安全性：通过使用盐值，每个用户的密码哈希都是唯一的，即使两个用户使用了相同的密码。

    兼容性：被多种应用程序和服务广泛支持，包括 Apache HTTP 服务器、Nginx、Postfix 等。

    可配置性：支持不同的哈希算法，如 MD5、SHA-1、SHA-256 和 SHA-512。

使用这种格式时，通常需要使用专门的工具（如 htpasswd 或 openssl passwd 命令）来生成密码哈希。

openssl passwd 的常用选项

    -salt string：加入随机数，目前不需要手动指定了，会自动使用系统随机数

    -in file：对输入的文件内容进行加密

    -stdion：对标准输入的内容进行加密

默认用 MD5 算法哈希你的密码

    $ openssl passwd 123456
    $1$7F4haqDH$cVSLoqMYiBp.rggAG21Hz0

输出字符串的格式：

    开始的 $1$ 位为算法标志

        $1$ 为 MD5

        $5$ 为 SHA-256

        $6$ 为 SHA-512

        详见 crypt() 函数的说明

    第二段 $1$...$ 包裹的内容是盐salt。

    第三段 cVSLoqMYiBp.rggAG21Hz0 才是该密码的 hash 值，下同。

示例：

使用 sha256 对你的密码计算哈希

    $ openssl passwd -5 password
    $5$tVpwoB7k9wgI6QLu$P.RSnrktgV.ldMoONdlCLhC.WOp/jAH/Y7RlGoFZgl4

使用 sha512 算法你的密码计算哈希

    $ openssl passwd -6 password
    $6$eTL1LNGrE3.hMH9T$0e4AGG1iOYOfWlJjwWcCgWVMCNFdwS8MW.0ee67zVNPO4Cd2o6fATx8lzI0OIaI0RzP/8wE7x2kbuQFEVl.2w.

如果给出了盐salt，则hash值也就固定了，最好不给出，使用系统随机数即可

    $ openssl passwd -1 -salt 1234567 'wodemima'
    $1$1234567$T422txbws/GIfsRDYZ3.r.

不写密码会提示输入

    $ openssl passwd -1 -salt SALT
    Password:

这个不知道为何给出了3行

    $ openssl passwd -1 –salt centos wodemima
    $1$8Ch7O7sx$jyz2BwIvCbweTrnWDkIpU/
    $1$6TzTaiVo$imX.dJcqZU7ThQWuRHVNS0
    $1$a00Ku7MG$WVRs.DdeaIPaADJe7mZIo1

如果还需要增加破解难度，见章节 [使用 argon2 编码你的密码]。

##### 使用 argon2 编码你的密码

    https://lindevs.com/install-argon2-on-raspberry-pi

NOTE: 在密码散列函数已经到了足够的迭代次数后，使用更长的密码比增加迭代数更有用。

    密码管理器 1Password 的开发者这样表述：密码增加一个字符，相当于把迭代次数从 40,000 增加到 400,000，而两个字符就是 4,000,000。与其让自己的 SSH 密钥从默认的迭代 24 次改到 256 次，也不如把自己密码多写两位，反正增加的时间一样也是两秒。

Argon2

对密码加密保存一般使用加盐计算 hash 值的方式，但是常用的哈希算法防破解效果不好。所以有 argon2 算法专门用于存储密码。它通过加盐和多次迭代来增加破解难度，argon2id 算法还增加了内存使用量，针对使用 GPU 的并行破解增大难度

    $ sudo apt install -y argon2

    -m  定义最大内存使用量，以千字节为单位，2 的 m 次方，如 1GB 为 20
    -k  定义最大内存使用量，以千字节为单位
    -t  定义迭代次数
    -p  定义线程数
    -e  只输出 hash 的结果

Argon2i 变体用于生成哈希

    $ echo -n "Hello" | argon2 mysalt0123456789 -t 4 -k 65536 -p 2 -e
    $argon2i$v=19$m=65536,t=4,p=2$bXlzYWx0MDEyMzQ1Njc4OQ$N59WxssOt4L/ylaGzZGrPXkwClGZMDxn1Q3UolMEBLw

 Argon2id 变体，强度更高可以对抗使用显卡的并行运算，用选项 -id 指定

    $ echo -n "Hello" | argon2 mysalt0123456789 -id -t 4 -m 20  -p 2
    Type:           Argon2id
    Iterations:     4
    Memory:         1048576 KiB
    Parallelism:    2
    Hash:           05a3be8590c5a4f1eb4ba86b3da0afa7a7830b827ad432f9285d329d48520ada
    Encoded:        $argon2id$v=19$m=1048576,t=4,p=2$bXlzYWx0MDEyMzQ1Njc4OQ$BaO+hZDFpPHrS6hrPaCvp6eDC4J61DL5KF0ynUhSCto
    3.792 seconds
    Verification ok

### 按数制显示内容 od

xxd : 反编译文件内容，从二进制转为十六进制转换

    # 可以得到密码的hash值
    xxd "/etc/shadow" |xxd -r

od :按数制显示内容

    od [-A<字码基数> ] [-t[TYPE[SIZE]] ] 文件名

-A<字码基数>，在第一列地址栏，使用何种基数表示地址

    o：八进制（系统默认值）
    d：十进制
    x：十六进制
    n：不打印位移值

输出格式-t，格式比较奇怪，是累加的，不明白看下面的示例

    -t[TYPE] 指定数据的显示格式的主要参数有：

        a[SIZE]: ASCII字符，回车用字母
        c[SIZE]：ASCII字符，回车用反斜杠序列(如\n)
        d[SIZE]：有符号十进制数
        f[SIZE]：浮点数
        o[SIZE]：八进制（系统默认值）
        u[SIZE]：无符号十进制数
        x[SIZE]：十六进制数 默认以四字节为一组（一列）显示。

            [SIZE]：每列输出几个字节。
            SIZE may also be
                C for sizeof(char),
                S for sizeof(short),
                I for sizeof(int) or
                L for sizeof(long).
                If TYPE is f, SIZE may also be
                    F for sizeof(float),
                    D for sizeof(double) or
                    L for sizeof(long double)

    如果-t后面跟随两个小写字母，表示同时使用两个显示格式。

如果感觉 -t[type[size]] 不好记，常用的几个有快速参数

    -a     same as -t a,  select named characters, ignoring high-order bit

    -b     same as -t o1, select octal bytes

    -c     same as -t c,  select printable characters or backslash escapes

    -d     same as -t u2, select unsigned decimal 2-byte units

    -f     same as -t fF, select floats

    -i     same as -t dI, select decimal ints

    -l     same as -t dL, select decimal longs

    -o     same as -t o2, select octal 2-byte units

    -s     same as -t d2, select decimal 2-byte units

    -x     same as -t x2, select hexadecimal 2-byte units

示例

    # 以 16 进制显示文件 test.json，2字节一组，注意第一列是地址栏
    $ od -tx2 test.json
    0000000 0a7b 2020 6922 626e 756f 646e 2273 203a
    0000020 0a5b 2020 2020 0a7b 2020 2020 2020 7422
    0000040 6761 3a22 2220 7274 6e61 7073 7261 6e65

    # 以 ASCII 码的形式显示文件aa.txt内容，注意第一列是地址栏
    $ od -tc winscp.bat
    0000000   s   t   a   r   t       C   :   \   S   t   a   r   t   H   e
    0000020   r   e   \   t   o   o   l   s   \   W   i   n   S   C   P   -
    0000040   P   o   r   t   a   b   l   e   \   W   i   n   S   C   P   .
    0000060   e   x   e       %   1  \n
    0000067

    # 以 ASCII 码 和 16 进制的形式显示文件aa.txt内容
    $ od -tcx aa.txt
    0000000   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o   p
                64636261        68676665        6c6b6a69        706f6e6d
    0000020   q  \n   9   8   7   6   5   4   3   2   1   0   1   2   3   4
                38390a71        34353637        30313233        34333231
    0000040   5   6   7   8   9  \n   A   B   C  \n  \n
                38373635        42410a39        000a0a43
    0000053

    # 以 ASCII 码的形式显示文件aa.txt内容的，等效 -ta
    $ od -a aa.txt
    0000000   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o   p
    0000020   q  nl   9   8   7   6   5   4   3   2   1   0   1   2   3   4
    0000040   5   6   7   8   9  nl   A   B   C  nl  nl
    0000053

    $ echo 'abc' | od -An -t dC
    97   98   99   10

#### 查看 16 进制

hexdump 一般都自带了

    $ sudo dd if=/dev/nvme0n1p1 bs=512 count=2|hexdump -C
    00000000  eb 58 90 4d 53 44 4f 53  35 2e 30 00 02 02 fe 19  |.X.MSDOS5.0.....|
    00000010  02 00 00 00 00 f8 00 00  3f 00 ff 00 00 08 00 00  |........?.......|
    00000020  00 20 03 00 01 03 00 00  00 00 00 00 02 00 00 00  |. ..............|
    00000030  01 00 06 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    2+0 records in
    2+0 records out
    1024 bytes (1.0 kB, 1.0 KiB) copied, 0.000446537 s, 2.3 MB/s
    00000040  80 00 29 e1 a6 aa f0 4e  4f 20 4e 41 4d 45 20 20  |..)....NO NAME  |
    00000050  20 20 46 41 54 33 32 20  20 20 33 c9 8e d1 bc f4  |  FAT32   3.....|
    00000060  7b 8e c1 8e d9 bd 00 7c  88 56 40 88 4e 02 8a 56  |{......|.V@.N..V|
    00000070  40 b4 41 bb aa 55 cd 13  72 10 81 fb 55 aa 75 0a  |@.A..U..r...U.u.|
    00000080  f6 c1 01 74 05 fe 46 02  eb 2d 8a 56 40 b4 08 cd  |...t..F..-.V@...|
    00000090  13 73 05 b9 ff ff 8a f1  66 0f b6 c6 40 66 0f b6  |.s......f...@f..|
    000000a0  d1 80 e2 3f f7 e2 86 cd  c0 ed 06 41 66 0f b7 c9  |...?.......Af...|
    000000b0  66 f7 e1 66 89 46 f8 83  7e 16 00 75 39 83 7e 2a  |f..f.F..~..u9.~*|
    000000c0  00 77 33 66 8b 46 1c 66  83 c0 0c bb 00 80 b9 01  |.w3f.F.f........|
    000000d0  00 e8 2c 00 e9 a8 03 a1  f8 7d 80 c4 7c 8b f0 ac  |..,......}..|...|
    000000e0  84 c0 74 17 3c ff 74 09  b4 0e bb 07 00 cd 10 eb  |..t.<.t.........|
    000000f0  ee a1 fa 7d eb e4 a1 7d  80 eb df 98 cd 16 cd 19  |...}...}........|
    00000100  66 60 80 7e 02 00 0f 84  20 00 66 6a 00 66 50 06  |f`.~.... .fj.fP.|
    00000110  53 66 68 10 00 01 00 b4  42 8a 56 40 8b f4 cd 13  |Sfh.....B.V@....|
    00000120  66 58 66 58 66 58 66 58  eb 33 66 3b 46 f8 72 03  |fXfXfXfX.3f;F.r.|
    00000130  f9 eb 2a 66 33 d2 66 0f  b7 4e 18 66 f7 f1 fe c2  |..*f3.f..N.f....|
    00000140  8a ca 66 8b d0 66 c1 ea  10 f7 76 1a 86 d6 8a 56  |..f..f....v....V|
    00000150  40 8a e8 c0 e4 06 0a cc  b8 01 02 cd 13 66 61 0f  |@............fa.|
    00000160  82 74 ff 81 c3 00 02 66  40 49 75 94 c3 42 4f 4f  |.t.....f@Iu..BOO|
    00000170  54 4d 47 52 20 20 20 20  00 00 00 00 00 00 00 00  |TMGR    ........|
    00000180  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

hexyl

    https://github.com/sharkdp/hexyl

可以传递文件名，也可以接收管道传递过来的内容，注意 bash 中字符串是默认补位 0a 的

    $ echo 'abcdefgh123456789' |hexyl
    ┌────────┬─────────────────────────┬─────────────────────────┬────────┬────────┐
    │00000000│ 61 62 63 64 65 66 67 68 ┊ 31 32 33 34 35 36 37 38 │abcdefgh┊12345678│
    │00000010│ 39 0a                   ┊                         │9_      ┊        │
    └────────┴─────────────────────────┴─────────────────────────┴────────┴────────┘

可以限制位数

    $ hexyl -n 256 /dev/random
    ┌────────┬─────────────────────────┬─────────────────────────┬────────┬────────┐
    │00000000│ e0 c9 0c 31 ab 31 34 5b ┊ 5d 2b 51 b2 d5 f8 db 85 │××_1×141┊1+Q×××××│
    │00000010│ e1 da 43 57 35 88 33 d2 ┊ be 34 5c f5 d9 34 6f 31 │××CW5×3×┊×4\××4o1│
    │00000020│ 0c d6 74 50 ff 90 1a e8 ┊ 21 84 60 fe 36 65 26 3b │_×tP××•×┊!×`×6e&;│
    │00000030│ ac 8f dc a5 0e 70 8c d5 ┊ 68 cc 56 ef 54 d8 6e 60 │××××•p××┊h×V×T×n`│
    │00000040│ 68 5f a4 6c 8d 76 1d eb ┊ 31 db 7d 3b 07 6b 7f da │h_×l×v•×┊1×1;•k•×│
    │00000050│ 67 f6 3f ca 2c 6d 54 86 ┊ b1 e6 f0 33 67 55 55 c2 │g×?×,mT×┊×××3gUU×│
    │00000060│ cc ee 15 6e c2 c9 9d f4 ┊ a0 41 4c e5 36 59 9a 80 │××•n××××┊×AL×6Y××│
    │00000070│ 34 aa 55 d3 52 a3 90 a2 ┊ 27 a4 2e 43 3b a2 fb 2d │4×U×R×××┊'×.C;××-│
    │00000080│ a4 57 a4 37 c3 68 ba b7 ┊ 1f 33 59 01 74 60 57 5f │×W×7×h××┊•3Y•t`W_│
    │00000090│ e9 33 bb a8 dc 86 8a 17 ┊ c8 5e 88 b4 2b 09 1e e3 │×3×××××•┊×^××+_•×│
    │000000a0│ 84 f4 62 6a e2 89 7d c6 ┊ 9c e4 9d d3 d0 ab 30 8f │××bj××1×┊××××××0×│
    │000000b0│ a2 a3 90 1b 3e 1a 67 62 ┊ 07 53 50 8b a7 fa 20 46 │×××•>•gb┊•SP××× F│
    │000000c0│ 12 ea 39 aa a4 79 6f 0c ┊ 84 5d 8d c5 e9 24 68 95 │•×9××yo_┊×1×××$h×│
    │000000d0│ da 9d ba 7a 97 37 47 6d ┊ f1 27 08 64 31 e9 07 ce │×××z×7Gm┊×'•d1×•×│
    │000000e0│ 56 54 d2 f6 c4 e4 00 2f ┊ c9 f3 79 8e 8b 1a de 0e │VT××××⋄/┊××y××•×•│
    │000000f0│ 29 1c 09 0c 94 cb b5 40 ┊ 5a dc 29 e4 dc 01 5a 42 │1•__×××@┊Z×1××•ZB│
    └────────┴─────────────────────────┴─────────────────────────┴────────┴────────┘

### 查看自己的公网 IP 地址是多少

浏览器打开 <https://test.ustc.edu.cn/> 可看到自己的ip和测速。

只显示地址，方便脚本调用：

    $ curl members.3322.org/dyndns/getip
    11.22.33.44

    $ curl ipinfo.io/ip
    11.22.33.44

    $ curl ipv4.icanhazip.com
    11.22.33.44

    $ curl ipv6.icanhazip.com
    2409:xxxx:...

    $ curl ifconfig.me
    2409:xxxx:...

    $ curl ifconfig.io
    2409:xxxx:...

显示结构化数据，需要解析：

    $ curl httpbin.org/ip
    {
        "origin": "11.22.33.44"
    }

    $ curl -fsSL httpbin.org/ip | jq -r '.origin'
    "11.22.33.44"

    $ curl ipinfo.io
    {
        "ip": "11.22.33.44",
        "city": "Shanghai",
        "region": "Shanghai",
        "country": "CN",
        "loc": "11.22,33.44",
        "org": "xxx Company Limited",
        "postal": "100000",
        "timezone": "Asia/Shanghai",
        "readme": "https://ipinfo.io/missingauth"
    }

    $ curl -fsSL ipinfo.io | jq -r '.ip'
    11.22.33.44

    $ curl myip.ipip.net
    当前 IP：11.22.33.44  来自于：中国

    $ curl cip.cc
    IP      : 11.22.33.44
    地址    : 中国
    运营商  : 移动

    数据二  : 中国 | 移动/全省通用

    数据三  : 中国  | 移动

    URL     : http://www.cip.cc/11.22.33.44

### 下载工具

每日更新tracker

    https://github.com/ngosang/trackerslist

    https://github.com/XIU2/TrackersListCollection
        https://trackerslist.com/

xdm 有图形界面

    https://github.com/subhra74/xdm/releases

#### Aria2

支持 http、bt 等多种格式，速度奇快

    https://github.com/aria2/aria2
        https://aria2.github.io/

    https://wiki.archlinux.org/title/Aria2

    https://aria2.github.io/manual/en/html/aria2c.html#example

    Aria2 完美配置
            https://github.com/P3TERX/aria2.conf
            https://github.com/P3TERX/aria2.conf/blob/master/aria2.conf

    替代品 axel

        https://github.com/axel-download-accelerator/axel

        $ sudo dnf install axel

    [不推荐]Motrix 是 Windows 下的 aria2 图形界面程序，该软件使用方便，预先配置好了 aria2，自动更新最佳 dht 站点清单。

        https://github.com/agalwood/Motrix

        注意：Motrix 自带的 Aria2 来源于他自己的专用 Fork（未开源） 而非官方发行的预编译包。

    不知道 NSA 蜜罐会搞镜像站点么

        https://github.com/VPNSox/NSABlocklist

Aria2 的命令行传输各种参数，设置复杂，一般都使用各种客户端发送下载请求给它。

在 Fedora 下使用，发现 aria2 经常 coredump 呢，不如 transmission 稳定。

    $ sudo apt install aria2

图形界面 uget，自动调用 aria2 支持bt下载，该软件目前仍然不完善，别用了

    https://github.com/ugetdm/uget

    $ sudo dnf install uget aria2

    安装后设置选择，插件选 aria2 + curl 即可。

推荐使用浏览器扩展插件：Aria2 Explorer（内置AriaNg），安装后设置 api key，即可在浏览器中直接给 aria2 进程发下载请求了。

##### aria2 作为后台进程运行响应 RPC 请求

aria2 作为后台守护进程运行，在指定端口监听 RPC 请求，用户在浏览器安装扩展插件 Aria2 Explorer 把下载请求发送给 aria2 去执行，这样的方式最好用。因为是 RPC 方式，aria2 可以单独部署到家用 NAS 等单独的下载机，用户连接家庭内网的机器都可以操作它。

1、先生成 Aria2 运行时依赖的配置文件 aria2.conf，可参考 Motrix 的 aria2.conf

```conf
################################################
# aria2.conf
# https://aria2.github.io/manual/en/html/aria2c.html
log-level=warn

################ RPC ################
# Enable JSON-RPC/XML-RPC server.
enable-rpc=true
# Add Access-Control-Allow-Origin header field with value * to the RPC response.
rpc-allow-origin-all=true
# Listen incoming JSON-RPC/XML-RPC requests on all network interfaces.
rpc-listen-all=true


################ File system ################
# Save a control file(*.aria2) every SEC seconds.
auto-save-interval=10
# Enable disk cache.
disk-cache=32M
# Specify file allocation method.
file-allocation=falloc
# Save error/unfinished downloads to a file specified by --save-session option every SEC seconds.
save-session-interval=10


################ Task ################
# Exclude seed only downloads when counting concurrent active downloads
bt-detach-seed-only=true
# Verify the peer using certificates specified in --ca-certificate option.
check-certificate=false
# If aria2 receives "file not found" status from the remote HTTP/FTP servers NUM times
# without getting a single byte, then force the download to fail.
max-file-not-found=5
# Set number of tries.
max-tries=5
# aria2 does not split less than 2*SIZE byte range.
min-split-size=1M
# Set user agent for HTTP(S) downloads.
user-agent=Transmission/2.94
# Send Accept: deflate, gzip request header
http-accept-gzip=true


################ BT Task ################
# Enable Local Peer Discovery.
bt-enable-lpd=true
# Requires BitTorrent message payload encryption with arc4.
# bt-force-encryption=true
# If true is given, after hash check using --check-integrity option and file is complete, continue to seed file.
bt-hash-check-seed=true
# Specify the maximum number of peers per torrent.
bt-max-peers=255
# Try to download first and last pieces of each file first. This is useful for previewing files.
bt-prioritize-piece=head
# Removes the unselected files when download is completed in BitTorrent.
bt-remove-unselected-file=true
# Seed previously downloaded files without verifying piece hashes.
bt-seed-unverified=true
# Set host and port as an entry point to IPv4 DHT network.
dht-entry-point=dht.transmissionbt.com:6881
# Set host and port as an entry point to IPv6 DHT network.
dht-entry-point6=dht.transmissionbt.com:6881
# Enable IPv4 DHT functionality. It also enables UDP tracker support.
enable-dht=true
# Enable IPv6 DHT functionality.
enable-dht6=true
# Enable Peer Exchange extension.
enable-peer-exchange=true
# Specify the string used during the bitorrent extended handshake for the peer's client version.
peer-agent=Transmission/2.94
# Specify the prefix of peer ID.
peer-id-prefix=-TR2940-
bt-tracker=http://1337.abcvg.info:80/announce

```

2、执行 p3terx 的 tracker.sh 把最新的 bt-tracker 地址更新到配置文件 aria2.conf。

    https://github.com/P3TERX/aria2.conf/raw/master/tracker.sh

3、启动 aria2 作为后台进程的命令行参数

启动 aria2 后在浏览器中通过插件 Aria2 Explorer 进行下载即可。

Windows cmd：

    aria2c.exe --conf-path=%USERPROFILE%\.aria2\aria2.conf --enable-rpc --rpc-secret=your_password --dir=%USERPROFILE%\Downloads --save-session=%USERPROFILE%\.aria2\download.session --input-file=%USERPROFILE%\.aria2\download.session --dht-file-path=%USERPROFILE%\.aria2\dht.dat --dht-file-path6=%USERPROFILE%\.aria2\dht6.dat --allow-overwrite=false --auto-file-renaming=true --bt-load-saved-metadata=true --bt-save-metadata=true --continue=true --dht-listen-port=26701 --listen-port=21301 --max-concurrent-downloads=5 --max-download-limit=0 --max-overall-download-limit=0 --max-overall-upload-limit=256K --min-split-size=1M --pause=true --rpc-listen-port=6800 --seed-ratio=1 --seed-time=60 --split=64 --user-agent=Transmission/2.94

bash shell：

    $ aria2c --conf-path=$HOME/.aria2/aria2.conf --enable-rpc --rpc-secret=your_password --dir=$HOME/Downloads --save-session=$HOME/.aria2/download.session --input-file=$HOME/.aria2/download.session --dht-file-path=$HOME/.aria2/dht.dat --dht-file-path6=$HOME/.aria2/dht6.dat --allow-overwrite=false --auto-file-renaming=true --bt-load-saved-metadata=true --bt-save-metadata=true --continue=true --dht-listen-port=26701 --listen-port=21301 --max-concurrent-downloads=5 --max-download-limit=0 --max-overall-download-limit=0 --max-overall-upload-limit=256K --min-split-size=1M --pause=true --rpc-listen-port=6800 --seed-ratio=1 --seed-time=60 --split=64 --user-agent=Transmission/2.94

注意修改 --rpc-secret 密码。

验证：

用浏览器插件 Aria2 Explorer 也可以看到 aria2 状态是否可用。

另见章节 [curl 调试 http/wss/json-rpc]。

为什么在 AriaNg 中删除暂停的任务无法删除文件

    Aria2 本身没有通过 RPC 方式（比如 We­bUI ）删除文件的功能，目前你所看到的删除任务后删除文件的功能是通过下载完成后执行命令（on-download-stop）的接口去调用删除脚本实现的，只能删除正在下载的任务。Aria2 定义暂停状态的任务为未开始的任务，而 on-download-stop 这个选项的执行条件是并不包含未开始的任务。所以删除脚本没有触发，文件也就不会被删除。

4、配置为开机自启动服务

Windows 下可使用 WinSW 将 Aria2 安装成用户服务来开机自启。

Linux 配置为 systemd 服务，创建 /etc/systemd/system/aria2.service 文件，内容如下：

```conf
[Unit]
Description=Aria2 Service
# 等待网络就绪，等待本地文件系统，等待挂载目录完毕
After=network.target local-fs.target mnt-my_lv.mount
# 等待目录挂载完毕见章节 [使用 systemd.mount 在开机后自动挂载目录](init_a_server think)
Requires=mnt-my_lv.mount

[Service]
Type=simple
#PIDFile = /run/aria2.pid
#ExecReload=/bin/kill -s HUP $MAINPID
#KillSignal=SIGQUIT
#TimeoutStopSec=5
#KillMode=process
# 非 root 用户执行，方便后续操作下载到的文件，不需要切换到root用户
User=pi
Group=pi
WorkingDirectory=/home/pi
#
ExecStartPre=/bin/bash /usr/local/etc/aria2/tracker.sh /usr/local/etc/aria2/aria2.conf
ExecStart=/usr/bin/aria2c --conf-path=/usr/local/etc/aria2/aria2.conf --enable-rpc --rpc-secret=YOUR_PASS --dir=YOUR_DIR --save-session=/usr/local/etc/aria2/download.session --input-file=/usr/local/etc/aria2/download.session --dht-file-path=/usr/local/etc/aria2/dht.dat --dht-file-path6=/usr/local/etc/aria2/dht6.dat --allow-overwrite=false --auto-file-renaming=true --bt-load-saved-metadata=true --bt-save-metadata=true --continue=true --dht-listen-port=26701 --listen-port=21301 --max-concurrent-downloads=5 --max-download-limit=0 --max-overall-download-limit=0 --max-overall-upload-limit=256K --min-split-size=1M --pause=true --rpc-listen-port=6800 --seed-ratio=1 --seed-time=60 --split=64 --user-agent=Transmission/2.94
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s TERM $MAINPID
Restart=always

[Install]
WantedBy=multi-user.target
```

上面内容替换 YOUR_DIR 和 YOUR_PASS，在目录 /usr/local/etc/aria2/ 下保存 aria2.conf 配置文件

    因为使用普通用户执行，注意你设置的 your_dir 目录对该用户是可写的

在 /usr/local/etc/aria2/ 下准备：

    $ git clone --depth=1 git@github.com:P3TERX/Aria2-Pro-Docker

    $ git clone --depth=1 git@github.com:P3TERX/aria2.conf p3terx_conf
    从 p3terx_conf 子目录里拷贝 tracker.sh 到当前目录

然后启动服务

    $ sudo systemctl daemon-reload

    $ sudo systemctl enable aria2.service --now

> Aria2 服务端不会自己去删除文件

aira2 作为服务运行，各种使用配置上的小坑太麻烦了，建议用现成的容器，见章节 [容器化运行 aria2 服务端](raspberry-pi.md think)。

Aria2 服务端不会自己去删除文件，这是官方的回答，所以下载完成后.aria2 文件会保留。这也导致在下载出错的时候即使你删掉了任务，下载的文件依然还在，且 Aria2 是预分配磁盘空间的，这是磁盘占满的原因之一。

aria2.conf 有两个配置项 on-download-complete、on-download-stop，前者可以在下载完成后执行一个脚本，后者可以在停止后执行一个脚本。Aria2 会给脚本传递 3 个变量 $1、$2、$3 分别为 gid 、文件数量、文件路径。利用这些配置项和这些变量就可以实现一些功能，比如在下载完成后调用 Rclone 上传、错误停止后对文件进行删除等操作

    https://p3terx.com/archives/solve-problems-encountered-in-using-aria2-and-rclone.html

    https://github.com/P3TERX/aria2.conf

#### Transmission

一种 BitTorrent 客户端，特点是一个跨平台的后端和其上的简洁的用户界面。

    https://transmissionbt.com/
        https://github.com/transmission/transmission

    安装配置说明
        https://trac.transmissionbt.com/wiki/UnixServer/Debian
        https://github.com/transmission/transmission/wiki/Editing-Configuration-Files

    简单点直接 docker

        https://registry.hub.docker.com/r/linuxserver/transmission/

        https://registry.hub.docker.com/r/andrewmhub/transmission-tracker-add/

    https://blog.csdn.net/slimmm/article/details/115720184

    竞品 qBittorrent

        https://www.qbittorrent.org/

也是前后台分离的设计，后台进程负责下载，前台负责任务管理

    transmission-gtk: GTK+界面客户端。

    transmission-qt: QT界面客户端。

    transmission-cli: 命令行BT客户端。

    transmission-daemon: 是一个Transmission的后台守护程序，本身不具备操作指令，只能通过Web客户端或者transmission-remote-cli来进行控制。这个程序特别适合安装在服务器上或者嵌入式系统中，以及一些没有显示器的设备上。

    transmission-remote-cli: 用来控制transmission-daemon的命令套件，本身不具备下载BT的功能，只能够配合daemon使用。

1、主要安装服务端

    apt install transmission-daemon

系统级配置文件目录： /var/lib/transmission-daemon/info/

    settings.json    主要配置文件，设置daemon的各项参数，包括RPC的用户名密码配置。其软链接指向/etc/transmission-daemon/settings.json。配置说明

    torrents/    用户存放.torrent种子文件的目录,凡是添加到下载任务的种子，都存放在这里。.torrent的命名包含,种子文件本身的名字和种子的SHA1 HASH值。

    resume/    该存放了.resume文件，.resume文件包含了一个种子的信息，例如该文件哪些部分被下载了，下载的数据存储的位置等等。

    blocklists/    存储被屏蔽的peer的地址。

    注意：在编辑Transmission的配置文件的时候，需要先关闭daemon进程。

安装时会自动创建一个用户来专门运行 transmission-daemon，用户名为：debian-transmission。所以，如果使用另外一个用户来运行 transmission-daemon 的话，会在该用户的目录下，创建一个.config/transmission-daemon 的文件夹，在这个文件夹里有单独的 settings.json 配置文件，下载目录也会变为 $HOME/Download

    # 启动
    sudo service transmission-daemon start

    # 停止
    sudo service transmission-daemon stop

2、修改配置文件 settings.json

    {
        ......
        "rpc-authentication-required": true
        "rpc-bind-address": "0.0.0.0",
        "rpc-enabled": true,
        "rpc-password": "123456",     # 这里明文写入登录密码，初次启动后会自动被替换为 hash 值
        "rpc-port": 9091,     #端口
        "rpc-url": "/transmission/",
        "rpc-username": "transmission",     #用户名
        "rpc-whitelist": "*",             #白名单，也可以指定IP
        "rpc-whitelist-enabled": true,
        ......
    }

3、经过上述配置后，我们就可以通过Web界面来访问和控制Transmission daemon了。在浏览器里面输入以下地址

    http://<your.server.ip.addr>:9091/

浏览器提示你输入刚才配置的用户名和密码，就可以成功登录Web管理界面。

一般安装浏览器插件 Aria2 Explorer，实现拦截浏览器的下载，弹窗添加到transmission。

#### curl 支持 http/https 等下载

区别于之前流行的 wget 默认下载为文件，curl 默认输出到标准输出流

    $ wget https://www.cloudflare.com/ips-v4
    --2023-04-12 15:06:35--  https://www.cloudflare.com/ips-v4
    Resolving www.cloudflare.com (www.cloudflare.com)... 2606:4700::6810:7c60, 2606:4700::6810:7b60, 104.16.123.96, ...
    Connecting to www.cloudflare.com (www.cloudflare.com)|2606:4700::6810:7c60|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 230 [text/plain]
    Saving to: ‘ips-v4’

    100%[======================================>] 230         --.-K/s   in 0s

    2023-04-12 15:06:35 (24.9 MB/s) - ‘ips-v4’ saved [230/230]

    # 静默下载，输出到标准输出流
    wget -q -O - http://deb.opera.com/archive.key |gpg --import

    https://www.ruanyifeng.com/blog/2019/09/curl-reference.html

无参数默认只把获取的内容输出到终端的默认标准输出流

    curl https://www.cloudflare.com/ips-v4

一般在使用中，至少要加参数：跟踪重定向，不显示进度条，静默错误信息但要报错失败

    curl -fsSL https://github.com/web-flow.gpg

    如果对端服务器的 https 签名信息错误，可以用 -k 跳过 SSL 检测

下载并保存为默认文件名，最后一个参数是大写的 O

    curl -fsSLO https://www.cloudflare.com/ips-v4

下载并保存为指定文件名，最后一个参数是小写的 o

    curl -fsSLo cfipv4 https://www.cloudflare.com/ips-v4

下载并保存为文件名，如果指定路径不存在则创建

    curl -fsSLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

##### curl 直接上传

用 “-” 从标准输入流读取，如果换成 “.” 还可以显示服务器的输出

    gpg --export your_address@example.net |curl -T - https://keys.openpgp.org

命令行获取 web 内容

    # http get 方法
    $ curl -fsSL 11.22.33.44:1234

    # http post 方法
    $ curl -fsS -d '上传到服务器的负载内容' 11.22.33.44:1234

其它常用选项

    -o  指定保存为文件
    -k  运行内网 https 无证书

##### curl 调试 http/wss/json-rpc

可以调试 ssh 站点，也支持 telnet、ftp 等站点，用参数 -vvv 显示服务器输出信息

curl http-get

    $ curl -vvv 11.22.33.44:1234
    * About to connect() to 11.22.33.44 port 1234 (#0)
    *   Trying 11.22.33.44...
    * Connected to 11.22.33.44 (11.22.33.44) port 1234 (#0)
    > GET / HTTP/1.1
    > User-Agent: curl/7.29.0
    > Host: 11.22.33.44:1234
    > Accept: */*
    >
    SSH-2.0-OpenSSH_7.4
    Protocol mismatch.
    * Recv failure: Connection reset by peer
    * Closing connection 0
    curl: (56) Recv failure: Connection reset by peer

curl http-post

    # 使用 HTTP Basic 认证
    $ curl -u root:123456 -X POST -d "Reboot=Reboot" http://192.168.0.1/ADVANCED_home2.htm

    wget -v --http-user root --http-password 123456 "http://192.168.0.1/ADVANCED_home2.htm"

    # 填写表单字段
    $ curl -X POST -d "Username=root" -d "Password=123456" -d "Reboot=Reboot" http://192.168.0.1/ADVANCED_home.htm

    $ curl -v -XPOST -H "Content-Type:application/json"  http://172.24.7.63:36963/VIID/MotorVehicles -d  ' {"DataType" : "Face"} '

ws

    $ curl -vvv --no-buffer \
        -H 'Connection: keep-alive, Upgrade' \
        -H 'Upgrade: websocket' \
        -H 'Sec-WebSocket-Version: 13' \
        -H 'Sec-WebSocket-Key: websocket' \
        http://echo.websocket.org | od -t c

    $ curl -vvv --include \
        --no-buffer \
        --header "Connection: Upgrade" \
        --header "Upgrade: websocket" \
        --header "Host: websocket.org:80" \
        --header "Origin: http://websocket.org:80" \
        --header "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" \
        --header "Sec-WebSocket-Version: 13" \
         https://echo.websocket.org

json-rpc

        https://aria2.github.io/manual/en/html/aria2c.html#rpc-interface

    $ curl -vvv localhost:6800/jsonrpc
    {"id":null,"jsonrpc":"2.0","error":{"code":-32600,"message":"Invalid Request."}}

    # 内网 https 地址加 -k
    $ curl -X POST -H "Content-Type: application/json" \
        -d '{"jsonrpc":"2.0", "id":"test", "method":"aria2.getVersion", "params":["token:your_password"]}' \
        localhost:6800/jsonrpc
    {"id":"test","jsonrpc":"2.0","result":{"enabledFeatures":["Async DNS","BitTorrent","Firefox3 Cookie","GZip","HTTPS","Message Digest","Metalink","XML-RPC"],"version":"1.36.0"}}

### ZModem 协议的文件传输工具 rs/rz

连接嵌入式设备传送文件，没有 sftp、ftp 时， 用 rs、rz 比较方便。

ssh 连续跳转连接几个服务器后，sftp 传送命令不方便的时候，用 rz、sz 比较方便。不过这种情况下最方便的办法是直接设置 ssh 的 ProxyJump 参数，不管是 ssh 连接还是 sftp 都能无缝操作。

缺点是几十年前的老协议了，速率较慢误码率较高，大文件的传送需要自行做 hash 校验。

    https://github.com/tmux/tmux/issues/906#issuecomment-321890340

    https://blog.csdn.net/mynamepg/article/details/81118580

    mintty 不支持 https://github.com/mintty/mintty/issues/235

在远程设备里安装

    $[iot@remote_ip] sudo apt install lrzsz

本地也需要安装 lrzsz 软件包，而且需要你的终端工具支持 zmodem 协议

    如果终端工具如 putty、mintty、Gnome terminal 等不支持 zmodem 协议，但是支持从桌面拖放文件（变成路径名称）到终端工具，则可以安装 Gnu screen，使用 screen 来实现对 rz、sz 的支持，参见章节 [竞品 screen/Zellij]。

    另有软件包 ztelnet 包装 telnet 支持 zmodem 协议

    为解决明文传送的问题，可安装软件包：zssh 通过包装 ssh 支持 zmodem 协议，使用 zssh 命令而不是 ssh 连接远程，热键 ctl+@ 即可切换到传送命令行（类似 sftp）。

        https://www.jianshu.com/p/dcd0111f3043
        https://www.cnblogs.com/pied/p/5813018.html

发送：

    远程接收方运行 rz 命令后等待

        $[iot@remote_ip] rz
        **B0100000023be50eive.**B0100000023be50

    然后在桌面直接把你要发送的文件拖动到你的终端工具窗口即可

    记得比对下校验码，防止误码

         $[iot@remote_ip] sha1sum your_file

接收：

    本地接受方运行 rz 等待

        $ rz

    远程发送方直接运行 sz 命令即可把文件传递到你终端工具设置的目录下

        $[iot@remote_ip] sz you_need_this_file

    记得比对下校验码，防止误码

         $[iot@remote_ip] sha1sum you_need_this_file

### 安全传输文件 sftp

sftp 支持的常用文件操作命令跟bash一致，比如 ls，pwd，cd 等，操作本地前缀字母l，如 lls，lcd，lpwd 等，全部命令输入 ? 即可。

sftp 上传目录如果报错要先建立好

    sftp xxx.com
    sftp> put -r your_dir/
    Error：...
    sftp> mkdir your_dir/
    sftp> put -r -p your_dir/
    Ok.

下载目录

    sftp xxx.com
    sftp> get -r svr_dir/

限制 sftp 连接用户可访问路径，使用 chroot Jail 将 sFTP 用户限制到其主目录中

    https://www.tecmint.com/restrict-sftp-user-home-directories-using-chroot/

### 跨机远程拷贝 scp

scp 本意是代替 rcp 的，但是命令行参数解析漏洞无法保证兼容性，只能废了：

    用 rsync 代替 scp

    或直接使用 sftp 传送文件，比如 RedHat 就是用 sftp 替换掉了 scp

    https://ostechnix.com/securely-transfer-files-with-scp-in-linux/
        https://lists.mindrot.org/pipermail/openssh-unix-dev/2019-March/037672.html

    sftp 附加了远程文件管理功能如建立或删除文件、支持断点续传等，单纯看速度 scp 更快，但是 sftp 的安全性要高于 scp

        https://goteleport.com/blog/sftp

        https://goteleport.com/blog/scp-familiar-simple-insecure-slow/

    在 Windows 下 scp 和 sftp 的开源软件是 WinSCP 和 FileZilla。

使用 scp 的前提条件跟 sftp 一样

    可以 ssh 登录才能 scp 文件

scp 是利用 ssh 协议的文件拷贝，所以实际工作时使用 ssh 进行身份验证和加密，使用 rcp 传输文件。所以 scp 的命令行用法跟 rcp 是一致的。

scp 基本用法

    注意后缀有没有目录标识 ‘/’ 的行为是不同的，拷贝为目录下或拷贝为目录

远程文件复制到本地：

    # 指定端口用 -P
    scp -P 16022 root@www.test.com:/val/test/test.tar.gz /val/test/test.tar.gz

从远程主机复制多个文件到当前目录

    cd /val/
    scp root@192.168.1.104:/usr/local/nginx/html/webs/\{index.css,json.js\} .

远程文件复制到本地指定目录下：

    scp root@www.test.com:/val/test/test.tar.gz /val/test/

本地文件复制到远程：

    scp /val/test.tar.gz root@www.test.com:/val/test.tar.gz

从本地文件复制多个文件到远程主机（多个文件使用空格分隔开）

    cd /val/
    scp index.css json.js root@192.168.1.104:/usr/local/nginx/html/webs/

本地文件复制到远程指定目录下：

    scp /val/test.tar.gz root@www.test.com:/val/

远程目录复制到本地：

    # 指定端口用 -P
    scp -P 16022 -r root@www.test.com:/val/test/ /val/test/

本地目录复制到远程：

    scp -r ./ubuntu_env/ root@192.168.0.111:/home/pipipika

    scp -r SocialNetworks/ piting@192.168.0.172:/media/data/pipi/datasets/

把文件从一个远程主机复制到另一个远程主机上

    scp root@192.168.1.104:/usr/local/xx.txt root@192.168.1.105:/usr/local/webs/

### 万兆光纤链路拷贝工具--bbcp

数据中心光纤线路传输大文件或目录，需要加密多线程传输工具以充分利用带宽，商业版的有 IBM Aspera，开源产品中除了 rsync 开启多线程传输，还可以考虑 bbcp

    http://www.slac.stanford.edu/~abh/bbcp/

源服务器和目标服务器都需要安装 bbcp，源服务器执行 bbcp 时会用 ssh 连接到目标服务器自动调用 bbcp

    下载 https://www.slac.stanford.edu/~abh/bbcp/bin/amd64_ubuntu22.04/bbcp

    $ chmod +x bbcp && sudo cp bbcp /usr/bin/

测试运行

    本机测试，第一次运行会提示你登录 localhost 的 ssh 密钥，确认即可：

        $ bbcp -P 2 /dev/zero localhost:/dev/null
        The authenticity of host 'localhost (::1)' can't be established.
        ED25519 key fingerprint is SHA256:xxxxxxx.
        This key is not known by any other names.
        Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
        Warning: Permanently added 'localhost' (ED25519) to the list of known hosts.
        bbcp: Creating /dev/null/zero
        bbcp: 250226 01:04:30  0% done; 2.4 GB/s
        bbcp: 250226 01:04:32  0% done; 2.0 GB/s
        bbcp: 250226 01:04:33  0% done; 2.1 GB/s
        bbcp: 250226 01:04:35  0% done; 2.2 GB/s
        bbcp: 250226 01:04:36  0% done; 2.2 GB/s
        bbcp: 250226 01:04:37  0% done; 2.2 GB/s

    网络上的主机，尝试使用大的 TCP 窗口

        $ bbcp -P 2 -v -w 2M /dev/zero v10chi.datatag.org:/dev/null

如果你的服务器启用防火墙了，注意目标服务器上需要开放 5031 端口。源服务器上不需要添加相应的规则。

#### 参数调优

正常调优之后，10G 光纤线路是可以跑满的

    http://pcbunn.cithep.caltech.edu/bbcp/using_bbcp.htm

1、操作系统参数

Issue a "cat /proc/sys/net/ipv4/tcp_rmem" command, and verify that the numbers you see are large, for example:

    1610612736      1610612736      1610612736

(and not small, like 4360)

Here are some typical settings that will allow high throughput in the WAN:

    ### IPV4 specific settings
    net.ipv4.tcp_timestamps = 0
    net.ipv4.tcp_sack = 0

    # on systems with a VERY fast bus -> memory interface this is the big gainer
    net.ipv4.tcp_rmem = 536870912 536870912 536870912
    net.ipv4.tcp_wmem = 536870912 536870912 536870912
    net.ipv4.tcp_mem = 536870912 536870912 536870912

    ### CORE settings (mostly for socket and UDP effect)
    net.core.rmem_max = 536870912
    net.core.wmem_max = 536870912
    net.core.rmem_default = 536870912
    net.core.wmem_default = 536870912
    net.core.optmem_max = 536870912
    net.core.netdev_max_backlog = 1000000

In RHEL Linux, you can put these in /etc/sysctl.conf, or run `sysctl` from the command line (you'll need to be root).

Note that, with default large windows like these, *every* user who starts a TCP connection will get a connection that is allocated the full window size, which might not be what you want on a multi-user system.

There are many Web sites which describe how to tune TCP/IP, so we do not cover that here.

2、网卡 MTU 要开启巨型帧

如果有多块网卡，确认好传输使用的是 9000 MTU 或以上的网卡，默认 1500 MTU 的网卡速度快不起来。

3、确认路由

用 `tracepath`检查到目标服务器的路由，确认是两块巨型帧网卡之间的传输，且 MTU 没有被路由器降低。

如果调整了路由设置，刷新下系统的：

    $ sysctl -w net.ipv4.route.flush=1

4、确认 -w 参数

    https://www.slac.stanford.edu/~abh/bbcp/#_Toc392015142

先用 ping 看下平均延迟，假设是 120msecs，线路是 10G 光纤，可得 `iperf` 工具的参数：

    Window Size = 10Gbits/sec * 120msecs = 120 MBytes

则 bbcp 的参数要除以 2，为 60M。

5、避免名称查找

如果给出的是 ip 地址，按规范会默认用 DNS 查找功能转为名称，然后又查找一次到具体的 ip 地址。用 -n 参数禁止这个用法。

示例：

    https://www.cnblogs.com/ddroot/p/7815552.html

拷贝文件

    $ /usr/local/bin/bbcp -4 -k -a -r -F -v -P 2 -w 9m -s 16 -T 'ssh -p 1222 -x -a -oFallBackToRsh=no %I -l %U %H /usr/local/bin/bbcp' test.tar.gz

参数详解：

    -4 使用ipv4 IP地进行传输
    -k 保留所有未传输完成的文件，并允许在重试时进行覆盖，使用-f后即使加了-k也会全部重传，一般与-a一起使用，默认不使用-k时当传输未完成就中断传输时会删除没有传输完的目标文件
    -a 保留checkpoint信息用于校验文件的完整性
    -r 递归传输指定路径下的所有文件
    -c 使用压缩减少网络上传输的字节但需要额外的CPU资源，如果CPU资源不足，性能会非常差。bbcp使用zip对数据进行压缩传输压缩级别1-9，1速度最快，9最大压缩率速度最慢
    -d 多目录复制，可以使用多个源以空格隔开。如:/home/ddroot/data dir1/data1 dir2/data2
    -P 2 每两秒显示传输的进程
    -v 显示拷贝信息
    -V 打印调试信息
    -f 强制覆盖远端已经存在的文件
    -F 不检查目标服务器的剩余空间
    -w 设置Disk (I/O) buffers
    算法为(window = netspeed/8*RTT = 1000Mb/8*74ms = 1000/1000/8*74 = 9.25 M)
    对应链接：https://www.slac.stanford.edu/~abh/bbcp/#_Toc392015142
    -s 16 设置并发数为16，默认4个
    参考官方建议：https://www.slac.stanford.edu/~abh/bbcp/#_Toc392015143
    -T "ssh -x -a -p 1222 -oFallBackToRsh=no -i /home/ddroot/.ssh/id_rsa -l ddroot 172.16.66.66 /usr/bin/bbcp"
        指定远端主机的认证方式：
        采用-p 1222指定端口；
        设置-oFallBackToRsh=no减少ssh响应时间；
        设置-i /home/ddroot/.ssh/id_rsa指定SSH Key；
        -I 使用传输文件列表文件
        设置-l ddroot指定登陆用户；
        172.16.66.66为远程主机地址；
        /usr/bin/bbcp为远程主机的bbcp路径；
    --port pn1 指定接收数据端口，默认5031
    -Z pn1:pn2 指定接收数据端口范围

### 文件同步 rsync

rsync 用于增量备份（只复制有变动的文件），同步文件或目录，支持远程机器。其默认的行为是，使用文件大小和修改时间来判断目标文件是否需要更新

    http://rsync.samba.org

    https://www.ruanyifeng.com/blog/2020/08/rsync.html

    rsync 完全手册 https://www.junmajinlong.com/linux/index/#Linux%E5%9F%BA%E6%9C%AC%E6%9C%8D%E5%8A%A1

    https://blog.csdn.net/wanli245/article/details/80317255

    http://c.biancheng.net/view/6121.html

    使用 rsync 备份操作系统

        https://wiki.archlinux.org/title/Rsync#Full_system_backup

最常用的就是代替 scp 命令

使用 `rsync -e ssh` 即可代替 scp 命令，但是注意其对目录的处理方式跟 scp/cp 方式有区别：

    源目录 source 完整地复制到了目标目录 destination 下面，即形成了 destination/source 的目录结构

        rsync source destination/

    只想同步源目录source里面的内容到目标目录destination，则需要在源目录后面加上斜杠

        rsync source/ destination/

rsync的工作方式

    主机本地间的数据传输数据（此时类似于cp命令的功能）

    借助rcp,ssh等传输数据（此时类似于scp命令的功能）

    以守护进程（socket）的方式传输数据（这个是rsync的重要的功能）

rsync 实现增量备份：

    首次同步：rsync 会复制源目录中的所有文件到目标目录，无论它们是否发生变化。

    后续同步：

        rsync 会在同步前比较源目录和目标目录中的文件。

        如果文件在源目录中被修改、删除或新增，rsync 会相应地更新目标目录。

        如果文件没有变化，rsync 不会重新传输这些文件。

    所以，重复执行相同的 rsync 命令就可以实现只更新变化的文件，简单方便

一般要配合使用 ionice 来降低 rsync 进程的 io 优先级：

    scp 不占资源，不会提高多少系统负荷，在这一点上，rsync 就远远不及它了。虽然 rsync 比 scp 会快一点，但当小文件众多的情况下，rsync 增量备份会导致硬盘 I/O 非常高，而 scp 基本不影响系统正常使用。

    $ sudo ionice -c 2 -n 7 rsync -avz /source/ /destination/

    -c 2 指定了 I/O 类（2 代表“best effort”），-n 7 指定了优先级级别（从 0 到 7，7 最低）。

    所以使用时根据自己的情况酌情决定选用哪个。

rsync 默认使用 SSH 进行远程登录和数据传输。一般在目标设备上建立普通身份的用户，ssh 中限制权限到指定备份文件夹读写，然后只通过 SSH 的公私钥认证一种方式登录，然后配置一个自动 rsync 的脚本定时运行备份数据到目标设备上。

    rsync 在源服务器上运行：这种直接从源服务器复制文件到目标服务器的方式更直观，而且可以在源服务器上监控整个同步过程，包括进度和任何错误。

    rsync 在目标服务器上运行：需要在目标服务器上有权限访问源服务器。可以在目标服务器上监控同步过程，但可能需要额外的配置，如设置 SSH 密钥认证等。

   早期 rsync 不使用 SSH 协议，需要用 -e 参数指定协议，后来才改的。

        # -e ssh 可以省略
        $ rsync -av -e ssh source/ user@remote_host:/destination

但是，如果 ssh 命令有附加的参数，则必须使用 -e 参数指定所要执行的 SSH 命令。

    # -e 参数指定 SSH 使用 2234 端口
    $ rsync -av -e 'ssh -p 2234' source/ user@remote_host:/destination

    # 使用密钥文件登录服务器
    rsync -av -e "ssh -i /Users/hs/test.pem" {本地源文件夹路径}/* root@{服务器IP}:{服务器目标文件夹路径}

    # 使用 rsync 之前把 ssh 相关连接参数设置到变量 RSYNC_RSH 更方便
    export RSYNC_RSH ="ssh -T -c aes128-ctr -o Compression = no -x"

rsync 命令提供使用的 OPTION 及功能

    OPTION选项    功能

    -a    这是归档模式，表示以递归方式传输文件，并保持所有属性，它等同于开启 -r、-l、-p、-t、-g、-o、-D 选项。 -a 选项后面可以跟一个 --no-OPTION，表示关闭 -r、-l、-p、-t、-g、-o、-D 中的某一个，比如-a --no-l 等同于 -r、-p、-t、-g、-o、-D 选项。

    -r    以递归模式处理子目录，它主要是针对同步目录来说的，如果单独传一个文件不需要加 -r 选项，但是传输目录时必须加。 --relative /var/www/uploads/abcd

    -z    加上该选项，将会在传输过程中压缩。

    -v    打印一些信息，比如文件列表、文件数量等。

    -h    让输出信息人性化可读

    --progress    在同步的过程中可以看到同步的过程状态，比如统计要同步的文件数量、 同步的文件传输速度等。

    -n    模拟命令执行的结果，并不真的执行命令(--dry-run) 。

    -l    保留软链接，默认不处理软链接文件。

    -L    像对待常规文件一样处理软链接。如果是 SRC 中有软链接文件，则加上该选项后，将会把软链接指向的目标文件复制到 DEST，默认不处理软链接文件。

    -H    保留硬链信息

    -p    保持文件权限。

    -D    保持设备文件信息。

    -t    保持文件的修改时间信息。

    --delete  使两个目录保持相同。在多次备份时源目录中已经删除的文件也会在目标目录中删除。默认情况下，rsync 只确保源目录的所有内容（明确排除的文件除外）都复制到目标目录，它不会使两个目录保持相同，并且不会删除文件。如果要使得目标目录成为源目录的镜像副本，则必须使用 --delete 参数，这将删除只存在于目标目录、不存在于源目录的文件。

    --exclude=PATTERN   指定排除不需要传输的文件，等号后面跟文件名，可以是通配符模式（如 *.txt）。

    -u    把 DEST 中比 SRC 还新的文件排除掉，不会覆盖。

    -c 或 --checksum    使用校验和判断文件变更，而不是默认的文件大小变化或文件修改时间变化，这会增加cpu消耗。

    --size-only     只同步大小有变化的文件，不考虑文件修改时间的差异。

    --partial       断点续传。保留那些未传输完成的文件，以便可以在下次传输时继续。部分传输的文件通常会被存放在目标目录中，但它们会被放置在一个以 .rsync-partial 命名的隐藏目录里。这个隐藏目录会在目标路径下自动创建，用于存放在传输过程中断时的部分文件。

    --append-verify 断点续传。在 --partial 的基础上，它还会在传输完成后对文件进行校验，如果校验失败，则会重新传输该文件。这是对数据完整性更好的选择，但是会大大降低数据同步的速度，并增加cpu消耗。

    --delete        增量备份时删除目标服务器上在源服务器不存在的文件，建议使用前先用 -n 参数干跑一下看看效果

    --exclude       同步时排除某些文件或目录

    --bwlimit=KBPS  最大传输速率，限制 rsync 的带宽使用

以上也仅是列出了 rsync 命令常用的一些选项，对于初学者来说，记住最常用的几个即可，比如 -a、-v、-z、--delete 和 --exclude。

自动尝试断点续传的触发条件：

    重新执行的命令必须与最初中断的命令完全相同，包括源文件、目标文件以及使用的参数。

    rsync 会检查目标路径下是否存在未完成的文件部分，检查源文件的大小和修改时间，如果找到了这样的部分文件，rsync 会从上次中断的地方继续传输。

    如果源文件在传的过程中改变了，或一开始就断连了，不会进行续传

    如果使用了 --inplace 参数，rsync 会直接在目标位置更新文件，而不是首先将数据传输到临时文件然后再重命名。这种情况下，rsync 不会保留未完成的传输数据。

    如果使用了 --whole-file 参数，rsync 会传输整个文件，而不是增量传输，因此不会进行断点续传。

因为使用 ssh 进行备份，所以实际使用中一般不指定属主和属组，只备份数据。如果要实现备份 /home 目录，支持多个用户和属主权限，则使用如下参数，但是注意限制：

    -o  参数 -a 已经包含，保持文件属主信息。如果源服务器上的文件属主在目标服务器上也存在，那么使用 -o 参数可以保留文件的属主信息。

        如果目标服务器上不存在相应的属主，那么即使使用了 -o 参数，文件的属主也不会被设置为源服务器上的属主。在这种情况下，文件通常会被设置为目标服务器上执行 rsync 命令的用户的属主。

    -g  参数 -a 已经包含，保持文件属组信息。如果源服务器上的文件属组在目标服务器上也存在，那么使用 -g 参数可以保留文件的属组信息。

        如果目标服务器上不存在相应的属组，那么即使使用了 -g 参数，文件的属组也可能不会被保留。文件可能会被设置为目标服务器上执行 rsync 命令的用户的属组，或者根据目标服务器的配置被设置为其他默认属组。

    --chown=john:users 参数来指定文件在目标服务器上的属主和属组。这个参数允许你指定一个用户名和属组名，即使这些用户在目标服务器上不存在，可能需要目标服务器上的用户有足够的权限来更改文件的属主和属组，如果目标服务器的安全策略不允许修改文件的属主和属组，那么即使使用了 --chown 参数，也可能无法实现预期的效果。

rsync 的 5 种不同的工作模式：

    rsync [OPTION] SRC DEST

    rsync [OPTION] SRC :DEST

    rsync [OPTION] :SRC DEST

    rsync [OPTION] ::SRC DEST

    rsync [OPTION] SRC ::DEST

第一种用于仅在本地备份数据；

第二种用于将本地数据备份到远程机器上；

第三种用于将远程机器上的数据备份到本地机器上；

第四种和第三种是相对的，同样第五种和第二种是相对的，它们各自之间的区别在于登录认证时使用的验证方式不同。

> 使用 rsync://协议

在 rsync 命令中的远程操作，如果使用单个冒号（:），则默认使用 ssh 协议；反之，如果使用两个冒号（::），则使用 rsync 协议，默认端口873。ssh 协议和 rsync 协议的区别在于，rsync 协议在使用时需要额外配置，增加了工作量

    # module并不是实际路径名，而是 rsync 守护程序指定的一个资源名，由管理员分配
    rsync -av source/ 192.168.122.32::module/destination

    # rsync 守护程序分配的所有 module 列表
    rsync rsync://192.168.122.32

    # 除了使用双冒号，也可以直接用 rsync://
    rsync -av source/ rsync://192.168.122.32/module/destination

> rsyncd 守护进程

rsyncd 通常配置在源服务器上，它监听客户端的连接请求，并允许客户端同步（拷贝）文件。这里的“源服务器”是指拥有你想要同步的文件的服务器，而“目标服务器”可以是任何需要这些文件的服务器。

NOTE: 在支持 SELinux 的服务器上，如果要使用 rsync 守护进程共享文件，您必须使用 `public_content_t` 类型标记文件和目录。

    https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/chap-managing_confined_services-rsync

源服务器的 rsyncd.conf 配置：

```conf
# rsyncd.conf

# 用户和组
uid = nobody
gid = nogroup

# 最大连接数
max connections = 4

# 守护进程模式
use chroot = yes
chroot = /path/to/chroot

# 日志文件
log file = /var/log/rsync.log

# PID 文件
pid file = /var/run/rsyncd.pid

# 拒绝对 .sensitive 文件夹的访问
read only = yes
exclude = .sensitive/

# [module_name] 定义了一个可以被同步的模块
[module_name]
path = /path/to/directory/on/server
comment = This is a comment
read only = no
list = yes
uid = nobody
gid = nogroup

# 可以添加更多的模块
[another_module]
path = /another/path/on/server
comment = Another comment
```

在这个配置文件中：

    uid 和 gid 指定了运行 rsync 守护进程的用户和组。

    max connections 指定了同时可以有多少个连接。

    use chroot = yes 和 chroot 指定了 rsync 守护进程将使用 chroot 监狱来限制访问。

    log file 和 pid file 分别指定了日志文件和 PID 文件的位置。

    read only = yes 和 exclude = .sensitive/ 指定了同步操作是只读的，并且排除了 .sensitive 文件夹。

    [module_name] 是一个模块，它定义了客户端可以同步的文件和目录。

    path 指定了服务器上的同步目录。

    comment 是一个可选的描述。

    read only 可以设置为 no 来允许写入操作。

    list 设置为 yes 允许客户端列出模块中的文件。

    uid 和 gid 指定了文件的拥有者和组。

如果想知道 rsync 守护程序分配的所有 module 列表，可以执行下面命令。

    $ rsync rsync://192.168.122.32

客户端执行同步：

    rsync -avz rsync://remote_host::module_name /path/to/local/directory

remote_host 是守护进程运行的服务器的主机名或 IP 地址。

module_name 是你在 rsyncd.conf 中定义的模块名。

/path/to/local/directory 是客户端的目标目录。

注意事项

    权限：确保源服务器上的 rsync 守护进程有权限访问指定的文件和目录。

    安全性：如果使用非加密的连接，数据可能会被截获。使用 SSH 隧道或其他加密方法可以提高安全性。
    如果你希望允许写入操作，确保 read only 设置为 no，并且服务器上的目录有适当的写入权限。

    性能：rsync 守护进程可以配置为使用 chroot 监狱来限制进程的活动范围，提高安全性。

    如果你使用 SSH 进行传输，可以在客户端命令中添加 -e ssh 选项。

通过这种方式，rsync 守护进程允许客户端从源服务器同步文件，而客户端可以是任何需要这些文件的目标服务器。

#### rsync 命令行示例

一般使用中，最常用的归档模式且输出信息用参数 `-v -a`，一般合写为 `-av`，这样就可以实现增量备份。

    -a：存档模式（等于-rlptgoD）：递归，将符号链接复制为符号链接，保留权限，保留修改时间，保留组，保留所有者，保留设备文件和特殊文件

    -v：在传输过程中增加详细信息

    -u：跳过接收方上较新的文件

    -r：递归到目录

    --progress：显示传输过程中的进度

    --delete：从远程服务器中删除多余的文件

在生产系统上运行，一般要用 `ionice` 降低 IO 优先级，需要 root 权限

    $ sudo ionice -c 2 -n 7 rsync -avr --progress source username@remote_host:destination

如果不确定 rsync 执行后会产生什么结果，先 -n 模拟跑下看看输出

    rsync -anv source destination

    # 断点续传
    rsync -avth --partial --progress --bwlimit=4000 --exclude='*.xxx' /path1/ xxx@192.111.11.111:/path2/

NOTE：rsync 命令源目录是否写 '/' 处理方式不同

    # 源目录 source 中的内容复制到了目标目录 destination 中，不建立source子目录的方式

    # 理解为    source/*
    rsync -av  source/ destination

    # 源目录 source 被完整地复制到了目标目录 destination 下面，source成为子目录
    rsync -av source destination

其它多个用法

    # 同步时排除某些文件或目录，可以用多个 --exclude
    rsync -av --exclude='*.txt' source/ destination

    # 同步时排除隐藏文件
    rsync -av --exclude=".*" source/ destination

    # 排除某个目录里面的所有文件，但不希望排除目录本身
    rsync -av --exclude 'dir1/*' source/ destination

    # 同步时，排除所有文件，但是不排除 txt 文件
    rsync -av --include="*.txt" --exclude='*' source/ destination

    # 排除一个文件列表里的内容，每个模式一行
    rsync -av --exclude-from='exclude-file.txt' source/ destination

增量备份的三方比对用法：使用基准目录，即将源目录与基准目录之间变动的部分，同步到目标目录

    # 目标目录中，也是包含所有文件，只有那些变动过的文件是存在于该目录，其他没有变动的文件都是指向基准目录文件的硬链接。
    rsync -a --delete --link-dest /compare/path /source/path /target/path

远程数据传输，默认使用 SSH

    # 将本地内容，同步到远程服务器
    rsync -avz --progress source/ username@remote_host:destination

    # 将远程内容同步到本地
    rsync -av username@remote_host:source/ destination

    # 如果 ssh 命令有附加的参数，则必须使用 -e 参数指定所要执行的 SSH 命令
    rsync -av -e 'ssh -p 2234' source/ user@remote_host:/destination

#### 软硬链接文件的处理区别

如果是单独拷贝文件，软链接只是个引用，硬链接是文件实体，参数有区别。

默认对文件的操作是保留软链接，如果是拷贝一个目录结构，其内部的软链接指向目录内的文件实体，则会保持软链接；

    https://zhuanlan.zhihu.com/p/365239653

    # 如果 your_dir_or_file 是个文件，会拷贝到目标目录下
    # 如果 your_dir_or_file 是个目录，会在目标目录下建立子目录，内容拷贝过去
    $ rsync -av /etc/letsencrypt/live/your_dir_or_file root@remote:/etc/letsencrypt/live

如果目录结构内部的软链接指向外部目录的文件实体，需要拷贝软链接对应的实体文件，则添加参数 -L

拷贝一个目录结构，目录内的软链接文件处理为实体文件，拷贝到远程

    # -r 参数 在目的目录内递归的生成源目录结构的子目录，目的目录需要提前建好（`mkdir -p /etc/letsencrypt/live`），否则会报错
    # -L 参数 拷贝软链接对应的实体文件
    rsync -avrL /etc/letsencrypt/live/your_dir_or_file   root@remote:/etc/letsencrypt/live

    等效于 -avrL .................live/your_dir_or_file/  remote.......................live/your_dir_or_file

拷贝一个软链接文件处理为实体文件

    # 只是普通的文件去掉 -L 参数即可
    rsync -avL /etc/letsencrypt/live/your_dir_or_file/cert.pem root@remote:/etc/letsencrypt/live/your_dir_or_file

#### 示例：备份用户的主目录

```shell

#!/bin/bash
# A script to perform incremental backups using rsync

set -o errexit
set -o nounset
set -o pipefail

readonly SOURCE_DIR="${HOME}"
readonly BACKUP_DIR="/mnt/data/backups"
readonly DATETIME="$(date '+%Y-%m-%d_%H:%M:%S')"
readonly BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
readonly LATEST_LINK="${BACKUP_DIR}/latest"

mkdir -p "${BACKUP_DIR}"

rsync -av --delete \
  "${SOURCE_DIR}/" \
  --link-dest "${LATEST_LINK}" \
  --exclude=".cache" \
  "${BACKUP_PATH}"

rm -rf "${LATEST_LINK}"
ln -s "${BACKUP_PATH}" "${LATEST_LINK}"

```

#### 用 rsync 服务从 Linux 到 Windows 和 Linux 进行远程备份

> 使用 rsync 协议

    https://www.zhihu.com/question/20322405/answer/2874017681

一、安装设置服务器端软件

下载 rysnc，在两台服务器中都要安装，主服务器上 rsync 以服务器模式运行 rsyncd 守护进程，在同步上用 crond 定时任务以客户端方法运行 rsync，同步主服务器上需要同步的内容

一般 Linux 发行版自带的就不必自行编译安装了。

 rsync 服务器的设置文件为 /etc/rsyncd.conf，其操控认证、拜访、日志记载等。

 该文件是由一个或多个模块结构组成。一个模块定义以方括弧中的模块名开端，直到下一个模块定义开端或文件结束，模块中包含格式为 `name= value` 的参数定义。

 每个模块其实就对应需要备份的一个目录树，比方说在咱们的实例环境中，有三个目录树需要备份：

    /www/

    /mirror/file0/

    /mirror/file1/

那么就需要在设置文件中定义三个模块，分别对应三个目录树。

设置文件是行为单位的，每个新行都表明一个新的注释、模块定义或许参数赋值。

例如，在 168 上创建 rsyncd 的设置文件 /etc/rsyncd.conf，内容如下：

    uid = nobody # 备份以什么身份进行，用户ID
    gid = nobody # 备份以什么身份进行，组ID
    # 留意这个用户 ID 和组 ID，假如要便利的话，能够设置成 root，这样 rsync 简直就可以读取任何文件和目录了，但是也带来安全隐患。建议设置成只能读取你要备份的目录和文件即可。

    #use chroot = no
    max connections = 0 # 最大衔接数没有限制
    pid file = /var/log/rsync/rsyncd.pid
    lock file = /var/log/rsync/rsync.lock
    log file = /var/log/rsync/rsyncd.log

    [attachment] # 指定认证的备份模块名
    path = /www/htdocs/pub/attachment/ # 需要备份的目录
    comment = BACKUP attachment # 注释
    ignore errors # 疏忽一些无关的IO过错
    read only = false # 设置为非只读
    list = false # 不答应列文件
    #hosts allow = 210.51.0.80 #答应衔接服务器的主机IP地址
    #hosts deny = 0.0.0.0/0.0.0.0 #制止衔接服务器的主机IP地址
    auth users = msyn # 认证的用户名，假如没有这行，则表明是匿名
    secrets file = /etc/rsyncd.scrt # 认证文件名，用来存放暗码

    [98htdocs]
    uid = nobody
    gid = nobody
    path = /www/htdocs/
    #ignore errors
    read only = false
    list = false
    #hosts allow = 210.51.0.98
    #hosts deny = 202.108.211.38
    #hosts deny = 0.0.0.0/0.0.0.0
    auth users = msyn
    secrets file = /etc/rsyncd.scrt

    [98html]
    uid = ejbftp
    gid = nobody
    path = /www/htdocs/pub/html/
    #ignore errors
    read only = false
    list = false
    #hosts allow = 210.51.0.98
    #hosts deny = 0.0.0.0/0.0.0.0
    auth users = 98syn
    secrets file = /etc/rsync98.scrt

这里分别定义了 [attachment]、[98htdocs]、[98html] 三个模块，分别对应于三个需要备份的目树。三个模块授权的备份用户分别为 msyn，msyn，98syn，用户信息保存在文件 /etc/rsyncd.scrt 和 /etc/rsync98.scrt 中，其内容如下：

    $ sudo cat /etc/rsyncd.scrt
    msyn:xxxxxxxxx

该文件只能 是root 用户可读写的，出于安全目的，这个文件的特点必需是只要属主可读，文件权限 600 不然 rsync 将拒绝运行。

    # /usr/local/bin/rsync --daemon

rsync 默许服务端口为 873。

二、装备客户端

1、linux下执行 rsync 客户端指令

    [backup@backup /] /usr/bin/rsync -vlzrtogp --progress --delete 98syn@x.x.x.168::98html /usr/local/apache/htdocs/pub/html/ --password-file=/etc/rsync98.scrt

上面这个指令行中：

    -vzrtopg 里的 v 是代表 verbose(具体)，z 是代表 zip（压缩），r 是代表 recursive（递归），topg 都是保留文件原有特点如属主、时间的参数。

    --progress 是指显示出当前的进度，

    --delete 是指假如服务器端删除了这一文件，那么客户端也相应把文件删除，保持一致。

    98syn@x.x.x.168::98html 是表明该指令是对服务器x .x.x.168 中的 98html 模块进行备份，其中 98syn 表明运用 98syn 用户来对该模块进行备份。

    -- password-file=/etc/rsync98.scrt 来指定密码文件，这样就能够在脚本中调用而无需交互式地输入验证密码了，这里需要注意的是密码文件权限，要设得只能执行这个指令的用户可读，本例中是98syn 用户。

备份的内容存放在备份机的/usr/local/apache/htdocs/pub/html/目录下。

这样，rsync同步服务就搭建好了，可以通过 设置 crontab 定时任务来调度执行。

2、Windows装备客户端

为了在Windows环境运用 rsync 工具，需要下载 rsync for windows --- cwRsync。

然后运行以下指令

    rsync -vzrtopg --progress --delete 98syn@xx.xx.xx.xx::98html .\bak\ --password-file=.\rsync98.scrt

如果命令行执行过程中出现提示输入密码 `password:`，正确输入密码后就应该看到开始执行备份了。

引起这种过错有几种可能性

    一是你没有输入正确的用户名或密码

    二是你的服务器端存储密码的文件没有正确的 600 权限

最好把命令写成批处理文件，放到 Windows 计划任务里定时执行。

> 使用 ssh 协议

把 apache 的 html/ 下的所有目录和文件传送到 ssh 服务器的 /destination 目录下，同步删除源目录不存在的文件和目录

    /usr/bin/rsync -avz --progress --delete /usr/local/apache/htdocs/pub/html/ user@remote_host:/destination

说明：

    -avz        里的 a 是递归方式传输文件并保持所有属性；v 是显示正在处理的文件详细信息；z 是传输中使用 zip 压缩。

    --progress  显示出当前的进度，

    --delete    源目录如果删除了一文件，那么目的目录也相应把文件删除，保持一致。

可以考虑增加参数以提高数据准确性或速度

    --checksum      使用校验和判断文件变更，等同参数 -c

    --size-only     只同步大小有变化的文件，不考虑文件修改时间的差异。

自制 systemd 单元文件：

/usr/lib/systemd/system/rsync_bkup.service

``` ini
[Unit]
Description=rsync backup your data
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
# 注意 --delete 的风险，如果存储没有挂载只有空目录，会导致目标目录的内容也都删除了
ExecStart=/usr/bin/rsync -avz --progress --delete /sorce/path/ user@remote_host:/destination

[Install]
WantedBy=multi-user.target
```

定时器：跟单元文件同名，后缀改为 .timer

/usr/lib/systemd/system/rsync_bkup.timer

``` ini
[Unit]
Description=rsync backup your data daily

[Timer]
OnCalendar=daily
Persistent=true
AccuracySec=1h
RandomizedDelaySec=900
Unit=rsync_bkup.service

[Install]
WantedBy=timers.target
```

启动并设置开机自启动

    $ sudo systemctl daemon-reload

    $ sudo systemctl enable --now rsync_bkup.timer

验证

    systemctl list-timers

#### rsync+inotify 实时增量备份

使用 inotify 可以用来监控文件系统的各种变化情况，如文件存取、删除、移动、修改等，并做出通知响应。利用这一机制，可以非常方便地实现文件异动告警、增量备份，并针对目录或文件的变化及时作出响应

    https://blog.51cto.com/u_16213651/10493107

    https://github.com/inotify-tools/inotify-tools

感觉比较适合备份配置文件等变化不频繁的静态资源，对重度任务的实时同步要慎重，比如日志、生产数据的实时备份，不能确定对文件系统和块设备 io 占用率的冲击有多大，在文件快速频繁变化的极端场景下，会不会产生备份任务的重复扫描和积压？

inotifywait（持续监控并实时输出监控结果的命令）

    $ inotifywait [参数]

    -m      持续进行监控
    -r      递归监控所有子对象
    -q      简化输出信息
    -e      指定要监控哪些事件类型

调整inotify内核参数（优化）/etc/sysctl.conf(内核参数配置文件)

    inotifywait             #用于持续监控，实时输出结果
    inotifywatch             #用于短期监控，任务完成后再输出结果
    max_queue_events        #监控事件队列大小
    max_user_instances      #最多监控实例数
    max_user_watches        #每个实例最多监控文件数

一、 server配置

安装 inotify

    $ dnf install inotify-tools

验证：

监控 /abc 下，添加文件、移动文件等操作，并跟踪屏幕输出结果

    $ sudo mkdir -p /abc

    $ inotifywait -mrq -e modify,create,move,delete /abc

然后另开一个终端,进行 创建、删除、重命名 等操作，会看到 inotifywait 屏幕的输出

    touch 4.txt
    touch 5.txt
    rm -rf 4.txt
    mv 5.txt 6.txt

优化配置 inotify 内核参数 /etc/sysctl.conf

    fs.inotify.max_queued_events = 32768      #监控事件队列，默认为16384
    fs.inotify.max_user_instances = 1024      #最多监控实例数，默认为128
    fs.inotify.max_user_watches = 1048576      #每个实例最多监控文件数，默认为8192

    #当要监控的目录、文件数据量较多或者变化频繁时，建议加大参数值

配置生效：

    $ sudo sysctl -p

二、 rsync服务器配置

1、先关闭rsync进程

    $ kill $(cat /var/run/rsyncd.pid)
    $ netstat -natp | grep rsync

2、修改rsync配置文件 /etc/rsyncd.conf

```conf
uid = root
gid = root
use chroot = yes
address = 192.168.3.12
port 873
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid
hosts allow = 192.168.3.0/24
[wwwroot]
path = /var/www/html
comment = Document Root of www.ljm.com
read only = no
dont comperss = *.gz *.bz2 *.tgz *.zip *.rar *.z
auth users = backuper
secrets file = /etc/user.db

```

3、启动rsync

    $ rsync --daemon
    $ netstat -natp | grep rsync

三、将 rsync+inotify 两个服务结合在一起

1、脚本 /opt/inotify.sh

```bash
#!/bin/bash

INOTIFY_CMD="inotifywait -mrq -e create,delete,move,modify,attrib /abc/"

RSYNC_CMD="rsync -apzH --delete --password-file=/etc/server.pass /abc/ backuper@192.168.8.14::wwwroot/"

$INOTIFY_CMD | while read DIRECTORY EVENT FILE
do
    if [ $(pgrep rsync | wc -l) -le 0 ]; then
        $RSYNC_CMD
    fi
done

```

2、脚本赋权

    chmod +x /opt/inotify.sh
    chmod +x /etc/rc.d/rc.local

3、设置开机自启动

    echo "/opt/inotify.sh" >> /etc/rc.d/rc.local

4、验证

    $ cd /abc
    touch 1.txt

再回到 rsync 看，发现已经同步过去

### 增量备份工具 Restic

Restic 是一个强大的快照式增量备份工具，可以把本地的文件备份到本地的另一地方，或云端。

    https://restic.net/
        https://github.com/restic/restic

    文档 https://restic.readthedocs.io/en/stable/
        https://github.com/restic/restic/blob/master/doc/design.rst

    https://juejin.cn/post/7014803100074672135

    Using rclone as a restic Backend
        https://restic.net/blog/2018-04-01/rclone-backend/

    使用 restic 和 systemd 自动备份 https://zhuanlan.zhihu.com/p/66324926
        https://fedoramagazine.org/use-restic-encrypted-backups/

Restic 基于 “存储库(Repository)” 和快照的概念，每次备份就相当于一份快照，它用增量方式生成快照并用 AES 等方式加密，使用 ssh 密钥方式连接备份服务器的保存到云端的 “存储库”。当您备份敏感数据并将备份放在不受自己管辖服务器（例如，云提供商）时，这一点尤其重要。

在使用上分离为前端和后端，后端实现挂载本地、sftp、远程云存储等功能，在后端提供了统一的存储库底层架构的基础上，前端在存储库上实现基于快照的增量备份功能

    Restic 支持的存储类型

        本地存储
        SFTP
        REST Server
        Amazon S3
        Minio Server
        OpenStack Swift
        Backblaze B2
        Microsoft Azure Blob Storage
        Google Cloud Storage
        通过后端(backend)使用 Rclone 进行挂载，支持流行的各种云盘，比如：Google Drive、OneDrive 等

    Restic 的增量备份是基于快照的。每次备份操作，Restic 都会创建一个新的快照，这些快照代表了指定时间点的数据状态
    。增量备份的工作原理是 Restic 会检查自上次备份以来哪些文件发生了变化，然后仅备份这些变化的部分，而不是每次都备份全部数据。这种方式不仅节省了存储空间，还提高了备份效率。Restic 的增量备份机制通过以下步骤实现：

        数据分块：Restic 会将文件分割成小块（Blobs），并对这些块进行哈希计算。

        变更检测：Restic 会检测自上次备份以来哪些块发生了变化。

        增量备份：仅备份新的或变化的数据块，而不是整个文件。

        快照创建：每次备份都会生成一个新的快照，这些快照包含了备份时刻的数据状态。

        数据去重：Restic 在存储数据时会进行去重，相同的数据块不会重复存储，这进一步节省了存储空间。

        备份恢复：用户可以根据快照恢复到特定的数据状态。

Rclone 和 Restic 各有所长，要根据不同的业务需求选择使用。比如：网站数据的增量备份，用 Restic 就比较合适。而常规文件的远程备份到云端，用 Rclone 就很合适， Rclone 支持的云存储比 Restic 多的多。目前主流的使用方式是组合二者的长处， Restic 使用 rclone 作为后端存储。

    Rclone 和 Restic 的相同点

        两者都是基于命令行的开源文件同步和备份工具。

        两者都支持将文件备份到本地、远程服务器或对象存储。

    不同点是

        Rclone 面向的是文件同步，即保证两端文件的一致，也可以增量备份。
        Restic 面向的是文件备份和加密，文件先加密再传输备份，而且是增量备份，即每次只备份变化的部分。

        Rclone 仓库配置保存在本地，备份的文件会保持原样的同步于存储仓库中。
        Restic 配置信息直接写在仓库，只要有仓库密码，在任何安装了 Restic 的计算机上都可以操作仓库。

        Rclone 不记录文件版本，无法根据某一次备份找回特定时间点上的文件。
        Restic 每次备份都会生成一个快照，记录当前时间点的文件结构，可以找回特定时间点的文件。

        Rclone 可以在配置的多个存储端之间传输文件。

Restic 相对 rsync 有何优点

    加密: Restic 在备份数据时会对数据进行加密处理，确保备份数据的安全性和完整性，而 rsync 则不提供加密功能

    备份快照: Restic 为每次备份创建一个快照，可以恢复到任何先前的状态，而 rsync 则不具备这样的时间点恢复功能

    增量备份: Restic 支持增量备份，只备份自上次备份后变化的部分，这可以节省存储空间和备份时间。虽然 rsync 也支持增量备份，但 Restic 的增量备份更加精细和高效

    数据去重: Restic 在存储备份数据时会进行数据去重，多个快照中的相同数据只会存储一次，这样可以节省存储空间

    可验证性: Restic 允许用户验证备份数据的完整性，确保可以恢复。这是通过备份的校验和来实现的，而 rsync 则没有这样的特性。执行 `restic check --read-data` 命令可以手工验证，这会下载存储库中的所有包文件进行完整性校验。

    存储类型: Restic 支持多种存储类型，包括本地存储、SFTP、各种云存储服务等，这使得它可以灵活地备份到不同的位置

    备份仓库: Restic 的备份仓库是自包含的，可以在任何安装了 Restic 的计算机上操作，而 rsync 则需要在特定的服务器上运行

    数据完整性: Restic 备份时会对数据进行完整性校验，确保备份数据未被篡改，而 rsync 则主要关注数据的传输和同步

总的来说，Restic 是专为备份设计的，它提供了加密、增量备份、可验证性和数据去重等特性，而 rsync 更多是用于文件同步和传输，虽然也可以用于备份，但在安全性和备份管理方面不如 Restic。

#### 初始化储存库

Restic 不直接存储所有已配置的存储库的列表，当你初始化一个新的存储库时，Restic 会在指定的位置创建存储库数据，但它不会在你的系统上创建一个全局列表来跟踪所有存储库，存储库可以存储在本地，也可以存储在远程服务器或服务器上

法一：在远程 ssh 服务器上初始化存储库

    # https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html#sftp
    $ restic -r sftp:user@host:/srv/restic-repo init

如果连接的 sftp 需要密码，会提示输入。

需要给出存储库的密码，之后在任何客户端连接到 sftp 服务器后，都可以使用该密码访问该存储库。

可使用 --password-file 参数来读取存储库的密码文件

    echo 'Lf0uHG1wVpVzsgEi' > /root/resticpasswd

或设置到环境变量 export RESTIC_PASSWORD='yourpassword'

    https://restic.readthedocs.io/en/stable/040_backup.html#environment-variables

注意不支持 ssh 服务器的密码，只支持使用密钥文件。

法二：在本地目录初始化存储库

    $ restic --repo /srv/restic-repo init
    enter password for new repository:
    enter password again:
    根据提示输入两次密码

    或添加参数 --password-file= 指定密码文件

创建成功后，可以用 tree 命令看下储存库的结构

    $ tree /srv/restic-repo
    /srv/restic-repo
    ├── config
    ├── data
    │   ├── 00
    │   ├── 01
    │   [...]
    │   ├── fe
    │   └── ff
    ├── index
    ├── keys
    │   └── f5793ac470614552a179964abc17e381b20c3039486e89bf39728079d210ec57
    ├── locks
    └── snapshots

    261 directories, 2 files

两种使用方式：

一、支持 sftp 方式备份到服务器

执行数据备份

    restic -r sftp:bkuser@server_B:/data backup ./

查看备份

    restic -r sftp:bkuser@server_B:/data snapshots

查看备份内容

    restic -r sftp:bkuser@server_B:/data ls 875a2a32

恢复快照

    restic -r sftp:bkuser@server_B:/data restore 875a2a32 -t ./

    restic -r sftp:bkuser@server_B:/data restore 875a2a32 --target ./

删除备份

    restic -r sftp:root@106.53.117.41:/data forget 875a2a32

清理快照：forget 与 prune

    快照是会越积越多的，因此我们需要定期/不定期地执行 autorestic forget 命令根据我们的配置删除过期的快照，在执行的同时带上 --prune 参数可以一并删掉不再被用到的存储块。只有这些块被删掉，空间才真正被节约了！

还可以将备份仓库挂载为文件系统，以便于浏览和恢复文件：

    restic mount -r rclone:mybackup:/backup/path /path/to/mount

二、对象存储备份

支持基于 s3 协议的后端对象存储，例如 minio 或者腾讯/阿里对象存储。

云存储参见章节 [云存储](office_great_wall think)。

建议使用 rclone 作为后端存储，可以支持常见的各种云盘，见章节 [远程备份归档 RClone]。

阿里云对象存储

    $ export AWS_ACCESS_KEY_ID=<YOUR-OSS-ACCESS-KEY-ID>
    $ export AWS_SECRET_ACCESS_KEY=<YOUR-OSS-SECRET-ACCESS-KEY>

    $ ./restic -o s3.bucket-lookup=dns -o s3.region=<OSS-REGION> -r s3:https://<OSS-ENDPOINT>/<OSS-BUCKET-NAME> init
    $ restic -o s3.bucket-lookup=dns -o s3.region=oss-eu-west-1 -r s3:https://oss-eu-west-1.aliyuncs.com/bucketname init

    $ restic -o s3.bucket-lookup=dns -o oss-cn-beijing.aliyuncs.com -r s3:https://xueltestoss.oss-cn-beijing.aliyuncs.com init

    创建 repository

    $ export AWS_ACCESS_KEY_ID=LTAIxxxxxxxdZa9
    $ export AWS_SECRET_ACCESS_KEY=XvHxxxxxxxxxxxxxxxxxJt3wb7
    $ restic -o s3.bucket-lookup=dns -o s3.region=oss-cn-beijing.aliyuncs.com -r s3:https://xueltestoss.oss-cn-beijing.aliyuncs.com/xueltestoss init

在备份命令中加 --password-file 参数来读取文本中的密码，这里以sftp为例

    $ restic -r s3:https://oss-cn-beijing.aliyuncs.com/xueltestoss --password-file /root/resticpasswd backup /data/

其他恢复操作基本上和 sftp 的一致。

#### Restic + RClone 实现将快照保存到远程存储

restic 支持把 rclone 作为后端存储，二者结合进行备份时，restic 会创建数据的快照，然后这些快照存储在 rclone 配置的远程存储中。

1、安装配置 RClone，配置远程存储比如云盘或 ssh 服务器

    $ rclone config

详见章节 [远程备份归档 RClone]，记下远程存储的名称如 ssh_rc1。

2、初始化 Restic 存储库

Restic 不使用其他后端，则需要一些额外的配置连接服务器，例如密码或密钥文件。你可以使用 --password-command 提供密码。

后端使用 rclone

    # restic init --repo rclone:ssh_jnzh:/mnt/universal/thin/sysbak
    $ restic init --repo rclone:ssh_rc1:/backup/host1/home

这里 ssh_rc1 是你在 RClone 中配置的远程存储的名称，/backup/path 是你希望存储快照的路径。

3、配置后验证连接

    $ restic check

    $ restic snapshots

    $ restic ls [snapshot-id]

    $ restic stats

3、使用 restic 执行备份：

    $ restic backup /path/to/backup -r rclone:ssh_rc1:/backup/path

这里 /path/to/backup 是你希望备份的目录，rclone:ssh_rc1/backup/path 是你的 RClone 存储路径。

4、管理快照

Restic 会为每次备份创建一个快照。

列出所有快照：

    restic snapshots -r rclone:ssh_rc1:/backup/path

恢复备份

    restic restore latest -r rclone:ssh_rc1:/backup/path --target /path/to/restore

删除过时的快照

    restic forget --keep-within 5 --keep-last 5 -r rclone:ssh_rc1:/backup/path

挂载为本地文件系统

    restic mount -r rclone:ssh_rc1:/backup/path /path/to/mount

Restic 允许你将备份仓库挂载为文件系统，以便于浏览和恢复文件

#### 使用 autorestic 简化你的操作

    https://chariri.moe/archives/122/personal-backup-restic-rclone/

restic 是一个 CLI 工具，但缺了一些关键的功能，如定时备份，且其所有设置都要通过命令行参数给定，很不方便。autorestic 是 restic 的一个「包装器」，通过自动调用 restic 的方法，加上了配置文件、定时执行（伪）等功能。

简单地说，restic 会把数据备份到称作「存储库」的地方，这个存储库就是一个有特定目录结构的一组文件，可以在本地也可以在云上。每次备份会创建一个「快照」，表示一个备份源的当前所有数据。随着时间推移，快照会越来越多，但快照间的数据是去重的，多个快照中的相同数据只会存一份，有效节约了空间。

我们先按 restic 的文档初始化好三个存储库，设置好密码（备份数据会用这个加密）。

autorestic 还引入了一些不同的概念。「location」指一个备份源，而「backend」指一个 repository 的存储位置，以下配置中的locations和backends就反映了这一点。

autorestic 的配置文件使用 YAML 格式，如下示例：

```yaml
version: 2

locations:
  user_data:
    from: 'C:\Users\charlie'
    to:
      - external_hdd
      - onedrive_nju
      - onedrive_e5
    cron: '0 4 * * 0'    # 定时操作设置
    options:             # 这些都是传给 restic 的参数
      all:               # 这些会传给所有的 restic 命令
        tag: home
      forget:            # 会传给 restic forget 命令，下面的 backup 同理
        keep-last: 15    # 指定保留快照的策略
        keep-weekly: 4
        keep-monthly: 6
        keep-yearly: 2
      backup:
        use-fs-snapshot: true   # 在 Windows 上会用 Windows VSS 打一个临时的分区快照，这样不会受运行的进程占用、写入数据的影响
        exclude-caches: true    # 一些个人的排除选项
        exclude-larger-than: 2G
        exclude:
          - '*/AutoPCH'
          - '*/.vs'
          - '*/Tencent Files'
          - '*/AppData'
          - '*/NTDATA*'
          - '*/OneDrive'

backends:
  external_hdd:
    type: local                          # 本地的源，很直接
    path: 'E:\Backups\UserDirectory_Restic'
    key: ''                              # 您的源的密码，前面 restic init 时设置的，下同
  onedrive_e5:
    type: rclone
    path: 'onedrive_e5:/Backup_UserData' # 注意这里和手动跑 restic 不同，不需要写 rclone:onedrive_e5:/path/xxxxxxxxxxxx 了
    key: ''
  onedrive_nju:
    type: rclone
    path: 'onedrive_nju:/Backup_UserData'#这种写法的意思是，存在这个 OneDrive 空间的 Backup_UserData 文件夹下
    key: ''

```

执行 `autorestic backup --config C:\您的autorestic配置文件路径` 执行全面备份。

#### 填坑

restic 的功能缺失和 bug

restic 有一个 bug 没有解决。在接 rclone 做后端的时候，restic 是开一个子进程并用 stdin/stdout 管道和其进行 HTTP 通信。然而，如果在一个控制台窗口执行 restic，restic 在 Windows 上开子进程的时候，子进程会被挂到亲进程所在的控制台上。在这个控制台上发 Ctrl+C 会把 SIGINT 信号发到所有的挂接的进程上！rclone 接到信号会马上退出，但 restic 在退出的时候不能马上退出，还要删除备份目标上的锁等。

问题就在于，此时 rclone 已经退出、stdio 管道已经关了，restic 的删除指令没法发送。restic 会不断重试，把整个控制台卡住。

同时，restic 有一些我认为应该有而没有的功能，如压缩。但最重要的莫过于自定义数据包文件大小的选项。

restic 的备份方法是把文件拆成小片进行 hash，再把一堆小片打成一个个包传到云上，但默认的包大小是 4M。这对本地备份还好，但对云端备份就是一个灾难 --- 300G 的数据至少要 76800 个文件！ 我调到了 32M，显示出了良好的性能提升。

目前 autorestic 在处理单个源备份到多个储存库的情况时，是通过对同一个源多次执行 backup 命令，每次带不同的 repository 实现的，这对资源的消耗有些大，也不节约时间。

当 restic 被强制结束

如果 restic 出了问题（如网络问题），造成其卡在那里一直运行，那 Windows 任务计划会在 3d（我的配置）后把其强制结束。考虑到 Windows 上没有“优雅”地结束一个纯命令行程序的方法，这个基本就是直接结束进程了。那 restic 就来不及进行清理，造成：存储库上的锁没有释放；Windows 卷影复制服务 (VSS) 没有删除，这会造成 VSS 吃空间、降低性能，锁影响下次运行。

### 远程备份归档 RClone

最佳使用方式见章节 [restic + rclone 实现将快照保存到远程存储]。

Rclone (rsync for cloud storage) 是一个云存储的「通用客户端」命令行程序，用于同步文件和目录。支持常见的 Amazon Drive、Google Drive、OneDrive、Dropbox 等云存储，也支持传统的 ftp/smb/sftp/http。

    https://rclone.org/docs/

    https://blog.csdn.net/qq_34466488/article/details/124381783

    https://p3terx.com/archives/rclone-installation-and-configuration-tutorial.html

    https://p3terx.com/archives/rclone-advanced-user-manual-common-command-parameters.html

    使用 REST API 访问 onedrive https://p3terx.com/archives/rclone-connect-onedrive-with-selfbuilt-api.html

还支持在不同对象存储、网盘间同步、上传、下载数据。可以自动化访问各种云盘进行同步、上传、下载等操作，实现离线下载、服务器备份等非常实用的功能。

一般在 Windows 平台下将 OneDrive 挂载为本地硬盘，并使用跨平台的 Rclone GUI 连接到云盘。

rclone 支持以 mount 挂载的使用方式，非常方便，但是目前不稳定

    Rclone 以挂载方式使用会在本地缓存文件，往挂载盘移动文件只不过是本地转移了位置而已，依然占用着本地磁盘空间，所以当你不断的往挂载盘移动文件，你的本地磁盘就满了，移动文件的过程中内存占用也很大，这可能会导致进程终结和宕机。

    $ rclone mount --daemon MyCloudServer:C:\ Z:

如果是备份到网盘，需要先设置网盘，见下面的两个子章节，然后再设置 rclone。

设置 rclone，以远程存储为单元建立的配置选项

    rclone config - 进入交互式配置选项，进行添加、删除、管理网盘等操作

        名称格式建议 '连接类型_服务器名'

        如果使用 ssh 密钥方式连接，注意选择使用 key_use_agent，否则默认 false。

        如果该 ssh 使用了 2FA，注意选择使用 ask_password，这样在连接时会提示输入验证码。

    rclone config file - 显示配置文件的路径，一般配置文件在 ~/.config/rclone/rclone.conf

    rclone config show - 显示配置文件信息

配置后操作对象就是该远程存储的名称，比如 ssh_rc1

    # https://rclone.org/sftp/
    # 相当于命令行参数 --sftp-pass='943590'
    #   export RCLONE_SFTP_PASS='943590' 无效：对端使用2FA，把验证码设置到环境变量，连接的时候报错无法创建文件系统
    $ rclone -vvv size ssh_rc1:/download

该远程存储的配置文件位于

    $HOME/.config/rclone/rclone.conf

    ```ini
    [ssh_rc1]
    type = sftp
    host = 192.168.0.11
    user = ssss
    known_hosts_file = ~/.ssh/known_hosts
    ask_password = true
    key_use_agent = true
    shell_type = unix
    ```

命令语法

    # 查看可用命令
    rclone --help

    # 本地到网盘
    rclone [功能选项] <本地路径> <网盘名称:路径> [参数] [参数] ...

    # 网盘到本地
    rclone [功能选项] <网盘名称:路径> <本地路径> [参数] [参数] ...

    # 网盘到网盘
    rclone [功能选项] <网盘名称:路径> <网盘名称:路径> [参数] [参数] ...
    rclone move -v /Download Onedrive:/Download --transfers=1

rclone 通常用于同步或复制目录。但是，如果远程源指向一个文件，rclone 将只复制该文件。目标远程必须指向一个目录 -，不然 rclone 将给出为“Failed to create file system for "remote:file": is a file not a directory ”。

例如，假设您有一个远程，其中有一个名为 test.jpg，然后你可以像这样复制那个文件:

    $ rclone copy remote:test.jpg /tmp/download

文件 test.jpg 将被放置在 /tmp/download 下面。

这相当于指定

    # 当 /tmp/files 包含单个 test.jpg
    $ rclone copy --files-from /tmp/files remote: /tmp/download

建议在复制单个文件时使用 copy，而不是 sync。他们有几乎相同的效果，但 copy 将使用更少的内存。

将名为 sync:me 的目录同步到名为 remote: 的远程：

    $ rclone sync ./sync:me remote:path

或者

    $ rclone sync /full/path/to/sync:me remote:path

常用功能选项

    rclone copy     - 复制
    rclone move     - 移动，如果要在移动后删除空源目录，请加上 --delete-empty-src-dirs 参数
    rclone sync     - 同步：将源目录同步到目标目录，只更改目标目录。
    rclone size     - 查看网盘文件占用大小。
    rclone delete   - 删除路径下的文件内容。
    rclone purge    - 删除路径及其所有文件内容。
    rclone mkdir    - 创建目录。
    rclone rmdir    - 删除目录。
    rclone rmdirs   - 删除指定灵境下的空目录。如果加上 --leave-root 参数，则不会删除根目录。
    rclone check    - 检查源和目的地址数据是否匹配。
    rclone ls       - 列出指定路径下的所有的文件以及文件大小和路径。
    rclone lsl      - 比上面多一个显示上传时间。
    rclone lsd      - 列出指定路径下的目录
    rclone lsf      - 列出指定路径下的目录和文件

常用参数

    -n = --dry-run - 测试运行，用来查看 rclone 在实际运行中会进行哪些操作。

    -P = --progress - 显示实时传输进度，500mS 刷新一次，否则默认 1 分钟刷新一次。

    --cache-chunk-size SizeSuffi - 块的大小，默认5M，理论上是越大上传速度越快，同时占用内存也越多。如果设置得太大，可能会导致进程中断。

    --cache-chunk-total-size SizeSuffix - 块可以在本地磁盘上占用的总大小，默认10G。

    --transfers=N - 并行文件数，默认为4。在比较小的内存的VPS上建议调小这个参数，比如128M的小鸡上使用建议设置为1。

    --config string - 指定配置文件路径，string为配置文件路径。

    --ignore-errors - 跳过错误。比如 OneDrive 在传了某些特殊文件后会提示Failed to copy: failed to open source object: malwareDetected: Malware detected，这会导致后续的传输任务被终止掉，此时就可以加上这个参数跳过错误。但需要注意 RCLONE 的退出状态码不会为0。

    rclone 有 4 个级别的日志记录，ERROR，NOTICE，INFO 和 DEBUG。默认情况下，rclone 将生成 ERROR 和 NOTICE 级别消息。

    -q - rclone将仅生成 ERROR 消息。
    -v - rclone将生成 ERROR，NOTICE 和 INFO 消息，推荐此项。
    -vv - rclone 将生成 ERROR，NOTICE，INFO和 DEBUG 消息。
    --log-level LEVEL - 标志控制日志级别。

输出日志到文件

    使用 --log-file=FILE 选项，rclone 会将 Error，Info 和 Debug 消息以及标准错误重定向到 FILE，这里的 FILE 是你指定的日志文件路径。

    另一种方法是使用系统的指向命令，比如：

        $ rclone sync -v Onedrive:/DRIVEX Gdrive:/DRIVEX > "~/DRIVEX.log" 2>&1

文件过滤

    --exclude - 排除文件或目录。

    --include - 包含文件或目录。

    --filter - 文件过滤规则，相当于上面两个选项的其它使用方式。包含规则以 + 开头，排除规则以 - 开头。

文件类型过滤

    比如 --exclude "*.bak"、--filter "- *.bak"，排除所有 bak 文件。也可以写作。

    比如 --include "*.{png,jpg}"、--filter "+ *.{png,jpg}"，包含所有 png 和 jpg 文件，排除其他文件。

    --delete-excluded 删除排除的文件。需配合过滤参数使用，否则无效。

目录过滤需要在目录名称后面加上 /，否则会被当做文件进行匹配。以 / 开头只会匹配根目录（指定目录下），否则匹配所目录。这同样适用于文件。

    --exclude ".git/" 排除所有目录下的.git 目录。

    --exclude "/.git/" 只排除根目录下的.git 目录。

    --exclude "{Video,Software}/" 排除所有目录下的 Video 和 Software 目录。

    --exclude "/{Video,Software}/" 只排除根目录下的 Video 和 Software 目录。

    --include "/{Video,Software}/**" 仅包含根目录下的 Video 和 Software 目录的所有内容。

过滤规则文件

    https://rclone.org/filtering/

命令行使用参数 --filter-from <规则文件> 从文件添加包含 / 排除规则。比如 --filter-from filter-file.txt。

过滤规则文件示例：

    - secret*.jpg
    + *.jpg
    + *.png
    + file2.avi
    - /dir/Trash/**
    + /dir/**
    - *

rclone 中的每个命令行参数都可以通过环境变量设置：

环境变量的名称可以通过长选项名称进行转换，删除 -- 前缀，更改 - 为_，大写并添加前缀 RCLONE_。环境变量的优先级会低于命令行选项，即通过命令行追加相应的选项时会覆盖环境变量设定的值。

比如设置最小上传大小 --min-size 50，使用环境变量是 RCLONE_MIN_SIZE=50。当环境变量设置后，在命令行中使用 --min-size 100，那么此时环境变量的值就会被覆盖。

常用环境变量

    RCLONE_CONFIG - 自定义配置文件路径
    RCLONE_CONFIG_PASS - 若 rclone 进行了加密设置，把此环境变量设置为密码，可自动解密配置文件。
    RCLONE_RETRIES - 上传失败重试次数，默认 3 次
    RCLONE_RETRIES_SLEEP - 上传失败重试等待时间，默认禁用，单位s、m、h分别代表秒、分钟、小时。
    CLONE_TRANSFERS - 并行上传文件数。
    RCLONE_CACHE_CHUNK_SIZE - 块的大小，默认5M，理论上是越大上传速度越快，同时占用内存也越多。如果设置得太大，可能会导致进程中断。
    RCLONE_CACHE_CHUNK_TOTAL_SIZE - 块可以在本地磁盘上占用的总大小，默认10G。
    RCLONE_IGNORE_ERRORS=true - 跳过错误。

#### Rclone 连接 OneDrive

获取 token

在本地 Win­dows 电脑上下载 rclone，然后解压出来，解压后进入文件夹，在资源管理器地址栏输入 cmd，回车就会在当前路径打开命令提示符。输入以下命令：

    rclone authorize "onedrive"

接下来会弹出浏览器，要求你登录账号进行授权。授权完后命令提示符窗口会出现以下信息：

    If your browser doesn't open automatically go to the following link: http://127.0.0.1:53682/auth
    Log in and authorize rclone for access
    Waiting for code...
    Got code
    Paste the following into your remote machine --->
    {"access_token":"xxxxxxxx"}  # 注意!复制{xxxxxxxx}整个内容，并保存好，后面需要用到
    <---End paste

配置 Rclone

输入 rclone config 命令，会出现以下信息，参照下面的注释进行操作。

    e) Edit existing remote
    n) New remote
    d) Delete remote
    r) Rename remote
    c) Copy remote
    s) Set configuration password
    q) Quit config
    e/n/d/r/c/s/q> n  # 选择n，新建
    name> P3TERX   # 输入名称，类似于标签，用于区分不同的网盘。
    Type of storage to configure.
    Enter a string value. Press Enter for the default ("").
    Choose a number from below, or type in your own value
    1 / A stackable unification remote, which can appear to merge the contents of several remotes
    \ "union"
    2 / Alias for a existing remote
    \ "alias"
    3 / Amazon Drive
    \ "amazon cloud drive"
    4 / Amazon S3 Compliant Storage Providers (AWS, Ceph, Dreamhost, IBM COS, Minio)
    \ "s3"
    5 / Backblaze B2
    \ "b2"
    6 / Box
    \ "box"
    7 / Cache a remote
    \ "cache"
    8 / Dropbox
    \ "dropbox"
    9 / Encrypt/Decrypt a remote
    \ "crypt"
    10 / FTP Connection
    \ "ftp"
    11 / Google Cloud Storage (this is not Google Drive)
    \ "google cloud storage"
    12 / Google Drive
    \ "drive"
    13 / Hubic
    \ "hubic"
    14 / JottaCloud
    \ "jottacloud"
    15 / Local Disk
    \ "local"
    16 / Mega
    \ "mega"
    17 / Microsoft Azure Blob Storage
    \ "azureblob"
    18 / Microsoft OneDrive
    \ "onedrive"
    19 / OpenDrive
    \ "opendrive"
    20 / Openstack Swift (Rackspace Cloud Files, Memset Memstore, OVH)
    \ "swift"
    21 / Pcloud
    \ "pcloud"
    22 / QingCloud Object Storage
    \ "qingstor"
    23 / SSH/SFTP Connection
    \ "sftp"
    24 / Webdav
    \ "webdav"
    25 / Yandex Disk
    \ "yandex"
    26 / http Connection
    \ "http"
    Storage> 18  # 选择18，Microsoft OneDrive
    ** See help for onedrive backend at: https://rclone.org/onedrive/ **

    Microsoft App Client Id
    Leave blank normally.
    Enter a string value. Press Enter for the default ("").
    client_id>   # 留空，回车
    Microsoft App Client Secret
    Leave blank normally.
    Enter a string value. Press Enter for the default ("").
    client_secret>   # 留空，回车
    Edit advanced config? (y/n)
    y) Yes
    n) No
    y/n> n  # 选n
    Remote config
    Use auto config?
    * Say Y if not sure
    * Say N if you are working on a remote or headless machine
    y) Yes
    n) No
    y/n> n  # 选n
    For this to work, you will need rclone available on a machine that has a web browser available.
    Execute the following on your machine:
        rclone authorize "onedrive"
    Then paste the result below:
    result> {"XXXXXXXX"}  # 上面保存的token复制到这里
    2018/10/31 19:54:06 ERROR : Failed to save new token in config file: section 'P3TERX' not found
    Choose a number from below, or type in an existing value
    1 / OneDrive Personal or Business
    \ "onedrive"
    2 / Root Sharepoint site
    \ "sharepoint"
    3 / Type in driveID
    \ "driveid"
    4 / Type in SiteID
    \ "siteid"
    5 / Search a Sharepoint site
    \ "search"
    Your choice> 1  # 这里问你要选择的类型，选1
    Found 1 drives, please select the one you want to use:
    0: OneDrive (business)
    Chose drive to use:> 0  # 程序找到网盘，这里编号是0，就选择0
    Found drive 'root' of type 'business', URL: https://xxxxxx-my.sharepoint.com/personal/xxxxxxx/Documents
    Is that okay?
    y) Yes
    n) No
    y/n> y  # 选y
    --------------------
    [P3TERX]
    type = onedrive
    token = {"XXXXXXXX"}
    drive_id = XXXXXXXXX
    drive_type = business
    --------------------
    y) Yes this is OK
    e) Edit this remote
    d) Delete this remote
    y/e/d> y  # 选y
    Current remotes:

    Name                 Type
    ====                 ====
    P3TERX               onedrive

    e) Edit existing remote
    n) New remote
    d) Delete remote
    r) Rename remote
    c) Copy remote
    s) Set configuration password
    q) Quit config
    e/n/d/r/c/s/q> q  # 选q，退出

至此，Rclone 已成功连接到了 OneDrive 网盘。

#### Rclone 连接 Google Drive

与 OneDrive 不同的是，Google Drive 不需要本地 Win­dows 客户端预先进行授权获取 to­ken，而是在配置过程中进行授权。

输入 rclone config 命令，会出现以下信息，参照下面的注释进行操作。

    e) Edit existing remote
    n) New remote
    d) Delete remote
    r) Rename remote
    c) Copy remote
    s) Set configuration password
    q) Quit config
    e/n/d/r/c/s/q> n  # 选择n，新建
    name> Google  # 输入名称，类似于标签，用于区分不同的网盘。
    Type of storage to configure.
    Enter a string value. Press Enter for the default ("").
    Choose a number from below, or type in your own value
    1 / A stackable unification remote, which can appear to merge the contents of several remotes
    \ "union"
    2 / Alias for a existing remote
    \ "alias"
    3 / Amazon Drive
    \ "amazon cloud drive"
    4 / Amazon S3 Compliant Storage Providers (AWS, Ceph, Dreamhost, IBM COS, Minio)
    \ "s3"
    5 / Backblaze B2
    \ "b2"
    6 / Box
    \ "box"
    7 / Cache a remote
    \ "cache"
    8 / Dropbox
    \ "dropbox"
    9 / Encrypt/Decrypt a remote
    \ "crypt"
    10 / FTP Connection
    \ "ftp"
    11 / Google Cloud Storage (this is not Google Drive)
    \ "google cloud storage"
    12 / Google Drive
    \ "drive"
    13 / Hubic
    \ "hubic"
    14 / JottaCloud
    \ "jottacloud"
    15 / Local Disk
    \ "local"
    16 / Mega
    \ "mega"
    17 / Microsoft Azure Blob Storage
    \ "azureblob"
    18 / Microsoft OneDrive
    \ "onedrive"
    19 / OpenDrive
    \ "opendrive"
    20 / Openstack Swift (Rackspace Cloud Files, Memset Memstore, OVH)
    \ "swift"
    21 / Pcloud
    \ "pcloud"
    22 / QingCloud Object Storage
    \ "qingstor"
    23 / SSH/SFTP Connection
    \ "sftp"
    24 / Webdav
    \ "webdav"
    25 / Yandex Disk
    \ "yandex"
    26 / http Connection
    \ "http"
    Storage> 12  # 选择12，Google Drive
    ** See help for drive backend at: https://rclone.org/drive/ **

    Google Application Client Id
    Leave blank normally.
    Enter a string value. Press Enter for the default ("").
    client_id>  # 留空，回车
    Google Application Client Secret
    Leave blank normally.
    Enter a string value. Press Enter for the default ("").
    client_secret>  # 留空，回车
    Scope that rclone should use when requesting access from drive.
    Enter a string value. Press Enter for the default ("").
    Choose a number from below, or type in your own value
    1 / Full access all files, excluding Application Data Folder.
    \ "drive"
    2 / Read-only access to file metadata and file contents.
    \ "drive.readonly"
    / Access to files created by rclone only.
    3 | These are visible in the drive website.
    | File authorization is revoked when the user deauthorizes the app.
    \ "drive.file"
    / Allows read and write access to the Application Data folder.
    4 | This is not visible in the drive website.
    \ "drive.appfolder"
    / Allows read-only access to file metadata but
    5 | does not allow any access to read or download file content.
    \ "drive.metadata.readonly"
    scope> 1
    ID of the root folder
    Leave blank normally.
    Fill in to access "Computers" folders. (see docs).
    Enter a string value. Press Enter for the default ("").
    root_folder_id>  # 留空，回车
    Service Account Credentials JSON file path
    Leave blank normally.
    Needed only if you want use SA instead of interactive login.
    Enter a string value. Press Enter for the default ("").
    service_account_file>
    Edit advanced config? (y/n)
    y) Yes
    n) No
    y/n> n
    Remote config
    Use auto config?
    * Say Y if not sure
    * Say N if you are working on a remote or headless machine or Y didn't work
    y) Yes
    n) No
    y/n> n
    If your browser doesn't open automatically go to the following link: https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=XXXXXXXXXXX.apps.googleusercontent.com&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&state=XXXXXXXXXXXXXXXXXXXX
    Log in and authorize rclone for access  # 会弹出浏览器，要求你登录账号进行授权。如果没有弹出，复制上面的链接到浏览器中打开进行授权。
    Enter verification code>  # 在这里输入网页上显示的验证码

    Configure this as a team drive?
    y) Yes
    n) No
    y/n> y
    Fetching team drive list...
    No team drives found in your account--------------------
    [Google]
    type = drive
    scope = drive
    token = {"access_token":"XXXXXXXXXXXXXXXXXXXXX"}
    --------------------
    y) Yes this is OK
    e) Edit this remote
    d) Delete this remote
    y/e/d> y
    Current remotes:

    Name                 Type
    ====                 ====
    Google               drive
    P3TERX               onedrive

    e) Edit existing remote
    n) New remote
    d) Delete remote
    r) Rename remote
    c) Copy remote
    s) Set configuration password
    q) Quit config
    e/n/d/r/c/s/q> q

至此，Rclone 已成功连接到了 Google Drive 网盘。

### 在当前目录启动一个简单的http服务器

Python 2，使用端口 7777

    python -m SimpleHTTPServer 7777

Python 3，注意包名变了，使用端口 7777

    python3 -m http.server 7777

### 字符终端下的一些小玩具如 figlet、cmatrix 等

    符号字符 https://www.webfx.com/tools/emoji-cheat-sheet/

    unicode编码 http://www.unicode.org/emoji/charts/full-emoji-list.html

    emoji 大全 https://emojipedia.org/

        unicode emoji https://unicode.org/emoji/charts/full-emoji-list.html

        git emoji https://blog.csdn.net/li1669852599/article/details/113336076

给字符渲染颜色 lolcat/aafire

显示天气

    curl -s --connect-timeout 3 -m 5 http://wttr.in/newyork

小火车sl

    sudo apt install sl

水族箱

    asciiaquarium

牛说

    # cowsay
    # cowsay -l
    # echo "Hello world" |cowthink
    # echo "Hello world" |cowsay -f www -d
    sudo apt install cowsay

    格言大全

        sudo apt install fortunes

    随机化选取动物的脚本：

    ```bash
    # https://zhuanlan.zhihu.com/p/81867213
    #!/bin/bash

    function rand(){
        min=$1
        max=$(($2-$min+1))
        echo $(($RANDOM%$max+$min))
    }

    animal=$(ls /usr/share/cowsay/cows | sed 's/\.cow//' | shuf -n 1)
    fortunes[0]='fortune -e fortunes | cowsay'
    fortunes[1]='fortune -e literature | cowsay'
    fortunes[2]='fortune -e riddles | cowsay'
    fortunes[3]='fortune -e chinese | cowsay'
    fortunes[4]='fortune -e tang300 | cowsay -n'
    fortunes[5]='fortune -e song100 | cowsay -n'
    index=$(rand 0 5)
    cmd="${fortunes[$index]} -f $animal | lolcat"
    eval $cmd
    ```

字符画 figlet + toilet

    sudo apt install -y figlet toilet

    # figlet字体位置 /usr/share/figlet
    # 命令 showfigfonts 查看figlet字体

    # 安装 toilet 后，figlet 可使用更好看的 tlf(toilet UTF-8) 字体
    for tlf in $(ls /usr/share/figlet/*.tlf)
    do
        echo -e "$(basename ${tlf} :) \n"
        figlet -f $tlf 12:34:56:78:90:abc:ABC
    done

    钟表

        # watch -n1 "date '+%D%n%T'|figlet -k"
        $ watch -n1 "date '+%D %T'|figlet -f future.tlf -w 80"

        # 温度及钟表：需要尝试0或1 /sys/class/hwmon/hwmon1/temp1_input
        $ watch -n1 "(date '+%T'; (echo 'scale=1;' |tr '\n' ' '; (cat /sys/class/thermal/thermal_zone0/temp |tr '\n' ' '; echo '/ 1000') ) |bc; echo C) |tr '\n' ' '|figlet -f future.tlf -w 80"

字符画 boxes

    https://zhuanlan.zhihu.com/p/52558937

hollywood 让你的 tmux 跑满各种夸张程序，就像好莱坞的科幻电影

    sudo apt install hollywood

    打开了很多小工具，刷太快 cpu 都飙起来了，自己看代码调吧。

        小工具在 /usr/lib/hollywood/ 目录下，主脚本在 /usr/games/hollywood
        https://github.com/dustinkirkland/hollywood

+ matrix 字符屏保

    参考

        https://magiclen.org/cmatrix/
            https://github.com/abishekvashok/cmatrix

    Debian / Ubuntu 安装发行版

        sudo apt install cmatrix

        cmatrix -ba

        Ctrl + c 或 q 退出

    Debian 自编最新版

        下载源代码

            git clone --depth=1 https://github.com/abishekvashok/cmatrix

        安装依赖库

            sudo apt install automake libncurses-dev

        Using configure (recommended for most linux/mingw users)

            autoreconf -i  # skip if using released tarball
            ./configure
            make

            # 不要 sudo make install，尽量打包然后用包管理器安装
            $ sudo make install  # 这样装完了 cmatrix 文件是 root 属组
            make[1]: Entering directory '/pcode/cmatrix'
            /usr/bin/mkdir -p '/usr/local/bin'
            /usr/bin/install -c cmatrix '/usr/local/bin'
            Installing matrix fonts in /usr/share/consolefonts...
            /usr/bin/mkdir -p '/usr/local/share/man/man1'
            /usr/bin/install -c -m 644 cmatrix.1 '/usr/local/share/man/man1'
            make[1]: Leaving directory '/pcode/cmatrix'

        /usr/local/bin/cmatrix -sbau8

    CentOs 需要自行编译

        <https://thornelabs.net/posts/linux-install-cmatrix-from-rpm-deb-xz-or-source.html>

        下载源代码

            git clone --depth=1 https://github.com/abishekvashok/cmatrix

        安装依赖库

            sudo yum install -y gcc make autoconf automake ncurses-devel

        Generate aclocal.m4 man page:

            aclocal

        Generate configuration scripts:

            autoconf

        Generate Makefile.in for configure from Makefile.am:

            automake -a

        Configure, make, and make install the binary:

            ./configure
            make
            sudo make install

Windows 版

    https://www.catch22.net/projects/matrix/
        https://github.com/strobejb/matrix

    https://github.com/OscarL/MatrixSS

类似 cmatrix，实现了电影 Sneakers 里字符效果

    https://github.com/bartobri/no-more-secrets

    把管道传过来的字符变换一番，然后才呈现给你

        ls -l |nms -a

        sneakers

    需要自己编译，如果感觉转换速度太慢，自己改

        $ git clone --depth=1 https://github.com/bartobri/no-more-secrets.git
        $ cd ./no-more-secrets

        $ make nms
        $ make sneakers             ## Optional

        $ sudo make install

### 操作时间 timedatectl/chronyc 及 NTP 服务

目前通用的查看时间控制的命令 timedatectl，来自 systemd 的配套工具。

    验证当前系统时间是否准确，访问如下网址比较你电脑/手机和此网站的差值，同步精确度±5ms，不准就刷新

        https://time.is/

    用 timedatectl 命令操作时间时区  https://www.cnblogs.com/zhi-leaf/p/6282301.html

查看当前时间相关的设置，包括时区、NTP 设置等

    $ timedatectl status
                Local time: 二 2023-08-08 15:30:53 +08
            Universal time: 二 2023-08-08 07:30:53 UTC
                    RTC time: 二 2023-08-08 07:30:53 UTC  <----- RTC 跟 UTC 一致
                    Time zone: Asia/Shanghai (+08, +0800)
    System clock synchronized: yes    <-------- 系统时钟同步正常
                NTP service: active   <-------- 使用 chrony、systemd-timesyncd 等 NTP 服务可以被这个命令识别到
            RTC in local TZ: no

调整时区

    https://docs.fedoraproject.org/en-US/fedora-coreos/time-zone/

    命令方法来自 https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/basic-system-configuration/Configuring_the_Date_and_Time/

    1、先更新下系统，以获取夏令时等最新的时区信息

        $ sudo dnf update -y

        $ timedatectl
                    Local time: Mon 2021-05-17 20:10:20 UTC
                Universal time: Mon 2021-05-17 20:10:20 UTC
                        RTC time: Mon 2021-05-17 20:10:20
                        Time zone: UTC (UTC, +0000)
        System clock synchronized: yes
                    NTP service: active
                RTC in local TZ: no

    2、查找你的时区的标准名称

        $ timedatectl list-timezones |greps sing
        313:Asia/Singapore
        438:Europe/Busingen
        578:Singapore

    3、更改时区

        $ sudo timedatectl set-timezone Asia/Singapore

    老方法：

        $ tzselect

        $ ln -s /usr/share/zoneinfo/Asia/Singapore /etc/localtime

    4、时间变化较大，务必重启一次，防止相关服务错乱

        $ sudo reboot

    时区标准参见章节 [时区标准tzinfo](time_t.md)

设置硬件 RTC 保存时间的标准

    在 Linux 中系统时间受时区、夏令时影响，而硬件时间默认 UTC。当前的系统时间都是计算出来的，读出硬件时间按 UTC 处理然后叠加时区、夏令时，得到最终结果。

    systemd-timesyncd/chrony 等修改时间，只会更改系统时间而不会更改 RTC 硬件时间，即系统时间是根据硬件 RTC 时间和当前时区计算得出的。

    可以改变这个机制，通过 `hwclock` 命令将系统时间（受时区、夏令时影响）同步到硬件时间（默认 UTC）。

        # 以硬件时钟为准，校正系统时钟，默认 --utc
        $ sudo hwclock -s

        # 以系统时钟为准，校正硬件时钟，不使用默认的 UTC 时间，而是本地时间，这样硬件 RTC 保存本地时间
        $ sudo hwclock -w --localtime

    hwclock 命令选项：

        -s, --hctosys     # 将硬件时间同步到系统时间：以硬件时钟为准，校正系统时钟

        -w, --systohc     # 将系统时间同步到硬件时间：以系统时钟为准，校正硬件时钟

    timedatectl 命令也可以实现上面的这两个功能。

    需要改这个标准的场景，常见于 Windows/Linux 双系统的计算机系统时间冲突，因为 Linux 处理 RTC 时间跟 Windows 的机制不同，详见章节 [Linux + Windows 双系统时间差8个小时](Windows 10+ 安装的那些事儿.md)。

修改日期时间：

    $ sudo date -s  "2017-01-23 10:30:00" # "YYYY-MM-DD HH:MM:SS"

    $ timedatectl set-time "2017-01-23 10:30:00" # YYYY-mm-dd HH-MM-SS

另见章节 [虚拟机时间同步的常用方法](virtualization thnik)。

#### NTP 时间同步服务

    NTP 时间同步的原理

        https://learn.microsoft.com/zh-cn/windows-server/networking/windows-time-service/how-the-windows-time-service-works#ntp-algorithms

    网络时间的那些事及 ntpq 详解  https://www.cnblogs.com/GYoungBean/p/4225465.html

    使用 ntpd 配置 NTP https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/7/html-single/system_administrators_guide/index#ch-Configuring_NTP_Using_ntpd

    https://wiki.debian.org/NTP

    https://pan-xiao.gitbook.io/debian/config/ntp

    `ntpstat`

软件包 ntp 过时了：

    以前 Linux 时间同步基本是使用 ntpdate 和 ntpd 这两个工具实现的，其中 ntpd 是步进式平滑的逐渐调整时间，而 ntpdate 是断点式更新时间。

    现在的主流 Linux 发行版，Debian 系一般都使用 systemd 自带的 `systemd-timesyncd`，而 Fedora 系使用 `chrony` 作为默认时间同步工具。而且这些 Linux 发行版都提供了一个默认配置，它指向发行版维护的 NTP 时间服务器。

    推荐 [使用 chrony]。

要自建 NTP 服务器，可以安装 chrony、ntpd，或者 open-ntp，推荐 [使用 chrony]。

> NTP 强制同步

如果发现执行命令 `timedatectl status` 的输出 'System clock synchronized1 值设置为 no（计算机时间的偏差较大常见于虚拟机从休眠中恢复后的时间不准），需要立即调整时间，而不是等待 NTP 服务平滑的慢慢调整：

    NOTE：NTP 服务是平滑式的调整时间，最好不要直接跳变式的设置一个时间,对数据库服务等可能有不利影响，生产环境下慎重！

    # sudo ntpdate -u <NTP 服务器地址>  # 例如 ntp.ubuntu.com
    $ sudo chronyc makestep

还不行就试试重启 NTP 服务，如 chrony 或 systemd-timesyncd

    $ sudo systemctl restart systemd-timesyncd
    $ sudo systemctl restart chronyd

实在不行就重启计算机。

> 配置公共 NTP 服务器

Debian、Fedora 等发行版都有自己的 NTP 服务器，开机后会自动对时，但如果你发现连接困难，可以更换

    https://www.zhihu.com/question/30252609/answer/2276727955

公共 NTP 服务器池

    这些是由社区维护的 NTP 服务器池，支持全球用户：

    pool.ntp.org（自动分配最近的服务器）

    0.pool.ntp.org

    1.pool.ntp.org

    2.pool.ntp.org

    3.pool.ntp.org

根据所在地区选择更近的 NTP 服务器池：

    亚洲：

    NTP 项目亚洲时间服务器，延迟情况不如国内的

    asia.pool.ntp.org

    0.asia.pool.ntp.org

    1.asia.pool.ntp.org

    欧洲：

    europe.pool.ntp.org

    0.europe.pool.ntp.org

    1.europe.pool.ntp.org

    北美：

    north-america.pool.ntp.org

    0.north-america.pool.ntp.org

    1.north-america.pool.ntp.org

    中国：

    NTP 项目国内时间服务器，CERNET 的一堆服务器就在那里面，应该比较靠谱

    cn.pool.ntp.org

    0.cn.pool.ntp.org

    1.cn.pool.ntp.org

知名组织和机构提供的公共 NTP 服务器：

    # Cloudflare
    time.cloudflare.com

    # Google 公共 NTP：

    time.google.com

    time1.google.com

    time2.google.com

    time3.google.com

    time4.google.com

    # 微软公共 NTP：

    time.windows.com

    # 苹果公共 NTP：

    time.apple.com

    time.asia.apple.com

    # NIST 公共 NTP（美国国家标准与技术研究院）：

    time.nist.gov

    time-a.nist.gov

    time-b.nist.gov

    # 不建议使用中国科学院国家授时中心，精度不高，专业的人家有自己的协议，商业的有北斗，对外开放的这个是免费凑合的
    # https://www.cas.cn/tz/201809/t20180921_4664344.shtml
    ntp.ntsc.ac.cn

    # 不要使用国内的这个，自愿自费组织，2023年12月发现 ntp.org.cn 域名都无法访问了
    # cn.ntp.org.cn

    # 教育网
    time.edu.cn

    edu.ntp.org.cn

    # 清华
    ntp.tuna.tsinghua.edu.cn

    # 阿里云还是算了，2023年开始连自己的整个云服务平台都出现崩溃
    ntp.aliyun.com

    ntp1.aliyun.com

    ntp2.aliyun.com

    # 腾讯云

    ntp.tencent.com

> 使用 NTP 服务器的最佳方案

    https://documentation.suse.com/zh-cn/sles/15-SP4/html/SLES-all/cha-ntp.html#sec-net-xntp-netconf

要同步同一网络中的多台计算机的时间，建议不要直接通过外部服务器同步所有计算机。比较好的做法是将其中一台计算机作为时间服务器（它与外部时间服务器同步），其他内网计算机作为它的客户端。将 local 指令添加至该服务器的 /etc/chrony.conf，以将其与权威时间服务器区分开：

    local stratum 10

选择离你地理位置较近的 NTP 服务器可以减少延迟，提高同步精度。

如果需要高精度时间同步，建议使用多个 NTP 服务器作为备份。

查看时间同步源，出现 ^* 表示当前最佳服务器

    $ chronyc sources -v

    .-- Source mode  '^' = server, '=' = peer, '#' = local clock.
    / .- Source state '*' = current best, '+' = combined, '-' = not combined,
    | /             'x' = may be in error, '~' = too variable, '?' = unusable.
    ||                                                 .- xxxx [ yyyy ] +/- zzzz
    ||      Reachability register (octal) -.           |  xxxx = adjusted offset,
    ||      Log2(Polling interval) --.      |          |  yyyy = measured offset,
    ||                                \     |          |  zzzz = estimated error.
    ||                                 |    |           \
    MS Name/IP address         Stratum Poll Reach LastRx Last sample
    ===============================================================================
    ^+ dns1.synet.edu.cn             2  10   377   194   +631us[ +631us] +/-   17ms
    ^- a.chl.la                      2  10   377   124  -7151us[-7151us] +/-   97ms
    ^* time.neu.edu.cn               1  10   377   237  +1129us[+1792us] +/-   16ms
    ^- ntp1.flashdance.cx            2  10   277   372    -24ms[  -24ms] +/-  136ms

查看 NTP 服务器的质量：延迟、偏移

    Windows: w32tm /stripchart /computer:cn.pool.ntp.org

    $ chronyc tracking

Windows 设置时间服务器的地址，在控制面板的时间设置->Internet时间。

#### 使用 chrony

Fedora 等 Redhat 系目前使用这个软件包，它实现了 NTP 协议并且可以作为服务器或客户端

    https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/configuring-time-synchronization_configuring-basic-system-settings

    使用 chrony 套件配置 NTP https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/7/html-single/system_administrators_guide/index#ch-Configuring_NTP_Using_the_chrony_Suite

    https://www.cnblogs.com/pipci/p/12871993.html

    https://wiki.archlinux.org/title/Chrony

    https://idroot.us/change-timezone-fedora-38

安装

    $ sudo apt install chrony

chronyd 是一个在系统后台运行的守护进程。主要用于调整内核中运行的系统时间和时间服务器同步，他根据网络上其他时间服务器时间来测量本机时间的偏移量从而调整系统时钟。对于孤立系统，用户可以手动周期性的输入正确时间（通过chronyc）。在这两种情况下，chronyd 决定计算机快慢的比例，并加以纠正。

    $ systemctl status chronyd
    ● chronyd.service - NTP client/server
        Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; preset: enabled)
        Drop-In: /usr/lib/systemd/system/service.d
                └─10-timeout-abort.conf
        Active: active (running) since Fri 2023-11-10 23:29:16 +08; 3h 38min ago
        Docs: man:chronyd(8)
                man:chrony.conf(5)
        Process: 1245 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
    Main PID: 1303 (chronyd)
        Tasks: 1 (limit: 57594)
        Memory: 8.1M
            CPU: 82ms
        CGroup: /system.slice/chronyd.service
                └─1303 /usr/sbin/chronyd -F 2

服务unit文件： /usr/lib/systemd/system/chronyd.service

监听端口： 323/udp，123/udp

配置文件： /etc/chrony.conf 或 /etc/chrony/chrony.conf，在这里添加你的 NTP 服务器的地址

    # 使用特定的服务器名称或 IP 地址
    server 0.europe.pool.ntp.org

    # 还可以指定池名称，池名称会解析为若干个 IP 地址
    pool pool.ntp.org

    地址列表见章节 [配置公共 NTP 服务器]。

chronyc  - 监控 chronyd 性能和配置其参数的用户界面，它可以控制本机及其他计算机上运行的 chronyd 进程

    $ chronyc tracking
    Reference ID    : 54104921 (tick.ntp.infomaniak.ch)
    Stratum         : 2
    Ref time (UTC)  : Tue Aug 08 07:14:06 2023
    System time     : 0.003024213 seconds fast of NTP time
    Last offset     : -0.000142650 seconds
    RMS offset      : 0.009726741 seconds
    Frequency       : 1.493 ppm slow
    Residual freq   : -0.003 ppm
    Skew            : 4.812 ppm
    Root delay      : 0.192027435 seconds
    Root dispersion : 0.018389940 seconds
    Update interval : 1035.0 seconds
    Leap status     : Normal

#### 使用 systemd-timesyncd

推荐 [使用 chrony]

    systemd-timesyncd 是断点式更新时间，也就是时间不同立即更新，这样会对某些服务产生影响，所以在生产环境尽量不要用，在桌面环境或者是系统刚开机时来进行时间同步还是很好的。

    timesyncd 替代了 ntpd 的客户端的部分。默认情况下 timesyncd 会定期检测并同步时间。它还会在本地存储更新的时间，以便在系统重启时做时间单步调整。

    如果是虚拟机环境，应该把与主机时间同步功能关闭后再启用 systemd-timesyncd，否则可能会有问题.

目前 Debian/openSUSE 使用这个机制，systemd-timesyncd 只实现了简单的 NTP 协议 SNTP，专注于从远程服务器查询然后同步到本地的系统时间，即只是 NTP 客户端。

    `man systemctl status systemd-timesyncd.service`
    `man timesyncd.conf`

    https://www.cnblogs.com/pipci/p/12833228.html

    https://itslinuxfoss.com/sync-time-debian-12/

    https://www.freedesktop.org/software/systemd/man/latest/systemd-timesyncd.service.html

    https://wiki.archlinux.org/title/Systemd-timesyncd

systemd-timesyncd 只能作为客户端，不能作为 NTP 服务器，但如果有多一点的需求，例如你需要连接一个硬件来提供时钟，或要成为 NTP 服务器，可以安装 chrony、ntpd，或者 open-ntp。注意这些 ntp 包只能安装一个，否则会互相干扰。

使用 systemd 自带的时间同步服务 systemd-timesyncd

    # 注意先卸载 ntp 软件包，二者不能共存
    $ sudo apt purge ntp -y

    $ sudo apt install systemd-timesyncd

    $ sudo systemctl start systemd-timesyncd --now

查看服务的状态

    $ systemctl status systemd-timesyncd.service
    ● systemd-timesyncd.service - Network Time Synchronization
    Loaded: loaded (/lib/systemd/system/systemd-timesyncd.service; enabled; vendor preset: enabled)
    Drop-In: /usr/lib/systemd/system/systemd-timesyncd.service.d
            └─disable-with-time-daemon.conf
    Active: active (running) since Sat 2023-01-21 00:14:58 +08; 6 days ago
        Docs: man:systemd-timesyncd.service(8)
    Main PID: 338 (systemd-timesyn)
    Status: "Synchronized to time server for the first time [2406:da1e:2b8:7e32:e92a:3c4b:358e:2dfb]:123 (2.debian.pool.ntp.org)."
        Tasks: 2 (limit: 4915)
    CGroup: /system.slice/systemd-timesyncd.service
            └─338 /lib/systemd/systemd-timesyncd

查看 systemd-timesyncd 同步 NTP 服务器的状态

    $ timedatectl timesync-status
    Server: 2406:da1e:2b8:7e32:e92a:3c4b:358e:2dfb (2.debian.pool.ntp.org)
    Poll interval: 34min 8s (min: 32s; max 34min 8s)
            Leap: normal
        Version: 4
        Stratum: 2
        Reference: 875729E5
        Precision: 1us (-25)
    Root distance: 23.338ms (max: 5s)
        Offset: -406us
            Delay: 95.029ms
        Jitter: 2.817ms
    Packet count: 263
        Frequency: -1.446ppm

配置 NTP 服务器地址修改 /etc/systemd/timesyncd.conf 文件即可，默认虽然 NTP 的选项都处于注释状态，但是 systemd-timesyncd 还是会去默认的 NTP 服务器进行同步

    [Time]
    #NTP=
    #FallbackNTP=0.debian.pool.ntp.org 1.debian.pool.ntp.org 2.debian.pool.ntp.org 3.debian.pool.ntp.org
    NTP=ntp.ubuntu.com pool.ntp.org
    FallbackNTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org

    地址列表见章节 [配置公共 NTP 服务器]

#### Windows加快 NTP 更新频率

Windows 的 NTP 同步时间功能默认每周只同步一次。

如果你的计算机主板时钟连一周的准时都保证不了，或者你的 Windows 虚拟机需要强化时间同步的频率，可以把同步间隔改短：

    Win+R 输入“Regedit”进入注册表编辑器 展开 “计算机\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient” 双击 “SpecialPollInterval” 键值，将对话框中的“基数栏”选择到“十进制”上 对话框中显示的数字正是自动对时的间隔（以秒为单位），比如1天就是 86400，1小时就是 3600，5 分钟是 150。

    在 Parameters 列表中，还可将 “NtpServer” 键值修改为相应服务器的IP地址，然后点击 “确定” 按钮保存。

更细节的调整就是区分慢多少时间算慢了，正常情况下完全没必要改

    运行“gpedit.msc”进入本地组策略编辑器 展开 “本地计算机 策略\计算机配置\管理模板\系统\Windows 时间服务”，双击 “全局配置设置” 选项 “FrequencyCorrectRate”和“PhaseCorrectRate”，以我的理解，“慢工出细活”，所以设置成了1。

    MaxNegPhaseCorrection 和 MaxPosPhaseCorrection 分别控制本地时钟最多快/慢（-/+）多少秒，超过这个范围就会提示时间差过大，请手动调整时间。默认值：172800 秒 MaxPollInterval和MinPollInterval分别控制最大/最小轮询间隔，如果设置的是x，则实际的最大/最小轮询间隔为 秒，默认值分别为10和6，对应1024秒和64秒 就个人有限经验来看，时间误差大的时候，会连续间隔几个小的轮询间隔反复校准；而时间相对准确时，好像是按照最大轮询间隔和前面设置的那个秒数里面较小的为准，但最大轮询间隔数值不整，强迫症可能会有点难受~

### 设置替换命令 update-alternatives

linux 版本历经多年的使用，有些命令会出现各种变体，为保持通用，用符号链接的方式统一进行管理

    update-alternatives --all

设置 vi 的变体

查看实际使用版本

    $ readlink -f `which vi`
    /usr/bin/vim.tiny

设置替换版本

    update-alternatives --config vi

### 压力测试

测试 Linux 的磁盘读写能力，我们可以使用 FIO 来进行

    $ sudo apt install fio

测试顺序读写 10G 的文件，测试结果是大文件读写：

    # fio -filename=test -direct=1 -iodepth 1 -thread -rw=write -ioengine=psync -bs=16k -size=10G -numjobs=1 -runtime=600 -group_reporting -name=write

测试文件顺序读取：

    # fio -filename=test -direct=1 -iodepth 1 -thread -rw=read -ioengine=psync -bs=16k -size=10G -numjobs=1 -runtime=600 -group_reporting -name=read

测试随机写入和读取：

    # fio -filename=test -direct=1 -iodepth 1 -thread -rw=randwrite -ioengine=psync -bs=16k -size=10G -numjobs=1 -runtime=600 -group_reporting -name=write

dd 也可用于做 i/o 速率测试：

    不执行 `sync` 的话，其实是生成数据到内存的速率

        # 测试内存最大写入速率
        $ dd if=/dev/zero of=/tmp/file_01.txt bs=8K count=3000
        3000+0 records in
        3000+0 records out
        24576000 bytes (25 MB, 23 MiB) copied, 0.0136067 s, 1.8 GB/s

        # 测试当前系统的随机数生成能力
        $ dd if=/dev/urandom of=/tmp/file_01.txt bs=8K count=3000
        3000+0 records in
        3000+0 records out
        24576000 bytes (25 MB, 23 MiB) copied, 0.0276212 s, 890 MB/s

    读取到内存后，一次性同步到硬盘的速率

        $ dd if=/dev/zero of=/tmp/file_01.txt bs=8K count=3000 conv=fdatasync
        3000+0 records in
        3000+0 records out
        24576000 bytes (25 MB, 23 MiB) copied, 0.0365097 s, 673 MB/s

    执行时每次都进行同步到硬盘的操作，下例是做了3000次8k写入硬盘

        $ dd if=/dev/zero of=/tmp/file_01.txt bs=8K count=3000 oflag=dsync
        3000+0 records in
        3000+0 records out
        24576000 bytes (25 MB, 23 MiB) copied, 0.280321 s, 87.7 MB/s

    如果要防止硬盘缓存优化，写入量要加大，比如 1 GB 的文件写入速率更客观 bs=64k count=16k

stress-ng 压测 cpu 的著名工具

    # sudo apt install stress-ng
    stress-ng -c 2 --cpu-method pi --timeout 60
    stress-ng -i 1 --timeout 60
    stress-ng -m 1 --timeout 60

    s-tui 是 stress-ng 的命令行前端，用户只需要按键选择即可方便的测试和查看压测情况

        $ sudo apt install s-tui -y
        $ s-tui

```shell
# 简单的脚本用于 cpu 加热，入参是cpu的核心数
#!/bin/bash
# Destription: testing cpu usage performance
# Example    : bash heatcpu.sh 12
# Remark     : cat /proc/cpuinfo | grep "processor"|wc -l    #12==>Get the number of processor
# Date       : 2015-1-12
# update     : 2015-1-12

endless_loop()
{
  echo -ne "i=0;

  while true
  do
    i=i+100;
    i=100
  done" | /bin/bash &
}

if [ $# != 1 ] ; then
  echo "USAGE: $0 <CPUs>"
  exit 1;
fi
for i in `seq $1`
do
  endless_loop
  pid_array[$i]=$! ;
done

for i in "${pid_array[@]}"; do
  echo 'kill ' $i ';';
done

```

### 分析存储空间 df/du

    https://cloud.tencent.com/developer/article/1721037

1、先 df 查看挂载的目录占用情况，主要关注 Avail 段的可用空间

    $ df -h
    Filesystem                    Size  Used Avail Use% Mounted on
    /dev/mapper/dev01-root         75G   58G   14G  82% /
    udev                          2.0G  4.0K  2.0G   1% /dev
    tmpfs                         396M  292K  396M   1% /run
    none                          5.0M     0  5.0M   0% /run/lock
    none                          2.0G  4.0K  2.0G   1% /run/shm
    /dev/sda1                     228M  149M   68M  69% /boot

找出驱动器上占用存储空间最大的前 10 个目录：

    $ sudo su

    # du -sh /*

    # du -a / | sort -n -r |head -n 10

    另外用 du -sh --apparent-size 可以看到实际文件大小，适用于小文件太多占用巨量磁盘空间的分析。

2、如果发现目录下所有文件的大小总和远远低于这个分区已用空间的大小，但是就是找不出占用磁盘最多的那个文件在哪里，那就要怀疑是分区文件系统的 inode 节点满了：

    $ df -ih

    Filesystem     Inodes IUsed IFree IUse% Mounted on
    devtmpfs         5.9M   721  5.9M    1% /dev
    tmpfs            5.9M    54  5.9M    1% /dev/shm
    tmpfs            800K  1.5K  799K    1% /run

如果看到 IFree 段 为 0，会导致该文件系统上无法新建文件，这种情况常见于锁碎小文件特别多的场合，总容量不大但是把 inode 吃光了。

3、文件删除时还被其它进程占用，此时文件并不会真正删除，只是标记为 deleted，只有进程结束后才会将文件真正从磁盘中清除。

    $ sudo lsof | grep deleted

这种情况常见于程序运行过程中对输出文件做删除，比如 nothup.out 或持续写入的日志文件，由于该文件被占用，所以操作系统只能先标记为 deleted，而未真正删除，最后导致磁盘爆满。

所以在shell命令行将任务放到后台时要考虑输出，特别是使用 nohup 命令时，所有的输出都会被不断地添加到同一个文件中，如果该进程不会自己终止，就可能导致输出文件占满整个磁盘。规范的 nohup 命令用法见章节 [nohup]。

### 查看计算机的传感器如温度、风扇

简单看 cpu 温度使用 btop 即可，展示又全面又准确。

hwinfo

    https://github.com/openSUSE/hwinfo

lm-sensors 查看计算机传感器的的内核工具，支持温度、pwm风扇转速等

    https://wiki.archlinux.org/title/Fan_speed_control

    https://www.cyberciti.biz/faq/how-to-find-fan-speed-in-linux-for-cpu-and-gpu/

    # sudo dnf install lm_sensors
    $ sudo apt install lm-sensors

安装后先运行一次 `sudo sensors-detect` 来检测传感器，注意提示，有时候 YES 有时候 yes 有时候按回车（槽！），输错就跳过检测项目了。

然后就可以查看传感器数据了

    $ sensors
    nouveau-pci-0100
    Adapter: PCI adapter
    fan1:           0 RPM
    temp1:        +43.0°C  (high = +95.0°C, hyst =  +3.0°C)
                        (crit = +105.0°C, hyst =  +5.0°C)
                        (emerg = +135.0°C, hyst =  +5.0°C)

    acpitz-acpi-0
    Adapter: ACPI interface
    temp1:        +16.8°C  (crit = +20.8°C)
    temp2:        +16.8°C  (crit = +20.8°C)
    temp3:        +27.8°C  (crit = +105.0°C)

    coretemp-isa-0000
    Adapter: ISA adapter
    Package id 0:  +46.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 0:        +45.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 1:        +45.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 2:        +46.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 3:        +43.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 4:        +43.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 5:        +43.0°C  (high = +100.0°C, crit = +100.0°C)

    nvme-pci-0200
    Adapter: PCI adapter
    Composite:    +46.9°C  (low  = -273.1°C, high = +81.8°C)
                        (crit = +84.8°C)
    Sensor 1:     +46.9°C  (low  = -273.1°C, high = +65261.8°C)
    Sensor 2:     +54.9°C  (low  = -273.1°C, high = +65261.8°C)

看风扇转速，比较新的主板接口统统不支持。。。

    $ sudo pwmconfig

控制风扇转速，不支持主板接口就没有配置文件，啥也干不了

    $ fancontrol

    # 安装成 systemd 服务了
    $ systemctl status fancontrol.service

如果使用桌面环境，还可安装图形化工具 xsensors 来展现这些传感器和风扇

    $ sudo dnf install xsensors fancontrol-gui

水冷都支持 Coolero

    coolero https://gitlab.com/coolercontrol/coolercontrol
        liquidctl https://github.com/liquidctl/liquidctl

    flatpak 安装即可
    $ sudo dnf install coolercontrol
    $ sudo systemctl enable coolercontrold
    $ sudo systemctl start coolercontrold

显卡cpu超频工具

    CoreCtrl https://gitlab.com/corectrl/corectrl

#### 控制笔记本电脑的风扇速度 thinkfan

    Thinkpad

        https://wiki.archlinux.org/title/Fan_speed_control#ThinkPad_laptops

    Dell/Lenovo_Legions/ASUS

        https://wiki.archlinux.org/title/Fan_speed_control#Dell_laptops
        https://wiki.archlinux.org/title/Fan_speed_control#Lenovo_Legions_laptops
        https://wiki.archlinux.org/title/Fan_speed_control#ASUS_laptops

    https://blog.monosoul.dev/2021/10/17/how-to-control-thinkpad-p14s-fan-speed-in-linux/

    https://github.com/vmatare/thinkfan

Enable fan control

    echo 'options thinkpad_acpi fan_control=1' | sudo tee /lib/modprobe.d/thinkpad_acpi.conf

Install thinkfan package

    sudo apt install thinkfan

Create a new thinkfan configuration file

    sudo touch /etc/thinkfan.conf

Put the following lines into /etc/thinkfan.conf

    sensors:
    # GPU
    - tpacpi: /proc/acpi/ibm/thermal
        indices: [1]
    # CPU
    - hwmon: /sys/class/hwmon
        name: coretemp
        indices: [2, 3, 4, 5]
    # Chassis
    - hwmon: /sys/class/hwmon
        name: thinkpad
        indices: [3, 5, 6, 7]
    # SSD
    - hwmon: /sys/class/hwmon
        name: nvme
        indices: [1, 2, 3]
        correction: [-5, 0, 0]
    # MB
    - hwmon: /sys/class/hwmon
        name: acpitz
        indices: [1]

    fans:
    - tpacpi: /proc/acpi/ibm/fan

    levels:
    - [0, 0, 37]
    - [1, 35, 42]
    - [2, 40, 45]
    - [3, 43, 47]
    - [4, 45, 52]
    - [5, 50, 57]
    - [6, 55, 72]
    - [7, 70, 82]
    - ["level full-speed", 77, 32767]

Configure thinkfan to use the newly created file

    echo 'THINKFAN_ARGS="-c /etc/thinkfan.conf"' | sudo tee -a /etc/default/thinkfan

Enable thinkfan service

    sudo systemctl enable thinkfan

Reboot

    sudo reboot

### 控制笔记本电脑切换独显 EnvyControl

    https://github.com/bayasdev/envycontrol

    https://ivonblog.com/posts/linux-envycontrol-turn-off-nvidia-gpu/

### 优化笔记本电脑的电池 tlp

GNOME 和 KDE 主流桌面環境都已內建 PPD(Power Profile Daemon) 來調節耗電量，大部份發行版還會將 TLP 與 PPD 列為衝突套件。再根據 Reddit 的討論認為二者無明顯差距，我便沒有再刻意安裝 TLP

    https://linrunner.de/tlp/

    https://zhuanlan.zhihu.com/p/65546444

    https://ostechnix.com/how-to-optimize-laptop-battery-life-with-tlp-in-linux/

    https://www.jwillikers.com/power-management-on-linux-with-tlp

    竞品 PowerTOP

        https://github.com/fenrus75/powertop

        tlp 文档说比 PowerTOP 好用 https://linrunner.de/tlp/faq/powertop.html

    openSuse 上使用 TLP 管理电源，PowerTOP 仅作为监测工具使用

        https://zh.opensuse.org/SDB:%E7%94%B5%E6%B1%A0%E7%AE%A1%E7%90%86

        https://forum.suse.org.cn/t/topic/13067

TLP的默认配置已针对电池寿命进行了优化，因此你可能只需要安装，然后就忘记它吧。

TLP 是一个具有自动后台任务的纯命令行工具。它不包含GUI，它可以高度定制化，以满足你的特定要求。

TLP 适用于各种品牌的笔记本电脑。设置电池充电阈值仅适用于 IBM/Lenovo ThinkPad

Fedora

    sudo dnf install tlp tlp-rdw

然后卸载有冲突的 power-profiles-daemon 软件包：

    sudo dnf remove power-profiles-daemon

设置开机启动 TLP 的服务：

    sudo systemctl enable tlp.service

您还应该屏蔽以下服务以避免冲突，确保 TLP 的无线设备（蓝牙、wifi等）切换选项的能够正确操作：

    sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket

## 使用 Linux 桌面环境

老老实实用最多人用的 GNOME 吧，其它桌面环境坑更多，随便就有软件运行不起来。

### 常用桌面工具软件

搜索和安装图形化软件的方法，参见章节 [使用 Fedora 软件商店](init_a_server think)。

终端工具的选择，参见章节 [Linux 桌面下的终端模拟器]。

文件管理器 GNOME Files（Nautilus）

    https://www.cnblogs.com/keatonlao/p/12717071.html

    显示隐藏文件的快捷键是 ctrl + h

    地址栏切换为输入模式需要按 ctrl + l ，才能输入或粘贴地址，嫌麻烦直接改注册表

        # https://askubuntu.com/questions/1248692/how-to-get-folder-windows-to-display-address-bars
        $ gsettings set org.gnome.nautilus.preferences always-use-location-entry true

    “打开文件”对话框里粘贴地址没法鼠标操作，直接 ctrl + v 即可

    如果使用 meld，可以添加右键菜单，参见章节 [给资源管理器添加 meld 右键菜单]。

记事本

    没想到 Gnome Text Editor 这么烂，打开时虽然会自动打开上次开着的文件包括未保存状态的文件，但是显示区域不能定位到当前光标位置，粘贴的时候显示区域直接乱跳，正常使用非常难受。推荐安装 LXQT 的 FeatherPad 或 Kde 的 KWrite。白板程序的推荐在下面。

磁盘管理

    gnome Disks

        $ gnome-disks

磁盘占用分析

    gnome Disk Usage Analyzer 分析起来很方便，只是只支持查看当前用户的，查看全系统的需要用命令行

        $ sudo baobab

全系统性能分析，支持火焰图查看各调用栈，功能类似 Windows 的系统性能分析工具

    https://fedoramagazine.org/performance-profiling-in-fedora-linux/

        $ sysprof

办公套件

    LibreOffice 是 GNU/Linux 用户中最流行的办公套件。它的用户界面和用户体验类似于微软 Office。

    ONLYOFFICE 是一款与微软 Office 高度兼容的办公套件应用程序

        https://www.onlyoffice.com/zh/download-desktop.aspx

        ONLYOFFICE 还有一个重磅功能，那就是它的多人协作功能，比如服务器安装使用 Nextcloud，而 ONLYOFFICE 文档我们可以直接通过Docker拉取即可。参见章节 [自建云盘 Nextcloud](rasp think)。

    FreeOffice 包括 TextMaker（可替代 Word）、PlanMaker（可替代 Excel）以及 Presentations（可替代 PowerPoint）。

        https://www.freeoffice.com/en/

    Gnome Evince：支持 pdf 查看

    Okular：主要用于查看 pdf 并添加批注

    calibre：Okular進階版，是電子書閱讀器也是電子書庫管理軟體。

    GNU PSPP：資料統計軟體。IBM SPSS的替代品。

    FreePlane：繪製心智圖。

    XMind【專有軟體】：繪製心智圖，支援上傳到雲端。

    ImageMagick (無圖形界面)：用於圖片轉檔的純文字工具。

    白板程序：可以又写又画，非常适合记笔记

        Rnote 方便的随手笔记

        Xournal++ 这个更重量级一点

        Lorien https://github.com/mbrlabs/Lorien

    番茄时钟：采用番茄工作法，工作分 4 个时段，在每个时段之间休息，在全部 4 个时段之后有一次长时间休息

        Solanum

        Pomodoro

邮件

    Mozilla Thunderbird 支持 gpg 加密

    Gnome Evolution

    ProtonMail
        https://proton.me/mail
            https://zhuanlan.zhihu.com/p/25085337

即时通信

    pidgin 支持各种聊天协议的客户端，甚至可通过插件支持qq/微信

    matrix 服务器列表 https://tatsumoto-ren.github.io/blog/list-of-matrix-servers.html

        https://element.linuxdelta.com/

        https://element.fedibird.com/

        https://webchat.kde.org/

        https://chat.fedoraproject.org/

        https://chat.opensuse.org/

        最次选则才在官网注册 https://matrix.org/

    IRC

        https://zh.opensuse.org/openSUSE:IRC_for_newbies

画图工具

    GIMP 功能几乎与 Adobe Photoshop 相同
        https://www.gimp.org/

    Inkscape 号称替代 Adobe illustrator（AI）的矢量图制作编辑工具
        https://inkscape.org/

    Krita 是一款用于创作像艺术家那样的数字绘画的应用程序。你可以用 Krita 来制作概念艺术、插图、漫画、纹理和哑光画。
        https://krita.org/en/

截屏

    OBS Stduio 是一款用于视频录制和直播推流的开源软件
        https://obsproject.com/

    Shutter

    Kazam

    maim 命令行截图
        https://github.com/naelstrof/maim

        ssh -t pi@<pi_ip_address> 'DISPLAY=:0 maim' >screenshot.png

照片管理

    Nomacs：极简跨平台看圖軟體，可簡單調整圖片，支援批次圖片編輯操作。

    DigiKam：攝影師整理相片的跨平台軟體，類似Adobe Lightroom。自带sqlite数据库缓存缩略图，浏览处理大批量图片的常用功能快速方便，高级功能支持人脸模式、图片搜索除了相似度还支持画图搜索，根据绘画内容检索图片、根据照片信息显示地理位置等。还安装了单独的程序叫 showFoto，不缓存到数据库，功能简单只在界面上可选编辑。

    Gwenview：KDE的看圖軟體，可簡單編輯圖片和加文字，支援讀取壓縮檔的圖片。
    Shotwell：GNOME附屬的相片管理程式。

    Darktable: 照片调色软件

音频编辑器

    Audacity 是一个流行的多轨音频编辑器和录音机，可用于对所有类型的音频进行后期处理。

    Deadbeef 是一个在 HiFi 社区中流行，可自定义的开源音频播放器。

    Audacious 是一个开源的音频播放器。

视频播放

    至2023年，Linux 尚未实现支持 HDR 显示器

        https://wiki.archlinux.org/title/HDR_monitor_support
            https://gitlab.freedesktop.org/xorg/xserver/-/issues/1037#note_521100
            https://gitlab.freedesktop.org/wayland/weston/-/issues/467

    vlc player，建议安装 flatpak 版本，这样闭源的编解码器都自带了，不需要单独安装

        https://www.videolan.org/vlc/index.zh_CN.html
            https://github.com/videolan/vlc

        Fedora: dnf group install 'VideoLAN Client'  # vlc vlc-plugin-ffmpeg vlc-plugin-gstreamer vlc-plugin-pipewire

        插件安装：VLSub，可以搜索下载字幕

        调整字幕时间轴热键 g、h

    mplayer 原生 linux 下的播放器，不提供有效的GUI

        注意：以下播放器依赖操作系统安装h264等编码器，用起来不是开箱即用的，即使 flatpak 版本也不行

        http://www.mplayerhq.hu/design7/info.html
            Windows build
                https://oss.netfarm.it/mplayer/

        MPV player --- mplayer 的新发展

            https://mpv.io/installation/
                https://github.com/mpv-player/mpv/
                https://sourceforge.net/projects/mpv-player-windows/files/

            配置 https://github.com/thisisshihan/mpv-player-config-snad

        smplayer 使用 以上两者做作为播放引擎的 GUI 外壳程序，也支持播放 youtube

            https://www.smplayer.info/
                https://github.com/smplayer-dev/smplayer

    跨平台的高级字幕编辑工具

        Aegisub https://github.com/Aegisub/Aegisub

        Subtitle editor https://github.com/SubtitleEdit/subtitleedit

        gnome 也带一个字幕编辑软件 gnome-subtitles

视频编辑

    Blender 類似 Maya、3DS Max。是一个集动画电影制作、视觉特效、3D 打印、三维/二维建模、动态图形、交互式 3D 应用和 VR 等多项领域为一体的知名开源软件。

        https://www.blender.org/

        优秀作品展示区域，供大家学习交流 https://blender.bgteach.com/index.jsp

    Kdenlive 基于 Qt 和 MIT 多媒体框架开发的非线性视频编辑软件，类似 Adobe premiere 或 Davinci Resolve
        https://kdenlive.org/

    Shotcut 是由 MIT 多媒体框架开发者开发的一款基于 MIT 多媒体框架的非线性视频编辑软件。
        https://www.shotcut.org/

    Autodesk Maya【專有軟體】：專業3D建模軟體。

    FreeCAD：繪製CAD工程圖的軟體。

    Vapoursynth： 视频压缩

图片和视频转换

    XnConvert

    HandBrake

    Fondo：查找和设置Linux桌面壁纸，使用无版权图片网站 Unsplash 作为来源

游戏平台

    Steam：在 steam 的设置中启动 Proton 来游玩 Windows 游戏。

可与命令行交互的图形界面 zenity

    在桌面环境的终端里，执行 shell 脚本时实现弹出式对话框，用户的选择可以用返回值方式被 shell 脚本读取以实现交互，基于 gtk 库实现，需要操作系统有桌面图形化环境

        https://help.gnome.org/users/zenity/stable/

        KDE 桌面项目也有类似的工具——KDialog

            https://develop.kde.org/docs/administration/kdialog/

        https://ostechnix.com/zenity-create-gui-dialog-boxes-in-bash-scripts/

        https://blog.gtwang.org/programming/zenity-gui-utility/

    简单显示消息

        $ zenity --info --text="這是訊息內容" --title="這是標題"

#### Linux 桌面使用浏览器

安全设置

    安装浏览器扩展要谨慎，只安装大家都用的扩展，装完后要设置它的访问权限尽量小，各大浏览器都支持设置。

    浏览器尽量使用容器化、匿名化访问，不同用途的浏览分开，多个虚拟机打开多个浏览器。

    浏览器安装后，最好检查下内置的证书，详见章节 [浏览器 CA 认证面对的挑战](Windows 10+ 安装的那些事儿)

推荐用 flatpak 安装 UngoogledChromium

    来自 Chromium 项目的开源 Web 浏览器，它有一个极简的用户界面。 谷歌已经禁止 chromium 和基于 chromium 的第三方浏览器读取谷歌的数据，所以 chromium 无法同步你原有的谷歌浏览器账户数据，也无法连接谷歌扩展商店，但它有自己的开源扩展商店，也支持本地安装你从 github 下载的开源扩展。

        $ flatpak install flathub com.github.Eloston.UngoogledChromium

    手工下载浏览器官方商店的扩展文件并安装的方法

            https://ungoogled-software.github.io/ungoogled-chromium-wiki/faq#can-i-install-extensions-or-themes-from-the-chrome-webstore

        浏览器打开官方商店的页面，选择下载扩展，然后把下载的 .crx 文件改名为 .zip并解压，然后在 UngoogledChromium 的 Manage Extension 页面点击右上角的 “Develop mode” 按钮，选择 “load unpacked”，选择你刚才解压的目录即可安装该扩展了

    强烈推荐必装扩展：让你可以直接使用浏览器官方商店的扩展 chromium-web-store

        插件设置中，打开 “Allow access to file URLs” 选项。

        安装这个扩展后，打开 ms edge/google chrome 等多个浏览器官方商店的网页，然后可以看到各个扩展的下载按钮都是可用的了，点击即可直接下载安装，不需要上面介绍的手动流程了。如果不可用，点击鼠标右键，选择菜单项目 “Add to Chromium” 即可下载安装。

        先打开设置地址 chrome://flags/#extension-mime-request-handling，设置为 “Always prompt for install”。

        下载 https://github.com/NeverDecaf/chromium-web-store/releases 中的 .crx 文件，然后使用上面介绍的手工安装扩展的方法安装该 .crx 文件。

        访问官方商店页面选个扩展看是否可以直接下载了

            https://microsoftedge.microsoft.com/addons/Microsoft-Edge-Extensions-Home

            https://chrome.google.com/webstore/

        如果只是下载了 .crx 文件没有安装，可以尝试双击该文件，在提示使用哪个程序打开时选择 UngoogledChromium 即可直接安装。之后只要在商店页面点击 get 即可自动下载并安装扩展了。

    其它推荐扩展

        见章节 [安装 Microsoft Edge 浏览器插件](Windows 10+ 那些事儿.md)，各浏览器都是通用的。

        记得设置插件选项，“读取和更改站点数据”配置为“单击扩展时”

GNOME Web

    GNOME 桌面附带的一个基于 WebKit 的浏览器代号 Epiphany，功能比 Firefox 少，但对于普通用途来说已经足够了，而且支持安装火狐和谷歌浏览器的扩展。

FireFox

    中文版的 FireFox 等浏览器由cn公司开发，不要下载安装！

    FireFox 只在 mozila 官方网站下载“英文版”使用，目前各大发行版内置 Firfox 安全性应该等于官方英文版。

    多帐户容器：通过使用容器，你在一个容器中的浏览活动不会与其他容器共享。这种隔离意味着你可以在不同容器中登录同一网站上的两个不同帐户。你的登录会话、网站偏好和跟踪数据将被限制在你使用某个网站的容器中。你的登录会话、网站偏好和跟踪数据将被限制在你使用某个网站的容器中。Firefox 默认情况下提供的容器包括 Facebook、Messenger 和 Instagram 网站，当你打开这三个网站中的任何一个时，它们都只会在 “Facebook 容器” 中打开。因此，Facebook 将无法跟踪你在其他网站上的活动。Firefox 附加组件网站上的 扩展程序页面，找到 “Firefox Multi-Account Containers”。之后你唯一需要做的就是单击 “添加到 Firefox” 按钮。

        注意：你的浏览器历史记录本身之类的内容仍会暴露给你的正常浏览器会话，容器功能只是提供了一种方法来分离登录帐户等内容。

    Firefox 的 “插件”（plugin）和“扩展”（extension）是两种不同的东西：插件以动态库（Windows 上就是 DLL 文件）的方式，加载到浏览器的进程内。扩展可以调用浏览器自身的 API，但是大部分扩展【不能】调用操作系统的 API。

    建议把 Firefox 的缓存指向内存目录，可以大大提升你的浏览感受，见章节 [tmpfs/ramfs 映射内存目录](init_a_server think)。

Chrome

    google 基于开源浏览器 chromium 而搭建的闭源浏览器

    $ flatpak install flathub com.google.Chrome

Tor 浏览器

    通过 Flatpak 安装：

        $ flatpak install flathub com.github.micahflee.torbrowser-launcher

    使用 dnf 安装官方仓库的：

        $ sudo dnf install torbrowser-launcher

##### 浏览器 “UA(User Agent)用户代理” 字符串的故事

    https://imbearchild.cyou/archives/2024/04/yes-browser-are-faking-to-be-firefox/

1、NCSA Mosaic 浏览器，历史上最早的浏览器之一

    NCSA 是（美国）国家超级电脑应用中心的缩写，除了浏览器，他们还开发了 NCSA Telnet 和 NCSA HTTPd，这个 HTTPd 是 Apache HTTPd 的前身。

Mosaic 还是很遵守标准的，他的 UA 长这样：

    NCSA_Mosaic/2.7b6~flatpak4_(X11;Linux 6.6.24 x86_64) libwww/2.12 modified

    这里使用的是以现代 Flatpak 格式重新编译打包的的 Mosaic。

        https://flathub.org/apps/com.github.fries1234.ncsa-mosaic

据说其 Windows 版的 UA 是这样：

    NCSA_Mosaic/2.0 (Windows 3.1)

2、Netscape

Mosaic 的开发者创立了 Netscape 公司，开发 Netscape 浏览器，他们原来想延续 Mosaic 的名字，但是 NCSA 不让，所以新起了一个项目代号，叫“Mozilla”，基本上就是把“Mosaic”和“Godzilla”粘在一起。

他的 UA 是：

    Mozilla/1.0 (Win3.1)

Netscape 开始变得和他的前辈 Mosaic 一样流行。可是 Netscape 与 Mosaic 功能并不一样，于是服务器软件和管理员开始利用 UA 来判断浏览器，并发送兼容的页面。所以，UA 以 Mozilla 开头的浏览器会获得更加高级的网页，因为 Netscape 支持高级特性，反之就是更加简单的网页。

3、Internet Explorer

微软打算插上一脚，他们开发了自己的浏览器，叫 Internet Explorer，并且功能和 Netscape 不相上下。但是，他们觉得没必要等服务器开发者和网络管理员熟悉自己，然后给自己发送高级网页。

相反，他们选择假装自己是 Netscape，所以 UA 是这样：

    Mozilla/1.22 (compatible; MSIE 2.0; Windows 95)

之后的故事几乎是所有微软故事的翻版，垄断然后腐烂，全球人民用着 Internet Explorer 直到 Google Chrome 出现。

4、Firefox Gecko

微软打败了 Netscape，但是 Netscape 成立了 Mozilla 组织借尸还魂。他们开源了 Netscape，重写了不少代码。重写后的渲染引擎叫 Gecko，浏览器叫 Firefox。

当时 Netscape 独立开发的浏览器版本号刚好走到 4.X，于是新的 Mozilla 浏览器套件的版本就变成了 5.0。

所以火狐的 UA 长这样：

    Mozilla/5.0 (X11; Linux i686; rv:2.0.1) Gecko/20101130 Firefox/4.0.1

因为 Gecko 引擎不止 Firefox 一个应用，所以 Firefox/4.0.1 仅代表应用本身的版本，真正的 Gecko 版本在前面的 rv:2.0.1 里面。

直到 Firefox 4 ，他们决定冻结 Gecko/yyyymmdd 为 Gecko/20100101，抛弃了在 UA 写编译日期的奇葩做法。

5、Konqueror KHTML

KDE 开源爱好者开发了自己的浏览器和渲染引擎。KDE 就是 Kool 桌面环境的缩写，然后他们开发的许多东西起名都要与 K 相关。

浏览器叫 Konqueror，渲染引擎叫 KHTML。 Gecko 很好，IE 不好。然后 KDE 觉得自己的 KHTML 与 Gecko 差不多一样好，支持也差不多，他们和微软一样选择假装自己。于是 UA 就变成了：

    Mozilla/5.0 (compatible; Konqueror/3.2; FreeBSD) (KHTML, like Gecko)

6、Safari WebKit

Apple 看了 KHTML，决定拿过来开发自己的浏览器和引擎。

浏览器叫 Safari，引擎叫 WebKit。他们继承了 KHTML 的全部要素，假装自己是 KHTML，加上了自己的部分，于是 UA 就这样了：

    Mozilla/5.0 (Macintosh; U; PPC Mac OS X; de-de) AppleWebKit/85.7 (KHTML, like Gecko) Safari/85.5

7、Chrome Blink

Google 看了 Apple Webkit，决定拿过来开发自己的浏览器和引擎。

浏览器叫 Chrome，引擎叫 Blink。他们继承了 Webkit 的全部要素，假装自己是 Safari，加上了自己的部分，于是 UA 就这样了：

    Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.2.149.27 Safari/525.13

所以 UA 字符串就变成了这么大一块垃圾。

目前现代的浏览器就三个流派

    Blink（Chrome）

    Webkit（Safari）

    Gecko（Firefox）。

套壳浏览器比如现在的 Edge 和现在的 Opera 基本上就是 Chrome 改皮肤，然后 Chrome 假装自己是 Webkit 和 Safari，Webkit 假装自己是 Gecko。

所有人都在假装自己是别人，只有火狐不用假装，因为无论是他的前身 Netscape 还是现在的 Gecko，都是被假装的那个。

#### 操作系统时光机 timeshift

基于快照的备份系统 timeshift

    https://github.com/linuxmint/timeshift

    https://www.makeuseof.com/use-timeshift-backup-and-restore-linux-snapshots/
        https://discussion.fedoraproject.org/t/a-quick-guide-to-setting-up-btrfs-timeshift-on-fedora-33/27573

    https://ivonblog.com/posts/linux-timeshift-usage/

    竞品：基于全盘镜像备份的 cloneZilla

    Redhat 的应急救援盘 ReaR

        https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-relax-and-recover_rear

        https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/assembly_recovering-and-restoring-a-system_configuring-basic-system-settings#doc-wrapper

        https://www.yisu.com/zixun/460393.html

        `rear mkbackup` 命令不只创建救援系统了，还能完整备份操作系统

对标 Windows 系统映像备份或 MacOS 的操作系统备份功能。他会在你指定的硬盘（恢复驱动器）自动用一个目录保留各种安装好的程序和设置。

Timeshift提供時光機一樣的時光倒流功能，方便用戶備份整個Linux系統到另外一個硬碟，並在系統出錯的時候一鍵還原，甚至可以在 LiveUSB 模式修復損壞的系統。Timeshift 界面直觀易用，可以設定自動排程備份，備份檔案預設會壓縮以節省硬碟空間。

Timeshift原理是給目前系統製作快照(snapshot)，並儲存成備份檔。備份檔建議放在其他硬碟，要還原的話比較容易，尤其是系統根本無法開機的狀況下。

> 用Timeshift備份系統

選擇使用快照類型

    RSYNC 快照類型，此選項適用大多數Linux發行版使用的檔案系統。

    BTRFS 屬於較新的檔案系統，只有 Fedora 等少數發行版採用。注意 btrfs 快照需要建立子卷。

選取快照儲存位置

如圖所示，下面容量較大的vda2是我的系統碟，而我要將系統備份到另一個硬碟sda1。請放心，Timeshift的備份不會刪除整個硬碟，而是建立一個timeshift目錄專門放快照檔案。

接著選取多久要自動建立快照。

接著選取是否要備份使用者家目錄檔案，全部打勾。Timeshift不只備份使用者家目錄，連GRUB都一起備份。

點選左上角建立快照

輸入sudo密碼，等待快照製作完成。SSD寫入通常五分鐘就完成了。

從檔案管理員可以看到Timeshift製作的快照，佔用的容量會比原始的系統小一些。當然這邊只是範例，實務上因為要儲存多份快照，用來備份的硬碟容量還是得比系統碟大。

接著我在桌面新增一張相片和文字檔，等會還原系統的時候這些檔案就會不見。

> 用Timeshift還原系統

點選Timeshift的備份檔，點選上方的「還原」。

點選Timeshift的備份檔，點選上方的「還原」。

選取要還原的硬碟

所有選項全部同意，輸入sudo密碼，等待系統還原，接著它會重開機。

重開機後系統回到製作快照前的樣子，桌面的檔案不見了。

### 使用拼音输入法 ibus

    https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/getting_started_with_the_gnome_desktop_environment/assembly_enabling-chinese-japanese-or-korean-text-input_getting-started-with-the-gnome-desktop-environment

确认已经安装了支持中文的字体，详见章节 [设置中文字体]。

确认选择常用的输入法框架：Fcitx 或 IBus

    IBUS https://www.ibus.com/

    Fcitx5  https://fcitx-im.org/wiki/Fcitx_5/zh-cn 之前的是 Fcitx

主流发行版使用 IBUS 框架，比较成熟了，安装简单

> Gnome 桌面环境：

Fedora 可以 打开 Gnome Software， 在类别 'input source' 搜索 'Pinyin' 安装拼音输入法，会自动安装中文字体。

Debian 系 打开 Gnome 的 Settings -> Keyboard -> Input Source，点击添加，选择 “Chinese(Intelligent Pinyin)” ，这时时间栏出会出现en图标，用热键 'Win+空格' 即可切换输入法

    务必勾选 “Switch input sources individually for each window”，这样方便在文件管理器等软件中保持默认英语，支持热键

鼠标点击个可以输入文字的地方，然后切换到拼音输入法，右键点击输入法在时间栏处的“中”字图标，在弹出菜单选择 “Preference”，设置用逗号句号翻页(flip page)等选项。

GTK 程序默认支持表情符号，按热键 ctl + . 或 ctl + ; 会弹出表情符号菜单。

> KDE 桌面环境

1、安装 IBus 及中文输入法

    sudo dnf install ibus ibus-libpinyin  # 智能拼音

2、打开系统设置

KDE 菜单 > 系统设置 > 键盘 > 虚拟键盘：确保已选择 IBus（而非 Fcitx 或 XIM）。

3、添加中文输入法

在时间栏处的 ibus 图标，选择“首选项”，添加输入法，搜索并选择 中文 (Intelligent Pinyin) 或其他中文输入法。

确认后退出设置。

4、重启计算机生效

> 命令行安装ibus中文输入法(Linux/Ubuntu)

1 安装中文语言包

安装中文语言包是为了让 Input Sources 里面出现 Chinese 这一项。

选择 “Manage Installed Languages”-->“Install/Remove Languages”-->“Chinese(Simplified)”-->“Apply”。

2 安装ibus输入法

然后才可以安装 ibus 中文输入法。

先安装 ibus 框架

    sudo apt-get install ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-qt4

切换到 ibus 框架

    # im-chooser
    $ im-config -s ibus

安装拼音引擎

    $ sudo apt-get install ibus-pinyin

3 添加ibus中文输入法

把 ibus 输入法添加到输入法栏。

现在 Input Source 里面就有 Chinese 了，点进去。

选择 Chinese(Intelligent Pinyin)。

右上角选择 Chinese(Intelligent Pinyin)，中英文切换方式就是 shift，Preferences 里面可以选择 7 个选择项。

然后就可以愉快使用 ibus 中文输入法啦。

另一个示例很复杂

    sudo apt install ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-qt4
    im-config -s ibus

    sudo apt install ibus-pinyin ibus-sunpinyin

### 安装 fcitx 输入法框架及输入法

非 Gnome 桌面环境比较复杂，逐步手工操作吧。

    Fedora KDE Plasma 上安装 fcitx5 rime https://www.usmacd.com/cn/fcitx5-rime/#

    Ubuntu22.04安装Fcitx5中文输入法 https://zhuanlan.zhihu.com/p/508797663

    Fcitx 5

        https://github.com/fcitx/fcitx5

    Fcitx 5 配置详解 https://mephisto.cc/tech/fcitx5/

    维基百科中文拼音词库

        https://github.com/felixonmars/fcitx5-pinyin-zhwiki

Fcitx 把自己拆分的比较细：框架、图形界面、中文输入法等，安装时需要分别安装多个包，dnf/flatpak 的版本更新状态未必一致，多试试吧。

Fedora 的软件中心里就有，不过我安装了之后无法激活输入法，去官网主页看说明没搞定。

    Fedora

        $ sudo dnf install fcitx5 fcitx5-configtool fcitx5-chinese-addons

Debian

    $ sudo apt install fcitx5 \
        fcitx5-chinese-addons \
        fcitx5-frontend-gtk4 fcitx5-frontend-gtk3 fcitx5-frontend-gtk2 \
        fcitx5-frontend-qt5

安装中文输入法 fcitx 及 Google 拼音输入法

    $ sudo apt-get install fcitx fcitx-googlepinyin fcitx-module-cloudpinyin fcitx-sunpinyin

    树莓派安装中文输入法-谷歌拼音  https://blog.csdn.net/qq_45478359/article/details/113576252

树莓派 Raspbian 系统默认使用 LXDE，如果 fcitx 和 scim 都没法用，就只能用 ibus。

### 设置中文字体

桌面环境下系统内置的字体中文不好看，需要调整

    https://blog.csdn.net/linuxgroup/article/details/4162867

    https://www.systutorials.com/fedora-%e4%b8%ad%e6%96%87%e5%ad%97%e4%bd%93%e8%ae%be%e7%bd%ae/

    简体中文支持 https://wiki.archlinux.org/title/Localization/Simplified_Chinese

Gnome 环境下安装中文字体比较方便

    Settings-->Region & Languaes，点击添加 Language，勾选 Chinese 即可

Gnome 的图形界面设置程序 Gnome Tweaks Tool(gnome-tweaks) 有 “Font” 选项卡，可以给界面和文本分别设置不同的字体，但不支持按三种风格分别设置字体及回落选项

    在 “Hinting”（渲染微调）选项建议勾选 “Full” 拉高字体，否则显得扁

    对等宽字体，如果感觉系统的太丑，可以选用 “Noto Serif Mono Regular”。

    也可使用命令：

        # 查询桌面环境使用的字体
        $ gsettings get org.gnome.desktop.interface font-name

        # 设置桌面环境的字体
        $ gsettings set org.gnome.desktop.interface font-name 'Cantarell 10'

单一调整桌面环境的字体设置，比如选择使用中文字体，则对英文字符的显示会默认使用该字体内置的英文字体。

而我们最需要的，是类似 MS Word 这样的，可以让用户明确指定一篇文章里的中、英文字体。利用 Windows、Linux 都默认支持的字体回落机制，选择多个中英文字体，使得显示英文使用一种字体，显示中文使用另一种字体，详见章节 [使中英文分别使用一种字体]。

#### 前置知识：界面上的字体到底是怎么显示的

    https://zhuanlan.zhihu.com/p/32961737

根据印刷专业的区分方法，字体可以分别设置三种风格：

    sans

    serif

    mono

操作系统如 Windows、Linux，office/firefox 等软件都支持设置三种风格的字体，且每种风格都可以设置多个字体（前一个未找到就用下一个，所谓“回落”）

    在西方国家的罗马字母阵营中，字体分为两大种类：Sans Serif 和 Serif

    Serif 的意思是有衬线，即文字带笔锋，来自自然的手写形态。比如 Times New Roma、仿宋体、楷体，中规中具适合正文阅读，Windows 在文字处理软件中使用 Serif 风格的字体。Serif 是现代印刷行业最初的字体风格。

    Sans 在古希腊语中是 without 的意思，现在英语里面也有这个词。Sans Serif 指没有额外的装饰，笔划粗细大致差不多，比如 Tahoma、黑体、幼圆，用于报纸标题、标语等醒目场合，Windows 在窗口的标题栏等位置就使用 san 风格的字体。宋体 是明代为适应木版印刷的木纹特点发明的横细竖粗的字体，笔划粗壮，也归类在 sans 类。Sans Serif 是现代点阵打印机、电子屏幕流行后为适应点阵化的显示出现的字体风格。

    Monospace 等宽字体：近代在机械打字机出现后，针对打字机的特点单独类，虽然也属于 Sans Serif，但由于是等宽字体，所以细分出了 Monospace 这一种类。，比如 Courier New、Consolas，适合会计数字、编程写代码等格式严谨上下行的字符严格对齐的场合。

很多文字处理程序有自己的字体配置，至少三种归类：无衬线字体 sans-serif, 衬线字体 serif, 等宽字体 monospace, 就会遵循 fontconfig 的设置了。甚至 Firefox 浏览器也可在 about:config 中针对这三种风格分别设置字体，但是大多数软件都自动处理这些细节不让用户自行设置。

对东亚字符 CJK 来说，这三种风格的字体又按字符集细分出支持简体中文 SC、繁体中文 TC、日文 JP、韩文 KR 的分支。有些异体字（Variable Font）在三种文字中都有，需要统一设计方案，使得一个字体即可显示多国的文字。

#### 前置知识；字体文件的格式

    https://www.ottoli.cn/study/fonts

字体文件的格式跟印刷和显示器行业的发展紧密关联。

PostScript Type 1

    1970年代，西方的字体业界正在从照相排版（Photocomposition）转移到数码排版（Digital Publishing）。彼时技术非常不成熟，无论是行将就木的照排机，还是方兴未艾的电脑，印刷效果都非常差。

    在 PostScript 出现之前，打印机多以点阵形式实现，也就是一种位图格式。有点类似于现在我们经常见到的各种购物小票或者电影票，喵喵机打印的也是这种点阵字符。这种打印方式打印的字符很不清晰，特别是放大后总是出现锯齿。

    PostScript 是 Adobe 公司在 1984 年开发的页面描述语言。我们现在熟知的 PDF、XPS、SVG 都是同类型的东西。同时它也是个完备的编程语言，用函数的方式描述原本用点阵形式呈现的字符，实现了计算机时代任意球放大缩小字符都不会导致字体显示出现锯齿的效果。Type 1 是作为PostScript的一部分出现的一个配套字体文件，一般由 *.pfm，*.pfb，*.afm，*.inf 四个文件组成。

TrueType

    苹果公司为了对抗 Adobe 开发的 PostScript Type 1 字体，开发了 TrueType 字体。后来，微软也加入了 TrueType 的开发。相对于商业封闭严密的 PostScript 字体，TrueType 技术规范全部公开，不收取一分钱的授权费（No royalty）。TrueType 随后成为了应用最广泛的屏幕显示字体格式。TrueType 字体文件在 Windows 中的格式为 .ttf（TrueType Fonts）或 .ttc（TrueType Collection），在 MacOS 中为 .dfont。

    Hinting（渲染微调）是为了防止在显示时出现的字体走形的修正程序，TrueType 对于字体中的每一个字符（glyph），都有一套与之相对应的 hint。这样看来，一套一套的 hint 就相当于高德纳 Metafont 中的一个个小程序。

OpenType 标准将是未来字体显示技术的主流

    微软还在1994年开发了一个叫“智能字体”（TrueType Open）的技术，两年后与 Adobe 的 Type 1 技术合并，共同开发了新一代字体格式 OpenType，用来代替 TrueType 的地位。再之后，苹果和谷歌也陆续加入了 OpenType 的开发。

    OpenType 向下兼容 TrueType 以及 PostScript 字体，扩展名可能为 .otf、.otc、.ttf、.ttc 等。使用 PostScript 曲线的 OpenType 字体格式为 .otf、.otc，使用 TrueType 曲线的格式为 .ttf、.ttc。

    OpenType 字体编码基于万国码（Unicode），可以支持任何文本，或者同时支持多种文本。一个 OpenType 字体可以带有最多 65,536 个字形，基本满足绝大多数地区的使用需求，OpenType 拥有良好的跨平台兼容性，能够在 Mac OS，Windows 和一些 Unix 系统中进行设置。

    基于 TrueType 的 OpenType 字体使用 .ttf 扩展名

    基于 PostScript 的 OpenType 字体使用 .otf 扩展名

    .otc 是字体合集（OpenType Collection）它是一个集成文件，在一单独文件结构中包含多种字体，OTC 字体安装后在字体列表中会看到两个以上的字体。当两个字体中大部分字都一样时，为共享笔划数据，可以将两种字体做成一个 OTC 文件，以便更有效地共享轮廓数据。主要是为了适应多种字体共享同一笔画，区别只是字符宽度不一样，以适应不同的版面排版要求，这时 OTC 技术可有效地减小字体文件的大小。而 OTF 字体则只包含一种字型。

        https://www.zhihu.com/question/24639343

        对于大陆地区的一般用户而言，选择 OTF 版本的字体能够满足界面字体、一般排版等需求了。而使用 InDesign、具有要求的用户，则可以使用 OTF 或 OTC 版本。在不支持多语言功能的程序中，要进行多语言排版，则要安装所要用语言的地区子集。

    .ttc（TrueType Collection），它是 TrueType 字体曲线的集成文件(. TTC文件)，目前操作系统对 OTF 的支持还不完善，会使用 ttc 格式的字体文件

OpenType 可变字体（OpenType variable fonts）技术

    https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Fonts/Variable_Fonts_Guide

    https://mp.weixin.qq.com/s?__biz=MzA3MjM1MDUzMQ==&mid=2660341229&idx=1&sn=362723b69ae82aedd87689a5ab4b4c3a&chksm=847a9bc1b30d12d7e94a1d287dbe0774a3dd9405128ca4fb562f60d36d2b0260061d3798f51f&scene=21#wechat_redirect

为了在一个单纯正文展示的页面中使用一个字体，你至少需要四个字体文件：常规Regular、斜体Italic、加粗Bold、斜体加粗Bold Italic。如果你想添加更多的字重，比如让题注更轻或让额外强调的地方更重，意味着你需要更多文件。

可变字体属于 OpenType 字体规范上的演进，能够储存轮廓变化数据，在初始字形轮廓的基础上自动生成丰富的变化造型，允许在一个字体文件中包含多种字重（Weight）和样式（Style），而不是为每种字重和样式单独提供文件。从而无需再将不同字宽、字重或不同样式的字体分割成不同的字体文件。高德纳（Donald Knuth）当年用 Metafont 创立的曲线自动调整技术发扬光大，无级字重成为现实。

可变字体是一种新型字体格式

#### 安装官方仓库的中文字体包

    https://blog.lilydjwg.me/2023/3/5/linux-fonts.216591.html

    除了中文字体，还可以安装符号字体用于编程和控制台显示，见章节 [图标字体]

> 对版本比较老的不支持中文的 Linux

早些年还没有 Noto 和思源的时候，Linux 系统上通常使用文泉驿正黑或者文泉驿微米黑。后者是基于 Android 系统上的 Droid Sans Fallback 字体，体积较小。再之前是文鼎系列字体，也就是名字「AR PL」开头、包名叫 ttf-arphic-{uming,ukai} 的那些。

    先安装中文字体

        # uming 和 ukai字体，即 AR PL UMing CN 等
        $ sudo dnf install cjkuni-ukai-fonts cjkuni-uming-fonts

    然后使用该配置即可 https://github.com/zma/config_files/blob/master/others/local.conf

    上述配置文件对于 sans-serif 字体会首选 Libration Sans，如果无法显示那么会使用 AR PL UMing CN 字体。这样英文字体使用 Libration Sans 正常显示。而对于中文字体，由于 Libration Sans 中没有中文字体，实际使用 AR PL UMing CN 字体显示。这样就实现了显示中英文的 sans-serif 字体实际是不同的两种字体类型中的 Sans 字体。

> 主流 Linux 发行版使用 Noto 字体内置支持中文

Fedora 系统默认的 Cantarell 字体支持显示中文，从 Fedora 36 开始使用新的字体 Noto Fonts 来覆盖所有语言（或尽可能多的语言），但需要用户单独安装设置 [https://fedoraproject.org/wiki/Changes/ImproveDefaultFontHandling#Detailed_Description]。

Noto 系列字族名只支持英文，命名规则是 Noto + Sans 或 Serif + 文字名称。其中东亚字符部分叫 Noto Sans/Serif CJK SC/TC/HK/JP/KR，词 CJK 表示东亚字体中日韩，最后一个词是地区变种。

支持汉语的 Noto Fonts 字体拆出来单独的 cjk 包，按关键字搜索可得：

    $ dnf list --installed |grep noto|grep cjk
    google-noto-sans-cjk-vf-fonts.noarch
    google-noto-sans-mono-cjk-vf-fonts.noarch
    google-noto-serif-cjk-vf-fonts.noarch

注意 Fedora 默认使用 .ttc 格式而不是 .ttf 格式。

其实这个开源中文字体就一套，只是同时被 Noto 和思源两个项目收录

    Noto 系列字体是 Google 主导的，名字的含义是「没有豆腐」（no tofu），因为缺字时显示的方框或者方框被叫作「tofu」。

    思源系列字体是 Adobe 主导的。其中汉字部分被称为「思源黑体」和「思源宋体」，是由这两家公司共同开发的，两个字体系列的汉字部分是一样的。

Noto 字体在 Arch Linux 上位于以下软件包中：

    noto-fonts: 大部分文字的常见样式，不包含汉字

    noto-fonts-cjk: 汉字，中日韩三国字体

    noto-fonts-emoji: 彩色的表情符号字体

    noto-fonts-extra: 提供额外的字重和宽度变种

思源字体在 Arch Linux 上位于以下软件包中：

    adobe-source-sans-fonts: 无衬线字体，不含汉字。字族名叫 Source Sans 3 和 Source Sans Pro，以及带字重的变体，加上 Source Sans 3 VF

    adobe-source-serif-fonts: 衬线字体，不含汉字。字族名叫 Source Code Pro，以及带字重的变体

    adobe-source-code-pro-fonts: 等宽字体，不含汉字。字族名叫 Source Code Pro，以及带字重的变体，加上 Source Code Variable。

    adobe-source-han-{sans,serif,mono}-{cn,hk,jp,kr,tw}-fonts: 五个地区的汉字之黑体、宋体和等宽版本

    adobe-source-han-{sans,serif,mono}-otc-fonts: 所有地区合体了的汉字之黑体、宋体和等宽版本

    思源汉字字体的字族名有两种，「独立包装」的版本（非 OTC 版本），是「Source Han Sans/Serif」或本地化名称、空格、地区代码（CN/HK/TW/JP/KR）。比如「思源黑体 CN」、「源ノ角ゴシック JP」等。也有带字重的别名。

    而全部打包的 OTC 版本，字族名是本地化名称或者英文的「Source Han Sans/Serif」空格再加上「HC/TC/HC/K」变种代码。如果没有变种代码，则是日文变种。为了区分，香港繁体的版本附带「香港」字样，比如黑体叫「思源黑體 香港」。这些字体也有不同字重的别名。另外有个半宽的版本，是在字族名的变种代码前加「HW」字样，仅有少数几个字符是半宽的。

    OTC 版本有趣的地方在于，对于大多数软件来说，不管你叫它的哪个地区的名字，它都会以设定的语种来显示。比如网页声明语种为日文（<html lang=ja>），那么不管字体指定为「源ノ角ゴシック」还是「思源黑体」或者「본고딕」，它都会「门上插刀、直字拐弯、天顶加盖、船顶漏雨」。所以用这个字体的话，不妨一律写「Source Han Sans」，然后加好语种标记。我知道的唯一例外是 mpv 的 ass 字幕文件，里边指定本地化名称的话，会使用那个语种的变体显示。

在 Gnome Software 的首页分类里，就可以安装选择中文字体

    Localization--> Simplified Chinese 有两个：

        Localization support：给内装软件添加中文字体、中文语言包，包括默认输入法

        Core Localization support：内核级的如 glibc 库的中文版，这样连命令行提示都会显示中文

        注意这个是全界面的汉化，等同于你在系统设置的 Language 选择了 中国-中文

    font：单独选择安装你需要的中文字体

也可在以下页面下载手工安装，目录树选 ttf -> 简体中文

    https://github.com/notofonts/noto-cjk/blob/main/Sans/README.md

    https://github.com/notofonts/noto-cjk/blob/main/Serif/README.md

    说明 https://aur.archlinux.org/packages/noto-fonts-cjk-vf

    手工安装自行下载的字体的方法参见章节 [Nerd font]。

    添加中文输入法见章节 [使用拼音输入法]。

也可以在命令行安装，安装完成后都是 .ttc 字体

    Sans Serif 字体包：

        $ dnf search google-noto-sans-cjk
        google-noto-sans-cjk-fonts.noarch : Google Noto Sans CJK Fonts <---- 全部cjk字体 OTF 文件打包
        google-noto-sans-cjk-hk-fonts.noarch : Traditional Chinese Multilingual Sans OTF font files for google-noto-cjk-fonts
        google-noto-sans-cjk-jp-fonts.noarch : Japanese Multilingual Sans OTF font files for google-noto-cjk-fonts
        google-noto-sans-cjk-kr-fonts.noarch : Korean Multilingual Sans OTF font files for google-noto-cjk-fonts
        google-noto-sans-cjk-sc-fonts.noarch : Simplified Chinese Multilingual Sans OTF font files for google-noto-cjk-fonts  <---- 仅简体中文
        google-noto-sans-cjk-tc-fonts.noarch : Traditional Chinese Multilingual Sans OTF font files for google-noto-cjk-fonts
        google-noto-sans-cjk-ttc-fonts.noarch : Sans OTC font files for google-noto-cjk-fonts  <---- 仅简体中文的 OTC 格式打包
        google-noto-sans-cjk-vf-fonts.noarch : Google Noto Sans CJK Variable Fonts <---- 变体字包，文件小，不知为啥报告跟前面的 otf 包冲突。

    Serif 字体包：

        $ dnf search google-noto-serif-cj
        google-noto-serif-cjk-fonts.noarch : Google Noto Serif CJK Fonts  <---- 全部cjk字体 OTF 文件打包
        google-noto-serif-cjk-jp-fonts.noarch : Japanese Multilingual Serif OTF font files for google-noto-cjk-fonts
        google-noto-serif-cjk-kr-fonts.noarch : Korean Multilingual Serif OTF font files for google-noto-cjk-fonts
        google-noto-serif-cjk-sc-fonts.noarch : Simplified Chinese Multilingual Serif OTF font files for google-noto-cjk-fonts  <---- 仅简体中文
        google-noto-serif-cjk-tc-fonts.noarch : Traditional Chinese Multilingual Serif OTF font files for google-noto-cjk-fonts
        google-noto-serif-cjk-ttc-fonts.noarch : Serif OTC font files for google-noto-cjk-fonts  <---- 仅简体中文的 OTC 格式打包
        google-noto-serif-cjk-vf-fonts.noarch : Google Noto Serif CJK Variable Fonts <---- 变体字包，文件小，但是跟前面的 otf 包冲突，且其otc 文件不一定所有软件都支持

我的 Fedora 38 发行版在安装了中文输入法后自动安装了 Noto Sans CJK，但没有 Noto Serif CJK，手动安装下

    # https://fedoraproject.org/wiki/Changes/Noto_CJK_Variable_Fonts#Detailed_Description
    # 所有字体的完整版：google-noto-cjk-fonts
    # Serif 合集：google-noto-serif-cjk-fonts 是 OTF 文件打包，google-noto-serif-cjk-ttc-fonts 是 OTC 格式打包
    #   也可以只安装简体中文 google-noto-serif-sc-fonts
    # $ sudo dnf install google-noto-serif-cjk-fonts
    #
    # Fedora 支持异体字（Variable Font），装这个最省事，文件还小
    $ sudo dnf install google-noto-serif-cjk-vf-fonts
    $ sudo dnf install google-noto-sans-cjk-vf-fonts

    mono 不用单独安装，sans 字体自带了

adobe 思源跟 Google Noto 这俩字体是一回事

    https://github.com/adobe-fonts/source-han-sans

#### 设置中英文分别使用一种字体 fontconfig

    用 fontconfig 治理 Linux 中的字体 https://catcat.cc/post/2021-03-07/

    Linux fontconfig 的字体匹配机制 https://catcat.cc/post/2020-10-31/

    示例 https://github.com/rydesun/myconf/tree/master/.config/fontconfig

    https://www.jinbuguo.com/gui/linux_fontconfig.html

    https://www.insidentally.com/articles/000036/

Fedora 36 开始通过使用新的字体 Noto Fonts 来覆盖尽可能多的语言 <https://fedoraproject.org/wiki/Changes/ImproveDefaultFontHandling#Detailed_Description>，但其默认的 Cantarell 字体显示中文太丑了，需要手工改设置，利用“回落”使得中英文分别使用不同的字体。

需要手工设置操作系统针对三种风格的默认字体，对英文使用系统默认的英文字体，对中文回落到 Google 的开源字体：

    Sans --> 思源黑体（Source Han Sans/Noto Sans CJK），自带 mono 风格了

    Serif --> 思源宋体（Source Han Serif/ Noto Serif CJK）

    其实思源中文字体也内置了西文，只设置该中文字体也可以，但其西文部分使用的是 Adobe Source 家族字体不大好看我们不去使用它（思源黑体集成 Source Sans Pro、思源宋体集成 Source Serif，详见 <https://sspai.com/post/38705>）。

查看字体效果的工具

    GNOME Character Map --- 原名 gucharmap ，可以检查所有字符使用指定的字体时的渲染效果，以及它回落到什么字体上了。找到要查看的字符，然后对着它按住右键即可。

    Fonts Tweak Tool(fonts-tweak-tool) 可以直观的预览中文字体的效果，而且可以设置更多的 truetype 选项，支持按三种风格分别设置字体及回落选项

        https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/desktop_migration_and_administration_guide/configure-fonts#substitute-font

        $ sudo dnf install fonts-tweak-tool

##### 使用 fontconfig 软件配置字体回落

Linux 操作系统一般都内置 fontconfig 软件包选择字体，默认无需用户干预

    https://www.freedesktop.org/software/fontconfig/fontconfig-user.html
        https://www.freedesktop.org/wiki/Software/fontconfig/

    https://wiki.archlinux.org/title/Font_configuration

列出当前系统安装的字体文件

    $ fc-list : file

显示当前系统安装的中文字体

    $ fc-list :lang=zh

该命令还会列出该字体支持的浓淡，比如 “Noto Serif CJK SC:style=Black”，则设置字体时可以选择 “Noto Serif CJK SC Black”，这样字体会加重类似黑体的效果。

测试自己的选择是否能够匹配，可以运行：

    $ fc-match "Noto Sans CJK SC"
    NotoSansCJK-VF.ttc: "Noto Sans CJK SC" "Regular"

    $ fc-match "Noto Serif CJK SC"
    NotoSerifCJK-VF.ttc: "Noto Serif CJK SC" "Regular"

    $ fc-match "Noto Serif CJK SC Black"
    NotoSans[wght].ttf: "Noto Sans" "Regular"

查看配置后的最终字体选择

    $ fc-conflist

查看针对指定字符的字体优先顺序

    # 534E 是「华」字的 Unicode 码点之十六进制值，如果不加 -s 就是看指定的模式会匹配上的字体了
    $ fc-match -s :charset=534E

    # 查看在语种为日文的时候，使用 serif 字族名会使用哪个字体来显示「华」字
    $ fc-match serif:charset=534E:lang=ja

    # 查看包含「华」字的所有字体
    $ fc-list :charset=534E

fontconfig 支持字体的回落（fallback），可以实现中英文分别使用不同的字体，但需要用户手工配置，但是配置文件的位置比较乱：

    设置 /etc/fonts/local.conf 文件，这是最初的实现，各大发行版都支持这个配置方式。

    随着发行版的演进，又开始使用 /etc/fonts/fonts.conf，这是更符合 XDG 规范的用法

        建立文件 fonts.conf

            系统级在 /etc/fonts/conf.d/ 下

            用户级在 ~/.config/fontconfig/conf.d 下

            其实应该是 $XDG_CONFIG_HOME 指向 $HOME，但目前 Gnome 等桌面环境好像都不设置这个变量。

        但是，截止 2025 年 Fedora 41 上仍然只能使用 /etc/fonts/local.conf 文件。

下面的示例是最初的格式，目前仍然可以直接使用：

```xml
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
 <!--
    Begin user preferred fonts config:
    Created by: Eric Zhiqiang Ma (zma [at] ericzma.com)
    https://github.com/zma/config_files/blob/master/fonts/local.noto.conf
    To use this, put it into /etc/fonts/local.conf for system wide configuration
    or ~/.fonts.conf for user-specific configuration
 -->
 <!--
  Preferred fonts:
    Noto fonts
    liberation fonts (for Monospace fonts)
 -->
 <!--
  Serif faces
 -->
 <alias>
  <family>serif</family>
  <prefer>
   <family>Noto Serif</family>
   <!-- 我的 Fedora 下中文太轻，用加深的 Black-->
   <family>Noto Serif CJK SC Black</family>
   <family>Noto Serif CJK TC</family>
   <!--
   <family>Source Han Sans CN Normal</family>
   <family>Source Han Sans TWHK Normal</family>
   -->
  </prefer>
 </alias>
 <!--
  Sans-serif faces
 -->
 <alias>
  <family>sans-serif</family>
  <prefer>
   <family>Noto Sans</family>
   <family>Noto Sans CJK SC</family>
   <family>Noto Sans CJK TC</family>
   <!--
   <family>Source Han Sans CN Normal</family>
   <family>Source Han Sans TWHK Normal</family>
   -->
  </prefer>
 </alias>
 <!--
  Monospace faces
 -->
 <alias>
  <family>monospace</family>
  <prefer>
   <family>Liberation Mono</family>
   <!-- 我的 Fedora 下中文mono的字符间距太大，还是用去掉 Mono 字样的普通的Sans即可-->
   <family>Noto Sans CJK SC</family>
   <family>Noto Sans CJK TC</family>
   <!--
   <family>Source Han Sans CN Normal</family>
   <family>Source Han Sans TWHK Normal</family>
   -->
  </prefer>
 </alias>
</fontconfig>
```

把格式改造的更规范，这个是新的兼容旧的规范：

    <alias> 转换为 <match> + <test> + <edit>：

        每个 <alias> 块被转换为一个 <match> 块。

        <family> 标签的内容被移动到 <test> 和 <edit> 中。

    <prefer> 转换为 <edit>：

        <prefer> 中的字体列表被移动到 <edit> 的 mode="prepend" 中。

        mode="prepend" 表示将这些字体插入到匹配结果的最前面。

```xml
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
 <!--
    Begin user preferred fonts config:
    Created by: Eric Zhiqiang Ma (zma [at] ericzma.com)
    https://github.com/zma/config_files/blob/master/fonts/local.noto.conf
    To use this, put it into /etc/fonts/local.conf for system wide configuration
    or ~/.fonts.conf for user-specific configuration
 -->
 <!--
  Preferred fonts:
    Noto fonts
    liberation fonts (for Monospace fonts)
 -->

 <!--
  Serif faces
 -->
 <match>
  <test name="family">
   <string>serif</string>
  </test>
  <edit name="family" mode="prepend" binding="strong">
   <string>Noto Serif</string> <!-- 优先使用 Noto Serif 渲染英文 -->
   <!-- 我的 Fedora 下中文太轻，用加深的 Black-->
   <string>Noto Serif CJK SC :style=Black</string> <!-- 中文回落到 Noto Serif CJK SC -->
   <string>Noto Serif CJK TC</string> <!-- 繁体中文回落到 Noto Serif CJK TC -->
   <!--
   <string>Source Han Sans CN Normal</string>
   <string>Source Han Sans TWHK Normal</string>
   -->
  </edit>
 </match>

 <!--
  Sans-serif faces
 -->
 <match>
  <test name="family">
   <string>sans-serif</string>
  </test>
  <edit name="family" mode="prepend" binding="strong">
   <string>Noto Sans</string> <!-- 优先使用 Noto Sans 渲染英文 -->
   <string>Noto Sans CJK SC</string> <!-- 中文回落到 Noto Sans CJK SC -->
   <string>Noto Sans CJK TC</string> <!-- 繁体中文回落到 Noto Sans CJK TC -->
   <!--
   <string>Source Han Sans CN Normal</string>
   <string>Source Han Sans TWHK Normal</string>
   -->
  </edit>
 </match>

 <!--
  Monospace faces
 -->
 <match>
  <test name="family">
   <string>monospace</string>
  </test>
  <edit name="family" mode="prepend" binding="strong">
   <!-- 我的 Fedora 下中文mono的字符间距太大，还是用去掉 Mono 字样的普通的Sans即可-->
   <string>Liberation Mono</string> <!-- 优先使用 Liberation 渲染英文 -->
   <string>Noto Sans CJK SC</string> <!-- 中文回落到 Noto Sans Mono CJK SC -->
   <string>Noto Sans CJK TC</string> <!-- 繁体中文回落到 Noto Sans Mono CJK TC -->
   <!--
   <string>Source Han Sans CN Normal</string>
   <string>Source Han Sans TWHK Normal</string>
   -->
  </edit>
 </match>
</fontconfig>

```

修改权限：

    $ chmod 644 ~/.config/fontconfig/fonts.conf

    # RHEL 系需要重新设置 SELinux
    $ restorecon -vFr /etc/fonts

参见章节 [Fedora(SELinux) 下安装下载的字体]。

刷新字体缓存：

    $ sudo fc-cache -fv

测试字体配置是否生效：

    $ fc-match serif
    NotoSerif[wght].ttf: "Noto Serif" "Regular"

    $ fc-match sans-serif
    NotoSans[wght].ttf: "Noto Sans" "Regular"

    $ fc-match monospace
    LiberationMono-Regular.ttf: "Liberation Mono" "Regular"

来自 tinywrkb <https://aur.archlinux.org/packages/noto-fonts-cjk-vf> 的例子，编辑 $XDG_CONFIG_HOME/fontconfig/fonts.conf 文件：

```xml
<alias>
   <family>sans-serif</family>
   <prefer>
     <family>Noto Sans</family>
     <family>Noto Sans CJK SC</family>
     <family>Noto Color Emoji</family>
     <family>Noto Emoji</family>
   </prefer>
</alias>

<alias>
   <family>serif</family>
   <prefer>
     <family>Noto Serif</family>
     <family>Noto Serif CJK SC</family>
     <family>Noto Color Emoji</family>
     <family>Noto Emoji</family>
   </prefer>
</alias>

<alias>
  <family>monospace</family>
  <prefer>
    <family>Noto Sans Mono</family>
    <family>Noto Sans Mono CJK SC</family>
    <family>Noto Color Emoji</family>
    <family>Noto Emoji</family>
   </prefer>
</alias>

<alias>
  <family>Source Code Pro</family>
  <prefer>
    <family>monospace</family>
    <family>Noto Sans Mono</family>
    <family>Noto Sans Mono CJK SC</family>
    <family>Noto Color Emoji</family>
    <family>Noto Emoji</family>
  </prefer>
</alias>
```

来自依云的例子

    https://github.com/lilydjwg/dotconfig/tree/master/fontconfig
        https://blog.lilydjwg.me/2023/3/5/linux-fonts.216591.html

```xml
<match target="pattern">
  <test qual="any" name="family">
    <string>sans-serif</string>
  </test>
  <edit name="family" mode="prepend" binding="strong">
    <string>DejaVu Sans</string>
    <string>文泉驿正黑</string>
    <string>Twemoji</string>
    <string>Font Awesome 6 Free</string>
    <string>Font Awesome 6 Brands</string>
    <string>Source Han Sans</string>
  </edit>
</match>
```

其它的例子

    文章较详细 https://szclsya.me/zh-cn/posts/fonts/linux-config-guide/
        https://github.com/szclsya/dotfiles/blob/master/fontconfig/fonts.conf

    https://github.com/rydesun/dotfiles/blob/master/.config/fontconfig/conf.d/

还可以开启一些诸如连字等特性，只需要设置特殊标志即可：

    https://learn.microsoft.com/zh-cn/typography/opentype/spec/featurelist

#### 给控制台console设置中文字体

桌面环境一般还提供直接切换到控制台的操作，详见章节 [登录控制台 tty login]。

目前控制台默认字体只支持基本英文，没有使用桌面环境默认的支持中文的 Noto 字体。

    如果您正在使用的是图形界面（GUI），并且使用的是支持中文的终端模拟器（如 GNOME Terminal 或 Konsole），则通常不需要进行这些步骤，因为终端模拟器会自动处理中文显示。

    如果您在控制台中遇到中文显示问题，建议首先检查您的系统是否安装了中文语言包和字体。

1、安装中文字体：

如果你的操作系统中还没有安装中文字体，可以使用以下命令安装 Noto 字体系列，它支持多种语言，包括中文：

    # sudo apt install fonts-noto-cjk
    $ sudo dnf install noto-fonts-cjk

2、配置控制台字体：

控制台字体配置通常在 /etc/default/grub 文件中设置。您需要编辑这个文件来指定中文字体。使用文本编辑器打开它，例如：

    $ sudo nano /etc/default/grub

然后找到 GRUB_CMDLINE_LINUX 这一行，添加或者修改 consolefont 参数，指定中文字体。例如：

    GRUB_CMDLINE_LINUX="consolefont=ter-v32n"

ter-v32n 是 Noto Sans Mono CJK 的字体名称之一，您可以使用 ls /usr/share/consolefonts/ 来查看系统中可用的字体列表。

修改 grub 配置后，需要更新 GRUB 以应用更改：

    $ sudo grub2-mkconfig -o /boot/grub2/grub.cfg

注意：如果您的系统使用的是 BIOS，GRUB 配置文件可能位于 /boot/grub/grub.cfg。

更新 GRUB 配置后，重启您的系统以使更改生效：

    $ sudo reboot

> Fedroa 特殊

从 Fedora 15 开始，Fedora 引入了一个新的系统称为 console-setup，它使用 kbd 包来管理控制台的键盘和字体设置。

要配置控制台以使用中文，您可以按照以下步骤操作：

1、安装中文字体：

安装 Noto Sans CJK 字体，这些字体通常已经预装在 Fedora 中。如果没有，可以使用以下命令安装：

    $ sudo dnf install noto-fonts-cjk

2、使用 kbd 工具配置控制台：

Fedora 使用 kbd 包中的 kbd 命令来配置控制台。首先，您需要找出可用的中文字体。可以通过以下命令列出所有可用的控制台字体：

    $ ls /lib/kbd/consolefonts

这将列出所有可用的控制台字体文件。

选择并设置中文字体：

从上一步的输出中选择一个中文字体，例如 unifont 或 WenQuanYi Zen Hei，然后使用以下命令设置控制台字体：

    $ sudo kbd -f /lib/kbd/consolefonts/your-chosen-font.psf

请将 your-chosen-font.psf 替换为您选择的字体文件的实际路径。

更新GRUB配置（如果需要）：

    如果您需要永久更改控制台字体，可能需要编辑 /etc/default/grub 文件，并添加或修改 GRUB_CMDLINE_LINUX 行，包含 consolefont 参数。然后，使用 grub2-mkconfig 命令更新GRUB配置。

重启系统：

更改控制台字体设置后，您可能需要重启系统以使更改生效：

    $ sudo reboot

切换到控制台并测试中文显示：

系统重启后，使用 Ctrl+Alt+F1 至 Ctrl+Alt+F6 切换到虚拟控制台，并测试中文字符的显示。

#### 转换 Windows 默认文件编码 GBK(GB-2132)

Linux 文件默认编码是 UTF-8，所以 Windows 下的文件要正常在 Linux 下显示，需要转换，除非 Linux 下的软件支持显示 GBK

可以使用如下命令转换

    # 文本内容转换 iconv
    yum install -y glibc-common
    iconv -f gbk -t utf8 test.gbk -o test.utf8

    # 文件名转换 convmv
    yum install -y convmv
    convmv -f gbk -t utf-8 -r --notest /your/文件名

### 给应用设置桌面图标

进入如下目录，复制一个文件，改改就行：

    /usr/share/applications/

示例

```ini
[Desktop Entry]
Type=Application
Name=Xfce Terminal
Exec=xfce4-terminal
Icon=utilities-terminal
Categories=GTK;System;TerminalEmulator;
```

### 使用 Gnome 桌面

    使用 GNOME 桌面环境

        https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/getting_started_with_the_gnome_desktop_environment/index

    设置 GNOME 桌面环境

        https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/administering_the_system_using_the_gnome_desktop_environment/index

    自定义 GNOME 桌面环境

        https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/customizing_the_gnome_desktop_environment/index

    gnome 桌面软件手册 https://help.gnome.org/users/

    GNOME-4X 入坑指南 https://zhuanlan.zhihu.com/p/545083349
                    https://jedsek.xyz/posts/desktop-beautify/gnome

    GNOME Linux — 一场彻底的灾难 https://zhuanlan.zhihu.com/p/490505981

为方便理解，对比 Windows 词汇如下：

    Windows 桌面        --->    Gnome Workspace 工作区，可以有多个

    Windows 任务栏      --->    Gnome Panel 边栏，就是在屏幕侧边的工具栏，比如 Gnome Topbar 顶栏就类似 Windows 的任务栏，但不支持切换应用程序

    Windows 桌面工具栏   --->    Gnome Dash 常用工具栏
                               Gnome Dock 浮动工具栏

以下尽量使用 Windows 词汇。

Gnome 桌面默认只展示壁纸，不能放文件（临时下载文件没法选择保存到桌面了，估计大多数人都不习惯），用户交互操作强调精简，在操作向手机风格转换的同时，优化宽屏、多桌面的使用方式

    桌面顶部永远是任务栏（顶栏Topbar），交互功能有限，大多时候的用途只是展示当前应用程序的状态（目的是演变成无交互的状态栏？），不像 Windows 任务栏，提供让你在打开的多个程序间切换的方法，这导致我在日常使用中除了看时间和点关机按钮，基本很少看任务栏。

        左上角的 “活动”（Activites）键用点和横线显示当前桌面是在所有桌面中的位置，鼠标滑过或点击都会显示 “任务概览”（Overview）。

        任务栏左侧只有一个栏目，显示当前打开的应用程序当前窗口的名称。单击程序的图标，只是弹出一个菜单让你选择多个实例窗口。

        居中栏目是日期时间天气

        右侧栏目是系统指示区，类似 Windows 任务栏托盘区(taskbar tray)，又细分为 Gnome 扩展的状态显示和系统设置的状态显示两个区域，最右边就是电源按钮。扩展显示区域的每个图标都可以点击显示单独的菜单，系统设置的显示区域却只弹出一个菜单，操作习题有差异。如果你安装了中文输入法，这个图标是显示在两个区域之间的。

开机后默认展示的界面是 “任务概览”（Overview），列出桌面列表和桌面内容的缩略图。“任务概览” 是用户操作多窗口切换最常使用的界面，操作热键是按 win 键，或鼠标撞几下屏幕左上角 --- “热角”（Hot Corner），或点击左上角的 “活动”（Activites）按钮：

    上部是搜索栏，直接打字就会默认填写到搜索栏，只需要输入你要使用的系统设置名称或应用程序名称，在搜索结果点击即可执行。搜索结果的展现是分类的，有当前安装的软件、软件商店的搜索结果等等，直接点击即可使用或下载安装。可以在系统设置里选择展示哪些分类，建议关闭字体搜索结果，最不常用但是搜索结果占大多数，影响使用体验。

        目前最快捷执行一个程序的方法就是按 Win 键呼叫出“任务概览”，然后打字，然后鼠标点击搜索结果里展示的软件名称

    居中的展示面积最大，预览当前桌面的的窗口内容，左右边缘显示相邻的桌面内容，点击即可在各个桌面间切换。这个界面跟手机的多个桌面操作类似。

        多个桌面的好处是，对经常同时打开很多应用程序的用户，可以分类管理：比如浏览器和文件管理器显示在一个桌面，代码开发调试的相关程序在一个桌面，远程桌面登录服务器在一个桌面全屏显示等等。

        可以拖动当前打开的程序窗口到其它桌面，那么这个程序就在那个桌面展示了。

        滚动鼠标滚轮，或按热键 ctl + alt + 左/右，即在各个桌面间进行切换，然后鼠标点击某个桌面即切换使用该桌面了。

        在多于两个桌面时会在顶部增加一个导航栏，列表显示所有桌面的预览，当前桌面稍微大一点，最右侧的桌面是新增桌面，点击会切换桌面预览。

        当前桌面的窗口关闭后会自动去掉空白的桌面，以此类推，保持最右侧只有一个新增的桌面，跟手机操作类似。

        目前的 Gnome 44 在用户从“任务概览”中点击选择一个桌面后，会进入空白桌面，除了壁纸，只有顶部的任务栏

            底部不显示常用工具栏（Dash），只能在“任务概览”找到常用工具栏。

            也就是说，你从“任务概览”选择进入一个空白桌面后，需要再点出“任务概览”，再点击常用工具栏里的“程序列表”，然后查找你要打开的程序。或者在“任务概览”里打字查找你要打开的程序。感觉这两种打开程序的方式都非常累赘。

            所以，强烈推荐务必安装扩展 “Dash to Dock”，见下面章节 [使用 gnome 扩展]，让常用工具栏常驻显示，极大的提高你的操作效率。

    底部是常用工具栏（Dash）当前所有打开的程序展示在这里，点击图标即可进行切换，还有个快捷启动部分固定了常用的几个程序的图标

        左侧部分是锁定(Pin to dash)的常用程序，点击即可执行方便使用

        中部列出当前打开的所有应用程序，点击图标即可在各个应用间选择切换，在图标上右键菜单选 “Pin to Dash” 可添加到快捷启动部分。

        最右那个9个点棋盘式的按钮 “Show Apps”，点击弹出一个新的界面，展示所有应用的 “程序列表”，在这里查找你想运行的程序，滚轮即可翻页

        感觉这是把 Windows 任务栏的切换应用功能拆分到了常用工具栏，但是这个最最常用的常用工具栏却藏的不好找。估计是想培养用户的使用习惯，按 Win 键呼叫出“任务概览”后直接打字找自己要的程序，而不是用鼠标点常用工具栏上的“程序列表”，然后继续点翻页找自己要的程序。可是一般人左手键盘asdf右手鼠标的组合是最常用的方式啊。。。

窗口切换：传统理解上，桌面环境下应用程序启动后就是一个窗口，再次启动一次该程序会再打开一个窗口，用户的日常操作基本就是多个窗口的展示和切换。Gnome 把窗口切换归类分组了 --- 区分为应用程序的切换(Switch-applications)和应用程序的多个实例窗口间的切换(Switch-Windows)操作，非常麻烦非常让人糊涂而且把简单事情复杂化（甚至还有更复杂的，设置切换操作仅限当前桌面的各个窗口）

    最方便的操作是在 “任务概览” 中进行选择，会展示所有应用程序的所有实例窗口，鼠标点击选择你要切换到的实例窗口即可

    切换应用程序

        启动应用程序即展示为当前窗口

        在打开的各应用程序间切换跟 Windows 相同，按热键 alt + tab 或 win + tab：一按即放就是切换到前一个应用，按住 alt 点按 tab 会在应用程序列表间切换，放开 alt 即切换到该应用程序

            注意：默认只切换到应用程序的最新实例，切换不到该应用程序的其它实例

    在一个应用程序的多个实例窗口间切换

        如果应用程序需要再开一个新的实例，在任务栏或常用工具栏的应用程序图标点右键菜单选择 “New Window”

        右键点击常用工具栏的应用程序图标，在弹出菜单的窗口列表中选择切换到该应用程序的某个实例，也即它的窗口

        右键点击任务栏的应用程序图标，在弹出菜单的窗口列表中也可以选择你要切换到的实例

        使用热键：当前窗口是你的应用程序，按 alt + ~ 或 win + ~。一按即放就会切换到最近的另一个实例，按住 alt 点按 ~ 会在各实例列表间切换，放开 alt 即切换到该实例

    也就是说，如果你打开了多个应用程序，每个应用程序打开了多个实例，想一步到位切换到某个实例只能按 win 键从 “任务概览” 里点选。不然只能先 alt + tab 切换到你的应用程序，然后 alt + ~ 切换到它打开的多个实例的某一个，这也太麻烦了。

    gnome 一直不能按 Alt+Tab 切换最近的两个窗口，必须安装扩展 “Alt+Tab Scroll Workaround”

为适应现代流行的 16:9 宽屏，优化了分割多个窗口占满屏幕的操作：

    鼠标双击窗口标题栏的操作跟 Windows 一致，在最大化和恢复小窗口间切换。

    鼠标点击窗口标题栏不要放开，拖动到屏幕的左侧边界或右侧时，会出现半透明的框提示占据半个屏幕，松开鼠标左键即可让窗口占半屏。不想这样就把鼠标往回拖动直至半透明的提示框消失，然后松开鼠标左键即可取消该操作。同理选择另一个窗口放到另一侧，这样两个窗口各占一半屏幕。

    如果是向上拖动窗口标题栏，触及屏幕顶部的任务栏时会提示最大化窗口，松开鼠标左键即可实现。对最大化窗口，点击标题栏不放向下拖动鼠标即会恢复到小窗口。

    如果窗口没有标题栏，按住 win 键的同时鼠标左键点击窗口内容部分不放，向各个方向拉动即可移动该窗口，触及屏幕边缘时系统提示跟上述操作相同。对最大化窗口，下拉会缩回为窗口模式。

    使用快捷键最方便，在当前窗口按 win + 方向键即可：向上最大化窗口，向下恢复小窗口，向左占据屏幕左半部分，向右占据屏幕右半部分。

其它热键：

    关闭窗口 alt + F4，跟 Windows 相同。

    临时离开电脑，用 win + l 锁屏，跟 Windows 相同。

笔记本用户使用触摸板

    双指滑动相当于鼠标操作滚动条

    触摸板操作默认居然不支持单指点击选中文字，需要安装 Gnome Tweaks，勾选 “Mouse Click Emulatsion-->Finger”。这样一般的文本编辑操作就比较方便了：单指滑动移动鼠标，单指点击选择文字，双指滑动滚动进度条。

    在锁屏界面，双指上滑进入解锁界面，双指下拉继续锁屏

其它一些使用习惯的差别

    用户未登录后长时间无操作会息屏，关闭节能选项无效。晃鼠标或触摸板不会唤醒，需要按键

#### 桌面环境提示系统更新

刚登录桌面后，会自动检查和下载系统更新，在此期间会有排他性：

    无法查看桌面软件的详情或添加删除软件，会长时间等待

    查看软件仓库配置也会长时间等待

如果在提示系统更新时选择安装，会重新启动计算机：

    重启前务必保存你的当前工作

命令行运行 `sudo dnf upgrade` 会立即安装更新，重启后生效，桌面环境需要先重启才安装更新：

    如果在关机时选择安装更新，会先重启安装更新然后再关机

    重启操作同样，如果在重启时选择安装更新，会在重启后安装更新，然后再次重启

#### 使用桌面环境的特有命令 gio

    `man gio`

    GVFS URI  https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/administering_the_system_using_the_gnome_desktop_environment/index#gvfs-uri-format-for-network-shares_browsing-files-on-a-network-share

    可用的 GIO 命令 https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/administering_the_system_using_the_gnome_desktop_environment/index#available-gio-commands_managing-storage-volumes-in-gnome

基本概念

    GVFS 提供完整的虚拟文件系统基础架构，并处理 GNOME 桌面中的存储。

    GVFS URI（统一资源标识符） 字符串作为地址，语法上与 Web 浏览器中的 URL 地址类似。

    GVFS 有助于挂载资源。这些挂载在多个应用之间共享。资源在运行的桌面会话中全局跟踪，这意味着即使您退出触发挂载的应用程序，挂载仍可用于任何其他应用程序。多个应用可以同时访问挂载，除非挂载被后端限制了。某些协议设计上仅允许一个通道。

    GVFS 可挂载 /run/media/ 目录中的可移动介质。

显示回收站

    $ gio list trash://

    $ gvfs-ls trash://

    $ gio info trash://
    display name: Trash
    name: /
    type: directory
    uri: trash:///
    attributes:
    standard::type: 2
    standard::name: /
    standard::display-name: Trash
    standard::icon: user-trash, user-trash-symbolic
    standard::content-type: inode/directory
    standard::symbolic-icon: user-trash-symbolic, user-trash
    id::filesystem: trash:
    trash::item-count: 0
    metadata::nautilus-icon-view-sort-by: trashed_on
    metadata::nautilus-icon-view-sort-reversed: true

列出本地 /tmp 目录中的所有文件

    $ gio list file:///tmp

从远程系统列出文本文件的内容

    # ftp://user@ftp.myserver.net/
    # sftp://[2001:db8::1]
    # smb://gnome.org
    # nfs://server/path
    $ gio cat ssh://joe@ftp.myserver.net/home/joe/todo.txt

将之前的文本文件复制到本地 /tmp 目录中

    $ gio copy ssh://joe@ftp.myserver.net/home/joe/todo.txt /tmp/

如果远程文件系统经常断网，处理办法是：

    卸载文件系统

    再次挂载它

#### 设置选项

点击桌面右上角的声音电源图标的栏目，选择弹出菜单的“Settings”。

刚装完系统后，一般进行如下设置：

    Wi-Fi ：设置连接你的无线路由器

    Privacy
        Screen Lock：选择自动黑屏的延时，黑屏后是否锁屏
        Location Services：如果选择关闭，桌面的天气组件需要手动设置你的当前城市
        Microphone：不需要关闭，安装下面介绍的 gnome 扩展 nothing to say 手动控制即可
        Diagnostics：关闭自动问题报告

    System:

        Remote Desktop 远程桌面细分为两种，仿效 Windows：

            Desktop Sharing：远程桌面共享，只能在本地用户登录的情况下使用桌面，本地用户随时可以观看到操作并接管鼠标。
            Remote Login：远程桌面登陆，跟上面相反，本地不能登陆桌面，这样才可以从远程连接本机使用桌面，无缝支持微软 mstsc。先点击窗口标题栏位置的开关，开启后才能开启下面的栏目

            这两个功能默认都使用 3389 端口，所以如果同时开启需要手动调整为不一样。其实只开启其中一个就可以了，酌情决定。

        Secure Shell: 开启 sshd 服务，这样可以远程ssh连接到本机，使用的用户名是你装系统时候给出的，注意不是那个用于显示的 “友好名称”

    Power:
        Power Mode：尽可能选“Performance”，不然桌面反应慢，程序切换慢。
        Power Saving Option：酌情选择

    Keyborad：
        Input Sources：建议两个输入法，英文和中文（拼音），英文顺序在上，这样在使用文件管理器时按键会自动成为热键定位文件首字母，方便。切换热键是 Win+空格。
        Input Source Switching：建议选择不同的窗口单独保持自己的输入法状态。

    Removable Media：勾选不许自动运行

    Users：
        Fingerprint Login：设置你的指纹识别登录桌面，注意不会解锁 gnome 钥匙环，在使用它保存的 ssh 或 gpg 的密钥时还是需要输入登录密码

##### Gnome Tweaks

桌面组件扩展的选项，在软件管理里搜索安装 “tweaks” ，或使用命令行

    # sudo apt install gnome-tweak-tool gnome-shell-extensions
    $ sudo dnf install gnome-tweaks

安装 Tweaks 后在 “Show Apps” 里找它打开即可，一般要调整如下选项

    center new window   新窗口居中打开，不然每次都是歪在当前屏幕的左上，而且互相覆盖，太不方便了

    给窗口的任务栏添加最大化最小化按钮，方便鼠标操作

    在 “Appearance” 选择任务栏主题，需要先安装 “User Themes” 扩展，见章节 [使用 gnome 主题]

    笔记本用户勾选“Mouse Click Emulatsion-->Finger”，否则触摸板操作不支持单指点击选中文字。这样一般的文本编辑操作就比较方便了，单指滑动移动鼠标，单指点击选择文字，双指移动滚动屏幕。

##### GDM 的 “注册表编辑器” --- 使用 GSettings 和 dconf 配置桌面

命令行方式调整选项，理解为Linux 下的 “注册表编辑器”

    https://wiki.archlinux.org/title/GDM#dconf_configuration

    https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/7/html/desktop_migration_and_administration_guide/profiles

GSettings 实际上是一套可使用多个 storage backends 的 API ，其文件是 xml 格式的，可以理解为 Linux 桌面环境的注册表数据库文件。

GSettings 是应用设置的高级 API，是 dconf 的前端。

    gsettings 命令行工具用于查看和更改用户设置，把它理解为命令行版的注册表编辑器

dconf 是一个基于键的配置系统，用于管理用户设置。它是 Red Hat Enterprise Linux 7 中使用的 GSettings 的后端。dconf 管理一系列不同的设置，包括 GDM、应用程序和代理设置，可以理解为 Linux 桌面环境的注册表数据库。

    dconf 命令行工具用于从/向 dconf 数据库读写单个值或整个目录，把它理解为注册表数据维护用的底层管理工具。

如果需要修改桌面环境下的系统的配置参数，一般可以使用图形化工具 Dconf Editor，或 gsettings 命令行工具。

#### 使用 gnome 扩展

    刚装完系统之后的 Gnome 桌面在用户使用引导方面很弱，会让你发楞，感觉什么都没有，也什么都不能设置

Gnome 桌面强调简洁，聚焦于迅速投入工作，从 gnome 43 开始甚至把文件管理器的主题色彩定制都取消了。这与 kde 桌面预置大量功能供用户把玩不同，在 Gnome 桌面没有什么设置选项，大多数定制功能需要用户自行安装扩展才能使用

    https://zhuanlan.zhihu.com/p/34608388

    https://opensource.com/article/19/8/extensions-gnome-desktop

    https://docs.fedoraproject.org/en-US/quick-docs/gnome-shell-extensions/

    介绍一些最常用的扩展

        https://www.cnblogs.com/keatonlao/p/12686234.html

如果想使用其它各种扩展，只能去网站 <https://extensions.gnome.org/> 自行搜索下载。现在的 GNOME 桌面组件自带的扩展管理器 “Extension Manager” 替换掉了之前的 “GNOME Extensions”，不需要去网站就可以搜索下载，在软件管理里搜索安装 “Extension Manager” 即可，或使用命令行安装 flatpak 版本

    # 命令行安装的好处是能看到细分的进度
    $ flatpak install flathub com.mattjakeman.ExtensionManager

    如果仍然想使用网站浏览然后安装的方式

        先浏览器访问如下网址，点击顶部提示，安装浏览器组件

        https://extensions.gnome.org/

            介绍 https://wiki.gnome.org/Projects/GnomeShell

        然后安装本地消息组件

            $ sudo dnf install gnome-browser-connector  # 原名 chrome-gnome-shell

推荐打开的内置扩展：

    Application Menu        常用工具栏的 “Show Apps” 按钮会罗列所有的应用程序，软件安装多了之后太乱了，用这个给你在任务栏为应用程序添加基于类别的菜单，方便你的选择，感觉再加上个打字即搜索列出结果和列出刚打开的程序的功能更好。

推荐安装的第三方扩展：

提升效率类

    Dash to Dock            把常用工具栏变成浮动工具栏，不需要进入“任务概览”才能找到了。浮动工具栏在用户打开的应用程序窗口覆盖该区域后就会自动隐藏，任何时候鼠标在屏幕的底边中部碰碰就会弹出（也可设置为总是显示）。我最常用的操作就是鼠标撞屏幕底部，就撞出来浮动工具栏了。对宽屏用户来说把浮动工具栏设置为显示在屏幕左边更方便。

        竞品 Dash2Dock Animated(原名Dash2Dock Lite)<https://extensions.gnome.org/extension/4994/dash2dock-lite/>，仿 MacOS 的动画效果，响应更敏捷。

    Dash to Panel           使用习惯模仿 Windows 任务栏，把常用工具栏变成底部的固定工具栏，右键菜单很方便，也添加了按钮“显示桌面”。这样就不需要内置的 Application Menu 扩展了。

    上面这俩扩展必装一个，大大提升你的工作效率。二者都可以设置任务栏图标显示打开窗口个数，滚动鼠标切换工作区，重复点击图标可以在同一应用的多个窗口间切换并最小化窗口等方便功能。

    quake-mode              设置热键，以下拉方式调出你的程序窗口，所有工作区共享该程序，再次按热键即收回该窗口。对程序员来说，设置热键 alt + enter 调出一个半屏的 terminal 窗口极其方便实用。

        https://extensions.gnome.org/extension/1411/quake-mode/
            https://github.com/repsac-by/gnome-shell-extension-quake-mode

        该扩展目前不支持 Gnome 45+，可以安装 ddterm 应急。

        目前支持Gnome 45+，但没有通过 gnome 扩展的审查规范，无法在网站安装，源码网站提供了手动安装的办法：

            git clone --depth=1 https://github.com/repsac-by/gnome-shell-extension-quake-mode.git

            cd gnome-shell-extension-quake-mode

            gnome-extensions pack quake-mode@repsac-by.github.com --extra-source={quakemodeapp,indicator,util}.js

            gnome-extensions install quake-mode@repsac-by.github.com.shell-extension.zip --force

    Coverflow Alt-Tab       像 Windows 的 win + tab 形式的立体呈现切换窗口，而且可以治愈 gnome 目前不能按 Alt+Tab 切换最近使用的两个窗口。gnome 的默认习惯，只能切换到应用：Alt+Tab 列表是应用窗口，按住 alt 持续点击 tab 循环到某个多实例的应用窗口时，会在上面再显示一个列表呈现该应用的多个实例。切换到应用后，按 Alt+` 在应用的多个实例间切换。

        实现 Windows 任务栏切换的习惯：选 AppSwitch 设置页，点开 “Make ... Like the Windows ...” 按钮，这样就不再把窗口分组为应用和应用的多个实例，还要选 Windows 设置页点开 “Workspaces” 选 “All workspaces”，否则会优先循环当前工作区的窗口。

    Grand Theft Focus       打开文件对话框显示在你的应用窗口后面，然后系统弹通知告诉你有个对话框打开了。。。这是病，得治！ 竞品 window-is-ready-notification-remover，或直接运行命令 `gsettings set org.gnome.desktop.wm.preferences focus-new-windows 'smart'`。

    Unblank lock screen     gnome的屏幕长时间空闲自动锁屏里没有单独的锁屏，只有黑屏并锁屏或黑屏不锁屏，要是鼠标晃不醒就只能蒙着打密码了，这也是病，得治！

    Alphabetical App Grid   应用程序列表“居然”是不按字母顺序排列的，而且无法拖放调整位置，这是不是该治的病！用这个扩展强制按字母顺序排列。

    Auto Move Windows       指定应用程序在指定桌面打开窗口。对经常同时打开很多应用程序的用户来说，按桌面归类各个应用程序的窗口，非常方便。竞品 put windows。

    Lock Keys               有些键盘的数字键盘和大写键没有指示灯，用这个在任务栏的系统区进行提示。

    nothing to say          在任务栏可以看到你的麦克风状态并手动控制是否静音，大大改善你的隐私保护

    Show Desktop Button     像 Windows 的显示桌面按钮，第一次点击最小化所有窗口显示桌面，再次点击恢复窗口。

    system-monitor-next     在任务栏显示你的cpu、内存使用情况，就像在终端使用 btop 或 nmon 的效果。竞品 Vitals/Freon。

    GSConnect               操作局域网联网（WIFI）的你的手机，支持传送文件、发送短信、查看通知等操作，需要手机安装 “KDE Cconnect”。如果需要完整操控你的手机，见章节 [Scrcpy --- 在 Linux 桌面显示和控制 Android 设备]。

    Night Theme Switcher     Gnome 系统内置明暗模式和相应的壁纸切换功能，但是只能手动切换明暗模式（某些壁纸跟随），这个扩展实现定时自动切换。

    Weather O'Clock         在任务栏的时间旁边显示当前天气，依赖你在任务栏的时间弹窗处先设置你的位置。

    Date Menu Formater      如果在任务栏显示的时间没有星期，在 Gnome Tweaks 中开启即可。在系统设置的 Clock&Calendar 可以设置是否显示星期，这个扩展可以调整日期时间的格式。

    Lunar Calendar          农历，需要先安装lunar-date库(https://github.com/yetist/lunar-date)

    Media Control           在任务栏显示当前的音乐播放器信息及控制按钮，感觉这也是应该内置的功能。

    Removable drive menu    在任务栏给你的 u 盘添加菜单方便访问，只要插入 u 盘就会出现一个大三角图标，点击会列出 u 盘列表，点击 u 盘名称即以文件管理器打开 u 盘，点击 u 盘名称右侧的三角即安全弹出该 u 盘。否则只能打开文件管理器才能选择卸载 u 盘。

    Clipboard Indicator     剪贴板历史记录，点击对应即放到当前剪贴板，在编辑器选择粘贴即可使用。竞品 Pano Clipboard Manager 可以显示复制的富媒体内容，需要安装依赖 `sudo dnf install libgda libgda-sqlite`。

    Smartcard lock          登录用的智能卡如yubikey被拔出，即自动锁屏

    Power Profile Switcher  使用AC电源时能源策略选择高性能，使用电池时能源策略使用节能，自动切换。在我的台式机上不准，总是切换到均衡。

    Prime Helper            让你方便的切换使用集成显卡或独立显卡，需要先安装支持 `prime-select` 的 prime 应用程序。竞品 GPU Profile Selector 需要先安装 envycontrol(https://github.com/geminis3/envycontrol)

    allow locked remote desktop
                            解除部分内置的远程桌面的本地锁定限制，允许在本地桌面锁定的情况下以远程桌面登录本机，未验证是否有效。

界面美化类

    User Themes             允许安装用户自定义主题扩展，然后可以在 Gnome Tweaks 里打开主题并切换显示了，这居然不是内置功能。

    Bing Wallpaper          自动从微软 bing 网站下载它的漂亮图片作为你的壁纸，还可设置锁屏背景。

        https://github.com/neffo/bing-wallpaper-gnome-extension
            https://github.com/utkarshgpta/bing-desktop-wallpaper-changer

    NASA APOD Wallpaper Changer自动从 NASA 网站下载它的漂亮图片作为你的壁纸

        https://github.com/Elinvention/gnome-shell-extension-nasa-apod

    另见章节 [自写脚本指定壁纸目录随机更换]

    blur my shell           透明模糊你的任务栏，勾选 PanelBlue 即可让概览窗口也使用你的壁纸作背景，而且支持某些应用程序和扩展透明化，注意跟有些主题兼容性不好边缘无法透明。不需要使用它的锁屏背景模糊功能，使用 Bing Wallpaper 扩展的这个功能效果更好。不需要使用它的 Dash to Dock/Panel 的透明化功能，那些扩展自己有透明化设置。

    burn my window          窗口的弹出和关闭各种特效化，推荐勾选 Apparition、Doom、Hexagon、TV Glitch。

#### 使用 gnome 主题

    Gnome 44 以后只能设置任务栏了，窗口的明暗主题无法变更，窗口的颜色和形状也无法自定义。

Gnome 主题乐园，在这里搜一下 Gnome Shell Themes 类别，你的 Gnome 任务栏就大变样了

    https://www.gnome-look.org/

    https://www.pling.com/

    推荐：

        创·战纪 风格的东京夜
            https://www.gnome-look.org/p/1681470
                https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme

        北极
            https://www.pling.com/p/1267246
                https://github.com/EliverLara/Nordic

        Flat Remix，绿色的还行，只支持白底，自带透明效果，支持流行的一些 gnome 扩展如 dash to dock 等也变透明
            https://www.pling.com/p/1013030
                https://github.com/daniruiz/Flat-Remix-GNOME-theme

        Graphite gnome-shell theme multicolor 多种颜色搭配比较明显，只支持白底
            https://www.pling.com/p/2014493/

        说明写的很清楚
            https://github.com/vinceliuice/WhiteSur-gtk-theme

如何使用主题：

安装一个 gnome 扩展 `User Themes`，然后启用 “用户主题 User Themes” 扩展，在扩展里面启用它。

安装 Murrine Engine 以兼容支持旧的 gtk2 标准

    sudo dnf install gtk-murrine-engine

下载主题，一般是打包好的 zip 文件，保存到 ~/.theme 目录下

然后打开 Gnome Tweaks，点击 "Appearence" 按钮，在右侧栏选择 "shell"，选择刚才的zip文件即可

以下内容过时了

    然后你就可以在 GNOME Shell 扩展页面 挑选扩展了

        https://extensions.gnome.org/

    安装主题：

        sudo dnf install flat-remix-theme

    安装图标：

        sudo dnf install numix-icon-theme-circle

    安装光标：

        sudo dnf install breeze-cursor-theme

    再去 GNOME 优化(Tweaks)的 “外观” 设置里面修改刚刚安装的主题、图标和光标，还可以修改字体。

#### 把浏览器缓存区指向内存目录

映射内存目录见章节 [tmpfs/ramfs 映射内存目录](init_a_server think)。

    https://www.insidentally.com/articles/000040/

Linux 下不同浏览器缓存位置不同：

    默认 Microsoft Edge 缓存位置在 ~/.cache/microsoft-edge
    默认 Google Chrome 缓存位置在 ~/.cache/google-chrome
    默认 Mozilla Firefox 缓存位置在 ~/.cache/mozilla/firefox/XXXXXXXX.default-release/cache2
    本文以 Microsoft Edge 浏览器为例。

    Firefox 浏览器缓存位置中 XXXXXXXX 为 8 位随机代码，请自行查找你缓存文件的位置。

如果不需要保存缓存内容，在登出系统时直接清理，最简单的是直接使用 /dev/shm 预置好的内存目录

    $ rm -rf $HOME/.cache/mozilla/firefox
    $ mkdir -p /dev/shm/mozilla-firefox
    $ ln -sf /dev/shm/mozilla-firefox $HOME/.cache/mozilla/firefox

如果想需要保存登录信息相关的 cookie，在登出前打包保存这个目录，登录后恢复，用以下脚本组合：

在你喜欢的位置建立核心脚本并添加可执行权限，建议将脚本建立在你的用户主目录下的某个位置，因为本文使用普通用户权限的 systemd 引用脚本。本文其他脚本同样如此。

内容如下：

1、缓存同步（打包解包）脚本，在登录和登出时调用，解压和打包你的浏览器缓存内容

```bash
#!/usr/bin/sh

# 在登录后登出前执行此脚本
# 确保你的系统已经安装 tar 和 lzop

case "$1" in
 import)
   cd /dev/shm
   tar vczf /home/你的用户名/.cache/edgecache-backup.tar.gz
   ;;
 dump)
   cd /dev/shm
   # 删除大于 5MB 的缓存文件
   find ./microsoft-edge/ -size +5M -exec rm {} \;
   tar vxzf /home/你的用户名/.cache/edgecache-backup.tar.gz microsoft-edge/
   ;;
 *)
   echo -e "Usage: $(cd `dirname $0`; pwd)/edgecache {import|dump}"
   exit 1
   ;;
esac

exit 0
```

2、登录导入脚本，登录时设置缓存路径，及从压缩包导入缓存

```bash
#!/bin/sh

# 将 microsoft edge 缓存路径到内存
/bin/rm ~/.cache/microsoft-edge -R
/bin/mkdir -p /dev/shm/microsoft-edge
/bin/ln -sf /dev/shm/microsoft-edge ~/.cache/microsoft-edge

# 将浏览器缓存同步到内存
echo [`date +"%Y-%m-%d %H:%M"`] On login - Importing caches to ram >> /home/你的用户名/edgecache_sync.log
/你/核心脚本/的位置 import >> /home/你的用户名/edgecache_sync.log
echo [`date +"%Y-%m-%d %H:%M"`] On login - Caches imported to ram >> /home/你的用户名/edgecache_sync.log
```

3、 登出前导出缓存到硬盘

```bash
#!/bin/sh

# 将浏览器缓存同步到磁盘
echo [`date +"%Y-%m-%d %H:%M"`] On logout - Dumping caches to disk >> /home/你的用户名/edgecache_sync.log
/你/核心脚本/的位置 dump >> /home/你的用户名/edgecache_sync.log
echo [`date +"%Y-%m-%d %H:%M"`] On logout - Caches dumped to disk >> /home/你的用户名/edgecache_sync.log

# 等待 4 秒
ping -c 4 127.1 > /dev/null
```

4、让 systemd 在登录和登出时自动执行上述脚本：

在 ~/.config/systemd/user/ 目录下创建文件 edgecache.service：

```conf
[Unit]
Description=Synchronize edge caches to disk
PartOf=graphical-session.target
DefaultDependencies=no
Before=umount.target shutdown.target reboot.target halt.target

[Service]
Type=simple
RemainAfterExit=true
ExecStart=/你/登录导入脚本/的位置
ExecStop=/你/登出导出脚本/的位置

[Install]
WantedBy=graphical-session.target
```

5、启用你的 systemd 服务

    $ systemctl --user daemon-reload
    $ systemctl --user enable edgecache.service

重新登录你的桌面，打开浏览器试试，速度是否有明显差别。

#### 自写脚本指定壁纸目录随机更换

    https://www.insidentally.com/articles/000037/

换壁纸的思路

    使用 find 命令生成包含所有图片地址的列表。

    从列表中随机挑选一张图片。

    使用 gsettings 设置壁纸。

    使用 systemd 定期执行脚本。

1、Bash 脚本

首先写一个 Bash 脚本，实现更换壁纸的目的，同时为了响应速度和硬盘寿命着想，所有相关文件都保存在 $XDG_RUNTIME_DIR，它其实是被 GNOME 桌面环境用 tmpfs 创建的内存目录。

$XDG_RUNTIME_DIR 是一个变量，后面将使用 systemd 传入你存放壁纸文件夹的路径这个变量。

生成地址列表

查找 $1 下面的图片，并且生成列表到 $XDG_RUNTIME_DIR/bg_db，如果已经生成过不需要重复生成。

    if [[ ! -f "${XDG_RUNTIME_DIR}/bg_db" ]]; then
        find "${1}" \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print > "${XDG_RUNTIME_DIR}/bg_db"
    fi

随机挑选一张图片

使用 shuf 命令挑选一张图片，如果文件不存在则重新挑选，注意如果上一步没有找到任何图片会陷入死循环。

    while [[ ! -f "${TARGET}" ]]; do
        TARGET=$(shuf -n 1 "${XDG_RUNTIME_DIR}/bg_db")
    done

假如需要跳过重复壁纸只需要每次挑选图片后删掉相应的行，然后在地址列表为空时重新扫描即可。

设置壁纸

通过 gsettings 来进行设置

    gsettings set org.gnome.desktop.background picture-uri "file://${TARGET}/" || true
    gsettings set org.gnome.desktop.background picture-uri-dark "file://${TARGET}" || true

picture-uri 是亮色模式下的壁纸，picture-uri-dark 是暗色模式下的壁纸。我这里将两个模式下的壁纸换为同一个。

合体后的脚本 background.sh，运行这个脚本就可以自动更换壁纸了。

```bash
#!/usr/bin/env bash
set -Eeo pipefail

if [[ ! -f "${XDG_RUNTIME_DIR}/bg_db" ]]; then
    find "${1}" \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print > "${XDG_RUNTIME_DIR}/bg_db"
fi

while [[ ! -f "${TARGET}" ]]; do
    TARGET=$(shuf -n 1 "${XDG_RUNTIME_DIR}/bg_db")
done

gsettings set org.gnome.desktop.background picture-uri "file://${TARGET}/" || true
gsettings set org.gnome.desktop.background picture-uri-dark "file://${TARGET}" || true
```

记得给这个文件添加可执行权限：chmod +x background.sh。

运行时记得传入你壁纸文件夹的路径： background.sh ./your/background/PATH。

2、使用 systemd --user 定期运行脚本。

创建文件

    background@.service

```ini
[Unit]
Description=Select a random background from %I

[Service]
Type=oneshot
RemainAfterExit=true
ExecStart=%h/path/to/background.sh "%I"
```

其中 %h 对于 systemd --user 而言相当于 $HOME 的作用，而 %I 则用于传递参数也就是存储的图片文件夹路径。

创建文件

    background@.service

```ini
[Unit]
Description=Select a random background from %I every 1 min
PartOf=graphical-session.target

[Timer]
OnStartupSec=1
OnUnitActiveSec=5min
AccuracySec=1s
Unit=background@.service

[Install]
WantedBy=gnome-session.target
```

使用 AccuracySec=1s 避免随机延迟，另外 PartOf 以及 WantedBy 确保了只有处于 Gnome 桌面环境时才会触发。

启动 Timer

    将 background@.service 和 background@.timer 放入 ~/.config/systemd/user/ 下，并启动 systemd 定时任务。

    $ install -m640 background@.service background@.timer ~/.config/systemd/user/

    $ systemctl --user daemon-reload

    # BGPATH=$(systemd-escape "path/to/background/directory")

    $ systemctl --user enable --now background@$BGPATH.timer

第三行 path/to/background/directory 替换为你壁纸的路径。

注意 @ 后面的路径 $BGPATH 变量需要使用 systemd-escape 进行转义。

查看当前壁纸

有时候需要知道当前壁纸的原图位置，只需要在 background.sh 相应位置添加：

    echo "$TARGET" > "$XDG_RUNTIME_DIR/bg_path"

    # 显示当前壁纸原图的位置
    cat "$XDG_RUNTIME_DIR/bg_path"

    # 在桌面环境打开原图
    xdg-open $(cat "$XDG_RUNTIME_DIR/bg_path")

#### 给资源管理器添加 meld 右键菜单

meld 基于 python 的开源合并工具，替换 BeyondCompare，缺点是在文件夹对比有大量文件时会卡住

    https://meldmerge.org/
        https://gitlab.gnome.org/GNOME/meld
        https://gitlab.gnome.org/GNOME/meld/-/wikis/home

    https://www.cnblogs.com/onelikeone/p/17291936.html

其它考虑

    Diffuse 文字对比不错，可惜不支持文件夹对比
        https://github.com/MightyCreak/diffuse
            原 https://github.com/MightyCreak/diffuse

    KDiff3 偏向 merge 方向，文件夹对比的差异不够直观 https://apps.kde.org/kdiff3/

    TkDiff https://sourceforge.net/projects/tkdiff/

    DiffMerge 闭源的免费软件 https://www.sourcegear.com/diffmerge/downloads.html

如果使用 GNOME桌面，其资源管理器可以添加右键菜单 “script”，在 ~/.local/share/nautilus/scripts 目录下建立如下两个文件：

A-set-as-meld-left：

```bash
#!/bin/bash
#
# https://www.cnblogs.com/onelikeone/p/17291936.html
# This script opens a compare tool with selected files/directory by
# script "set-as-*-left".
# so you should run "set-as-*-left" first
# Copyright (C) 2010  ReV Fycd
# Distributed under the terms of GNU GPL version 2 or later
#
# Install in ~/.gnome2/nautilus-scripts or ~/Nautilus/scripts
# or ~/.local/share/nautilus/scripts (ubuntu 14.04 LTS)
# You need to be running Nautilus 1.0.3+ to use scripts.
# You also need to install one compare tools to use scripts(such like meld)
# You can change the $compareTool to other compare tools(like "Kdiff3") that
# you have already installed before.

compareTool="meld"
if [ -n "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
    set $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
    if [ $# -eq 1 ]; then
        file1="$1"
        echo "set-as-Meld-left Copyright (C) 2010  ReV Fycd"
        echo "${compareTool} ${file1} \\"> ~/.startcompare
    fi
fi
```

注意：

    如果是 flatpak 安装的 meld，把上面的 `compareTool="meld"` 命令行替换为 `compareTool="flatpak run org.gnome.Meld"`

B-compare-to-left：

```bash
#!/bin/bash
#
# https://www.cnblogs.com/onelikeone/p/17291936.html
# This script opens a compare tool with selected files/directory by
# script "set-as-*-left".
# so you should run "set-as-*-left" first
#
# Copyright (C) 2010  ReV Fycd
# Distributed under the terms of GNU GPL version 2 or later
#
# Install in ~/.gnome2/nautilus-scripts or ~/Nautilus/scripts
# or ~/.local/share/nautilus/scripts (ubuntu 14.04 LTS)
# You need to be running Nautilus 1.0.3+ to use scripts.
# You also need to install one compare tools to use scripts(such like meld)

if [ -n "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
    set $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
fi
if [ $# -eq 1 ]; then
    file2="$1"
    echo "Compare-to-left Copyright (C) 2010  ReV Fycd"
    echo $file2 >> ~/.startcompare
fi

chmod +x ~/.startcompare
exec ~/.startcompare
```

然后赋予执行权限即可：

    $ chmod +x Meld-aset-as-left Meld-compare-to-left

使用

    在第一个文件点右键，弹出菜单选 “Scripts”-->“A-set-as-meld-left”，

    然后在第二个文件上点右键，弹出菜单选 “Scripts”-->“B-compare-to-left”

    这时 meld 会自动弹出窗口对这两个文件进行比较

如果是多选，如同时选择了两个文件或文件夹，右键菜单选择 “Open With...”，然后选择 meld 即可。

### 使用 KDE 桌面（Plasma）

KDE 因为多年保持桌面环境的稳定不变，所以应用软件的丰富程度比 GNOME 多太多了。

KDE 的桌面定制选项非常多，慢慢研究吧

    https://itsfoss.com/kde-customization/

KDE 桌面的定制也有专门的附加组件、小工具，不像 GNOME 从浏览器中添加扩展的那种不方便的方式（使用另一个浏览器扩展），你可以使用 KDE 的软件管理器 “发现（Discovery）”，直接访问 KDE 的附加组件。

KDE 自带的软件也有很多精品比如 KDE connect 等

    https://apps.kde.org/kdeconnect/

    已经延展到了多个平台 https://apps.kde.org/platforms/windows/

### 其它桌面环境

enlightenment 桌面

    https://www.enlightenment.org/

如果不想用桌面环境，但还需要在图形化的窗口下工作，见章节 [窗口管理器（Windows Manager）]。

### 多显示器调整显示

xrandr 是 Linux 系统中用于配置显示器分辨率和布局的命令行工具，而 arandr 则提供了图形化的界面，可以指定主显示器、扩展多屏幕、动态调整（缩放、旋转、反转）屏幕等功能。

### Linux 桌面的基本目录规范 XDG（X Desktop Group）

对桌面的图形化环境来说，规范化的使用目录，用各种变量来指定，有一套具体的规则，定義了基本的 Linux 下的 X Window System (X11) 以及其他 Unix-like 作業系統的桌面環境。目前最流行的 freedesktop 的规范称为 XDG

    https://www.freedesktop.org/software/systemd/man/file-hierarchy.html

    https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

    https://wiki.archlinux.org/index.php/XDG_Base_Directory
    https://wiki.archlinux.org/title/Xdg-utils

    https://catcat.cc/post/wn3np/

    https://blog.csdn.net/u014025444/article/details/94029895

    https://winddoing.github.io/post/ef694e1f.html

    https://blog.csdn.net/weixin_29702195/article/details/116886216

    https://blog.csdn.net/u014025444/article/details/94029895

Linux 操作系统的基本目录结构参见章节 [Linux 目录和分区](shellcmd.md)。

XDG 基本目录规范基于以下概念：

    XDG 环境变量             说明                                    默认值

    $XDG_DATA_HOME      用于写入特定用户数据文件的基本目录              $HOME/.local/share
    $XDG_CONFIG_HOME    用于写入特定用户的配置文件基本目录              $HOME/.config
    $XDG_DATA_DIRS      首选的基本数据目录                           /usr/local/share/:/usr/share/ 等

    $XDG_CONFIG_DIRS    首选的基本配置目录                           /etc/xdg
    $XDG_CACHE_HOME     用于写入用户特定的非必要（缓存）数据的基本目录    $HOME/.cache
    $XDG_RUNTIME_DIR    用户放置特定于用户的运行时文件和其他文件对象

$XDG_RUNTIME_DIR 是用户特定的不重要的运行时文件和其他文件对象（例如套接字，命名管道…）存储的基本目录。该目录必须由用户拥有，并且他必须是唯一具有读写访问权限的目录。它的Unix访问模式必须是 0700。

目录的生命周期必须绑定到登录用户。必须在用户首次登录时创建，如果用户完全注销，则必须删除该目录。如果用户多次登录，他应该指向同一目录，并且必须从第一次登录到他在系统上的最后一次登出时继续存在，而不是在两者之间删除。目录中的文件必须不能在重新启动或完全注销/登录循环后继续存在。

该目录必须位于本地文件系统上，不与任何其他系统共享。该目录必须完全按照操作系统的标准进行。更具体地说，在类Unix操作系统上，AF_UNIX套接字，符号链接，硬链接，适当的权限，文件锁定，稀疏文件，内存映射，文件更改通知，必须支持可靠的硬链接计数，并且对文件名没有限制应该强加字符集。此目录中的文件可能需要定期清理。为确保不删除您的文件，他们应至少每6小时单调时间修改一次访问时间戳记，或者在文件上设置“粘滞”位。

如果 $XDG_RUNTIME_DIR 未设置，应用程序应回退到具有类似功能的替换目录并打印警告消息。应用程序应使用此目录进行通信和同步，并且不应在其中放置较大的文件，因为它可能驻留在运行时内存中，并且不一定可以交换到磁盘。

环境变量清单：用户层面变量（User-Level Variables）

    $XDG_DATA_HOME          $HOME/.local/share/

        储用户特定的数据文件的基准目录。通常来说文件较大，有反复使用的价值，建议备份里面的文件。

        使用场景：

            用户下载的插件；
            程序产生的日志、历史记录、离线资源等数据文件；
            用户输入历史、书签、邮件等。

    $XDG_CONFIG_HOME        $HOME/.config/

        存储用户特定的配置文件的基准目录，建议备份里面的文件。

        使用场景：

            用户配置。

        一般来说，这个地方可以在程序初始化的时候存储一个默认的配置文件供加载和修改。

    $XDG_CACHE_HOME         $HOME/.cache/

        应存储用户特定的非重要性数据文件的基准目录，建议备份里面的文件。

        使用场景：

            缓存的缩略图、歌曲文件、视频文件等。
            程序应该做到哪怕这个目录被用户删了也能正常运行。

    $XDG_RUNTIME_DIR

        应存储用户特定的非重要性运行时文件和一些其他文件对象（例如套接字，命名管道…）存储的基本目录

        该目录必须由用户拥有，并且该用户必须是唯一具有读写访问权限的。该目录的 Unix 访问模式必须是 0700。

用户层面目录的生命周期必须绑定到登录用户。必须在用户首次登录时创建，如果用户完全注销，则必须删除该目录。如果用户多次登录，他应该指向同一目录，并且必须从第一次登录到他在系统上的最后一次登出时继续存在，而不是在两者之间删除。目录中的文件必须不能在重新启动或完全注销/登录循环后继续存在。

用户层面目录必须位于本地文件系统上，不与任何其他系统共享。该目录必须完全按照操作系统的标准进行。更具体地说，在类Unix操作系统上，AF_UNIX套接字，符号链接，硬链接，适当的权限，文件锁定，稀疏文件，内存映射，文件更改通知，必须支持可靠的硬链接计数，并且对文件名没有限制应该强加字符集。此目录中的文件可能需要定期清理。为确保不删除您的文件，他们应至少每6小时单调时间修改一次访问时间戳记，或者在文件上设置“粘滞”位。

如果 $XDG_RUNTIME_DIR 未设置，应用程序应回退到具有类似功能的替换目录并打印警告消息。应用程序应使用此目录进行通信和同步，并且不应在其中放置较大的文件，因为它可能驻留在运行时内存中，并且不一定可以交换到磁盘。

环境变量清单：系统层面变量（System-Level Variables）

    $config，默认为 ~/.config : /etc

        如果在尝试编写文件时，目标目录不存在，则应尝试使用权限 0700 创建目标目录。

        如果目标目录已存在，则不应更改权限。

        应用程序应准备好处理无法写入文件的情况，因为该目录不存在且无法创建，或者出于任何其他原因。在这种情况下，它可以选择向用户呈现错误消息。

    $XDG_CONFIG_DIRS        /etc/xdg/

        按照偏好顺序的基准目录集，用来搜索除了 $XDG_CONFIG_HOME 目录之外的配置文件。

        该目录中的文件夹应该用冒号（:）隔开。

        使用场景：

            可以被用户特定的配置文件所覆盖的系统层面的配置文件。

        一般来说，应用程序安装的时候可以加载配置文件到这个目录。

    $XDG_DATA_DIRS          /usr/local/share/:/usr/share/

        按照偏好顺序的基准目录集，用来搜索除了 $XDG_DATA_HOME 目录之外的数据文件。

        该目录中的文件夹应该用冒号（:）隔开。

        使用场景：

            可以被所有用户使用的插件或者主题。

        一般来说，应用程序安装的时候可以加载插件、主题等文件到这个目录。

参考规范

    文件                参考规范：subdir应该为软件名
    数据文件        $datadir/subdir/filename
    配置文件        $confdir/subdir/filename

#### xdg-utils

常用的桌面环境操作统一化，比如安装应用菜单，设置默认浏览器，设置默认电子邮件客户端，设置默认的媒体播放器等等

    https://wiki.archlinux.org/title/Xdg-utils

    https://juejin.cn/post/6844903944922087438

使用首选程序打开一个文件或链接，比如打开文件文件管理器、打开邮件、打开浏览器，统一到一个工具下面了

    xdg-open — opens a file or URL in the user's preferred application

xdg-utils 从 utils 后缀我们可以知道这是一组工具，目的就是能够让应用轻松的集成在用户的桌面环境，不必考虑特定的用户运行桌面环境。

这组工具集包括：

    xdg-desktop-menu - 安装桌面应用菜单项
    xdg-desktop-icon - 在用户桌面安装图标
    xdg-email - 使用用户默认电子邮件客户端写一封新邮件，可以使用参数指定主题、内容、附件等
    xdg-icon-resource - 为应用程序的启动程序安装一个图片资源
    xdg-mime - 查询关于文件类型处理的信息，并为新文件类型添加描述
    xdg-open - 以用户首选的应用程序打开一个URL，用于分别处理各自的URL或文件类型
    xdg-screensaver - 屏幕保护程序的控制工具，如：锁屏等
    xdg-settings - 查看、设置默认web浏览器和URL处理程序

### GNOME，Xorg，X Window，X Server，Wayland是什么关系

    https://www.zhihu.com/question/503270852

    https://zhuanlan.zhihu.com/p/134325713

    https://zhuanlan.zhihu.com/p/427637159

X window 是一个技术体系

    又叫 X 窗口系统，最初起源于1984年，是为了解决类 unix 系统的图形显示问题而推出的显示接口。它使用 unix 套接字式的 c/s 模式，从而分离出了前端和后端两部分，天生就支持远程分布。

        也就是说，应用程序和显示器不必在同一台计算机上，每一个窗口应用程序对应一个（或多个？）X Client，用户的显示界面上运行的是 X Server。注意这里本地运行的是 X server，远程服务器运行图形化程序使用的是 X client。注意这个概念只是程序实现时的术语，跟我们安装应用时本地称客户端，远程称服务端不同。

        就 X windows 桌面体系来说，天生就支持远程，XServer 和 XClient 在同一台电脑上就是连接本地桌面，通过  ssh -x 连接就是远程桌面了，没有本质区别。

    Xserver：用来处理用户输入和系统输出的指令。X server 运行在工作站上，而用户在具有更强处理能力的远程计算机上运行应用程序是很常见的。

    X11(X Window System)：Linux 桌面显示的协议。

    Xorg：是 Linux 上通用的桌面环境（后端）服务器（X11的一种具体开源实现）。它使用 X11 协议与 X client 端应用程序进行交互的应用程序，X Server 在显示器上绘制内容并发送输入事件，例如鼠标移动，单击和击键。因为它不直接传送图像数据，所以比较节约带宽。

    现在大多时候，可以把 Xorg、X11、X Server 说成 x-window 体系的同一个东西，就是 Linux 桌面的 X 后端服务器

        Xorg 的前端实现就是 X server，所以又称 Xorg xserver 或 X11 server

现在主流的 GNOME、KDE、Xfce 等桌面环境，使用的 X Window 体系都是基于 Xorg 基础之上开发，也就是桌面软件（或者是图形软件）的集合

    x window 体系的通用命令： startx 在命令行下启动桌面环境

查看当前桌面环境是什么类型

    $ echo $XDG_SESSION_TYPE

GTK+ and Qt

    这两个是 GUI toolkits 软件库，类似 c 语言的 stdio.h，win32，java 里 import 的各种外部包，可以任开发者调用（应该是 C/C++ 使用的库）去创建一些图形界面里面的控件，例如 button，下拉菜单，窗口等。我记得 JAVA 里面也有类似 AWT 和 Swing 库。用这一套库开发出的图形空间将会有一套统一的风格和标准，这就是不同系统安装的不同软件有的时候会有相同的样式，因为他们可能使用了 GTK 或者 QT 的库。

    KDE 默认使用 Qt 库开发，Gnome 默认使用 GTK+ 库开发，而这两套库又是基于 X window server 的，需要遵守 x11 协议，在 xwindow server 上运行，作为 client 应用实现的基础类库。

#### Wayland

    https://docs.freebsd.org/en/books/handbook/wayland/

    https://wiki.archlinux.org/title/Wayland

    https://zhuanlan.zhihu.com/p/503627248

    用 Wayland 开启 Linux
        https://zhuanlan.zhihu.com/p/531205278

    GNOME 设置默认 wayland 或 xorg
        https://docs.fedoraproject.org/en-US/quick-docs/switching-desktop-environments/

Wayland 是与 X Window 对等的概念，属于另一种显示标准，目的在于替代 X Window

    Wayland 只是提供一个协议的基础抽象，参考实现叫 Weston

    Gnome、KDE 等都有对应的 Wayland 实现

    不再是 Client-Server 模式，远程桌面的实现方式不同

    Wayland 使用 xwayland 兼容 X window 程序，也就是说，基于 X Window 的 VNC 远程桌面程序一样可以利用 xvnc 连接到 wayland 桌面环境。

Wayland 自带的 terminal emulator 叫 foot

    https://man.archlinux.org/man/foot.1.en
        https://codeberg.org/dnkl/foot

Wayland 环境使用 QT 应用如果启动报错，需要修改 /etc/environment

    QT_QPA_PLATFORM=wayland

### 显示管理器（DisplayManager）设置登录后的桌面环境

显示管理器又叫做 “登录管理器”，如 gdm、sddm、lightdm 等，其作用仅仅只是在你开机后，让你输入用户名和密码处理用户身份验证登录，然后引导进入桌面，至此任务完成，之后就交给桌面环境了。你可以不需要 DM，直接通过 startx脚本命令进入桌面。

    https://wiki.archlinux.org/title/Display_manager
        https://wiki.archlinux.org/title/GDM

    https://zhuanlan.zhihu.com/p/272740410

设置开机启动到桌面还是命令行，主流的桌面环境都用 systemctl 接管了，有专门的控制命令，参见章节 [桌面环境的开机自启动]。如果是启动到桌面，systemctl 会自动调度到显示管理器进行用户登录。

所以首先要确保 systemd 设置开机时启动到桌面

    # 一般都使用 systemctl 进行控制了
    $ systemctl get-default
    graphical.target

然后确保 systemd 的显示管理器服务也是启动的。

如果安装了多个桌面环境，可以在显示管理器选择启动到哪个桌面环境

    如果是本地登录，在显示管理器的用户登录界面，点击右下方的小齿轮可以选择使用何种桌面环境

    如果是 xrdp 远程登录，在 “session” 处选择

如果安装了多个显示管理器，则可以使用以下方法在它们之间进行选择

    sudo dpkg-reconfigure gdm3

    GNOME 显示管理器 gdm，在 flatpak 搜 “Login Manager Settings” 可以定制呈现界面

    KDE 的显示管理器 sddm

    Ubuntu Unity 桌面显示管理器 lightdm

    Wayland Login Manager 支持 x-window/wayland 环境的命令行下的显示管理器 wayland-lyl
    https://docs.freebsd.org/en/books/handbook/wayland/#wayland-ly

### 窗口管理器（Windows Manager）

窗口管理器 vs 桌面环境

    窗口管理器（Windows Manager），负责绘制窗口的边框，处理窗口运行比如移动、最小化之类的行为。

    桌面（Desktop Environment），是窗口管理器的超集，它使用合成器（Compositor）把多个程序窗口绘制出的内容，把它们合成出来并高效地增量更新用户界面 GUI。比如 compiz 这种基于 OpenGL 的混合型窗口管理器，用立体的方式显示窗口切换。

我们常用的 Gnome 就是一个桌面环境，默认使用 Metacity 作为窗口管理器。

常见的窗口管理器一般都基于 wlroots 库：一个为基于 wayland 的各类 wm/de（或者叫compositor）提供基础设施的项目

    https://gitlab.freedesktop.org/wlroots/wlroots

使用窗口管理器，需要自己配置软件源，自己安装字体，firefox 假死问题自己解决。

    https://zhuanlan.zhihu.com/p/47526909

    https://www.zhihu.com/question/41364792

    https://zhongguo.eskere.club/%E9%80%82%E7%94%A8%E4%BA%8E-linux-%E7%9A%84-5-%E4%B8%AA%E6%9C%80%E4%BD%B3%E7%AA%97%E5%8F%A3%E7%AE%A1%E7%90%86%E5%99%A8/2021-10-03/

平铺式窗口管理器：自动排列窗口，以不重叠的方式占据整个屏幕，自动的被调整各个窗口大小。

    i3 WM - 更好的平铺及动态窗口管理器。完全重写。目标平台是 GNU/Linux 和 BSD 操作系统。

    i3-gaps - i3-gaps 是拥有更多功能的 i3。

    sway - i3 的 wayland 实现，SwayFX 动态壁纸实现了桌面背景添加各种特效和动画

    Miracle-WM - 新出现的一个 wayland 下的平铺式窗口管理器，目标是超越 i3/sway

    Pop!_OS Shell - Pop Shell 是基于 GNOME shell 的窗口管理器，键盘驱动，自动平铺。

    Bspwm - bspwm 是一个平铺式窗口管理器，将窗口以二叉树的叶结点的方式展现。

    Herbstluftwm - 使用 Xlib 和 Glib 的手工平铺式窗口管理器。

    Qtile - qtile 是一款全功能，可 hack 的平铺窗口管理器，使用 Python 编写和配置。

    wayfire - 基于 Wayland 的 3D 混成器

        https://github.com/WayfireWM/wayfire/wiki

        配置文件位置：~/.config/wayfire.ini

        Wayfire 相关配置与美化方案 https://alancorn.github.io/blogs/2023/wayfire.html

叠加式窗口管理器：浮动式窗口管理器，由于屏幕空间有限，当前激活的窗口会浮在最上面，而遮住下面的窗口。

    labwc - 比 wayfire 更轻量级，树莓派 3 也可以使用

        https://mephisto.cc/series/labwc/

        窗口管理器labwc使用记 https://mephisto.cc/tech/labwc/
            配置文件参考 https://github.com/kmephistoh/dotfiles/tree/main/.config/labwc

    Openbox - 高度可配置，带有可扩展标准支持的下一代窗口管理器。

    2bwm - 快速的浮动窗口管理，有两个特殊边界，基于 XCB 库，由 mcwm 衍生。

    Blackbox - 快速，轻量化的 X 窗口系统窗口管理器，没有那些烦人的库依赖。

    Fluxbox - 基于 Blackbox 0.61.1 代码的 X 窗口管理器。

动态窗口管理器

    awesome - 高度可配置，下一代 X 框架窗口管理器

        https://blog.kelu.org/tech/2021/12/29/linux-awesome-wm.html

        https://blog.theerrorlog.com/switching-from-gnome-shell-to-awesome-wm-zh.html

        awesome 窗口管理器使用备忘 https://blog.kelu.org/tech/2021/12/29/linux-awesome-wm.html

    dwm - X 动态窗口管理器。它以平铺，单片镜以及浮动布局的方式管理窗口

        https://zhuanlan.zhihu.com/p/183861786

    spectrwm - 小型动态平铺 X11 窗口管理器。主要受 xmonad 和 dwm 启发。

    xmonad - 动态平铺 X11 窗口管理器，用 Haskell 编写和配置。

窗口管理器背后的工具 --- 合成器（Compositor）：

    Mutter  -  GNOME的窗口管理器和合成器

    Compton - Compton 是一款独立的合成管理器，适合同没有原生提供合成功能的窗口管理器一同使用。

    Gamescope - Gamescope 是一款微合成器，提供一个带有独立输入，分辨率和刷新率的沙盒 Xwayland 桌面。

    Sway - Sway 是平铺 Wayland 合成器，替代 X11 下 i3 窗口管理器（sway明确说不支持英伟达显卡）。

    Mir - Miracle-WM 的合成器

    Xcompmgr - Xcompmgr 是一个简单的合成管理器，能够渲染下拉阴影，使用 transset 工具的话，还可以实现简单的窗口透明。

    Compiz：OpenGL 窗口和合成管理器，能实现三维的切换窗口

        http://wiki.compiz.org/CommonKeyboardShortcuts

        Fedora 版 https://spins.fedoraproject.org/zh_Hans_CN/mate-compiz

        Compiz：2022年年中安装、配置和使用 https://ubunlog.com/zh-CN/compiz%E5%AE%89%E8%A3%85%E4%BD%BF%E7%94%A82022/

        compizconfig设置 https://blog.csdn.net/ysynhtt/article/details/44948989

        使用compiz https://blog.csdn.net/kewen_123/article/details/115871744

    Hyprland: 一个基于 wlroots 的动态平铺 Wayland 合成器，动态窗口的变换快速平滑

        https://wiki.hyprland.org/Getting-Started/Master-Tutorial/

        https://cascade.moe/posts/hyprland-configure/

        https://www.bilibili.com/read/cv22707313/

        不使用 wayland 的 Hypr --- 使用 Xorg 的窗口管理器
            https://github.com/vaxerski/Hypr

#### i3

通过键盘操作的 i3 平铺窗口管理器使用 Linux 桌面，当您开始使用 i3 时，您需要记住其中的一些快捷方式才能使用。

    https://i3wm.org/docs/userguide.html

    自定义参考

        https://github.com/Karmenzind/dotfiles-and-scripts/blob/master/home_k/.config/i3/common

        https://github.com/Karmenzind/dotfiles-and-scripts/blob/master/home_k/.config/i3status/config

        从零开始配置 i3-wm https://obster-y.github.io/zh-cn/posts/c4304786-bbc2-11eb-8847-0772b2ac4cf2/

    https://zhuanlan.zhihu.com/p/44783017

    https://zhuanlan.zhihu.com/p/51077654

    https://segmentfault.com/a/1190000022083424

在远程桌面 xrdp 下使用 i3，需要组件 xorgxrdp，参见章节 [xorgxrdp]。

安装

    # 不安装 urxvt，换为 terminator
    $ sudo dnf install -y i3 i3-ipc i3status i3lock dmenu terminator --exclude=rxvt-unicode

    $ sudo dnf group install "i3 desktop" "Window Managers"

    # 高分辨率小屏需要调整一下dpi
    $ echo 'Xft.dpi: 192' > ~/.Xresources

前导键叫 mod 键，可以由用户设定，可以是 Mod1(alt键) 或者是 Mod4(Super/Win)。

    # ++++++=定义按键变量=++++++#
    # (Mod1 = Alt, Mod4 = Super/Win)
    set $mod Mod4
    set $m_alt Mod1

    打开终端 urxvt          <mod> + <ENTER>

    使用命令区              <mod> + d ，如果输入“ i3-msg exit ",运行该命令即可退出 i3 wm

    切换到工作区 num        <mod> + num

    把窗口移到工作区 num    $mod+Shift+num

    切换窗口                Super+h或j或k或l 或者 Super+上下左右箭头

    杀掉窗口                Super+Shift+q

    退出 i3                 Super+Shift+e

窗口模式

    窗口在层叠、 标签和平铺之间来回切换    Super+s、w、e

    平铺模式切换水平或垂直               super+v、h，再开新窗口就可以看到变化了

切换模式后，新开窗口是在当前窗口区域执行你的模式，不断的在子窗口套娃。

在 i3 中，工作区是对窗口进行分组的一种简单方法。您可以根据您的工作流以不同的方式对它们进行分组。例如，您可以将浏览器放在一个工作区上，终端放在另一个工作区上，将电子邮件客户端放在第三个工作区上等等。

配置文件 /etc/i3/config 及 ~/.config/i3/config，或命令 i3-config-wizard

    # 先把屏保功能关了：
    exec --no-startup-id xset s 0

    # 黑屏、睡眠、断电时间分别设为6000s，8000s，9000s，也可以只写前一个，不必三个都写
    exec --no-startup-id xset dpms 6000 8000 9000

    # win+c 可以调出选项，你可以选择锁屏(L)，注销(O)，重启(R)，关机(S)，退出选项(Esc)。
    set $mode_system  lock(L) logout(O) reboot(R) shutdown(S) exit(Esc)
    bindsym $mod+c mode "$mode_system"
    mode "$mode_system" {
        bindsym l exec --no-startup-id i3lock -c '#000000', mode "default"
        bindsym o exec --no-startup-id i3-msg exit, mode "default"
        bindsym r exec --no-startup-id systemctl reboot, mode "default"
        bindsym s exec --no-startup-id systemctl poweroff, mode "default"
        bindsym Escape mode "default"
    }

    # 常用的软件在用户设定的工作区打开：
    # 打开URxvt的同时切换到tab模式
    for_window [class="URxvt"] layout tabbed
    # 打开软件时自动移至相应工作区
    assign [class="URxvt"] $WS1
    assign [class="Thunar"] $WS1
    assign [class="Firefox"] $WS2
    assign [class="Zathura"] $WS3
    assign [class="Gvim"] $WS4
    assign [class="Ise"] $WS5
    assign [class="VirtualBox"] $WS6

#### sway

i3 的 wayland 实现，操作热键参考 i3

    https://swaywm.org/

        https://github.com/swaywm/sway/wiki

        https://wiki.archlinux.org/title/Sway

    freebsd 全面介绍

        https://docs.freebsd.org/en/books/handbook/wayland/#wayland-sway

    sway - i3兼容Wayland compositor
        https://cloud-atlas.readthedocs.io/zh_CN/latest/linux/desktop/sway/index.html#sway

    探索 Linux 桌面全面 wayland化（基于swaywm）
        https://zhuanlan.zhihu.com/p/462322143

    Sway: 从尝试到放弃
        https://coda.world/sway-explore-and-giveup

    https://zhuanlan.zhihu.com/p/441251646
    https://blog.tiantian.cool/wayland/
    https://zhuanlan.zhihu.com/p/462322143
    https://www.fosskers.ca/en/blog/wayland

起因

之前重装系统时把桌面环境换成了 Wayland Gnome，经过一段时间的使用，感觉自己对 Gnome 这种寒酸大道至简的风格还是很满意的，不过它的窗口管理实在是有些混乱，于是萌生了试用一下平铺式窗口管理器的想法。

由于难以接受倒退回 X Server，所以 Sway 自然成了首选。然后相对于 Gnome 这种完整的桌面环境，Sway 就真的只是个窗口管理器而已，所以需要进行大量配置才能满足日常需求其实说白了我真正需要的是一个使用平铺式窗口管理器的桌面环境。

对比

虽然我个人单纯是为了更好的管理窗口而试用 Sway，不过实际上在选择平铺式/堆叠式窗口管理器的原因上确实存在更多考量。

平铺式窗口管理器

窗口被摆放的整整齐齐，强迫症狂喜！
屏幕太大了，放眼望去全是屏幕，完全没必要堆叠窗口，只要直接铺开就行了。
往往更加轻量化，对硬件的需求较低。
喜欢使用固定的布局显示窗口。
不喜欢碰鼠标，希望通过键盘进行大部分的操作。
堆叠式窗口管理器
堆叠式窗口管理器往往伴随着成熟的桌面环境，省时省力，开箱即用！
跟随主流，符合大多数人的使用习惯，也意味着碰到冷门问题的情况更少。
可以自由的摆放窗口，这点在小屏幕上优势很明显。

配置

如前文所言，Sway 只是一个单纯的窗口管理器，需要进行各种配置才能勉强达到可用的状态，由于配置太过琐碎，这里只简单的提一下其实是单纯的懒，以后有时间可能会更新详细配置。

Sway  快捷键

默认的 Terminal Emulator
字体
分辨率以及刷新率
壁纸
利用 swayidle 实现自动锁屏
Application Launcher/Status Bar 所调用的程序
窗口间距
鼠标主题 xcursor_theme
其他需要随 Sway 运行的命令(exec_always{ ... })，例如
    启动 exec /usr/bin/foo
    设置 gtk 程序主题 gsettings set org.gnome.desktop.interface foo bar
    设置 XDG_SESSION_TYPE 以及 DESKTOP_SESSION 环境变量

状态栏

Sway 有自带的状态栏 swaybar，不过目前比较热门的是 waybar

Application Launcher

一般使用 wofi，不过也可以自己写脚本配合 fzf 来实现。关机菜单也可以通过类似的方式进行生成和调用。

Display Manager

可以直接从终端启动 sway，不过我仍然使用了 GDM 作为 Display Manager，首先是因为可以自动读取 ~/.config/environment.d/*.conf 里的环境变量，其次是为了自动解锁 gnome-keyring。也不需要进行额外的设定，可以直接从登录界面选择进入 Sway。

锁屏

目前可以使用 swaylock 或者 swaylock-effects(AUR)，没有什么高级的设定，目前就显得很简陋。我也尝试过调用 GDM，不过以失败而告终。

GTK 主题

设置主题时不但要对 $XDG_CONFIG_HOME/gtk-*.0/settings.ini 进行设置，同时需要运行 gsettings set ...，总而言之就是能设置的地方都设置一遍，从而防止程序只读取特定位置的配置文件。

QT 主题

由于我没有使用任何基于 QT 的程序，所以直接省略了这个步骤。

鼠标主题

以我使用的 Breeze 主题为例，需要在多个地方进行设置，从而保证覆盖所有程序：

    环境变量 XCURSOR_THEME="Breeze"

    seat seat0 xcursor_theme Breeze 24

GTK: settings.ini 中 cursor-theme='Breeze'，以及运行 gsettings set org.gnome.desktop.interface cursor-theme 'Breeze'。

QT: 我没设置。

如果缺少设置可能会导致鼠标指针在部分程序、或者部分位置(例如标题栏)变成默认样式。

剪贴板

Sway 下默认关闭窗口时会清空剪贴板，其实我还挺喜欢这种模式的，如果希望在窗口关闭后仍旧保留剪贴板中的内容，可以通过 clipman 实现。

截图

使用 grim 实现截图功能。

系统通知

使用 mako 实现简单的系统通知。

Autostart

Sway 并不会自动运行 $XDG_CONFIG_DIRS/autostart 里的程序，需要自己写相应的 systemd user unit 实现。

结局

实际上平铺式窗口管理模式本身还是令我相当满意的，但是我还是最终放弃了把 Sway 当作主力的想法，主要原因：

窗口特效

Sway 除了给窗口加上一个简陋的标题栏和边框以外不支持任何特效，并且开发者已经坚决表示 Sway 的主要目标是稳定所以不会去支持高级特效。

虽然我个人对窗口特效的要求是简短、简约，但是 Sway 只能用简陋来形容，而明明添加一些简单的特效就能使窗口的视觉效果提升很多。

另外众所周知 X Server 走上了与混成器通信的畸形道路的原因之一就是对特效、透明、圆角边框的需求。而如今站在 wayland 的肩膀上，却不使用任何窗口特效未免显得无法物尽其用。

最后不知道是否和这个有关，同样的鼠标主题在 Gnome 和 KDE 下显示效果是一致的，但是在 Sway 下颜色就深得有点不自然。

集成度太低

就如文中反复提及的那样，Sway 仅仅是个窗口管理器而已，所以很多东西不能像使用高集成度的桌面环境时那样方便，例如很多设置需要在多个地方进行重复配置，不支持 XDG Autostart, 插上优盘后自动挂载，更别提在通知中心里面直接通过单击消息打开相应的程序这类体验了。当然这些问题都可以通过自己写代码解决，但是这种感觉真的就是 GNU/Car。

冷门

不像 i3 之类的那样热门，这直接导致了可以偷参考的配置更少，同时生态圈内的各种工具也开发缓慢。同时平铺式窗口管理器本身也相对冷门，导致在部分“喜欢弹小窗”的程序上面体验较差，当然这种体验可以通过修改配置进行改善，不过始终是多了一个步骤。

#### 使用窗口管理器需要自装组件

状态栏 waybar

    可以实现额外的功能，例如通过调用 `curl 'https://wttr.in/?format=1'` 来显示天气、调用自己写的脚本定期检查更新等。

        https://github.com/Alexays/Waybar/wiki

        示例

            https://github.com/Alexays/Waybar/wiki/Examples

            https://github.com/kmephistoh/dotfiles

锁屏 swaylock

关机菜单 wlogout，防止窗口管理器默认的 exit 时，直接就退出系统回到登录界面

壁纸软件

    swaybg  https://github.com/swaywm/swaybg
    swww    https://github.com/LGFae/swww
    mpvpaper 用 mpv 播放视频作为壁纸 https://github.com/GhostNaN/mpvpaper

### 桌面环境的开机自启动

    如果要配置登录到桌面后自动启动图形化软件，打开 Gnome Tweaks，点击 " Startup Applications" 添加即可。

RHEL 系和 Debian 系都採用了 XDG 规范，详见章节 [Linux 桌面的基本目录规范 XDG（X Desktop Group）].

#### 本地登录切换图形模式或控制台登录

Fedora 的桌面环境同时支持 x-window 和 wayland，关闭图形模式开机后会停留在控制台登录，按 ctl + alt + F1/F2/F3/F4，切换控制台使用即可：

    执行 `startx` 会在当前控制台启动一个 x-window 桌面环境，点击注销会退回到控制台

    执行 `sudo systemctl isolate graphical.target` 会启动 waylan 桌面环境，执行 `sudo systemctl isolate multi-user.target` 会退回到命令行环境。

    如果你的系统没有桌面环境， 只需要按下 Alt+Fn 键即可切换各个控制台，不需要按下 CTRL。

另见章节 [登录控制台 tty login].

#### X11 启动过程

基于 x-window 的桌面环境的启动过程

    https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login

    https://faq.i3wm.org/question/18/how-do-xsession-xinitrc-and-i3config-play-together.1.html

        https://tldp.org/HOWTO/XWindow-User-HOWTO/runningx.html

        https://dev.leiyanhui.com/c/arch-install-xrdp/

具体启动过程：

    在命令行执行 `startx` 将通过首先调用 xinit 来启动 X。

    xinit 将在用户的主目录中查找一个 ~/.xinitrc 文件，以作为 shell 脚本运行。

    xinitrc 用于设置合适的 X 环境，并启动其他程序，即我们可能希望在 X 启动后立即可用的“客户端”。

    窗口管理器或桌面环境通常是最后一个启动的应用程序。

一、设置登录终端后自动启动桌面，编辑 ~/.bash_profile 文件

    if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
        exec startx
    fi

如果要自行选择多个桌面自行启动，先编辑 ~/.xinitrc 文件

    # Here Xfce is kept as default
    session=${1:-xfce}

    case $session in
        i3|i3wm           ) exec i3;;
        kde               ) exec startplasma-x11;;
        xfce|xfce4        ) exec startxfce4;;
        # No known session, try to run it as command
        *                 ) exec $1;;
    esac

然后手工启动

    $ xinit session

    或

    $ startx ~/.xinitrc session

二、更常见的方法是 “GUI 登录”：

    X 在登录之前运行，其使用 xdm（显示管理器）用于此目的。

    登录管理器（如GDM，KDM，XDM）会查找执行 ~/.xsession。

    所以 xdm 的 ~/.xsession 大致相当于 startx 的 ~/.xinitrc。

所以，根据您启动 X 的方式，计算机将执行 ~/.xinitrc 或 ~/.xsession 文件。

在桌面启动的最后阶段，如果你从 ~/.xinitrc 或 ~/.xsession 执行 i3wm 窗口管理器，那么 i3wm 将从 ~/.i3/config 读取其初始配置。

利用这点，用户可以创建一个统一两种登录方式的单个脚本：

    `echo "exec i3" >> ~/.xinitrc`。

    # 创建 xdm 等效的符号链接
    ln -s $HOME/.xinitrc $HOME/.xsession

在启动 X11 时，将运行 .xinitrc 或 .xsession 脚本，并且脚本完成后，X11 会关闭：当 .xinitrc 完成时，也就是 X11 结束的时候，而不是当你的窗口管理器退出时才关闭。

另外，GDM 登录似乎忽略了“~/.xsession”，因此这并不能使其成为 Ubuntu 用户的选项。

#### 开机启动到命令行，直接启动显示管理器

```bash

# https://github.com/martinpitt/pitti-workstation-oci
if [ "$(tty)" = "/dev/tty1" ]; then
    export `gnome-keyring-daemon --start --components=ssh`
    export BROWSER=firefox-wayland
    export XDG_CURRENT_DESKTOP=sway
    exec sway > $XDG_RUNTIME_DIR/sway.log 2>&1
fi

```

#### 自助机 Kiosk 模式 --- 将会话限制为单个应用程序

在 GNOME 登录屏幕中，从齿轮按钮菜单中选择你的 kiosk 应用

    https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/customizing_the_gnome_desktop_environment/assembly_restricting-the-session-to-a-single-application_customizing-the-gnome-desktop-environment

    Windows 也有 https://learn.microsoft.com/en-us/windows/configuration/kiosk-single-app

单应用模式下启动 GNOME 会话，也称为 kiosk 模式。在此会话中，GNOME 只会显示您选择的应用程序的完整屏幕窗口。这样你的计算机就可以作为一台自助服务机提供公众服务了。

    $ sudo dnf install gnome-kiosk gnome-kiosk-script-session

还可以安装 remmina-gnome-session 软件包，实现开机自启动到远程桌面

    $ sudo dnf install remmina-gnome-session

#### 关闭桌面环境开机自启动

为了节约内存，可以设置成本地开机进入命令行模式，手工执行命令才进入桌面环境，或直接启动单独的图形化应用程序。

    https://www.redhat.com/sysadmin/configure-systemd-startup-targets

    https://docs.fedoraproject.org/en-US/quick-docs/understanding-and-administering-systemd/index.html#mapping-runlevels-to-targets

    https://askubuntu.com/questions/1242965/how-to-disable-gui-in-ubuntu

    https://askubuntu.com/questions/76543/

    https://superuser.com/questions/443997

    https://www.tecmint.com/change-runlevels-targets-in-systemd/

一、老式的 X-window 系统，关闭开机自启动参见章节 [X11 启动过程]。

二、对使用 systemd 管理的桌面环境

/etc/inittab 文件的说明：

    Ctrl-Alt-Delete is handled by /usr/lib/systemd/system/ctrl-alt-del.target

    systemd uses 'targets' instead of runlevels. By default, there are two main targets:

        multi-user.target: analogous to runlevel 3

        graphical.target: analogous to runlevel 5

    To view current default target, run:

        systemctl get-default

    To set a default target, run:

        systemctl set-default TARGET.target

查看登录后启动的设置选项

    $ systemctl get-default

    启动到桌面是 graphical.target，启动到命令行是 multi-user.target。

在系统运行时进行切换：

    # 切换到命令行模式，等效 init 3，在 Fedora 下会退出到控制台 ctl+alt+F2。
    $ sudo systemctl isolate multi-user.target

    # 切换到图形模式，等效 init 5
    $ sudo systemctl isolate graphical.target

设置开机自启动：

    设置为登录后启动到命令行（控制台）

        $ sudo systemctl set-default multi-user.target

    设置为登录后启动到图形界面

        $ sudo systemctl set-default graphical.target

    然后重启计算机即可

        $ sudo systemctl reboot

显示管理器也应该是启用状态

    $ sudo systemctl enable gdm/kdm/lightdm

三、利用 systemd 管理的显示管理器也可单独控制启停（内存占用还是大，不如上面的方法）

    # lightdm sddm
    $ sudo systemctl disable gdm

    也可手工启动、停止指定的显示管理器服务

        # lightdm sddm
        $ sudo systemctl start gdm

四、单独设置显示管理器服务是否开机自启动，编辑控制文件

lightdm

    https://wiki.debian.org/LightDM

    # 又说  /etc/lightdm/lightdm.conf
    echo 'manual' | sudo tee /etc/init/lightdm.override

    手工启动、停止

        startx

    如果行不通那就是用 systemd 管理了

gdm

    https://wiki.debian.org/GDM#systemd

    # 又说 /etc/gdm3/daemon.conf
    或编辑  /etc/init/gdm.conf

        stop on runlevel [0126]
        #================================================================
        #start on ((filesystem
        #           and runlevel [!026]
        #           and started dbus
        #           and (drm-device-added card0 PRIMARY_DEVICE_FOR_DISPLAY=1
        #                or stopped udev-fallback-graphics))
        #          or runlevel PREVLEVEL=S)
        #
        #stop on runlevel [0126]
        #================================================================

    手工启动、停止

        startx

    如果行不通那就是用 systemd 管理了

sddm

    https://wiki.debian.org/SDDM

    # 又说 /etc/sddm.conf
    编辑 /etc/init/kdm.conf

        stop on runlevel [0126]
        #================================================================
        #start on ((filesystem
        #           and runlevel [!026]
        #           and started dbus
        #           and (drm-device-added card0 PRIMARY_DEVICE_FOR_DISPLAY=1
        #                or stopped udev-fallback-graphics))
        #          or runlevel PREVLEVEL=S)
        #
        #stop on runlevel [0126]
        #================================================================

    手工启动、停止

        startx

    如果行不通那就是用 systemd 管理了

五、在操作系统启动分区管理设置开机后进入何种环境

直接编辑 grub 条目，在 'linux  ....' 行的末尾加 3 则等效于开机 init 3 进入命令行环境。

### 不进入桌面环境，控制台执行图形化程序

在 Linux 系统中，即使不进入桌面环境，可以在没有任何装饰、桌面或窗口管理的情况下启动应用程序，即通过命令行在控制台（console）下执行图形化程序。

#### 在 Wayland 环境控制台下执行图形化程序

GNOME 使用 Wayland 作为默认显示服务器，运行图形化程序的方式与传统的 Xorg 有所不同。Wayland 的设计更加现代化，但它的工作方式与 Xorg 有显著区别，因此需要一些额外的步骤来在控制台下运行图形化程序。

以下是在 Wayland 桌面环境（如 GNOME）中，不进入桌面环境，直接在控制台下运行图形化程序的方法：

1、确保 Wayland 会话已启动

Wayland 需要一个运行的会话（session）来管理显示和输入。如果你没有进入桌面环境，可以通过以下方式启动一个 Wayland 会话：

使用 gnome-shell 启动 Wayland 会话

    gnome-shell --wayland --display-server

这会启动一个 GNOME Shell 实例，并使用 Wayland 作为显示服务器。

2、设置 WAYLAND_DISPLAY 环境变量

Wayland 使用 WAYLAND_DISPLAY 环境变量来指定显示器的连接。你需要设置这个变量，以便图形化程序知道如何连接到 Wayland 服务器。

首先，查找当前运行的 Wayland 显示服务器的名称。通常，Wayland 显示服务器的名称类似于 wayland-0 或 wayland-1。你可以通过以下命令查找：

    ls /run/user/$(id -u)/wayland-*

假设输出是 /run/user/1000/wayland-0，那么你可以设置环境变量：

    export WAYLAND_DISPLAY=wayland-0

3、运行图形化程序

权限：你需要有权限访问 Wayland socket。这通常意味着你需要以启动 Wayland 会话的同一个用户身份运行图形化程序。

    如果你不是以启动 Wayland 会话的用户身份登录，你可能需要给当前用户权限
    注意：Wayland 更加安全，不提供像 X11 的 xhost 这样的简单权限机制
    你可以考虑使用 machinectl shell 或者 systemd-run --user 来获得访问权限

设置好 WAYLAND_DISPLAY 环境变量后，你可以直接在控制台中运行支持 Wayland 的图形化程序。例如，运行 gedit：

    #  对于一些同时支持 Xorg 和 Wayland 的图形化程序，设置 GDK_BACKEND 指定使用 Wayland 后端
    # export GDK_BACKEND=wayland

    gedit

如果程序支持 Wayland，它会在 Wayland 会话中显示出来。

如果在运行图形化程序时遇到权限或会话相关的问题，可以使用dbus-run-session命令来启动程序，它会在一个新的 D-Bus 会话中运行指定的命令，确保程序能够正常访问所需的服务和资源。例如：

    dbus-run-session gnome-calculator

需要注意的是，直接从 TTY 启动图形化程序的方式在 Wayland 上不如在 X11 上常见或直接。如果你遇到困难，最简单的办法可能是切换到已有的 Wayland 会话中去启动应用，或者使用 XWayland（一种兼容层，允许你在 Wayland 会话中运行 X11 应用程序）

    运行 Xwayland 来兼容一些只能在 Xorg 上运行的图形化程序。可以先确认 Xwayland 是否正在运行：

        ps ax | grep xwayland

    如果 Xwayland 正在运行，可通过设置DISPLAY环境变量来使用它运行图形化程序，例如：

        export DISPLAY=:0
        firefox

要切换到现有的 Wayland 会话，可以使用类似 loginctl 或 machinectl 的工具，具体取决于你的系统配置。例如：

    # 列出所有会话
    loginctl list-sessions

    # 假设你想切换到会话 ID 为 1 的会话
    loginctl attach 1

    # 或者使用 machinectl shell 直接进入会话
    machinectl shell :1 /bin/bash

4、使用 weston 作为 Wayland 合成器

如果你没有使用 GNOME Shell，而是希望启动一个轻量级的 Wayland 会话，可以使用 weston（一个独立的 Wayland 合成器）。首先安装 weston：

    sudo apt install weston  # 对于 Debian/Ubuntu
    sudo dnf install weston  # 对于 Fedora

然后启动 weston：

    weston

启动后，weston 会创建一个新的 Wayland 会话。你可以在 weston 终端中运行图形化程序。

5、使用 sway 作为 Wayland 合成器

sway 是一个兼容 Wayland 的平铺式窗口管理器，类似于 i3。你可以使用 sway 来启动一个 Wayland 会话：

    sway

在 sway 会话中，你可以直接运行支持 Wayland 的图形化程序。

6、检查程序是否支持 Wayland

并非所有图形化程序都原生支持 Wayland。你可以通过以下方式检查程序是否支持 Wayland：

查看程序的文档或官方网站。

使用 env WAYLAND_DEBUG=1 <程序> 运行程序，观察输出中是否有 Wayland 相关的日志。

如果程序不支持 Wayland，它可能会回退到 XWayland（Wayland 的 X11 兼容层）。XWayland 会自动处理 X11 程序的显示，因此你仍然可以运行这些程序。

7、使用 dbus-run-session 启动独立会话

如果你希望在一个独立的会话中运行图形化程序，可以使用 dbus-run-session：

    dbus-run-session -- gnome-shell --wayland --display-server

然后在新会话中运行图形化程序。

8、远程运行 Wayland 程序

如果你通过 SSH 连接到远程机器，并希望运行 Wayland 程序，可以使用 waypipe 或 ssh -X（通过 XWayland 运行程序）。

使用 waypipe

waypipe 是一个用于远程运行 Wayland 程序的工具。首先安装 waypipe：

    sudo apt install waypipe  # 对于 Debian/Ubuntu
    sudo dnf install waypipe  # 对于 Fedora

然后在远程机器上运行：

    waypipe ssh user@remote_host gedit

另一个说法：

    ssh -Y user@remotehost waypipe ssh xclock

    这里的 -Y 参数启用了信任的 X11 转发，而 waypipe ssh 则确保了 Wayland 流量能够正确地被转发到客户端16。

总结

在 Wayland 环境下运行图形化程序的关键是：

确保 Wayland 会话已启动（如 GNOME Shell、Weston 或 Sway）。

设置 WAYLAND_DISPLAY 环境变量以连接到正确的 Wayland 显示服务器。

运行支持 Wayland 的图形化程序。

如果程序不支持 Wayland，它会通过 XWayland 运行，因此你仍然可以在 Wayland 会话中使用它。

#### 在 Xorg 环境控制台下执行图形化程序

1、确保已安装图形化程序所需的依赖

首先，确保系统中已安装所需的图形库和依赖项。例如，如果你要运行一个基于 GTK 或 Qt 的应用程序，需要确保这些库已安装。

2、设置 DISPLAY 环境变量

图形化程序需要知道将图形输出到哪个显示器。通常，Xorg 服务器会管理显示器的连接。你需要设置 DISPLAY 环境变量来指定显示器。

    export DISPLAY=:0

这里的 :0 表示第一个显示器。如果你有多个显示器或 X 服务器实例，可能需要调整这个值。

3、启动 Xorg 服务器（如果未运行）

如果 Xorg 服务器未运行，你需要手动启动它。可以使用 startx 命令来启动 Xorg 服务器：

    startx

启动后，Xorg 服务器会在后台运行，并准备好接收图形化程序的输出。

4、在控制台中运行图形化程序

设置好 DISPLAY 环境变量后，你可以直接在控制台中运行图形化程序。例如，运行 gedit 文本编辑器：

    gedit

程序应该会在 Xorg 服务器管理的显示器上显示出来。

5、使用 xinit 启动单个程序

如果你只想运行一个图形化程序而不启动完整的桌面环境，可以使用 xinit 命令。例如：

    xinit /usr/bin/gedit -- :1

这里的 :1 表示使用第二个显示器（如果 :0 已被占用）。

6、使用 xvfb 虚拟显示器（无头环境）

如果你在没有物理显示器的服务器上运行图形化程序，可以使用 Xvfb（X Virtual Framebuffer）来创建一个虚拟显示器：

    Xvfb :1 -screen 0 1024x768x24 &
    export DISPLAY=:1
    gedit

7、使用 ssh -X 远程运行图形化程序

如果你通过 SSH 远程连接到 Linux 系统，可以使用 ssh -X 或 ssh -Y 来启用 X11 转发，然后在远程终端中运行图形化程序：

    ssh -X user@remote_host
    gedit

图形化程序会在本地显示器上显示。

总结

通过设置 DISPLAY 环境变量并确保 Xorg 服务器正在运行，你可以在不进入桌面环境的情况下从控制台运行图形化程序。如果是在无头环境中，可以使用 Xvfb 来创建虚拟显示器。

> 利用显示管理器直接执行图形化应用程序

    https://wiki.archlinux.org/title/Display_manager#Starting_applications_without_a_window_manager

设为桌面登录后，将立即启动设置的应用程序。当您关闭应用程序时，您将被带回登录管理器（与注销正常的桌面环境或窗口管理器相同），只需要编辑 /usr/share/xsessions/web-browser.desktop

```ini
[Desktop Entry]
Name=Web Browser
Comment=Use a web browser as your session
Exec=/usr/bin/google-chrome --auto-launch-at-startup
TryExec=/usr/bin/google-chrome --auto-launch-at-startup
Icon=google-chrome
Type=Application
```

> 利用 systemd 单元，不使用显示管理器，直接登录 xorg 桌面

    https://wiki.archlinux.org/title/Systemd/User#Automatic_login_into_Xorg_without_display_manager

感觉这 systemd 管的越来越多，直接做一个 systemd 操作系统得了。

另一个说法：X11 在命令行手工执行图形化应用程序

    https://wiki.archlinux.org/title/Xinit#Starting_applications_without_a_window_manager

一、对老式的 x 系统

    startx nautilus

编辑 ~/.xinitrc 文件

    exec chromium

在命令行环境执行 `startx` 会进入 x11 的桌面环境，注意如果是 Fedora Silverblue 的 x11 桌面会无法从终端进入 toolbox

在桌面选择 logout 即会退出到命令行环境。

二、如果要用 x-window 開啟後自動啟動應用程式,請自行修改或是新增 .desktop 檔案：

System-wide autostart directories:

    /etc/xdg/autostart

    /usr/share/autostart

    User specific autostart directories:

    ~/.config/autostart

    ~/.kde/share/autostart (KDE specific)

    ~/.kde/Autostart (KDE specific)

我們來看看基本的 .desktop 檔案內容有哪些

    [root@benjr ~]# cat ~/.config/autostart/gnome-terminal.desktop

    [Desktop Entry]

    Type=Application

    Exec=gnome-terminal

    Hidden=false

    X-GNOME-Autostart-enabled=true

    Name[en_US]=test

    Name=test

    Comment[en_US]=xdg testing

    Comment=xdg testing

    Type=Application

    Exec=gnome-terminal

最重要的就是指定要執行哪一個程式，这样实现在命令行直接启动图形化应用程序，无需进入桌面环境。

    Hidden=false

    X-GNOME-Autostart-enabled=true

    Name[en_US]=test

    Name=test

    Comment[en_US]=xdg testing

    Comment=xdg testing

### 远程桌面 vnc/rdp/mstsc

    就 X windows 桌面来说，本来就没有不远程的，XServer 和 XClient 放在一台电脑上就是本地桌面，通过  ssh -x 连接就远程了，没有本质区别。

远程桌面：当你从另一台电脑上想要通过图形化界面操作远程 Linux 时需要用到。常见的图形化远程桌面连接协议是 RDP 和 VNC。

    Linux 下的远程桌面体系很多 VNC(TigerVnc)等，适应 X Window(X11)、Wayland 等桌面体系

    Windows 下的远程桌面工具是 mstsc，使用 Microsoft RDP(Remote Desktop) 体系

VNC 是大部分 Linux 发行版默认的基于 RFB 协议的远程桌面程序

    对服务器端基于 X Window 的桌面环境来说，vnc server 的实现是基于 Xserver 后端的，直接给前端的 vnc viwer 传输图像数据。

    Xvnc： 是一种 X11 server，它能独立运行，它已经包含了 Xserver，无需系统安装 Xserver 库，但需要一个桌面端去操作它。

    x11vnc：Xvnc 包含自己的 XServer, x11vnc 却不包含。x11vnc 也是一种 VNC server，它需要一个正在运行的 X server，如 Xvnc，或 Xvfb。

技术上的差别

    VNC 主要传图像，适用于瘦客户端。

    RDP 主要传指令，适用于低速网络。此外微软还有针对 RDP 的软件增强技术 RemoteFX 加速传输速度。

    对 Wayland 桌面来说，其使用 xwayland 模块兼容 X window 程序

如果需要使用老式的 x11（XDMCP协议）图形窗口连接到 Xserver(X.org)，建议安装使用 MobaXterm/Xshell 的免费版。

现在比较流行在 Windows 和 Linux 的远程桌面都使用 RDP 协议 的工具：

    输入你要连接的机器的 IP 地址，一般前缀为 rdp://

具体实现上，差别很大，远程主机安装服务端，客户机使用客户端软件进行连接

    https://zhuanlan.zhihu.com/p/630641235

还有更多的方式比如 web 可以实现远程桌面

    https://devicetests.com/share-linux-desktop-web-browser

#### 远程桌面软件体系

在命令行界面下，远程管理 Linux 服务器都使用基于 SSH 协议的命令行管理方式。而 Linux 桌面环境下，有多种体系：

RDP 协议(倾向于传输指令，适用于低速网络)

    RDP 服务器端软件

        Linux 内置 rdp 协议的服务端，

            可单独安装 xrdp 支持多个远程桌面用户同时登录，参见章节 [使用 xrdp 服务端]

        Windows 内置 rdp 协议的服务端

    RDP 客户端软件

        Linux 的 Gnome 桌面内置 Connections(gnome-connections)

            推荐安装 Remmina，支持剪切板、支持共享文件夹等高级功能

        Windows 使用内置的 mstsc.exe

VNC（基于 RFB 协议倾向于传输图像，适用于瘦客户端）

    VNC 服务器端软件

        Linux 内置 vnc 协议的服务端

            可单独安装 TigerVNC 支持多个远程桌面用户同时登录，参见章节 [使用 TigerVNC Server]

        Windows 安装 TigerVNC 软件的服务端

    VNC 客户端软件

        Linux 的 Gnome 桌面内置 Connections(gnome-connections)，或安装 Remmina

        Windows 安装 TigerVNC 软件的客户端

使用 NX 技术体系的 X2GO

        https://wiki.x2go.org/doku.php/doc:newtox2go

    X2Go 基于 NoMachine 的 NX 远程桌面协议，通过利用主动压缩和缓存解决低带宽和高延迟的网络连接问题

    由远程桌面服务器和客户端组件组成

        $ sudo dnf install x2goclient
        $ sudo dnf install x2goserver

    X2Go 的服务端目前只支持部署在 Linux 上，因为利用 ssh 加密，所以登录时要输入你的 SSH 登录名和密码。
    X2Go 的客户端支持各个平台部署，而且可以把 rdp 客户端工具如 xfreerdp 作为自己的后端，这样就可以连接 rdp 协议的服务器了。

其它商业软件，自成体系

    TeamViewer 商业版本，免费使用有期限

    rustdesk，国人团队，可以自建开源服务器

        https://rustdesk.com/docs/en/self-host/

> Linux 下的客户端工具

1、Gnome 内置的客户端软件名为 “连接 Connections(gnome-connections)”，同时支持 rdp 和 vnc 协议。

软件 virt-manager 自带 virt-viewer，在软件商店里叫 remote viewer。

2、基于 FreeRDP 的客户端软件

推荐使用图形化工具 Remmina，同时支持 rdp 和 vnc 协议，可配置项目很多，详见章节 [使用 Remmina]。

xfreerdp 是命令行客户端，替代了已不再开发的 rdesktop

    https://github.com/FreeRDP/FreeRDP/wiki
        命令行参数比较独特 https://github.com/awakecoding/FreeRDP-Manuals/blob/master/User/FreeRDP-User-Manual.markdown
        可以有配置文件 https://github.com/awakecoding/FreeRDP-Manuals/blob/master/Configuration/FreeRDP-Configuration-Manual.markdown

    有问题先看看 FAQ https://github.com/FreeRDP/FreeRDP/wiki/FAQ
        连接 Win7 需要指定低级tls版本 https://github.com/FreeRDP/FreeRDP/wiki/FAQ#windows-7-errconnect_tls_connect_failed

    xfreerdp /u:”username” /v::3389

        /d: 指定域
        /u: 远程计算机的登录用户
        /v: 远程计算机的ip 地址或主机名:端口
        /w and /h: 设置远程桌面窗口的宽度和高度
        /dynamic-resolution: 根据本地窗口大小动态调整远程桌面窗口的宽度和高度
        /f: 全屏
        /bpp: 桌面颜色位深，一般设置为32,低速网络改为 16、8
        /sound: 开启声音设备重定向，值一般是 sys:pulse 或 sys:alsa，跟本地Linux系统的声音设备相关
        +clipboard: 开启剪贴板
        -wallpaper: 关闭显示远程壁纸
        /a:drive,home,/home：重定向指定的设备，包括路径、打印机等
            https://github.com/FreeRDP/FreeRDP/wiki/CommandLineInterface#plugins
            /drives 或 /home-drive: 把所有本地驱动器重定向到远程
            /printer: 把所有本地打印机重定向到远程
            /usb: <usbid>is a string like dev:054c:0268 when use `lsusb`

        也可以用 posix 命令行形式，但是会太长 https://github.com/awakecoding/FreeRDP-Manuals/blob/master/User/FreeRDP-User-Manual.markdown#alternate-syntax

    $ xfreerdp /v:54.226.239.0:3389 /u:"Administrator" /cert:tofu /p:password +clipboard -wallpaper /w:800 /h:600 /dynamic-resolution /f /sound:sys:pulse

原 rdesktop <ip>

    rdesktop -f -r clipboard:PRIMARYCLIPBOARD -r disk:mydisk=/home/$(whoami)/win-share-dir <ip>

        -f 全屏
        -r clipboard:PRIMARYCLIPBOARD 是实现剪切板共享，也就是物理机复制虚拟机粘贴。
        -r disk:mydisk=/device 实现文件夹共享，mydisk是名字，可以随便取，/device是物理机上用于共享的文件夹
        ip ： 虚拟机的IP

        按 `ctrl + alt +回车` 退出或进入全屏模式。

因为 Linux 支持多种桌面环境如 gnome、ked、i3 等待，各个远程桌面的客户端软件，登录后的默认桌面各不相同，详见各软件的说明。

#### 使用 Remmina 客户端软件

支持多种远程桌面/远程连接的客户端软件，必备软件

    https://zhuanlan.zhihu.com/p/26879292

> 快捷使用

    在地址栏左侧的下拉菜单中选择 RDP/VNC 协议。

    在地址栏中输入服务器的IP地址，然后按下 回车。

    当连接开始时，会打开另一个连接窗口。初次连接会提示服务器端的 ssl 指纹，确认即可。根据服务器的设置，你可能需要等待，直到服务器用户允许连接，或者你可能需要提供密码。

    输入登录用户名和密码，然后按 OK。该密码可以在服务器端的远程桌面设置里找到，对gnome内置的远程桌面功能，服务器重启后该密码会强制变化，也即有效性是受限的。

连接后默认使用的分辨率是很低的，除了更改配置文件外，还有几个设置只能在工具栏点击设置：

    点击按钮 “Toggle dynamic resolution update”，实现可以自动适应本机窗口大小调整远程桌面的分辨率

    点击按钮 ““Toggle fullscreen mode”，实现全屏模式

    点击按钮 “Grub all keyborad events”，实现可以在远程桌面计算机的 alt+tab 热键切换窗口

    点击三个点可以在各个配置文件间切换选择

    运行过程中如果修改了配置文件，单击 refresh 可以立即生效。

当处于全屏模式时，注意屏幕上边缘的白色窄条，鼠标划过会显示 Remmina 工具栏，当你需要离开全屏模式或改变一些设置时，你可以把鼠标移到它上面。

> 给你的远程连接建立一个配置文件

如果需要调整配置如共享文件夹、播放声音等功能，需要给你的远程计算机新建一个配置文件

    点击左上角的 + 号，弹出一个新窗口，输入名称

    在 “Protocol” 列表选择 “RDP”

    在 “Server” 填入要连接的远程服务器的 ip

    在 “Username” 和 “Password” 填入登录该服务器的用户名和密码。注意如果服务器使用的是gnome内置的远程桌面功能，服务器重启后密码会强制变化，你的这个连接需要重新设置密码。

注意这里有个坑，没有其它选项可选，先点击保存以关闭该窗口。

然后在 Remmina 的主窗口列表中找到刚建立的配置文件，右键菜单选择编辑：

    Basic:

        Group 设置分组，同组的多个远程桌面会共用一个 remmina 窗口，切换时会自动断开上一个。

        桌面分辨率选 “use client solution”，不然默认显示超小的一个屏幕。

        Network Connect type 选 “auto-detect“，不然默认是低速网络

        共享文件夹 Share folder: "host_dl,/home/user/Downloads;host_vd,/home/user/Videos;" 这样就实现了在远程服务器映射本地的两个文件夹，名为 host_dl 和 host_vd。

            共享文件夹应显示在远程计算机资源管理器的 other devices and drives（本地磁盘C:图标的下方），实质是映射的 Windows 网络邻居里的 \\tsclient\host_dl\ 目录，所以先在资源管理区里点击网络，提示开启网络发现时选择确定，这样才能确保映射成功。

            目前 Windows 10 的安全策略限制从 smb 共享文件夹执行文件，所以如果要从共享文件夹里安装程序，要先拷贝到远程计算机的本地磁盘然后再执行安装程序

    Advance:

        Quality：best，不然默认画质是低速网络下的传输速率，桌面背景是黑色的

        Audio output mode：local 可以把远程的声音转发到本地播放，质量不好，忍了

        安全性：选择自动或rdp

        共享剪贴板 turn off clipboard sync：默认不勾选就是放开的，可以复制粘贴文字，不支持粘贴文件和文件夹，只能使用上面共享文件夹的方式传输文件。

单击 save 会自动关闭该窗口。

然后就可以连接该远程服务器了，在 Remmina 窗口的下半部分列表中，选择你的刚才建立的配置文件，双击即可开启远程桌面窗口了。

如果连接失败，可以点工具栏的三个横线，选择“Debugging”，然后重新连接，查看“Debugging”窗口的输出内容

    如果显示的信息偏少看不到具体报错原因，则需要用命令行启动 remmina：

        https://gitlab.com/Remmina/Remmina/-/wikis/Usage/Remmina-debugging
        $ G_MESSAGES_PREFIXED=all G_MESSAGES_DEBUG=all remmina

        # flatpak安装的
        $ G_MESSAGES_PREFIXED=all G_MESSAGES_DEBUG=all flatpak run org.remmina.Remmina

    我遇到的是缺少 openH264，在命令行启动 remmina 才看到报错提示：Failed to create h264 codec context,libfreerdp returned code is 00000000。发行版一般都提供这个软件的安装包或单独的存储库。

#### 配置远程桌面服务端必做

如果服务端计算机安装 Linux 时启用了磁盘加密选项，则每次开机时必须在本地手工输入密码才能启动操作系统，然后远程用户才可以使用远程桌面登录。

服务端要禁止桌面息屏、禁止休眠、禁止自动屏幕锁定

    操作系统的设置默认节能策略导致 Linux 桌面环境不定什么时候就锁屏或休眠，导致无法远程桌面登录。

        Setting -> Power：

            禁用屏幕空白 Screen Blank: Never

            禁用自动挂起 AutoSuspend: off

            严重怀疑节能策略不是高性能而是均衡、节能啥的，还会自动休眠

                # https://wiki.debian.org/Suspend
                $ sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

                $ systemctl status hibernate.target
                ...
                Loaded: Masked
                ...

        Setting -> Privacy -> Screen Lock:

            关闭自动锁屏延迟 Blank Screen Delay: Never
            禁用自动屏幕锁定 Automatic Screen Lock: Off

    如果是使用 gnome 内置的远程桌面，可以通过下载安装插件 “allow locked remote desktop”，这样服务端本地登录后桌面锁定了，仍可以远程桌面登录服务端计算机了，这样能解决自动锁屏导致的无法连接问题，但对计算机休眠无法解决。

日常使用中，必须使用 ssh 本地端口转发的方式把远程桌面连接保护起来

    VNC 协议本身没有加密或保护，所以你通过它发送的任何东西都可能被泄露

    rdp 协议使用密码连接安全性不高，特别是在互联网下使用的服务器对外开启远程桌面端口，则必须使用 ssh 连接或 2FA 把该远程桌面的端口保护起来

既保险又实用的方式，就是用 ssh 隧道保护远程桌面双方的通信，参见章节 [Linux xrdp 远程桌面的 ssh 端口转发](home_great_wall think)。

#### 使用 Gnome 远程桌面

Gnome 自带远程桌面服务端，主要支持 RDP

    https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/getting_started_with_the_gnome_desktop_environment/remotely-accessing-the-desktop-as-a-single-user_getting-started-with-the-gnome-desktop-environment

    https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html/using_the_desktop_environment_in_rhel_8/accessing-the-desktop-remotely_using-the-desktop-environment-in-rhel-8#doc-wrapper

    https://linux.cn/article-14261-1.html

    https://www.addictivetips.com/ubuntu-linux-tips/how-to-use-the-new-gnome-shell-remote-desktop-feature/

    https://www.linuxmi.com/ubuntu-22-04-rdp-remote-desktop.html

同时支持 X11 和 Wayland 两种方式

    对 X11 会话中使用 vino 组件

    对 Wayland 会话使用 gnome-remote-desktop 组件

同时支持 VNC 和 RDP 两种协议

    原 Xorg 体系使用 VNC 协议，在使用 Waylande 之后改为 RDP 协议了，但仍然通过 xvnc 提供对 VNC 协议的支持。也就是说，客户端使用 rdp 或 vnc 协议都可以连接到 Gnome 桌面，只是会话类型不同

        https://discussion.fedoraproject.org/t/how-to-share-fedora-36-gnome-desktop-with-another-machine-running-linux/76182

        https://discussion.fedoraproject.org/t/after-upgrading-to-fedora-38-cannot-connect-to-computer-using-remote-desktop/82353?replies_to_post_number=12

GNOME “远程桌面” 服务端拆分为 2 个功能，应该是从安全性上考虑的

    桌面共享（Desktop sharing）：原来叫“共享屏幕”，使用上限制必须本地用户登录桌面，本地用户可以随时接管鼠标中断远程连接，类似 Windows 的 “远程协助”

    远程登录（Remote login）：不需要本机事先登录桌面就可以使用远程桌面，即支持无头会话 Headless session 模式。

客户端软件兼容性较好，只要支持 rdp 或 vnc 协议即可连接到服务端。

如果需要登录云服务器，或支持多个远程桌面用户同时登录，则只能安装第三方 vnc 或 rdp 软件

    推荐安装使用 RDP 协议的第三方软件，见章节 [使用 xrdp 服务端]。

    如果使用 vnc 协议，见章节 [使用 TigerVNC Server]。

    使用第三方 vnc 或 rdp 服务端，记得关闭操作系统内置的远程桌面服务，以防止端口冲突。

参见章节 [远程桌面软件体系]。

##### 桌面共享（Desktop sharing）的服务端设置

桌面共享的使用上限制较多，不得不整理出来供查阅。

先检查是否满足章节 [配置远程桌面服务端必做]。

默认情况下，Gnome 桌面共享功能是关闭的，需要手动开启：

    在系统设置找到“远程桌面”，选择打开“屏幕共享“。

    如果你希望能够从客户端控制屏幕，请勾选 “允许连接控制屏幕 Allow connections to control the screen”。如果不勾选这个按钮，访问共享屏幕将只允许 “仅浏览 view-only”。

    登录用户使用的当前用户名，但是密码是独立的，默认的随机密码，每次计算机重启后都会变更。只要本地计算机重启了，都要进入系统设置的共享桌面的设置里，复制新密码给客户端使用。

客户端可以连接服务器的先决条件：

    服务器正在运行。

    Gnome 会话正在运行。

    启用了屏幕共享的用户已经登录。

    会话没有被锁定，也就是说，用户可以使用该会话。

    只支持当前登录桌面的用户把自己的屏幕实时共享给 1 个用户。

也就是说，桌面共享的使用过程是严格受控的，功能设计上本地用户优先，只能一对一：

    用户在本地主机登录到桌面，然后远程才可以连接到该主机的桌面。

    本地主机屏幕上会同步显示远程在自己计算机上的操作，并可以随时本地操作干预或中断远程会话。

        从服务器本地登录的会话将始终保持其控制模式，能够控制鼠标和键盘。

        如果会话被锁定，从客户端解锁也会在服务器上解锁。它也会把显示器从待机模式中唤醒，任何能看到服务器屏幕的人都能看到远程桌面客户端此刻正在做什么。

        客户端远程连接进入远程桌面后，你的本地桌面顶栏处有一个黄色的图标，这表明你正在 Gnome 中共享电脑屏幕。如果你不再希望共享屏幕，你可以进入菜单，点击按钮“屏幕正在被共享Screen is being shared”，然后再选择 关闭 Turn off，立即停止共享屏幕。

如果用桌面共享功能实现无人值守（HEADLESS）模式是比较繁琐的

    必须在断开本地连接之前，在系统设置里开启用户自动登录，这样只要开机启动就会自动使用该用户登录到桌面。

    防止本地主机的节能策略自动锁屏或自动休眠，详见章节 [使用远程桌面必须做的设置]。

所以，远程桌面的“远程登录”功能，更适合远程使用。

##### 多用户同时使用远程桌面连接你的Linux服务器

headless multi-user access

    https://discourse.gnome.org/t/headless-remote-desktop-setup-process/20411/2?u=vgaetera
        https://discussion.fedoraproject.org/t/how-do-i-setup-a-remote-access-solution-in-wayland/121232/3

```bash
# Server
RDP_USER="${USER}"
RDP_PASS="12345678"

sudo dnf -y install gnome-remote-desktop freerdp

sudo -u gnome-remote-desktop winpr-makecert \
    -silent -rdp -path ~gnome-remote-desktop rdp-tls

sudo grdctl --system rdp enable
sudo grdctl --system rdp set-credentials "${RDP_USER}" "${RDP_PASS}"
sudo grdctl --system rdp set-tls-key ~gnome-remote-desktop/rdp-tls.key
sudo grdctl --system rdp set-tls-cert ~gnome-remote-desktop/rdp-tls.crt

sudo systemctl --now enable gnome-remote-desktop.service

sudo firewall-cmd --permanent --add-service=rdp
sudo firewall-cmd --reload

# Client
sudo dnf -y install gnome-connections
gnome-connections rdp://host
```

#### 使用 xrdp 服务端

Gnome 等桌面环境远程桌面功能已经从使用 VNC 协议转向了 RDP 协议，但 Gnome 等桌面环境内置的共享桌面功能太弱了，通常在服务器安装第三方的 xrdp 软件包支持多种桌面环境，远程桌面连接本机无需本地用户登录，客户端使用支持 rdp 协议的 mstsc、remmina 等软件即可。

    https://wiki.archlinux.org/title/Xrdp

    很多使用经验和技巧都在 wiki https://github.com/neutrinolabs/xrdp/wiki

    https://aws.amazon.com/cn/blogs/china/vnc-or-rdp-how-to-choose-a-remote-desktop-on-the-cloud/

    https://learn.microsoft.com/en-us/azure/virtual-machines/linux/use-remote-desktop?tabs=azure-cli

    配置 xrdp 支持 2FA 登录
        https://github.com/neutrinolabs/xrdp/wiki/Using-Authy-or-Google-Authenticator-for-2FA-with-XRDP

    https://www.cnblogs.com/Ansing/p/16788086.html

远程桌面 RDP 协议体系由客户端（viewer）与服务端两部分构成。xrdp 是在 Linux 上实现 RDP 协议的开源的服务端程序。他可以实现 Windows Server 的远程桌面多终端服务，一个无头服务器支持几十个远程登录的用户同时使用桌面，适合教学、办公场景。

NOTE: 在远程桌面环境下，建议只使用软件，不要安装软件或进行系统管理等操作

    不同的发行版和桌面环境区分远程桌面用户和本地桌面用户，在执行权限和polkit等方面是有区别的，但目前并未完全测试。所以如果使用远程桌面用户安装软件，在本地登录时暂无法明确有何负面的影响。

    树莓派内置 realvnc server，对 xrdp 的支持不好，做不到开箱即用

xrdp 利用服务器桌面环境的组件实现自己的后端，其后端基于 xvnc（VNC） 或 xorgxrdp（XORG），对 Wayland 通过 xwayland 兼容模块响应其调用

    xvnc 简单地将 vnc 位图流包装在 RDP 中。所以如果你安装了 GNOME，那 xnvc 就将 GNOME 桌面远程提供给你，如果你安装了 xfce，xvnc 就将 xfce 桌面提供给你。

    对 Wayland 体系，它使用 xwayland 模块来兼容使用 X window 体系的程序。也就是说，使用 xrdp 远程桌面，系统会切换到 x11 的桌面环境，不是 Wayland 桌面。

xrdp 服务端兼容各种 RDP 客户端，如 mstsc、gnome connections、remmina、rdesktop 等。

xrdp 的组件

    xrdp：远程桌面协议 （RDP） 服务器。

    xrdp-sesman：会话管理器通过对用户进行身份验证并启动相应的 X 服务器来管理用户会话。

    xrdp-dis：运行 xrdp-dis 时不带任何参数来断开 xrdp 会话的连接。

    xrdp-sesadmin：是一个控制台程序来管理正在运行的 XRDP 会话。

安装 xrdp

    $ sudo dnf install xrdp xrdp-selinux
    $ sudo apt install xrdp

    # 如果有防火墙，记得开放端口
    $ sudo ufw allow from any to any port 3389 proto tcp

启动服务之前，记得先关闭操作系统内置的远程桌面服务，不然端口冲突

    # sudo systemctl start xrdp
    $ sudo systemctl enable xrdp --now

    $ systemctl status xrdp
    $ systemctl status xrdp-sesman

    # 验证端口已经放开，否则查看你的操作系统的防火墙设置
    $ ss -antlp | grep 3389

在配置文件 /etc/xrdp/xrdp.ini，可以配置自己的 ssl 证书。

##### 安装 xrdp 后必做设置

先检查是否满足章节 [配置远程桌面服务端必做]。

关闭 Linunx 发行版内置的共享桌面功能：二者都使用 RDP 协议默认端口 3389，会导致冲突无法连接，找到桌面设置里的共享桌面功能，选择关闭。

注销您本地的 Linux 桌面登录（logged in on the system graphical console），否则在同名用户远程连接 xrdp 时，您将遇到黑屏闪退

    与发行版内置的 Gnome 共享桌面（实质是共享屏幕）不同，xrdp 支持多用户连接，所以本地的屏幕前看不到远程连接过来的用户的操作，本地屏幕可以是用户登录等待解锁的状态。原因是基于 systemd 的操作系统，多个远程桌面会话使用同一个用户登录，会共享同一个桌面环境，这是 D-Bus 共享数据的设计 <https://github.com/neutrinolabs/xrdp/wiki/Tips-and-FAQ#why-cant-i-log-the-same-user-on-on-the-graphical-console-and-over-xrdp-at-the-same-time>

    如果本地计算机是无人值守（HEADLESS）模式或虚拟机，记得在断开本地连接之前（本地拔下显示器之前），在用户设置里“取消”自动登录，不然开机就本地登录了，无法从远程登录 xrdp 服务端了

    如果用远程桌面连接的是 xrdp 服务，断开前最好也选择注销，否则本地登录桌面也会遇到黑屏，只能用控制台方式在命令行下先停止 xrdp 服务才行。

    以下两个未验证

        # 必须有密码
        $ sudo passwd ubuntu

        # 因为默认情况下，xRDP 使用的是自签发的证书，这个证书保存在 /etc/ssl/private/ssl-cert-snakeoil/ 目录下。证书的密钥文件只能由 “ssl-cert” 用户组的成员读取。
        $ sudo adduser ubuntu ssl-cert

NOTE: 如果是互联网使用的服务器对外开启远程桌面，务必使用 ssh 连接或 2FA 保护你的远程桌面连接

    [示例：Linux xrdp 远程桌面的 ssh 端口转发](home_great_wall think)

    [xrdp 登录使用 2FA](init_a_server think)

然后远程计算机的桌面用户就可以用支持 RDP 协议的远程桌面软件连接这台计算机登录桌面了：

    主机的 xrdp 安装的时候默认配置了证书，客户端 mstsc 连接时会提示证书信息，选择接受即可。

    客户端运行 `mstsc.exe`，在 “Computer” 区域输入远程服务器 IP 地址，然后点击 “Connect”。

    客户端在连接到主机后，会出现登录屏幕，Session 选 vnc 或 xorg，输入该主机的登录用户名和密码，点击 “OK”。跟 Gnome 内置的远程桌面不同，xrdp 使用目标计算机的用户名和密码登录，不需要单独设置。

    一旦登录，你将看到默认的桌面环境，根据你操作系统的 sddm 设置是 Gnome 或 Xfce、i3 等。

远程桌面客户端工具参见章节 [远程桌面软件体系]。

##### 后端依赖 xvnc/xorgxrdp

    https://github.com/neutrinolabs/xrdp/discussions/2619

    https://github.com/neutrinolabs/xrdp/wiki/Tips-and-FAQ#how-to-choose-backend-xorgxrdp-vs-xvnc

xrdp 默认使用 xvnc 实现远程桌面的服务端后端（常用于 Fedora 系），一般操作系统都会自带如 xvnc，或者手动安装 tigervnc-standalone-server 提供优化的 VNC 服务端。

xorgxrdp：

通过安装 xorgxrdp 可以给 xrdp 添加 Xorg 方式，用于使用 X Window 的桌面环境。xorgxrdp 模块用于搭配 xrdp + X.Org Server，无法单独运作。

作为一个xrdp改进技术，为了充分利用 X window 的机制，只传递绘制命令，X11rdp 通过将 X11 绘制命令作为 RDP 绘制命令转发而不是简单地将 vnc 位图流包装在 RDP 中，以提高效率。目前看兼容性反而不好，一般用 xrdp 就够了。

    https://github.com/neutrinolabs/xorgxrdp

    设置 Fedora 使用 xorg 而不是 Wayland 作为默认的 GNOME 桌面环境

        https://docs.fedoraproject.org/en-US/quick-docs/configuring-x-window-system-using-the-xorg-conf-file/

        https://docs.fedoraproject.org/en-US/quick-docs/configuring-xorg-as-default-gnome-session/

    Debian11+xorg+i3+xrdp 桌面环境搭建

        https://blog.csdn.net/lggirls/article/details/129748427

在 xrdp 登录界面 Session 选择 xorg，则 xrdp-sesman 会使用配置文件 /etc/xrdp/xrdp.ini 中的 xorg 段激活使用 xorgxrdp 模块（Fedora 38下默认是关闭的）。对使用基于 Wayland 的 Gnome 桌面，不要开启 xorg，功能不正常。

确保你的系统安装了 X.Org server，一般是软件包 xserver-xorg-core 或 xorg-x11-server-Xorg

    ls /usr/bin |grep Xorg

测试运行

    Xorg :10 -config xrdp/xorg.conf

##### 播放远程桌面的音频

1、Fedora 内置的 PipeWire 是一个新的底层多媒体框架，支持所有接入PulseAudio，JACK，ALSA和GStreamer的程序，也支持内置的远程共享功能。

    https://wiki.archlinux.org/title/PipeWire

    https://fedoramagazine.org/pipewire-the-new-audio-and-video-daemon-in-fedora-linux-34/

2、 目前 xrdp 仍使用 PulseAudio 实现音频输出重定向，遵守服务器到客户端音频重定向是根据远程桌面实现的相关协议

    https://github.com/neutrinolabs/pulseaudio-module-xrdp

在远程服务器安装 Pulse Audio，该软件可实现在设备间传输声音，安装后操作系统的声音设备会多出一个远端输出设备，各软件连接该设备即可。

目前需要手动编译

    https://github.com/neutrinolabs/pulseaudio-module-xrdp/wiki/README

安装该模块后，远程连接到服务器即可在运行远程桌面客户端的机器上播放服务器上的声音了。

##### xrdp 远程桌面用户相对本地登录用户有权限区别

使用远程桌面客户端软件连接后，虽然输入了用户名和密码，但不像本地用户登录或gnome内置远程桌面那样某些操作不再提示密码

    系统更新仍会提示输入密码

    gnome-keyring 不会自动解锁自动保存的浏览器/ssh/gpg等密码，可使用 seahorse 图形化工具进行管理，打开软件后手工点击解锁

    有些系统设置选项无法在远程桌面登录环境下设置，比如本地开机后用户自动登录等

> 解决 xrdp 远程桌面连接后在 Gnome software 无法搜索 flatpak 程序的问题

在 Windows 使用远程桌面 mstsc 登录运行 xrdp 的 Fedora 后，Gnomes “软件” 无法搜索 flatpak 软件包，设置里看不到 flathub 存储库，只能本地登录才能看到，但是用命令行 `flatpak search` 可以搜到，而且也不影响执行 flatpak 程序。

这是因为 xrdp 会话的远程桌面用户的权限被限制，需要修改 polkit，Polkit 知识参见章节 [sudo 的替代方案 Polkit（PolicyKit）](init_a_server think)。

以下是开发者给出的脚本化解决方案

        https://github.com/neutrinolabs/xrdp/issues/2700

    先创建一个本地用户组 pk-local，然后把你的 xrdp 用户添加进去

    $ sudo groupadd pk-local
    $ sudo usermod -aG pk-local uu

    安装自定义 polkit 策略

    $ git clone --depth https://github.com/matt335672/pk-local
    $ cd pk-local

    $ sudo ./setup-pk-local --enable

    验证：The polkit actions above should be using auth_admin for an xrdp session (e.g.):-

    $ pkaction --verbose --action-id org.freedesktop.Flatpak.appstream-update
    org.freedesktop.Flatpak.appstream-update:
    . . .
    implicit any:      auth_admin
    . . .
    implicit active:   yes

> 对 Fedora 等使用 SELinux 技术的操作系统

您可能需要编辑 /etc/pam.d/xrdp-sesman 以使会话过渡到正确的 SELinux 上下文。[#2094](https://github.com/neutrinolabs/xrdp/issues/2094) 中埋藏着有关此的更多信息 。

##### Windows 远程桌面(mstsc.exe)连接 xrdp 提速

在 mstsc 连接时选择高速网络，xrdp 会自动使用 RFX 技术

    https://github.com/neutrinolabs/xrdp/discussions/2136#discussioncomment-2080012

微软从 Windows 11 开始 mstsc 不再支持 RFX，未来必须切换到 GFX 了

    https://github.com/neutrinolabs/xrdp/issues/2400

xrdp 还未实现对 GFX 的支持，对使用 xorgxrdp 的 X window 桌面用户来说,客户端使用 Windows 10 的 mstsc 才能实现提速

    https://github.com/neutrinolabs/xrdp/issues/2506#issuecomment-1387172540

RFX/GFX 技术参见章节 [虚拟机启用显卡加速](Windows 10+ 安装的那些事儿.md)。

##### 避免客户端连接时提示“证书来自不信任的证书验证机构”

需要你的客户端安装服务器的CA证书，详见章节 [Linux xrdp 使用自签名 SSL 证书](openssl think)。

#### VNC 体系

VNC 体系由客户端（viewer）与服务端两部分构成

    https://blog.csdn.net/sinolover/article/details/119735572

建议：VNC 体系传输远程显示使用图像的方式，带宽消耗较大，大多数使用 VNC 的场合，一般都可以用其它方式代替

    操作远程文件，使用 ssh 连接，或 sshfs 挂载远程文件系统即可

    使用远程的图形化软件，建议换用 xrdp 这种节约带宽的方式

安全性问题：

    因为 VNC 的协议加密方面考虑的非常少，密钥可能会明文传输，务必用 ssh 本地端口转发功能包装 VNC 访问

        ssh -FL 9901:localhost:5901 <user>@<SERVER_IP> sleep 5; vncviewer localhost:9901

历史

    VNC 是由英国剑桥大学 Olivetti & Oracle 实验室研发的一款超级瘦终端系统。它以 1998年 IEEE Internet Computing 一篇论文 《Virtual Network Computing》 的形式而问世。此研究室在 1999 年併入美國電話電報公司（AT&T）。AT&T 於 2002 年中止了此研究室的運作，並把 VNC 以 GPL 釋出，衍生出了幾個 VNC 軟體：

    RealVNC：由 VNC 團隊部份成員開發，分為全功能商業版及免費版。http://www.realvnc.com/

    TightVNC：強調節省頻寬使用。http://www.tightvnc.com/ 2001年俄罗斯一名研究生 Konstantin V Kaplinsky 在 Modern Technique and Technologies 上发表的 《VNC TIGHT ENCODER》 中创新性的提出了一种新的 VNC 编码方式:tight，并以开源 VNC 为基础加以代码实现，发布了开源版的 tightvnc。

        TightVNC 的 Unix-like 平台的支持一直停留在十几年前的 1.3 版，一直不停更新的是其 Windows 版。

    推荐 TigerVNC：基于 TightVNC 从未发布过的 VNC4 分支而来，由于 TightVNC 的工作重心放到了 Windows，对 Linux 的 X11/Xorg 架构的优化不够新，TigerVNC 注重 Unix-like 版本的开发，对新版本的 X 桌面系统的强力支持，所以在 BSD、Linux 等 Unix-like 操作系统中实现远程虚拟桌面，最好的选择是 TigerVNC。

        https://github.com/TigerVNC/tigervnc/releases

    UltraVNC：加入了 TightVNC 的部份程式及加強效能的圖型映射驅動程式，並結合 Active Directory 及 NTLM 的帳號密碼認證，但僅有 Windows 版本。 http://ultravnc.com/

    Vine Viewer：Mac OS X 的 VNC 用戶端（Mac OS 自带 VNC 服务器）。

    TurboVNC：致力于优化图像、3d的 VirtualGL 体系 https://virtualgl.org/About/Background

    這些軟體間大多遵循基本的 VNC 協定，因此大多可互通使用。例如可以使用 Windows 平台上的 ultravnc 客户端连接 Linux 平台上的 tightvnc 服务端，但最好两侧版本一致以优化性能。

一般来说，发行版的桌面环境内置远程桌面功能的 VNC 服务器端，比如 Gnome 用 vino。

安装 xrdp 时也会连带安装 xvnc，也是一个 vnc 服务器端

    `man xvnc`

用户在客户端使用 vnc viwer 即可直接远程连接桌面。

##### 使用 TigerVNC Server

Gnome 等桌面环境内置的 vnc 软件功能太弱了，通常在服务器安装第三方的 TigerVNC Server 软件包，客户端使用 TigerVNC Viwer 软件包。

    https://tigervnc.org/
        源码 https://github.com/TigerVNC/tigervnc
        二进制发布 https://sourceforge.net/projects/tigervnc/files/

    安装使用 Tiger VNC

        https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/getting_started_with_the_gnome_desktop_environment/remotely-accessing-the-desktop-as-multiple-users_getting-started-with-the-gnome-desktop-environment

        https://blog.csdn.net/qlcheng2008/article/details/122421763

        https://www.cnblogs.com/liyuanhong/articles/15487147.html

    $ sudo apt install tigervnc-standalone-server

TigerVNC 服务器安装完成后，会自动进行 update-alternatives 的操作替换系统的几个默认命令：

    使用 tigervncconfig 来在自动模式中提供 vncconfig

    使用 tigervncpasswd 来在自动模式中提供 vncpasswd

    使用 tigervncserver 来在自动模式中提供 vncserver

    使用 Xtigervnc 来在自动模式中提供 Xvnc

实际上就是为这 5 个命令创建了一个链接，实际使用时用这两组命令都可以使用。

    $ vncpasswd   设置用户密码，请勿使用 sudo 运行

安装完第三方 vnc 服务器后，记得关闭操作系统桌面环境自带的共享桌面

    找到桌面里的设置，关闭屏幕共享。这样做是为了防止 vnc 服务默认端口 5900 的占用出现冲突。

先运行 VNC 服务器，这样会启动一个虚拟桌面供客户端连接使用

    $ vncserver -localhost no -geometry 1280x720 -depth 24

    树莓派自带的 realvnc server 输出信息较人性化，会给出明确的地址

        $ vncserver
        VNC(R) Server 7.0.1 (r49073) ARMv6 (Feb 13 2023 11:37:04)
        Copyright (C) RealVNC Ltd.
        RealVNC and VNC are trademarks of RealVNC Ltd and are protected by trademark
        registrations and/or pending trademark applications in the European Union,
        United States of America and other jurisdictions.
        Protected by UK patent 2481870; US patent 8760366; EU patent 2652951.
        See https://www.realvnc.com for information on VNC.
        For third party acknowledgements see:
        https://www.realvnc.com/docs/7/foss.html
        OS: Raspbian GNU/Linux 11, Linux 6.1.21, aarch64

        On some distributions (in particular Red Hat), you may get a better experience
        by running vncserver-virtual in conjunction with the system Xorg server, rather
        than the old version built-in to Xvnc. More desktop environments and
        applications will likely be compatible. For more information on this alternative
        implementation, please see: https://www.realvnc.com/doclink/kb-546

        Running applications in /etc/vnc/xstartup

        VNC Server catchphrase: "Lunar extend mono. Brown mineral Quebec."
                    signature: 44-9f-46-4b-df-a5-2d-ff

        Log file is /home/pi/.vnc/jn-zh:1.log
        New desktop is jn-zh:1 (192.168.0.88:1)

    缺点

        客户端只能使用 realvnc viwer 进行连接，输入地址 192.168.0.88:1 注意是带虚拟桌面号的

        第一次之后，单纯运行 vncserver 会有一堆提示，要运行 vncserver-virtual 才能启动

初次运行 vncserver，会自动调用 vncpasswd 命令设置客户端访问此服务器时的密码，并询问是否要设置一个 “view-only” 密码。当然，使用 “只看” 密码登录后就只有看的份了，用户将无法使用鼠标和键盘与VNC实例进行交互。

设置完密码后，vncserver 会自动选择一个空闲的显示器编号来启动桌面。这个编号一般从1开始，也可以在启动时指定虚拟桌面所用的显示器编号。

    vncserver -list 获取所有当前正在运行的VNC会话的列表

    vncserver -kill :1 停止VNC实例，其服务器在端口5901（:1）

一般初次运行服务器时，由于没有提前配置 xstartup 配置文件，VNC 服务器会启动默认的桌管理程序，这与其他的 VNC 服务器只显示一个灰色背景的桌面有着很大的不同。

如果系统中安装了多个桌面管理程序，那还要创建 ~/.vnc/xstartup 文件，并在文件中填入想要启动桌面管理程序。

启动 GNOME 桌面

    #!/bin/sh

    xsetroot -solid grey
    gnome-session &

启动 XFCE 桌面

    #!/bin/sh

    # unset SESSION_MANAGER
    # unset DBUS_SESSION_BUS_ADDRESS

    xsetroot -solid grey
    startxfce4 &

然后赋予执行权限

    chmod u+x ~/.vnc/xstartup

每当您启动或重新启动 TigerVNC 服务器时，以上命令都会自动执行。

为了操作方便，可以创建两个脚本，用来完成服务器的启动和停止工作。

    启动服务器脚本 startvnc：

        #!/bin/sh
        vncserver -geometry 1280x1024 -localhost no :2

    停止服务器脚本 stopvnc

        #!/bin/sh
        vncserver -kill :2

注意：VNC 的客户端使用，输入端口号时有点歪

    在 “VNC服务器” 栏中输入 TigerVNC 服务的计算机的IP地址和端口号。

    此处的端口号为 VNC 服务器启动时设置的显示器识别符加上 5900。如使用的是显示器 2 此端口号就为 5902。

    并且要用 ssh 本地端口转发保护你的 vnc 连接

        ssh -FL 9901:localhost:5902 <user>@<SERVER_IP> sleep 5; vncviewer localhost:9901

如果需要将其他选项传递给 VNC 服务器，请创建 ~/.vnc/config 文件，并在每行添加一个选项

    geometry=1920x1080
    dpi=96

##### noVnc

novnc 提供了一种云桌面方案，使得用户登录网页即可使用远程服务器。noVNC 被普遍用在各大云计算、虚拟机控制面板中，比如 OpenStack Dashboard 和 OpenNebula Sunstone 都用的是 noVNC。

    https://blog.csdn.net/jgku/article/details/127832459

    https://juejin.cn/post/6915679209692233735

    Debian11.6配置 noVNC 做远程桌面服务
        https://blog.csdn.net/lggirls/article/details/129024338

noVNC 通过在网页上 html5 的 Canvas，访问远程机器上 vncserver 提供的 vnc 服务，需要在远程机器上安装 websockfy 做 tcp 到 websocket 的转化，才能在 html5 中显示出来。

用户连接远程的网页就是一个客户端，类似 Windows 下面的 vncviewer，只是此时填的不是裸露的 vnc 服务的 ip+port，而是由 noVNC 提供的 websockets 的代理，在 noVNC 代理服务器上要配置每个 vnc 服务，noVNC 提供一个标识，去反向代理所配置的 vnc 服务。

服务器搭建 novnc

    安装 vncserver: yum install -y tigervnc

    安装 Node.js：https://nodejs.org/en/download/（用于执行Websockify.js）

    下载 novnc：http://github.com/kanaka/noVNC/zipball/master

noVNC 运行时执行的脚本为 noVNC/utils 目录下的 launch.sh，配置及参数修改直接在 lauch.sh 中设置

    –listen 后面加noVNC运行时的端口，默认为6080(⻅2.2.3)
    –vnc 后面跟vnc会话的信息，如172.16.0.56:5901

    –cert 指定证书(⻅2.2.4)

    –web 用来查找vnc.html的目录.根据代码逻辑，在noVNC目录或者noVNC/utils目录下执行时都无需设置此参 数，web变量会自动在当前目录或者上一级目录查找vnc.html。

    –ssl-only 限制只能用https进行vnc远程会话，此时http访问失效。装载安全证书后，此参数才会生效，否则 noVNC进程无法运行

安装 Websockify：

    https://github.com/novnc/websockify/archive/master.zip

启动:

    nohup python /root/noVNC/utils/websockify --web /root/noVNC --target-config=/srv/nfs4/vnc_tokens 6080 >> /root/noVNC/novnc.log &

当然，最好是直接采用已有的docker镜像:

    docker pull dorowu/ubuntu-desktop-lxde-vnc

相关软件

    MobaXterm: 默认有X Window 服务，可以直接弹出 GUI

    vncviewer: 最常用的 vnc 客户端

    xming: 开源X Server，搭配Putty使用。参见：http://www.straightrunning.com/XmingNotes/

    UltraVNC：http://www.uvnc.com/（Windows环境下的 VNC Server，还有 TightVNC、TigerVNC、RealVNC 等，其中 RealVNC 不能通过 noVNC）

#### Wayland 下的远程桌面

原生使用 wayland 体系而不是使用兼容模块 xwayland 的远程桌面比较少，原理也不同，有基于 vnc 的，有基于原生 wayland 模块的。

目前的大多数远程桌面软件使用 rdp 协议 和 vnc 协议，其实现都是基于 xwindow 的，所以 wayland 环境有 xvnc 或 xwayland 组件进行兼容化的支撑，可以正常使用。

完全基于 waylande 实现的远程桌面软件较少，见下。

##### 基于 VNC 的 WayVNC

在服务器上安装后，客户端可以使用 vnc 的方式远程连接 Wayland 桌面

    https://docs.freebsd.org/en/books/handbook/wayland/#wayland-remotedesktop
        中文版 https://freebsd.gitbook.io/freebsd-handbook/di-6-zhang-freebsd-zhong-de-wayland/6.1.-wayland-gai-shu

如果你想使用 vnc 的方式连接 Wayland 桌面，傳統的 x11 VNC Server 可能就无法使用，此時要改用 WayVNC 這個新技術。

wayvnc 要求桌面或窗口管理器支持 Wayland，所以可以使用 sway - i3 兼容 Wayland compositor。

    服务器端

        https://github.com/any1/wayvnc
            https://github.com/any1/wayvnc/blob/master/FAQ.md
            https://www.mankier.com/1/wayvnc

    Wayland 环境 VNC

        https://cloud-atlas.readthedocs.io/zh_CN/latest/linux/desktop/wayland/index.html

    WayVNC 使用教學 https://ivonblog.com/posts/linux-wayvnc/

由于 Wayland 不再是 X window 系统的 cs 工作模式，WayVNC 通过 wlroots-based Wayland compositors 的 VNC server，通过附加到一个运行的 Wayland 会话，创建虚拟输入设备，以及通过 RFB 协议输出一个单一显示，来实现 VNC。

客户端可以使用 TigerVNC 进行连接。

###### 服务器端安装配置

    dnf install wayvnc

检查 sshd 配置文件 /etc/ssh/sshd_config 参数

    AllowTcpForwarding yes

    X11Forwarding yes

为确保安全，需要使用自签名 ssl 证书

    # https://github.com/any1/wayvnc#encryption--authentication
    openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
        -keyout key.pem -out cert.pem -subj /CN=localhost \
        -addext subjectAltName=DNS:localhost,DNS:localhost,IP:127.0.0.1

上面的格式只用于本机测试，内网使用需要把 localhost 和 127.0.0.1 改为你的主机名和ip

然后添加到配置文件 ~/.config/wayvnc/config

    # https://github.com/any1/wayvnc#encryption--authentication
    address=0.0.0.0
    enable_auth=true
    username=username
    password=password
    private_key_file=/path/to/key.pem
    certificate_file=/path/to/cert.pem

有2种方式启动 wayvnc 服务器:

1、简单的服务器端启动方法就是:

    # wayvnc localhost 5900
    # wayvnc 0.0.0.0
    % wayvnc -C ~/.config/wayvnc/config

wayvnc 啟動後不會有任何輸出，要關閉請用CTRL+C

在终端启动无头模式(headless)

    # https://wiki.archlinux.org/title/OpenGL#Mesa
    #   https://docs.mesa3d.org/envvars.html
    LIBGL_ALWAYS_SOFTWARE=true
    GALLIUM_DRIVER=driver  # driver 可以是 softpipe , llvmpipe 或者 swr
    export MESA_LOADER_DRIVER_OVERRIDE=zink  # 看你的显卡驱动

    XDG_RUNTIME_DIR=/tmp/ WLR_BACKENDS=headless WLR_LIBINPUT_NO_DEVICES=1 sway

2、在sway内部启动 wayvnc

    swaymsg --socket /tmp/sway-ipc.*.sock exec 'WAYLAND_DISPLAY=wayland-1 wayvnc -C ~/.config/wayvnc/config 0.0.0.0'

###### 使用客户端 wlvncc

支持 sway 的客户端软件 wlvncc

    https://github.com/any1/wlvncc

Wayland 的 VNC 客户端可以采用 wlvncc 。WayVNC 0.5 支持使用 OpenH268 RFB 协议扩展的 H.264 编码。

编译依赖:

    GCC/clang
    meson
    ninja
    pkg-config
    wayland-protocols

编译和运行:

    git clone https://github.com/any1/aml.git
    git clone https://github.com/any1/wlvncc.git

    mkdir wlvncc/subprojects
    cd wlvncc/subprojects
    ln -s ../../aml .
    cd ..  # 在wlvncc目录

    meson build
    ninja -C build

    ./build/wlvncc <address>

###### 在 ssh 隧道里安全使用客户端

使用 ssh 做本地端口转发进行保护。

如果服务器端启动正常，可以在客户端使用:

    ssh -FL 9901:localhost:5901 <user>@<SERVER_IP> sleep 5; vncviewer localhost:9901

如果一步一步操作

    ssh -L 9901:localhost:5901 user@192.168.0.243  不要关闭这个窗口

    在本機開啟 RealVNC VNC Viewer，輸入連線IP：

        localhost:9901

##### 基于 weston 的 waypipe

WayPipe 是原生支持 Wayland 的桌面客户端工具，它借助 ssh 实现远程桌面，類似 SSH X11 forwarding的技術，支持 sway 窗口管理器。

    https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/getting_started_with_the_gnome_desktop_environment/remotely-accessing-an-individual-application-wayland_getting-started-with-the-gnome-desktop-environment#doc-wrapper

    https://gitlab.freedesktop.org/mstoeckl/waypipe
        https://mstoeckl.com/notes/gsoc/blog.html

    https://ivonblog.com/posts/waypipe-wayland-over-ssh/

安装时需要 openssh 和 weston

    # dnf install openssh
    # dnf install weston
    dnf install waypipe

ssh 连接到 theserver，远程执行 weston-terminal 程序

    waypipe ssh -C user@theserver weston-terminal

启动兼容方式

    # KDE
    waypipe ssh -C ivon@192.168.1.104 startplasma-wayland

如此一來就能啟動其他不支援 Wayland 協定的舊版應用程式，但是該桌面視窗無法縮放。

本地化使用

    /usr/bin/waypipe -s /tmp/socket-local client &
    ssh -R /tmp/socket-remote:/tmp/socket-local -t user@theserver \
        /usr/bin/waypipe -s /tmp/socket-remote server -- \
        /usr/bin/weston-terminal
    kill %1

Weston 是 Wayland 的合成器（compositor），一般和 Wayland 同步发布。

    https://wiki.archlinux.org/title/Weston

    https://blog.csdn.net/hexiaolong2009/article/details/104852721

    https://cloud.tencent.com/developer/article/1445734

目前最新的 Weston 8.0.0 支持如下几种 backend：

    drm-backend

        默认后端，在 Ctrl+Alt+F4 切换到虚拟终端后直接输入命令 wetson 即可启动

    fbdev-backend

        不支持 OpenGL 硬件加速，因此只能使用 pixman 做 CPU 纯软绘操作，界面会比较卡顿。
        weston --backend=fbdev-backend.so

    headless-backend

        不带任何 UI 界面，主要用于 weston 自测试

    rdp-backend

        用于远程桌面

    wayland-backend

        先启动一个 weston
        在 Weston 终端里，输入 weston 命令再启动一个 Weston 桌面

    x11-backend

        直接在 GNOME 终端里执行 weston 命令，Weston 的界面输出，将被作为一个 X Window 送到 X Server 中去显示。

    xwayland

        它不是一个 backend，它只是 Wayland 的一个扩展功能，可以让你在 Weston 中运行 X 的程序。
        操作步骤：

            sudo apt install xwayland，安装 /usr/bin/Xwayland 可执行程序；
            weston --modules=xwayland.so，随便以哪种 backend 方式启动都可以；

        启动后，可以直接在 Weston 终端中运行 X 程序，如 x-terminal-emulator。

SSH远程启动

    weston --tty=1

ssh 启动方式需要明确指定使用哪个终端来显示。

串口启动

    sudo -E weston --tty=1

串口启动同样需要明确指定使用哪个VT来显示。

##### 基于 Weston 的 QT Wayland

    https://runebook.dev/zh/docs/qt/wayland-and-qt

    https://doc.qt.io/qt-6.2/wayland-and-qt.html

Qt 客户端可以在任何 Wayland 合成器上运行，包括 Weston --- Wayland 项目的一部分而开发的参考合成器。任何 Qt 程序都可以作为 Wayland 客户端(作为多进程系统的一部分)或独立的客户端(单进程)运行。

##### wayland 下切换使用 xorg 桌面

wayland 下可以实现远程桌面，下面的操作过时了，仅供参考

    https://www.kclouder.cn/posts/53908.html

GDM (Gnome)在 RHEL8 中使用 Wayland 作为默认显示服务器，取代了在 RHEL7 中使用的 xorg 服务器。

在 RHEL8 中，VNC 协议的地位似乎有所下降，因为 Wayland 并不支持屏幕共享和屏幕录制功能。但是，这个功能在 xorg 中仍然可用。因此，要使用 VNC Server 我们必须将 GDM 切换到 xorg，使 xorg 成为 RHEL8 默认的显示服务器。

修改 GDM 配置文件 /etc/gdm/custom.conf

取消注释 waylandEnable=false

安装配置 tigervnc

    yum install -y tigervnc-server xorg-x11-fonts-Type1

在 /etc/systemd/system/ 中创建配置文件，以便将 VNC 服务作为系统服务运行。默认情况下，VNC 服务器使用端口 5900，但是如果为 VNC 设置端口偏移量，则可以在默认端口 5900 的子端口上运行 VNC 服务器。例如我们使用 9 号端口，那么就是 5909。

    配置文件名就是 /etc/systemd/system/vncserver@:.service

编辑配置文件如下，将用户名改为自己的用户名即可，这里的用户名是“jacky”，所以这里一共需要修
改四处名称。

    vi /etc/systemd/system/vncserver@:9.service

``` ini
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=forking
WorkingDirectory=/home/jacky
User=jacky
Group=jacky
PIDFile=/home/jacky/.vnc/%H%i.pid
ExecStartPre=/bin/sh -c ‘/usr/bin/vncserver -kill %i > /dev/null 2>&1 :’
ExecStart=/usr/bin/vncserver -autokill %i
ExecStop=/usr/bin/vncserver -kill %i
Restart=on-success
RestartSec=15

[Install]
WantedBy=multi-user.target
```

启动 VNC Server。注意要切换到要使用 VNC 的账号，首次启动会提示输入用户名和密码。

    vncserver

禁用 SELINUX

    setenforce 0
    sed -i ‘s/enforcing/disabled/g’ /etc/selinux/config2、禁用SELINUX

执行以下命令在 systemctl 启用 VNC Server

    systemctl daemon-reload
    systemctl start vncserver@:9.service
    systemctl enable vncserver@:9.service

添加防火墙规则，或考虑直接禁用防火墙

    firewall-cmd -permanent -add-port=5909/tcp
    firewall-cmd -reload

连接服务器

这里我们使用 VNC Viewer 来连接 RHEL8 系统，输入 VNC Server 的 IP 地址，这里我使用的是 9 号端口，所以端口号可以使用 5909 或 9，格式如下：

    ip address:5909 或 ip address:9

确认通过 VNC Viewer 可以正常登录到 RHEL8 系统桌面。

### Linux 桌面死机怎么办

    https://blog.csdn.net/qq_39779233/article/details/114758689

    https://wiki.archlinux.org/title/Keyboard_shortcuts

查看日志

    $ journalctl -f -o cat /usr/bin/gnome-shell

桌面的图形界面突然卡住且无法操作时，尝试“登录控制台”，注销当前用户重新登录

按 CTRL + ALT + F3 会切换到控制台登录的字符界面，关于控制台登录参见章节 [登录控制台 tty login]。

输入用户名和密码登录，此时输入命令，说法太多待验证

    重启显示管理器服务： `sudo systemctl restart gdm/kdm/lightdm`

    注销桌面重新登录系统：`sudo pkill Xorg` 或者 `sudo systemctl restart systemd-logind`

    `ps -t tty1` 找到进程中 xinit/xwindow… 或 gnome-session-binary 的 pid， 然后 `kill -9 pid` 即可

    输入 `init 3` 即可停止 X window，输入 `startx` 重新启动桌面

操作完成之后等待一会儿就会重新进入桌面，系统可以正常使用了。

#### “魔法键” 大法手工重启内核reisub

彻底死机，键盘无法输入任何内容，无法进入控制台注销当前用户，可以使用“魔法键”强制重启：

    https://www.kernel.org/doc/html/latest/admin-guide/sysrq.html

    https://fedoraproject.org/wiki/QA/Sysrq

    https://wiki.ubuntu.com/Kernel/CrashdumpRecipe

    https://www.cnblogs.com/ylan2009/articles/2322950.html

    https://www.cnblogs.com/klb561/p/11013746.html

使用 Magic SysRq key 需要满足 3 个前置条件：

1、键盘上有 Print Screen(SysRq) 键

2、系统使用的内核，在编译时打开了 CONFIG_MAGIC_KEY 选项

    $ grep -F CONFIG_MAGIC_SYSRQ /boot/config-$(uname -r)
    CONFIG_MAGIC_SYSRQ=y  # y 表示已开启

3、系统配置 Magic Sysrq Key 为可用

    临时启用

        # sudo echo "1" > /proc/sys/kernel/sysrq  # Fedora 不支持这样写入
        $ sudo sysctl -w kernel.sysrq=1

    长期使用，编辑 /etc/sysctl.conf 添加如下：

        kernel.sysrq = 1

    更改配置后使用以下方式激活

        $ sudo sysctl -p

验证：

    $ cat /proc/sys/kernel/sysrq
    1

满足了前置条件，在系统死机异常时，按住 Alt 不放，顺次执行以下操作：

    按 sysrq 键，如果是笔记本键盘可能需要组合键 Fn + SysRq

    松开 sysrq 键，如果是笔记本键盘松开 Fn + SysRq

        SysRq 叫做系统请求，这个时候输入的一切都会直接由 Linux 内核来处理，它可以进行许多低级操作。

    依次按下字母 r e i s u b ，每个字母需要间隔 5-10s 再执行下一个动作。 reisub 中的每一个字母都是一个独立操作，分别表示：

        r : unRaw       将键盘控制从 X Server 那里抢回来，使按键可以穿透 x server 捕捉传递给内核

            k : Sak (Secure Access Key) 确保使用 init 进程启动的终端，防木马

        e : tErminate   向除 init 外进程发送 SIGTERM 信号，让其自行结束

        i : kIll        向除 init 以外所有进程发送 SIGKILL 信号，强制结束进程

        s : Sync        同步缓冲区数据到硬盘，避免数据丢失

        u : Unmount     将所有已经挂载的文件系统 重新挂载为只读

        b : reBoot      立即重启计算机

每按一次都等那么几秒种，你会发现每按一次，屏幕上信息都会有所变化。最后按下 b 时，屏幕显示 reset，这时你的手可以松开了，等几秒钟，计算机就会安全重启。切记不可快速连按，否则后果和扣电池拔电源线无异。

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

### 桌面环境统一密码管理器 --- keyring-daemon

密码管理器：保存 ssh、gpg 等密钥的密码，包括浏览器中 web 网站的密码、WIFI 连接密码等，实现自动填充，支持接管多种应用软件的密码管理。默认使用你的登录身份进行加密，所以在用户登录后可以实现自动解锁密码管理器。

    https://wiki.archlinux.org/title/GNOME/Keyring

现在流行的大多数 Linux 桌面环境现在都引入了密码管理器这一工具，称为 keyring 钥匙圈

    注意区别于 GPG keyring 钥匙圈，那个是维护密钥间的信任关系

    后台进程 keyring-daemon，接管已知应用的输入密码请求，统一把用户输入的密码保存起来，在应用程序请求密码和用户输入密码之间成为一个代理。

    默认使用用户的登录密码加密保存这些密码到本地，这样只要用户使用本地账户的密码登录桌面，会利用登录密码解锁钥匙圈，从而实现浏览器登录网站、使用 ssh、gpg 等都可以免除输入相关密码。

密码管理器接管了多种密码的自动保存和自动填写：

    支持流行的浏览器、办公软件、各种流行的商业软件等自动保存密码，比如在用户使用浏览器登录 web 网站时自动保存和填充密码：在初次输入密码时，系统的密码管理器会弹窗提示保存该密码，在用户确认后会被加密保存，以后在该页面需要填写密码时会自动填写。

    支持 ssh、gpg、git 等应用在鉴权时自动接管原 ssh-agent、gpg pinentry、git 凭据管理器 credential.helper 的工作：

        以 ssh 密钥登录为例，在初次使用 ssh 密钥时，密码管理器会弹框要求输入该密钥的保护密码，在用户确认后该密码会被钥匙圈加密保存，在以后使用密钥时会自动调取保存的密码。对用户来说，只要第一次使用 ssh 密钥时，在密码管理器提示要求输入密钥的保护密码时选择加入钥匙圈，则以后使用该密钥的场景下，密码管理器会在后台直接给 ssh 应用返回该密钥的保护密码，不再需要用户手工输入。当然，前提是已经用密码登录了桌面，顺便解锁了钥匙圈

            GNOME 桌面环境下的使用终端是，shell 环境下的 ssh-agent 密钥代理，需要设置变量指向 gnome-keyring-daemon，详见 [多会话复用 ssh 密钥代理](bash_profile.sh)。

            KDE 桌面环境也是类似情况。

原理：用户使用的应用程序，其读取密码的 API 调用会被密码管理器（keyring-daemon）接管

    用户在相关的应用软件中输入密码，如浏览器登录 web 网站的密码，使用 ssh、gpg 、git 时输入的密钥的保护密码，只要首次遇到的密码都会被密码管理器识别，提示用户是否保存到钥匙圈。

    保存到钥匙圈时，会使用用户本地帐户的登录密码对这些密码进行加密（也可为其设置单独的密码）。

    当用户再次遇到应用软件提示输入密码时，只要应用软件读取密码的 API 被再次调用，则密码管理器会先解锁钥匙圈（用户初次登录时需要输入登录密码），也即解密该密码（使用用户给出的登录密码），返回给相关应用的 API 调用。

密码管理与用户的交互方式：

为了使用方便，“钥匙圈”默认使用用户的登录密码进行加密，这样在用户使用密码登录系统后，密码管理器不需要提示用户输入密码解锁“钥匙圈”，这样大大方便了日常使用。

    用户可以设置钥匙圈使用单独的密码，这样的话用户使用登录密码登录系统后“钥匙圈”是未解锁的，gnome 桌面环境会在用户登录进入桌面后弹窗提示，解锁钥匙圈 “Enter password to unlock your key ring”，用户需要输入自己设置的单独密码才能解锁“钥匙圈”。

如果在登录 gnome 桌面时没有输入登录密码，比如使用人脸识别或指纹登录了桌面，系统同样会在用户登录进入桌面后弹窗提示，解锁钥匙圈 “Enter password to unlock your key ring”，用户需要输入登录密码才能解锁“钥匙圈”。

    这是因为 gnome-keyring 使用登录密码作为加密密钥，不输入登录密码就无法解锁其保存的各种密钥和密码，而 gnome-keyring 目前不支持面部识别、指纹识别的数据作为加密密钥。

如果在登录桌面后，提示输入登录密码解锁钥匙圈时，选择了取消：

    则 keyring-daemon 会把鉴权请求传回到各个应用程序，也就是自己不再接管密钥处理了。这样在应用程序需要输入密码的场合，就会像之前一样，各应用软件自行弹窗提示用户输入密码。密码管理器不会再弹出解锁钥匙圈的提示了，即便使用的是钥匙圈里保存过的加密密钥。

    因为登录后选择了不解锁钥匙圈，在系统弹窗时要仔细看下提示，到底是应用程序的密码输入界面，还是钥匙圈解锁的界面，二者的密码是不同的。

使用图形化工具可以方便的看到钥匙圈是否处于解锁状态，点击图标会提示输入登录密码解锁该钥匙圈，详见下面子章节。

> MacOS： 也有自己的密钥管理器

略

> 第三方密码管理器

KeePass 是一个免费的开源密码管理器，它可以帮助您以安全的方式管理您的密码。您可以将所有密码存储在一个用主密钥锁定的数据库中。因此，您只需记住一个主密钥即可解锁整个数据库。数据库文件使用加密算法（AES-256、ChaCha20和Twofish）进行加密。

    https://keepass.info/

    https://wiki.archlinux.org/title/KeePass

Bitwarden 可 docker 部署实现自托管

    https://zhuanlan.zhihu.com/p/130492433

#### Gnome 桌面的密码管理器应用程序

GNOME Keyring（gnome-keyring）钥匙圈

    https://cn.linux-terminal.com/?p=3195

    https://wiki.gnome.org/action/show/Projects/GnomeKeyring

    https://wiki.archlinux.org/title/GNOME/Keyring

    https://zhuanlan.zhihu.com/p/128133025

操作系统软件包 gnome-keyring 提供了各种组件实现该功能。

支持登录解锁，pam 使用 pam_gnome_keyring.so

因为代替了 ssh-agent、gpg-agent 的功能，所以 gnome-keyring-daemon 不能与之共存，使用一个即可

图形界面管理程序叫 Passwords and Keys，其命令行程序名 seahorse

    用户可以建立多个钥匙圈，普通使用为了方便保持一个就可以了。

    如果你修改了账户密码，记得还得重设钥匙圈密码。假如你不记得仍然被钥匙圈使用的老的账户密码：只能移除老的钥匙圈，也就是说你保存的那些密码也都删掉了

#### KDE 桌面的密码管理器应用程序

kde 密码管理器：KDE Wallet - 原名 KDE 钱包（KWallet），在 22 版后改名为更贴切的 KDE 密码库

    https://apps.kde.org/zh-cn/kwalletmanager5/

    https://userbase.kde.org/KDE_Wallet_Manager

    https://wiki.archlinux.org/title/KDE_Wallet

    https://www.jwillikers.com/gnome-keyring-in-kde-plasma

图形界面管理程序是 KWalletManager。

以前 KDE Wallet 支持 ssh、git，不支持 gpg，需要用 KGpg 工具自动保存和填写 gpg 的密码

        https://userbase.kde.org/KGpg

        https://apps.kde.org/kgpg/

手工调起来 kwalletd 进程：

    # KDE 桌面环境用自己的 KWallet 管理接管了全系统的密码和密钥，图形化工具可使用 kwalletmanager5 进行管理
    # systemctl --user status plasma-kwallet-pam.service
    # $(/usr/bin/kwalletd6 >/dev/null 2>&1)

> 自动填写 gpg 密码

现在的 KDE Wallet，添加钱包时，可以设置独立的密码，或使用你现有的 gpg 密钥，以此加密保存你各种的密码。建议为了方便，设置独立的密码，跟你用户登录桌面的密码相同，这样用户登录桌面后就自动解锁了你的 kde wallet。

KDE6 默认使用 gpg-agent 与 KWallet 交互，无需额外配置：

    初次使用 gpg 的签名等功能时，会自动弹出 kde 钱包的添加密钥界面，提示输入 gpg 密钥的保护密码，可选保存到 kde 钱包。

    只要选择了保存到 kde 钱包，以后使用到 gpg 密钥时，只会提示解锁 kde 钱包的密码，不会再需要输入 gpg 密钥的保护密码了

检查 GPG 是否正常工作：

    $ gpg --list-keys

测试签名，应不再提示输入 gpg 密钥的保护密码：

    $ echo "test" | gpg --clearsign

    输入 ^d 退出

> KDE Wallet 不支持自动填写 ssh 密钥的保护密码

默认情况下，KWallet 不会自动拦截或存储 ssh 密钥的保护密码，用户只能自行使用 ssh-agent 进行缓存。

    # 这个 ksshaskpass 没用
    # https://github.com/KDE/ksshaskpass
    SSH_ASKPASS=/usr/bin/ksshaskpass

KDE 桌面环境用自己的 systemd 单元文件 ssh-agent.service 服务实现复用 ssh-agent，初次使用 ssh 密钥需要手工输入SSH 密钥密码，用以下命令预加载起来即可：

    $ ssh-add

最多可以利用 kWallet 的自定义条目，记录或显示你的 ssh 密码

    进入你的 KWallet，在 Passwords->Passwords 下 new 一个新条目，起名 ssh，输入密码的内容，点击 save

    验证，在命令行查看你添加的条目，最后的参数 ddd 是你的钱包的名字，默认钱包是 kdewallet

        $ kwallet-query -r ssh ddd
        your_password

### Linux 下的 “Windows Hello” 人脸识别认证 --- Howdy

提示：

    人脸识别和指纹识别的安全性不如密码、密钥、yubi-key 等认证方式，更容易被造假，建议只用于个人电脑的宽松使用场景

基于人脸识别的认证解锁功能，使用摄像头识别面部确认用户，可用于用户登录、sudo 等需要手工输入密码的场合

    https://github.com/boltgolt/howdy

        Fedora 下的安装和设置说明 https://copr.fedorainfracloud.org/coprs/principis/howdy/

    评论很全面 https://linuxreviews.org/Howdy

    这里说了红外发射器的调试 https://wiki.archlinux.org/title/Howdy

    中文最全面的 https://wszqkzqk.github.io/2021/08/17/%E5%9C%A8Manjaro%E4%B8%8B%E9%85%8D%E7%BD%AE%E4%BA%BA%E8%84%B8%E8%AF%86%E5%88%AB/

首先你要有一个支持 “Windows Hello” 标准的内置红外发射器的摄像头 IR camera。

Howdy 通过 OpenCV 和 Python 构建，支持使用内置红外发射器的摄像头来识别用户面部。通过调用 Linux 的 PAM 身份验证系统，意味着不仅可以使用人脸识别登录桌面环境，还可以将其用于 sudo、su、polkit-1 以及大多数需要使用其他帐户密码的场景。

因为 howdy 操作 pam，所以它的程序执行和设置都需要 root 权限，添加面部模型时可以指定用户名。

Fedora 下安装 howdy

    $ sudo dnf copr enable principis/howdy
    $ sudo dnf --refresh install howdy

    可选：如果 Linux 内核不支持你的红外发射器，在这里查找安装驱动

        https://github.com/EmixamPP/linux-enable-ir-emitter

1、确定摄像头设备

摄像头一般都是 usb 设备，系统会自动识别

    $ lsusb
    Bus 001 Device 011: ID 04f2:b612 Chicony Electronics Co., Ltd USB2.0 FHD UVC WebCam

然后查看系统是否识别出摄像头设备：

列出当前所有的摄像头设备，即使只有一个摄像头，也会列出多个设备，其实是对应了不同的功能，我们主要关注 video0 和 video2

    $ ls /dev/video*

一般来说，普通摄像头是 /dev/video0 ，可以打开红外发射器的摄像头是 /dev/video2。如果你的摄像头是带红外发射器的，会有两个设备可用：设备 video0 是普通摄像头，设备 video2 是打开红外发射器下的摄像头

    开启红外发射功能可以提高识别的准确度与安全性，而且红外发射式摄像头支持全黑暗状态下的人脸识别

用 VLC 确认所选摄像头设备工作正常

    vlc 菜单中的 媒体 - 打开捕获设备 - 高级选项（advance options），选择视频捕获设备 /dev/video0， 确定 - 播放 之后显示的摄像头捕捉到的画面。如果是带红外发射器的摄像头还可以选 /dev/video2 进行测试。

可选安装：摄像头管理软件包 v4l-utils

    $ sudo dnf install v4l-utils

    列出当前所有的摄像头设备，对普通摄像头我们使用 video0

        $ v4l2-ctl --list-devices
        UVC Camera (046d:0825) (usb-0000:00:14.0-9):
            /dev/video0
            /dev/video1
            /dev/media0

        支持红外发射器的摄像头的设备更多，我们使用 video2
        $ v4l2-ctl --list-devices
        USB2.0 FHD UVC WebCam: USB2.0 F (usb-0000:00:14.0-5.4):
            /dev/video0
            /dev/video1
            /dev/video2
            /dev/video3
            /dev/media0
            /dev/media1

    后面如果运行 howdy 遇到摄像头不工作，用以下命令查看当前摄像头支持的像素尺寸

        $ v4l2-ctl -d /dev/video0 --list-formats-ext

        然后找一个合适的分辨率填写到 howdy 的配置文件中的 frame_width 和 frame_height 字段即可。

2、配置摄像头

设备路径注意区别：普通摄像头是 /dev/video0，如果你的摄像头支持红外发射器，应该选择 /dev/video2，如果选择了 /dev/video0 是不会打开红外发射器的

    $ sudo howdy config 会调用 nano 打开配置文件

    或直接手工编辑 /lib64/security/howdy/config.ini 文件

        device_path = /dev/video2

验证摄像头配置

    $ sudo howdy test

    会打开一个窗口显示摄像头的内容，如果摄像头开启了红外发射器其指示灯会闪烁，停止运行可在命令行窗口按 ctrl+c

3、对 Redhat 系等开启 SELinux 的操作系统如 Fedora，需要配置 SELinux

    https://github.com/boltgolt/howdy/issues/711#issuecomment-1306559496

编辑一个 howdy.te 文件

```conf

module howdy 1.0;

require {
    type lib_t;
    type xdm_t;
    type v4l_device_t;
    type sysctl_vm_t;
    class chr_file map;
    class file { create getattr open read write };
    class dir add_name;
}

#============= xdm_t ==============
allow xdm_t lib_t:dir add_name;
allow xdm_t lib_t:file { create write };
allow xdm_t sysctl_vm_t:file { getattr open read };
allow xdm_t v4l_device_t:chr_file map;

```

然后执行如下命令：

    $ checkmodule -M -m -o howdy.mod howdy.te
    $ semodule_package -o howdy.pp -m howdy.mod
    $ sudo semodule -i howdy.pp

4、配置 PAM 在鉴权时调用人脸识别

调整 PAM 配置，优先使用人脸识别进行验证，若人脸识别验证失败，回落到原输入密码进行验证。

pam 控制文件的说明参见章节 [PAM --- Linux 使用的安全验证方式](init_a_server think)。

> 解锁 sudo

编辑 /etc/pam.d/sudo 文件，在排除注释语句后的首行加入如下内容

    #%PAM-1.0
    auth       sufficient   pam_python.so /lib64/security/howdy/pam.py  <--要保证在最前
    auth       include      system-auth
    account    include      system-auth
    ...

    如果是你本人本机使用，可以对 su 文件做相同的修改，这样执行 su 命令也可以使用面部识别了（需要在 howdy 给 root 用户添加面部模型，见下面）

        #%PAM-1.0
        auth    sufficient  pam_rootok.so
        auth    sufficient  pam_python.so /lib64/security/howdy/pam.py <-- 添加为第二行
        ...

> 解锁登录密码和锁屏密码

编辑 /etc/pam.d/gdm-password

    auth    [success=done ignore=ignore default=bad] pam_selinux_permit.so
    auth    sufficient    pam_python.so /lib64/security/howdy/pam.py  <-- 添加在这两行之间
    auth    substack      password-auth

使用说明：

    在 sudo 会自动启动人脸识别，如果人脸识别失败，会回落到使用密码验证。

    在登录界面，人脸识别不会像 Windows Hello 那样自动启动，但是不需要输入密码，只需点击登录按钮或按回车键会优先调用人脸识别，如果人脸识别失败，会回落到使用密码验证。

    在锁屏界面中点击鼠标即可自动解锁，如果人脸识别失败，会回落到使用密码验证。

> 目前不支持解锁 gnome-keyring：

    https://github.com/boltgolt/howdy/issues/438

在通过人脸识别登录桌面后，gnome 桌面环境会弹窗提示输入登录密码解锁 gnome 钥匙圈。

原因：见章节 [桌面环境统一密码管理器 --- keyring-daemon] 里 “用户交互” 部分的解释。

解决办法：给 gnome-keyring 设置空密码，或参照指纹登录的解决办法，使用 u 盘等设备单独保存你的 gnome-keyring 密码 <https://wiki.archlinux.org/title/Fingerprint_GUI#Password>。

验证：

    $ gpg --sign some.file

如果未解锁 gnome-keyring，这里会提示输入 gpg 密钥的保护密码（不是解锁 gnome-keyring 的密码）

5、（可选）配置 polkit

    预计在 v3.0 版本彻底解决身份验证类问题

gnome 桌面环境设置系统参数的某些选项时需要点击解锁按钮，会调用 polkit-1 这样的 GUI 授权验证工具，弹出一个密码输入窗口。这里也可以添加面部识别免除输入密码。

需要手工修改 polkit 策略

    https://github.com/boltgolt/howdy/issues/630

本修改方法可能不够完善：

    面部识别跳过了 polkit-1 文件中其它的 system-auth 策略，不知道是否还有哪些受限于输入密码的开关未解锁。这个 github 用户干脆添加到 system-auth <https://github.com/boltgolt/howdy/issues/630#issuecomment-1014654035>，但是还会弹出密码提示，应该是类似 gnome-keyring 使用登录密码加密存储数据的场合，必须使用登录密码才能解锁。

    正规做法是，howdy 应该像 xrdp 那样单独申请权限响应 polkit 策略，参见章节 [xrdp 远程桌面用户相对本地登录用户有权限区别]。

编辑 /etc/pam.d/polkit-1 文件

```conf

#%PAM-1.0

auth       sufficient   pam_python.so /lib64/security/howdy/pam.py  <--- 添加在首行
auth       include      system-auth
account    include      system-auth
password   include      system-auth
session    include      system-auth

```

配置后，会在调用到 polkit 的场景下使用人脸识别。如果同步弹出密码框，此时人脸识别已经启用，不需要任何输入即可完成验证，也无需点击确认密码的按钮，如果人脸识别失败，才会回落到使用密码验证。

6、手工调整几个选项保护你的隐私

> 避免自动拍照存档

编辑 /lib64/security/howdy/config.ini

    https://wiki.archlinux.org/title/Howdy#Secure_the_installation

    [snapshots]
    capture_failed = false   <----- 这个酌情放开
    capture_successful = false

    每次被调用时拍的照片默认会扔到 /lib64/security/howdy/snapshots/ 目录

> Intel 显卡避免频繁打印 MFX 消息

命令行下使用，默认在 sudo 认证成功后总是打印调试信息，太烦人。

编辑 /etc/profile.d/howdy.sh 和 /etc/profile.d/howdy.csh 文件，查找如下内容

    OPENCV_VIDEOIO_PRIORITY_INTEL_MFX

取消该语句的注释即可。

> 调整howdy的权限

    新版的 howdy 不需要调整以下权限了

因为大多数桌面环境内置的锁屏界面（不是指DM的登录界面）并未以root身份运行，而howdy的文件在默认状态下对非root用户不可读，故此时锁屏界面无法启用人脸识别

    # sudo chmod -R 755 /lib/security/howdy/
    $ chmod o+x /lib64/security/howdy/dlib-data

7、添加一个面部模型：

给当前用户添加一个面部模型，会提示给出标签，即一个用户可以有多个面部模型，多次运行即可

    $ sudo howdy add

    建议多个，比如 noglasses、withglasses

给其它用户添加

    # 不建议给 root 用户添加面部识别，用 sudo su 就挺好 https://github.com/boltgolt/howdy/issues/180
    $ sudo howdy -U root add

其它命令

    $ sudo howdy list             查看记录的面部模型列表
    $ sudo howdy remove face_ID   删除指定 ID 的面部记录
    $ sudo howdy clear            清除所有面部模型记录
    $ sudo howdy disable 1        禁用 Howdy 功能
    $ sudo howdy disable 0        启用 Howdy 功能

8、验证功能

    测试 sudo
    $ sudo whoami
    Identified face as xxx
    root

    测试锁屏
    $ win + l

    桌面->设置-> Users，点击 unlock，测试 Polkit 解锁

    $ sudo reboot 测试登录

### 开启指纹登录

    http://www.freedesktop.org/wiki/Software/fprint/fprintd

    https://help.gnome.org/users/gnome-help/stable/session-fingerprint.html.en

    https://wiki.archlinux.org/title/Fingerprint_GUI

    Debian 安装 pam-auth-update 包

        https://wiki.debian.org/SecurityManagement/fingerprint%20authentication

    https://winq.gitee.io/fprint-fedora/

    https://blog.csdn.net/weixin_31762925/article/details/116771481

以下仅供参考：

    Gnome 桌面已经内置该功能，在 Settings -> User 下面的选项找找，只要你的指纹设备被支持即可正常使用，默认只支持系统登录和 sudo 等鉴权免密码。

跟面部识别登录相同，目前不支持解锁 gnome-keyring，详见章节 [Linux 下的 “Windows Hello” 人脸识别认证 --- Howdy] 里“目前不支持解锁 gnome-keyring”的解释。

> 可以额外安装 libpam-fprintd 包以保存解锁 gnome 钥匙环的密码

还可以选择给更多的 pam 功能开启指纹验证：

    $ sudo pam-auth-update

    [*] Fingerprint authentication

    [*] Unix authentication

    [*] Register user sessions in the systemd control group hierarchy

    [ ] Create home directory on login

    [*] GNOME Keyring Daemon – Login keyring management

    [*] eCryptfs Key/Mount Management

    [*] Inheritable Capabilities Management

> 安装 fprintd 实现指纹登录

先确认你的发行版是否支持该指纹设备

    $ lsusb

根据输出信息在网址 <https://fprint.freedesktop.org/supported-devices.html> 查询。

确认系统上需要有软件包 fprintd

    # sudo apt install fprintd libpam-fprintd
    $ sudo dnf install fprintd fprintd-pam

使用以下命令添加指定手指的指纹,一共要求扫描五次

    $ sudo fprintd-enroll 用户名
    Using device /net/reactivated/Fprint/Device/0
    Enrolling right-index-finger finger.
    Enroll result: enroll-stage-passed
    Enroll result: enroll-stage-passed
    Enroll result: enroll-stage-passed
    Enroll result: enroll-stage-passed
    Enroll result: enroll-stage-passed
    Enroll result: enroll-completed

列出本机指定用户下已注册的指纹信息

    $ sudo fprintd-list winq

验证您本机刚注册过的指纹信息是否正确

    $ sudo fprintd-verify winq
    Using device /net/reactivated/Fprint/Device/0
    Listing enrolled fingers:
    - #0: right-index-finger
    Verify started!
    Verifying: right-index-finger
    Verify result: verify-match (done)

### Scrcpy --- 在 Linux 桌面显示和控制 Android 设备

Scrcpy，可以通过Linux桌面显示和控制 Android 设备，类似 Samsung Dex 的使用方式，用电脑玩手机：

    https://github.com/Genymobile/scrcpy

    https://zhuanlan.zhihu.com/p/606448877

Scrcpy 支持 Windows/Linux/macOS 多个平台，需要你的手机打开 usb 调试模式，这样  Scrcpy 才可以操作你的手机屏幕。

如果感觉不安全，只是需要在桌面操作你的手机的基本功能，安装 gnome 扩展 GSConnect 就够了。它可以操作局域网联网（WIFI）的你的手机，支持传送文件、发送短信、查看通知等操作，详见上面章节 [使用 gnome 扩展]。

还可以安装安卓虚拟机，实现在 Linux 桌面运行安卓 apk，详见章节 [安卓虚拟化](virtualization think)。

安装

    Debian 系可以从官方存储库安装 scrcpy

        $ sudo apt install scrcpy

    Fedora 系暂时还未收录到官方存储库，可以从 Cool Other Packages Repository (COPR)安装它：

        $ sudo dnf copr enable zeno/scrcpy
        $ sudo dnf install scrcpy

有两种连接方式：

一、在 Linux 中通过 USB 连接到 Android 设备

安装完成后，请记得如前所述在您的 Android 设备中启用USB调试（转到设置=>开发人员–> 选项=>USB 调试），然后通过 USB 数据线将您的设备连接到 Linux 台式电脑。

在 Linux 桌面下的命令行运行：

    $ scrcpy

手机上会弹出窗口以请求授权以允许从计算机进行 USB 调试，然后选择允许继续。

然后再次重新运行 `scrcpy`，会看到弹出一个窗口，显示您设备的活动屏幕，称 “镜像”，用鼠标模仿你的手指操作即可。

如果运行 scrcpy 提示 “libopenh264.so.7 is missing, openh264 support will be disabled” ，说明你的 Linux 桌面环境需要安装完全版本的 ffmpeg，详见章节 [安装 full ffmpeg](init_a_server think)。

二、在 Linux 桌面中通过 Wifi 连接到 Android 设备

首先，在您的计算机上安装 adb 命令行工具，这是安卓操作系统的开发工具。如果您已经安装了adb工具，请跳过下面的安装步骤：

    # 在Debian、Ubuntu 和 Mint上
    $ sudo apt install adb

    # 在RHEL/CentOS/Fedora和Rocky Linux/AlmaLinux上
    $ sudo yum install adb

    # 在Arch Linux上
    $ sudo pacman -S adb

在您的计算机上安装 adb 工具后，将您的 Android 设备和计算机连接到公共 Wi-Fi 网络。然后使用 USB 数据线将 Android 设备连接到计算机。

接下来，从目标设备上断开USB电缆并找到Android设备的 IP 地址（转到设置 –> 连接 –> Wi-Fi –> Wi-Fi 名称 –> 点击其设置）或运行以下命令以查看设备IP地址：

    $ adb shell ip route

查找 Android 设备 IP 地址

然后通过运行以下命令将目标Android设备设置为在端口5555上侦听TCP/IP连接（检查设备上的任何提示）：

    $ adb tcpip 5555

接下来，断开USB电线并使用其 IP 地址连接目标设备，如下所示：

    $ adb connect 192.168.1.4:5555

然后就可以运行 scrcpy 实现在 Linux 桌面上镜像 Android 设备的屏幕。

从终端运行以下命令也可以启动scrcpy：

        $ scrcpy

如果命令成功运行，将打开一个窗口，显示您设备的活动屏幕，称 “镜像”。

如果需要要控制镜像的 Android 屏幕的宽度和高度，请使用命令行 --max-size或-m 开关，如下所示：

    # scrcpy --max-size=1024
    $ scrcpy -m 1024

使用键盘和鼠标控制某些 Android 设的详细信息，请转到scrcpy Github 存储库查看文档：

    https://github.com/Genymobile/scrcpy#user-documentation

简单来说：

    鼠标左键相当于单指操作，右键是返回键，息屏时会点亮手机屏幕。

    如果操作中出现需要用户在手机上操作的内容，scrcpy 会黑屏，按 esc 可取消。

下表中的 MOD 表示修饰键，在 Windows 中对应 win 或 alt 键，在 Mac中对应 cmd 键：

    快捷键                      实施的动作

    右键点击                等同于点亮屏幕
    Ctrl + 点击和移动        相当于多指捏合动作

    MOD + f                切换到全屏 / 取消全屏
    MOD + 左                往左旋转屏幕
    MOD + 右                往右旋转屏幕
    MOD + g                重置屏幕尺寸到 像素比1:1（一般都是变得硕大）
    MOD + w                重置屏幕尺寸消除黑色边框

    MOD + h                等同于 home 键
    MOD + b                等同于 返回 键
    MOD + s                等同于切换app操作

    MOD + m                对应解锁屏的按键，如果是锁屏的话，仅点亮屏幕

    MOD + p                等同于按电源键

    MOD + 下                减少音量
    MOD + 上                增加音量

    MOD + o                把设备屏幕关闭但保持镜像同步
    MOD + Shift + o        点亮设备屏幕
    MOD + r                旋转屏幕（测试好像不好用，不知道是不是快捷键冲突）
    MOD + n                打开消息面板
    MOD + n + n            双击n，打开顶部设置栏
    MOD + shift + n        收起面板
    MOD + c                同步复制到电脑剪贴板
    MOD + x                同步剪贴到电脑剪贴板
    MOD + v                同步粘贴电脑剪贴板的内容（pc->手机或手机->pc均可）
    MOD + i                启用或禁用FPS计数

    安装APK                 拖拽APK文件到窗口
    推送文件到手机            拖拽非APK文件到窗口，默认放到 /sdcard/Movies 目录下

修饰键可以在命令行参数进行修改，可选的键有 lctrl、rctrl、lalt、ralt、lsuper 和 rsuper

    $ scrcpy --shortcut-mod=lalt

### steam、wine 及 Moonlight/Sunshine 串流

在 Linux 上运行 Windows 程序的几种方法

    https://itsfoss.com/use-windows-applications-linux/

最方便的是安装使用 steam 游戏平台，从下载到安装到运行，不管是玩 Windows 游戏还是串流到电视，统统搞定了。

    https://www.linuxcapable.com/how-to-install-steam-on-fedora-linux/

如果你是个游戏发烧友，在多个平台有众多游戏，还可以安装个 lutris 平台，把你的各个游戏平台和模拟器都综合起来了

    https://lutris.net/about

或者直接安装社区项目 Nobara，预装了游戏客户端 Lutris、Steam、OBS Studio 和 Kdenlive

        https://nobaraproject.org/

        https://zhuanlan.zhihu.com/p/469095571
            https://itsfoss.com/linux-gaming-distributions/

安装 mangohud 看 fps

    $ sudo dnf install mangohud

当前的 openGL 驱动版本

    $ glxinfo -B
    name of display: :0
    display: :0  screen: 0
    direct rendering: Yes
    Extended renderer info (GLX_MESA_query_renderer):
        Vendor: Intel (0x8086)
        Device: Mesa Intel(R) HD Graphics 610
        Version: 23.1.6
        Accelerated: yes
        Video memory: 64000MB
        Unified memory: yes
        Preferred profile: core (0x1)
        Max core profile version: 4.6
        Max compat profile version: 4.6
        Max GLES1 profile version: 1.1
        Max GLES[23] profile version: 3.2
    OpenGL vendor string: Intel
    OpenGL renderer string: Mesa Intel(R) HD Graphics 610
    OpenGL core profile version string: 4.6 (Core Profile) Mesa 23.1.6
    OpenGL core profile shading language version string: 4.60
    OpenGL core profile context flags: (none)
    OpenGL core profile profile mask: core profile

    OpenGL version string: 4.6 (Compatibility Profile) Mesa 23.1.6
    OpenGL shading language version string: 4.60
    OpenGL context flags: (none)
    OpenGL profile mask: compatibility profile

    OpenGL ES profile version string: OpenGL ES 3.2 Mesa 23.1.6
    OpenGL ES profile shading language version string: OpenGL ES GLSL ES 3.20

#### Steam on Linux：steam play / steam link

Steam 属于商业闭源软件，但是各大发行版都提供了安装 steam 的方式

    Steam/GOG.com/gameshub.com
        https://itsfoss.com/linux-gaming-guide/

    在 FreeBSD 安装
        https://ivonblog.com/posts/install-steam-proton-on-freebsd/

    玩 doom eternal
        https://www.addictivetips.com/ubuntu-linux-tips/doom-eternal-on-linux

从桌面的 Gnome “软件(Software)” / Kde “发现(Discoery)” 里搜索 steam，从发行版内置的第三方存储库安装 steam，使用命令行 `dnf install steam` 安装也可以。推荐安装 flatpak 版的，容器隔离的安全性更好。

##### Steam Play（原名 proton） 安裝 Windows 平台的遊戲

    https://itsfoss.com/steam-play/

    https://ivonblog.com/posts/install-steam-on-linux/

    https://fedoramagazine.org/set-up-fedora-silverblue-gaming-station/

Steam Play 這個計畫讓玩家在購買遊戲後能於 Linux、Windows、macOS 遊玩，背後使用的技術是  "Steam Proton"，基於 Wine 研發的轉譯層，Valve 自家的 Steam Deck 掌機也有用到 Steam Proton 技術。

设置改了：點選 Steam 左上角 → Settings -> Compatibility，勾选所有选项，看来这个技术要隐入底层自动启用，不再需要用户干预

    废弃：點選 Steam 左上角 → Steam Play，勾選 「為所有產品啟用 Steam Play」，之後選擇下載最新的 Proton，再按下確定。點選 Steam 左上角 → 離開 Steam，重新啟動 Steam。

然後下載一个 Windows 平台的遊戲，它就會一併安裝 Proton 等相关兼容层的包。

於是你就可以在 Linux 上玩 Windows 遊戲了！

使用 Proton 安装非 Steam 游戏

    简短的回答是，是的，你可以。Steam 应用程序允许您将非 Steam 游戏添加到库中。您需要做的就是打开 Steam > 添加游戏（在应用程序的左下角）> 添加非 Steam 游戏 > 导航到您的游戏的 .exe 文件 > 添加选定的程序。

用 Flatpak 裝 Steam 的話，遊戲收藏庫位於 ~/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/。

為了安全性考量，Flatpak 版的 Steam 預設只能存取使用者的 $HOME 目录，無法存取其他硬碟。

> 给 steam 增加额外的存储空间

    https://github.com/flathub/com.valvesoftware.Steam/wiki#i-want-to-add-external-disk-for-steam-libraries

如果你想移動 Steam 收藏庫，或是沿用舊有的 Steam 收藏庫，就得開放存取電腦特定目錄的權限。

例如，你的第二個硬碟已經有 Steam 這個目錄，而它的完整路徑是 /run/media/user/SSD2/Steam

目前 steam 已经支持 flatpake 门户访问申请目录了，直接操作选项设置即可：點選 Steam左上角 → 離開 Steam。然後重新啟動 Steam，在左上角菜单选：設定，在弹出窗口的左侧导航页面选择条目：存储(Storage)，在右侧页面上部默认的下拉列表点击 “Add Drive”，然后输入你的新存储空间的路径。然后再次点击下拉列表，选择已经成为条目的新路径，下面会列出新路径的详情，点击右侧的三个点的按钮，选择“Make Default”，这样以后安装的游戏都会保存到这里了。

    原来不支持的时候，需要先使用 override 的粗暴方式开启权限：

        使用 flatpak override 指令開放存取權限：

            $ flatpak override com.valvesoftware.Steam --user --filesystem="/path/to/mountpoint/"

        或者使用图形化的 flatpak 软件权限工具 flatseal：选 Steam -> "Filesystem" section -> Other files -> Enter /path/to/mountpoint/

    override 相关知识参见 [Flatpak 直接访问文件系统](init_a_server)。

如果报错提示无法访问，需要用命令添加

    https://github.com/ValveSoftware/steam-for-linux/issues/9640#issuecomment-1887854957

    Open with

        $ steam steam://open/console

        Flatpak: use `flatseal` open host filesystem first then run `flatpak run com.valvesoftware.Steam steam://open/console`

    Then type in：

        library_folder_add <path>

##### Steam Link 用另一部電腦串流遊玩 Linux 電腦的 Steam 遊戲

    https://store.steampowered.com/app/353380/Steam_Link

    https://help.steampowered.com/en/faqs/view/6424-467A-31D9-C6CB

    https://behind-the-scenes.net/running-steam-link-on-a-raspberry-pi/

假设有独立显卡的计算机作为服务端，安装 steam，设置串流到另一台设备上玩游戏，比如智能电视、机顶盒、树莓派、手机等。

1、服务端电脑，安装 steam 并启动，登录 steam 账户。

2、客户端树莓派安装 steamlink

    $ sudo apt install steamlink

Bullseye（撰写本文时的最新版本）不起作用，Raspbian Buster（32位）的完整版本工作正常。

客户端 Linux 需要有桌面环境，如果是 X windows 环境用 ctl + alt + F1 在控制台执行命令 `steamlink`

如果没有桌面环境，比如你的树莓派上运行的 Raspbian 版本是 “Raspbian Stretch Lite” 这样的纯命令行版本，那么你需要安装一个额外的包 “zenity”，以使 Steam Link 软件正常工作

    $ sudo apt install zenity

    zenity 的使用详见章节 [可与命令行交互的图形界面 zenity]

3、连接服务端电脑和串流设备（客户端）

在服务端电脑运行 steam，等待客户端。

在客户端串流设备上运行 steamlink，可以登录你的 steam 账户

    如果是局域网环境，不需要登录 steam 就会自动发现你的服务端，点选后会提示一个 “授权码”，需要在服务端输入该 pin 码

        如果没有出现你的服务端电脑，请确保你在Steam上启用了 “家庭流媒体”，并且在服务端电脑上正在运行 Steam。在服务端电脑上执行 Steam 后，启用 “家庭流媒体”按 “重新扫描”。

在服务端电脑，打开 steam 的左上角 -> 设置 -> 远程畅玩（Play），添加该授权码即添加了这个设备。现在的版本会自动弹出一个窗口，提示有设备申请连接，输入上面客户端提示的 pin 码即可。

配置游戏控制器

steamlink 支持很多游戏控制器，树莓派支持的游戏控制器参见下面

    https://behind-the-scenes.net/raspberry-pi-compatible-game-controllers/

主要就是把控制器对应的按钮设置好功能即可。

4、玩游戏播视频

在客户端的 Steam link 选择你的服务端电脑，点击选择 Play 即会出现新的页面，可选择执行服务端的 steam 上的游戏了

    客户端 Steam link 要退出串流长按 Esc 即可，再次按 esc 则退出 Steam link，返回到命令行。

若要在出门在外玩游戏，需要使电脑保持打开和联机状态，电脑可以处于睡眠模式，只要提前在客户端设备上配置过，可以选择唤醒。

如果要播放影音，在服务端的 steam 选择 “非 steam 游戏”，然后选择你的播放器程序即可。

    如果您在电脑上强制退出 Steam（ALT+F4），屏幕镜像将保持活动状态
    您可以在电视上访问计算机
    这使您可以在电视上查看电影，图片，文档或网站
    如果您还没有智能电视，这对于在Raspberry Pi上带来Windows应用程序的强大功能可能很有用

目前已经支持树莓派，所以家里电视机的树莓派只要安装 Steam link，用 hdmi 线连接电视即可玩你电脑上的游戏了。

    https://www.bilibili.com/video/BV1Cs4y1B7zQ/

    需要有桌面环境才能使用 steamlink

        sudo apt install steamlink

    安装中提示 GPU 显存要至少 128 MB，并安装一堆依赖包，调整树莓派 GPU 显存用量参见章节 [调整你的显存容量](raspberry-pi.md)。

    在树莓派桌面上运行 steam link 提示不支持 x11，按 ctrl+alt+F1 切换到控制台运行即可。

##### Battle.Net on steam

    https://mag37.org/posts/linux_gaming/#battlenet-on-steamproton

Download the regular BattleNet-Setup.exe.

    https://download.battle.net/en-us/?product=bnetdesk

    Add it to steam as non-steam game.

    Click properties -> compatibility -> Force specific … and choose latest proton/GE.

Play! To launch the installer, follow the steps until its done then close it.

Now Add the freshly installed Battle.net.

    Add non-steam game

    Browse to `home/user/.local/share/Steam/steamapps/compatdata/`

    Make sure to have “all files” as file type.

    Find the latest modified directory, 10-digit name and enter it.

        Go to pfx/drive_c/Program Files (x86)/Battle.net

        Select Battle.net Launcher.exe

    Click properties -> compatibility -> Force specific … and choose latest proton/Proton-GE.

Done - Now install your Battle.net games or browser for already installed ones.

#### Moonlight/Sunshine for Linux

开源的方案，雲端串流遊戲軟體，可讓你從另一部電腦串流玩遊戲

    https://zhuanlan.zhihu.com/p/694331494

    https://www.bilibili.com/read/cv24132717/

    https://blog.csdn.net/qq_38836741/article/details/129045274

    Sunshine + Moonlight 纯软件实现全平台设备作 Linux 副屏
        https://zhuanlan.zhihu.com/p/678206086

    https://zhuanlan.zhihu.com/p/139160734
    https://zhuanlan.zhihu.com/p/461015191
    https://bbs.a9vg.com/thread-5365751-1-1.html

Moonlight 是一款开源的利用 Nvidia GameStream 进行远程串流游戏的软件，常规来说使用 Nvidia GameStream 串流除需要一款支持 GameStream 的显卡以外，还需要 Nvidia Shield设 备的支持来接收串流，用 Moonlight 就是做了 Shield 的工作。使能安装 Moonlight 的设备都能成为 GameStream 串流客户端。

因为在流发送端（游戏执行端）需要安装英伟达 GeForce 显卡（N卡），并安装 GeForce Experience 注册 nvidia 账户，所以没人用。Nvidia 这套串流方案已经退出市场了，现在的方案是

    流发送端安装 sunshine ---- Nvidia/AMD/Intel 核显 三平台通用的串流服务端

    在流接收端（电视、手机或平板）安装 Moonlight 的客户端应用程序。

流接收端和发送端连接到同一个内网环境里即可实现串流。

##### 流发送端

服务端安装 sunshine

    https://github.com/loki-47-6F-64/sunshine#usage

Fedora 用 flatpak 安装即可

    flatpak search sunshine

Windows 操作系统下服务端安装

    安装手柄驱动

        https://github.com/ViGEm/ViGEmBus/releases

        下载 ViGEmBusSetup_x64.msi 或 ViGEmBusSetup_x86.msi 后安装

    安装 sunshine 服务端

        https://github.com/loki-47-6F-64/sunshine/releases

        下载 Sunshine-Windows.zip 并解压至任意位置

##### 流接收端

客户端安装 Moonlight，注意 Linux 平台需要有桌面环境

    https://moonlight-stream.org/

Windows, macOS, and Steam Link

    https://github.com/moonlight-stream/moonlight-qt/releases

android 客户端:

    https://github.com/moonlight-stream/moonlight-android/releases

    没 root 下 nonroot 版本

iOS 客户端:

    https://apps.apple.com/app/moonlight-game-streaming/id1000551566

Fedora 用 flatpak 安装即可

    # https://flathub.org/apps/details/com.moonlight_stream.Moonlight
    flatpak search moonlight

> 树莓派安装 moonlight

    https://github.com/moonlight-stream/moonlight-docs/wiki/Installing-Moonlight-Qt-on-Raspberry-Pi-4

步骤较多，按项目挨个做吧。

编辑 /boot/config.txt and reboot your Pi

    调整树莓派 GPU 显存用量的方法参见章节 [调整你的显存容量](raspberry-pi.md)。

    要使用树莓派的 HEVC 解码（提示废弃了）

        # https://github.com/moonlight-stream/moonlight-docs/wiki/Installing-Moonligdht-Qt-on-Raspberry-Pi-4#hevc-and-hdr-support
        dtoverlay=rpivid-v4l2

    Raspbian Bullseye 还得改

        # https://github.com/moonlight-stream/moonlight-docs/wiki/Installing-Moonlight-Qt-on-Raspberry-Pi-4#raspbian-bullseye
        dtoverlay=vc4-fkms-v3d

在桌面按 ctrl+alt+F1 切换到控制台运行 `moonlight-qt`

    # https://github.com/moonlight-stream/moonlight-docs/wiki/Installing-Moonlight-Qt-on-Raspberry-Pi-4#raspbian-bullseye
    #  Qt Critical: Could not queue DRM page flip on screen HDMI1 (Permission denied)
    env QT_QPA_EGLFS_KMS_ATOMIC=1 moonlight-qt

    GUI 将出现在连接到最靠近 USB-C 电源线的 mini-HDMI 端口的显示器上。这是树莓派4的主显示输出端口，它标注了 HDMI0（可以以相同的方式连接第二个屏幕到 HDMI1）。如果从树莓派桌面环境外部启动 Moonlight 时没有看到 UI 出现，请确保您的显示器连接到正确的端口。

    如果您的显示器已插入主 HDMI 输出，并且在从控制台启动 Moonlight 时仍然看不到 UI，请尝试使用以下命令启动 Moonlight：

        QT_QPA_EGLFS_ALWAYS_SET_MODE=1 moonlight-qt

界面中会自动显示当前局域网搜索到的发送端，点击图标即可连接，第一次会提示一个 pin 码，在发送端找 pin 码输入界面填入即可通过认证。

##### 连接

    确保客户端和服务端在同一局域网

    客户端安装后打开应该会自动搜索到主机

    如果没有的话在服务端设备运行ipconfig获取ip

    然后在客户端点右上角加号输入 IP 即可

    建立连接后，点击桌面（DESKTOP）将启动桌面串流。

    退出 moonlight 按 alt + esc，Windows客户端要牢记Ctrl+shift+alt+q是退出串流的快捷方式，全屏状态下各种操作都会视为对远程电脑的操作。

常见使用问题：

    pin 码在哪:

        https://127.0.0.1:47990 顶部 pin

    手动打开sunshine命令:

        net start sunshinesvc

    内网穿透端口，在路由器侧设置端口转发可在互联网访问

        TCP 47984,47989,48010
        UDP 5353,47998,47999,48000,48002,48010

    ipv6支持有问题 连接后出现画面立刻断掉:

        audio-sink/virtual-sink设置有问题

    除了玩steam的游戏，我还想串流各种模拟器怎么办？
    A：建议直接串流整个桌面，方法是发送段的程序中添加 “mstsc.exe”，路径为：“C:\Windows\System32\mstsc.exe”，串流了桌面我想下面你该懂怎么做了！

    目前UWP（WIN10商店）游戏比如《极限竞速：地平线3》在串流后手柄不认
    A：请不要在 Moonlight 运行桌面再去打开游戏。请直接在 Moonlight 中运行 UWP 游戏

    买个显卡欺骗器，hdmi的接头，让笔记本以为外接了走独显输出然后串流，这样可以解决一些游戏的异常黑屏问题。

#### vlc player 串流视频

    https://www.thewindowsclub.com/stream-videos-lan-vlc-media-player

    https://www.thewindowsclub.com/how-to-play-rtsp-stream-in-vlc-media-player

    https://fanrongbin.com/raspberrypi-autostart-vlc-autoplay-rtsp-stream/

    https://blog.csdn.net/m0_60259116/article/details/126351373

类似的串流视频还有 Jellyfin，详见章节 [自建 Jellyfin 私人影院](raspberry-pi think)。

如果是 flatpak 安装的 vlc，需要在 flatseal 中开放 vlc 的端口权限。

发送方，打开 vlc，菜单选择：

    “Media” --> “Stream”，添加你要播放的视频文件，点击 “Add”，还可以选择字幕文件，也点击 “add”，然后点击下面的 “Stream” 按钮。

    在弹出的新窗口选择 “Next”，在下一个页面，串流方式选择 RTP 和 http 点击 “add”，或选择 RSTP 点击 “add”，在后面的标签页设置对应的名称、路径、端口等，然后点击下一步

    在新页面选择一个转码编码方式，注意要跟上面的串流方式对应，如 RSTP 方式我选择的是 “Vide-H.264+MP3(TS)”，点击下一步，然后点击 “Stream” 按钮。

    这时推流已经开始了，可以看到 vlc 窗口下方时间栏的秒数变化。

    注意如果是 flatpak 安装的 vlc，需要放开对应的端口权限，不然无法对外广播。

接收方，局域网内的其他计算机上，打开 vlc，菜单选择：

    RTP 流：

        “View” ---> “Playlist”，在弹出窗口选择 “Local Network”，应该可以看到发送方设置的名称，双击即可播放了。

    RTSP 流：

        “Media” --> “Open network Stream”，在弹出窗口输入发送方的地址 rtsp://192.168.0.xx:8554/your_path

        为防止网速不好播放有卡顿，勾选 “Show more options”，在新增的内容中给 “caching” 选项增加缓冲时间，比如 30 秒

        点击 “play” 按钮即可播放。

#### 使用 FFmpeg 录制流视频到文件

分析视频流信息

    $ ffprobe -i rtsp://your_stream_url -show_streams

确认本机是否支持 h265:

    $ ffmpeg -codecs | grep hevc

> 分段录制 RTSP 视频流

使用 segment 过滤器来将视频流分割成多个较小的文件。这可以通过指定 -f segment 参数和输出文件的前缀来实现。

    $ ffmpeg -rtsp_transport tcp -i rtsp://your_stream_url -c copy -f segment -segment_time 60 stream_piece_%02d.mp4

    -segment_time 60 表示每个视频文件的时长为 60 秒，但稍有误差，h256压缩的视频大概 5.4MB。

    stream_piece_%02d.mp4 是输出文件的格式，%02d 是一个占位符，FFmpeg 会自动为每个文件编号。

所以，如果是每 15分钟(900秒) 一个文件，约 81MB，一天就是 96个文件。设置 %02d 会循环使用的文件名，如果只保留一天的视频文件，两位数文件名够用了。

一天下来的容量需求大概 5.4MB * 1440 约 8GB。如果是 32GB 的存储卡，大概能保存 4 天的视频。

如果使用 %3d 做文件名，则最多 1000 个文件循环写入，32GB 的存储卡想保留 4 天的话，每个文件的时长最短 1440*60/(1000/4) 约 350 秒，想保留 3 天则文件时长最短 260 秒，保留2天则文件时长最短 175 秒。

还可以使用 -limit_filesize 100MB 选项来限制输出文件的大小。当文件达到指定大小时，FFmpeg 将自动开始一个新的文件。

> 推送本地视频到流媒体服务器

    $ ffmpeg -re -i "D:\test.mp4" -vcodec h264 -acodec aac -f rtsp -rtsp_transport tcp rtsp://192.168.0.110/live/test

#### wine/Bottles

推荐安装 Bottles，这个 wine 的前端更方便，见本章节的最后部分。

wine 模拟 Win32 接口调用的中间层，类似 MGW 和 Cygwin 的实现思路，可以直接运行 Windows 的软件，这样就省去用虚拟机安装 Windows 了

    https://docs.fedoraproject.org/en-US/quick-docs/wine/

    https://www.winehq.org/
        支持的软件列表，游戏居多哦 https://appdb.winehq.org/

    wayland 下的 wine 不再使用 x11 体系
        https://github.com/varmd/wine-wayland

    https://www.cnblogs.com/garyw/p/13468491.html

    https://zhuanlan.zhihu.com/p/108106453

    https://www.linuxcapable.com/how-to-install-wine-on-fedora-linux/

    https://zhuanlan.zhihu.com/p/60876915

    https://bbs.deepin.org/en/post/179509

    用 Vulkan 实现的 DirectX 驱动程序
        https://github.com/doitsujin/dxvk#how-to-use

    示例
        https://github.com/shuvozula/steam-gta5-linux

proton 是 Valve 为他们的 steam 弄的 wine 衍生版，部分 steam 游戏使用它；crossover 是 wine 的一个商业应用。

可以从发行版自带的存储库 dnf 安装，或使用 wine 官方存储库安装 Wine 的最新稳定版：

> 安装 Wine32

目前大多数游戏和 Windows 应用程序是为 32 位体系结构系统开发的，为了更好的兼容性，应该安装 32 位的版本

    $ sudo dnf install wine.i686 wine-mono

    $ sudo apt install wine32

    $ wine --version

> 使用 wine 官方存储库安装 Wine

主要目的是从 Wine 官方存储库安装的稳定版本，比 Fedora 默认存储库中可用的版本新。缺点是一旦你的操作系统大版本升级，要记得删除之前手动安装的第三方存储库，升级后换为对应的存储库。而且没有国内镜像，从这个库下载比较痛苦。

先安装官方存储库

    # https://wiki.winehq.org/Category:Distributions
    # https://dl.winehq.org/wine-builds/fedora/
    $ sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/$(rpm -E %fedora)/winehq.repo

如果使用 rpm-ostree 安装，参见章节 [添加 RPMFusion 存储库]，步骤一致，替换地址即可。

然后再安装稳定版

    $ sudo dnf install winehq-stable

    如果喜欢尝鲜，等不及稳定版，可以试试暂存版

        $ sudo dnf install winehq-staging

    $ wine --version

wine 的官方存储库为了区别于 Fedora 默认存储库，软件包的名称是不同的，比较容易区分。

> 国内镜像

只支持 Debian/Ubuntu

    https://mirrors.tuna.tsinghua.edu.cn/help/wine-builds/

    https://help.mirrors.cernet.edu.cn/wine-builds/

> 安装后的配置工作：

    https://blog.csdn.net/Gerald_Jones/article/details/80781378

安装 Wine 后，必须安装一些依赖包并设置必要的环境，一种方法是在终端中运行 “winecfg” 命令

    在每次 Wine 升级或安装新的 Windows 应用程序后，都要运行 “winecfg” 命令重新设置环境。

NOTE：不要以 `sudo` 执行 winecfg

如果您希望将 Wine 环境作为“32 位”系统启动，则可以使用以下命令进行必要的调整

    $ export WINEARCH=win32 export WINEPREFIX=~/.wine32 winecfg
    wine: created the configuration directory '/home/uu/.wine32'
    wine: '/home/uu/.wine32' is a 32-bit installation, it cannot support 64-bit applications.

    $ WINEPREFIX=~/wine32 wine xxx.exe

打开 winecfg

    https://www.imooc.com/article/35491

确保第一个标签页中的 Windows 版本已经设置成了 Windows 7。暴雪不再对之前的版本提供支持。然后进入 “Staging” 标签页。 这里根据你用的是 staging 版本的 Wine 还是打了 Gallium 补丁的 Wine 来进行选择。

    不管是哪个版本的 Wine，都需要启用 VAAPI 以及 EAX。至于是否隐藏 Wine 的版本则由你自己决定。

字体配置

    https://blog.csdn.net/SHIGUANGTUJING/article/details/89291732

模拟的 Windows 相关目录在 ~/.wine 下面，可以从 Windows 操作系统 windows/Fonts 拷贝 sim* 字体 到对应的目录

    $ trees ~/.wine
    [目录树，最多2级，显示目录和可执行文件的标识，跳过.git等目录]
    /home/uu/.wine/
    ├── dosdevices/
    │   ├── c: -> ../drive_c/
    │   ├── lpt1 -> /dev/lp0
    │   ├── lpt2 -> /dev/lp1
    │   ├── lpt3 -> /dev/lp2
    │   ├── lpt4 -> /dev/lp3
    │   └── z: -> //
    ├── drive_c/
    │   ├── ProgramData/
    │   ├── Program Files/
    │   ├── Program Files (x86)/
    │   ├── users/
    │   └── windows/
    ├── system.reg
    ├── .update-timestamp
    ├── userdef.reg
    └── user.reg

    10 directories, 8 files

字体配置的 zh_font.reg

```ini
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes]
"Arial"="simsun"
"Arial CE,238"="simsun"
"Arial CYR,204"="simsun"
"Arial Greek,161"="simsun"
"Arial TUR,162"="simsun"
"Courier New"="simsun"
"Courier New CE,238"="simsun"
"Courier New CYR,204"="simsun"
"Courier New Greek,161"="simsun"
"Courier New TUR,162"="simsun"
"FixedSys"="simsun"
"Helv"="simsun"
"Helvetica"="simsun"
"MS Sans Serif"="simsun"
"MS Shell Dlg"="simsun"
"MS Shell Dlg 2"="simsun"
"System"="simsun"
"Tahoma"="simsun"
"Times"="simsun"
"Times New Roman CE,238"="simsun"
"Times New Roman CYR,204"="simsun"
"Times New Roman Greek,161"="simsun"
"Times New Roman TUR,162"="simsun""Tms Rmn"="simsun"

```

然后在终端执行 `wine regedit zh_font.reg`

##### 如何使用 Wine

对需要安装的 Windows 程序，下载并使用 Wine 打开 xxxInstall.exe 文件

    在桌面环境的文件管理器中，右键单击.exe文件，选择 “使用 Wine Windows 程序加载器打开” 并选择 Wine 应用程序来运行该文件，剩下的就是安装和运行了，跟 Windows 下的使用体验是一致的。

注意安全

    因为下载的程序不知道来源是否正规，应该新建个用户安装并运行这些程序

装好 Wine 以后，在终端输入 `regedit` 可以打开 wine 的注册表编辑器了

    http://wiki.winehq.org/regedit

    $ wine regedit xxx.reg 直接导入注册表

在英文 Linux 下执行 Win 7/WinXp 时代的简体中文程序

    # en_US.utf8
    $ env LANG=zh_CN.GBK wine your_app.exe

如果是中文 Linux，则换成：

    $ env LANG=zh_CN.UTF-8 wine your_app.exe

> 用 Winetricks 配置 WINE

    https://wiki.winehq.org/Winetricks

    https://www.cnblogs.com/jikexianfeng/p/5769430.html

winecfg 让你可以改变 WINE 本身的设置，而 winetricks 则可以让你改造实际的 Windows 层，它可以让你安装 Windows 重要的系统组件，比如 .dll　文件和系统字体，还可以允许你修改 Windows 注册表的信息。它还有任务管理器、卸载工具和文件浏览器。 尽管 winetricks 可以做以上这些工作，但是大部分时间我们用到的功能也就是管理 dll 文件和　Windows　组件。

    # 创建专用 Wine 前缀
    $ WINEPREFIX=~/.wine-win7 winecfg
    在弹出的窗口中，将 Windows 版本设置为 Windows 7

    # 为特定 Wine 前缀安装
    $ WINEPREFIX=~/.wine-win7 winetricks dxvk d3dx9 corefonts cjkfonts gdiplus vcrun2019

> wine 不需要窗口管理器（GNOME或KDE）也可以正常地运行

如果你在一个单独的 X server 下运行游戏，你会得到明显的性能提升。在运行游戏之前，关闭 GDM 或 KDM，还会得到更大的性能提升（只能通过控制（console）台来实现）。

    https://blog.csdn.net/Gerald_Jones/article/details/80781378

    1、首先，在终端下建立一个脚本 代码: nano launcher.sh（可以用vim替换nano）

    2、复制下面的文字到终端里。如果你没有nVidia的显卡，就删除nvidia settings的那部分，然后用你的游戏的正确路径替换里面的路径 代码:

    #!/bin/sh

    # uncomment if launching from console session
    #sudo /etc/init.d/gdm stop
    # KDE use this instead
    #sudo /etc/init.d/kdm stop

    # Launches a new X session on display 3.
    # If you don’t have an Nvidia card,take out the “& nvidia-settings –load-config-only” part
    X :3 -ac & nvidia-settings –load-config-only

    # Goto game dir (modify as needed)
    cd “$HOME/.wine/drive_c/Program Files/Game/Directory/”

    # Forces the system to have a break for 2 seconds, X doesn’t launch instantly
    sleep 2

    # Launches game (modify as needed)
    DISPLAY=:3 WINEDEBUG=-all wine “C:/Program Files/Game/Directory/game.exe”

    3、把文件保存到你的主文件夹
    4、然后，给你的脚本加上可执行属性 代码: chmod +x ~/launcher.sh
    5、运行脚本

        ./launcher.sh

    6、结束游戏后，用CTRL-ALT-BACKSPACE回到桌面

##### 示例：用 wine 运行魔兽争霸3

    https://blog.csdn.net/zhongdajiajiao/article/details/51635208
        http://linux-wiki.cn/wiki/%E7%94%A8Wine%E8%BF%90%E8%A1%8C%E9%AD%94%E5%85%BD%E4%BA%89%E9%9C%B8III

把 war3 放到某个目录下，比如放到 $HOME 目录下，如是 /home/abc/war3。

导入 war3 的注册表文件

    $ wine regedit initWar3.reg

    $ wine regedit 1920x1080.reg

    $ wine regedit 英文windows_转中文版本信息chn.reg

直接使用 wine 的默认配置运行简体中文版 war3 即可

    $ env LANG=zh_CN.GBK WINEDEBUG=-all wine war3.exe -opengl

    如果显卡驱动不兼容，强制指定版本

        $ env LANG=zh_CN.GBK MESA_GL_VERSION_OVERRIDE=4.5 wine war3.exe -opengl

另外，如果你安装了多个程序，并需要不同的环境去运行：

为了使 war3 的 wine 环境和默认的 wine 环境不相互污染，应该给它创建单独的配置文件，通过如下命令来启动

    WINEPREFIX=~/.war3 wine ~/war3/war3.exe

即 war3 的运行环境为 ~/.war3

为了使用方便，我们可以给war3创建一个桌面快捷方式，鼠标右键桌面空白处，编辑 /usr/share/applications/war3.desktop

输入以下内容：

```ini
[Desktop Entry]
Name=war3
Exec=env LANG=zh_CN.GBK MESA_GL_VERSION_OVERRIDE=4.5 wine Z:/home/user/game/Warcraft\ III/war3.exe -opengl
Type=Application
StartupNotify=true
Comment=war3
Path=/home/user/game/Warcraft\ III
Icon=/home/user/game/Warcraft\ III/war3.jpg
StartupWMClass=war3.exe

```

保存退出

    chmod 755 war3.desktop

现在可以双击图标打开 war3 了。

##### 更方便的 Bottles

更方便的图形界面配置你的 wine，自动安装各种依赖库，比 wine 自带的配置方便多了

Wine 使用一个被称之为 “Wineprefix” 的配置目录来控制使用 Wine 运行的 Windows 程序，这个目录也被比喻作 “bottle”，而 “Bottles” 是一个基于此机制的软件。在此，我将 “Wineprefix” 和 “bottle” 尝试翻译为 “Wine 前置配置” 和 “前置瓶”。

用 Wine 跑 Windows exe 通常需要打指令，而 Bottles 將過程簡化為只要點幾下就能執行 Windows 程式，用來跑小程式十分有用。

    https://ivonblog.com/posts/setup-linux-bottles/

用 gnome software 搜索 或 flatpak 就可以安装

    https://docs.usebottles.com/
        https://github.com/bottlesdevs/Bottles

    https://www.linuxmi.com/bottles-linux-windows-app.html

    https://linux.cn/article-16258-1.html
        https://zhuanlan.zhihu.com/p/659723921

    https://linux.cn/article-14285-1.html

竞品还有 Whisky，在Mac上运行Windows软件和游戏

    https://github.com/Whisky-App/Whisky

## Windows 下的 GNU/POSIX 环境

如果只是想做 Windows、macOS 和 Linux 等多个操作系统跨平台应用程序，使用 QT(c++/python) 或基于 Chromium+Node.js 的 Electron 框架的应用程序是更好的选择。

对 GNOME/GTK+ 环境可以考虑用 python 的 PyGObject 图形库，普通应用程序的界面用这个足够了，通过 mingw 也可在 Windows 下运行：

    https://gnome.pages.gitlab.gnome.org/pygobject/getting_started.html

    https://www.gtk.org/docs/installations/windows/

### 环境方案选择

Windows 10+ 下使用 WSL 开发 GNU 环境设置

    https://github.com/hsab/WSL-config

Windows C++ 开发环境配置

    g++ 7.0 + git + cmake

    code::block / vscode / SourceInsight

    WinSCP 同步本地和编译机代码

    BeyondCompare 图形化合并代码
        推荐用 meld 或 Diffuse 替换 BeyondCompare，参见章节 [给资源管理器添加 meld 右键菜单]

    tmux + vim 直接在编译机写代码，方便随时ssh上去复原现场继续。

    静态代码分析工具 SourceInsight

    Understand 王者没有之一
        https://www.scitools.com
        https://blog.csdn.net/jojozym/article/details/104722107
        https://www.zhihu.com/question/19570229/answer/1626066191

    库 toft + chrome + leveldb + folly + zeromq

#### 各框架对Windows本地资源的访问方式不同

虽然都是使用 mintty.exe 作为本地终端模拟器，但各框架对 Windows 目录 C:\> 的解释不同，shell操作的位置不一样

    Cygwin  /cygdrive/c

    MSYS2   /c

    wsl     /mnt/c

#### MGW 和 Cygwin 的实现思路

MingW 在编译时对二进制代码转译

    MingW (gcc 编译到mscrt)包含 gcc 和一系列工具，是 Windows 下的 gnu 环境。

    编译 linux c++ 源代码，生成 Windows 下的 exe 程序，全部使用从 KERNEL32 导出的标准 Windows 系统 API，相比 Cygwin 体积更小，使用更方便。

    如创建进程， Windows 用 CreateProcess() ，而 Linux 使用 fork()：修改编译器，让 Window 下的编译器把诸如 fork() 的调用翻译成等价的 mscrt CreateProcess() 形式。

Cygwin 在编译时中间加了个翻译层 cygwin1.dll

    https://zhuanlan.zhihu.com/p/56572298

    Cygwin 生成的程序依然有 fork() 这样的 Linux 系统调用，但目标库是 cygwin1.dll。

    Cygwin（POSIX接口转换后操作windows）在Windows中增加了一个中间层——兼容POSIX的模拟层，在此基础上构建了大量Linux-like的软件工具，由此提供了一个完整的 POSIX Linux 环境（以 GNU 工具为代表），模拟层对linux c++代码的接口如同 UNIX 一样， 对Windows由 win32 的 API 实现的cygwin1.dll，这就是 Cygwin 的做法。

    Cygwin实现，不是 kvm 虚拟机环境，也不是 QEMU 那种运行时模拟，它提供的是程序编译时的模拟层环境：exe调用通过它的中间层dll转换为对windows操作系统的调用。

    借助它不仅可以在 Windows 平台上使用 GCC 编译器，理论上可以在编译后运行 Linux 平台上所有的程序：GNU、UNIX、Linux软件的c++源代码几乎不用修改就可以在Cygwin环境中编译构建，从而在windows环境下运行。

    对于Windows开发者，程序代码既可以调用Win32 API，又可以调用Cygwin API，甚至混合，借助Cygwin的交叉编译构建环境，Windows版的代码改动很少就可以编译后运行在Linux下。

    用 MingW 编译的程序性能会高一点，而且也不用带着那个接近两兆的 cygwin1.dll 文件。
    但 Cygwin 对 Linux 的模拟比较完整，甚至有一个 Cygwin X 的项目，可以直接用 Cygwin 跑 X。

    另外 Cygwin 可以设置 -mno-cygwin 的 flag，来使用 MingW 编译。

取舍：选 MSYS2

    如果仅需要在 Windows 平台上使用 GCC，可以使用 MinGW 或者 Cygwin。

    如果还有更高的需求（例如运行 POSIX 应用程序），就只能选择安装 Cygwin。

    相对的 MingW 也有一个叫 MSYS（Minimal SYStem）的子项目，主要是提供了一个模拟 Linux 的 Shell 和一些基本的 Linux 工具。

    目前流行的 MSYS2 是 MSYS 的一个升级版，准确的说是集成了 pacman 和 Mingw-w64 的 Cygwin 升级版。

    如果你只是想在 Windows 下使用一些 Linux 小工具，建议用 MSYS2，把 /usr/bin 加进环境变量 path 以后，可以直接在命令行中使用 Linux 命令。

另有 Linux 下运行 Windows 程序的中间层 wine，也是这个思路

    https://www.winehq.org/

#### MinGW

此项目已停止维护

    https://www.ics.uci.edu/~pattis/common/handouts/mingweclipse/mingw.html

#### MinGW64

MinGW-w64 安装配置单，gcc 是 6.2.0 版本，系统架构是 64位，接口协议是 win32，异常处理模型是 seh，Build revision 是 1 。

简单操作的话，安装开源的 gcc IDE开发环境即可，已经都捆绑了Mingw64。比如 CodeLite，CodeBlocks，Eclipse CDT，Apache NetBeans（JDK 8）。

收费的有JetBrains Clion，AppCode （mac）。

#### MSYS、MSYS2

    https://www.msys2.org/

    https://msys2.github.io/

MinGW 仅仅是工具链，Windows 下的 cmd 使用起来不够方便，MSYS 是用于辅助 Windows 版 MinGW 进行命令行开发的配套软件包：提供了部分 Unix 工具以使得 MinGW 的工具使用起来方便一些。相比基于庞大的 Cygwin 下的 MinGW 会轻巧不少。

MSYS2 是 MSYS 的第二代，有大量预编译的软件包，并且具有包管理器 pacman (Arch Linux)。

在 Windows 上使用 Linux 程序

    如果只是需要一个编译器的话，可以用MinGW64。

    如果使用工具软件居多，还是 Msys2 能应付一切情况，它集合了 cygwin、mingw64 以及 mingw32（不等于老版的那个MinGW），shell、git、多种环境的 gcc（适用于 cygwin 环境或原生 Windows），而且有 pacman(ArcLinux) 作为包管理器。

#### Windows 10+ 本地化 Linux 编程接口

Windows 10 在 2022 年后，已经比较完整的提供了对 Linux 的字符程序和 GUI 程序的相应编程接口

    对 Linux 字符程序，通过 ConPty 接口支持 unix pty 应用

    对 Linux GUI 程序，通过 WSLg 接口支持 x-window/wayland 等框架下的应用

> ConPty

    https://zhuanlan.zhihu.com/p/102393122

    https://devblogs.microsoft.com/commandline/windows-command-line-introducing-the-windows-pseudo-console-conpty/

    https://learn.microsoft.com/en-us/windows/console/creating-a-pseudoconsole-session
    https://learn.microsoft.com/en-us/windows/terminal/samples
            https://github.com/microsoft/terminal/tree/main/samples/ConPTY/EchoCon

    https://www.zhihu.com/question/303307670

基于 ConPTY 的终端，既能运行 POSIX 命令行程序，也能运行基于 Windows ConHost 的命令行程序，需要 Windows version >= 10 / 2019 1809 (build >= 10.0.17763)。

目前支持 Conpty 接口的终端主要有

    Windows Terminal (from the people who wrote conpty)

    VSCode、IDEA、Eclipse 等 integrated terminal using ConPTY

    PowerShell 7+ 使用 conpty 接口运行 cmd 字符程序

    在 2022-10-28 MSYS2、mintty 支持使用 ConPty 接口了：

        MSYS2 的配置文件 /etc/git-bash.config 中设置变量 `MSYS=enable_pcon`

        mintty 配置文件 .minttyrc 中设置 `ConPTY=on`

    最直接的好处是，在 mintty 中执行 Windows 的 cmd 字符程序，不再需要借助 winpty 去加载调用了 https://github.com/mintty/mintty/wiki/Tips#inputoutput-interaction-with-alien-programs

有个性能对比测试

    https://kichwacoders.com/2021/05/24/conpty-performance-in-eclipse-terminal

> WSLg

    https://github.com/microsoft/wslg

目前已经可以支持在命令行启动运行 Linux GUI 程序了，如： gvim、gedit 等，甚至支持 GPU 加速的 3D 程序。

WSLg 其实是个部署了 X Server 的 Linux，添加了支持 Windows 远程桌面的 FreeRDP 服务，即作为 X-window 应用和  Windows 窗口应用的桥梁存在。

通过 Windows 远程桌面的接口实现了用户在 Windows 桌面直接使用 Linux GUI 程序：

    Windows 用户界面 <-> RDP <-> X Server <-> Linux GUI 程序。

而且 WSLg 用到的其实是替代 X Window System 的 Wayland Compositor，也就是 Wayland 官方给出的参考实现 Weston。这种类似于添加了个中间代理的解决方式，有利于完美适配各大 Linux 发行版和各种 Linux GUI 程序。

WSLg（Windows Subsystem for Linux GUI） 是微软官方提供的功能，允许 WSL 2 直接运行 Linux GUI 应用程序（包括完整的桌面环境），并自动集成到 Windows 桌面。

    无需额外 X Server（如 VcXsrv/X410）。

    默认使用 Wayland，支持 X11，需要额外安装

    支持剪贴板共享、音频、GPU 加速（适用于 OpenGL/Vulkan）。

    适用于 Windows 11（21H2+）或最新 Win10（需手动启用）。

在 Windows Subsystem for Linux (WSL) 下使用 GNOME + WSLg 是一种更现代、更便捷的方式，可以直接在 Windows 上运行完整的 Linux 桌面环境，而无需额外配置 X Server。

参见章节 [在 WSL 实例上运行完整的 Linux 桌面环境](Windows 10+ 那些事儿.md)。

## Windows字符终端

Windows 10 2018年之前的版本 CMD 终端不同于 Linux 的伪终端机制：

    终端模拟器的角色是 conhost.exe，通过外壳程序 cmd、powershell，他们在启动时连接本机的 conhost。

    conhost 实现机制跟 Linux 伪终端不同，一个是调用 Windows API，一个是发送文本字符作为显示效果的控制，所以按照 Linux 终端原理工作的终端模拟器及各种终端应用程序其实无法连接 conhost。

    终端概念参见章节 [Linux 字符终端]。

Windows 下实现 Linux 伪终端机制的是 Msys2 项目，基于 putty 制作了 mintty.exe 作为本地终端模拟器，借助它就可以使用 unix pty 的程序如 bash、zsh 等，详见章节 [mintty 终端模拟器]。

2018年 Windows 10 新的 ConPTY 接口实现了 *NIX 的伪终端功能，使得各种终端模拟器可以用文本的方式连接本机 Windows 接口的字符显示接口，参见章节 [Windows 10 本地化 Linux 编程接口]，下列三个常用工具程序估计用处不大了：

    clink 辅助工具，在 cmd 下模仿 bash，按 tab 键自动完成，像 emacs 一样编辑输入的命令，很多支持终端多路复用的软件在 Windows 下调用 cmd 都使用了 clink

        https://github.com/chrisant996/clink
            不再更新了 https://github.com/mridgers/clink

    winpty 辅助工具，提供了 unix pty 接口与 cmd conhost 接口的互通，是 mintty 这种 MSYS2 环境下执行 Windows CMD/PowerShell 程序的中介，参见章节 [winpty 运行 cmd 字符终端程序]

        https://github.com/rprichard/winpty

        https://gitforwindows.org/faq.html#some-native-console-programs-dont-work-when-run-from-git-bash-how-to-fix-it

    wslbridge 辅助工具，提供了 unix pty 接口与 WSL(Windows Subsystem for Linux) 的互通，很多支持终端多路复用的软件在 Windows 下都通过该组件使用 WSL 会话

        wslbridge2 https://github.com/Biswa96/wslbridge2
            wslbridge 不更新了2018 https://github.com/rprichard/wslbridge/

有很多图形化的终端模拟器，如果想统一在一个窗口程序下标签化管理各个连接，这样的程序称为终端多路复用器 terminal multiplexer，推荐使用 [Windows Terminal]。

Windows 下的字符终端，如果要显示图标化字符，需要 Windows 安装支持多种符号的字体，见章节 [Nerd Font]。

### putty 终端模拟器

putty 完美的实现了在 Windows 下使用 ssh 远程连接 Linux 服务器，连接后用户使用体验跟 Linux 下的本地终端模拟器完全一致

    https://www.chiark.greenend.org.uk/~sgtatham/putty/

    竞品 KiTTY https://github.com/cyd01/KiTTY

        从 putty 拉的分支而来，是对 putty 的易用性改进，共用putty的站点配置，增加了背景透明、支持站点列表的文件夹、自动化操作脚本，可以给站点加注释，还有便携版

        注意，区别于 https://sw.kovidgoyal.net/kitty，那个是 Linux 下的 GPU 加速终端模拟器

    竞品 bitvise https://www.bitvise.com/

putty 连接远程服务器，实现了 ssh 的全部功能，使用 PUTTYGEN.EXE 生成并管理密钥，使用 PAGEANT.EXE 作为密钥代理，并在一个单一窗口下填写远程服务器的参数配置，远程服务器的终端显示也是一个单一窗口。

术语：会话 Session

    因为功能是连接远程站点然后执行命令行操作，putty 把每个连接保存为会话，设置会话就是设置连接某站点的参数，除了终端显示的参数，还有各种连接协议的参数等多种设置

putty 登录站点后的使用很简单

    点击并拖动鼠标左键是选择文字并复制到操作系统剪贴板（运行 putty 的操作系统，不是远程站点的）

    点击鼠标右键，从操作系统剪贴板粘贴到当前的命令提示符后面

putty 的初始界面只有一个，选择会话和会话设置两个功能区混合，使用逻辑有点绕：

    会话设置的类别界面“Category”在左侧树形展示

    会话选择界面在右侧，对应左侧界面“Category”的树形列表第一项“Session”

    会话选择界面的上半部分是站点的ip地址和端口等参数设置，下半部分是会话列表供选择

    会话参数的各项设置界面在右侧，对应左侧界面“Category”的树形列表的其它各分支项

    连接会话的“Open”按钮在最下方，选择一个已有会话后点击该按钮即可连接登录站点

    左侧界面“Category”的树形列表的其它部分，是当前选择的会话的参数，点击各个分支时右侧界面会切换为该会话各参数的设置界面（需要先在会话选择界面选择会话，点“Load”按钮，否则是默认的初始参数）

    如果右侧界面需要切换到会话选择界面，点击左侧界面“Category”的树形列表第一项“Session”

简易连接站点：

    在左侧界面“Category”，点击的树形列表第一项“Session”，右侧出现会话选择界面，这也是 putty 启动后的初始界面

    右侧会话选择界面，在“Host Name(or IP address)”输入地址和端口，点击下方的“Open”按钮，这样会使用默认的初始参数进行连接

    可点击左侧界面的树形列表，设置本次连接使用的参数，然后再点击“Open”按钮

连接已有站点：

    在左侧界面“Category”，点击的树形列表第一项“Session”，右侧出现会话选择界面，这也是 putty 启动后的初始界面

    在右侧会话选择界面，操作如下：

        在“Saved Sessions”列表选择一个会话，双击即可。

        或在“Saved Sessions”列表点击一个会话，使其变为蓝色已选，然后点击下方的“Open”按钮

        或在“Saved Sessions”下方的编辑框手动输入会话名称，然后点击下方的“Open”按钮

建立新的会话

    在左侧界面“Category”，点击的树形列表第一项“Session”，右侧出现会话选择界面，这也是 putty 启动后的初始界面

    在右侧会话选择界面，操作如下：

        在“Host Name(or IP address)”、“Port”输入地址和端口

        在“Saved Sessions”输入新的会话名称

        点击右侧的“Save”按钮

    如果新会话有某些参数需要设置，执行下面的“编辑已有会话”步骤。

编辑已有会话

    在左侧界面“Category”，点击的树形列表第一项“Session”，右侧出现会话选择界面，这也是 putty 启动后的初始界面

    1、在右侧会话选择界面，操作如下：

    在 “Saved Sessions” 列表选择一个会话，点击右侧的 “Load” 按钮，这时会话名称会自动填充“Saved Sessions” 下方的编辑框，而且 “Host Name(or IP address)”、“Port” 和 “connection type” 栏目都会显示该会话的站点参数

        如果想复制该会话，编辑新的会话名称，然后点击右侧的 “Save” 按钮，转下面第4步。

        如果想删除该会话，点击右侧的 “Delete” 按钮，转下面第4步。

    下面的第2、3步可都做，或只做一个。

    2、基本会话参数的修改：

    在右侧会话选择界面，可修改“Host Name(or IP address)”、“Port” 和 “connection type” 栏目。

    点击右侧按钮 “Save” 保存你的修改。如果不保存，直接点击下方的 “Open” 按钮，相当于用你修改的参数临时连接当前站点。

    然后可转下面第4步。

    3、高级会话参数的修改：（这里比较绕，习惯习惯就好）

    点击左侧 “Category” 界面的树形列表的各个分支，右侧界面会跟随改变，不再是会话选择界面了，变成了你当前选择会话的相关参数的设置界面。如果未选择会话，则是 putty 启动后使用的默认初始参数。

        切换左侧选择树形列表的各个分支，则右侧界面跟随变为相关参数的设置，自行调整即可。

        比如“Connection->Data”里预设该站点的登录用户名，“Connection->SSH-Auth”里设置该站点密钥登录的密钥文件等等。

        有些参数是影响终端呈现效果的，比如终端类型可以选择 xterm-256color 等效于在登录站点后的shell里设置环境变量 Term=xterm-256color。

        有些参数影响 putty 的窗口，比如窗口滚动条缓存屏幕内容12000行，酌情设置。

    保存你的修改：调整完成后，点击左侧界面“Category”的树形列表第一项“Session”，右侧会重新出现你的会话选择界面

        检查下“Saved Sessions”下方的编辑框，务必确认自动填充的还是你刚才选择的那个会话名称，如果是新的名称会被保存为新的会话。

        点击右侧按钮“Save”保存你的修改。如果不保存，直接点击下方的“Open”按钮，相当于用你修改的参数临时连接当前站点。

    如果改乱了不想保存，转第1步重新加载会话设置即可。

    4、执行上面“连接已有会话”的步骤，连接你的会话。

如果在右侧的会话选择界面，不选择已有会话，直接在左侧 “Category” 界面的树形列表进行了各种调整

    不推荐这样做，可能会乱。

    这样需要后续再输入ip地址和端口

        点击Open按钮就是“简易连接”

        如果给出站点名称后点击“Save”按钮，这样会保存一个会话。

备份会话

putty把会话的参数写入了 Windows 注册表，需要手工导入，新建一个 exp_session.bat

```bat
REG EXPORT HKEY_CURRENT_USER\Software\SimonTatham SESSION.REG
```

执行该 bat 文件，会在当前目录下生成一个名为 session.reg 的文件。
如果需要恢复站点设置，直接双击该文件即会被 Windows 导入注册表。

> putty 美化

    仿效本地终端模拟器根据变量 $TERM 自动模拟为指定的终端类型，putty 可以在站点选项里设置终端类型，这样在登录远程服务器后就按照指定的类型显示了，一般默认为 xterm 就是彩色。

开启 Putty 终端 256色 的支持: Putty->load你的session->Window->Colours->勾选 “General options for colour usage” 下的几个选项。

即使你设置会话时勾选了使用 256color 和 true color 真彩色，putty 默认的主题比较保守，只使用 16 种颜色（用 rgb 设置，其实支持真彩色），你ssh登录到服务器会发现文字色彩比较刺眼。

可以自定义颜色，在设置会话时 custom color，如果感觉挨个设置太麻烦，试试别人做好的

    https://github.com/AlexAkulov/putty-color-themes

    北极主题颜色 https://github.com/arcticicestudio/nord-putty

    超多主题颜色，有 putty 的

        https://github.com/mbadolato/iTerm2-Color-Schemes

    自定义主题颜色，自己设计

        https://ciembor.github.io/4bit/ 点击右上角“Get Scheme”，选复制并粘贴

推荐使用 nord 主题

    curl -fsSLO https://github.com/arcticicestudio/nord-putty/raw/develop/src/nord.reg

双击该 reg 文件，确认导入，然后你的 putty 会话列表里新增一个 “NORD” 会话，点击 “load” 按钮加载该会话，可以看到只设置了颜色，并没有站点 ip，填写自己的 ip 地址和端口，连接看看，会发现颜色效果柔和多了。如果满意，就另存该会话为你的站点名称即可。

### mintty 终端模拟器

简单使用建议直接安装 git for Windows，它的 git bash 就是 mintty，而且自带 git 运行需要的相关 gnu 工具程序，非常方便。详见章节 [mintty 简单使用：Git for Windows]。

    https://github.com/mintty/mintty
        https://github.com/mintty/mintty/wiki/Tips
        http://mintty.github.io/
        帮助 https://mintty.github.io/mintty.1.html

源码来自 putty 拉分支，目前归属 MSYS2 项目，自带 bash，模拟 unix pty 效果又快又好

    如果运行 cmd 下的 Windows 字符命令，有些字符解释的显示效果不一致，建议与 cmd 分别使用，不在 mintty 下使用 cmd 的命令。或者使用 winpty 调度，参见章节 [winpty 运行 cmd 字符终端程序]。

    ctrl/shift + ins 复制/粘贴，其实系统默认用鼠标拖动选择的文字复制到系统剪贴板

    在 tmux 的鼠标模式下，按下 shift 就可以使用鼠标选择文字，自动复制到系统剪贴板

    ctrl + plus/minus/zero 放大、缩小、还原

    拖拽资源管理器里的文件/文件夹到 mintty 可以得到其路径

mintty 可以在终端显示图片，下载他的源代码下 utils 目录下的脚本 showimg 即可

    $ curl -fsSL https://github.com/mintty/utils/raw/master/showimg |sudo tee /usr/local/bin/showimg && sudo chmod 755 /usr/local/bin/showimg

    另外还有 catimg/SDL2_image（showimage2） 等软件包支持在终端下显示图片

建议放到本地 /usr/bin/ 下，以后执行 `showimg xxx.jpg` 就可以在 mintty 下显示本地图片；如果 ssh 登录到服务器上，在服务器的 /usr/local/bin/ 下也安装这个脚本，则 mintty 也可以响应服务器上执行的 `showimg xxx.jpg`，显示服务器上的图片。

或安装个 lsix 脚本，因为 mintty 支持 Sixel 格式的图片显示

        https://www.linuxprobe.com/sixel-linux.html

    先在服务器端安装依赖包，会安装一堆的库

        sudo apt install imagemagick

    然后把脚本 lsix 拷贝到你的终端的 /usr/bin/ 目录下即可

        # 只要你的终端支持 Sixel 图形格式即可
        git clone --depth=1 https://github.com/hackerb9/lsix

    就像 ls 命令那样使用 lsix。

#### winpty 运行 cmd 字符程序

    https://github.com/mintty/mintty/wiki/Tips#inputoutput-interaction-with-alien-programs

    https://github.com/git-for-windows/git/wiki/FAQ#some-native-console-programs-dont-work-when-run-from-git-bash-how-to-fix-it

在 mintty 或 Cygwin 的命令行环境下，如果执行Windows 控制台程序 （Windows CMD 程序或 PowerShell），如 python 会挂死无法进入。这是因为 python 使用的是 native Windows API for command-line user interaction，而 mintty 支持的是 unix pty，或称 Cygwin/MSYS pty。

也就是说，Windows 控制台程序在 MSYS2 mintty 下直接执行会挂死，需要有个 Cygwin/MSYS adapter 提供类似 wslbridge 的角色。

安装 winpty 作为 mintty 代理（git for windows 自带）

    pacman -S winpty

然后执行 `winpty python` 即可正常进入 python 解释器环境了

最好在用户登录脚本文件 ~/.bashrc、~/.zshrc 里添加 alias 方便使用

    alias python="winpty python"
    alias ipython="winpty ipython"
    alias mysql="winpty mysql"
    alias psql="winpty psql"
    alias redis-cli="winpty redis-cli"
    alias node="winpty node"
    alias vue='winpty vue'

    # Windows 控制台程序都可以在 bash 下用 winpty 来调用
    alias ping='winpty ping'

如果 Windows version >= 10.2019.1809，新增的 ConPty 接口兼容了老的控制台应用程序 ConHost 接口，支持 ConPty 接口的应用可以支持 unix pty，就不需要使用 winpty 做调度了，见章节 [Windows 10 本地化 Linux 编程接口]。

#### mintty 美化

mintty 支持对 16 色代码表的实际展现效果进行自定义，在 mintty 窗口右键选项选择“外观->颜色样式设计工具”，会打开如下网址自定义即可

    https://ciembor.github.io/4bit/ 点击右上角“Get Scheme”，弹出页面的链接上点右键选复制，在地址栏粘贴后回车

主题颜色

    https://github.com/hsab/WSL-config/tree/master/mintty/themes

    https://github.com/oumu/mintty-color-schemes

将主题文件保存到 mintty 安装目录的 msys64/usr/share/mintty/themes 目录下（C:\Program Files\Git\usr\share\mintty\themes），通过右键 mintty 窗口标题栏的 option 进行选择。

mintty 默认的主题比较保守，只使用256色，如果你想看到真彩色的效果，尝试下选择自定义主题，会看到颜色柔和多了，推荐 nord 主题。文字彩色设置，详见章节 [终端模拟器和软件的真彩色设置]。

也可以编辑 ~/.minttyrc 文件，自行设置各种颜色。

#### .minttyrc 配置文件样例

```config
# 可自定义表情标签 https://github.com/mintty/mintty/wiki/Tips#installing-emoji-resources
# https://mintty.github.io/mintty.1.html
# https://github.com/mintty/mintty/wiki/Tips#configuring-mintty
# 只支持等宽字体
Font=MesloLGS Nerd Font Mono
FontHeight=11
FontSmoothing=full
# FontWeight=700
# FontIsBold=yes

Columns=130
Rows=40
ScrollbackLines=12000

CursorType=block
CursorBlinks=yes

# 语言设置
# mintty界面的显示语言，zh_CN是中文，Language=@跟随Windows
Language=@

# 终端语言设置选项，在 Windows 10 下好像都不需要设置，下面的是 Windows 7 下的，是否因为操作系统默认编码是 ANSI ？
# https://www.cnblogs.com/LCcnblogs/p/6208110.html
# bash下设置，这个变量设置区域，影响语言、词汇、日期格式等，参见章节 [字符终端的区域、编码、语言]

# bash 下显示中文
Locale=zh_CN

# 中文版 Windows 使用 ansi 字符集，
# 但使用 UTF-8 的命令如 tail、ls 会没法都设置完美显示中文，
# 或使用 uinx pty 的命令如 python卡死，需要借助 winpty。
# 设置为 UTF-8 还能正确展现那些带图标的字体
#Charset=GBK
Charset=UTF-8

# LANG 只影响字符的显示语言
# win7下显示utf-8文件内容, 可先执行命令 `locale` 查看ssh所在服务器是否支持
#LANG=zh_CN.UTF-8

# 窗体透明效果，不适用于嵌入多窗口终端工具
# Transparency=low

# 为了使用更多的颜色，确保终端设置恰当
Term=xterm-256color

# 非通用标准的项目
UnderlineColour=153,241,219
AllowBlinking=yes
BoldAsFont=yes

# Windows version >= 10 / 2019 1809 (build >= 10.0.17763)
# 2023.2 脚本执行速度慢于 mintty 本地处理
# 2025.3 进入 tmux 后打印乱码
#ConPTY=on

# 自定义颜色方案，跟深色背景搭配
# https://github.com/mintty/mintty/wiki/Tips#background-image
# 自定义颜色方案 https://ciembor.github.io/4bit/ 点击右上角“Get Scheme”，选复制并粘贴
# 根据图片生成颜色方案 https://github.com/thefryscorer/schemer2 参见章节 [base16颜色方案](gnu_tools.md okletsgo)
Background=C:\tools\111dark.jpg,225
#0D1926
BackgroundColour=13,25,38
#839496 #B6CDD0
ForegroundColour=131,148,150
CursorColour=236,255,255
#353535
Black=53,53,53
#5C5C5C
BoldBlack=92,92,92
#FD6666
Red=253,102,102
#F38F8D
BoldRed=243,143,141
#3BC077
Green=59,192,119
#37B58B
BoldGreen=55,181,139
#CFBE74
Yellow=207,190,116
#DFD877
BoldYellow=223,216,149
#377AB0
Blue=55,122,176
#68A0CC
BoldBlue=104,160,204
#AD5136
Magenta=173,81,54
#CA7055
BoldMagenta=202,112,85
#4FC4B5
Cyan=79,196,181
#74CFBE
BoldCyan=116,207,190
#EEE8D5
White=238,232,213
#FDF6E3
BoldWhite=253,246,227

# 自定义颜色方案，跟深色背景搭配，nord 的暗淡方案
# https://github.com/arcticicestudio/nord-alacritty/blob/main/src/nord.yml
#Background=C:\tools\DR_6.jpg
#BackgroundColour=46,52,64
#ForegroundColour=216,222,233
#CursorColour=216,222,233
#Black=55,62,77
#BoldBlack=55,62,77
#Red=148,84,93
#BoldRed=148,84,93
#Green=128,149,117
#BoldGreen=128,149,117
#Yellow=178,158,117
#BoldYellow=178,158,117
#Blue=104,128,154
#BoldBlue=104,128,154
#Magenta=140,115,140
#BoldMagenta=140,115,140
#Cyan=109,150,165
#BoldCyan=109,150,165
#White=174,179,187
#BoldWhite=174,179,187

# 自定义颜色方案，跟浅色背景搭配-黄色
#Background=C:\tools\222yellow.jpg,225
#BackgroundColour=250,234,182
#ForegroundColour=0,61,121
#CursorColour=217,230,242
#Black=80,80,80
#BoldBlack=103,103,103
#Red=243,37,20
#BoldRed=238,83,83
#Green=67,156,57
#BoldGreen=91,191,80
#Yellow=207,190,35
#BoldYellow=220,203,48
#Blue=3,82,139
#BoldBlue=10,123,184
#Magenta=133,41,39
#BoldMagenta=176,38,38
#Cyan=38,176,166
#BoldCyan=80,191,180
#White=205,175,175
#BoldWhite=176,182,204

# 自定义颜色方案，跟浅色背景搭配-绿色
#Background=C:\tools\333green.jpg,128
#BackgroundColour=250,234,182
#ForegroundColour=47,47,47
#CursorColour=217,230,242
#Black=0,0,0
#BoldBlack=38,38,38
#Red=255,30,18
#BoldRed=255,153,147
#Green=82,173,58
#BoldGreen=65,136,47
#Yellow=193,117,40
#BoldYellow=213,179,60
#Blue=11,80,155
#BoldBlue=17,120,234
#Magenta=255,18,243
#BoldMagenta=255,147,250
#Cyan=32,138,115
#BoldCyan=36,162,133
#White=235,235,235
#BoldWhite=255,255,255

# 北极主题颜色 https://github.com/arcticicestudio/nord-mintty
# papercolor https://github.com/NLKNguyen/papercolor-theme
# https://github.com/mavnn/mintty-colors-solarized/blob/master/.minttyrc.light
# https://github.com/mavnn/mintty-colors-solarized/blob/master/.minttyrc.dark
#
# 使用内置颜色方案，建议放在最下面以覆盖上面的颜色设置
# ThemeFile=nord

```

#### mintty 简单使用：Git for Windows

Git 在 Windows 下运行，专门起了一个项目 git for Windows，主要是因为 git 在 Linux 下运行依赖 bash 环境，在 Windows 下使用了 GNU tools 的 MinGW(Msys2) 实现了 git bash，并集成了 git bash 需要的部分工具软件，我们主要使用他的 git bash、 mintty.exe 终端模拟器和 git、ssh、gpg、winpty 等命令行工具。

安装 git for Windows 或 MSYS2 后就有了，为了简单安装 git for windows 就可以了

    https://git-scm.com/download/win
        https://gitforwindows.org/

配置文件样例参见章节 [mintty 美化]

    git for Windows 下的 mintty 配置文件在 ~\.minttyrc

    MSYS2 的 mintty 的配置文件与 git for Windows 不同，详见章节[全套使用：安装 MSYS2(Cygwin/Msys)]

如果使用 mintty.exe，需要添加额外的启动参数，指定使用何种shell

    mintty.exe /bin/bash --login -i

    --login 加载配置文件 ~/.bash_profile 等，不然你进入的是个干巴的 shell

    -i      创建一个交互式的shell

git-bash.exe

    自称 git bash，其实是 `mintty.exe /bin/bash --login -i` 的封装，可直接双击执行。用于执行 unix pty 的命令，显示兼容性最好。

    如果使用 git-bash.exe，一般使用 `git-bash.exe --cd-to-home` 打开即进入 $HOME 目录，比较方便

git-cmd.exe

    其实是 cmd 的一个封装，可直接双击执行。用于执行 cmd 下的命令，显示兼容性最好。路径 path 优先指向了 git for windows 的目录。

对路径的表示有点特殊，如磁盘路径需要使用 /c/ 来代替 c：来访问具体路径

    cd /c/tools 表示访问 Windows 的 c:\tools 目录

其它的几个的 Linux 目录结构跟 Windows 目录的对应关系

    $HOME 目录      %USERPROFILE%

    / 目录          git安装目录 C:\Program Files\Git
    /usr 目录       C:\Program Files\Git\usr
    /bin 目录       C:\Program Files\Git\bin
    /dev 目录       C:\Program Files\Git\dev
    /etc 目录       C:\Program Files\Git\etc

    /tmp 目录       C:\Users\%USERNAME%\AppData\Local\Temp

    /proc 目录      这个是 git 自己虚出来的，只能在 git bash(mintty) 下看到

    /cmd 目录       C:\Program Files\Git\cmd，用于 cmd 命令行窗口下运行 git 和 ssh 用的几个脚本

退出bash时，最好不要直接关闭窗口，使用命令exit或^D，不然会提示有进程未关闭。

putty的退出也是同样的建议。

#### mintty 组合使用：git for Windows + MSYS2

拷贝 MSYS2 的工具到 git 里，这样只使用 git bash(mintty) 就可以了。

二者混用是个凑合的解决办法，因为如果遇到二者的调用库版本不一致会导致报错，所以最好是安装 MSYS2，然后使用它自带的 mintty、git、ssh、zsh 等工具，详见下面章节 [mintty 全套使用]。

假设 git 的安装目录在 D:\Git，可执行文件在 D:\Git\usr\bin\ 目录：

以迁移 tmux.exe 为例，可执行文件放在 D:\Git\usr\bin\：

    tmux.exe
    event_rpcgen.py
    msys-event-2-1-7.dll
    msys-event_core-2-1-7.dll
    msys-event_extra-2-1-7.dll
    msys-event_openssl-2-1-7.dll
    msys-event_pthreads-2-1-7.dll

其它放在 D:\Git\usr\share\ 下：

    licenses\libevent
    licenses\tmux
    man\man1\tmux.1.gz

使二者共享一套 HOME 目录：

MSYS2 的 mintty 的配置文件不使用操作系统当前用户的 home 目录，详见章节[全套使用：安装 MSYS2(Cygwin/Msys)]。

git for windows 使用操作系统当前用户的 home 目录，默认为 %USERPROFILE% （C:\Users\%USERNAME%\）。

home 目录的隔离虽然使两个软件的设置互不干扰，但也使得 ssh、gpg、git、vim、tmux 等工具的配置文件不能共享。

    保持隔离的解决办法

        如果在安装 MSYS2 之前已经安装了 git for windows，可以将之前 ssh、git 、vim、tmux 等工具的配置文件拷贝到 MSYS2 的 home 目录下。

    共享的解决办法

        在 Windows 上配置环境变量 HOME 为 C:\you-path\msys64\home\your-name，增加这个环境变量的目的是为了让 git for windows 的 home 目录指向 MSYS2 的 home 目录。

#### mintty 全套使用：安装 MSYS2(Cygwin/Msys) + pacman

参考文章

    MSYS2 和 mintty 打造 Windows 下 Linux 工具体验
        https://creaink.github.io/post/Computer/Windows/win-msys2.html

    Windows 下 MSYS2 配置及填坑 https://hustlei.github.io/2018/11/msys2-for-win.html

下载安装 MSYS2

    https://www.msys2.org/

    https://msys2.github.io/

使用 pacman 安装各种包，详见下面章节 [软件仓库 pacman]。

pacman 更换清华源 <https://mirrors.tuna.tsinghua.edu.cn/help/msys2/> 中科大 <https://mirrors.ustc.edu.cn/help/msys2.html>，配置文件在 msys 的安装目录下的文件夹 msys64\etc\pacman.d\ 下。

依次添加

    编辑 /etc/pacman.d/mirrorlist.msys，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/msys/$arch/
        Server = http://mirrors.ustc.edu.cn/msys2/msys/$arch/

    编辑 /etc/pacman.d/mirrorlist.mingw32，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/i686/
        Server = http://mirrors.ustc.edu.cn/msys2/mingw/i686/

    编辑 /etc/pacman.d/mirrorlist.mingw64，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/x86_64/
        Server = http://mirrors.ustc.edu.cn/msys2/mingw/x86_64/

    编辑 /etc/pacman.d/mirrorlist.ucrt64，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/ucrt64/
        Server = http://mirrors.ustc.edu.cn/msys2/mingw/ucrt64/

    编辑 /etc/pacman.d/mirrorlist.clang64，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/clang64/
        Server = http://mirrors.ustc.edu.cn/msys2/mingw/clang64/

然后 Windows 执行开始菜单的快捷方式 "MSYS2 MSYS" 以打开命令行，更新软件包数据，之后可以使用 "MSYS2 MinGW X64"，

    # pacman -Sy
    :: Synchronizing package databases...
    mingw32              1594.6 KiB   729 KiB/s 00:02 [#####################] 100%
    mingw64              1604.5 KiB   494 KiB/s 00:03 [#####################] 100%
    ucrt64               1663.1 KiB   985 KiB/s 00:02 [#####################] 100%
    clang32              1556.7 KiB   400 KiB/s 00:04 [#####################] 100%
    clang64              1587.3 KiB   532 KiB/s 00:03 [#####################] 100%
    msys                  384.9 KiB   293 KiB/s 00:01 [#####################] 100%

    # 更新核心软件包
    # pacman -Su

安装时给出了一些文件链接的提示

    './.bashrc' -> '/home/%USERNAME%/.bashrc'
    './.bash_logout' -> '/home/%USERNAME%/.bash_logout'
    './.bash_profile' -> '/home/%USERNAME%/.bash_profile'
    './.inputrc' -> '/home/%USERNAME%/.inputrc'
    './.profile' -> '/home/%USERNAME%/.profile'

    'C:\Windows\system32\drivers\etc\hosts' -> '/etc/hosts'
    'C:\Windows\system32\drivers\etc\protocol' -> '/etc/protocols'
    'C:\Windows\system32\drivers\etc\services' -> '/etc/services'
    'C:\Windows\system32\drivers\etc\networks' -> '/etc/networks'

该软件安装后，使用的Linux目录结构跟Windows目录的对应关系

    home 目录      位于msys2的安装目录 msys64\ 下的 home\%USERNAME%

    / 目录          位于msys2的安装目录 msys64\ 下
    /usr 目录       同上
    /tmp 目录       同上

环境的隔离做的比较好，不会干扰Windows当前用户目录下的配置文件

    如果你的系统中独立安装了如 git for Windows 、 Anaconda for Windows 等，他们使用 C:\Users\%USERNAME% 下的 bash_profile、mintty 等配置文件，注意区分。

msys2在开始菜单下的好几个版本的说明

    是因为编译器和链接的windows的c库不同，而故意分开编译的。作为一个软件运行平台，为了适应不同编译器编译出来的程序（Windows 对 CRT 运行库的支持不一样），而不得不区分开来。

    LLVM/Clang 和 MINGW(GCC) 是两个不同的 C/C++ 编译器， mingw64、ucrt64、clang64 都是 Windows 原生程序（不依赖 cygwin.dll），不过 mingw64 是很早就有的，后两者是最近才新加的，所以只是选一个的话就用 mingw64。

具体区别是：

    mingw64 与 ucrt64 都是用 mingw64 编译器编译的 Windows 64位程序，只不过它们链接到的 crt（C runtime）不同， mingw64 是链接到了 msvcrt ，而 ucrt64 则是链接到了 Windows 10+ 上新的 ucrt 上。

    而 clang64 很好理解，就是用 clang 而非 mingw 来编译各种库，另外它也是链接到了 ucrt 而非 msvcrt。

    引自 <https://www.zhihu.com/question/463666011/answer/1927907983>

    官方解释 <https://www.msys2.org/docs/environments/>

msys2的启动方式都是通过调用 msys2_shell.cmd，不同仅在于传递了变量 set MSYSTEM=xxxx，msys2_shell.cmd 启动时，都默认使用 mintty

    # c:\msys64为msys2安装目录，bash 为默认 shell，可以用 zsh,csh 等替换
    set MSYSTEM=MINGW64
    "c:\msys64\usr\bin\mintty" "c:\msys64\usr\bin\bash" --login

自己运行 Msys2 时可以不使用 mintty，直接运行如下命令就OK：

```bat

rem 启动MSYS2 MSYS
set MSYSTEM=MSYS
"c:\msys64\usr\bin\mintty" "c:\msys64\usr\bin\bash" --login

rem 启动MSYS2 MINGW32
set MSYSTEM=MINGW32
"c:\msys64\usr\bin\bash" --login

rem 启动MSYS2 MINGW64
set MSYSTEM=MINGW64
"c:\msys64\usr\bin\bash" --login

```

##### 软件仓库 pacman

基于 Arch Linux 的 pacman 提供软件仓库，采用滚动升级模式，初始安装仅提供命令行环境：高手用户不需要删除大量不需要的软件包，而是可以从官方软件仓库成千上万的高质量软件包中进行选择，搭建自己的系统。

pacman 命令较多，常用的命令如下：

    pacman -Sy           更新软件包数据
    pacman -Su           更新核心软件包
    # pacman -Syu        升级系统及所有已经安装的软件。
    pacman -S 软件名      安装软件。也可以同时安装多个包，只需以空格分隔包名即可。
    pacman -Rs 软件名     删除软件，同时删除本机上只有该软件依赖的软件。
    pacman -Ru 软件名     删除软件，同时删除不再被任何软件所需要的依赖。
    pacman -Ssq 关键字    在仓库中搜索含关键字的软件包，并用简洁方式显示。
    pacman -Qs 关键字     搜索已安装的软件包。
    pacman -Qi 软件名     查看某个软件包信息，显示软件简介,构架,依赖,大小等详细信息。
    pacman -Sg           列出软件仓库上所有的软件包组。
    pacman -Sg 软件包组    查看某软件包组所包含的所有软件包。
    pacman -Sc           清理未安装的包文件，包文件位于 /var/cache/pacman/pkg/ 目录。
    pacman -Scc          清理所有的缓存文件。

安装常用软件

    不要安装 msys2 版的 python，还是用 anaconda 最方便

    pacman -S openssh opengpg vim git tmux winpty

    pacman -S sed awk tree curl time nano tar gzip rsync

    # netcat 的版本选择： gnu nc 没有 proxy 参数(-x), 因此我们要选择 openbsd 版
    pacman -S openbsd-netcat

    # 下面的命令大部分在 bash 中内置了

    # 常用的系统命令 cat cut chmod echo mv tail 等，http://gnu.org/software/coreutils
    pacman -S coreutils

    # 进程管理 ps、kill、top、watch 等，https://gitlab.com/procps-ng/procps/
    pacman -S procps-ng

    # 常用的网络命令 ping, ping6, traceroute, whois, rsh 等，https://www.gnu.org/software/inetutils/
    pacman -S inetutils

    # find xargs
    pacman -S Findutils

    # diff
    pacman -S diffutils

    # 安装 zsh 主要是为了它多彩的命令行提示符等扩展插件，详见下面章节 [使用 zsh]
    pacman -S zsh

如果需要安装什么命令不知道输入何种包名，一般可以在搜索引擎里以 `MSYS2 xxx` 的形式得到结果。

另外， Cygwin下还有 apt-cyg 命令行包管理器 <https://zhuanlan.zhihu.com/p/66930502>，操作软件仓库 <https://zhuanlan.zhihu.com/p/65482014>。

### 其他终端模拟器

不常用终端会遇到 terminfo 问题

    https://ttys3.dev/post/kitty/

    如果你尝试 ssh 到远程机器, 可能会发现你本机的 zsh 报错:

    /home/user007/.zsh_compatible:bindkey:2: cannot bind to an empty key sequence

    这个问题其实不只存在于 kitty, 任何有自己独立的 terminfo 的 terminal (且其信息没有在 ncurses 中内置), 基本上都会有这个问题. 比如 Alacritty 也有这个问题.

    这个问题在官方faq文档里面也有说明:

    I get errors about the terminal being unknown or opening the terminal failing when SSHing into a different computer?

    This happens because the kitty terminfo files are not available on the server. You can ssh in using the following command which will automatically copy the terminfo files to the server:

        kitty +kitten ssh myserver

    This ssh kitten takes all the same command line arguments as ssh, you can alias it to ssh in your shell’s rc files to avoid having to type it each time:

        alias ssh="kitty +kitten ssh"

Contour Terminal Emulator 这个是真正的速度极快，而且跨平台

    还在发展中，不足较多：不支持中文字体回落

    https://contour-terminal.org/configuration/
    https://zhuanlan.zhihu.com/p/505530480

        $ sudo dnf install contour-terminal

    快捷操作

        Ctrl+Shift+Space 当前屏幕进入vim模式，方便用键盘选择屏幕文字复制粘贴等操作。
        按 a 或 i 进入编辑模式会自动退出到命令行进行普通的编辑。

    配置文件在

        # flatpak：~/.var/app/org.contourterminal.Contour/config/contour/contour.yml
        ~/.config/contour/contour.yml

    目前只能手动修改：

    ```yml
    # 主配置
    profiles:
        main:
            # 打开终端后作为登录shell
            shell: "/bin/bash"
            arguments: ["-l"]

            # 按字符数的窗口大小
            terminal_size:
                columns: 80
                lines: 25

            scrollbar:
                position: Right

            # 字体
            font:
                regular:
                    # 不支持中文字体回落 ["MesloLGS Nerd Font", "Noto Serif CJK SC"]
                    family: "MesloLGS Nerd Font"

            # 光标样式和闪动
            cursor:
                blinking: true

            # 背景透明和模糊
            background:
                opacity: 0.95
                blur: false

            # 颜色方案，在下面的 color_schemes 处配置
            # Specifies a colorscheme to use (alternatively the colors can be inlined).
            colors: "default"

    # 颜色方案
    color_schemes:
        # 系统默认的颜色方案
        default:

            background_image:
                # flatpak 下不知道怎么找路径。。。
                path: '/Pictures/78883229_UHD.jpg'
                opacity: 0.5
                blur: false

    # 快捷键
    input_mapping:
        # 选择文字后按 ctrl+c 是复制到内部剪贴板，中键可粘贴
    ```

WindTerm 基于 C 开发的开源终端模拟器，支持多个平台，支持终端多路复用，绿色不需要安装。速度快，兼容性较好，左侧就是文件夹树方便 sftp，支持 lrzsz 的文件拖放传送，命令行输出还支持标签折叠

    https://github.com/kingToolbox/WindTerm
        https://kingtoolbox.github.io/

    https://zhuanlan.zhihu.com/p/550149638

    初次使用注意关闭主密码、关闭自动锁屏的功能。否则一旦锁屏了，只能编辑 user.config 文件：

        干掉 application.fingerprint 和 application.masterPassword

        再找到 .wind/profiles/default.v10/terminal/user.sessions 文件删除 session.autoLogin， 就可以将主密码设置为空字符串了，之后再来修改主密码，就 OK 了。

nyagos 类 Unix 终端，但是支持 Windows 格式的路径

    https://github.com/nyaosorg/nyagos

        nyagos增加zoxide的支持 https://wentao.org/post/2023-04-27-zoxide-with-nyagos/

edex-ui 创·战纪 风格的终端模拟器，还带一个简单的文件浏览器，系统资源监视器，虽然基于 Electron 的应用程序比较笨重，但效果太酷了

    https://github.com/GitSquared/edex-ui

    配置文件说明 https://github.com/GitSquared/edex-ui/wiki/settings.json

    自定义主题说明 https://github.com/GitSquared/edex-ui/wiki/Themes

Alacritty 使用 OpenGL 进行显示加速（速度一般）的终端模拟器，在 Linux 下刷新速度快，在 Windows 下使用 powershell 不推荐

    https://github.com/alacritty/alacritty

    主题颜色使用 Nord theme

        curl -fsSL https://github.com/nordtheme/alacritty/raw/main/src/nord.yaml | tee $HOME/.alacritty.toml

WezTerm GPU 加速（其实不快）跨平台终端仿真器，支持终端多路复用，至今未解决偶发的卡顿问题

    https://github.com/wez/wezterm
        https://wezfurlong.org/

cmder 推荐了几个本地终端模拟器，可以嵌入 cmder 代替 ConEmu

    https://github.com/cmderdev/cmder/wiki/Seamless-Terminus-integration

        Tabby（原名Terminus）跨平台的终端模拟器，electron + nodejs 写的，支持终端多路复用，不支持导入 putty 的站点，目前使用sz传输大文件时文件会损坏，老老实实的用 sftp 吧
            https://github.com/Eugeny/tabby
            使用介绍 https://zhuanlan.zhihu.com/p/447977207

    https://github.com/cmderdev/cmder/wiki/Seamless-Hyper-integration

        hyper 基于 xterm.js 和 Electron 实现
            https://hyper.is/

    https://github.com/cmderdev/cmder/wiki/Seamless-FluentTerminal-Integration

        FluentTerminal 基于 xterm.js 的 UWP 应用
            https://github.com/felixse/FluentTerminal

Nushell 既是一种编程语言，也是一种 Shell，执行 `help commands` 查看常用命令。自己的脚本语言可以基于自己的指令定义函数、基于函数定义脚本。可以开发 rust 插件给他扩展功能。

    https://github.com/nushell/nushell
        https://www.nushell.sh/zh-CN/book/thinking_in_nu.html

另见章节 [Linux 桌面下的终端模拟器]。

Supper Putty

    别用了：最新的版本调用 git bash，粘贴脚本文件内容，随机添加字符，在 tmux 下发生的更频繁。

    https://github.com/jimradford/superputty

#### ConEmu 和 Cmder

ConEmu 用配置 Task（任务）的形式，支持标签化窗口使用 cmd, powershell, msys2, bash, putty 等等终端模拟器。不止是个终端多路复用器，他还自己实现了对 cmd 和 unix pty 两种类型的终端模拟。

    https://conemu.github.io/

    console 类似ConEmu的软件
        console2 不更新了2021 https://github.com/cbucher/console
            console 不更新了2013 https://sourceforge.net/projects/console/

ConEmu 最大的缺点是不稳定，反应速度偶尔很慢，估计跟它基于 Windows conhost，连带支持 unix pty 这样包打一切的实现机制有关。

ConEmu 用配置 Task（任务）的形式，支持标签化窗口使用 cmd, powershell, msys2, bash, putty 等等终端模拟器。

ConEmu\ConEmu 目录下集成了几个常用工具

    clink 使 cmd 像 bash 按 tab 键自动完成

    wslbridge 使 mintty 或 ConEmu 可以支持 WSL(Windows Subsystem for Linux)

ConEmu 色彩方案

    https://github.com/joonro/ConEmu-Color-Themes

Cmder 是一个软件包，整合上述几个工具无需安装直接使用的软件包

    https://github.com/cmderdev/cmder

    它整合了：

        本地终端模拟器：Conemu （它是Cmder的基础），可换为别的
            https://zhuanlan.zhihu.com/p/71706782

        clink 使 cmd 像 bash 按tab键自动完成

        git for windows 使用它自带的 unix tools

##### 基本的 ConEmu 任务配置示例

ConEmu 安装时会自动检测当前可用的shell并配置默认的任务列表

    https://conemu.github.io/en/Tasks.html#add-default-tasks

甚至 Windows 下的普通软件都可以嵌套到ConEmu的窗口下

    选择新建任务的选项 'New console dialog'

    在弹出窗口的栏目 'Startup command or {Task} name...'下输入： notepad

    启动该任务会看到新建了一个标签打开了 Windows 的记事本。

可以调用普通的 Windows 程序

如果是调用 putty.exe、mintty.exe、notepad.exe 等 Windows 程序，ConEmu 会利用自己的 ChildGUI 功能，内嵌显示窗体，显示效果完美，但不能使用 ConEmu 的颜色和背景方案 <https://conemu.github.io/en/ChildGui.html>。

对 bash.exe/tmux.exe 等 unix pty 的连接，Conemu 是通过 cmd 实现的，支持 ConEmu 的颜色和背景方案目前的实现方式，显示兼容性并不完美，见 Conemu 安装后生成的默认任务 {Bash::Git bash}。不知何时切换到 Windows 新的 Conpty 接口。

1、关于 ConEmu 安装后自动生成的任务 {Bash::Git bash}

    使用普通的 linux 命令显示效果正常，而且支持 ConEmu 的颜色和背景方案。但如果使用 tmux/zsh 状态栏工具，因为上面所述原因，显示效果有缺陷：在刷新后会出现底部栏重叠，还有光标错位的问题。这种情况下，建议见下面的示例 2。

        set "PATH=%ProgramFiles%\Git\usr\bin;%PATH%" & %ProgramFiles%\Git\git-cmd.exe --no-cd --command=%ConEmuBaseDirShort%\conemu-msys2-64.exe /usr/bin/bash.exe -l -i -new_console:p

    建议用下面的示例2配置原生的 git-bash.exe 任务

2、配置 git-bash 任务

    简单使用，安装 git for Windows，配置任务为直接调用 git-bash.exe，或直接调用 mintty.exe，用参数加载 bash，在 bash 中使用 ssh/tmux 效果是完美的。复杂点的可以安装 MSYS2（MinGW64)工具包，见下面示例 5。

        点击+号，新建一个Task名为 {Bash::git-bash}，命令文本框输入

        set "PATH=%ProgramFiles%\Git\usr\bin;%PATH%" & %ProgramFiles%\Git\git-bash.exe --cd-to-home

        注：git-bash.exe 其实是封装执行 `mintty.exe /bin/bash -l`

3、配置 Anaconda 任务

    点击+号，新建一个Task名为 {cmd::Anaconda}，命令文本框输入

    cmd /k "C:\ProgramData\Anaconda3\Scripts\activate.bat C:\ProgramData\Anaconda3"  -new_console:d:%USERPROFILE%

4、配置 putty 任务

    直接调用 putty.exe

        点击+号，新建一个Task名为 {putty::your_putty_session}，命令文本框输入如下

        C:\tools\PuTTY\putty.exe -load "your_putty_session_name"

        如果不使用参数指定 putty 会话名，任务启动时会自动弹出 putty 的窗口供用户选择

5、ConEmu 配置 MSYS2 任务

    直接调用 mintty.exe，由它调用 shell 程序，这样显示效果由 mintty 决定，等效于上面的示例2。

        C:\msys64\usr\bin\mintty.exe -i /msys2.ico -t "%CONTITLE%" "/usr/bin/zsh" -new_console:C:"%D%\msys2.ico"

        C:\msys64\usr\bin\mintty.exe -i /msys2.ico -t "%CONTITLE%" "/usr/bin/bash -l" -new_console:C:"%D%\msys2.ico"

    直接调用 bash.exe

        显示会光标错行，估计也是因为 ConEmu 通过 cmd 实现对 bash.exe 的连接导致的。

        打开 conemu 的 settings 对话框，选择 Startup>>Tasks 选项
        点击+号，新建一个 Task 名字为 Msys2::MingGW64，在 commands 下文本框内输入如下代码：

            set MSYS2_PATH_TYPE=inherit & set MSYSTEM=mingw64 & set "D=C:\msys64" & %D%\usr\bin\bash.exe --login -i -new_console:C:"%D%\msys2.ico"

        MSYS2_PATH_TYPE=inherit 表示合并 Windows 系统的 path 变量。注意修改变量值 `D=` 为你的msys2的安装目录。

        打开后会自动把工作目录设置为 msys64/home/%user% 下。

#### Windows Terminal

    WIndows Terminal 文档
        https://learn.microsoft.com/zh-cn/windows/terminal/

    Windows Terminal 与 MSYS2 MinGW64 集成
        https://ttys3.dev/post/windows-terminal-msys2-mingw64-setup/

Windows 10 v1809 推出的 ConPTY 接口也支持第三方终端模拟器了，微软版的实现就是 Windows Terminal，同时支持之前 cmd 的 Console API，多标签化窗口同时打开 cmd、powershell、wsl、bash 等多个终端窗口，自动添加当前识别到的 git bash 等 mintty 应用（对 MSYS2 应用通过 ConPty 接口实现的兼容 <https://github.com/msys2/MSYS2-packages/issues/1684>）。

    # https://github.com/microsoft/terminal/releases
    winget install --id=Microsoft.WindowsTerminal -e

直接安装从 github 下载的 .msixbundle 文件，在 powershell 下运行如下命令从文件安装

    Add-AppxPackage .\xxx.msixbundle

如果提示无法安装，缺少框架，下载 github 发布页的那个 xxxx_Windows10_PreinstallKit.zip，解压，先安装 Microsoft.UI.Xaml 和 Microsoft.VCLibs.140 等包。

如果安装后无法正常启动 Windows Terminal，经过一顿操作，终于找到了解决方法，用魔法打败了魔法！

    https://www.cnblogs.com/albelt/p/15253147.html

    要求：

        Windows 10 1903 版本及以上

    步骤：

        到 Windows Terminal 的 Github 仓库下载最新的 release 包，即以 .msixbundle 为后缀的文件

        将文件后缀名改为 .zip 后解压缩文件

        在解压后的文件夹中找到名为 CascadiaPackage***.msix 的文件，有 x86、x64 和 ARM64 版本的，选择 x64 那个文件，修改后缀名为 .zip，然后解压

        在解压后的文件夹中，找到 WindowsTerminal.exe 的文件，直接双击就能运行了，还是绿色免安装版的，是不是很简单？

        可以把这个文件夹拷贝到安全的位置，然后将 .exe 文件添加到桌面快捷方式，就能愉快地使用 Windows Terminal 啦！

##### 配置 Windows Terminal

> 给各个终端生成配置文件

点击按钮“添加新配置文件”，选择基于哪个现有的配置文件进行生成，然后修改启动参数就可以了。

wsl，启动参数

    %SystemRoot%\System32\cmd.exe /c wsl --cd ~

Git Bash，启动参数

    "C:/Program Files/Git/bin/bash.exe" -i -l

复制 Anaconda 的命令行启动参数，在 cmd 使用 anaconda

    %WINDIR%\System32\cmd.exe "/K" %USERPROFILE%\anaconda3\Scripts\activate.bat %USERPROFILE%\anaconda3

如果追求反应速度，使用 cmd 终端(conhost)目前是最快的

    按住回车键不放对比下刷屏速度就知道了

    cmd 利用 ConPTY 可以无缝支持 Linux 程序的显示，兼容性没问题了，我用 cmd 终端运行 git bash 自带的 `ssh` 连接远程服务器、运行 `wsl` 使用 WSL 实例，都非常快，未遇到任何错误。

    而且，可以在 Windows Terminal 中给 cmd 终端可以设置自定义背景和字体，使用起来手感跟 git bash 没有差别了。

> 配置 Windows Terminal 的主题、终端配色方案等

Windows Terminal 有自己的主题，颜色方案背景等配置修改 setting.json。目前版本的 Windows Terminal 可以在用户界面选择设置，如选择背景图片、开启毛玻璃效果、开启复古的像素化终端效果等。

复杂点的设置，比如终端配色方案，需要手动修改配置文件，点击 Windows Terminal 窗口左下方的按钮 “打开json文件” 即可打开文本编辑，配置文件的位置一般在 %USERPROFILE%\AppData\Local\Microsoft\Windows Terminal。

四部分：

    Global Windows Terminal APP 整体的配置，启动参数、样式等，对应下图的 Global Config

    profiles 配置每个终端的样式

    schemes 终端配色方案

    actions 定义快捷键操作，一般默认即可

如果不知道如何配置 setting.json，可以参考 default.json 每一个节点的 key-value 值。主题配置主要是 Global、profiles 和 schemes 节点。

list 段是基本设置

    "list":
    [
        {
            "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
            "hidden": false,
            "name": "PowerShell",
            "source": "Windows.Terminal.PowershellCore",
            "colorScheme":"Zhuang B",
            "fontFace":"Cascadia Code PL",
            // 开启毛玻璃效果
            "useAcrylic":true,
            // 毛玻璃透明度
            "acrylicOpacity":0.5
            // 只要加上这一句，即可开启亮瞎眼的效果。
            "experimental.retroTerminalEffect":true
        }
    ]

schemes 段设置配色方案，同样是一个数组，每种配色方案会有一个名字 name，引用配色方案就是通过 name 的值。默认预设了几种配色方案，可在 default.json 查看

```json

    // 典型的 schemes 格式
    {
        "schemes":[
            {
                "name": "Campbell", // 配色方案名称，必须的
                "foreground": "#CCCCCC", // 输出显示字体颜色
                "background": "#0C0C0C", // 背景色
                "cursorColor": "#FFFFFF", // 光标颜色
                "black": "#0C0C0C", // 箭头左边三角，git 目录的 .git 目录下提示箭头背景提示文字
                "red": "#C50F1F", // ssh 后 vim 打开文本文件已输入行普通字符显示文字
                "green": "#13A10E", // git 目录的 .git 目录下提示箭头背景提示
                "yellow": "#C19C00", // git 目录的分支箭头背景提示
                "blue": "#0037DA", // 目录箭头本体
                "purple": "#881798", // ssh 后 vim 等工具打开文件后的 { 和 }等符号本体，git 更新完后显示的分支箭头背景提示
                "cyan": "#3A96DD", // 引号及内部字符
                "white": "#CCCCCC", // 未知
                "brightBlack": "#767676", // cd 等 命令后面的 .. 和 * 等特殊符号，以及命令参数字符颜色
                "brightRed": "#E74856", // 系统提示字符颜色：错误的命令，git status 显示
                "brightGreen": "#16C60C", // ssh 用户权限显示
                "brightYellow": "#F9F1A5", // 输入的命令字符
                "brightBlue": "#3B78FF", // ssh 文件夹等高亮显示，ssh 目录，vim 打开文本文件未输入行 ~ 字符显示
                "brightPurple": "#B4009E", // 未知
                "brightCyan": "#61D6D6", // ssh vim 等工具打开文件后的 { 和 } 等符号背景
                "brightWhite": "#F2F2F2" // 目录箭头左边和中间的提示文字
            }
        ]
    }

```

自定义 nord 方案，来自章节 [配色方案：整套支持终端模拟器和命令行软件的主题]的三种模式

    https://compiledexperience.com/blog/posts/windows-terminal-nord

```json

    "schemes": [
        {
            "name": "Nord",
            "foreground": "#d8dee9",
            "background": "#2e3440",
            "cursorColor": "#d8dee9",
            "black": "#3b4252",
            "red": "#bf616a",
            "green": "#a3be8c",
            "yellow": "#ebcb8b",
            "blue": "#81a1c1",
            "purple": "#b48ead",
            "cyan": "#88c0d0",
            "white": "#e5e9f0",
            "brightBlack": "#4c566a",
            "brightRed": "#bf616a",
            "brightGreen": "#a3be8c",
            "brightYellow": "#ebcb8b",
            "brightBlue": "#81a1c1",
            "brightPurple": "#b48ead",
            "brightCyan": "#8fbcbb",
            "brightWhite": "#eceff4",
            "selectionBackground": "#FFFFFF"
        },
    ],

```

在如下几个网站别已有的颜色方案

    https://github.com/mbadolato/iTerm2-Color-Schemes

    https://windowsterminalthemes.dev/

    http://terminal.sexy/

#### PowerShell 7+ 命令提示符工具及美化

    https://yqc.im/windows-terminal-using-windows-terminal/

    https://zhuanlan.zhihu.com/p/352882990

Windows 系统自带的 Windows PowerShell 5.x 和下载安装的 PowerShell 7.x 是两个独立的 Shell，注意到 5.x 带有 Windows 前缀，而 7.x 没有。两者的配置也是独立的，互不影响，所以如果你在 7.x 做配置，打开 5.x 并不会生效。

一、先安装独立的 Powershell 7，从这个版本开始不跟随 Windows 发布了

    https://learn.microsoft.com/zh-cn/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3

Powershell 7 有自己的软件包仓库

        https://learn.microsoft.com/zh-cn/powershell/scripting/gallery/overview?view=powershell-7.3

        https://www.powershellgallery.com/packages/

其实使用 PowerShell 最大的问题是

    执行 `ssh` 使用 Windows 自带的 C:\Windows\System32\OpenSSH，版本太老了

    执行 `curl` 等工具被 alias 指向 wsl，也就是说，你得先在 wsl 里装个 Linux。

为了减少疑惑，接下来将统一使用原生的 PowerShell 7.x。

Powershell 优化

    https://www.dejavu.moe/posts/windows-terminal/
    一般我们不用 Azure 相关服务的话，建议禁用 Azure 账户模块

    $env:AZ_ENABLE=$false

PowerShell 美化：

    更改整体配色，改变输出样式，提示符前显示用户名和计算机名等

    增强 Git 命令功能和 Git 分支状态显示

    自动补齐功能，可根据历史命令和当前目录补齐

    ls 命令显示色彩

1、安装图标字体，参见章节 [图标字体]。

也可以用 scoop 安装

    > scoop search FantasqueSansMono-NF
    > scoop bucket add 'nerd-fonts'

    # 下面一个命令要加 sudo 提权
    > sudo scoop install FantasqueSansMono-NF

2、安装 posh-git

posh-git 可以实现命令提示符 Git 命令增强（命令别名和显示分支信息等）。

可以通过 [PowerShell Gallery](https://www.powershellgallery.com) 安装，方法：打开 PowerShell 7（不是 Windows PowerShell），输入命令：

    > Install-Module posh-git

更改命令提示符显示的 oh-my-posh 配置复杂，不玩了

    https://ohmyposh.dev/docs/installation/windows

3、增强 PowerShell 的 ls 功能

dircolors 是 Linux 下的命令，可以设置 ls 指令用彩色显示目录或文件。PowerShell 用插件 DirColors 实现同样的效果。

    # 安装 DirColors
    > Install-Module DirColors

4、使用 ColorTool 更改 PowerShell 文字颜色，这个可以省略

    # 安装更改文字颜色工具
    > scoop install colortool

    # 查看内置的配色方案，共有 8 种
    > colortool --schemes

    # 设置主题，后面是配色方案名称
    > colortool OneHalfDark.itermcolors

5、最后，把配置写入 PowerShell 的配置文件

    # if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force } notepad $PROFILE

    PS C:\Users\your_name> $PROFILE
    C:\Users\your_name\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

    > code $PROFILE

内容见下。

##### PowerShell 7 配置文件样例

```powershell

# 命令行提示符git增强
Import-Module posh-git

# ls 结果使用彩色
Import-Module DirColors

# 设置预测文本来源为历史记录
Set-PSReadLineOption -PredictionSource History

# 设置 Tab 键补全
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# 设置 Ctrl+d 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function MenuComplete

# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

# 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

# 设置向下键为前向搜索历史纪录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# 清除 scoop 缓存和软件旧版本 | 别名: scoopwipe
#function scoopwipe{sudo scoop cleanup -gk * && sudo scoop cleanup * -g && scoop cache rm * && scoop cleanup * && Write-Host "Scoop 缓存清理完成啦~👌" }

# 关联 conda 命令，来自 Ananconda 的开始菜单快捷方式
C:\ProgramData\Anaconda3\shell\condabin\conda-hook.ps1

```
