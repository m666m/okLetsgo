# 适用于 Linux bash、Windows mintty bash，每个段落用 ########## 分隔，根据说明自行选用搭配即可
#
# 别人的配置文件参考大全 https://github.com/pseudoyu/dotfiles
#                       https://www.pseudoyu.com/zh/2022/07/10/my_config_and_beautify_solution_of_macos_terminal/

###################################################################
# 自此开始都是自定义设置

# 兼容性设置，用于 .bash_profile 加载多种linux的配置文件
test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc

# exit for non-interactive shell
[[ ! -t 1 ]] && return

# 命令行开启vi-mode模式，按esc后用vi中的上下左右键选择历史命令
set -o vi

####################################################################
# alias 本该放到 .bashrc 文件，为了方便统一在此了
#
# 添加 dbian 自带的 .bashrc 脚本中，常用命令开启彩色选项
# enable color support of ls and also add handy aliases
#if [ -x /usr/bin/dircolors ]; then
#    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
#     这里放 alias
#fi

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
alias lsg='ls -lA |grep -i'

####################################################################
# Windows git bash(mintty)
# 在 mintty 下使用普通的 Windows 控制台程序
alias python="winpty python"
alias ipython="winpty ipython"
alias mysql="winpty mysql"
alias psql="winpty psql"
alias redis-cli="winpty redis-cli"
alias node="winpty node"
alias vue='winpty vue'

# Windows 的 cmd 字符程序都可以在 bash 下用 winpty 来调用
alias ping='winpty ping'

####################################################################
# Linux bash / Windows git bash(mintty)
# 命令行提示符显示当前路径、git分支、python环境名等

# 显式设置终端启用256color，防止终端工具未设置。若终端工具能开启透明选项，则显示的效果更好
export TERM=xterm-256color

# https://zhuanlan.zhihu.com/p/570148970
# https://zhuanlan.zhihu.com/p/566797565
# 色彩      黑    红    绿    黄    蓝    洋红    青    白
# 前景色    30    31    32    33   34    35    36    37
# 背景色    40    41    42    43   44    45    46    47

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

TODO:缩进不统一，需要解决

# 注意：在执行判断退出码的函数前面不能执行别的函数，
# 所以 PS1exit-code 要放在变量 PS1 的最前面
function PS1exit-code {
  local exitcode=$?
  if [ $exitcode -eq 0 ]; then printf "%s" ''; else printf "%s" ' -'$exitcode' '; fi
}

function PS1conda-env-name {
  # 自定义 conda 的环境名格式，需要先修改 conda 的默认设置，不允许 conda 命令修改 PS1 变量
  #
  # 在 Anaconda cmd 命令行下执行（或者cmd下手工激活base环境，执行命令 `conda activate`）做如下的设置，只做一次即可
  #   让 Anaconda 可以 hook 到 .bash_profile
  #       conda init bash
  #   禁止 conda 修改命令行提示符，以防止修改 PS1 变量
  #       conda config --set changeps1 False
  #   禁止 conda 进入命令行提示符时自动激活base环境，以方便检测 $CONDA_DEFAULT_ENV 变量
  #       conda config --set auto_activate_base false
  [[ -n $CONDA_DEFAULT_ENV ]] && printf "(conda:%s)" $CONDA_DEFAULT_ENV
}

# virtualenv 自定义环境名格式，禁止 activate 命令脚本中在 PS1 变量添加环境名称
export VIRTUAL_ENV_DISABLE_PROMPT=1

function PS1virtualenv-env-name {
    [[ -n $VIRTUAL_ENV ]] && printf "(venv:%s)" $(basename $VIRTUAL_ENV)
}

function PS1git-branch-name {
  # 一条命令取当前分支名

  # 优先使用 __git_ps1 取分支名信息
  #
  #   如果使用 git for Windows 自带的 mintty bash，它自带 git 状态脚本
  #   只要启动 bash ，其会自动 source C:\Program Files\Git\etc\profile.d\git-prompt.sh，
  #   最终执行 C:\Program Files\Git\mingw64\share\git\completion\git-prompt.sh。
  #   只要是git管理的目录就会显示git状态字符串。
  #   来源 https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
  #   如果自定义命令提示符，可以在PS1变量拼接中调用函数 $(__git_ps1 " (%s)") ，
  #   可惜tag和hashid的提示符有点丑，为了显示速度快，忍忍得了
  #
  # __git_ps1 居然透传 $?，前面的命令执行结果被它作为返回值了，只能先清一下，佛了
  pp_git_pt=$(>/dev/null;__git_ps1 '%s' 2>/dev/null)
  if [ "$?" = "0" ]; then
    printf "%s" $pp_git_pt
    unset pp_git_pt
    return
  else
    unset pp_git_pt
  fi

  # 命令 git symbolic-ref 在裸仓库或 .git 目录中运行不报错，都会打印出当前分支名，
  # 除非不在当前分支，返回 128，如果当前分支是分离的，返回 1
  # 注意：如果用 local branch_name 则无法直接判断嵌入变量赋值语句的命令的失败状态
  branch_name=$(git symbolic-ref --short -q HEAD 2>/dev/null)
  local exitcode=$?

  # 优先显示当前 head 指向的分支名
  if [ $exitcode -eq 0 ]; then
    printf "%s" $branch_name
    unset branch_name
    return
  fi
  unset branch_name

  # 如果是 detached HEAD，则显示标签名或 commit id
  if [ $exitcode -eq 1 ]; then

      local headhash="$(git rev-parse HEAD)"
      local tagname="$(git for-each-ref --sort='-committerdate' --format='%(refname) %(objectname) %(*objectname)' |grep -a $headhash |grep 'refs/tags' |awk '{print$1}'|awk -F'/' '{print$3}')"

      # 有标签名就显示标签否则显示 commit id
      [[ -n $tagname ]] && printf "@%s" "$tagname" || printf "#%s" "$headhash"

  fi

  # exitcode 是其它数字的，视为不在 git 环境中，不做任何打印输出
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

# linux bash 命令行提示符显示：返回值 \t当前时间 \u用户名 \h主机名 \w当前路径 git分支及状态
PS1="\n$magenta┌─$red\$(PS1exit-code)$magenta[$white\t $green\u$white@$green\h$white:$cyan\w$magenta]$yellow\$(PS1conda-env-name)\$(PS1virtualenv-env-name)\$(PS1git-branch-prompt)\n$magenta└──$white\$ $normal"

#################################
# Linux bash - raspberrypi
# 在上面的基础上增加 raspberry pi 的状态检测
# 告警条件：
#   CPU 温度的单位是千分位提权 1000
#   系统 throttled 不是零
#   CPU Load Average 的值应该小于CPU核数的70%，取5分钟平均负载
function PS1raspi-warning-info {

  # [[ $(which vcgencmd >/dev/null 2>&1; echo $?) = "0" ]] || return

  local CPUTEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

  if [ "$CPUTEMP" -gt  "65000" ] && [ "$CPUTEMP" -lt  "70000" ]; then
    local CPUTEMP_WARN="= CPU `vcgencmd measure_temp` ！HIGH TEMPERATURE! ="
  elif [ "$CPUTEMP" -gt  "70000" ];  then
     local CPUTEMP_WARN="= CPU `vcgencmd measure_temp` IS VERY HIGH! PLEASE SHUTDOWN! ="
  fi

  local THROTT=`vcgencmd get_throttled| tr -d "throttled="`
  if [ "$THROTT" != "0x0" ];  then
    local THROTT_WARN="= System throttled $THROTT ！PLEASE check RASPBERRYPI:https://www.raspberrypi.com/documentation/computers/os.html#get_throttled ="
  fi

  local CPU_CORES=`grep 'model name' /proc/cpuinfo | wc -l`
  local LOAD_AVG_CAP=`echo | awk -v cores="$CPU_CORES" '{printf("%.2f",cores*0.7)}'`
  local LOAD_AVG_5=`cat /proc/loadavg | cut -d' ' -f 2`
  local LOAD_AVG_THLOD=`echo | awk -v avg="$LOAD_AVG_5" -v cap="$LOAD_AVG_CAP" '{if (avg>cap) {print "1"} else {print "0"}}'`
  (($LOAD_AVG_THLOD > 0)) && local LOAD_AVG_WARN="= AVG_LOAD 5min: $LOAD_AVG_5 ="

  printf "%s%s%s" "$CPUTEMP_WARN" "$THROTT_WARN" "$LOAD_AVG_WARN"
}

function PS1raspi-warning-prompt {
  local raspi_warning=`PS1raspi-warning-info`
  if [ -n "$raspi_warning" ]; then
    printf "====%s====" "$raspi_warning"
  fi
}

# Raspberry OS bash 命令行提示符显示：返回值 \t当前时间 \u用户名 \h主机名 \w当前路径 树莓派温度告警 git分支及状态
PS1="\n$magenta┌─$red\$(PS1exit-code)$magenta[$white\t $green\u$white@$green\h$white:$cyan\w$magenta]$red\$(PS1raspi-warning-prompt)$yellow\$(PS1conda-env-name)\$(PS1virtualenv-env-name)\$(PS1git-branch-prompt)\n$magenta└──$white\$ $normal"

#################################
# Windows git bash(mintty)
# 命令行提示符显示： 在上面的基础上修改了两个兼容性函数
#
# 目前 git bash(mintty) 有点bug：
# 在\$(函数名)后直接用换行\n就冲突，不支持$?检查退出码
# 规避办法是或者把换行\n放在引用函数前面，或者拼接凑合用
#   PS1="\n$magenta┌──── $white\t ""$PS1""$magenta───┘ $normal"
#
# 新的解决办法：
# 用新增子函数 PS1git-bash-new-line 和 PS1git-bash-exitcode 实现跟上面完全一致的显示效果。

function PS1git-bash-new-line {
    printf "\n└"
}

function PS1git-bash-exitcode {
    local exitcode=$(printf "$?")
    (($exitcode != 0)) && printf "%s" ' -'$exitcode' '
}

# git bash 命令行提示符显示：返回值 \t当前时间 \u用户名 \h主机名 \w当前路径 git分支及状态
PS1="\n$blue┌─$red\$(PS1git-bash-exitcode)$blue[$white\t $green\u$white@$green\h$white:$cyan\w$blue]$yellow\$(PS1conda-env-name)\$(PS1virtualenv-env-name)\$(PS1git-branch-prompt)$blue$(PS1git-bash-new-line)──$white\$ $normal"

####################################################################
# Linux bash / Windows git bash(mintty)
# 多会话复用 ssh-agent
#
# 代码来源 git bash auto ssh-agent
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows
# 来自章节 [多会话复用 ssh-agent 进程] <ssh okletsgo>

env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

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
# 多会话复用 ssh-pageant 及运行gpg钥匙圈更新
#
# 用它连接 putty 的 pagent.exe，代替上面多会话复用 ssh-agent 的段落
# 来自章节 [使ssh鉴权统一调用putty的pageant] <ssh.md>

# 利用检查 ssh-pageant 进程是否存在，判断是否开机后第一次打开bash会话，则运行gpg钥匙圈更新
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
