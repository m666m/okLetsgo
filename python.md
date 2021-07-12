# python

## wheels

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

### Windows 7 最高只能使用 Python3.8

## conda pip

首先切换到你的环境 venv/conda

conda 有很多频道，在网页版频道列表里有对应的版本，找合适自己的安装
注意不是名字对了就能装，版本不一定是新的！

    conda install -c conda-forge pyqtgraph

pip用之前先which pip 看看位置，防止不是你的环境的pip，用了就装到别的地方了

    yourenv/Scripts/pip.exe install pyqt5-tools~=5.15

<https://pypi.org/project/pyqt5-tools/>
The ~=5.15 specifies a release compatible with 5.15 which will be
the latest version of pyqt5-tools built for PyQt5 5.15.
If you are using a different PyQt5 version, specify it instead of 5.15.

## Anaconda 安装和管理

<https://www.jianshu.com/p/ef1ae10ba950>


### conda配置

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
上一步查到我电脑上的 Python 版本为 3.7.0 ，我想在这个版本基础上创建一个名为xiaolvshijie的虚拟环境。

conda create -n xiaolvshijie python=3.7.0

新的开发环境会被默认安装在你 conda 目录下的 envs 文件目录下。

3.激活环境

    activate xiaolvshijie

4.列出所有的环境

    conda info -e

当前激活的环境会标*。

5.切换到另一个环境

    activate xiaolvshijie

6.注销当前环境

    deactivate

7.复制环境

    conda create -n xiaolv --clone xiaolvshijie

8.删除环境

    conda remove -n xiaolv --all

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

<https://python-xy.github.io/> 微软推荐的<https://devblogs.microsoft.com/python/unable-to-find-vcvarsall-bat>
