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

### mintty(bash)

安装git后就有了，windows下的配置文件 ~\.minttyrc

    Background=C:\Users\xxxx\Pictures\1111111111.jpg
    Font=Consolas
    FontHeight=11
    Columns=200
    Rows=60
    # 如果嫌默认的白色不够纯就改
    ForegroundColour=255,255,255
    # 语言设置选项，在 Windows 10 下好像都不需要设置，下面的是 Windows 7 下的，是否因为操作系统默认编码是 ANSI ？
    LANG=zh_CN.UTF-8  # win7下显示utf-8文件内容, 可先执行 local -a 查看ssh所在服务器是否支持
    Language=zh_CN  # cmd 下中文
    # bash下设置
    Locale=zh_CN  # bash 下中文
    Charset=GBK  # ls列windows目录名可以显示中文，但tail等显示中文utf-8文件需要设为UTF-8，此时中文目录名就不正常显示了，原因是中文版windows是ANSI而不是UTF

如果在 SuperPutty 下使用，需要添加额外的启动参数 "/bin/bash --login -i"

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

    # 根据校验和文件进行校验
    $ sha256sum -c file.sha256

    # 同时校验多个文件
    $ echo aaa > a
    $ echo bbb > b
    $ sha256sum a b > c.sha256

    $ more c.sha256
    17e682f060b5f8e47ea04c5c4855908b0a5ad612022260fe50e11ecb0cc0ab76  a
    3cf9a1a81f6bdeaf08a343c1e1c73e89cf44c06ac2427a892382cae825e7c9c1  b

    $ sha256sum -c c.sha256
    a: OK
    b: OK

## 使用 GPG 验证asc文件

<https://cloud.tencent.com/developer/article/1531457>
<http://c.biancheng.net/view/4832.html>

简单的话，gpg随着git已经安装了。单独下载 GPG：访问 <http://www.gnupg.org/download>，下载适合自己操作系统平台的安装程序。

安装完成后，打开 CMD 窗口，输入 gpg --version ，出现信息表示安装成功。

在使用 GPG 之前，先要准备一个密钥对，即一个私钥，一个公钥。这样才能使用私钥对文件进行签名，将公钥分发到公钥服务器供其他用户下载，其他用户就可以使用公钥对签名进行验证。

### 生成密钥对

注意：命令输出的密钥信息都是简化的密钥指纹的形式来进行显示，操作中引用密钥指纹来指代密钥。

在 CMD 命令行中，输入命令生成密钥对：

    # 不要用 gpg --gen-key， 简化了有些默认值不足。
    gpg --full-generate-key

### 给文件创建签名文件

打开 CMD 命令行窗口，切换到 your.file 文件所在的目录。输入：

    gpg -ab your.file

再输入前面生成密钥时输入的私钥密码 ，会在当前目录下生成一个名叫 your.file.asc 的签名文件。

### 分发公钥文件

为了让用户能方便地获取公钥文件，对下载的文件进行验证，需要将公钥文件发布到公共的公钥服务器上，
如 hkp://pgp.mit.edu 是美国麻省理工学院提供的公钥服务器。

打开 CMD 命令行窗口，将目录切换到公钥文件所在的目录，输入如下命令将公钥文件分发到公钥服务器。

    gpg  --send-keys DDAAB5A8 --keyserver hkp://pgp.mit.edu

“hkp://pgp.mit.edu”是公钥服务器名称。DDAAB5A8 是要发布的公钥 id（前面生成的密钥对中的公钥）。

显示如下信息，表示发布成功。
gpg: sending key DDAAB5A8 to hkp server pgp.mit.edu

有一点需要说明的是，只需往一台服务器上发布公钥就行，其他公钥服务器会自动同步。

### 导入公钥服务器上的公钥

为了验证下载的文件是否准确，需要先从公钥服务器上下载对应的公钥，导入本地 GPG 服务器中，才能使用 GPG 完成对下载文件的验证。

下载 DDAAB5A8 对应的公钥，在 CMD 命令行窗口中输入:

    gpg --recv-keys DDAAB5A8 --keyserver hkp://pgp.mit.edu

注：因为本地已经有这个公钥，所有下载后提示没有改变。

### 使用公钥验证 your.file 文件

打开 CMD 命令行窗口，切换到下载文件所在的目录（原始文件和签名文件），输入命令如下：

    gpg --verify your.file.asc

到现在为止，已经完成了 GPG 的安装、签名、分发和验证的流程。

### 示例：验证ubuntu服务器上下载的iso安装包文件

<https://developer.aliyun.com/article/85793>

登陆 <http://releases.ubuntu.com/20.04/> 下载2个文件，分别是 SHA256SUMS.txt 和 SHA256SUMS.gpg。

第一个文件是 ISO 镜像的 SHA256 验校文件，而第二个文件（*.gpg）是验校文件的签名。第二个文件的目的是验证验校文件本身的有效性。只有这两个文件保真，后续对下载的iso文件进行完整性验证才能保证准确性。

#### 1、验证SHA256SUMS.txt

运行命令

    $ gpg --verify SHA256SUMS.gpg SHA256SUMS.txt
    gpg: Signature made 2022年02月25日  4:36:20
    gpg:                using RSA key 843938DF228D22F7B3742BC0D94AA3F0EFE21092
    gpg: Can't check signature: No public key

如果你得到上面的错误信息，是因为你还没有导入生成这个签名的公共密钥。因此我们现在导入需要的公钥。

#### 2、导入需要的公钥

这样做之前，你需要知道公共密钥的 “key ID”，而这在上面的 gpg 命令的输出中有显示。在这个例子中，密钥 ID 时 “843938DF228D22F7B3742BC0D94AA3F0EFE21092”。

运行下面的命令来从官方 Ubuntu 密钥服务器导入公共密钥。

    $ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 843938DF228D22F7B3742BC0D94AA3F0EFE21092
    gpg: key D94AA3F0EFE21092: public key "Ubuntu CD Image Automatic Signing Key (2012) <cdimage@ubuntu.com>" imported
    gpg: Total number processed: 1
    gpg:               imported: 1

#### 3、验证指纹

导入后会给一个key ID，验证下指纹，需要跟网站上发布的（如果有）比对完全一致才可以。

    $ gpg --fingerprint D94AA3F0EFE21092
    pub   rsa4096 2012-05-11 [SC]
        8439 38DF 228D 22F7 B374  2BC0 D94A A3F0 EFE2 1092
    uid           [ unknown] Ubuntu CD Image Automatic Signing Key (2012) <cdimage@ubuntu.com>

#### 4、再次验证SHA256SUMS.txt

既然公共密钥已经被导入，我们可以继续并重新运行之前的命令来验证签名。

    $ gpg --verify SHA256SUMS.gpg SHA256SUMS.txt
    gpg: Signature made 2022年02月25日  4:36:20
    gpg:                using RSA key 843938DF228D22F7B3742BC0D94AA3F0EFE21092
    gpg: Good signature from "Ubuntu CD Image Automatic Signing Key (2012) <cdimage@ubuntu.com>" [unknown]
    gpg: WARNING: This key is not certified with a trusted signature!
    gpg:          There is no indication that the signature belongs to the owner.
    Primary key fingerprint: 8439 38DF 228D 22F7 B374  2BC0 D94A A3F0 EFE2 1092

这次你没有看到 “public key not found” 的错误信息。如果 SHA256SUMS.txt 文件是有效的，你会看到 “Good signature from ” 的信息。如果错误，需要检查你的网络下载的为何不能保真，是否网络错误过多，或登陆了仿造网站。

注意到警告信息“This key is not certified with a trusted signature” 。基本上这个警告信息是告诉你对导入的公共密钥没有明确信任。只有指定完全信任导入的公共密钥才不会出这个警告。一般使用中，我们不会对外来的公钥选择完全信任，所以忽略这个警告即可。

#### 5、验证下载iso文件完整性

在验证了 SHA256SUMS.txt 文件的完整性后，最后一个步骤是校验和比对，生成 iso 文件的 SHA256 验校和，跟SHA256SUMS.txt 文件中保存的该文件的验校和进行比对，如果完全一致，则认为该iso文件是完整的。 先下载 <http://releases.ubuntu.com/20.04/ubuntu-20.04.4-desktop-amd64.iso>，然后在该iso文件的目录下，用命令行执行：

你可以使用 sha256sum 命令行工具

    sha256sum ubuntu-20.04.4-desktop-amd64.iso

肉眼查看输出结果是否与 SHA256SUMS.txt 文件中的内容一致。

为方便起见，下面一行命令比较 SHA256 验校和并报告结果。

    $ sha256sum -c <(grep ubuntu-20.04.4-desktop-amd64.iso SHA256SUMS.txt)
    ubuntu-14.10-desktop-amd64.iso: OK

如果你看到了上面的输出信息，这表明两个验校值相匹配。这样已下载 ISO 镜像的完整性就被成功的验证了。

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

Cygwin实现，不是虚拟机那种运行时环境，它提供的是程序编译时的模拟层环境：exe调用通过它的中间层dll转换为对windows操作系统的调用。

借助它不仅可以在 Windows 平台上使用 GCC 编译器，理论上可以在编译后运行 Linux 平台上所有的程序：GNU、UNIX、Linux软件的c++源代码几乎不用修改就可以在Cygwin环境中编译构建，从而在windows环境下运行。

对于Windows开发者，程序代码既可以调用Win32 API，又可以调用Cygwin API，甚至混合，借助Cygwin的交叉编译构建环境，Windows版的代码改动很少就可以编译后运行在Linux下。

用 MingW 编译的程序性能会高一点，而且也不用带着那个接近两兆的 cygwin1.dll 文件。
但 Cygwin 对 Linux 的模拟比较完整，甚至有一个 Cygwin X 的项目，可以直接用 Cygwin 跑 X。
另外 Cygwin 可以设置 -mno-cygwin 的 flag，来使用 MingW 编译。

#### 取舍

如果仅需要在 Windows 平台上使用 GCC，可以使用 MinGW 或者 Cygwin。

如果还有更高的需求（例如运行 POSIX 应用程序），就只能选择安装 Cygwin。

相对的 MingW 也有一个叫 MSYS（Minimal SYStem）的子项目，主要是提供了一个模拟 Linux 的 Shell 和一些基本的 Linux 工具，目前流行的 MSYS2 是 MSYS 的一个升级版，准确的说是集成了 pacman 和 Mingw-w64 的 Cygwin 升级版。把 /usr/bin 加进环境变量 path 以后，可以直接在 cmd 中使用 Linux 命令。

如果你只是想在Windows下使用一些linux小工具，建议用MSYS2就可以了。

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
