# python

## Windows 7 最高只能使用 Python3.8

windows下的python，各种命令的脚本都是cmd下的bat，如果用bash运行这些命令，有时候会出现各种提示报错信息。
推荐windows下的python使用cmd做命令行。

## pip

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

### 国内开源镜像

    清华 <https://mirrors.tuna.tsinghua.edu.cn/>

### pip版本更新

1.pip直接更新

    pip install --upgrade pip

    pip3 install --user --upgrade pip

    python -m pip install --upgrade pip

失败的话，首先查看windows下使用cmd环境，并检查下环境变量，which看下命令指向，是否有conda环境冲突了。windows下，如果是干净的python环境，不使用bash切换到cmd下，直接pip是可以的。

或强制重装：

    python -m pip install -U --force-reinstall pip

如果您到 pip 默认源的网络连接较差，临时使用本镜像站来升级 pip：

    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U

2.直接使用后面的提示命令

    也就是you should consider upgrading via the 后面的命令

3.使用命令

    python3 -m pipinstallpip==版本号

4.有时候有两个pip，如果是这种情况可以使用

    pip3 install--index-url https://pypi.douban.com/simple xxxx

这个是使用镜像来安装库，比较常用的有

    清华：<https://mirrors.tuna.tsinghua.edu.cn/help/pypi/>

    中国科学技术大学：<https://pypi.mirrors.ustc.edu.cn/simple>

### pip 升级包

    pip install --upgrade 要升级的包名

### pip github

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

    Last released version: conda install -c conda-forge pyqtgraph

To install system-wide from source distribution:

    python setup.py install
    Many linux package repositories have release versions.

To use with a specific project, simply copy the PyQtGraph subdirectory anywhere that is importable from your project.

## virtualenv 配置pip环境

适合标准的python安装到windows上，原始python的脚本更适合用cmd环境，而pip的有些脚本适合用bash做环境。
激活环境：

    CMD: c:/Users/xxx/pyenvs/py38/Scripts/activate.bat
    bash：source c:/Users/xxx/pyenvs/py38/Scripts/activate

命令行bat文件一键运行

    cmd /k "c:/Users/xxx/pyenvs/py38/Scripts/python.exe c:/Users/xxx/pycode/aaa.py" | CMD /k "c:/Users/xxx/pyenvs/py38/Scripts/activate.bat"

创建虚拟环境

1.安装虚拟环境的第三方包 virtualenv

    pip install virtualenv

    # 使用清华源安装：
    pip install virtualenv -i https://pypi.python.org/simple/

2.创建虚拟环境

    cd 到存放虚拟环境的地址

    在当前目录下创建名为myvenv的虚拟环境（如果第三方包virtualenv安装在python3下面，此时创建的虚拟环境就是基于python3的）
    virtualenv myvenv

    virtualenv -p /usr/local/bin/python2.7 myvenv2 参数 -p 指定python版本创建虚拟环境

    virtualenv --system-site-packages myvenv 参数 --system-site-packages 指定创建虚拟环境时继承系统三方库

3.激活/退出虚拟环境

    cd ~/myvenv 跳转到虚拟环境的文件夹

    source bin/activate 激活虚拟环境
    （windows下是 .\Scripts\activate ）

    which pip 看是否使用了当前环境目录下的pip
    pip list 查看当前虚拟环境下所安装的第三方库

    deactivate 退出虚拟环境

4.删除虚拟环境

直接删除虚拟环境所在目录即可

### pip在virtualenv虚拟环境下不要使用 --user 参数

直接 pip install 就好了

    https://stackoverflow.com/questions/30604952/pip-default-behavior-conflicts-with-virtualenv

### vscode 使用bash适应 virtualenv

如果用cmd，则vscode使用的时候偶尔会有脚本报错……
用bash的问题是用pip的时候，最好切换回cmd环境，因为python的windows脚本都是按兼容cmd写的……

    source c:/tools/pyenvs/btcgoenv/Scripts/activate

## Anaconda 安装和管理

<https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/>
<https://www.jianshu.com/p/ef1ae10ba950>

在windows上用cmd做脚本环境，如果使用bash，自带命令会提示各种错误信息。

### 注意windows下的Anaconda需要使用cmd环境运行而不是bash

    目前版本的都是bat，在bash下运行经常报错，
    尤其是vscode，他的开发默认都是在bash的，各种source xxx之后运行，在cmd下的命令报错概率大。

### conda pip

首先切换到你的环境

    /c/ProgramData/Anaconda3/Scripts/activate venv/conda

conda 有很多频道，在网页版频道列表里有对应的版本，找合适自己的安装
注意不是名字对了就能装，版本不一定是新的！

    conda install -c conda-forge pyqtgraph

pip用之前先which pip 看看位置，防止不是你的环境的pip，用了就装到别的地方了

    yourenv/Scripts/pip.exe install pyqt5-tools~=5.15

<https://pypi.org/project/pyqt5-tools/>
The ~=5.15 specifies a release compatible with 5.15 which will be
the latest version of pyqt5-tools built for PyQt5 5.15.
If you are using a different PyQt5 version, specify it instead of 5.15.

### conda配置

0.不同的conda频道，看看默认软件名在自己的os下对应的版本

    <https://anaconda.org/search?q=pyqtgraph>
    <https://anaconda.org/conda-forge/pyqtgraph>

1.查看 conda 版本
安装完成后按Win+R打开cmd终端，输入

    conda --version

2.添加国内源
查看现有源

    conda config --show-sources

添加国内清华源

    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/

    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/

删除默认源

    conda config --remove channels defaults

设置搜索时显示通道地址

    conda config --set show_channel_urls yes

3.升级 conda
设置完国内源后，升级 conda 的速度会快很多，之后安装包时也会从国内源下载。

    conda update conda

### 配置python环境

1. 查看 Python 版本
python --version

2. 创建环境
上一步查到我电脑上的 Python 版本为 3.7.0 ，我想在这个版本基础上创建一个名为 xnhj 的虚拟环境。

conda create -n xnhj python=3.7.0

新的开发环境会被默认安装在你 conda 目录下的 envs 文件目录下。

3.激活环境

    # 原 activate xnhj
    conda activate xnhj

windows cmd下：

    C:/ProgramData/Anaconda3/Scripts/activate
    conda activate xnhj

4.列出所有的环境

    conda info -e

当前激活的环境会标*。

5.切换到另一个环境

    conda activate xnhj

6.注销当前环境

    conda deactivate

7.复制环境

    conda create -n xiaolv --clone xnhj

8.删除环境

    conda remove -n xiaolv --all

### 用conda复制虚拟环境到其他机器上

1.复制anaconda3/envs/下的某个环境的文件夹到另外一台机器上

    rsync -va username@ip.add.re.ss:/home/username/anaconda3/envs/copied_env/

2.用命令新建虚拟环境env2

    conda create --name env2 --clone /home/username/anaconda3/envs/copied_env/

### conda 包管理

1. 查看已安装包

    conda list

2. 使用 Conda 命令安装包

    conda install beautifulsoup4

3. 通过 pip 命令来安装包，如果无法通过conda安装，可以用pip命令来安装包。详见下面章节[anaconda环境中使用pip]

    pip install beautifulsoup4

4. 移除包

    conda remove beautifulsoup4

## anaconda环境中使用pip

为什么anaconda环境中，还需要用pip安装包，此情况下用pip需要哪些注意项
<https://www.cnblogs.com/zhangxingcomeon/p/13801554.html>

1、在anaconda下用pip装包的原因：尽管在anaconda下我们可以很方便的使用conda install来安装我们需要的依赖，但是anaconda本身只提供部分包，远没有pip提供的包多，有时conda无法安装我们需要的包，我们需要用pip将其装到conda环境里。

2、用pip装包时候需要哪些注意事项？

首先，我们需要判断目前我们用的pip指令，会把包装到哪里，通常情况下，pip不像conda一样，他不知道环境，我们首先要确保我们用的是本环境的pip，这样pip install时，包才会创建到本环境中，不然包会创建到base环境，供各个不同的其他conda环境共享，此时可能会产生版本冲突问题（不同环境中可能对同一个包的版本要求不同）。

用下面命令查看我们此时用的pip为哪个环境：

    which -a pip

如base环境的pip可能在/root/anaconda3/bin/pip,,,,而其他conda环境的pip,可能在/root/anaconda3/envs/my_env/bin/pip。

经试验，anaconda4.8版本，在conda create新的环境时，已经默认在新环境装了pip，此时source activate进入该环境后，用pip命令安装的包，默认会装在本环境中,不必担心pip一个包后后会将其他环境的包改变版本的情况。

当然我们自己创建的conda环境里，可能没有pip，此时进入自己的conda环境也会默认用base环境的pip，这就需要我们自己将pip安装入本环境，尽量不要使用base的pip在其他环境装包，这样也会装在base里，有产生版本冲突的可能（上文已讲）。

在自己conda环境安装pip使用如下命令：

　　　　（进入环境后）
　　　　 conda install pip

安装好本环境的pip之后，在本环境中使用pip install安装的包，就只在本conda中了，
我们可以用conda list查看我们的包，同时pip安装的包，conda list结果中的build项目为pypi......

## python-xy

不再更新维护了，废弃
<https://python-xy.github.io/> 微软推荐的<https://devblogs.microsoft.com/python/unable-to-find-vcvarsall-bat>
