
# exit for non-interactive shell
[[ ! -t 1 ]] && return

# 兼容性设置，用于 .bash_profile 加载多种linux的配置文件
test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc

# 命令行开启vi-mode模式，按esc后用vi中的上下左右键选择历史命令
set -o vi

####################################################################
# Linux bash / Windows git bash(mintty)
# : 命令行提示符显示当前路径和git分支等，放入任一 .profile 或 .bashrc 或 .bash_profile 内

# 显式设置终端启用256color，防止终端工具未设置，终端工具能开启透明选项，则显示的效果更好
export TERM=xterm-256color

black=$'\[\e[0;30m\]'

red=$'\[\e[0;31m\]'

green=$'\[\e[0;32m\]'

yellow=$'\[\e[0;33m\]'

blue=$'\[\e[0;34m\]'

magenta=$'\[\e[0;35m\]'

cyan=$'\[\e[0;36m\]'

white=$'\[\e[0;37m\]'

normal=$'\[\e[m\]'

# 为防止函数名污染命令行环境，尽量使用奇怪点的函数名
# 注意：在执行判断退出码的函数前面不能执行函数，
#      所以 PS1exit-code 要放在最前面执行

function PS1exit-code {
    local exitcode=$?
    if [ $exitcode -eq 0 ]; then printf "%s" ''; else printf "%s" ' -'$exitcode' '; fi
}

function PS1conda-env-name {
    # 暂未调试成功
    local envname=$(if [ "$(which conda >/dev/null 2>&1)" = "0" ]; then printf "%s" $(conda env list); fi)
    [[ ! -z $envname ]] && printf " conda:%s" $envname
}

function PS1git-branch-name {
    git symbolic-ref --short -q HEAD >/dev/null 2>&1
    local exitcode=$?

    # 优先显示当前head指向的分支名
    if [ $exitcode -eq 0 ]; then
        local result="$(git symbolic-ref --short -q HEAD 2>/dev/null)"
        printf "%s" $result

    else
        # 不是git环境
        if [ $exitcode -gt 1 ]; then
            printf "%s" ""
            return

        # detached HEAD
        else
            local commit="$(git rev-parse HEAD)"
            local tagname="$(git for-each-ref --sort='-committerdate' --format='%(refname) %(objectname) %(*objectname)' |grep -a $commit |grep 'refs/tags' |awk '{print$1}'|awk -F'/' '{print$3}')"

            # 有标签名就显示标签否则显示commit id
            if [[ -n $tagname ]]; then
                printf "tag:%s" "$tagname"

            else
                printf "hash:%s" "$commit"
            fi
        fi
    fi
}

function PS1git-branch-prompt {
  local branch=`PS1git-branch-name`
  if [ $branch ]; then
    local git_modify=$(if ! [ -z "$(git status --porcelain)" ]; then printf "%s" '<!>'; else printf "%s" ''; fi)
    if [ -n "$git_modify" ]; then
	    printf " git:%s(%s)" $git_modify $branch
    else
	    printf " git:(%s)" $branch
    fi
  fi
}

# linux bash 命令行提示符显示： \t当前时间 \u用户名 \h主机名 \w当前路径 返回值 git分支及状态
PS1="\n$magenta┌─$red\$(PS1exit-code)$magenta[$white\t $green\u$white@$green\h$white:$cyan\w$magenta]$yellow\$(PS1git-branch-prompt)\n$magenta└──$white\$ $normal"

#################################
# Linux bash
# : 在上面的基础上增加 raspberry pi 的状态检测
# 告警条件：
#   CPU 温度的单位是千分位提权1000
#   系统throttled不是零
#   CPU Load Average的值应该小于CPU核数X0.7，取5分钟平均负载
function PS1raspi-warning-info {
    local CPUTEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

    if [ "$CPUTEMP" -gt  "65000" ] && [ "$CPUTEMP" -lt  "75000" ]; then
            local CPUTEMP_WARN="= CPU `vcgencmd measure_temp` ！HIGH TEMPERATURE! ="
    elif [ "$CPUTEMP" -gt  "75000" ];  then
            local CPUTEMP_WARN="= CPU `vcgencmd measure_temp` ！PLEASE SHUTDOWN RASPBERRYPI: TEMPERATURE IS VERY HIGH! ="
    fi

    local THROTT=`vcgencmd get_throttled| tr -d "throttled="`
    if [ "$THROTT" != "0x0" ];  then
        local THROTT_WARN="= System throttled $THROTT ！PLEASE check RASPBERRYPI:https://www.raspberrypi.com/documentation/computers/os.html#get_throttled ="
    fi

    local CPU_CORES=`grep 'model name' /proc/cpuinfo | wc -l`
    local LOAD_AVG_CAP=`echo | awk -v cores="$CPU_CORES" '{printf("%.2f",cores*0.7)}'`
    local LOAD_AVG_5=`cat /proc/loadavg | cut -d' ' -f 2`
    local LOAD_AVG_THLOD=`echo | awk -v avg="$LOAD_AVG_5" -v cap="$LOAD_AVG_CAP" '{if (avg>cap) {print "1"} else {print "0"}}'`
    (($LOAD_AVG_THLOD > 0)) && local LOAD_AVG_WARN="= cpu_avg_load 5min: $LOAD_AVG_5 ="

    printf "%s%s%s" "$CPUTEMP_WARN" "$THROTT_WARN" "$LOAD_AVG_WARN"
}

function PS1raspi-warning-prompt {
    local raspi_warning=`PS1raspi-warning-info`
    if [ -n "$raspi_warning" ]; then
        printf "====%s====" "$raspi_warning"
    fi
}

PS1="\n$magenta┌─$red\$(PS1exit-code)$magenta[$white\t $green\u$white@$green\h$white:$cyan\w$magenta]$red\$(PS1raspi-warning-prompt)$yellow\$(PS1git-branch-prompt)\n$magenta└──$white\$ $normal"

#################################
# Windows git bash(mintty)
# : 命令行提示符显示： 部分复用了上面的函数
#
# 在\$(函数名)后直接用换行\n就冲突，不支持$?检查退出码，或者把换行\n放在引用函数前面，或者拼接凑合用
#PS1="\n$magenta┌──── $white\t ""$PS1""$magenta───┘ $normal"
# 目前完美解决办法是新增子函数PS1git-bash-new-line和PS1git-bash-exitcode实现跟上面完全一致的美化效果。

function PS1git-bash-new-line {
    printf "\n└"
}

function PS1git-bash-exitcode {
    local exitcode=$(printf "$?")
    (($exitcode != '0')) && printf "%s" ' -'$exitcode' '
}

PS1="\n$magenta┌─$red\$(PS1git-bash-exitcode)$magenta[$white\t $green\u$white@$green\h$white:$cyan\w$magenta]$yellow\$(PS1git-branch-prompt)$magenta$(PS1git-bash-new-line)──$white\$ $normal"

####################################################################
# Linux bash / Windows git bash(mintty)
# : 多会话复用 ssh-agent
#
# 来自章节 [多会话复用 ssh-agent 进程] <ssh.md>
# git bash auto ssh-agent
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows
#
# You can run ssh-agent automatically when you open bash or Git shell.
# Copy the following lines and paste them into one of your
#    ~/.bash_profile
#    ~/.profile
#    ~/.bashrc

env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

##########
# 加载 ssh-agent 需要用户手工输入密钥的保护密码
# 这里不能使用工具 sshpass，它用于在命令行自动输入 ssh 登陆的密码，对密钥的保护密码无法实现自动输入

# agent_run_state:
#   0=agent running w/ key;
#   1=agent w/o key;
#   2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    # 开机后第一次打开bash会话
    echo "正在启动ssh-agent..."
    agent_start

    echo ''
    echo "加载ssh密钥，注意根据提示输入保护密码"
    ssh-add

elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    # ssh-agent正在运行，但是没有加载过密钥
    echo "加载ssh密钥,注意根据提示输入保护密码"
    ssh-add
fi

unset env

####################################################################
# Windows git bash(mintty)
# : 多会话复用 ssh-pageant，用它连接 putty 的 pagent.exe，代替上面多会话复用 ssh-agent 的段落
# : 运行gpg钥匙圈更新

# 利用检查 ssh-pageant 进程是否存在，
# 判断是否开机后第一次打开bash会话，则运行gpg钥匙圈更新
if ! $(ps -s|grep ssh-pageant>/dev/null) ;then
    echo ''
    # echo "更新gpg钥匙圈需要点时间，请稍等..."
    # gpg --refresh-keys

    echo "更新TrustDB，跳过owner-trust未定义的导入公钥..."
    gpg --check-trustdb

    echo ''
    echo "检查gpg签名情况..."
    gpg --check-sigs

fi

echo ''
echo '用 ssh-pageant 连接 putty pageant，复用已加载的ssh密钥'
# ssh-pageant 使用以下参数来判断是否有已经运行的进程，不会多次运行自己
eval $(/usr/bin/ssh-pageant -r -a "/tmp/.ssh-pageant-$USERNAME")
ssh-add -l

####################################################################
