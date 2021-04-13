# 常用GNU环境的使用

## windows下配置GNU环境

### 安装 Git for Windows

GIT Bash uses MINGW compilation of GNU tools.
but it uses only selected ones.
主要使用他的 mintty.exe 命令行终端程序和 ssh.exe 工具

下载地址 <https://git-scm.com/download/win>

### 安装 msys2，安装它下面的工具

You can install the whole distribution of the tools from <https://www.msys2.org/>
    pacman -S tmux

### 拷贝 msys2 下面的工具到 git

假设git的安装目录在 D:\Git

可执行文件放在 D:\Git\usr\bin\ 下：
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

tmux ls
    列出当前的会话（tmux session），下面表示0号有2个窗口
        0: 2 windows (created Tue Apr 13 17:28:34 2021)

tmux a -t 3
    进入tmux，连接到3号会话

tmux a -t mydevelop
    进入tmux，连接到会话名为 mydevelop

tmux kill-session -t mydevelop
    不用的会话可能有很多窗口，挨个退出很麻烦，直接杀掉会话，mydevelop 是要杀掉的会话名称

tmux rename -t old_session_name new_session_name
    重命名会话

#### 快捷键

组合键ctrl+b 作为前导，松开后再按其它键如下

?       显示所有快捷键，使用pgup和pgdown翻页，按q退出(其实是在vim里显示的，命令用vim的)

:       进入命令行模式，可输入命c令如：
            show-options -g  # 显示所有选项设置的参数，使用pgup和pgdown翻页，按q退出
            set-option -g display-time 5000 # 提示信息的持续时间；设置足够的时间以避免看不清提示，单位为毫秒
            # 把前导键从 ctrl+b 改成 ctrl+g， M-a是Alt+a
            set-option -g prefix C-g unbind-key C-b bind-key C-g send-prefix

s       列出当前会话，
        下面表示0号会话有2个窗口，是当前连接，1号会话有1个窗口
            (0) + 0: 2 windows (attached)
            (1) + 1: 1 windows

$       重命名当前会话；这样便于识别

[       查看历史输出（默认只显示一屏），使用pgup和pgdown翻页，按q退出

窗口（Window）可以拆分为面板（pane），默认情况下在一个window中，只有一个大窗格，占满整个窗口区域。
"       新建面板，向下拆分
%       新建面板，向右拆分
空格     在上述两种布局间切换
o       选择下一面板
方向键   在相邻两个面板中切换
{       当前面板与上一个面板交换位置
}       当前面板与下一个面板交换位置
!       将当前面板拆分为一个独立窗口。
z       当前面板全屏显示，再使用一次会变回原来大小。
q       显示面板编号
Ctrl+方向键     以1个单元格为单位移动边缘以调整当前面板大小
Alt+方向键      以5个单元格为单位移动边缘以调整当前面板大小

c       创建新窗口，状态栏显示窗口编号
w       列出当前会话的所有窗口，通过上、下键切换
数字0-9  切换到指定窗口
n       切换到下一个窗口
p       切换到上一个窗口
,       重命名当前窗口；这样便于识别
.       修改当前窗口编号；相当于窗口重新排序

d       脱离当前会话返回Shell界面，tmux里面的所有session继续运行，
        会话里面的程序不会退出在后台保持继续运行，
        如果操作系统突然断连，也是一样的效果，
        下次运行tmux attach 能够重新进入之前的会话

最后一个窗口退出时，当前的tmux seesion就会被关闭。
x       关闭当前面板，并自动切换到下一个，
        操作之后会给出是否关闭的提示，按y确认即关闭。
        等同于当前的unix shell下Ctrl+d或输入exit命令。
&       关闭当前窗口， 并自动切换到下一个，
        操作之后会给出是否关闭的提示，按y确认即关闭。
        等同于当前所有面板的unix shell下Ctrl+d或输入exit命令。

#### 配置文件

~/.tmux.conf

    # https://github.com/hongwenjun/tmux_for_windows
    setw -g mouse
    set-option -g history-limit 20000
    set-option -g mouse off

### cmatrix 字符屏保

<https://magiclen.org/cmatrix/>

Ubuntu
    sudo apt install cmatrix

    cmatrix -ba

    Ctrl + c 或 q 退出

Centos
    sudo yum install cmatrix