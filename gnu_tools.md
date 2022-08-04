# GNU/Linux 常用工具

    各种linux帮助手册速查 https://manned.org/

    Linux 命令速查 https://linux.die.net/man/

    Bash脚本指南 https://linux.die.net/abs-guide/
                    https://linux.die.net/

## Linux下常用工具

### 终端字符的区域、编码、语言

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

### 字符界面的一些小玩具如emoji等

    字符式输入 https://www.webfx.com/tools/emoji-cheat-sheet/

    unicode编码 http://www.unicode.org/emoji/charts/full-emoji-list.html

    emoji 大全 https://emojipedia.org/
        unicode emoji https://unicode.org/emoji/charts/full-emoji-list.html
        git emoji https://blog.csdn.net/li1669852599/article/details/113336076

小火车sl

    sudo apt install sl

figlet实现字符画钟表，在tmux里开一个正合适

    watch -n1 "date '+%D%n%T'|figlet -k"

+ matrix 字符屏保

    参考

        https://magiclen.org/cmatrix/
            https://github.com/abishekvashok/cmatrix

    Debian / Ubuntu

            sudo apt install cmatrix

            cmatrix -ba

            Ctrl + c 或 q 退出

    Centos

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

### bash命令提示符美化

见章节  [bash_profile.sh] <shell_script okletsgo>

### 使用 zsh + ohmyzsh

    https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH

安装

    sudo apt install zsh

设置当前用户使用 zsh

    sudo chsh -s /bin/zsh

    # 修改用户登入后所使用的shell
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

    https://ohmyz.sh/

ohmyzsh安装目前是从github下载

    # wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

    # 或 sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

有些插件和主题依赖 python 和 git

    # https://github.com/zsh-users/antigen/wiki/Installation
    sudo apt install zsh-antigen

    # https://github.com/caiogondim/bullet-train.zsh
    sudo apt install fonts-powerline
    sudo apt install ttf-ancient-fonts

在 ~/.zshrc 里找到ZSH_THEME，就可以设置主题了，默认主题是：

    ZSH_THEME=”robbyrussell”

定制主题文件位置

    $ZSH_CUSTOM
    └── themes
        └── my_awesome_theme.zsh-theme

下载主题

    https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#overriding-and-adding-themes

    内置主题 https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
    更多的主题 https://github.com/ohmyzsh/ohmyzsh/wiki/External-themes
                https://github.com/unixorn/awesome-zsh-plugins

内置主题bira比较简洁，可手工修改添加时间提示`RPROMPT="[%*]%B${return_code}%b"`
![bira](https://user-images.githubusercontent.com/49100982/108254762-7a77a480-716c-11eb-8665-b4f459fd8920.jpg)

+ 推荐安装主题 [powerlevel10k](https://github.com/romkatv/powerlevel10k)

    安装 MesloLGS NF 字体后显示效果起飞 <https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k>

    运行 `p10k configure` 设置使用习惯

    参考图片![powerlevel10k](https://camo.githubusercontent.com/80ec23fda88d2f445906a3502690f22827336736/687474703a2f2f692e696d6775722e636f6d2f777942565a51792e676966)

    可先在docker中试用下

        docker run -e TERM -e COLORTERM -e LC_ALL=C.UTF-8 -it --rm alpine sh -uec '
        apk add git zsh nano vim
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
        echo "source ~/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
        cd ~/powerlevel10k
        exec zsh'

额外主题 [Bullet train](https://github.com/caiogondim/bullet-train.zsh)，可手工修改主机名字段颜色`BULLETTRAIN_CONTEXT_BG=magenta`，目前还没找到合适的字体显示各种图标，安装了 Powerline Vim plugin 没见效果。

### Vim 和 nano

在vim中输入的命令，只在当前文件中有效，可编辑 ~/.vimrc 文件配置。

vim 关闭语法高亮

     :syntax clear

Vim 关闭鼠标功能

    :set mouse-=a

Vim 使用鼠标

    :set mouse=a

Vim 解决汉字乱码

如果你的 Vim 打开汉字出现乱码的话，那么在home目录(~)下，新建.vimrc文件

    nano ~/.vimrc

添加内容如下：

    ini
    set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
    set enc=utf8
    set fencs=utf8,gbk,gb2312,gb18030

保存退出后执行下环境变量

    source .vimrc

 自定义 vim 编辑器的颜色方案

 打开一个Vim窗口

    输入命令:color 后回车查看当前的颜色主题。

    输入命令:echo $VIMRUNTIME 来查看Vim的运行目录
        进入vim的运行目录，查看color目录下以“.vim”为结尾的文件
        这些文件即是颜色主题文件，文件名就是主题名字。

    输入命令":colorscheme 主题名字"，即可设置当前vim实例的颜色主题。

 更改默认颜色主题

 打开~/.vimrc文件，在其中加入一行"colorscheme 颜色主题名字"，之后保存更改即可。

 如：

    colorscheme slate

#### nano 用法

用法
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

使用Ctrl+O来保存所做的修改

退出

按Ctrl+X

如果你修改了文件，下面会询问你是否需要保存修改。输入Y确认保存，输入N不保存，按Ctrl+C取消返回。如果输入了Y，下一步会让你输入想要保存的文件名。如果不需要修改文件名直接回车就行；若想要保存成别的名字（也就是另存为）则输入新名称然后确 定。这个时候也可用Ctrl+C来取消返回。

#### Vim powerline

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

        新建一个会话，并连接

    tmux ls

        列出当前的会话（tmux session），下面表示0号有2个窗口
            0: 2 windows (created Tue Apr 13 17:28:34 2021)

    tmux a

        进入tmux，直接回到上次退出前的那个会话的那个窗口的那个分屏

    tmux new -s roclinux

        创建一个新会话名为 roclinux，并连接

    #  ssh -t localhost tmux  a
    tmux new-session -s username -d

        创建一个全新的 tmux 会话 ，在开机脚本(Service等）中调度也不会关闭
        https://stackoverflow.com/questions/25207909/tmux-open-terminal-failed-not-a-terminal

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

    s       列出当前会话
            下面表示0号会话有2个窗口，是当前连接，1号会话有1个窗口
                (0) + 0: 2 windows (attached)
                (1) + 1: 1 windows

    w       列出当前会话的所有窗口，通过上、下键切换，
            新版的按树图列出所有会话的所有窗口，切换更方便，不需要s键了。

    $       重命名当前会话；这样便于识别

    [       查看历史输出（默认只显示一屏），使用pgup和pgdown翻页，按q退出

    d       脱离当前会话返回Shell界面，tmux里面的所有会话继续运行，
            会话里面的程序不会退出在后台保持继续运行，
            如果操作系统突然断连，也是一样的效果，
            下次在命令行运行`tmux a`能够重新进入之前的会话

如果在shell中执行exit，退出的顺序如下：

    先退出当前面板，返回到当前窗口的上一个面板，
    如果没有面板可用，则退出当前窗口，返回到当前会话的上一个窗口的某个面板，
    所有窗口退出时，当前的会话就会被关闭并退出tmux，其他会话继续运行。

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
    w       列出当前会话的所有窗口，通过上、下键切换，新版的按树图列出所有会话的所有窗口，切换更方便
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
    set-option -g mouse on  # v2.1 之前的老版本 set-option -g mode-mouse on
    bind -n WheelUpPane select-pane -t= ; copy-mode -e ; send-keys -M
    bind -n WheelDownPane select-pane -t= ; send-keys -M

如果开启了鼠标滚屏，在tmux中用鼠标右键粘贴等就不能用了，用ctrl+shift+c/v，或shift+ins。

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

补充熵池

随机数生成的这些工具，通过 /dev/random 依赖系统的熵池，而服务器在运行时，既没有键盘事件，也没有鼠标事件，那么就会导致噪声源减少。在很多发行版本中存在一个 rngd 程序，用来增加系统的熵池（用 urandom 给 random 灌数据）。在 debian，该工具包含在 rng-tools 工具中。

可以通过如下命令查看

    # 监视当前熵池的大小
    watch cat /proc/sys/kernel/random/entropy_avail

    # 从另外一个终端窗口启动服务
    sudo rngd -r /dev/urandom -o /dev/random -f -t 1

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

### 字符串处理awk/sed/cut/tr

删除字符，主要用于截取字符串

    $ echo "throttled=50.0"| tr -d "throttled="
    50.0

按分隔符打印指定的字段

    $ cat /etc/passwd| cut -d ':' -f7
    /bin/bash
    /usr/sbin/nologin
    /bin/sync
    /usr/sbin/nologin

awk 指定分隔符，可以用简单的语句组合字段

sed 删除、替换文件中的字符串

### scp 跨机远程拷贝

前提条件

    可以ssh登陆才能scp文件

基本用法

    后缀有没有目录标识‘/’导致拷贝为目录下或目录名

远程文件复制到本地：

    scp root@www.test.com:/val/test/test.tar.gz /val/test/test.tar.gz

远程文件复制到本地指定目录下：

    scp root@www.test.com:/val/test/test.tar.gz /val/test/

本地文件复制到远程：

    scp /val/test.tar.gz root@www.test.com:/val/test.tar.gz

本地文件复制到远程指定目录下：

    scp /val/test.tar.gz root@www.test.com:/val/

远程目录复制到本地：

    scp -r root@www.test.com:/val/test/ /val/test/

本地目录复制到远程：

    scp -r ./ubuntu_env/ root@192.168.0.111:/home/pipipika

    scp -r SocialNetworks/ piting@192.168.0.172:/media/data/pipi/datasets/

### 使用 timedatectl 命令操作时间时区

    https://www.cnblogs.com/zhi-leaf/p/6282301.html

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

### 开机启动 SystemV(init) 和 systemd

    https://www.debian.org/doc/manuals/debian-handbook/unix-services.zh-cn.html#sect.systemd

    https://zhuanlan.zhihu.com/p/140273445

    http://ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html

Linux 引导

Linux 主机从关机状态到运行状态的完整启动过程很复杂，但它是开放的并且是可知的。在详细介绍之前，我将简要介绍一下从主机硬件被上电到系统准备好用户登录的过程。大多数时候，“引导过程”被作为一个整体来讨论，但这是不准确的。实际上，完整的引导和启动过程包含三个主要部分：

    硬件引导：初始化系统硬件
    Linux 引导(boot)：加载 Linux 内核和 systemd
    Linux 启动(startup)：systemd 为主机的生产性工作做准备

Linux 启动阶段始于内核加载了 init 或 systemd（取决于具体发行版使用的是旧的方式还是还是新的方式）之后。init 和 systemd 程序启动并管理所有其它进程，它们在各自的系统上都被称为“所有进程之母”。

#### SystemV

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

##### SystemV设置开机自启动

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

或者，简单的命令脚本调用，可以直接修改/etc/rc.local文件，在exit 0之前增加需要运行的脚本

    1.vi /etc/rc.local

        #!/bin/sh -e

        nohup /usr/local/bin/your_shell_script.sh >/dev/null 2>&1 &

        exit 0

    2、给文件添加执行权限

        sudo chmod 755 rc.local

        chmod 755 /usr/local/bin/your_shell_script.sh

    3、重启计算机，程序会被root用户调用起来。

#### systemd

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

    systemd会检查老的 SystemV init 目录，以确认是否存在任何启动文件。如果有，systemd 会将它们作为配置文件以启动它们描述的服务。

    systemd 定时器提供类似 cron 的高级功能，包括在相对于系统启动、systemd 启动时间、定时器上次启动时间的某个时间点运行脚本。它提供了一个工具来分析定时器规范中使用的日期和时间。

#### systemd 基本管理命令

systemctl 是 Systemd 的主命令，用于管理系统

    # 重启系统
    $ sudo systemctl reboot

    # 关闭系统，切断电源
    $ sudo systemctl poweroff

    # CPU停止工作
    $ sudo systemctl halt

    # 暂停系统
    $ sudo systemctl suspend

    # 让系统进入冬眠状态
    $ sudo systemctl hibernate

    # 让系统进入交互式休眠状态
    $ sudo systemctl hybrid-sleep

    # 启动进入救援状态（单用户状态）
    $ sudo systemctl rescue

systemd-analyze命令用于查看启动耗时

    # 查看启动耗时
    $ systemd-analyze

    # 查看每个服务的启动耗时
    $ systemd-analyze blame

    # 显示瀑布状的启动过程流
    $ systemd-analyze critical-chain

    # 显示指定服务的启动流
    $ systemd-analyze critical-chain atd.service

hostnamectl命令用于查看当前主机的信息

    # 显示当前主机的信息
    $ hostnamectl

    # 设置主机名。
    $ sudo hostnamectl set-hostname rhel7

localectl命令用于查看本地化设置

    # 查看本地化设置
    $ localectl

    # 设置本地化参数。
    $ sudo localectl set-locale LANG=en_GB.utf8
    $ sudo localectl set-keymap en_GB

timedatectl命令用于查看当前时区设置

    # 查看当前时区设置
    $ timedatectl

    # 显示所有可用的时区
    $ timedatectl list-timezones

    # 设置当前时区
    $ sudo timedatectl set-timezone America/New_York
    $ sudo timedatectl set-time YYYY-MM-DD
    $ sudo timedatectl set-time HH:MM:SS

loginctl命令用于查看当前登录的用户

    # 列出当前session
    $ loginctl list-sessions

    # 列出当前登录用户
    $ loginctl list-users

    # 列出显示指定用户的信息
    $ loginctl show-user ruanyf

#### systemd 系统资源管理命令 systemctl

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

systemctl list-units命令可以查看当前系统的所有 Unit

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

systemctl status命令用于查看系统状态和单个 Unit 的状态

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

systemctl list-dependencies命令列出一个 Unit 的所有依赖

    $ systemctl list-dependencies nginx.service
    nginx.service
    ● ├─system.slice
    ● └─sysinit.target
    ●   ├─dev-hugepages.mount
    ●   ├─dev-mqueue.mount
    ●   ├─fake-hwclock.service
    ●   ├─keyboard-setup.service
    ●   ├─kmod-static-nodes.service
    ●   ├─proc-sys-fs-binfmt_misc.automount
    ●   ├─sys-fs-fuse-connections.mount
    ●   ├─sys-kernel-config.mount
    ●   ├─sys-kernel-debug.mount
    ●   ├─systemd-ask-password-console.path
    ●   ├─systemd-binfmt.service
    ●   ├─systemd-hwdb-update.service
    ●   ├─systemd-journal-flush.service
    ●   ├─systemd-journald.service
    ●   ├─systemd-machine-id-commit.service
    ●   ├─systemd-modules-load.service
    ●   ├─systemd-random-seed.service
    ●   ├─systemd-sysctl.service
    ●   ├─systemd-sysusers.service
    ●   ├─systemd-timesyncd.service
    ●   ├─systemd-tmpfiles-setup-dev.service
    ●   ├─systemd-tmpfiles-setup.service
    ●   ├─systemd-udev-trigger.service
    ●   ├─systemd-udevd.service
    ●   ├─systemd-update-utmp.service
    ●   ├─cryptsetup.target
    ●   ├─local-fs.target
    ●   │ ├─-.mount
    ●   │ ├─boot.mount
    ●   │ ├─systemd-fsck-root.service
    ●   │ └─systemd-remount-fs.service
    ●   └─swap.target

上面命令的输出结果之中，有些依赖是 Target 类型，默认不会展开显示。如果要展开 Target，就需要使用--all参数

    systemctl list-dependencies --all nginx.service

#### systemd 系统资源配置文件

每一个 Unit 都有一个配置文件，告诉 Systemd 怎么启动这个 Unit 。

Systemd 默认从目录 /etc/systemd/system/ 读取配置文件。但是，里面存放的大部分文件都是符号链接，指向目录/usr/lib/systemd/system/，真正的配置文件存放在那个目录。

systemctl enable命令用于在上面两个目录之间，建立符号链接关系

    $ sudo systemctl enable clamd@scan.service
    # 等同于
    $ sudo ln -s '/usr/lib/systemd/system/clamd@scan.service' '/etc/systemd/system/multi-user.target.wants/clamd@scan.service'

如果配置文件里面设置了开机启动，systemctl enable 命令相当于激活指定服务的开机启动。

与之对应的，systemctl disable命令用于在两个目录之间，撤销符号链接关系，相当于撤销指定服务的开机启动

    sudo systemctl disable clamd@scan.service

配置文件的后缀名，就是该 Unit 的种类，比如sshd.socket。如果省略，Systemd 默认后缀名为.service，所以sshd会被理解成sshd.service。

systemctl list-unit-files命令用于列出所有配置文件

    # 列出所有配置文件
    $ systemctl list-unit-files

    # 列出指定类型的配置文件
    $ systemctl list-unit-files --type=service

这个命令会输出一个列表，表示每个配置文件的状态，一共有四种

    enabled：已建立启动链接
    disabled：没建立启动链接
    static：该配置文件没有[Install]部分（无法执行），只能作为其他配置文件的依赖
    masked：该配置文件被禁止建立启动链接

从配置文件的状态无法看出，该 Unit 是否正在运行。这必须执行前面提到的systemctl status命令。

一旦修改配置文件，就要让 SystemD 重新加载配置文件，然后重新启动，否则修改不会生效

    sudo systemctl daemon-reload
    sudo systemctl restart httpd.service

配置文件就是普通的文本文件，可以用文本编辑器打开。

systemctl cat命令可以查看配置文件的内容

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

##### 配置文件的区块

[Unit]区块通常是配置文件的第一个区块，用来定义 Unit 的元数据，以及配置与其他 Unit 的关系。它的主要字段如下。

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

[Service]区块用来 Service 的配置，只有 Service 类型的 Unit 才有这个区块。它的主要字段如下。

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

#### Systemd 统一管理所有 Unit 的启动日志 journalctl

带来的好处就是，可以只用 journalctl 一个命令，查看所有日志（内核日志和应用日志）。日志的配置文件是/etc/systemd/journald.conf。

journalctl 功能强大，用法非常多

    # 查看所有日志（默认情况下 ，只保存本次启动的日志）
    $ sudo journalctl

    # 查看内核日志（不显示应用日志）
    $ sudo journalctl -k

    # 查看系统本次启动的日志
    $ sudo journalctl -b
    $ sudo journalctl -b -0

    # 查看上一次启动的日志（需更改设置）
    $ sudo journalctl -b -1

    # 查看指定时间的日志
    $ sudo journalctl --since="2012-10-30 18:17:16"
    $ sudo journalctl --since "20 min ago"
    $ sudo journalctl --since yesterday
    $ sudo journalctl --since "2015-01-10" --until "2015-01-11 03:00"
    $ sudo journalctl --since 09:00 --until "1 hour ago"

    # 显示尾部的最新10行日志
    $ sudo journalctl -n

    # 显示尾部指定行数的日志
    $ sudo journalctl -n 20

    # 实时滚动显示最新日志
    $ sudo journalctl -f

    # 查看指定服务的日志
    $ sudo journalctl /usr/lib/systemd/systemd

    # 查看指定进程的日志
    $ sudo journalctl _PID=1

    # 查看某个路径的脚本的日志
    $ sudo journalctl /usr/bin/bash

    # 查看指定用户的日志
    $ sudo journalctl _UID=33 --since today

    # 查看某个 Unit 的日志
    $ sudo journalctl -u nginx.service
    $ sudo journalctl -u nginx.service --since today

    # 实时滚动显示某个 Unit 的最新日志
    $ sudo journalctl -u nginx.service -f

    # 合并显示多个 Unit 的日志
    $ journalctl -u nginx.service -u php-fpm.service --since today

    # 查看指定优先级（及其以上级别）的日志，共有8级
    # 0: emerg
    # 1: alert
    # 2: crit
    # 3: err
    # 4: warning
    # 5: notice
    # 6: info
    # 7: debug
    $ sudo journalctl -p err -b

    # 日志默认分页输出，--no-pager 改为正常的标准输出
    $ sudo journalctl --no-pager

    # 以 JSON 格式（单行）输出
    $ sudo journalctl -b -u nginx.service -o json

    # 以 JSON 格式（多行）输出，可读性更好
    $ sudo journalctl -b -u nginx.serviceqq
    -o json-pretty

    # 显示日志占据的硬盘空间
    $ sudo journalctl --disk-usage

    # 指定日志文件占据的最大空间
    $ sudo journalctl --vacuum-size=1G

    # 指定日志文件保存多久
    $ sudo journalctl --vacuum-time=1years

#### systemd 设置开机自启动脚本

确认 systemd 已经开启了 systemV 启动脚本 rc.local 的兼容服务

    cd /lib/systemd/system/

    $ cat rc-local.service
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

### crontab 定时任务

    https://www.debian.org/doc/manuals/debian-handbook/sect.task-scheduling-cron-atd.zh-cn.html

    http://c.biancheng.net/view/1092.html

    https://www.cnblogs.com/GavinSimons/p/9132966.html

    各种不能执行的原因 https://segmentfault.com/a/1190000020850932
                        https://github.com/tony-yin/Why-Cronjob-Not-Work

    https://www.cnblogs.com/pengdonglin137/p/3625018.html
    https://www.cnblogs.com/utopia68/p/12221769.html
    https://blog.csdn.net/zhubin215130/article/details/43271835
    https://developer.aliyun.com/article/541971

#### 1、crontab 与 anacron

    crontab：crontab命令被用来提交和管理用户的需要周期性执行的任务，与windows下的计划任务类似，当安装完成操作系统后，默认会安装此服务工具，并且会自动启动crond服务，crond进程每分钟会定期检查是否有要执行的任务，如果有，则自动执行该任务。依赖于crond服务

    anacron：cron的补充，能够实现让cron因为各种原因在过去的时间该执行而未执行的任务在恢复正常执行一次。依赖于nancron服务

    debian 中安装 anacron 软件包会禁用 cron 在/etc/cron.{daily，weekly，monthly} 目录中的脚本，仅由 anacron 调用，以避免 anacron 和 cron 重复运行这些脚本。 cron 命令仍然可用并处理其他计划任务（特别是用户安排的计划任务）。

#### 2、Crontab任务种类及格式定义

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

#### 3、时间的有效取值

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

#### 4、时间通配表示

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

#### 5、cron的环境变量

cron 启动任务时，环境变量非常少，即使是用户级任务，也不会执行用户的 .profile 文件，所以，如果需要操作数据库等跟用户相关的脚本或命令，一般采用在用户脚本中执行环境变量文件，然后再执行相关操作。

cron在crontab文件中的默认 PATH=/usr/bin:/bin，cron执行所有命令都用该PATH环境变量指定的路径下去找。

详见章节 [坑：环境变量是单独的跟用户登陆后的环境变量不一样]

#### 6、执行结果将以邮件形式发送

    */3 * * * * /bin/cat /etc/fstab > /dev/null         # 错误信息仍然发送给管理员

    */3 * * * * /bin/cat /etc/fstab &> /dev/null         # 所有信息都不发送给管理员，无论是否正确执行

在 /var/mail 目录下查看邮件

在 /var/log/syslog 查看日志，debian默认的rsyslog不记录cron日志，需要手动开启

注意 /var 的空间不要被填满了

#### 坑：区分crontab命令和crontab文件

用crontab -e命令配置是针对当前用户的定时任务，而编辑/etc/crontab文件是针对系统的任务。cron服务每分钟不仅要读一次 /var/spool/cron 内的所有文件，还需要读一次 /etc/crontab 文件。

使用下面的命令，会在vi 里打开crontab的内容以供编辑：

    crontab -e

如果你只想看看，不需要编辑，可以使用以下的命令

    crontab -l

要删除crontab的内容，就是删除所有的计划任务，可以这样：

    crontab -r

[root@kind-codes-1 /etc]# cat /etc/crontab

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

#### 坑：crontab文件最后要有个空行

    crontab要求cron中的每个条目都要以换行符结尾

对crontab文件的最后一行任务设置来说，如果后面没有一个空白行，那说明它没有换行符，不会被crotnab执行。。。

解决方案

    养成给cron中每个条目后面都添加一个空行的习惯

如果你用Windows编辑的crontab文件，注意必须改为 unix格式保存。

#### 坑：修改 /etc/crontab 文件后要加载到cron服务

命令和文件名相同，注意区分

    crontab /etc/crontab

debian 不需要这么做了

    $ cat /etc/crontab
    # /etc/crontab: system-wide crontab
    # Unlike any other crontab you don't have to run the `crontab'
    # command to install the new version when you edit this file
    # and files in /etc/cron.d. These files also have username fields,
    # that none of the other crontabs do.

#### 坑：环境变量是单独的跟用户登陆后的环境变量不一样

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

#### 坑：命令解释器默认是sh而不是bash

从坑一的变量 SHELL=/bin/sh 可以看到默认的解释器不是bash，而大多数命令脚本都是用bash来解释执行的。所以配置定时任务时，要明确的指定执行命令的解释器

    bash -c "mybashcommand"

    或
    /bin/bash /usapce/code/test1.sh

或在脚本内的第一行指定：

    #!/bin/bash

#### 坑：换行符

这也算通病了，很多linux命令的执行都以行结束为标志，从文件中读取的最后一行如果直接结束时没有换行符的，导致永远无法执行。。。

所以，确保您的crontab文件在末尾有一个空白行。

最好养成习惯，给crontab文件的中每个条目下面添加一个空行，文件的最后一行多敲一个回车再保存。

另外文件格式注意不能时Windows的^M、mac的\r等，必须是unix格式，这样的换行符才是 \n。

很多编辑软件编辑ftp上的文件，或上传到ftp时，默认都做格式转换，其实容易混淆，还不如直接设置，保留原文件格式，不要自动转换。这样查看文件的时候非常方便，一目了然，unix下的vi显示Windows文件会出现很多乱码。在Windows下编辑unix文件，现在流行的编辑软件也都支持正确显示这个格式了，不要让他来回的转。

#### 坑：需要执行权限

如果设置了非root用户的定时任务，需要注意很多权限问题，比如该用户对操作的文件或目录是否存在权限等。

解决方案

    # correct permission
    sudo chmod 600 /var/spool/cron/crontabs/user

    # signal crond to reload the file
    sudo touch /var/spool/cron/crontabs

#### 坑：防止屏幕打印

把脚本的输出和报错信息都打印到空

    xxx.sh >/dev/null 2>&1

#### 坑：定时时间的书写格式不统一

一些特殊选项各个平台支持不一样，有的支持，有的不支持，例如2/3、1-5、1,3,5

这个只能试一下才知道。

#### 坑：corn服务默认不启动

查看当前系统是否有进程

    $ ps -ef|grep cron
    root       398     1  0 May08 ?        00:00:07 /usr/sbin/cron -f

查看系统服务cron的状态

    $ sudo systemctl status cron
    ● cron.service - Regular background program processing daemon
    Loaded: loaded (/lib/systemd/system/cron.service; enabled; vendor preset: enabled)
    Active: active (running) since Sun 2022-05-08 09:10:43 UTC; 1 months 27 days ago
        Docs: man:cron(8)
    Main PID: 398 (cron)
        Tasks: 1 (limit: 1148)
    Memory: 2.3M
    CGroup: /system.slice/cron.service
            └─398 /usr/sbin/cron -f

#### 坑：百分号需要转义字符

    https://unix.stackexchange.com/questions/29578/how-can-i-execute-date-inside-of-a-cron-tab-job

当cron定时执行命令中，有百分号并且没有转义的时候，cron执行会出错，比如执行以下cron：

    0 * * * * echo hello >> ~/cron-logs/hourly/test`date "+%d"`.log

会有如下报错：

    /bin/sh: -c: line 0: unexpected EOF while looking for matching ``'
    /bin/sh: -c: line 1: syntax error: unexpected end of file

即cron中换行符或%前的命令会被shell解释器执行，但是%会被认为新一行的字符，并且%后所有的数据都会以标准输出的形式发送给命令。

解决方案：为百分号做转义，即在%前添加反斜杠\

    0 * * * * echo hello >> ~/cron-logs/hourly/test`date "+\%d"`.log

#### 坑：crontab文件里的变量使用有限制

因为在crontable里面只能声明变量，不能对变量进行操作或者执行其他任何shell命令的，所以下述的shell字符串拼接是不会成功的，所以只能声明变量，然后在命令中引用变量。

    SOME_DIR=/var/log
    MY_LOG_FILE=${SOME_LOG}/some_file.log

    BIN_DIR=/usr/local/bin
    MY_EXE=${BIN_DIR}/some_executable_file

    0 10 * * * ${MY_EXE} some_param >> ${MY_LOG_FILE}

解决方案：

方案1： 直接声明变量

    SOME_DIR=/var/log
    MY_LOG_FILE=/var/log/some_file.log

    BIN_DIR=/usr/local/bin
    MY_EXE=/usr/local/bin/some_executable_file

    0 10 * * * ${MY_EXE} some_param >> ${MY_LOG_FILE}

方案2： 声明多个变量，在命令中引用拼接

    SOME_DIR=/var/log
    MY_LOG_FILE=some_file.log

    BIN_DIR=/usr/local/bin
    MY_EXE=some_executable_file

    0 10 * * * ${BIN_DIR}/${MY_EXE} some_param >> ${SOME_DIR}/${MY_LOG_FILE}

#### 坑：用户密码过期也不会启动定时任务

当用户密码过期也会导致cron脚本执行失败。

Linux下新建用户密码过期时间是从/etc/login.defs文件中PASS_MAX_DAYS提取的，普通系统默认就是99999，而有些安全操作系统是90天，这个参数只影响新建用户的密码过期时效，如果之前该用户已经密码过期了，该这个参数没用。

将用户密码有效期设置成永久有效期或者延长有效期

    chage -M <expire> <username>

    或
    passwd -x -1 <username>

#### 坑：切换时区后要重启cron服务

当修改系统时区后，无论是之前已经存在的cron还是之后新创建的cron，脚本中设置的定时时间都以旧时区为准，比如原来时区是Asia/Shanghai，时间为10:00，然后修改时区为Europe/Paris，时间变为3:00，此时你设置11:00的定时时间，cron会在Asia/Shanghai时区的11:00执行。

解决方案1：

重启crond服务

    sudo systemctl restart cron

解决方案2：

    kill cron进程，因为cron进程是自动重生的

## 网络故障排查

不建议使用ifconfig，而推荐使用新的 ip 命令，未来net-tools套件会被完全废弃，功能上被iproute2套件取代，见[二者命令详细对比](https://linux.cn/article-4326-1.html)。

    # apt install net-tools
    ifconfig

列出登入系统失败的用户相关信息，安全性检查，经常看看，如果太多必须考虑ssh的安全性

    lastb|less

    lastb|awk '{print $1}'|sort|uniq

端口是否可用
    telnet 127.0.0.1 443
    wget 127.0.0.1:443

当前对外开放的监听端口
    # 127.0.0.1 只对本机开放
    # 0.0.0.0   外来连接也开放
    netstat -ant

监听端口的简单通信

    sudo apt update && sudo apt -y install ncat

    nc -l 端口

    nc 192.168.200.27 端口 后直接输入文字即可

icmp测试网络连通情况

    ping -t 192.168.0.1

    tracert www.bing.com

    traceroute

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

## Windows 下的 GNU/POSIX 环境

### 环境方案选择

Windows 10+ 下使用 WSL 开发 GNU 环境设置

    https://github.com/hsab/WSL-config

Windows C++ 开发环境配置

    g++7.0 + git + cmake

    code::block / vscode

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

### 环境配置

#### 简单使用：安装 Git for Windows

GIT Bash 使用了 GNU tools 的 MINGW，但是工具只选择了它自己需要的部分进行了集成，我们主要使用他的 mintty 命令行终端程序和 ssh、gpg 等工具。

下载地址 <https://git-scm.com/download/win>

##### Windows下 的 bash -- mintty

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

###### mintty 美化

如果是 git for Windows 的mintty，修改 ~/.minttyrc 为下面的内容

    # https://mintty.github.io/mintty.1.html
    # https://github.com/mintty/mintty/wiki/Tips#configuring-mintty
    Font=Consolas
    FontHeight=11
    Columns=140
    Rows=40

    AllowBlinking=yes
    CursorType=block
    CursorBlinks=no

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
    Background=C:\StartHere\tools\SuperPuTTY\111dark.jpg
    BackgroundColour=109,69,35
    ForegroundColour=228,228,228
    CursorColour=217,230,242

    Black=0,0,0
    BoldBlack=36,36,36
    Red=255,0,0
    BoldRed=255,0,128
    Green=51,242,133
    BoldGreen=22,184,74
    Yellow=249,237,134
    BoldYellow=240,197,47
    Blue=97,197,239
    BoldBlue=157,202,225
    Magenta=172,53,101
    BoldMagenta=249,159,210
    Cyan=7,254,254
    BoldCyan=1,220,220
    White=217,217,217
    BoldWhite=255,255,255

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
    #ForegroundColour=131, 148, 150
    #BackgroundColour=  0,  43,  54
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

    # 使用内置颜色方案，建议放在最下面以覆盖上面的颜色设置
    # ThemeFile=mintty

如果是 MSYS2 的 mintty，可以在<https://github.com/hsab/WSL-config/tree/master/mintty/themes> 找到很多主题，将主题文件保存到 msys64/usr/share/mintty/themes 目录下，通过右键 mintty 窗口标题栏的 option 进行选择。

###### 多终端工具 ConEmu/SuperPutty

SuperPutty 支持putty、mintty、cmd、powershell等多种终端嵌入显示，可导入putty站点，可设置站点关联WinScp/FileZilla等软件的快捷调用，使用简单方便，只要安装了 git for Windows 和 putty 等软件即可直接使用，不需要做复杂的设置。

ConEmu是一个非常好用的终端，支持标签切换功能，可以在conemu中同时打开cmd,powershell,msys2，bash等等。自定义选项多，非常好用。缺点是配置复杂，慢慢研究吧

    https://zhuanlan.zhihu.com/p/99963508
        https://conemu.github.io/

    ConEmu配置Msys2 https://blog.csdn.net/sherpahu/article/details/101903539
    msys2使用conemu终端配置 https://blog.csdn.net/hustlei/article/details/86688160

conemu中设置MSYS2

+ 以MSYS2 MingGW64为例：

    打开conemu的settings对话框

    选择Startup>>Tasks选项

    点击+号，新建一个Task

    修改Task名字为Msys2::MingGW64

    在commands下文本框内输入如下代码：

        set MSYS2_PATH_TYPE=inherit & set MSYSTEM=mingw64 & set "D=C:\msys64" & %D%\usr\bin\bash.exe --login -i -new_console:C:"%D%\msys2.ico"

MSYS2_PATH_TYPE=inherit表示合并windows系统的path变量。注意修改变量值`D=`为你的msys2的安装目录。

如果安装了zsh并想默认使用zsh，可以把代码里的bash改为zsh。

打开后会自动把工作目录设置为msys64/home/%user%下。

#### 组合使用：git for Windows + MSYS2

##### 拷贝 MSYS2 的工具到 git 里，这样只使用 git bash(mintty) 就可以了

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

##### 共享一套 Home 目录

如果安装了 git for windows ，其 home 目录默认为 %USERPROFILE%，导致 git for windows 和 MSYS2 的 git 配置和 vim 等配置不能共享。

如果在安装 MSYS2 之前已经安装 git for windows 需要使用将之前的 ssh 和 git 的配置拷贝到 MSYS2 的 home 目录下。

在 Windows 上配置环境变量 HOME 为 C:\you-path\msys64\home\your-name，增加这个环境变量的目的是为了让 git for windows 的 home 目录指向 MSYS2 的 home 目录。

#### 全套使用：安装 MSYS2(Cygwin/Msys)

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

##### 软件仓库 pacman

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
