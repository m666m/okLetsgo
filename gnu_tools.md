# Windows 下的 GNU/POSIX 环境

## 环境方案选择

Windows 10+ 下使用 WSL 开发 GNU 环境设置

    https://github.com/hsab/WSL-config

Windows C++ 开发环境配置

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

相对的 MingW 也有一个叫 MSYS（Minimal SYStem）的子项目，主要是提供了一个模拟 Linux 的 Shell 和一些基本的 Linux 工具。

目前流行的 MSYS2 是 MSYS 的一个升级版，准确的说是集成了 pacman 和 Mingw-w64 的 Cygwin 升级版。

如果你只是想在Windows下使用一些linux小工具，建议用 MSYS2，把 /usr/bin 加进环境变量 path 以后，可以直接在 命令行终端中使用 Linux 命令。

### MinGW

此项目已停止维护。

<https://www.ics.uci.edu/~pattis/common/handouts/mingweclipse/mingw.html>

### MinGW64

MinGW-w64 安装配置单，gcc 是 6.2.0 版本，系统架构是 64位，接口协议是 win32，异常处理模型是 seh，Build revision 是 1 。

简单操作的话，安装开源的 gcc IDE开发环境即可，已经都捆绑了Mingw64。
比如 CodeLite，CodeBlocks，Eclipse CDT，Apache NetBeans（JDK 8）。
收费的有JetBrains Clion，AppCode （mac）。

### MSYS、MSYS2

    https://www.msys2.org/
    https://msys2.github.io/

MinGW 仅仅是工具链，Windows 下的 cmd 使用起来不够方便，MSYS 是用于辅助 Windows 版 MinGW 进行命令行开发的配套软件包：提供了部分 Unix 工具以使得 MinGW 的工具使用起来方便一些。相比基于庞大的 Cygwin 下的 MinGW 会轻巧不少。

MSYS2 是 MSYS 的第二代，有大量预编译的软件包，并且具有包管理器 pacman (ArchLinux)。

目前在windows上使用Linux程序

    如果只是需要一个编译器的话，可以用MinGW64。

    如果使用工具软件居多，还是 Msys2 能应付一切情况，它集合了cygwin、mingw64以及mingw32（不等于老版的那个MinGW），shell、git、多种环境的gcc（适用于cygwin环境或原生Windows），而且有pacman (ArcLinux)作为包管理器。

    Windows 10 在 2021 年后的版本更新中集成的 WSL2 使用比较方便，简单开发使用 WSL2 也可以。

### Windows 10+ 下的 WSL 混合环境

    https://github.com/hsab/WSL-config

## 环境配置

### 简单使用：安装 Git for Windows

GIT Bash 使用了 GNU tools 的 MINGW，但是工具只选择了它自己需要的部分进行了集成，我们主要使用他的 mintty 命令行终端程序和 ssh、gpg 等工具。

下载地址 <https://git-scm.com/download/win>

#### Windows下 的 bash -- mintty

    http://mintty.github.io/
    https://github.com/mintty/mintty/wiki/Tips

安装 git for Windows 或 MSYS2 后就有了，git for Windows下的配置文件在 ~\.minttyrc。

如果安装 MSYS2，则配置文件不同，详见章节[全套使用：安装 MSYS2(Cygwin/Msys)]。

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

git for windows 的 mintty 目录

    / 目录          位于git安装目录下的 C:\Program Files\Git\ 目录下
    /usr 目录       同上
    /tmp 目录       位于 C:\Users\%USERNAME%\AppData\Local\Temp\  目录下

退出bash时，最好不要直接关闭窗口，使用命令exit或^D。

putty的退出也是同样的建议。

##### mintty 美化

如果是 git for Windows 的mintty，修改 ~/.minttyrc 为下面的内容

    # https://mintty.github.io/mintty.1.html
    # https://github.com/mintty/mintty/wiki/Tips#configuring-mintty
    Font=Consolas
    FontHeight=11
    Columns=140
    Rows=40
    AllowBlinking=yes

    # 语言设置
    Language=zh_CN
    # Locale=zh_CN
    # Charset=GBK
    Charset=UTF-8

    # 窗体透明效果，不适用于嵌入多窗口终端工具
    # Transparency=low

    # 为了使用花哨颜色，确保终端设置恰当
    Term=xterm-256color

    FontSmoothing=full
    # FontWeight=700
    # FontIsBold=yes

    # 自定义颜色方案，跟深色背景搭配
    # Background=C:\StartHere\tools\SuperPuTTY\111dark.jpg
    #BackgroundColour=109,69,35
    #ForegroundColour=228,228,228
    #CursorColour=217,230,242
    #
    #Black=0,0,0
    #BoldBlack=36,36,36
    #Red=255,0,0
    #BoldRed=255,0,128
    #Green=51,242,133
    #BoldGreen=22,184,74
    #Yellow=249,237,134
    #BoldYellow=240,197,47
    #Blue=198,159,249
    #BoldBlue=15,118,232
    #Magenta=172,53,101
    #BoldMagenta=249,159,210
    #Cyan=7,254,254
    #BoldCyan=1,220,220
    #White=217,217,217
    #BoldWhite=255,255,255

    # 自定义颜色方案，跟浅色背景搭配-黄色
    # Background=C:\StartHere\tools\SuperPuTTY\222yellow.jpg
    #BackgroundColour=250,234,182
    #ForegroundColour=0,61,121
    #CursorColour=217,230,242
    #
    #Black=0,0,0
    #BoldBlack=72,72,72
    #Red=255,30,18
    #BoldRed=255,84,74
    #Green=82,173,58
    #BoldGreen=65,136,47
    #Yellow=192,175,56
    #BoldYellow=166,150,36
    #Blue=11,80,155
    #BoldBlue=9,58,113
    #Magenta=255,18,243
    #BoldMagenta=255,147,250
    #Cyan=3,201,162
    #BoldCyan=67,214,181
    #White=107,165,186
    #BoldWhite=180,180,180

    # TODO:自定义颜色方案，跟浅色背景搭配-绿色
    # Background=C:\StartHere\tools\SuperPuTTY\333green.jpg
    # Background=C:\StartHere\tools\SuperPuTTY\444blue.jpg

    # https://github.com/mavnn/mintty-colors-solarized/blob/master/.minttyrc.light
    #ForegroundColour=101, 123, 131
    #BackgroundColour=253, 246, 227
    #CursorColour=    220,  50,  47
    #
    #Black=             7,  54,  66
    #BoldBlack=         0,  43,  54
    #Red=             220,  50,  47
    #BoldRed=         203,  75,  22
    #Green=           133, 153,   0
    #BoldGreen=        88, 110, 117
    #Yellow=          181, 137,   0
    #BoldYellow=      101, 123, 131
    #Blue=             38, 139, 210
    #BoldBlue=        131, 148, 150
    #Magenta=         211,  54, 130
    #BoldMagenta=     108, 113, 196
    #Cyan=             42, 161, 152
    #BoldCyan=        147, 161, 161
    #White=           238, 232, 213
    #BoldWhite=       253, 246, 227

    # https://github.com/mavnn/mintty-colors-solarized/blob/master/.minttyrc.dark
    ForegroundColour=131, 148, 150
    BackgroundColour=  0,  43,  54
    CursorColour=    220,  50,  47

    Black=             7,  54,  66
    BoldBlack=         0,  43,  54
    Red=             220,  50,  47
    BoldRed=         203,  75,  22
    Green=           133, 153,   0
    BoldGreen=        88, 110, 117
    Yellow=          181, 137,   0
    BoldYellow=      101, 123, 131
    Blue=             38, 139, 210
    BoldBlue=        131, 148, 150
    Magenta=         211,  54, 130
    BoldMagenta=     108, 113, 196
    Cyan=             42, 161, 152
    BoldCyan=        147, 161, 161
    White=           238, 232, 213
    BoldWhite=       253, 246, 227

    # 使用内置颜色方案，建议放在最下面以覆盖上面的颜色设置
    # ThemeFile=mintty

如果是 MSYS2 的 mintty，可以在<https://github.com/hsab/WSL-config/tree/master/mintty/themes> 找到很多主题，将主题文件保存到 msys64/usr/share/mintty/themes 目录下，通过右键 mintty 窗口标题栏的 option 进行选择。

##### 多终端工具 ConEmu/SuperPutty

SuperPutty 支持putty、mintty、cmd、powershell等多种终端嵌入显示，可导入putty站点，可设置站点关联WinScp/FileZilla等软件的快捷调用，使用简单方便，只要安装了 git for Windows 和 putty 等软件即可直接使用，不需要做复杂的设置。

ConEmu是一个非常好用的终端，支持标签切换功能，可以在conemu中同时打开cmd,powershell,msys2，bash等等。自定义选项多，非常好用。缺点是配置复杂，慢慢研究吧

    https://zhuanlan.zhihu.com/p/99963508
        https://conemu.github.io/

    ConEmu配置Msys2 https://blog.csdn.net/sherpahu/article/details/101903539
    msys2使用conemu终端配置 https://blog.csdn.net/hustlei/article/details/86688160

conemu中设置MSYS2

以MSYS2 MingGW64为例：

> 打开conemu的settings对话框
> 选择Startup>>Tasks选项
> 点击+号，新建一个Task
> 修改Task名字为Msys2::MingGW64
>
> 在commands下文本框内输入如下代码：
>
>     set MSYS2_PATH_TYPE=inherit & set MSYSTEM=mingw64 & set "D=C:\msys64" & %D%\usr\bin\bash.exe --login -i -new_console:C:"%D%\msys2.ico"
>

MSYS2_PATH_TYPE=inherit表示合并windows系统的path变量。注意修改变量值`D=`为你的msys2的安装目录。

如果安装了zsh并想默认使用zsh，可以把代码里的bash改为zsh。

打开后会自动把工作目录设置为msys64/home/%user%下。

### 组合使用：git for Windows + MSYS2

#### 拷贝 MSYS2 的工具到 git 里，这样只使用 git bash(mintty) 就可以了

假设git的安装目录在 D:\Git，可执行文件在 D:\Git\usr\bin\ 目录：

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

#### 共享一套 Home 目录

如果安装了 git for windows ，其 home 目录默认为 %USERPROFILE%，导致 git for windows 和 MSYS2 的 git 配置和 vim 等配置不能共享。

如果在安装 MSYS2 之前已经安装 git for windows 需要使用将之前的 ssh 和 git 的配置拷贝到 MSYS2 的 home 目录下。

在 Windows 上配置环境变量 HOME 为 C:\you-path\msys64\home\your-name，增加这个环境变量的目的是为了让 git for windows 的 home 目录指向 MSYS2 的 home 目录。

### 全套使用：安装 MSYS2(Cygwin/Msys)

参考文章

    MSYS2 和 mintty 打造 Windows 下 Linux 工具体验
        https://creaink.github.io/post/Computer/Windows/win-msys2/

    Windows 下 MSYS2 配置及填坑 https://hustlei.github.io/2018/11/msys2-for-win.html

下载安装 MSYS2

    https://www.msys2.org/
    https://msys2.github.io/

使用pacman安装各种包：

    pacman -S vim openssh git

安装后先pacman更换清华源 <https://mirrors.tuna.tsinghua.edu.cn/help/msys2/> 中科大 <https://mirrors.ustc.edu.cn/help/msys2.html>，在windows下是msys的安装目录下的文件夹 msys64\etc\pacman.d\ 下。

依次添加

    nano 编辑 /etc/pacman.d/mirrorlist.msys ，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/msys/$arch/
        Server = http://mirrors.ustc.edu.cn/msys2/msys/$arch/

    nano 编辑 /etc/pacman.d/mirrorlist.mingw32 ，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/i686/
        Server = http://mirrors.ustc.edu.cn/msys2/mingw/i686/

    nano 编辑 /etc/pacman.d/mirrorlist.mingw64 ，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/x86_64/
        Server = http://mirrors.ustc.edu.cn/msys2/mingw/x86_64/

    nano 编辑 /etc/pacman.d/mirrorlist.ucrt64 ，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/ucrt64/
        Server = http://mirrors.ustc.edu.cn/msys2/mingw/ucrt64/

    nano 编辑 /etc/pacman.d/mirrorlist.clang64 ，在文件开头添加：

        Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/clang64/
        Server = http://mirrors.ustc.edu.cn/msys2/mingw/clang64/

然后Windows执行开始菜单的快捷方式 "MSYS2 MSYS" 以打开命令行，更新软件包数据，之后可以使用 "MSYS2 MinGW X64"，

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

    / 目录          位于msys2的安装目录 msys64\ 下
    /usr 目录       同上
    /tmp 目录       同上
    /home 目录      位于msys2的安装目录 msys64\ 下的 home\%USERNAME%

环境的隔离做的比较好，不会干扰Windows当前用户目录下的配置文件。

NOTE: 如果你的系统中独立安装了如 git for Windows 、 Anaconda for Windows 等，他们使用 C:\Users\%USERNAME% 下的bash、mintty等配置文件，注意区分。

msys2在开始菜单下的好几个版本是因为编译器和链接的windows的c库不同

    LLVM/Clang 和 MINGW(GCC) 是两个不同的 C/C++ 编译器， mingw64、ucrt64、clang64 都是 Windows 原生程序（不依赖 cygwin.dll），不过 mingw64 是很早就有的，后两者是最近才新加的，所以只是选一个用的话就 mingw64 就没问题。

    具体区别是：mingw64 与 ucrt64 都是用 mingw64 编译器编译的 Windows 64位程序，只不过它们链接到的 crt（C runtime）不同， mingw64 是链接到了 msvcrt ，而 ucrt64 则是链接到了 Windows 10+ 上新的 ucrt 上。而 clang64 很好理解，就是用 clang 而非 mingw 来编译各种库，另外它也是链接到了 ucrt 而非 msvcrt。

    引自 <https://www.zhihu.com/question/463666011/answer/1927907983>

    官方解释 <https://www.msys2.org/docs/environments/>

msys2的启动方式都是通过调用 msys2_shell.cmd，不同仅在于传递了变量 set MSYSTEM=xxxx，msys2_shell.cmd启动时，都默认使用mintty虚拟终端。

    # c:\msys64为msys2安装目录，bash为默认shell，可以用zsh,csh等替换
    set MSYSTEM=MINGW64
    "c:\msys64\usr\bin\mintty" "c:\msys64\usr\bin\bash" --login

自己运行Msys2时可以不使用mintty虚拟终端。直接运行如下命令就OK：

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

#### 软件仓库 pacman

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

## Linux下常用工具

### 终端字符编码

变量依赖从大到小的顺序是：LC_ALL, LC_CTYPE, LANG

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

在env设置，如

    LC_CTYPE=zh_CN.gbk; export LC_CTYPE

中文Windows使用ansi gbk编码，设置变量：Locale 、 Charset

    Locale=zh_CN
    Charset=GB18030

### emoji

    字符式输入 https://www.webfx.com/tools/emoji-cheat-sheet/

    unicode编码 http://www.unicode.org/emoji/charts/full-emoji-list.html

### bash命令提示符美化

```shell

# 用于 .bash_profile先加载初始设置
test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc

# Bash开启vi-mode模式
set -o vi

####################################################################
# 命令行提示符显示当前路径和git分支等，放入任一 .profile 或 .bashrc 或 .bash_profile 内

black=$'\[\e[0;30m\]'

red=$'\[\e[0;31m\]'

green=$'\[\e[0;32m\]'

yellow=$'\[\e[0;33m\]'

blue=$'\[\e[0;34m\]'

magenta=$'\[\e[0;35m\]'

cyan=$'\[\e[0;36m\]'

white=$'\[\e[0;37m\]'

normal=$'\[\e[m\]'

# 使用奇怪点的函数名，防止污染shell的脚本命名空间
# 注意判断退出码的函数前面不能执行函数

function PS1exit-code {
    local exitcode=$?
    if [ $exitcode -eq 0 ]; then printf "%s" ''; else printf "%s" ' -'$exitcode' '; fi
}

function PS1conda-env-name {
    # 暂未调试成功
    local envname=$(if [ "$(which conda >/dev/null 2>&1)" = "0" ]; then printf "%s" $(conda env list); fi)
    ((! -z $envname)) && printf " conda:%s" $envname;
}

function PS1git-branch-name {
  git symbolic-ref --short -q HEAD 2>/dev/null
}

function PS1git-branch-prompt {
  local branch=`PS1git-branch-name`
  if [ $branch ]; then
    local git_modify=$(if ! [ -z "$(git status --porcelain)" ]; then printf "%s" '<!>'; else printf "%s" ''; fi)
    printf " git:(%s)" $branch$git_modify;
  fi
}

# bash 命令行提示符显示： \t当前时间 \u用户名 \h主机名 \w当前路径 返回值 git分支及状态
PS1="\n$magenta┌─$red\$(PS1exit-code)$magenta[$white\t $green\u$white@$green\h$white:$cyan\w$magenta]$yellow\$(PS1git-branch-prompt)\n$magenta└──$white\$ $normal"

# git bash 命令行提示符显示： 在\$(函数名)后直接用换行\n就冲突，不支持$?检查退出码，或者把换行\n放在引用函数前面，或者拼接凑合用
#PS1="\n$magenta┌──── $white\t ""$PS1""$magenta───┘ $normal"
# 目前完美解决办法是新增子函数PS1new-line和PS1exitcode实现跟上面完全一致的美化效果。
function PS1new-line {
    printf "\n└"
}

function PS1exitcode {
    local exitcode=$(printf "$?")
    (($exitcode != '0')) && printf "%s" ' -'$exitcode' '
}

PS1="\n$magenta┌─$red\$(PS1exitcode)$magenta[$white\t $green\u$white@$green\h$white:$cyan\w$magenta]$yellow\$(PS1git-branch-prompt)$magenta$(PS1new-line)──$white\$ $normal"

```

### 使用 zsh + ohmyzsh

    https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH

切换zsh
    sudo chsh -s /bin/zsh
    sudo usermod -s /bin/zsh username

进入终端界面后也可以运行：

    if [ -t 1 ]; then
    exec zsh
    fi

如果是初次运行zsh，有个引导程序设置zsh读取的配置文 ~/.zshrc 文件，也可以手动调用

    autoload -Uz zsh-newuser-install

    zsh-newuser-install -f

如果之前使用bash，在 ~/.zshrc 文件中加上`source ~/.bash_profile`，可以继承 bash的配置文件 ~/.bash_profile 内容。

#### 超多插件和主题的 ohmyzsh

    https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#overriding-and-adding-themes

    内置主题 https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
    更多的主题 https://github.com/ohmyzsh/ohmyzsh/wiki/External-themes
                https://github.com/unixorn/awesome-zsh-plugins

内置主题bira，添加时间字段修改`RPROMPT="[%*]%B${return_code}%b"`
![bira](https://user-images.githubusercontent.com/49100982/108254762-7a77a480-716c-11eb-8665-b4f459fd8920.jpg)

额外主题 [Bullet train](https://github.com/caiogondim/bullet-train.zsh)，修改主机名字段颜色`BULLETTRAIN_CONTEXT_BG=magenta`
![Bullet train](https://camo.githubusercontent.com/3ce1f2e157549ff5ce549af57e3e635b4b85c5919c48223d7e963e98c2613e2e/687474703a2f2f7261772e6769746875622e636f6d2f6361696f676f6e64696d2f62756c6c65742d747261696e2d6f682d6d792d7a73682d7468656d652f6d61737465722f696d672f707265766965772e676966)

额外主题 [powerlevel10k](https://github.com/romkatv/powerlevel10k)，可以运行`p10k configure`设置使用习惯，![powerlevel10k](https://camo.githubusercontent.com/80ec23fda88d2f445906a3502690f22827336736/687474703a2f2f692e696d6775722e636f6d2f777942565a51792e676966)

安装目前是从github下载

    # sh -c "$(curl -fsSL
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

安装依赖

    # 有些插件和主题依赖 python 和 git
    # 详见章节 [Debian/Ubuntu 如何安装自己版本的python和pip] <python.md>

    # https://github.com/zsh-users/antigen/wiki/Installation
    sudo apt install zsh-antigen

    # https://github.com/caiogondim/bullet-train.zsh
    sudo apt install fonts-powerline
    sudo apt install ttf-ancient-fonts

定制主题文件位置

    $ZSH_CUSTOM
    └── themes
        └── my_awesome_theme.zsh-theme

### Vim powerline

安装说明

    https://askubuntu.com/questions/283908/how-can-i-install-and-use-powerline-plugin

    https://powerline.readthedocs.io/en/latest/installation.html

命令行安装

    # https://powerline.readthedocs.io/en/latest/installation.html
    # pip install powerline-status 这个是python2的一堆坑
    # pip3 install --user git+https://github.com/powerline/powerline
    # 这个最方便，自带的安装到 /usr/share/powerline/
    sudo apt install powerline

还得弄个自定义路径

    # Add ~/.local/bin to $PATH by modifying ~/.profile
    if [ -d "$HOME/.local/bin" ]; then
        PATH="$HOME/.local/bin:$PATH"
    fi

绑定各软件

先查看你安装的位置，找到bindings目录，用apt 安装的在 /usr/share/powerline/bindings/

~/.vimrc or /etc/vim/vimrc

    set rtp+=/usr/share/powerline/bindings/vim/

    " Always show statusline
    set laststatus=2

    " Use 256 colours (Use this setting only if your terminal supports 256 colours)
    set t_Co=256

### Vim 解决汉字乱码

如果你的 Vim 打开汉字出现乱码的话，那么在家目录(~)下，新建.vimrc文件

    vim ~/.vimrc

添加内容如下：

    ini
    set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
    set enc=utf8
    set fencs=utf8,gbk,gb2312,gb18030

保存退出后执行下环境变量

    source .vimrc

### tmux 不怕断连的多窗口命令行

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

### Aria2 下载工具

命令行传输各种参数，设置复杂，Windows下下载开源的GUI程序 [Motrix](https://github.com/agalwood/Motrix) 即可，该软件最大的优点是自动更新最佳dht站点清单。

    aria2c.exe --conf-path=C:\tools\Motrix\resources\engine\aria2.conf --save-session=C:\Users\XXXX\AppData\Roaming\Motrix\download.session --input-file=C:\Users\XXXX\AppData\Roaming\Motrix\download.session --allow-overwrite=false --auto-file-renaming=true --bt-load-saved-metadata=true --bt-save-metadata=true --bt-tracker=udp://93.158.213.92:1337/announce,udp://151.80.120.115:2810/announce,udp://45.154.253.8:6969/announce,http://45.154.253.8:80/announce,udp://51.81.46.170:6969/announce,udp://91.216.110.52:451/announce,udp://185.181.60.155:80/announce,udp://208.83.20.20:6969/announce,udp://149.202.88.193:80/announce,udp://5.79.251.251:6969/announce,udp://5.161.62.40:6969/announce,udp://217.30.10.52:6969/announce,udp://149.28.47.87:1738/announce,udp://163.172.209.40:80/announce,udp://156.234.201.18:80/announce,udp://62.210.217.207:1337/announce,udp://209.141.59.16:6969/announce,udp://106.14.254.164:6969/announce,udp://tracker.opentrackr.org:1337/announce,udp://9.rarbg.com:2810/announce,udp://tracker.openbittorrent.com:6969/announce,http://tracker.openbittorrent.com:80/announce,udp://opentracker.i2p.rocks:6969/announce,https://opentracker.i2p.rocks:443/announce,udp://www.torrent.eu.org:451/announce,udp://tracker.torrent.eu.org:451/announce,udp://open.stealth.si:80/announce,udp://exodus.desync.com:6969/announce,udp://ipv4.tracker.harry.lu:80/announce,udp://tracker.tiny-vps.com:6969/announce,udp://tracker.moeking.me:6969/announce,udp://tracker.dler.org:6969/announce,udp://vibe.sleepyinternetfun.xyz:1738/announce,udp://tracker2.dler.org:80/announce,udp://tracker1.bt.moack.co.kr:80/announce,udp://tracker.zerobytes.xyz:1337/announce,udp://tracker.theoks.net:6969/announce,udp://tracker.skyts.net:6969/announce --continue=true --dht-file-path=C:\Users\XXXX\AppData\Roaming\Motrix\dht.dat --dht-file-path6=C:\Users\XXXX\AppData\Roaming\Motrix\dht6.dat --dht-listen-port=26701 --dir=C:\Users\XXXX\Downloads --listen-port=21301 --max-concurrent-downloads=5 --max-connection-per-server=64 --max-download-limit=0 --max-overall-download-limit=0 --max-overall-upload-limit=256K --min-split-size=1M --pause=true --rpc-listen-port=16800 --rpc-secret=evhiORlwDiah --seed-ratio=1 --seed-time=60 --split=64 --user-agent=Transmission/2.94

### cmatrix 字符屏保

    https://magiclen.org/cmatrix/
        https://github.com/abishekvashok/cmatrix

+ Debian / Ubuntu

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

### sha256文件完整性校验

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

Windows 自带工具，支持校验MD5 SHA1 SHA256类型文件，cmd调出命令行

    certutil -hashfile  <文件名>  <hash类型>

如

    certutil -hashfile cn_windows_7.iso MD5
    certutil -hashfile cn_windows_7.iso SHA1
    certutil -hashfile cn_windows_7.iso SHA256

## 网络故障排查

    # 端口是否可用
    telnet 192.168.0.1:3389

    netstat -an

    ping -t 192.168.0.1

    tracert www.bing.com

    traceroute

    $ nslookup baidu.com
    Non-authoritative answer:
    Server:  192.168.0.1
    Address:  192.168.0.1

    Name:    baidu.com
    Addresses:  220.181.38.148
            220.181.38.251


    whois

## rsync 文件同步

用于备份，重复的同步文件或目录，支持远程机器。

    http://c.biancheng.net/view/6121.html

rsync 有 5 种不同的工作模式：

    rsync [OPTION] SRC DEST

    rsync [OPTION] SRC [USER@]HOST:DEST

    rsync [OPTION] [USER@]HOST:SRC DEST

    rsync [OPTION] [USER@]HOST::SRC DEST

    rsync [OPTION] SRC [USER@]HOST::DEST

第一种用于仅在本地备份数据；

第二种用于将本地数据备份到远程机器上；

第三种用于将远程机器上的数据备份到本地机器上；

第四种和第三种是相对的，同样第五种和第二种是相对的，它们各自之间的区别在于登陆认证时使用的验证方式不同。
在 rsync 命令中，如果使用单个冒号（:），则默认使用 ssh 协议；反之，如果使用两个冒号（::），则使用 rsync 协议。ssh 协议和 rsync 协议的区别在于，rsync 协议在使用时需要额外配置，增加了工作量，但优势是更加安全；反之，ssh 协议使用方便，无需进行配置，但有泄漏服务器密码的风险。

rsync 命令提供使用的 OPTION 及功能

    OPTION选项    功能

    -a    这是归档模式，表示以递归方式传输文件，并保持所有属性，它等同于-r、-l、-p、-t、-g、-o、-D 选项。-a 选项后面可以跟一个 --no-OPTION，表示关闭 -r、-l、-p、-t、-g、-o、-D 中的某一个，比如-a --no-l 等同于 -r、-p、-t、-g、-o、-D 选项。

    -r    表示以递归模式处理子目录，它主要是针对目录来说的，如果单独传一个文件不需要加 -r 选项，但是传输目录时必须加。

    -v    表示打印一些信息，比如文件列表、文件数量等。

    -l    表示保留软链接，默认不处理软链接文件。

    -L    表示像对待常规文件一样处理软链接。如果是 SRC 中有软链接文件，则加上该选项后，将会把软链接指向的目标文件复制到 DEST，默认不处理软链接文件。

    -p    表示保持文件权限。

    -o    表示保持文件属主信息。

    -g    表示保持文件属组信息。

    -D    表示保持设备文件信息。

    -t    表示保持文件时间信息。

    --delete    表示删除 DEST 中 SRC 没有的文件，即多次备份时会删除源中已经删除的文件，默认会保留。

    --exclude=PATTERN    表示指定排除不需要传输的文件，等号后面跟文件名，可以是通配符模式（如 *.txt）。

    --progress    表示在同步的过程中可以看到同步的过程状态，比如统计要同步的文件数量、 同步的文件传输速度等。

    -u    表示把 DEST 中比 SRC 还新的文件排除掉，不会覆盖。
    -z    加上该选项，将会在传输过程中压缩。

以上也仅是列出了 async 命令常用的一些选项，对于初学者来说，记住最常用的几个即可，比如 -a、-v、-z、--delete 和 --exclude。

使用示例

    # 把 test1 目录中的内容直接放到 test2 目录中
    rsync -v -a test1/ test2/

    # 把 test1目录拷贝到到新建的 test2 目录中
    rsync -v -a test1 test2

## crontab 定时任务

    https://www.cnblogs.com/pengdonglin137/p/3625018.html
    https://www.cnblogs.com/utopia68/p/12221769.html
    https://blog.csdn.net/zhubin215130/article/details/43271835
    https://segmentfault.com/a/1190000020850932

坑一：环境变量是单独的

cron中的环境变量很多都和系统环境变量不一样（cron会忽略/etc/environment文件），尤其是PATH，只有/usr/bin:/bin，也就是说在cron中运行shell命令，如果不是全路径，只能运行/usr/bin或/bin这两个目录中的标准命令，而像/usr/sbin、/usr/local/bin等目录中的非标准命令是不能运行的。

## acme.sh 自动申请免费ssl证书

    https://blog.csdn.net/dancen/article/details/121044863

官网：

    Github: https://github.com/acmesh-official/acme.sh

    Wiki: https://github.com/acmesh-official/acme.sh/wiki

acme.sh用于生成免费的ssl证书，其完整实现了acme协议，并且由纯Shell脚本语言编写，没有过多的依赖项，安装和使用都非常方便。

1.支持的CA

    ZeroSSL.com CA(default)：90天 默认，切换别的见[切换CA]
    Letsencrypt.org CA：90天
    BuyPass.com CA：180天
    SSL.com CA
    Pebble strict Mode
    Any other RFC8555-compliant CA

2.支持的运行模式

    Webroot mode
    Standalone mode
    Standalone tls-alpn mode
    Apache mode
    Nginx mode
    DNS mode
    DNS alias mode
    Stateless mode

### 一. 安装

1.在线安装

直接通过curl下载安装脚本并自动执行：

    curl https://get.acme.sh | sh -s email=my@example.com

或者使用wget：

    wget -O -  https://get.acme.sh | sh -s email=my@example.com

如果acme.sh使用zeroSSL CA，则这里的-s参数指定的邮箱可以关联到已有的zeroSSL账号。关联成功后，通过acme.sh生成的zeroSSL证书会在zeroSSL网站的控制面板上显示

2.或者通过git安装

    git clone https://github.com/acmesh-official/acme.sh.git

    cd ./acme.sh

    ./acme.sh --install -m my@example.com

3.安装操作做了哪些修改

    a. 部署acme.sh程序到用户文件夹 ($HOME): ~/.acme.sh/ 目录下，root用户是 /root/.acme.sh/  目录下

    其核心脚本文件为：($HOME): ~/.acme.sh/acme.sh。

    b. 为脚本执行文件创建别名 acme.sh=~/.acme.sh/acme.sh

    注意，别名需要重启终端后才能生效。

    c. 创建一个每日执行的cron任务，用于自动更新即将过期的证书。

    示例，通过crontab -l命令查看证书更新任务计划：

        0 0 * * * "/home/user/.acme.sh"/acme.sh --cron --home "/home/user/.acme.sh" > /dev/null

    如果是root用户：

        40 0 * * * "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" > /dev/null

    在该计划任务下，当证书剩余有效期不足30天时，证书将会被自动更新。

    更高级的安装选项请参考: <https://github.com/Neilpang/acme.sh/wiki/How-to-install>

    安装过程不会污染已有的系统任何功能和文件, 所有的修改都限制在安装目录中: ~/.acme.sh/

    4.查看帮助信息 `acme.sh -h`

    5.卸载后，cron计划任务也会被移除：`acme.sh --uninstall`

### 二. 生成证书

以域名example.com为例，生成的证书将放置在以下目录：~/.acme.sh/example.com/

该目录之下是证书、私钥等文件以及一些其它配置文件：

    证书文件: example.com.cer

    私钥: example.com.key

    中间证书: ca.cer

    证书链:fullchain.cer

1.切换CA

当前acme.sh使用的默认CA机构为zeroSSL，通过--set-default-ca命令，可以修改默认的CA机构，该命令使用--server参数来指定CA机构名称。

切换默认CA为Let's Encrypt：

    acme.sh --set-default-ca --server letsencrypt

更换默认CA为ZeroSSL：

    acme.sh --set-default-ca --server zerossl

2.webroot模式

webroot模式要求在服务器上已经运行了http服务，并且可以通过公网访问，该模式的好处是，你无需在申请证书的过程中停止web服务，因此，该模式也是推荐使用的模式。

使用webroot模式申请证书时，acme.sh会在网站对应域名的webroot目录下生成域名验证文件, 然后通过公网访问之，以验证对域名的所有权。验证完毕后，acme.sh会清除这些临时生成的文件。

申请证书使用--issue命令：

    acme.sh --issue -d example.com -d test.com -w /home/webroot

略

3.nginx webroot模式

如果服务器上运行的http服务为nginx，并且当前系统用户具有修改nginx配置的权限，则可以通过nginx模式生成证书。

通过--nginx参数使用nginx模式：

    acme.sh --issue --nginx -d example.com -d www.example.com

该命令相比于webroot模式增加了--nginx参数，同时省略了-w参数。该命令会自动修改nginx配置并重新加载之以适配域名的验证要求，所以无需-w参数。另外，acme.sh会在域名验证完毕后自动将nginx配置还原，因此，nginx配置最终并没有被修改。

特殊的情况是acme.sh可能无法识别nginx配置文件所在位置，此时，可以明确指定：

    acme.sh --issue -d example.com --nginx /etc/nginx/nginx.conf

4.standalone模式

如果服务器的tcp 80端口空闲可用，则可通过standalone模式生成证书。该模式下，acme.sh 自己运行一个webserver, 临时监听在80 端口, 完成验证：

    acme.sh --issue --standalone -d example.com -d www.example.com

如果服务器已经占用了80端口，可以通过--httpport参数使用80以外的端口：

    acme.sh --issue --standalone -d example.com -d www.example.com --httpport 88

需要指出的是，standalone模式下，acme.sh会自己运行一个webserver，依赖的是socat，需要提前安装：

    yum install socat

5.standalone ssl模式

这是另一个standalone模式，使用了ssl，要求服务器的tcp 443端口空闲可用：

    acme.sh --issue --alpn -d example.com -d www.example.com

可以通过--tlsport参数使用443以外的端口：

    acme.sh --issue --alpn -d example.com -d www.example.com --tlsport 8443

6.DNS手动模式

webroot模式和standalone模式可以统称为http模式，即证书验证服务器通过http协议下载acme.sh客户端在域名指向的服务器上生成的验证文件来验证域名所有权。

在某些情况下，我们可能无法使用http模式，例如：

    没有域名所指向的服务器的管理权限。

    域名使用了CDN并设置了多个源站：由于验证文件只会在其中一个源站上生成，验证服务器将不能确保能够下载到验证文件。

此时，我们可以使用更加传统的DNS模式来生成证书，DNS模式要求用户在指定域名上设置指定的TXT记录值，已验证其对域名的所有权。

略

7.DNS自动模式

DNS自动模式可以使用域名解析商提供的api自动为域名添加txt记录以完成域名所有权验证，不同于DNS手动模式，DNS自动模式支持自动更新证书。

acme.sh目前支持cloudflare，dnspod，aliyun，cloudxns，godaddy以及ovh等数十种解析商的自动集成。

8.生成ECC证书

目前大部分的证书都是使用RSA非对称加密算法，但一些CA，例如letsencryption、zerossl等，已经支持颁发性能更加优良的ECC非对称加密算法证书。

通过—keylength参数申请ECC证书：

    acme.sh --issue -w /home/webroot -d example.com -d example1.com --keylength ec-256

--keylength参数指定算法，ec-256表示256位的ecc非对称加密算法，可选的值有：

    ec-256 (prime256v1, "ECDSA P-256")

    ec-384 (secp384r1, "ECDSA P-384")

    ec-521 (secp521r1, "ECDSA P-521", which is not supported by Let's Encrypt yet.)

9.生成泛域名证书

泛域名证书的生成只适用于DNS验证的方式：

    acme.sh --issue -d example.com -d '*.example.com' --dns dns_cf

10.强制生成证书

如果想在当前证书剩余有效期在30天以上时重新生成证书，需要使用--force参数。

    acme.sh --issue --nginx -d example.com -d www.example.com --force

### 三. 更新证书

默认情况下acme.sh会自动更新即将过期的证书，手动执行更新的方式如下：

    acme.sh --renew -d example.com

如果是ecc证书：

    acme.sh --renew -d example.com --ecc

    acme.sh只会更新有效期不足30天的证书，如果想强制更新，则增加—force参数：

    acme.sh --renew -d example.com --force --ecc

停止更新证书：

    acme.sh --remove -d example.com [--ecc]

该命令执行之后，指定的证书不会再自动更新，但对应的证书文件并不会被从硬盘上删除。

### 四. 部署证书

当acme.sh生成证书后，不宜直接将web服务器的证书路径指向证书的生成路径：

    ~/.acme.sh/[domain]

因为该目录仅供acme.sh内部使用，有可能被修改。正确的做法是将证书文件拷贝至另外的目录。

1.直接拷贝

可以直接通过拷贝命令直接拷贝证书文件，对应修改web服务器配置即可。

2.也可以通过--install-cert命令部署

通过acme.sh的--install-cert命令来拷贝证书，并令web服务重新加载配置，需要注意的是，--install-cert命令并不会去修改web服务器的配置，因此，需要提前修改web服务器配置，将证书以及私钥路径指向部署路径，以nginx为例：

    acme.sh --install-cert -d example.com \
    --key-file       /path/to/keyfile/in/nginx/key.pem  \
    --fullchain-file /path/to/fullchain/nginx/cert.pem \
    --reloadcmd     "service nginx force-reload"

--reloadcmd参数用于重新加载nginx配置。一个小提醒，这里用的是service nginx force-reload，不是service nginx reload。据测试，nginx的reload信号能够重新加载配置，但并不会重新加载证书，所以需要使用force-reload。nginx实际上没有force-reload这一信号，force-reload的实质为stop，然后start，即重启nginx。

示例：

    acme.sh --install-cert -d example.com \
    --key-file /etc/nginx/ssl/example.com.key \
    --fullchain-file /etc/nginx/ssl/example.com.fullchain.cer \
    --reloadcmd  "/usr/sbin/nginx -s stop && /usr/sbin/nginx"

在示例中，由于nginx没有注册为service，因此直接使用了nginx的停止和启动命令来重启nginx。

需要补充的是，这里指定的参数，包括证书拷贝的目的地，web服务器的重启命令等，都会被acme.sh自动记录下来，存储到对应证书的配置文件中。以证书example.com为例，存储路径为： ~/.acme.sh/example.com/example.com.conf 并且，在将来证书自动更新以后, --install-cert命令将被再次自动调用，以免去手动拷贝证书，以及重导web服务器配置的操作。

### 五. 查看证书列表

查看已经生成的证书：

    acme.sh --list

### 六. 更新acme.sh

手动更新：

    acme.sh --upgrade

开启自动更新：

    acme.sh --upgrade --auto-upgrade

关闭自动更新：

    acme.sh --upgrade --auto-upgrade 0

### 七. 查看acme.sh报错

如果运行acme.sh出错，可开启debug或者log。

查看debug：

    acme.sh  --issue  .....  --debug

查看error：

    acme.sh  --issue  .....  --debug  2

生成日志：

    acme.sh  --issue  .....  --log

日志文件路径为：~/.acme.sh/acme.sh.log
