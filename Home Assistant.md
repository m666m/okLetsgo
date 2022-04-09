# 智能家居开源系统

## Home Assistant

    https://www.home-assistant.io/getting-started/
        https://github.com/home-assistant

基于HomeAssistant服务器（），可以方便地连接各种外部设备（智能设备、摄像头、邮件、短消息、云服务等，成熟的可连接组件有近千种），手动或按照自己的需求自动化地联动这些外部设备，构建随心所欲的智慧空间。目前大部分（美国）市面上的智能设备都与Home Assistant 兼容。

在Home Assistant 中，每个设备都拥有状态：比如灯的开关、亮度、颜色，音频设备的播放暂停、响度、曲目；事件也是主要构成部分：比如灯的状态改变，主人回到家（移动、位置检测），孩子到学校了等等。

[hassio](https://www.home-assistant.io/blog/2017/07/25/introducing-hassio/)是一个框架，他利用 docker 来部署 homeassistant，并且为homeassistant 提供各种插件(addons)，hassio 和homeassistant 是通过他们的API进行联系和沟通。<https://github.com/home-assistant/hassio-installer>。

### 安装

推荐：树莓派用docker安装。单独下载安装在<https://www.home-assistant.io/installation/>。

linux

    pip3 install homeassistant

    # 执行
    hass --open-ui。

windows上需要先安装python3

    pip install homeassistant安装，

    # 执行
    python -m homeassistant --open-ui。

通过[配置文件](https://www.home-assistant.io/docs/configuration/yaml)，我们可以配置Home Assistant

    Linux ~/.homeassistant

    Windows %APPDATA%/.homeassistant

安装过程

设备类型选型说明

    intel-nuc ：英特尔的nuc小主机
    odroid-c2 ：韩国odroid-c2
    odroid-xu ：韩国odroid-xu
    orangepi-prime ：香橙派
    qemuarm ：通用arm设备（例如斐讯N1)
    qemuarm-64 ：通用arm设备（例如斐讯N1) 64位系统
    qemux86 ：通用X86 64位系统（普通的PC机电脑）
    qemux86-64 ：通用X86（普通的PC机电脑）64位系统
    raspberrypi ：树莓派一代
    raspberrypi2 ：树莓派二代
    raspberrypi3 ：树莓派三代
    raspberrypi4 ：树莓派四代
    raspberrypi3-64 ：树莓派三代64位系统
    raspberrypi4-64 ：树莓派四代64位系统
    tinker ：华硕tinker

64位设备类型（默认：qemux86-64）

        [1]: raspberrypi3-64
        [2]: qemuarm-64
        [3]: qemux86-64

32位设备类型（默认：qemux86）

        [1]: raspberrypi
        [2]: raspberrypi2
        [3]: raspberrypi3
        [4]: qemuarm
        [5]: qemux86
        [6]: intel-nuc

安装后要更改系统源为清华源。（目前支持 Debian Ubuntu Raspbian 三款系统）。

安装 Docker，可以选择切换 Docker 源为国内源，提高容器下载速度。当前系统的用户，将其添加至 docker 用户组。

操作说明

    停止（但重启依然会自启动）
    systemctl stop hassio-supervisor.service

    重启
    systemctl restart hassio-supervisor.service

    禁用自启动
    systemctl disable hassio-supervisor.service

    启用自启动
    systemctl enable hassio-supervisor.service

    查询当前启动状态
    systemctl status hassio-supervisor.service

    查询当前是否自启动
    systemctl is-enabled hassio-supervisor.service

    查询 hassio 日志
    docker logs -f hassio_supervisor

    查询 hassio 日志最新20行信息
    docker logs -f hassio_supervisor --tail 20

    查询 ha 日志
    docker logs -f homeassistant

    查询 ha 日志最新20行信息
    docker logs -f homeassistant --tail 20

docker logs 命令用法：<https://docs.docker.com/engine/reference/commandline/logs>

### 智能化配件

智能开关：可以将一些老旧设备连接上Home Assistant。（其实不少设备加上一个智能开关就足以满足大部分日常需求）。

门开关感应器：门的打开可以作为触发信号，可以实现主人回家开门则客厅的灯打开、假期出去玩门被打开则自动报警等类似自动化流程。

## QEUM

[QEMU](https://www.qemu.org/download/)是一种通用的开源计算机仿真器和虚拟器。QEMU共有两种操作模式

    全系统仿真：能够在任意支持的架构上为任何机器运行一个完整的操作系统

    用户模式仿真：能够在任意支持的架构上为另一个Linux/BSD运行程序

QEMU可以通过动态代码翻译机制（dynamic translation）在不同的机器上仿真任意一台机器（例如ARM板），并执行不同于主机架构的代码。同时由于动态代码翻译机制，它也能够实现不错的性能。

而当QEMU用作虚拟器时，QEMU的优点在于其实纯软件实现的虚拟化模拟器，几乎可以模拟任何硬件设备，但是也正因为QEMU是纯软件实现的，因此所有指令都需要QEMU转手，因此会严重的降低性能。而可行的办法是通过配合KVM或者Xen来进行加速，目前肯定是以KVM为主。KVM 是硬件辅助的虚拟化技术，主要负责 比较繁琐的 CPU 和内存虚拟化，而 QEMU 则负责 I/O 虚拟化，两者合作各自发挥自身的优势，相得益彰。

Windows上qemu的性能不佳，这主要是其架构问题，在Windows上将无法使用其他专门负责虚拟化的工具进行加速，因此更好地方式是运行于Ubuntu之上，然后，借用kvm进行有效的加速，而如果需要使用kvm，则需要还需要安装qemu-kvm。

QEMU-KVM，是QEMU的一个特定于KVM加速模块的分支，里面包含了很多关于KVM的特定代码，与KVM模块一起配合使用。不过目前QEMU-KVM已经与QEMU合二为一，所有特定于KVM的代码也都合入了QEMU，当需要与KVM模块配合使用的时候，只需要在QEMU命令行加上 --enable-kvm就可以。

Ubuntu

安装方法如下

    sudo apt install qemu
    sudo apt install kvm libvirt-clients
    # 检查是否已经安装kvm
    # egrep -o '(vmx|svm)' /proc/cpuinfo
    # 使用kvm启动镜像
    sudo kvm -hda gxzy-tf-win7.qcow2 -m 8192 -smp 4
    # 检查正在运行的镜像
    # virsh -c qemu:///system list

或者，我们也可以直接使用qemu的命令进行操作，使用kvm加速只需要再加上--enable-kvm。

Linux各个版本安装命令

在大部分Linux系统中，QEMU都可以通过安装包的形式进行安装。不过由于原生的QEMU性能不佳，因此也可以直接使用qemu-kvm进行操作。目前qemu已经集成了该组件，

    Arch: pacman -S qemu
    Debian/Ubuntu: apt-get install qemu
    Fedora: dnf install @virtualization
    Gentoo: emerge --ask app-emulation/qemu
    RHEL/CentOS: yum install qemu-kvm
    SUSE: zypper install qemu
    macOS

QEMU can be installed from Homebrew:brew install qemu
QEMU can be installed from MacPorts:sudo port install qemu

QEMU的源码安装

QEMU提供了多个版本的源码，你可以在QEMU全版本源码列表下载有关版本。或者使用以下代码进行安装：

    wget https://download.qemu.org/qemu-4.2.0.tar.xz
    tar xvJf qemu-4.2.0.tar.xz
    cd qemu-4.2.0
    ./configure
    make

又或者，我们可以直接从git上下载和编译QEMU：

    git clone https://git.qemu.org/git/qemu.git
    cd qemu
    git submodule init
    git submodule update --recursive
    ./configure
    make

configure 脚本用于生成 Makefile，其选项可以用 ./configure --help 查看。

这里使用到的选项含义如下：

    –enable-kvm：编译 KVM 模块，使 Qemu 可以利用 KVM 来访问硬件提供的虚拟化服务。
    –enable-vnc：启用 VNC。
    –enalbe-werror：编译时，将所有的警告当作错误处理。
    –target-list：选择目标机器的架构。默认是将所有的架构都编译，但为了更快的完成编译，指定需要的架构即可。

安装好之后，会生成如下应用程序：

编译安装qemu

    vshmem-client/server：这是一个 guest 和 host 共享内存的应用程序，遵循 C/S 的架构。
    qemu-ga：这是一个不利用网络实现 guest 和 host 之间交互的应用程序（使用 virtio-serial），运行在 guest 中。
    qemu-io：这是一个执行 Qemu I/O 操作的命令行工具。
    qemu-system-x86_64：Qemu 的核心应用程序，虚拟机就由它创建的。
    qemu-img：创建虚拟机镜像文件的工具，下面有例子说明。
    qemu-nbd：磁盘挂载工具。
