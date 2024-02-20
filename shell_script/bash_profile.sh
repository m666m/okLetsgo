##################################################################################################################
# 适用于 Linux bash、Windows mintty bash，每个段落用 ########## 分隔，根据说明自行选用搭配即可
#
# 别人的配置文件参考大全 https://github.com/pseudoyu/dotfiles
#                       https://www.pseudoyu.com/zh/2022/07/10/my_config_and_beautify_solution_of_macos_terminal/

###################################################################
# 自此开始都是自定义设置
#
# 为防止变量名污染命令行环境，尽量使用奇怪点的名称

# 兼容性设置，用于 .bash_profile 加载多种 Linux 的配置文件
#   ~/.bashrc: executed by bash(1) for non-login shells.
#       see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples
#   ~/.profile: executed by the command interpreter for login shells.
#     This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.
#     see /usr/share/doc/bash/examples/startup-files for examples.
#     the files are located in the bash-doc package.
# test -f ~/.profile && . ~/.profile
# test -f ~/.bashrc && . ~/.bashrc

# exit for non-interactive shell
[[ ! -t 1 ]] && return

# 有些版本的 Linux 默认不支持的标准目录给它补上
PATH=$PATH:$HOME/.local/bin:$HOME/bin; export PATH

# 命令行开启vi-mode模式，按esc后用vi中的上下左右键选择历史命
# zsh 命令行用 `bindkey -v` 来设置 vi 操作模式令
set -o vi

# 有些软件默认使用变量 EDITOR 指定的编辑器，一般是 nano，不习惯就换成 vi
export EDITOR=/usr/bin/vi

# 历史记录不记录如下命令 vault* kill，除了用于保护参数带密码命令，还可以精简命令历史，不保存哪些不常用的命令
# 一个简单的方法是输入密码的参数使用短划线“-”，然后按 Enter 键。这使您可以 在新行中输入密钥。
# export HISTIGNORE="&:[ \t]*vault*:[ \t]*kill*"

####################################################################
# 命令行的字符可以显示彩色，依赖这个设置
# 显式设置终端启用256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
export TERM=xterm-256color
export COLORTERM=truecolor

####################################################################
# alias 本该放到 .bashrc 文件，为了方便统一在此了
# 可放到 .zshrc 中保持自己的使用习惯
#
# 参考自 Debian 的 .bashrc 脚本中，常用命令开启彩色选项
# enable color support of ls and also add handy aliases
# 整体仍然受终端模拟器对16种基本颜色的设置控制，也就是说，在终端模拟器中使用颜色方案，配套修改 dir_colors ，让更多的文件类型使用彩色显示
if [ -x /usr/bin/dircolors ]; then

    # 使用 dir_colors 颜色方案-北极，可影响 ls、tree 等命令的颜色风格
    # [[ -f ~/.dircolors ]] ||curl -fsSLo ~/.dir_colors https://github.com/arcticicestudio/nord-dircolors/raw/develop/src/dir_colors
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    # 注意基础命令不要搞太花哨，导致脚本里解析出现用法不一致的问题
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias ls='ls --color=auto'
    alias diff='diff --color=auto'
    alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,__pycache__}'
    #alias egrep='egrep --color=auto'
    #alias fgrep='fgrep --color=auto'
    alias tree='tree -a -C'

    # 常用的列文件的惯用法
    alias lsa='ls -A'
    alias l='ls -CFA'
    alias ll='ls -lh'
    alias la='ls -lAh'

    # 其它常用命令的惯用法：

    # 列出目录下的文件清单，查找指定关键字，如 `lsg fnwithstr`。因为ls列出的目录颜色被grep覆盖，用 ls -l 查看更方便。
    alias lsg='ls -lFA |grep -i'
    # 列出当前目录及子目录的文件清单，查找指定关键字，如 `findf fnwithstr`
    alias findf='find ./* |grep -i'
    # 在管道或当前目录下的文件中查找指定关键字，列出文件名和所在行，如 `greps strinfile *`
    alias greps='grep --color=auto -d skip -in'
    # 在当前目录和子目录下的文件中查找指定关键字，列出文件名和所在行，跳过.git等目录，如 `finds strinfile`
    alias finds='find . \( -name ".git" -o -name "__pycache__" \) -prune -o -print |xargs grep --color=auto -d skip -in'
    alias trees='echo "[目录树，最多2级，显示目录和可执行文件的标识，跳过.git等目录]" && tree -a -CF -I ".git|__pycache__" -L 2'
    alias pstrees='echo "[进程树，列出pid，及全部子进程]" && pstree -p -s'
    alias curls='echo "curl 不显示服务器返回的错误内容，静默信息不显示进度条，但错误信息打印到屏幕，跟踪重定向，可加 -O 保存到默认文件" &&curl -fsSL'
    alias passr='echo "[16 个随机字符作为密码]" && echo && cat /dev/random |tr -dc 'a-zA-Z0-9' |head -c 16 && echo'
    alias passf='echo "[256 随机字节作为密钥文件，过滤了换行符]" && echo &&cat /dev/random |tr -d '\n' |head -c 256'

    # cp -a：此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容。其作用等于dpR参数组合。
    function cpbak {
        # find . -max-depth 1 -name '$1*' -exec cp "{}" "{}.bak" \;
        echo "[复制一个备份，同名后缀.bak，如果是目录名不要后缀/]" && cp -a $1{,.bak}
    }

    # scp rsync
    alias scps='echo "[scp 源 目的。远程格式 user@host:/home/user/ 端口用 -P]" && scp -r'
    alias rsyncs='echo "[rsync 源 目的。远程格式 user@host:/home/user/ 端口用 -e 写 ssh 命令]" && rsync -av --progress'

    # vi 后悔药
    alias viw='echo "[只给出提示：vi 后悔药 --- 等保存了才发现是只读]" && echo ":w !sudo tee %"'

    # wsl 或 git bash 下快捷进入从Windows复制过来的绝对路径，注意要在路径前后添加双引号，如：cdw "C:\Windows\Path"
    function cdw {
        cd "/$(echo ${1//\\/\/} | cut -d: -f1 | tr -t [A-Z] [a-z])$(echo ${1//\\/\/} | cut -d: -f2)"
    }

    alias nmaps='echo "nmap 列出当前局域网内ip及端口" && nmap 192.168.0.0/24'

    # git 常用命令
    alias gs='git status'
    alias gd='echo "[差异：工作区与暂存区]" && git diff'
    alias gds='echo "[差异：暂存区与仓库]" && git diff --staged'
    alias gdh='echo "[差异：工作区与仓库]" && git diff HEAD'
    alias gdh2='echo "[差异：最近的两次提交记录]" && git diff HEAD~ HEAD'
    alias glog='echo "[提交记录：树形]" && git log --oneline --graph'
    alias glb='echo "[提交记录：对比分支，需要给出两分支名，二点三点分隔效果不同]" && git log --left-right --oneline'
    alias glm='echo "[提交记录：本地远程库对比本地库--master]" && git log --graph --oneline ..origin/master --'
    alias gld='echo "[提交记录：本地远程库对比本地库--dev]" && git log --graph --oneline ..origin/dev --'
    alias gba='echo "[分支：全部分支及跟踪关系、最近提交及注释]" && git branch -avv'
    alias gro='echo "[远程信息]" && git remote show origin'
    alias gcd3='echo  "[精简diff3信息]" && sed -n "/||||||| merged common ancestor/,/>>>>>>> Temporary merge branch/!p"'
    alias gpull='echo "[github 经常断连，自动重试 pull 直至成功]" && git pull --rebase || while (($? != 0)); do   echo -e "[Retry pull...] \n" && sleep 1; git pull --rebase; done'
    alias gpush='echo "[github 经常断连，自动重试 push 直至成功]" && git push || while (($? != 0)); do   echo -e "[Retry push...] \n" && sleep 1; git push; done'
    function gaddr {
        # 把 github.com 的 https 地址转为 git@ 地址
        echo ${1//https:\/\/github.com\//git@github.com:}
    }

    # gpg 常用命令，一般用法都是后跟文件名即可
    alias ggk='echo "[查看有私钥的gpg密钥及其子密钥，带指纹和keygrip]" && gpg -K --keyid-format=long --with-subkey-fingerprint --with-keygrip'
    alias ggl='echo "[查看密钥的可读性信息pgpdump]" && gpg --list-packets'
    alias ggsb='echo "[签名，生成二进制.gpg签名文件，默认选择当前可用的私钥签名，可用 -u 指定]" && gpg --sign'
    alias ggst='echo "[签名，生成文本.asc签名文件，默认选择当前可用的私钥签名，可用 -u 指定]" && gpg --clearsign'
    alias ggsdb='echo "[分离式签名，生成二进制.sig签名文件，默认选择当前可用的私钥签名，可用 -u 指定]" && gpg --detach-sign'
    alias ggsdt='echo "[分离式签名，生成文本.asc签名文件，默认选择当前可用的私钥签名，可用 -u 指定]" && gpg --armor --detach-sign'
    alias ggkd='echo "[从公钥服务器下载指定公钥到本地]" && gpg --keyserver hkps://keys.openpgp.org --no-default-keyring --keyring ./pub_key.gpg --recv-keys'
    alias ggf='echo "[查看公钥的指纹以便跟跟网站发布的核对]" && gpg --with-fingerprint --show-keys --keyid-format=long'
    alias ggvs='echo "[使用临时钥匙圈验证文件签名，如 ggvs ./fedora.gpg xxx.checksum xxx.zip]" && gpgv --keyring'
    alias ggv='echo "[验证签名]" && gpg --verify'
    alias gges='echo "[非对称算法加密并签名，参数太多，只给出提示]" && echo "gpg -s -u 'sender@xxx.com' -r 'reciver@xxx.com' -e msg.txt"'
    alias ggcs='echo "[对称算法加密，默认选择当前可用的私钥签名，可用 -u 指定，默认生成的.gpg文件。]" && gpg -s --cipher-algo AES-256 -c'
    # 解密并验签，需要给出文件名或从管道流入，默认输出到屏幕
    alias ggd='gpg -d'
    # 映射内存目录
    alias ggdrv='echo "[映射内存目录] mount --mkdir -t ramfs ramfs /root/tmp [用完了解除挂载即可] sync; umount /root/tmp"'

    # 只下载了一个文件，从校验和文件中抽出单个文件进行校验 `sha256sumf abc.iso SHA256SUMS.txt`
    function sha256sumf {
        sha256sum -c <(grep $1 $2)
    }

    # openssl 常用命令
    # 对称算法加密，如 `echo abc |ssle` 输出到屏幕， `ssle -in 1.txt -out 1.txt.asc` 操作文件，加 -kfile 指定密钥文件
    alias ssle='openssl enc -e -aes-256-cbc -md sha512 -pbkdf2 -iter 10000000 -salt'
    # 对称算法解密，如 `cat 1.txt.asc |ssld` 输出到屏幕，`ssld -in 1.txt.asc -out 1.txt`操作文件，加 -kfile 指定密钥文件
    alias ssld='openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 10000000 -salt'

    # dnf
    alias dnfp='echo "[dnf搜索包含指定命令的软件包]" && dnf provides'
    alias dnfqi='echo "[dnf查找指定的软件包在哪些存储库]" && dnf repoquery -i'
    alias dnfqr='echo "[dnf查看软件包依赖]" && dnf repoquery --requires'
    alias dnfr='echo "[dnf查看当前有哪些存储库]" && dnf repolist'
    alias dnfrl='echo "[dnf查看存储库软件列表]" && dnf list --repo'
    alias dnfl='echo "[dnf查看安装的软件]" && dnf list --installed'
    alias dnfd='echo "[dnf卸载软件]" && dnf remove'
    alias dnft='echo "[在toolbox里运行dnf]" && toolbox run dnf'

    # flatpak
    alias fpkr='echo "[flatpak查看当前有哪些存储库]" && flatpak remotes'
    alias fpkrl='echo "[flatpak查看存储库软件列表]" && flatpak remote-ls'
    alias fpkl='echo "[flatpak查看安装的软件]" && flatpak list --runtime'
    alias fpkd='echo "[flatpak卸载软件]" && flatpak uninstall --delete-data'

    # podman
    alias podmans='echo "[podman搜索列出镜像版本]" && podman search --list-tags'

    # distrobox 这词打不快
    alias dbox='distrobox'

    # selinux 审计信息：ausearch -i
    alias aud='sudo tail -f /var/log/audit/audit.log |sudo ausearch --format text'

    # systemd
    alias stded='echo "[systemd 直接编辑服务的单元配置文件]" && sudo env SYSTEMD_EDITOR=vi systemctl edit --force --full'

    # 切换桌面图形模式和命令行模式 --- systemctl 模式
    function swc {
        [[ $(echo $XDG_SESSION_TYPE) = 'tty' ]] \
            && (echo -e "\033[0;33mWARN\033[0m: Start Desktop, wait until login shows..."; sudo systemctl isolate graphical.target) \
            || (echo -e "\033[0;33mWARN\033[0m: Shut down desktop and return to tty..."; sleep 1; sudo systemctl isolate multi-user.target)
    }

    # 命令行看天气 https://wttr.in/:help
    # https://zhuanlan.zhihu.com/p/40854581 https://zhuanlan.zhihu.com/p/43096471
    # 支持任意Unicode字符指定任何的地址 curl http://wttr.in/~大明湖
    # 看月相 curl http://wttr.in/moon
    function weather {
        curl -s --connect-timeout 3 -m 5 http://wttr.in/$1
    }

fi

####################################################################
# Windows git bash(mintty)
# 在 mintty 下使用普通的 Windows 控制台程序
# 如 mintty 使用 ConPty 接口则可以不需要这些 alias 使用 winpty 来调用了
#   Windows version >= 10 / 2019 1809 (build >= 10.0.17763) 在 ~/.mintty.rc 中添加 `ConPTY=true`

#if $(git --version |grep -i Windows >/dev/null 2>&1); then
if [[ $OS =~ Windows && "$OSTYPE" =~ msys ]]; then
    alias python="winpty python"
    alias ipython="winpty ipython"
    alias mysql="winpty mysql"
    alias psql="winpty psql"
    alias redis-cli="winpty redis-cli"
    alias node="winpty node"
    alias vue='winpty vue'

    # Windows 的 cmd 字符程序都可以在 bash 下用 winpty 来调用
    alias ping='winpty ping'
fi

####################################################################
# gpg: problem with the agent: Inappropriate ioctl for device，
# 参见章节 [命令行终端下 gpg 无法弹出密码输入框的问题](gpg think)
export GPG_TTY=$(tty)
# echo "以当前终端 tty 连接 gpg-agent..."
# gpg-connect-agent updatestartuptty /bye >/dev/null

#################################
# Mac OS
# 如果你要在 OS-X 上使用 gpg-agent，记得将下面的命令填入你的 Shell 的默认配置中。
#
if [[ $OSTYPE =~ darwin ]]; then
    if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
        source ~/.gnupg/.gpg-agent-info
        export GPG_AGENT_INFO
    else
        eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
    fi
fi

####################################################################
# Linux bash / Windows git bash(mintty)
# 多会话复用 ssh 密钥代理

# GNOME 桌面环境下的终端需要给 ssh 密钥代理 ssh-agent 设置变量指向 gnome-keyring-daemon
if [[ $XDG_CURRENT_DESKTOP = 'GNOME' ]]; then
    # if [[ $(uname) == 'Linux' ]]; then

    # GNOME 桌面环境用自己的 keyring 管理接管了全系统的密码和密钥，图形化工具可使用 seahorse 进行管理
    # 如果有时候没有启动默认的 /usr/bin/ssh-agent -D -a /run/user/1000/keyring/.ssh 会导致无法读取ssh代理的密钥
    # 干脆手工指定
    # https://blog.csdn.net/asdfgh0077/article/details/104121479
    $(pgrep gnome-keyring >/dev/null 2>&1) || eval `gnome-keyring-daemon --start >/dev/null 2>&1`

    export SSH_AUTH_SOCK="$(ls /run/user/$(id -u $USERNAME)/keyring*/ssh |head -1)"
    export SSH_AGENT_PID="$(pgrep gnome-keyring)"

# Windows git bash 环境
elif [[ $OS =~ Windows && "$OSTYPE" =~ msys ]]; then

    # Windows git bash(mintty)
    # 多会话复用 ssh-pageant，用它连接 putty 的 pagent.exe，稍带运行gpg钥匙圈更新
    # 来自章节 [使ssh鉴权统一调用putty的pageant](ssh.md think)

    # 利用检查 ssh-pageant 进程是否存在，判断是否开机后第一次打开bash会话，则运行gpg钥匙圈更新
    if ! $(ps -s |grep ssh-pageant >/dev/null) ;then
        # 开机后第一次打开bash会话

        echo ''
        # echo "更新gpg钥匙圈需要点时间，请稍等..."
        # gpg --refresh-keys

        echo "gpg 更新 TrustDB，跳过 owner-trust 未定义的导入公钥..."
        gpg --check-trustdb

        echo ''
        echo "gpg 检查签名情况..."
        gpg --check-sigs
    fi

    echo ''
    echo '用 ssh-pageant 连接 putty pageant，复用已加载的 ssh 密钥'
    # ssh-pageant 使用以下参数来判断是否有已经运行的进程，不会多次运行自己
    eval $(/usr/bin/ssh-pageant -r -a "/tmp/.ssh-pageant-$USERNAME")
    ssh-add -l

# 默认用 tty 命令行环境通用的设置
else

    # Linux bash / Windows git bash(mintty)
    # 多会话复用 ssh-agent
    # 代码来源 git bash auto ssh-agent
    # https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows
    # 来自章节 [多会话复用 ssh-agent 进程] <ssh okletsgo>

    agent_env=~/.ssh/agent.env

    agent_load_env () { test -f "$agent_env" && source "$agent_env" >| /dev/null ; }

    agent_start () {
        (umask 077; ssh-agent >| "$agent_env")
        source "$agent_env" >| /dev/null ; }

    agent_load_env

    # 加载 ssh-agent 需要用户手工输入密钥的保护密码
    # 这里不能使用工具 sshpass，它用于在命令行自动输入 ssh 登陆的密码，对密钥的保护密码无法实现自动输入
    #
    # agent_run_state:
    #   0=agent running w/ key;
    #   1=agent w/o key;
    #   2=agent not running
    agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

    if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
        # 开机后第一次打开bash会话

        echo ''
        # echo "更新gpg钥匙圈需要点时间，请稍等..."
        # gpg --refresh-keys

        echo "gpg 更新 TrustDB，跳过 owner-trust 未定义的导入公钥..."
        gpg --check-trustdb

        echo ''
        echo "gpg 检查签名情况..."
        gpg --check-sigs

        echo && echo "启动 ssh-agent..."
        agent_start

        echo "加载 ssh 密钥，请根据提示输入密钥的保护密码"
        ssh-add

    elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
        # ssh-agent正在运行，但是没有加载过密钥
        echo "加载 ssh 密钥，请根据提示输入密钥的保护密码"
        ssh-add
    fi

    unset agent_env
fi

####################################################################
# Bash：加载插件或小工具

# ssh 命令后面按tab键自动补全 hostname
[[ -f ~/.ssh/config && -f ~/.ssh/known_hosts ]] && complete -W "$(cat ~/.ssh/config | grep ^Host | cut -f 2 -d ' ';) $(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

# ackg 看日志最常用，见章节 [ackg 给终端输出的自定义关键字加颜色](gnu_tools.md okletsgo)
[[ -f /usr/local/bin/ackg.sh ]] && source /usr/local/bin/ackg.sh

#################################
# Bash：手动配置插件

# 从上面的 ackg.sh 扩展看日志的快捷命令
alias ackglog='ackg -i "Fail|Error|\bNot\b|\bNo\b|Invalid|Disabled|denied" "\bOk\b|Success|Good|Done|Finish|Enabled" "Warn|Timeout|\bDown\b|Unknown|Disconnect|Restart"'

####################################################################
# Linux bash / Windows git bash(mintty)
# 双行彩色命令行提示符，显示当前路径、git分支、python环境名等
#
# 效果示例：
#
#  ╭─[13:18:18 user@MY-PC::~/yourproject](conda:p37) git:<?>master|MERGING
#  ╰──$ uname -a
#  MSYS_NT-10.0-19044 MY-PC 3.3.5-341.x86_64 2022-11-08 19:41 UTC x86_64 Msys
#
#  ┌─[13:18:06 user@YOURhost:/usr]
#  └──$

# https://zhuanlan.zhihu.com/p/570148970
# https://zhuanlan.zhihu.com/p/566797565
# 色彩      黑    红    绿    黄    蓝    洋红    青    白
# 前景色    30    31    32    33   34    35    36    37
# 背景色    40    41    42    43   44    45    46    47

PS1Cblack=$'\[\e[0;30m\]'

PS1Cred=$'\[\e[0;31m\]'

PS1Cgreen=$'\[\e[0;32m\]'

PS1Cyellow=$'\[\e[0;33m\]'

PS1Cblue=$'\[\e[0;34m\]'

PS1Cmagenta=$'\[\e[0;35m\]'

PS1Ccyan=$'\[\e[0;36m\]'

PS1Cwhite=$'\[\e[0;37m\]'

PS1Cnormal=$'\[\e[m\]'

# 注意：在执行判断退出码的函数前面不能执行别的函数，
# 所以 PS1exit-code 要放在放在 PS1 变量赋值语句的最前面
# 否则
#   所有的函数都要实现 $? 变量的透传
#   { ret_code="$?"; your code...; return ret_code}
#   这样的好处是 PS1exit-code 不必放在 PS1 变量赋值语句的最前面了
function PS1exit-code {
    local exitcode="$?"
    #if [ $exitcode -eq 0 ]; then printf "%s" ''; else printf "%s" ' -'$exitcode' '; fi
    (($exitcode != 0)) && printf "%s" ' -'$exitcode' '
}

function PS1conda-env-name {
    # Linux 下安装 Anaconda 后要加入如下 bash 初始化语句才能在 bash 中使用 conda 命令
    # `conda init bash` 已经加入了 ~/.bashrc 文件，这里应该不需要多次执行
    #eval "$(/home/uu/anaconda3/bin/conda shell.bash hook)"

    # 自定义 conda 的环境名格式，需要先修改 conda 的默认设置，不允许 conda 命令修改 PS1 变量
    # 做如下的设置，只做一次即可：
    #   在 Anaconda cmd 命令行下执行（或者cmd下手工激活base环境，执行命令 `conda activate`）
    #       让 Anaconda 可以 hook 到 .bash_profile
    #           conda init bash
    #       禁止 conda 修改命令行提示符，以防止修改 PS1 变量
    #           conda config --set changeps1 False
    #       禁止 conda 进入命令行提示符时自动激活base环境，以方便检测 $CONDA_DEFAULT_ENV 变量
    #           conda config --set auto_activate_base false
    # 详见 [bash 命令行提示符显示 python 环境名](gnu_tools)
    [[ -n $CONDA_DEFAULT_ENV ]] && printf "(conda:%s)" $CONDA_DEFAULT_ENV
}

# virtualenv 自定义环境名格式，禁止 activate 命令脚本中在 PS1 变量添加环境名称
export VIRTUAL_ENV_DISABLE_PROMPT=1
function PS1virtualenv-env-name {
    [[ -n $VIRTUAL_ENV ]] && printf "(venv:%s)" $(basename $VIRTUAL_ENV)
}

function PS1git-branch-name {

    if $(command -v __git_ps1 >/dev/null 2>&1); then
        # 优先使用 __git_ps1() 取分支名信息
        #
        #   如果使用git for Windows自带的mintty bash，它自带git状态脚本(貌似Debian系的bash都有)
        #   只要启动bash ，其会自动 source C:\Program Files\Git\etc\profile.d\git-prompt.sh，
        #   最终 source C:\Program Files\Git\mingw64\share\git\completion\git-prompt.sh。
        #   这样实现了用户 cd 到git管理的目录就会显示git状态字符串。
        #   来源 https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
        #   如果自定义命令提示符，可以在PS1变量拼接中调用函数 $(__git_ps1 "(%s)") ，
        #   可惜tag和hashid的提示符有点丑，为了显示速度快，忍忍得了
        #
        # __git_ps1 居然透传 $?，前面的命令执行结果被它作为返回值了，只能先清一下，佛了
        _pp_git_pt=$(>/dev/null; __git_ps1 '%s' 2>/dev/null)
        if [ "$?" = "0" ]; then
            # 如果是有效的 git 信息，这里就直接打印并退出函数
            printf "%s" $_pp_git_pt
            unset _pp_git_pt
            return
        else
            unset _pp_git_pt
        fi
    fi

    # 一条命令取当前分支名
    # 命令 git symbolic-ref 在裸仓库或 .git 目录中运行不报错，都会打印出当前分支名，
    # 除非不在当前分支，返回 128，如果当前分支是分离的，返回 1
    # 注意：如果用 local _pp_branch_name 则无法直接判断嵌入变量赋值语句的命令的失败状态
    _pp_branch_name=$(git symbolic-ref --short -q HEAD 2>/dev/null)
    local exitcode="$?"

    case "$exitcode" in
        '0')
            # 优先显示当前 head 指向的分支名
            printf "%s" $_pp_branch_name
            unset _pp_branch_name
            ;;
        '1')
            # 如果是 detached HEAD，则显示标签名或 commit id
            local headhash="$(git rev-parse HEAD)"
            local tagname="$(git for-each-ref --sort='-committerdate' --format='%(refname) %(objectname) %(*objectname)' |grep -a $headhash |grep 'refs/tags' |awk '{print$1}'|awk -F'/' '{print$3}')"
            # 有标签名就显示标签否则显示 commit id
            [[ -n $tagname ]] && printf "%s" "@${tagname}" || printf "%s" "#${headhash}"
            unset _pp_branch_name
            ;;
        *)
            # exitcode 是其它数字的，视为不在 git 环境中，不做任何打印输出
            unset _pp_branch_name
            return
            ;;
    esac
}

function PS1git-branch-prompt {
    local branch=`PS1git-branch-name`

    # branch 变量是空的说明不在 git 环境中
    [[ $branch ]] || return

    # 在裸仓库或 .git 目录中，运行 git status 会报错，所以先判断下
    # if ! $(git status >/dev/null 2>&1) ; then
    if [ "$(git rev-parse --is-inside-work-tree)" == 'false' ]; then
        # 如果不在 git 工作区，则不打印分支名，以提醒使用者
        printf " git:!git-dir"

    else
        # git 工作区有变更就显示问号
        local notify_flag=$(if ! [ -z "$(git status --porcelain)" ]; then printf "%s" '<?>'; else printf "%s" ''; fi)
        # 拼接后输出 git 工作区状态和分支名
        printf " git:%s%s" $notify_flag $branch

    fi
}

# 主机名用不同颜色提示本地或远程登录：本地登录是绿色，ssh 远程登录是洋红色
function PS1_host_name {
    [[ -n $SSH_TTY ]] && echo -e "\033[0;35m$(hostname)" || echo -e "\033[0;32m$(hostname)"
}

# 提示当前在 toolbox 或 distrobox 等交互式容器环境，白色容器名配洋红背景
# https://docs.fedoraproject.org/en-US/fedora-silverblue/tips-and-tricks/#_working_with_toolbx
# https://ublue.it/guide/toolbox/#using-the-hosts-xdg-open-inside-distrobox
# https://github.com/docker/cli/issues/3037
# Windows 下的 wsl 环境，wsl 下的 docker，暂未研究
function PS1_is_in_toolbox {
    if [ -f "/run/.toolboxenv" ] || [ -e /run/.containerenv ]; then
        echo -e "\033[0;45m<$(cat /run/.containerenv | grep -oP "(?<=name=\")[^\";]+")>"
    elif  [ -e /.dockerenv ]; then
        echo -e "\033[0;45m<$(cat /run/.dockerenv | grep -oP "(?<=name=\")[^\";]+")>"
    fi
}

###################
# Windows git bash(mintty)
# 设置命令行提示符 PS1
# 在上面的基础上修改了个兼容性函数，因为 目前 git bash(mintty) 有点bug：
#   在\$(函数名)后直接用换行\n就冲突
# 规避办法
#   法1. 把换行\n放在引用函数前面
#   法2. 重新拼接成新样式避开这个bug: PS1="\n$PS1Cblue┌──── $PS1Cwhite\t ""$PS1""$PS1Cblue───┘ $PS1Cnormal"
#   法3. 完美的解决办法：新增子函数 PS1git-bash-new-line 实现跟上面完全一致的显示效果。
function PS1git-bash-new-line {
    printf "\n╰"
}

###################
# Linux bash - raspberry pi os (debian)
# raspberry pi 的状态检测
# 告警条件：
#   CPU 温度的单位是千分位提权 1000
#   系统 throttled 不是零
#   CPU Load Average 的值应该小于CPU核数的70%，取1分钟平均负载
function PS1raspi-warning-info {

    [[ $(command -v vcgencmd >/dev/null 2>&1; echo $?) = "0" ]] || return

    local CPUTEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

    if [ "$CPUTEMP" -gt "60000" ] && [ "$CPUTEMP" -lt "70000" ]; then
        local CPUTEMP_WARN="= CPU `vcgencmd measure_temp` ="
    elif [ "$CPUTEMP" -gt  "70000" ];  then
        local CPUTEMP_WARN="= CPU `vcgencmd measure_temp` IS VERY HIGH! SHUTDOWN NOW! ="
    fi

    local THROTT=`vcgencmd get_throttled| tr -d "throttled="`
    if [ "$THROTT" != "0x0" ];  then
        local THROTT_WARN="= System throttled [$THROTT], check https://www.raspberrypi.com/documentation/computers/os.html#get_throttled ="
    fi

    local CPU_CORES=`grep -e 'processor.*:' /proc/cpuinfo | wc -l`
    local LOAD_AVG_CAP=`echo | awk -v cores="$CPU_CORES" '{printf("%.2f",cores*0.7)}'`
    local LOAD_AVG=`cat /proc/loadavg | cut -d' ' -f 1`
    local LOAD_AVG_THLOD=`echo | awk -v avg="$LOAD_AVG" -v cap="$LOAD_AVG_CAP" '{if (avg>cap) {print "1"} else {print "0"}}'`
    (($LOAD_AVG_THLOD > 0)) && local LOAD_AVG_WARN="= AVG_LOAD 1min: $LOAD_AVG ="

    printf "%s%s%s" "$CPUTEMP_WARN" "$THROTT_WARN" "$LOAD_AVG_WARN"
}

function PS1raspi-warning-prompt {
    local raspi_warning=`PS1raspi-warning-info`
    if [ -n "$raspi_warning" ]; then
        printf "====%s====" "$raspi_warning"
    fi
}

#################################
# 设置命令行提示符 PS1
if [[ $OS =~ Windows && "$OSTYPE" =~ msys ]]; then
    # Windows git bash 命令行提示符显示：返回值 \t当前时间 \u用户名 \h主机名 \w当前路径 python环境 git分支及状态
    PS1="\n$PS1Cblue╭─$PS1Cred\$(PS1exit-code)$PS1Cblue[$PS1Cwhite\t $PS1Cgreen\u$PS1Cwhite@\$(PS1_host_name)$PS1Cwhite:$PS1Ccyan\w$PS1Cblue]$PS1Cyellow\$(PS1conda-env-name)\$(PS1virtualenv-env-name)\$(PS1git-branch-prompt)$PS1Cblue$(PS1git-bash-new-line)──$PS1Cwhite\$ $PS1Cnormal"

elif $(cat /proc/cpuinfo |grep Model |grep Raspberry >/dev/null 2>&1); then
    # 本机登录后禁用屏幕休眠 https://zhuanlan.zhihu.com/p/114716305
    # 本机图形界面
    #   /etc/profile.d/hibernate.sh
    #   xset s off
    #   xset dpms 0 0 0
    # 本机命令行
    setterm --powerdown 0

    # Raspberry OS bash 命令行提示符显示：返回值 \t当前时间 \u用户名 \h主机名<toolbox容器名> \w当前路径 树莓派温度告警 python环境 git分支及状态
    PS1="\n$PS1Cblue┌─$PS1Cred\$(PS1exit-code)$PS1Cblue[$PS1Cwhite\t $PS1Cgreen\u$PS1Cwhite@$PS1Cgreen\$(PS1_host_name)\$(PS1_is_in_toolbox)$PS1Cwhite:$PS1Ccyan\w$PS1Cblue]$PS1Cred\$(PS1raspi-warning-prompt)$PS1Cyellow\$(PS1conda-env-name)\$(PS1virtualenv-env-name)\$(PS1git-branch-prompt)\n$PS1Cblue└──$PS1Cwhite\$ $PS1Cnormal"

else
    # 通用 Linux bash 命令行提示符显示：返回值 \t当前时间 \u用户名 \h主机名<toolbox容器名> \w当前路径 python环境 git分支及状态
    PS1="\n$PS1Cblue┌─$PS1Cred\$(PS1exit-code)$PS1Cblue[$PS1Cwhite\t $PS1Cgreen\u$PS1Cwhite@\$(PS1_host_name)\$(PS1_is_in_toolbox)$PS1Cwhite:$PS1Ccyan\w$PS1Cblue]$PS1Cyellow\$(PS1conda-env-name)\$(PS1virtualenv-env-name)\$(PS1git-branch-prompt)\n$PS1Cblue└──$PS1Cwhite\$ $PS1Cnormal"

fi
