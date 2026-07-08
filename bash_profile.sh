# .bash_profile

#####################################################################
# 适用于 Linux bash、Linux zsh、Windows git bash(mintty.exe)，macOS（未完全测试）
#
# 1、统一在一个文件
#   alias和路径设置等本该放到 .bashrc 文件，为了方便统一在此了。
#   支持在 .zshrc 中 `source`，以便在 zsh 下也保持使用习惯。
# 2、可直接部署到远程服务器
#   ssh user@server "tee .bash_profile" < bash_profile.sh
#   如果遇到  $'\r': command not found
#       ssh user@server "sed -i 's/\r$//' .bash_profile"
# 3、使用前需要手工调整的地方：
#
#   环境变量 PDMREPO ，要根据你的内网镜像仓库服务器手动设置地址
#
#   如果在网络不卡的环境，应该屏蔽掉函数 poor_connection 的执行
#
# 4、脚本比较长，其实结构不复杂
#  先引用配置文件配置几个环节变量，非交互式登录至此就退出了，
#  后面的设置都是给交互式登录，为了使用习惯的用户自定义设置：
#  一、准备环境信息，方便后面使用
#  二、适用性方面的调整和环境设置，涉及颜色方案、字符编码、常用工具设置等
#  三、常用命令的惯用法用别名和函数封装起来，方便日常使用
#  四、双行彩色命令行提示符，显示当前路径、git分支、python环境名等
# 5、别人的配置文件参考大全
#   https://github.com/pseudoyu/dotfiles
#   https://www.pseudoyu.com/zh/2022/07/10/my_config_and_beautify_solution_of_macos_terminal/

#######################
# 此部分作为普通脚本的默认头部内容，便于调测运行。
# 在本脚本中不适用，保留备查。
#
# declare -p PS1 打印指定变量的定义
# set 显示当前所有内置变量和函数定义：
#   -x ： 在执行每一个命令之前把经过变量展开之后的命令打印出来。
#   -e ： 遇到一个命令失败（返回码非零）时，立即退出。
#   -u ：试图使用未定义的变量，就立即退出。
#   -o pipefail ： 只要管道中的一个子命令失败，整个管道命令就失败，这样可以捕获到其退出代码
# 可连写 set -euo pipefail
# trap "rm -f $temp_file" 0 2 3 15  # `trap -l` for all useble signal
# 意外退出时杀掉所有子进程
# trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

#######################
# 兼容性设置：.bash_profile 明确加载 `source .bashrc`
#    很多软件的安装脚本设置变量会写入 .bashrc
#    zsh 可以 `source .bash_profile`` 就没道理不 `source .bashrc`
# 以此避免有的发行版不加载，因为其原定义是 ~/.bashrc: executed by bash(1) for non-login shells.
#   see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples
if [[ -f ~/.bashrc ]]; then
    . ~/.bashrc
fi

#######################
# 兼容性设置：bash 优先调用 .bash_profile，就不会调用 .profile
# 而 Debian 系在 .profile 里把某几个标准目录设置到变量 $PATH，不调用 .profile 会导致 bash 找不到某些基础命令。
#   ~/.profile: executed by the command interpreter for login shells.
#     This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.
#     see /usr/share/doc/bash/examples/startup-files for examples.
#     the files are located in the bash-doc package.
# 为保持兼容性，这里不直接执行 .profile 文件，而是单独补充，只把这几个标准目录设置到变量 $PATH
for dir in "$HOME/.local/bin" "$HOME/bin"; do
    if [[ -d "$dir" ]] && [[ ":$PATH:" != *":$dir:"* ]]; then
        PATH="$PATH:$dir"
    fi
done
export PATH

#######################
# 兼容性设置：exit for non-interactive shell
# 如果是非交互式登录(ssh直接在服务器执行脚本等场景)，到这里就可以退出了，后面的设置统统不需要
# 注意：
#   本脚本是被 source 使用的 `source .bash_profile`，直接执行是错误用法，而 `source` 可以用 return 命令。
#   如果把 return 改成 exit 会导致致命问题：GNOME/KDE 桌面环境下用户登录过程秒退到登录界面且无任何提示。
# export QT_QPA_PLATFORM=offscreen
[[ $- != *i* ]] && return

#####################################################################
# 以下内容都是为了使用习惯的用户自定义设置
# User specific environment and startup programs

# 避坑
#   变量赋值别习惯性的在等号两边加空格
#   为防止变量名污染命令行环境，尽量使用奇怪点的名称

##############################################
# 一、准备环境信息，方便后面使用

# current_shell：当前脚本环境
if [ -n "$BASH_VERSION" ]; then
    current_shell="bash"
elif [ -n "$ZSH_VERSION" ]; then
    current_shell="zsh"
elif [ -n "$KSH_VERSION" ]; then
    current_shell="ksh"
elif [ -n "$FISH_VERSION" ]; then
    current_shell="fish"
else
    current_shell=$(ps -p $$ -o comm= | sed 's/^-//')
fi

# os_type：当前操作系统类型
os_name=$(uname -s)
case "$os_name" in
    Linux*)
        # linux 再细分几个类型
        if command -v vcgencmd >/dev/null 2>&1; then
            os_type="raspi"
        elif uname -r | grep -i Microsoft >/dev/null 2>&1; then
            os_type="wsl"
        else
            os_type="linux"
        fi
        ;;
    Darwin*)
        os_type="macos"
        ;;
    FreeBSD*)
        os_type="freebsd"
        ;;
    MSYS_NT*|MINGW32_NT*|MINGW64_NT*|CYGWIN_NT*)
        # Windows git bash(mintty)/MSYS2
        os_type="windows"
        ;;
    *)
        echo "Warning: Unknown OS detected: $os_name" >&2
        os_type="unknown"
        ;;
esac
unset os_name

#######################
# 设置仓库和镜像地址，方便后面使用

# 为方便做多个内网环境使用，只能加这么个屏幕打印，暂没有更好的解决办法
export PDMREPO="192.168.0.111:5000" && echo "内网私有容器镜像仓库地址设置为 PDMREPO=${PDMREPO}"

# 常用软件仓库的国内镜像
poor_connection() {
    # huggingface.co
    export HF_ENDPOINT=https://hf-mirror.com

    # uv
    export UV_DEFAULT_INDEX=https://pypi.tuna.tsinghua.edu.cn/simple/

    # nvm 只用于快速安装 Node.js
    export NVM_NODEJS_ORG_MIRROR="https://npmmirror.com/mirrors/node"

    # 加速 npm 所有普通包的下载
    export NPM_CONFIG_REGISTRY="https://registry.npmmirror.com"

    # 有些 npm 包需要单独设置，比如 Hermes Agent 编译安装桌面版
    # node-gyp (依赖：disturl)用于编译原生模块，加速 Node.js 源码和头文件的下载
    export npm_config_disturl="https://npmmirror.com/mirrors/node/"
    # Electron 镜像：加速 Electron 预编译二进制文件的下载
    export ELECTRON_MIRROR="https://npmmirror.com/mirrors/electron/"

    # rust
    export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
    export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup

    if [[ $os_type = 'macos' ]]; then
        # Homebrew 国内镜像
        # https://mirrors.ustc.edu.cn/help/brew.git.html
        export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"

        # 核心软件仓库 https://mirrors.ustc.edu.cn/help/homebrew-core.git.html
        export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"

        # Brew 4.0 版本后默认使用元数据 JSON API 获取仓库信息
        # https://mirrors.ustc.edu.cn/help/homebrew-bottles.html
        export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

        # 预编译二进制软件包与软件包元数据文件 https://mirrors.ustc.edu.cn/help/homebrew-bottles.html
        export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"

        # cask 软件仓库，提供 macOS 应用和大型二进制文件 https://mirrors.ustc.edu.cn/help/homebrew-cask.git.html
        # 不再需要设置了 brew tap --custom-remote homebrew/cask https://mirrors.ustc.edu.cn/homebrew-cask.git
    fi
}
# 如果在网络不卡的环境，应该屏蔽掉函数 poor_connection 的执行
poor_connection

#######################
# 定义工具函数，方便后面使用

# curlgh - 从 GitHub 下载文件，支持多种 URL 格式，直连失败自动降级到 jsDelivr CDN
curlgh() {
    if [ $# -eq 0 ]; then
        echo "获取 github 文件，下载超时则自动更换 CDN 下载：" >&2
        echo "  curlgh https://github.com/m666m/ask/blob/main/install.sh" >&2
        echo "  curlgh https://github.com/m666m/ask/raw/refs/heads/main/install.sh" >&2
        echo "  curlgh https://raw.githubusercontent.com/m666m/ask/main/install.sh" >&2
        return 1
    fi

    local url="$1"
    local raw_url=""

    # NOTE: 调用可能不存在的命令，必须先 `command -v` 判断一下，否则不存在的命令Fedora会搜索软件仓库导致卡顿
    if ! command -v curl >/dev/null 2>&1; then
        echo "  Error: Cant find curl!" >&2
        return 1
    fi

    # ---------- 第一步：统一转换为 raw.githubusercontent.com 地址 ----------
    if [[ "$url" == *"raw.githubusercontent.com"* ]]; then
        # 已经是原始文件地址
        raw_url="$url"
    elif [[ "$url" == *"github.com"* ]]; then
        # 处理页面浏览地址，例如 https://github.com/m666m/ask/blob/main/install.sh
        # 转换为原始文件地址   https://raw.githubusercontent.com/m666m/ask/main/install.sh
        if [[ "$url" == *"/blob/"* ]]; then
            raw_url=$(echo "$url" | sed 's#https://github.com/#https://raw.githubusercontent.com/#; s#/blob/#/#')

        # 处理 /raw/ 格式的浏览地址，自动去除 /refs/heads/ 和 /refs/tags/ 部分
        # https://github.com/m666m/ask/raw/refs/heads/main/install.sh
        #   → https://raw.githubusercontent.com/m666m/ask/main/install.sh
        elif [[ "$url" == *"/raw/"* ]]; then
            raw_url=$(echo "$url" | sed -E 's#https://github.com/([^/]+)/([^/]+)/raw/(refs/(heads|tags)/)?([^/]+)/(.*)#https://raw.githubusercontent.com/\1/\2/\5/\6#')
        else
            echo "[curlgh] 不支持的 GitHub 链接格式: $url" >&2
            return 1
        fi
    else
        # 非 GitHub 链接，直接报错
        echo "[curlgh] 不支持的非 GitHub 链接: $url" >&2
        return 1
    fi

    # ---------- 第二步：优先从原始地址下载 ----------
    if curl -fsSL --connect-timeout 10 --max-time 30 --speed-time 15 --speed-limit 1 "$raw_url"; then
        return 0
    fi

    # ---------- 第三步：原始地址下载失败，则尝试 jsDelivr CDN 地址 ----------
    # https://raw.githubusercontent.com/m666m/ask/main/install.sh
    #   ↓
    # https://cdn.jsdelivr.net/gh/m666m/ask@main/install.sh
    local cdn_url
    # shellcheck disable=SC2001  # 需要正则回引号重组 URL，不能用 ${//}
    cdn_url=$(echo "$raw_url" | sed 's|https://raw.githubusercontent.com/\([^/]*\)/\([^/]*\)/\([^/]*\)/\(.*\)|https://cdn.jsdelivr.net/gh/\1/\2@\3/\4|')

    echo "[curlgh] 原始地址下载失败，尝试 CDN 地址: $cdn_url" >&2

    if curl -fsSL --connect-timeout 10 --max-time 30 --speed-time 15 --speed-limit 1 "$cdn_url"; then
        return 0
    else
        echo "[curlgh] CDN 下载也失败了，请重试！" >&2
        return 1
    fi
}

# ASK_INSTALL_CURL=curlgh curlgh https://github.com/m666m/ask/raw/main/install.sh | bash
# curl: (28) SSL connection timeout
# [curlgh] 原始地址下载失败，尝试 CDN 地址: https://cdn.jsdelivr.net/gh/m666m/ask@main/install.sh
# 开始安装 ask AI 助手...
# 下载 ask 脚本...
# curl: (56) Failure when receiving data from the peer
# 错误: ask 安装失败，请检查网络后重试

##############################################
# 二、适用性方面的调整和环境设置，涉及颜色方案、字符编码、常用工具设置等

# 在终端模拟器中命令行的字符显示彩色
# 显式设置终端启用256color，防止终端工具未设置或设置的太低。若终端工具能开启透明选项，则显示的效果更好
export TERM=xterm-256color
export COLORTERM=truecolor

# 参考自 Debian 的 .bashrc 脚本中，常用命令开启彩色选项
# enable color support of ls and also add handy aliases
# 整体仍然受终端模拟器对16种基本颜色的设置控制，也就是说，在终端模拟器中使用颜色方案，配套修改 dir_colors ，让更多的文件类型使用彩色显示
if [ -x /usr/bin/dircolors ]; then

    # 下载使用 dir_colors 颜色方案-北极，可影响 ls、tree 等命令的颜色风格
    if [[ ! -f ~/.dir_colors ]]; then
        echo '建议安装命令行显示文件颜色方案 nord-dircolors'
        echo "  curlgh https://raw.githubusercontent.com/nordtheme/dircolors/develop/src/dir_colors > ~/.dir_colors || rm -f ~/.dir_colors "
    fi

    if test -r ~/.dir_colors; then
        eval "$(dircolors -b ~/.dir_colors)"
    else
        eval "$(dircolors -b)"
    fi

fi

# Debian 下的 distrobox 环境不继承宿主机的 LANG 变量，导致图标字体不能正确显示
[[ -n $LANG ]] || export LANG=en_US.UTF-8

# 删除 vi 然后安装 vim，居然没有 `vi` 了
command -v vi >/dev/null || {
    echo "建议补全 vi 调用：sudo ln -sf /usr/bin/vim /usr/bin/vi"
}

# 命令行开启 vi 模式，按esc后用vi中的上下左右键选择历史命令
# zsh 命令行用 `bindkey -v` 来设置 vi 操作模式
[[ $current_shell != 'zsh' ]] && set -o vi

# 有些命令使用变量 EDITOR 指定的编辑器，一般是 nano，强制指定为 vi
export EDITOR=/usr/bin/vi

# 在终端模拟器中设置了光标闪动有时候在ssh连接远程后或tmux中也不生效，强制开启
#tput cnorm && echo -e '\033[?12h\033[1 q'

#######################
# 树莓派下的环境设置
if  [[ $os_type = 'raspi' ]]; then
    # 树莓派在纯终端下也会休眠显示器，必须设置本机登录后禁用屏幕休眠
    setterm --powerdown 0
fi

#######################
# macOS 下的环境设置
if [[ $os_type = 'macos' ]]; then
    if [[ $current_shell = 'bash' ]]; then
        if [ "${BASH_VERSION%%.*}" -lt 5 ]; then
            echo 'macOS 预装的 bash 版本老旧，建议 `brew install bash` 使用 /opt/homebrew/bin/bash'
        fi

        # Homebrew 下情况特殊，bash 安装的目录是区别于系统自带的
        # 1、bash-completion 需要主动引用下
        # `brew install bash bash-completion@2` 才是新版及配套自动完成
        # 自带的自动完成脚本在 $HOMEBREW_PREFIX/opt/homebrew/share/bash-completion/completions
        # 软件自行安装的自动完成脚本一般放在 $HOMEBREW_PREFIX/etc/bash_completion.d
        if [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]]; then
           source $HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh
        fi
    fi

    # 自动切换对应架构的 Homebrew，在使用 x86 容器镜像或 Windows 游戏时常用
    if [ "$(arch)" = "arm64" ]; then
        if [ -f "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        if [ -f "/usr/local/bin/brew" ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

fi

#######################
# gpg: problem with the agent: Inappropriate ioctl for device，
#   参见章节 [命令行终端下 gpg 无法弹出密码输入框的问题](gpg think)
if command -v gpg >/dev/null 2>&1; then
    export GPG_TTY=${TTY:-$(tty)}
    #echo "以当前终端 tty 连接 gpg-agent..."
    gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
fi

#######################
# 功能增强：ssh 命令后面按tab键自动补全 hostname，zsh 有扩展插件不需要
_comp_ssh_hosts() {
    local cur config_hosts known_hosts hosts

    cur="${COMP_WORDS[COMP_CWORD]}"

    [[ -f ~/.ssh/config ]] && config_hosts=$(awk '/^Host / && $2 !~ /\*/ {print $2}' ~/.ssh/config 2>/dev/null)

    [[ -f ~/.ssh/known_hosts ]] && known_hosts=$(grep -v '^|' ~/.ssh/known_hosts 2>/dev/null | awk '{print $1}' | tr ',' '\n' | sed -E 's/^\[(.*)\](:[0-9]+)?$/\1/; s/:[0-9]+$//' | sort -u)

    hosts=$(echo "$config_hosts $known_hosts" | tr ' ' '\n' | sort -u)

    COMPREPLY=($(compgen -W "$hosts" -- "$cur"))
}

if [[ $current_shell != 'zsh' ]]; then

    # Linux bash 使用配套的自动完成，依次回落：
    # 优先调用 openssh-clients 包自带的
    if [[ -f /etc/bash_completion.d/ssh ]]; then
        source /etc/bash_completion.d/ssh

    # 回落到 bash-completion 包自带的
    elif [[ -f /usr/share/bash-completion/completions/ssh ]]; then
        source /usr/share/bash-completion/completions/ssh

    # 回落到自制的
    else
        complete -F _comp_ssh_hosts ssh
    fi
fi

#######################
# 功能增强：Hermes Agent 等命令的自动完成功能需要主动引入
if [[ $current_shell != 'zsh' ]]; then
    if command -v hermes >/dev/null; then
        eval "$(hermes completion bash)"
    fi
fi

#######################
# 功能增强：命令行使用 ssh 多会话复用 ssh 密钥代理
# 设置变量指向ssh密钥代理的进程即可实现复用，参见章节 [多会话复用 ssh-agent 进程](ssh.md think)
# 适用于 Linux bash / Windows git bash(mintty) / macOS
if ls "$HOME/.ssh"/id_* >/dev/null 2>&1; then

    # macOS 下把 ssh 密钥加入钥匙圈，并接管 ssh-agent 复用
    # 1、ssh-add --apple-use-keychain ~/.ssh/id_rsa
    # 2、配合 SSH 配置文件的 Host * 段添加 UseKeychain yes 和 AddKeysToAgent yes 可以不用再输入保护密码了
    if [[ $os_type = 'macos' ]]; then
        # macOS 默认集成了 launchd 来启动 ssh-agent，还负责设置 SSH_AUTH_SOCK 变量。
        # 但是重启电脑后，需要手动执行一次加载密钥的命令
        # 以下代码参考自下面的 默认 Linux tty 环境复用 ssh-agent 进程
        agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
        if  [ $agent_run_state = 1 ]; then
            # agent 没有加载密钥视作开机后第一次执行 shell 登录
            ssh-add --apple-load-keychain
        fi

    # GNOME 桌面环境下使用 ssh 密钥，ssh-agent 可以被 gnome-keyring 接管复用，
    # 只需要 SSH 配置文件的 Host * 段添加 AddKeysToAgent yes，然后执行一次 `ssh-add` 即可。
    # 原理见 [Gnome 桌面的密码管理器应用程序](okletsgo)。
    # 以下代码保留至 Debian 13(GNOME 48) retired(LTS 阶段：至 2030 年 8 月).
    elif [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && command -v gnome-shell >/dev/null; then
        # 以下操作仅限于 gnome49 之前的版本，之后 GNOME 使用 gcr-ssh-agent.service 接管 ssh-agent 了，不再有需要手工启动 gnome-keyring-daemon 的情况
        gsversion=$(gnome-shell --version | awk '{print $3}' | awk -F. '{print $1}')

        if [ "$gsversion" -lt 49 ]; then

            # GNOME 桌面环境用自己的 keyring 管理接管了全系统的密码和密钥，并实现了 ssh 密钥代理功能
            # 但 gnome-keyring-daemon 有时候没有开机自启动 gnome-keyring-daemon 守护进程，
            # 就没有 /usr/bin/ssh-agent -D -a /run/user/1000/keyring/.ssh，导致无法读取ssh代理的密钥
            # 干脆手工启动  https://blog.csdn.net/asdfgh0077/article/details/104121479
            pgrep gnome-keyring >/dev/null 2>&1 || gnome-keyring-daemon --start >/dev/null 2>&1

            # 给 ssh 密钥代理 ssh-agent 设置变量指向 gnome-keyring-daemon
            # 实现复用需要设置变量指向ssh密钥代理的进程
            # gnome-keyring 为何不自动设置这两个变量，既然接管了，又不声明，很有个性。。。
            # 目前必须手动设置
            export SSH_AUTH_SOCK="$(ls /run/user/$(id -u "$USER")/keyring*/ssh | head -1)"
            export SSH_AGENT_PID="$(pgrep gnome-keyring)"

            # 然后就可以加载密钥了，缓存到 ssh-agent 进程，后续用到时就会自动使用
            # 因为 gnome-keyring-daemon 接管了这个功能，用到的时候自动提交，全程用户无感知，不需要执行 `ssh-add` 了
            # ssh-add

        fi

    # KDE 桌面环境使用 systemd 单元文件 ssh-agent.service 实现复用 ssh-agent 进程
    elif [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]]; then

        # KDE 桌面环境有自己的 `systemctl --user status ssh-agent.service`
        # 启动默认的 /usr/bin/ssh-agent -D -a /run/user/1000/ssh-agent.socket

        # 实现复用需要设置变量指向ssh密钥代理的进程
        # 需要两个变量，服务 ssh-agent.service 只设置了一个，很有个性
        # export SSH_AUTH_SOCK="$(ls $XDG_RUNTIME_DIR/ssh-agent.socket |head -1)"
        # export SSH_AGENT_PID="$(ps -ef | grep 'ssh-agent -D -a' | grep -v grep | awk '{print $2}')"
        # 所以，目前必须手动设置该变量，获取服务进程的 PID
        AGENT_PID=$(systemctl --user show ssh-agent.service --property=ExecMainPID | awk -F= '{print $2}')
        # 通过进程树找到 ssh-agent 的实际 PID（需安装 pstree）
        SSH_AGENT_PID=$(pstree -p $AGENT_PID | grep -oP 'ssh-agent\(\K\d+')
        export SSH_AGENT_PID

        # 这个 ksshaskpass 没用
        # https://github.com/KDE/ksshaskpass
        # SSH_ASKPASS=/usr/bin/ksshaskpass

        # 然后就可以加载密钥了，缓存到 ssh-agent 进程，后续用到时就会自动使用
        if ! ssh-add -l >| /dev/null 2>&1; then
            echo "--> Adding ssh key to agent, input the key passphrase if prompted..."
            ssh-add
        else
            # ssh-agent正在运行，加载过密钥
            # ssh-add -l
            :
        fi

    # Windows 下使用 putty 桌面程序 pagent 加载密钥，
    # Windows git bash(mintty) 利用 ssh-pageant 连接到 pagent.exe 进程，复用其缓存的密钥，
    # 这样不需要运行 ssh-agent 并执行 `ssh-add` 那套流程。
    # 来自章节 [Windows 下 ssh 身份认证复用 putty pageant](ssh.md think)
    elif [[ $os_type = 'windows' ]]; then

        if ! ps -s | grep -q ssh-pageant; then
            # ssh-pageant 未运行视作开机后第一次执行 shell 登录，清理掉上次使用过的临时文件，否则会被加载
            rm -f /tmp/.ssh-pageant-$USERNAME

            # 搭车运行 gpg 钥匙圈更新
            # ggkupd
        fi

        echo ''
        # 使用以下参数启动 ssh-pageant，不会多次重复运行
        # ssh-pageant 还会导出变量指向ssh密钥代理的进程，用户不需要操心
        eval $(/usr/bin/ssh-pageant -r -a "/tmp/.ssh-pageant-$USERNAME")

    # 默认 Linux tty 环境复用 ssh-agent 进程，这个设置最通用，在 macOS / Windows git bash(mintty) 环境下也可以使用
    else

        # 代码来源 git bash auto ssh-agent
        # https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows
        #
        # You can run ssh-agent automatically when you open bash or Git shell.
        # Copy the following lines and paste them into one of your
        #    ~/.bash_profile
        #    ~/.profile
        #    ~/.bashrc
        # 说明：当你打开一个 bash 会话，自动调用 ssh-add 加载你的密钥。
        # 如果 ssh-agent 进程没启动，则自动调用起来，
        # 若已经在其它会话调起来了，则复用该进程，保持你的用户会话中只运行一个ssh-agent进程。
        # 如果要提高使用安全性，在不使用 ssh-agent 的时候，从操作系统进程中找到该进程手工杀掉即可。

        # 环境变量指向已经启动的 ssh-agent 进程
        agent_env=~/.ssh/agent.env

        # 复用已经启动的 ssh-agent 进程，引用环境变量即可
        agent_load_env () { test -f "$agent_env" && source "$agent_env" >| /dev/null ; }

        # 启动 ssh-agent，并保存指向它的环境变量
        agent_start () {
            (umask 077; ssh-agent >| "$agent_env")
            source "$agent_env" >| /dev/null
        }

        agent_load_env

        # 检查密钥是否加载了
        # 如果 agent 未运行，则复用的变量可能是上次开机设置的，需要重新设置
        # `ssh-add` 会读取相关环境变量调用到 ssh-agent 进程
        # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
        agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
        if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
            # 如果 agent 未运行视作开机后第一次执行 shell 登录

            # 搭车运行 gpg 钥匙圈更新
            #ggkupd

            echo
            echo "Start ssh-agent..."
            agent_start

            # 加载密钥，缓存到 ssh-agent 进程，
            # 这里必须手动输入一次密钥的保护密码，后续用到时就会自动使用无需再次输入
            echo "--> Adding ssh key to agent, input the key passphrase if prompted..."
            ssh-add

        elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
            # ssh-agent 正在运行，但是没有加载过密钥

            # 加载密钥，缓存到 ssh-agent 进程，
            # 这里必须手动输入一次密钥的保护密码，后续用到时就会自动使用无需再次输入
            echo "--> Adding ssh key to agent, input the key passphrase if prompted..."
            ssh-add

        else
            # ssh-agent正在运行，加载过密钥
            # ssh-add -l
            :
        fi

        unset agent_run_state
        unset agent_env
    fi
fi

#######################
# 功能增强：ack 命令下载个 hhighlighter 插件
if command -v ack >/dev/null 2>&1; then

    if [[ -s /usr/local/bin/ackg.sh ]]; then
        source /usr/local/bin/ackg.sh

        alias ackgs='ackg -i'
        alias ackglog='ackg -i "Fail|Error|\bNot\b|\bNo\b|Invalid|Disabled|denied" "\bOk\b|Success|Good|Done|Finish|Enabled" "Warn|Timeout|\bDown\b|Unknown|Disconnect|Restart"'

    else

        echo "ackg 看日志比grep好用，见章节 [ackg 给终端输出的自定义关键字加颜色](gnu_tools.md okletsgo)" >&2

        printf "建议如下操作
        tmpfile=\$(mktemp)
        curlgh https://github.com/paoloantinori/hhighlighter/raw/master/h.sh > \$tmpfile || rm -f \$tmpfile

        sed -i 's/^h()/ackg()/' \$tmpfile
        sed -i.bak 's/^h()/ackg()/' \$tmpfile && rm \$tmpfile.bak
        sudo mv \$tmpfile /usr/local/bin/ackg.sh

        rm -f \$tmpfile
        unset tmpfile

        source /usr/local/bin/ackg.sh
        \n"
    fi
fi

#######################
# 功能增强：ask 命令问 AI
if ! command -v ask >/dev/null 2>&1; then
    # (set -o pipefail; curlgh "https://github.com/m666m/ask/blob/main/install.sh" | bash) || echo "Ask installation failed"
    echo "建议安装 ask 命令问 AI:" >&2
    echo "  export -f curlgh" >&2
    echo "  curlgh https://github.com/m666m/ask/raw/main/install.sh | ASK_INSTALL_CURL=curlgh bash" >&2
fi

##############################################
# 三、常用命令的惯用法用别名和函数封装起来，方便日常使用

# 注意：基础命令不要搞太花哨，导致脚本里解析出现用法不一致的问题
# 常用的列文件的惯用法
alias ls='ls --color=auto'
alias l='ls -CFA'
alias ll='ls -lh'
alias la='ls -lAh'
alias las='ls -lAhZ'
alias lsa='ls -A'

#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto --exclude-dir=.bzr --exclude-dir=CVS --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=__pycache__'
#alias egrep='egrep --color=auto'
#alias fgrep='fgrep --color=auto'
alias tree='tree -a -C'

# 列出目录下的文件清单，查找指定关键字，如 `lsg fnwithstr`。因为ls列出的目录颜色被grep覆盖，用 ls -l 查看更方便。
alias lsg='ls -lFA |grep -i'
# 列出当前目录及子目录的文件清单，查找指定关键字，如 `findf fnwithstr`
alias findf='find . |grep -i'
# 在管道或当前目录下的文件中（排除目录）查找指定关键字，列出文件名和所在行，如 `greps strinfile *`
alias greps='grep -d skip -in'
# 在管道或配置文件查找指定关键字，列出文件名和所在行，追加显示后续的 5 行内容
alias grepa='grep -d skip -in -A5'
# 在当前目录和子目录下的文件中查找指定关键字，列出文件名和所在行，跳过.git等目录，如 `finds strinfile`
alias finds='find . \( -name ".git" -o -name "__pycache__" \) -prune -o -print0 |xargs -0 grep --color=auto -d skip -in'

alias trees='echo "[目录树，最多2级，显示目录和可执行文件的标识，跳过.git等目录]" >&2; tree -a -CF -I ".git|__pycache__" -L 2'
alias trees3='echo "[目录树，最多3级，显示目录和可执行文件的标识，跳过.git等目录]" >&2; tree -a -CF -I ".git|__pycache__" -L 3'
alias treeh='echo "[树形列出目录及文件大小，最多2级]" >&2; tree --du -h -L 2'
alias treeh3='echo "[树形列出目录及文件大小，最多3级]" >&2; tree --du -h -L 3'

if [[ $os_type = 'macos' ]]; then
    alias pstreep='echo "[进程树，列出pid所在的进程树]" >&2; pstree -p'
    alias pstrees='echo "[进程树，列出相关名称所在的进程树]" >&2; pstree -s'
else
    alias pstreep='echo "[进程树，列出pid所在的进程树]" >&2; pstree -s -p'
fi

# 从下载文件夹的子目录里把各种电影文件统一挪到当前，方便整理
mvf() {
    if [ "$#" -ne 1 ]; then
        echo '用法：把子目录下的指定后缀的文件移动到当前目录 mvf mp4' >&2
        return 1
    fi

    local fnn=${1}
    # find . -mindepth 2 -type f -name "${fnn}" -print0 | xargs -0 -I {} mv "{}" .
    find . -mindepth 2 -type f -name "*.${fnn}" -exec mv {} . \;
}

# 设置目录及其子目录和文件权限的常用操作
chperm() {
    if [ $# -lt 1 ]; then
        echo "指定 umask 值，设置目录及内容的权限" >&2
        echo "用法: chperm <目录路径> [umask值，默认为 002，即 目录是 775，文件是 664]" >&2
        return 1
    fi

    local target_dir="$1"
    local umask_value="${2:-002}"

    # 计算权限
    local dir_perm=$(printf "%o" $((0777 - 0$umask_value)))
    local file_perm=$(printf "%o" $((0666 - 0$umask_value)))

    echo "应用 umask $umask_value: 目录=$dir_perm, 文件=$file_perm" >&2

    find "$target_dir" -type d -exec chmod $dir_perm {} + -o -type f -exec chmod $file_perm {} +

    if [ $? -ne 0 ]; then
        echo -e "\n    设置权限失败，请尝试提权执行: find $target_dir -type d -exec chmod $dir_perm {} + -o -type f -exec chmod $file_perm {} +" >&2
        return 1
    fi
}

# cp -a：此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容。其作用等于dpR参数组合。
cpbak() {
    # find . -max-depth 1 -name '$1*' -exec cp "{}" "{}.bak" \;
    #cp -a $1{,.bak}
    local DT=$(date  +"%Y-%m-%d_%H:%M:%S")
    echo "[复制一个备份 $1.bak.${DT}，如果是目录名不要传入后缀/]" >&2
    cp -a "$1" "$1.bak.${DT}"

    if [ $? -ne 0 ]; then
        printf '\n    备份失败，请尝试提权执行: sudo cp -a "%s" "%s.bak.%s"\n' "$1" "$1" "$DT"
    fi
}

# wsl 或 git bash 下快捷进入从Windows复制过来的绝对路径，注意要在路径前后添加双引号，如：cdw "C:\Windows\Path"
cdw() {
    echo "[进入 Windows 路径，路径前后要加双引号，如：cdw \"C:\\Windows\\Path\"]"
    cd "/$(echo ${1//\\/\/} | cut -d: -f1 | tr -t [A-Z] [a-z])$(echo ${1//\\/\/} | cut -d: -f2)"
}

# 切换桌面模式和命令行模式 --- 使用 systemd 控制引导的系统都可以这么做
swc() {
    if [[ ! ($os_type == 'linux' || $os_type == 'raspi') ]]; then
        return
    fi

    if [[ "$XDG_SESSION_TYPE" = 'tty' ]]; then
        read -p "Switch to graphical mode? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            printf '\033[0;33mWARN\033[0m: Starting Desktop, launching login screen...\n'
            sudo systemctl isolate graphical.target
        fi
    else
        read -p "Switch to text mode? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            printf '\033[0;33mWARN\033[0m: Shut down desktop and return to tty...'
            sleep 1
            sudo systemctl isolate multi-user.target
        fi
    fi
}

# bat 显示文件支持语法高亮，在 Debian 系可执行命令居然是 batcat
if command -v batcat >/dev/null 2>&1; then
    alias bat='batcat'
    # bat 作为 man 的彩色分页器
    export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | batcat -p -lman'"
elif command -v bat >/dev/null 2>&1; then
    export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
fi

# man
alias mans='echo "[在man手册页的描述中搜索关键字]" >&2; man -k'

# chrony
alias chronys='echo "[虚拟机跟宿主机对时]" >&2; sudo chronyc makestep'

alias viw='echo "[vi 后悔药：等保存了才发现是只读，运行以下命令]" >&2; echo ":w !sudo tee %"'

alias myip='echo "[浏览器打开 https://test.ustc.edu.cn/ 可看到自己的ip和测速]" >&2; curl ipv4.icanhazip.com 2>/dev/null;curl ipv6.icanhazip.com 2>/dev/null'

# 命令行查天气
# 支持任意Unicode字符指定任何的地址 curl http://wttr.in/~大明湖
#  https://wttr.in/:help 看月相 curl http://wttr.in/moon
weather() { curl -s --connect-timeout 3 -m 5 "http://wttr.in/$1"; }

# ssh
alias sshs='echo "[跳过其它各种协商使用密码连接主机]" >&2; ssh -o "PreferredAuthentications password"'
alias sshme='echo "[断开ssh连接复用]" >&2; ssh -O exit'
alias sshmn='echo "[不使用ssh连接复用]" >&2; ssh -o "ControlPath=no"'
alias sshk='echo "[使用kitty连接无terminfo的sshd服务器]" >&2; kitty +kitten ssh'

# curl
alias curls='echo "[curl http-get  不显示服务器返回的错误内容，静默信息不显示进度条，但错误信息打印到屏幕，跟踪重定向，可加 -O 保存到默认文件]" >&2; curl -fsSL'
alias curld='echo "[curl http-post 不显示服务器返回的错误内容，静默信息不显示进度条，但错误信息打印到屏幕]" >&2; curl -fsSd'

# nmap
alias nmaps='echo "[nmap 指定端口提供了什么类型的服务]" >&2; nmap -sV -p'
alias nmapl='echo "[nmap 列出当前局域网 192.168.0.x 内的ip及端口]" >&2; nmap 192.168.0.0/24'

# scp rsync
alias scps='echo "[scp 源 目的网络。远程格式 user@host:/path/to/ 端口用 -P]" >&2; scp -r'
alias rsyncs='echo "[rsync 保留文件扩展属性保持硬链接保持稀疏文件：源 目的 ]" >&2; rsync -avAXHS'
alias rsyncl='echo "[低io优先级运行 rsync 保留文件属性：源 目的]" >&2; sudo ionice -c 2 -n 5 rsync -av --progress --stats --bwlimit=50000'
alias rsyncr='echo "[rsync 源 目的网络。远程格式 user@host:/path/to/]" >&2; rsync -av --progress --stats -e "ssh -p 22" '
alias rsyncrb='echo "[rsync 源 目的慢速网络。远程格式 user@host:/path/to/]" >&2; rsync -av --progress --stats --partial --partial-dir=.rsync-partial --timeout=30 --bwlimit=5000 -e "ssh -p 22 -o ServerAliveInterval=15 -o ConnectTimeout=20" '

# dd
alias ddp='echo "[给dd发信号显示进度信息]" >&2; sudo watch -n 5 killall -USR1 dd'

# du
alias dus='echo "[降序列出各个文件的大小]" >&2; find . -type f -exec du -b {} + | sort -n -r | numfmt --to=iec'
alias dud='echo "[降序列出各个子目录的大小]" >&2; du -hd1 . 2>/dev/null | sort -h -r'
duh() {
    local target=${1:-.}
    echo "[列出 $target 空间占用最大的前 10 个文件或目录(MB)]"
    # sudo du -sb "$target"/* "$target"/.* 2>/dev/null | sort -n -r | numfmt --to=iec | head -10
    sudo find "$target" -maxdepth 1 \( -type f -o -type d \) -print0 2>/dev/null \
      | xargs -0 du -sb 2>/dev/null \
      | sort -n -r | numfmt --to=iec | head -10
}

# udisksctl
alias udj='echo "[弹出 U 盘]" >&2; sync; udisksctl power-off -b'

# mount 使用当前用户权限挂载 Windows 分区 U 盘，用于防止默认参数使用 root 用户权限不方便当前用户读写
mntfat() {
    echo "[挂载 FAT 文件系统的分区设备 $1 到目录 $2，使用当前用户权限]"
    local _uid=$(id -u $USER)
    local _gid=$(id -g $USER)
    sudo mount -t vfat -o rw,nosuid,nodev,noatime,uid=$_uid,gid=$_gid,umask=0000,codepage=437,iocharset=ascii,shortname=mixed,showexec,utf8,flush,errors=remount-ro "$1" "$2"
}
mntntfs() {
    echo "[挂载 NTFS 文件系统的分区设备 $1 到目录 $2，使用当前用户权限]"
    local _uid=$(id -u $USER)
    local _gid=$(id -g $USER)
    sudo mount -t ntfs3 -o rw,nosuid,nodev,noatime,uid=$_uid,gid=$_gid,windows_names,iocharset=utf8 "$1" "$2"
}
mntexfat() {
    echo "[挂载 exFAT 文件系统的分区设备 $1 到目录 $2，使用当前用户权限]"
    local _uid=$(id -u $USER)
    local _gid=$(id -g $USER)
    sudo mount -t exfat -o rw,nosuid,nodev,noatime,uid=$_uid,gid=$_gid,fmask=0022,dmask=0022,iocharset=utf8,errors=remount-ro "$1" "$2"
}
mntram() {
    echo "[映射内存目录 $1，用完了记得要解除挂载：sync; sudo umount $1]"
    sudo mount --mkdir -t ramfs ramfs "$1" && sudo chown $(id -u):$(id -g) "$1"
}
mntsmb() {
    echo "[挂载samba目录 $1 到本地目录 $2，用户名为 $3]"
    sudo mount -t cifs -o user="$3" "$1" "$2"
}
mntnfs() {
    echo "[挂载nfs目录 $1 到本地目录 $2，不许其内的 dev 再挂载]"
    sudo mount -t nfs -o vers=4,nodev,noatime "$1" "$2"
}

# 显示16进制内容及对应的ascii字符
alias hexdumps='hexdump -C'

# 生成二维码
alias qrens='qrencode -t ANSIUTF8'

# 生成密码
alias passs='echo "[生成16个字符的强密码]" >&2; cat /dev/random |tr -dc "!@#$%^&*()-+=0-9a-zA-Z" | head -c16'
alias passr='printf "[16 个随机字符作为密码]\n\n" >&2; cat /dev/urandom | tr -dc "a-zA-Z0-9" | head -c 16; echo'
passf() {
    # 256 随机字节作为密钥文件，过滤了换行符
    # passf > key.bin          # 保存为文件
    # passf | base64           # 输出base64
    # passf | xxd -p           # 输出十六进制
    cat /dev/random | tr -d "\n" | head -c 256
}

# 桌面环境下执行命令行程序，对需要保护的凭证如密钥、密码等，不要用环境变量，尽量用钥匙圈 keyring/keychain
# 1. 存储到钥匙圈
# 2. 运行时从钥匙圈读取
# 示例：
#    # 存储时不会留下历史痕迹
#    $ token_put my-token
#    请输入 'my-token' 对应的凭证（不会回显）: █
#
#    # 获取时作为命令替换，仅在使用瞬间挂载
#    $ curl -H "Authorization: Bearer $(token_get my-token)" https://api.example.com

# 静默读入密码，避免被 shell 历史记录或 ps 窥探
token_put() {
    local name="$1"
    if [[ -z "$name" ]]; then
        echo >&2 "用法: token_put <名称>     # 会提示输入密码"
        return 1
    fi

    local token
    printf "请输入 '%s' 对应的凭证（不会回显）: " "$name"
    read -rs token
    echo >&2

    if [[ -z "$token" ]]; then
        echo >&2 "未输入任何内容，操作取消。"
        return 1
    fi

    # --- macOS ---
    if [[ $os_type = 'macos' ]]; then
        # -U : 如果已存在则更新，-T : 只允许 /usr/bin/security 访问（避免弹窗）
        security add-generic-password -T /usr/bin/security \
          -U -a "$USER" -s "$name" -w "$token" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            echo >&2 "✓ 已存入 macOS Keychain (account=$USER, service=$name)"
        else
            echo >&2 "✗ 存入 macOS Keychain 失败"
            return 1
        fi

    # --- Linux GNOME ---
    elif [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && command -v secret-tool >/dev/null 2>&1; then
        echo -n "$token" | secret-tool store --label="token $name" service "$name" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            echo >&2 "✓ 已存入 GNOME Keyring (service=$name)"
        else
            echo >&2 "✗ 存入 GNOME Keyring 失败"
            return 1
        fi

    # --- Linux KDE ---
    elif [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]] && command -v kwallet-query >/dev/null 2>&1; then
        # 若文件夹不存在会自动创建
        echo -n "$token" | QT_QPA_PLATFORM=offscreen kwallet-query -w kdewallet -f tokens -e "$name" -p 2>/dev/null
        if [[ $? -eq 0 ]]; then
            echo >&2 "✓ 已存入 KDE Wallet (wallet=kdewallet, folder=tokens, entry=$name)"
        else
            echo >&2 "✗ 存入 KDE Wallet 失败（钱包是否已打开？）"
            return 1
        fi

    else
        echo >&2 "✗ 未检测到可用的 keyring 后端（需要 macOS Keychain / GNOME Keyring / KDE Wallet）"
        return 1
    fi
}

token_get() {
    local name="$1"
    if [[ -z "$name" ]]; then
        echo >&2 "用法: token_get <名称>"
        return 1
    fi

    # --- macOS ---
    if [[ $os_type = 'macos' ]]; then
        security find-generic-password -a "$USER" -s "$name" -w 2>/dev/null

    # --- Linux GNOME ---
    elif [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && command -v secret-tool >/dev/null 2>&1; then
            secret-tool lookup service "$name" 2>/dev/null

    # --- Linux KDE ---
    elif [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]] && command -v kwallet-query >/dev/null 2>&1; then
        QT_QPA_PLATFORM=offscreen kwallet-query -r -w kdewallet -f tokens -e "$name" 2>/dev/null

    else
        echo >&2 "未检测到可用的 keyring 后端"
        return 1
    fi
}

# sha256sum
alias shasums='echo "[sha256sum 按校验和文件逐个校验，跳过缺失文件告警]" >&2; sha256sum --ignore-missing -c'
shasumf() {
    # `shasumc abc.iso SHA256SUMS.txt`
    echo "[sha256sum，只下载了一个文件 $1，从校验和文件 $2 中抽出单个文件进行校验]"
    sha256sum -c <(grep $1 $2)
}
shasumd() {
    echo "[sha256sum 对目录 $1 下的所有文件及子目录文件生成一个校验和文件 $2]"
    find "$1" -type f -print0 | while IFS= read -r -d '' fname; do
        printf '%s\n' "$fname"
        sha256sum "$fname" >>"$2"
    done
}

# 看日志
alias dmesgs='echo "[分屏显示内核信息带颜色提示]" >&2; sudo dmesg --color=always | less -R'
alias audk='echo "[持续显示内核信息]" >&2; sudo dmesg -w -T'
alias auds='echo "[持续显示系统日志中 systemd-journald 分类信息]" >&2; sudo journalctl -f'
alias audj='echo "[持续显示系统日志中人性化可读审计信息-精简文本]" >&2; sudo tail -f /var/log/audit/audit.log |sudo ausearch --format text'
alias audkb='echo "[列出所有启动记录]" >&2; journalctl --list-boots; echo "[显示操作系统上次启动时的内核信息]" >&2; journalctl -k -b -1'

# systemd
alias stmu='echo "[systemd 列出当前系统的单元，可 grep]" >&2; systemctl list-units --no-pager'
alias stmur='echo "[systemd 列出当前系统正在运行的单元，可 grep]" >&2; systemctl list-units --state=running --no-pager'
alias stmud='echo "[systemd 查看单元的依赖关系]" >&2; systemctl list-dependencies '
alias stmuf='echo "[systemd 列出当前系统开机自启动的单元文件]" >&2; systemctl list-unit-files --state enabled --no-pager'
alias stme='echo "[systemd 直接编辑服务的单元配置文件]" >&2; sudo env SYSTEMD_EDITOR=vi systemctl edit --force --full '
alias stmr='echo "[systemd 重载单元文件]" >&2; sudo systemctl daemon-reload'
alias stmav='echo "[systemd 验证单元文件]" >&2; systemd-analyze verify '
alias stmab='echo "[systemd 分析计算机启动耗时]" >&2; systemd-analyze blame'

# lvm
alias lvvlvs='echo "[lvm显示lv详情]" >&2; sudo lvs -a -o+integritymismatches -o+devices -o+segtype'

# SELinux
alias sexs='echo "[SELinux 当前状态]" >&2; getenforce'
alias sext='echo "[临时关闭或打开 SELinux]" >&2; sudo setenforce'
alias sexr='echo "[SELinux 恢复目录的默认权限设置]" >&2; sudo restorecon -R -v'
alias sexlc='echo "[列出当前的 SELinux 上下文]" >&2; sudo semanage fcontext -l'
alias sexlp='echo "[列出当前的 SELinux 端口]" >&2; sudo semanage port -l'
alias sexlb='echo "[列出当前的 SELinux 开关]" >&2; sudo semanage boolean -l'

# git 常用命令
alias gts='git status'
alias gtcs='echo "[git给最近的提交签名]" >&2; git commit --amend -S --no-edit'
alias gtw='echo "[修复Windows下显示Linux下拷贝过来的代码文件权限差异]" >&2; git config core.fileMode false'
alias gtd='echo "[差异：工作区与暂存区]" >&2; git diff'
alias gtds='echo "[差异：暂存区与仓库]" >&2; git diff --staged'
alias gtdh='echo "[差异：工作区与仓库]" >&2; git diff HEAD'
alias gtdh2='echo "[差异：最近的两次提交记录]" >&2; git diff HEAD~ HEAD'
alias gtlog='echo "[提交记录：树形]" >&2; git log --oneline --graph'
alias gtlb='echo "[提交记录：对比分支，需要给出两分支名，二点三点分隔效果不同]" >&2; git log --left-right --oneline'
alias gtlm='echo "[提交记录：本地远程库对比本地库--master]" >&2; git log --graph --oneline ..origin/master --'
alias gtld='echo "[提交记录：本地远程库对比本地库--dev]" >&2; git log --graph --oneline ..origin/dev --'
alias gtba='echo "[分支：全部分支及跟踪关系、最近提交及注释]" >&2; git branch -avv'
alias gtro='echo "[远程信息]" >&2; git remote show origin'
alias gtr3='echo "[git编辑最近3条历史提交]" >&2; git rebase -i HEAD~3'
alias gtcd3='echo  "[精简diff3信息]" >&2; sed -n "/||||||| merged common ancestor/,/>>>>>>> Temporary merge branch/!p"'
alias gtpull='echo "[github 经常断连，自动重试 pull 直至成功]" >&2; while ! git pull --rebase; do printf "[Retry pull...]\n\n"; sleep 1; done'
alias gtpush='echo "[github 经常断连，自动重试 push 直至成功]" >&2; while ! git push; do printf "[Retry push...]\n\n"; sleep 1; done'
gtaddr() {
    echo "[把 github.com 的 https 地址转为 git@ 地址，方便鉴权登录github]"
    echo ${1//https:\/\/github.com\//git@github.com:}
}
ghaddr() {
    # [无法访问 github 的解决方案](git_usage)
    echo "[更新本地 hosts 文件的 github.com 地址]"
    local tfile=$(mktemp)

    # 备选 https://raw.githubusercontent.com/521xueweihan/GitHub520/refs/heads/main/hosts
    curlgh https://raw.githubusercontent.com/maxiaof/github-hosts/master/hosts > "$tfile" || rm -f "$tfile"

    if [[ ! -s "$tfile" ]]; then
        echo '获取 github 地址列表失败！'
        return 1
    fi

    local REPLY

    printf "确认写入? [y/N]: " >&2
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy] ]]; then
        echo "已取消" >&2
        rm "$tfile"
        return 1
    fi

    if grep 'Github Hosts Start' /etc/hosts >/dev/null 2>&1; then
        sed '/#Github Hosts Start/,/#Github Hosts End/ {
            /#Github Hosts Start/ {
                r '"$tfile"'
                d
            }
            /#Github Hosts End/!d
        }' /etc/hosts |awk '!a[$0]++' |sudo tee /etc/hosts
    else
        cat "$tfile" |sudo tee -a /etc/hosts
    fi

    rm "$tfile"
}

# gpg 常用命令，一般用法都是后跟文件名即可
alias ggk='echo "[查看有私钥的gpg密钥及其子密钥，带指纹和keygrip]" >&2; gpg -K --keyid-format=long --with-subkey-fingerprint --with-keygrip'
alias ggl='echo "[查看密钥的可读性信息pgpdump]" >&2; gpg --list-packets'
alias ggsb='echo "[签名，生成二进制.gpg签名文件，默认选择当前可用的私钥签名，可用 -u 指定]" >&2; gpg --sign'
alias ggst='echo "[签名，生成文本.asc签名文件，默认选择当前可用的私钥签名，可用 -u 指定]" >&2; gpg --clearsign'
alias ggsdb='echo "[分离式签名，生成二进制.sig签名文件，默认选择当前可用的私钥签名，可用 -u 指定]" >&2; gpg --detach-sign'
alias ggsdt='echo "[分离式签名，生成文本.asc签名文件，默认选择当前可用的私钥签名，可用 -u 指定]" >&2; gpg --armor --detach-sign'
alias ggf='echo "[查看公钥的指纹以便跟跟网站发布的核对]" >&2; gpg --with-fingerprint --show-keys --keyid-format=long'
ggkd() {
    echo "[从公钥服务器下载指定公钥到本地 $1.gpg]"
    gpg --keyserver hkps://keys.openpgp.org --no-default-keyring --keyring ./$1.gpg --recv-keys
}
alias ggvs='echo "[使用临时钥匙圈验证文件签名，如 ggvs ./fedora.gpg xxx.sign xxx.zip 或 ggvs ./fedora.gpg xxx.CHECHSUM]" >&2; gpgv --keyring'
alias ggv='echo "[验证签名]" >&2; gpg --verify'
alias gges='echo "[非对称算法加密并签名，参数太多，只给出提示]" >&2; echo "gpg -s -u 'sender@xxx.com' -r 'reciver@xxx.com' -e msg.txt"'
alias ggcs='echo "[对称算法加密，默认选择当前可用的私钥签名，可用 -u 指定，默认生成的.gpg文件。]" >&2; gpg -s --cipher-algo AES-256 -c'
# 解密并验签，需要给出文件名或从管道流入，默认输出到屏幕
alias ggd='gpg -d'
alias ggaq='echo "[退出 gpg-agent 代理]" >&2; gpg-connect-agent killagent /bye'
ggkupd() {
    echo "更新 gpg 钥匙圈需要点时间，请稍等..."
    gpg --refresh-keys

    echo "更新 gpg TrustDB, 跳过 owner-trust 未定义的导入公钥..."
    gpg --check-trustdb

    echo ''
    echo "检查 gpg 签名..."
    gpg --check-sigs
}
# openssl 常用命令
# 对称算法加密，如 `echo abc |ssle` 输出到屏幕， `ssle -in 1.txt -out 1.txt.asc` 操作文件，加 -kfile 指定密钥文件
alias ssle='openssl enc -e -aes-256-cbc -md sha512 -pbkdf2 -iter 9876543 -salt'
# 对称算法解密，如 `cat 1.txt.asc |ssld` 输出到屏幕，`ssld -in 1.txt.asc -out 1.txt`操作文件，加 -kfile 指定密钥文件
alias ssld='openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 9876543 -salt'

# dnf
alias dnfp='echo "[dnf搜索包含指定命令的软件包]" >&2; dnf provides'
alias dnfql='echo "[dnf查看软件包的内容]" >&2; rpm -ql'
alias dnfqi='echo "[dnf查找指定的软件包在哪些存储库]" >&2; dnf repoquery -i'
alias dnfqr='echo "[dnf查看软件包依赖]" >&2; dnf repoquery --requires'
alias dnfr='echo "[dnf查看当前有哪些存储库]" >&2; dnf repolist'
alias dnfrl='echo "[dnf查看存储库软件列表]" >&2; dnf list --repo'
alias dnfl='echo "[dnf查看已经安装的软件]" >&2; dnf list --installed'
alias dnft='echo "[在toolbox里运行dnf]" >&2; toolbox run dnf'

# pip
alias pipi='echo "[pip 跳过缓存更新指定包]" >&2; pip install --upgrade --no-cache-dir'
alias pipu='echo "[pip 更新自己]" >&2; python -m pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple --upgrade pip'

# flatpak
alias fpkr='echo "[flatpak查看当前有哪些存储库]" >&2; flatpak remotes'
alias fpkrl='echo "[flatpak查看存储库软件列表]" >&2; flatpak remote-ls'
alias fpkl='echo "[flatpak查看安装的软件]" >&2; flatpak list --runtime'
alias fpkd='echo "[flatpak卸载软件]" >&2; flatpak uninstall --delete-data'
fpks() {
    echo "[flatpak 搜软件不展示 id 让你没法安装: ${1}]"

    flatpak search $1 |column
}

# 容器化
# Debian 系skopeo命令的版本太旧了，也不想开通 Backports 仓库，直接用容器运行
if [[ $os_type != 'wsl' && -f /etc/debian_version ]]; then
    alias skopeo='docker run --rm \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v $HOME/.docker/config.json:/root/.docker/config.json:ro \
      -v /etc/docker/certs.d:/etc/containers/certs.d:ro \
      -e REGISTRY_AUTH_FILE=/root/.docker/config.json \
      quay.io/skopeo/stable:latest'
fi

# podman
pdms() {
    echo "[podman 列出镜像详细信息，需要完整的镜像地址]"
    skopeo inspect --format '{{json .}}' docker://${1} |jq .
}
pdmst() {
    # https://stackoverflow.com/questions/28320134/how-can-i-list-all-tags-for-a-docker-image-on-a-remote-registry
    # echo "[podman 搜索列出镜像标签，非官方镜像需要完整的源地址]"
    # podman search --list-tags --limit=5000 $1
    echo "[podman 列出镜像的标签，需要完整的镜像地址]"
    skopeo list-tags docker://${1}
}
pdmsd() {
    echo "[podman 列出镜像的摘要，需要完整的镜像地址]"
    skopeo inspect --format "{{.Digest}}" docker://${1}
}
alias pdmc='echo "[podman简单运行一个容器]" >&2; podman run -it --rm -P'
alias pdmexec='echo "[podman在运行的容器名里执行shell命令]" >&2; podman exec'
pdmtty() {
    echo "[登录到容器 $1 内的tty]"
    podman exec -it $1 sh
}
alias pdmip='echo "[podman列出所有容器的ip和开放端口(rootless容器无ip地址)]" >&2; podman inspect -f="{{.Name}} {{.NetworkSettings.IPAddress}} {{.HostConfig.PortBindings}}" $(podman ps -aq)'
alias pdmlog='echo "[podman查看指定容器日志]" >&2; podman logs -f --tail 100'
alias pdmdf='echo "[podman查看资源情况]" >&2; podman system df -v'
pdmv() {
    for c in $(podman ps -a --format="{{.Names}}"); do
        echo "容器 '$c' 使用了卷：$(podman inspect $c --format='{{range .Mounts}}{{.Name}} {{end}}' )"
    done
}
# 操作私有容器仓库
alias pdmr='echo "[podman 列出私有仓库 ${PDMREPO} 的所有镜像]" >&2; curl -s http://${PDMREPO}/v2/_catalog | jq'
pdmrl() {
  echo "[podman 列出私有仓库 ${PDMREPO} 的全部镜像及标签]"
  local repo

  curl -s http://${PDMREPO}/v2/_catalog |
  jq -r '.repositories[]' |
  while read -r repo; do
    echo "$repo"
    skopeo list-tags --tls-verify=false \
      "docker://${PDMREPO}/${repo}" |
    jq -r '.Tags[]' |
    sed 's/^/   标签: /'
    echo
  done
}
pdmrs() {
    local img=$(echo $1  |cut -d: -f1)
    local tag=$(echo $1  |cut -d: -f2)
    echo "[podman 显示私有仓库 ${PDMREPO} 镜像名 ${img} 标签 ${tag} 的 manifests]"
    curl -s http://${PDMREPO}/v2/${img}/manifests/${tag}
}
pdmrm() {
    local img=$(echo $1 |cut -d: -f1)
    local tag=$(basename $1 |cut -d: -f2)
    local sha=$2
    echo "[podman 删除私有仓库的镜像 ${PDMREPO}/$img:$tag，sha256摘要: ${sha}]"
    curl -v -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' -X DELETE http://${PDMREPO}/v2/${img}/manifests/sha256:${sha}
    echo "注意：登录仓库的 tty 运行垃圾收集(GC)才能真正的释放磁盘空间"
}
pdmrcpd() {
    echo "[podman 从本地 docker 仓库推送到私有仓库]"
    skopeo copy docker-daemon:${1} docker://${PDMREPO}/${2}
}
pdmrcpp() {
    echo "[podman 从本地 podman 仓库推送到私有仓库]"
    skopeo copy containers-storage:${1} docker://${PDMREPO}/${2}
}

# distrobox 这词打不快
alias dbox='distrobox'
alias dboxe='echo "[在distrobox里运行一个命令]" >&2; distrobox-enter --'
dboxstop() {
    echo "Stop all distrobox container:"
    #local container_name=$(distrobox-list --no-color |sed 1d |cut -d '|' -f 2)
    #for cname in "${container_name[@]}"
    #do
    #    distrobox-stop --yes $cname
    #done
    distrobox-list --no-color |sed 1d |cut -d '|' -f 2 |while read boxname
    do
        distrobox-stop --yes $boxname
    done
}

# Hermes Agent
alias hersd='echo "[Hermes Agent清理所有会话]" >&2; hermes sessions list | awk "NR>2 {print $NF}" | xargs -I {} hermes sessions delete {} -y'

# Windows git bash
# 使 mintty 下执行普通的 Windows 控制台程序，用 winpty 辅助可以正常显示
# 如果你的终端软件开启了 ConPTY=on 选项则不需要这个辅助，暂无法在脚本中判断。
# 适用于 Windows git bash(mintty.exe) 等 Windows 下的终端软件
if [[ $os_type = 'windows' ]] && ! grep '^ConPTY=on' ~/.minttyrc >/dev/null 2>&1; then
    alias python="winpty python"
    alias ipython="winpty ipython"
    alias mysql="winpty mysql"
    alias psql="winpty psql"
    alias redis-cli="winpty redis-cli"
    alias node="winpty node"
    alias vue='winpty vue'

    # 其实 Windows 的 cmd 字符程序都可以在 bash 下用 winpty 来调用
    # 在这里做 alias 就可以
    alias ping='winpty ping'
fi

# 删除 macOS 制造的垃圾文件 ._xxx 和 .Dstore
rmjunk() {
    find . -type f \( -name ".DS_Store" -o -name "._*" \) -size -10k -print 2>/dev/null

    echo ""
    echo "===================================="
    echo "以上文件将被删除，确认继续吗？"
    echo -n "输入 y 确认删除，输入其他任意键取消: "
    read confirm

    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        find . -type f \( -name ".DS_Store" -o -name "._*" \) -size -10k -delete 2>/dev/null
        echo "✅ 已全部删除"
    else
        echo "❌ 已取消，未删除任何文件"
    fi
}

# macOS
if [[ $os_type = 'macos' ]]; then
    alias arch86='echo "[快捷执行 x86 架构命令]" >&2; arch -x86_64 '
    alias archs='echo "[进入 x86 架构的子shell]" >&2; arch -x86_64 zsh'
    # 快捷执行 x86 架构 brew
    alias ibrew='arch -x86_64 /usr/local/bin/brew'
    # 下载的文件或自编译的程序默认会添加隔离属性导致拒绝打开，需要手动去除这个属性
    alias xattrs='echo "[清除指定文件的隔离属性]" >&2; xattr -cr '
fi

##############################################
# 四、双行彩色命令行提示符，显示当前路径、git分支、python环境名等
# 适用于 Linux bash / Windows git bash(mintty)
#
# 效果示例：
#
#  ╭─[13:18:18 user@MY-PC::~/yourproject](conda:p37) git:<?>master|MERGING
#  ╰──$ uname -a
#  MSYS_NT-10.0-19044 MY-PC 3.3.5-341.x86_64 2022-11-08 19:41 UTC x86_64 Msys

# 1、先定义各种辅助变量和函数

# ANSI 标准
# 色彩      黑    红    绿    黄    蓝    洋红    青    白
# 前景色    30    31    32    33   34    35    36    37
# 背景色    40    41    42    43   44    45    46    47
ccBLACK='\[\e[0;30m\]'
ccRED='\[\e[0;31m\]'
ccGREEN='\[\e[0;32m\]'
ccYELLOW='\[\e[0;33m\]'
ccBLUE='\[\e[0;34m\]'
ccMAGENTA='\[\e[0;35m\]'
ccCYAN='\[\e[0;36m\]'
ccWHITE='\[\e[0;37m\]'
ccNORMAL='\[\e[m\]'

# 注意：判断用户在命令行执行命令返回值的函数 PS1exit_code 要放在放在 PS1 变量赋值语句的最前面，
# 或者它前面的函数要实现 $? 变量的透传，否则成了判断前面子函数的命令的返回值了
#   { ret_code="$?"; your code...; return ret_code}
PS1exit_code() {
    local exitcode="$?"
    #if [ $exitcode -eq 0 ]; then printf "%s" ''; else printf "%s" ' -'$exitcode' '; fi
    #(($exitcode != 0)) && printf "%s" ' -'$exitcode' '
    [[ ! $exitcode = 0 ]] && printf "%s" ' -'$exitcode' '
}

PS1conda_env_name() {
    # Linux 下安装 Anaconda 需要执行一次如下命令，才能在 bash 中使用 conda 命令
    #   `conda init bash`
    # 会自动在 ~/.bashrc 或 .bash_profile 文件添加如下内容：
    #   eval "$(/home/uu/anaconda3/bin/conda shell.bash hook)"

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
PS1virtualenv_envname() {
    [[ -n $VIRTUAL_ENV ]] && printf "(venv:%s)" $(basename $VIRTUAL_ENV)
}

PS1git_branch_name() {

    if ! command -v git >/dev/null 2>&1; then
        return
    fi

    # 优先使用 __git_ps1() 取分支名信息，如果取到有效的 git 信息，就直接打印出来，然后退出函数
    #
    #   如果使用git for Windows自带的mintty bash，它自带git状态脚本(貌似Debian系的bash都有)
    #   只要启动bash ，其会自动 source C:\Program Files\Git\etc\profile.d\git-prompt.sh，
    #   最终 source C:\Program Files\Git\mingw64\share\git\completion\git-prompt.sh。
    #   这样实现了用户 cd 到git管理的目录就会显示git状态字符串。
    #   来源 https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
    #   如果自定义命令提示符，可以在PS1变量拼接中调用函数 $(__git_ps1 "(%s)") ，
    #   可惜tag和hashid的提示符有点丑，为了显示速度快，忍忍得了
    if command -v __git_ps1 >/dev/null 2>&1; then
        # __git_ps1 居然透传 $?，前面的命令执行结果被它作为返回值了，只能先清一下，后面也不能用它的返回值判断是否执行成功
        # NOTE:如果用 local 声明变量 _pp_git_pt，就无法取到执行语句的返回值了
        _pp_git_pt=$(>/dev/null; __git_ps1 '%s' 2>/dev/null)
        if [ "$?" = "0" ]; then
            # 如果是有效的 git 信息，这里就直接打印并退出函数
            printf "%s" $_pp_git_pt
            unset _pp_git_pt
            return
        fi

        unset _pp_git_pt
    fi

    # __git_ps1 没取到有效信息，则自行获取git信息
    # 一条命令取当前分支名
    # 命令 git symbolic-ref 在裸仓库或 .git 目录中运行不报错，都会打印出当前分支名，
    # 如果当前分支是分离的，返回 1,不在当前分支，返回 128
    # NOTE:如果用 local 声明变量 _pp_branch_name，就无法取到执行语句的返回值了
    _pp_branch_name=$(git symbolic-ref --short -q HEAD 2>/dev/null)
    local exitcode="$?"

    case "$exitcode" in
        '0')
            # 优先显示当前 head 指向的分支名
            printf "%s" $_pp_branch_name
            ;;
        '1')
            # 如果是 detached HEAD，则显示标签名或 commit id
            local headhash="$(git rev-parse HEAD)"
            local tagname="$(git for-each-ref --sort='-committerdate' --format='%(refname) %(objectname) %(*objectname)' |grep -a $headhash |grep 'refs/tags' |awk '{print$1}'|awk -F'/' '{print$3}')"
            # 有标签名就显示标签否则显示 commit id
            if [[ -n "$tagname" ]]; then
                printf "%s" "@${tagname}"
            else
                printf "%s" "#${headhash}"
            fi
            ;;
        *)
            # exitcode 是其它数字的，视为不在 git 环境中，不做任何打印输出
            unset _pp_branch_name
            return
            ;;
    esac

    unset _pp_branch_name
}

PS1git_branch_prompt() {
    local branch=`PS1git_branch_name`

    # branch 变量是空的说明不在 git 环境中，返回即可
    [[ $branch ]] || return

    # 在裸仓库或 .git 目录中，运行 git status 会报错，所以先判断下
    # if ! $(git status >/dev/null 2>&1) ; then
    if [ "$(git rev-parse --is-inside-work-tree)" == 'false' ]; then
        # 如果不在 git 工作区，则不打印分支名，以提醒使用者
        printf " git:!git-dir"

    else
        # git 工作区有变更就显示问号
        # 如果嫌慢可以开启选项，见 https://git-scm.com/docs/git-status#_untracked_files_and_performance
        local notify_flag=$(if ! [ -z "$(git status --porcelain)" ]; then printf "%s" '<?>'; else printf "%s" ''; fi)

        # 拼接后输出 git 工作区状态和分支名
        printf " git:%s%s" $notify_flag $branch
    fi
}

# 显示主机名，用不同颜色提示本地或 ssh 远程登录：本地登录是绿色，远程登录是洋红色
PS1_host_name() {
    local is_remote=false

    # 判断当前是否进入远程ssh会话：
    # 远程会话检测变量 SSH_CLIENT，交互式登录检测变量 SSH_TTY
    # 此方法仅在主机环境或 distrobox 容器中有效
    if [[ -n $SSH_CLIENT ]] || [[ -n $SSH_TTY ]]; then
        is_remote=true
    fi

    # 如果是 FQDN 格式主机名只显示前段，如 abc.local 显示 abc
    local raw_host_name=$(echo ${HOSTNAME%%.*})

    # 在交互式容器中特殊处理，从 HOSTNAME 提取出宿主机的主机名
    if [ -f "/run/.toolboxenv" ] || [ -e /run/.containerenv ]; then
        # 如果是在交互式容器 toolbox 中，现在又改成 toolbx 了
        if [[ $(uname -n) = 'toolbx' ]]; then

            # 变量 HOSTNAME 的值与宿主机一致，但 /etc/hostname 变为 toolbox
            # cat /run/host/etc/hostname | cut -d '.' -f 1

            # 之前，toolbox 容器中只能用下面这个方式判断是否进入远程ssh会话，不是很靠谱
            # [[ $(pstree |grep sshd |grep toolbox |grep podman |grep -v grep >/dev/null 2>&1; echo $?) = "0" ]] && is_remote=true
            # 现在，暂无法获取当前是否处于远程连接的状态，除非把环境变量 SSH_CLIENT 保存到 /tmp 等共享目录进行交换
            :

            # raw_host_name 使用前面设置过的

        # 否则是在交互式容器 distrobox 中
        else
            # distrobox 容器继承了宿主机的环境变量，前面的 is_remote 判断结果可以直接用

            # 之前， distrobox 容器把 HOSTNAME 的值变为：容器名.宿主机的主机名，用 raw_host_name=$(echo ${HOSTNAME##*.}) 取宿主机的主机名
            # 现在， HOSTNAME 的值就是 宿主机的主机名
            :
        fi
    fi

    if [[ $is_remote = true ]]; then
        printf '\033[0;35m%s\033[0m' "$raw_host_name"
    else
        printf '\033[0;32m%s\033[0m' "$raw_host_name"
    fi
}

# 提示当前在 toolbox 或 distrobox 等交互式容器环境，白色容器名配蓝色背景
# https://docs.fedoraproject.org/en-US/fedora-silverblue/tips-and-tricks/#_working_with_toolbx
# https://ublue.it/guide/toolbox/#using-the-hosts-xdg-open-inside-distrobox
# https://github.com/docker/cli/issues/3037
# Windows 下的 wsl 环境，wsl 下的 docker，暂未研究
PS1_container_name() {
    if [ -f "/run/.toolboxenv" ] || [ -e /run/.containerenv ]; then
        # $CONTAINER_ID
        printf '\033[0;44m\U0001f4e6<%s>' $(cat /run/.containerenv | grep -oP "(?<=name=\")[^\";]+")
    elif  [ -e /.dockerenv ]; then
        printf '\033[0;44m\U0001f4e6<%s>' $(cat /run/.dockerenv | grep -oP "(?<=name=\")[^\";]+")
    fi
}

# Windows git bash(mintty) 设置命令行提示符 PS1
# 在上面的基础上修改了个兼容性函数，因为 目前 git bash(mintty) 有点bug：
#   在\$(函数名)后直接用换行\n就冲突
# 规避办法
#   法1. 把换行\n放在引用函数前面
#   法2. 重新拼接成新样式避开这个bug: PS1="\n$ccBLUE┌──── $ccWHITE\t ""$PS1""$ccBLUE───┘ $ccNORMAL"
#   法3. 完美的解决办法：新增子函数 PS1gitbash_newline 实现跟上面完全一致的显示效果。
PS1gitbash_newline() {
    printf "\n╰"
}

# Linux bash - raspberry pi os (debian)
# raspberry pi 的状态检测
# 告警条件：
#   CPU 温度的单位是千分位提权 1000
#   系统 throttled 不是零
#   CPU Load Average 的值应该小于CPU核数的70%，取1分钟平均负载
PS1raspi_warn_info() {

    # [[ $(command -v vcgencmd >/dev/null 2>&1; echo $?) = "0" ]] || return
    # command -v vcgencmd >/dev/null 2>&1 || return
    [[ $os_type = 'raspi' ]] || return

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

PS1raspi_warn_prompt() {
    local raspi_warning=`PS1raspi_warn_info`
    if [ -n "$raspi_warning" ]; then
        printf "====%s====" "$raspi_warning"
    fi
}

# 2、终于可以设置双行彩色命令行提示符 PS1 了
if [[ $current_shell = 'zsh' ]]; then
    # zsh 有自己的 powerlevel10k 设置命令行提示符
    :

elif [[ $os_type = 'windows' ]]; then
    # Windows git bash 命令行提示符显示：返回值 \t当前时间 \u用户名 \h主机名 \w当前路径 python环境 git分支及状态
    PS1="\n${ccBLUE}╭─$ccRED\$(PS1exit_code)$ccBLUE[$ccWHITE\t $ccGREEN\u$ccWHITE@\$(PS1_host_name)$ccWHITE:$ccCYAN\w$ccBLUE]$ccYELLOW\$(PS1conda_env_name)\$(PS1virtualenv_envname)\$(PS1git_branch_prompt)${ccBLUE}$(PS1gitbash_newline)──$ccWHITE\$ $ccNORMAL"

elif [[ $os_type = 'wsl' ]]; then
    # Windows wsl 命令行提示符显示：返回值 \t当前时间 \u用户名 \h主机名 \w当前路径 python环境 git分支及状态
    PS1="\n${ccBLUE}╭─$ccRED\$(PS1exit_code)$ccBLUE[$ccWHITE\t $ccGREEN\u$ccYELLOW@WSL_\$(PS1_host_name)\$(PS1_container_name)$ccWHITE:$ccCYAN\w$ccBLUE]$ccYELLOW\$(PS1conda_env_name)\$(PS1virtualenv_envname)\$(PS1git_branch_prompt)\n${ccBLUE}╰─$ccWHITE\$ $ccNORMAL"

elif  [[ $os_type = 'raspi' ]]; then
    # Raspberry OS bash 命令行提示符显示：返回值 \t当前时间 \u用户名 \h主机名<toolbox容器名> \w当前路径 树莓派温度告警 python环境 git分支及状态
    PS1="\n${ccBLUE}┌─$ccRED\$(PS1exit_code)$ccBLUE[$ccWHITE\t $ccGREEN\u$ccWHITE@\$(PS1_host_name)\$(PS1_container_name)$ccWHITE:$ccCYAN\w$ccBLUE]$ccRED\$(PS1raspi_warn_prompt)$ccYELLOW\$(PS1conda_env_name)\$(PS1virtualenv_envname)\$(PS1git_branch_prompt)\n${ccBLUE}└──$ccWHITE\$ $ccNORMAL"

else
    # 通用 Linux bash 命令行提示符显示：返回值 \t当前时间 \u用户名 \h主机名<toolbox容器名> \w当前路径 python环境 git分支及状态
    PS1="\n${ccBLUE}┌─$ccRED\$(PS1exit_code)$ccBLUE[$ccWHITE\t $ccGREEN\u$ccWHITE@\$(PS1_host_name)\$(PS1_container_name)$ccWHITE:$ccCYAN\w$ccBLUE]$ccYELLOW\$(PS1conda_env_name)\$(PS1virtualenv_envname)\$(PS1git_branch_prompt)\n${ccBLUE}└──$ccWHITE\$ $ccNORMAL"

fi

##############################################
# 退出前清理无用的变量定义

unset current_shell
unset os_type
unset gsversion
