# 常用GNU环境的使用

## windows下配置GNU环境

### 1.安装 Git for Windows

GIT Bash 使用了GNU tools 的 MINGW，但是工具只选择了它自己需要的几个。
我们主要使用他的 mintty.exe 命令行终端程序和 ssh.exe 工具

下载地址 <https://git-scm.com/download/win>

### 2.安装 msys2，安装它下面的工具

You can install the whole distribution of the tools from <https://www.msys2.org/>
安装好后，选择安装需要的工具，如tmux：
    pacman -S tmux

### 3.拷贝 msys2 下面的工具到 git 下

假设git的安装目录在 D:\Git，可执行文件放在 D:\Git\usr\bin\ 下：

以tmux.exe为例：
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

## Linux下常用工具

### tmux

开启tmux后，一个session管理多个window，每个window都有一个shell。
任意的非tmux shell可以attach到你的session。
只要不主动退出session和重启，都可以通过attach的方式回到你的操作界面。

#### 安装

1.操作系统仓库安装

redhat、centos 或 fedora:
    yum install tmux

ubuntu:
    apt-get install tmux

mac os:
    brew install tmux

2.源代码编译安装

    git clone https://github.com/tmux/tmux.git
    cd tmux
    sh autogen.sh
    ./configure && make

#### 常用命令

这些命令在tmn的:命令行模式一样可以使用

    tmux
        创建一个会话，并连接

    tmux new -s roclinux
        创建一个全新的 tmux 会话 叫作 roclinux

    tmux new-session -s username -d
        创建一个全新的 tmux 会话 ，开机脚本(Service等）中调度也不会关闭
        https://stackoverflow.com/questions/25207909/tmux-open-terminal-failed-not-a-terminal

    tmux ls
        列出当前的会话（tmux session），下面表示0号有2个窗口
            0: 2 windows (created Tue Apr 13 17:28:34 2021)

    tmux a -t 3
        进入tmux，连接到3号会话

    tmux a -t mydevelop
        进入tmux，连接到名为 mydevelop 的会话

    tmux kill-session -t mydevelop
        不用的会话可能有很多窗口，挨个退出很麻烦，直接杀掉会话，mydevelop 是要杀掉的会话名称

    tmux rename -t old_session_name new_session_name
        重命名会话

#### 快捷键

会话（Session）
tmux可以有多个会话，每个会话里可以有多个窗口，每个窗口又可以拆分成多个面板，在窗口中各种排列。

组合键 ctrl+b 作为前导，松开后再按其它键如下

    ?       显示所有快捷键，使用pgup和pgdown翻页，按q退出(其实是在vim里显示的，命令用vim的)

    :       进入命令行模式，可输入命c令如：
                show-options -g  # 显示所有选项设置的参数，使用pgup和pgdown翻页，按q退出
                set-option -g display-time 5000 # 提示信息的持续时间；设置足够的时间以避免看不清提示，单位为毫秒

    s       列出当前会话，
            下面表示0号会话有2个窗口，是当前连接，1号会话有1个窗口
                (0) + 0: 2 windows (attached)
                (1) + 1: 1 windows

    $       重命名当前会话；这样便于识别

    [       查看历史输出（默认只显示一屏），使用pgup和pgdown翻页，按q退出

    d       脱离当前会话返回Shell界面，tmux里面的所有session继续运行，
            会话里面的程序不会退出在后台保持继续运行，
            如果操作系统突然断连，也是一样的效果，
            下次运行tmux attach 能够重新进入之前的会话

如果在shell中执行exit，退出的顺序如下：
    先退出当前面板，返回到当前窗口的下一个面板，
    如果没有面板可用，则退出当前窗口，返回到当前会话的下一个窗口的某个面板，
    所有窗口退出时，当前的seesion就会被关闭并退出tmux，其他session继续运行。

    x       关闭当前面板，并自动切换到下一个，
            操作之后会给出是否关闭的提示，按y确认即关闭。
            等同于当前的unix shell下Ctrl+d或输入exit命令。

    &       关闭当前窗口， 并自动切换到下一个，
            操作之后会给出是否关闭的提示，按y确认即关闭。
            等同于当前所有面板的unix shell下Ctrl+d或输入exit命令。

面板（pane）
窗口可以拆分为面板，默认情况下在一个窗口中只有一个面板，占满整个窗口区域。

    "       在当前窗口新建面板，向下拆分
    %       在当前窗口新建面板，向右拆分
    空格     当前窗口的多个面板在各种布局间切换
    o       选择下一面板
    方向键   在相邻两个面板中切换
    {       当前面板与上一个面板交换位置
    }       当前面板与下一个面板交换位置
    !       将当前面板拆分为一个独立窗口
    z       当前面板全屏显示，再使用一次会变回原来大小
    q       显示面板编号
    Ctrl+方向键     以1个单元格为单位移动边缘以调整当前面板大小
    Alt+方向键      以5个单元格为单位移动边缘以调整当前面板大小

窗口（Window）

    c       创建新窗口，状态栏显示窗口编号
    w       列出当前会话的所有窗口，通过上、下键切换
    数字0-9  切换到指定窗口
    n       切换到下一个窗口
    p       切换到上一个窗口
    ,       重命名当前窗口；这样便于识别
    .       修改当前窗口编号；相当于窗口重新排序

#### 配置文件

~/.tmux.conf

    set-option -g history-limit 20000
    set-window-option -g utf8 on # 开启窗口的UTF-8支持
    # 把前导键从 ctrl+b 改成 ctrl+g， M-a是Alt+a
    set-option -g prefix C-g unbind-key C-b bind-key C-g send-prefix

    # https://github.com/hongwenjun/tmux_for_windows
    setw -g mouse
    set-option -g mouse on
    bind -n WheelUpPane select-pane -t= ; copy-mode -e ; send-keys -M
    bind -n WheelDownPane select-pane -t= ; send-keys -M

### cmatrix 字符屏保

<https://magiclen.org/cmatrix/>

+ Ubuntu

        sudo apt install cmatrix

        cmatrix -ba

        Ctrl + c 或 q 退出

+ Centos
    <https://thornelabs.net/posts/linux-install-cmatrix-from-rpm-deb-xz-or-source.html>

    下载源代码

        git clone https://github.com/abishekvashok/cmatrix

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

## GNU POSIX环境开发

windows c++环境配置：
g++7.0 + git + cmake
code::block / vscode
库 toft + chrome + leveldb + folly + zeromq

<https://zhuanlan.zhihu.com/p/56572298>

MingW (gcc 编译到mscrt)包含gcc和一系列工具，是windows下的gnu环境，
编译linux c++代码生成的exe程序，全部使用从 KERNEL32 导出的标准 Windows 系统 API，相比Cygwin体积更小，使用更方便。

如 创建进程， Windows 用 CreateProcess() ，而 Linux 使用 fork()：
修改编译器，让 Window 下的编译器把诸如 fork() 的调用翻译成等价的mscrt CreateProcess()形式，这就是 MingW 的做法。
Cygwin 生成的程序依然有 fork() 这样的 Linux 系统调用，但目标库是 cygwin1.dll。
这样看来用 MingW 编译的程序性能会高一点，而且也不用带着那个接近两兆的 cygwin1.dll 文件。
但 Cygwin 对 Linux 的模拟比较完整，甚至有一个 Cygwin X 的项目，可以直接用 Cygwin 跑 X。
另外 Cygwin 可以设置 -mno-cygwin 的 flag，来使用 MingW 编译。

对linux c++代码的接口如同 UNIX 一样， 对windows由 win32 的 API 实现的cygwin1.dll，这就是 Cygwin 的做法。
Cygwin（POSIX接口转换后操作windows）在Windows中增加了一个中间层——兼容POSIX的模拟层，
在此基础上构建了大量Linux-like的软件工具，由此提供了一个完整的 POSIX Linux 环境（以 GNU 工具为代表），
注意不是虚拟机那种运行时环境，它提供的是程序编译时的模拟层环境，exe调用通过它的中间层dll转换为对windows操作系统的调用。
借助它不仅可以在 Windows 平台上使用 GCC 编译器，理论上可以在编译后运行 Linux 平台上所有的程序：
GNU、UNIX、Linux软件的c++源代码几乎不用修改就可以在Cygwin环境中编译构建，从而在windows环境下运行。

对于Windows开发者，程序代码既可以调用Win32 API，又可以调用Cygwin API，甚至混合，
借助Cygwin的交叉编译构建环境，windows版的代码改动很少就可以编译后运行在Linux下。

如果仅需要在 Windows 平台上使用 GCC，可以使用 MinGW 或者 Cygwin；
如果还有更高的需求（例如运行 POSIX 应用程序），就只能选择安装 Cygwin。

相对的 MingW 也有一个叫 MSys（Minimal SYStem）的子项目，主要是提供了一个模拟 Linux 的 Shell 和一些基本的 Linux 工具.

MSYS2 是MSYS的一个升级版,准确的说是集成了pacman和Mingw-w64的Cygwin升级版。
把/usr/bin加进环境变量path以后，可以直接在cmd中使用Linux命令。

### Mingw

简单操作的话，安装开源的 gcc IDE开发环境即可，已经都捆绑了mingw。
比如 CodeLite，CodeBlocks，Eclipse CDT，Apache NetBeans（JDK 8）。
收费的有JetBrains Clion，AppCode （mac）。

<https://www.ics.uci.edu/~pattis/common/handouts/mingweclipse/mingw.html>

1.run setup.exe
Ensure on the left that Basic Setup is highlighted. Click the three boxes indicated below:

    mingw32-base,
    mingw32-gcc=g++,
    msys-base.

After clicking each, select Mark for selection.

Terminate (click X on) the MinGW Installation Manager (I know this is weird).

2.The following pop-up window should appear,Click Review Change

3.The following pop-up window should appear,Click Apply.

4.The following pop-up window will appear, showing the downloading progress.
 After a while (a few minutes to an hour, depending on your download speed), it should start extracting the donwloaded files.

5.A few minutes after that, the following pop-up window should appear,Click Close.

6.Edit Path
Enviroment Variables...In the System variables (lower) part, scroll to line starting with Path and click that line.

    C:\MinGW\bin;C:\MinGW\msys\1.0\bin;

paste it at the very start of the Variable Value text entry.

Click OK (3 times).

### Mingw-w64

MinGW-w64 安装配置单，gcc 是 6.2.0 版本，系统架构是 64位，接口协议是 win32，异常处理模型是 seh，Build revision 是 1 。

### Cygwin Msys Msys2
