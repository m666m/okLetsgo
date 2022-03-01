# python

## Windows 7 最高只能使用 Python3.8

windows下的python，各种命令的脚本都是cmd下的bat，如果用bash运行这些命令，有时候会出现各种提示报错信息。
推荐windows下的python使用cmd做命令行。

## github web页面添加导航树

目前各浏览器插件都有

<https://github.com/ovity/octotree>
<https://github.com/ineo6/git-master>

## pip

### 务必搞清环境，pip安装可能把包放到的几个地方

pip之前先看看到底用的哪个地方的pip，特别是当前操作系统里有多个pip：

    pip -V 这个会列出当前的pip的命令行位置
    which pip  # linux
    where pip  # windows

Pip can install software in three different ways:

    At global level. 标准的python环境下，"pip install xxx"放在了python目录的site-packages里，这个影响当前操作系统的所有用户.
    At user level. "pip install xxx --user"放在了当前操作系统用户home目录的python目录的site-packages里，这个放置的地方比较别扭。
    At virtualenv level. virtualenv环境下，"pip install xxx"放在了virtualenv建立的环境目录的site-packages里，最好用这个。

    如果当前操作系统还安装了conda，请先conda list 看看有没有pip，有可能运行的是conda环境里的pip，那就安装到了conda建立的环境目录的site-packages里

pip用之前先 pip -V 看看位置，防止不是你的环境的pip，用了就装到别的地方了

    yourenv/Scripts/pip.exe install pyqt5-tools~=5.15

### wheels

最简单的解决办法是下载好心人提供的编译好的windows二进制包 <https://www.lfd.uci.edu/~gohlke/pythonlibs/>

在windows环境中，python 的 Setup 需要调用一个 vcvarsall.bat 的文件，该文件需要安装c++编程环境才会有。网上的方法有两个：一、安装MinGW；二、安装Visual Studio 。很多python包也是如此，pip提供的是代码，需要借助python环境在本地编译出二进制。

python2.7用的是msvs2008编译的，所以python2.7默认只能认出msvs2008.
python3.4用的是msvs2010编译的，所以python3.4默认只能认出msvs2010。
python3.7使用vs2015（WIN10SDK）
python3.8应该对应了VS2017(15.9)，用VS2019基本也可以。

如果安装的是VS2014，则VERSION为13.0；
如果安装的是VS2013，则VERSION为12.0；
如果安装的是VS2012，则VERSION为11.0；
如果安装的是VS2010，则VERSION为10.0；
如果安装的是VS2008，则VERSION为9.0。

如何编译python3.7/3.8
<https://www.cnblogs.com/xiacaojun/p/9914545.html>
<https://zhuanlan.zhihu.com/p/148348614>

清华开源镜像 <https://mirrors.tuna.tsinghua.edu.cn/>

### pip版本更新

1.pip直接更新

如果您到 pip 默认源的网络连接较差，临时使用清华镜像站来升级 pip：

    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U

通常步骤

    pip install --upgrade pip

    pip3 install --user --upgrade pip

    python -m pip install --upgrade pip

失败的话，首先查看windows下使用cmd环境，并检查下环境变量，which看下命令指向，是否有conda环境冲突了。
windows下，如果是干净的python环境，不要使用bash，在cmd命令行下，直接pip是可以的。

或强制重装：

    python -m pip install -U --force-reinstall pip

2.直接使用后面的提示命令

    也就是you should consider upgrading via the 后面的命令

3.使用命令

    python3 -m pipinstallpip==版本号

4.有时候有两个pip，如果是这种情况可以使用

    pip3 install--index-url https://pypi.douban.com/simple xxxx

如果使用镜像来安装库，比较常用的有<https://mirrors.tuna.tsinghua.edu.cn/help/pypi/> <https://pypi.mirrors.ustc.edu.cn/simple> 参见下面章节[PyPi使用国内源]

### pip 升级包

    pip install --upgrade 要升级的包名

### pip install 指定 github 位置

From PyPI:

    # Last released version:
    pip install pyqtgraph

    # Latest development version:
    pip install git+https://github.com/pyqtgraph/pyqtgraph@master

    # Latest development version:
    pip install git+git://github.com/pyqtgraph/pyqtgraph@master

From github:

    pip install git+ssh://git@github.com/seatgeek/fuzzywuzzy.git@0.17.0#egg=fuzzywuzzy
    pip install git+https://github.com/blampe/IbPy.git
    pip install https://github.com/blampe/IbPy/archive/master.zip

特定版本签出：

    pip install -e hg+https://foss.heptapod.net/openpyxl/openpyxl/@3.0#egg=openpyxl

From txt

    pip3 install -r requirements.txt

From conda

    Last released version: conda install -n myenv -c conda-forge pyqtgraph

To install system-wide from source distribution:

    python setup.py install
    Many linux package repositories have release versions.

To use with a specific project, simply copy the PyQtGraph subdirectory anywhere that is importable from your project.

### PyPI使用国内源

注意：

    如果是annconda内使用的pip或virtualenv使用的pip，先切换到对应的环境下，
    pip -V 看看路径，然后再更新pip

通过几次 pip 的使用，对于默认的 pip 源的速度实在无法忍受，于是便搜集了一些国内的pip源，如下：

    清华源说明 <https://mirrors.tuna.tsinghua.edu.cn/help/pypi/>

    Python官方 <https://pypi.python.org/simple>
    清华大学 <https://pypi.tuna.tsinghua.edu.cn/simple/>
    阿里云 <http://mirrors.aliyun.com/pypi/simple/>
    中国科技大学 <https://pypi.mirrors.ustc.edu.cn/simple/>
    豆瓣 <http://pypi.douban.com/simple>
    v2ex <http://pypi.v2ex.com/simple>
    中国科学院 <http://pypi.mirrors.opencas.cn/simple/>

cmd命令行，切换到你的环境下(conda/virtualenv等)执行

    # 临时使用国内镜像
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple flask

    # 设为默认
    # 升级 pip 到最新的版本 (>=10.0.0) 后进行配置：
    # sudo pip install pip -U
    sudo pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
    sudo pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

#### 在 Linux 和 macOS 中，用户配置需要写到 ~/.pip/pip.conf 中

    [global]
    index-url=http://mirrors.aliyun.com/pypi/simple/

    [install]
    trusted-host=mirrors.aliyun.com

## virtualenv 配置python环境

    https://docs.python-guide.org/dev/virtualenvs/

适合标准的python安装到windows上，原始 Python 的脚本更适合用cmd环境，而pip的有些脚本适合用bash做环境。

激活环境命令：

    # CMD
    c:/Users/xxx/pyenvs/py38/Scripts/activate.bat

    # bash
    source c:/Users/xxx/pyenvs/py38/Scripts/activate

命令行脚本（bat、sh）文件一键运行，详见下面的章节

创建虚拟环境

1.安装虚拟环境的第三方包 virtualenv

    pip install virtualenv
    pip install virtualenv -i https://pypi.python.org/simple/

    # 使用清华源安装：
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package

    # 升级 pip 到最新的版本 (>=10.0.0) 后进行配置：
    pip install pip -U
    # 临时使用本镜像站来升级 pip
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U

    # 设为默认
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

2.创建虚拟环境

    cd 到存放虚拟环境的地址

    在当前目录下创建名为myvenv的虚拟环境（如果第三方包virtualenv安装在python3下面，此时创建的虚拟环境就是基于python3的）
    virtualenv myvenv

    virtualenv -p /usr/local/bin/python2.7 myvenv2 参数 -p 指定python版本创建虚拟环境

    virtualenv --system-site-packages myvenv 参数 --system-site-packages 指定创建虚拟环境时继承系统三方库

3.激活/退出虚拟环境

    cd ~/myvenv 跳转到虚拟环境的文件夹

    source bin/activate 激活虚拟环境
    （windows cmd 下是 .\Scripts\activate， mintty下是 ./Scripts/activate）

    which pip 看是否使用了当前环境目录下的pip
    pip list 查看当前虚拟环境下所安装的第三方库

    deactivate 退出虚拟环境

4.删除虚拟环境

直接删除虚拟环境所在目录即可

### pip在virtualenv虚拟环境下不要使用 --user 参数

直接 pip install 就好了

    https://stackoverflow.com/questions/30604952/pip-default-behavior-conflicts-with-virtualenv

### Windows 命令行环境下使用脚本执行 Virtualenv

如果用cmd，则vs code使用的时候偶尔会有脚本报错……

用bash的问题是，用pip的时候偶尔有报错，最好切换回cmd环境，因为python的windows脚本都是按cmd环境开发的

windows下用mintty(bash)执行sh脚本自动执行环境和python程序，cmd命令行：

    "C:\Program Files\Git\git-bash.exe" --no-cd "C:\tools\pyenvs\yourprojectenv.sh"

#### Windows 命令行环境下 bash 的sh文件（virtualenv）

git-bash(mintty) 下执行，Windows 下只要安装了git直接双击sh文件就关联调用了。

```shell
#!/bin/sh
# env source export 只认识linux目录结构
source /c/tools/pyenvs/yourprojectenv/Scripts/activate
python /c/Users/xxxuser/pycode/yourproject/app.py

conda deactivate
read -n1 -p "Press any key to continue..."
```

#### Windows 命令行环境下 cmd 的bat文件（virtualenv）

cmd下执行

```cmd
@REM
call c:\tools\pyenvs\yourprojectenv\Scripts\activate.bat
python C:\Users\xxxuser\pycode\yourapp.py

pause
```

## python-xy

不再更新维护了，废弃
<https://python-xy.github.io/> 微软推荐的<https://devblogs.microsoft.com/python/unable-to-find-vcvarsall-bat>

## Linux 下安装 anaconda

1. 网站下载
2. bash xxxx.sh
3. 注意选择：添加到路径中!!! 这个跟windows下安装是不同的.
4. 安装完毕，重启Linux
5. python 看输出信息包含 anaconda 字样
   conda info
   conda list
6. 启动器终端运行：anaconda-navigator
-搜索计算机： visual studio code 或 conda
 或 终端运行：spyder

## Windows 安装 anaconda的初始设置

官方介绍 <https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html>

1.如果想让vs code自动找到，安装时的选项记得勾选“add Anaconda3 to the system PATH environment variable”

2.安装完毕后，先打开anaconda-navigator，切换到base环境，这货要执行一堆初始化工作，不是光setup.exe安装完了就行了。

3.换清华源 <https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/> 参见下面章节[conda频道和源配置]

conda 有很多频道，见章节[conda频道和源配置]

4.用管理员权限打开命令行工具，设置conda在哪个shell下使用（windows默认是cmd）

    # 支持bash、cmd.exe、powershell等，all是全部
    conda init --all

然后关闭命令行工具，以便生效。

5.安装代码格式化插件

    conda install yapf
    conda install Flake8

6.如果安装anaconda时没有勾选"add anaconda3 to the system PATH environment variable"加入到环境变量，vscode 无法找到python，则安装插件：Code Runner

7.python 填坑

    启动Python3.7，报如下错误
    File "C:\Anaconda3\lib\site-packages\pyreadline\lineeditor\history.py", line 82, in read_history_file
        for line in open(filename, 'r'):
    UnicodeDecodeError: 'gbk' codec can't decode byte 0x80 in position 407: illegal multibyte sequence

    https://github.com/pyreadline/pyreadline/issues/38
    Open file C:\Python351\lib\site-packages\pyreadline\lineeditor\history.py.
    Go to 82 line and edit: this - for line in open(filename, 'r'): on this -
        for line in open(filename, 'r', encoding='utf-8'):

    windows下python按[TAB]出现报错：
    AttributeError: module 'readline' has no attribute 'redisplay'

    pip install git+https://github.com/ankostis/pyreadline@redisplay
    https://github.com/pyreadline/pyreadline/pull/56
    https://github.com/winpython/winpython/issues/544

8.卸载 anaconda

<https://docs.anaconda.com/anaconda/install/uninstall/>

清理并备份~/.conda目录为.anaconda_backup

    conda install anaconda-clean
    anaconda-clean --yes

删除目录 envs and pkgs。

执行Windows添加删除程序里的anaconda卸载程序。或者ananconda文件夹里找到uninstall annaconda.exe。

9.卸载 vscode ，需要手动再做如下：
    C:\Users\xxx\AppData\Roaming\Code 目录清空
    C:\Users\xxx\.vscode 目录清空

## Anaconda 管理

注意： 见下面章节 [conda操作前务必先检查当前环境中 conda/pip/python的路径]

conda的环境操作类设置，因为要操作C:\ProgramData\Anaconda3，所以要用管理员权限执行annconda安装后自带的命令行工具，
如果单独打开windows的cmd窗口（管理员权限执行），则先执行 conda activate进入[base]环境。

注意：conda 命令在Windows下是一堆的bat文件，执行了各种变量设置和传递，在激活的base环境下执行其他命令，出现报错的概率小。

### 命令行工具使用conda环境

要确保在[base]环境下执行 conda 命令。

以前 conda 版本的 source activate 和 source deactivate 跟 virtualenv 环境的脚本经常路径冲突。conda 4.4之后激活和退出环境统一了命令用法，不用 source了，操作步骤如下：

    # 激活[base]环境
    conda activat

    # 切换到指定的[p37]环境
    conda activate p37

    # 退出当前环境，返回的是上一个环境。
    conda deactivate

仍需要用source的案例

    ssh连接该服务器使用 conda activate p36 命令激活环境后，
    未使用 conda deactivate 退出环境就关闭终端，
    再次 conda activate p36 会报错。

    解决具体操作如下：

        # 重新进入虚拟环境
        source activate

        # 重新退出虚拟环境
        source deactivate

        # 再正常进入conda环境
        conda activate p36

执行bat或sh文件，参见下面的章节 [Windows 下执行 conda 脚本]。

### conda init 命令设置命令行解释工具

设置conda在哪个shell下使用（windows下默认cmd.exe），这样可以使conda的各个命令脚本可以自动适应bash、cmd、powershell等。

    conda init bash  # 用户Home目录下.bash_profile文件中自动激活[base]环境

    conda init cmd.exe

    conda init powershell

    conda init --all  # 都绑定上

运行后记得关闭命令行工具，以便生效。

详情见

    conda init -h

怎么发现的？填坑呗！

    vscode 1.61 默认用bash而不是cmd，执行anaconda.2021.05 环境py3.7，
    偶然一打python进去发现python的提示是3.8版...

    原来是anaconda的bash脚本写的有问题，也不调试，直接屏蔽错误提示，
    导致指向py3.7环境的命令根本没成功，默认执行的base环境，找到py3.8去了，一点提示都没有！

查找路径的解释见下面的章节 [注意！Anaconda 用 pip 要修改配置文件]

### conda 包管理常用命令

    # update最新版本的conda
    conda update -n base conda
    conda update anaconda
    conda update anaconda-navigator

    # 创建python3.7的xxxx虚拟环境，新的开发环境会被默认安装在你 conda 目录下的 envs 文件目录下。
    conda create -n xxxx python=3.7

    # 复制一个虚拟环境
    conda create --name myclone --clone myenv

    # 显示所有的虚拟环境，当前虚拟环境前面有个星号
    conda info --envs  // 或 conda env list

    # 显示当前虚拟环境下安装的包
    conda list

    # 使用相对路径，在当前目录下建立一个虚拟环境，这样做的好处是只跟项目代码目录相关
    conda create --prefix ./condaenvs python=3.7
    conda activate ./condaenvs

    # 导出环境配置文件，便于定制
    conda env export > environment.yml

    # 根据指定的配置文件更新指定的虚拟环境
    conda env update --prefix ./env --file environment.yml  --prune

    ## 精确的可复现的安装环境
    conda list --explicit > spec-file.txt
    conda create --name myenv --file spec-file.txt
    conda install --name myenv --file spec-file.txt

    # 列出所有的环境，当前激活的环境会标*。
    conda info -e

    # 删除环境
    conda remove -n xiaolv --all

### 使用 conda install 要指定虚拟环境名

    # 在指定的频道搜索包名
    anaconda search -t conda tensorflow

    # 必须指定目的虚拟环境的名字 p37
    conda install -n p37 beautifulsoup4
    # 或
    conda install --name p37 beautifulsoup4  -y

    # 移除包
    conda remove beautifulsoup4

### 用conda复制虚拟环境到其他机器上

1.复制anaconda3/envs/下的某个环境的文件夹到另外一台机器上

    rsync -va username@ip.add.re.ss:/home/username/anaconda3/envs/copied_env/

2.用命令新建虚拟环境env2

    conda create --name env2 --clone /home/username/anaconda3/envs/copied_env/

### 安装特定版本的包

conda用“=”，pip用“==”

    conda install -n myenv  numpy=1.93

    pip  install numpy==1.93  # 注意先进入虚拟环境

#### conda频道和源配置

0.不同的conda频道，看看默认软件名在自己的os下对应的版本

    <https://anaconda.org/search?q=pyqtgraph>
    <https://anaconda.org/conda-forge/pyqtgraph>

conda 有很多频道，在网页版频道列表里有对应的版本，找合适自己的安装
注意不是名字对了就能装，版本不一定是新的！

    conda install -n myenv -c conda-forge pyqtgraph

1.查看 conda 版本

安装完成后按Win+R打开cmd终端，输入

    conda --version

2.添加国内源

按清华源的说明操作即可

    <https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/>

    <https://www.jianshu.com/p/ef1ae10ba950>

设置搜索时显示通道地址

    conda config --set show_channel_urls yes

3.升级 conda

设置完国内源后，升级 conda 的速度会快很多，之后安装包时也会从国内源下载。

    # 不行呢奇怪，用下面的这个升级了
    conda update conda

    # vs code 提示
    conda update -n base -c defaults conda

### conda 操作前，务必先检查当前环境中 conda/pip/python 的路径

我们需要判断目前我们用的pip指令，会把包装到哪里。因为pip不像conda一样，他不知道环境！pip 在路径里可能有多个，Windows单独安装的python自带，virtualenv环境自带，anaconda默认base环境自带，调用起来按PATH搜索的顺序，即使切换到了自己的环境下，也一定要看看。如: base环境的pip可能在/root/anaconda3/bin/pip，而其他conda环境的pip,可能在/root/anaconda3/envs/my_env/bin/pip。

要确保我们用的是本环境的pip，这样pip install时，包才会创建到本环境中。不然包会创建到[base]环境，供各个不同的其他conda环境共享，此时可能会产生版本冲突问题（不同环境中可能对同一个包的版本要求不同）。

用下面命令查看我们此时用的pip为哪个环境：

    # linux
    which -a pip

    # windows
    where pip

    # pip 自己
    pip -V

先切换到你的环境下，看看到底用的哪个 pip 和 python

    which pip  # bash，在 cmd.exe 下用 where
    pip -V  # 列出当前的pip的命令行位置，未必是在自己的环境下面的

    which python  # 确认是你的虚拟环境目录下的python
    python -V  # 版本
    python -m site  # pip指定的脚本和安装包的基础路径

#### bash 示例

    $ conda activate
    (base)
    $ conda activate p37
    (p37)


    $ which pip
    /c/Users/xxx/.conda/envs/p37/Scripts/pip
    (p37)

    $ where pip
    C:\Users\xxx\.conda\envs\p37\Scripts\pip.exe
    (p37)

    $ pip -V
    pip 21.2.4 from C:\Users\xxx\.conda\envs\p37\lib\site-packages\pip (python 3.7)
    (p37)

    $ which python
    /c/Users/xxx/.conda/envs/p37/python

    $ python -V
    Python 3.7.11

    $ conda info

        active environment : p37
        active env location : C:\Users\xxx\.conda\envs\p37
                shell level : 2
        user config file : C:\Users\xxx\.condarc
    populated config files : C:\Users\xxx\.condarc
            conda version : 4.11.0
        conda-build version : 3.21.6
            python version : 3.9.7.final.0
        virtual packages : __cuda=11.4=0
                            __win=0=0
                            __archspec=1=x86_64
        base environment : C:\ProgramData\Anaconda3  (read only)
        conda av data dir : C:\ProgramData\Anaconda3\etc\conda
    conda av metadata url : None
            channel URLs : https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/win-64
                            https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/noarch
                            https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r/win-64
                            https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r/noarch
                            https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2/win-64
                            https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2/noarch
            package cache : C:\ProgramData\Anaconda3\pkgs
                            C:\Users\xxx\.conda\pkgs
                            C:\Users\xxx\AppData\Local\conda\conda\pkgs
        envs directories : C:\Users\xxx\.conda\envs
                            C:\ProgramData\Anaconda3\envs
                            C:\Users\xxx\AppData\Local\conda\conda\envs
                platform : win-64
                user-agent : conda/4.11.0 requests/2.26.0 CPython/3.9.7 Windows/10 Windows/10.0.19044
            administrator : False
                netrc file : None
            offline mode : False

    $ python -m site

    sys.path = [
        'C:\\Users\\xxx',
        'C:\\Users\\xxx\\.conda\\envs\\p37\\python37.zip',
        'C:\\Users\\xxx\\.conda\\envs\\p37\\DLLs',
        'C:\\Users\\xxx\\.conda\\envs\\p37\\lib',
        'C:\\Users\\xxx\\.conda\\envs\\p37',
        'C:\\Users\\xxx\\.conda\\envs\\p37\\lib\\site-packages',
    ]
    USER_BASE: 'C:\\Users\\xxx\\AppData\\Roaming\\Python' (doesn't exist)
    USER_SITE: 'C:\\Users\\xxx\\AppData\\Roaming\\Python\\Python37\\site-packages' (doesn't exist)
    ENABLE_USER_SITE: True

#### cmd 示例

    C:\>conda activate
    (base) C:\>conda activate p37
    (p37)C:\>

    (p37) C:\>where pip
    C:\Users\xxx\.conda\envs\p37\Scripts\pip.exe

    (p37) C:\>where python
    C:\Users\xxx\.conda\envs\p37\python.exe

    (p37) C:\>python -V
    Python 3.7.11

    (p37) C:\>conda info

        active environment : p37
        active env location : C:\Users\xxx\.conda\envs\p37
                shell level : 2
        user config file : C:\Users\xxx\.condarc
    populated config files : C:\Users\xxx\.condarc
            conda version : 4.11.0
        conda-build version : 3.21.6
            python version : 3.9.7.final.0
        virtual packages : __cuda=11.4=0
                            __win=0=0
                            __archspec=1=x86_64
        base environment : C:\ProgramData\Anaconda3  (read only)
        conda av data dir : C:\ProgramData\Anaconda3\etc\conda
    conda av metadata url : None
            channel URLs : https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/win-64
                            https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/noarch
                            https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r/win-64
                            https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r/noarch
                            https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2/win-64
                            https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2/noarch
            package cache : C:\ProgramData\Anaconda3\pkgs
                            C:\Users\xxx\.conda\pkgs
                            C:\Users\xxx\AppData\Local\conda\conda\pkgs
        envs directories : C:\Users\xxx\.conda\envs
                            C:\ProgramData\Anaconda3\envs
                            C:\Users\xxx\AppData\Local\conda\conda\envs
                platform : win-64
                user-agent : conda/4.11.0 requests/2.26.0 CPython/3.9.7 Windows/10 Windows/10.0.19044
            administrator : False
                netrc file : None
            offline mode : False

    (p37) C:\>python -m site

        sys.path = [
            'C:\\Windows\\system32',
            'C:\\Users\\xxx\\.conda\\envs\\p37\\python37.zip',
            'C:\\Users\\xxx\\.conda\\envs\\p37\\DLLs',
            'C:\\Users\\xxx\\.conda\\envs\\p37\\lib',
            'C:\\Users\\xxx\\.conda\\envs\\p37',
            'C:\\Users\\xxx\\.conda\\envs\\p37\\lib\\site-packages',
        ]
        USER_BASE: 'C:\\Users\\xxx\\AppData\\Roaming\\Python' (doesn't exist)
        USER_SITE: 'C:\\Users\\xxx\\AppData\\Roaming\\Python\\Python37\\site-packages' (doesn't exist)
        ENABLE_USER_SITE: True

USER_BASE 决定了当前环境的Python的启动程序及pip等脚本的位置。

USER_SITE 决定了当前环境的site-packages默认安装路径。

当前环境下这俩变量位于配置文件 C:\Users\xxx\.conda\envs\p37\Lib\site.py中， 区别于是否安装了anaconda，执行的pip是否不同，而且受变量 ENABLE_USER_SITE 控制。 参见下面章节 [注意！Anaconda 用 pip 要修改默认安装依赖包路径的配置文件 ]

### Windows 下执行 conda 脚本

在windows的命令行脚本环境下，第一次运行 conda activate 是激活[base]环境，
然后再次执行 conda activate p37 以切换到指定的环境。

也就是说，确保你执行的conda命令都是在[base]环境下，就不会报错找不到啥的。

#### Windows 下执行 conda 脚本的 bat 文件

cmd下执行

```cmd
@rem anaconda 命令行执行
@rem C:\ProgramData\Anaconda3\Scripts\activate
@rem conda activate xdhj

@rem --------------------------------------------------
@rem anaconda 脚本执行
call C:\ProgramData\Anaconda3\condabin\conda.bat activate p37

@rem --------------------------------------------------
python C:\Users\your_name\pycode\your_project\app.py

pause
```

#### Windows 下执行 conda 脚本的 的 sh 文件

用bash执行conda脚本需要设置conda init 以支持bash，详见上面章节[conda init 命令设置命令行解释工具].
只要安装了 git 直接双击sh文件就关联git-bash(mintty)调用了。

```shell
#!/bin/sh
# env source export 只认识linux目录结构
/c/ProgramData/Anaconda3/condabin/conda.bat activate

conda activate p37
python /c/Users/your_name/pycode/your_project/app.py

conda deactivate
read -n1 -p "Press any key to continue..."
```

如果需要显示中文需要修改配置文件 ~\.minttyrc，详见 [mintty(bash)] <gnu_tools.md>

## Anaconda 环境中使用 pip

官方介绍 <https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#using-pip-in-an-environment>

更改Python的 pip install 默认安装依赖路径方法详解 <https://blog.csdn.net/woyizhizaizhaoni/article/details/102954067>

### 不要在base环境下使用pip

conda默认的把这个base环境视为root的，其他环境都是在这个环境之上建立链接。如果在这里用了pip安装，环境大概率乱了。

### 先conda，然后pip

如果用过pip了，就不要再用conda，否则也是容易搞乱环境。
如果后续又想装新的包了，就再建个环境，还是先用conda，后pip。

这样说来，装完了就不要删，宁可重建，什么 conda remove/pip uninstall 都别用了。

### pip install 不用使用参数 --user

如果pip在安装时候提示权限不足，无法写入啥的，提示用“--user”，不要用！不然会写入到所有用户文件夹下面，即安装到公用包目录中了！原因见下面章节 [注意！Anaconda 用 pip 要修改默认安装依赖包路径的配置文件]

### 为什么anaconda环境中，还需要用pip安装包

<https://www.cnblogs.com/zhangxingcomeon/p/13801554.html>

尽管在anaconda下我们可以很方便的使用conda install来安装我们需要的依赖包，但是anaconda本身只提供部分包，远没有pip提供的包多，有时conda无法安装我们需要的包，我们需要用pip将其装到conda环境里。

另一个原因是，我们自己创建的conda环境里，可能没有pip：导致默认使用base环境的pip，有产生版本冲突的可能。

安装好本环境的pip之后，在本环境中使用pip install安装的包，就只在本环境的conda中了。我们可以切换到自己的虚拟环境，然后用conda list查看包的清单。其中，使用pip安装的包，conda list结果中的build项目为pypi。

在自己conda环境安装pip使用如下命令：

    conda install  -n myenv pip
    conda activate myenv
    pip <pip_subcommand>

### 注意！Anaconda 用 pip 要修改默认安装依赖包路径的配置文件

执行 python -m site，（参见前面章节[conda 操作前，务必先检查当前环境中 conda/pip/python 的路径]）。

检查变量 USER_BASE、USER_SITE，如果不是指向你自己的环境，可以执行下列操作。

想要做到 Anaconda 中不同环境互相不干涉，只建好了新环境，这是不够的！

需要再修改各自环境中的配置文件！

另一个说法

    <https://blog.csdn.net/qq_37344125/article/details/104418636>

假设Anaconda3安装完成后建立的默认环境[base]，python版本是3.7，
路径 C:\ProgramData\Anaconda3 下面的Scripts目录是pip等命令，Lib\site-packages是安装好的包

新建个环境[p36]，python版本是3.6，
路径 C:\Users\xxx\.conda\envs\p36 （给所有用户安装是在 C:\ProgramData\Anaconda3\envs\p36）下面的Scripts目录是pip等命令，Lib\site-packages是安装好的包

    activate p36
    # 会装到 [base]下  ！！！
    pip install numpy

环境[p36]必须改配置文件 C:\Users\xxx\.conda\envs\p36\Lib\site.py

    USER_SITE = None
    USER_BASE = None
    # 改为  （给所有用户安装是在 C:\ProgramData\Anaconda3\envs\p36）
    USER_SITE = "C:\\Users\\xxx\\.conda\\envs\\p36\\Lib\\site-packages"
    USER_BASE = "C:\\Users\\xxx\\.conda\\envs\\p36\\Scripts"

咋办啊坑这么多没法填，anaconda只能多建一个环境，这个应该是不跟其它环境混的（只跟base混）：

    在anaconda.2021.5安装后，建立了一个py3.8的环境，后来建第二个py3.7的环境，
    改文件site.py时发现，居然用的是第一个的！
    我说我的anaconda建了几个版本之后的环境喜欢乱套呢，他自己就乱引用啊……

    我把前两个环境删除了，关了anaconda然后打开，又建了个不同名的py3.7环境，里面的内容居然是之前的！

## anaconda怎么同时安装2.7和3.6？

前提是你的anaconda最高支持到3.7，才可以任意选择低版本的。

如果你已经安装了Anaconda Python3.6版，想要再安装Python2.7环境，在命令行中输入：

    conda create -n python27 python=2.7

想要使用python2.7环境同样需要命令

    activate python27（这里面的python27是前面create时自己定义的名字），

该条命令在linux和mac环境中使用

    source activate python27 。

接下来看到命令行的最前端多出来(python27)，这时候已经处在python2.7的环境中了。

想要退出python2.7进入python3.6，需要再次键入命令deactivate（linux和mac下用source deactivate命令）。

### 最显着的区别可能是这样的

pip在任何环境中安装python包;
conda安装在conda环境中装任何包。

    pip install 的各种问题  https://www.cnblogs.com/feixiablog/p/8320602.html

## 在ubuntu系统配置多python环境

### ubuntu16.04自带python的版本

既有python2.7，又有python3.5

但是默认的python命令是python2.7，我要想执行python3就必须输入python3

    输入命令sudo apt-get install python3.7

    按Y确认

    调整Python3的优先级，使得3.7优先级较高

    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1

    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2

    更改默认值，python默认为Python2，现在修改为Python3

    sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 100

    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 150

### ubuntu如何安装自己版本的python

1.安装ubuntu 17.10 桌面版64位系统
2.系统已内置安装了python2.7和python3.6版本
    python执行路径为:/usr/bin/python2 /usr/bin/python3
    如果没有安装对应的版本，可执行以下命令安装
    sudo apt-get install python2.7 python2.7-dev
    sudo apt-get install python3.6 python3.6-dev
3.安装pip，根据不同的python版本，可以执行
    sudo apt install python-pip
    sudo apt install python3-pip
4.使用对应版本的pip安装virtualenv，使用哪个版本的pip安装，则virtualenv默认环境为哪个版本
    pip install virtualenv
    pip3 install virtualenv
5.创建对应版本的virtual env
    virtualenv -p /usr/bin/python2 ~/.venv/python2
    virtualenv -p /usr/bin/python3 ~/.venv/python3
6.使用时，激活对应环境的activate
    source ~/.venv/python2/bin/activate
    source ~/.venv/python3/bin/activate
7.退出环境，使用 deactivate

## Centos 7 源码安装 python3.7+ 含 pip3 实现多版本共存 (不替换老版本新装的方法 )

因为Centos 7 自带的python是2.7.5，而yum安装的python3是3.6.8，所以手动下载源代码安装python3.7为最新的3.7.5

1.到官网下载源码

    cd /usr/src
    sudo wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz
    sudo xz -d Python-3.7.3.tar.xz
    sudo tar -xf Python-3.7.3.tar

2.解决个zlib库找不到报错的问题 No module named zlib found

<https://stackoverflow.com/questions/10654707/no-module-named-zlib-found>
<https://stackoverflow.com/questions/6169522/no-module-named-zlib>
<https://ubuntuforums.org/showthread.php?t=1976837>

在python的源代码修改setup.py中查找如下代码段：
lib_dirs = self.compiler.library_dirs + [
'/lib64', '/usr/lib64',
'/lib', '/usr/lib',
]
添加个 '/usr/lib/x86_64-linux-gnu' 或 /usr/lib/i386-linux-gnu

3.运行命令：

    sudo yum update -y

    # 开发环境
    sudo yum -y groupinstall "Development Tools"
    #sudo yum  -y install gcc

    # 依赖包
    sudo yum -y install openssl-devel bzip2-devel libffi-devel

    # 再加几个依赖包防止报错：
    #    import pandas UserWarning: Could not import the lzma module. Your installed Python is incomplete
    #       https://stackoverflow.com/questions/57743230/userwarning-could-not-import-the-lzma-module-your-installed-python-is-incomple
    yum install -y xz-devel
        还是不行？ 0.25.1之前的版本不行，安装最新版pandas
            https://stackoverflow.com/questions/57113269/import-pandas-results-in-modulenotfounderror-lzma

    ./configure --enable-optimizations
    make altinstall （注意命令 make install 会替换默认的python3）

4.验证：
python --version
python3 --version
python3.7 --version

## Ubuntu16.04 源码安装 python3.7+ 含 pip3 实现多版本共存 (不替换老版本新装的方法 )

ubuntu16 上自带python2 (2.7.12)和python3 (3.5.2)，而apt-get install python 安装的是3.6，所以手动下载源代码安装python3.7为最新的3.7.5

未测试：用apt-get install安装指定版本的软件
    # 查看可用版本并安装指定版本
    sudo apt-get update
    aptitude versions apache2
    sudo apt-get install apache2=2.2.20-1ubuntu1

未测试：清除之前安装的python3
    sudo apt-get purge python3

1.到官网下载源码

    cd /usr/src
    sudo wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz
    sudo xz -d Python-3.7.3.tar.xz
    sudo tar -xf Python-3.7.3.tar

2.解决个zlib库找不到报错的问题 的问题

  No module named zlib found

      https://stackoverflow.com/questions/10654707/no-module-named-zlib-found
      https://stackoverflow.com/questions/6169522/no-module-named-zlib
      https://ubuntuforums.org/showthread.php?t=1976837

3.在python的源代码修改setup.py中查找如下代码段：

    lib_dirs = self.compiler.library_dirs + [
    '/lib64', '/usr/lib64',
    '/lib', '/usr/lib',
    ]
    添加个 '/usr/lib/x86_64-linux-gnu' 或 /usr/lib/i386-linux-gnu

或

    sudo apt-get install zlib1g-dev
    假如出现->“Ubuntu ：zlib1g-dev依赖: zlib1g (= 1:1.2.8.dfsg-2ubuntu4) 但是 1:1.2.8.dfsg-2ubuntu4.1 正要被安装” 的问题，解决办法：
    图形界面的桌面下，点击“软件和更新”，选择选项卡“更新”，勾选前两个选项，安装重要的和可选的更新。
    然后，sudo apt-get update
            sudo apt-get upgrade
            sudo apt-get install zlib1g-dev

4.依赖包：

    sudo apt-get install update
    sudo apt-get install build-essential checkinstall
    sudo apt-get install libreadline-gplv2-dev libncursesw5-dev libssl-dev \
        libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev

4.1 补充依赖包

    import pandas UserWarning: Could not import the lzma module. Your installed Python is incomplete
        https://stackoverflow.com/questions/57743230/userwarning-could-not-import-the-lzma-module-your-installed-python-is-incomple

    sudo apt-get install  lzma
    sudo apt-get install  liblzma-dev
        还是不行？ 0.25.1之前的版本不行，安装最新版pandas
            https://stackoverflow.com/questions/57113269/import-pandas-results-in-modulenotfounderror-lzma

4.2 补充依赖包

注意：  <https://stackoverflow.com/questions/12806122/missing-python-bz2-module>

        linux下使用官方source release安装会出现问题 ModuleNotFoundError: No module named '_bz2'，
            需要 sudo apt-get install libbz2-dev
        解决 sudo apt-get install E: 无法定位软件包
            在 etc/apt 下的sources.list添加镜像源：deb http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse  sudo apt-get update

5.配置安装位置 配置优化：

(make altinstall is used to prevent replacing the default python binary file /usr/bin/python.)

6.安装，而不是替换

    cd Python-3.7.3
    sudo ./configure --prefix=/usr/local/python37 --enable-optimizations
    sudo make altinstall  （注意命令 make install 会替换默认的python3）

7.验证：

    $python3.7 -V

8.安装pip

    sudo apt install python3-pip

## Installing Pip for Python 3 on Ubuntu 18.04

<https://phoenixnap.com/kb/how-to-install-pip-on-ubuntu>

comes with Python 3 installed by default, but it does not come with pip.

### To install pip for Python 3 on Ubuntu 18.04

1.Open the terminal.
The simplest way is to right-click on the desktop and select Open Terminal from the drop-down menu.

2.Update the repository package list by running the following command in the terminal:

    sudo apt update

3.Install pip for Python 3 and all the dependencies for building Python modules by running the following command:

    sudo apt install python3-pip

4.The package installs quickly. To verify the install run the following command:

    pip3 -–version

The installed version might be different for you, but the general output should resemble the line below:

    OUTPUT

    pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)

5.To upgrade pip3 to the latest version, you would issue the --upgrade command just like for any other PyPI package:

    sudo pip3 install --upgrade pip

6.Install Pip for Python 2

### To install pip for Python 2 on Ubuntu 18.04

1.Open the terminal. The simplest way is to use the CTRL+ALT+T shortcut.

2.Update the repository package list by running the following command:

    sudo apt update

3.Install pip for Python 2 and all the dependencies for building Python modules by running:

    sudo apt install python-pip

4.To verify the install run the following command:

    sudo pip –version

At the time of writing this article, the latest version of Pip is 9.0.1, but this may vary.

    OUTPUT
    pip 9.0.1 from /usr/lib/python2.7/dist-packages (python 2.7)

5.This step is optional but highly recommended. Namely, you can install a required file that contains all the packages that can be installed with pip. To install the requirements contained in requirements.txt, run the following command:

    sudo pip install -r requirements.txt

6.To upgrade pip for Python 2 to the latest version, run the --upgrade command:

    sudo pip install --upgrade pip

## 外网访问内网使用ssh和远程桌面

<https://github.com/microsoft/vscode-docs/blob/master/remote-release-notes/v1_37.md>

## VS Code 插件

插件的安装位置为 C:\Users\你的用户名\.vscode\extensions

### 快速解析python，代码自动完成更快

pylance

### 格式化 yapf

    用conda安装的这个直接带二进制包：
    conda install --name p37 yapf -y

    yapf 用这个，禁用 # yapf:disable 代码块  #yapf:enable 或 某行后面的注释 # yapf:disable 禁用一行
    "python.formatting.provider": "yapf",
    "python.formatting.yapfArgs": [
        // "--sytle=yapf_style.cfg"
    ],

### 代码检查 flake8

    flake8 用这个 可以在要忽略 flake8 检查的那一行加上 # noqa 注释即可
    整个文件禁用的话，在文件第一行 # flake8: noqa

    "python.linting.enabled": true,
    "python.linting.pylintEnabled": false,
    "python.linting.flake8Enabled": true,
    "python.linting.flake8Args": [
        "--max-line-length=100",
        // "--ignore=E501, E262",
    ],

### 代码测试 unittest

    单元测试不要用pytest，老老实实用系统的unittest
    如果用pytest ，虽然兼容unittest，不需要写子类也可以的。但是：记得在项目跟目录放个空文件 conftest.py
    https://stackoverflow.com/questions/10253826/path-issue-with-pytest-importerror-no-module-named-yadayadayada/50610630#50610630

### 高亮空格并消除

    Trailing Spaces

### 正则表达式预览

    LouisWT.regexp-explain
        RegExp Preview and Editor : le0zh.vscode-regexp-preivew （废弃了）

### 查看sqllite数据库

    sqlite (alexcvzz.vscode-sqlite)

    优选工具
        DB Browser for SQLite <https://github.com/sqlitebrowser/sqlitebrowser>
        SQLiteStudio <https://github.com/pawelsalawa/sqlitestudio>

### 远程开发： Remote Development  装这一个就会自动装一堆

    打开远程ssh文件夹后，各插件不可用？ 删除服务器上的 ~/.vscode-server 目录，重新安装插件
    Extension not working on remote SSH?  Remove directory ~/.vscode-server
    https://github.com/microsoft/vscode-remote-release/issues/1443

### 不要用AI代码完成的插件

全都把你的代码上传服务器了，包括Visual Studio IntelliCode // "python.jediEnabled": false,

### 自动添加函数头说明 Python Docstring Generator

    "autoDocstring.docstringFormat": "numpy",

### 括号匹配 Bracket Pair Colorizer 2

    // vscode 1.60+ 自带了 "editor.bracketPairColorization.enabled": true,

    "bracket-pair-colorizer-2.colors": [
        "rgba(213,135,32,255)",
        "rgba(62,145,222,255)",
        "rgba(18,230,155,255)"
    ],

### PYQT Integration

    "pyqt-integration.qtdesigner.path": "C:\\ProgramData\\Anaconda3\\Lib\\site-packages\\pyqt5_tools\\designer.exe",
    "pyqt-integration.pyuic.compile.filepath": "..\\uicode\\Ui_${ui_name}.py",
    "pyqt-integration.pyrcc.compile.filepath": "..\\uicode\\${qrc_name}_rc.py",

### GitLens

### Git History

### 护眼主题

MacOS Modern Theme
GitHub Theme
Solarized Light（自带）  这个是羊皮纸底色，去蓝光了

### GitHubcdn加速

jsdelivr  <https://cdn.jsdelivr.net/gh/xxx>

### JScript/Json的格式化，比系统自带的好用

Prettier - Code formatter

### Prettify JSON

    格式化json文件很好用，容错率高

### pyreverse

pylint里自带

        pyreverse -ASmy -o png your/

### Draw.io Integration

### UMLet 简单好用的UML流程图

Free UML Tool for Fast UML Diagrams 生成一个".uxf"文件打开即可使用

### vscode-mindmap 脑图

json文件格式节点图。生成一个".km"文件打开即可使用

### Graphviz Dot文件查看

Graphviz Interactive Preview 支持路线高亮
    F1命令呼叫预览

    https://github.com/tintinweb/vscode-interactive-graphviz

Graphviz (dot) language support for Visual Studio Code 语法高亮，可生成Html代码
    右键菜单呼叫预览

    https://github.com/joaompinto/vscode-graphviz

### MarkDown

    Markdown All in One 高亮，预览

    markdownlint 语法检查

    xlthu.pangu-markdown 中文英文之间加入空格，所谓“盘古空白”

### shell-format

    shell 脚本语法高亮

### TODO TREE

    "todo-tree.general.tags": [
        "TODO",
        "FIXME",
        "XXX",
        "NOTE"
    ],
    "todo-tree.highlights.customHighlight": {
        "TODO": {
            "icon": "tasklist",
            "iconColour": "magenta",
            "background": "#D0FFFF",
            "type": "tag"
        },
        "FIXME": {
            "icon": "eye",
            "iconColour": "red",
            "background": "#D0FFFF",
            "type": "tag"
        },
        "XXX": {
            "icon": "beaker",
            "iconColour": "pink",
            "background": "#D0FFFF",
            "type": "tag"
        },
        "NOTE": {
            "icon": "info",
            "iconColour": "blue",
            "background": "#D0FFFF",
            "type": "tag"
        }
    },
    "todo-tree.general.statusBar": "tags",
    "todo-tree.tree.grouped": true,

### csv文件查看

    Rainbow CSV 设置颜色区分：
    // rainbowCsv https://github.com/mechatroner/vscode_rainbow_csv/blob/master/test/color_customization_example.md#colors-customization
    "editor.tokenColorCustomizations": {
        "textMateRules": [
            {
                "scope": "rainbow1",
                "settings": {
                   "foreground": "#E6194B"
                }
            },
            {
                "scope": "keyword.rainbow2",
                "settings": {
                   "foreground": "#3CB44B",
                   "fontStyle": "bold"
                }
            },
            {
                "scope": "entity.name.function.rainbow3",
                "settings": {
                   "foreground": "#ff9b19",
                }
            },
            {
                "scope": "comment.rainbow4",
                "settings": {
                   "foreground": "#0082C8",
                   "fontStyle": "underline"
                }
            },
            {
                "scope": "string.rainbow5",
                "settings": {
                   "foreground": "#FABEBE"
                }
            },
            {
                "scope": "variable.parameter.rainbow6",
                "settings": {
                   "foreground": "#46F0F0",
                   "fontStyle": "bold"
                }
            },
            {
                "scope": "constant.numeric.rainbow7",
                "settings": {
                   "foreground": "#F032E6",
                }
            },
            {
                "scope": "entity.name.type.rainbow8",
                "settings": {
                   "foreground": "#008080",
                   "fontStyle": "underline"
                }
            },
            {
                "scope": "markup.bold.rainbow9",
                "settings": {
                   "foreground": "#F58231"
                }
            },
            {
                "scope": "invalid.rainbow10",
                "settings": {
                   "foreground": "#bace09"
                }
            }
        ]
    },

### 性能分析

runsnakerun 可惜了只能在python2下面运行

<http://www.vrplumber.com/programming/runsnakerun/>

For Debian/Ubuntu distributions the prerequisite setup looks like this:

    apt-get install python-profiler python-wxgtk2.8 python-setuptools

RunSnakeRun and SquareMap will install well in a VirtualEnv
if you would like to keep them isolated (normally you do not want to use the --no-site-packages flag if you are doing this).
I recommend this approach rather than using easy_install directly on your Linux/OS-X host.

virtualenv runsnake
source runsnake/bin/activate

### vscode python多线程调试的坑

    # https://code.visualstudio.com/docs/python/debugging#_troubleshooting
    # If you're working with a multi-threaded app that uses native thread APIs (such as the Win32 CreateThread function rather than the Python threading APIs), it's presently necessary to include the following source code at the top of whichever file you wish to debug:

    # import debugpy
    # debugpy.debug_this_thread()
    # Next steps#

    import ptvsd at the top and add this to the thread function, ptvsd.debug_this_thread()

    schperplata commented on 11 Apr 2019
    @karthiknadig Is there a plan to support such cases where the library uses native thread APIs (Kernel32!CreateThread, pthread_create, etc) instead of the python threading APIs. by default, or is this just the way it is going to be (or can't be different)?

    Thanks for your solution anyway.

    @karthiknadig
    Member
    karthiknadig commented on 11 Apr 2019
    We have plans to support native threads. We have not gotten around to it yet :)
    https://github.com/Microsoft/ptvsd/issues/305
