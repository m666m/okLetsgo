
# Windows 10+ 安装的那些事儿

## 关键词 UEFI/CSM、GPT/MBR

目标系统类型 UEFI/CSM

    UEFI模式是Windows 7 之后出现的新型操作系统启动引导方式，跳过很多硬件自检，加速了开机步骤，缺点是跟Windows 7之前的系统启动过程不兼容。

    为区别于新式的UEFI，主板BIOS设置中提供了兼容老的启动方式的选项“CSM模式”，CSM模式从BIOS引导设备，用于在引导时检查兼容性模式，适用于不兼容UEFI方式启动的老显卡等设备能正常的显示。
    具体来说，CSM模式提供硬盘MBR引导和传统PCI opROM加载支持，后者可以让没有GOP的显卡在操作系统启动前（例如bios设置和OS引导器）可以使用并固定使用VGA分辨率。只要用到其中一个功能就需要打开CSM。

    早期的Windows 7无法很好地支持UEFI，因此需要CSM来检测UEFI功能是否已完全启用。也就是说，主板BIOS在CSM模式下，对UEFI进行支持（甚至提供选项使用非UEFI的最古老方式），但是这跟Windows 10的那种开机后直接UEFI引导操作系统快速进入桌面有区别。

    有些如 nvidia gtx 1080 时代的显卡，用 HDMI 口可以用UEFI方式显示画面，而 DP 口则不兼容（只能通过CSM模式下的UEFI进行显示），需要根据连接该口开机后显示器是否出现画面来设置BIOS的上述选项。

    在Windows 10/11安装之前，如果要享受快速启动进入桌面，则需要在主板的BIOS设置中明确开启UEFI选项，在主板BIOS设置中，启动模式选项（Windows 10 Features）要选择“Windows 10”而不是“other os”，CMS模式选择“关闭”。
    技嘉主板要注意，CMS模式开启时，关于存储和PCIe设备的选项要保证是UEFI模式，然后再关闭CSM模式。原因详见下面章节 [技嘉主板BIOS设置 UEFI + GPT 模式启动Windows]

硬盘分区类型 GPT/MBR:

    MBR是Windows 10/7之前老的硬盘分区方式， GPT是win7之后新的硬盘分区方式，使用不同的硬盘分区类型，Windows引导启动的方式是不同的。
    在Windows安装时，有个步骤是划分硬盘分区，自动使用的是GPT方式，默认把启动硬盘上划分了3个分区（如果是一块新的未划分分区的硬盘），其中两个特殊的小分区在Windows安装完成后默认是隐藏看不到的，这里其实放置了存储设备的UEFI引导信息。
    所以如果只想用一个分区，需要提前把硬盘挂到别的电脑上用Windows管理或其他软件分区，明确选择类型为MBR，或者用命令行diskpart程序。

    目前发现 Windows 10 安装程序根据BIOS设置里把存储设备设为UEFI才会给硬盘用GPT类型分区，否则会用MBR类型分区，但是安装的时候是不给出任何提示的。
    这样用MBR类型的硬盘安装好的Windows 10，虽然也像GPT类型的硬盘一样分成了3个区，其实只是保持在CSM模式下的UEFI方式的兼容而已，系统启动其实是走的主板CSM模式，存储设备leagcy，不会绕开bios引导自检那些耗时过程。
    即使这时进入主板BIOS设置里，把存储设备改为UEFI，该MBR硬盘启动系统的时候会转主板的CMS模式下的UEFI方式，利用Windows安装时的UEFI分区引导系统，这样还是绕不开系统bios引导自检步骤的，无法实现 Windows 10 真正的UEFI方式启动系统那样秒进桌面。
    见下面章节 [技嘉主板BIOS设置 UEFI + GPT 模式启动Windows]中的踩坑经历。

## 技嘉 B560M AORUS PRO 主板（BIOS版本 F7） + Intel 11600KF CPU + DDR4 3600 内存的初始BIOS设置

1. HDMI口连接显示器（防止老显卡的DP口不支持默认的UEFI），开机按Del键进入主板BIOS设置。

2. F7 装载系统默认优化设置：BOOT->Load optimized defaults，注意这之后引导操作系统默认是UEFI的，存储设备选项需要手动打开CSM后切换，详见后面的章节 [技嘉主板BIOS设置 UEFI + GPT 模式启动Windows]。

3. 内存：TWEAKS->Memory， 选择X.M.P profiles，以启用3600MHz最优频率，这个版本的BIOS也已经自动放开了，我的这个内存默认1.2v跑到了3900MHz。

4. AVX512: Advanced CPU settings-> AVX settings，选custom，出现的avx512选项选择disable，关闭这个无用功能，可以降低20%的cpu整体功耗。。。电源功耗PL1/PL2不用设了，这个版本的BIOS已经全放开了。

5. 虚拟化：Advanced CPU settings-> Hyper Threading 选项打开英特尔CPU超线程； Settings-> MISC-> VT-d 选项打开虚拟机。

6. F6 风扇设置：对各个风扇选静音模式，或手动，先选全速看看最大转速多少，再切换手动，先拉曲线到最低转速，然后再横向找不同的温度调整风扇转速挡位。

7. UEFI + GPT + Secure Boot： 先F10保存退出，重启计算机，后续再设置，详见下面相关章节

## 技嘉主板BIOS设置 UEFI + GPT 模式启动Windows

1.确保存储和PCIe设备是UEFI 模式

UEFI + GPT模式一开, 都是直接厂商logo转一圈就直接进系统的，不会再有主板启动画面和windows启动的画面。

UEFI引导会直接跳过硬件检测。过程如下：引导→UEFI初始化→加载系统→进入系统。传统的BIOS在加载系统之前需要进行一系列的硬件检查。

主板BIOS设置中，启动模式选项（Windows 10 Features）要选择“Windows 10”而不是“other os”，CSM模式选关闭，UEFI硬盘和PCIe设备是UEFI模式，这样系统才能默认用Windows的UEFI模式快速启动。

重启开机后按 F2 进入bios，选BOOT选项卡：

    启动模式选项（Windows 10 Features）要选择“Windows 10”而不是“other os”。

    选项 “CSM Support”， 选“Enable”，
    之后下面出现的三项，除了网卡启动的那个选项不用管，其它两个关于存储和PCIe设备的选项要确认选的是“UEFI”。

    然后选项 “CSM Support”， 选“Disable”，再关闭CMS模式。

    CMS模式关闭后，当前系统内的PCIe设备应该是出现了一些选项可以进行设置，比如“Advanced”界面 PCI  Subsystem setting 下RX30系列显卡的支持Resize Bar等

为什么要CSM模式又开又关这样操作呢？ Windows 10安装的时候踩了个坑：

    我在主板BIOS设置中启动模式选项（Windows 10 Features）选择“Windows 10”，“CSM Support”选项选择“Disable”后下面的三个选项自动隐藏了，我以为都是自动UEFI了，其实技嘉主板只是把选项隐藏了，硬盘模式保持了上次安装windows时设置的legacy不是UEFI……

    这样导致我的Windows引导还是走的老模式，UEFI引导硬盘其实没用上，装完后Windows启动没有实现秒进桌面才发现的这个问题。

    原因在于，Windows安装程序是根据当前BIOS设置的引导方式，来决定对硬盘格式化为哪个分区类型，只有BIOS里把“CSM Support”模式enable后出现的存储设备类型设为UEFI才会默认用GPT类型，设为legacy就会默认用MBR类型，设好后还得把“CSM Support”禁用选disable才行。

总结来说，Windows 10的安装兼容各种老设备，最古老的一种是主板BIOS设置里“Windows 10 Features”选择“other os”，“CSM Support”选“Enable”，存储和PCIe设备都选择“leagcy”，也可以安装Windows 10，但是就无法享受真正UEFI引导系统的秒进桌面了。

我的显卡因为用DP口不兼容，BIOS设置里“Windows 10 Features”选择“other os”，“CSM Support”选“Enable”，存储和PCIe设备都选择“UEFI”安装的Windows 10 2019 LTSC。
后来显卡升级了BIOS，又关闭主板CMS模式装了Windows 10 21H1，在主板BIOS设置里装载默认值“Load optimized defaults”（默认把存储设备换回了legacy），然后设置“Windows 10 Features”选择“Windows 10”，“CSM Support”选“Disable”，但是忘记把存储设备换回UEFI类型了，导致硬盘被Windows安装程序格式化为MBR类型。这样装完windows开机启动后，估计是主板尝试UEFI没有引导成功，自动转为CSM模式走bios+UEFI的过程，导致无法秒进桌面。

总之，完美的做法，应该在BIOS设置中“Windows 10 Features”选择“Windows 10”，“CSM Support”选项选择“Enable”后出现的存储和PCIe设备的选项都选择“UEFI”，然后再把“CSM Support”选项选择“Disable”，使用Rufus制作安装u盘时也需要选择GPT+UEFI方式，这样u盘可以正常启动，这样安装好的windows才能实现秒进桌面。

2.SATA硬盘使用“AHCI”模式

    确认下主板BIOS的“settings”界面中，“SATA And RST configuration”的选项，硬盘模式为“AHCI”，这个一般主板都是默认开启的。

3.确保硬盘格式化为GPT类型

如果你的BIOS设置已经选择了“UEFI”，但开机后不是直接秒进Windows的，那就怀疑是Windows安装的时候，没有把你的硬盘格式化为GPT模式。

    进入磁盘管理，在磁盘0上点击右键，看看“转换到动态磁盘”是可用的而不是灰色的不可用？如果是，那么说明当前磁盘的分区格式不是GPT类型，而是MBR类型。

原因参见上面第一节的踩坑经历。

验证：启动windows后运行msinfo32，在“系统摘要”界面找“BIOS模式”选项，看到结果是“UEFI”。

参考 <https://www.163.com/dy/article/FTJ5LN090531NEQA.html>

## 技嘉主板BIOS设置 Secure Boot 功能

其实secure boot是uefi设置中的一个子规格，简单的来说就是一个参数设置选项，它的作用体现在主板上只能加载经过认证过的操作系统或者硬件驱动程序，从而防止恶意软件侵入。

1.开启UEFI功能

    见前面的章节 [技嘉主板BIOS设置 UEFI + GPT 模式启动Windows]中的第一项“确保存储和PCIe设备是UEFI 模式”

2.设置“Secure Boot”为“Enable”并导入设备商出厂密钥

在BIOS中，仅仅设置“Secure Boot”为“Enable”还不够，选择进入“Secure Boot”界面，这时可以看到，“Secure Boot”为“Enable”，但是出现“Not Active”字样。

如果是，则需要导入出厂密钥：

    选择“Secure Boot Mode”为“custom”，打开用户模式

    下面的灰色选项“Restore Factory keys”可以点击了，敲一下，弹出画面选择确认，以安装出厂默认密钥。

    这时的“Secure Boot”下面会出现“Active”字样

    F10储存并退出重启系统。

注意要确认下“Settings”界面中的“IO Ports”选项里，查看对应的PCIe设备，比如网卡等能正确显示名称可以点击进去设置或查看信息，这表示PCIe卡中有带数字签名的UEFI驱动，否则不会被加载。

验证：启动windows后运行msinfo32，在“系统摘要”界面找“安全启动”选项，看到结果是“开启”。

补充：从华为服务器的一篇说明 <https://support.huawei.com/enterprise/zh/doc/EDOC1000039566/596b9d40>中看到，
“Secure Boot Mode”选“custom”后，在“Key Management”界面，设置“Provision Factory Default keys”为 “Enable”，打开出厂默认密钥开关，这个不知道是否必须做，也是导入密钥的操作，
看主板BIOS下面的说明是“Secure Boot Mode”改回“Standard”，也能让“Secure Boot”依然是“Active”。
我是按这个做的，进入BIOS设置，把“Secure Boot Mode”改回“Standard”，这时“Secure Boot”依然是“Active”字样，说明密钥都导入成功了

不大明白为嘛技嘉没提供个详细的操作说明呢？

## 用Rufus制作启动u盘安装 Windows11

WIN11除了硬件要求之外，还有2个必要条件：

    1.主板BIOS开启 TPM2.0

    进入主板BIOS设置的“Settings”，选择“Intel Platform Trust Technology(PTT)”，选择“Enable”，下面的选项“Trusted Computing”回车，进入的设置界面，找“Security Device Support”选择“Enable”。

    2.主板BIOS开启安全启动（Secure Boot）

    见前面的章节[技嘉主板BIOS设置UEFI模式下Secure Boot功能]

用Rufus制作启动u盘时，分区类型要选择GPT（这时目标系统类型自动选择UEFI），这样的开机过程直接可以跳过BIOS自检等一堆耗时过程，U盘启动用UEFI+GPT，秒进引导系统，也符合windows 11的启动要求（如果u盘用MBR模式启动，那主板BIOS也得设置存储设备为非UEFI，则windows 11安装程序默认的格式化硬盘就不是GPT类型了……）。

特殊之处在于 Rufus 3.17版之前制作的启动u盘，初始引导启动需要临时关闭“Secure Boot”，3.17之后的版本不用了，已经取得windows的签名文件了：

    一、根据Rufus的要求 <https://github.com/pbatard/Rufus/wiki/FAQ#Windows_11_and_Secure_Boot>，见下面的章节 [老显卡不支持DP口开机显示（Nvidia Geforce 1080系）]中的[凑合方案：主板BIOS设置为 CSM 方式安装 Windows 可以连接DP口]。

    用Rufus制作的启动u盘（制作时的选项是“分区类型GPT+目标系统类型UEFI”）启动计算机，Windows安装程序自动启动，按提示点选下一步，注意原硬盘分区建议全删，这时Windows安装程序开始拷贝文件，并未实质进入配置计算机硬件系统的过程，这时的Windows安装过程并不要求Secure Boot。

    注：觉得Secure Boot关闭就不安全了？ 不，它本来就不是什么安全措施，只是名字叫安全，其实做的工作就是数字签名验证，而且微软的密钥已经在2016年就泄露了…… 参见<https://github.com/pbatard/Rufus/wiki/FAQ#Why_do_I_need_to_disable_Secure_Boot_to_use_UEFINTFS>。至于linux，没参与微软的这个步骤的话，主板厂商不会内置它的公钥到主板中，估计安装的时候就不能开启这个选项。

    二、在Windows安装程序拷贝完文件，提示进行第一次重启的时候，重新打开BIOS的“Secure Boot”选项：

    重启后按 F2 进入bios设置，选BOOT选项卡，

        找到“Windows 10 Features” 设置为 “Windows 10”

        之后下面的选项“CSM Support”会消失，故其原来设置的 Disabled 或 Enable 没啥用了，同时下面的三个选项也会消失，都不需要了

        之后下面出现的是“Secure Boot”选项，选择Enable，按 F10 保存退出，主板重启后自动引导硬盘上的Windows安装程序进行后续的安装配置工作

        注意：主板BIOS的选项 Windows 10 feature 设置为“win10”后，原来用MBR方式安装的win7或win10就进不了系统了，除非还原为“other os”

## 使用 Rufus 制作ghost启动盘

制作时引导类型选择“FreeDos”就行了，完成后把ghost拷贝到u盘上，以后用它开机引导直接进入dos命令行方式，运行命令ghost即可。

<https://qastack.cn/superuser/1228136/what-version-of-ms-dos-does-rufus-use-to-make-bootable-usbs>

## 技嘉 B560M AORUS PRO 主板BIOS打开网络唤醒功能

根据产品规格指出，此产品有提供网络唤醒 (Wake On LAN) 的功能，但是找不到相关设定或是开关可以启用该选项。

首先，请在开机时进入 BIOS 设定程序，在电源管理选项中，请启用 PME EVENT WAKEUP 功能，然后储存设定退出程序，再重新启动进入 Windows 后，请开启设备管理器窗口，检查网络卡内容并开启唤醒功能相关设定即可。
如果使用的网络卡上有 WOL 接头，需配合主板上 WOL 接头；如果使用的网络卡上没有 WOL 接头，且它的规格是 PCI 2.3，则依上述的方法即可。

<https://www.gigabyte.cn/Motherboard/B560M-AORUS-PRO-rev-10/support#support-dl-driver>

注意：确认Windows 10快速启动功能是否关闭，参见下面章节[关闭“快速启动”]  <https://www.asus.com.cn/support/FAQ/1045950>

## 技嘉 B560M AORUS PRO 主板开启待机状态USB口供电功能和定时自动开机功能

BIOS中的“Erp”(ErP为Energy-related Products欧洲能耗有关联的产品节能要求)选项选择开启，

    usb口功能设置选择供电。
    RTC（定时开机）设置具体时间

注意：确认Windows 10快速启动功能是否关闭，参见下面章节[关闭“快速启动”]  <https://www.asus.com.cn/support/FAQ/1042220> <https://www.asus.com.cn/support/FAQ/1043640>

## 老显卡不支持DP口开机显示（Nvidia Geforce 1080系）

### 一劳永逸方案：Nvidia 显卡可以升级固件解决这个问题

先把显卡挂到别的能显示的机器上（或先连接HDMI口安装Windows能进入系统后），升级下固件，以后就可以实现连接DP口安装 Windows 10 了

    <https://www.tenforums.com/graphic-cards/144258-latest-nvidia-geforce-graphics-drivers-Windows-10-2-a.html>
        <https://www.tenforums.com/Windows-10-news/111671-nvidia-graphics-firmware-update-tool-displayport-1-3-1-4-a.html>
            Geforce 1080系 <https://www.nvidia.com/en-us/drivers/nv-uefi-update-x64/>
            Geforce 3080系 <https://nvidia.custhelp.com/app/answers/detail/a_id/5233/>

### 简单方案：连接HDMI口安装Windows就行了

主板BIOS设置为 GPT + UEFI 的情况下只能连接HDMI口安装系统

新出技嘉主板的BIOS设置中，默认BOOT选项采用的是GPT分区+UEFI引导，这样的启动u盘注意选择对应模式才能顺利启动，而且这样的BIOS设置才符合Windows 11的安装要求。

用Rufus制作Windows 10安装u盘，选择分区类型是GPT（右侧的选项自动选择“UEFI(非CSM)”，估计是UEFI也有版本更替）而不能是MBR，这样的启动u盘才能顺利启动。
有些如 nvidia gtx 1080 时代的显卡，连接 HDMI 口可以兼容UEFI方式，而 DP 口则不兼容，这样制作的安装u盘可以启动系统但是DP口在开机的时候不显示，只能连接HDMI口安装系统。

### 凑合方案：主板BIOS设置为 CSM 方式安装 Windows 可以连接DP口

用Rufus制作Windows 10安装u盘，如果分区类型选择MBR（右侧选项自动选择“BIOS+UEFI(CSM)”），则也只能连接HDMI口安装系统。
这时如果想使用DP口开机显示，则主板BIOS要更改设置，CSM Support（Windows 10之前Windows版本安装的兼容模式，事关识别usb键盘鼠标和UEFI显卡）要选“Enable”，并设置兼容模式：

    重启开机后按 F2 进入bios，选BOOT选项卡，找到 Window 10 Features，选“other os”

    之后下面出现了 CSM Support， 选“Enable”，
    之后下面出现的三项，除了网卡启动的那个选项不用管，其它两个关于存储和PCIe设备的选项要确认选的是“UEFI”，这样在“other os”模式下可以实现DP口的开机显示，要是还不行，那两个选项直接选非UEFI的选项。

关于主板BIOS设置CSM模式可以启动DP口的解释 <https://nvidia.custhelp.com/app/answers/detail/a_id/3156/kw/doom/related/1>

## 装完 Windows 10 后的一些设置

先激活

Windows安装后，先把电源计划调整为“高性能”或“卓越性能”，省的它各种乱省电，系统反应不正常的时候你根本猜不出啥原因导致的。

关闭Windows搜索，这玩意非常没用，但是总是在闲时扫描硬盘，太浪费硬盘和电了。

设置：设备->自动播放->关闭自动运行。

设置：系统->多任务处理，按ALT+TAB将显示“仅打开的窗口”，不然开了一堆edge窗口都给你切换上，太乱了。

设置：个性化->任务栏，合并任务栏按钮，选择“任务栏已满时”，不然你多开窗口非常不方便在任务栏上选择切换。

设置：隐私策略各种关闭，有空的时候挨个琢磨吧

打开Windows store，菜单选择“settings”，把“App updates”的“Update apps automatically”选项抓紧关闭了，太烦人了！
商店应用默认不提供卸载选项，解决办法见下面章节 [删除无关占用cpu时间的项目]

### 设置windows安全中心

开始->运行：msinfo32，在“系统摘要”页面，查看状态是“关闭”的那些安全相关选项，逐个解决。

如果主板BIOS设置中关于Intel CPU虚拟化选项如vt-d、hyper-threading的设置没有打开，则可能有些依赖虚拟机的隔离浏览的选项不可用，需要去主板BIOS设置中打开。

某些windows默认没有安装的组件是增强安全功能依赖的，需要单独安装：设置->应用->应用和功能->可选功能，点击右侧的“更多windows功能”，弹出窗口选择“启用和关闭windows功能”：

    Hyper-V
    Microsoft Defender 应用程序防护
    Windows 沙盒
    Windows 虚拟机监控程序平台
    适用于Linux的Windows子系统（这个是安装Linux用的，不是安全必备，顺手装上吧）
    虚拟机平台

设置->更新和安全->windows安全中心，左侧页面点击“打开Windows安全中心”

    ->应用和浏览器控制，打开“隔离浏览（WDAG）” <https://docs.microsoft.com/zh-cn/Windows/security/threat-protection/microsoft-defender-application-guard/install-md-app-guard>

    ->设备安全性->内核隔离，手动开启“核心隔离”、“内存完整性”  <https://support.microsoft.com/zh-cn/Windows/afa11526-de57-b1c5-599f-3a4c6a61c5e2> <https://go.microsoft.com/fwlink/?linkid=866348>

    在“设备安全性”屏幕的底部，如果显示“你的设备满足增强型硬件安全性要求”，那就是基本都打开了。
    目前发现windows 10 21H1版本的“核心隔离”类别中缺少“内核DMA 保护”、“固件保护”等选项，而windows 2019 LTSC版本是有的，
    如果想显示“你的设备超出增强的硬件安全性要求”，需要在下面的页面慢慢研究如何开启。
    <https://docs.microsoft.com/zh-cn/windows/security/information-protection/kernel-dma-protection-for-thunderbolt>
    <https://docs.microsoft.com/zh-cn/windows/security/threat-protection/windows-defender-system-guard/system-guard-secure-launch-and-smm-protection>

验证：启动windows后运行msinfo32，在“系统摘要”界面查看

    “内核DMA 保护”选项，“启用”
    “基于虚拟化的安全xxx”等选项，有详细描述信息
    “设备加密支持”选项，不是“失败”

更多关于Windows10安全性要求的选项参见各个子目录章节 <https://docs.microsoft.com/zh-cn/Windows-hardware/design/device-experiences/oem-highly-secure#what-makes-a-secured-core-pc>

整个windows安全体系，挨个看吧 <https://docs.microsoft.com/zh-cn/windows/security/>

### 关闭“快速启动”

这傻逼功能不是设置UEFI快速开机，只是windows关机后系统状态暂存挂起功能，类似休眠。

但是，它使BIOS里定时自动开机失效，并跟很多usb设备不兼容，导致关机下次启动以后usb设备不可用，需要重新插拔。

比如我的无线网卡、我的显示器集成的hub连接的鼠标键盘等等，开机或重启后各种报错无响应……

关关关：

    打开设置-系统-电源和睡眠-其他电源设置（或右击开始菜单(win+x)，选择“电源选项”，弹出窗口的右侧选择“其它电源设置”），

    点击“选择电源按钮的功能”，选择“更改当前不可用的设置”，

    去掉勾选“启用快速启动（推荐）”，然后点击保存修改。

    小技巧：点击关机按钮时按住shift，此次关机就不使用快速启动

### 默认键盘设置为英文

中文版 Windows 10 默认唯一键盘是中文，而且中文键盘的默认输入法是微软拼音的中文状态。原Windows 7之前“Ctrl+空格”切换中英文的热键被微软拼音输入法使用了，而且按shift键就切换中英文，默认还是各个应用的窗口统一使用的。

问题是Windows桌面/资源管理器/炒股游戏等软件的默认状态是响应英文输入，仅对文本编辑软件才应该默认用中文输入。如果只有默认的中文键盘，则微软拼音输入法按一下shift键，中英文状态就切换，非常容易误触。在实际使用中，各个软件窗口一变，或者输入个字母就弹出中文候选字对话框，按个shift键，微软拼音输入法就来回切换中英文，非常非常非常的繁琐。尤其在有些游戏中，一按shift就切出来中文输入法，再按asdf就变成打字到中文输入法的输入栏了。

所以需要再添加一个“英文键盘”，使用它的英文输入法状态，并把这个键盘作为默认状态。两种键盘间切换使用热键“Win+空格”。这样做的好处是，切换键盘的同时中英文输入法也跟着切换了（不需要依赖在中文键盘下微软拼音输入法的shift键切换），而且不同的窗口还可以选择记住不同的输入法状态，非常方便。

设置->搜索“语言”，选择"英语"，添加确认，注意取消选择“设置为默认的界面语言”。

点击右侧按钮“拼写、键入和键盘设置”（设置->设备->输入），把输入提示、输入建议什么的都去掉，不然你按Ctrl+空格的时候会给你好看。

点击下面的“高级键盘设置”（设置->搜索“keyboard”，“高级键盘设置”），操作如下步骤：

    替换默认输入法，选择“英语”，而不是微软拼音输入法。这样对Windows桌面/资源管理器/炒股/游戏等软件的默认状态是英文按键的正确状态。

    勾选“允许我为每个应用窗口使用不同的输入法”，这个非常重要，可以实现有的窗口是英文键盘状态，有的编辑软件窗口保持是切换到中文键盘的微软拼音输入法状态。

    注意这两种键盘的切换热键是“Win+空格”，以后中英文输入的切换就切换键盘就行了，除非中文输入状态下临时输入英文按下shift键切换。

    取消勾选“使用桌面语言栏”，这个也很重要，某些全屏HDR游戏不兼容这个工具栏，一旦出来输入法条，显示器的HDR状态就跟着来回黑屏切换……

    选择“语言栏选项”，勾选“在任务栏中显示其他语言栏图标”，方便鼠标点选切换中英文键盘。

    选择“语言栏选项”，点击“高级键设置”：在“输入语言的热键”列表，点击“输入法/非输入法切换  Ctrl+空格”，点击“更改按键顺序”，取消勾选“启用按键顺序”可以禁用微软拼音输入法的中英文切换使用此按键，因为现在用shift键就够了。

### 关闭Windows自带的压缩文件夹（zip folder）

从 Windows XP 开始，之后的每一代操作系统（如 Vista、7、8、10），都有一个默认开启的功能：能将压缩文件当作普通文件夹来管理。

在资源管理器左侧的文件夹树视图中，展开一个包含压缩文件（zip 或 cab 格式）的文件夹时，就能看见这些压缩文件如同普通的子文件夹一样，可以直接展开。展开它们，就能很方便地浏览压缩文件中所有文件的信息，同时还能方便地解压。

但是一般用户通常都有自己喜爱的压缩软件，例如 WinRAR、7-Zip 等，他们往往不常使用系统自带的这个压缩文件管理方式，更倾向于使用压缩软件提供的右键菜单功能来压缩或解压文件。而且还会抱怨系统自带的压缩文件夹功 能消耗系统资源，每次打开文件夹时的延迟更让人觉得系统变得缓慢。

Windows XP关闭 zip folder 功能

    打开命令提示符窗口，输入“regsvr32 /u %windir%\system32\zipfldr.dll” （不含引号），回车后提示成功即可关闭。

    开启功能：
    打开命令提示符窗口，输入“regsvr32 %windir%\system32\zipfldr.dll”（不含引号），回车后提示成功即可打开。

提示：以上操作可能只关闭了 ZIP 文件的文件夹显示，可能 CAB 文件没有关闭。未测试。

Windows Vista、7、8、10关闭 zip folder 功能

需要删除或更名两个注册表键：

对于 ZIP 文件：HKEY_CLASSES_ROOT\CLSID\{E88DCCE0-B7B3-11d1-A9F0-00AA0060FA31}

对于 CAB 文件：HKEY_CLASSES_ROOT\CLSID\{0CD7A5C0-9F37-11CE-AE65-08002B2E1262}

由于涉及到权限问题，无法直接删除，需按照以下步骤来操作：（注册表操作有风险，要小心谨慎，并切记要备份。）

    按 Win-R，在运行窗口输入“regedit” 并回车，打开注册表编辑器。

    找到要操作的第一个注册表键 HKEY_CLASSES_ROOT\CLSID\{E88DCCE0-B7B3-11d1-A9F0-00AA0060FA31}

    右键单击它，从弹出菜单中单击“导出(E)”，将该注册表键的原始信息备份到安全位置，以便遇到不测时恢复。

    导出备份完成后，再右键单击该键，从弹出菜单中单击“权限(P)...”

    单击“高级(V)”按钮

    单击“所有者”选项卡

    在“将所有者更改为(O):”框中，选中你当前的用户名

    勾选“替换子容器和对象的所有者(R)”

    单击“应用(A)”按钮

    单击“确定”

    在“安全”选项卡下，在上框中选中你的用户名，然后 在下框中勾选“完全控制”的“允许”

    单击“应用(A)”和“确定”按钮

    现在，你可以自由选择删除或重命名这个注册表键了。注意：请确定你在正确的注册表键上操作！

    好，重复以上步骤来为 第二个注册表键进行重命名或删除。

    重启计算机，压缩文件夹是不是都消失啦？

开启功能：

恢复的话，只需将关闭时建立的两个备份文件导入注册表，重启即可。万一备份不见了，可以从另外的电脑中导出，当然前题是操作系统的版本要一致。

用开源的7-zip软件替换zip文件的打开方式

    打开7-zip软件，菜单“工具”->“选项”，弹出的窗口选择“系统”选项卡，列出的类型中，zip选择“7-zip”

### 切换黑暗模式（夜间模式）

次选：设置->系统->显示：选择打开“夜间模式”，Windows只是把色温降成黄色，显示器亮度还是很晃眼。

优选：设置->轻松使用->颜色滤镜：选择“打开颜色滤镜”，选择“灰度”按钮，显示器变成黑白效果，失去了彩色，也不舒服。

最优选：设置->个性化->颜色：下面有个“更多选项”，对“选择默认应用模式”选择“暗”，整个Windows的配色方案都变成了暗色，各个软件窗口也跟着变了。
这个办法最舒服，白天切换回去也很方便。写到注册表里，在桌面点击右键实现方便切换

Add_App_Mode_to_desktop_context_menu.reg：

```ini
Windows Registry Editor Version 5.00

; Created by: Shawn Brink
; Created on: September 3rd 2017
; Tutorial: https://www.tenforums.com/tutorials/92740-add-app-mode-context-menu-light-dark-theme-Windows-10-a.html
; Tutorial: https://www.tenforums.com/tutorials/24038-change-default-app-mode-light-dark-theme-Windows-10-a.html

[HKEY_CLASSES_ROOT\DesktopBackground\Shell\AppMode]
"Icon"="themecpl.dll,-1"
"MUIVerb"="App mode"
"Position"="Bottom"
"SubCommands"=""

[HKEY_CLASSES_ROOT\DesktopBackground\Shell\AppMode\shell\001flyout]
"MUIVerb"="Light theme"
"Icon"="imageres.dll,-5411"

[HKEY_CLASSES_ROOT\DesktopBackground\Shell\AppMode\shell\001flyout\command]
@="Reg Add HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize /v AppsUseLightTheme /t REG_DWORD /d 1 /f"

[HKEY_CLASSES_ROOT\DesktopBackground\Shell\AppMode\shell\002flyout]
"Icon"="imageres.dll,-5412"
"MUIVerb"="Dark theme"

[HKEY_CLASSES_ROOT\DesktopBackground\Shell\AppMode\shell\002flyout\command]
@="Reg Add HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize /v AppsUseLightTheme /t REG_DWORD /d 0 /f"
```

edge浏览器->设置->外观->整体外观：选择“系统默认”则跟随Windows系统的主题颜色变换，缺点是仅窗口标签外观变换。如果需要对网页内容开启夜间模式，需要强制开启：

    在浏览器地址栏输入edge://flags/

    在搜索栏输入“Force Dark Mode for Web Contents”

    选择enable，点击选择重启浏览器，除图片以外的所有部分进入夜间模式

### 关闭附件管理器检查

为什么要关闭？ 浏览器我正常下载的没签名的文件，在有些软件调用的时候就打不开，也没有任何提示，总是报错，让人抓狂。
之前遇到过技嘉制作u盘启动的工具，添加了下载的zip文件，总是制作失败，直到把下载的文件点击右键，选择属性，勾选解除限制，才能正常读取。整个过程中没有任何提示性信息。其它还有zip解压文件，读取zip压缩包，悄悄的失败，也没有任何提示，从Windows 7 到 Windows 11，一直如此。

有两种方法： 第一种是修改组策略中的配置：

“运行”中输入gpedit.msc，然后选择“用户配置”-“管理模板”-“Windows组件”-“附件管理器”。

    1.文件附件值中不保留区域信息，设置为“启用” （光这步就够了）

    2.文件类型的默认风险级别，设置为“启用”，“低风险”。
    3.低风险文件类型的包含列表，设置为“启用”，扩展名增加比如：.docx;.doc;.xls;.xlsx

第二种是增加一个全局的环境变量SEE_MASK_NOZONECHECKS，设置值为1.

    [HKEY_CURRENT_USER \Environment]
    SEE_MASK_NOZONECHECKS = "1"

### 删除无关占用cpu时间的项目

有了windows store后，商店应用由单独的wsappx.exe运行的UWP运行环境，甚至appx的保存目录 C:\Program Files\WindowsApps 都是默认锁定的。

单纯用msinfo32或传统的启动管理程序，只能看到本地windows的程序，由wsappx.exe运行的那些商店应用是没法单独看到的，目前只能由windows提供的开放接口查看和设置

目前用： 设置->应用->启动，看列出的项目，取消勾选可以禁止开机启动

在任务管理器中，有个应用历史记录，可以发现，比如windows photo这样的windows商店的appx应用占用cpu时间非常多，其实用户根本没用，真不知道它在后台干了些什么。不要犹豫，用不到的就删除啊。win+xn 设置->应用->应用和功能，搜索应用名称，找到后点击，展开菜单选择“卸载”即可。如果没有“卸载”选项，就得手工解决了，以删除cpu时间使用最多的windows photo为例：

    以管理员身份运行“Windows PowerShell”

    在控制台输入命令“Get-AppxPackage”回车键

    菜单项选择：编辑->查找，输入“photo”，按“查找下一个”按钮就能找到了

    找对应“PackageFullName”，包的名称。把后面的名称“Microsoft.Windows.Photos_2021.21090.10008.0_x64__8wekyb3d8bbwe”复制下来。

    在控制台输入命令“Remove-AppxPackage Microsoft.Windows.Photos_2021.21090.10008.0_x64__8wekyb3d8bbwe”回车键，等待片刻就卸载完了。

### 打开任务栏毛玻璃效果

<https://bbs.pcbeta.com/viewthread-1899753-1-1.html>

高斯模糊：
支持深、浅色模式
支持任务栏主题色
需重启资源管理器进程

```ini
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize]
; 开启透明效果
"EnableTransparency"=dword:00000001

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
; 任务栏透明度
"TaskbarAcrylicOpacity"=dword:00000005

[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"UseOLEDTaskbarTransparency"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm]
"ForceEffectMode"=-
```

恢复到系统默认：

```ini
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarAcrylicOpacity"=-

[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"UseOLEDTaskbarTransparency"=-

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm]
"ForceEffectMode"=-
```

重启explorer.exe

### 为Windows 10 Enterprise LTSC增加应用商店

<https://github.com/kkkgo/LTSC-Add-MicrosoftStore>

要开始安装, 请打包下载LTSC-Add-MicrosoftStore-2019.zip后用右键管理员运行 Add-Store.cmd

如果您不想安装App Installer / Purchase App / Xbox，请在运行安装之前删除对应的.appxbundle后缀的文件。但是，如果您计划安装游戏，或带有购买选项的应用，则不要删除。

如果装完之后商店仍然打不开，请先重启试试。如果仍然不行，请以管理员身份打开命令提示符并运行以下命令之后，然后再重启试试。
PowerShell -ExecutionPolicy Unrestricted -Command "& {$manifest = (Get-AppxPackage Microsoft.WindowsStore).InstallLocation + '\AppxManifest.xml' ; Add-AppxPackage -DisableDevelopmentMode -Register $manifest}"

商店修复
Win+R打开运行，输入WSReset.exe回车。
该命令会清空并重置Windows Store商店的所有缓存。

该脚本由abbodi1406贡献：
<https://forums.mydigitallife.net/threads/add-store-to-Windows-10-enterprise-ltsc-LTSC.70741/page-30#post-1468779>

## UEFI Fast Boot 设置为 Ultra Fast 启动的操作系统中引导到UEFI固件设置（无法用键盘进入主板BIOS设置的解决办法）

很多支持 Fast Boot 的主板，在主板BIOS的“Fast Boot”项设置了“Ultra Fast”之后，开机过程中不能用键盘进入BIOS了，解决办法是进入操作系统后指定下一次重启进入 BIOS。

对技嘉 B560M AORUS PRO 主板来说，可以对usb等各个细分选项分别设置是否在初始化的时候跳过，可以避免这个问题。

实际试了一下，没感觉到 Ultra Fast 比 Fast Boot 快多少，还是不用了。

### 在windows 10中指定重启到UEFI固件的步骤

    点击“开始”菜单—选择“设置”

    点击“更新和安全”

    在“更新和安全”界面中点击左侧的“恢复”选项，再在右侧的“高级启动”中点击“立即重新启动”

    Windows 10重启之后你将会看到出现一个界面提供选项，选择“疑难解答（重置你的电脑或高级选项）”

    新出现的界面选择“高级选项—>UEFI固件设置”，重启之后就可以直接引导到 UEFI 了。

    参考 <https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/boot-to-uefi-mode-or-legacy-bios-mode>

### Linux 指定重启到UEFI固件的步骤

    Linux 也可以在重启时告诉系统下一次启动进入 UEFI 设置。使用 systemd 的 Linux 系统有 systemctl 工具可以设置。

    可以查看帮助：systemctl --help|grep firmware-setup

    --firmware-setup Tell the firmware to show the setup menu on next boot
    直接在命令行执行下面命令即可在下一次启动后进入 UEFI 设置。

    systemctl reboot --firmware-setup
    参考资料：https://www.freedesktop.org/software/systemd/man/systemctl.html#--firmware-setup

原因是UEFI启动的操作系统是跟主板设置密切结合的，“Fast Boot”分几个选项，导致了初始化部分设备的限制：

    主板BIOS的“Fast Boot”项如果开启“Fast”选项，可以减少硬件自检时间，但是会存在一些功能限制，比如Fast模式下不能使用USB设备启动了，因为这个加速功能其实是在BIOS自检中禁止扫描USB设备了。

    主板BIOS的“Fast Boot”项如果开启“Ultra Fast”选项，之后就不能用键盘进入BIOS了，估计跟Fast模式一样把大部分不是必须的自检过程给禁用了，所以要想进BIOS只能清空CMOS或者在操作系统里选择“重启到UEFI”。

    参考说明
        <https://www.expreview.com/22043.html>
        <https://www.tenforums.com/tutorials/21284-enable-disable-fast-boot-uefi-firmware-settings-windows.html>

## 安全的使用你的 windows 10

确保windows安全中心中的相关设置都开启，参见上面的章节[刚装完 Windows 10 后的一些设置]里的“设置windows安全中心”部分。

### 1.浏览网页时防止网页偷偷改浏览器主页等坏行为

在edge浏览器，点击菜单，选择“应用程序防护窗口”，这样新开的一个edge窗口，是在虚拟机进程启动的，任何网页操作都不会侵入到正常使用的windows中。

在windows安全中心里可以设置，是否从这里复制粘贴内容到正常使用的Windows中等各种功能。

### 2.用沙盒运行小工具等相对不靠谱的程序

开始菜单，选择“windows sandbox”程序，将新开一个虚拟的windows窗口，把你觉得危险的程序复制粘贴到这个虚拟的windows系统里运行，格式化这里的硬盘都没关系，在这个系统里还可以正常上网。

这个虚拟的windows窗口一旦关闭，里面的任何操作都会清零，所以可以把运行结果复制粘贴到正常使用的windows中。

windows沙盒可以用配置文件的方式设置共享目录，并设置只读权限，方便使用。比如把c:\tools目录映射到windows沙盒里运行网络下载的小程序，或者把download目录映射到沙盒的download目录以便在沙盒里浏览网页并下载程序。

windows沙盒使用 WDAGUtilityAccount 本地帐户，所以共享文件夹也保存在这个用户目录的desktop目录下。

tools.wsb示例：

```xml
<Configuration>
  <MappedFolders>
    <MappedFolder>
      <HostFolder>C:\StartHere\tools</HostFolder>
      <ReadOnly>true</ReadOnly>
    </MappedFolder>
    <MappedFolder>
      <HostFolder>C:\Users\Public\Downloads</HostFolder>
      <SandboxFolder>C:\Users\WDAGUtilityAccount\Downloads</SandboxFolder>
      <ReadOnly>false</ReadOnly>
    </MappedFolder>
  </MappedFolders>
  <LogonCommand>
    <Command>explorer.exe C:\users\WDAGUtilityAccount\Downloads</Command>
  </LogonCommand>
</Configuration>
```

MappedFolder可以有多个，默认映射到桌面，也可以单独指定，关于windows沙盒的详细介绍，参见 <https://docs.microsoft.com/zh-cn/windows/security/threat-protection/windows-sandbox/windows-sandbox-overview>

## Windows 10 使用虚拟机的几个途径

### Hyper-V

这个方法就像普通虚拟机操作了，类似 VM Ware、Virtual Box
<https://docs.microsoft.com/zh-cn/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v>

### docker (Hyper-V)

windows 10+ 上的docker是通过Hyper-V实现的，之前的windows 7 上的docker是安装了virtual box。
<https://docs.microsoft.com/zh-cn/virtualization/windowscontainers/about/>

需要注意不同映像的区别，完整windows api的是windows和windows server，其它的是仅支持 .net
<https://docs.microsoft.com/zh-cn/virtualization/windowscontainers/manage-containers/container-base-images>

### 适用于 Linux 的 Windows 子系统（WSL）- 命令行安装Ubuntu

WSL2的底层还是使用了虚拟机（Hyper-V），但是他使用的Linux完全集成到了windows中，即使用起来就像在windows中直接运行linux程序。

开发工具可以使用Virsual Studio Code，支持直接打开WSL虚机，就像连接Docker虚机或远程连接SSH服务器一样简单。其它开发工具如git、docker、数据库、vGpu加速（<https://developer.nvidia.com/cuda/wsl> ）等也都无缝支持，详见 <https://docs.microsoft.com/zh-cn/windows/wsl/setup/environment>

1.开启 WSL 功能： windows 设置->应用和功能，点击右侧的“程序和功能”，弹出窗口选择“启用或关闭windows功能”，在列表勾选“适用于Linux的Windows子系统”，确定。

2.power shell下就执行几个命令：

    # 安装ubuntu，已经安装过了忽略这条
    # 详见 <https://docs.microsoft.com/windows/wsl/install>
    wsl --install -d Ubuntu

    # 更新WSL内核，需要管理员权限
    wsl --update

    # 查看当前wsl安装的版本及默认linux系统
    wsl --status
    默认分发：Ubuntu
    默认版本：2

    # 进入ubuntu系统
    wsl 或 bash

    # 更新下包
    sudo apt update
    # 建议更换国内源之后再做 apt-get update | apt-get upgrade

    # 看看安装的什么版本的linux
    $ sudo lsb_release -a
    [sudo] password for xx:
    No LSB modules are available.
    Distributor ID: Ubuntu
    Description:    Ubuntu 20.04 LTS
    Release:        20.04
    Codename:       focal

    # 安装小火车
    sudo apt install sl

    # 出现火车，说明安装成功
    sl

3.Linux 下的GUI应用的安装和使用

    详见 <https://docs.microsoft.com/zh-cn/windows/wsl/tutorials/gui-apps>

4.手动下载安装linux的微软发行版

    详见 <https://docs.microsoft.com/zh-cn/windows/wsl/install-manual#downloading-distributions>

5.安装遇到问题

遇到报错试试下面这个：

    启用“适用于 Linux 的 Windows 子系统”可选功能
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    启用“虚拟机平台”可选功能
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    要启用 WSL，请在 PowerShell 提示符下以具有管理员权限的身份运行此命令：
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

更多的问题，详见 <https://docs.microsoft.com/zh-cn/windows/wsl/troubleshooting>

注意：

    使用了WSL2就只能用微软发布的Linux版本<https://docs.microsoft.com/zh-cn/windows/wsl/compare-versions#full-linux-kernel>，但是提供了完全的二进制兼容，用户可以自行升级linux内核。

    甚至可以在上面再运行docker，这个docker也需要是微软发布的 <https://docs.microsoft.com/zh-cn/windows/wsl/tutorials/wsl-containers> 。

    这个虚拟机是放到当前用户目录下的，类似于：USERPROFILE%\AppData\Local\Packages\CanonicalGroupLimited...，所以注意你的c盘空间。如果需要更改存储位置，打开“设置”->“系统”-->“存储”->“更多存储设置: 更改新内容的保存位置”，选择项目“新的应用将保存到:”

### 图形化安装 - Windows Store 安装Ubuntu子系统 (WSL)

win10+ubuntu双系统见<https://www.cnblogs.com/masbay/p/10745170.html>

1.首先点击开始，然后点击设置

2.选择更新和安全

3.在左边点击开发者选项

4.点击开发人员模式，选择打开

5.会出现正在安装开发人员模式程序包

6.稍等片刻，大概2分钟左右就可以安装成功

7.然后返回，点击应用

8.在应用和功能界面，选择程序和功能

9.点击启用或关闭Windows功能

10.弹出的窗口中拉到最下面，勾选上适用于Linux的Windows子系统

11.然后会自动安装所需要的库

12.大约5秒，安装完毕后需要重启电脑

【废弃】13.重启电脑后并没有安装linux系统，还需要输入lxrun /install /y来进行系统的下载 （win10 2020版已经弃用此命令）

13.在Windows搜索框中输入网址 <https://aka.ms/wslstore> ，然后回车，之后会先打开edge浏览器，然后自动跳转到win10应用商店。
打开微软商店应用，在搜索框中输入“Linux”然后搜索，选择一个你喜欢的 Linux 发行版本然后安装。

14.然后会弹出一个shell窗口，正在安装。

15.安装完会提示输入用户名和密码，输入自己的就可以。

16.然后安装完成后点击打开，等待启动

17.初次使用ubuntu

打开cmd，输入bash。

输入sudo apt update 检测更新

输入sudo apt install sl 安装小火车

输入sl 出现火车，说明安装成功

最后要说明的一点是，这个系统是安装在C:\Users\%user_name%\AppData\Local\lxss中的，所以会占用c盘的空间，所以最好把数据之类的都保存在其他盘中，这样不至于使c盘急剧膨胀。

后续关于如何更换国内源、配置ubuntu桌面并进行vnc连接，参见 <https://sspai.com/post/43813>

## 使用中要注意，WSL下的Linux命令区别于某些PowerShell下的命令

注意 PowerShell 对某些linux命令是使用了别名，而不是调用的真正的exe文件，有没有后缀.exe是有区别的！

下面是个例子 ：

    # <https://docs.microsoft.com/zh-cn/windows/wsl/install-manual#downloading-distributions>
    使用 curl 命令行实用程序来下载 Ubuntu 20.04 ：

    控制台

        curl.exe -L -o ubuntu-2004.appx https://aka.ms/wsl-ubuntu-2004

    在本示例中，将执行 curl.exe（而不仅仅是 curl），以确保在 PowerShell 中调用真正的 curl 可执行文件，而不是调用 Invoke WebRequest 的 PowerShell curl 别名。详细列表参见 <https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.2>

## 常见问题

### 如何判断USB Type-C口有哪些功能

    <https://www.asus.com.cn/support/FAQ/1042843>

### 显示器在Win10开启HDR变灰泛白的原因

在游戏或播放软件里单独设置HDR选项就可以了，Windows系统不需要打开HDR选项，目前的 Windows 10 并没有很好的适配HDR显示器。

原因很简单, 你的显示器并不真正提供HDR显示(OLED/FALD), 而Windows还没有对Display HDR400和600这两个"假HDR"提供支持.

Windows现在的偏灰, 是在输出HDR信号的情况下自动降低UI亮度的被Display HDR400误显示的结果. 这些显示器的HDR并没有低亮度细节, 所以低亮度部分就发灰了.HDR和暗部平衡差不多，都可以把暗部系列显示出来，所以看起来就像是亮度调得很高的样子，会泛白.

这个问题在FALD/OLED显示器上是不存在的. 仅在Display HDR400-600的"假HDR"显示器上存在.

简单来说就是为了支持桌面HDR软件App, 桌面必须声明需求显示器的完整HDR亮度范围. 然而显然桌面UI本身不能闪瞎人眼, 所以桌面UI的亮度是低亮度模式. Display HDR400-600的显示器并不能显示完整的HDR内容, 自然这种为真HDR设计的模式就会出现显示错误.

因为其实问题是Display HDR400-600并不是真的支持HDR, 亮度范围根本没那么大, 现有的协议并没有体现出这一点微软也没辙, 属于技术局限, 只能等未来看微软打算怎么解决这个问题了.

最好是显示器厂商单独出HDR配置文件, 让Windows自动识别实际的HDR亮度范围, 而不是接收显示器现在汇报的这个虚假的HDR亮度范围.

现在的HDR标准其实是纯凑活事的, 信号输出了剩下的全看显示器, 导致HDR内容的显示没有任何标准, 大家效果千差万别. 这在真HDR显示器上也很明显, 不同品牌的FALD显示器效果也是完全不同的. 颜色亮度各种跑偏. 完全是群魔乱舞.

很多游戏内置HDR选项, 让你单独调节亮度来适应屏幕就是这个原因.
