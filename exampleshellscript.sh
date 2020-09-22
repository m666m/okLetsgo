#!/bin/bash
#
# 参考:
# https://zhuanlan.zhihu.com/p/123989641

# Bach脚本测试框架 https://github.com/bach-sh/bach/blob/master/README-cn.md
# source path/to/bach.sh

####################################################################
# 此部分作为普通脚本的默认头部内容，便于调测运行。
#
#
# -x ： 在执行每一个命令之前把经过变量展开之后的命令打印出来。
# -e ： 遇到一个命令失败（返回码非零）时，立即退出。
# -u ：试图使用未定义的变量，就立即退出。
# -o pipefail ： 只要管道中的一个子命令失败，整个管道命令就失败。
set -xeuo pipefail

# 防止重叠运行
exec 123<>lock_myscript   # 把lock_myscript打开为文件描述符123
flock  --wait 5  123 || { echo 'cannot get lock, exit'; exit 1; }

# 意外退出时杀掉所有子进程
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

# timeout 限制运行时间
timeout 600s  some_command arg1 arg2

# 连续管道时，考虑使用 tee 将中间结果落盘，以便查问题
cmd1 | tee out1.dat | cmd2 | tee out2.dat | cmd3 > out3.dat


####################################################################
# 命令行提示符显示当前路径和git分支名

black=$'\[\e[0;30m\]'

red=$'\[\e[0;31m\]'

green=$'\[\e[0;32m\]'

yellow=$'\[\e[0;33m\]'

blue=$'\[\e[0;34m\]'

magenta=$'\[\e[0;35m\]'

cyan=$'\[\e[0;36m\]'

white=$'\[\e[0;37m\]'

normal=$'\[\e[m\]'

function git-branch-name {
  git symbolic-ref --short -q HEAD 2>/dev/null
}

function git-branch-prompt {
  local branch=`git-branch-name`
  if [ $branch ]; then printf "(%s)" $branch; fi
}

# 命令行提示符显示当前路径和git分支名 # \W 当前路径 \w 当前路径的末位
PS1="$magenta\u$white@$green\h$white:$cyan\W$yellow\$(git-branch-prompt)$white\$ $normal"

# 简单写颜色
PS1="\u@\h \[\033[0;36m\]\W\[\033[0m\]\[\033[0;32m\]\$(git-branch-prompt)\[\033[0m\] \$ "


####################################################################
#
# 文字颜色生成模板 http://ciembor.github.io/4bit
#

# 一个颜色文字的例子
red='\033[0;31m'
green="\033[0;32m"
plain='\033[0m'

[ -z "$res" ] && ngstatus="${red}已停止${plain}" || ngstatus="${green}正在运行${plain}"
echo -e " nginx运行状态：${ngstatus}"


####################################################################
# 自定义 vim 编辑器的颜色方案等
#
# 打开一个Vim窗口，输入命令:color 后回车查看当前的颜色主题。
# 输入命令:echo $VIMRUNTIME 来查看Vim的运行目录
#     进入vim的运行目录，查看color目录下以“.vim”为结尾的文件
#     这些文件即是颜色主题文件，文件名就是主题名字。
# 输入命令"colorscheme 主题名字"，即可设置当前vim实例的颜色主题。
# 更改默认颜色主题
# 打开~/.vimrc文件，在其中加入一行"colorscheme 颜色主题名字"，之后保存更改即可。
# 如：
#     colorscheme slate


####################################################################
#
# python 颜色字符串
#
import platform
from colorama import Fore, Back, Style

text = "Ok, let's go!"

def print_color(color, message=""):
    v_system = platform.system()
        if v_system == 'Linux':
            print(color+message)

# 将前景设为红色，背景默认是黑色
print(Fore.RED + text)
# 将背景设为白色，前景沿用之前的红色，并且在显示完之后将格式复位
print(Back.WHITE + text + Style.RESET_ALL)
print(text)
# 将前景设为黑色，背景设为白色
print(Fore.BLACK + Back.WHITE + text + Style.RESET_ALL)
print(Style.RESET_ALL)
print('back to normal now')

####################################################################
