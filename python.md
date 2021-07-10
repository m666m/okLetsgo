# python

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
