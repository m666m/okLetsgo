# GNU/Linux 常用工具

    GNU 收录软件，可查手册 https://www.gnu.org/software/software.html

        Linux 命令速查 https://man7.org/linux/man-pages/index.html
        Linux 命令速查 https://linux.die.net/man/

    各种linux帮助手册速查 https://manned.org/

## Windows 下的 GNU/POSIX 环境

### 环境方案选择

Windows 10+ 下使用 WSL 开发 GNU 环境设置

    https://github.com/hsab/WSL-config

Windows C++ 开发环境配置

    g++ 7.0 + git + cmake

    code::block / vscode / SourceInsight

    WinSCP 同步本地和编译机代码

    BeyondCompare 合并代码
        meld 基于python的开源合并工具，替换 BeyondCompare https://meldmerge.org/

    tmux + vim 直接在编译机写代码，方便随时ssh上去复原现场继续。

    静态代码分析工具 SourceInsight

    Understand 王者没有之一
        https://www.scitools.com
        https://blog.csdn.net/jojozym/article/details/104722107
        https://www.zhihu.com/question/19570229/answer/1626066191

    库 toft + chrome + leveldb + folly + zeromq

#### MGW 和 Cygwin 的实现思路

MingW 在编译时对二进制代码转译

    MingW (gcc 编译到mscrt)包含gcc和一系列工具，是Windows下的gnu环境。

    编译 linux c++ 源代码，生成 Windows 下的exe程序，全部使用从 KERNEL32 导出的标准 Windows 系统 API，相比Cygwin体积更小，使用更方便。

    如 创建进程， Windows 用 CreateProcess() ，而 Linux 使用 fork()：修改编译器，让 Window 下的编译器把诸如 fork() 的调用翻译成等价的mscrt CreateProcess()形式。

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

    如果你只是想在Windows下使用一些linux小工具，建议用 MSYS2，把 /usr/bin 加进环境变量 path 以后，可以直接在命令行终端中使用 Linux 命令。

#### MinGW

此项目已停止维护

    https://www.ics.uci.edu/~pattis/common/handouts/mingweclipse/mingw.html

#### MinGW64

MinGW-w64 安装配置单，gcc 是 6.2.0 版本，系统架构是 64位，接口协议是 win32，异常处理模型是 seh，Build revision 是 1 。

简单操作的话，安装开源的 gcc IDE开发环境即可，已经都捆绑了Mingw64。
比如 CodeLite，CodeBlocks，Eclipse CDT，Apache NetBeans（JDK 8）。
收费的有JetBrains Clion，AppCode （mac）。

#### MSYS、MSYS2

    https://www.msys2.org/

    https://msys2.github.io/

MinGW 仅仅是工具链，Windows 下的 cmd 使用起来不够方便，MSYS 是用于辅助 Windows 版 MinGW 进行命令行开发的配套软件包：提供了部分 Unix 工具以使得 MinGW 的工具使用起来方便一些。相比基于庞大的 Cygwin 下的 MinGW 会轻巧不少。

MSYS2 是 MSYS 的第二代，有大量预编译的软件包，并且具有包管理器 pacman (Arch Linux)。

在 Windows 上使用 Linux 程序

    如果只是需要一个编译器的话，可以用MinGW64。

    如果使用工具软件居多，还是 Msys2 能应付一切情况，它集合了cygwin、mingw64以及mingw32（不等于老版的那个MinGW），shell、git、多种环境的gcc（适用于cygwin环境或原生Windows），而且有pacman (ArcLinux)作为包管理器。

#### WSL 适用于 Linux 的 Windows 子系统

    https://zhuanlan.zhihu.com/p/377263437

Windows 10 在 2021 年后的版本更新中集成的 WSL2 使用比较方便，简单开发可以使用 WSL2。

WSL 1 虚拟机类似于程序层面的二进制转译，没有实现完整的 Linux，但是实现了 Linux 程序可以在 Windows 上运行，但是有些功能如 GUI 实现的有限。可以理解成使用了 MingW/Cygwin 的中间模拟层思路，但不在编译时实现，而是 QEMU 这种运行时转码的实现思路。 <https://docs.microsoft.com/zh-cn/Windows/wsl/compare-versions#full-system-call-compatibility>。后来发现坑太大填不满，就搞了个新思路 WSL2。

WSL 2 在底层使用虚拟机（Hyper-V）同时运行 Linux 内核和 Windows 内核，并且把 Linux 完全集成到了 Windows 中，使用起来就像在 Windows 中直接运行 Linux 程序。

##### 连接 WSL

配置 WSL 环境

    https://github.com/hsab/WSL-config

PowerShell 通过函数包装器，实现在 Windows 命令行使用 Linux 命令，实质是指向了 wsl 虚拟机去执行。<https://devblogs.microsoft.com/commandline/integrate-linux-commands-into-windows-with-powershell-and-the-windows-subsystem-for-linux/>

PowerShell 可以配置命令提示符等，参见章节 [PowerShell 7+ 命令提示符工具及美化]。

其它连接 wsl 的工具

    mintty 支持连接 WSL

        # https://github.com/mintty/mintty/wiki/Tips#supporting-linuxposix-subsystems
        # mintty 直接使用WSL会话，需要 MSYS2 环境的 /bin/下安装了 wslbridge2
        mintty --WSL=Ubuntu

    独立的 WSLtty，调用 Windows ConPty 接口开发的 mintty，通过 wslbridge 实现调用 WSL 会话

        https://github.com/mintty/wsltty

    ConPtyShell 使用 Windows ConPty 接口利用 PowerShell 实现的 WSL 本地终端

        https://github.com/antonioCoco/ConPtyShell

##### Windows 10 对 Linux 的字符程序和GUI程序的支持

Windows 10 在 2022 年后已经比较完整的对外提供了相应编程接口

    对 Linux 字符程序，通过 ConPty 接口支持 unix pty 应用

    对 Linux GUI 程序，通过 WSLg 接口支持 x-window 应用

ConPty

    https://zhuanlan.zhihu.com/p/102393122

    https://devblogs.microsoft.com/commandline/windows-command-line-introducing-the-windows-pseudo-console-conpty/

    https://learn.microsoft.com/en-us/windows/console/creating-a-pseudoconsole-session
    https://learn.microsoft.com/en-us/windows/terminal/samples
            https://github.com/microsoft/terminal/tree/main/samples/ConPTY/EchoCon

    https://www.zhihu.com/question/303307670

基于 ConPTY 的终端，既能运行 POSIX 命令行程序，也能运行基于 Windows ConHost 的命令行程序。需要 Windows version >= 10 / 2019 1809 (build >= 10.0.17763)。

目前支持 Conpty 接口的终端主要有

    Windows Terminal (from the people who wrote conpty)

    VSCode、IDEA、Eclipse 等 integrated terminal using ConPTY

    PowerShell 7+ 使用 conpty 接口运行 cmd 字符程序

    在 2022-10-28 MSYS2 mintty 支持使用 ConPty 接口了：
    在 MSYS2 的配置文件 /etc/git-bash.config 中设置变量 `MSYS=enable_pcon`，或 mintty 配置文件 .minttyrc 中设置 `ConPTY=true` 即可。这样调用普通 cmd 字符程序，不再需要借助 winpty 去加载调用了 <https://github.com/mintty/mintty/wiki/Tips#inputoutput-interaction-with-alien-programs>。

有个性能对比测试 <https://kichwacoders.com/2021/05/24/conpty-performance-in-eclipse-terminal/>

WSLg

    https://github.com/microsoft/wslg

目前已经可以支持命令行启动运行 Linux GUI 程序了，如： gvim、gedit 等，甚至支持 GPU 加速的 3D 程序。WSLg 其实是个部署了 X Server 的 Linux，添加了支持 Windows 远程桌面的 FreeRDP 服务，即作为 X-window 应用和 windows 窗口应用的桥梁存在。通过 Windows 远程桌面的接口实现了用户在 Windows 桌面直接使用 Linux GUI 程序： Windows 用户界面 <-> RDP <-> X Server <-> Linux GUI 程序。而且 WSLg 用到的其实是替代 X Window System 的 Wayland Compositor，就是 Wayland 官方给出的参考实现 Weston。这种类似于添加了个中间代理的解决方式，有利于完美适配各大 Linux 发行版和各种 Linux GUI 程序。

X Window system

    https://zhuanlan.zhihu.com/p/134325713

    https://zhuanlan.zhihu.com/p/427637159>

    最著名的GUI客户端是 xterm，至今大多数字符终端模拟器的彩色文本方案支持的还是 xterm。

    替代品 Wayland 体系见 <https://zhuanlan.zhihu.com/p/503627248>。

## Windows字符终端

终端概念参见章节 [Linux 字符终端]。

Windows 下的字符终端，如果要显示图标化字符，需要 Windows 安装支持多种符号的字体，见章节 [Nerd Font]。

### putty 远程终端模拟器

PuTTY is a free implementation of SSH and Telnet for Windows and Unix platforms, along with an xterm terminal emulator.

    https://www.chiark.greenend.org.uk/~sgtatham/putty/

    KiTTY https://github.com/cyd01/KiTTY

        从 putty 拉的分支而来，是对 putty 的易用性改进，共用putty的站点配置，增加了背景透明、支持站点列表的文件夹、自动化操作脚本，可以给站点加注释，还有便携版

    北极主题颜色 https://github.com/arcticicestudio/nord-putty
        导入后putty会话里多了一个只进行了颜色设置的 session：Nord，以此 session 打开各个ssh连接即可。

    超多主题颜色，有 putty 的

        https://github.com/mbadolato/iTerm2-Color-Schemes

    自定义主题颜色，自己设计

        https://ciembor.github.io/4bit/ 点击右上角“Get Scheme”，选复制并粘贴

putty 连接远程服务器，实现了 ssh 的全部功能，使用 PUTTYGEN.EXE 生成并管理密钥，使用 PAGEANT.EXE 作为密钥代理，并在一个单一窗口下填写远程服务器的参数配置，远程服务器的终端显示也是一个单一窗口。

术语：会话 Session

    因为功能是连接远程站点然后执行命令行操作，putty 把每个连接保存为会话，设置会话就是设置连接某站点的参数，除了终端显示的参数，还有各种连接协议的参数等多种设置

putty 登陆站点后的使用很简单

    点击并拖动鼠标左键是选择文字并复制到操作系统剪贴板（运行 putty 的操作系统，不是远程站点的）

    点击鼠标右键，从操作系统剪贴板粘贴到当前的命令提示符后面

putty 的初始界面只有一个，选择会话和会话设置两个功能区混合，使用逻辑有点绕：

    会话设置的类别界面“Category”在左侧树形展示

    会话选择界面在右侧，对应左侧界面“Category”的树形列表第一项“Session”

    会话选择界面的上半部分是站点的ip地址和端口等参数设置，下半部分是会话列表供选择

    会话参数的各项设置界面在右侧，对应左侧界面“Category”的树形列表的其它各分支项

    连接会话的“Open”按钮在最下方，选择一个已有会话后点击该按钮即可连接登陆站点

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

        比如“Connection->Data”里预设该站点的登陆用户名，“Connection->SSH-Auth”里设置该站点密钥登陆的密钥文件等等。

        有些参数是影响终端呈现效果的，比如终端类型可以选择 xterm-256color 等效于在登陆站点后的shell里设置环境变量 Term=xterm-256color。

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

putty 美化

即使你设置会话时勾选了使用 256color 和 true color 真彩色，putty 默认的主题比较保守，只使用 16 种颜色（用 rgb 设置，其实支持真彩色），你ssh登陆到服务器会发现文字色彩比较刺眼。

可以自定义颜色，在设置会话时 custom color，如果感觉挨个设置太麻烦，试试别人做好的

    https://github.com/AlexAkulov/putty-color-themes

推荐使用 nord 主题

    curl -fsSLO https://github.com/arcticicestudio/nord-putty/raw/develop/src/nord.reg

双击该reg文件，会在你的putty会话列表里新增一个“NORD”会话，点击“load”按钮加载该会话，然后填写自己的ip地址和端口，连接看看，会发现颜色效果柔和多了。

### mintty 本地终端模拟器

    https://github.com/mintty/mintty
        https://github.com/mintty/mintty/wiki/Tips
        http://mintty.github.io/
        帮助 https://mintty.github.io/mintty.1.html

源码来自 putty 拉分支，目前归属 MSYS2 项目，自带 bash， 模拟 unix pty 效果又快又好

    如果运行 cmd 下的 Windows 字符命令，有些字符解释的显示效果不一致，建议与 cmd 分别使用，不在 mintty 下使用 cmd 的命令。或者使用 winpty 调度，参见章节 [winpty 运行 cmd 字符终端程序]。

    ctrl/shift + ins 复制/粘贴，其实系统默认用鼠标拖动选择的文字复制到系统剪贴板

    在 tmux 的鼠标模式下，按下 shift 就可以使用鼠标选择文字，自动复制到系统剪贴板

    ctrl + plus/minus/zero 放大、缩小、还原

    拖拽资源管理器里的文件/文件夹到 mintty 可以得到其路径

mintty 可以在命令行显示图片，下载他的源代码下utils目录下的脚本 showimg 即可

    cd /usr/local/bin/

    curl -fsSLO https://github.com/mintty/utils/raw/master/showimg

    chmod 755 ./showimg

建议放到本地 /usr/bin/ 下，以后执行 `showimg xxx.jpg` 就可以在 mintty 下显示本地图片；如果 ssh 登陆到服务器上，在服务器的 /usr/local/bin/ 下也安装这个脚本，则 mintty 也可以响应服务器上执行的 `showimg xxx.jpg`，显示服务器上的图片。

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

在 mintty 或 Cygwin's sshd 下，如果执行Windows 控制台程序 （Windows CMD 字符程序或PowerShell），如 python 会挂死无法进入。这是因为 python 使用的是 native Windows API for command-line user interaction，而 mintty 支持的是 unix pty，或称 Cygwin/MSYS pty。

也就是说，Windows 控制台程序在 MSYS2 mintty 下直接执行会挂死，需要有个 Cygwin/MSYS adapter 提供类似 wslbridge 的角色。

安装 winpty 作为 mintty 代理（git for windows 自带无需安装)

    pacman -S winpty

然后执行 `winpty python` 即可正常进入 python 解释器环境了

最好在用户登陆脚本文件 .bashrc/.zshrc 里添加 alias 方便使用

    alias python="winpty python"
    alias ipython="winpty ipython"
    alias mysql="winpty mysql"
    alias psql="winpty psql"
    alias redis-cli="winpty redis-cli"
    alias node="winpty node"
    alias vue='winpty vue'

    # Windows 控制台程序都可以在 bash 下用 winpty 来调用
    alias ping='winpty ping'

Windows version >= 10 / 2019 1809 下的 ConPty 接口兼容了老的控制台应用程序 ConHost 接口，支持 ConPty 接口的应用可以支持unix pty，就不需要使用 winpty 做调度了，见章节 [Windows 10 对 Linux 的字符程序和GUI程序的支持]。

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
Font=MesloLGS NF
FontHeight=11
FontSmoothing=full
# FontWeight=700
# FontIsBold=yes

Columns=130
Rows=40
ScrollbackLines=12000

CursorType=block
CursorBlinks=no

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

# 2023.2 脚本执行速度慢于 mintty 本地处理
# Windows version >= 10 / 2019 1809 (build >= 10.0.17763)
#ConPTY=true

# 自定义颜色方案，跟深色背景搭配
# https://github.com/mintty/mintty/wiki/Tips#background-image
# 自定义颜色方案 https://ciembor.github.io/4bit/ 点击右上角“Get Scheme”，选复制并粘贴
# 根据图片生成颜色方案 https://github.com/thefryscorer/schemer2 参见章节 [base16颜色方案](gnu_tools.md okletsgo)
Background=C:\tools\SuperPuTTY\111dark.jpg
BackgroundColour=13,25,38
ForegroundColour=217,230,242
CursorColour=236,255,255
Black=53,53,53
BoldBlack=92,92,92
Red=253,102,102
BoldRed=243,143,141
Green=34,206,112
BoldGreen=65,243,123
Yellow=207,190,116
BoldYellow=223,216,149
Blue=55,122,176
BoldBlue=48,135,222
Magenta=173,81,54
BoldMagenta=202,112,85
Cyan=79,196,181
BoldCyan=116,207,190
White=242,251,249
BoldWhite=251,243,242

# 自定义颜色方案，跟深色背景搭配，nord 的暗淡方案
# https://github.com/arcticicestudio/nord-alacritty/blob/main/src/nord.yml
#Background=C:\tools\SuperPuTTY\DR_6.jpg
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
#Background=C:\tools\SuperPuTTY\222yellow.jpg
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
#Background=C:\tools\SuperPuTTY\333green.jpg
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

Git Bash 使用了 GNU tools 的 MinGW(Msys2)，但是只编译了它自己需要的部分工具软件进行了集成，我们主要使用他的 mintty.exe 命令行终端模拟器和 git、ssh、gpg、winpty 等工具。

安装 git for Windows 或 MSYS2 后就有了

    https://git-scm.com/download/win

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

pacman命令较多，常用的命令如下：

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

### 其他本地终端模拟器

WindTerm 基于 C 开发的开源终端模拟器，支持多个平台，支持终端多路复用，绿色不需要安装。速度快，兼容性较好，左侧就是文件夹树方便sftp，支持 lrzsz 的文件拖放传送，命令行输出还支持标签折叠

    https://github.com/kingToolbox/WindTerm
        https://kingtoolbox.github.io/

    https://zhuanlan.zhihu.com/p/550149638

    初次使用注意关闭主密码、关闭自动锁屏的功能。否则只能编辑 user.config 文件：

        干掉 application.fingerprint 和 application.masterPassword

        再找到 .wind/profiles/default.v10/terminal/user.sessions 文件删除 session.autoLogin 就可以将主密码设置为空字符串了，之后再来修改主密码，就 OK 了。

alacritty 使用 OpenGL 进行显示加速的本地终端模拟器，在 Windows 下使用 powershell

    https://github.com/alacritty/alacritty

WezTerm GPU 加速跨平台终端仿真器，支持终端多路复用，至今未解决偶发的卡顿问题

    https://github.com/wez/wezterm
        https://wezfurlong.org/

Linux 桌面下的终端模拟器感觉没啥意义，用自带的就行了

    Gnome 桌面自带 Xterm
    KDE 桌面自带 Konsole
    Xfce 桌面自带 xfce

    rxvt-unicode

    terminator

    guake

    cool-retro-term

    terminology

    kitty 使用 gpu 进行显示加速的本地终端模拟器，只能在 linux/MacOS 桌面下使用

        sudo apt install kitty

        https://github.com/kovidgoyal/kitty
            https://www.linuxshelltips.com/kitty-terminal-emulator-linux/

        常用插件挺好用 https://sw.kovidgoyal.net/kitty/kittens_intro/

    Warp 号称比 iTerm2 顺滑，半开源，只能在 MacOS 桌面下使用

        https://www.warp.dev/
            https://github.com/warpdotdev/Warp
            主题 https://github.com/warpdotdev/themes

cmder 推荐了几个本地终端模拟器，可以嵌入 cmder 代替 ConEmu

    https://github.com/cmderdev/cmder/wiki/Seamless-Terminus-integration

        Tabby（原名Terminus）跨平台的终端模拟器，electron + nodejs 写的，支持终端多路复用，不支持导入 putty 的站点，目前使用sz传输大文件时文件会损坏，老老实实的用 sftp 吧
            https://github.com/Eugeny/tabby
            使用介绍 https://zhuanlan.zhihu.com/p/447977207

    https://github.com/cmderdev/cmder/wiki/Seamless-Hyper-integration

        hyper 基于 xterm.js 和 Electron实现
            https://hyper.is/

    https://github.com/cmderdev/cmder/wiki/Seamless-FluentTerminal-Integration

        FluentTerminal 基于 xterm.js 的 UWP 应用
            https://github.com/felixse/FluentTerminal

Nushell 既是一种编程语言，也是一种 Shell，执行 `help commands` 查看常用命令。自己的脚本语言可以基于自己的指令定义函数、基于函数定义脚本。可以开发 rust 插件给他扩展功能。

    https://github.com/nushell/nushell
        https://www.nushell.sh/zh-CN/book/thinking_in_nu.html

clink 辅助工具，在cmd下模仿bash，按tab键自动完成，像emacs一样编辑输入的命令，很多支持终端多路复用的软件在 Windows 下调用 cmd 都使用了 clink

    https://github.com/chrisant996/clink
        不再更新了 https://github.com/mridgers/clink

winpty 辅助工具，提供了 unix pty 接口与 cmd conhost 接口的互通，是 mintty 这种 MSYS2 环境下执行 Windows CMD/PowerShell 程序的中介，参见章节 [winpty 运行 cmd 字符终端程序]

    https://github.com/rprichard/winpty

wslbridge 辅助工具，使用 Windows ConPty 接口 以支持 WSL(Windows Subsystem for Linux)，很多支持终端多路复用的软件在 Windows 下都通过该组件使用 WSL 会话

    wslbridge2 https://github.com/Biswa96/wslbridge2
        wslbridge 不更新了2018 https://github.com/rprichard/wslbridge/

### 终端多路复用器

Windows 下的命令行终端类型很多，如果想统一在一个程序下x标签化管理各个窗口，这样的程序称为终端多路复用器 terminal multiplexer。

#### Supper Putty

    可惜目前更新不大及时 https://github.com/jimradford/superputty

本质上是给 putty 加了个多窗口的外壳，树形展示会话列表，方便管理和使用

    支持嵌入其它的各种终端窗口: putty、mintty(bash)、cmd、powershell

    putty/mintty 兼容性和反应速度满分

    窗口切换有点问题，Windows 切换任务热键 alt+tab 要按两次才能切换成功

    只要安装了 git for Windows 和 putty 等软件即可直接配置使用，不需要做复杂的设置

    可一键导入 putty 站点

    可设置关联 WinScp/FileZilla 等软件的快捷调用，右键点选站点方便调用

初次使用前的设置

    先设置 Supper Putty 使用的各工具路径

        选择菜单项 Tools->Options:General，至少要给出 putty.exe 的路径。还可以给出 mintty.exe 的路径，只要安装了 git for Windows 一般在 C:\Program Files\Git\usr\bin\mintty.exe 。

        其它的工具类似，配置好了后在站点列表处点击右键，可以方便调用 winscp、filezila、vnc 等工具。

    导入 putty 的 session。

        选择菜单项 File->Import Sessions->From Putty Settings，导入putty session。导入后，在窗口侧栏的树状选择列表，双击即会打开 putty 窗口登陆该站点。

设置自动登陆 putty 的用户名

    点击想导入的session，右键菜单选“Edit”，弹出窗口选择“Login username”。这样设置了以后，打开该站点不需要在 putty 的 session 里保存登陆用户名了。

    如果 putty 中该用户可以使用密钥登陆，在这里也跟单独使用 putty 同样效果。

    如果 pageant 代理程序在运行，在这里也跟单独使用 putty 同样效果。

新建 mintty (git bash) 终端

    快速连接工具栏，本地登陆协议选择 “mintty”，主机地址“localhost”即可，然后回车，就出现登陆窗口了。

    或会话列表上点击右键，选择“New”，填写“Session Name”，把“Connection type”选“Mintty”，“HOST Name”设置为 “localhost”即可。

    或编辑一个已导入的putty session，把“Connection type”选“Mintty”，“HOST Name”设置为 “localhost”即可。

    如果需要mintty在调用bash登陆的时候执行用户脚本，则需要编辑会话的高级设置：

        注意选项 “Extra Arguments”

            /bin/bash --login -i

        因为最终要实现调用命令行如下：

            "C:\Program Files (x86)\Git\bin\mintty.exe" /bin/bash --login -i

    因为是窗体嵌套的 mintty，所以在 mintty 窗口里，它的右键菜单依然是可用的。

    关于 mintty 的详细介绍，参见章节 [mintty 本地终端模拟器]。

备份自己的站点设置

    除了putty的站点，用户还可以自建 cmd/power shell/rdp 等多种协议的站点，保存站点设置很有必要。

    保存站点设置

        选择菜单项 File->Emport Sessions，会给出默认的当前目录下的 Sessions.XML 文件，点击确定即可。

    恢复站点设置

        选择菜单项 File->Import Sessions->From File，选择之前备份的 Sessions.XML 文件，点击确定即可。

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

直接安装从 github 下载的 .msixbundle 文件安装后，无法正常启动 Windows Terminal。经过一顿操作，终于找到了解决方法，用魔法打败了魔法！<https://www.cnblogs.com/albelt/p/15253147.html>

要求：

    Windows 10 1903 版本及以上

步骤：

    到 Windows Terminal 的 Github 仓库下载最新的 release 包，即以 .msixbundle 为后缀的文件

    将文件后缀名改为 .zip 后解压缩文件

    在解压后的文件夹中找到名为 CascadiaPackage***.msix 的文件，有 x86、x64 和 ARM64 版本的，选择 x64 那个文件，修改后缀名为 .zip，然后解压

    在解压后的文件夹中，找到 WindowsTerminal.exe 的文件，直接双击就能运行了，还是绿色免安装版的，是不是很简单？

    可以把这个文件夹拷贝到安全的位置，然后将 .exe 文件添加到桌面快捷方式，就能愉快地使用 Windows Terminal 啦！

##### 配置 Windows Terminal

因为 Windows Terminal 有自己的主题，颜色方案背景等配置修改 setting.json。目前版本的 Windows Terminal 可以在用户界面选择设置，如选择背景图片、开启毛玻璃效果、开启复古的像素化终端效果等，下面的说明仅供参考。

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

schemes 段设置配色方案，同样是一个数组，每种配色方案会有一个名字 name ，引用配色方案就是通过 name 的值。默认预设了几种配色方案，可在 default.json 查看

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

自定义 nord 方案，来自章节 [Nord 整套支持终端模拟器和各个软件的配色方案]的三种模式

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

### PowerShell 7+ 命令提示符工具及美化

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

#### PowerShell 7 配置文件样例

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

## Linux 字符终端

参见终端的历史演进

    https://devblogs.microsoft.com/commandline/windows-command-line-introducing-the-windows-pseudo-console-conpty/#in-the-beginning-was-the-tty

    https://zhuanlan.zhihu.com/p/99963508

    https://vt100.net/

console 即控制台，是与操作系统交互的设备，操作系统将一些信息直接输出到控制台上。用户登录控制台，一般都是通过终端设备，输入命令等跟操作系统交互。

在80年代个人计算机出现前，50-70年代的电子计算机都是多用户大型机，程序在大型机上运行，使用者使用不同的硬件设备连接到主机进行操作。这些设备给使用者提供输入和输出字符的功能，称为终端机 Terminal。最简单的字符输入设备是电传打字机（Teletype, tty），所以现在也用 tty 来表示字符输入终端。输出字符的显示界面有不同的显示规格，从打字机的纸带发展到到不同分辨率的电子显示屏。

终端设备接受用户界面的输入传递给主机，接受主机的输出展现在用户界面，在这个过程中需要对字符进行编码转换以便人与主机互相“理解”。70 年代 ANSI 标准沿用至今，主流设备都保持对此标准的兼容。

80年代通用计算机发展以来，主要的连接方式是通用计算机通过串行电缆连接主机，利用通用计算机的显示器和键盘与主机的命令行程序交互。随着处理器能力发展强大，GUI 图形化操作系统的发展，带来了一个新的使用问题：如果用户使用图形化窗口的Terminal，需要与本机上运行的另一个命令行应用程序交互，那么本机的程序需要营造出一个物理终端设备的仿真环境，以便通过命令行跟主机进行交互，即所谓终端模拟器（Terminal Emulator）。这种连接本机的终端可称为本地终端，或称软件进入“console mode”。

UNIX/Linux 内核使用伪终端（pseudo tty，缩写为 pty）设备的概念，实现这个伪终端功能的程序即可把自己模拟成主机的终端。我们现在说的终端，不再是真实的硬件设备，一般都是指软件终端模拟器。目前流行的字符终端模拟器有 putty、xterm 等，图形终端模拟器有 vnc、rdp 等。在使用终端模拟器的时候，如果不清楚主机类型，终端类型可选择最常见的 xterm。

随着计算机网络的发展，网络上的服务器（Server）作为主机，客户机（Client）通过网络连接主机。主机和客户机间可以使用各种不同类型的协议进行连接，比如 ssh/telnet/ftp 等都有对应的命令行程序。远程连接使用的通信协议主要采用非对称密钥加密算法，一般利用 ssh 建立通信隧道。上述终端模拟器中，xterm 连接本机，通过 ssh 等程序连接网络上的主机。putty 主要用于 ssh 协议连接网络上的主机，通过 ssh 的方式也可连接本机（需要本机运行 sshd 服务），也支持模拟 rs232 串口方式连接本机操作系统 console。

早期 Windows 操作系统下，终端模拟器的角色是 conhost.exe，通过外壳程序 cmd、powershell，他们在启动时连接本机的 conhost，类似于 Linux 的伪终端机制。因为 Windows 的 conhost 实现机制跟 Linux 伪终端实质上不同(一个是调用Windows API，一个是发送文本字符)，第三方终端应用程序其实无法连接 conhost，所以有来自 Msys2 项目的 mintty.exe 作为本地终端模拟器，借助它就可以使用 unix pty 的程序如 bash、zsh 等。详见章节 [Windows字符终端]。

直至 2018年 Windows 新的 ConPTY 接口实现了 *NIX 的伪终端功能，使得终端模拟器可以用文本的方式连接本机。参见章节 [Windows 10 对 Linux 的字符程序和GUI程序的支持]。

### 终端模拟器和软件的彩色设置

    https://github.com/mintty/mintty/wiki/CtrlSeqs

自 1978 年的 VT100 以来，Unix/Linux 一直通用 [ANSI escape codes 彩色字符方案](http://en.wikipedia.org/wiki/ANSI_escape_code)：使用固定的文本代码，对字符终端的文本进行修饰，由终端模拟器和软件解释并呈现对应的色彩。在我们使用终端模拟器软件时，设置 ssh 要连接的站点，一般选择终端类型为 xterm 即可（可以使用 shell 的 tput 命令查询或创建交互性的、专业性强的屏幕输出，如移动或更改光标、更改文本属性，以及清除终端屏幕的特定区域）。

最古老的基本颜色板（basic colour palette），前景色和背景色分别有 8 种，合计16种如下，修饰文本的颜色代码 \033[0，参见终端登陆脚本中颜色设置的代码 <bash_profile.sh>，历史介绍见 <https://zhuanlan.zhihu.com/p/566797565>。

    # https://blog.csdn.net/Dreamhai/article/details/103432525
    # https://zhuanlan.zhihu.com/p/570148970
    # 色彩      黑    红    绿    黄    蓝    洋红    青    白
    # 前景色    30    31    32    33   34    35    36    37
    # 背景色    40    41    42    43   44    45    46    47

    输出特效格式控制：

        \033[0m 关闭所有属性
        \033[1m 设置高亮度
        \03[4m 下划线
        \033[5m 闪烁
        \033[7m 反显
        \033[8m 消隐
        \033[30m -- \033[37m 设置前景色
        \033[40m -- \033[47m 设置背景色

    光标位置等的格式控制：

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

所以目前通用的前景颜色代码就是16种（基本8种、加亮8种）:

        normal="\033[0m"

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

如果你的终端模拟器支持彩色，那么在 bash 下输入如下代码，会看到输出红色的文字

    # ascii表中 \e 或 \033 或 \x1b
    # 使用16色代码表 基本颜色板
    echo -en "\033[0;31m I am red\033[0m\n"

    # 使用256色代码表
    echo -en "\033[38:5:88m I am red\033[0m\n"

    # 使用RGB真彩色
    echo -en "\033[38:2:168:28:38m I am red\033[0m\n"

所以，要能看到彩色的文本，终端模拟器应该至少在选项设置中设置为 xterm 类型。若终端工具能支持24位真彩色、开启透明选项，则显示的效果更好

为防止终端模拟器中未进行设置，一般在用户登陆脚本 .bash_profile 中设置环境变量，起到相同的效果

    # 显式设置终端启用256color，防止终端工具未设置。若终端工具能支持24位真彩色、开启透明选项，则显示的效果更好
    export TERM="xterm-256color"

如果终端模拟器支持真彩色，还可以对16色代码表的实际展现效果进行自定义，从 65536 种颜色中选取：比如把红色代码 31 的实际展现效果定义为 RGB(168,28,38)。这样做的目的是兼容性：绝大多数的 shell 脚本对文字进行颜色修饰都通用 16 色代码，除非脚本的代码改造为 RGB() 的形式才能呈现更丰富的色彩。所以，不需要修改脚本的折衷办法是，由用户设置自己的终端模拟器把这 16 种颜色解释为更丰富的颜色。

基本颜色板的自定义，详见各终端模拟器的设置。

如果需要确定当前终端模拟器是否支持真彩色，参见下面网址中的真彩色检测代码

    https://github.com/termstandard/colors
        https://gist.github.com/XVilka/8346728

终端模拟器即使开启了 24 位真彩，出于兼容性考虑，默认的色彩主题，对16种颜色代码也只会选用 16/256 色中的颜色，导致看不出更好看的效果。所以，为了能看到更丰富的颜色，应该自定义设置，选择颜色更丰富的其它主题，或自定义这16种颜色代码的实际展现颜色，详见各终端模拟器的设置。

#### 测试终端支持色彩的情况

使用不同终端模拟器（mintty bash、putty、Windows Terminal bash）,

用 ssh 登陆同一个服务器，

在 bash/zsh+powerlevel10k 、tmux 环境下，

打开 vim 查看代码文件，在 vim 里执行 `:terminal` 进入新的终端，各种情况的组合测试。

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

    同上，简单脚本实现  # https://github.com/msys2/MSYS2-packages/issues/1684#issuecomment-570793998
    for x in {0..8}; do for i in {30..37}; do for a in {40..47}; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo ""

256 color 测试脚本

    256色展示，按每种颜色组织

        curl -fsSL https://github.com/robertknight/konsole/raw/master/tests/color-spaces.pl |perl

True color(24bit) 色条测试脚本，如果色条出现明显的条带分隔，那说明只支持 256 color

    简单在 bash 下执行即可

    ```shell

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

#### 软件支持真彩色

终端模拟器定义的颜色方案，默认只影响 shell 下基本的文字显示效果，如 ls、grep、systemctl 等命令输出标准的16色文字修饰代码都可以正常显示。

命令 ls 对子目录显示蓝色，可执行sh文件显示绿色，对特定类型的文件用不同的颜色显示。通过变量 $LS_COLORS 获取颜色值，该值由 ls 程序所在的服务器端设置，参见 `man dir_colors`。如果你发现在不同的 Linux 下 ls 命令的结果对特定类型的文件显示不同的颜色，就是这里的设置不同导致

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

    ls、tree 等命令颜色方案-北极

        https://www.nordtheme.com/docs/ports/dircolors/type-support
            https://github.com/arcticicestudio/nord-dircolors

        curl -fsSLo ~/.dir_colors https://github.com/arcticicestudio/nord-dircolors/raw/develop/src/dir_colors

    这些颜色整体仍然受终端模拟器对16种基本颜色的设置控制，也就是说，在终端模拟器中使用颜色方案，配套修改 dir_colors ，让更多的文件类型使用彩色显示。

有些软件支持自定义颜色方案，色彩效果超越终端模拟器设置：

tmux、vim 有自己的色彩方案设置：

要开启软件自己的 256color 和 RGB 真彩色两个选项。两个选项都要开启，否则在使用这两个软件时，还是无法呈现真彩色。

详见下面章节中的各软件自己的配置文件样例，可参考 <https://lotabout.me/2018/true-color-for-tmux-and-vim/>。

而且，基于跟前面章节所述同样的原因，不要使用 tmux、vim 默认的主题颜色，自定义设置，选用颜色更丰富的其它主题效果更好。

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

schemer2 可以用读取指定的图片，生成该图片用色风格的 base16 配色方案

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

print('\nThen restart mintty to take effect, you can run `curl -fsSL https://github.com/mintty/utils/raw/master/colourscheme |bash` to see the color scheme.')

```

#### 整套支持终端模拟器和各个软件的配色方案

Dracula theme

    https://draculatheme.com/
        https://github.com/dracula/dracula-theme/tree/master/themes

Nord theme

    https://www.nordtheme.com/ports/
        https://github.com/arcticicestudio/

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
    这里是一个暗淡风格的nord，其它地方未见
    dim:
        black: '#373e4d'
        red: '#94545d'
        green: '#809575'
        yellow: '#b29e75'
        blue: '#68809a'
        magenta: '#8c738c'
        cyan: '#6d96a5'
        white: '#aeb3bb'

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

shell中的命令显示中文（如果支持的话）就设置 LANG

    export LANG=zh_CN.UTF-8

### bash 命令提示符美化

依赖多彩色设置，详见章节 [终端模拟器和软件的真彩色设置]。

简单的双行状态栏，见代码段落 [命令行提示符显示当前路径、git分支、python环境名等](bash_profile.sh) 中设置变量 PS1 部分。

或者使用 powerline，参见章节 [状态栏工具 powerline]

    # apt 安装的在 /usr/share 下，如果是 pip 安装的用 `pip show powerline-status` 查看路径
    source /usr/share/powerline/bindings/bash/powerline.sh

bash 内置命令和快捷键见 <shellcmd.md> 的相关章节。

#### bash 命令行提示符显示 python 环境名

完整的命令行提示符显示 conda/virtualenv 环境名，见代码段落 [命令行提示符显示当前路径、git分支、python环境名等](bash_profile.sh) 中设置变量 PS1 部分。

Conda

    https://zhuanlan.zhihu.com/p/572716915

conda 激活环境时，默认会修改命令行提示符，比较丑，Windows cmd 下还好，只是增加个前缀 (base) C:\>，在 mintty bash 下是个两行的怪物，而且默认不支持 utf-8。

+ mintty bash 使用 conda 自定义 PS1 变量的尝试过程如下：

    mintty bash 使用 conda 自定义 PS1

        $ conda env config vars set PS1='($CONDA_DEFAULT_ENV)[\u@\h:\W]$'

        这样设置后，进入 mintty bash 后使用 conda 的效果如下：

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

最终还是用 mintty bash 自定义比较好：

1、把 conda 的自定义 PS1 变量关掉

    自定义 conda 的环境名格式，需要先修改 conda 的默认设置，不允许 conda 命令修改 PS1 变量

    在 Anaconda cmd 命令行下执行（或者cmd下手工激活base环境，执行命令 `conda activate`）做如下的设置，只做一次即可

        让 Anaconda 可以 hook 到 .bash_profile
            conda init bash

        禁止 conda 修改命令行提示符，以防止修改 PS1 变量
            conda config --set changeps1 False

        禁止 conda 进入命令行提示符时自动激活base环境，以方便检测 $CONDA_DEFAULT_ENV 变量
            conda config --set auto_activate_base false

    这样在用户登陆进入bash环境后，执行 `conda activate` 后读取 $CONDA_DEFAULT_ENV 变量即可获取到当前环境名。

2、virtualenv 的处理类似 conda

    先禁止 virtualenv 环境中的 activate 命令在 PS1 变量添加环境名称

        export VIRTUAL_ENV_DISABLE_PROMPT=1

    这样在用户登陆进入bash环境后，执行 `source activate` 后读取 $VIRTUAL_ENV 变量即可获取到当前环境名。

3、在 PS1 变量的设置代码中读取二者的环境名变量，具体实现详见 [PS1conda-env-name](bash_profile.sh)。

### 状态栏工具 powerline

依赖多彩色设置，详见章节 [终端模拟器和软件的真彩色设置]。

Powerline 最初是一款 Vim statusline 的插件，后来发展到支持 bash、vim、tmux 等众多工具及插件，powerline 都可适配进行状态栏显示。

    https://github.com/powerline/powerline/

    配置说明 https://powerline.readthedocs.io/en/master/configuration/reference.html

powerline 最大的优点是它的各种符号字体可以图形化的显示文件夹、电池、git状态、进度等。

缺点是它的代码 python2、3 混杂，安装和使用都很难配置，所以现在有些插件不使用它了。

使用这个插件，先确定你当前操作系统的 python 命令指向的是 python2 还是 python3，我的 Debian 10 默认是 python2，目前从 github 安装的最新版只支持 python3，所以得改设置。简单点的安装发行版自带的就可以了。

基础安装

    # https://askubuntu.com/questions/283908/how-can-i-install-and-use-powerline-plugin
    # https://powerline.readthedocs.io/en/latest/installation.html
    #
    # 最好别用pip安装，我折腾了一上午都搞不定最终起效的设置
    # https://powerline.readthedocs.io/en/latest/installation.html
    # pip install powerline-status 这个是python2的一堆坑
    # python3 -m pip install --user git+https://github.com/powerline/powerline
    #
    # 最好用发行版自带的，一步到位，默认的安装到 /usr/share/powerline/ 目录下了
    sudo apt install powerline

安装后有个后台进程

    # 由 systemd 调度管理 /etc/systemd/user/default.target.wants/powerline-daemon.service
    $ ps -ef|grep powerline
    00:00:00 /usr/bin/python3 /usr/bin/powerline-daemon --foreground

你使用的终端工具的 Terminal 相关参数设置中设置 xterm-256color，防止用户登陆脚本未设置变量TERM，以保证命令行显示的颜色更丰富

    # 显式设置终端启用256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
    export TERM="xterm-256color"

终端模拟器字体推荐 MesloLGS NF，详见下面章节[图标字体]。

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

#### 替代品

startship 通用的状态栏工具，支持 sh、bash、cmd 等 shell

    https://starship.rs/zh-CN/
        https://github.com/starship/starship

    https://sspai.com/post/72888

推荐安装 zsh，安装 powerlevle10k，这个状态栏工具的兼容性和显示效果直接起飞，见章节 [推荐主题powerlevel10k]。

### 图标字体

    https://juejin.cn/post/6844904054322102285

作为程序员，和命令行打交道很频繁，设置一个赏心悦目的命行行 prompt 或者 Vim 的 status line 主题就很有必要了，不过一般这些漂亮的主题都会用到一些 icon 字符，这些 icon 字符一般的字体里是没有的。

如果使用的是没有打 patch 的字体，可以看到很多特殊字符都会显示不正确，这也是很多爱好者安装一些主题后，显示效果不理想的原因。

Powerline fonts 或者 Nerd fonts 这些字体集，他们对已有的一些 (编程) 字体打了 patch，新增一些 icon 字符。

字体要安装到你使用终端模拟器的计算机上

    你在 Windows 下使用 putty 或 mintty 等终端工具，则字体要安装到你的 Windows 系统中。

    你在 MacOS 下使用 iTerm2 终端工具，则要在你的苹果电脑上安装这些字体。

如果你的计算机使用的是 Linux 就比较省事，直接 apt install 安装到本机，很多发行版如 Debian 都带 powerline 字体。

然后设置在终端模拟器或编辑器使用该字体，这样才能正确显示。

简单测试几个unicode字符

    $ echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
     ±  ➦ ✘ ⚡ ⚙

#### Powerline fonts

    https://github.com/powerline/fonts

Powerline发展到后来，为了显示各种好看的图标使用了特殊的 icon 字符。powerline fonts 就是给 Powerline 配套的字体集，本质是对一些现有的字体打 patch，把 powerline icon 字符添加到这些现有的字体里去，目前对非常多的编程字体打了 patch。Powerline fonts 对打过 patch 的字体做了重命名，后面都加上了 for Powerline 的后缀，比如 Source Code Pro 打完 patch 后名字改为了 Source Code Pro for Powerline。

很多状态栏插件等工具，为了使用图标字体，都依赖 powerline fonts 的字体。

    # Debian 等发行版自带
    # https://github.com/caiogondim/bullet-train.zsh
    sudo apt install fonts-powerline
    sudo apt install ttf-ancient-fonts

    # 最新版
    git clone --depth=1 https://github.com/powerline/fonts.git

    # install
    cd fonts
    ./install.sh

    cd ..
    rm -rf fonts/

Nerd fonts 是 Powerline fonts 的超集，建议直接使用 Nerd font，参见下面章节 [Nerd font]。

#### Nerd font

    https://www.nerdfonts.com/font-downloads
        https://github.com/ryanoasis/nerd-fonts

原理和 Powerline fonts 是一样的，针对已有的字体打 patch，把一些 icon 字符插入进去。不过 Nerd font 就比较厉害了，是一个“集大成者”，他几乎把目前市面上主流的 icon 字符全打进去了，包括上面提到的 powerline icon 字符以及 Font Awesome 等几千个 icon 字符。

类似 Powerline fonts，字体 patch 后对名字加了后缀 NF，比如 Source Code Font 会修改为 Sauce Code Nerd Font (Sauce Code 并非 typo，故意为之)，Fira Code 改名为 Fira Code NF。

终端模拟器推荐使用 Meslo LGS NF 字体，如果还支持透明效果（如mintty），显示效果直接起飞 <https://github.com/romkatv/powerlevel10k#fonts>。

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

    $ echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699 \u2743 \uf70f \ue20a \ue350 \uf2c8"
     ±  ➦ ✘ ⚡ ⚙ ❃    

### 使用 zsh

单纯的 zsh 并不慢，只要别装 ohmyzsh，没有任何功能性插件的使用场景依赖这个 ohmyzsh。

    https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH

    https://www.zhihu.com/question/21418449/answer/300879747

从语法上来说，zsh和bash是不兼容的；但是zsh有一个仿真模式，可以支持对 bash/sh 语法的仿真（也有对csh的仿真，但是支持不完善，不建议使用）：

    $ emulate bash
    或
    $ emulate sh

安装

    sudo apt install zsh

如果是用 apt install 安装的发行版，位置在 /usr/share/zsh

zsh 默认使用的用户插件位置，在 ~/.zsh/plugin/

可设置当前用户默认登陆使用 zsh

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

如果之前使用bash，在 ~/.zshrc 文件中加上 `source ~/.bash_profile`，可以继承执行 bash 的配置文件。

有些插件和主题依赖 python 和 git，注意提前安装好。

zsh 命令提示符主题推荐使用简洁的 pure

    https://github.com/sindresorhus/pure

    下面章节[推荐状态栏工具 powerlevel10k]，也可设置为 pure 风格。

zsh 自带功能

    命令智能补全：相对于 bash，两次 TAB 键只能用于提示目录，在 zsh 中输入长命令，输入开头字母后连续敲击两次 TAB 键 zsh 给你一个可能的列表，用tab或方向键选择，回车确认。比如已经输入了 svn commit，但是有一个 commit 的参数我忘记了，我只记得两个减号开头的，在svn commit -- 后面按两次TAB，会列出所有命令。

    快速跳转：输入 cd - 按TAB，会列出历史路径清单供选择。

#### 安装常用的插件

下面的几个常用插件挨个装太复杂了，想无脑安装参见章节 [开箱即用一步到位的软件包 -- zsh4humans]。

除了 powerline 外，其它的插件都要进入 zsh 后再执行安装

    powerline：见章节[状态栏工具 powerline]，建议使用替代品见章节 [推荐状态栏工具 powerlevel10k]。

    命令自动完成：输入完 “tar”命令，后面就用灰色给你提示 tar 命令的参数，而且是随着你动态输入完每一个字母不断修正变化，tar -c 还是 tar -x 跟随你的输入不断提示可用参数，这个命令提示是基于你的历史命令数据库进行分析的。按TAB键快速进入下一级，或直接按右方向键确认该提示(按Alt+m接两次vi的右方向键更方便)。

        # git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
        sudo apt install zsh-autosuggestions

    命令语法高亮：根据你输入的命令是否正确的色彩高亮，比如输入date查看时间，错为data，字体的颜色会跟随你的输入一个字母一个字母的变化，错误会直接变红。

        # git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting
        sudo apt install zsh-syntax-highlighting

        # 发现个替代品 https://github.com/zdharma-continuum/fast-syntax-highlighting

    命令模糊查找：输入错的也没关系，给你候选命令的提示，vi模式改良为按上下键进入搜索，直接输入关键字即可

        # https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh
        sudo apt install fzf

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

炫酷的符号字体，需要在你使用终端模拟器的计算机上安装 MesloLGS NF 字体，详见章节[图标字体]。

终端模拟器最好明确设置 $TERM 变量，这样各个插件会自动使用更丰富的颜色

    # 或者在你的用户登陆脚本 .bash_profile 中显式设置
    # 显式设置终端启用256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
    export TERM="xterm-256color"

依赖多彩色设置，详见章节 [终端模拟器和软件的真彩色设置]。

如果你的终端模拟器不支持透明效果，且未使用 MesloLGS NF 字体的话，显示风格会有差别，这是设计者做了兼容性考虑，以防止显示不正常。

然后从github安装powerlevel10k

    # https://github.com/romkatv/powerlevel10k#manual
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

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

    选择把 zsh 安装到home下，而且不作为默认登陆shell
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

#### .zshrc 配置文件样例

安装 powerlevle10k、ohmyzsh(可选) 等几个插件后的配置

```zsh

##########################################################
# powerlevel10k 自动生成的首行，不用动
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

##########################################################
# zsh 自己的内容，不用动
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/pi/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

##############
# 如果安装了 ohmyzsh 会自动生成一堆设置，不用管他
# ...
# ...
# ohmyzsh 自带插件管理，在 plugin=() 段落启用内置插件，可以在这里加载那些 source xxx 的插件

##########################################################
# powerlevel10k 安装程序添加，不用动

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

##########################################################
# 从这里开始用户自己的设置

# 命令行开启vi-mode模式，按esc后用vi中的上下键选择历史命令
# zsh 命令行用 bindkey -v 来设置 vi 操作模式
#set -o vi

# 显式设置终端启用256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
export TERM="xterm-256color"

####################################################################
# alias 本该放到 .bashrc 文件，为了方便统一在此了
#
# 参考自 dbian 的 .bashrc 脚本中，常用命令开启彩色选项
# enable color support of ls and also add handy aliases
# 整体仍然受终端模拟器对16种基本颜色的设置控制，也就是说，在终端模拟器中使用颜色方案，配套修改 dir_colors ，让更多的多种文件类型使用彩色显示
# curl -fsSLo ~/.dir_colors https://github.com/arcticicestudio/nord-dircolors/raw/develop/src/dir_colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    # 常用的列文件
    alias ls='ls --color=auto'
    alias l='ls -CFA'
    alias ll='ls -l'
    alias la='ls -lA'
    alias lla='ls -la'

    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    # 注意不要搞太花哨，导致脚本里解析出现用法不一致的问题
    alias diff='diff --color=auto'
    alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
    #alias egrep='egrep --color=auto'
    #alias fgrep='fgrep --color=auto'
    alias tree='tree -a -I .git'

    # ls 列出的目录颜色被 grep 覆盖，用 ls -l 更方便
    alias lsg='ls -lA|grep -i'

    # git 常用命令
    alias gs='echo "git status ..." && git status'
    alias glog='echo "[树形提交记录]" && git log --oneline --graph'
    alias gdh='echo "[对比最近的两次提交]" && git diff HEAD^ HEAD'

    # gpg 常用命令
    alias gkey='echo "[有私钥的gpg密钥]" && gpg -K --keyid-format=long'
fi

# 执行 cd 命令后自动执行下 ls 列出当前文件
chpwd() ls
chpwd

############# 加载插件
# 如果是用 apt install 安装的发行版插件，位置在 /usr/share/ 目录
# 手动安装的插件，位置在 ~/.zsh/plugins/ 目录

# 加载插件：状态栏工具 powerline
# 如果是pip安装的查看路径用 pip show powerline-status
# source /usr/share/powerline/bindings/zsh/powerline.zsh

# 加载插件：命令自动完成
# source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 加载插件：命令语法高亮
# 官网提示要在配置文件的最后一行
# source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##########################################################
# 手动配置插件

# 命令自动完成的颜色太暗  # ,bg=cyan
# https://github.com/zsh-users/zsh-autosuggestions#suggestion-highlight-style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#006799,bold"

```

## Linux 常用工具

    Linux 命令速查

        https://man7.org/linux/man-pages/index.html

        GNU 按用途分类介绍
            https://www.gnu.org/software/coreutils/manual/html_node/index.html#SEC_Contents

        常用工具 coreutils 包清单
            https://manpages.debian.org/unstable/coreutils/index.html

        按内容搜索包
            https://www.debian.org/distrib/packages#search_contents

    GNU 按软件包分类

        https://www.gnu.org/manual/manual.html

    简易 GNU 软件列表

        https://www.gnu.org/software/software.en.html#allgnupkgs

    带说明的 GUN 软件列表

        https://directory.fsf.org/wiki/GNU

### man/info 查看帮助信息

man 查看各章节后缀用.数字即可

    man signal.7

    man 7 signal

用 `apropos` 命令来查找相关联的帮助

    $ apropos sysctl
    _sysctl (2)          - read/write system parameters
    sysctl (2)           - read/write system parameters
    sysctl (8)           - configure kernel parameters at runtime
    sysctl.conf (5)      - sysctl preload/configuration file
    sysctl.d (5)         - Configure kernel parameters at boot
    systemd-sysctl (8)   - Configure kernel parameters at boot
    systemd-sysctl.service (8) - Configure kernel parameters at boot

### Vim 和 nano

    https://vim-jp.org/vimdoc-en/scroll.html

    https://vimcdoc.sourceforge.net/doc/help.html

最基础的版本是类似 vi 的 vim tinny 版本，不支持语法高亮、窗口拆分等各种高级功能。

vim 安装见章节 [使用状态栏工具等扩展插件的先决条件]。

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

插件管理器见下面相关章节

颜色方案

    推荐北极，作为插件安装即可 https://www.nordtheme.com/ports/vim

    vim-airline 和 lightline 都内置的一个养眼主题
        papercolor https://github.com/NLKNguyen/papercolor-theme

    material https://github.com/material-theme/vsc-material-theme

    夜猫子 https://github.com/sdras/night-owl-vscode-theme

插件大全列表

    https://vimawesome.com/

##### 使用状态栏工具等扩展插件的先决条件

检查 vim 的版本，进入 vim 执行命令 :version

    Small version without GUI.

如果出现上述字样，说明当前系统只安装了兼容 vi 模式的精简版 vim.tiny，不支持彩色语法高亮、切分窗口等高级功能（vim 内置插件）

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

然后安装 vim 的增强版

    # https://askubuntu.com/questions/284957/vi-getting-multiple-sorry-the-command-is-not-available-in-this-version-af
    # 不用单独装 sudo apt install vim-runtime
    # 不用单独装 sudo apt install vim-gui-common 这个是给linux桌面用的
    $ sudo apt install vim
    The following NEW packages will be installed:
        vim vim-common vim-runtime

    # 安装个文档
    suodu apt install vim-doc

    # 可选安装各种脚本 https://github.com/vim-scripts
    sudo apt install vim-scripts

然后在 vim 中运行命令 :version

    Huge version without GUI.

确认如上字样即可。

要启用彩色语法高亮、状态栏彩色，包括tmux中vim使用彩色，需要编辑 ~/.vimrc 文件，添加如下行

```vim

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

##### 不推荐状态栏工具 powerline

    推荐使用替代品 vim-airline，状态栏和标签栏都有，而且可以配合很多知名插件的显示

powerline 介绍，参见章节 [状态栏工具 powerline]。

使用 powerline 在 vim 下的插件需要 Vim 在编译时添加 python 支持，而一般的用于嵌入式设备的操作系统如树莓派自带的是 vim 精简版 vim.tinny，这个版本是无法使用该插件的，如何解决见上面的“使用状态栏工具等扩展插件的先决条件”。

powerline 为保证多样性，使用python实现的。现在的问题是操作系统自带的 python 指的 python2 还是 python3 版本

    搞清 操作系统安装的包 python-pip 和 python3-pip 的使用区别
    搞清 powerline 有 python 和 python3 两个发行版本
    搞清 操作系统默认的 python 环境是 python 还是 python3
    搞清 你安装的 powerline 到底是用 python 还是 python3 执行的？如果是用 apt install 安装的是使用发行版环境的。
    搞清 所有的 powerline 的插件，安装前都要先看看到底支持哪个python版本？
    搞清 前面这堆 python 到底是指 python2 还是 python3 ？如果是python3，最低要求 3.6 还是 3.7 ？
    搞清 在 virtualenv/conda 下使用vim会否影响其使用python的插件？

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

##### 更简洁的状态栏工具 lightline.vim

    https://github.com/itchyny/lightline.vim

如果你想只安装个干净的工具栏，其它插件自己配置自己玩的话，状态栏工具用这个 lightline.vim 就足够了。

Why yet another clone of powerline?

    [vim-powerline](https://github.com/Lokaltog/vim-powerline)  is a nice plugin, but deprecated.

    powerline is a nice plugin, but difficult to configure.

    vim-airline is a nice plugin, but it uses too many functions of other plugins, which should be done by users in .vimrc.

这个比较简洁，只有状态栏工具和颜色方案。也是不使用 python 代码，都用 vim script 写的，速度和兼容性都有保证。

vim.tinny 版是无法使用该插件的，如何解决见章节 [使用状态栏工具等扩展插件的先决条件]。

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

    :bd 我们可以将 netrw 理解为，使用编辑命令对于目录进行操作的特殊缓冲区。也就是说，我们可以使用 :bdelete 命令，来关闭 netrw 打开的缓冲区，但不会退出 Vim。

可设置打开文件的方式

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

##### 推荐：插件管理器 vim-plug

Vundle不更新了，这个项目取代之，用法神似，只需要编辑 ~/.vimrc，便于用户自定义，安装使用 github 来源的插件非常简单

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
Plug '/usr/share/vim/addons/plugin/vim-airline'
Plug '/usr/share/vim/addons/plugin/vim-airline-themes'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" 在侧边显示git修改状态
Plug 'airblade/vim-gitgutter',

" 显示 vim 寄存器的内容
" 在 vis mode 有点小问题 https://github.com/junegunn/vim-peekaboo/issues/22
" Peekaboo extends " and @ in normal mode and <CTRL-R> in insert mode so you can see the contents of the registers.
Plug 'junegunn/vim-peekaboo'

" 注意颜色主题需要使用命令 colorscheme xxx 才能启用
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
```

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

结合我自己使用的插件和 airline 的配置，vim 编辑后无需退出，运行命令 `:source ~/.vimrc` 重新加载即可。

```vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim 的默认设置
"   全局配置文件 /etc/vim/vimrc
"   启动脚本 /usr/share/vim/vim81/default.vim
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
let mapleader="\<space>"

 " 删除行尾空格，普通模式下连续按3次空格
 nmap <leader><Space><Space> :%s/\s\+$//<cr>

" 开启了自动注释和自动缩进对粘帖代码不方便
"set fo-=r  "关闭自动注释
"set smartindent "识别花括号、c语言格式的自动缩进
"set noautoindent  "关闭自动缩进（新增加的行和前一行使用相同的缩进，这个对C/C++代码好像无效） :set autoindent
"set nocindent  "关闭C语言缩进  :set cindent
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
"   见章节 [插件管理器 vim-plug] 里的示例配置
"   见章节 [插件管理器 vim-addon-manager]，用命令的方式对插件进行管理，不需要配置文件

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

" 不使用自定义的 colorscheme 会使 vim 背景跟随终端模拟器背景图片
" 使用下载的主题插件自带的语法高亮的色彩方案
"colorscheme PaperColor  " 支持设置背景色
colorscheme nord

" 设置背景色(需要主题支持)，切换语法颜色方案使用亮色还是暗色
"set background=dark
"set background=light

" 如果终端工具设置了背景图片，而你的colorscheme背景色挡住了图片，开启这个设置强制透明
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

在普通模式下输入：即可切换到命令行模式，然后输入命令后回车。

最方便的地方是：命令键可以组合使用，比如 2dd 是执行2次删除操作，"0p 粘贴复制寄存器的内容。

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
    :%s/old/new/gc  替换，搜索整个文件，将所有的 old 替换为 new，每次都要你确认是否替换，可根据提示选择a=all

删除复制粘贴

    J     删除行尾的换行，将下一行和当前行连接为一行，中间用空格分隔，不添加空格使用命令 gJ。

    x     删除当前字符
    X     删除前一个字符

    dd    删除光标所在行
    dw    删除一个字(word)

    d$    删除到行末，或 D
    d^    删除到行首

    NOTE: 删除操作其实是剪切，详见下面章节 [vim寄存器--删除是剪切操作]

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

    按 Ctrl + v 键，从光标位置开始进逐字符的列多选，操作同上。

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

##### 命令行模式 command mode

在普通模式下，用户按冒号:键即可进入命令行模式下，此时 vi 会在显示窗口的最后一行（通常也是屏幕的最后一行）显示一个:作为命令行模式的说明符，等待用户输入命令。多数文件管理命令都是在此模式下执行的（如把编辑缓冲区的内容写到文件中等）。

命令行命令执行完后，vi 自动回到普通模式。

在vim中输入的命令，也可编辑 ~/.vimrc 文件配置。

退出编辑器

    即使缓冲区打开了多个文件，一次q就会全部退出，不需要挨个退出。

    如果有多个标签页或窗口，需要挨个执行q退出

    :w      将缓冲区写入文件，即保存修改
    :wq     保存修改并退出
    :x      保存修改并退出
    :q      退出，如果对缓冲区进行过修改，则会提示
    :q!     强制退出，放弃修改

    :w !sudo tee %      用于 vim /etc 内的文件，等保存时才发现没权限。曲线方法是先保存个临时文件，退出后再sudo cp回去。实际上在vim里面可以直接完成这个过程的。:w!{cmd}，让vim执行一个外部命令{cmd}，然后把当前缓冲区的内容从stdin传入。tee是一个把stdin保存到文件的小工具。%，是vim当中一个只读寄存器的名字，总保存着当前编辑文件的文件路径。

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

##### 查看命令历史

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

    :next 切换到下个文件（的缓冲区，下同）
    :prev 切换到前个文件（的缓冲区）

    :next！ 不保存当前编辑文件并切换到下个文件
    :prev！ 不保存当前编辑文件并切换到上个文件

    :wnext 保存当前编辑文件并切换到下个文件
    :wprev 保存当前编辑文件并切换到上个文件

在当前窗口默认只显示缓冲区中的一个文件

    :ls         显示缓冲区里的文件列表，即 vim 打开的文件列表

    :b num      切换显示文件（其中 num 为 buffer list 中的编号）
                NOTE: 缓冲区中的编号不是1，2，3的顺序分布。

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

在 vim 术语中，窗口是缓冲区的显示区域，窗口与缓冲区并非一一对应的关系。

既可以打开多个窗口，在这些窗口中显示同一个文件，也可以在每个窗口里载入不同的文件。

    :sp   当前窗口水平切分为两个窗口，或 :split
    :vs   当前窗口垂直切分为两个窗口，或 :vsp :vsplit
    上述两个命令后跟文件名会在新窗口打开该文件

    前导 Ctrl+w，然后 方向键        切换到前／下／上／后一个窗口
    前导 Ctrl+w，然后  h/j/k/l     同上
    前导 Ctrl+w，然后  w           依次向后切换到下一个窗口中

    :q      关闭当前窗口

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

建议使用 vim-airline 自带的标签页功能进行切换，详见章节 [.vimrc配置文件样例]。

根据这个文章我自定义热键用 Alt 总是设置不上，用的 Ctrl+w 解决了，不知道咋回事，待研究

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

        新建一个 tmux 会话 ，在开机脚本(Service等）中调度也不会关闭
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

    # 重新加载当前的 Tmux 配置
    tmux source-file ~/.tmux.conf

#### 快捷键

MacOS 下可以做映射 <https://www.joshmedeski.com/posts/macos-keyboard-shortcuts-for-tmux/>

组合键 ctrl+b 作为前导，松开后再按其它键：

会话（Session）

    ?       显示所有快捷键，使用pgup和pgdown翻页，按q退出(其实是在vim里显示的，命令用vim的)

    :       进入命令行模式，可输入命令如：
                show-options -g  # 显示所有选项设置的参数，使用pgup和pgdown翻页，按q退出
                set-option -g display-time 5000 # 提示信息的持续时间；设置足够的时间以避免看不清提示，单位为毫秒

    s       列出当前会话，通过上、下键切换，回车确认切换到该会话的默认窗口。
            下面表示0号会话有2个窗口，是当前连接，1号会话有1个窗口
                (0) + 0: 2 windows (attached)
                (1) + 1: 1 windows

    w       列出当前会话的所有窗口，通过上、下键切换，回车确认连接到该窗口。
            新版tmux按树图列出所有会话的所有窗口，切换更方便，不需要先s选择会话了。

    $       重命名当前会话；这样便于识别

    [       copy-mode模式，用于查看历史输出（默认只显示一屏），使用pgup和pgdown翻页，按q退出

    d       脱离当前会话返回你的Shell，tmux里面的所有会话在后台继续运行，会话里面的程序不会退出。
            如果ssh突然断连，也是相同的效果，下次登陆后在命令行运行 `tmux a` 就能重新连接到之前的会话

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

要设置状态栏彩色，包括tmux中vim使用彩色，需要编辑 ~/.tmux.conf 文件，添加如下行

    # 设置状态栏工具显示256彩色
    # 如果终端工具已经设置了变量 export TERM="xterm-256color"，那么这个参数可有可无
    set -g default-terminal screen-256color
    # 真彩色
    # https://github.com/tmux/tmux/wiki/FAQ#how-do-i-use-rgb-colour
    #   https://github.com/tmux/tmux/raw/master/tools/24-bit-color.sh
    #set -as terminal-features ",xterm-256color:RGB"  # tmux 3.2+
    set -as terminal-overrides ",xterm-256color:RGB"

多彩色设置的其它依赖项，详见章节 [终端模拟器和软件的真彩色设置]。

##### 状态栏显示使用 powerline

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

###### 替换 powerline 状态栏显示

安装 nord 主题，使用这个主题的好处是它支持 <https://github.com/tmux-plugins> 的所有插件，可以在状态栏显示图标字符，启动速度也比 powerline 快。

注意终端工具也需要启用 nord 主题，否则颜色方案会不一致

    https://www.nordtheme.com/ports/tmux
        https://github.com/arcticicestudio/nord-tmux

不使用插件管理器的安装步骤：

先从 github 下载

    git clone --depth=1 https://github.com/arcticicestudio/nord-tmux ~/.tmux/themes/nord-tmux

将下述命令添加到.tmux.conf文件中

    run-shell "~/.tmux/themes/nord-tmux/nord.tmux"

重新加载配置文件

    tmux source-file ~/.tmux.conf

还可以安装 tmux-powerline，这个只使用 bash 脚本实现

    https://github.com/erikw/tmux-powerline

##### 插件管理

感觉 tmux 就别折腾各种插件了。。。

    插件管理器 https://github.com/tmux-plugins/tpm

    高亮关键字 https://github.com/tmux-plugins/tmux-prefix-highlight

+ 保存 tmux 会话设置，以便计算机重启后快速恢复

        https://github.com/tmux-plugins/tmux-continuum

        https://github.com/tmux-plugins/tmux-resurrect

    配置

        # 将下述命令添加到.tmux.conf文件中
        run-shell ~/.tmux/tmux-resurrect/resurrect.tmux
        run-shell ~/.tmux/tmux-continuum/continuum.tmux

        # Tmux Continuum 默认每隔 15 分钟备份一次，如果你频率过高，可以设置为 1 小时一次：
        set -g @continuum-save-interval '60'

        # 重载配置文件使之生效
        tmux source-file ~/.tmux.conf

    使用方法

    手动保存tmux会话

        前缀键(Ctrl-b) + Ctrl-s 此时 ，左下角 tmux 状态栏会显示 saving ... 字样 ， 完毕后会提示 Tmux environment saved字样表示 tmux 环境已保存 。

        Tmux Resurrect 会将 Tmux 会话的详细信息以文本文件形式保存到 ~/.tmux/resurrect 目录 。

    手动还原tmux会话： 前缀键(Ctrl-b) + Ctrl-r，Tmux Continuum 会读取之前在 Tmux Resurrect 保存的会话配置并按此恢复 tmux

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
#set -as terminal-features ",xterm-256color:RGB"  # tmux 3.2+
set -as terminal-overrides ",xterm-256color:RGB"

# 状态栏使用 nord 主题，替换掉 powerline
# run-shell 'powerline-config tmux setup'
run-shell "~/.tmux/themes/nord-tmux/nord.tmux"

```

重新加载配置文件

    tmux source-file ~/.tmux.conf

#### 类似 tmux 的工具 screen

    https://www.cnblogs.com/bamanzi/p/switch-tmux-to-gnu-screen.html

安装发行版的即可

    sudo apt install screen

在Screen环境下，所有的会话都独立的运行，并拥有各自的编号、输入、输出和窗口缓存。

用户可以通过快捷键在不同的窗口下切换，并可以自由的重定向各个窗口的输入和输出。GNU Screen的窗口与区域关系更接近Emacs里面buffer与window的关系：

    gnu screen里面的region相当于tmux里面的pane，而screen的window更类似于跑在tmux pane里面的程序；与tmux不同的是，一般情况下程序/窗口是隐藏的，每次只把一个程序/窗口切换到当前region来（tmux里面一般情况下所有程序都会在某个window的某个pane里面显示者，除非有其它pane被最大化导致当前pane被隐藏了）

    GNU Screen里面没有tmux里面的window那样的东西，它的layout倒是跟tmux的window有点像，虽然我们可以从一个layout切换到另外一个layout，但layout只是region的容器，而不是window的容器，两个layout里面是可以查看同一个应用(window)的．

Screen实现了基本的文本操作，如复制粘贴等；还提供了类似滚动条的功能，可以查看窗口状况的历史记录。窗口还可以被分区和命名，还可以监视后台窗口的活动。

Screen 支持 Zmodem 协议，也就是说，你可以用 rz、sz 命令方便的传输文件 <https://adammonsen.com/post/256/>。

会话共享 Screen可以让一个或多个用户从不同终端多次连接到同一个会话，并共享会话的所有特性（比如可以看到完全相同的输出）。它同时提供了窗口访问权限的机制，可以对窗口进行密码保护。

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

    d      退出当前的screen界面回到初始的shell，当前运行的会话进程不关闭，其中的程序会继续运行

    c     在当前screen会话中创建窗口

    w         数字显示窗口列表
    "         上下光标键可选择的窗口列表
    C-a       在两个最近使用的 window 间切换
    [Space]   由视窗0循序切换到视窗9
    0-9       在第0个窗口和第9个窗口之间切换
    n         下一个窗口
    p         上一个窗口

    x      锁屏(需要你有该Linux登录用户的登录密码才能解锁，否则，当前的会话终端算是废了，你需要重新打开一个终端才行)(锁屏后，重新登录一个设置过密码的screen会话，你需要输入2次密码，第一次是输入Linux系统的登录密码，第二次是输入该screen会话的密码)

    S    屏幕水平分割
    |    屏幕垂直分割
    [tab] 在各个区块间切换，每一区块上需要再次用 Ctrl+a c 创建窗口。
    X     关闭当前焦点所在的屏幕区块,关闭的区块中的窗口并不会关闭，还可以通过窗口切换找到它。
    Q     关闭除当前区块之外其他的所有区块,关闭的区块中的窗口并不会关闭，还可以通过窗口切换找到它。

会话共享

还有一种比较好玩的会话恢复，可以实现会话共享。假设你在和朋友在不同地点以相同用户登录一台机器，然后你创建一个screen会话，你朋友可以在他的终端上命令：

    screen -x

这个命令会将你朋友的终端Attach到你的Screen会话上，并且你的终端不会被Detach。这样你就可以和朋友共享同一个会话了，如果你们当前又处于同一个窗口，那就相当于坐在同一个显示器前面，你的操作会同步演示给你朋友，你朋友的操作也会同步演示给你。当然，如果你们切换到这个会话的不同窗口中去，那还是可以分别进行不同的操作的。

### Midnight Commander 命令行下的文件资源管理器

    # https://midnight-commander.org/ https://github.com/MidnightCommander/mc
    # https://sourceforge.net/projects/mcwin32/files/
    sudo apt install mc

命令行下使用两个面板来处理文件和目录，类似 [Far Manager](https://conemu.github.io/en/FarManager.html)。

### reptyr 从 pid 把后台任务调回前台

reptyr

    # https://github.com/nelhage/reptyr
    sudo apt install reptyr

从你的当前终端连接指定的 pid，适用于把 Ctrl+Z 挂起到后台的任务重新调用回前台。

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

xargs 命令是给其他命令传递参数的一个过滤器，常作为组合多个命令的一个工具。它主要用于将标准输入数据转换成命令行参数，xargs 能够处理管道或者标准输入并将其转换成特定命令的命令参数。也就是说 find 的结果经过 xargs 后，其实将 find 找出来的文件名逐个传递给 grep 做参数，grep 再在这些文件内容中查找关键字 test。

    ls /xx | xargs -t -I{} cp {} /tmp/{}

        -t ： 打印内容，去掉\n之后的字符串

        -I : 后面定义占位符，

    上例子是{} ，后面命令行中可以多次使用占位符### 字符串处理 awk sed cut tr wc

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

awk 指定分隔符，可以用简单的语句组合字段

sed 删除、替换文件中的字符串

    在文件的匹配行前面加上#注释
    #   // 模式匹配，可匹配文字中的空格，后面的 s// 替换操作是在前面模式匹配到的行中做
    #   s       替换
    #   ^       开头匹配
    #   [^#]    匹配非#
    #   #&      用&来原封不动引用前面匹配到的行内容，在其前面加上#号
    #   g       全部（只匹配特定行不加g）
    sed '/^static domain_name_servers=8.8.8.8/ s/^[^#].*domain_name_servers.*/#&/g' /etc/dhcpcd.conf

    在文件的匹配行前面取消#注释
    #   // 模式匹配，可匹配文字中的空格，后面的 s// 替换操作是在前面模式匹配到的行中做
    #   ^#//    去掉代表开头的#
    sed '/^#static domain_name_servers=192.168.1.1/ s/^#//' /etc/dhcpcd.conf

    # 给所有没有#开头的行改为#开头
    # sed '/[^#]/ s/^[^#]/#&/' /etc/dhcpcd.conf
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

### 终端输出字符的后处理工具

格式化 JSON 数据，并彩色显示，也可用作格式检查

    # sudo apt install jq
    cat config.json |jq

对程序的输出同时打印到文件和屏幕

    ls -al | tee file.txt

#### ackg 给终端输出的自定义关键字加颜色

hhighlighter 给终端输出的自定义关键字加颜色，非常适合监控日志输出调试程序使用

    https://github.com/paoloantinori/hhighlighter
        主要封装的是 ack --passthru 的透传和着色
            https://linux.die.net/man/1/ack
                https://beyondgrep.com/
                    https://github.com/beyondgrep/ack3/

    竞品 https://github.com/Scopart/colorex/

    https://www.cnblogs.com/bamanzi/p/colorful-shell.html

脚本名和函数名都太简单了，都换成不易混淆的 ackg 吧

    # 先安装依赖 ack https://wangchujiang.com/linux-command/c/ack.html
    # sudo apt install ack

    cd /usr/local/bin/

    sudo curl -fsSLo ackg.sh https://github.com/paoloantinori/hhighlighter/raw/master/h.sh

    sudo sed -i 's/h()/ackg()/' ackg.sh

然后测试你感兴趣的文字，支持 -i 忽略大小写，支持 perl 形式的正则表达式

    # 先 source 一下就可以在 shell 下使用它的同名函数了
    source ackg.sh

    # 等效 echo abc | ack --flush --passthru --color --color-match=red a | ack --flush --passthru --color --color-match=yellow b
    echo "abcdefghijklmnopqrstuvxywz" |ackg a b c d e f g h i j k l

    ps -ef |ackg 'root|ssh' "$(whoami)"  '\d{2}:\d{2}:\d{2}'

    # \b 是perl正则表达式的单词限定符 https://perldoc.perl.org/perlre
    cat /var/log/kern.log.1 |ackg -i 'Fail|Error|\bNot\b|\bNo\b|Invalid' '\bOk\b|Success|Good|Done|Finish' 'Warn|Timeout|\bDown\b|Unknown|Disconnect|Restart'

### dd 写入文件

dd 命令是基于块（block）的复制，用途很多。

用 boot.img 制作启动盘

    dd if=boot.img of=/dev/fd0 bs=1440k

读取挂载在存储设备上的 iso 文件，进行 gpg 校验

    dd if=/dev/sdb | gpg --keyid-format 0xlong --verify my_signature.sig -

将本地的 /dev/hdb 整盘备份到 /dev/hdd

    dd if=/dev/hdb of=/dev/hdd

将 /dev/hdb 全盘数据备份到指定路径的 image 文件

    dd if=/dev/hdb of=/root/image

将备份文件恢复到指定盘

    dd if=/root/image of=/dev/hdb

备份 /dev/hdb 全盘数据，并利用 gzip 工具进行压缩，保存到指定路径

    dd if=/dev/hdb | gzip > /root/image.gz

将压缩的备份文件恢复到指定盘

    gzip -dc /root/image.gz | dd of=/dev/hdb

备份与恢复 MBR

备份磁盘开始的 512 个字节大小的 MBR 信息到指定文件：

    # count=1指仅拷贝一个块；bs=512指块大小为512个字节。
    dd if=/dev/hda of=/root/image count=1 bs=512

恢复：

    # 将上面备份的MBR信息写到磁盘开始部分
    dd if=/root/image of=/dev/had

备份软盘

    dd if=/dev/fd0 of=disk.img count=1 bs=1440k (即块大小为1.44M)

拷贝内存内容到硬盘

    dd if=/dev/mem of=/root/mem.bin bs=1024 (指定块大小为1k)

拷贝光盘内容到指定文件夹，并保存为 cd.iso 文件

    dd if=/dev/cdrom(hdc) of=/root/cd.iso

### 快速清理文件和快速建立文件

最快建立大文件的方式是用 truncate 命令

    # dd if=/dev/zero of=fs.img bs=1M count=1M seek=1024
    truncate --size 10G test.db.bak

快速清理文件

    # truncate -s 0 /var/log/yum.log
    > your_file.txt

+ 删除大量文件

    删除数量巨大的文件， rm * 报错，用 find 命令遍历目录挨个传参数的办法删除，虽然慢但是能做，注意用后台命令，不然挂好久

        find /tmp -type f -exec rm {} \; &

        find /home -type f -size 0 -exec rm {} \;

    最快方法

        https://web.archive.org/web/20130929001850/

        http://linuxnote.net/jianingy/en/linux/a-fast-way-to-remove-huge-number-of-files.html

        mkdir empty && rsync -r --delete empty/ some-dir && rmdir some-dir

### 压缩解压缩

tar 命令的选项和参数有几种写法，注意区别

    GUN 传统写法没横线，多个单字母选项合起来写在第一个参数位

        tar vcf a.tar /tmp

    UNIX 写法用 -选项1 选项1自己的参数 -选项2 选项2自己的参数

        tar -c -v -f a.tar /tmp

        tar -cvf a.tar /tmp  # 没有参数的选项合写

        tar -vkp -f a.tar /tmp  # f也可以合写，但是要在最后一个，以便后面跟参数

    GUN 写法用 -- 或 -，连写用一个 -

        # --选项 后面紧跟空格参数
        tar --create --file a.tar --verbose /tmp

        # -- 也可以用单字母选项连写，但是要保证没有歧义
        # -- 选项用=连接参数，中间没有空格。可选参数必须始终使用这种方法
        tar --cre --file=a.tar --verb /tmp

.tar.gz 文件

    # c打包并z压缩，生成.tar.gz文件，源可以是多个文件或目录名
    # 只c打包，生成 .tar 文件，其它参数相同
    # 把 z 换成 j 就是压缩为.bz2文件，而不是.gz文件了
    tar czvf arc.tar.gz file1 file2
    tar cjvf arc.tar.bz2 file1 file2

    # 解包并解压缩, 把 x 换成 t 就是只查看文件列表而不真正解压
    tar xzvf arc.tar.gz
    tar xjvf xx.tar.bz2

    # 把 /home 目录打包，输出到标准输入流，管道后面的命令是从标准输出流读取数据解包
    tar cvf - /home |tar -xvf -

    # curl下载默认输出是标准输入流，管道后面的命令是tar从标准输出流读取数据解压到指定的目录下
    curl -fsSL https://go.dev/dl/go1.19.5.linux-armv6l.tar.gz |sudo tar -C /usr/local -xzvf -

    大文件压缩，注意加参数 d 校验

    # 打包并加密
    tar cjf - <path> | gpg --cipher-algo AES -c - > backup.tbz2.gpg

    # 解密并解包
    cat backup.tbz2.gpg | gpg - | tar djf -

.gz 文件

    # 解压
    #gunzip FileName.gz
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

    # 把当前目录打包到tar，用zip
    tar cf - . | zip backup -

    # 只查看文件列表
    unzip -l arc.zip

使用 zless、zmore、zcat 和 zgrep 对压缩过的文件进行查看等操作。

.xz 文件

    # 把 foo.tar.xz 解压缩为 foo.tar
    xz -d foo.tar.xz

    # 把文件 foo 压缩为 foo.xz
    xz foo

### 文件链接 ln

ln 命令默认生成硬链接，但是我们通常使用软连接

    # 主要是给出链接的目标文件，可以多个，最后的是保存软链接的文件目录
    # 如果省略最后的目录，默认就是当前目录保存，软连接文件名默认跟目标文件同名
    # 如果最后的目录给出的是一个文件名，则就是在当前目录下建立软链接文件
    ln -s /tmp/cmd_1 /tmp/cmd_2 /usr/bin/

### 文件完整性校验 sha256

Linux 下，每个算法都是单独的程序：cksum md5sum sha1sum sha256sum sha512sum

直接传递文件名操作即可

生成

    # 生成 crc 校验和以及字节数
    $ cksum test.json
    1758862648 4855 test.json

    # 生成sha256校验文件
    $ sha256sum file > file.sha256

    # 生成多个文件的sha256校验
    $ sha256sum a.txt b.txt > checksums.sha256
    $ more checksums.sha256
    17e682f060b5f8e47ea04c5c4855908b0a5ad612022260fe50e11ecb0cc0ab76  a.txt
    3cf9a1a81f6bdeaf08a343c1e1c73e89cf44c06ac2427a892382cae825e7c9c1  b.txt

    # 对当前目录下找到的所有文件，生成校验码
    find . -type f -exec sha256sum \{\} \; > checksum-file

校验

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

### 带精度的计算器

bc - An arbitrary precision calculator language

    # sudo apt install jq
    $ echo '1 / 6' |bc -l
    .16666666666666666666

### 生成随机数

    https://huataihuang.gitbooks.io/cloud-atlas/content/os/linux/device/random_number_generator.html

在 Linux 中，有两类用于生成随机数的设备，分别是 /dev/random 以及 /dev/urandom ，其中前者可能会导致阻塞，而读取 /dev/urandom 不会堵塞，不过此时 urandom 的随机性弱于 random 。 urandom 是 unblocked random 的简称，会重用内部池中的数据以产生伪随机数据，可用于安全性较低的应用。

    # 对随机数取哈希，用 cksum 取 crc 校验和，还可以用 sha256sum、md5sum 等
    $ head /dev/random | cksum
    3768469767 1971

    # 对随机数转化为16进制2字节一组，取第一行
    $ cat /dev/urandom | od  -An -x | head -n 1
    0637 34d5 16f5 f393 250e a2eb aac0 27c3

    # 对随机数只取字符和数字，9个一行，取第一行
    $ cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 9 | head -n 1
    DPTDA9W29

    # 对随机数只取字符和数字，取前14个
    $ cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 14
    cFW4vaqucb4K4T

    # base64编码的14个字符
    $ openssl rand -base64 14
    lPIm1hobPBr+iaUXLSk=

    # 16进制编码的20个字符
    $ openssl rand -hex 20
    f231202787c01502287c420a8a05e960ec8f5129

    # 14个ascii字符
    $ gpg --gen-random --armor 1 14
    RaJKEUBT89Tq9uZzvkI=

    # 生成一个uuid，这个也是随机的
    $ cat /proc/sys/kernel/random/uuid
    6ab4ef55-2501-4ace-b069-139855bea8dc

    # 这个shuf不知道是否伪随机
    # 把数字 5-12 直接乱序排序，每行一个数字，输出1行
    $ shuf -i5-12 -n1
    9

补充熵池

随机数生成的这些工具，通过 /dev/random 依赖系统的熵池，而服务器在运行时，既没有键盘事件，也没有鼠标事件，那么就会导致噪声源减少。很多发行版本中存在一个 rngd 程序，用来增加系统的熵池（用 urandom 给 random 灌数据），详见章节 [给random()增加熵] <init_a_server.md think>。

### od 按数制显示内容

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
    od -tcx aa.txt

    # 以 ASCII 码的形式显示文件aa.txt内容的，等效 -ta
    od -a aa.txt

### Aria2 下载工具

TODO: 命令行传输各种参数，设置复杂。

    Aria2 Linux下一键安装管理脚本 增强版 https://github.com/P3TERX/aria2.sh
        Aria2 完美配置 https://github.com/P3TERX/aria2.conf

    每日更新tracker
        https://github.com/ngosang/trackerslist
        https://github.com/XIU2/TrackersListCollection

    Aria2 Pro: 基于 Aria2 完美配置和特殊定制优化的 Aria2 Docker
        https://p3terx.com/archives/docker-aria2-pro.html
            https://github.com/P3TERX/Aria2-Pro-Docker
            https://hub.docker.com/r/p3terx/aria2-pro

        docker run -d \
            --name aria2-pro \
            --restart unless-stopped \
            --log-opt max-size=1m \
            --network host \
            -e PUID=$UID \
            -e PGID=$GID \
            -e RPC_SECRET=<TOKEN> \
            -e RPC_PORT=6800 \
            -e LISTEN_PORT=6888 \
            -v $PWD/aria2-config:/config \
            -v $PWD/aria2-downloads:/downloads \
            p3terx/aria2-pro

    配置本机防火墙开放必要的入站端口，内网机器在路由器设置端口转发到相同端口。
    使用你喜欢的 WebUI 或 App 进行连接，强烈推荐 AriaNg

简单使用： Windows 下载开源的GUI程序 [Motrix](https://github.com/agalwood/Motrix) 即可，该软件最大的优点是自动更新最佳 dht 站点清单。

浏览器搜索插件：aria2 相关，安装后设置aip-key，可在浏览器中直接调用Motrix运行的aria2进程。

这是 Motrix 生成的启动命令行

    aria2c.exe --conf-path=C:\tools\Motrix\resources\engine\aria2.conf --save-session=C:\Users\XXXX\AppData\Roaming\Motrix\download.session --input-file=C:\Users\XXXX\AppData\Roaming\Motrix\download.session --allow-overwrite=false --auto-file-renaming=true --bt-load-saved-metadata=true --bt-save-metadata=true --bt-tracker=udp://93.158.213.92:1337/announce,udp://151.80.120.115:2810/announce  --continue=true --dht-file-path=C:\Users\XXXX\AppData\Roaming\Motrix\dht.dat --dht-file-path6=C:\Users\XXXX\AppData\Roaming\Motrix\dht6.dat --dht-listen-port=26701 --dir=C:\Users\XXXX\Downloads --listen-port=21301 --max-concurrent-downloads=5 --max-connection-per-server=64 --max-download-limit=0 --max-overall-download-limit=0 --max-overall-upload-limit=256K --min-split-size=1M --pause=true --rpc-listen-port=16800 --rpc-secret=evhiwwwwwDiah --seed-ratio=1 --seed-time=60 --split=64 --user-agent=Transmission/2.94

Motrix 使用的 Aria2 来源于他自己的专用 Fork 而非官方发行的预编译包。

建议：

    使用官方 Aria2 v1.36.0 ，配置文件原样复用 Motrix 的 aria2.conf ，使用 WinSW 将 Aria2 安装成用户服务来开机自启，配合 Aria2 for Edge 插件拦截浏览器下载，使用插件附带 AirNG 进行图形化交互。<https://github.com/agalwood/Motrix/issues/1379>。

配置文件 aira2.conf，以 Motrix 为例

```conf

###############################
# Motrix Windows Aria2 config file
#
# @see https://aria2.github.io/manual/en/html/aria2c.html
#
###############################


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

```

### ZModem 文件传输协议工具 rs rz

需要你的终端工具支持 zmodem 协议，使用起来比较方便

    sudo apt install lrzsz

    $ rz
    **B0100000023be50eive.**B0100000023be50

    然后直接把你要发送的文件拖动到你的终端工具窗口

    $ sha1sum your_file

    记得比对下校验码，防止误码

如果嵌入式设备传送文件，没有 sftp、ftp 时，用 rs rz，缺点是速率较慢误码率较高，大文件传送需要自行做 hash 校验。

    https://blog.csdn.net/mynamepg/article/details/81118580

    mintty 不支持 https://github.com/mintty/mintty/issues/235

### netcat(nc) 简单的端口通信

开源项目持续性不稳定，历史较复杂

    原始 nc(netcat)，在 2007 年发布 1.10 稳定版本之后，就不再更新了。它的原始版本是一个类Unix程序，原作者 Hobbit。

    现在一般用的是 GNU 项目维护的 GNU Netcat，维护目的是提升 nc 在其他平台的可移植性的同时保持对原始 nc 的兼容性。安装 netcat后，nc 是 netcat 的 alias，命令行里输入 nc 等于输入 netcat。

    Ncat 是 Nmap 项目的作者 Fyodor，在原始 Netcat 之上新增功能二次开发的另一款强大工具，也就是说 Netcat 有的功能 Ncat 都具备，并且 ncat还有更多强大的功能。安装了 ncat 后，nc、netcat 都成了 ncat 的 alias，命令行里输入这三者都是一样的。

运行服务端

    nc -l 5678

运行客户端

    nc 127.0.0.1 5678 或 telnet 127.0.0.1 5678

客户端输入文字即可显示在服务端

对本机端口转发来说，nc是个临时的端口转发的好工具，永久的端口转发用iptables。

利用netcat远程备份

    # 在源主机上执行此命令备份/dev/hda
    dd if=/dev/hda bs=16065b | netcat < targethost-IP > 1234

    # 在目的主机上执行此命令来接收数据并写入/dev/hdc
    netcat -l -p 1234 | dd of=/dev/hdc bs=16065b

    # 在目的主机上执行此命令来采用bzip2、gzip对数据进行压缩，并将备份文件保存在当前目录。
    netcat -l -p 1234 | bzip2 > partition.img

加强版 socat(socket cat)

    socat 使用手册 https://payloads.online/tools/socat/
    新版瑞士军刀：socat https://zhuanlan.zhihu.com/p/347722248

命令格式

    socat [参数]  <地址1>  <地址2>

使用 socat 需要提供两个地址，然后 socat 做的事情就是把这两个地址的数据流串起来，把左边地址的输出数据传给右边，同时又把右边输出的数据传到左边。

最简单的地址就是一个减号“-”，代表标准输入输出，而在命令行输入：

    socat - -

把标准输入和标准输出对接，输入什么显示什么。除了减号地址外，socat 还支持：TCP, TCP-LISTEN, UDP, UDP-LISTEN, OPEN, EXEC, SOCKS, PROXY 等多种地址，用于端口监听、链接，文件和进程读写，代理桥接等等。

类似 nc 的连通性测试，两台主机到底网络能否联通：

    socat - TCP-LISTEN:8080               # 终端1 上启动 server 监听 TCP
    socat - TCP:localhost:8080            # 终端2 上启动 client 链接 TCP

在终端 1 上输入第一行命令作为服务端，并在终端 2 上输入第二行命令作为客户端去连接。

做简易的端口转发

    把局域网下设备(如Nas、监控摄像头、网络服务器)的IPv4地址的到路由器的IPv6地址上

    socat TCP6-LISTEN:{IPv6端口,远程访问的端口},reuseaddr,fork TCP4:{IPv4地址}:{IPv4端口}

国内目前拨号路由器的端口都被屏蔽了，但是ipv6的端口是放开的。用 socat 简单的实现内网设备的端口转发到路由器对外开放。注意：你的内网设备对外开放端口，安全性由使用该端口的程序自行保障！酌情考虑用 openVPN 进行保护。

### scp 跨机远程拷贝

前提条件

    可以 ssh 登陆才能 scp 文件

scp 使用 rcp 传输文件，使用 ssh 进行身份验证和加密。所以命令行用法跟 rcp 一致。

scp 是利用 ssh 协议的文件拷贝，而 sftp 在此基础上还附加了远程文件管理功能如建立或删除文件、支持断点续传等，单纯看速度 scp 更快。Windows 下二者是 WinSCP 和 FileZilla。

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

    默认设置是使用文件大小和修改时间来判断文件是否需要更新

scp 不占资源，不会提高多少系统负荷，在这一点上，rsync就远远不及它了。虽然 rsync比scp会快一点，但当小文件众多的情况下，rsync会导致硬盘I/O非常高，而scp基本不影响系统正常使用。所以使用时根据自己的情况酌情决定选用哪个。

其实可以在 rsync 下代替 scp

    rsync -e ssh

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

#### 用 rsync 服务从 Linux 到 Windows 和 Linux 进行远程备份

    https://www.zhihu.com/question/20322405/answer/2874017681

一、安装设置服务器端软件

下载 rysnc 的主页地址为：<http://rsync.samba.org>

在两台服务器中都要安装，主服务器上 rsync 以服务器模式运行 rsyn 守护进程，在同步上用 crond 定时任务以客户端方法运行 rsync，同步主服务器上需要同步的内容

    一般 Linux 发行版自带的就不必自行编译安装了

    $ tar xvf rsync-2.6.3.tgz

    $ cd rsync-2.6.3

    $ ./configure

    $ make

    $ make install

 rsync服务器的设置文件为 /etc/rsyncd.conf，其操控认证、拜访、日志记载等。

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

### 在当前目录启动一个简单的http服务器

    # Python 2，使用端口 7777
    python -m SimpleHTTPServer 7777

    # Python 3 http服务器的包名变了，使用端口 7777
    python3 -m http.server 7777

### 字符终端下的一些小玩具如 figlet、cmatrix 等

    符号字符 https://www.webfx.com/tools/emoji-cheat-sheet/

    unicode编码 http://www.unicode.org/emoji/charts/full-emoji-list.html

    emoji 大全 https://emojipedia.org/
        unicode emoji https://unicode.org/emoji/charts/full-emoji-list.html
        git emoji https://blog.csdn.net/li1669852599/article/details/113336076

小火车sl

    sudo apt install sl

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

### 项目构建工具 Make、Automake、CMake、Ninja

Make

    http://www.gnu.org/software/make/manual/html_node/index.html#SEC_Contents

Make的流行也带动起一批自动生成Makefile的工具，目的就是进一步减轻项目构建中的工作量，让我们程序员全身心投入到开发之中。在这些工具中，不得不提Automake和CMake。

Automake

Automake 其实是一系列工具集 Autotools 中的一员，要想发挥Automake的威力，需要配合使用 Autotools 中的其他工具，例如 autoscan、aclocal、autoconf 和 autoheader。在下面的 Automake 构建流程中，能看到这些工具的身影。

    autoscan：生成 configure.scan

    configure.in：将 configure.scan 重命名为 configure.in 后，修改内容。重点是 AM_INIT_AUTOMAKE 和 AC_CONFIG_FILES 两项，如果没配置的话，下一步的 aclocal 是无法产生 aclocal.m4 的

    aclocal：生成 aclocal.m4

    autoconf：生成 configure

    autoheader：生成 config.h.in，使程序可移植

    Makefile.am：手动编写 Makefile.am。bin_PROGRAMS 指定最终生成可执行文件的名称，helloworld_SOURCES 指定所有源文件

    NEWS AUTHORS README ChangeLog：手动创建

    automake：执行 `automake -a` 生成 Makefile.in

    configure：执行 ./configure 生成Makefile

CMake

重新用CMake生成Makefile，Automake中的9步被压缩到了只需要2步！

    编写CMakeLists.txt

    执行cmake .

Ninja

Ninja通过将编译任务并行组织，大大提高了构建速度。

    https://ninja-build.org/
        https://github.com/ninja-build/ninja

    https://www.cnblogs.com/sandeepin/p/ninja.html

Ninja 还集成了 graphviz 等一些对开发非常有用的工具，执行 `./ninja -t list`

    ninja subtools:

        browse        # 在浏览器中浏览依赖关系图。（默认会在 8080 端口启动一个基于python的http服务）
        clean         # 清除构建生成的文件
        commands      # 罗列重新构建制定目标所需的所有命令
        deps          # 显示存储在deps日志中的依赖关系
        graph         # 为指定目标生成 graphviz dot 文件。
                        如 ninja -t graph all |dot -Tpng -ograph.png
        query         # 显示一个路径的inputs/outputs
        targets       # 通过DAG中rule或depth罗列target
        compdb        # dump JSON兼容的数据库到标准输出
        recompact     # 重新紧凑化ninja内部数据结构

可通过cmake来生成ninja的配置，进而进行编译

    # 生成ninja工程
    cmake -Bbuild -GNinja

    # 运行ninja编译
    ninja

### graphviz 文本生成流程图

    https://www.graphviz.org/

<https://stackoverflow.com/questions/4366511/is-there-a-jquery-plugin-for-dot-language-file-visualization/>
There are three different implementations:

1.Render svg in simple js, no needs install of graphviz

    jquery.graphviz.svg[DEPRECATED] https://github.com/mountainstorm/jquery.graphviz.svg

        jQuery plugin to make Graphviz SVG output more interactive and easier to navigate. Makes it easy to have features like:

        Highlight nodes/edges
        Zoom in/out
        Graph navigation - select linked nodes
        Fancy UI tooltips; bootstrap supported out the box
        Move things forward/back in the graph

        Have a look at the demo: https://cdn.rawgit.com/mountainstorm/jquery.graphviz.svg/master/demo.html

2.Based on d3.js

    d3.js + hpcc-js-wasm https://github.com/magjac/d3-graphviz

        build graphviz to wasm https://github.com/hpcc-systems/hpcc-js-wasm

    d3.js + dagre https://github.com/dagrejs/dagre-d3

        pure js library from graphviz https://github.com/dagrejs/dagre

3.server side call graphviz to generate svg file.

    http://viz-js.com/

        https://github.com/mdaines/viz.js

    https://github.com/dreampuf/GraphvizOnline

### 压力测试

dd 可用于做 i/o 速率测试：

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

    $ $ dd if=/dev/zero of=/tmp/file_01.txt bs=8K count=3000 oflag=dsync
    3000+0 records in
    3000+0 records out
    24576000 bytes (25 MB, 23 MiB) copied, 0.280321 s, 87.7 MB/s

如果要防止硬盘缓存优化，写入量要加大，比如 1 GB 的文件写入速率更客观 bs=64k count=16k

有个现成的工具测试 cpu

    # sudo apt install stress-ng
    stress-ng -c 2 --cpu-method pi --timeout 60
    stress-ng -i 1 --timeout 60
    stress-ng -m 1 --timeout 60

下面是个简单的脚本用于 cpu 加热，入参是cpu的核心数

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

很多发行版用 timedatectl 代替了 ntpd 等服务

    用timedatectl命令操作时间时区  https://www.cnblogs.com/zhi-leaf/p/6282301.html

    网络时间的那些事及 ntpq 详解  https://www.cnblogs.com/GYoungBean/p/4225465.html

一般都使用 systemd 自带的时间同步服务

    $ systemctl status systemd-timesyncd.service
    Warning: The unit file, source configuration file or drop-ins of systemd-timesyncd.service changed on disk. Run 'systemctl daemon-reload' to reload units.
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

timedatectl 查看时间同步服务器状态

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

### 设置替换命令 update-alternatives

linux 版本历经多年的使用，有些命令会出现各种变体，为保持通用，用符号链接的方式统一进行管理

    update-alternatives --all

设置 vi 的变体

查看实际使用版本

    $ readlink -f `which vi`
    /usr/bin/vim.tiny

设置替换版本

    update-alternatives --config vi

### rdesktop

    rdesktop -f -r clipboard:PRIMARYCLIPBOARD -r disk:mydisk=/home/$(whoami)/win-share-dir <ip>

按ctrl + alt +回车退出或进入全屏模式。

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

    4 - 系统保留

    5 - X11 （xwindow)

    6 - 重新启动

init 程序最先运行的服务是放在 /etc/rc.d/ 目录下的文件。

在大多数的Linux 发行版本中，启动脚本都是位于 /etc/rc.d/init.d/ 中的，这些脚本被用 ln 命令连接到 /etc/rc.d/rcX.d/ 目录。(这里的X 就是运行级0-6) ,每个不同级别的目录都链接了 /etc/rc.d/init.d/ 中的一个脚本。

所有这些程序都是可读的shell脚本，SystemV 服务是串行启动的，一次只能启动一个服务，每个启动脚本都被编了号，以便按特定顺序启动预期的服务。可以通读这些脚本确切了解整个启动过程中发生的事情。

注：在较新版本的 Linux 系统中，目录 /etc/rc.d/init.d/ 和 /etc/rc.d/rcX.d/ 简化为 /etc/init.d/ 和 /etc/rcX.d/。

#### SystemV 设置开机自启动

1、在 /etc/init.d/ 目录下添加需要执行的 .sh 脚本，脚本里调用需要开机启动的程序（shell文件格式参考目录下其它文件）

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

大多数 Linux 发行版都过渡到使用 systemd 管理系统了，但还是有讨厌 systemd 的发行版：Devuan 是使用 SysV init 软件代替 Debian systemd 包的 Debian 分支，提供了多种初始化系统供用户选择，其中包括 SysV init、sinit、openrc、runit、s6 和 shepherd

    https://www.devuan.org/

systemd 工具是编译后的二进制文件，但该工具包是开放的，因为所有配置文件都是 ASCII 文本文件。可以通过各种 GUI 和命令行工具来修改启动配置，也可以添加或修改各种配置文件来满足特定的本地计算环境的需求。几乎可以管理正在运行的 Linux 系统的各个方面。它可以管理正在运行的服务，同时提供比 SystemV 多得多的状态信息。它还管理硬件、进程和进程组、文件系统挂载等。systemd 几乎涉足于现代 Linux 操作系统的每方面，使其成为系统管理的一站式工具。

    systemd 在启动阶段并行地启动尽可能多的服务。这样可以加快整个的启动速度，使得主机系统比 SystemV 更快地到达登录屏幕。

systemd 并不是一个命令，而是一组命令，涉及到系统管理的方方面面。根据编译过程中使用的选项（不在本系列中介绍），systemd 可以有多达 69 个二进制可执行文件执行以下任务，其中包括：

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

crontab

    crontab命令被用来提交和管理用户的需要周期性执行的任务，与windows下的计划任务类似，当安装完成操作系统后，默认会安装此服务工具，并且会自动启动crond服务，crond进程每分钟会定期检查是否有要执行的任务，如果有则自动执行该任务。依赖于crond服务

anacron

    cron的补充，能够实现让cron因为各种原因在过去的时间该执行而未执行的任务在恢复正常执行一次。依赖于nancron服务

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
    no crontab for user

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

cron 在 crontab 文件中的默认 PATH=/usr/bin:/bin，cron 执行所有命令都用该PATH环境变量指定的路径下去找。

详见章节 [坑：环境变量是单独的跟用户登陆后的环境变量不一样]

### 6、执行结果将以邮件形式发送

    */3 * * * * /bin/cat /etc/fstab > /dev/null         # 错误信息仍然发送给管理员

    */3 * * * * /bin/cat /etc/fstab &> /dev/null         # 所有信息都不发送给管理员，无论是否正确执行

在 /var/mail/ 目录下查看邮件

在 /var/log/syslog 文件查看系统日志，debian默认的 rsyslog 不记录 cron 日志，需要手动开启

注意 /var 的空间不要被填满了

### 坑：区分crontab命令和crontab文件

用 crontab -e 命令配置是针对当前用户的定时任务，而编辑 /etc/crontab 文件是针对系统的任务。

cron服务每分钟不仅要读一次 /var/spool/cron/crontabs/ 内的所有文件，还读一次 /etc/crontab 文件。

使用下面的命令，会在 vi 里打开crontab的内容以供编辑：

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

## cgroup 控制操作系统资源分配

查看当前的服务

    ❯ systemd-cgls
    Control group /:
    -.slice
    ├─user.slice
    │ └─user-1000.slice
    │   ├─session-2.scope
    │   │ ├─  661 zsh
    │   │ ├─  664 zsh
    │   │ ├─  678 zsh
    │   │ ├─  918 tmux
    │   │ └─8519 tmux a
    │   └─user@1000.service
    │     ├─powerline-daemon.service
    │     │ └─872 /usr/bin/python3 /usr/bin/powerline-daemon --foreground
    │     └─init.scope
    │       ├─860 /lib/systemd/systemd --user
    │       └─861 (sd-pam)
    ├─init.scope
    │ └─1 /sbin/init
    └─system.slice
    ├─alsa-state.service
    │ └─385 /usr/sbin/alsactl -E HOME=/run/alsa -s -n 19 -c rdaemon
    ├─systemd-timesyncd.service
    │ └─332 /lib/systemd/systemd-timesyncd
    ├─dbus.service
    │ └─395 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
    ├─ssh.service
    │ └─579 /usr/sbin/sshd -D
    ├─watchdog.service
    │ └─5008 /usr/sbin/watchdog
    ├─cron.service
    │ └─369 /usr/sbin/cron -f
    ├─systemd-journald.service
    │ └─127 /lib/systemd/systemd-journald
    ├─rng-tools.service
    │ └─380 /usr/sbin/rngd -r /dev/hwrng
    └─dhcpcd.service
        ├─497 wpa_supplicant -B -c/etc/wpa_supplicant/wpa_supplicant.conf -iwlan0 -Dnl80211,wext
        └─567 /sbin/dhcpcd -q -w
