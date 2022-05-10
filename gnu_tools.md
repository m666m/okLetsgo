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

## 网络故障排查

    # 端口是否可用
    telnet 192.168.0.1:3389

    netstat -an

    ping -t 192.168.0.1

    tracert www.bing.com

## crontab

    https://www.cnblogs.com/pengdonglin137/p/3625018.html
    https://www.cnblogs.com/utopia68/p/12221769.html
    https://blog.csdn.net/zhubin215130/article/details/43271835
    https://segmentfault.com/a/1190000020850932

坑一：环境变量是单独的

cron中的环境变量很多都和系统环境变量不一样（cron会忽略/etc/environment文件），尤其是PATH，只有/usr/bin:/bin，也就是说在cron中运行shell命令，如果不是全路径，只能运行/usr/bin或/bin这两个目录中的标准命令，而像/usr/sbin、/usr/local/bin等目录中的非标准命令是不能运行的。

## Linux下常用工具

### Aria2 下载工具

命令行传输各种参数，设置复杂，Windows下下载开源的GUI程序 [Motrix](https://github.com/agalwood/Motrix) 即可，该软件最大的优点是自动更新最佳dht站点清单。

    aria2c.exe --conf-path=C:\tools\Motrix\resources\engine\aria2.conf --save-session=C:\Users\ThinkRight\AppData\Roaming\Motrix\download.session --input-file=C:\Users\ThinkRight\AppData\Roaming\Motrix\download.session --allow-overwrite=false --auto-file-renaming=true --bt-load-saved-metadata=true --bt-save-metadata=true --bt-tracker=udp://93.158.213.92:1337/announce,udp://151.80.120.115:2810/announce,udp://45.154.253.8:6969/announce,http://45.154.253.8:80/announce,udp://51.81.46.170:6969/announce,udp://91.216.110.52:451/announce,udp://185.181.60.155:80/announce,udp://208.83.20.20:6969/announce,udp://149.202.88.193:80/announce,udp://5.79.251.251:6969/announce,udp://5.161.62.40:6969/announce,udp://217.30.10.52:6969/announce,udp://149.28.47.87:1738/announce,udp://163.172.209.40:80/announce,udp://156.234.201.18:80/announce,udp://62.210.217.207:1337/announce,udp://209.141.59.16:6969/announce,udp://106.14.254.164:6969/announce,udp://tracker.opentrackr.org:1337/announce,udp://9.rarbg.com:2810/announce,udp://tracker.openbittorrent.com:6969/announce,http://tracker.openbittorrent.com:80/announce,udp://opentracker.i2p.rocks:6969/announce,https://opentracker.i2p.rocks:443/announce,udp://www.torrent.eu.org:451/announce,udp://tracker.torrent.eu.org:451/announce,udp://open.stealth.si:80/announce,udp://exodus.desync.com:6969/announce,udp://ipv4.tracker.harry.lu:80/announce,udp://tracker.tiny-vps.com:6969/announce,udp://tracker.moeking.me:6969/announce,udp://tracker.dler.org:6969/announce,udp://vibe.sleepyinternetfun.xyz:1738/announce,udp://tracker2.dler.org:80/announce,udp://tracker1.bt.moack.co.kr:80/announce,udp://tracker.zerobytes.xyz:1337/announce,udp://tracker.theoks.net:6969/announce,udp://tracker.skyts.net:6969/announce --continue=true --dht-file-path=C:\Users\ThinkRight\AppData\Roaming\Motrix\dht.dat --dht-file-path6=C:\Users\ThinkRight\AppData\Roaming\Motrix\dht6.dat --dht-listen-port=26701 --dir=C:\Users\ThinkRight\Downloads --listen-port=21301 --max-concurrent-downloads=5 --max-connection-per-server=64 --max-download-limit=0 --max-overall-download-limit=0 --max-overall-upload-limit=256K --min-split-size=1M --pause=true --rpc-listen-port=16800 --rpc-secret=evhiORlwDiah --seed-ratio=1 --seed-time=60 --split=64 --user-agent=Transmission/2.94

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

### Windows下 的 bash -- mintty

安装git后就有了，windows下的配置文件 ~\.minttyrc

    Background=C:\Users\xxxx\Pictures\1111111111.jpg
    Font=Consolas
    FontHeight=11
    Columns=200
    Rows=60
    # 如果嫌默认的白色不够纯就改
    ForegroundColour=255,255,255
    # mintty界面的显示语言，zh_CN是中文，Language=@跟随Windows
    Language=@
    # 终端语言设置选项，在 Windows 10 下好像都不需要设置，下面的是 Windows 7 下的，是否因为操作系统默认编码是 ANSI ？
    # https://www.cnblogs.com/LCcnblogs/p/6208110.html
    # bash下设置，这个变量设置区域，影响语言、词汇、日期格式等
    Locale=zh_CN  # bash 下显示中文
    Charset=GBK  # ls列windows目录名可以显示中文，但tail等命令显示中文utf-8文件需要设为UTF-8，此时中文目录名就不正常显示了，原因是中文版windows是ANSI而不是UTF
    # LANG 只影响字符的显示语言
    LANG=zh_CN.UTF-8  # win7下显示utf-8文件内容, 可先执行命令“locale” 查看ssh所在服务器是否支持

如果在 SuperPutty 下使用，需要添加额外的启动参数 "/bin/bash --login -i"。

mintty 下的 /tmp 目录位于 C:\Users\ThinkRight\AppData\Local\Temp。

退出bash时，最好不要直接关闭窗口，使用命令exit或^D。

putty的退出也是同样的建议。

### 解决 Vim 汉字乱码

如果你的 Vim 打开汉字出现乱码的话，那么在家目录(~)下，新建.vimrc文件

    vim ~/.vimrc

添加内容如下：

    ini
    set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
    set enc=utf8
    set fencs=utf8,gbk,gb2312,gb18030

保存退出后执行下环境变量

    source .vimrc

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

## sha256文件完整性校验

Windows 自带工具，支持校验MD5 SHA1 SHA256类型文件，cmd调出命令行

    certutil -hashfile  <文件名>  <hash类型>

如

    certutil -hashfile cn_windows_7.iso MD5
    certutil -hashfile cn_windows_7.iso SHA1
    certutil -hashfile cn_windows_7.iso SHA256

Linux

每个算法都是单独的程序 md5sum sha1sum sha256sum sha512sum，直接带文件名操作即可。

    # 生成sha256校验文件
    $ sha256sum file > file.sha256

    # 生成多个文件的sha256校验
    $ sha256sum a.txt b.txt > checksums.sha256
    $ more checksums.sha256
    17e682f060b5f8e47ea04c5c4855908b0a5ad612022260fe50e11ecb0cc0ab76  a.txt
    3cf9a1a81f6bdeaf08a343c1e1c73e89cf44c06ac2427a892382cae825e7c9c1  b.txt

    # 根据校验和文件进行校验
    $ sha256sum -c checksums.sha256
    a.txt: OK
    b.txt: OK

    # 抽出单个文件进行校验
    sha256sum -c <(grep ubuntu-20.04.4-desktop-amd64.iso SHA256SUMS.txt)

使用 OpenSSL 验证

    # 主要用于数据摘要，可指定各种算法查看 openssl dgst -list
    $ openssl dgst -sha256 Release.unsigned
    SHA256(Release.unsigned)= f6edd059408744b50edc911111111113eeef30dc5fea0

    # 跟校验和文件比对数值
    $ grep f6edd059408744b50edc911111111113eeef30dc5fea0 *dgst
    SHA256= f6edd059408744b50edc911111111113eeef30dc5fea0

## GNU POSIX环境开发

windows c++环境配置：
g++7.0 + git + cmake
code::block / vscode
库 toft + chrome + leveldb + folly + zeromq

<https://zhuanlan.zhihu.com/p/56572298>

### MGW 和 Cygwin 的实现思路

#### MingW 在编译时对二进制代码转译

MingW (gcc 编译到mscrt)包含gcc和一系列工具，是Windows下的gnu环境。

编译 linux c++ 源代码，生成 Windows 下的exe程序，全部使用从 KERNEL32 导出的标准 Windows 系统 API，相比Cygwin体积更小，使用更方便。

如 创建进程， Windows 用 CreateProcess() ，而 Linux 使用 fork()：修改编译器，让 Window 下的编译器把诸如 fork() 的调用翻译成等价的mscrt CreateProcess()形式。

#### Cygwin 在编译时中间加了个翻译层 cygwin1.dll

Cygwin 生成的程序依然有 fork() 这样的 Linux 系统调用，但目标库是 cygwin1.dll。

Cygwin（POSIX接口转换后操作windows）在Windows中增加了一个中间层——兼容POSIX的模拟层，在此基础上构建了大量Linux-like的软件工具，由此提供了一个完整的 POSIX Linux 环境（以 GNU 工具为代表），模拟层对linux c++代码的接口如同 UNIX 一样， 对Windows由 win32 的 API 实现的cygwin1.dll，这就是 Cygwin 的做法。

Cygwin实现，不是 kvm 虚拟机环境，也不是 QEMU 那种运行时模拟，它提供的是程序编译时的模拟层环境：exe调用通过它的中间层dll转换为对windows操作系统的调用。

借助它不仅可以在 Windows 平台上使用 GCC 编译器，理论上可以在编译后运行 Linux 平台上所有的程序：GNU、UNIX、Linux软件的c++源代码几乎不用修改就可以在Cygwin环境中编译构建，从而在windows环境下运行。

对于Windows开发者，程序代码既可以调用Win32 API，又可以调用Cygwin API，甚至混合，借助Cygwin的交叉编译构建环境，Windows版的代码改动很少就可以编译后运行在Linux下。

用 MingW 编译的程序性能会高一点，而且也不用带着那个接近两兆的 cygwin1.dll 文件。
但 Cygwin 对 Linux 的模拟比较完整，甚至有一个 Cygwin X 的项目，可以直接用 Cygwin 跑 X。

另外 Cygwin 可以设置 -mno-cygwin 的 flag，来使用 MingW 编译。

#### 取舍：选 MSYS2

如果仅需要在 Windows 平台上使用 GCC，可以使用 MinGW 或者 Cygwin。

如果还有更高的需求（例如运行 POSIX 应用程序），就只能选择安装 Cygwin。

相对的 MingW 也有一个叫 MSYS（Minimal SYStem）的子项目，主要是提供了一个模拟 Linux 的 Shell 和一些基本的 Linux 工具，目前流行的 MSYS2 是 MSYS 的一个升级版，准确的说是集成了 pacman 和 Mingw-w64 的 Cygwin 升级版。把 /usr/bin 加进环境变量 path 以后，可以直接在 cmd 中使用 Linux 命令。

如果你只是想在Windows下使用一些linux小工具，建议用 MSYS2 就可以了。

### MinGW

此项目已停止维护。

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

### MinGW64

MinGW-w64 安装配置单，gcc 是 6.2.0 版本，系统架构是 64位，接口协议是 win32，异常处理模型是 seh，Build revision 是 1 。

简单操作的话，安装开源的 gcc IDE开发环境即可，已经都捆绑了Mingw。
比如 CodeLite，CodeBlocks，Eclipse CDT，Apache NetBeans（JDK 8）。
收费的有JetBrains Clion，AppCode （mac）。

### MSYS2(Cygwin Msys)

如果只是需要一个编译器的话，可以用MinGW64。不过总体来说还是 Msys2 能应付一切情况，它集合了cygwin、mingw64以及mingw32（不等于老版的那个MinGW），shell、git、多种环境的gcc（适用于cygwin环境或原生Windows），而且有pacman (ArcLinux)作为包管理器。

下载 <https://www.msys2.org/>

安装后先pacman更换清华源 <https://mirrors.tuna.tsinghua.edu.cn/help/msys2/> 中科大 <https://mirrors.ustc.edu.cn/help/msys2.html>，在windows下是msys的安装目录下的文件夹 msys64\etc\pacman.d\ 下。

依次添加

    编辑 /etc/pacman.d/mirrorlist.msys ，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/msys/$arch/
        Server = http://mirrors.ustc.edu.cn/msys2/msys/$arch/

    编辑 /etc/pacman.d/mirrorlist.mingw32 ，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/i686/
        Server = http://mirrors.ustc.edu.cn/msys2/mingw/i686/

    编辑 /etc/pacman.d/mirrorlist.mingw64 ，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/x86_64/
        Server = http://mirrors.ustc.edu.cn/msys2/mingw/x86_64/

    编辑 /etc/pacman.d/mirrorlist.ucrt64 ，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/ucrt64/
        Server = http://mirrors.ustc.edu.cn/msys2/mingw/ucrt64/

    编辑 /etc/pacman.d/mirrorlist.clang64 ，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/clang64/
        Server = http://mirrors.ustc.edu.cn/msys2/mingw/clang64/

然后Windows执行开始菜单的快捷方式 MSYS2 MSYS 以打开命令行，更新软件包数据（之后可以使用 MSYS2 MinGW X64）

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

该软件安装后，使用的Linux目录结构跟Windows目录的对应关系

    / 目录位于msys2的安装目录 msys64\
    /home 目录对应 msys64\home\%USERNAME%
    /tmp 目录对应 C:\Users\%USERNAME%\AppData\Local\Temp

环境的隔离做的比较好，不会干扰Windows当前用户目录下的配置文件。

如果你的系统中独立安装了如 git for Windows 、 Anaconda for Windows 等，他们使用 C:\Users\%USERNAME% 下的bash、mintty等配置文件，注意区分。

安装时的提示

    './.bashrc' -> '/home/%USERNAME%/.bashrc'
    './.bash_logout' -> '/home/%USERNAME%/.bash_logout'
    './.bash_profile' -> '/home/%USERNAME%/.bash_profile'
    './.inputrc' -> '/home/%USERNAME%/.inputrc'
    './.profile' -> '/home/%USERNAME%/.profile'
    'C:\Windows\system32\drivers\etc\hosts' -> '/etc/hosts'
    'C:\Windows\system32\drivers\etc\protocol' -> '/etc/protocols'
    'C:\Windows\system32\drivers\etc\services' -> '/etc/services'
    'C:\Windows\system32\drivers\etc\networks' -> '/etc/networks'

msys2在开始菜单下的好几个版本是因为编译器和链接的windows的c库不同

    官方解释 <https://www.msys2.org/docs/environments/>

    clang 和 mingw(gcc) 是两个不同的 C/C++ 编译器， mingw64、ucrt64、clang64 都是 Windows 原生程序（不依赖 cygwin.dll），不过 mingw64 是很早就有的，后两者是最近才新加的，所以只是选一个用的话就 mingw64 就没问题。

    具体区别是：mingw64 与 ucrt64 都是用 mingw64 编译器编译的 Windows 64位程序，只不过它们链接到的 crt（C runtime）不同， mingw64 是链接到了 msvcrt ，而 ucrt64 则是链接到了 Windows 10+ 上新的 ucrt 上。而 clang64 很好理解，就是用 clang 而非 mingw 来编译各种库，另外它也是链接到了 ucrt 而非 msvcrt。

    引自 <https://www.zhihu.com/question/463666011/answer/1927907983>

基于 Arch Linux 的 pacman 提供软件仓库，采用滚动升级模式，初始安装仅提供命令行环境：用户不需要删除大量不需要的软件包，而是可以从官方软件仓库成千上万的高质量软件包中进行选择，搭建自己的系统。

pacman命令较多，作为新手，将个人最常用的命令总结如下：

    pacman -Sy :更新软件包数据
    pacman -Su :更新核心软件包
    # pacman -Syu: 升级系统及所有已经安装的软件。
    pacman -S 软件名: 安装软件。也可以同时安装多个包，只需以空格分隔包名即可。
    pacman -Rs 软件名: 删除软件，同时删除本机上只有该软件依赖的软件。
    pacman -Ru 软件名: 删除软件，同时删除不再被任何软件所需要的依赖。
    pacman -Ssq 关键字: 在仓库中搜索含关键字的软件包，并用简洁方式显示。
    pacman -Qs 关键字: 搜索已安装的软件包。
    pacman -Qi 软件名: 查看某个软件包信息，显示软件简介,构架,依赖,大小等详细信息。
    pacman -Sg: 列出软件仓库上所有的软件包组。
    pacman -Sg 软件包组: 查看某软件包组所包含的所有软件包。
    pacman -Sc：清理未安装的包文件，包文件位于 /var/cache/pacman/pkg/ 目录。
    pacman -Scc：清理所有的缓存文件。
