# 手机相关使用

## 安卓工具软件

## 安全的使用你的手机

安卓系统权限管理的 Google 官方说明

    <https://developer.android.google.cn/guide/topics/permissions/overview?hl=zh-cn>

安卓系统应用程序对用户数据发送给第三方的现状

    <https://zhuanlan.zhihu.com/p/397453757>

### 安全使用的背景

手机 app 出于各种目的，非必要获取用户的设备数据如通话联系人，用户安装了哪些应用程序，用户剪贴板里有什么，甚至扫描硬盘查找用户是否保存了某些文件，不得不屏蔽。

安卓的权限是归类的，用户看到的是 app 申请一个权限，其实安卓系统给它开放的是一个类别的全部权限。而没有 app 会明确向你解释它到底读了些啥，又发给了谁。

如果在安卓系统的权限提示中选择禁用该权限，有些比较下作的软件，比如微信、QQ 等会拒绝运行。

安卓系统的权限提示，有些无法选择动态使用（用到的时候提示）。比如你使用时给了某个 app 存储照片时访问系统根目录的许可，但是这个 app 过会儿自己在后台扫描系统目录，你能得到任何提示吗？它的联网上传功能默认都是放开的，不可能随时随地给你弹窗提示你联网吧？

基本所有的c国手机软件都在读取系统剪贴板，你知道它在搜什么，又传给了谁？

### 一个腐烂的例子

你花钱买的东西，使用起来要听某米公司的安排，你能接受吗

    某米牌手机，已经安装使用的 app，因故被应用商店下架，比如某打车软件，你现在是否还能点开运行？由某米公司直接禁止用户使用自己的手机，这个你怎么解决？

    你的某米牌智能家电，他要是给你远程禁用了，你咋办？

    某米的产品在各种位置弹出广告，甚至覆盖别的app的广告换成某米的，你能选择一键关闭全部吗？

    某米的智能家电，除了他明面上告诉你的某些记录功能，如果在后台悄悄的记录你的谈话关键字、行动轨迹，至少发送给广告商，他会告诉你吗？

这样明显的侵犯用户个人权利，请问如何解决落实？

### 如果有人觉得苹果手机安全

苹果总裁能拒绝米国司法机关要求，不解锁毒贩子的 iphone。注意这种操作仅限于对米国。人家跟钱没仇，其它国家要求啥就是啥，赚钱就行。

苹果非常配合各国市场的不同国情，r 国的苹果和米国的苹果其实是完全不一样的：前几天，r 国苹果下线了反对派的某软件，据说又上线了一个该国国家机构的同款软件（疑似钓鱼），不知道 r 国反对派那些政党咋办。请自行搜索如下新闻：

    2021 年 09 月 17 日 俄罗斯的"Smart Voting"选举应用程序已从 App Store 和 Google Play 中删除，反对派发言人称这是"政治审查"。在俄罗斯要求苹果和 Google 删除该应用程序，然后威胁罚款之后，苹果和 Google 已经在该国下架了这一应用程序。
    <https://new.qq.com/rain/a/20210918a00gc400>
    <https://www.cnbeta.com/articles/tech/1180405.htm>

目前c国苹果手机卖的好，一个原因是没得选，想不看广告，不被骚扰，免除私人活动的不安全感，沉默的大多数只能用钱投票。

### 沙箱运行

google 自称安卓 app 都是在 java 沙箱运行，但是留足了系统接口，应用可以经权限申请，读取整个系统的任意信息。这样跟没限制啥区别？

安卓操作系统是开源的，如果手机厂商深度修改了安卓的权限控制，用户怎么知道？ 人家卖广告数据赚钱的，都是走后台。

### 某些山寨机，深度修改安卓系统的权限申请控制

有些权限比如读取应用列表等，根本不会在用户界面给出提示，摆明了给某些特殊 app 比如广告程序调用，详见下面章节[验证方法] 的 java 代码。

### 虚拟化解决方案

要求

    可以正常使用手机各项功能，又能够限制 app 乱读取发送用户数据，甚至越界操作用户软件。

在当前的手机系统（宿主机）上再运行个虚拟机系统，这个虚拟机系统完整照搬当前手机的原始安卓系统状态，软件系统和数据都是原始系统的，就像一个新买的手机系统。

把 app 装到这个虚拟机系统的安卓里，这样它无法越界到宿主机，读取甚至控制宿主机的应用程序。

重点就是虚拟机内运行的 app，看不到外部的应用、应用列表、数据等。

如果不安装虚拟机，轻量化的实现是：应用程序虚拟化运行--给流氓软件个干净的系统环境让他随便折腾。

#### 三星 knox

    <https://zhuanlan.zhihu.com/p/66659414>
    <https://www.v2ex.com/t/377512>

使用三星 knox 技术的“安全文件夹”，把 app 添加到“安全文件夹”，就可以在单独的虚拟环境运行了。

理论上是把手机出厂设置状态的软硬件系统单独克隆了一份，而后安装的 app 不会被克隆进去，需要手工单独选择“添加到安全文件夹运行”。

这样可以实现同一 app 在手机里安装两份，一个是当前的，一个是“安全文件夹”里的，互不干扰。

在安全文件夹内的 app 看来，这个虚拟机就是个刚买的裸机状态，本地存储、软件如联系人等都跟实机分离，应用程序的安装和权限设置也是单独的。

手机的应用程序节能策略，是全局不区分实机虚机的。“安全文件夹”内的 app，也是可以设置进入深度休眠不乱发系统通知。

三星的本意是把需要保密的 app 装到“安全文件夹”里运行，鉴于当前安卓 app 的混乱情况，只能倒用：

    把不安全的 app 装到这个“安全文件夹”里，让他对着一份干净的安卓系统随意折腾去吧。

可以信赖的裸机是：如果 google 的安卓系统是照顾到用户个人权利，它进行权限控制是可信的；三星手机的订制版安卓系统是老老实实按照 google 的安卓系统要求开发实现的，并没有把权限控制等功能变成用户无感知，那么三星手机的安卓系统也是可信的，在此基础上的三星“安全文件夹”进行的权限控制，也是可信的。在“安全文件夹”内部运行的程序，都受到“安全文件夹”权限控制的管理，哪怕它绕过安全权限的限制，读取到的也是虚拟机本体的裸机状态，不会读取到实机的应用和数据。

#### 安卓虚拟机

    <https://www.jianshu.com/p/84127032d15a> 这个提到如何虚拟运行安卓 app，并检查它到底使用了啥权限
        <https://github.com/android-hacker/VirtualXposed>
        <https://github.com/sgl890226/HookLoginDemo>

    TODO: 自己写个申请各种权限的 app，装到手机里挨个检查。

#### XXX: 实现安卓系统下自定义的的虚拟机套娃

硬件只暴露为出厂状态，系统软件为出厂状态。

隐私策略json文件配置，用户可自定义。格式仿 vs code 的 defaultSetting.json

    // 控制在已有窗口时新开窗口的尺寸。请注意，此设置对第一个打开的窗口无效。第一个窗口将始终恢复关闭前的大小和位置。
    //  - default: 在屏幕中心打开新窗口。
    //  - inherit: 以与上一个活动窗口相同的尺寸打开新窗口。
    //  - offset: 打开与上次活动窗口具有相同尺寸的新窗口，并带有偏移位置。
    //  - maximized: 打开最大化的新窗口。
    //  - fullscreen: 在全屏模式下打开新窗口。
    "window.newWindowDimensions": "default",

    // 控制是否在新窗口中打开文件。
    // 注意，此设置可能会被忽略 (例如，在使用 `--new-window` 或 `--reuse-window` 命令行选项时)。
    //  - on: 在新窗口中打开文件。
    //  - off: 在文件所在文件夹的已有窗口中或在上一个活动窗口中打开文件。
    //  - default: 在新窗口中打开文件，除非文件从应用程序内进行选取 (例如，通过“文件”菜单)。
    "window.openFilesInNewWindow": "off",

### 虚拟化隔离app的验证方法

安装腾讯手机版 QQ，点击头像，在弹出菜单选择“我的文件”，选择“手机文件”，在弹出界面进行如下检查：

    选择“图片”，是否只列出了虚拟系统内你保存的图片，而不是你的手机系统的全部图片

    选择“应用”，确认读取应用列表权限，是否只列出了虚拟系统内安装的 app，而不是你的手机系统内的安装的 app

    选择底部的“全部（手机内存/SD 卡）”，是否只列出了虚拟系统的文件夹结构和文件，而不是你的手机系统的文件夹结构和文件

``` java
/*
https://bbs.pediy.com/thread-256968.htm

getInstalledPackages 这个函数在很多手机上面是要权限的，我的方法不用任何权限。
我刚刚也去查看了 Android 的源代码，确实有权限控制，但是这个权限是很多手机默认就给了的。
除非有一些手机，默认就不给，或者用户根本就不给这个权限，这个时候肯定获取不到。这个代码就是为了绕过这部分机器的限制做的。
经过我自己的实验，华为三星等手机没有任何问题。在 9.0 的系统上面也没有问题，10.0 的我没有手机，如果哪位有也客户测试一些。简单的跟大家分享一下我的研究成果。

千秋事佐闲茶 活跃值 2019-12-30 15:49
非某些国产手机，获取应用列表本来就不需要权限
sunzhanwei 2019-12-30 15:52
我测试过了，某米手机不需要，但是华为，三星等是需要的，主要针对需要权限的手机，不需要权限的无所谓。

参考
    https://www.jianshu.com/p/dee8bc1fb847
    https://blog.csdn.net/q384415054/article/details/72972405
    https://blog.csdn.net/qq_40315080/article/details/96853966
*/

private void getPackageList(Context ctx) {

    Log.d("TAG", "无需权限获取应用列表");
    PackageManager pkgMgr = ctx.getPackageManager();
    String[] pkgs = null;
    int uid = 1000;

    while (uid <= 19999) {
        pkgs = pkgMgr.getPackagesForUid(uid);
        if (pkgs != null && pkgs.length > 0) {
            for (String pkg : pkgs) {

                try {
                    final PackageInfo pkginfo = pkgMgr.getPackageInfo(pkg, 0);
                    if (pkginfo == null) {
                        break;
                    }

                    CharSequence name = pkgMgr.getApplicationLabel(pkgMgr.getApplicationInfo(pkginfo.packageName, PackageManager.GET_META_DATA));

                    Log.d("TAG", "应用名称 = " + name.toString() + " (" + pkginfo.packageName + ")");

                } catch (PackageManager.NameNotFoundException e) {
                    e.printStackTrace();
                }
            }
        }
        uid++;
    }
}
```

### 打电话时拨号界面弹出视频广告

拨打电话后的等待过程中，手机拨号界面会弹出小视频或视频广告，这个业务叫视频彩铃。

要命的地方在于，当你拨号完毕看到手机出现了拨号画面，刚把手机放到耳边，突然响起了雷鸣般的欢呼“唔哇！xxx夺冠啦！xxxx！xxxxxxx！”，或者突然一阵炸响的鞭炮声“欢欢喜喜过大年！啊过大年！”惊魂未定的你，发现通话背景变成了一段欢腾的视频广告，声音还巨响。吓得气抖冷的你，怪谁好呢？

#### 原因解释

这种情况是由于被叫方（对方）开通了视频彩铃功能，主叫方（用户）界面没有关闭按钮。关键在于，通信运营商默认给用户开通这个业务，手机默认支持这个功能，而用户自己一般是不知道的。

当您的手机满足下列三点条件时，就可以看到被叫方（对方）的视频彩铃：

1. 双方都开通了4G网络通信，且支持视频彩铃业务。
2. 主叫方（用户）设备支持播放视频彩铃。
3. 被叫方（对方）开通视频彩铃业务。

4G模式下，当被叫方（对方）开通视频彩铃业务后，无论被叫方（对方）是否关闭VoLTE，主叫方（用户）打开VoLTE就可以显示视频彩铃，关闭VoLTE则不可显示。

5G模式下，当5G手机打开5G功能时，手机默认支持VoLTE通话功能。当关闭5G开关后，VoLTE高清通话开关会显示出来，关闭VoLTE高清通话即可。

#### 如果您不想看到别人的视频彩铃，可尝试以下操作进行关闭

“Volte 高清通话”功能其实可以细分为“Volte 高清语音”和“Volte 高清视频”两类，只是手机或运营商给的设置未必分这么细。我们需要的其实是关闭“Volte 高清视频”这个功能。

移动用户

    关闭“Volte 通话”功能，以三星手机为例：设置->连接->移动网络，关闭“Volte 通话”。
    缺点是不看广告的同时会失去4G手机的高清语音功能，不过你在3G时代打电话遇到过语音不清嘛？

联通用户

    目前无解，手机下载联通营业厅app，在“业务->办理”选择关闭“Volte 通话”功能，提示套餐禁止关闭该功能。
    拨打10010联系不上话务员，只能去本地营业厅问。

#### 如果你不想用自己的视频彩铃吓到打电话给你的人，特别是家里的老人和妇女，可尝试以下操作关闭

移动用户

    拨打10086，告知话务员关闭自己的视频彩铃业务。

联通用户

    手机下载联通营业厅app，在“我的业务“里面找到视频彩铃，选择关闭。

## 安卓神器 Termux -- 运行在 Android 上的开源linux模拟器

开源且不需要root，基于chroot技术的运行在android上的容器，内部是linux，内核一部分被砍了，不能安装docker。支持apt管理软件包，支持python,ruby,go,nodejs…甚至可以手机作为反向代理、或Web服务器。

    https://wiki.termux.com/wiki/Main_Page
    https://github.com/termux/termux-app#github

    Termux各种玩法专栏 <https://zhuanlan.zhihu.com/c_1208079877376901120>

busybox跟它比，简直就是小弟 <https://stackoverflow.com/questions/40140533/android-busybox-termux-test-envionment>

在Android的通知栏中也可以看到当前Termux运行的会话数，点击可切换进入。

屏幕左上角，左划弹出菜单选择新建会话，跟全面屏手势冲突，耐心点多试几次。。。

扩展功能按键（常用键是 PC 端常用的按键如: ESC键、Tab 键、CTR 键、ALT 键）打开和隐藏这个目前有下面两种方法：

    方法一 从左向右滑动，显示隐藏式导航栏，长按左下角的KEYBOARD

    方法二 使用Termux快捷键:音量++Q键 或者 音量++K键

### Termux 替换官方源为 TUNA 镜像源

    清华源 <https://mirrors.tuna.tsinghua.edu.cn/help/termux/>

图形界面（TUI）
在较新版的 Termux 中，官方提供了图形界面（TUI）来半自动替换镜像，推荐使用该种方式以规避其他风险。 在 Termux 中执行如下命令

    termux-change-repo

在图形界面引导下，使用自带方向键可上下移动。使用空格选择需要更换的仓库，之后在第二步选择 TUNA/BFSU 镜像源，确认无误后使用空格选择，然后回车，镜像源会自动完成更换。

如果上面的图形界面不可用，无vi下的sed替换，使用命令行替换

    sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list

    sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list

    sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list

最后更新包信息及升级已安装的包

    apt update && apt upgrade -y

清华镜像站还提供了如下社区维护的源，如需使用请自行添加：

    https://mirrors.tuna.tsinghua.edu.cn/termux/x11-packages
    https://mirrors.tuna.tsinghua.edu.cn/termux/unstable-packages
    https://mirrors.tuna.tsinghua.edu.cn/termux/termux-root-packages-24

### Termux 安装常用包

Termux 初步使用和设置

    <https://zhuanlan.zhihu.com/p/92664273>
    <http://wwj718.github.io/post/%E5%B7%A5%E5%85%B7/termux-hello-world/>

Termux支持pkg、apt管理软件包

    # apt install
    pkg install vim curl wget git unzip tmux fish

    apt install python
    apt install clang

    # 取得sd卡权限，需授权
    pkg install termux-tools
    termux-setup-storage
    # 当前目录下出现了storage这个目录，下面在子目录分别对应了手机当中的部分目录
    # 子目录shared，共享了手机中的内部存储

    # 设置密码
    passwd

    # 查询手机ip，以实际手机ip为准
    ifconfig

    *查询当前用户
    whoami

    *确认sshd服务的监听端口
    netstat -ntlp | grep sshd

    # 电脑端ssh连接手机端termux
    # 假定用户名为u0_a123（whoami查询可得），ip为192.168.0.1（ifconfig查询可得）
    ssh u0_a123@192.168.0.1 -p 8022

Aria2+Transdroid完全能够代替其他手机版下载软件，并且表现完美。唯一的问题是aria2依托于Termux终端环境，终端关闭，Aria2下载服务也就关闭了。

#### 安装 Open-SSH

安装的 ssh ，包括客户端 ssh 和服务端 sshd，我们既可以使用ssh访问远程设备，也可以在本机上开启ssh服务以方便其他设备远程访问本机。默认情况下，安装openssh不开启服务端，需要手工开启。

    # 安装 ssh ，包括客户端 ssh 和服务端 sshd
    pkg install openssh

    # 开启 sshd 服务，默认打开的端口是8022，-p 指定了新的端口9000
    sshd -p 9000

Termux终端中使用ssh访问远程服务器与Linux终端中使用ssh别无二致。但要使用ssh访问Android设备就不同了，Termux终端中sshd服务不支持密码验证，也就是说用户不能期望通过 ssh user@server 然后输入用户密码的方式从别的终端访问Android设备。Termux终端中sshd只支持密钥验证。

ssh服务的配置文件默认在 $PREFIX/etc/ssh/sshd_config 中。

客户端公钥需要手工传递到手机输入

    cat id_rsa.pub >> $HOME/.ssh/authorized_keys

#### 公网访问手机

我们如何把手机中的端口暴露到公网呢，有两种方式都很方便:

    使用ssh反向代理(使用autossh解决隧道的稳定性问题)
    使用ngrok（使用ngrok arm版本）

如此一来手机中运行的网站你就可以在公网访问它，当然你也可以把ssh端口暴露到外网，这样你可以在任何有网络连接的地方连接到你的手机里，前提是Termux处于运行状态。

### Termux 上安装linux

    极致安卓之—Termux安装完整版Linux <https://zhuanlan.zhihu.com/p/95865982>

    <https://wiki.termux.com/wiki/PRoot#Installing_Linux_distributions>

### Termux 下的chroot

    <https://github.com/termux/proot>

chroot命令用来在指定的根目录下运行指令。chroot，即 change root directory （更改 root 目录）。在 linux 系统中，系统默认的目录结构都是以/，即是以根 (root) 开始的。而在使用 chroot 之后，系统的目录结构将以指定的位置作为/位置。

在经过 chroot 之后，系统读取到的目录和文件将不在是旧系统根下的而是新根下(即被指定的新的位置)的目录结构和文件，因此它带来的好处大致有以下3个：

1、增加了系统的安全性，限制了用户的权力；
在经过 chroot 之后，在新根下将访问不到旧系统的根目录结构和文件，这样就增强了系统的安全性。这个一般是在登录 (login) 前使用 chroot，以此达到用户不能访问一些特定的文件。

2、建立一个与原系统隔离的系统目录结构，方便用户的开发；
使用 chroot 后，系统读取的是新根下的目录和文件，这是一个与原系统根下文件不相关的目录结构。在这个新的环境中，可以用来测试软件的静态编译以及一些与系统不相关的独立开发。

3、切换系统的根目录位置，引导 Linux 系统启动以及急救系统等。
chroot 的作用就是切换系统的根位置，而这个作用最为明显的是在系统初始引导磁盘的处理过程中使用，从初始 RAM 磁盘 (initrd) 切换系统的根位置并执行真正的 init。另外，当系统出现一些问题时，我们也可以使用 chroot 来切换到一个临时的系统。

### 使用Python驱动手机

接下来才是精彩之处

我们先安装termux的插件[Termux:API](https://wiki.termux.com/wiki/Termux:API)，用于访问手机硬件。

安装完Termux:API App之后，还需要在terminal里安装termux-api:

    apt install termux-api

之后就可以在terminal中操控手机硬件，这样一来我们可以以编程的方式来控制手机

    # 获取手机剪贴板内容
    termux-clipboard-get

    # 给10010发短信 hello:
    termux-sms-send -n 10010 hello

python包装了一下termux:api: <https://github.com/wwj718/termux_python>

### Termux 高级终端安装使用配置教程

    <https://www.sqlsec.com/2018/05/termux.html>

基本命令

Termux 除了支持 apt 命令外，还在此基础上封装了pkg命令，pkg 命令向下兼容 apt 命令。apt命令大家应该都比较熟悉了，这里直接简单的介绍下pkg命令:

    pkg search <query>              # 搜索包
    pkg install <package>           # 安装包
    pkg uninstall <package>         # 卸载包
    pkg reinstall <package>         # 重新安装包
    pkg update                      # 更新源
    pkg upgrade                     # 升级软件包
    pkg list-all                    # 列出可供安装的所有包
    pkg list-installed              # 列出已经安装的包
    pkg show <package>              # 显示某个包的详细信息
    pkg files <package>             # 显示某个包的相关文件夹路径

国光建议大家使用 pkg 命令，因为 pkg 命令每次安装的时候自动执行 apt update 命令，还是比较方便的。

## BusyBox

    <https://busybox.net/>

需要root手机，优点是安装到安卓的linux系统里了，给系统增强了非常多的linux命令。一个集成了三百多个最常用Linux命令和工具的软件。BusyBox 包含了一些简单的工具，例如ls、cat和echo等等，还包含了一些更大、更复杂的工具，例grep、find、mount以及telnet。有些人将 BusyBox 称为 Linux 工具里的瑞士军刀。简单的说BusyBox就好像是个大工具箱，它集成压缩了 Linux 的许多工具和命令，也包含了 Android 系统的自带的shell。

    <https://www.cnblogs.com/xiaowenji/archive/2011/03/12/1982309.html>
    <https://www.zhihu.com/question/26190694>
