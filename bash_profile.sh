##################################################################################################################
# 适用于 Linux bash、Windows git bash(mintty)，Mac OS 未测试
# 本该放到 .bashrc 文件，为了方便统一在此了，可放到 .zshrc 中保持自己的使用习惯
#
# 别人的配置文件参考大全
#   https://github.com/pseudoyu/dotfiles
#   https://www.pseudoyu.com/zh/2022/07/10/my_config_and_beautify_solution_of_macos_terminal/

####################################################################
# 此部分作为普通脚本的默认头部内容，便于调测运行。
#
# declare -p PS1 打印指定变量的定义
# set 显示当前所有内置变量和函数定义
#
# -x ： 在执行每一个命令之前把经过变量展开之后的命令打印出来。
# -e ： 遇到一个命令失败（返回码非零）时，立即退出。
# -u ：试图使用未定义的变量，就立即退出。
# -o pipefail ： 只要管道中的一个子命令失败，整个管道命令就失败，这样可以捕获到其退出代码
#set -xeuo pipefail
# trap "rm -f $temp_file" 0 2 3 15  # `trap -l` for all useble signal
# 意外退出时杀掉所有子进程
# trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

###################################################################
# 兼容性设置，用于 .bash_profile 加载多种 Linux 的配置文件，zsh不加载
#   ~/.bashrc: executed by bash(1) for non-login shells.
#       see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples
#   用 $0 取当前shell是否为 -zsh 或 zsh，截取后三位得到 zsh
__cur_shell=$(echo ${0:0-3})
[[ $__cur_shell = 'zsh' ]] || (test -f ~/.bashrc && . ~/.bashrc)

# bash 优先调用 .bash_profile，就不会调用 .profle，该文件是 Debian 等使用的
#   ~/.profile: executed by the command interpreter for login shells.
#     This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.
#     see /usr/share/doc/bash/examples/startup-files for examples.
#     the files are located in the bash-doc package.
# test -f ~/.profile && . ~/.profile
# 这几个标准目录设置到 $PATH，在 Debian 等发行版放在 .profile 里了，这里要补上执行
PATH=$PATH:$HOME/.local/bin:$HOME/bin; export PATH

# exit for non-interactive shell
# [[ ! -t 0 ]] && return
[[ $- != *i* ]] && return

###################################################################
# 自此开始都是自定义设置
#
# 为防止变量名污染命令行环境，尽量使用奇怪点的名称

# 命令行开启vi-mode模式，按esc后用vi中的上下左右键选择历史命令
# zsh 命令行用 `bindkey -v` 来设置 vi 操作模式
if [[ ! $__cur_shell = 'zsh' ]]; then
    set -o vi
fi

# 有些软件默认使用变量 EDITOR 指定的编辑器，一般是 nano，不习惯就换成 vi
export EDITOR=/usr/bin/vi

# 历史记录不记录如下命令 vault* kill，除了用于保护参数带密码命令，还可以精简命令历史，不保存那些不常用的命令
# 一个简单的方法是输入密码的参数使用短划线“-”，然后按 Enter 键。这使您可以在新行中输入密钥。
export HISTIGNORE="&:[ \t]*vault*:[ \t]*kill*"

####################################################################
# 命令行的字符可以显示彩色，依赖这个设置
# 显式设置终端启用256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
export TERM=xterm-256color
export COLORTERM=truecolor

# Debian 下的 distrobox 环境不继承宿主机的 LANG 变量，导致图标字体不能正确显示
[[ -n $LANG ]] || export LANG=en_US.UTF-8

####################################################################
# 参考自 Debian 的 .bashrc 脚本中，常用命令开启彩色选项
# enable color support of ls and also add handy aliases
# 整体仍然受终端模拟器对16种基本颜色的设置控制，也就是说，在终端模拟器中使用颜色方案，配套修改 dir_colors ，让更多的文件类型使用彩色显示
if [ -x /usr/bin/dircolors ]; then

    # 使用 dir_colors 颜色方案-北极，可影响 ls、tree 等命令的颜色风格
    [[ -f ~/.dir_colors ]] || (echo 'Get nord-dircolors from github or gitee...' && curl -fsSLo ~/.dir_colors https://github.com/arcticicestudio/nord-dircolors/raw/develop/src/dir_colors || curl -fsSLo ~/.dir_colors https://gitee.com/mirrors_arcticicestudio/nord-dircolors/raw/develop/src/dir_colors)
    test -r ~/.dir_colors && eval "$(dircolors -b ~/.dir_colors)" || eval "$(dircolors -b)"

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
    alias l='ls -CFA'
    alias ll='ls -lh'
    alias la='ls -lAh'
    alias lsa='ls -A'
    alias lss='ls -lhZ'

    # 其它常用命令的惯用法：

    # 列出目录下的文件清单，查找指定关键字，如 `lsg fnwithstr`。因为ls列出的目录颜色被grep覆盖，用 ls -l 查看更方便。
    alias lsg='ls -lFA |grep -i'
    # 列出当前目录及子目录的文件清单，查找指定关键字，如 `findf fnwithstr`
    alias findf='find ./* |grep -i'
    # 在管道或当前目录下的文件中（排除目录）查找指定关键字，列出文件名和所在行，如 `greps strinfile *`
    alias greps='grep -d skip -in'
    # 在当前目录和子目录下的文件中查找指定关键字，列出文件名和所在行，跳过.git等目录，如 `finds strinfile`
    alias finds='find . \( -name ".git" -o -name "__pycache__" \) -prune -o -print |xargs grep --color=auto -d skip -in'

    alias trees='echo "[目录树，最多2级，显示目录和可执行文件的标识，跳过.git等目录]" && tree -a -CF -I ".git|__pycache__" -L 2'
    alias treeh='echo "[树形列出目录及文件大小]" && tree --du -h'
    alias pstrees='echo "[进程树，列出pid，及全部子进程]" && pstree -p -s'

    function mvf {
        if [ "$#" -ne 1 ]; then
            echo '把子目录下的文件都移动到当前目录 `mvf *.mp4`'
            return 1
        fi

        local fnn=${1}
        # find . -type f -name "*.mp4" -print0 | xargs -0 -I {} sh -c 'echo "$1" /mnt/movies/' _ {}
        find . -type f -name ${fnn} -print0 | xargs -0 -I {} sh -c 'mv "$1" .' _ {}
    }

    # cp -a：此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容。其作用等于dpR参数组合。
    function cpbak {
        # find . -max-depth 1 -name '$1*' -exec cp "{}" "{}.bak" \;
        #cp -a $1{,.bak}
        local DT=$(date  +"%Y-%m-%d_%H:%M:%S")
        echo "[复制一个备份 $1.bak.${DT}，如果是目录名不要传入后缀/]"
        cp -a $1{,.bak.${DT}}
    }

    # wsl 或 git bash 下快捷进入从Windows复制过来的绝对路径，注意要在路径前后添加双引号，如：cdw "C:\Windows\Path"
    function cdw {
        cd "/$(echo ${1//\\/\/} | cut -d: -f1 | tr -t [A-Z] [a-z])$(echo ${1//\\/\/} | cut -d: -f2)"
    }

    # vi 后悔药
    alias viw='echo "[提示：vi 后悔药 --- 等保存了才发现是只读]" && echo ":w !sudo tee %"'

    # 命令行看天气 https://wttr.in/:help
    # https://zhuanlan.zhihu.com/p/40854581 https://zhuanlan.zhihu.com/p/43096471
    # 支持任意Unicode字符指定任何的地址 curl http://wttr.in/~大明湖
    # 看月相 curl http://wttr.in/moon
    function weather {
        curl -s --connect-timeout 3 -m 5 http://wttr.in/$1
    }

    # 切换桌面图形模式和命令行模式 --- systemctl 模式
    function swc {
        [[ $(echo $XDG_SESSION_TYPE) = 'tty' ]] \
            && (echo -e "\033[0;33mWARN\033[0m: Start Desktop, wait until login shows..."; sudo systemctl isolate graphical.target) \
            || (echo -e "\033[0;33mWARN\033[0m: Shut down desktop and return to tty..."; sleep 1; sudo systemctl isolate multi-user.target)
    }

    # man
    alias mans='echo "[模糊查找man手册]" && man -k'

    # chrony
    alias chronys='echo "[虚拟机跟宿主机对时]" && sudo chronyc makestep'

    # ssh
    alias sshs='echo "[跳过其它各种协商使用密码连接主机]" && ssh -o "PreferredAuthentications password"'
    alias sshme='echo "[断开ssh连接复用]" && ssh -O exit'
    alias sshmn='echo "[不使用ssh连接复用]" && ssh -o "ControlPath=no"'

    # curl
    alias curls='echo "[curl http-get 不显示服务器返回的错误内容，静默信息不显示进度条，但错误信息打印到屏幕，跟踪重定向，可加 -O 保存到默认文件]" && curl -fsSL'
    alias curld='echo "[curl http-post 不显示服务器返回的错误内容，静默信息不显示进度条，但错误信息打印到屏幕]" && curl -fsSd'

    # nmap
    alias nmaps='echo "[nmap 列出当前局域网 192.168.0.x 内ip及端口]" && nmap 192.168.0.0/24'

    # scp rsync
    alias scps='echo "[scp 源 目的。远程格式 user@host:/path/to/ 端口用 -P]" && scp -r'
    alias rsyncs='echo "[rsync 源 目的。远程格式 user@host:/path/to/ 端口用 -e 写 ssh 命令]" && rsync -av --progress'

    # dd
    alias ddp='echo "[给dd发信号显示进度信息]" && sudo watch -n 5 killall -USR1 dd'

    # du
    alias dus='echo "[降序列出各个文件的大小(MB)]" && (find . -type f -exec du -sh {} \;)|sort -n -r'
    alias dud='echo "[降序列出各个子目录的大小]" && (find . -type d -exec du -sh {} \;)|sort -n -r'
    function duh {
        #local target='.'
        #[[ -n $1 ]] && target=$1
        local target=${1:-.}
        echo "[列出 $target 空间占用最大的前 10 个文件或目录(MB)]"
        sudo du -am "$target" | sort -n -r |head -n 10
    }

    # udisksctl
    alias udj='echo "[弹出 U 盘]" && sync && udisksctl power-off -b'

    # mount 使用当前用户权限挂载 Windows 分区 U 盘，用于防止默认参数使用 root 用户权限不方便当前用户读写
    function mntfat {
        echo "[挂载 FAT 文件系统的分区设备 $1 到目录 $2，使用当前用户权限]"
        sudo mount -t vfat -o rw,nosuid,nodev,noatime,uid=1000,gid=1000,umask=0000,codepage=437,iocharset=ascii,shortname=mixed,showexec,utf8,flush,errors=remount-ro $1 $2
    }
    function mntexfat {
        echo "[挂载 exFAT 文件系统的分区设备 $1 到目录 $2，使用当前用户权限]"
        sudo mount -t exfat -o rw,nosuid,nodev,noatime,uid=1000,gid=1000,fmask=0022,dmask=0022,iocharset=utf8,errors=remount-ro $1 $2
    }
    function mntntfs {
        echo "[挂载 NTFS 文件系统的分区设备 $1 到目录 $2，使用当前用户权限]"
        sudo mount -t ntfs3 -o rw,nosuid,nodev,noatime,uid=1000,gid=1000,windows_names,iocharset=utf8 $1 $2
    }
    function mntram {
        echo "[映射内存目录 $1，用完了记得要解除挂载：sync; sudo umount $1]"
        sudo mount --mkdir -t ramfs ramfs $1
    }
    function mntsmb {
        echo "[挂载samba目录 $1 到本地目录 $2，用户名为 $3]"
        sudo mount -t cifs -o user=$3 $1 $2
    }
    function mntnfs {
        echo "[挂载nfs目录 $1 到本地目录 $2]"
        sudo mount -t nfs -o vers=4,rsize=1048576,wsize=1048576 $1 $2
    }

    # 显示16进制内容及对应的ascii字符
    alias hexdumps='hexdump -C'

    # 生成密码
    alias passs='echo "[生成16个字符的强密码]" && cat /dev/random |tr -dc "!@#$%^&*()-+=0-9a-zA-Z" | head -c16'
    alias passr='echo "[16 个随机字符作为密码]" && echo && cat /dev/random |tr -dc 'a-zA-Z0-9' |head -c 16 && echo'
    alias passf='echo "[256 随机字节作为密钥文件，过滤了换行符]" && echo &&cat /dev/random |tr -d '\n' |head -c 256'

    # sha256sum
    alias shasums='echo "[sha256sum 按校验和文件逐个校验，跳过缺失文件告警]" && sha256sum --ignore-missing -c'
    function shasumc {
        # `shasumc abc.iso SHA256SUMS.txt`
        echo "[sha256sum，只下载了一个文件 $1，从校验和文件 $2 中抽出单个文件进行校验]"
        sha256sum -c <(grep $1 $2)
    }
    function shasumf {
        echo "[sha256sum 对目录 $1 下的所有文件及子目录文件生成一个校验和文件 $2]"
        find $1 -type f |while read fname; do
            # if [[ "$fname" = "$1" ]]; then
            #   continue
            # fi
            echo $fname
            sha256sum "$fname" >>$2
        done
    }

    # 看日志
    alias audk='echo "[持续显示内核信息]" && sudo dmesg -w'
    alias auds='echo "[持续显示系统日志中 systemd-journald 分类信息]" && sudo journalctl -f'
    alias audj='echo "[持续显示系统日志中人性化可读审计信息-精简文本]" && sudo tail -f /var/log/audit/audit.log |sudo ausearch --format text'

    # systemd
    alias stmu='echo "[systemd 当前系统的单元，可 grep]" && systemctl list-units --no-pager'
    alias stmur='echo "[systemd 当前系统正在运行的单元，可 grep]" && systemctl list-units --state=running --no-pager'
    alias stmuf='echo "[systemd 列出当前系统开机自启动的单元文件]" && systemctl list-unit-files --state enabled --no-pager'
    alias stmed='echo "[systemd 直接编辑服务的单元配置文件]" && sudo env SYSTEMD_EDITOR=vi systemctl edit --force --full'
    alias stmr='echo "[systemd 重载单元文件]" && sudo systemctl daemon-reload'
    alias stmav='echo "[systemd 验证单元文件]" && systemd-analyze verify'
    alias stmab='echo "[systemd 分析计算机启动耗时]" && systemd-analyze blame'

    # lvm
    alias lvvlvs='echo "[lvm显示lv详情]" && sudo lvs -a -o+integritymismatches -o+devices -o+segtype'

    # SELinux
    alias selxr='echo "[SELinux 恢复目录的默认权限设置]" && sudo restorecon -R -v'
    alias selxt='echo "[SELinux 临时关闭或打开]" && sudo setenforce'
    alias selxs='echo "[SELinux 当前状态]" && getenforce'
    alias selxl='echo "[列出当前的 SELinux 规则]" && sudo semanage fcontext -l'

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
    function gadd {
        echo "[把 github.com 的 https 地址转为 git@ 地址，方便鉴权登录github]"
        echo ${1//https:\/\/github.com\//git@github.com:}
    }
    function gaddr {
        # [无法访问 github 的解决方案](git_usage)
        echo "[更新本地 hosts 文件的 github.com 地址]"
        local tfile=$(mktemp)

        # https://raw.githubusercontent.com/521xueweihan/GitHub520/refs/heads/main/hosts
        curl -o $tfile https://raw.githubusercontent.com/maxiaof/github-hosts/master/hosts

        [[ ! -s $tfile ]] && echo '获取 github 地址列表失败！' && return 0

        $(grep 'Github Hosts Start' /etc/hosts >/dev/null 2>&1)
        if [[ "$?" = "0" ]]; then
            sed '/#Github Hosts Start/,/#Github Hosts End/ {
                /#Github Hosts Start/ {
                    r '"$tfile"'
                    d
                }
                /#Github Hosts End/!d
            }' /etc/hosts |awk '!a[$0]++' |sudo tee /etc/hosts
        else
            cat $tfile |sudo tee -a /etc/hosts
        fi

        rm $tfile
    }

    # gpg 常用命令，一般用法都是后跟文件名即可
    alias ggk='echo "[查看有私钥的gpg密钥及其子密钥，带指纹和keygrip]" && gpg -K --keyid-format=long --with-subkey-fingerprint --with-keygrip'
    alias ggl='echo "[查看密钥的可读性信息pgpdump]" && gpg --list-packets'
    alias ggsb='echo "[签名，生成二进制.gpg签名文件，默认选择当前可用的私钥签名，可用 -u 指定]" && gpg --sign'
    alias ggst='echo "[签名，生成文本.asc签名文件，默认选择当前可用的私钥签名，可用 -u 指定]" && gpg --clearsign'
    alias ggsdb='echo "[分离式签名，生成二进制.sig签名文件，默认选择当前可用的私钥签名，可用 -u 指定]" && gpg --detach-sign'
    alias ggsdt='echo "[分离式签名，生成文本.asc签名文件，默认选择当前可用的私钥签名，可用 -u 指定]" && gpg --armor --detach-sign'
    alias ggf='echo "[查看公钥的指纹以便跟跟网站发布的核对]" && gpg --with-fingerprint --show-keys --keyid-format=long'
    function ggkd {
        echo "[从公钥服务器下载指定公钥到本地 $1.gpg]"
        gpg --keyserver hkps://keys.openpgp.org --no-default-keyring --keyring ./$1.gpg --recv-keys
    }
    alias ggvs='echo "[使用临时钥匙圈验证文件签名，如 ggvs ./fedora.gpg xxx.sign xxx.zip 或 ggvs ./fedora.gpg xxx.CHECHSUM]" && gpgv --keyring'
    alias ggv='echo "[验证签名]" && gpg --verify'
    alias gges='echo "[非对称算法加密并签名，参数太多，只给出提示]" && echo "gpg -s -u 'sender@xxx.com' -r 'reciver@xxx.com' -e msg.txt"'
    alias ggcs='echo "[对称算法加密，默认选择当前可用的私钥签名，可用 -u 指定，默认生成的.gpg文件。]" && gpg -s --cipher-algo AES-256 -c'
    # 解密并验签，需要给出文件名或从管道流入，默认输出到屏幕
    alias ggd='gpg -d'
    alias ggaq='echo "[退出 gpg-agent 代理]" && gpg-connect-agent killagent /bye'

    # openssl 常用命令
    # 对称算法加密，如 `echo abc |ssle` 输出到屏幕， `ssle -in 1.txt -out 1.txt.asc` 操作文件，加 -kfile 指定密钥文件
    alias ssle='openssl enc -e -aes-256-cbc -md sha512 -pbkdf2 -iter 9876543 -salt'
    # 对称算法解密，如 `cat 1.txt.asc |ssld` 输出到屏幕，`ssld -in 1.txt.asc -out 1.txt`操作文件，加 -kfile 指定密钥文件
    alias ssld='openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 9876543 -salt'

    # dnf
    alias dnfp='echo "[dnf搜索包含指定命令的软件包]" && dnf provides'
    alias dnfqi='echo "[dnf查找指定的软件包在哪些存储库]" && dnf repoquery -i'
    alias dnfqr='echo "[dnf查看软件包依赖]" && dnf repoquery --requires'
    alias dnfr='echo "[dnf查看当前有哪些存储库]" && dnf repolist'
    alias dnfrl='echo "[dnf查看存储库软件列表]" && dnf list --repo'
    alias dnfl='echo "[dnf查看安装的软件]" && dnf list --installed'
    alias dnfd='echo "[dnf卸载软件]" && dnf remove'
    alias dnft='echo "[在toolbox里运行dnf]" && toolbox run dnf'

    # pip
    alias pipi='echo "[pip 跳过缓存更新指定包]" && pip install --upgrade --no-cache-dir'

    # flatpak
    alias fpkr='echo "[flatpak查看当前有哪些存储库]" && flatpak remotes'
    alias fpkrl='echo "[flatpak查看存储库软件列表]" && flatpak remote-ls'
    alias fpkl='echo "[flatpak查看安装的软件]" && flatpak list --runtime'
    alias fpkd='echo "[flatpak卸载软件]" && flatpak uninstall --delete-data'

    # podman
    alias docker="podman"
    function pdms() {
        # https://stackoverflow.com/questions/28320134/how-can-i-list-all-tags-for-a-docker-image-on-a-remote-registry
        echo "[podman搜索列出镜像标签，非官方镜像需要完整的源地址]"
        podman search --list-tags --limit=5000 $1
    }
    alias pdmrun='echo "[podman简单运行一个容器]" && podman run -it --rm -P'
    alias pdme='echo "[podman在运行的容器里执行一个命令]" && podman exec'
    alias pdmip='echo "[podman列出所有容器的ip和开放端口(rootless容器无ip地址)]" && podman inspect -f="{{.Name}} {{.NetworkSettings.IPAddress}} {{.HostConfig.PortBindings}}" $(podman ps -aq)'
    alias pdmlog='echo "[podman查看指定容器日志]" && podman logs -f --tail 100'
    alias pdmdf='echo "[podman查看资源情况]" && podman system df -v'
    alias pdmvp='echo "[podman清理空闲空间]" && podman volume prune'
    function pdmtty() {
        echo "[登录到容器 $1 内的tty]"
        podman exec -it $1 sh
    }
    alias pdmrs='echo "[podman 搜索包含本地无tls私有仓库]" && podman search --tls-verify=false'
    alias pdmr='echo "[podman 列出本地私有仓库 192.168.0.88:5000 的所有镜像]" && curl http://192.168.0.88:5000/v2/_catalog'
    function pdmrtag() {
        echo "[podman 列出本地私有仓库 192.168.0.88:5000 镜像 ${1} 的所有 tag]"
        local img=$(echo $1  |cut -d: -f1)
        curl http://192.168.0.88:5000/v2/${img}/tags/list
    }
    function pdmrm() {
        echo "[podman 显示本地私有仓库 192.168.0.88:5000 镜像 ${1} 的 manifests]"
        local img=$(echo $1  |cut -d: -f1)
        local tag=$(echo $1  |cut -d: -f2)
        curl http://192.168.0.88:5000/v2/${img}/manifests/${tag}
    }
    function pdmrt() {
        local img=$(basename ${1})
        echo "[给本地镜像 ${1} 打标签为私有仓库 192.168.0.88:5000/$img]"
        podman tag $1 192.168.0.88:5000/$img
    }
    function pdmrh() {
        echo "[向本地私有仓库推送镜像 192.168.0.88:5000/$1]"
        podman push --tls-verify=false 192.168.0.88:5000/$1
    }
    function pdmrl() {
        echo "[从本地私有仓库拉取镜像 192.168.0.88:5000/$1]"
        podman pull --tls-verify=false 192.168.0.88:5000/$1
    }
    function pdmrd() {
        local img=$(echo $1  |cut -d: -f1)
        local tag=$(echo $1  |cut -d: -f2)
        local sha=$2
        echo "[从本地私有仓库删除镜像 192.168.0.88:5000/$img:$tag，manifests的sha256摘要: ${sha}]"
        curl  -v -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' -X DELETE http://192.168.0.88:5000/v2/${img}/manifests/sha256:${sha}
    }

    # distrobox 这词打不快
    alias dbox='distrobox'
    alias dboxe='echo "[在distrobox里运行一个命令]" && distrobox-enter --'
    function dboxstop() {
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
        rm -f /tmp/.ssh-pageant-$USERNAME

        echo ''
        # echo "update gpg keyrings, wait a second..."
        # gpg --refresh-keys

        echo "GPG update TrustDB,跳过 owner-trust 未定义的导入公钥..."
        gpg --check-trustdb

        echo ''
        echo "GPG check sigs..."
        gpg --check-sigs
    fi

    echo ''
    echo 'ssh-pageant reusing ssh key loaded in putty pageant'
    # ssh-pageant 使用以下参数来判断是否有已经运行的进程，不会多次运行自己
    eval $(/usr/bin/ssh-pageant -r -a "/tmp/.ssh-pageant-$USERNAME")
    ssh-add -l

# 默认用 tty 命令行环境通用的设置
else

    # Linux bash
    # 多会话复用 ssh-agent
    # 代码来源 git bash auto ssh-agent
    # https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows
    # 来自章节 [多会话复用 ssh-agent 进程] <ssh okletsgo>

    agent_env=~/.ssh/agent.env

    agent_load_env () { test -f "$agent_env" && source "$agent_env" >| /dev/null ; }
    agent_load_env

    agent_start () { test -d "$HOME/.ssh" && (umask 077; ssh-agent >| "$agent_env") && source "$agent_env" >| /dev/null ; }

    # 加载 ssh-agent 需要用户手工输入密钥的保护密码
    # 这里不能使用工具 sshpass，它用于在命令行自动输入 ssh 登陆的密码，对密钥的保护密码无法实现自动输入
    #
    # agent_run_state:
    #   0=agent running w/ key;
    #   1=agent w/o key;
    #   2=agent not running
    agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

    if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
        # agent未运行视作开机后第一次打开bash会话

        echo ''
        # echo "更新gpg钥匙圈需要点时间，请稍等..."
        # gpg --refresh-keys

        echo "GPG update TrustDB, 跳过 owner-trust 未定义的导入公钥..."
        gpg --check-trustdb

        echo ''
        echo "GPG check sigs..."
        gpg --check-sigs

        echo && echo "Start ssh-agent..."
        agent_start

        echo "-->Adding ssh key to agent，input passphrase of the key if prompted"
        ssh-add

    elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
        # ssh-agent正在运行，但是没有加载过密钥
        echo "-->Adding ssh key to agent，input passphrase of the key if prompted"
        ssh-add
    fi

    unset agent_run_state
    unset agent_env
fi

####################################################################
# Bash：加载插件或小工具

# ssh 命令后面按tab键自动补全 hostname，zsh 自带不需要
if [[ ! $__cur_shell = 'zsh' ]]; then
    [[ -f ~/.ssh/config && -f ~/.ssh/known_hosts ]] && complete -W "$(cat ~/.ssh/config | grep ^Host | cut -f 2 -d ' ';) $(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
fi

# ackg 看日志最常用，见章节 [ackg 给终端输出的自定义关键字加颜色](gnu_tools.md okletsgo)
[[ -f /usr/local/bin/ackg.sh ]] && source /usr/local/bin/ackg.sh || (echo 'Get ackg from github...' && curl -fsSL https://github.com/paoloantinori/hhighlighter/raw/master/h.sh |sed -e 's/h()/ackg()/' |sudo tee /usr/local/bin/ackg.sh) && source /usr/local/bin/ackg.sh

#################################
# Bash：手动配置插件

# 从上面的 ackg.sh 扩展的看日志的快捷命令
alias ackgs='ackg -i'
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
    # Linux 下安装 Anaconda 需要执行一次如下命令，才能在 bash 中使用 conda 命令
    #   `conda init bash`
    # 会自动在 ~/.bashrc 或 .bash_profile.sh 文件添加如下内容：
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
            # __git_ps1 没取到有效信息，由下面的补充获取
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

# 主机名用不同颜色提示本地或 ssh 远程登录：本地登录是绿色，远程登录是洋红色
function PS1_host_name {
    local is_remote=false

    # 判断当前是否远程ssh会话：变量 SSH_TTY 仅在交互式登录会话中被设置，变量 SSH_CLIENT 只要远程 ssh 登录即设置
    # 此方法仅在主机环境或 distrobox 容器中有效，在 toolbox 容器中要用其它办法
    ([[ -n $SSH_CLIENT ]] || [[ -n $SSH_TTY ]]) && is_remote=true

    # 默认主机环境，显示的主机名适应 FQDN 只显示最前段，如 host.local 显示 host
    local raw_host_name=$(echo ${HOSTNAME%%.*})

    # 如果进入了交互式容器，在这里处理显示宿主机的主机名，后面有单独的函数处理显示容器名
    if [ -f "/run/.toolboxenv" ] || [ -e /run/.containerenv ]; then
        # 如果是在交互式容器 toolbox 中，$HOSTNAME 与宿主机一致，但 /etc/hostname 变为 toolbox
        if [[ $(uname -n) = 'toolbox' ]]; then
            # toolbox 容器中只能用这个方式判断是否远程连接中，不是很靠谱
            [[ $(pstree |grep sshd |grep toolbox |grep podman |grep -v grep >/dev/null 2>&1; echo $?) = "0" ]] && is_remote=true

        else
            # 否则是在交互式容器 distrobox 中，主机名的值变为：容器名.宿主机的主机名
            # distrobox 容器中不需要判断是否在远程连接中，它继承了宿主机的环境变量，前面的 is_remote 判断结果直接用
            # 显示宿主机的主机名
            raw_host_name=$(echo ${HOSTNAME} |cut -d. -f2)
        fi

    fi

    [[ $is_remote = true ]] && echo -e "\033[0;35m$(echo $raw_host_name)" || echo -e "\033[0;32m$(echo $raw_host_name)"
}

# 提示当前在 toolbox 或 distrobox 等交互式容器环境，白色容器名配蓝色背景
# https://docs.fedoraproject.org/en-US/fedora-silverblue/tips-and-tricks/#_working_with_toolbx
# https://ublue.it/guide/toolbox/#using-the-hosts-xdg-open-inside-distrobox
# https://github.com/docker/cli/issues/3037
# Windows 下的 wsl 环境，wsl 下的 docker，暂未研究
function PS1_container_name {
    if [ -f "/run/.toolboxenv" ] || [ -e /run/.containerenv ]; then
        # $CONTAINER_ID
        echo -e "\033[0;44m\U0001f4e6<$(cat /run/.containerenv | grep -oP "(?<=name=\")[^\";]+")>"
    elif  [ -e /.dockerenv ]; then
        echo -e "\033[0;44m\U0001f4e6<$(cat /run/.dockerenv | grep -oP "(?<=name=\")[^\";]+")>"
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

    #[[ $(command -v vcgencmd >/dev/null 2>&1; echo $?) = "0" ]] || return
    $(command -v vcgencmd >/dev/null 2>&1) ||return

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
if [[ $__cur_shell = 'zsh' ]]; then
    # "zsh 有自己的 powerlevel10k 设置命令行提示符"
    :

elif [[ $OS =~ Windows && "$OSTYPE" =~ msys ]]; then
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
    PS1="\n$PS1Cblue┌─$PS1Cred\$(PS1exit-code)$PS1Cblue[$PS1Cwhite\t $PS1Cgreen\u$PS1Cwhite@$PS1Cgreen\$(PS1_host_name)\$(PS1_container_name)$PS1Cwhite:$PS1Ccyan\w$PS1Cblue]$PS1Cred\$(PS1raspi-warning-prompt)$PS1Cyellow\$(PS1conda-env-name)\$(PS1virtualenv-env-name)\$(PS1git-branch-prompt)\n$PS1Cblue└──$PS1Cwhite\$ $PS1Cnormal"

else
    # 通用 Linux bash 命令行提示符显示：返回值 \t当前时间 \u用户名 \h主机名<toolbox容器名> \w当前路径 python环境 git分支及状态
    PS1="\n$PS1Cblue┌─$PS1Cred\$(PS1exit-code)$PS1Cblue[$PS1Cwhite\t $PS1Cgreen\u$PS1Cwhite@\$(PS1_host_name)\$(PS1_container_name)$PS1Cwhite:$PS1Ccyan\w$PS1Cblue]$PS1Cyellow\$(PS1conda-env-name)\$(PS1virtualenv-env-name)\$(PS1git-branch-prompt)\n$PS1Cblue└──$PS1Cwhite\$ $PS1Cnormal"

fi

unset __cur_shell
