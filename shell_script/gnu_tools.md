# GNU/Linux 常用工具

    各种linux帮助手册速查 https://manned.org/

    Linux 命令速查 https://linux.die.net/man/

## Windows 下的 GNU/POSIX 环境

### 环境方案选择

Windows 10+ 下使用 WSL 开发 GNU 环境设置

    https://github.com/hsab/WSL-config

Windows C++ 开发环境配置

    g++ 7.0 + git + cmake

    code::block / vscode / SourceInsight(WinSCP 同步本地和编译机代码，或 BeyondCompare 合并)

    tmux + vim 直接在编译机写代码，方便随时ssh上去复原现场继续。

    静态代码分析工具除了 SourceInsight，就是 [Understand](https://www.scitools.com/)，王者没有之一。
        https://blog.csdn.net/jojozym/article/details/104722107

    库 toft + chrome + leveldb + folly + zeromq

<https://zhuanlan.zhihu.com/p/56572298>

#### MGW 和 Cygwin 的实现思路

##### MingW 在编译时对二进制代码转译

MingW (gcc 编译到mscrt)包含gcc和一系列工具，是Windows下的gnu环境。

编译 linux c++ 源代码，生成 Windows 下的exe程序，全部使用从 KERNEL32 导出的标准 Windows 系统 API，相比Cygwin体积更小，使用更方便。

如 创建进程， Windows 用 CreateProcess() ，而 Linux 使用 fork()：修改编译器，让 Window 下的编译器把诸如 fork() 的调用翻译成等价的mscrt CreateProcess()形式。

##### Cygwin 在编译时中间加了个翻译层 cygwin1.dll

Cygwin 生成的程序依然有 fork() 这样的 Linux 系统调用，但目标库是 cygwin1.dll。

Cygwin（POSIX接口转换后操作windows）在Windows中增加了一个中间层——兼容POSIX的模拟层，在此基础上构建了大量Linux-like的软件工具，由此提供了一个完整的 POSIX Linux 环境（以 GNU 工具为代表），模拟层对linux c++代码的接口如同 UNIX 一样， 对Windows由 win32 的 API 实现的cygwin1.dll，这就是 Cygwin 的做法。

Cygwin实现，不是 kvm 虚拟机环境，也不是 QEMU 那种运行时模拟，它提供的是程序编译时的模拟层环境：exe调用通过它的中间层dll转换为对windows操作系统的调用。

借助它不仅可以在 Windows 平台上使用 GCC 编译器，理论上可以在编译后运行 Linux 平台上所有的程序：GNU、UNIX、Linux软件的c++源代码几乎不用修改就可以在Cygwin环境中编译构建，从而在windows环境下运行。

对于Windows开发者，程序代码既可以调用Win32 API，又可以调用Cygwin API，甚至混合，借助Cygwin的交叉编译构建环境，Windows版的代码改动很少就可以编译后运行在Linux下。

用 MingW 编译的程序性能会高一点，而且也不用带着那个接近两兆的 cygwin1.dll 文件。
但 Cygwin 对 Linux 的模拟比较完整，甚至有一个 Cygwin X 的项目，可以直接用 Cygwin 跑 X。

另外 Cygwin 可以设置 -mno-cygwin 的 flag，来使用 MingW 编译。

##### 取舍：选 MSYS2

如果仅需要在 Windows 平台上使用 GCC，可以使用 MinGW 或者 Cygwin。

如果还有更高的需求（例如运行 POSIX 应用程序），就只能选择安装 Cygwin。

相对的 MingW 也有一个叫 MSYS（Minimal SYStem）的子项目，主要是提供了一个模拟 Linux 的 Shell 和一些基本的 Linux 工具。

目前流行的 MSYS2 是 MSYS 的一个升级版，准确的说是集成了 pacman 和 Mingw-w64 的 Cygwin 升级版。

如果你只是想在Windows下使用一些linux小工具，建议用 MSYS2，把 /usr/bin 加进环境变量 path 以后，可以直接在 命令行终端中使用 Linux 命令。

#### MinGW

此项目已停止维护。

<https://www.ics.uci.edu/~pattis/common/handouts/mingweclipse/mingw.html>

#### MinGW64

MinGW-w64 安装配置单，gcc 是 6.2.0 版本，系统架构是 64位，接口协议是 win32，异常处理模型是 seh，Build revision 是 1 。

简单操作的话，安装开源的 gcc IDE开发环境即可，已经都捆绑了Mingw64。
比如 CodeLite，CodeBlocks，Eclipse CDT，Apache NetBeans（JDK 8）。
收费的有JetBrains Clion，AppCode （mac）。

#### MSYS、MSYS2

    https://www.msys2.org/
    https://msys2.github.io/

MinGW 仅仅是工具链，Windows 下的 cmd 使用起来不够方便，MSYS 是用于辅助 Windows 版 MinGW 进行命令行开发的配套软件包：提供了部分 Unix 工具以使得 MinGW 的工具使用起来方便一些。相比基于庞大的 Cygwin 下的 MinGW 会轻巧不少。

MSYS2 是 MSYS 的第二代，有大量预编译的软件包，并且具有包管理器 pacman (ArchLinux)。

目前在windows上使用Linux程序

    如果只是需要一个编译器的话，可以用MinGW64。

    如果使用工具软件居多，还是 Msys2 能应付一切情况，它集合了cygwin、mingw64以及mingw32（不等于老版的那个MinGW），shell、git、多种环境的gcc（适用于cygwin环境或原生Windows），而且有pacman (ArcLinux)作为包管理器。

    Windows 10 在 2021 年后的版本更新中集成的 WSL2 使用比较方便，简单开发使用 WSL2 也可以。

#### Windows 10+ 下的 WSL 混合环境

    https://github.com/hsab/WSL-config

## Windows字符终端

终端的历史演进

    https://zhuanlan.zhihu.com/p/99963508

Windows 下如果要显示图标化字符，需要给 Windows 安装支持多种符号的字体，见下面章节 [Nerd Font]。

### putty 远程终端模拟器

    https://www.chiark.greenend.org.uk/~sgtatham/putty/

    北极主题颜色 https://github.com/arcticicestudio/nord-putty
        只进行了颜色设置的一个 session：Nord，以此 session 打开各个ssh连接即可。

putty 只有一个使用界面，使用逻辑有点绕：

    初始界面，连接站点的按钮在最下方，站点配置界面Category在左侧树形展示

    站点选择界面在右侧，对应左侧界面 “Category” 的树形列表第一项 “Session”

    左侧树形列表的其它部分，是当前选择站点配置参数，点击时右侧界面会切换为各种设置界面

    如果需要换回站点选择界面需要点击左侧界面 “Category” 的树形列表第一项 “Session”

简易连接：

    在右侧站点选择界面，操作如下：

    在 “Host Name(or IP address)” 输入地址和端口，点击下方的 “Open” 按钮

    这样会使用默认的参数进行连接。

连接已有站点：

    在右侧站点选择界面，操作如下：

    在 “Saved Sessions” 列表选择一个站点，双击即可。

    或在 “Saved Sessions” 列表点击一个站点，使其变为蓝色已选，然后点击下方的 “Open” 按钮

    或在 “Saved Sessions” 下方的编辑框手动输入站点名称，然后点击下方的 “Open” 按钮

建立新的站点

    在右侧站点选择界面，操作如下：

    在 “Host Name(or IP address)”、“Port” 输入地址和端口

    在 “Saved Sessions” 下方输入新的站点名称

    点击右侧的 “Save” 按钮

    如果新站点有某些参数需要设置，再执行下面的“编辑已有站点”步骤。

编辑已有站点

    1、在右侧站点选择界面，操作如下：

    在 “Saved Sessions” 列表选择一个站点，点击右侧的 “Load” 按钮，这时站点名称会自动填充“Saved Sessions” 下方的编辑框，而且 “Host Name(or IP address)”、“Port” 和 “connection type” 栏目都会显示该站点的参数

        如果想复制该站点，编辑新的站点名称，然后点击右侧的 “Save” 按钮，转下面第4步。

        如果想删除该站点，点击右侧的 “Delete” 按钮，转下面第4步。

    下面的第2、3步可都做，或只做一个。

    2、基本站点参数的修改：

    在右侧站点选择界面，可修改“Host Name(or IP address)”、“Port” 和 “connection type” 栏目。

    点击右侧按钮 “Save” 保存你的修改。如果不保存，直接点击下方的 “Open” 按钮，相当于用你修改的参数临时连接当前站点。

    可转下面第4步。

    3、高级站点参数的修改：（这里比较绕，习惯习惯就好）

    点击左侧 “Category” 界面的树形列表，右侧界面会变，不再是站点选择界面了，变成了你当前选择站点的相关参数的设置界面。

        切换左侧选择树形列表的各个分支，则右侧界面跟随变为相关参数的设置，自行调整即可。

        比如 “Connection->Data” 里预设登陆用户名，“Connection->SSH-Auth” 里设置密钥登陆的密钥文件等等。

    调整完成后，点击左侧界面 “Category” 的树形列表第一项 “Session”，右侧会重新出现你的站点选择界面

        检查下 “Saved Sessions” 下方的编辑框，务必确认自动填充的还是你刚才选择的那个站点名称。

        点击右侧按钮 “Save” 保存你的修改。如果不保存，直接点击下方的 “Open” 按钮，相当于用你修改的参数临时连接当前站点。

    4、执行上面“连接已有站点”的步骤，连接你的站点。

如果在站点选择界面，不选择已有站点，直接在左侧 “Category” 界面的树形列表进行了各种调整

    不推荐这样做，可能会乱。

    这样需要后续再输入ip地址和端口

        点击Open按钮就是“简易连接”

        如果给出站点名称后点击“Save”按钮，这样会保存一个站点。

### mintty 本地终端模拟器

自带 bash，详见下面几个章节的详细介绍。

    http://mintty.github.io/
        https://github.com/mintty/mintty
        https://github.com/mintty/mintty/wiki/Tips

    可以在 https://github.com/hsab/WSL-config/tree/master/mintty/themes 找到很多主题，将主题文件保存到 msys64/usr/share/mintty/themes 目录下，通过右键 mintty 窗口标题栏的 option 进行选择。

#### mintty 简单使用：Git for Windows

Git Bash 使用了 GNU tools 的 MinGW(Msys2)，但是工具只选择了它自己需要的部分进行了集成，我们主要使用他的 mintty 命令行终端程序(自称 git bash)和 ssh、gpg 等工具。

安装 git for Windows 或 MSYS2 后就有了

    https://git-scm.com/download/win

配置文件样例参见章节 [mintty 美化]

    git for Windows 下的 mintty 配置文件在 ~\.minttyrc

    MSYS2 的 mintty 的配置文件与 git for Windows 不同，详见章节[全套使用：安装 MSYS2(Cygwin/Msys)]

如果使用 mintty.exe，需要添加额外的启动参数 "mintty.exe /bin/bash --login -i"

    -i      创建一个交互式的shell

    --login 加载配置文件 ~/.profile、~/.bash_profile 等，不然你进入的是个干巴的shell

如果使用 git-bash.exe，一般使用 `git-bash.exe --cd-to-home` 打开即进入$HOME目录，比较方便。git-bash.exe 其实就是 mintty.exe 带上面参数的一个封装。

git for windows 的Linux目录结构跟Windows目录的对应关系

    / 目录          位于git安装目录下的 C:\Program Files\Git\ 目录
    /usr 目录       C:\Program Files\Git\usr\
    /bin 目录       C:\Program Files\Git\bin\
    /dev 目录       C:\Program Files\Git\dev\
    /etc 目录       C:\Program Files\Git\etc\

    /tmp 目录       位于 C:\Users\%USERNAME%\AppData\Local\Temp\  目录下

    /proc 目录      这个是 git 自己虚出来的，只能在 git bash(mintty) 下看到

    /cmd 目录       C:\Program Files\Git\cmd\，保存给 cmd 命令行窗口下运行 git 和 ssh 用的几个脚本

退出bash时，最好不要直接关闭窗口，使用命令exit或^D，不然会提示有进程未关闭。

putty的退出也是同样的建议。

#### mintty 组合使用：git for Windows + MSYS2

拷贝 MSYS2 的工具到 git 里，这样只使用 git bash(mintty) 就可以了

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
        https://creaink.github.io/post/Computer/Windows/win-msys2/

    Windows 下 MSYS2 配置及填坑 https://hustlei.github.io/2018/11/msys2-for-win.html

下载安装 MSYS2

    https://www.msys2.org/

    https://msys2.github.io/

使用 pacman 安装各种包：

    pacman -S openssh opengpg git vim tmux

pacman安装后先更换 清华源 <https://mirrors.tuna.tsinghua.edu.cn/help/msys2/> 中科大 <https://mirrors.ustc.edu.cn/help/msys2.html>，配置文件在 msys 的安装目录下的文件夹 msys64\etc\pacman.d\ 下。

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

    / 目录          位于msys2的安装目录 msys64\ 下
    /usr 目录       同上
    /tmp 目录       同上
    /home 目录      位于msys2的安装目录 msys64\ 下的 home\%USERNAME%

环境的隔离做的比较好，不会干扰Windows当前用户目录下的配置文件

    如果你的系统中独立安装了如 git for Windows 、 Anaconda for Windows 等，他们使用 C:\Users\%USERNAME% 下的 bash_profile、mintty 等配置文件，注意区分。

msys2在开始菜单下的好几个版本的说明

    是因为编译器和链接的windows的c库不同，而故意分开编译的。作为一个软件运行平台，为了适应不同编译器编译出来的程序（Windows 对 CRT 运行库的支持不一样），而不得不区分开来。

    LLVM/Clang 和 MINGW(GCC) 是两个不同的 C/C++ 编译器， mingw64、ucrt64、clang64 都是 Windows 原生程序（不依赖 cygwin.dll），不过 mingw64 是很早就有的，后两者是最近才新加的，所以只是选一个的话就用 mingw64。具体区别是：

    mingw64 与 ucrt64 都是用 mingw64 编译器编译的 Windows 64位程序，只不过它们链接到的 crt（C runtime）不同， mingw64 是链接到了 msvcrt ，而 ucrt64 则是链接到了 Windows 10+ 上新的 ucrt 上。

    而 clang64 很好理解，就是用 clang 而非 mingw 来编译各种库，另外它也是链接到了 ucrt 而非 msvcrt。

引自 <https://www.zhihu.com/question/463666011/answer/1927907983>.

官方解释 <https://www.msys2.org/docs/environments/>.

msys2的启动方式都是通过调用 msys2_shell.cmd，不同仅在于传递了变量 set MSYSTEM=xxxx，msys2_shell.cmd 启动时，都默认使用 mintty 虚拟终端。

    # c:\msys64为msys2安装目录，bash 为默认 shell，可以用 zsh,csh 等替换
    set MSYSTEM=MINGW64
    "c:\msys64\usr\bin\mintty" "c:\msys64\usr\bin\bash" --login

自己运行 Msys2 时可以不使用 mintty 虚拟终端。直接运行如下命令就OK：

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

基于 Arch Linux 的 pacman 提供软件仓库，采用滚动升级模式，初始安装仅提供命令行环境：用户不需要删除大量不需要的软件包，而是可以从官方软件仓库成千上万的高质量软件包中进行选择，搭建自己的系统。

pacman命令较多，作为新手，将个人最常用的命令总结如下：

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

#### mintty 美化

    字符终端的颜色配置说明 https://github.com/termstandard/colors

如果是 git for Windows 的 mintty，编辑 ~/.minttyrc 文件为下面的内容

```config

# https://mintty.github.io/mintty.1.html
# https://github.com/mintty/mintty/wiki/Tips#configuring-mintty
Font=MesloLGS NF
FontHeight=11

Columns=130
Rows=40
ScrollbackLines=12000

CursorType=block
AllowBlinking=yes
CursorBlinks=no

FontSmoothing=full
# FontWeight=700
# FontIsBold=yes

# 语言设置
# mintty界面的显示语言，zh_CN是中文，Language=@跟随Windows
Language=@
# 终端语言设置选项，在 Windows 10 下好像都不需要设置，下面的是 Windows 7 下的，是否因为操作系统默认编码是 ANSI ？
# https://www.cnblogs.com/LCcnblogs/p/6208110.html
# bash下设置，这个变量设置区域，影响语言、词汇、日期格式等，参见章节 [字符终端的区域、编码、语言]
Locale=zh_CN  # bash 下显示中文
#Charset=GBK # 中文版 Windows 使用 ansi 字符集，有些使用utf-8的命令如tail与使用本地字符集的命令如ls会没法都设置完美显示
Charset=UTF-8 # 这样就能正确展现那些带图标的字体了
# LANG 只影响字符的显示语言
#LANG=zh_CN.UTF-8  # win7下显示utf-8文件内容, 可先执行命令“locale” 查看ssh所在服务器是否支持

# 窗体透明效果，不适用于嵌入多窗口终端工具
# Transparency=low

# 为了使用更多的颜色，确保终端设置恰当
Term=xterm-256color

# 非通用标准的色彩项目，单独
UnderlineColour=153,241,219

# 自定义颜色方案，跟深色背景搭配
Background=C:\StartHere\tools\SuperPuTTY\111dark.jpg
BackgroundColour=13,25,38
ForegroundColour=217,230,242
CursorColour=236,255,255
Black=53,53,53
BoldBlack=92,92,92
Red=207,116,133
BoldRed=232,190,198
Green=0,135,0
BoldGreen=143,218,149
Yellow=207,190,116
BoldYellow=232,225,190
Blue=66,113,174
BoldBlue=88,133,192
Magenta=190,116,207
BoldMagenta=225,190,232
Cyan=116,207,190
BoldCyan=190,232,225
White=255,255,253
BoldWhite=255,255,255

# 自定义颜色方案，跟浅色背景搭配-黄色
#Background=C:\StartHere\tools\SuperPuTTY\222yellow.jpg
#BackgroundColour=250,234,182
#ForegroundColour=0,61,121
#CursorColour=217,230,242
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
##218,232,237
#White=107,165,186
#BoldWhite=180,180,180

# 自定义颜色方案，跟浅色背景搭配-绿色
#Background=C:\StartHere\tools\SuperPuTTY\333green.jpg
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

### 其他本地终端模拟器

alacritty 使用gpu进行显示加速的本地终端模拟器，在 Windows 下使用 powershell

    https://github.com/alacritty/alacritty

startship 通用的状态栏工具，支持 sh、bash、cmd 等 shell

    https://starship.rs/zh-CN/
        https://github.com/starship/starship

    https://sspai.com/post/72888

独立的 powershell

    https://learn.microsoft.com/zh-cn/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2

clink 使 cmd 像 bash 按tab键tab键自动完成

    https://github.com/chrisant996/clink
        不再更新了 https://github.com/mridgers/clink

    安装后打开cmd就会发现，cmd支持bash一样的行编辑功能了，在命令提示符下默认可以像emacs一样编辑输入的命令

        Ctrl+p：显示上一条命令
        Ctrl+n：显示下一条命令
        Ctrl+a：移动光标到行首
        Ctrl+e：移动光标到行尾
        Ctrl+b：光标后退一个字符
        Ctrl+f：光标前进一个字符
        Ctrl+d：删除一个字
        Ctrl+y：粘贴

    等等。

cmder 推荐的本地终端

    https://github.com/cmderdev/cmder/wiki/Seamless-Terminus-integration
        Tabby（原名Terminus）跨平台的终端模拟器 https://github.com/Eugeny/tabby

    https://github.com/cmderdev/cmder/wiki/Seamless-Hyper-integration
        hyper 基于 xterm.js 和 Electron实现 https://hyper.is/

    https://github.com/cmderdev/cmder/wiki/Seamless-FluentTerminal-Integration
        FluentTerminal 基于 xterm.js 的 UWP 应用 https://github.com/felixse/FluentTerminal

### 终端多路复用器

#### Supper Putty

    可惜目前更新不大及时 https://github.com/jimradford/superputty

本质上是给 putty 的站点加了个多窗口的外壳，树形展示站点列表，方便管理和使用

    支持嵌入其它的各种终端窗口: putty、mintty(bash)、cmd、powershell

    putty/mintty 兼容性和反应速度满分，Windows 切换任务热键 alt+tab 要按两次才能切换成功

    只要安装了 git for Windows 和 putty 等软件即可直接配置使用，不需要做复杂的设置

    可一键导入 putty 站点

    可设置关联 WinScp/FileZilla 等软件的快捷调用，右键点选站点方便调用

1、设置 Supper Putty 使用的各工具路径

    选择菜单项 Tools->Options:General，至少要给出 putty.exe 的路径，还可以给出 mintty.exe 的路径。

    其它的工具类似，配置好了后在站点列表处点击右键，可以方便调用 winscp、filezila、vnc 等工具。

2、初次使用，先导入 putty 的 session。

    选择菜单项 File->Import Sessions->From Putty Settings，导入putty session。导入后，在窗口侧栏的树状选择列表，双击即会打开 putty 窗口登陆该站点。

3、设置自动登陆 putty 的用户名

    点击想设置的session，右键菜单选“Edit”，弹出窗口选择“Login username”。这样设置了以后，打开该站点不需要putty的 session 里保存登陆用户名了。如果putty中该用户可以使用密钥登陆，则这里也自动免密码登陆，如果 pageant 代理程序在运行，一样可以免密码。

4、使用本地命令行工具 mintty (git bash)

    本地登陆协议选择 “minty”，主机地址留空即可，然后回车，就出现登陆窗口了。其实就是git bash用的那个。

    或者，编辑一个已导入的putty session，把“Connection type”选“Mintty”，“HOST Name”设置为 “localhost”即可。

    注意选项 “Extra Arguments”，因为最终要实现调用命令行如下：

        "C:\Program Files (x86)\Git\bin\mintty.exe" /bin/bash --login -i

    其它的设置选项在mintty的窗口右键菜单都有选项可选。

5、备份自己的站点设置

    除了putty的站点，用户还可以自建 cmd/power shell/rdp 等多种协议的站点，保存站点设置很有必要。

    保存站点设置

        选择菜单项 File->Emport Sessions，会给出默认的当前目录下的 Sessions.XML 文件，点击确定即可。

    恢复站点设置

        选择菜单项 File->Import Sessions->From File，选择之前备份的 Sessions.XML 文件，点击确定即可。

#### ConEmu 和 Cmder

ConEmu 用配置 Task（任务）的形式，支持标签化窗口使用 cmd, powershell, msys2, bash, putty 等等终端模拟器.

    https://conemu.github.io/

    console 类似ConEmu的软件 https://sourceforge.net/projects/console/

    ConEmu\ConEmu 目录下集成几个常用工具

        clink 使 cmd 像 bash 按tab键自动完成

        wslbridge  使 mintty 或 ConEmu 可以支持 wsl （Windows Subsystem for Linux）

            不再更新了 https://github.com/rprichard/wslbridge/

            wslbridge2 手动安装这个吧

                https://github.com/Biswa96/wslbridge2

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

    会看到新建了一个标签打开了 Windows 的记事本。

如果是调用 putty.exe/notepad.exe 等 Windows 程序，ConEmu 会利用自己的 ChildGUI 功能，内嵌显示窗体，显示效果完美，缺点是无法使用 ConEmu 的颜色和背景方案 <https://conemu.github.io/en/ChildGui.html>。

conemu 是通过 cmd 实现对 bash.exe/tmux.exe 等 unix pty 的连接，在 ssh 到服务器后使用 tmux 会出现显示问题：在刷新后总会出现底部栏重叠，还有光标错位的问题。这种情况下，建议配置任务为直接调用 mintty.exe，用参数加载 bash，在 bash 中调用 ssh/tmux 的方式实现完美兼容。

ConEmu 配置 Anaconda 会话

    点击+号，新建一个Task名为 Shells::Anaconda，命令文本框输入

    "%windir%\syswow64\cmd.exe" /k "C:\ProgramData\Anaconda3\Scripts\activate.bat C:\ProgramData\Anaconda3"  -new_console:d:%USERPROFILE%

ConEmu 配置 putty 会话

    直接调用 putty.exe

        点击+号，新建一个Task名为 putty::your_putty_session，命令文本框输入如下

        C:\tools\PuTTY\putty.exe -load "your_putty_session_name"

        如果不指定会话名称，会自动弹出 putty 的窗口供用户选择会话

ConEmu 配置 git-bash 会话

    直接调用 git-bash.exe

        点击+号，新建一个Task名为 Bash::git-bash，命令文本框输入

        set "PATH=%ProgramFiles%\Git\usr\bin;%PATH%" & %ProgramFiles%\Git\git-bash.exe --cd-to-home

        git-bash.exe 等同于 "%ProgramFiles%\Git\usr\bin\mintty.exe" /bin/bash -l

关于 ConEmu 配置 Git bash 会话的默认任务 {Bash::Git bash}

    如果不使用 tmux/zsh 状态栏工具，倒是可以正常使用，好处是支持 ConEmu 的颜色和背景方案。

    如果运行 tmux/zsh 状态栏工具会错行，而且光标错位：conemu 是通过 cmd 实现对 bash 的连接，tmux 不能直接打开，在 ssh到服务器后使用 tmux 会出现显示的问题，在刷新后总会出现底部栏重叠，还有光标错位的问题。

        set "PATH=%ProgramFiles%\Git\usr\bin;%PATH%" & %ProgramFiles%\Git\git-cmd.exe --no-cd --command=%ConEmuBaseDirShort%\conemu-msys2-64.exe /usr/bin/bash.exe -l -i -new_console:p

ConEmu 配置 MSYS2 任务

    直接调用 mintty.exe，由它调用 shell 程序，这样显示效果由 mintty 决定。

        C:\msys64\usr\bin\mintty.exe -i /msys2.ico -t "%CONTITLE%" "/usr/bin/zsh" -new_console:C:"%D%\msys2.ico"

    直接调用 bash.exe

        显示会光标错行，估计也是因为 ConEmu 通过 cmd 实现对 bash.exe 的连接导致的。

        打开 conemu 的 settings 对话框，选择 Startup>>Tasks 选项
        点击+号，新建一个 Task 名字为 Msys2::MingGW64，在 commands 下文本框内输入如下代码：

            set MSYS2_PATH_TYPE=inherit & set MSYSTEM=mingw64 & set "D=C:\msys64" & %D%\usr\bin\bash.exe --login -i -new_console:C:"%D%\msys2.ico"

        MSYS2_PATH_TYPE=inherit 表示合并 Windows 系统的 path 变量。注意修改变量值 `D=` 为你的msys2的安装目录。

        打开后会自动把工作目录设置为 msys64/home/%user% 下。

## Linux 字符终端

使用 gpu 进行显示加速的字符终端，号称比 iTerm 速度快

    https://github.com/alacritty/alacritty

使用 gpu 进行显示加速的字符终端，只能在 linux 桌面下使用

    https://github.com/kovidgoyal/kitty

        https://www.linuxshelltips.com/kitty-terminal-emulator-linux/

### 字符终端的区域、编码、语言

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

### 字符终端下的一些小玩具如 emoji、cmatrix 等

    符号字符 https://www.webfx.com/tools/emoji-cheat-sheet/

    unicode编码 http://www.unicode.org/emoji/charts/full-emoji-list.html

    emoji 大全 https://emojipedia.org/
        unicode emoji https://unicode.org/emoji/charts/full-emoji-list.html
        git emoji https://blog.csdn.net/li1669852599/article/details/113336076

小火车sl

    sudo apt install sl

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
    watch -n1 "date '+%D %T'|figlet -f future.tlf -w 80"

    # 温度及钟表
    # watch -n1  "date '+%D %T ' && vcgencmd measure_temp |figlet -f future.tlf -w 80 "
    watch -n1  "(date '+%T'; vcgencmd measure_temp) |tr '\n' ' ' |figlet -f future.tlf -w 80 "

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

            # 不要sudo make install，尽量打包然后用包管理器安装
            $ sudo make install
            make[1]: Entering directory '/pcode/cmatrix'
            /usr/bin/mkdir -p '/usr/local/bin'
            /usr/bin/install -c cmatrix '/usr/local/bin'
            Installing matrix fonts in /usr/share/consolefonts...
            /usr/bin/mkdir -p '/usr/local/share/man/man1'
            /usr/bin/install -c -m 644 cmatrix.1 '/usr/local/share/man/man1'
            make[1]: Leaving directory '/pcode/cmatrix'

        /usr/local/bin/cmatrix -sbau8

    Centos 需要自行编译

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

### bash 命令提示符美化

终端工具应该设置256color显示，最好开启透明效果，或在登陆脚本中设置环境变量

    # 显式设置终端启用256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
    export TERM="xterm-256color"

简单的双行状态栏 见章节  [bash_profile.sh] <shell_script okletsgo>

或者使用 powerline（参见章节[状态栏工具 powerline]）

    # 如果是pip安装的查看路径用 pip show powerline-status
    source /usr/share/powerline/bindings/bash/powerline.sh

各种字符显示工具通用的颜色方案-北极

    https://www.nordtheme.com/ports

### 状态栏工具 powerline

bash、vim、tmux 等众多工具及插件，powerline 都可适配进行状态栏显示。

    https://github.com/powerline/powerline/

    配置说明 https://powerline.readthedocs.io/en/master/configuration/reference.html

powerline 最大的优点是它的各种符号字体可以图形化的显示文件夹、电池、git状态、进度等。

缺点是它的代码 python2、3 混杂，安装和使用都很难配置，所以现在有些插件不使用它了。

基础安装

    # https://askubuntu.com/questions/283908/how-can-i-install-and-use-powerline-plugin
    # https://powerline.readthedocs.io/en/latest/installation.html

    # 最好别用pip安装，我弄了一上午都搞不定最终起效的设置
    # https://powerline.readthedocs.io/en/latest/installation.html
    # pip install powerline-status 这个是python2的一堆坑
    # python3 -m pip install --user git+https://github.com/powerline/powerline

    # 最好用发行版自带的，一步到位，默认的安装到 /usr/share/powerline/ 目录下了
    sudo apt install powerline

安装后有个后台进程

    # 由 systemd 调度管理 /etc/systemd/user/default.target.wants/powerline-daemon.service
    $ ps -ef|grep powerline
    00:00:00 /usr/bin/python3 /usr/bin/powerline-daemon --foreground

终端工具最好明确设置变量 Term，这样各个插件会自动使用更丰富的颜色

    # 显式设置终端启用256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
    export TERM="xterm-256color"

终端工具字体推荐 MesloLGS NF，详见下面章节[状态栏字体]。

#### 使用 powerline-config 命令行绑定到各软件

    $ powerline-config -h
    usage: powerline-config [-h] [-p PATH] {tmux,shell} ...

    Script used to obtain powerline configuration.

    positional arguments:
    {tmux,shell}
        tmux                Tmux-specific commands
        shell               Shell-specific commands

tmux:

    powerline-config tmux

其它的shell，我没弄出来效果呢？

    powerline-config shell -s bash uses prompt

    powerline-config shell -s zsh uses prompt

#### 手工配置各软件的绑定

先查看你安装 powerline 的位置，找到bindings目录

    # 如果是用 pip 安装的 powerline
    # 用命令 pip show powerline-status 查看
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

    # 如果是pip安装的查看路径用 pip show powerline-status
    /usr/share/powerline/config_files/themes/相关软件名/xxx.json

替换自己喜欢的函数即可

    官方函数说明 https://powerline.readthedocs.io/en/master/configuration/segments.html

想自己做个状态栏工具，参考下这个

    https://github.com/agnoster/agnoster-zsh-theme

#### 替代品

如果不使用 powerline，可使用 startship，这个 sh、bash、cmd 等 shell 下通用的状态栏工具，见章节 [Windows字符终端]。

推荐安装 zsh，使用 zsh 下的 powerlevle10k 工具，这个兼容性和效果直接起飞，见章节 [推荐主题powerlevel10k]。

### 状态栏字体

    https://juejin.cn/post/6844904054322102285

作为程序员，和命令行打交道很频繁，设置一个赏心悦目的命行行 prompt 或者 Vim 的 status line 主题就很有必要了，不过一般这些漂亮的主题都会用到一些 icon 字符，这些 icon 字符一般的字体里是没有的。

如果使用的是没有打 patch 的字体，可以看到很多特殊字符都会显示不正确，这也是很多爱好者安装一些主题后，显示效果不理想的原因。

Powerline fonts 或者 Nerd fonts 这些字体集，他们对已有的一些 (编程) 字体打了 patch，新增一些 icon 字符。

字体要安装到你使用终端窗口工具的计算机上

    你在 Windows 下使用 putty 或 mintty 等终端窗口工具连接到服务器，则字体要安装到你的 Windows 系统中。

    你在 MacOS 下使用 iTerm2 终端窗口工具连接服务器，则要在你的苹果电脑上安装这些字体。

如果你使用的是linux终端就比较省事了，直接安装到本机，Debian 发行版自带 powline 字体

    # https://github.com/caiogondim/bullet-train.zsh
    sudo apt install fonts-powerline
    sudo apt install ttf-ancient-fonts

然后设置在终端窗口工具或编辑器使用该字体，这样才能正确显示。

简单测试几个unicode字符

    $ echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
     ±  ➦ ✘ ⚡ ⚙

#### Powerline fonts

Nerd fonts 是 Powerline fonts 的超集，建议直接使用 Nerd font 就好了。

    https://github.com/powerline/fonts

Powerline 是一款 Vim statusline 的插件，它用到了很多特殊的 icon 字符。

powerline fonts 是一个字体集，本质是对一些现有的字体打 patch，把 powerline icon 字符添加到这些现有的字体里去，目前对非常多的编程字体打了 patch。Powerline fonts 对打过 patch 的字体做了重命名，后面都加上了 for Powerline 的后缀，比如 Source Code Pro 打完 patch 后名字改为了 Source Code Pro for Powerline。

很多状态栏插件工具等，即使不支持 powerline，也会支持 powerline fonts 的字体。

    # clone
    git clone --depth=1 https://github.com/powerline/fonts.git

    # install
    cd fonts
    ./install.sh

    cd ..
    rm -rf fonts/

#### Nerd font

    https://www.nerdfonts.com/font-downloads
        https://github.com/ryanoasis/nerd-fonts

原理和 Powerline fonts 是一样的，也是针对已有的字体打 patch，把一些 icon 字符插入进去。不过 Nerd font 就比较厉害了，是一个“集大成者”，他几乎把目前市面上主流的 icon 字符全打进去了，包括上面刚刚提到的 powerline icon 字符以及 Font Awesome 等几千个 icon 字符。

和 Powerline fonts 类似，也会在 patch 后，对名字做一下修改，比如 Source Code Font 会修改为 Sauce Code Nerd Font (Sauce Code 并非 typo，故意为之)

终端窗口工具推荐安装 MesloLGS NF 字体，如果窗口支持透明效果（如mintty），显示效果直接起飞 <https://github.com/romkatv/powerlevel10k#fonts>。

    快速下载地址

    https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k

    原始地址，Windows 用户找带 Windows 字样的下载即可

        https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo/S/Regular/complete

        原版 Meslo 字体
            https://github.com/andreberg/Meslo-Font
                Windows 下用 Meslo LG S (行间距 小)

代码编辑器推荐安装 FiraCode NF 字体，该字体支持连字符，Windows 用户找带 Windows 字样的下载即可

    https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode

字体名称的区别在于，“Code”变体包含连字，而“Mono”变体不包含连字，“PL”字样是支持PowerLine图形。

简单测试几个 unicode 扩展 NF 字符

    $ echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699 \u2743 \uf70f \ue20a \ue350 \uf2c8 \uf2c7"
     ±  ➦ ✘ ⚡ ⚙ ❃      

### 使用 zsh

单纯的 zsh 并不慢，只要别装 ohmyzsh，没有任何功能性插件的使用场景依赖这个 ohmyzsh）。

    https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH

    https://www.zhihu.com/question/21418449/answer/300879747

从语法上来说，zsh和bash是不兼容的；但是zsh有一个仿真模式，可以支持对 bash/sh 语法的仿真（也有对csh的仿真，但是支持不完善，不建议使用）：

    $ emulate bash
    # or
    $ emulate sh

安装

    sudo apt install zsh

如果是用 apt install 安装的发行版，位置在 /usr/share/

zsh 默认使用的用户插件位置，在 ~/.zsh/plugin/

设置当前用户使用 zsh

    # 用户修改自己的登陆shell
    sudo chsh -s /bin/zsh

    # 修改指定用户的登陆shell
    sudo usermod -s /bin/zsh username

插件和主题太多了容易搞乱环境，保守点的用法是登陆环境默认还是用 bash，登陆后手动执行 `exec zsh` 切换到zsh（如果执行 `zsh` 则在 bash 的基础上进入 zsh，执行 exit 退出时会先退出到 bash，然后再次 exit 才是断开连接）。

    # 如果在 .bash_profile 中，需要判断下是否在终端打开的（程序登陆时不是交互式shell）
    if [ -t 1 ]; then
        exec zsh
    fi

如果是初次运行zsh，有个引导程序设置zsh读取的配置文 ~/.zshrc 文件，也可以手动调用

    autoload -Uz zsh-newuser-install

    zsh-newuser-install -f

如果之前使用bash，在 ~/.zshrc 文件中加上`source ~/.bash_profile`，可以继承 bash 的配置文件 ~/.bash_profile 内容。

有些插件和主题依赖 python 和 git，注意提前安装好。

推荐使用简洁的zsh提示符主题 pure

    https://github.com/sindresorhus/pure

    下面章节[推荐状态栏工具 powerlevel10k]，也可设置为 pure 风格。

zsh自带功能

    命令智能补全：相对于 bash，两次 TAB 键只能用于提示目录，在 zsh 中输入长命令，输入开头字母后连续敲击两次 TAB 键 zsh 给你一个可能的列表，用tab或方向键选择，回车确认。比如已经输入了 svn commit，但是有一个 commit 的参数我忘记了，我只记得两个减号开头的，在svn commit -- 后面按两次TAB，会列出所有命令。

    快速跳转：输入 cd - 按TAB，会列出历史路径清单供选择。

#### 安装常用的插件

    powerline：见章节[状态栏工具 powerline]

    命令自动完成：输入完 “tar”命令，后面就用灰色给你提示 tar 命令的参数，而且是随着你动态输入完每一个字母不断修正变化，tar -c 还是 tar -x 跟随你的输入不断提示可用参数，这个命令提示是基于你的历史命令数据库进行分析的。按TAB键快速进入下一级，或直接按右方向键确认该提示。

        # git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
        zsh
        sudo apt install zsh-autosuggestions

    命令语法高亮：根据你输入的命令是否正确的色彩高亮，比如输入date查看时间，错为data，字体的颜色会跟随你的输入一个字母一个字母的变化，错误会直接变红。

        # git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting
        zsh
        sudo apt install zsh-syntax-highlighting

        # 发现个替代品 https://github.com/zdharma-continuum/fast-syntax-highlighting

    命令模糊查找：输入错的也没关系，给你候选命令的提示，vi模式改良为按上下键进入搜索，直接输入关键字即可

        # https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh
        sudo apt install fzf

使用 source 命令启用插件的 ~/.zshrc 文件

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

#### 推荐状态栏工具 powerlevel10k

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

先在你使用终端窗口工具的计算机上安装 MesloLGS NF 字体，详见章节[状态栏字体]。

终端工具最好明确设置变量Term，这样各个插件会自动使用更丰富的颜色

    # 显式设置终端启用256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
    export TERM="xterm-256color"

如果你的终端窗口工具不支持透明效果，且未使用 MesloLGS NF 字体的话，显示风格会有差别，这是设计者做了兼容性考虑，以防止出现不正常的显示。

然后从github安装powerlevel10k

    # https://github.com/romkatv/powerlevel10k#manual
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

再次进入 `zsh` 就可以起飞了。

初次进入zsh后会自动提示设置使用习惯，之后可以执行命令 `p10k configure` 再次设置。

这个主题自带一堆状态插件包括git、virtualenv等等，如果之前在zsh的plugin里启用了git，可以删除。

自定义启用它自带的哪些插件，编辑 ~/.p10k.zsh 文件，搜索 POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS= 即可。

##### 自定义状态栏提示段，监控树莓派温度

可运行命令查看帮助说明

    p10k help segment

编辑 ~/.p10k.zsh 文件，搜索 prompt_example，先看说明

1、在状态栏提示段新增一个处理函数

```shell

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    raspi_temp_warn         # raspberry pi cpu temperature
    ...
)

```

2、在函数 prompt_example() 后面追加个新的函数：

``` shell

function prompt_raspi_temp_warn() {

  which vcgencmd >/dev/null 2>&1 || return 0

  local CPUTEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

  if [ "$CPUTEMP" -gt  "60000" ] && [ "$CPUTEMP" -lt  "65000" ]; then
          p10k segment -b yellow -f blue -i ''

  elif [ "$CPUTEMP" -gt  "65000" ] && [ "$CPUTEMP" -lt  "70000" ]; then
          local CPUTEMP_WARN="CPU `vcgencmd measure_temp`!"
          p10k segment -b yellow -f blue -i '' -t "$CPUTEMP_WARN"

  elif [ "$CPUTEMP" -gt  "70000" ];  then
          local CPUTEMP_WARN="CPU TEMPERATURE IS VERY HIGH!`vcgencmd measure_temp`"
          p10k segment -b red -f black -i '' -t "$CPUTEMP_WARN"
  fi
}

```

如果担心 instant-prompt 功能会在出现 y/n 提示的时候提前输入y，酌情关掉这个功能，编辑 ~/.zshrc 注释掉该文件最前面的几行

    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

#### 推荐套件 -- zsh4humans

嫌上面逐个配置太麻烦就用打包的，它还优化了速度，比自己手工在zsh里挨个装插件还有优化。

    https://github.com/romkatv/zsh4humans

无脑安装就完事了，最常用的几个插件都给你配置好了：状态栏工具、自动完成、语法高亮、命令模糊查找

    powerlevel10k
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf

而且能跨主机记忆命令历史，比如你在本机ssh某个主机后执行的操作，在本机或另一个ssh主机上都可以被回忆到，方便！

如果想研究哪个插件过慢导致命令行反应让人不爽，有专门搞测量的 zsh-bench

    https://github.com/romkatv/zsh-bench#conclusions

它的建议是状态栏工具使用主题 powerlevle10k，如果还需要自动完成啥的那几个插件，就直接安装 zsh4humans，这些都有而且优化了。

自己简单测试下加载zsh的速度

    $  for i in $(seq 1 5); do /usr/bin/time /bin/zsh -i -c exit; done

    0.23user 0.14system 0:00.33elapsed 114%CPU (0avgtext+0avgdata 6044maxresident)k
    0inputs+0outputs (0major+4998minor)pagefaults 0swaps
    0.25user 0.09system 0:00.30elapsed 113%CPU (0avgtext+0avgdata 5912maxresident)k
    0inputs+0outputs (0major+5016minor)pagefaults 0swaps
    0.21user 0.18system 0:00.33elapsed 118%CPU (0avgtext+0avgdata 5916maxresident)k
    0inputs+0outputs (0major+5012minor)pagefaults 0swaps
    0.19user 0.15system 0:00.30elapsed 111%CPU (0avgtext+0avgdata 5980maxresident)k
    0inputs+0outputs (0major+4998minor)pagefaults 0swaps
    0.20user 0.13system 0:00.30elapsed 114%CPU (0avgtext+0avgdata 5904maxresident)k
    0inputs+0outputs (0major+4995minor)pagefaults 0swaps

#### 自带插件管理器，内置超多插件和主题的 ohmyzsh

    如果只是简单使用 zsh + powerlevel10k + 自动完成等几个插件，不需要安装ohmyzsh，这货太慢，而且经常自动升级，你进入zsh时会等半天它更新才给出提示行...

ohmyzsh 是在 zsh 的基础上增加了更多的花样的shell封装、主题管理等。

    https://ohmyz.sh/
        https://github.com/ohmyzsh/ohmyzsh

先在你使用终端窗口工具的计算机上安装 MesloLGS NF 字体，详见章节[状态栏字体]。

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

    更多的主题 https://github.com/ohmyzsh/ohmyzsh/wiki/External-themes
                https://github.com/unixorn/awesome-zsh-plugins

内置主题bira比较简洁，可手工修改添加时间提示`RPROMPT="[%*]%B${return_code}%b"`
![bira](https://user-images.githubusercontent.com/49100982/108254762-7a77a480-716c-11eb-8665-b4f459fd8920.jpg)

额外主题 [Bullet train](https://github.com/caiogondim/bullet-train.zsh)，可手工修改主机名字段颜色`BULLETTRAIN_CONTEXT_BG=magenta`，目前还没找到合适的字体显示各种图标，安装了 Powerline Vim plugin 没见效果。

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

zsh 默认未提供命令行的 vi 模式，需要手工编辑 ~/.zshrc 文件

    # 命令行开启vi-mode模式，按esc后用vi中的上下键选择历史命令
    set -o vi

#### .zshrc 配置文件样例

安装 powerlevle10k、ohmyzsh(可选) 等几个插件后的配置

```zsh

############ powerlevel10k 自动生成的首行，不用动
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

############ zsh 自己的内容

##########################################################
# 用户自己的插件设置

# 显式设置终端启用256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
export TERM="xterm-256color"

# 添加 dbian 自带的 .bashrc 脚本，常用命令开启彩色选项
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    alias l='ls -CF'
    alias ll='ls -l'
    alias la='ls -lA'
    alias lla='ls -la'

fi

############# 手动设置插件
# 如果是用 apt install 安装的发行版插件，位置在 /usr/share/ 目录
# 手动安装的插件，位置在 ~/.zsh/plugins/ 目录

# 启用插件：状态栏工具 powerline
# 如果是pip安装的查看路径用 pip show powerline-status
# source /usr/share/powerline/bindings/zsh/powerline.zsh

# 启用插件：命令自动完成
# source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 启用插件：命令语法高亮
# 官网提示要在配置文件的最后一行
# source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##############
# 如果安装了 ohmyzsh 会自动生成一堆设置，不用动
# ...
# ...
# 有个 ohmyzsh 的插件管理，在 plugin=() 段落启用内置插件，可以在这里加载上面的插件，不用 source xxx 了

############## powerlevel10k 安装程序添加部分

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

############ 手动配置插件

############ 自定义调整
# 命令自动完成的颜色太暗  # ,bg=cyan
# https://github.com/zsh-users/zsh-autosuggestions#suggestion-highlight-style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#006799,bold"

# zsh 默认是 vi 操作模式，不需要显式设置了
#set -o vi

```

#### zsh插件管理器 antigen

    <https://github.com/zsh-users/antigen>

我在 Debian 10 buster 下面就没整利索过这货，不用了

    # https://github.com/zsh-users/antigen/wiki/Installation
    sudo apt install zsh-antigen

如果是用 apt install 安装的发行版，位置在 /usr/share/ 下面

antigen用法：快速配置

假如你之前使用了oh-my-zsh，在这里可以先把原来的oh-my-zsh和.zshrc文件删掉，然后创建一个新的 ~/.zshrc 文件，内容如下

    # 格式：antigen bundle <内置的插件名>
    # 格式：antigen bundle <github_user/repo_name>

    source /path-to-antigen/antigen.zsh

    # 加载oh-my-zsh库

    antigen use oh-my-zsh

    # 加载原版oh-my-zsh中的功能

    antigen bundle git

    antigen bundle pip

    antigen bundle command-not-found

    # 语法高亮功能

    antigen bundle zsh-users/zsh-syntax-highlighting

    # 代码提示功能

    antigen bundle zsh-users/zsh-autosuggestions

    # 自动补全功能

    antigen bundle zsh-users/zsh-completions

    # 加载主题

    antigen theme robbyrussell

    # 保存更改

    antigen apply

    # 退出重启shell
    exit
    zsh

zsh配置文件样例，有空慢慢研究吧 <https://linux.zone/1306>。

目前最快的插件管理器是 zinit（原 zplugin）

    https://github.com/zdharma-continuum/zinit

    https://gist.github.com/laggardkernel/4a4c4986ccdcaf47b91e8227f9868ded

    https://zhuanlan.zhihu.com/p/98450570

这个插件管理器在 ~/.zshrc 文件中的加载设置如下

    # Load powerlevel10k theme
    zinit ice depth"1" # git clone depth
    zinit light romkatv/powerlevel10k

This is powerlevel10k, pure, starship sample:

    # Load powerlevel10k theme
    zinit ice depth"1" # git clone depth
    zinit light romkatv/powerlevel10k

    # Load pure theme
    zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
    zinit light sindresorhus/pure

    # Load starship theme
    zinit ice as"command" from"gh-r" \ # `starship` binary as command, from github release
            atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \ # starship setup at clone(create init.zsh, completion)
            atpull"%atclone" src"init.zsh" # pull behavior same as clone, source init.zsh
    zinit light starship/starship

## Linux 常用工具

### man/info 查看帮助信息

SEE ALSO
       kill(1), alarm(2), kill(2), pause(2), sigaction(2),  signalfd(2),  sigpending(2),  sigprocmask(2),  sigsuspend(2),  bsd_signal(3),
       killpg(3), raise(3), siginterrupt(3), sigqueue(3), sigsetops(3), sigvec(3), sysv_signal(3), signal(7)

man 查看各章节后缀用.数字即可

    man signal.7

### Vim 和 nano

最基础的版本是类似 vi 的 vim tinny 版本，不支持语法高亮、窗口拆分等各种高级功能。

如果 vim 的默认颜色方案太丑

    输入命令 :color 后回车查看当前的颜色主题。

    输入命令 :colorscheme slate ，即可设置当前vim实例的颜色主题为 slate。

    :syntax enable  启用语法高亮

    :syntax clear   关闭语法高亮

+ vim 解决汉字乱码

如果你的 vim 打开汉字出现乱码的话，那么在 $HOME 目录(~)下，新建 .vimrc 文件

    nano ~/.vimrc

添加内容如下：

    set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
    set enc=utf8
    set fencs=utf8,gbk,gb2312,gb18030

保存退出后执行下环境变量

    source ~/.vimrc

#### nano 用法

常用编辑命令在底部都有提示，适合不会用 vi 的用户。

光标控制

    移动光标：使用用方向键移动。
    选择文字：按住鼠标左键拖到。

复制、剪贴和粘贴

    复制一整行：Alt+6
    剪贴一整行：Ctrl+K
    粘贴：Ctrl+U

如果需要复制／剪贴多行或者一行中的一部分，先将光标移动到需要复制／剪贴的文本的开头，按Ctrl+6（或者Alt+A）做标记，然后移动光标到 待复制／剪贴的文本末尾。这时选定的文本会反白，用Alt+6来复制，Ctrl+K来剪贴。若在选择文本过程中要取消，只需要再按一次Ctrl+6。

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

插件管理器

    推荐 https://github.com/junegunn/vim-plug

    2019年之后不更新了 https://github.com/VundleVim/Vundle.vim

    老资格的vim插件管理器 https://github.com/MarcWeber/vim-addon-manager
    在 debian 10 buster 里如果用 apt install 安装 vim 的插件就会自动安装这个依赖
    sudo apt install vim-addon-manager

颜色方案

    推荐北极，作为插件安装即可 https://www.nordtheme.com/ports/vim

    vim-airline 和 lightline 都内置的一个养眼主题
        papercolor https://github.com/NLKNguyen/papercolor-theme

    material https://github.com/material-theme/vsc-material-theme

    夜猫子 https://github.com/sdras/night-owl-vscode-theme

插件大全列表

    https://vimawesome.com/

##### 使用状态栏工具等扩展插件的先决条件

终端工具启用 256color，最好支持透明效果

    # 在 .bash_profile 中显式设置终端启用256color，防止终端工具未设置
    # 如果终端工具能开启透明选项，则显示的效果更好
    export TERM="xterm-256color"

检查vim的版本，进入vim执行命令 :version

    Small version without GUI.

如果出现上述字样，说明当前系统只安装了兼容 vi 模式的精简版 vim.tiny，不支持语法高亮、切分窗口等高级功能（vim 内置插件）

    $ apt show vim.tiny
    Description: Vi IMproved - enhanced vi editor - compact version

    This package contains a minimal version of Vim compiled with no GUI and
    a small subset of features. This package's sole purpose is to provide
    the vi binary for base installations.

    If a vim binary is wanted, try one of the following more featureful
    packages: vim, vim-nox, vim-athena, vim-gtk, or vim-gtk3.

    $ vi --version
    Small version without GUI.  Features included (+) or not (-):
    +acl               -extra_search      -mouse_sgr         -tcl
    -arabic            -farsi             -mouse_sysmouse    -termguicolors
    +autocmd           -file_in_path      -mouse_urxvt       -terminal

先删除 vim.tiny

    $ sudo apt remove vim-common
    The following packages will be REMOVED:
        vim-common vim-tiny

然后安装vim的增强版

    # https://askubuntu.com/questions/284957/vi-getting-multiple-sorry-the-command-is-not-available-in-this-version-af
    # sudo apt install vim-runtime
    # sudo apt install vim-gui-common 给linux桌面准备的

    $sudo apt install vim
    The following NEW packages will be installed:
        vim vim-common vim-runtime

然后在 vim 中运行命令 :version

    Huge version without GUI.

确认如上字样即可。

##### 配置扩展插件

vim 配置文件在 ~/.vimrc 或 /etc/vim/vimrc

各种扩展插件使用的目录

    https://vimhelp.org/options.txt.html#%27runtimepath%27

使用命令 `:set rtp` 查看当前加载扩展的路径

    runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim81,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after

1、如果是 `apt install xxx` 安装的插件一般默认安装了插件管理 vim-addon-manager，在 /usr/share/vim/addons/

   自定义插件  /usr/share/vim/addons/plugin/
   使用时加载  /usr/share/vim/addons/autoload/

   vim 自带插件        /usr/share/vim/vim81/plugin/
   vim 自带使用时加载   /usr/share/vim/vim81/autoload/

2、如果是用户自定义安装的插件，保存在 ~/.vim/ 下，vim 会自动查找该目录

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

##### 不推荐状态栏工具 powerline

    推荐使用替代品 vim-airline，状态栏和标签栏都有，而且可以配合很多知名插件的显示

powerline 介绍，参见章节 [状态栏工具 powerline]。

使用 powerline 在 vim 下的插件需要 Vim 在编译时添加 python 支持，所以 vim.tinny 版是无法使用该插件的，如何解决见上面的“使用状态栏工具等扩展插件的先决条件”。

powerline 为保证多样性，使用python，现在的问题是默认python指的python2版本

    搞清 操作系统安装的包 python-pip 和 python3-pip 的使用区别
    搞清 powerline 有 python 和 python3 两个发行版本
    搞清 操作系统默认的 python 环境是 python 还是 python3
    搞清 你安装的 powerline 到底是用 python 还是 python3 执行的？如果是用 apt install 安装的更不一样。
    搞清 所有的 powerline 的插件，安装前都要先看看到底支持哪个python版本？
    搞清 前面这堆 python 到底是指 python2 还是 python3 ？如果是python3，最低要求 3.6 还是 3.7 ？

    建议不要自行编译 vim ！你的 python 环境是什么，在 virtualenv 下如何使用vim？

    建议安装 debian 发行版自带的 powerline，用 `sudo apt install powerline`即可

        新版只能用pypi `python3 -m pip install powerline-status`

        最新版就得用github `python3 -m pip install --user git+git://github.com/powerline/powerline`

        如果，你用的是 pip install powerline-status，那么安装的应该是 python 2.7 版本的 powerline-status。

        然后继续，所有的 powerline 的插件，安装前都要先看看到底支持哪个python版本？

如果确定你的 vim 可以使用 powerline ，做如下设置：

    先查看 powerline 的安装位置，找到bindings目录

        如果是用 pip 安装的 powerline，就是如下这种的路径

            # pip show powerline-status
            # /usr/lib/python3/dist-packages/powerline/bindings/vim/
            /usr/local/lib/python2.7/site-packages/powerline/bindings/vim/

        如果是用 apt 安装的 powerline ，就是这种路径

            /usr/share/powerline/bindings/vim/

    添加到配置文件 ~/.vimrc 或 /etc/vim/vimrc 中

        set rtp+=/usr/share/powerline/bindings/vim/

        " Always show statusline
        set laststatus=2

        " Always show tabline
        set showtabline=2

        " Use 256 colours (Use this setting only if your terminal supports 256 colours)
        set t_Co=256

##### 推荐 vim 状态栏工具 vim-airline

完美替换掉 powerline

    https://github.com/vim-airline/vim-airline

省事了，不仅是状态栏和标签栏，而且能配合很多常用插件如目录树的显示，普通字体也可以正常显示，开箱即用。

没使用 python 代码，都用 vim script 写的，速度和兼容性都有保证。

    # 会自动安装插件管理器 vim-addon-manager，然后把自己安装到插件目录中
    apt install vim-airline
    apt install vim-airline-themes

vim.tinny 版是无法使用该插件的，如何解决见章节 [使用状态栏工具等扩展插件的先决条件]。

查看帮助

    :help airline

Airline 扩展支持适配 tabline、nerdtree 等插件的颜色方案，在 ~/.vimrc 中配置

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

AirlineTheme 自己管理主题，在 ~/.vimrc 中配置

    " AirlineTheme 需要启用 powerline 的字体才能起飞
    let g:airline_powerline_fonts = 1

    " airline_theme内置的主题大部分都只是状态栏的，没有同步设置语法高亮
    " 建议自定义插件，直接安装 PaperColor 或 nord，状态栏和语法高亮颜色都有了,不需要用 airline_theme内置的主题
    " https://github.com/vim-airline/vim-airline-themes/tree/master/autoload/airline/themes
    " 列表见 https://github.com/vim-airline/vim-airline/wiki/Screenshots
    " 保存在 ~/.vim/bundle/vim-airline-themes/autoload/airline/themes
    " 使用说明 ~/.vim/bundle/vim-airline-themes/README.md
    " 在vi中切换主题 :AirlineTheme night_owl
    let g:airline_theme='papercolor'

##### 更简洁的状态栏工具 lightline.vim

    https://github.com/itchyny/lightline.vim

如果你想只安装个干净的工具栏，其它插件自己配置自己玩的话，状态栏工具用这个 lightline.vim 就足够了。

Why yet another clone of powerline?

    [vim-powerline](https://github.com/Lokaltog/vim-powerline)  is a nice plugin, but deprecated.

    powerline is a nice plugin, but difficult to configure.

    vim-airline is a nice plugin, but it uses too many functions of other plugins, which should be done by users in .vimrc.

这个比较简洁，只有状态栏工具和颜色方案。也是不使用 python 代码，都用 vim script 写的，速度和兼容性都有保证。

vim.tinny 版是无法使用该插件的，如何解决见上面的“使用状态栏工具等扩展插件的先决条件”。

配置主题

    let g:lightline = { 'colorscheme': 'PaperColor' }

##### nerdtree 树形文件夹插件

如果感觉插件太多太麻烦，可以使用 vim 自带的树形文件夹插件 netrw，见章节 [vim 内置的树形文件夹管理 netrw]。

nerdtree 以在当前窗口的左侧垂直新建窗口的方式，树形展示当前路径下的文件列表，方便用户操作。

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

###### vim 内置的树形文件夹插件 netrw

netrw 是 vim 自带的插件, 不需要额外安装, 其提供的功能非常强大, 相比与 nerdtree 这些第三方插件来说速度更快, 体量更轻, 设计更简洁。

默认情况下，netrw 将在当前窗口中打开目录树列表，选择文件后回车即可在当前窗口打开文件。

在 vim 中打开 netrw 窗口

    :E       全屏进入 netrw, 全称是 :Explorer 或 :Ex
    :Se      水平分割进入 netrw
    :Ve      垂直分割进入 netrw

退出

    :q  关闭 netrw 窗口（保持回车打开文件的窗口），如果 netrw 是唯一打开的窗口，那么将同时退出Vim。

    :bd 我们可以将 netrw 理解为，使用编辑命令对于目录进行操作的特殊缓冲区。也就是说，我们可以使用:bdelete命令，来关闭Netwr打开的缓冲区，但不会退出 Vim。

可设置打开的方式

        let g:netrw_browse_split = n

    其中，参数 n 的值可以为以下四种

        1   在目录树列表窗口，水平拆分新窗口打开文件
        2   在目录树列表窗口，垂直拆分新窗口打开文件
        3   用新建标签页打开文件
        4   用前一个窗口打开文件

拆分窗口的切换，使用 vim 多窗口操作的前导键 ctrl+w，参见章节 [多窗口(Window)操作]

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

##### 插件管理器 vim-addon-manager

在 `apt install vim-airline` 的时候会自动安装 vim-addon-manager

    apt install vim-addon-manager

使用目录

    # apt install 安装
    /usr/share/vim/addons/

    # 自定义安装
    ~/.vim/addons/

使用有一系列的命令

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

##### 推荐：插件管理器 vim-plug

Vundle不更新了，这个项目取代之，用法神似

    https://github.com/junegunn/vim-plug

先github下载

    # vim 使用时加载     ~/.vim/autoload/
    # vim-plug 存放插件  ~/.vim/plugged/

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

然后修改  ~/.vimrc

```vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug 插件管理器官方配置

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
Plug '/usr/share/vim/addons/plugin/vim-airline'
Plug '/usr/share/vim/addons/plugin/vim-airline-themes'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" 在侧边显示git修改状态
Plug 'airblade/vim-gitgutter',

" 显示 vim 寄存器的内容
Plug 'junegunn/vim-peekaboo'

" 颜色主题 https://www.nordtheme.com/ports/vim
Plug 'arcticicestudio/nord-vim'

" 颜色主题 https://github.com/NLKNguyen/papercolor-theme
" Plug 'NLKNguyen/papercolor-theme'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 在下面增加自己的设置
```

然后 Reload .vimrc and :PlugInstall to install plugins.

##### 插件管理器 Vundle

优点是只需要编辑 ~/.vimrc，便于用户自定义，可惜自2019年之后不更新了

    https://github.com/VundleVim/Vundle.vim

先git安装 (会在子目录 autoload、ftplugin等增加内容)

    # Vundle使用    ~/.vim/bundle/
    # 自定义插件    ~/.vim/bundle/对应的插件/plugin/
    # 使用时加载    ~/.vim/bundle/对应的插件/autoload/

    git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

然后修改  ~/.vimrc 如下

```vim

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

##### .vimrc 配置文件样例

结合我自己使用的插件和 airline 的配置

```vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim 的一些默认设置，一般在全局配置文件 /etc/vim/vimrc 中都有

"set nonumber
set number  " 显示行号

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" 使用 vim-airline 并开启tabline设置后，就不需要这两个设置了
"set laststatus=2  " 始终显示状态栏
"set showtabline=2  " 始终显示标签页
set noshowmode  " 有了状态栏工具就可以省掉当前模式的显示

" 设置前导键为空格键，需要利用转义符“\”
let mapleader="\<space>"

" 如果终端工具已经设置了变量 export TERM=xterm-256color，那么这个参数可有可无
" 如果在 tmux 下使用 vim ，防止 tmux 默认设置 TERM=screen，应该保留此设置
" https://www.codenong.com/15375992/
"if &term =~? 'mlterm\|xterm'
if &term =="screen"
    set t_Co=256
endif

" 设置 netrw 的显示风格
"let g:netrw_hide = 1 " 设置默认隐藏
"let g:netrw_banner = 0  " 隐藏 netrw 顶端的横幅（Banner）
let g:netrw_browse_split = 4  " 用前一个窗口打开文件
let g:netrw_liststyle = 3  " 目录树的显示风格，可以用 i 键来回切换
let g:netrw_winsize = 25  " 设置 netrw 窗口宽度占比 25%
"let g:netrw_altv = 1 " 控制垂直拆分的窗口位于右边

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件管理器二选一：
"
"   见章节 [插件管理器 Vundle] VundleVim 插件管理器官方配置
"
"   见章节 [插件管理器 vim-plug] vim-plug 插件管理器官方配置

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-airline 内置扩展设置
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
let g:airline#extensions#tabline#enabled = 1
" 在说明文件中搜 airline-tabline 查看具体功能说明
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline#extensions#tabline#show_tab_nr = 1

let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#buffer_nr_show = 0  " 有一个就够了
let g:airline#extensions#tabline#fnametruncate = 16
let g:airline#extensions#tabline#fnamecollapse = 2

" 使用 airline 自带功能进行标签之间的切换
let g:airline#extensions#tabline#buffer_idx_mode = 1
" 定义切换 tab 和 buffer 的快捷键
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

" 启用 airline 内置主题：如果自行下载了主题，可以关闭这里
" 内置主题居然没有配套的 colorscheme，不用这个内置的了
"let g:airline_theme='papercolor'

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 语法高亮的彩色方案设置

" 防止某次关闭了语法高亮，下次打开vi则自动再打开
syntax enable

" 使用下载的主题插件自带的语法高亮的色彩方案
"colorscheme PaperColor
colorscheme nord

" 切换语法颜色方案使用亮色还是暗色，如果支持的话
"set background=dark
"set background=light

" 终端工具设置了背景透明以显示图片，如果你使用了配色方案以后设置背景色挡住了图片，开启这个设置强制透明
"hi Normal guibg=#111111 ctermbg=black
"hi Normal guibg=NONE ctermbg=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 使用下载的插件：NERDTree

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

经常遇到输乱了按键的情况，多按几次 Esc 保平安，然后重新输入即可

多看帮助吧

    :help Visual-mode

##### 文本输入模式（编辑模式/插入模式）

在普通模式下输入插入命令i、附加命令a、打开命令o、修改命令c、取代命令r或替换命令s都可以进入文本输入模式。

在该模式下，用户输入的任何字符都被 vi 当做文件内容缓存起来，并将其显示在屏幕上。

在文本输入过程中，若想回到普通模式下，按下 Esc 键即可。

##### 普通模式

在普通模式下输入：即可切换到命令行模式，然后输入命令后回车。

移动光标

    h,j,k,l  上，下，左，右

    ctrl-e   移动页面
    ctrl-f   上翻一页
    ctrl-b   下翻一页
    ctrl-u   上翻半页
    ctrl-d   下翻半页

    w    跳到下一个字首，按标点或单词分割
    W    跳到下一个字首，长跳，如end-of-line被认为是一个字

    e    跳到下一个字尾
    E    跳到下一个字尾，长跳

    b    跳到上一个字
    B    跳到上一个字，长跳

    0    跳至行首，不管有无缩进，就是跳到第0个字符
    ^    跳至行首的第一个字符

    $    跳至行尾

    gg   跳至文首，或 1g 跳到第一行，默认是在行首
    G    跳至文尾

    5gg     跳至第5行，或 5G
    ctrl-g  显示当前行位置

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
    :%s/old/new/gc  替换，搜索整个文件，将所有的 old 替换为 new，每次都要你确认是否替换

删除复制粘贴

    J     删除行尾的换行，将下一行和当前行连接为一行，中间用空格分隔，不添加空格使用命令 gJ。

    x     删除当前字符
    X     删除前一个字符

    dd    删除光标所在行
    dw    删除一个字(word)

    d$    删除到行末，或 D
    d^    删除到行首

    NOTE: 删除操作其实是剪切，详见下面章节 [vi中的删除是剪切操作--寄存器]

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

    s     删除当前字符并进入编辑模式，这个就省去 x + i 两个按键了
    S     删除光标所在行并进入编辑模式
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

##### 替换模式

    r   单字符替换模式，此时新输入的字符将替代光标之下的当前字符，然后自动返回到普通模式。

        在r命令中增加数字前缀，可以一次性替换多个字符。例如，将光标定位到“||”字符处，然后执行2r&命令，可以将其替换为“&&”。

    R   进入替换模式（屏幕底部显示“--REPLACE--”）。此时新输入的文本将直接替代/覆盖已经存在的内容，直至点击ESC键返回普通模式。

    gR 进入虚拟替换模式（virtual replace mode）（屏幕底部显示“--VREPLACE--”），其与替换模式最主要的区别在于，对<Tab>键和换行符的不同处理方式

        虚拟替换模式（VREPLACE）则将<Tab>键拆分为多个独立的空格来分别处理

        虚拟替换模式（VREPLACE）下，输入<Enter>回车键将用新行替代当前行内容（即清空当前行）

        gr命令，可以进入单字符虚拟替换模式。在替换光标下的当前字符之后，将自动返回到常规模式。

##### 可视模式(列块操作)

普通模式下按下列键进入可视模式

    按 v 键，然后加方向键（h、j、k、l）或者另外的四个方向键移动光标，从光标位置开始进逐字符的行多选，然后可以执行删除复制粘贴合并行等普通模式下的命令操作

    按 V 键是以行为单位的多选，操作同上

    按 Ctrl + v 键，从光标位置开始进逐字符的列多选，操作同上

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

    用 `c`将删除高亮选中的文本并进入插入模式，在你输入文本并点击Esc返回之后，输入的文本将插入到块选中的每一行里。

    用 `C` 会删除从选中文本到行尾的所有字符并进入插入状态。

    用 `A` 然后输入字符，所有的字符会添加到文本块后面。

    对高亮显示的文本块，我们可以用 `~` 进行大小写转换，用 `r` 替换单个字符，用 `>` 增加缩进，或用 `<` 减少缩进。

    对高亮显示的文本块，可以用 `o` 或 `O` 在块内移动光标，方便后续操作执行后光标的起始定位。

##### 命令行模式

在普通模式下，用户按冒号:键即可进入命令行模式下，此时 vi 会在显示窗口的最后一行（通常也是屏幕的最后一行）显示一个:作为命令行模式的说明符，等待用户输入命令。多数文件管理命令都是在此模式下执行的（如把编辑缓冲区的内容写到文件中等）。

命令行命令执行完后，vi 自动回到普通模式。

在vim中输入的命令，也可编辑 ~/.vimrc 文件配置。

退出编辑器

    即使缓冲区打开了多个文件，一次q就会全部退出，不需要挨个退出。

    如果有多个标签页或窗口，需要挨个执行q退出。
    :w      将缓冲区写入文件，即保存修改
    :wq     保存修改并退出
    :x      保存修改并退出
    :q      退出，如果对缓冲区进行过修改，则会提示
    :q!     强制退出，放弃修改

执行shell命令

    在普通模式下输入 ":sh"，可以运行一个shell，想回到vim编辑器中用`exit`或`ctrl+D`返回vim编辑器

    在普通模式下输入 ":!xxx"，在当前目录下运行指定的命令xxx，运行结束后自动回到 vim 编辑器中

    用 "Ctrl+Z" 回到shell，用 `fg` 返回 vim 编辑器中

##### 自定义快捷键

重新定义快捷键，放到 ~/.vimrc 文件中即可：

```vim

" 切换目录树显示的热键定义为 Ctrl-n
" map 是 vim 的快捷键映射命令
" <C-n> 定义了快捷键，表示 Ctrl-n
" 后面是对应的命令以及回车键 <CR>
map <C-n> :NERDTreeToggle<CR>

```

前缀代表生效范围

    inoremap 就只在插入(insert)模式下生效

    vnoremap 只在 visual 模式下生效

    nnoremap 就在 normal 模式下(狂按esc后的模式)生效

前导键

为解决 vim 中快捷键太多不够用的问题，又引入了前导键，即按一个热键松手，然后再按键，对应新的命令。

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

##### vim查看命令历史

命令行模式下：

    :history 查看所有命令行模式下输入的命令历史，按q退出

    :history search或 / 或？ 查看搜索历史

普通模式下：

    q:  查看命令行历史

    q/  查看使用/输入的搜索历史
    q?  查看使用？输入的搜索历史

##### 其它常用快捷键

内置插件 netrw 的快捷键，参见章节 [vim 内置的树形文件夹插件 netrw]

文件夹树形展示插件 nerdtree 的快捷键，参见章节 [nerdtree 树形文件夹插件]。

#### 理解vim的多文件操作（缓冲buffer）

    https://www.cnblogs.com/standardzero/p/10720922.html

vim 打开的多个文件，每个文件都会加载到缓冲区

    vim file1 file2 ... 同时打开多个文件，当前窗口只展现一个文件

    :next 切换到下个文件
    :prev 切换到前个文件

    :next！ 不保存当前编辑文件并切换到下个文件
    :prev！ 不保存当前编辑文件并切换到上个文件

    :wnext 保存当前编辑文件并切换到下个文件
    :wprev 保存当前编辑文件并切换到上个文件

在当前窗口默认只显示缓冲区中的一个文件

    :ls         显示缓冲区里的文件列表，即已经打开的文件列表

    :b num      切换显示文件（其中 num 为 buffer list 中的编号）
                NOTE: 缓冲中的编号不是1，2，3的顺序分布。

    :bn         切换显示下一个文件
    :bp         切换显示上一个文件

    Ctrl+6      在普通模式下的热键，切换到下一个文件

                对于用 split 在多个窗口中打开的文件，切换缓冲区文件的命令只会在当前窗口中切换不同的文件。

    :bd         关闭当前打开的缓冲区，单一窗口下也不会退出vim，或 :bdelete 。

    :q          退出vi，也就关闭全部缓冲区退出了。
                如果是 tab 标签页或 window 分割窗口打开的文件，则会关闭当前标签页或窗口。

    :qa!        丢弃所有缓冲区退出vim

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

vim 除了使用一个窗口显示所有缓冲区(只能来回切换)，还可以使用 tab 多标签化或 Window 多窗口化。

##### 多窗口(Window)操作

在 vim 术语中，窗口是缓冲区的显示区域。既可以打开多个窗口，在这些窗口中显示同一个文件，也可以在每个窗口里载入不同的文件。

    :sp    当前窗口水平切分为两个窗口，或 :split
    :vsp   当前窗口垂直切分为两个窗口，或 :vsplit

    前导 Ctrl+w，然后 方向键        切换到前／下／上／后一个窗口
    前导 Ctrl+w，然后  h/j/k/l     同上
    前导 Ctrl+w，然后  w           依次向后切换到下一个窗口中

    :qall    对所有窗口执行 :q  操作
    :qall!   对所有窗口执行 :q! 操作
    :wall    对所有窗口执行 :w  操作
    :wqall   对所有窗口执行 :wq 操作

##### 多标签页(Tab)操作

普通的文本编辑器中，标签页代表了当前打开的文件，在 Vim 中，标签页与缓冲区并非一一对应的关系。

把 vim 的标签页理解为多个窗口组成的一个工作区，每个标签页都可包含一个或多个窗口。

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

###### 使用 alt+数字键 来切换 tab 标签页

建议使用 vim-airline 自带的功能进行 tab 和 Buffer 之间的切换，见章节 [.vimrc配置文件样例]。

自定义热键用 Alt 总是设置不上，用的 Ctrl+w 解决了，不知道咋回事，待研究。

或自定义

    https://blog.csdn.net/ghostyusheng/article/details/77893780

用 gt, gT 来一个个切换有点不方便, 如果用 :tabnext {count}, 又按键太多.

可以用 alt + n 来切换tab标签, 比如按 alt + 1 切换到第一个 tab，按 alt + 2 切换到第二个 tab。

把以下代码加到你的 .vimrc 文件, 或者存为 .vim 文件，然后放到 plugin 目录

```shell

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

鼠标模式 :set mouse= 的参数说明

    n   普通模式
    v   可视模式
    i   插入模式
    c   命令行模式
    h   在帮助文件里，以上所有模式
    a   以上所有模式
    r   跳过|lit-enter|提示
    A   在可视模式下自动选择

'mouse' 的缺省值为空，即不响应鼠标

    这时用鼠标在 vim 中选择，会进入可视模式，但只响应终端工具的右键菜单操作，而不会响应vim自己的热键操作。

    也就是说，你用鼠标进入的这个可视模式，vim 不会响应热键做y复制、d删除等操作。

打开鼠标功能，就会使你的vim响应你的鼠标选择了，即在鼠标选择进入的可视模式中，你可以使用vim热键了

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

#### vi中的删除是剪切操作--寄存器

    vim中没有删除，实际上都是剪切，黑洞寄存器除外

你以为用 x、dw、dd 啥的删除了东西，其实删除的会替换最近的无名寄存器。

    如果复制了内容想替换，直接ctrl+v进入可视模式，选好了之后直接按p粘贴即可覆盖原内容。

测试文件

    echo abc > test.txt
    echo xyz >> test.txt

比如，你复制了"abc"，想替换文件中的"xyz"。

如果你的操作是

    先v..y复制"abc"，然后dw删除"xyz"，然后按p粘贴，你会发现粘贴的还是"xyz"

原因是

    你执行的 yy 命令 其实是 ""yy，不指定就是默认的无名寄存器

    vi把删除的内容也放到无名寄存器，冲了。。。

导致vim的删除然后粘贴操作是有顺序依赖的

    先dw删除"xyz"，然后v..y复制"abc"，然后按p粘贴，你才能粘贴上"abc“

或者粘贴的时候，选择使用"0复制寄存器，然后粘贴操作即可

    "0p 把刚才复制的内容粘贴上

查看系统寄存器

    :reg

    Name       Content
    ""       x、s、d{motion}、c{motion}和y{motion}指令都会覆盖无名寄存器中的内容，按p会粘贴回去
    "0       y{motion}指令 存储复制内容
    "1       104.188^J
    "2       4.117^J
    ...
    "-       上一次删除的文本
    ".       上一次插入的文本
    "*       系统剪贴板
    "%       当前文件的名字
    "/       上一次查找的字符串
    ":       上次执行的命令

普通模式下使用寄存器，直接使用 "开头的寄存器名称加命令 操作即可

    "0p     从0号寄存器粘贴内容

    "+y    将内容复制到系统剪切板中，供其他程序使用

    使用系统剪贴板粘贴还是先进入文本模式，然后按 shift + Ins

    这里说的系统剪贴板，通过终端工具，使用的是用户操作系统的剪贴板。

插入模式下使用寄存器，比如：在文本输入模式，使用寄存器里的内容

    使用热键 <C-r> 做前导即可: <C-r>0  从0号寄存器粘贴内容

用 / 输入搜索内容 或 : 命令行模式 都可用这个方法使用寄存器里的内容。

也可以设置vim默认使用系统剪贴板 <https://www.cnblogs.com/huahuayu/p/12235242.html>

    确定vim支持 +clipboard后，如果想 y/p 直接和系统剪贴板打通，可以在~/.vimrc中加上以下配置）：

        set clipboard^=unnamed,unnamedplus

    其中unnamed代表 *寄存器，unnamedplus 代表 +寄存器。在mac系统中，两者都一样；一般在linux系统中+和*是不同的，+对应ctrl + c,ctrl + v的桌面系统剪贴板，*对应x桌面系统的剪贴板（用鼠标选择复制，用鼠标中键粘贴）。

可以给 vim 安装个插件在按到对应热键时显式寄存器内容

    https://github.com/junegunn/vim-peekaboo

### tmux 不怕断连的多窗口命令行

开启tmux后，可以有多个 session，每个 session 管理多个 window，每个window还可以划分多个面板，每个面板都运行一个shell。

任意的非 tmux shell 可以 attach 到你的 session。

只要不主动退出 shell，或重启计算机，任何时候都可以通过attach的方式回到你的操作界面。

    tmux的使用方法和个性化配置 http://mingxinglai.com/cn/2012/09/tmux/

    Tmux使用手册 http://louiszhai.github.io/2017/09/30/tmux/

    http://man.openbsd.org/OpenBSD-current/man1/tmux.1

如果感觉 tmux/screen 用起来比较麻烦，有个前端替代品（后端调用 tmux 进程）

    https://github.com/dustinkirkland/byobu

如果 tmux 开启的会话较多，希望重启后能一次性恢复

    https://github.com/tmux-python/tmuxp

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

这些命令在tmn的:命令行模式一样可以使用

    tmux

        新建一个会话，并连接

    tmux ls

        列出当前的会话（tmux session），下面表示0号有2个窗口
            0: 2 windows (created Tue Apr 13 17:28:34 2021)

    tmux a

        进入tmux，直接回到上次退出前的那个会话的那个窗口的那个分屏

    tmux new -s mydevelop

        创建一个新会话名为 mydevelop，并连接

    tmux a -t mydevelop

        进入tmux，连接到名为 mydevelop 的会话，如果有人已经连接，则进入双人共用模式，互相操作可见

    #  ssh -t localhost tmux  a
    tmux new-session -s username -d

        创建一个全新的 tmux 会话 ，在开机脚本(Service等）中调度也不会关闭
        https://stackoverflow.com/questions/25207909/tmux-open-terminal-failed-not-a-terminal

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

    # 重新加载当前的 Tmux 配置
    tmux source-file ~/.tmux.conf

#### 快捷键

    组合键 ctrl+b 作为前导，松开后再按其它键如下

会话（Session）

tmux可以有多个会话，每个会话里可以有多个窗口，每个窗口又可以拆分成多个面板，在窗口中各种排列。

    ?       显示所有快捷键，使用pgup和pgdown翻页，按q退出(其实是在vim里显示的，命令用vim的)

    :       进入命令行模式，可输入命令如：
                show-options -g  # 显示所有选项设置的参数，使用pgup和pgdown翻页，按q退出
                set-option -g display-time 5000 # 提示信息的持续时间；设置足够的时间以避免看不清提示，单位为毫秒

    s       列出当前会话
            下面表示0号会话有2个窗口，是当前连接，1号会话有1个窗口
                (0) + 0: 2 windows (attached)
                (1) + 1: 1 windows

    w       列出当前会话的所有窗口，通过上、下键切换，
            新版的按树图列出所有会话的所有窗口，切换更方便，不需要s键了。

    $       重命名当前会话；这样便于识别

    [       copy-mode模式，用于查看历史输出（默认只显示一屏），使用pgup和pgdown翻页，按q退出

    d       脱离当前会话返回Shell界面，tmux里面的所有会话继续运行，
            会话里面的程序不会退出在后台保持继续运行。
            如果操作系统突然断连，也是相同的效果，
            下次在命令行运行`tmux a`能够重新连接到之前的会话

窗口（Window）

    c       创建新窗口，状态栏会显示窗口编号
    w       列出当前会话的所有窗口，通过上、下键切换，新版的按树图列出所有会话的所有窗口，切换更方便
    数字0-9  切换到指定窗口
    n       切换到下一个窗口
    p       切换到上一个窗口
    ,       重命名当前窗口；这样便于识别
    .       修改当前窗口编号；相当于窗口重新排序

面板（pane）

窗口可以拆分为面板，默认情况下在一个窗口中只有一个面板，占满整个窗口区域。每个面板都运行一个shell，这是给用户界面切分的最小单位了。

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

    t       在当前面板显示一个时钟，等于在当前面板的shell里执行命令 `tmux clock`，按q退出。

如果在shell中执行命令exit，退出的顺序如下：

    先退出当前面板，返回到当前窗口的上一个面板，

    如果没有面板可用，则退出当前窗口，返回到当前会话的上一个窗口的某个面板，

    如果当前会话的所有窗口都退出了，当前的会话就会被关闭并退出tmux，但其他会话继续运行。

    x       关闭当前面板，并自动切换到下一个，
            操作之后会给出是否关闭的提示，按y确认即关闭。
            等同于当前的 unix shell 下 ctrl+d 或输入 exit 命令。

    &       关闭当前窗口， 并自动切换到下一个，
            操作之后会给出是否关闭的提示，按y确认即关闭。
            等同于当前所有面板的unix shell下Ctrl+d或输入exit命令。

#### tmux 的 copy 模式 -鼠标或光标选择

前导键 + [ 进入 tmux 的 copy-mode，默认按键使用 Emacs 模式

    按空格键进入选择模式，然后移动光标进行选择，再按回车键复制并退出，按 q 不复制并退出

    不会复制到系统剪贴板，由 tmux 自行管理，在命令行执行 `tmux show-buffer` 显示复制的内容

    前导键 + ] 粘贴复制的内容

在 tmux 里运行 vim 复制到 Windows 剪贴板

    直接用鼠标选择的时候，是由 vim 处理的，需要按住 shift 进行选择，才会复制到系统剪贴板

    后来用vnc连server发现在vim中也是同样适用的。

查看历史输入时的翻页、移动光标、切换选择窗口等方向键绑定使用 vi 模式，原默认是 emacs 模式

    set-window-option -g mode-keys vi

##### 建议开启鼠标滚屏

    set-option -g mouse on

可以用鼠标在状态栏选择切换窗口了。

可以用鼠标点击窗口的切分面板，自动把光标切换到该面板。

可以用滚轮方便的查看历史输出，按 q 退出。

右键单击tmux面板，该面板的边框会加粗显示，脚本里可以引用，界面操作无感，就是给该面板做个标记，状态栏对应的窗口名会出现 M 字样。

不过，在终端工具中常用的鼠标右键粘贴等就不能用了，需要换个操作方式：

    鼠标选择前，按住 Shift 键，然后点击鼠标左键拖动选择，即可复制到系统剪贴板，熟悉的中键又回来了。

    在文本输入模式，用 Shift+Insert 可将系统剪切板中的内容输入 tmux 中。

相对于 tmux 原生的选择模式（不加 shift 键），使用系统选择有个缺陷，即当一行内存在多个面板时，无法选择单个面板中的内容，这时就必须使用 tmux 自带的复制粘贴系统了ctrl+shift+c/v。

#### tmux 开机自启动

开机脚本，自动启动tmux服务，运行指定的程序。

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

    https://bobbyhadz.com/blog/tmux-powerline-ubuntu

要设置状态栏彩色，包括tmux中vim使用彩色，需要编辑 ~/.tmux.conf 文件，添加如下行

    # 如果终端工具已经设置了变量 export TERM="xterm-256color"，那么这个参数可有可无
    set -g default-terminal "screen-256color"

一、状态栏显示使用 powerline

先安装 powerline，见章节 [状态栏工具 powerline]。

tmux使用powerline，编辑 ~/.tmux.conf 文件，添加如下行

    run-shell 'powerline-config tmux setup'

然后就可以自由发挥了。

如果不使用 powerline，可以安装 tmux-powerline，这个只使用bash脚本，更简洁

    https://github.com/erikw/tmux-powerline

二、插件管理

感觉这个就别折腾各种插件了。。。

    https://github.com/tmux-plugins/tpm

        高亮关键字 https://github.com/tmux-plugins/tmux-prefix-highlight

三、安装nord主题，替换 powerline 状态栏显示

使用这个主题的好处是它支持<https://github.com/tmux-plugins>的所有插件，在状态栏显示各种字符，启动速度也比 powerline 快。

    颜色方案 https://www.nordtheme.com/ports/tmux
        https://github.com/arcticicestudio/nord-tmux

不使用插件管理器的安装步骤：

先从github下载

    git clone --depth=1 https://github.com/arcticicestudio/nord-tmux ~/.tmux/themes/nord-tmux

##### 定制 powerline 的段Segment

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

# 设置状态栏工具显示彩色
# 如果终端工具已经设置了变量 export TERM="xterm-256color"，那么这个参数可有可无
set -g default-terminal screen-256color

# 状态栏使用 nord 主题，替换掉 powerline
# run-shell 'powerline-config tmux setup'
run-shell "~/.tmux/themes/nord-tmux/nord.tmux"

```

重新加载配置文件

    tmux source-file ~/.tmux.conf

#### 类似的工具 screen

在Screen环境下，所有的会话都独立的运行，并拥有各自的编号、输入、输出和窗口缓存。用户可以通过快捷键在不同的窗口下切换，并可以自由的重定向各个窗口的输入和输出。Screen实现了基本的文本操作，如复制粘贴等；还提供了类似滚动条的功能，可以查看窗口状况的历史记录。窗口还可以被分区和命名，还可以监视后台窗口的活动。 会话共享 Screen可以让一个或多个用户从不同终端多次登录一个会话，并共享会话的所有特性（比如可以看到完全相同的输出）。它同时提供了窗口访问权限的机制，可以对窗口进行密码保护。

    sudo apt install screen

会列出当前存在的会话列表

    $ screen -ls
    There are screens on:
            # 会话名格式 [[pid.]tty[.host]]
            335.pts-4.jn-zh (08/07/22 17:56:22)     (Detached)
            29396.pts-4.jn-zh       (08/07/22 17:47:42)     (Detached)
    2 Sockets in /run/screen/S-pi.

连接到已有的会话，用上面看到的系统给出的默认会话名或pid即可。

    screen -r 29396

创建一个名字为lamp的会话并连接到该会话

    screen -S lamp

连接到会话以后就可以执行操作了，在此期间，可以随时关闭SSH,或自己的电脑，会话中的程序不会关闭，仍在运行。

特殊：如果你在另一台机器上没有分离一个Screen会话，就无从再次连接这个会话。

    screen -d <作业名称> 　将指定的screen会话离线。

    screen -m <作业名称> 　即使目前已在作业中的screen作业，仍强制建立新的screen会话。

    screen -R <作业名称> 　先试图恢复离线的会话。若找不到离线的作业，即建立新的screen会话。

    screen -wipe 　检查目前所有的screen作业，并删除已经无法使用的screen作业。

当需要退出当前的screen界面回到初始的shell，可以用快捷键Ctrl+a d(即按住Ctrl按a,然后可以松手去按d)，会话中的程序不会关闭，仍在运行。

关闭screen会话中的窗口

    # 在screen会话里的shell执行 或热键 Ctrl+a k
    exit

如果一个Screen会话中最后一个窗口被关闭了，那么整个Screen会话也就退出了，screen进程会被终止。

常用快捷键，先按引导键 Ctrl+a，然后按

    d :     退出当前的screen界面回到初始的shell，当前运行的会话进程不关闭，其中的程序会继续运行

    c ：    在当前screen会话中创建窗口

    w ：    数字显示窗口列表
    " :     上下光标键可选择的窗口列表
    C-a  ： 在两个最近使用的 window 间切换
    [Space]  ： 由视窗0循序切换到视窗9
    0-9 ：  在第0个窗口和第9个窗口之间切换
    n ：    下一个窗口
    p ：    上一个窗口

    x:      锁屏(需要你有该Linux登录用户的登录密码才能解锁，否则，当前的会话终端算是废了，你需要重新打开一个终端才行)(锁屏后，重新登录一个设置过密码的screen会话，你需要输入2次密码，第一次是输入Linux系统的登录密码，第二次是输入该screen会话的密码)

    S ：   屏幕水平分割
    | ：   屏幕垂直分割
    [tab]： 在各个区块间切换，每一区块上需要再次用 Ctrl+a c 创建窗口。
    X：     关闭当前焦点所在的屏幕区块,关闭的区块中的窗口并不会关闭，还可以通过窗口切换找到它。
    Q：     关闭除当前区块之外其他的所有区块,关闭的区块中的窗口并不会关闭，还可以通过窗口切换找到它。

会话共享

还有一种比较好玩的会话恢复，可以实现会话共享。假设你在和朋友在不同地点以相同用户登录一台机器，然后你创建一个screen会话，你朋友可以在他的终端上命令：

    screen -x

这个命令会将你朋友的终端Attach到你的Screen会话上，并且你的终端不会被Detach。这样你就可以和朋友共享同一个会话了，如果你们当前又处于同一个窗口，那就相当于坐在同一个显示器前面，你的操作会同步演示给你朋友，你朋友的操作也会同步演示给你。当然，如果你们切换到这个会话的不同窗口中去，那还是可以分别进行不同的操作的。

### Aria2 下载工具

命令行传输各种参数，设置复杂，Windows下下载开源的GUI程序 [Motrix](https://github.com/agalwood/Motrix) 即可，该软件最大的优点是自动更新最佳dht站点清单。

    aria2c.exe --conf-path=C:\tools\Motrix\resources\engine\aria2.conf --save-session=C:\Users\XXXX\AppData\Roaming\Motrix\download.session --input-file=C:\Users\XXXX\AppData\Roaming\Motrix\download.session --allow-overwrite=false --auto-file-renaming=true --bt-load-saved-metadata=true --bt-save-metadata=true --bt-tracker=udp://93.158.213.92:1337/announce,udp://151.80.120.115:2810/announce  --continue=true --dht-file-path=C:\Users\XXXX\AppData\Roaming\Motrix\dht.dat --dht-file-path6=C:\Users\XXXX\AppData\Roaming\Motrix\dht6.dat --dht-listen-port=26701 --dir=C:\Users\XXXX\Downloads --listen-port=21301 --max-concurrent-downloads=5 --max-connection-per-server=64 --max-download-limit=0 --max-overall-download-limit=0 --max-overall-upload-limit=256K --min-split-size=1M --pause=true --rpc-listen-port=16800 --rpc-secret=evhiwwwwwDiah --seed-ratio=1 --seed-time=60 --split=64 --user-agent=Transmission/2.94

浏览器搜索插件：aria2 相关，安装后设置aip-key，可在浏览器中直接调用Motrix运行的aria2进程。

### 压缩解压缩

.tar.gz 文件

    # 打包并压缩，可以是多个文件或目录名
    # 去掉 z 就是只打包，生成 .tar 文件，其它参数相同
    # 把 z 换成 j 就是压缩为.bz2文件，而不是.gz文件了
    tar -czvf arc.tar.gz file1 file2
    tar -cjvf arc.tar.bz2 file1 file2

    # 解包并解压缩, 把 x 换成 t 就是只查看文件列表而不真正解压
    tar -xzvf arc.tar.gz
    tar -jxvf xx.tar.bz2

.gz 文件

    # 解压
    gunzip FileName.gz

    gzip -d FileName.gz

    # 压缩，生成同名文件，后缀.gz，原文件默认删除，除非使用 -k 参数保留
    gzip FileName

    # 列出指定文件列表并压缩
    ls |grep -v GNUmakefile |xargs gzip

    # 查看内容
    zcat usermod.8.gz

.zip 文件

    # 解压缩zip
    unzip arc.zip -d your_unzip_dir

    # 压缩文件，生成新文件，并添加 .zip 后缀的文件

    zip arc file1.txt file2.txt ...

    # 打包压缩目录
    zip -r arc.zip foo1/ foo2/

    # 查找匹配的 c 语言文件并打包压缩
    find . -name "*.[ch]" -print | zip source_code -@

    tar cf - . | zip backup -

    # 只查看文件列表
    unzip -l arc.zip

### 文件链接

ln 命令默认生成硬链接，但是我们通常使用软连接

    # 主要是给出链接的目标文件，可以多个，最后的是保存软链接的文件目录
    # 如果省略最后的目录，默认就是当前目录保存，软连接文件名默认跟目标文件同名
    # 如果最后的目录给出的是一个文件名，则就是在当前目录下建立软链接文件
    ln -s /tmp/cmd_1 /tmp/cmd_2 /usr/bin/

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

### 生成随机数

    https://huataihuang.gitbooks.io/cloud-atlas/content/os/linux/device/random_number_generator.html

在 Linux 中，有两类用于生成随机数的设备，分别是 /dev/random 以及 /dev/urandom ，其中前者可能会导致阻塞，而读取 /dev/urandom 不会堵塞，不过此时 urandom 的随机性弱于 random 。 urandom 是 unblocked random 的简称，会重用内部池中的数据以产生伪随机数据，可用于安全性较低的应用。

    # sha256sum md5sum
    $ head /dev/random | cksum
    3768469767 1971

    $ cat /dev/urandom | od  -An -x | head -n 1
    0637 34d5 16f5 f393 250e a2eb aac0 27c3

    $ cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 14
    cFW4vaqucb4K4T

    $ cat /proc/sys/kernel/random/uuid
    6ab4ef55-2501-4ace-b069-139855bea8dc

    $ openssl rand -base64 14
    lPIm1hobPBr+iaUXLSk=

    $ openssl rand -hex 20
    f231202787c01502287c420a8a05e960ec8f5129

    $ gpg --gen-random --armor 1 14
    RaJKEUBT89Tq9uZzvkI=

    # python3.6 增加了标准库 secrets
    genernator = secrets.SystemRandom()
    genernator.choice([3, 4, 5])
    genernator.randint(0, 50)
    genernator.uniform(2.5, 13.8)
    # secrets.token_urlsafe()  # base64
    url = 'https://mydomain.com/reset=' + secrets.token_urlsafe()
    secrets.token_bytes(nbytes=10)
    secrets.token_hex()
    # 判断相等或不等的耗时一致，抵抗计时攻击
    secrets.compare_digest('50','500')

补充熵池

随机数生成的这些工具，通过 /dev/random 依赖系统的熵池，而服务器在运行时，既没有键盘事件，也没有鼠标事件，那么就会导致噪声源减少。很多发行版本中存在一个 rngd 程序，用来增加系统的熵池（用 urandom 给 random 灌数据），详见章节 [给random()增加熵] <init_a_server.md think>。

### od 按数制显示内容

    od [-A<字码基数> ] [-t[TYPE][SIZE] ] 文件名

-A<字码基数>  左侧显示的地址使用何种基数

    o：八进制（系统默认值）
    d：十进制
    x：十六进制
    n：不打印位移值

主要关心输出格式-t

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

快速参数

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

    # 以 ASCII 码的形式显示文件aa.txt内容
    od -tc aa.txt

    # 以 ASCII 码 和 16 进制的形式显示文件aa.txt内容
    od -tcx aa.txt

    # 以 ASCII 码的形式显示文件aa.txt内容的，等效 -ta
    od -a aa.txt

### find + grep + xargs 组合按内容查找文件

查找指定文件

    find ./ -name 2.sql

组合查找文件内容

显示内容，但是带目录了

    find ./ -name "*" -exec grep "gitee" {} \;

显示内容，排除目录

    find ./ -name "*" -type f -exec grep -in "gitee" {} \;

显示内容，显示文件名和行号，排除目录

    find ./ -name "*" -type f | xargs grep -in 'gitee'

xargs 命令是给其他命令传递参数的一个过滤器，常作为组合多个命令的一个工具。它主要用于将标准输入数据转换成命令行参数，xargs 能够处理管道或者标准输入并将其转换成特定命令的命令参数。也就是说 find 的结果经过 xargs 后，其实将 find 找出来的文件名逐个作为了 grep 的参数。grep 再在这些文件内容中查找关键字 test。

### 字符串处理 awk sed cut tr wc

tr 删除字符，主要用于截取字符串

    $ echo "throttled=50.0"| tr -d "throttled="
    50.0

cut 按分隔符打印指定的字段

    $ cat /etc/passwd| cut -d ':' -f7
    /bin/bash
    /usr/sbin/nologin
    /bin/sync
    /usr/sbin/nologin

awk 指定分隔符，可以用简单的语句组合字段

sed 删除、替换文件中的字符串

    # 在文件的匹配行前面加上#注释
    #   // 模式匹配，可匹配文字中的空格，后面的替换操作是在匹配到的行中找的
    #   s:替换
    #   ^:开头匹配
    #   [^#]:匹配非#
    #   #&:用&来原封不动引用前面匹配到的行内容，在其前面加上#号
    #   g:全部（只匹配特定行不加）
    sed '/^static domain_name_servers=8.8.8.8/ s/^[^#].*domain_name_servers.*/#&/g' /etc/dhcpcd.conf

    # 在文件的匹配行前面取消#注释
    #   // 模式匹配，可匹配文字中的空格，后面的替换操作是在匹配到的行中找的
    #   ^#//:去掉代表开头的#

    sed '/^#static domain_name_servers=192.168.1.1/ s/^#//' /etc/dhcpcd.conf

    # 给所有没有#开头的行改为#开头
    sed 's/^[^#]/#&/' /etc/dhcpcd.conf

    选项与参数：

        -n ：使用安静(silent)模式。在一般 sed 的用法中，所有来自 STDIN 的数据一般都会被列出到终端上。但如果加上 -n 参数后，则只有经过sed 特殊处理的那一行(或者动作)才会被列出来。
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

wc -l 计算文本文件的行数，用于 vi 打开大文件之前先评估

    wc -l README.rst

grep -n 显示要找的字符串所在的行号 -i 忽略大小写

    $ grep -in 'apt-get' README.rst
    20:     sudo apt-get install fonts-powerline

### nc 监听端口的简单通信

    sudo apt update && sudo apt -y install ncat

    nc -l <端口>

    nc 192.168.200.27 <端口>
    然后直接输入文字即可简单通信

对本机端口转发来说，nc是个临时的端口转发的好工具，永久的端口转发用iptables。

### scp 跨机远程拷贝

前提条件

    可以 ssh 登陆才能 scp 文件

基本用法

    后缀有没有目录标识‘/’导致拷贝为目录下或目录名

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

### rsync 文件同步

    http://c.biancheng.net/view/6121.html

    https://www.ruanyifeng.com/blog/2020/08/rsync.html

用于增量备份（只复制有变动的文件），同步文件或目录，支持远程机器。

默认使用文件大小和修改时间决定文件是否需要更新。

rsync 命令提供使用的 OPTION 及功能

    OPTION选项    功能

    -a    这是归档模式，表示以递归方式传输文件，并保持所有属性，它等同于-r、-l、-p、-t、-g、-o、-D 选项。-a 选项后面可以跟一个 --no-OPTION，表示关闭 -r、-l、-p、-t、-g、-o、-D 中的某一个，比如-a --no-l 等同于 -r、-p、-t、-g、-o、-D 选项。

    -r    以递归模式处理子目录，它主要是针对同步目录来说的，如果单独传一个文件不需要加 -r 选项，但是传输目录时必须加。 --relative /var/www/uploads/abcd

    -v    打印一些信息，比如文件列表、文件数量等。

    -n    模拟命令执行的结果，并不真的执行命令(--dry-run) 。

    -l    保留软链接，默认不处理软链接文件。

    -L    像对待常规文件一样处理软链接。如果是 SRC 中有软链接文件，则加上该选项后，将会把软链接指向的目标文件复制到 DEST，默认不处理软链接文件。

    -H    保留硬链信息

    -p    保持文件权限。

    -o    保持文件属主信息。

    -g    保持文件属组信息。

    -D    保持设备文件信息。

    -t    保持文件时间信息。

    --delete  多次备份时源目录中已经删除的文件也会在目标目录中删除，默认会保留。默认情况下，rsync 只确保源目录的所有内容（明确排除的文件除外）都复制到目标目录，它不会使两个目录保持相同，并且不会删除文件。如果要使得目标目录成为源目录的镜像副本，则必须使用--delete参数，这将删除只存在于目标目录、不存在于源目录的文件。

    --exclude=PATTERN    指定排除不需要传输的文件，等号后面跟文件名，可以是通配符模式（如 *.txt）。

    --progress    在同步的过程中可以看到同步的过程状态，比如统计要同步的文件数量、 同步的文件传输速度等。

    -u    把 DEST 中比 SRC 还新的文件排除掉，不会覆盖。
    -z    加上该选项，将会在传输过程中压缩。

    --append-verify 指定文件接着上次中断的地方，继续传输。对传输完成后的文件进行一次校验。如果校验失败，将重新发送整个文件。

    --checksum      使用校验和判断文件变更，等同参数 -c

    --size-only     只同步大小有变化的文件，不考虑文件修改时间的差异。

以上也仅是列出了 async 命令常用的一些选项，对于初学者来说，记住最常用的几个即可，比如 -a、-v、-z、--delete 和 --exclude。

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

在 rsync 命令中的远程操作，如果使用单个冒号（:），则默认使用 ssh 协议；反之，如果使用两个冒号（::），则使用 rsync 协议。ssh 协议和 rsync 协议的区别在于，rsync 协议在使用时需要额外配置，增加了工作量，但优势是更加安全；反之，ssh 协议使用方便，无需进行配置，但有泄漏服务器密码的风险。

远程操作的rsync协议

rsync://协议（默认端口873）进行传输。具体写法是服务器与目标目录之间使用双冒号分隔`::`。

    # module并不是实际路径名，而是 rsync 守护程序指定的一个资源名，由管理员分配
    rsync -av source/ 192.168.122.32::module/destination

    # rsync 守护程序分配的所有 module 列表
    rsync rsync://192.168.122.32

    # 除了使用双冒号，也可以直接用rsync://
    rsync -av source/ rsync://192.168.122.32/module/destination

#### 示例

一般使用中，最常用的归档模式且输出信息用参数 `-v -a`，一般合写为 `-av`。

注意区分：源目录是否写'/'处理方式的不同

    # 源目录 source 中的内容复制到了目标目录 destination 中，不建立source子目录的方式

    rsync -av  source/ destination

    # 源目录 source 被完整地复制到了目标目录 destination 下面，source成为子目录
    rsync -av source destination

如果不确定 rsync 执行后会产生什么结果，先模拟跑下看看输出

    rsync -anv source/ destination

其它多个用法

    # 同步时排除某些文件或目录，可以用多个--exclude
    rsync -av --exclude='*.txt' source/ destination

    # rsync 会同步以"点"开头的隐藏文件，如果要排除隐藏文件
    rsync -av --exclude=".*" source/ destination

    # 排除某个目录里面的所有文件，但不希望排除目录本身
    rsync -av --exclude 'dir1/*' source/ destination

    # 排除一个文件列表里的内容，每个模式一行
    rsync -av --exclude-from='exclude-file.txt' source/ destination

    # 同步时，排除所有文件，但是不排除 txt 文件
    rsync -av --include="*.txt" --exclude='*' source/ destination

使用基准目录，即将源目录与基准目录之间变动的部分，同步到目标目录，注意这个是三方。

    # 目标目录中，也是包含所有文件，只有那些变动过的文件是存在于该目录，其他没有变动的文件都是指向基准目录文件的硬链接。
    rsync -a --delete --link-dest /compare/path /source/path /target/path

默认使用 SSH 进行远程登录和数据传输

    # 将本地内容，同步到远程服务器
    rsync -av source/ username@remote_host:destination

    # 将远程内容同步到本地
    rsync -av username@remote_host:source/ destination

    # 如果 ssh 命令有附加的参数，则必须使用-e参数指定所要执行的 SSH 命令
    rsync -av -e 'ssh -p 2234' source/ user@remote_host:/destination

#### 软硬链接文件的处理区别

默认是保留软链接。

    https://zhuanlan.zhihu.com/p/365239653

普通的操作中，软链接不做处理

    # 如果 your_dir_or_file 是个文件，会拷贝到目标目录下
    # 如果 your_dir_or_file 是个目录，会在目标目录下建立子目录，内容拷贝过去
    rsync -av /etc/letsencrypt/live/your_dir_or_file root@remote:/etc/letsencrypt/live

使用原则

    如果是单独拷贝文件，软链接只是个引用，硬链接是文件实体，参数有区别。

    如果是拷贝一个目录结构，内部的软链接指向目录内的文件实体，则应该保持软链接拷贝文件实体，如果内部的软链接指向外部目录的文件实体，应该拷贝文件实体，参数有区别。

如果需要拷贝软链接对应的实体文件，用参数 -L 。

示例：

拷贝一个目录结构，目录内的软链接文件处理为实体文件，拷贝到远程

    # -r 参数 在目的目录内递归的生成源目录结构的子目录，目的目录需要提前建好（`mkdir -p /etc/letsencrypt/live`），否则会报错
    # -L 参数 拷贝软链接对应的实体文件
    rsync -avrL /etc/letsencrypt/live/your_dir_or_file   root@remote:/etc/letsencrypt/live
    # 等效-avrL .................live/your_dir_or_file/  remote.......................live/your_dir_or_file

拷贝一个软链接文件处理为实体文件

    # 只是普通的文件去掉 -L 参数即可
    rsync -avL /etc/letsencrypt/live/your_dir_or_file/cert.pem root@remote:/etc/letsencrypt/live/your_dir_or_file

#### 示例脚本：备份用户的主目录

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

### 压力测试

    sudo apt install stress-ng

    stress-ng -c 2 --cpu-method pi --timeout 60
    stress-ng -i 1 --timeout 60
    stress-ng -m 1 --timeout 60

cpu 压力测试，入参是cpu的核心数

```shell

#!/bin/bash
# Destription: testing cpu usage performance
# Example    : sh cpu_usage.sh 12
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

### 操作时间时区 timedatectl

    https://www.cnblogs.com/zhi-leaf/p/6282301.html

### 设置替换命令 update-alternatives

linux 版本历经多年的使用，有些命令会出现各种变体，为保持通用，用符号链接的方式统一进行管理

    update-alternatives --all

设置 vi 的变体

查看实际使用版本

    $ readlink -f `which vi`
    /usr/bin/vim.tiny

设置替换版本

    update-alternatives --config vi

## 开机启动 SystemV(init) 和 systemd

    https://www.debian.org/doc/manuals/debian-handbook/unix-services.zh-cn.html#sect.systemd

    https://zhuanlan.zhihu.com/p/140273445

    http://ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html

Linux 引导

Linux 主机从关机状态到运行状态的完整启动过程很复杂，但它是开放的并且是可知的。在详细介绍之前，我将简要介绍一下从主机硬件被上电到系统准备好用户登录的过程。大多数时候，“引导过程”被作为一个整体来讨论，但这是不准确的。实际上，完整的引导和启动过程包含三个主要部分：

    硬件引导：初始化系统硬件
    Linux 引导(boot)：加载 Linux 内核和 systemd
    Linux 启动(startup)：systemd 为主机的生产性工作做准备

Linux 启动阶段始于内核加载了 init 或 systemd（取决于具体发行版使用的是旧的方式还是还是新的方式）之后。init 和 systemd 程序启动并管理所有其它进程，它们在各自的系统上都被称为“所有进程之母”。

### SystemV

unix systemV以来的习惯是使用 Bash 脚本来完成启动。

内核启动 init 程序（这是一个编译后的二进制）后，init 启动 rc.sysinit 脚本，该脚本执行许多系统初始化任务。

rc.sysinit 执行完后，init 启动 /etc/rc.d/rc 脚本，该脚本依次启动 /etc/rc.d/rcX.d 中由 SystemV 启动脚本定义的各种服务。其中 X 是待启动的运行级别号。这些级别在/etc/inittab 文件里指定。

比如，在命令行进入单机模式的命令是 `init 1`

    0 - 停机

    1 - 单用户模式

    2 - 多用户，没有 NFS

    3 - 完全多用户模式(标准的运行级)

    4 - 没有用到

    5 - X11 （xwindow)

    6 - 重新启动

init 程序最先运行的服务是放在 /etc/rc.d/ 目录下的文件。

在大多数的Linux 发行版本中，启动脚本都是位于 /etc/rc.d/init.d/ 中的，这些脚本被用 ln 命令连接到 /etc/rc.d/rcX.d/ 目录。(这里的X 就是运行级0-6) ,每个不同级别的目录都链接了 /etc/rc.d/init.d/ 中的一个脚本。

所有这些程序都是可读的shell脚本。SystemV 服务是串行启动的，一次只能启动一个服务，每个启动脚本都被编了号，以便按特定顺序启动预期的服务。可以通读这些脚本确切了解整个启动过程中发生的事情。

注：在2020年代的linux系统中，目录 /etc/rc.d/init.d/ 和 /etc/rc.d/rcX.d/ 简化为 /etc/init.d/ 和 /etc/rcX.d/。

#### SystemV 设置开机自启动

1、在 /etc/init.d/目录下添加需要执行的.sh脚本，脚本里调用需要开机启动的程序（shell文件格式参考目录下其它文件）

```shell

#!/bin/sh
### BEGIN INIT INFO
# Provides:       nginx
# Required-Start:    $local_fs $remote_fs $network $syslog $named
# Required-Stop:     $local_fs $remote_fs $network $syslog $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the nginx web server
# Description:       starts nginx using start-stop-daemon
### END INIT INFO

your_cmd_here

exit 0

```

Provides 的名字是唯一的，也就是在所有的开机启动项中，Provides不能有任何同名冲突。

需要执行的命令，按照正常的Bash Shell书写方式书写即可。

需要后台静默运行的程序，请使用 `nohup [需要执行的命令] >/dev/null 2>&1 &` 方式来启动！

2、给shell脚本test.sh添加执行权限

    chmod 755 test.sh

3、添加自启动命令

    update-rc.d test.sh defaults

4、删除自启动的命令

    update-rc.d -f test.sh remove

简单的命令脚本调用，可以直接修改 /etc/rc.local 文件，在exit 0之前增加需要运行的脚本

    1.vi /etc/rc.local

        #!/bin/sh -e

        nohup /usr/local/bin/your_shell_script.sh >/dev/null 2>&1 &

        exit 0

    2、给文件添加执行权限

        sudo chmod 755 rc.local

        chmod 755 /usr/local/bin/your_shell_script.sh

    3、重启计算机，程序会被root用户调用起来。

#### systemd 对 SystemV 的兼容性

    /etc/init.d/ 下的脚本，有不少是对 systemd 兼容的，写法参见具体文件，如 nginx、rng-tools

    /etc/rc.local 文件，在systemd中也添加了控制文件，可以保持对 SystemV 的兼容性

systemd 保持对 SystemV 的兼容性使用的控制文件

    /usr/lib/systemd/system/systemd-initctl.service

    /usr/lib/systemd/system/rc-local.service

### systemd

    https://www.freedesktop.org/software/systemd/man/index.html

systemd 工具是编译后的二进制文件，但该工具包是开放的，因为所有配置文件都是 ASCII 文本文件。可以通过各种 GUI 和命令行工具来修改启动配置，也可以添加或修改各种配置文件来满足特定的本地计算环境的需求。几乎可以管理正在运行的 Linux 系统的各个方面。它可以管理正在运行的服务，同时提供比SystemV 多得多的状态信息。它还管理硬件、进程和进程组、文件系统挂载等。systemd 几乎涉足于现代 Linux 操作系统的每方面，使其成为系统管理的一站式工具。

    systemd在启动阶段并行地启动尽可能多的服务。这样可以加快整个的启动速度，使得主机系统比 SystemV 更快地到达登录屏幕。

systemd并不是一个命令，而是一组命令，涉及到系统管理的方方面面。根据编译过程中使用的选项（不在本系列中介绍），systemd 可以有多达 69 个二进制可执行文件执行以下任务，其中包括：

    提供基本的系统配置工具，例如主机名、日期、语言环境、已登录用户的列表，正在运行的容器和虚拟机、系统帐户、运行时目录及设置，用于简易网络配置、网络时间同步、日志转发和名称解析的守护进程。

    提供套接字管理。

    能感知分层的文件系统挂载和卸载功能可以更安全地级联挂载的文件系统。

    允许主动的创建和管理临时文件，包括删除。

    D-Bus 的接口提供了在插入或移除设备时运行脚本的能力。这允许将所有设备（无论是否可插拔）都被视为即插即用，从而大大简化了设备的处理。

    分析启动环节的工具可用于查找耗时最多的服务。

    它包括用于存储系统消息的日志以及管理日志的工具。

    systemctl 服务管理和报告提供了比 SystemV 更多的服务状态数据。

对之前系统的兼容性

    systemd 会检查老的 SystemV init 目录，以确认是否存在任何启动文件。如果有，systemd 会将它们作为配置文件以启动它们描述的服务，参见章节 [systemd 对 SystemV 的兼容性]。

    systemd 定时器提供类似 cron 的高级功能，包括在相对于系统启动、systemd 启动时间、定时器上次启动时间的某个时间点运行脚本。它提供了一个工具来分析定时器规范中使用的日期和时间。

#### 基本管理命令

systemctl 是 Systemd 的主命令，用于管理系统

    # 重启系统
    $ sudo systemctl reboot

    # 关闭系统，切断电源
    $ sudo systemctl poweroff

    # CPU停止工作
    $ sudo systemctl halt

    # 暂停系统
    $ sudo systemctl suspend

    # 让系统进入休眠状态
    $ sudo systemctl hibernate

    # 让系统进入交互式休眠状态
    $ sudo systemctl hybrid-sleep

    # 启动进入救援状态（单用户状态）
    $ sudo systemctl rescue

systemd-analyze 命令用于查看启动耗时

    # 查看启动耗时
    $ systemd-analyze

    # 查看每个服务的启动耗时
    $ systemd-analyze blame

    # 显示瀑布状的启动过程流
    $ systemd-analyze critical-chain

    # 显示指定服务的启动流
    $ systemd-analyze critical-chain atd.service

hostnamectl 命令用于查看当前主机的信息

    # 显示当前主机的信息
    $ hostnamectl

    # 设置主机名。
    $ sudo hostnamectl set-hostname rhel7

localectl 命令用于查看本地化设置

    # 查看本地化设置
    $ localectl

    # 设置本地化参数。
    $ sudo localectl set-locale LANG=en_GB.utf8
    $ sudo localectl set-keymap en_GB

timedatectl 命令用于查看当前时区设置

    # 查看当前时区设置
    $ timedatectl

    # 显示所有可用的时区
    $ timedatectl list-timezones

    # 设置当前时区
    $ sudo timedatectl set-timezone America/New_York
    $ sudo timedatectl set-time YYYY-MM-DD
    $ sudo timedatectl set-time HH:MM:SS

loginctl 命令用于查看当前登录的用户

    # 列出当前session
    $ loginctl list-sessions

    # 列出当前登录用户
    $ loginctl list-users

    # 列出显示指定用户的信息
    $ loginctl show-user ruanyf

#### systemctl系统资源管理命令

Systemd 可以管理所有系统资源。不同的资源统称为 Unit（单位）。

Unit 一共分成12种

    Service unit：系统服务
    Target unit：多个 Unit 构成的一个组
    Device Unit：硬件设备
    Mount Unit：文件系统的挂载点
    Automount Unit：自动挂载点
    Path Unit：文件或路径
    Scope Unit：不是由 Systemd 启动的外部进程
    Slice Unit：进程组
    Snapshot Unit：Systemd 快照，可以切回某个快照
    Socket Unit：进程间通信的 socket
    Swap Unit：swap 文件
    Timer Unit：定时器

systemctl list-units 命令可以查看当前系统的所有 Unit

    # 列出正在运行的 Unit
    $ systemctl list-units

    # 列出所有Unit，包括没有找到配置文件的或者启动失败的
    $ systemctl list-units --all

    # 列出所有没有运行的 Unit
    $ systemctl list-units --all --state=inactive

    # 列出所有加载失败的 Unit
    $ systemctl list-units --failed

    # 列出所有正在运行的、类型为 service 的 Unit
    $ systemctl list-units --type=service

systemctl status 命令用于查看系统状态和单个 Unit 的状态

    # 显示系统状态
    $ systemctl status

    # 显示单个 Unit 的状态
    $ sysystemctl status bluetooth.service

    # 显示远程主机的某个 Unit 的状态
    $ systemctl -H root@rhel7.example.com status httpd.service

三个查询状态的简单方法，主要供脚本内部的判断语句使用

    # 显示某个 Unit 是否正在运行
    $ systemctl is-active application.service

    # 显示某个 Unit 是否处于启动失败状态
    $ systemctl is-failed application.service

    # 显示某个 Unit 服务是否建立了启动链接
    $ systemctl is-enabled application.service

启动和停止 Unit（主要是 service）

    # 立即启动一个服务
    $ sudo systemctl start apache.service

    # 立即停止一个服务
    $ sudo systemctl stop apache.service

    # 重启一个服务
    $ sudo systemctl restart apache.service

    # 杀死一个服务的所有子进程
    $ sudo systemctl kill apache.service

    # 重新加载一个服务的配置文件
    $ sudo systemctl reload apache.service

    # 重载所有修改过的配置文件
    $ sudo systemctl daemon-reload

    # 显示某个 Unit 的所有底层参数
    $ systemctl show httpd.service

    # 显示某个 Unit 的指定属性的值
    $ systemctl show -p CPUShares httpd.service

    # 设置某个 Unit 的指定属性
    $ sudo systemctl set-property httpd.service CPUShares=500

systemctl list-dependencies 命令列出一个 Unit 的所有依赖

    $ systemctl list-dependencies nginx.service
    nginx.service
    ● ├─system.slice
    ● └─sysinit.target
    ●   ├─dev-hugepages.mount
    ●   ├─keyboard-setup.service
    ●   ├─systemd-update-utmp.service
    ...
    ●   ├─cryptsetup.target
    ●   ├─local-fs.target
    ●   │ ├─-.mount
    ●   │ ├─boot.mount
    ●   │ ├─systemd-fsck-root.service
    ●   │ └─systemd-remount-fs.service
    ●   └─swap.target

上面命令的输出结果之中，有些依赖是 Target 类型，默认不会展开显示。如果要展开 Target，就需要使用--all参数

    systemctl list-dependencies --all nginx.service

#### journalctl日志管理命令

Systemd 统一管理所有 Unit 的日志，可以只用 journalctl 一个命令，查看所有日志（内核日志和应用日志）。

日志的配置文件是/etc/systemd/journald.conf。

journalctl 功能强大，用法非常多

    # 查看所有日志（默认情况下 ，只保存本次启动以来的日志）
    $ journalctl

    # 实时滚动显示最新日志
    $ journalctl -f

    # 查看某个 Unit 的日志
    $ journalctl -u nginx.service
    $ journalctl -u nginx.service --since today

    # 实时滚动显示某个 Unit 的最新日志
    $ journalctl -u nginx.service -f

    # 合并显示多个 Unit 的日志
    $ journalctl -u nginx.service -u php-fpm.service --since today

    # 查看内核日志（不显示应用日志）
    $ journalctl -k

    # 查看系统本次启动的日志
    $ journalctl -b
    $ journalctl -b -0

    # 查看上一次启动的日志（需更改设置）
    $ journalctl -b -1

    # 查看指定时间的日志
    $ journalctl --since="2012-10-30 18:17:16"
    $ journalctl --since "20 min ago"
    $ journalctl --since yesterday
    $ journalctl --since "2015-01-10" --until "2015-01-11 03:00"
    $ journalctl --since 09:00 --until "1 hour ago"

    # 显示尾部的最新10行日志
    $ journalctl -n

    # 显示尾部指定行数的日志
    $ journalctl -n 20

    # 查看指定服务的日志
    $ journalctl /usr/lib/systemd/systemd

    # 查看指定进程的日志
    $ journalctl _PID=1

    # 查看某个路径的脚本的日志
    $ journalctl /usr/bin/bash

    # 查看指定用户的日志
    $ journalctl _UID=33 --since today

    # 查看指定优先级（及其以上级别）的日志，共有8级
    # 0: emerg
    # 1: alert
    # 2: crit
    # 3: err
    # 4: warning
    # 5: notice
    # 6: info
    # 7: debug
    $ journalctl -p err -b

    # 日志默认分页输出，--no-pager 改为正常的标准输出
    $ journalctl --no-pager

    # 以 JSON 格式（单行）输出
    $ journalctl -b -u nginx.service -o json

    # 以 JSON 格式（多行）输出，可读性更好
    $ journalctl -b -u nginx.serviceqq
    -o json-pretty

    # 显示日志占据的硬盘空间
    $ journalctl --disk-usage

    # 指定日志文件占据的最大空间
    $ journalctl --vacuum-size=1G

    # 指定日志文件保存多久
    $ journalctl --vacuum-time=1years

#### xxx.service系统资源配置文件

每一个 Unit 都有一个配置文件，告诉 Systemd 怎么启动这个 Unit 。

Systemd 的配置文件存放在目录 /lib/systemd/system/，
用 systemctl start 启动后出现在 /usr/lib/systemd/system/
用 systemctl enable 设置为自启动后添加连接文件在 /etc/systemd/system/ 。

也可直接存放在 /etc/systemd/system/ 下，暂不知道区别

systemctl enable 命令用于在上面两个目录之间，建立符号链接关系

    $ sudo systemctl enable clamd@scan.service
    # 等同于
    $ sudo ln -s '/lib/systemd/system/clamd@scan.service' '/etc/systemd/system/multi-user.target.wants/clamd@scan.service'

如果配置文件里面设置了开机启动，systemctl enable 命令相当于激活指定服务的开机启动。

与之对应的，systemctl disable 命令用于在两个目录之间，撤销符号链接关系，相当于撤销指定服务的开机启动

    sudo systemctl disable clamd@scan.service

配置文件的后缀名，就是该 Unit 的种类，比如sshd.socket。如果省略，Systemd 默认后缀名为.service，所以sshd会被理解成sshd.service。

systemctl list-unit-files 命令用于列出所有配置文件

    # 列出所有配置文件
    $ systemctl list-unit-files

    # 列出指定类型的配置文件
    $ systemctl list-unit-files --type=service

这个命令会输出一个列表，表示每个配置文件的状态，一共有四种

    enabled：已建立启动链接
    disabled：没建立启动链接
    static：该配置文件没有[Install]部分（无法执行），只能作为其他配置文件的依赖
    masked：该配置文件被禁止建立启动链接

从配置文件的状态无法看出，该 Unit 是否正在运行。这必须执行前面提到的 systemctl status 命令。

一旦修改配置文件，就要让 SystemD 重新加载配置文件，然后重新启动，否则修改不会生效

    sudo systemctl daemon-reload
    sudo systemctl restart httpd.service

配置文件就是普通的文本文件，可以用文本编辑器打开。

systemctl cat 命令可以查看配置文件的内容

    $ systemctl cat sshd
    # /lib/systemd/system/ssh.service
    [Unit]
    Description=OpenBSD Secure Shell server
    Documentation=man:sshd(8) man:sshd_config(5)
    After=network.target auditd.service
    ConditionPathExists=!/etc/ssh/sshd_not_to_be_run

    [Service]
    EnvironmentFile=-/etc/default/ssh
    ExecStartPre=/usr/sbin/sshd -t
    ExecStart=/usr/sbin/sshd -D $SSHD_OPTS
    ExecReload=/usr/sbin/sshd -t
    ExecReload=/bin/kill -HUP $MAINPID
    KillMode=process
    Restart=on-failure
    RestartPreventExitStatus=255
    Type=notify
    RuntimeDirectory=sshd
    RuntimeDirectoryMode=0755

    [Install]
    WantedBy=multi-user.target
    Alias=sshd.service

配置文件分成几个区块。每个区块的第一行，是用方括号表示的区别名，比如[Unit]，每个区块内部是一些等号连接的键值对。
注意，配置文件的区块名和字段名，都是大小写敏感的，键值对的等号两侧不能有空格。

示例参见：

    [用 systemd-networkd 配置策略路由] <vnn.md>

    [设置为 systemd 的服务] <org03k.md>

##### 配置文件的区块

[Unit]区块通常是配置文件的第一个区块，用来定义 Unit 的元数据，以及配置与其他 Unit 的关系。它的主要字段如下

    https://www.freedesktop.org/software/systemd/man/systemd.unit.html

    Description：简短描述
    Documentation：文档地址
    Requires：当前 Unit 依赖的其他 Unit，如果它们没有运行，当前 Unit 会启动失败
    Wants：与当前 Unit 配合的其他 Unit，如果它们没有运行，当前 Unit 不会启动失败
    BindsTo：与Requires类似，它指定的 Unit 如果退出，会导致当前 Unit 停止运行
    Before：如果该字段指定的 Unit 也要启动，那么必须在当前 Unit 之后启动
    After：如果该字段指定的 Unit 也要启动，那么必须在当前 Unit 之前启动
    Conflicts：这里指定的 Unit 不能与当前 Unit 同时运行
    Condition...：当前 Unit 运行必须满足的条件，否则不会运行
    Assert...：当前 Unit 运行必须满足的条件，否则会报启动失败

[Install]通常是配置文件的最后一个区块，用来定义如何启动，以及是否开机启动。它的主要字段如下。

    WantedBy：它的值是一个或多个 Target，当前 Unit 激活时（enable）符号链接会放入/etc/systemd/system目录下面以 Target 名 + .wants后缀构成的子目录中
    RequiredBy：它的值是一个或多个 Target，当前 Unit 激活时，符号链接会放入/etc/systemd/system目录下面以 Target 名 + .required后缀构成的子目录中
    Alias：当前 Unit 可用于启动的别名
    Also：当前 Unit 激活（enable）时，会被同时激活的其他 Unit

[Service]区块用来 Service 的配置，只有 Service 类型的 Unit 才有这个区块。它的主要字段如下

    https://www.freedesktop.org/software/systemd/man/systemd.service.html

    Type：定义启动时的进程行为。它有以下几种值。
    Type=simple：默认值，执行ExecStart指定的命令，启动主进程
    Type=forking：以 fork 方式从父进程创建子进程，创建后父进程会立即退出
    Type=oneshot：一次性进程，Systemd 会等当前服务退出，再继续往下执行
    Type=dbus：当前服务通过D-Bus启动
    Type=notify：当前服务启动完毕，会通知Systemd，再继续往下执行
    Type=idle：若有其他任务执行完毕，当前服务才会运行

    ExecStart：启动当前服务的命令
    ExecStartPre：启动当前服务之前执行的命令
    ExecStartPost：启动当前服务之后执行的命令
    ExecReload：重启当前服务时执行的命令
    ExecStop：停止当前服务时执行的命令
    ExecStopPost：停止当其服务之后执行的命令
    RestartSec：自动重启当前服务间隔的秒数
    Restart：定义何种情况 Systemd 会自动重启当前服务，可能的值包括always（总是重启）、on-success、on-failure、on-abnormal、on-abort、on-watchdog
    TimeoutSec：定义 Systemd 停止当前服务之前等待的秒数
    Environment：指定环境变量

Unit 配置文件的完整字段清单，请参考[systemd官方文档](https://www.freedesktop.org/software/systemd/man/systemd.unit.html)。

##### Target 就是一个 Unit 组

包含许多相关的 Unit 。启动某个 Target 的时候，Systemd 就会启动里面所有的 Unit。

传统的init启动模式里面，有 RunLevel 的概念，跟 Target 的作用很类似。不同的是，RunLevel 是互斥的，不可能多个 RunLevel 同时启动，但是多个 Target 可以同时启动。

    # 查看当前系统的所有 Target
    $ systemctl list-unit-files --type=target

    # 查看一个 Target 包含的所有 Unit
    $ systemctl list-dependencies multi-user.target

    # 查看启动时的默认 Target
    $ systemctl get-default

    # 设置启动时的默认 Target
    $ sudo systemctl set-default multi-user.target

    # 切换 Target 时，默认不关闭前一个 Target 启动的进程，
    # systemctl isolate 命令改变这种行为，
    # 关闭前一个 Target 里面所有不属于后一个 Target 的进程
    $ sudo systemctl isolate multi-user.target

Target 与 传统 RunLevel 的对应关系如下

    Traditional runlevel      New target name     Symbolically linked to...

    Runlevel 0           |    runlevel0.target -> poweroff.target
    Runlevel 1           |    runlevel1.target -> rescue.target
    Runlevel 2           |    runlevel2.target -> multi-user.target
    Runlevel 3           |    runlevel3.target -> multi-user.target
    Runlevel 4           |    runlevel4.target -> multi-user.target
    Runlevel 5           |    runlevel5.target -> graphical.target
    Runlevel 6           |    runlevel6.target -> reboot.target

它与init进程的主要差别如下

（1）默认的 RunLevel（在/etc/inittab文件设置）现在被默认的 Target 取代，位置是/etc/systemd/system/default.target，通常符号链接到graphical.target（图形界面）或者multi-user.target（多用户命令行）。

（2）启动脚本的位置，以前是/etc/init.d目录，符号链接到不同的 RunLevel 目录 （比如/etc/rc3.d、/etc/rc5.d等），现在则存放在/lib/systemd/system和/etc/systemd/system目录。

（3）配置文件的位置，以前init进程的配置文件是/etc/inittab，各种服务的配置文件存放在/etc/sysconfig目录。现在的配置文件主要存放在/lib/systemd目录，在/etc/systemd目录里面的修改可以覆盖原始设置。

#### 设置 systemd 开机自启动脚本

示例一：

自制的shell脚本，想让systemd进行启动管理。

确认 systemd 已经开启了 systemV 启动脚本 rc.local 的兼容服务

    $ cat /lib/systemd/system/rc-local.service
    [Unit]
    Description=/etc/rc.local Compatibility
    Documentation=man:systemd-rc-local-generator(8)
    ConditionFileIsExecutable=/etc/rc.local
    After=network.target

    [Service]
    Type=forking
    ExecStart=/etc/rc.local start
    TimeoutSec=0
    RemainAfterExit=yes
    GuessMainPID=no

然后执行章节 [SystemV设置开机自启动]。

示例二：

自制一个 systemd 服务，使用systemd的格式要求。

创建 /etc/systemd/system/tproxyrule.service 文件

    [Unit]
    Description=Tproxy rule
    After=network.target
    Wants=network.target

    [Service]

    Type=oneshot
    RemainAfterExit=yes

    # 注意分号前后要有空格
    ExecStart=/sbin/ip rule add fwmark 1 table 100 ; /sbin/ip route add local 0.0.0.0/0 dev lo table 100 ; /sbin/iptables-restore /etc/iptables/rules.v4
    ExecStop=/sbin/ip rule del fwmark 1 table 100 ; /sbin/ip route del local 0.0.0.0/0 dev lo table 100 ; /sbin/iptables -t mangle -F

    # 如果是 nftables，则改为以下命令
    # ExecStart=/sbin/ip rule add fwmark 1 table 100 ; /sbin/ip route add local 0.0.0.0/0 dev lo table 100 ; /sbin/nft -f /etc/nftables/rules.v4
    # ExecStop=/sbin/ip rule del fwmark 1 table 100 ; /sbin/ip route del local 0.0.0.0/0 dev lo table 100 ; /sbin/nft flush ruleset

    [Install]
    WantedBy=multi-user.target

执行下面的命令使 tproxyrule.service 可以开机自动运行

    systemctl enable tproxyrule

## crontab 定时任务

    https://www.debian.org/doc/manuals/debian-handbook/sect.task-scheduling-cron-atd.zh-cn.html

    http://c.biancheng.net/view/1092.html

    https://www.cnblogs.com/GavinSimons/p/9132966.html

    各种不能执行的原因 https://segmentfault.com/a/1190000020850932
                        https://github.com/tony-yin/Why-Cronjob-Not-Work

    https://www.cnblogs.com/pengdonglin137/p/3625018.html
    https://www.cnblogs.com/utopia68/p/12221769.html
    https://blog.csdn.net/zhubin215130/article/details/43271835
    https://developer.aliyun.com/article/541971

### 1、crontab 与 anacron

    crontab：crontab命令被用来提交和管理用户的需要周期性执行的任务，与windows下的计划任务类似，当安装完成操作系统后，默认会安装此服务工具，并且会自动启动crond服务，crond进程每分钟会定期检查是否有要执行的任务，如果有，则自动执行该任务。依赖于crond服务

    anacron：cron的补充，能够实现让cron因为各种原因在过去的时间该执行而未执行的任务在恢复正常执行一次。依赖于nancron服务

    debian 中安装 anacron 软件包会禁用 cron 在/etc/cron.{daily，weekly，monthly} 目录中的脚本，仅由 anacron 调用，以避免 anacron 和 cron 重复运行这些脚本。 cron 命令仍然可用并处理其他计划任务（特别是用户安排的计划任务）。

### 2、Crontab任务种类及格式定义

cron分为系统cron和用户cron，用户cron指 /var/spool/cron/crontabs/$USER 文件，系统cron指
/etc/crontab 文件 以及 /etc/cron.{daily，weekly，monthly}/ 目录 ，这两者是存在部分差异的。

系统cron 在命令行运行之前有一个额外的字段user。

(1)、系统cron任务：/etc/crontab 文件

一般配置系统级任务，开机即可启动，注意格式比用户级多了个执行的user。

    cd /etc

    $ ls -l|grep cron
    drwxr-xr-x 2 root root    4096 May 13 17:28 cron.d
    drwxr-xr-x 2 root root    4096 May 27 06:49 cron.daily
    drwxr-xr-x 2 root root    4096 Jul 12  2021 cron.hourly
    drwxr-xr-x 2 root root    4096 Jul 12  2021 cron.monthly
    drwxr-xr-x 2 root root    4096 Jul 12  2021 cron.weekly
    -rw-r--r-- 1 root root    1042 Oct 11  2019 crontab

    $ cat crontab
    # /etc/crontab: system-wide crontab
    # Unlike any other crontab you don't have to run the `crontab'
    # command to install the new version when you edit this file
    # and files in /etc/cron.d. These files also have username fields,
    # that none of the other crontabs do.

    SHELL=/bin/sh
    PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

    # Example of job definition:
    # .---------------- minute (0 - 59)
    # |  .------------- hour (0 - 23)
    # |  |  .---------- day of month (1 - 31)
    # |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
    # |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
    # |  |  |  |  |
    # *  *  *  *  * user-name command to be executed
    17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
    25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
    47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
    52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
    # 分钟 小时 天 月 周 用户 任务

run-parts 参数运行指定目录中的所有脚本。

(2)、用户cron任务：/var/spool/cron/$USER 文件

编辑指定用户的crontab设置

    # 显示当前用户的定时任务
    $ crontab -l
    no crontab for uu

    # 显示指定用户的定时任务
    $ sudo crontab -u root -l
    no crontab for root

    # 编辑指定用户的定时任务
    sudo crontab -u root -e

命令行格式

    # 分钟 小时 天 月 周 任务

(3)、anacron：/etc/anacrontab 检查频率 分钟 任务注释信息 运行的任务

(4)、在启动时运行命令

只是在系统启动后，单次执行一个命令，可以使用 @reboot 宏（仅仅重启 cron 命令不会触发使用@reboot调度的命令）。该宏表示了 crontab条目的前五个区段。

### 3、时间的有效取值

    代表意义    分钟    小时    日    月    周    命令
    ------------------------------------------------
    数字范围    0~59    0~23    1~31    1~12    0~7    就命令啊

    周的数字为0或7时，都代表“星期天”的意思。另外，还有一些辅助的字符，大概有下面这些：

    特殊字符      代表意义
    ------------------------
    *(星号)    代表任何时刻都接受的意思。举例来说，范例一内那个日、月、周都是*，就代表着不论何月、何日的礼拜几的12：00都执行后续命令的意思。

    ,(逗号)    代表都使用的时段。举例来说，如果要执行的工作是3：00与6：00时： 0 3,6 * * * command

    -(减号)    代表一段时间范围内，举例来说，8点到12点之间的每小时的20分都进行一项工作：20 8-12 * * * command

    /n(斜线)   n代表数字，即是每隔n单位间隔的意思，例如每五分钟进行一次，则： */5 * * * * command

    用*与/5来搭配，也可以写成0-59/5，意思相同

### 4、时间通配表示

1)对应时间的所有有效取值

    3 * * * *         # 每天每小时的第三分钟执行一次

    3 * * * 7         # 每周日每小时的第三分钟执行一次

    13 12 6 7 *        # 每年的7月6日12点13分执行一次

2)离散时间点：

    10,40 02 * * 2,5            # 每周二和周五的凌晨2点10分和40分执行一次

3)连续时间点：

    10 02 * * 1-5                # 周一至周五的凌晨2点10分执行一次

4)对应取值范围内每多久一次

    */3 * * * *                   # 每三分钟执行一次

注意：比所要求小的时间单位必须要给定时间点(每天执行 那么分钟 小时都要给定时间 不能用*)

如：

    08 */2 * * *                  # 每两小时执行一次

    10 04 */2 * *                 # 每两天执行一次

### 5、cron的环境变量

cron 启动任务时，环境变量非常少，即使是用户级任务，也不会执行用户的 .profile 文件，所以，如果需要操作数据库等跟用户相关的脚本或命令，一般采用在用户脚本中执行环境变量文件，然后再执行相关操作。

cron在crontab文件中的默认 PATH=/usr/bin:/bin，cron执行所有命令都用该PATH环境变量指定的路径下去找。

详见章节 [坑：环境变量是单独的跟用户登陆后的环境变量不一样]

### 6、执行结果将以邮件形式发送

    */3 * * * * /bin/cat /etc/fstab > /dev/null         # 错误信息仍然发送给管理员

    */3 * * * * /bin/cat /etc/fstab &> /dev/null         # 所有信息都不发送给管理员，无论是否正确执行

在 /var/mail 目录下查看邮件

在 /var/log/syslog 查看日志，debian默认的rsyslog不记录cron日志，需要手动开启

注意 /var 的空间不要被填满了

### 坑：区分crontab命令和crontab文件

用 crontab -e 命令配置是针对当前用户的定时任务，而编辑 /etc/crontab 文件是针对系统的任务。

cron服务每分钟不仅要读一次 /var/spool/cron/crontabs/ 内的所有文件，还读一次 /etc/crontab 文件。

使用下面的命令，会在vi 里打开crontab的内容以供编辑：

    crontab -e

如果你只想看看，不需要编辑，可以使用以下的命令

    crontab -l

要删除crontab的内容，就是删除所有的计划任务，可以这样：

    crontab -r

/etc/crontab 文件的内容如下

```shell

SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root  # 任务执行时的输出保存在/var/mail下的用户名同名文件中

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
0 3 1 */2 0 root systemctl stop nginx; /usr/local/bin/certbot renew; systemctl restart nginx

```

星号  如果某个部分出现的是星号而不是数字，就是说明这个部分表示的时间全部会执行。

    1.分钟（0-59）
    2.小时（0-23）
    3.一个月的哪一天（1-31）
    4.一年中的哪个月（1-12）
    5.星期几（0是星期天）

每小时运行3次，在0分，10分，和20分时

    0,10,20 * * * * user-name  command

每5分钟运行一次

    */5 * * * * user-name  command

每2小时的零分运行一次

    00 */2 * * * user-name  command

5到10点的每个整点运行一次

    0 5-10 * * * user-name  command

### 坑：crontab文件最后要有个空行

    crontab要求cron中的每个条目都要以换行符结尾

对crontab文件的最后一行任务设置来说，如果后面没有一个空白行，那说明它没有换行符，不会被crotnab执行。。。

解决方案

    养成给cron中每个条目后面都添加一个空行的习惯

如果你用Windows编辑的crontab文件，注意必须改为 unix格式保存。

这也算unix文本文件的通病了，很多linux命令的执行都以行结束为标志，从文件中读取的最后一行如果直接结束时没有换行符的，导致永远无法执行。。。

所以，确保您的crontab文件在末尾有一个空白行。

最好养成习惯，给crontab文件的中每个条目下面添加一个空行，文件的最后一行多敲一个回车再保存。

另外文件格式注意，各个操作系统的行结束符是不一样的，linux下 不能是 Windows 文本格式的 ^M、macOS 文本格式的 \r 等，必须是unix格式，这样的换行符才是 \n。

很多编辑软件编辑ftp上的文件，或上传到ftp时，默认都做格式转换，其实容易混淆，还不如直接设置，保留原文件格式，不要自动转换。这样查看文件的时候非常方便，一目了然，unix下的vi显示Windows文件会出现很多乱码。在Windows下编辑unix文件，现在流行的编辑软件也都支持正确显示这个格式了，不要让他来回的转。

### 坑：修改 /etc/crontab 文件后要加载到cron服务

命令和文件名相同，注意区分

    crontab /etc/crontab

debian 不需要这么做了

    $ cat /etc/crontab
    # /etc/crontab: system-wide crontab
    # Unlike any other crontab you don't have to run the `crontab'
    # command to install the new version when you edit this file
    # and files in /etc/cron.d. These files also have username fields,
    # that none of the other crontabs do.

### 坑：环境变量是单独的跟用户登陆后的环境变量不一样

root用户登陆后的PATH

    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

普通用户登陆后的PATH

    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games

调测：将cron中的环境变量打印出来：

    * * * * * env > /tmp/env.output

一分钟后查看

    $ cat /tmp/env.output
    HOME=/root
    LOGNAME=root
    PATH=/usr/bin:/bin
    LANG=C.UTF-8
    SHELL=/bin/sh
    LC_ALL=C.UTF-8
    PWD=/root

cron中的环境变量与用户登陆系统后的env环境变量不一样（cron会忽略 /etc/environment 文件），尤其是PATH，只有/usr/bin:/bin，也就是说在cron中运行shell命令，如果不是全路径，只能运行/usr/bin或/bin这两个目录中的标准命令，而像/usr/sbin、/usr/local/bin等目录中的非标准命令是不能运行的。详见章节 [环境变量文件的说明] <shellcmd.md>。

所以定时任务的命令行一般都要先执行下 profile、bash_profile等用户环境的变量文件，然后才能执行用户脚本。或者在cron脚本文件头部声明PATH，或者在用户脚本中执行环境变量文件

    . /etc/profile

配置定时任务的格式

    01 03    * * * . /etc/profile; /bin/bash /usapce/code/test1.sh

+ 否则你就会遇到一个经典问题：

    手动输入：

        /bin/bash /usapce/code/test1.sh

    可以执行，但放在crontab里就总是不起作用。

### 坑：命令解释器默认是sh而不是bash

从坑一的变量 SHELL=/bin/sh 可以看到默认的解释器不是bash，而大多数命令脚本都是用bash来解释执行的。所以配置定时任务时，要明确的指定执行命令的解释器

    bash -c "mybashcommand"

    或
    /bin/bash /usapce/code/test1.sh

或在脚本内的第一行指定：

    #!/bin/bash

### 坑：需要执行权限

如果设置了非root用户的定时任务，需要注意很多权限问题，比如该用户对操作的文件或目录是否存在权限等。

解决方案

    # correct permission
    sudo chmod 600 /var/spool/cron/crontabs/user

    # signal crond to reload the file
    sudo touch /var/spool/cron/crontabs

### 坑：防止屏幕打印

把脚本的输出和报错信息都打印到空

    xxx.sh >/dev/null 2>&1

### 坑：定时时间的书写格式不统一

一些特殊选项各个平台支持不一样，有的支持，有的不支持，例如2/3、1-5、1,3,5

这个只能试一下才知道。

### 坑：corn服务默认不启动

查看当前系统是否有进程

    $ ps -ef|grep cron
    root       398     1  0 May08 ?        00:00:07 /usr/sbin/cron -f

Debian 等现在用 systemd 配置 cron 服务，拉起来的 cron 进程

    $ systemctl status cron
    ● cron.service - Regular background program processing daemon
    Loaded: loaded (/lib/systemd/system/cron.service; enabled; vendor preset: enabled)
    Active: active (running) since Sun 2022-05-08 09:10:43 UTC; 1 months 27 days ago
        Docs: man:cron(8)
    Main PID: 398 (cron)
        Tasks: 1 (limit: 1148)
    Memory: 2.3M
    CGroup: /system.slice/cron.service
            └─398 /usr/sbin/cron -f

### 坑：百分号需要转义字符

    https://unix.stackexchange.com/questions/29578/how-can-i-execute-date-inside-of-a-cron-tab-job

当cron定时执行命令中，有百分号并且没有转义的时候，cron执行会出错，比如执行以下cron：

    0 * * * * echo hello >> ~/cron-logs/hourly/test`date "+%d"`.log

会有如下报错：

    /bin/sh: -c: line 0: unexpected EOF while looking for matching ``'
    /bin/sh: -c: line 1: syntax error: unexpected end of file

即cron中换行符或%前的命令会被shell解释器执行，但是%会被认为新一行的字符，并且%后所有的数据都会以标准输出的形式发送给命令。

解决方案：为百分号做转义，即在%前添加反斜杠\

    0 * * * * echo hello >> ~/cron-logs/hourly/test`date "+\%d"`.log

### 坑：crontab文件里的变量使用有限制

因为在 crontable 里面只能声明变量，不能对变量进行操作或者执行其他任何shell命令的，所以下述的shell字符串拼接是不会成功的，所以只能声明变量，然后在命令中引用变量。

    SOME_DIR=/var/log
    MY_LOG_FILE=${SOME_DIR}/some_file.log

    BIN_DIR=/usr/local/bin
    MY_EXE=${BIN_DIR}/some_executable_file

    0 10 * * * ${MY_EXE} some_param >> ${MY_LOG_FILE}

解决方案：

方案1： 直接声明一个变量，值是完整拼接好的字符串

    SOME_DIR=/var/log
    MY_LOG_FILE=/var/log/some_file.log

    BIN_DIR=/usr/local/bin
    MY_EXE=/usr/local/bin/some_executable_file

    0 10 * * * ${MY_EXE} some_param >> ${MY_LOG_FILE}

方案2： 声明多个变量，在命令中引用可以拼接变量

    SOME_DIR=/var/log
    MY_LOG_FILE=some_file.log

    BIN_DIR=/usr/local/bin
    MY_EXE=some_executable_file

    0 10 * * * ${BIN_DIR}/${MY_EXE} some_param >> ${SOME_DIR}/${MY_LOG_FILE}

### 坑：用户密码过期也不会启动定时任务

当用户密码过期也会导致cron脚本执行失败。

Linux下新建用户密码过期时间是从/etc/login.defs文件中PASS_MAX_DAYS提取的，普通系统默认就是99999，而有些安全操作系统是90天，这个参数只影响新建用户的密码过期时效，如果之前该用户已经密码过期了，该这个参数没用。

将用户密码有效期设置成永久有效期或者延长有效期

    chage -M <expire> <username>

    或
    passwd -x -1 <username>

### 坑：切换时区后要重启cron服务

当修改系统时区后，无论是之前已经存在的cron还是之后新创建的cron，脚本中设置的定时时间都以旧时区为准，比如原来时区是Asia/Shanghai，时间为10:00，然后修改时区为Europe/Paris，时间变为3:00，此时你设置11:00的定时时间，cron会在Asia/Shanghai时区的11:00执行。

解决方案1：

重启crond服务

    sudo systemctl restart cron

解决方案2：

    kill cron进程，因为cron进程是自动重生的

## 网络故障排查

    https://www.debian.org/doc/manuals/debian-reference/ch05.zh-cn.html

不建议使用ifconfig，而推荐使用新的 ip 命令，未来net-tools套件会被完全废弃，功能上被iproute2套件取代，见[二者命令详细对比](https://linux.cn/article-4326-1.html)。

    # apt install net-tools
    ifconfig

端口是否可用

    curl -vvv 127.0.0.1:443

    wget 127.0.0.1:443

    ssh -vvv -p 443 127.0.0.1

    telnet 127.0.0.1 443

当前对外开放的监听端口

    # 127.0.0.1 只对本机开放
    # 0.0.0.0   外来连接也开放
    netstat -ant

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

查看路由节点

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
