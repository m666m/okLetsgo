# python

    https://github.com/jackfrued/Python-100-Days
    https://www.labri.fr/perso/nrougier/from-python-to-numpy/#id7

Python 之禅

    $ python -c "import this"
    The Zen of Python, by Tim Peters

    Beautiful is better than ugly.
    Explicit is better than implicit.
    Simple is better than complex.
    Complex is better than complicated.
    Flat is better than nested.
    Sparse is better than dense.
    Readability counts.
    Special cases aren't special enough to break the rules.
    Although practicality beats purity.
    Errors should never pass silently.
    Unless explicitly silenced.
    In the face of ambiguity, refuse the temptation to guess.
    There should be one-- and preferably only one --obvious way to do it.
    Although that way may not be obvious at first unless you're Dutch.
    Now is better than never.
    Although never is often better than *right* now.
    If the implementation is hard to explain, it's a bad idea.
    If the implementation is easy to explain, it may be a good idea.
    Namespaces are one honking great idea -- let's do more of those!

## python 多环境隔离

    https://www.cnblogs.com/doublexi/p/15783355.html

我们经常会遇见这样的场景：

1、各个项目使用的 python 版本不相同

由于 Python 的解释器版本众多，各版本之间差异非常大。特别是 python2 和 python3，互不兼容。

有些项目可能用的 python2.7，有些项目可能用的是 python3.6，有些则使用的 python 3.8 等，但是它们却需要运行在同一个服务器中。（docker除外，docker容器可以隔离不同的项目环境）。

2、操作系统依赖自带的 python 解释器

操作系统的一些服务组件一般也会依赖 Python 环境。不同的 Linux 发行版自带的 Python 也不同。如 ubuntu16 自带 2.7 和 3.5 版本, Centos7 依赖 python2.7。你不能轻易删除这个版本，一旦删除或者更改都可能造成系统出问题，比如 yum/dnf 等操作系统的命令都是使用 python 进行解释的。

3、依赖默认的解释器路径冲突

很多 python 脚本用python这一个引用，却没有使用python2、python3这样分开，这就很容易导致它们的一些python引用冲突。

    比如 Centos7 系统自带的 python 是 2.7，系统很多组件比如 yum 依赖的都是 2.7 这个版本，这些工具脚本开头使用的都是：`#!/usr/bin/python`

    而一些新的使用 python 开发的服务组件，它们依赖 python 3.6 以上的版本，但是它们一些代码开头也是这样的写法：`#!/usr/bin/python`

对 Debian 11之前的发行版同时带有 python 2 和 python 3，命令 `python` 默认是python 2，如果要使用 python 3，则使用命令 `python3`：

    python  指向 python2，.py代码文件开头写 #!/usr/bin/python

    python3 指向 python3，.py代码文件开头写 #!/usr/bin/python3

开源系统各家的处理方式有差别，导致你使用软件时不一定能完整适配，所以尽量安装使用发行版的软件包，这些都是测试过可以正常运行的，实在不行再从第三方下载安装。

4、依赖冲突。（最常见）

    由于 Python 的依赖库管理是中心化的，而且大版本上的不兼容且长期并行，就出现了这么一个独特的话题

我们都知道 python 的软件包依赖经常是个很头疼的问题，经常因为这个问题导致到家在安装一些 python 环境或者服务组件时失败。

而不同的 python 解释器版本，对软件包依赖库的管理也是个问题。

比如 sqlalchemy 这个包，有些项目使用的 python2.7 版本，它需要依赖这个库，有些项目使用的 python3.6 版本，它也需要依赖这个库，有些项目使用的 python3.8 版本，它同样也需要依赖这个库，

但是头疼的是，这三者它们依赖的这个包版本还不一致。sqlalchemy 从 0.1-2.0 有众多版本。

这时候如果你在系统上直接使用 `pip install sqlalchemy` 的话，它只能选择安装一个版本，但是这样其他两个项目是无法使用这个版本，就会出现依赖冲突的问题。

常用的隔离方案比较多

    venv 是 python3 自带的，只能在 3.3 以后的版本使用，2.x 用不了。env 用于创建一个虚拟环境，与当前的操作系统的 pytyhon 环境隔离。但是它不能创建当前系统上不存在的 python 版本的虚拟环境，不能查看环境列表。

    virtualenv 同时支持 python2 和 python3，可通过 pip 安装和更新，会自动查找当前操作系统内的不同 python 版本，为每个虚拟环境指定某版本的 python 解释器，可选择继承父环境的包。virtualenv 也不能创建当前系统上不存在的 python 版本的虚拟环境。

    conda 虚拟环境是独立于操作系统解释器环境的，可以建立当前操作系统不存在的 python 版本，conda 可以安装编译版，所以可以安装一些工具软件，即使这些软件不是基于Python开发的。

## Windows 7 最高只能使用 Python3.8

Windows下的python，各种命令的脚本都是cmd下的bat，如果用bash运行这些命令，有时候会出现各种提示报错信息。

Windows下推荐使用 cmd 命令行执行纯python操作。

Windows下推荐使用 cmd 命令行执行conda操作。

例外情况是，你的命令脚本不是sh，其实执行的是.py，则配置路径类参数的格式需要根据操作系统的类型写，由python自行解析。

总之，python环境的发展众多，用conda或者pip或者virtualenv都可以，但是很多命令是 .sh .bat .py 三者混杂的，使用的时候最好先研究下到底执行的是哪个命令，多用 `which`或`where`查看。

## pip

pip 是 python 的包管理程序，手工安装的 python 一般都带，但是 Linux 发行版不带这个模块，需要你自行安装

    https://packaging.python.org/en/latest/tutorials/installing-packages/#id13

    https://packaging.python.org/en/latest/guides/installing-using-linux-tools/#fedora

    $ python -m pip --version
    /usr/bin/python: No module named pip

    $ sudo dnf install python3-pip python3-wheel

pip 安装各种包时默认搜索的 python 仓库就是著名的 pypi

    https://pypi.org/

pip 不像 conda/virtualenv 一样，他不知道环境！执行命令 `pip install` 就扔到 python 的基础环境下，后来弄了个 --user 扔当前用户的目录下，所以在 conda/virtualenv 下使用 pip 需要调整参数，参见章节 [确认pip下载的包的保存位置]。

    https://www.cnblogs.com/feixiablog/p/8320602.html

pip --user install 和 virtualenv --no-site-packages 对 site_package 目录的处理异同

    --user 到底为啥 https://pip.pypa.io/en/stable/user_guide/#user-installs

    virtualenv从版本20开始，默认就是’--no-site-packages‘了，默认就是不继承父环境的包。创建的虚拟环境是一个不带任何第三方包的“干净”的Python运行环境。

Debian/Ubuntu 下默认安装 python 2 以及 python 3，python 命令指向 python 2，python3 命令指向 python3。pip 命令是 python2 的 pip, pip3 命令才是 python3 的 pip。不过使用命令 python3 -m 执行包的方式时，用包名 pip ，如 `python3 -m pip install xxx`

    # 安装 pip3 给 python3 使用
    sudo apt install python3-pip

pip 安装的有些包调用c语言库，需要安装c开发环境和对应的头文件，见章节 [开发工具](raspberry-pi think)。

新的可以自动创建环境的 pipx，适合命令行使用

    pyenv

    pipenv

    pipx

### 操作系统发行版的基础python环境不要变更

仅在虚拟环境中使用 pip

    https://github.com/pypa/pip/issues/5599
        https://blog.csdn.net/cangye0504/article/details/104905616

只用系统管理升级操作系统的包，确保一直是发行版，自行升级 pip 或 pip install 各种包经常会出现各种奇怪的问题。

    在操作系统发行版的基础环境里，不要更新pip `pip install --upgrade pip`

在操作系统发行版的基础环境中，即使某些工具可以用 pip 安装新版，也要优先安装系统发行版

    # 不要 pip3 install yapf
    sudo apt install yapf

如果一定要在操作系统发行版的基础环境里使用 pip 安装各种包

    # https://snarky.ca/why-you-should-use-python-m-pip/
    优先使用`python3 -m pip install xxxx`， 不要用 `pip3 install`，因为你用`python -m pip`运行pip时环境是确定的，包名也是确定的。

    不要根据 pip 的提示使用 sudo 执行 或 --user 参数，因为 pip 命令不像 conda 或virtualenv，pip 不知道虚拟环境，会直接写入你的操作系统的基础环境，即使你已经切换到了 python 的虚拟环境中

如果需要升级 pip，也是在你的虚拟环境里升级

    使用 virtualenv 等建立虚拟环境，在虚拟环境里可自由升级pip，执行 pip install 等

验证 pip 环境路径，在操作系统发行版的基础环境里也不要改动

    $ python -m site
    sys.path = [
        '/home/pi/.local/bin',
        '/usr/lib/python2.7',
        '/usr/lib/python2.7/plat-arm-linux-gnueabihf',
        '/usr/lib/python2.7/lib-tk',
        '/usr/lib/python2.7/lib-old',
        '/usr/lib/python2.7/lib-dynload',
        '/usr/local/lib/python2.7/dist-packages',
        '/usr/lib/python2.7/dist-packages',
    ]
    USER_BASE: '/home/pi/.local' (exists)
    USER_SITE: '/home/pi/.local/lib/python2.7/site-packages' (doesn't exist)
    ENABLE_USER_SITE: True

    $ python3 -m site
    sys.path = [
        '/home/pi/.local/bin',
        '/usr/lib/python37.zip',
        '/usr/lib/python3.7',
        '/usr/lib/python3.7/lib-dynload',
        '/home/pi/.local/lib/python3.7/site-packages',
        '/usr/local/lib/python3.7/dist-packages',
        '/usr/lib/python3/dist-packages',
    ]
    USER_BASE: '/home/pi/.local' (exists)
    USER_SITE: '/home/pi/.local/lib/python3.7/site-packages' (doesn't exists)
    ENABLE_USER_SITE: True

pip的国内镜像清华源提供的更新方法在操作系统发行版的基础环境里慎用，仅在虚拟环境里升级pip，安装各种包

    # pip修复回发行版
    python3 -m pip uninstall pip setuptools wheel
    sudo apt --reinstall install  python3-setuptools python3-wheel python3-pip

### 务必搞清环境，pip install 可能把包放到的几个地方

pip install 之前先看看到底用的哪个地方的pip，特别是当前操作系统里有多个pip：

    先切换到你自己的环境(conda/virtualenv等)

    pip -V 这个会列出当前的pip的命令行位置
    which pip  # linux
    where pip  # windows

Pip can install software in three different ways:

    At global level. 标准的python环境下，"pip install xxx"放在了python目录的site-packages里，这个影响当前操作系统的所有用户.

    At user level. "pip install xxx --user"放在了当前操作系统用户home目录的python目录的site-packages里，这个放置的地方比较别扭。使用命令 `python -m site` 中的变量 USER_SITE。

    At virtualenv level. virtualenv环境下，"pip install xxx"放在了virtualenv建立的环境目录的site-packages里，最好用这个。

如果当前操作系统还安装了conda，请先conda list 看看有没有pip，有可能运行的是conda环境里的pip，那就安装到了conda建立的环境目录的site-packages里。详见章节 [conda/pip操作前务必先检查当前环境中conda/pip/python的路径]。

### wheels

    https://devblogs.microsoft.com/python/unable-to-find-vcvarsall-bat/
    https://www.lfd.uci.edu/~gohlke/pythonlibs/

pip安装某些python包需要c++编译环境（pip提供的是.pyd文件，需要借助python环境在本地编译出二进制。），在Windows下需要手动安装，方法有两个：一、安装 MinGW；二、安装 Visual Studio 社区版。python安装的setup也是如此，都依赖c++编译环境。

不想安装编译环境，最简单的解决办法是下载好心人提供的编译好的whell文件 <https://www.lfd.uci.edu/~gohlke/pythonlibs/>

    python2.7用的是msvs2008编译的，所以python2.7默认只能认出msvs2008.
    python3.4用的是msvs2010编译的，所以python3.4默认只能认出msvs2010。
    python3.7使用vs2015（WIN10SDK）
    python3.8应该对应了VS2017(15.9)，用VS2019基本也可以。 这是支持 Windows 7 的最后一个版本了。

    如果安装的是VS2014，则VERSION为13.0；
    如果安装的是VS2013，则VERSION为12.0；
    如果安装的是VS2012，则VERSION为11.0；
    如果安装的是VS2010，则VERSION为10.0；
    如果安装的是VS2008，则VERSION为9.0。

如何编译 python3.7/3.8 <https://www.cnblogs.com/xiacaojun/p/9914545.html>
<https://zhuanlan.zhihu.com/p/148348614>

清华开源镜像 <https://mirrors.tuna.tsinghua.edu.cn/> 只保留最近的新版本，老的都清理。

### pip 版本更新

如果安装了Anaconda，需要在conda中安装或更新pip，见下面的章节 [在conda中安装/更新pip]。

Windows下干净的python环境，命令行工具不要使用bash，在cmd下用pip没问题。因为python的windows脚本都是用bat实现的。

命令行工具cmd

    先切换到你自己的环境(virtualenv或操作系统自带的python)

    # -U 等效 --upgrade
    # pip install --upgrade pip
    # 如果您到 pip 默认源的网络连接较差，临时使用清华镜像站来升级 pip
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U

失败的话，应该先检查下你运行pip的时候，是不是没有在虚拟环境下。找不到下载的包文件对应位置的时候，pip安装到系统默认的python目录，才会出现这种权限不足的提示。详见章节[conda/pip操作前务必先检查当前环境中conda/pip/python的路径]。

正确的用法，是切换到你的环境下，再 pip install。

像下面这样强行安装，搜索百度的大多数结果，会搞乱基础环境：

    直接使用后面的提示命令 --user，也就是 you should consider upgrading via the 后面的命令。

    python -m pip install -U --force-reinstall pip

    sudo -h pip install -U pip

    管理员权限运行

指定版本

    python3 -m pip install pip==版本号

Debian/Ubuntu 下有两个pip，如果是这种情况可以使用

    # python3 的版本
    pip3 install--index-url https://pypi.douban.com/simple xxxx

如果使用镜像来安装库，比较常用的有 <https://mirrors.tuna.tsinghua.edu.cn/help/pypi/> <https://pypi.mirrors.ustc.edu.cn/simple> 参见下面章节[PyPi使用国内源]

### pip 升级包

    先切换到你自己的环境(conda/virtualenv等)

    pip install --upgrade 要升级的包名

### 使用 pip 进行安装的各种用法

默认 PyPI，Last released version:

    pip install pyqtgraph

    # Latest development version:
    pip install git+https://github.com/pyqtgraph/pyqtgraph@master

    # Latest development version:
    pip install git+git://github.com/pyqtgraph/pyqtgraph@master

    pip install git+git://github.com/scrappy/scrappy@master  # 直接从GitHub中的master分支安装scrappy

    pip install git+ssh://git@github.com/seatgeek/fuzzywuzzy.git@0.17.0#egg=fuzzywuzzy

    pip install git+https://github.com/blampe/IbPy.git

    pip install https://github.com/blampe/IbPy/archive/master.zip

    强制重装 pip install --force-reinstall https://github.com/mwaskom/seaborn/archive/refs/heads/master.tar.gz

    强制更新 pip install --upgrade --no-cache-dir xxx

    到pypi网站查找对应你python版本的历史版本，下载wheel文件用pip进行安装即可。

    如果只有源代码和 setup.py 文件，进入到该文件的 setup.py 目录下 ，打开 cmd，并切换到该目录下：
    先执行 `python setup.py build`
    然后执行 `python setup.py install`

    pip install -r requirements.txt

特定版本签出：

    先切换到你自己的环境(conda/virtualenv等)

    pip install -e hg+https://foss.heptapod.net/openpyxl/openpyxl/@3.0#egg=openpyxl

From txt

    先切换到你自己的环境(conda/virtualenv等)

    pip3 install -r requirements.txt

From conda

    先切换到你自己的环境(conda/virtualenv等)

    Last released version: conda install -n myenv -c conda-forge pyqtgraph

To install system-wide from source distribution:

    先切换到你自己的环境(conda/virtualenv等)

    python setup.py install
    Many linux package repositories have release versions.

To use with a specific project, simply copy the PyQtGraph subdirectory anywhere that is importable from your project.

### PyPI使用国内源

如果需要的版本下载不到

    国内的 pypi 源一般只保留包的最近几个版本，去 pypi.org 手动下载 wheel 包到本地手动安装

任何操作前，先切换到自己的环境下，然后检查pip的路径设置

    # 切换到base环境(conda/virtualenv等)
    conda activate

    $ pip -V
    pip 21.0.1 from C:\ProgramData\Anaconda3\lib\site-packages\pip (python 3.8)

    $ pip config list -v
    For variant 'global', will try loading 'C:\ProgramData\pip\pip.ini'
    For variant 'user', will try loading 'C:\Users\username\pip\pip.ini'
    For variant 'user', will try loading 'C:\Users\username\AppData\Roaming\pip\pip.ini'
    For variant 'site', will try loading 'C:\ProgramData\Anaconda3\pip.ini'

    # 切换到你自己的环境(conda/virtualenv等)
    conda activate p37

    pip -V

    pip config list -v

如果为空，说明未配置，都是默认值，pip config 配置之后就有了。

全局使用清华源

    # https://mirrors.tuna.tsinghua.edu.cn/help/pypi
    # https://help.mirrors.cernet.edu.cn/pypi/

    # 切换到base环境(conda/virtualenv等)
    conda activate

    # NOTE: 在Anancoda下的[base]环境，更新pip其它conda环境默认共用这个pip！尽量只在自己的conda环境下更新pip！

    # 临时使用国内镜像，更新pip自身
    $ python -m pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple --upgrade pip

    # 设为全局默认
    $ pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

验证

    conda activate

    (base)$ pip config list -v
    For variant 'global', will try loading 'C:\ProgramData\pip\pip.ini'
    For variant 'user', will try loading 'C:\Users\username\pip\pip.ini'
    For variant 'user', will try loading 'C:\Users\username\AppData\Roaming\pip\pip.ini'
    For variant 'site', will try loading 'D:\pycode\py37\pip.ini'
    global.index-url='https://pypi.tuna.tsinghua.edu.cn/simple'
    conda activate p37

    (p37)$ pip config list -v
    global.index-url='https://pypi.tuna.tsinghua.edu.cn/simple'

配置文件生成在  ~/.pip/pip.conf，Anaconda 安装的在 C:\Users\username\AppData\Roaming\pip\pip.ini。

其它源

    Python官方 <https://pypi.python.org/simple>
    清华大学 <https://pypi.tuna.tsinghua.edu.cn/simple/>
    阿里云 <http://mirrors.aliyun.com/pypi/simple/>
    中国科技大学 <https://pypi.mirrors.ustc.edu.cn/simple/>
    豆瓣 <http://pypi.douban.com/simple>
    v2ex <http://pypi.v2ex.com/simple>
    中国科学院 <http://pypi.mirrors.opencas.cn/simple/>

#### 在 Linux 和 macOS 中，用户配置需要写到 ~/.pip/pip.conf 中

    [global]
    index-url=http://mirrors.aliyun.com/pypi/simple/

    [install]
    trusted-host=mirrors.aliyun.com

## uv 代替 pip

借鉴 Rust cargo 的管理办法，代替 pip，目前的优势是速度快，环境管理 requirements.txt 也很方便移植

    https://docs.astral.sh/uv/
        https://github.com/astral-sh/uv

    https://zhuanlan.zhihu.com/p/689976933

uv是一个全局的二进制文件，只要在一个环境中安装就全局生效

    $ pip install uv

即使是在venv环境中安装的，uv也会复制自己的可执行文件也会被复制到系统的PATH目录中，保证退出或切换虚拟环境后，uv命令依然能够正常使用。

目前不支持读取 `pip.conf`，只能手动设置镜像地址

    # 镜像地址
    export UV_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple

    # 额外镜像地址
    export EXTRA_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple

    # 不用缓存
    export UV_NO_CACHE=0

    # 下载包时的超时时间，单位为秒
    UV_HTTP_TIMEOUT=60

创建环境

    # --python 同 -p
    $ uv venv --python 3.12

uv 工具不会自动下载Python包，因此如果设置-p时指定系统不存在的Python版本，则会报错

## 何时用 conda/virtualenv/venv

pip 只能安装 Python 的包，conda 可以安装一些工具软件，即使这些软件不是基于 Python 开发的。也就是说，pip 安装的时候，可能有需要源码编译的场景，而 conda 把二进制代码编译好了直接发布。

conda 虚拟环境是独立于操作系统自带的 python 解释器环境的（debian 自带的是 2.7+3.3），通过使用 conda 自带的 python，用户可以任意指定虚拟环境 python 版本为 2.7/3.3/3.4/3.5/3.x，所以 conda 的隔离性最强。

virtualenv 依赖操作系统内安装好的 python，主要解决多个项目对不同库版本的依赖、以及间接授权等问题（也支持多个 python 版本，需要操作系统里先安装好）。virtualenv 在创建虚拟环境的时候，会把系统 Python 复制一份到虚拟环境目录下，当用命令 `source env/bin/activate` 进入虚拟环境时，virtualenv 会修改相关环境变量，让命令 python 和 pip 均指向当前的虚拟环境，所以 virtualenv 的隔离性也很强，只是无法任意指定 python 版本，只能使用当前系统自带的 python。

    如果你的多个项目需要对应多个 python 版本，且无法在操作系统里安装多个 python 版本，或你的项目依赖的包在 pip 下不好找，用 conda。

    如果你的多个项目只是一个版本的 python 下对不同的库版本有依赖，用 virtualenv 。

    如果你只使用 Python 3.3 及以上版本，使用标准库内置的 venv 模块即可，可不用安装 virtualenv。

    如果你使用 Python 2，就只能选择 virtualenv。

## virtualenv 配置python环境

适合标准的 python 安装到 Windows 上，原始 Python 的脚本更适合用 cmd 环境，而 pip 的有些脚本适合用 bash 做环境。

    https://virtualenv.pypa.io/en/latest/

    https://docs.python-guide.org/dev/virtualenvs/

    https://www.cnblogs.com/doublexi/p/15783355.html

激活环境命令：

    # CMD
    call c:/Users/xxxx/pyenvs/py38/Scripts/activate.bat

    # bash
    source c:/Users/xxxx/pyenvs/py38/Scripts/activate

让命令行提示符显示当前 vritualenv 环境参见章节 [bash 命令行提示符显示 python 环境名](gnu_tools.md)。

创建虚拟环境

1.安装虚拟环境的第三方包 virtualenv

    pip install virtualenv

    pip install -i https://pypi.python.org/simple virtualenv
    # 使用清华源安装：
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple virtualenv

    # 升级 pip 到最新的版本 (>=10.0.0) 后进行配置：
    pip install pip -U
    # 临时使用本镜像站来升级 pip
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U

    # 设清华源为默认
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

2.创建虚拟环境

    cd your_envs

    # 在当前目录下创建名为myvenv的虚拟环境（如果第三方包virtualenv安装在python3下面，此时创建的虚拟环境就是基于python3的）
    virtualenv myvenv

    # 参数 -p 指定python可执行文件，根据版本创建虚拟环境
    virtualenv -p /usr/local/bin/python2.7 myvenv2

    virtualenv -p /c/tools/Python38/python.exe e38

    # 默认参数是 --no-site-packages 已经安装到系统python环境中的所有第三方包都不会复制过来
    virtualenv myvenv

    # 参数 --system-site-packages 指定创建虚拟环境时继承系统三方库
    virtualenv --system-site-packages myvenv

3.激活/退出虚拟环境

    cd ~/myvenv 跳转到虚拟环境的文件夹

    source bin/activate 激活虚拟环境
    （windows cmd 下是 .\Scripts\activate， mintty下是 ./Scripts/activate）

    which pip 看是否使用了当前环境目录下的pip
    pip list 查看当前虚拟环境下所安装的第三方库

    deactivate 退出虚拟环境

4.删除虚拟环境

直接删除虚拟环境所在目录即可

### pip install 在 virtualenv 虚拟环境下不要使用 --user 参数

在自己的环境下更新pip，当前用户目录是公用的不要去动他

    source c:/Users/xxx/pyenvs/py38/Scripts/activate

    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U

直接 pip install 就好了，这样默认才会把下载的包放到你的环境目录下 <https://stackoverflow.com/questions/30604952/pip-default-behavior-conflicts-with-virtualenv>。

### Windows 下脚本化使用 Virtualenv 环境

最好使用 cmd 环境，因为 python 在 Windows 下的脚本都是按 cmd 环境开发的。缺点是 vscode 使用的时候偶尔会有脚本报错，因为开发团队在 bash 下开发测试的。。。

用 bash 的问题是，用 pip 的时候偶尔有报错，因为 pip 在 Windows 下的脚本是按 cmd 环境开发的。

在 cmd 下执行的 bat 文件

```cmd
@REM
call c:\tools\pyenvs\yourenv\Scripts\activate.bat
python C:\Users\xxx\pycode\yourapp.py

deactivate
pause
```

执行最好用 call

    call your_env.bat

在 bash 下执行的 sh 文件，需要设置 conda init 以支持 git bash(mintty)，详见章节 [conda init 命令设置命令行工具]。

```shell
#!/bin/sh
# env source export 只认识linux目录结构
source /c/tools/pyenvs/yourenv/Scripts/activate
python /c/Users/xxx/pycode/yourapp.py

deactivate
read -n1 -p "Press any key to continue..."
```

如果安装了 git for windows，直接双击该 sh 文件就可以执行。如果 sh 文件的关联没有建立，则执行 git-bash(mintty) 调用 sh 文件

    "C:\Program Files\Git\git-bash.exe" --no-cd "C:\tools\pyenvs\yourprojectenv.sh"

如果需要显示中文需要修改配置文件 ~\.minttyrc，详见 [mintty(bash)] <gnu_tools.md>。

python-xy 不再更新维护了，废弃
<https://python-xy.github.io/> 微软推荐的<https://devblogs.microsoft.com/python/unable-to-find-vcvarsall-bat>

## Anaconda 管理

    命令速查 https://docs.conda.io/projects/conda/en/latest/commands/remove.html

    用户指南 https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#

理解 Anaconda 版本管理的特殊性

    当我们创建新的环境的时候，Anaconda 对相同的 python 版本指向为一个打包文件的链接。

    所以如果你改变了第一个 python 版本的环境，则后续新建同版本的环境会跟着变。。。

    对 pip 包默认下载路径，conda 库更新，都会同步这个影响。

    <https://www.anaconda.com/blog/using-pip-in-a-conda-environment>

### Linux 安装 anaconda

推荐安装 miniconda，其余的包都用 pip 安装

anaconda：

        https://docs.conda.io/projects/conda/en/stable/user-guide/install/linux.html

    1. 网站下载，验证hash https://docs.anaconda.com/free/anaconda/reference/hashes/all/
    2. bash xxxx.sh
    3. 注意选择：添加到路径中!!! 这个跟 Windows 下安装是不同的.

miniconda：

    简单安装可以用发行版自带的 conda 包，但是我的 Fedora `dnf install conda` 后运行 `conda init bash` 就报错……

        https://docs.conda.io/en/latest/miniconda.html

    $ mkdir -p ~/miniconda3

    $ wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh

    # 验证 hash https://conda.io/en/latest/miniconda_hashes.html
    $ sha256sum ~/miniconda3/miniconda.sh

    $ bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    $ rm -rf ~/miniconda3/miniconda.sh

    $ ~/miniconda3/bin/conda init bash
    $ ~/miniconda3/bin/conda init zsh

安装后

    # 重启命令行终端
    $ exit

    更新 conda 和 pip
    $ conda update conda
    $ pip install --upgrade pip

    查看 conda 信息：
    $ conda info
    $ conda list
    $ conda env list

    在终端运行启动器：

        $ conda activate
        $ anaconda-navigator

    搜索计算机： visual studio code 或 conda
    或 终端运行：spyder

### Windows 安装 anaconda

官方介绍 <https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html>

#### 初始化

0.先安装 git for Windows，后续使用它自带的 bash、ssh 比较方便，不装也行

1.如果想让 vscode 自动找到，安装时的选项记得勾选“add Anaconda3 to the system PATH environment variable”或“set Anaconda3 the system default python”。如果你想使用路径名的虚拟环境，可以不勾选。

2.选择了 “给所有用户安装”时，程序会安装到 C:\ProgramData\anaconda3，新建环境如[p37]会保存在C:\ProgramData\Anaconda3\envs\p37，不选则保存在 C:\Users\xxxx\.conda\envs\p37，相应的python、pip位置也会跟随变化。

3.安装完毕后，换清华源，参见下面章节 [conda频道和源配置]，然后打开 anaconda-navigator，切换到 [base] 环境，界面反应很慢，多等等，不要着急切换。后台脚本一直在远程下载处理，要执行一堆初始化工作，不是光 setup.exe 安装完了就可以了。。。

4.不推荐更新 conda。如果想更新包，仅在自己的虚拟环境里更新指定的包。

5.初始化conda的那些管理类命令，要使用 cmd 窗口执行

    初始化conda的的操作修改变量等，实质执行的 conda 命令在Windows下是各种bat文件，所以应该在cmd窗口里，在base环境下执行初始化的相关命令。

如果在安装时选择了给所有用户安装，则要操作的默认根环境在 C:\ProgramData\Anaconda3 这个目录，在环境列表中名叫[base]（不要往base环境里添加包）。

初次使用的初始化操作，最好执行 Anaconda 在开始菜单的快捷方式'Anaconda Prompt' 的 cmd 窗口。

    如果单独打开 Windows 的 cmd 窗口，要用管理员权打开 cmd 窗口，首先要执行 `conda activate` 以进入 [base] 环境，然后执行conda 初始化相关的命令。

管理员权限打开命令行工具

    conda activate

    # conda 默认 base 环境下自带的直接用就行，基础环境更新了容易乱，不要乱动 base 环境
    conda update -n base conda
    conda update anaconda
    conda update anaconda-navigator

6.pip更换国内源，详见上面章节 [PyPI使用国内源]。

x. 不推荐更新pip。仅在自己的虚拟环境里更新pip和指定的包，详见下面章节[Anaconda环境中使用pip]

7.设置conda在哪个shell下使用（windows默认是cmd），详见下面章节 [conda init 命令设置命令行工具]

8.vscode配置默认终端，选择“Git Bash”

9.anaconda-navigator 逐个python版本的新建环境，作为标准环境，这些环境建了之后不要更新、下载包，不要做任何改动！

NOTE:后续建立的同版本的python环境都会复用最早建立的那个环境！原因是Anaconda节省空间使用文件的链接，但是无法区分pip。

所以，稳妥的办法是，如果你的系统里要使用多个python版本，先逐个建立各个版本的环境，什么都不要改。
然后针对具体的项目建路径名的虚拟环境，在这个虚拟环境里面安装pip，然后改路径。

10.建立你自己项目的虚拟环境（见下面的章节 [使用路径名，在你的项目目录下建立虚拟环境]），在这个虚拟环境里面安装pip，然后改路径（详见下面章节[更改conda环境下pip包默认下载路径]）。

11.详细配置信息请切换到自己的环境下，运行 conda info，观察多个env路径的查找顺序。

#### 填坑

如果安装anaconda时没有勾选"add anaconda3 to the system PATH environment variable"加入到环境变量，vscode 无法找到python，则安装插件：Code Runner

启动Python3.7，报如下错误

    File "C:\Anaconda3\lib\site-packages\pyreadline\lineeditor\history.py", line 82, in read_history_file
        for line in open(filename, 'r'):
    UnicodeDecodeError: 'gbk' codec can't decode byte 0x80 in position 407: illegal multibyte sequence

执行

    https://github.com/pyreadline/pyreadline/issues/38
    Open file C:\Python351\lib\site-packages\pyreadline\lineeditor\history.py.
    Go to 82 line and edit: this - for line in open(filename, 'r'): on this -
        for line in open(filename, 'r', encoding='utf-8'):

Windows 命令行进入 python 后，按[TAB]出现报错：

    AttributeError: module 'readline' has no attribute 'redisplay'

执行

    pip install git+https://github.com/ankostis/pyreadline@redisplay
    https://github.com/pyreadline/pyreadline/pull/56
    https://github.com/winpython/winpython/issues/544

在 mintty 下的 bash，进入 python 后不出现命令提示符，需要使用 winpty 程序加载执行

    winpty python

#### 如果不想用了

卸载 anaconda

<https://docs.anaconda.com/anaconda/install/uninstall/>

清理并备份~/.conda目录为.anaconda_backup

    conda install anaconda-clean
    anaconda-clean --yes

删除目录 envs and pkgs。

执行Windows添加删除程序里的anaconda卸载程序。或者ananconda文件夹里找到uninstall annaconda.exe。

卸载 vscode ，需要手动再做如下

    C:\Users\xxxx\AppData\Roaming\Code 目录清空
    C:\Users\xxxx\.vscode 目录清空

### Anaconda多环境最佳方案

原则

    操作系统发行版的基础python环境不要变更，conda的基础环境也不要做任何变更

Anaconda 安装完毕后，默认的环境base是最新的一个python版本如python3.10，需要先对其它各个版本建立基础的虚拟环境如b37、b38，但是不要做任何pip变动，比如pip安装更新包、修改pip包的默认下载路径等。

原因是Ananconda为了节约硬盘空间，多个相同python版本的环境内容通过链接的方式共享使用第一个环境的各个包文件，而conda是不管pip的，pip自身也不区分环境，所以pip配置类的文件是直接引用的，你要是在基础环境更新了pip，则conda各个环境里所有其他同版本的pip也都升级了，要是修改了路径，其它版本的也跟着变了，搞得非常乱。

例外：可以变更pip源到国内源，在bash环境下做这个变动影响全局没问题，除非你有个环境非得要国外源，那就在那个环境里手动改pip源即可。

有了第一个基础版本的python环境之后，再建立针对具体项目的虚拟环境如p37、p38，在这个虚拟环境里修改pip包的默认下载路径、进行conda/pip包的安装和更新等操作。

详见章节 [conda/pip操作前务必先检查当前环境中conda/pip/python的路径]

### 命令行工具使用conda环境

要确保在[base]环境下执行 conda 的各种操作，这个是特殊的root环境，可以找到conda需要的各种变量和路径设置，所以最好的方式是点击开始菜单的Anaconda命令行快捷方式，如果想设置各命令行自动进入conda见下面章节 [conda init 命令设置命令行工具]。在base环境的基础上执行 `conda xxx` 等操作，也可以用 `conda activate p37` 进入你的环境。

官方推荐：慎用 deactivate 命令，从当前环境用 deactivate` 命令返回到[base]，不如重新开个 shell，默认是 [base] 环境，这样更少bug <https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#deactivating-an-environment>。

以前 conda 版本的 source activate 和 source deactivate 跟 virtualenv 环境的脚本经常路径冲突。conda 4.4之后激活和退出环境统一了命令用法，不用 source 了，操作步骤如下：

    # 激活[base]环境
    conda activat

    # 切换到指定的[p37]环境
    conda activate p37

    # 退出当前环境，返回的是上一个环境，官方建议是重新开个shell再activate别的环境。
    conda deactivate

仍需要用 source 的案例

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

#### conda init 命令设置命令行工具

    让命令行提示符显示当前 conda 环境参见章节 [bash 命令行提示符显示 python 环境名](gnu_tools.md)

设置在哪个 shell 下使用 conda，主要的操作其实是给该命令行的用户配置文件添加自动进入 [base] 环境的脚本，这样可以使conda 的各个命令在 bash、cmd、powershell 等命令行工具下直接使用。

打开 Windows 开始菜单里 Anaconda prompt，执行

    conda init -h

用管理员权限打开 cmd 命令行工具

    # 激活[base]环境
    # 如果打开Windows开始菜单里Anaconda prompt，就不用这步重复激活base了
    conda activate

    # 用 bash，推荐
    # 需要先安装 git，conda使用它自带的bash(mintty)即可
    # 操作是在 ~/.bash_profile 中添加代码，自动激活[base]环境
    conda init bash

    # 用 cmd，不推荐
    # 建议把 cmd 留给单独安装的 python 环境，这样可以并行使用 virtualenv
    # Windows 开始菜单里的 Anaconda Prompt (Anaconda3)，也可以进入 cmd
    conda init cmd.exe

    # powershell，微软来回改版本，不推荐
    # 再次打开 powershell会提示：C:\Users\...\profile.ps1限制执行
    # 需要以管理员身份打开PowerShell，输入 get-executionpolicy 查询当前策略，
    # 输入 set-executionpolicy remotesigned，输入 y 变更策略。
    conda init powershell

    # 都绑定上，太乱，不推荐
    conda init --all

然后关闭cmd窗口，以便生效。如果是用的bash，用^d或exit显式退出。

以后用bash就可以了（打开就是默认的base环境）。

不执行这个设置也可以，则每次进入命令行工具后，都要先执行 conda activate 进入base环境，以确保后续的 conda 命令可以被搜索到。

    对 cmd 环境，如果 conda 命令不在系统变量 PATH 中，可以手动执行 `C:\ProgramData\Anaconda3\Scripts\activate.bat C:\ProgramData\Anaconda3`，然后即可执行 `conda activate`。

    对 bash 环境，如果 conda 命令不在系统变量 PATH 中，可以手动执行 `eval "$('/c/ProgramData/Anaconda3/Scripts/conda.exe' 'shell.bash' 'hook')"`，然后即可执行 `conda activate`。

    对 powershell 环境，如果 conda 命令不在系统变量 PATH 中，需要手动先执行 `C:\ProgramData\Anaconda3\shell\condabin\conda-hook.ps1`，然后即可执行 `conda activate` 。

填坑：运行 conda init bash 出现错误

排错

    $ conda init -d
    modified      /usr/condabin/conda
    modified      /usr/bin/conda
    modified      /usr/bin/conda-env
    modified      /usr/bin/activate
    modified      /usr/bin/deactivate
    modified      /usr/etc/profile.d/conda.sh
    modified      /usr/etc/fish/conf.d/conda.fish
    modified      /usr/shell/condabin/Conda.psm1
    modified      /usr/shell/condabin/conda-hook.ps1
    needs sudo    /usr/lib/python3.11/site-packages/xontrib/conda.xsh
    modified      /usr/etc/profile.d/conda.csh
    no change     /home/uu/.bashrc

发现写入一个不存在的目录，不知道 conda 的脚本弄啥咧，我不用 xonsh 啊。不管了，给它装上，这样就有这个包了

    $ sudo dnf install xonsh

其它修改的文件都在 /usr/lib/python3.11/site-packages/conda/shell/condabin 下面。

查看 conda-hook.ps1，发现有 ChangePs1 设置。回忆起，修改过~/.condarc文件，添加了提示符相关的设置。

    https://zhuanlan.zhihu.com/p/584509576

    注释掉 ~/.condarc 中的 changeps1 行

根据提示，加 sudo 运行

    sudo conda init bash

    然后再改回去即可。

### Windows 下脚本化使用 conda 环境

CMD 下执行的 bat 脚本

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

mintty bash 的 sh 文件

```shell
#!/bin/sh
# env source export 只认识linux目录结构
/c/ProgramData/Anaconda3/condabin/conda.bat activate

conda activate p37
python /c/Users/your_name/pycode/your_project/app.py

conda deactivate
read -n1 -p "Press any key to continue..."
```

### conda 包管理常用命令

    # 创建python3.7的xxxx虚拟环境，新的开发环境会被默认安装在你 conda 目录下的 envs 文件目录下。
    conda create -n p37 python=3.7

    # 复制一个虚拟环境
    conda create --name myclone --clone myenv

    # 显示所有的虚拟环境，当前虚拟环境前面有个星号
    conda info --envs  // 或 conda env list

    # 显示当前虚拟环境下安装的包
    conda list

    # 显示conda的信息
    conda info

    # 参见章节[使用路径名，在你的项目目录下建立虚拟环境]
    cd your_project_dir
    conda create --prefix ./py37 python=3.7
    conda activate ./py37

    # 官方推荐所有的依赖包一次性install完毕，避免依赖文件重复
    conda install --name p37 yapf Flake8
    # 环境在路径名
    conda install --prefix ./py37 yapf Flake8

    # 导出环境配置文件，便于定制，包含pip包，推荐
    conda env export > environment.yml

    # 根据指定的配置文件更新指定的虚拟环境
    conda env update --prefix ./py37 --file environment.yml  --prune

    ## 精确的可复现的安装环境，不包含pip包，不推荐
    conda list --explicit > spec-file.txt
    conda create --name myenv --file spec-file.txt
    conda install --name myenv --file spec-file.txt

    # 列出所有的环境，当前激活的环境会标*。
    conda info -e

    # 删除环境
    conda remove -n p37 --all

#### 【不要在base环境下使用 conda install / pip install】

conda默认的把这个base环境"/c/ProgramData/Anaconda3/"视为root的，其他命令的使用和环境都是在这个环境之上建立链接。如果在base环境下用了conda/pip安装各种包，其他的环境大概率会乱。

仅在你自己的虚拟环境下进行包的安装和更新。

#### 使用 conda install 要指定虚拟环境名

    conda install -n p37 beautifulsoup4

    # 或
    conda install --name p37 beautifulsoup4  -y

    # 环境是路径名
    conda install --prefix ./p37 beautifulsoup4  -y

#### 官方推荐所有的依赖包一次性install完毕

这样的好处是避免依赖文件重复

    conda install -n p37 numpy pandas pyqtgraph

    # 在指定的频道搜索包名
    anaconda search -t conda tensorflow

    # 移除包
    conda remove beautifulsoup4

It is best to install all packages at once, so that all of the dependencies are installed at the same time. <https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html>

#### 安装特定版本的包

conda用“=”，pip用“==”

    conda install -n myenv  numpy=1.93

    pip  install numpy==1.93

### 【使用路径名，在你的项目目录下建立虚拟环境】

    参数 -n, --name 使用环境名
    参数 -p, --prefix 使用路径名

这样做的好处：你的环境只跟项目目录相关，独立性更强，不会干扰到别的环境。

如果想使用通用的虚拟环境，把 --prefix ./py37 换成 --name p37 即可，其它的命令不变。

虚拟环境使用路径名，之后所有跟环境名相关的 conda 操作都要明确指定“--prefix”，因为 conda --name 只在conda默认的env目录寻找你的环境名 <https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#specifying-a-location-for-an-environment>

1.在你的项目目录下创建虚拟环境

    conda activate

    cd your_project_dir

    # conda create --name p37 python=3.7
    conda create --prefix ./py37 python=3.7

    # conda activate p37
    conda activate ./py37

2.路径名太长，改为短名

    conda config --set env_prompt '({name})'

退出命令行工具，再次打开生效

3.确认conda、python、pip都是用的你的环境的，参见章节 [conda/pip操作前务必先检查当前环境中conda/pip/python的路径]。

4.修改你的环境pip保存下载包的位置，参见章节 [更改conda环境下pip包默认下载路径]。

5.官方推荐所有的依赖包一次性 conda install，避免依赖文件重复

    conda install --prefix ./py37 yapf Flake8 scipy numpy pandas matplotlib  sqlalchemy openpyxl seaborn beautifulsoup4 pyqtgraph

6.pip install 依赖包

7.环境配置文件保留好

    conda env export --prefix ./py37 > environment.yml

下次安装就简单了，直接恢复即可，见下面的章节 [环境文件的备份和恢复]

### conda 虚拟环境的备份和恢复

目前建议在 cmd 下执行，脚本好像有路径解析问题，在bash下总是报错

#### 方法一：导出环境配置文件yml

    https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#exporting-an-environment-file-across-platforms

便于定制，包含pip包，推荐使用这个用法。

方法一 导出虚拟环境配置文件yml

    # 先切换到你的环境！
    conda activate p37

    # 注意手工编辑yml文件删除你后来用wheel安装的包。参数 --from-history 不导出依赖包。
    conda env export > py37_environment.yml

方法二 导出路径名的虚拟环境配置文件yml

    conda activate
    cd your_project_dir

    conda env export --prefix ./py37 > py37_environment.yml

##### 恢复环境

这种方式最大的优点是pip包也是自动安装在你的指定环境目录里的，不是安装到系统默认的用户目录下，参见章节[确认pip下载的包的保存位置]。

方法一 创建虚拟环境

    conda activate
    cd your_project_dir

    # 注意环境名是写在yml文件里的，酌情修改
    # https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#create-env-file-manually
    conda env create --name p37 -f py37_environment.yml

    conda activate p37

方法二 创建路径名的虚拟环境

    conda activate
    cd your_project_dir

    # 注意环境名是写在yml文件里的，酌情修改
    # yml文件中的环境名name和路径名prefix一定要一致都是全路径，否则会放到conda系统env目录中
    (base) C:\Users\user_name\your_project>type py37_environment.yml
    name: C:\Users\user_name\your_project\py37env
    channels:
    - defaults
    dependencies:
      - beautifulsoup4=4.10.0=pyh06a4308_0
      - ...
      - pip:
        - websocket-client==1.3.1
        - ...
    prefix: C:\Users\user_name\your_project\py37env

    # <https://stackoverflow.com/questions/35802939/install-only-available-packages-using-conda-install-yes-file-requirements-t>
    conda env create --prefix ./py37 --file py37_environment.yml

    # yml文件中，如果发现已经更新了pip，不是原装的，会给个提示，问题不大。
    # 解决：新建个同版本的python环境，把之前的那个base环境删除，然后再次做导出。
    # Warning: you have pip-installed dependencies in your environment file, but you do not list pip itself as one of your conda dependencies.  Conda may not use the correct pip to install your packages, and they may end up in the wrong place.  Please add an explicit pip dependency.  I'm adding one for you, but still nagging you.

    conda activate ./py37env

    # 路径名太长，改为短名
    conda config --set env_prompt '({name})'

    # 重要，一定要执行章节 【更改conda环境下pip包默认下载路径】
    vi site.py

    # 最后手动安装yml文件中用wheel安装的包

还可以利用配置文件yml更新已有的环境

    conda env update --prefix ./py37 --file py37_environment.yml --prune

    conda activate ./py37

验证：

    # 列出所有的环境，当前激活的环境会标*
    conda info -e

#### 方法二：带conda包地址的配置文件

也可复现虚拟环境，但不包含pip包，需要手工编辑，不推荐。

导出conda包信息

    # 先切换到你的环境！
    cd your_project_dir
    conda activate ./py37env

    conda list --explicit > py37_conda_spec-file.txt

导出pip包信息

    建议根据自己的具体项目，手工一个个的写入requirements.txt。

##### 恢复环境

    cd your_project_dir
    conda activate

    # 恢复环境：创建新环境
    conda create --prefix ./py37_new --file py37_conda_spec-file.txt

    # 恢复环境：在已有环境上安装
    conda install --prefix ./py37_exist --file py37_conda_spec-file.txt

    # 验证：列出所有的环境，当前激活的环境会标*
    conda info -e

    # 需要先修改pip包默认下载路径，见章节 [更改conda环境下pip包默认下载路径]
    conda activate ./py37_new
    pip install -r requirements.txt

#### 方法三：混入pip、conda包信息

这样的虚拟环境混入pip、conda包和各包的依赖包，不推荐。

    # 先切换到你的环境！
    cd your_project_dir
    conda activate ./py37env

    pip list

    # 导出pip包
    pip freeze > py37_requirements.txt

    # 在目标环境里导入pip包
    pip install -r py37_requirements.txt

#### 复制虚拟环境

    # 克隆
    conda create --name new_p37 --clone p37

    # 验证：列出所有的环境，当前激活的环境会标*
    conda info --envs

    # 复制anaconda3/envs/下的某个环境的文件夹到另外一台机器上
    rsync -va username@xxx.xxx.xxx.xxx:/home/username/anaconda3/envs/p37/

#### 删除虚拟环境

    # 先切换到base环境，再删除你的其它环境

    conda remove --name myenv --all
    或
    conda env remove --name myenv

    # 使用路径名
    conda env remove --prefix myenv

### conda频道和源配置

    https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-channels.html

0.不同的conda频道，看看默认软件名在自己的os下对应的版本

    https://anaconda.org/search?q=pyqtgraph
    https://anaconda.org/conda-forge/pyqtgraph

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

    # 注意先切换到base环境
    conda activate
    conda update conda

    # vscode 提示
    # conda update -n base -c defaults conda

## Anaconda环境中使用pip

python 设计之初，并没有考虑一个操作系统上有多个环境的问题，默认就是安装到当前操作系统里用的。
后来pip包很多，版本也很多，引入了环境的概念，虚拟环境的保存目录是系统或当前用户，是跟当前操作系统环境捆绑的。也就是说，你使用的virtualenv虚拟环境，只能从当前操作系统里安装的python3.6和python2.7之上建立。

Anaconda更进一步，你的虚拟环境里的python版本可以不安装到当前操作系统，实现python版本跟操作系统的隔离。
但是，你的虚拟环境里的pip不知道这个隔离，下载包默认还是会安装到系统或当前用户，
所以需要手工修改site.py配置文件，详见下面的章节 [更改conda环境下pip包默认下载路径]

当你新建conda环境时，anaconda并没有在新建的环境中新建pip，此时只有anaconda默认的环境有pip。
所以此时你用pip install，所安装的包和依赖包均在anaconda默认的环境中，其他环境共享这个包的使用。

如果你之前建立过同版本的python环境，anaconda会节约硬盘空间，直接建立一个指向该python文件的链接。
这样会导致，你以为你新建了个环境，但是pip的下载包还是指向你第一个同版本python的环境下的目录，乱了吧？

验证：

    建立多个相同python版本的conda环境，更改 site.py的配置文件路径

    看看各个环境的site.py文件是不是以最后一个更改的路径为准，因为他们是共享的链接文件。。。

官方介绍
    <https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#using-pip-in-an-environment>
    <https://www.anaconda.com/blog/using-pip-in-a-conda-environment>

### 为什么anaconda环境中，还需要用pip安装包

<https://www.cnblogs.com/zhangxingcomeon/p/13801554.html>

尽管在anaconda下我们可以很方便的使用conda install来安装我们需要的依赖包，但是anaconda本身只提供部分包，远没有pip提供的包多，有时conda无法安装我们需要的包，我们需要用pip将其装到conda环境里。

另一个原因是，我们自己创建的conda环境里，可能没有pip。这会导致默认使用base环境的pip，有产生版本冲突的可能。

安装好本环境的pip之后，在本环境中使用pip install安装的包，就只在本环境的conda中了。用conda list查看包的清单，对pip安装的包，build列显示为pypi。

### 在conda中安装/更新pip

    conda activate myenv

    conda install -n myenv pip

    conda update pip
    # pip install --upgrade pip

    pip <pip_subcommand>

### 基本原则

pip不像conda一样，他不知道环境！

不要在操作系统的python环境或conda的base环境下更新pip，只更新你自己的环境(conda/virtualenv等)下的pip。

conda安装在conda环境中装任何包，pip在任何环境中安装python包。

先 conda install，然后 pip install

    如果用过pip了，就不要再用conda，否则也是容易搞乱环境。

    如果后续又想装新的包了，就再建个环境，还是先用conda，后pip。

    也就是说，装完了就不要删或update，宁可重建，什么 conda remove/pip uninstall 都别用。

+ 使用 pip install 不要使用参数 --user

    如果pip在安装时候提示权限不足，无法写入啥的，提示用“--user”，不要用！不然会写入到公用包目录中：如果是base环境下，是所有用户文件夹(ProgramData/Anaconda)下面，如果是其它环境，则安装到用户home目录下的公用目录了！

    原因见章节 [conda/pip操作前务必先检查当前环境中conda/pip/python的路径]。

    pip install 默认使用全局配置文件，见上面的章节 [PyPI使用国内源]

        (py37)$ pip config list -v
        For variant 'global', will try loading 'C:\ProgramData\pip\pip.ini'
        For variant 'user', will try loading 'C:\Users\xxxx\pip\pip.ini'
        For variant 'user', will try loading 'C:\Users\xxxx\AppData\Roaming\pip\pip.ini'
        For variant 'site', will try loading 'D:\pycode\py37\pip.ini'
        global.index-url='https://pypi.tuna.tsinghua.edu.cn/simple'

新建立的conda环境，首选要修改pip包安装默认路径

    以后只要切换到你的环境下，再运行pip，默认会安装到你环境下的目录。否则会安装到默认的pyhon环境目录比如 C:\ProgramData\Anaconda3，详见章节 [更改conda环境下pip包默认下载路径]。

### conda/pip操作前务必先检查当前环境中conda/pip/python的路径

我们需要判断目前我们用的pip指令，会把包装到哪里。pip 在路径里可能有多个，Windows单独安装的python自带，virtualenv环境自带，Anaconda 默认 base 环境自带，调用起来按PATH搜索的顺序。

所以，自己的环境在初次使用前，或者做了新的包安装或更新，也一定要先确认下。

Anaconda安装时选择了“给所有用户安装”时，虚拟环境的保存目录是 C:\ProgramData\Anaconda3\envs\p37，
如果是给当前用户安装，则虚拟环境的保存目录是 C:\Users\xxxx\.conda\envs\p37 ，相应的pip位置跟随变化。
详细配置信息请切换到自己的环境下，运行 conda info，观察多个env路径的查找顺序。

同理，linux下，base环境的pip可能在/root/anaconda3/bin/pip，而其他conda环境的pip，可能在/root/anaconda3/envs/my_env/bin/pip。

要确保我们用的是本环境的pip，这样pip install时，包才有可能（anaconda、virtualenv不同）会创建到本环境中。不然包的安装默认会到[base]环境（anaconda）或python根环境（virtuanlenv），供各个不同的其他conda环境共享，此时可能会产生版本冲突问题（不同环境中可能对同一个包的版本要求不同）。

#### 确认python的位置是否跟随环境

    # 默认base环境的python位置
    $ which -a python
    /c/ProgramData/Anaconda3/python
    (base)

    $ conda activate p37
    (p37)

    # 自己环境的python位置
    $ which -a python
    /c/Users/xxxx/.conda/envs/p37/python
    (p37)

    # 自己环境的pip位置
    which -a pip  # bash，在 cmd.exe 下用 where pip
    pip -V  # 列出当前的pip的命令行位置，确认是在自己的环境下面的

    # conda 环境的配置信息，便于对照
    conda info

    # 查看当前环境的变量指向配置文件
    (base) C:\Users\xxxx>pip config list -v
    For variant 'global', will try loading 'C:\ProgramData\pip\pip.ini'
    For variant 'user', will try loading 'C:\Users\xxxx\pip\pip.ini'
    For variant 'user', will try loading 'C:\Users\xxxx\AppData\Roaming\pip\pip
    .ini'
    For variant 'site', will try loading 'C:\ProgramData\Anaconda3\pip.ini'
    global.index-url='https://pypi.tuna.tsinghua.edu.cn/simple'

#### 确认 site.py 的位置是否跟随环境

    # 配置文件位置
    $ python -m site -help
    C:\Users\xxxx\.conda\envs\p37\lib\site.py [--user-base] [--user-site]

#### 确认pip下载的包的保存位置

    # 当前环境的配置文件 site.py 中下载的package的存放路径
    python -m site

输出

    # https://docs.python.org/3/install/index.html#alternate-installation-windows-the-prefix-scheme
    USER_BASE 表示当前环境下python.exe、pip.exe的位置。
    USER_SITE 表示当前环境下下载的package的存放路径，默认为None，也有可能为其他。pip install 使用参数 --user 就是使用的这个变量找保存位置 site.USER_SITE <https://docs.python.org/3/install/index.html#inst-alt-install-user>。

    比如Windows下 USER_BASE=...\envs\py37env\，USER_SITE=...\envs\py37env\lib\site-packages 。

默认None，则使用base环境的设置，也就是python默认的pip根路径设置。所以，这几个变量的效果，区别于是否安装了anaconda，执行的pip是否不同，而且受变量 ENABLE_USER_SITE 控制。

检查变量 USER_BASE、USER_SITE，如果指向你自己的python根环境

    "C:\Users\xxxx\AppData\Roaming\Python"（ENABLE_USER_SITE: True）
    或
    "C:\ProgramData\Anaconda3\Scripts"（ENABLE_USER_SITE: False）

则可以修改到自己的虚拟环境下，参见下面章节 [更改conda环境下pip包默认下载路径]。

#### bash 示例

    $ conda activate
    (base)
    $ conda activate p37
    (p37)


    $ which -a pip
    /c/Users/xxxx/.conda/envs/p37/Scripts/pip
    (p37)

    $ where pip
    C:\Users\xxxx\.conda\envs\p37\Scripts\pip.exe
    (p37)

    $ pip -V
    pip 21.2.4 from C:\Users\xxxx\.conda\envs\p37\lib\site-packages\pip (python 3.7)
    (p37)

    $ which -a python
    /c/Users/xxxx/.conda/envs/p37/python

    $ python -V
    Python 3.7.11

    $ conda info

        active environment : p37
        active env location : C:\Users\xxxx\.conda\envs\p37
                shell level : 2
        user config file : C:\Users\xxxx\.condarc
    populated config files : C:\Users\xxxx\.condarc
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
                            C:\Users\xxxx\.conda\pkgs
                            C:\Users\xxxx\AppData\Local\conda\conda\pkgs
        envs directories : C:\Users\xxxx\.conda\envs
                            C:\ProgramData\Anaconda3\envs
                            C:\Users\xxxx\AppData\Local\conda\conda\envs
                platform : win-64
                user-agent : conda/4.11.0 requests/2.26.0 CPython/3.9.7 Windows/10 Windows/10.0.19044
            administrator : False
                netrc file : None
            offline mode : False

    $ python -m site

    sys.path = [
        'C:\\Users\\xxx',
        'C:\\Users\\xxxx\\.conda\\envs\\p37\\python37.zip',
        'C:\\Users\\xxxx\\.conda\\envs\\p37\\DLLs',
        'C:\\Users\\xxxx\\.conda\\envs\\p37\\lib',
        'C:\\Users\\xxxx\\.conda\\envs\\p37',
        'C:\\Users\\xxxx\\.conda\\envs\\p37\\lib\\site-packages',
    ]
    USER_BASE: 'C:\\Users\\xxxx\\AppData\\Roaming\\Python' (doesn't exist)
    USER_SITE: 'C:\\Users\\xxxx\\AppData\\Roaming\\Python\\Python37\\site-packages' (doesn't exist)
    ENABLE_USER_SITE: True

#### cmd 示例

    C:\>conda activate
    (base) C:\>conda activate p37
    (p37)C:\>

    (p37) C:\>where pip
    C:\Users\xxxx\.conda\envs\p37\Scripts\pip.exe

    (p37) C:\>where python
    C:\Users\xxxx\.conda\envs\p37\python.exe

    (p37) C:\>python -V
    Python 3.7.11

    (p37) C:\>conda info

        active environment : p37
        active env location : C:\Users\xxxx\.conda\envs\p37
                shell level : 2
        user config file : C:\Users\xxxx\.condarc
    populated config files : C:\Users\xxxx\.condarc
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
                            C:\Users\xxxx\.conda\pkgs
                            C:\Users\xxxx\AppData\Local\conda\conda\pkgs
        envs directories : C:\Users\xxxx\.conda\envs
                            C:\ProgramData\Anaconda3\envs
                            C:\Users\xxxx\AppData\Local\conda\conda\envs
                platform : win-64
                user-agent : conda/4.11.0 requests/2.26.0 CPython/3.9.7 Windows/10 Windows/10.0.19044
            administrator : False
                netrc file : None
            offline mode : False

    (p37) C:\>python -m site

        sys.path = [
            'C:\\Windows\\system32',
            'C:\\Users\\xxxx\\.conda\\envs\\p37\\python37.zip',
            'C:\\Users\\xxxx\\.conda\\envs\\p37\\DLLs',
            'C:\\Users\\xxxx\\.conda\\envs\\p37\\lib',
            'C:\\Users\\xxxx\\.conda\\envs\\p37',
            'C:\\Users\\xxxx\\.conda\\envs\\p37\\lib\\site-packages',
        ]
        USER_BASE: 'C:\\Users\\xxxx\\AppData\\Roaming\\Python' (doesn't exist)
        USER_SITE: 'C:\\Users\\xxxx\\AppData\\Roaming\\Python\\Python37\\site-packages' (doesn't exist)
        ENABLE_USER_SITE: True

### 【更改conda环境下pip包默认下载路径】

想要做到 Anaconda 中不同环境互相不干涉，不仅需要建新的conda环境，如果想pip下载包跟其它环境隔离，还需要修改配置文件。

这是因为当我们创建新的环境的时候，Anaconda 对相同的python版本指向为一个打包文件的链接，导致无法区分pip。
特别是默认的pip下载包时的安装路径，参见章节[conda/pip操作前务必先检查当前环境中conda/pip/python的路径]。

稳妥的办法是

    如果你的操作系统里要使用多个python版本，先在Ananconda里逐个建立每个版本的基础虚拟环境，什么都不要改。

    然后再针对你具体的项目建路径名的虚拟环境，在这个虚拟环境里改pip包默认下载路径。

如果不这样做，第一个版本的python环境，会被后续的同版本pytyhon环境复用，如果该环境中pip路径变了，其它各环境也跟着变。。。。这样就可以理解为什么Anaconda新建环境默认不安装pip了，最好自己手动安装。

参考

    <https://blog.csdn.net/qq_37344125/article/details/104418636>
    <https://blog.csdn.net/tsq292978891/article/details/104655113>
    <https://blog.csdn.net/mukvintt/article/details/80908951>

#### 操作步骤

假设 Anaconda3 安装完成后建立的默认 root环境 [base]，python 版本是 3.9，路径在 C:\ProgramData\Anaconda3 ，其下默认路径为：Scripts 目录是 pip 等命令，Lib\site-packages 目录保存下载包，配置文件在 Lib\site.py。

新建个环境 [p37]，python 版本是 3.7，路径在 C:\Users\xxxx\.conda\envs\p37（Anaconda安装时选择了“给所有用户安装”时在 C:\ProgramData\Anaconda3\envs\p37）。

先切换到你当前的环境

     conda activate ./py37

查看当前环境的 python 的路径设置

    $ python -m site

可以看到 sys.path 变量至少有你当前 python 环境下保存包的 site-packages 位置，复制该路径后面会用到。

    Windows: C:\Users\xxxx\.conda\envs\p37\Lib\site-packages
    Linux: /home/username/anaconda3/envs/p37/lib/python3.10/site-packages

而默认的 USER_SITE 和 USER_BASE 变量指向了当前操作系统用户的 .local 目录，而不是你当前 python 环境下的 site-packages 目录。

如果需要详细配置信息请切换到自己的环境下，运行 conda info，观察多个env路径的查找顺序。

然后查看当前环境的配置文件 site.py 的位置：

    $ python -m site -help
    C:\Users\xxxx\.conda\envs\p37\Lib\site.py

    # 如果 Anaconda 安装时选择了“给所有用户安装”，有时候是下面这个
    C:\ProgramData\Anaconda3\envs\p37\Lib\site.py

    # Linux
    /home/username/anaconda3/envs/p37/lib/python3.10/site.py

编辑该 site.py 文件，修改下面两行

    USER_SITE = None
    USER_BASE = None

改为你干脆复制的当前 python 环境下保存包的 site-packages 位置：

    # 注意 USER_BASE 在 Windows 下的目录结构跟 Linux 不同，而且要用 \\ 转义 \
    # 参考
    #       https://docs.python.org/3/library/site.html#site.USER_BASE
    #           https://docs.python.org/3/install/index.html#inst-alt-install-user
    #           https://peps.python.org/pep-0370/

    USER_SITE = "C:\\Users\\xxxx\\.conda\\envs\\p37\\Lib\\site-packages"
    USER_BASE = "C:\\Users\\xxxx\\.conda\\envs\\p37"

如果 env 指向系统路径 C:\ProgramData\Anaconda3\envs 改为

    USER_SITE = "C:\\ProgramData\\Anaconda3\\envs\\p37\\Lib\\site-packages"
    USER_BASE = "C:\\ProgramData\\Anaconda3\\envs\\p37"

如果你建立的路径名环境在项目目录下，如 D:\pycode\your_project 改为

    USER_SITE = "D:\\pycode\\your_project\\env\\py37\\Lib\\site-packages"
    USER_BASE = "D:\\pycode\\your_project\\env\\py37"

Linux 下改为

    USER_SITE = "/home/xxxx/anaconda3/envs/p310/lib/python3.10/site-packages"
    USER_BASE = "/home/xxxx/anaconda3/envs/p310"

如果你使用的命令行工具是 bash，也不需要改为 /d/pycode/your_project/py37 的形式，因为 site.py 是 python 执行，python 根据当前操作系统自动识别路径格式。

验证

    python -m site

    USER_BASE: '.....' (exists)
    USER_SITE: '.....' (exists)

查看后缀是否为 exists，且路径指向了你当前 python 环境下保存包的 site-packages 位置。

## anaconda怎么同时安装2.7和3.6？

前提是你的 anaconda 最高支持到3.7，才可以任意选择低版本的。

下面的操作命令过时了，conda 和 virtuenv 等都更新了命令的用法，以下仅供参考：

    如果你已经安装了 Anaconda Python3.6 版，想要再安装 Python2.7 环境，在命令行中输入：

        conda create -n python27 python=2.7

    想要使用 python2.7 环境同样需要命令

        activate python27（这里面的python27是前面create时自己定义的名字），

    该条命令在 Linux 和 macOS 环境中使用

        source activate python27

    接下来看到命令行的最前端多出来(python27)，这时候已经处在python2.7的环境中了。

    想要退出python2.7进入python3.6，需要再次键入命令deactivate（linux和mac下用source deactivate命令）。

## 在ubuntu系统配置多python环境

### ubuntu16.04自带2个 python 版本

Debian/Ubuntu 下同时安装了python2和python3，既有python2.7，又有python3.5

但是默认的 python 命令是指向 python2.7，要执行 python3 就必须输入python3

    输入命令sudo apt-get install python3.7

    按Y确认

    调整Python3的优先级，使得3.7优先级较高

    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1

    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2

    更改默认值，python默认为Python2，现在修改为Python3

    sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 100

    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 150

### Debian/Ubuntu 如何安装自己版本的python和pip

Debian/Ubuntu 下同时安装了python2和python3，对应的pip也是两个：pip 和 pip3，注意区别。特别是有些脚本不考虑多版本python共存，默认的命令就是pip，在Debian/Ubuntu 下会执行到python2里去了，注意给pip3建立个链接文件，方便使用。

其实用python执行自带的pip即可对应各自版本，这样先指定指定的python会安装到对应的site-package目录，因为pip不区分环境

    python -m pip install xxx

    python3 -m pip install xxx

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

2.解决个zlib库找不到报错的问题

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

    pip 9.0.1 from /usr/lib/python2.7/dist-packages (python 2.7)

5.This step is optional but highly recommended. Namely, you can install a required file that contains all the packages that can be installed with pip. To install the requirements contained in requirements.txt, run the following command:

    sudo pip install -r requirements.txt

6.To upgrade pip for Python 2 to the latest version, run the --upgrade command:

    sudo pip install --upgrade pip

## 著名的python字符串编码问题解释

    https://www.cnblogs.com/chenpython123/p/10965382.html

python 出来的时间太早了，80 年代的操作系统只支持英文，绝大多数软件也只支持英文编码 ANSI，特别是基于 c 语言开发的软件，基本都是把字符串按 ansi 编码的，这个默认规则沿用至今。

90年代，微软 Windows 生意做到了全球，所以推出了各种本地化版本

    中国大陆版的中文 Windows 95，使用 GB-2132 编码，该标准兼容英文的 ANSI，Windows 内置中文字体支持正常显示该编码的中文字符。

    港台日韩等地区的本地化 Windows 版本也有自己的编码标准，都不一致。但是，这些编码里其实都包含汉字的，大陆地区其实可以阅读使用这些编码的文字，只要能正确的按它编码的规则显示文字。

所以，在中文 Windows 下要查看来自日本、韩国、港台等使用其它编码规则字符的文件，需要安装个转码软件，才能正常的显示字符，还需要安装对应的字体文件。所以在 dos/Widnows 95 时代，大家玩很多港台日本的游戏都需要配合一个转码软件如 cjk。

大陆的标准 GB-2132 后来扩展了叫 gbk，也称 cp-936。

全球的语言编码太多了，各种本地化版本操作系统下生成的文本文件，除了大家都兼容的 ANSI 字符，其它字符特别是各地自有的字符，在其他地区的操作系统上无法正常显示。必须安装转码软件或字体文件，如果不知道文件来源，接收方甚至无法手动指定转码软件使用何种规则进行解码。

所以，制定了国际化统一标准通用编码规则 UTF，目的是分区域的把全人类用的字符都统一编码起来，称 unicode，目前的互联网和 Linux 系统一般使用的是 UTF-8 编码规则，使用 UTF 规则进行编码是大势所趋。

全球大多数软件都按照操作系统的本地规则编码解码字符，即读取操作系统的区域语言设置。如果操作系统设置字符编码规则是 gbk，则这些软件默认设置下是无法显示 UTF-8 编码的文件的。不过，只要这个软件可以指定编码规则和字体文件，无论打开何种编码的文件，都可以正常的显示。最常见的就是浏览器了，打开各个国家的网站，可以看到不同的字符，虽然不一定认识，但不是乱码，这是因为 html 网页在制作时写明了自己使用何种编码和字体。

比如简体中文版 Windows 的默认代码页是 GBK（只要你的程序是基于 WIN-CRT 框架的，而不是 .net 等后期新框架），由于一般文字编辑软件默认跟随当前操作系统代码页的设置，导致你打开个 utf-8 编码的文本文件，在 Widnows 记事本中是无法正常显示的，需要手动选择切换编码方式。包括微软的 Windows、Office 的各种本地化版本，都有这种问题（参见 <https://docs.microsoft.com/zh-cn/cpp/c-runtime-library/code-pages?view=msvc-170> ）。大概在 Windows 10 的 2019 年版本才默认对 .appx 应用使用 UTF-8 编码。

如果你修改了操作系统的代码页设置为默认编码 UTF-8，那么 Windows、Office 可以正常显示 UTF-8 文件。但是，在打开 gbk 编码的文件时，如果软件判断使用的编码规则错误，则还是会显示乱码，想正确显示还是需要在软件中手动指定编码规则。

有些老程序没做操作系统代码页适配就玩不转了，比如 CMD 命令行窗口，执行命令：dir c:\，如果操作系统使用 UTF-8 编码，会报错不认识这些字，需要手动设置 cmd 的参数，设置代码页。为嘛这么麻烦呢？ cmd 这货来自 1990 年的 MS-DOS，当年 DOS 操作系统就需要用户手动设置代码页，为保持对老系统的使用习惯兼容，就一直这样了。所以后来微软搞了 power shell，想抛弃 cmd，这也是一个原因。仅对微软来说，光是让 Windows 操作系统内置的程序都可以默认使用操作系统代码页都是一件很头疼的事，何况全球范围的各大软件呢。

CMD 命令 `chcp` 手动设置当前会话的代码页：

    代码页          描述
    936         简体中文 Windows 的 CMD 默认 GBK
    65001       UTF-8代码页
    950         繁体中文
    437         MS-DOS 美国英语

比如，终端模拟器 `mintty`，设置参数切换代码页为 gbk，执行命令 `ls`，可以正常显示当前目录的中文文件名。但执行 `tail` 命令打开个 utf-8 编码的日志文件，显示的是乱码，因为 `tail` 命令实际执行时使用了底层的 c 语言函数，默认适配当前操作系统代码页 gbk 读取文件，晕了没。

在 Windows 下的 python 代码，有个常见的运行时报错：只要该代码使用函数 open() 打开文本文件，会默认使用操作系统代码页 gbk，导致打开现在流行的 utf8 编码的文本文件都报错，解决办法是 open() 函数要加参数 `encoding='UTF-8'`。

所以，各个软件切换使用 UTF 编码不够统一，使用上总是有一定的混乱。而为保持兼容性，直到 2010 年代 Windows 记事本 和 Office 才开始慢慢的切换为默认使用 UTF 编码，对于用户原来使用了 ANSI/GBK 编码的文件，加入了自动判断的功能按照其编码规则正常显示，这时用户的使用体验是无感的。但是对小文件来说，单个或几个字符的字符串，如果软件猜不准其编码规则，显示还是会乱码，需要用户手工指定编码方式。

### python2 的文件编码和字符编码大坑

    NOTE: python2 执行 .py 文件读取文件内容时的编码方式，和对 python 代码中的字符串的编码方式，处理逻辑不一致

python 1 读取 .py 文件使用 ansi 编码，字符串编码也是用 ansi，这个是很久远的历史了，那个时候绝大多数的计算机都使用 ansi 代码页。

python 2 的问题，在于支持全球的本地化代码页的解释方式：

用户在本地化版本 Windows 下建立 .py 文件，如果使用记事本，则默认使用的文本编码是当前操作系统的代码页，如果使用 vs code，则默认使用 UTF-8 规则。比如：用中文 Windows 自带的记事本，保存内容到一个 .py 文件，你会发现文件内容是 GBK 编码（在 2020年代 Windows 10 的后期版本中记事本已经改为默认 UTF-8编码了）。

而 python 2 在执行 .py 文件时，默认使用 ANSI 编码读取文件内容，它不跟随当前操作系统的代码页，估计是为了保持源代码共享时原文件的解释一致性。但这样导致了，.py 文件中只要出现中文字符就报错。

验证下，建立两个文件，编码格式分别是 GBK 和 UTF-8，内容如下，用 python 2 执行

```python

print 'abcdefg'

# 中文注释都报错

```

所以 python 制定了一个规则，统一由用户手动控制文件的编码规则，在 .py 文件的第 1 或 2 行写 `# coding：utf-8`，明确告知 python 2 这个文件的编码使用 UTF-8。当然，这样要求你使用的编辑器，在保存的文件时，可以指定使用 UTF-8 编码方式。你可以尝试下指定编码规则为 `# coding：GBK`，在 python 2 执行该文件不会报错。

.py 文件的编码格式使用 UTF-8 就没问题了？ 不！

    python 2 对代码中字符串的处理，与对 .py 文件的读取，处理逻辑是不一致的，你光设置了.py 文件使用 UTF-8 格式编码是不够的

```python

# coding：utf-8

print 'abcdefg'

# 中文注释不报错了
print '这行用中文报错'

```

python 2 对代码中的字符串，默认使用 ANSI 编码进行解释，即使你的 .py 文件是 UTF-8 编码保存的，python 2 在遇到字符串里的中文字符还是会报错：“UnicodeDecodeError: 'ascii' codec can't decode byte ......”

所以，对 python2 代码里的中文字符串，还得加个前缀 u 表示该字符串使用 unicode 编码，或者用函数 .encode() 指定编码规则。

```python

# coding：utf-8

print 'abcdefg'
print u'abcdefg'

print u'这行字符串用中文用UTF-8编码，不报错'

print '这行字符串用中文转码为UTF-8，不报错'.decode('UTF-8')

print '这行字符串会默认被用 ansi 解码导致报错'

```

python 2 中使用的很多开源包，都是全球网友自制的，对字符串使用各种字符编码方式都有可能，有的使用 ansi，有的使用 utf-8。原因在于很多包、甚至 python 内置函数使用的输入输出流都不指定字符编码方式，即默认使用当前操作系统的代码页设置，如果你使用的是中文版 Windows，如果不指定转换编码规则，读取到的字符串是 gbk 编码，而你的 .py 文件中的操作是按 utf-8规则，不一致就会报错。所以很多时候你调用别人的包的函数，如果返回值是字符串的时候，在接收该值的时候最好指定下编码方式，以防止报错，如：

    # 视情况而定，得看他包的源码到底如何处理字符串编码的
    my_str1 = received_from_other_pkg_string.decode('UTF-8')

    other_pkg_function(my_str2.encode('UTF-8'))

最好的办法是

    python 所有的包、所有的文件、所有的字符串默认都用 UTF-8 编码。

直到 python 3 才统一了这个规则，好难是吧。。。

那统一了就完美解决问题了么？ 不！python 3 留了个坑：涉及本地输入输出流的字符串编码方式，默认是本地化的。python 字符串编码问题的普遍性和难以根除就在于此。

python3 内置的 open() 函数的返回结果，默认使用当前操作系统的代码页，比如在中文 Widnows 下是 GBK：

    python2 执行 .py 文件默认用 ansi 编码读取文件内容，假如开发者为了保持统一，设置 .py 文件头声明用 utf-8，这样只是解决了 .py 文件的编码方式统一性问题。但如果遇到代码中调用 python 内置的 open() 函数，返回值的字符串编码规则，仍然是本地化的！比如，中文 Windows 下执行该 .py 文件，open() 函数返回的字符串仍然需要转码。

    python3 同样，执行 .py 文件虽然改为使用 UTF-8 编码读取内容，使用 python3 内置的 open() 函数仍需要对接收的返回结果字符串进行转码。

常见的经典现象：

    `pip install  -r` 命令，pip 命令是 python 写的，其源代码中使用这个 open() 函数打开文件时，未指定 encoding 参数。所以对命令 `pip install -r requirements.txt`，如果 requirements.txt 文件使用了 UTF-8 编码，且里面有中文注释，在中文 Windows 下会报错 “UnicodeDecodeError: 'gbk' codec can't decode byte...”。解决办法是：把该文件转换编码为 GBK，或者用户自己修改 pip 命令的 .py 文件：找到 pip 命令源代码中调用 open() 函数的地方，加上参数 `encoding='UTF-8'`，或在接收返回值处给字符串转码 “ .decode('UTF-8')”。

    对网络爬取的包比如 request、lxml，花样更多了，它还会根据读取到的 html 文件中写的编码方式转换输入输出缓冲区，最终你对缓冲区获得的字符串，很可能需要再转一次编码方式才能正常使用。

所以，通用的解决方式不好找，在 Linux 下统一用 UTF-8 规则就少了很多幺蛾子，在中文 Windows 下，只能是多调试了。

## python 常用法

```python

    import itertools

    # 拉平为一维 [0  1  2  11 12 13]
    # pos_arr_1d = np.array([y for x in valid_pos_2dlist for y in x])
    # 多维数组转换为一维最有效率的做法 https://blog.csdn.net/qq_36853469/article/details/106928360
    # 展开列表内嵌的列表或组合两个列表可以用 itertools.chain https://blog.csdn.net/woshisunyizhen/article/details/103157881
    # list(itertools.chain(config_cc.values()))
    pos_arr_1d = list(itertools.chain.from_iterable(valid_pos_2dlist))

    # 取第一个值，这里依赖Python3.7字典是有序的
    code = next(iter(stock_dict.keys()))

```

## 下载开发版的软件库以便调试问题

    https://github.com/ranaroussi/yfinance/discussions/1080#discussioncomment-4778895

1: Download from GitHub:

    git clone https://github.com/ranaroussi/yfinance.git

Or if a specific branch:

    git clone -b dev https://github.com/ranaroussi/yfinance.git

2: Add download location to Python search path

Two different ways, choose one:

    add path to PYTHONPATH environment variable
    add to top of Python file: import sys ; sys.path.insert(0, "path/to/downloaded/yfinance")

3: Verify

    import yfinance
    print(yfinance)

Output should be:

    <module 'yfinance' from 'path/to/downloaded/yfinance/yfinance/__init__.py'>

If output looks like this then you did step 2 wrong

    <module 'yfinance' from '.../lib/python3.10/site-packages/yfinance/__init__.py'>

## 安装 TA-Lib 行情数据指标库

    https://ta-lib.org/

TA-lib 只发布了 c 语言源代码，所以如果想调用，需要先自行编译为操作系统使用的 c 运行库，即下面的步骤 1。

如果使用 python 调用系统环境里的 talib c 运行库，还要安装它的 python 封装，即下面的步骤 2。

如果嫌麻烦，可以换用 pandas 实现它的各种函数

    https://github.com/twopirllc/pandas-ta

### 1、安装 TA-lib c 运行库

安装 TA-lib，其实安装的是从源代码编译的 c 运行库到你的操作系统或应用程序环境下。

    https://github.com/TA-Lib/ta-lib

        原 https://github.com/mrjbq7/ta-lib
            https://ta-lib.github.io/

            原 https://sourceforge.net/projects/ta-lib/
            基于源代码 http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz

#### Windows 安装 TA-lib c 运行库

简单使用的话，可以下载别人编译好的安装包：

法一：直接下载 talib 维护者提供的编译好的二进制包

    https://github.com/TA-Lib/ta-lib/releases

安装：执行 .msi 安装包，会安装到你的 Windows 的系统目录下，这样所有的环境都可以调用它。

法二：下载好心人编译好的二进制包 python .whl，这样可以只安装到你的 python 环境下

    https://github.com/cgohlke/talib-build/releases
        原 http://www.lfd.uci.edu/~gohlke/pythonlibs/#ta-lib

安装：在你的 python 环境下安装该 .whl 文件

    $ conda activate p37
    $ pip install TA_Lib-0.4.21-cp37-cp37m-win_amd64.whl

法三：使用 anaconda quantopian 版本

    https://anaconda.org/quantopian/ta-lib

如果要自己编译：用 Visual Studio 2022 社区版打开源码自行编译

    https://ta-lib.org/install/#windows-build-from-source

    C:\ta-lib> "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
    C:\ta-lib> mkdir build
    C:\ta-lib> cd build
    C:\ta-lib\build> cmake ..
    C:\ta-lib\build> cmake --build .

You might need to adjust the vcvarsall.bat command depending on your VSCode installation and platform.

#### Linux 安装 TA-lib c 运行库

Linux 下只能从源代码自行编译安装

    https://github.com/TA-Lib/ta-lib/blob/main/docs/install.md#linux-build-from-source
        https://ta-lib.org/install/#linux-build-from-source

1、下载源代码

    # 早期的 sourceforge时代原作者 0.4.0 源代码，可以正常用的。
    # wget http://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz
    # tar -xzf ta-lib-0.4.0-src.tar.gz

    推荐直接下载迁移到 github 后的版本，下载后解压缩，可以直接编译的，这个最新最方便

        https://github.com/TA-Lib/ta-lib/releases/download/v0.6.4/ta-lib-0.6.4-src.tar.gz

    或者 git 下载最新的开发中代码，需要自行调试编译参数才能 make
    $ git clone --depth=1 https://github.com/TA-Lib/ta-lib

2、自行编译为 c 运行库

    # https://github.com/TA-Lib/ta-lib-python/issues/594#issuecomment-1523606397
    # 如果你的应用中加密货币的单位特别小显示不出来后面的数，比如兑换 BTC 的货币对单位是 0.0000000000001
    # 修改下代码，把显示单位的长度放大即可：
    # 不要改了，https://github.com/TA-Lib/ta-lib 处的代码更新了
    # $ sed -i 's/0.00000000000001/0.000000000000000000000000001/g' src/ta_func/ta_utility.h

    # 然后设置编译参数，默认安装到操作系统 /usr/local/lib
    $ ./configure
    $ make

可以给 `configure` 手动指定路径，添加参数 --prefix=/usr，则 `make install` 会安装到 /usr/lib64，注意指定路径注意不需要写 ./lib 这一级，`make install` 时会自行添加，比如写 /usr 会生成到 /usr/lib64 下。

3、复制到你的运行环境中

    # 这里安装到操作系统目录需要 sudo 执行，会提示生成到哪个目录下了
    $ sudo make install
    Libraries have been installed in:
        /usr/local/lib

也可以手动将编译好的库文件复制到你的 python 环境的虚拟目录中，这样就可以保持操作系统 /usr/lib 目录内容的纯净

    $ ./configure --prefix=$HOME/pyenvs/py310
    $ make
    $ make install  # 会提示生成到哪个目录下了
    Libraries have been installed in:
        /home/user/pyenvs/py310/lib

如果不想用 `make install`，也可以自行拷贝到自己想要的目录下：

    $ cp /usr/lib/libta_lib* ~/py37/lib

    # centos8:
    $ cp /usr/lib64/libta_lib* ~/py37/lib

### 2、安装 TA-lib python 封装

    https://github.com/TA-Lib/ta-lib-python
        https://pypi.org/project/ta-lib/

这个封装依赖 ta-lib 的 c 运行库和 numpy，所以做完前面的第 1 步后，即可直接从 pypi 安装：

    $ conda activate p37
    $ pip install numpy TA-Lib

还可从 Conda Forge 安装：

    # https://anaconda.org/conda-forge/ta-lib
    $ conda install -c conda-forge ta-lib

> 不嫌麻烦自行编译

    https://ta-lib.github.io/ta-lib-python/install.html

1、切换到你的环境下

    $ conda activate p37

2、你的环境或操作系统中已经安装了 ta-lib 的 c 运行库，即先执行完前面的第 1 步。

3、你的环境中安装了 numpy

    # https://github.com/TA-Lib/ta-lib-python/issues/661#issuecomment-2207912052
    $ pip install numpy

4、然后才可以从 python 源代码编译安装 python wrapper：

先安装 python 的 c 头文件，否则编译时会报错 'Python.h: No such file or directory'

    # https://blog.csdn.net/xk_xx/article/details/123166742
    $ sudo dnf install python3-devel  # Fedora
    $ sudo apt install python3-dev    # Debian

然后才可以从 python 源代码编译了

    # 如果前面安装 c 运行库时指定了生成的路径 `./configure --prefix=/usr`，则这里需要设置环境变量
    $ export TA_LIBRARY_PATH=/usr/lib64
    $ export TA_INCLUDE_PATH=/usr/include

    $ git clone --depth=1 https://github.com/TA-Lib/ta-lib-python
    $ cd ta-lib-python
    $ python setup.py install

## 配置 VS Code

    https://code.visualstudio.com/docs#vscode

从源码构建 vscode

    ttps://cloud.tencent.com/developer/article/1588399

历史记录保存位置

    %APPDATA%\Code\User\History

配置文件是给调试模式用的

    %APPDATA%\Code\User\settings.json

        https://code.visualstudio.com/docs/editor/debugging#_launch-configurations

    调试模式可以在库中加断点 在.vscode\launch.json 中添加"justMyCode": false

    添加环境变量："env": { "QT_QPA_PLATFORM": "xcb" }

插件安装位置

    %USERPROFILE%\.vscode

### Linux 下安装 vs code

    https://code.visualstudio.com/docs/setup/linux

比较安全又方便的是在 distrobox 里安装使用 vscode

    https://ublue.it/guide/toolbox/#integrating-vscode-with-distrobox

    https://distrobox.privatedns.org/posts/integrate_vscode_distrobox.html

    两种方式：

        在 distrobox 里安装 vscode，然后用 distrobox-export 导出到主机下使用。这样 vscode 集成的终端及插件都在 distrobox 里运行。

        或者在主机安装 vscode，使用插件 Dev Containers 来连接使用 distrobox。

也可集成安装到 toolbox 中

    https://github.com/owtaylor/toolbox-vscode

VSCodium

    https://github.com/VSCodium/vscodium/blob/master/DOCS.md

    VSCodium 从 VS Code 中移除了遥测部分。除此之外，它就是这个微软项目的克隆版，在外观和功能上与著名的 VS Code 完全相同。不过插件商店也改为开源的了，这样无法使用微软的那些官方插件了。。。
        https://www.roboleary.net/tools/2022/04/20/vscode-telemetry.html

        https://zhuanlan.zhihu.com/p/71050663

不嫌麻烦可以安装 flatpak 版 VSCode、VSCodium

    https://github.com/flathub/com.vscodium.codium/

    终端下打印 'Warning: waitpid override ignores groups' 的说明

        https://github.com/flathub/com.visualstudio.code/issues/370

### vscode 插件

插件的安装位置为 C:\Users\你的用户名\.vscode\extensions

#### 中文语言包

    MS-CEINTL.vscode-language-pack-zh-hans

#### 护眼主题

在 vscode 下按 F1 输入命令 'Generate Color Theme From Current Settings'，会自动新建一个 theme 文件，自己慢慢研究吧

    开发指南

    https://github.com/bcomnes/tron-legacy-vscode/blob/master/vsc-extension-quickstart.md

        各种图形对象说明 https://code.visualstudio.com/api/references/theme-color

        语法着色说明 https://code.visualstudio.com/api/extension-capabilities/theming#textmate-theme-rules

        添加颜色主题 https://code.visualstudio.com/docs/extensions/themes-snippets-colorizers#_adding-a-new-color-theme

看代码和看文字有些区别，对比度以字体清晰可辨，段落分隔明显，亮度以清晰长时间看眼睛不费力为原则。

整体的亮度很重要：除了白天和黑夜，不同的光照条件下，不要只用一个主题，根据环境光亮度酌情切换，下为建议：

浅色

|            看代码                              |          看文字            |
|-----------------------------------------------|---------------------------|
|   MacOS Modern Light：Xcode Default           |         <----             |
|                                               | Solarized Light           |
|                                               | Winter is coming：Light    |

深色

|            看代码                             |           看文字              |
|----------------------------------------------|-------------------------------|
|   MacOS Modern Dark：Ventura Xcode Default   | MacOS Modern Dark：Xcode Modern|
|   Nord                                       |          <----                |
|                                              | Material Neutral              |
|   Winter is coming：Dark Blue                | Winter is coming：Dark Black   |

MacOS Modern Theme 看代码深色浅色都好，多选单选查找相关内容高亮颜色都有区分，而且不刺眼

    davidbwaters.macos-modern-theme

凛冬来临 Winter is coming，对比度好清晰不刺眼，深浅主题都可以。

    johnpapa.winteriscoming

北极 Nord，夏夜使用，凉爽的感觉

    arcticicestudio.nord-visual-studio-code 适合环境亮度高的时候使用

    marlosirapuan.nord-deep     深点的北极，适合低光

    dnlytras.nord-wave          最深的北极，适合无光

Material Neutral 深色看文字比较养眼

    bernardodsanderson.theme-material-neutral

Solarized Light（vscode 自带），这个是羊皮纸底色，但是语法高亮浅蓝色太多，视物不清，需要自改。

创·战纪

    风格来源
        https://disneyworld.disney.go.com/attractions/magic-kingdom/tron-lightcycle-run/

    Tron Dark Themes 有蓝、黄、橙三种配色，酷
        Vaporizer.tron-theme

        TronLight Theme 语法文件好，只是蓝色的，不刺眼
            gerane.Theme-TronLight

        Tron Legacy 语法文件好，蓝色配红橙
            gerane.Theme-TronLegacy

#### 图标

产品主题图标

    davidbwaters.macos-modern-theme 自带的就好

文件图标

    vscode-icons-team.vscode-icons

#### 不得不用 github copilot

OpenAI 等人工智能助理是大势所趋了，不得不用了。会提示2个登录：

    copilot 使用 github 账户登录，先登录网页版 github，然后点击授权第三方即可

    然后 copilot 会申请读取 github 账户，同样在网页版 github 出点击授权同意即可

之前为了代码安全，不使用 AI 代码完成的相关插件，因为可能会把你的代码上传服务器，包括 kate、IntelliCode、github copilot 等。

    java 软件包安装会默认安装 IntelliCode，注意禁用。

    python 软件包为兼容老版本不用 pylance 的习惯，所以默认不安装 IntelliCode，不代表以后不装。

    python.languageServer 用 Pylance

        原来用的 Jedi

            https://docs.microsoft.com/zh-cn/visualstudio/intellicode/intellicode-visual-studio-code

            "python.jediEnabled": True, // Falses

            "python.languageServer": "Jedi" // "Pylance"

> 使用代理连接

有些用户（比如中国大陆的用户）可能会遇到Copilot不工作的问题，原因是Copilot无法访问互联网或Github api。你可以在输出面板上看到以下错误信息：GitHub Copilot could not connect to server. Extension activation failed: "connect ETIMEDOUT xxx.xxx.xxx:443"。

在这种情况下，你需要设置http代理。

然后，打开VSCode的设置，搜索 'http.proxy'，并设置代理地址和端口。

设置完成后，重新启动VSCode，Copilot应该可以正常工作。

#### 远程开发： Remote Development

装这一个就会自动装一堆

    ms-vscode-remote.vscode-remote-extensionpack

    ms-vscode.remote-explorer

远程开发最大的好处是你不需要在本地计算机保留代码了，省去每次在本地用 git 提交并推送远程仓库，然后 ssh 连接到远程开发机，再用 git 拉取同步代码，然后才能调试运行。当然了，开发机上的代码做了修改也要推送远程仓库的。

Visual Studio Code Remote Development 允许您连接使用如下方式到远程服务器

一、容器 container： vs code 直接编辑容器并使用

二、连接到 Windows Linux 子系统 （WSL）：直接打开 wsl 环境下的文件夹

三、ssh 连接到远程计算机：vs code 直接打开远程开发机上的文件夹进行编辑和调试运行

首次连接到远程后需要等一下，vs code 会自动在远程服务器上安装 vs code server（在~/.vscode-server 目录下），此时打开的终端也是连接到远程后的tty了。

需要在服务器上也安装扩展才能使用，点击 vs code 的侧栏“扩展”按钮，会看到你安装过的那些扩展都有了个提示 “Install in SSH：XXX”，酌情选择后点击安装即可。

实质上是利用 ssh 端口转发在本地查看远程运行的 vs code server 的内容。

打开远程ssh文件夹后，各插件不可用？

    删除服务器上的 ~/.vscode-server 目录，重新安装插件
    Extension not working on remote SSH?  Remove directory ~/.vscode-server
    https://github.com/microsoft/vscode-remote-release/issues/1443

四、远程隧道：微软提供中继服务的 SSH 端口转发，这样ssh连接内网计算机不需要有外网 ip 的 ssh中转服务器做反向端口转发了。

    1、远程开发机下载安装 code cli，运行 `code tunnel --accept-server-license-terms --disable-telemetry`，根据提示登陆 github 网址，输入 user code。这样就在你的 github 账户中注册了这台开发机。

    2、客户端或使用 https://vscode.dev/ 都可以，登录你的 gihub 账户或微软账户。点击 vscode 的用户账户图标，在弹出菜单中选择你的远程隧道，这就实现了从任何能连公网的地方连接到开发机上进行开发。

利用远程隧道，你可以实现一次登录，处处运行，996 越玩越开心：

    你可以无缝的从一台设备切换到另一台设备，代码保存在内网的开发机，你开会前在台式机上写代码，开会时拿起笔记本继续写刚才的代码，下班可以直接关掉公司的电脑，在回家路上用手机登陆网页版 https://vscode.dev/ 继续写代码，回到家打开家里的电脑还可以继续写代码。。。开发机上的代码环境，只要你打开 vs code 登陆 github 账户即可选择恢复。

服务端配置远程隧道开机自启(需要管理员权限)

    没有 systemd 的计算机执行下述命令使得 code 以用户服务守护运行

        code tunnel service install --accept-server-license-terms --disable-telemetry

    使用 systemctl 管理的 linux 服务器上，服务将可以使用 systemctl 进行管理

        systemctl enable code-tunnel --now

    下列示例以 ubuntu 为例，手动创建 systemctl 配置文件，并以普通用户（但可以使用sudo）启动tunnel 。

        https://www.cnblogs.com/pdysb/p/17067042.html

    配置自启动文件，自建 /etc/systemd/system/vscode-tunnel.service 文件，填写以下配置

        ```conf

        [Unit]
        Description=Visual Studio Code Tunneli2
        After=network.target
        StartLimitIntervalSec=0

        [Service]
        Type=simple
        Restart=always
        User={{your-user-name}}
        RestartSec=10
        ExecStart= {{path-to-your-code}} "--verbose" "--cli-data-dir" "{{path-to-your-root-dir}}/.vscode-cli" "tunnel" "service" "internal-run"

        [Install]
        WantedBy=multi-user.target

        ```

    ⚠ 注意

        your-user-name 是指你希望 tunnel 以什么用户身份运行

        path-to-your-code 是指实例中 vscode cli 的位置，即示例中解压的位置。

        path-to-your-root-dir 是指 cli 配置文件所在目录，一般是第一次运行示例时候自动产生的，如 ~/.vscode-cli 目录。

    验证：

        code --verbose --cli-data-dir ~/.vscode-cli tunnel service internal-run

    设置开机自启动

        systemctl daemon-reload
        systemctl restart vscode-tunnel

        systemctl staus vscode-tunnel  # 看看有无错误

#### GitLens

干扰文件内容显示太多了，酌情考虑

    eamodio.gitlens

#### Git History

非常实用，可惜不更新了

    donjayamanne.githistory

#### 书签

    alefragnani.Bookmarks

#### todo tree 记录你的待办

1、TODO Highlight v2

    jgclark.vscode-todo-highlight

```json
    // Todo Highlight
    // "todohighlight.isCaseSensitive": true,
    "todohighlight.keywords": [
        "BUG:",
        {
            "text": "TODO:",
            "regex": {
                "pattern": "(?<=^|\"|\\s)TODO(\\(\\w+\\))?:"
            },
            "color": "#ffffff",
            "backgroundColor": "#b96a03"
        },
        {
            "text": "FIXME:",
            "color": "#30fdfd",
            "backgroundColor": "#e4136a",
            "overviewRulerColor": "#e4136a"
        },
        {
            "text": "XXX:",
            "color": "#2b313d",
            "backgroundColor": "#10dfdf",
            "overviewRulerColor": "#10dfdf"
        },
        {
            "text": "NOTE:",
            "color": "#e0bb3f",
            "backgroundColor": "#005f87",
            "overviewRulerColor": "#005f87",
            "isWholeLine": true
        },
    ],"todohighlight.include": [
        "**/*.md",
        "**/*.py",
    ],
    "todohighlight.exclude": [
        "**/node_modules/**",
        "**/bower_components/**",
        "**/dist/**",
        "**/build/**",
        "**/.vscode/**",
        "**/.vscode-test/**",
        "**/.github/**",
        "**/_output/**",
        "**/*.min.*",
        "**/*.map",
        "**/.next/**"
    ],
    "todohighlight.maxFilesForSearch": 5120,
    "todohighlight.toggleURI": false,

```

2、备选 Todo Tree：分类显示常见的 TODO/FIXME 为标签，缺点是在粘贴文本的时候 vscode 响应慢。

    Gruntfuggly.todo-tree

```json
     // Todo Tree
    "todo-tree.highlights.customHighlight": {
        "TODO": {
            "icon": "tasklist",
            "iconColour": "#b96a03",
            "foreground": "#ffffff",
            "background": "#b96a03",
            "type": "tag"
        },
        "FIXME": {
            "icon": "eye",
            "iconColour": "#e4136a",
            "foreground": "#30fdfd",
            "background": "#e4136a",
            "type": "tag"
        },
        "XXX": {
            "icon": "beaker",
            "iconColour": "#10dfdf",
            "foreground": "#2b313d",
            "background": "#10dfdf",
            "type": "tag"
        },
        "NOTE": {
            "icon": "info",
            "iconColour": "#005f87",
            "foreground": "#e0bb3f",
            "background": "#005f87",
            "type": "tag"
        }
        // "[x]":{
        //   "foreground": "#64dd17",
        //   "background":"#008800"
        // },
        // "[ ]":{
        //   "foreground": "#f44336",
        //   "background": "#592c2c",
        // },
    },
    // "todo-tree.regex.regex": "((//|#|<!--|;|/\\*|^)\\s*($TAGS)|^//\\s*\\[x\\]|^//\\s*\\[ \\])",
    "todo-tree.general.tags": [
        "TODO",
        "FIXME",
        "XXX",
        "NOTE"
        //"[ ]",
        //"[x]"
    ],
    "todo-tree.general.tagGroups": {
        "FIXME": [
            "FIXME",
            "FIXIT",
            "FIX",
            "BUG"
        ],
        "XXX": [
            "XXX",
            "HACK"
        ]
    },
    "todo-tree.general.statusBar": "tags",

```

#### 高亮空格并消除

Trailing Spaces

    shardulm94.trailing-spaces

#### 正则表达式预览

Regexp Explain

    LouisWT.regexp-preview

RegExp Preview and Editor 废弃了

    le0zh.vscode-regexp-preivew

#### 查看sqllite数据库

sqlite

    alexcvzz.vscode-sqlite

优选工具

    DB Browser for SQLite  https://github.com/sqlitebrowser/sqlitebrowser

    SQLiteStudio https://github.com/pawelsalawa/sqlitestudio

#### MarkDown 文件格式

markdownlint 语法检查、格式化

    DavidAnson.vscode-markdownlint

缺点是在粘贴文本的时候 vscode 响应慢，可以在配置文件中设置仅保存文件时进行检查以缓解：

    "markdownlint.run": "onSave",

屏蔽当前行，添加如下内容即可

    <!-- markdownlint-disable-line -->

选装：

Markdown All in One 高亮，预览，给md文件加目录

中文英文之间加入空格，所谓“盘古空白”

    xlthu.pangu-markdown

#### csv文件查看

Rainbow CSV

    mechatroner.rainbow-csv

```json
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

```

#### JScript/Json的格式化，比系统自带的好用

Prettify JSON，格式化json文件很好用，容错率高

    mohsen1.prettify-json

Prettier - Code formatter

    esbenp.prettier-vscode

#### shell 脚本格式化

    foxundermoon.shell-format

#### PYQT Integration

在 qt 的 ui 文件上右键即可编译，非常方便

    zhoufeng.pyqt-integration

参数需要设置指向你的环境里安装的 pyqt5_tools 包里的工具

    "pyqt-integration.qtdesigner.path": "C:\\ProgramData\\Anaconda3\\Lib\\site-packages\\pyqt5_tools\\designer.exe",
    "pyqt-integration.pyuic.compile.filepath": "..\\uicode\\Ui_${ui_name}.py",
    "pyqt-integration.pyrcc.compile.filepath": "..\\uicode\\${qrc_name}_rc.py",

#### python 环境管理器

比官方的更直观，在侧栏图标选择后用树形列表的方式列出你当前所有相关的 python 环境，支持 conda、virtualenv 等

    donjayamanne.python-environment-manager

#### Python Docstring Generator 自动添加函数头说明

废弃，官方有这个功能了。

autoDocstring - Python Docstring Generator

    njpwerner.autodocstring

可配置文本风格

    "autoDocstring.docstringFormat": "numpy",

#### vi 完整模拟了 vim 的各种操作

懒得用鼠标，就它了，缺点是偶尔会乱，常按 esc 吧。偶尔发现混入非空白字符的不可见字符，算了别用了。

    vscodevim.vim

    这个插件还可以配置模拟几个著名的插件 https://github.com/VSCodeVim/Vim#vim-airline

用起来的习惯跟 vim 基本保持一致，但是估计是为了保持 Windows 下的操作习惯及方便：

    非编辑方式下，可以鼠标操作：拖动选择、复制粘贴

    保留了 vscode 保存文件的热键 ctrl+s，

    在文本编辑状态也支持 Windows 热键比如复制粘贴 ctrl+c/ctrl+v，

    注意：

        撤销 ctrl+Z 只能在 vs code 的菜单或命令中执行，支持多次撤销。如果使用 vim 的热键 u，则只能撤销一次。

        其他的常用编辑热键也都是这样，比如全选 ctrl+ A，只能在vs code 的菜单或命令中执行

vim 脚本语言语法高亮

    XadillaX.viml

#### 中文简繁转换

Chinese Translation

    Compulim.vscode-chinese-translation

选择文字后，F1 输入命令：Chinese Translation，在列出的可用命令中选择一个即可，一般选 `Traditional Chinese to Simplified Chinese` 即可。

#### 预览 svg 图片

SVG 图片语法高亮和预览

    jock.svg

#### Draw.io Integration

    hediet.vscode-drawio

#### UMLet 简单好用的 UML 流程图

Free UML Tool for Fast UML Diagrams 生成一个".uxf"文件打开即可使用

    TheUMLetTeam.umlet

#### vscode-mindmap 脑图

json文件格式节点图。生成一个".km"文件打开即可使用

    Souche.vscode-mindmap

#### Graphviz Dot 文件查看

Graphviz Interactive Preview 支持路线高亮

    tintinweb.graphviz-interactive-preview

    F1命令呼叫预览

Graphviz (dot) language support for Visual Studio Code 语法高亮，可生成Html代码

    joaompinto.vscode-graphviz

    右键菜单呼叫预览

### vscode 用的 Python 配套包

    这些包需要在你当前环境下安装，如果按 vscode 提示安装，默认会安装到你的基础环境中，自动适应conda 或 virtualenv。

    如果你远程连接服务器进行开发，则服务器上的对应环境下也需要安装这些包，否则无法使用该功能。

    目前 flake8 被 vscode 做成插件(ms-python.flake8)了，已经不需要在各个环境下安装了，不知道 yapf 何时也这么处理。

用 python 安装这些包的问题是你的每个 python 环境都得安装，微软现在正在开发 vscode 的扩展引入这些包，免除 python 环境依赖。

#### pylance 快速解析，代码自动完成更快

pylance 目前是 python 插件默认安装了

    ms-python.vscode-pylance

自带这个插件对逐个排查 import 的使用方式来说没用，建议禁用

    ms-python.isort

#### use typestub for VSCode pylance

Let pyqtgraph use PyQt6's pyi file

    https://github.com/microsoft/pylance-release/issues/4823
        https://github.com/pyqtgraph/pyqtgraph/issues/2409

    其它的流行的库的 typestub https://github.com/microsoft/python-type-stubs/tree/main/stubs

1. Copy "QtCore.pyi/QtGui.pyi/QtWidgets.pyi" from

    ~/anaconda3/envs/p310/lib/python3.10/site-packages/PyQt6

to

    /your/custom/dir/typings/pyqtgraph/Qt

or make a link for the .pyi files

You can set a separated dir for your environment in VSCode :

    "python.analysis.stubPath":"/your/custom/dir"

2. To make aliasing work，such as pyqtgraph:

    import pyqtgraph as pg
    pg.Qt.QtWidgets.QPushButton('hello')

add the following:

/your/custom/dir/typings/pyqtgraph/__init__.pyi:

    from . import Qt as Qt

/your/custom/dir/typings/pyqtgraph/Qt/__init__.pyi:

    from . import QtWidgets as QtWidgets

3. bash shell for all above

```bash
#!/bin/sh
# https://github.com/microsoft/pylance-release/issues/4823

if uname -s |grep -i linux >/dev/null 2>&1; then
    os='linux'
else
    os='windows'
fi

# ---> Modify here with your envs
ENV_BASE="${HOME}/anaconda3/envs/p310"

if [[ $os = 'linux' ]]; then
    ENV_DIR="${ENV_BASE}/lib/python3.10"
else
    ENV_DIR="${ENV_BASE}/Lib"
fi

TYPINGS_BASE="${ENV_BASE}_typestub/typings"
mkdir -p  $TYPINGS_BASE

function typestub_for_pg {

    typings_for_pg="${ENV_DIR}/site-packages/PyQt6"

    typings_pg="${TYPINGS_BASE}/pyqtgraph/Qt"
    mkdir -p $typings_pg

    cd $typings_pg

    echo "from . import Qt as Qt" > ../__init__.pyi

    for fname in $(ls ${typings_for_pg}/*.pyi); do
        if [[ $os = 'linux' ]]; then
            ln -s $fname
        else
            cp $fname .
        fi
    done

    > __init__.pyi
    for fname in $(ls *.pyi |grep -v __init__); do
        ff=$(basename -s .pyi ${fname})
        echo "from . import $ff as $ff" >>__init__.pyi
    done
}

typestub_for_pg

echo -e "\nAdd below to your VSCode settings: \n     \"python.analysis.stubPath\":\"${TYPINGS_BASE}\","

```

vs code 设置，酌情对 pyqtgraph 等封装比较深的库，把解析的深度也加大：

```jsonc
    "python.analysis.stubPath":"/your/path/to/typestub_env_p310/typings",
    "python.analysis.packageIndexDepths": [
        {
            "name": "matplotlib",
            "depth": 3
        },
        {
            "name": "pyqtgraph",
            "depth": 8,
            "includeAllSymbols": true
        },
        {
            "name": "PyQt6",
            "depth": 6,
            "includeAllSymbols": true
        }
    ],

```

#### 格式化 yapf、black

 vscode 整合了代码格式化及代码规范检查 lint 工具，不再使用 python 包 yapf，用户在扩展里选择微软官方的 ms-python.black-formatter 或 ms-python.autopep8，建议 black。

```json
    // python 的格式化工具用 black
    "black-formatter.args": [
        // https://black.readthedocs.io/en/stable/the_black_code_style/current_style.html
        "--skip-string-normalization"  // 双引号字符串太乱了
    ],
```

black 的简单用法

    https://black.readthedocs.io/en/stable/the_black_code_style/current_style.html

禁用一行：

    某行后面的注释  # fmt: skip

禁用代码块：

    # fmt: off
    你的代码块
    # fmt: on

    也兼容 yapf 的禁用用法。

> python 包 yapf

```json
    "python.formatting.provider": "yapf",
    "python.formatting.yapfArgs": [
        // "--sytle=yapf_style.cfg"
    //"python.formatting.autopep8Args": ["--ignore","E402"],
    ],
```

用 conda 在指定环境中安装 yapf，这个直接带二进制包：

    conda install --name p37 yapf -y

禁用代码块

    # yapf:disable
    你的代码块
    # yapf:enable

禁用一行

    某行后面的注释  # yapf:disable

#### 代码规范检查 flake8

 vscode 整合了代码格式化及代码规范检查 lint 工具，不再使用 python 包 flake8 ，用户在扩展里选择微软官方的 ms-python.flake8 即可。

```json
    // python 的 lint 工具用 flake8，参数调整为配合 black
    // 适应 black 规则 https://black.readthedocs.io/en/stable/the_black_code_style/current_style.html#flake8
    "flake8.args": [
        // compatible with black
        "max-line-length = 88",
        "--ignore",
        "E203"
    ],
```

> python 包 flake8

```json
"python.linting.enabled": true,
"python.linting.pylintEnabled": false,
"python.linting.flake8Enabled": true,
"python.linting.flake8Args": [
    "--max-line-length=100",
    // "--ignore=E501, E262",
],
```

flake8 的规则非常规矩，好用

    https://gitlab.com/pycqa/flake8/
    # pip install flake8

在要忽略 flake8 检查的那一行加上 # noqa 注释即可

整个文件禁用的话，在文件第一行

    # flake8: noqa

最近出来个竞品 Ruff，可以替换 flake 8

     charliermarsh.ruff

        各规则都实现了 https://beta.ruff.rs/docs/rules/#pyflakes-f

#### 代码测试 unittest

单元测试如果不使用 pytest，那就用最基础的 python 系统包 unittest。

使用 pytest

pytest 兼容 unittest，不写子类也可以用的。

记得在项目跟目录放个空文件 conftest.py

    https://stackoverflow.com/questions/10253826/path-issue-with-pytest-importerror-no-module-named-yadayadayada/50610630#50610630

#### pylint 代码静态分析工具

    https://github.com/PyCQA/pylint

pyreverse 生成 UML 的包图和类图（pylint 自带）

    pyreverse -ASmy -o png your/

代码复杂度 Mccabe

    https://github.com/PyCQA/mccabe

整合上述多个代码分析工具 prospector

    https://github.com/PyCQA/prospector
        https://prospector.landscape.io/en/latest/supported_tools.html

#### 性能分析 runsnakerun

runsnakerun 需要安装图形库 wxPython4

    python3 导入版 https://github.com/venthur/snakerunner
        一个动画地图库 https://github.com/jpenilla/squaremap

使用说明

    http://www.vrplumber.com/programming/runsnakerun/

    https://cci.lbl.gov/docs/phenix/prog_runsnake/

For Debian/Ubuntu distributions the prerequisite setup looks like this:

    apt-get install python-profiler python-wxgtk2.8 python-setuptools

RunSnakeRun and SquareMap will install well in a VirtualEnv.

if you would like to keep them isolated (normally you do not want to use the --no-site-packages flag if you are doing this).

I recommend this approach rather than using easy_install directly on your Linux/OS-X host.

    virtualenv runsnake

    source runsnake/bin/activate

### vs code 填坑

Visual Sutdio 2022 中使用 python 虚拟环境

    https://docs.microsoft.com/zh-cn/visualstudio/python/managing-python-environments-in-visual-studio?view=vs-2022

vscode 外网访问内网使用 ssh和远程桌面

    https://github.com/microsoft/vscode-docs/blob/master/remote-release-notes/v1_37.md

#### vscode 在 Windows 下不断提示输入 ssh 密钥的保护密码

    https://stackoverflow.com/questions/42707896/vscode-keep-asking-for-passphrase-of-ssh-key

前提

    安装了 Git for Windows，使用 git 协议（底层是 ssh）操作你的项目，已经配置好可以用密钥 ssh 连接到服务器，已经配置好了 ssh-agent 缓存密钥，在 git-bash（mintty bash）下可以正常使用 git 的 push、pull 进行推送和拉取，不再提示密钥的保护密码。

问题现象

    在 vscode 下每次 pull 代码或 fetch 代码（点击按钮或在终端窗口手动执行命令），都会提问 ssh 密钥的保护密码。特别是如果 vscode 设置了选项：自动同步（"git.autofetch": true），界面会频繁弹窗提示输入密钥的保护密码。

    点击 vscode 的 git 代码同步功能的按钮会报错 ssh 密钥验证失败。

而你已经设置过 ssh 代理进程缓存密钥的保护密码

    在 bash 窗口运行过 ssh-agent 并且已经添加了密钥，用 ssh 连接站点时，不需要再输入 ssh 密钥的保护密码了。

    或在 cmd 窗口里运行过 start-ssh-agent.cmd 并且已经添加了密钥，用 ssh 连接站点时，不需要再输入 ssh 密钥的保护密码了。

    或 在 bash 窗口已经运行过 ssh-pageant 代理进程，共享使用了 putty 的 pageant.exe 的 ssh-agent 功能，在 bash 或 putty 中，用 ssh 连接站点时，不需要再输入 ssh 密钥的保护密码了。

    或在 cmd 窗口里运行过 start-ssh-pageant.cmd，共享使用了 putty 的 pageant.exe 的 ssh 代理功能，在 cmd 或 putty 中 ，用 ssh 连接站点时，不需要再输入 ssh 密钥的保护密码了。

解决办法

法一：

    在已经运行过 ssh 代理进程缓存密钥的 git-bash（mintty bash）窗口里运行命令 `code` 打开 vscode。

    这样 vscode 会继承该 git-bash 终端窗口下 ssh 代理进程设置的环境变量 SSH_AUTH_SOCK，vscode 就不会问密码了。如果是 cmd 执行 start-ssh-agent 缓存密钥使用 ssh，则 cmd 的窗口不能关。如果需要打开多个 vscode 实例，在任务栏的 vscode 图标右键选择“新窗口”。偶发问题：在退出 git bash 的最后一个实例前，要先关闭 vs code，否则再重新运行 git bash 时会报错打不开。

法二：

    使用 Windows 10 自带的 OpenSSH，启用服务 SSH-AGENT 的自动运行，设置 vscode 使用 Windows 10 自带的 OpenSSH，而不要用自行安装的 git for Windows 的 ssh。开机后在 power shell 提示窗口执行一次 `ssh-add` 缓存你的密钥，后续也不会被提示输入密码了。

法三：取消 ssh 密钥的保护密码：执行命令 `ssh-keygen -p` 提示新密码时直接回车即可。

#### vscode python多线程调试的坑

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
