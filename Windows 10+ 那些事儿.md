
# Windows 10+ 安装的那些事儿

## UEFI 安全启动必须了解的关键概念

### 应用/APP

跟以前的 application 区别，那个是 Windows 桌面版的 exe 程序，俗称应用程序。

现在的 app 来自于安卓、ios 操作系统，俗称应用。

微软自 Windows 10 以来，为了打通手机和桌面操作系统，把 app 商店这一套都移植到 Windows 了， 而且开发工具也在打通，一套 API 可以在多个 os 平台无缝自适应运行，所以在 Windows 10+ 里的 “应用” 这个词，特指商店里安装的那些 “app”。

### 目标系统类型 UEFI/CSM

UEFI 模式是 Windows 7 之后出现的新型操作系统启动引导方式，可以优化硬件驱动的加载方式，加速了开机步骤，缺点是跟 Windows 7 之前的传统系统启动过程不兼容。

主板加载操作系统的方式在“传统 BIOS(Leagcy)”模式、“UEFI CSM” 模式（兼容传统(Leagcy)）和原生 UEFI 模式之间完全不同。为区别于原生 UEFI，主板 BIOS 设置中提供了兼容传统(Leagcy)模式的 “UEFI CSM” 模式，一般简称 CSM 模式。CSM 模式可以在 UEFI 启动时让不兼容原生 UEFI 方式启动的老显卡和存储设备等可以正常的工作。

具体来说，CSM 模式启动时主板 BIOS 可以选择使用 “传统(Leagcy)“ 模式引导 UEFI 设备和非 UEFI 设备：比如硬盘 MBR 引导和传统 PCI opROM 加载支持，后者可以让没有支持 UEFI GOP VBIOS 的显卡在操作系统启动前（例如 BIOS 设置和 OS 引导器）可以使用并固定使用 VGA 分辨率（如果开机后显示的主板厂商 logo 基本满屏就说明可能是 CSM 模式）。存储或 PCIE 设备只要其中一个用到该功能就需要主板打开 CSM 模式。支持  WinXP/Win7 的 Intel z170 之前的主板还提供使用非 UEFI 的传统(Leagcy)模式的选项。

有些如 Nvidia gtx 1080 时代的显卡，用 HDMI 口可以在 UEFI 模式显示画面，而 DP 口则不兼容（只能在 CSM 模式进行显示），需要根据连接该口开机后显示器是否出现画面来调整 BIOS 的选项。

### 硬盘分区类型 GPT/MBR

MBR 是 Windows 7 之前的硬盘分区方式，GPT 是后续增加的原生 UEFI 引导使用的硬盘分区方式。对不同的硬盘分区类型，Windows 引导启动的方式是不同的。

传统 BIOS、UEFI CSM 模式和原生 UEFI 之间完全不同，一个主要的区别是硬盘分区在硬盘上的记录方式：传统模式 和 CSM 模式下使用 DOS 分区表（MBR），原生 UEFI 模式使用不同的分区方案，称为 “GUID分区表”（GPT）。

在单个磁盘上，MBR 或 GPT 类型只能使用二者之一，并且在同一个磁盘上使用不同操作系统的多引导设置的情况下，所有系统都必须使用相同类型的分区表。使用 GPT 从磁盘引导只能在原生 UEFI 模式下进行 <https://www.debian.org/releases/stable/amd64/ch03s06.zh-cn.html#UEFI>。

在 Windows 安装时，有个步骤是划分硬盘分区，如果是一块新的未划分分区的硬盘，默认把启动硬盘上划分了 3 个分区，其中两个特殊的小分区在 Windows 安装完成后默认是隐藏看不到的，这里其实放置了存储设备的 UEFI 引导信息，但无法保证硬盘类型是 GPT 还是 MBR，依赖条件见章节 [确保硬盘格式化为 GPT 类型]。

如果只想用一个分区，需要提前把硬盘挂到别的电脑上用 Windows 管理或其他软件分区，明确选择类型为 MBR，或者在 Windows安装程序界面按 Shift+F10 调出命令行，使用命令行 diskpart 程序，手工划分（不推荐）。这样主板必须设置为 CSM 模式了，因为需要它启动时读取 MBR 磁盘数据。

### EFI 方式加载设备驱动程序

BIOS 启动的时候，按照 CMOS 设置里的顺序，挨个存储设备看：（此处不讨论 PXE 和光盘）
    这个存储设备的前 512 字节是不是以 0x55 0xAA 结尾？
    不是，那就跳过。找下一个设备。
    是的话，嗯，这个磁盘可以启动，加载这 512 字节里的代码，然后执行。
执行之后，后面的事，几乎就跟 BIOS 没啥关系了。

UEFI 启动的时候，经过一系列初始化阶段（SEC、CAR、DXE 等），然后按照设置里的顺序，找启动项。

启动项分两种，设备启动项和文件启动项：

    文件启动项，大约记录的是某个磁盘的某个分区的某个路径下的某个文件。对于文件启动项，固件会直接加载这个 EFI 文件，并执行。类似于 DOS 下你敲了个 win.com 就执行了 Windows 3.2/95/98 的启动。文件不存在则失败。

    设备启动项，大约记录的就是“某个u盘”、“某个硬盘”。（此处只讨论u盘、硬盘）对于设备启动项，UEFI 标准规定了默认的路径“\EFI\Boot\bootX64.efi”。UEFI 会加载磁盘上的这个文件。文件不存在则失败。

    UEFI 标准 2.x，推出了一个叫做 SecureBoot 的功能。开了 SecureBoot 功能之后，主板会验证即将加载的 efi 文件的签名，如果开发者不是受信任的开发者，就会拒绝加载。所以主板厂商需要提前在主板里内置微软的公钥，设备商想做 efi 文件需要去微软做认证取得签名，这样主板加载 efi 的时候会用内置的微软的公钥验证设备商 efi 文件里的签名，通过了才加载。这个过程从头到位都得微软认证，满满的对 Linux 不友好啊。

    目前Debian包含一个由 Microsoft 签名的 “shim” 启动加载程序，因此可以在启用了安全引导的计算机上正常工作  <https://www.debian.org/releases/stable/amd64/ch03s06.en.html#secure-boot>。

首先各种 PCI-E 的设备，比如显卡，比如 PCI-E 的 NVMe 固态硬盘，都有固件。其中支持 UEFI 的设备，比如 10 系列的 Nvidia 显卡，固件里就会有对应的 UEFI 的驱动。

UEFI 启动后，进入了 DXE 阶段，就开始加载设备驱动，然后 UEFI 就会有设备列表了。启动过程中的 DXE 阶段，全称叫 Driver eXecution Environment，就是加载驱动用的。

对于其中的磁盘，UEFI 会加载对应的驱动解析其中的分区表（GPT 和 MBR）。

然后 UEFI 就会有所有分区的列表了。然后 UEFI 就会用内置的文件系统驱动，解析每个分区。UEFI 标准里，钦定的文件系统，FAT32.efi 是每个主板都会带的。所有 UEFI 的主板都认识 FAT32 分区。这就是 UEFI 的 Windows 安装盘为啥非得是 FAT32 的，UEFI 模式安装好的的 Windows 操作系统，也会有个默认的 FAT32 格式的 EFI 分区，就是保存的这个信息以便主板读取加载。苹果的主板还会支持 hfs 分区，Linux 如果有专用主板，那应该会支持 EXT4.efi 分区。

然后 UEFI 就会认识分区里的文件了。比如“\EFI\Boot\bootX64.efi”。UEFI 规范里，在 GPT 分区表的基础上，规定了一个 EFI 系统分区（EFI System Partition，ESP），ESP 要格式化成 FAT32，EFI 启动文件要放在“\EFI\<厂商>”文件夹下面。比如 Windows 的 UEFI 启动文件，都在“\EFI\Microsoft”下面。

如同 Windows 可以安装驱动一样，UEFI 也能在后期加载驱动。比如 CloverX64.efi 启动之后，会加载、EFI\Clover\drivers64UEFI 下的所有驱动。包括 VboxHFS.efi 等各种 efi。网上你也能搜到 NTFS.efi。再比如，UEFIShell 下，你可以手动执行命令加载驱动。

根据 UEFI 标准里说的，你可以把启动u盘里的“\EFI\Clover”文件夹，拷贝到硬盘里的 ESP 对应的路径下。然后把“\EFI\Clover\CloverX64.efi”添加为 UEFI 的文件启动项就行了。Windows 的 BCD 命令，其实也可以添加 UEFI 启动项。

EFI 分区中的“\EFI\Boot”这个文件夹，放谁家的程序都行。无论是“\EFI\Microsoft\Boot\Bootmgfw.efi”，还是“\EFI\Clover\CloverX64.efi”，只要放到“\EFI\Boot”下并且改名“bootX64.efi”，就能在没添加文件启动项的情况下，默认加载对应的系统。

传统模式下：

    BIOS 加载某个磁盘 MBR 的启动代码，这里特指 Windows 的引导代码，这段代码会查找活动分区（BIOS 不认识活动分区，但这段代码认识活动分区）的位置，加载并执行活动分区的 PBR（另一段引导程序）。

    Windows 的 PBR 认识 FAT32 和 NTFS 两种分区，找到分区根目录的 bootmgr 文件，加载、执行 bootmgr。

    bootmgr 没了 MBR 和 PBR 的大小限制，可以做更多的事。它会加载并分析 BCD 启动项存储。而且 bootmgr 可以跨越磁盘读取文件了。所以无论你有几个磁盘，你在多少块磁盘上装了 Windows，一个电脑只需要一个 bootmgr 就行了。bootmgr 会去加载某磁盘某 NTFS 分区的“\Windows\System32\WinLoad.exe”，后面启动 Windows 的事就由 WinLoad.exe 来完成了。

UEFI 模式下：

    “UEFI 下，启动盘是 ESP 分区，跟 Windows 不是同一个分区”。

    主板 UEFI 初始化，在 EFI 系统分区（ESP）找到了默认启动项“Windows Boot Manager”，里面写了 bootmgfw.efi 的位置。固件加载 bootmgfw.efi。bootmgfw.efi 根据 BCD 启动项存储，找到装 Windows 的那个磁盘的具体分区，加载其中的 WinLoad.efi。由 WinLoad.efi 完成剩下的启动工作。

#### UEFI 之后真的没法 Ghost 了么

Windows 10 下使用 “系统映像备份” 备份到别的硬盘，以后可以选择重启到 WinRe 进行恢复，不需要用ghost了，详见章节 [系统映像备份]。

传统的 Ghost 盘，都是只 Clone 了 C 盘，现在应该 clone 整个磁盘，这样所有的分区包括 EFI 系统分区都可以备份了。

Ghost 备份，并不能备份分区的 GUID。这时候，需要用 bcdedit.exe 命令，或者 BCDBoot.exe 命令，修改 BCD 存储。

鉴于目前的 Ghost 盘，很少基于 DOS 了，如果是基于 WinPE 的，bcdedit 命令和 bcdboot 命令都是已经内置了的。
只要制作者在批处理文件里，在 Ghost 之后，调用 bcdedit 命令改一下 bcd 配置就行了。

即使没 Ghost 备份 ESP 分区，你依然可以用 bcdboot 命令来生成 ESP 分区的内容。
同样，在 WinPE 下，批处理文件里，Ghost 还原之后，使用 BCDBoot 命令生成启动文件就行了。

所以，Ghost 还原 Windows 分区之后，调用 BCDBoot 配置启动项即可。

1.WinPe 中的 UEFI 引导修复工具，点挂载，挂载后可看到 esp 分区挂载为 S 盘

2.如果没有步骤 1 中的 PE 盘，则用 Windows 安装盘引导，在开始安装的界面按 Shift+F10 调出命令行，使用 diskpart 的”assign letter”调整各驱动器的盘符。

把 Windows 分区调整成 C，保留分区调整成其他比如为 S：

    Diskpart
    >list disk
    >select disk 0

    # Verify that the EFI partition (EPS) is using the FAT32 file system and assign a drive letter to it that is not already in use:
    >list vol
    >sel vol 1
    >assign letter=S:

    下三行不用了，分区和 vol 还不一样呢
        >list partition
        >Select Partition 1
        >assign letter=S:

    >exit

    参考自 https://zhuanlan.zhihu.com/p/149099252

3.用 BCD 引导修复，指定已经 ghost 恢复的 C 盘，efi 分区是 S 盘：

    bcdboot C:\Windows  /s S: /f uefi /l zh-cn

如果是 MBR 分区的，不这么写，暂不研究了，Windows 10 还是用 UEFI 比较好.

UEFI 下用 diskpart 进行分区的详细资料见<https://docs.microsoft.com/zh-cn/Windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions>

#### 不需要第三方工具就能做 UEFI 下的 Windows 安装盘？

U 盘，格式化成 FAT32，然后把 Windows 安装盘的 ISO 里面的东西提取到u盘就行了。（适用于 Win8/8.1/10 以及 WinServer2012/2012R2/2016。WinVista x64/Win7x64 以及 WinServer2008x64/2008R2 需要额外操作，WinVista x86/Win7x86/WinServer2008x86 不支持 UEFI）

#### 电脑是 UEFI 的，想装 Linux，但我手头没u盘，听说也能搞定

硬盘搞个 FAT32 的分区，把 Linux 安装盘的 iso 镜像里面的文件 /EFI/BOOT/ 下的 BOOTx64.efi、grubx64.efi 拷贝进去，然后在 Windows 下，用工具给那个分区的 BOOTx64.efi，添加为 UEFI 文件启动项，开机时候选那个启动项，就能启动到 Linux 安装盘了。

如果你要装的 Linux 不支持 SecureBoot，记得关掉主板 BIOS 的 SecureBoot 设置。

#### MBR 分区表，也能启动 UEFI 模式下的 Windows

只是 Windows 安装程序提示不允许罢了。

现代主板 BIOS 设置为 UEFI 模式启动，如果引导时没找到 GPT 分区，就会自动转 CSM 模式，通过 MBR 分区表引导 UEFI 模式的 Windows 进行启动（c盘有两个隐含分区的那种Windows）。这就是为啥有些人的电脑开机后黑屏等半天才会开始出现 Windows 启动画面的原因，BIOS 发现引导超时才会自动转 CSM 模式。

#### 参考

    本文来源 https://zhuanlan.zhihu.com/p/31365115

    BCDBoot 命令行选项 https://docs.microsoft.com/zh-cn/Windows-hardware/manufacture/desktop/bcdboot-command-line-options-techref-di

    BCDEdit 命令行选项 https://docs.microsoft.com/zh-cn/Windows-hardware/manufacture/desktop/bcdedit-command-line-options

## 技嘉 B560M AORUS PRO 主板（BIOS 版本 F7） + Intel 11600KF CPU + DDR4 3600 内存的初始 BIOS 设置

1、HDMI 口连接显示器（防止 Nvidia 40 系以下显卡的 DP 口不支持默认的 UEFI），开机按 Del 键进入主板 BIOS 设置。

2、F7 装载系统默认优化设置：BOOT->Load optimized defaults，F10 保存设置并立刻重启计算机。然后再重新进入主板 BIOS 设置做进一步设置。特别是在装机后第一次开机后、刷新bios后、主板更换电池后等情况下。

我装机时第一次开机进入 BIOS 连续改一堆设置，正改着就死机了，估计是bios系统没初始化好，改的太多它自己就乱了或主板电池没激活导致的。所以如果有很多功能要调整，别连续改，改一个系列的就保存设置重启计算机一次。

3、注意这之后引导操作系统默认是 UEFI 的，存储设备选项需要手动打开 CSM 后切换，详见后面的章节 [主板 BIOS 设置启动模式为原生 UEFI]。

4、内存：TWEAKS->Memory， 选择 X.M.P profiles，以启用 3600MHz 最优频率，这个版本的 BIOS 也已经自动放开了，我的这个内存默认 1.2v 跑到了 3900MHz。

5、AVX512: Advanced CPU settings-> AVX settings，选 custom，出现的 avx512 选项选择 disable，关闭这个无用功能，可以降低 20%的 cpu 整体功耗。

6、虚拟化：Advanced CPU settings-> Hyper Threading 选项打开英特尔 CPU 超线程； Settings-> MISC-> VT-d 选项打开虚拟机。

7、F6 风扇设置：对各个风扇选静音模式，或手动，先选全速看看最大转速多少，再切换手动，先拉曲线到最低转速，然后再横向找不同的温度调整风扇转速挡位。

8、BIOS 开启 UEFI + GPT 和 Secure Boot： 先 F10 保存之前的设置并重启计算机，然后再进行设置，详见章节[Windows 启用 Secure Boot 功能]

9、不需要开启 “UEFI Fast Boot”。参见章节 [开启或关闭“快速启动”]

10、寻找英特尔 SpeedStep 技术或增强型英特尔 SpeedStep 技术（EIST），选择启用或禁用。这个技术是2000年代英特尔为笔记本电脑处理器搞出来的节能技术，以能效比为优先策略导致状态切换明显卡顿，特别是激烈的枪战游戏能卡顿你会信？一般台式机玩家都会选择关掉。

后来的 Speed Shift 技术没这么明显的问题了，Windows 10 等操作系统使用这个技术动态调整频率节能甚至睿频（短时超频），用户感知不明显，一般开启即可。或可用 Intel XTU、Throttlestop 软件手动调整 EPP 的设置，降低响应延迟。

    https://zhuanlan.zhihu.com/p/42438026
    https://zhuanlan.zhihu.com/p/109877021

如果讨厌这种cpu级别频率变动技术带来的动态延迟变化，直接在 BIOS 关闭所有的这些相关选项，把cpu频率设置也定在固定频率即可。这样可以观察到你的cpu 频率和功耗不再动态变化，一直稳定在官方 TDP 值。

### 电源功耗 PL1/PL2

不用设了，这个版本的 BIOS 已经全放开了。开机默认就是 4.6 GHz

参考

    https://zhuanlan.zhihu.com/p/359307098

    https://zhuanlan.zhihu.com/p/403675380

以下引用网上烤鸡的文章：

    先默认状态烤个机：在 AIDA 的 FPU 烤机测试中，我们可以看到 10700K 最终在接近70℃左右的温度下运行在了 4.5GHz 左右，功耗保持在 125W 左右。通过对记录文件的分析，开启测试后 10700K 频率保持在 4.7G Hz全核心（140W），3 分钟之后掉到了 4.5GHz~4.6GHz 之间跳动。通过这一点判断，B560M AORUS PRO AX 一阶段功耗控制约 140W，二阶段功耗控制在 125W。

    其实你只需要在BIOS里面设置一下就可以让他不降频。我把CPU的核心电压降低到1.25v，其他不动然后再进行烤机。这个时候我们的10700K就可以工作再65摄氏度4.7GHz左右了，功耗只有121W。也就是说只要不突破它的功耗限制就不会发生降频。

    如果我拿一个10900K装到这个主板上再降压都会被限制睿频的提升？没错，但是还有其他办法，那就是解锁功耗墙。

    在BIOS中找到“进阶处理器设置”，然后找到“TurboPower限制”，然后把功耗限制1/功耗限制2都设置到较高的值，对于10代酷睿 220W以上就足够了，当然也可以直接设置到最高，然后再把电流极限也拉高，可以直接到256。

    那么这个时候也是可以稳定运行在4.7GHz的，只不过功耗和温度都有所提升。如果各位使用的是10900K或者11900K/11700K的话可以参考以上两种方法进行设置，解锁功耗墙的同时适当降压获得更低的功耗和温度。

    有人肯定会担心降压会影响稳定性和单核心最高睿频，这个是没有错的，所以我说“适当降压”，大家可以0.01的幅度降压然后反复测试找到自己CPU的“甜蜜点”（每个CPU体质不尽相同）。我降压1.25v时单核心性能时稍稍有点落后，但是多核心相差很少的：降压1.24v

### 内存超频大于 3600 MHz 会分频实际效果变差

3200 MHz、3600 MHz 频率内存最适合于 B560 主板 +11 代酷睿平台。这样的频率下并没有分频。当超频至 4000 MHz 时，虽然内存带宽有所增加，但是延迟却比 3600 MHz 高出不少，这是 Gear2 分频模式下带来的弊端。除非将内存超至 4400 MHz 或以上高频，同时保持较好的时序。那内存带宽提升的同时，延迟也会降下来。

## 安装 Windows 启用 Secure Boot 功能

从制作安装 u 盘，到主板 BIOS 设置，都要进行设置

    https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-secure-boot

    https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/secure-boot-landing

    嵌入式 CPU 安全启动的说明 https://www.zhihu.com/question/57346559/answer/2895463445

    ARM 对安全启动 --- ATF https://zhuanlan.zhihu.com/p/391101179

    苹果笔记本ARM版电脑不再使用UEFI启动 https://zhuanlan.zhihu.com/p/680420213

> 前提条件：原生 UEFI+GPT

NOTE: Windows 10+ 取消了对非 ssd 硬盘做系统盘的优化，SATA 硬盘做系统盘最多安装 Windows 8。

Secure Boot 功能是 Windows 在安装时自动确定是否可以开启的

    安装 u 盘在制作时要选择 “GPT+UEFI” 方式：见下面的一

    主板 BIOS 设置启动模式为原生 UEFI：见下面的二

    主板 BIOS 设置开启 Secure Boot 功能：见下面的三

    安装u盘启动计算机时要选择 UEFI 模式：见下面的四

    硬盘分区格式化时使用 GPT 类型：见下面的五。

    旧显卡如果不是连接 HDMI 口而是 DP 口，参见章节 [老显卡不支持 DP 口开机显示（Nvidia Geforce 1080 系）]

只要系统引导时不是原生 UEFI+GPT，比如使用 UEFI CSM 兼容模式，这样安装的 Windows 无法开启 Secure Boot 功能

    比如安装 Windows 后发现 BIOS 启动模式不是原生 UEFI，把 BIOS 设置里的存储设备类型改回为 UEFI：该硬盘启动系统的时候会自动跳转主板 BIOS 的 CMS 模式的 UEFI，读取硬盘的 UEFI 分区引导系统。无法启用 Secure Boot 功能，只能重装系统 Windows。

如果有条件不符合要求，Windows 10 安装程序不会做任何提示，会自动选择兼容的 CSM 模式，在安装完成启动 Windows 后运行 msinfo32 才能确认 Secure Boot 功能是否成功开启。

安装 Windows 11 在 Secure Boot 的基础上，还要求主板 BIOS 开启 TPM2.0

    https://support.microsoft.com/en-us/windows/enable-tpm-2-0-on-your-pc-1fd5a332-360d-4f46-a1e7-ae6b0c90645c

    进入主板 BIOS 设置的 “Settings”，选择 “Intel Platform Trust Technology(PTT)”，选择 “Enable”，下面的选项 “Trusted Computing” 回车，进入的设置界面，找 “Security Device Support” 选择 “Enable”。

2024年的 Windows 7 如果需要支持 UEFI 需要打补丁，之前的数字签名都过期了，安全启动功能会限制驱动程序导致 Windows 7 无法启动

    KB5017361 该补丁依赖 KB5017397

    更新并重签名了引导文件 bootmgr.efi 和 bootmgfw.efi 及内核 winload.efi 文件属性

    虚拟机设置固件类型下，可选择 UEFI 并且勾选启用安全引导

### 一、制作支持 UEFI + GPT 的启动u盘

建议使用英文版 Windows 的 iso 文件制作启动u盘，在安装 Windows 时，区域设置选择 “新加坡”，系统语言选择简体中文。或者选择区域为美国，安装完成后添加中文语言包，然后更改界面提示语言为简体中文，原因不解释。安装后在键盘选项的 “非unicode区域设置” 选择“中国”即可支持 Windows xp 时代的 gbk 编码的中文程序正常显示。

u盘制作工具

    开源的 rufus 这个最佳，可惜只支持 Windows 下使用

        https://rufus.ie/
            https://github.com/pbatard/rufus

    社区版 balena Etcher 支持多平台

        https://etcher.balena.io/
            https://github.com/balena-io/etcher/

    ventoy 原无忧启动，优势是自定义多合一启动盘

        https://www.ventoy.net/
            https://github.com/ventoy/Ventoy

        https://soulteary.com/2023/11/08/open-source-all-in-one-usb-flash-drive-maintenance-tool-ventoy.html

#### 用 Rufus 制作 Windows 10+ 安装u盘

用 Rufus 制作安装u盘时，分区类型要选择 GPT，这时目标系统类型自动选择 UEFI。

对 Windows 10 来说这是可选的，如果u盘用 MBR 模式启动，那主板 BIOS 也得设置存储设备为非 UEFI（或 CMS 兼容模式）才能引导，但这会导致 Windows 10 安装后无法开启 Secure Boot 功能。

特殊之处在于 Rufus 3.17 版之前制作的启动u盘，初始引导启动需要临时关闭“Secure Boot”（3.17 之后的版本不用了，已经取得 Windows 的签名了）：

    一、根据 Rufus 的要求 <https://github.com/pbatard/rufus/wiki/FAQ#Windows_11_and_Secure_Boot>，见下面的章节 [老显卡不支持 DP 口开机显示（Nvidia Geforce 1080 系）] 中的 [凑合方案：主板 BIOS 设置为 CSM 方式安装 Windows 可以连接 DP 口]。

    用 Rufus 制作的启动u盘（制作时的选项是“分区类型 GPT+目标系统类型 UEFI”）启动计算机，Windows 安装程序自动启动，按提示点选下一步，注意原硬盘分区建议全删，这时 Windows 安装程序开始拷贝文件，并未实质进入配置计算机硬件系统的过程，这时的 Windows 安装过程并不要求 Secure Boot。

    注：觉得 Secure Boot 关闭就不安全了？ 不，它本来就不是什么安全措施，只是名字叫安全，其实做的工作就是数字签名验证，而且微软的密钥已经在 2016 年就泄露了…… 参见<https://github.com/pbatard/rufus/wiki/FAQ#Why_do_I_need_to_disable_Secure_Boot_to_use_UEFINTFS>。也就是说，各个厂商制作的驱动，现在都需要给微软发申请得到数字签名，这样操作系统启动时才会加载该驱动，仅此而已。

    至于 Linux，没参与微软的这个步骤的话，主板厂商不会内置它的公钥到主板中，安装的时候无法开启 Secure Boot 选项。后续如何解决还需要 Linux 跟微软的协调解决。

    二、在 Windows 安装程序拷贝完文件，提示进行第一次重启的时候，注意手快点重新进入 BIOS ，打开 “Secure Boot” 选项：

    重启后按 F2 进入 bios 设置，选 BOOT 选项卡，

        找到“Windows 10 Features” 设置为 “Windows 10”

        之后下面的选项“CSM Support”会消失，故其原来设置的 Disabled 或 Enable 没啥用了，同时下面的三个选项也会消失，都不需要了

        之后下面出现的是“Secure Boot”选项，选择 Enable，按 F10 保存退出，主板重启后自动引导硬盘上的 Windows 安装程序进行后续的安装配置工作

        注意：主板 BIOS 的选项 Windows 10 feature 设置为 “win10” 后，原来用 MBR 方式安装的 Win7 或 Win10 就进不了系统了，除非还原为 “other os”。

rufus 4.6 版本 检测到被吊销的 UEFI 引导加载器警告

    https://www.zhihu.com/question/1897546762/answer/82801270588

    老版本的 Windows 10/11 的 bootloader bootmgfw.efi（其实是2023年之前的所有版本）的哈希值，已经被加入UEFI 安全启动的黑名单了，也就是被吊销了（revoked）！因为2023年，一个叫做黑莲花（BlackLotus）的恶意软件，会利用CVE-2022-21894[2]，来攻击安全启动链条，注入恶意的代码。

    可以忽略，新版本的 rufus 只不过是根据最新的dbx，发现 bootloader 有问题，提出警告而已

    后果：有可能这个新作的 USB 安装盘无法 UEFI 启动！当使用者的主板 BIOS 升级到最新包含最新 dbx 的版本后，主板 BIOS 开启了安全启动的情况下，BIOS 会拒绝执行 U 盘中的 bootloader，因为已经被标记为不安全了。

#### 用 Rufus 制作 ghost 启动盘

    https://qastack.cn/superuser/1228136/what-version-of-ms-dos-does-rufus-use-to-make-bootable-usbs

rufus 制作u盘时引导类型选择 “FreeDos” 就行了，完成后把 ghost 拷贝到u盘上。

用该u盘开机引导直接进入 dos 命令行方式，运行命令 ghost 即可。

如果引导类型选择 “grub”，那你得准备 menu.list 文件，引导到对应的 img 文件上。

对 Windows 10 + 来说，不需要用 ghost 启动盘了，推荐直接使用 Windows 自带的 [系统映像备份]。

### 二、主板设置启动模式为原生 UEFI

重启开机后按 F2 进入 BIOS

1、确保“启动模式”、“存储”和 “PCIe 设备” 等都是 UEFI 模式

BOOT 选项卡：

    启动模式选项（Windows 10 Features）要选择 “Windows 10” 而不是 “other os”。

    选项 “CSM Support”， 先选 “Enable”，之后出现的三项，除了网卡启动的那个选项不用管，其它两个关于 “存储” 和 “PCIe 设备” 的选项要确认选的是 “UEFI”。

    然后对选项 “CSM Support”， 再选 “Disable” 关闭 CMS 模式，三个选项消失。

确认

    主板 BIOS 设置界面可以直接加载 UEFI 驱动了（所以现在叫主板 UEFI 设置界面）：在 “Settings” 界面中的 “IO Ports” 选项里，查看对应的 PCIe 设备，比如网卡、nvme硬盘等，能正确显示设备名称，还可以选择查看信息或设置该设备选项。在 “Advanced” 界面 “PCI  Subsystem setting” 下，可以看到你的设备多出了功能菜单，如 Nvidia RTX30 系列显卡设置支持 Resize Bar，三星 ssd 硬盘可以运行自检等。

总结来说，Windows 10 的安装程序兼容各种老设备

    主板 BIOS 设置里 “Windows 10 Features” 选择 “other os”，“CSM Support” 选 “Enable”，存储和 PCIe 设备都选择 “leagcy”，兼容非 UEFI 设备，可以安装 Windows 10，但无法开启 Secure Boot 功能。

    主板 BIOS 设置里 “Windows 10 Features” 选择 “other os”，“CSM Support” 选 “Enable”，存储和 PCIe 设备都选择 “UEFI”，兼容 UEFI 设备，可以安装 Windows 10，但无法开启 Secure Boot 功能。

    主板 BIOS 设置里 “Windows 10 Features” 选择 “Windows 10”，“CSM Support” 选“Enable”，存储和 PCIe 设备都选择 “leagcy”，兼容非 UEFI 设备，可以安装 Windows 10，但无法开启 Secure Boot 功能。

    主板 BIOS 设置里 “Windows 10 Features” 选择 “Windows 10”，“CSM Support” 选 “Disable”，存储和 PCIe 设备都选择 “UEFI”，完全支持 UEFI 设备，可以安装 Windows 10，可以开启 Secure Boot 功能。

UEFI 模式下显卡连接 DP 口刚开机时，显示器会自动使用物理分辨率，出现的主板厂商 logo 画面应该是比较小的原始图片尺寸，没有经过拉伸等分辨率调整。我的 Nvidia 1080 显卡目前只能在 HDMI 口连接时实现这个效果，DP 口连接时主板厂商 logo 画面被自动拉伸了，暂无法确定是否在显示器的物理分辨率下。

2、SATA 硬盘使用“AHCI”模式

    确认下主板 BIOS 的 “settings” 界面中，“SATA And RST configuration” 的选项，硬盘模式为 “AHCI”，这个一般主板都是默认开启的。

3、验证

    Windows 安装完成后，运行 msinfo32，在 “系统摘要” 界面找 “BIOS 模式” 选项，看到结果是 “UEFI”。

### 三、主板开启 Secure Boot 功能

Secure Boot 是 UEIF 设置中的一个子规格，简单的来说就是一个参数设置选项，它的作用是主板 UEFI 启动时只加载经过认证的操作系统或者硬件驱动程序，从而防止恶意软件侵入。

UEFI 安全启动可以绕过，已经有常驻 UEFI 启动区的木马了，所以安全启动名字很吓人，其实意义不大，当年 DOS 时代就有常驻系统启动区的病毒，现在也没啥差别

    https://arstechnica.com/information-technology/2023/03/unkillable-uefi-malware-bypassing-secure-boot-enabled-by-unpatchable-windows-flaw/

    手机安卓系统对安全启动的保护的就比较好，见 [Work Profile 隔离 ---- 三星 knox 安全文件夹](mobile_phone.md)。

    Linux 下参见章节 [Linux 对安全启动的实现](init_a_server think)。

首先要确保实现了上一个章节 [主板 BIOS 设置启动模式为原生 UEFI]。

1、开启 “Secure Boot”

在 BIOS 中，设置 “Secure Boot” 项为 “Enable”。

但这只是开启，并没有激活。

2、回车选择进入 “Secure Boot” 出现新界面，在这里可以看到，“Secure Boot” 为 “Enable”，但是出现 “Not Active” 字样。

如果是 “Not Active”，则需要导入出厂密钥：

    选择 “Secure Boot Mode” 为 “custom”，打开用户模式

    下面的灰色选项 “Key Management”界面可用了，进入后点击 “Restore Factory keys” ，弹出画面选择确认，以安装出厂默认密钥。

    返回上级菜单， 这时的 “Secure Boot” 下面会出现 “Active” 字样

    “Secure Boot Mode” 目前不能改回 “Standard”（虽然在主板 BIOS 底部显示的操作提示是再改回 “Standard”），如果这次不能改就先不做。

    F10 储存并退出重启系统。

3、重启后再次进入BIOS设置

    把 “Secure Boot Mode” 改回 “Standard”，这时 “Secure Boot” 依然是 “Active” 字样，说明密钥都导入成功了。

    F10 储存并退出，再次重启系统。

主板厂商的操作说明

    https://www.asus.com.cn/support/faq/1050047/

参考1

    <https://www.sevecek.com/EnglishPages/Lists/Posts/Post.aspx?ID=105>

    switch the Attempt Secure Boot to Enabled
    switch the Secure Boot Mode to Customized - it enables the Key Management submenu
    go into the Key Management sub menu
    switch the Provision Factory Default keys to Enabled
    go back up
    switch the Secure Boot Mode to Standard
    And you are all done.

参考2

    从华为服务器的一篇说明 <https://support.huawei.com/enterprise/zh/doc/EDOC1000039566/596b9d40>中看到，“Secure Boot Mode”选“custom”后，在“Key Management”界面，设置“Provision Factory Default keys”为 “Enable”，打开出厂默认密钥开关，这个不知道是否必须做，也是导入密钥的操作，

### 四、Windows安装u盘使用 UEFI 模式启动计算机

用第一步制作的 UEFI+GPT 的安装 U 盘开机启动，按快捷键 F8 进入 BIOS 的启动菜单，同一个启动 U 盘有两个选项，注意要选择带有 “UEFI” 字样的那个 U 盘启动。

如果不明确选择使用 UEFI 驱动引导 U 盘启动，有可能导致主板使用 CMS 模式，从而影响 Windows 安装程序的条件判断。

### 五、确保硬盘格式化为 GPT 类型

以上条件作为前提条件，如果都符合，Windows 安装程序才会认为计算机是启动于原生 UEFI 模式，接下来对硬盘的操作才会默认采用 GPT 类型。

如果是新硬盘，或用户选择对整个磁盘重新建立分区：

    前提条件都符合，Windows 安装程序会把硬盘格式化为 GPT 类型，并进行安装，这样能保证安装后的 Windows 启用 Secure Boot 功能。

    只要有前提条件不符，Windows 安装程序就会自动把硬盘格式化为 MBR 类型，并使用 CSM 兼容模式进行引导安装。

如果是已经划分过分区的旧硬盘：

    如果硬盘是 GPT类型，但是其它前提条件不符，或硬盘不是 GPT 类型，且用户选择直接在原有分区上安装 Windows，都会导致 Windows 安装程序自动使用 CSM 兼容模式进行引导安装。

    所以，如果你的硬盘之前安装过的 Windows 是可以启用 Secure Boot 功能的，那它的分区设置是没有问题的，可以不用重新新建分区，选择把老的分区格式化清除即可继续安装 Windows 了。

NOTE：Windows 安装程序选择原生 UEFI 模式还是 CSM 兼容模式安装，都不会做出任何提示。

所以不管新旧硬盘，在 Windows 安装程序到了划分磁盘这一步，都是建议把硬盘分区全删后重新建分区，然后全新安装 Windows，这样可以避免很多不必要的麻烦。

另外：安装完 Windows 后，三星 SSD 硬盘的管理程序 Samsung Magican 里，不要设置 Over Provisioning 功能。原因见章节 [踩坑经历]。

验证1

    Windows 安装完成后，cmd 管理员模式

        diskpart

        >list disk

    查看对应磁盘的 GPT 那一列，是否有星号，有就是确认 GPT 磁盘了

验证2

    Windows 安装完成后，在控制面板进入磁盘管理，在磁盘 0 上点击右键，看看“转换成 GPT 磁盘”是可用的而不是灰色的不可用？如果是，那么说明当前磁盘的分区格式不是 GPT 类型，大概率是 MBR 类型。真正的 GPT 磁盘，只提供“转换成 MBR 磁盘”选项。注意，那个 “转换成动态磁盘” 不要理它，微软都废弃了。

参考 <https://www.163.com/dy/article/FTJ5LN090531NEQA.html>

### 验证

Windows 安装完成后，运行 msinfo32，在 “系统摘要” 界面找 “安全启动” 选项，看到结果是 “开启”。

### 踩坑经历

为什么要 CSM 模式又开又关这样操作呢？我安装 Windows 10 的时候踩了个坑：

因为我的老显卡不支持在 UEFI 下连接 DP 口开机显示内容，初次安装用了 HDMI 线，而且为了兼容使用了 CSM 模式安装的 Windows：BIOS 设置里 “Windows 10 Features” 选择 “other os”，“CSM Support” 选 “Enable”，存储和 PCIe 设备都选择 “UEFI” ，然后安装了 Windows 10。见章节 [老显卡不支持 DP 口开机显示（Nvidia Geforce 1080 系）]。

后来显卡升级了 BIOS，又关闭主板 CMS 模式，重新安装了 Windows 10 21H1，在主板 BIOS 设置里装载默认值 “Load optimized defaults”（默认把存储设备换回了 legacy），然后设置 “Windows 10 Features” 选择 “Windows 10”，“CSM Support” 选 “Disable”，但没有提前把存储设备换回 UEFI 类型。该存储设备的选项在关闭 CMS 模式时屏蔽显示，没有自动改回为 UEFI 类型，而用户又看不到了。。。这就导致后续运行的 Windows 安装程序自动把硬盘格式化为 MBR 类型。

这样装完 Windows 开机启动后，主板尝试 UEFI 没有引导成功，自动转为 CSM 模式走 bios+UEFI，表现为开机时最初的黑屏时间较长，等待很久以为不能启动了，才出现 Windows 开机画面登录桌面，这样安装的 Windows 是无法开启 Secure Boot 功能的。

后来升级了显卡 BIOS ，可以支持主板 UEFI 下的 DP 口显示后，我重装了 Windows，在主板 BIOS 设置中启动模式选项 “Windows 10 Features” 选择 “Windows 10”，“CSM Support” 选项 “Disable” 后下面的三个选项自动隐藏了，我以为都是自动 UEFI 了，其实技嘉主板只是把选项隐藏了，硬盘模式保持了上次安装 Windows 时设置的 legacy 不是 UEFI……

这样导致我的 Windows 引导还是走的老模式，UEFI 引导硬盘其实没用上，装完后 Windows 启动没有实现秒进桌面才发现的这个问题。

另外，安装成功后我手贱，三星 SSD 硬盘的管理程序 Samsung Magican 里，设置 Over Provisioning 功能，重新调整了硬盘分区，结果 Secure Boot 又没了。。。

## 装完 Windows 后的一些设置

不要把你使用的计算机的账户，跟微软账户绑定，也不要跟你的微软邮箱绑定，或者什么手机认证，2FA认证啥的。这些账户之间不要建立联系。在 cn 无所谓，在法律很严的国家，这是关联使用证据，认定标准不同，违法后果不同。

基本设置

    如果是在 VirtualBox、Vmware 类的虚拟机里安装的 Windows，先选择安装 “增强包”，这样桌面的鼠标反应会顺畅。

    激活

    做一次 Windows 更新，有一大堆的包要装，装完了再改设置吧，不然会给改回去。。。

    把电源计划调整为 “卓越性能”或“高性能”，省的它各种乱省电，系统反应不正常的时候你根本猜不出啥原因导致的。

    关闭 Windows 搜索，这玩意非常没用，但是总是在闲时扫描硬盘，太浪费硬盘和电了。

    设置：设备->自动播放->关闭自动运行。但是双击还是会执行自动播放指向的程序！

        https://learn.microsoft.com/zh-cn/windows/win32/shell/autoplay-reg

        https://zhuanlan.zhihu.com/p/352538274

        打开 注册表,随后进入 "计算机\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer "主键下，双击 “NoDriveTypeAutoRun”，修改其值为十进制的 221

    设置：系统->多任务处理，按 ALT+TAB 将显示 “仅打开的窗口”，不然开了一堆 edge 窗口都给你切换上，太乱了。

    设置：个性化->任务栏，合并任务栏按钮，选择 “任务栏已满时”，不然多开窗口非常不方便在任务栏上选择切换。

    设置：轻松使用->键盘，那些 “粘滞键”、“切换键” 啥的热键统统关掉，特别是连按五次 shift，打 fps 游戏时给你个弹窗。。。

    设置：隐私策略各种关闭，有空的时候挨个琢磨吧。这个是针对 app 商店里的应用，属于 Windows 容器化管理应用商店的权限控制，控制不到普通的 Windows 应用程序。关闭这些隐私设置不会影响桌面应用程序。例如，自行下载安装的驱动程序的应用可以直接与摄像头或麦克风硬件交互，从而绕过 Windows 的访问控制功能。要更全面地保护个人数据，应该想办法禁用这些设备，例如物理断开或禁用摄像头或麦克风。<https://support.microsoft.com/en-us/windows/windows-desktop-apps-and-privacy-8b3b13bc-d8ff-5460-8423-7d5d5c1f6665>

打开 Windows store，菜单选择 “Settings”，把 “App updates” 的 “Update apps automatically” 选项抓紧关闭了，太烦人了！

Windows 商店应用默认不提供卸载选项，解决办法见章节 [删除无关占用 cpu 时间的项目]。

如果有程序开机就启动挺烦人的，运行 “msconfig.exe”，在启动选项卡进行筛选

命令行查看各功能是否开启:

    dism /online /get-features

更多的定制化见 tenforums 的各种教程

    https://www.tenforums.com/tutorials/id-Customization/

### 关闭 Windows 11 “召回Recall” 功能

最新版本的 Windows 11 系统中，微软默认启用了备受争议的 “召回Recall” 功能。这一功能通过定期截取用户屏幕并进行分析，旨在帮助用户快速检索过去操作的信息。

从 2021 年开始我就换到 Linux 了，实在是受不了微软往操作系统里乱塞东西，什么绑定账户就够恶心的了，现在弄了个实时记录你的屏幕，唉

### 选择开启虚拟化功能

开启虚拟化功能的重要性：

    日常的使用习惯，应该**[在虚拟机里使用你的日常软件]** 。

    只要不涉及章节 [开启 hyper-v 的负面影响]，强烈建议开启虚拟化功能。

    Windows 系统安全在向虚拟化方面加强，所以本章跟下面的 [设置Windows安全中心] 并列。

1、计算机主板开启虚拟化功能

如果主板 BIOS 设置中关于 Intel CPU 虚拟化选项如 vt-d、hyper-threading 的设置没有打开，则可能有些依赖虚拟机的隔离浏览的选项不可用，需要去主板 BIOS 设置中打开。

2、操作系统开启虚拟化功能，需要单独安装

Windows 10：Windows 设置->应用->应用和功能，点击右上角的“程序和功能”，在弹出窗口选择 “启用或关闭 Windows 功能”，在列表勾选如下组件确定即可安装。

Windows 11：Windows 设置—系统—可选功能，页面下面 “更多windows功能”，点击即弹出窗口“启用或关闭 Windows 功能”，在列表勾选如下组件确定即可安装。

选择安装如下组件：

    Hyper-V (Windows Hypervisor) --- 微软的 Hyper-V 虚拟机及其管理工具

    Windows 虚拟机监控程序平台 (Windows Hypervisor Platform) --- 给 virtualBox 等第三方虚拟机软件提供服务

    虚拟机平台 (Virtual Machine Platform) --- 给 wsl2 虚拟机提供服务

    适用于 Linux 的 Windows 子系统（这个是 WSL 1 安装 Linux 用的，不是安全必备，顺手装上吧）

为何这么多组件，参见章节 [Hyper-V] 中关于 Windows 10+ 体系架构基于虚拟化的部分。

关于这几个功能的解释

    https://superuser.com/questions/1510172/hyper-v-vs-virtual-machine-platform-vs-Windows-hypervisor-platform-settings-in-p

    https://zhuanlan.zhihu.com/p/381969738

    https://superuser.com/questions/1556521/virtual-machine-platform-in-win-10-2004-is-hyper-v

Hyper-V: is Microsoft's Hypervisor.

Windows Hypervisor Platform - "Enables virtualization software to run on the Windows hypervisor" and at one time was required for Docker on Windows. The Hypervisor platform is an API that third-party developers can use in order to use Hyper-V. Oracle VirtualBox, Docker, and QEMU are examples of these projects. 微软向第三方虚拟机软件开放的虚拟机平台，使得 VirtualBox 等虚拟机软件也可以安装在开启了 hyper-v 的计算机上（之前 hyper-v 独占模式，别人无法安装）。

Virtual Machine Platform - "Enables platform support for virtual machines" and is required for WSL2. Virtual Machine Platform can be used to create MSIX Application packages for an App-V or MSI. 给 WSL2 使用的虚拟机平台，跟 Windows 融合密切，使得在 Windows 下可以无缝执行 Linux 程序。

### 设置 Windows 安全中心

关闭扫描局域网文件，不然啊，局域网内别的电脑硬盘狂响，原因是你。。。

开始->运行：msinfo32，在“系统摘要”页面，查看状态是“关闭”的那些安全相关选项，逐个解决。

Windows 10 默认没有安装的某些增强性安全功能组件是依赖虚拟化的，需要先手动安装虚拟化功能，见章节[选择开启虚拟化功能]。

+ 手动安装单独的安全组件：

    设置->应用->应用和功能->可选功能，点击右侧的“更多 Windows 功能”，弹出窗口选择“启用和关闭 Windows 功能”：

        Microsoft Defender 应用程序防护

        Windows 沙盒(Windows Sandbox)

+ 设置 Windows安全中心

  设置->更新和安全->Windows 安全中心，左侧页面点击 “打开 Windows 安全中心”

    ->应用和浏览器控制，打开 “隔离浏览（WDAG）”

        https://docs.microsoft.com/zh-cn/Windows/security/threat-protection/microsoft-defender-application-guard/install-md-app-guard

    ->设备安全性->内核隔离，手动开启“内存完整性”

        https://support.microsoft.com/zh-cn/Windows/afa11526-de57-b1c5-599f-3a4c6a61c5e2

        https://go.microsoft.com/fwlink/?linkid=866348

    在“设备安全性”屏幕的底部，如果显示“你的设备满足增强型硬件安全性要求”，那就是基本都打开了。

    “内核隔离” ->“内核 DMA 保护”、“固件保护”等选项，内核 DMA 是为了应对 PCIE 设备现在可以热插拔（如雷电thunderbolt接口）导致的黑客可以插入u盘入侵操作系统的问题

        https://learn.microsoft.com/zh-cn/windows/security/information-protection/kernel-dma-protection-for-thunderbolt

        https://docs.microsoft.com/zh-cn/Windows-hardware/design/device-experiences/oem-kernel-dma-protection

    如果想显示“你的设备超出增强的硬件安全性要求”，需要在下面的页面慢慢研究如何开启。

        https://docs.microsoft.com/zh-cn/Windows/security/information-protection/kernel-dma-protection-for-thunderbolt

        https://docs.microsoft.com/zh-cn/Windows/security/threat-protection/Windows-defender-system-guard/system-guard-secure-launch-and-smm-protection

验证：

启动 Windows 后以管理员权限运行 msinfo32，在“系统摘要”界面查看

    “内核 DMA 保护”  --  “启用”

    “基于虚拟化的安全 xxx”等选项，有详细描述信息

更多关于 Windows10 安全性要求的选项参见各个子目录章节

    https://docs.microsoft.com/zh-cn/Windows-hardware/design/device-experiences/oem-highly-secure#what-makes-a-secured-core-pc

基于虚拟化的安全 Virtualization Based Security(VBS) 详细介绍

    https://docs.microsoft.com/zh-cn/Windows-hardware/design/device-experiences/oem-vbs

整个 Windows 安全体系，挨个看吧

    https://docs.microsoft.com/zh-cn/Windows/security/

### 默认键盘设置为英文

中文版 Windows 10 默认唯一键盘是中文，而且中文键盘的默认输入法是微软拼音的中文状态。原 Windows 7、XP 的 “Ctrl+空格” 切换中英文的热键，被微软拼音输入法占用为切换中英文，按 shift 键也是切换中英文，而且默认各个应用的窗口统一使用这个状态。

问题是

    桌面/资源管理器/炒股/游戏/网页浏览器 等软件的默认热键是响应英文的键盘输入，所以仅对文本编辑软件启用中文输入才是最优方案。在实际使用中，各个软件只要切换窗口，或者输入个字母就弹出中文候选字对话框，按 shift 键就来回切换中英文，实际输入的过程中，非常非常非常的繁琐。在使用 Windows 资源管理器时，无法用按键快速导航到指定开头字母的文件；在打 fps 游戏的时候，一按 shift 就切出来中文输入法，再按 asdw 就变成打字到中文输入法的输入栏了。

所以需要再添加一个“英文键盘”，使用它的英文输入法状态，并把这个键盘作为默认状态。两种键盘间切换使用热键“Win+空格”。这样做的好处是，切换键盘的同时中英文输入法也跟着切换了（不需要依赖在中文键盘下微软拼音输入法的 shift 键切换），而且有了多种输入法，不同的窗口还可以选择记住不同的输入法状态，非常方便。

设置->搜索“语言”，“首选语言”

    选择添加 "英语(美国)"，注意取消选择 “设置为默认的界面语言”，语言包的选项中，选择添加 “美式键盘”，下载语言包什么的。

    如果是英文版 Windows， 选择添加语言包 “简体中文（新加坡）”。然后选择该语言包，点击按钮“选项”，在弹出窗口中选中 “键盘” 下面的 “微软拼音输入法”，设置 “选项”：候选字词限制最多 5 个，开启用逗号和句号翻页。

设置->设备->输入（右侧按钮“拼写、键入和键盘设置”），做如下设置：

    把输入提示、输入建议什么的都去掉，不然你按 “Ctrl+空格” 的时候会给你好看。

点击下面的“高级键盘设置”（可在设置中搜索“keyboard”，选择“高级键盘设置”）：

    “替换默认输入法” 选择 “英语”（美式键盘），这样对 Windows 桌面/资源管理器/炒股/游戏等软件的默认状态是英文按键的正确状态。

    勾选 “允许我为每个应用窗口使用不同的输入法”，这个非常重要，可以实现你打开不同的软件，保持你切换到的不同输入法状态，不会出现你切换编辑软件到中文输入法，你的资源管理器、linux终端软件的输入法也跟着变中文了。

    注意这两种键盘的切换热键是 “Win+空格”，以后中英文输入的切换就切换键盘就行了，也可在中文输入状态下按一下 shift 键切换到英文输入。所以最好一种键盘只保留一个输入法，这样切换最方便。

    取消勾选“使用桌面语言栏”，这个也很重要，某些全屏 HDR 游戏不兼容这个工具栏，一旦出来输入法条，显示器的 HDR 状态就跟着来回黑屏切换……

点击下面的 “语言栏选项”：

    在 “语言栏” 页面，勾选 “在任务栏中显示其他语言栏图标”，方便鼠标点选切换中英文键盘。

    切换到 “高级键设置” 页面，在 “输入语言的热键” 列表，选择 “输入法/非输入法切换  Ctrl+空格”，点击 “更改按键顺序”，在弹出窗口中取消勾选 “启用按键顺序”。禁用此热键是因为切换功能已经有 “win+空格” 这个热键了，而且主流中文输入法都用 shift 键切换到英文输入。现在很多文字编辑软件包括 Windows 10 默认都用 “Ctrl+空格” 作为输入提示的热键，从 Windows 2000 年代的过来的这个热键习惯要该改。

重启计算机，进入桌面后应该默认就是英文输入法了，按 “Win + 空格”切换两种输入法，误触机会基本没有了！

> 如果是英文 Windows

除了上述措施之外，还有几个小坑要填：

设置了区域是新加坡等非中国区域，在安装传统的简体中文 Windows（gbk 编码） 程序时出现乱码提示，无法进入程序

    设置->区域，点击页面右侧的 “其他日期、时间和区域设置”，这时会跳转到传统的控制面板的 “时钟和区域” 窗口

    点击 “设置：更改日期、时间或数字格式”，弹出新窗口

    点击 “管理” 页面，对 “非 Unicode 程序的语言” 栏目，点击 “更改系统区域设置”，把默认的 “英语（美国）” 改为 “中文（中国）”

    重启计算机，重新尝试安装那些程序即可。

Edge 浏览器的英文网页默认不出现 “翻译” 选项

    在 Edge 的菜单选择 “设置”，新开页面中选择 “语言”，添加中文，并点击按钮 “...”（更多操作）勾选 “让我选择使用此语言翻译页面”，并选择上移到顶部，以便优先级高于默认的英文。

VS Code 安装了中文语言包，但是界面仍然是默认的英文

    F1 -> Configure display language 选择中文即可。

### 切换黑暗模式（夜间模式）

次选：设置->系统->显示：选择打开“夜间模式”，Windows 只是把色温降成黄色，显示器亮度还是很晃眼。

优选：设置->轻松使用->颜色滤镜：选择“打开颜色滤镜”，选择“灰度”按钮，显示器变成黑白效果，失去了彩色，也不舒服。

最优选：设置->个性化->颜色：下面有个“更多选项”，对“选择默认应用模式”选择“暗”，整个 Windows 的主题配色方案都变成了暗色，各个软件窗口也跟着变了。这个办法最舒服，白天切换到“亮”也很方便。写到注册表里，在桌面点击右键实现方便切换，见下面

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

edge 浏览器->设置->外观->整体外观：选择 “系统默认” 则跟随 Windows 系统的主题颜色变换，缺点是仅窗口标签外观变换。如果需要对网页内容开启夜间模式，需要强制开启：

    在浏览器地址栏输入 edge://flags/

    在搜索栏输入“Force Dark Mode for Web Contents”

    选择 enable，点击选择重启浏览器，除图片以外的所有部分进入夜间模式

### 右键菜单 “发送到”

右键点击系统桌面左下角的【开始】，在开始菜单中点击【运行】，在运行对话框中输入：

    shell:sendto

点击确定或者回车，打开SendTo（发送到）窗口 C:\Users\your_user_name\AppData\Roaming\Microsoft\Windows\SendTo

把 notepad 等记事本工具的快捷方式放在这里，方便查看各种格式的文本文件。

上一级目录还可以配置 “启动”，可以把自己希望开机自动启动的程序的快捷方式放到这里。

### 关闭附件管理器检查

为什么要关闭？

我通过浏览器正常下载的没签名的文件，在有些软件调用的时候就打不开，也没有任何提示，总是报错，让人抓狂。
之前遇到过技嘉制作u盘启动的工具，添加了下载的 zip 文件，总是制作失败，直到把下载的文件点击右键，选择属性，勾选解除限制，才能正常读取。整个过程中没有任何提示性信息。其它还有 zip 解压文件，读取 zip 压缩包，悄悄的失败，也没有任何提示，从 Windows 7 到 Windows 11，一直如此。

有两种方法： 第一种是修改组策略中的配置：

“运行”中输入 gpedit.msc，然后选择“用户配置”-“管理模板”-“Windows 组件”-“附件管理器”。

    1. 文件附件值中不保留区域信息，设置为“启用” （光这步就够了）

    2. 文件类型的默认风险级别，设置为“启用”，“低风险”。

    3. 低风险文件类型的包含列表，设置为“启用”，扩展名增加比如：.docx;.doc;.xls;.xlsx

第二种是增加一个全局的环境变量 SEE_MASK_NOZONECHECKS，设置值为 1.

    [HKEY_CURRENT_USER \Environment]
    SEE_MASK_NOZONECHECKS = "1"

### 删除无关占用 cpu 时间的项目

有了 Windows Store 后，商店应用由单独的 wsappx.exe 运行的 UWP 运行环境，甚至 appx 的保存目录 C:\Program Files\WindowsApps 都是默认锁定的。

单纯用 msinfo32 或传统的启动管理程序，只能看到本地 Windows 的程序，由 wsappx.exe 运行的那些商店应用是没法单独看到的，目前只能由 Windows 提供的开放接口查看和设置

目前用： 设置->应用->启动，看列出的项目，取消勾选可以禁止开机启动

在任务管理器中，有个应用历史记录，可以发现，比如 Windows photo 这样的 Windows 商店的 appx 应用占用 cpu 时间非常多，其实用户根本没用，真不知道它在后台干了些什么。不要犹豫，用不到的就删除啊。win+xn 设置->应用->应用和功能，搜索应用名称，找到后点击，展开菜单选择“卸载”即可。

如果没有“卸载”选项，就得手工解决了，以删除 cpu 时间使用最多的 Windows photo 为例：

    以管理员身份运行“Windows PowerShell”

    在控制台输入命令“Get-AppxPackage”回车键

    菜单项选择：编辑->查找，输入“photo”，按“查找下一个”按钮就能找到了

    找对应“PackageFullName”，包的名称。把后面的名称“Microsoft.Windows.Photos_2021.21090.10008.0_x64__8wekyb3d8bbwe”复制下来。

    在控制台输入命令“Remove-AppxPackage Microsoft.Windows.Photos_2021.21090.10008.0_x64__8wekyb3d8bbwe”回车键，等待片刻就卸载完了。

### 打开任务栏毛玻璃效果

2022年版的 Windows 10 已经默认打开了。

    https://bbs.pcbeta.com/viewthread-1899753-1-1.html

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

重启 explorer.exe

### 关闭 Windows 自带的压缩文件夹（zip folder）

Windows 10 下发现取消这个组件，居然有 Windows 更新的安装包报错的情况，建议用开源的 7-zip 软件替换 zip 文件的打开方式，不要取消Windows的zip组件。

    管理员身份运行 7-zip 软件，菜单“工具”->“选项”，弹出的窗口选择“系统”选项卡，列出的类型中，zip 选择“7-zip”

### 开启网络邻居

如果你的计算机连接的是家庭网络或办公网络，则Windows 10的默认网络类型需要更改，不然无法在网络邻居中被别的计算机发现。

在Windows10、Windows11与windows7、xp、2000共享文件中，设置网络邻居

在资源管理器地址栏通过【双左斜杠+ip】即可进行快速访问。如共享文件的旧电脑ip为【192.168.1.100】，在新电脑上资源管理器地址栏输入【\\192.168.1.100\c$】

防火墙【公网】场景导致的无法ping通或网络邻居看不到：“网络和Internet设置-属性-网络配置文件”将网络场景改为【专用】

网络和共享中心\高级共享设置：将“专用”场景的“文件和打印共享”、“网络发现”选项都开启。

### 取消输入用户登录密码

不登录微软账户，只使用本地账户更方便。

最方便的是使用 Windows 操作系统的计算机管理中的用户管理：

    运行 Compmgmt.msc，选择 计算机管理（本地）-> 系统工具 -> 本地用户和组 -> 用户

    在你想要管理的用户名点击右键，选择“设置密码”，连续两次输入空密码即可实现免密码登录；选择“属性”，勾选“密码永不过期”

使用微软官方工具 sysinternals 的 autologon 工具帮你记住用户名和密码

    https://learn.microsoft.com/zh-cn/sysinternals/downloads/autologon

其它方法：

    运行“netplwiz.exe”，选择要管理的用户，点击按钮重置密码，连续两次输入空密码即可实现免密码登录

以上修改都是重启计算机生效。

### 关闭 Windows defender杀毒软件

[各种方法失效]，只能暂时停用，过后 Windows 会自动拉起来。

所以，打开某些目录之前，手动停用下，抓紧操作，赶快退出。另外不要开放扫描网络设备的目录，不然会巨慢。

### 系统信息中，“设备加密支持”选项的结果有“失败”字样

以管理员权限运行 msinfo32，在“系统摘要”界面查看，根据具体描述进行调整

#### 不允许使用的DMA设备

参见 <https://docs.microsoft.com/zh-cn/Windows-hardware/design/device-experiences/oem-bitlocker#un-allowed-dma-capable-busdevices-detected>

#### 设备不是 InstantGo

待机(S0 低电量待机)功能比较新，截至2022年仅部分笔记本电脑实现该功能了，而且功能不稳定，耗电情况不如之前的睡眠模式好。

S0 新式待机（Modern Standby），可实现类似手机锁屏后的秒开机。在最初，它叫做 Instant-on，Windows 8上市的时候叫做 Connected Standby，后改名叫做 InstantGo，在 Windows 10 为了包容性，改名 Modern Standby（现代待机），包含 Connected Standby 和 Disconnected Standby 两种模式。<https://docs.microsoft.com/en-us/Windows-hardware/design/device-experiences/modern-standby-vs-s3>

    C:\Windows\system32>powercfg -a
    此系统上有以下睡眠状态:
        待机 (S3)
        休眠
        快速启动

    此系统上没有以下睡眠状态:
        待机 (S1)
            系统固件不支持此待机状态。

        待机 (S2)
            系统固件不支持此待机状态。

        待机(S0 低电量待机)
            系统固件不支持此待机状态。

        混合睡眠
            虚拟机监控程序不支持此待机状态。

为防止待机时有黑客手工把硬件接入计算机（Windows 支持雷电等设备热插拔加载驱动）跨越操作系统操作权限读取硬件信息，connected standby 这个功能需要 TPM2.0 的支持，并进行一系列的加密防护，所以，待机跟系统安全身份认证功能也关联上了。

如果在 “Windows 安全中心”->“设备安全性”->“内核隔离” 里启用了内核保护的内存完整性，则它的虚拟机程序会禁用混合睡眠，因为内存隔离区不允许复制，参见 <https://forums.tomshardware.com/threads/hybrid-sleep-and-Windows-10-hypervisor.3699339/>。

这个提问者 <https://support.microsoft.com/en-us/topic/connected-standby-is-not-available-when-the-hyper-v-role-is-enabled-4af35556-6065-35aa-ed01-f8aef90f2027> 直接关闭了虚拟机，其实是通过关闭内存完整性保护实现了混合睡眠，意义不大。相关的类似有
使用 WSL2 的虚拟化开启后，Windows10 无法睡眠，合盖后自动睡眠但无法唤醒系统，只能通过电源键强制重启来重启系统等。

ACPI(Advanced Configuration and Power Interface)在运行中有以下几种模式：

    S0 新式待机（Modern Standby），可实现类似手机锁屏后的秒开机。
    S1 CPU停止工作。唤醒时间：0秒。
    S2 CPU关闭。唤醒时间：0.1秒。
    S3 除了内存外的部件都停止工作。唤醒时间：0.5秒。
    S4 内存信息写入硬盘，所有部件停止工作。唤醒时间：30秒。（休眠状态）
    S5 关闭。

#### 未配置 WinRe

如果电脑配置了恢复环境，在"Windows RE位置"后面我们是可以看到WinRE映像存放的位置。
关于WinRe的详细解释见下面章节[Windows RE]

    C:\Windows\system32>reagentc /info
    Windows 恢复环境(Windows RE)和系统初始化配置
    信息:

        Windows RE 状态:           Enabled      // 不能为 Disabled
        Windows RE 位置:           \\?\GLOBALROOT\device\harddisk0\partition4\Recovery\WindowsRE
        引导配置数据(BCD)标识符:   64511af6-4dd0-11ec-9f84-d4c2febe2930
        恢复映像位置:
        恢复映像索引:              0
        自定义映像位置:
        自定义映像索引:            0

    REAGENTC.EXE: 操作成功。

情况1：对于已配置恢复环境但未能正常加载这一问题，一般只需要先将其禁用然后再重新启用即可解决。

依次运行以下两条命令

    reagentc /disable
    reagentc /enable

再次运行 reagentc /info，确认 Windows RE 状态:Enabled Windows RE 位置:为所选择的目录

    C:\Windows\system32>reagentc /info
    Windows 恢复环境(Windows RE)和系统初始化配置
    信息:

        Windows RE 状态:           Enabled
        Windows RE 位置:           \\?\GLOBALROOT\device\harddisk0\partition4\Recovery\WindowsRE
        引导配置数据(BCD)标识符:   64511af8-4dd0-11ec-9f84-d4c2febe2930
        恢复映像位置:
        恢复映像索引:              0
        自定义映像位置:
        自定义映像索引:            0

    REAGENTC.EXE: 操作成功。

情况2：如果Windows RE 位置处提示为空白，则需要从微软原版ISO镜像中恢复WinRE.wim映像

    用7z工具解压微软原版ISO镜像文件，进入sources目录
    用7z工具打开install.wim文件，找Windows/system32/recovery/WinRE.wim，
    选中winre.wim文件，点击上方的“解压到” 将路径更改为 C:\Recovery\WindowsRE

打开“命令提示符（管理员）”，输入下面的命令回车运行即可：

    reagentc /setreimage /path C:\Recovery\WindowsRE

设置成功后，还需将其开启

    reagentc /enable

最后，开始菜单的电源按钮，按住Shift键点击重启

#### 开启或关闭“快速启动”

“快速启动” 跟上面的两个条目讨论的 InstantGo 和 WinRe 有依赖关系，所以不单独开章节。

如果无法接受以下缺陷，建议关闭快速启动

    BIOS 里设置定时自动开机失效

    跟很多 usb 设备不兼容，关机再启动以后出现 usb 设备不可用，需要重新插拔。比如我的无线网卡、我的显示器集成的 usb-hub 连接的鼠标键盘网卡显示器等等，开机后偶发无响应需要重新插拔……

    快速启动意味着你上次的关机并不是完全关机，所以笔记本电脑用户会发现关机的电脑没几天电池就没电了。该技术的早期还出现过笔记本电脑在关机状态下发热，其实在干活呢。。。；有些人的电脑开机后需要重启一次才能恢复正常。

    影响与 Linux 系统的双引导：<https://www.debian.org/releases/stable/amd64/ch03s06.zh-cn.html#disable-fast-boot>

    这些都是因为上一次关机并不是真正的关机，而重启时反而会执行真正的硬件清零（也不保险，快速启动打开到 Ultra 档时重启操作相当于注销 Windows，秒登录）。解决办法是按 shift 键点关机或重启键，这样才会执行硬件清零的操作。

验证当前是否处于快速启动状态：

    打开任务管理器，查看[性能]选项卡，“正常运行时间” 中显示的是你上次重启后到现在的运行时间。如果你关机时快速启动功能是打开的，这个时间就不会清零。

    在[启动]选项卡里的“上次bios所用时间”，也会不一样，快速启动功能开启后会该时间会减小。

“快速启动”是 Windows 关机后操作系统暂存挂起功能，类似休眠+睡眠，而且他跟主板 BIOS 设置中的 UEFI Fast Boot 功能关联，二者互相起作用，实现关机后的再次开机非常快，该技术还在持续演进变化。

开机硬件加载阶段

    原生 UEFI 引导会直接跳过硬件检测，过程如下：引导→UEFI 初始化→加载系统→进入系统。传统的 BIOS 在加载系统之前需要进行一系列的硬件检查。

“UEFI + GPT” 模式结合 “快速启动（Fast Boot）” 功能打开后，关机之后的开机，都是直接厂商 logo 转一圈就直接进系统的，不会再有主板自检启动画面和 Windows 启动的画面。

即使是 CSM 模式，也能开机秒进桌面，只要 BIOS 中设置开启 Fast Boot，而 Windows 默认开启了 FAST BOOT，二者配合，即使没有原生 UEFI 模式下跳过 UEFE 开机加载的零点几秒，也有睡眠恢复操作系统节约的好几秒，从而使用户感觉开机非常快。

操作系统快速恢复之前现场

    快速启动设计初衷是，「如果用户关机只是想要电脑回到初始化状态，为什么我们不将这种状态存储到「休眠文件」中，以实现更快的开机速度呢？」

    引入原来的“休眠”功能，先结束掉所有用户进程（比如你开的word，浏览器之类的），内存里保留内核及系统相关的模块，还有一部分驱动。然后把它们写到硬盘里的一个文件里，这样下次开机直接把它们加载进内存。

    为了秒开，又引入原来的“睡眠”功能，在操作系统把内存里的内核部分写入休眠文件后，计算机进入「混合睡眠」模式，其实是低功耗待机状态。

如果要添加或更换硬件

    因为 BIOS 和 Windows 会综合判断这次开机是否可以启用上次的快速启动文件和系统状态，但是无法保证不会出现判断失误。所以在更换硬件之前，关机后务必关闭电源，笔记本要拔掉电池，或者重启一次再关机。以防止没有真正关机，开机后操作系统因为不兼容这个硬件的状态判断错了，导致开机之后的 Windows 不稳定或不识别你的新硬件。

晕了没？

如果启用了快速启动，你真正需要重启计算机的时候，操作不能是关机，需要热键，具体说明如下：

    点关机按钮，执行的是休眠+睡眠，下次开机会秒开。

    点重启按钮，执行的是注销并登陆 Windows，会秒重启完。通过这种重启你无法按 F8 进入「恢复模式」。

    按住 Shift 点关机按钮，此次关机后的再次开机将不使用快速启动。

    按住 Shift 点重启按钮，会让电脑重启进入「恢复模式」的 WinRe。

或者使用命令行关机

    shutdown /r     完全关闭并重启计算机。
    shutdown /r /o  完全关闭转到 WinRe 高级启动选项菜单并重新启动计算机。

关闭 “快速启动”

    打开 设置-系统-电源和睡眠-其他电源设置（或右击开始菜单 (win+x)，选择“电源选项”，弹出窗口的右侧选择“其它电源设置”），

    点击 “选择电源按钮的功能”，选择 “更改当前不可用的设置”，

    去掉勾选 “启用快速启动（推荐）”，然后点击保存修改。

    主板 BIOS 中的 FAST BOOT 选项也要关闭。

## 常用软件工具

hwinfo 最好的系统传感器监控软件，没有之一，支持全球计算机传感器，比主板自带的监控软件可用性大多了

    https://www.hwinfo.com/

问题步骤记录器

    快捷键【Win+R】调出运行窗口，在运行窗口内输入【psr.exe】命令，输入完成之后句点击下方的【确定】按钮。

    弹出问题步骤记录器后，点击【开始记录】就可以记录桌面上所有的操作，点击【停止记录】就会自动弹出保存文件的窗口。（这个录制的方法只能录制画面，不能录制声音，而且它是以HTML的格式保存的，会抓取你的每一步操作并添加说明。）

    PPT也自带录屏功能，打开PPT，点击菜单栏上的【插入】-【媒体】，然后点击里面的【屏幕录制】功能。

    接着就会弹出录制窗口，记住要先点击【音频】这样才会录制声音，然后点击【选择区域】选择你需要录制的区域，之后就可以点击【开始录制了】，录制完成之后，按下快捷键【Win+shift+Q】就会将录制的视频放到PPT中，你可以将视频PPT中的视频单独另存为到桌面上哦！

按键显示

    方便录制说明视频时，屏幕上显示按键的顺序
    https://github.com/Code52/carnac

剪贴板历史查看

    快捷键【Win+v】调出

屏幕录制

    快捷键【Win+g】调出，属于xbox游戏工具栏，可以录制游戏中的视频。

    QQ里面也有一个录屏功能，不过要在QQ运行状态下才能使用，按下快捷键【Ctrl+Alt+S】弹出鼠标箭头和网格线后，框选要录屏的区域，然后点击右上角的【开始录制】就可以了。

屏幕录制、直播推流

    https://obsproject.com/

媒体播放器

    vlc player
        https://www.videolan.org/vlc/index.zh_CN.html
            https://github.com/videolan/vlc

    media player classic BE

        https://sourceforge.net/projects/mpcbe/
            https://apps.microsoft.com/store/detail/mpcbe/9PD88QB3BGKN?hl=en-us&gl=us

        HC 不再更新2017 https://mpc-hc.org/
            https://github.com/mpc-hc/mpc-hc

        搭配 madVR
            http://www.madvr.com/

    mpv player
        https://mpv.io/installation/
            https://github.com/mpv-player/mpv/
            https://sourceforge.net/projects/mpv-player-windows/files/

    MPlayer 原生 linux 下的播放器
        http://www.mplayerhq.hu/design7/dload.html

        Windows build
            https://oss.netfarm.it/mplayer/
            GUI外壳 https://www.smplayer.info/
                    https://github.com/smplayer-dev/smplayer

图片查看器

    IrfanView
        https://www.irfanview.com/

    ImageGlass
        https://github.com/d2phap/ImageGlass

    XnView
        https://www.xnview.com/

Windows 驱动存储查看

    https://github.com/lostindark/DriverStoreExplorer
        https://learn.microsoft.com/zh-cn/windows-hardware/drivers/install/driver-store

开发人员随手工具，数值转换、颜色、格式整理等

    https://github.com/veler/DevToys

Microsoft 出品的工具包

    sysinternals https://learn.microsoft.com/en-us/sysinternals/

        Autologon       自动登录

        Autorunsc       列出所有的开机自启动

        ProcessExplorer 更强大的任务管理器

        PsTools 套件     在命令行控制你的进程

        sysmon          监视系统活动记录

    powertoys https://learn.microsoft.com/en-us/windows/powertoys/

把任意程序配置为开机自启动的服务

    WinSW https://github.com/winsw/winsw
        配置文件说明 https://github.com/winsw/winsw/blob/v3/docs/xml-config-file.md
        配置文件样例 https://github.com/winsw/winsw/tree/v3/samples

    竞品 nssm https://nssm.cc/download

在线流程图

    https://app.diagrams.net/

在线ps

    https://pixlr.com/cn/
    https://www.photopea.com/

人工智能的涌现

    https://github.com/chrxh/alien

### 安装 Microsoft Edge 浏览器插件

注意设置右键插件图标，选择扩展在哪些网站生效，尽量缩小插件的生效范围。

    尽量设置 “读取和更改站点数据” 配置为 “单击扩展时”

uBlock Origin 广告屏蔽

    https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak

    edge 兼容 chrome 插件，该插件详情统一放在章节 [安装 Google Chrome 浏览器插件]

Aria2 Explorer 把下载添加到aria2任务

    https://microsoftedge.microsoft.com/addons/detail/aria2-explorer/jjfgljkjddpcpfapejfkelkbjbehagbh

    edge 兼容 chrome 插件，该插件详情统一放在章节 [安装 Google Chrome 浏览器插件]

Superb Copy 解锁 csdn/51cto 右键复制

    https://microsoftedge.microsoft.com/addons/detail/superb-copy/iaeijdamgmgkigibpoapgahideaobdde

Sublime Copy 解锁 csdn/51cto 右键复制

    https://microsoftedge.microsoft.com/addons/detail/sublime-copy/ligcjpcogfdnidfhkgcchmpheaeljakp

最终启用右键单击，这个并未开源，github 上的只是骗人的一个页面，不要安装：

    https://microsoftedge.microsoft.com/addons/detail/%E6%9C%80%E7%BB%88%E5%90%AF%E7%94%A8%E5%8F%B3%E9%94%AE%E5%8D%95%E5%87%BB/ijopbbfjlehabpldjiaipgiiedhfhbad

    https://ultimate-enable-right-click.github.io/

防止 bilibili 利用 webrtc 偷偷上传

    https://www.zhihu.com/question/447119724/answer/1892411379094364951

    WebRTC Control
        https://microsoftedge.microsoft.com/addons/detail/webrtc-control/eepeadgljpkkjpbfecfkijnnliikglpl

QR码生成与识别

    https://microsoftedge.microsoft.com/addons/detail/qr%E7%A0%81%E7%94%9F%E6%88%90%E4%B8%8E%E8%AF%86%E5%88%AB/nmddeihindhodaigflchmkmechmjjjbc

    “读取和更改站点数据”配置为“单击扩展时”

Git Master 在 github web页面添加导航树：

    https://microsoftedge.microsoft.com/addons/detail/git-master/pcpkfgepcjdmdfelbabogmgoadgmiocg

    https://github.com/ineo6/git-master

    同类还有 https://github.com/ovity/octotree

    “读取和更改站点数据”配置为仅限 github、gitee、gitlab 站点

        https://github.com/*

        https://gitlab.com/*

        https://gitee.com/*

smartUp 手势：配置中增加“摇杆手势”

    https://microsoftedge.microsoft.com/addons/detail/smartup%E6%89%8B%E5%8A%BF/elponhbfjjjihgeijofonnflefhcbckp

    https://github.com/zimocode/smartup

    同类有个 clean crxMouse Gestures 但是没有开源且不更新了。

### 安装 Google Chrome 浏览器插件

国内可用的 Chrome 扩展下载网站

    https://www.crx4chrome.com

    离线安装 Chrome 扩展程序的方法

    最新版的 Chrome 已经不支持将 CRX 扩展文件拖入浏览器直接安装了。

    点击“下载”，下载格式为 zip 压缩包，解压后可以得到 CRX 离线安装包。

    下载好 CRX 离线安装包后，我们需要先把文件的后缀名由 .crx 修改为 .zip，然后解压到文件夹中。

    打开 Chrome，菜单 → 更多工具 → 扩展程序，进入扩展管理页面。

    打开开发者模式 → 加载已解压的扩展程序 → 选择刚刚解压的文件夹，

改善 google 搜索质量，过滤某些国家

    打开 Chrome 的 偏好设置 - 搜索引擎，选择管理搜索引擎：

    点击 Add 按钮添加搜索引擎

    添加 Google NCR（无国家/地区重定向）搜素引擎，并将其设置为浏览器默认搜索引擎即可

    //设置 URL with %s in place of query 为：
    https://www.google.com/search?q=%s&pws=0&gl=us&gws_rd=cr

    打开 Google 搜索的 偏好设置，之后有些垃圾搜索结果会被屏蔽掉，所以现在需要将搜索结果分页设置为 20 条，否则每个分页的搜索结果就太少啦。

    导航到搜索语言设置，将 Google 产品的语言设置为 English，将显示搜索结果的语言设置为：English, 한국어, 中文 (简体), 中文 (繁體), 日本語

uBlock Origin

    chrome://extensions/?id=cjpalhdlnbpafiamejdnhcphjbkeiagm

    https://github.com/gorhill/uBlock/releases

    增加以下规则

        CJX's Annoyance List（反自我推广，移除Anti AdBlock，防跟踪补充）：
        https://github.com/cjx82630/cjxlist

        https://github.com/xinggsf/Adblock-Plus-Rule

读取网站数据权限：在所有网站上

Aria2 for Chrome

    chrome://extensions/?id=mpkodccbngfoacfalldjimigbofkhgjn

    https://github.com/alexhua/Aria2-Explorer

配合开源的aria2的下载程序 [Motrix](https://github.com/agalwood/Motrix/)，选项 `Aria2-RPC-Server`，端口统一16800，设置相同的 api key，监听地址 <http://localhost:16800/jsonrpcAria2-RPC-Server>。

读取网站数据权限：在所有网站上

smartUp手势

    chrome://extensions/?id=bgjfekefhjemchdeigphccilhncnjldn

Proxy SwitchyOmega

    chrome://extensions/?id=padekgcemlokbadohgkifijomclgjgif

添加 proxy，类型 SOCKS5 localhost 10808

读取网站数据权限：在所有网站上

Git Master

    chrome://extensions/?id=klmeolbcejnhefkapdchfhlhhjgobhmo

读取网站数据权限：在特定网站上

    https://github.com/*
    https://gitlab.com/*
    https://gitee.com/*

读取网站数据权限：在所有网站上

APK Downloader

    chrome://extensions/?id=idkigghdjmipnppaeahkpcoaiphjdccm

读取网站数据权限：无

uBlacklist

    自从谷歌退出中国市场后，其搜索结果质量日渐下降。壹读、每日头条、热备资讯、兰州养生网、代码日志等网站，多为复制抄袭、机器翻译的垃圾内容网站，在谷歌搜索中反而占据前排位置。

    uBlacklist 是一个禁止特定网站显示在谷歌搜索结果的浏览器插件，使用其可以将不喜欢的网站、垃圾网站加入屏蔽列表，从而净化搜索结果，节省你宝贵的时间。

    使用Chrome浏览器打开 uBlacklist 安装网址：

        https://chrome.google.com/webstore/detail/ublacklist/pncfbmialoiaghdehhbnbhkkgmjanfhe

    点击页面上的安装按钮即可。

    uBlacklist 添加订阅源

        uBlacklist 插件支持订阅黑名单，感谢网友提供信息，可以使用 https://cdn.jsdelivr.net/gh/cobaltdisco/Google-Chinese-Results-Blocklist@master/uBlacklist_subscription.txt

        这一个比较好的订阅源，基本覆盖了各种不良网址以及内容农场。

        使用方法如下：

        在禁止图标上右键，点击“选项”；

        选项页面拉到下面，点击“添加订阅”。在弹框中名称随便填写，例如“abc”，URL地址填入 https://cdn.jsdelivr.net/gh/cobaltdisco/Google-Chinese-Results-Blocklist@master/uBlacklist_subscription.txt，

        然后点击“添加”

    读取网站数据权限：在特定网站

        https://google.com/*

### 定制 Windows 10+ 的主题

这个网站的主题好像都是微软签名的，不需要安装破解

    创·战纪
    https://expothemes.com/themes/tron-legacy-windows-theme

        风格来源
        https://disneyworld.disney.go.com/attractions/magic-kingdom/tron-lightcycle-run/

关于第三方自定义主题的说明

    https://github.com/niivu/Windows-11-themes

先安装软件去除 Windows 对第三方主题的限制

    UltraUXThemePatcher 它修改你的系统文件，使第三方的主题可用。

        https://mhoefs.eu/software_uxtheme.php?lang=en

    SecureUxTheme 不修改系统文件

        https://github.com/namazso/SecureUxTheme

从各种主题网站下载安装

    创·战纪
    https://vsthemes.org/en/themes/windows10/510-tron.html

    https://www.deviantart.com/tag/windows10themes

    https://7themes.su/load/windows_10_themes/32

## 备份和恢复选项

    https://support.microsoft.com/en-us/windows/recovery-options-in-windows-31ce2444-7de3-818c-d626-e3b5a3024da5

### 备份

Windows 10 继承和扩展了 Win7 的各种级别的备份和恢复，概念比较多，注意区别。

#### 系统还原

设置-系统-关于：点开右上角的“系统信息”，系统保护-系统还原

在 Windows 操作系统安装更新补丁/驱动程序/应用等对系统稳定性可能有影响的改动时，对操作系统的文件做的还原点备份，出现问题时可以通过回退解决。一般只设置操作系统所在的c盘开启这个功能，其它盘不需要。

对注册表庞大系统变慢了，电脑用久了各种垃圾文件一大堆，导致的系统变慢，解决不了。

#### 文件历史记录

Windows -设置-更新和安全-备份

简单化的一个类似服务器文件系统的快照功能：

按时间同步复制你的用户 home 文件夹到别的硬盘，因为现在有很多应用和数据是安装到用户的 home 文件夹的，计算机使用久了这个目录会变得硕大无比。

如果 home 文件夹里的内容有误删除，可以恢复。

如果是装的东西太多，导致系统变慢，反安装软件后系统还是有垃圾文件，解决不了。

#### 恢复驱动器

制作一个安装到 u 盘上的 WinRe，可备份系统文件（可选择不备份，则只有 WinRe 了），不备份个人文件(home 目录)和自行安装的应用程序。

Windows 搜索 “恢复驱动器”，或选择“控制面板”>“恢复”。

目前还是用的 Win7 的，用于无法启动计算机的时候，重新初始化你的 Windows 系统到刚安装完的状态，可以选择保留你的个人文件(home 目录)。

恢复驱动器不是系统映像，其中不包含你的个人文件(home 目录)、设置和程序。

u 盘启动后使用 WinRe 对各种备份选项进行恢复，参见章节 [WinRe 的功能]。

#### 系统映像备份

    https://support.microsoft.com/en-us/windows/backup-and-restore-in-windows-352091d2-bb9d-3ea3-ed18-52ef2b88cbef#WindowsVersion=Windows_10

按文件备份你的 C 盘到别的存储盘，可以替代用 ghost 按硬盘扇区做系统镜像进行备份的方式。

在你的 Windows 安装完各种软件，做完各种设置后，备份一个系统映像最方便，他会在你指定的硬盘（恢复驱动器）自动创建一个目录保留各种安装好的程序和设置，以便可以恢复 Windows 到备份时点的状态。

目前还是用的 Win7 的，设置-更新和安全-备份：点击 “转到备份和还原 (Windows 7)”。或在任务栏上的搜索框中键入 “控制面板”。 然后依次选择 “控制面板”>“系统和安全”>“备份和还原 (Windows 7)”。

使用 WinRe 对各种备份选项进行恢复，参见章节 [WinRe 的功能]。

### 恢复

重置此电脑（初始化此电脑）

    恢复 Windows 到刚安装完的状态，只保留你的个人文件(home 目录)，删除你安装的应用和驱动程序，选项“预安装的应用”指OEM厂商随机的软件是否保留。跟前面的 “恢复驱动器” U盘做的事儿是一样的。

高级启动

    就是不使用 “快速启动” 模式的关机再开机初始化的过程，下次开机会进入 WinRe 环境，在 WinRe 里面选择对前面章节中各种备份的恢复。

这两个恢复选项，其实都是启动到你的计算机本地 c 盘的 WinRe 保留区。

如果计算机彻底无法启动，则需要使用上面章节 “恢复驱动器” 制作的 u 盘来启动，使用 u 盘上的 WinRe。

使用 WinRe 对各种备份选项进行恢复，参见章节 [WinRe 的功能]。

#### Windows RE

    https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/windows-recovery-environment--windows-re--technical-reference?view=windows-11

    替换掉了 Windows To Go https://learn.microsoft.com/zh-cn/windows/deployment/planning/windows-to-go-overview

Windows RE(简称 WinRe)的全称为 Windows Recovery Environment，即 Windows 恢复环境。

Windows RE实质上是提供了一些恢复工具的 Windows PE，预安装了「系统还原」、「命令提示符」、「系统重置」等CMD实用工具，以Winre.wim镜像文件的形式，储存于操作系统安装分区的「C:\Recovery\WindowsRE」中。

磁盘管理器中的 c 盘，默认有个恢复分区 500MB 是 WinRE 隐藏分区，另外还有个 EFI 启动区 100MB。

##### WinRe 的功能

重置此电脑（初始化此电脑）

    就是上面的恢复选项对应的内容。

启动修复

    使用 “启动修复” 功能时，WinRe 会自动监测当前操作系统存在什么问题，并自动予以修复。例如，如果MBR被修改，该功能可以帮助恢复 MBR。应该是利用 c 盘的保留分区恢复操作系统的引导信息。

系统还原

    对应前面章节 [系统还原]。如果已经自动创建过系统还原点，可以用 WinRe 还原系统到当时的状态。

系统映像恢复

    对应前面章节 [系统映像备份]，可以利用 WinRe 恢复你的c盘到备份时的状态。

    疑难解答-高级选项-更多-系统映像恢复

Windows内存诊断

    该功能与启动Windows时在 “工具” 菜单中选择Windows内存诊断功能相同，可以诊断内存硬件的问题。

命令提示符

    WinRe 命令提示符相当于 Windows PE 命令提示符，执行某些系统修复命令如 bcdedit 等。

##### WinRe 的使用

进入 WinRe 的几个方法

    在开始菜单的"电源"按钮，按住 shift 点击重启。

    或在设置-更新和安全-恢复，选择“高级启动”。

    命令行模式执行：

        shutdown /r /o  完全关闭转到 WinRe 高级启动选项菜单并重新启动计算机。

    在开启计算机电源后的 Windows 加载界面狂按 F8。

    最极端的方法：在 Windows 开机画面按住计算机的电源开关，直到关机，重复 3 次，Windows 引导会自动进入WinRe环境了。。。

你的电脑将重启到 Windows 恢复环境 (WinRE) 环境中，在“选择一个选项”屏幕上，选择“疑难解答”，然后在表格中选择一个功能。

## 安全的使用你的 Windows 10

强烈建议**在虚拟机里使用你的日常软件**，参见章节 [在虚拟机里使用你的日常软件]。

### 经常整理开机启动项目

开始菜单的启动项

运行（win + r）

    shell:startup

或资源管理器打开如下位置

系统级

    C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp

用户级

    C:\Users\xxx\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

注册表启动项位置（还有很多略）

    HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run

计划任务

    taskschd.msc

在这里有 Intel 和 Office 安装后搞的一些用户数据遥测上传，把能看懂的都选择 “禁用”。

如果想看到最全的统计，下载微软官方的 SystemInternals 工具包，运行 `Autoruns.exe`。

### 信息盗窃已经渗透到了驱动程序、操作系统根证书、浏览器证书级别

NOTE: 如果有浏览器下载的不明来源程序，虚拟机里都不要用，防止它偷 qq 密码等，这种程序要放在 Windows 沙盒里运行。

NOTE: 不要连接公共 wifi，特别是扫码认证让你安装证书才能使用的 wifi，该用手机流量就用，千万别节约。

    确保 Windows 安全中心的相关设置都开启，参见上面的章节 [装完Windows10后的一些设置] 里的 “设置 Windows 安全中心” 部分。

制作 Windows 安装 u 盘时，选择 iso 的版本一定要使用 Windows 英文版，安装时选择区域“新加坡”，装完操作系统后再将语言切换为简体中文。或安装时选择区域“美国”，安装后添加中文语言包，更改界面提示语言为简体中文，原因不解释。

主机只安装开源的应用程序。

淘宝等杂货铺来源的外接设备，提供的各种国内国外小公司的驱动程序，安装时会提示是否信任该机构，确定才可以安装，在安装后**务必检查当前操作系统的证书，预期目的是<所有>，这种驱动安装的证书的都极其不规范**，建议退货。

中国产程序特别是 QQ、微信、钉钉、360、网络游戏等安装操作系统级别的驱动程序，或支付宝、银行、12306 这样安装好几个不相关的根证书，而且证书的预期目的是“所有”的，统统不该被信任。建议在 hpyer-v 虚拟机安装的 Windows 里使用这些软件，开启直通主机 usb 设备。

#### 国外大公司出品的 cn 本地化版本

其实是跟 cn 公司合作开发出来的软件，也要放在虚拟机里运行

    M$ 中国研究院出品的 cn 特供版的 bing 应用，比如打着 edge 工具的名号等直接在 edge 浏览器弹窗推荐安装，慎用！

    Adobe Flash 已转让给 cn 私企，禁用或在 Windows 沙盒使用！

    FireFox 只在 mozila 官方网站下载“英文版”使用。中文版的 FireFox 等浏览器由 cn 公司开发，不要下载安装！<https://zhuanlan.zhihu.com/p/141853308>

    Mozilla Firefox 自己维护一套可信任的 CA 证书列表，Firefox Fusion 甚至用洋葱；Chrome/Edge 使用操作系统厂商维护的可信任 CA 证书列表。但是，Mozilla 的 CA 认证出事不止一次了，搜“Firefox 证书” <https://wiki.mozilla.org/CA%3AWoSign_Issues>。

#### 浏览器 CA 认证面对的挑战

只要通信双方使用同一个证书，通信数据在链路上对第三方是可以确保是保密的。确定就是第三方如果持有该证书的私钥，会明文查看到你的通信数据，即你以为的通信加密，有人是可以看到的。

国内大的系统如银行、支付宝等使用的自己的证书，只要你信任对端银行，那么使用该证书是没有问题的。相信银行和支付宝不敢把自己的私钥共享给第三方

    https://www.zhihu.com/question/322568840/answer/682296416

问题在于

    伪造的网站，比如一个假的 google.cn，使用国内的证书，欺骗浏览器不提示假冒。

    在通信网络的骨干节点替换 https 地址，欺骗你的应用程序，从而实现第三方可以解密甚至替换你的通信数据。比如你从 github.com 下载软件，但是在网络上被偷偷替换掉了地址，实质下载了另一个软件。

对于互联网应用来说，滥发数字证书的危害，在于通配符式匹配如 *.github.com 容易让用户被钓鱼网站蒙蔽。

直接危害性小：

    对木马等监听程序来说，如果欺骗用户信任了木马的证书（公钥）进行加密以登录网站，那么还需要部署私钥才能解密，但木马自己的私钥并不适合部署到用户计算机，或欺诈网站上。也即木马程序自身不会带解密的私钥，它只转发用户被骗加密的消息。

    木马只是个引导，即便CA证书被乱发，只要用户没有被引导到钓鱼网站，或用户的浏览器被实现跨域的 cookie session 攻击，黑客并不能直接实现对用户的侵害。但是伪造的网站必然有把用户引导到钓鱼网站的可能，所以滥发CA证书必需被大家抵制。

次生灾害大：

    如果证书有问题，通信加密是完全没有作用的，对方可以随便使用一个伪造的网站如邮箱网站引导你登录，而你的浏览器会视为真实网站，不会做任何提示。对网络通信的封包来说，如果证书有问题，在网关或路由器层面隐藏的中间人代理，完全可以使用他的私钥解密任何你发送的数据包的内容。

    如果 github.com 用通配符 * 给申请的用户颁发的网站证书，使得 heike.github.com 被认定为官方网站，这会严重误导普通使用用户。

Chrome/Edge 使用操作系统厂商维护的可信任 CA 证书列表。

    Firefox Fusion 用洋葱来提升匿名性 https://wiki.mozilla.org/Security/Fusion。

    目前更先进的用于网络浏览器的匿名公钥认证体系是 [onion service](https://github.com/topics/onion-service)，例子见 https://ntzwrk.org/static/misc/onion-services.txt。

Mozilla Firefox 自己维护一套可信任的 CA 证书列表，但是信誉不佳出事不止一次了

    搜 “Firefox 证书”

    搜 “Firefox CNNIC MCS wosign starcom OSCCA 证书”
        https://wiki.mozilla.org/CA%3AWoSign_Issues

        https://zhuanlan.zhihu.com/p/34391770
        https://www.zhihu.com/question/49291684
        https://www.landian.vip/archives/15656.html

滥发证书的实例：

波兰认证机构 Certum 2万元就能做下线代理

    https://zhuanlan.zhihu.com/p/612235572

CNNIC(中国互联网信息中心)证书

    2015年3月20日开始，谷歌察觉到有人在使用了伪造的 Google 证书，经查，伪造的 Google 证书是由埃及一家叫做 MCS 集团的机构所发行的，这个名为 MCS 集团的中级证书颁发机构发行了多个谷歌域名的假证书，而MCS集团的中级证书则来自 CNNIC。

    该证书冒充成受信任的谷歌的域名，被用于部署到网络防火墙中，用于劫持所有处于该防火墙后的 HTTPS 网络通信，而绕过浏览器警告。

    谷歌联系了 CNNIC，CNNIC 在3月22日回应称，CNNIC 向 MCS 发行了一个无约束的中级证书，MCS 本应该只向它拥有的域名发行证书，但 MCS 将其安装在一个防火墙设备上充当中间人代理，伪装成目标域名，用于执行加密连接拦截（SSL MITM）。企业如出于法律或安全理由需要监控员工的加密连接，必须限制在企业内网中，然而防火墙设备却在用户访问外部服务时发行了不受其控制的域名的证书，这种做法严重违反了证书信任系统的规则。尽管这种解释看起来符合事实，然而，CNNIC 还是签发了不适合 MCS 持有的证书。

    3月23日，谷歌发文宣布撤销对 CNNIC 的信任，同日 Mozilla 也宣布吊销 CNNIC 证书，并且在事后公布了一份调查报告。

WoSign(沃通)证书和 StartCom 证书

    2015 年 6 月，有申请者发现沃通免费证书服务存在问题，只要申请者证明他们拥有子域名，沃通就会给他们颁发根域的证书。这名申请者本来是想要申请一张 <https://med.ucf.edu> 的证书，不小心写成了 <https://www.ucf.edu>，结果沃通居然同意了，颁发了一张根域名的证书给他。

    为了进一步测试，研究人员用同样的方法针对 Github 的根域名实施了欺骗，众所周知，GitHub 是可以支持用户创建自己的 <https://{username}.github.io> 子域名的。因此，当申请者证明自己有子域控制权后，沃通同样分发了 GitHub 根域名的证书。进一步调查发现，除了Github，沃通还错误颁发了许多其他网站的证书，如微软的证书。

    这些漏洞在网络上引起了是否吊销沃通证书的讨论，沃通随后发表了一份调查报告。但是 Mozilla 在随后调查中发现，沃通还秘密收购了另一家以色列的证书商 StartCom。除此之外，调查还显示沃通存在着许多严重的问题，这显示出该公司内部管理十分混乱，不符合一个 CA 机构应有的标准。其中一些问题包括：

        在违反 CA 策略的情况下仍然颁发 SHA1 算法证书
        证书使用重复序列号
        违反多项 CA/B 行业基准要求
        任意端口认证域名身份
        附加域名错误
        使用 SM2 签名算法，不符合CA/B行业基准中对于签名算法的要求
        秘密收购 StartCom
        允许用户修改证书起始时间
        未经认证用户身份颁发证书

    随后，苹果、Mozilla 等浏览器厂商吊销了沃通的证书。

    值得注意的是，当时沃通的母公司是奇虎360。

    Mozilla 对沃通的处罚仅仅是吊销证书一年，但是很显然，沃通以及 StartCom 已经无法得到信任。如果你在操作系统和浏览器中仍发现了存留的沃通(WoSign)和 StartCom 证书，请将其移除。

    StartCom 已经于2018年1月1日停止签发任何证书。

#### 务必检查当前操作系统的证书

当今世界，普遍采用非对称加密算法对文件进行签名和验签，而非对称加密无法防御“中间人攻击”，目前的解决办法是通过建立CA认证体系，由大家公认的大机构对各公钥提供签名的方式，实现公钥交换阶段的互相认可。各厂家的浏览器、各操作系统，在出厂设置时都会内置一些CA证书，以保证连接其它CA认证的网站时可以互相验证签名，操作系统发布的程序或包，也有很多使用CA证书来验证是否原厂签发的文件，所谓保真。

数字证书保真问题在近10年非常混乱，特别是非微软的第三方驱动程序（自签名test用途即可）也能加载到 Windows 操作系统内核，特别是很多小厂商的电脑部件，用户买了之后安装个驱动，不明不白的就安装了厂商自己签发的根证书，而该证书的权限设置为test默认申请全部权限。微软直至 Windows 10、11 才比较多的关注这个问题，开始限制不合理的签名软件的功能。

根证书预期目的是 “所有”(ALL) 的危险性，比如写一个Windows程序，签名用CNNIC签发的或test用途，Windows 操作系统会认可并加载。<https://www.zhihu.com/question/50919835>，隐患就是中间人攻击，突破ssl获取用户隐私。

比如：某个不良厂商自建证书或申请 CNNIC 证书，申请了 “ALL” 权限，则只要他的程序可以对操作系统或通信中的信息进行截获，特别是驱动程序，可以拦截任何操作系统底层通信。如果间谍在网关或路由器层级设置代理，添加中间人攻击拦截用户发送的信息包，只要该信息该驱动程序换用自己的证书加密了，都可以使用自己的对应私钥解密为明文查看。

现实中，大量的淘宝等杂货铺来源的 usb/pcie/雷电接口的外接设备，提供的驱动程序来自国内国外各种奇怪的小作坊公司，一般都会安装一个 test 用途的证书，权限是“ALL”，这种证书一般是开发内部测试使用，绝不该出现在正规的厂商发布中。对这种驱动程序，只能建议在虚拟机中隔离使用，千万不能为了方便跟你的常用电脑环境混在一起。

如果证书有问题，通信加密是完全没有作用的，对方可以随便使用一个伪造的网站如邮箱网站引导你登陆，而你的浏览器会视为真实网站，不会做任何提示。对网络通信的封包来说，如果证书有问题，在网关或路由器层面隐藏的中间人代理，完全可以使用他的私钥解密任何你发送的数据包的内容。

运行：`certmgr.msc`，逐个检查 “受信任的根证书颁发机构” 目录，重点看**预期目的是<所有 ALL>的**。

    不明来源、声誉不好的公司出品的软件，尽量在虚拟机安装使用。

    如果要清除该证书，只需将其移动到"不受信任的证书"中。

    删除所有疑似跟 cn 相关的证书，即使来源注明是美国注册的公司，但是只要有 cn 投资的，统统删除，这个之前出过几次丑闻了，搜“Firefox CNNIC MCS wosign starcom OSCCA 证书” 。

Certum 证书的预期目的全是所有，极为可疑，Windows 中除了微软自己的证书，没有预期目的时所有的。

我们下载的应用常见的证书 DigiCert

    Certbase平台Thawte品牌：Thawte 是首个向美国以外的公共实体颁发 SSL 证书的证书的CA机构，且从 1995 年起，已颁发超过 945,000 个 SSL 和代码签名证书，保护 240 多个国家/地区中的身份和交易。

    Certbase平台的代码签名证书：Certbase平台代理的 Sectigo、DigiCert、GlobalSign 等品牌

    TrustAsia 例外：Symantec 的国内合作伙伴，Symantec 的 CA 业务被 DigiCert 收购，其证书链也从 Symantec 变为 DigiCert。https://www.trustasia.com/digicert/ev-code-signing

Windows 10的1607版本之后，内核模式代码似乎使用了独立的信任证书库，可防止第三方的驱动程序只要有自签名就可以加载到操作系统 <https://github.com/HyperSine/Windows10-CustomKernelSigners/blob/master/README.zh-CN.md>。

    Windows证书的使用说明 <https://docs.microsoft.com/zh-cn/windows-hardware/drivers/install/local-machine-and-current-user-certificate-stores>

    微软官方操作系统根证书列表 <https://docs.microsoft.com/zh-cn/troubleshoot/windows-server/identity/trusted-root-certificates-are-required>

    Apple 操作系统中可用的受信任根证书 <https://support.apple.com/zh-cn/HT209143> <https://support.apple.com/en-us/HT209143>

    Mozilla浏览器的信任列表 <https://ccadb-public.secure.force.com/mozilla/IncludedCACertificateReport>

##### 清理操作系统证书

    运行 `certlm.msc` `certmgr.msc`

在操作系统根证书管理中，去除内置的 CN 证书、Certum 证书、Trust Asia 证书！先导出证书为文件，然后导入为 “不信任的证书”。

验证

    访问网站 https://www.xycq.gov.cn/，提示不安全的数字证书就说明不信任 “Certum” 证书了

    访问网址 https://www1.cnnic.cn/，如果浏览器提示不是安全连接，则你的浏览器没有使用 cnnic 伪造的证书或操作系统中没有该证书。

    访问网址 https://www.libinx.com/，提示不安全的数字证书就说明是假的 “Trust Asia” 证书

    执行 cpuz，提示被管理员禁用

#### 除了 Firefox 没有浏览器检查吊销证书

    https://zhul.in/2024/11/19/firefox-is-the-only-mainstream-brower-doing-online-certificate-revocation-checks/

Google Chrome / Microsoft Edge 上，OCSP 是不被支持的，chromium 团队在 2014 年就禁用了 OCSP 校验，且目前没有设置项允许用户手动开启。

验证，访问以下网址，看浏览器是否提示证书已经被吊销了：

    https://digicert-tls-ecc-p384-root-g5-revoked.chain-demos.digicert.com/

    https://revoked-isrgrootx1.letsencrypt.org/

ssl 证书这个方式现在用到的估计就是所谓的有效性，但时效无法保证。

这样也侧面印证了，微软主推的安全启动功能，其实没什么靠谱的。

### 浏览网页时防止网页偷偷改浏览器主页等坏行为

在 edge 浏览器，点击菜单，选择“应用程序防护窗口”，这样新开的一个 edge 窗口，是在虚拟机进程启动的，感觉是容器化处理，任何网页操作都不会侵入到正常使用的 Windows 中。

在 Windows 安全中心里可以设置，能否从这里复制粘贴内容到正常使用的 Windows 中等各种功能。

### 用沙盒运行小工具等相对不靠谱的程序

    https://learn.microsoft.com/zh-cn/windows/security/threat-protection/windows-sandbox/windows-sandbox-overview

    微软官方推荐的一些方便你使用的小工具

        https://github.com/microsoft/Windows-Sandbox-Utilities

沙盒属于容器化技术，底层共用你当前操作系统的静态文件，系统资源的共享理解为进程争用即可，支持硬件直通

Windows 沙盒属于无状态的操作系统，这个虚拟的 Windows 窗口一旦关闭，里面的任何操作都会清零，所以可以提前把运行结果复制粘贴到正常使用的 Windows 中。

使用：开始菜单，选择“Windows sandbox”程序，将新开一个虚拟的 Windows 窗口，把你觉得危险的程序复制粘贴到这个虚拟的 Windows 系统里运行，格式化这里的硬盘都没关系，在这个系统里可以正常上网。

Windows 沙盒可以用配置文件的方式设置共享目录，并设置只读权限，方便使用。比如把 c:\tools 目录映射到 Windows 沙盒里运行网络下载的小程序，或者把 download 目录映射到沙盒的 download 目录以便在沙盒里浏览网页并下载程序。

Windows 沙盒使用 WDAGUtilityAccount 本地帐户，所以共享文件夹也保存在这个用户目录的 desktop 目录下。

tools.wsb 示例：

```xml

<Configuration>
  <MappedFolders>
    <MappedFolder>
      <HostFolder>C:\tools</HostFolder>
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

其中，MappedFolder 可以有多个，默认映射到桌面，也可以单独指定。

图形化编辑配置文件

    https://github.com/damienvanrobaeys/Windows_Sandbox_Editor

添加到右键

    https://github.com/damienvanrobaeys/Run-in-Sandbox

    先下载

        git clone --depth=1 https://github.com/damienvanrobaeys/Run-in-Sandbox.git

    然后用管理员权限运行 Add_Structure.ps1

其它开源的轻量化沙盒工具

    https://github.com/sandboxie-plus/Sandboxie

    QQ、微信、钉钉、360啥的很多cn软件很多都添加到系统级驱动，在这种容器化沙盒里防不住，老老实实的用虚拟机吧。

#### RemoteApp 隔离国内 Windows 毒瘤应用运行方案

Microsoft 所开发的一种基于 RDC 协议的隔离运行任何应用的方案 —— RemoteApp。配合单独的电脑主机、或虚拟机应用或是 ESXi/Proxmox VE 这样的虚拟机服务器来运行。

    https://techcommunity.microsoft.com/blog/microsoft-security-blog/introducing-remoteapp-and-desktop-connections/246803

配置 RemoteApp 程序快捷方式可以使用一款叫做 RemoteAppTool 的开源应用完成。该应用要求必须安装 .NET Framework 4.x 才能使用。

    https://github.com/kimmknight/remoteapptool

    https://bbs.letitfly.me/d/1199

1、给客户机安装符合以上条件的操作系统。如果客户机是虚拟机，这个虚拟机可以不使用声卡，不影响毒瘤应用发出声音。必要的话，请固定好这台客户机的局域网IP地址以便后续操作。

2、请给你托管这些应用的客户机配置登录密码。登录密码是使用 RDC 必须要有的东西。最简单的配置登录密码的方法是，按下 Ctrl+Alt+Delete 后点击修改密码，然后配置密码。

3、必须开启允许接受远程桌面连接。如果你打算把这个客户机暴露到公网且你确实有公网IP，选择“仅允许运行使用网络级别身份验证的远程桌面的计算机连接”。

4、现在你可以安装 RemoteAppTool 以及你想托管的应用了。如果你想使用第三方输入法，也请在这个环境下安装好。

5、点击【+】图标添加应用，把你要的应用主程序添加进去。如果找不到相关的主程序，可以添加快捷方式。然后，点击列表内你想制作快捷方式的应用后再来点击Create Client Connection。

6、这边注意，如果你在配置系统的时候没有开启网络发现，或者你打算用公网IP连接到这个服务器，请将下面的两个计算机名字改成实际的IP地址或是DDNS域名。你也可以按照实际需求，在Options内勾上Create icon files，以便产生你需要的RDP格式文件和对应的应用图标。最后点击Create，以制作RDP文件和对应应用图标。

7、制作好的RDP文件和应用图标在桌面上会以这种方式提供。请将这些文件发送到可以连接到这台客户机的电脑上。

8、打开RDP文件，输入你在这个机器上配置的用户名和密码。注意，如果使用的用户名不是Administrator或微软账户，则用户名必须填写客户机的计算机名\你的用户名，例如hia-pc\hikarical。你可能需要同时在自己的一端和客户机端确认登出。

9、你可以制作多个RDP文件分别对应不同的应用。第一个开启之后，开启后面的RDP文件后启动应用就不需要等待连接了。在任务管理器下，它们全部被隔离在远程桌面连接下，完全不会占用多余的内存。剪贴板也可以无缝复制粘贴，看起来就像是在自己的机器上直接运行，但实际运行效果强于各种虚拟机的融合模式。如果愿意，你仍然可以用它调用位于你自己电脑上的文件，加载速度取决于你和这个客户机之间的网络传输速度。

为了最佳的视觉体验，个人推荐在托管这些应用的机器使用Windows 8.x或以上版本。

很多国内毒瘤应用特别喜欢套DirectUI，这玩意在Windows 7和以下版本的情况下运行，就不能调用DWM而是GDI来处理和分离这些窗口。你可以看到这些窗口后面有一圈丑陋无比的托管用客户机的背景图。

最后关于RemoteApp的客户机需求，微软官方给出的要求是必须要使用远程桌面客户端6.1或以上版本，能够支持该版本远程桌面客户端的最低版本是Windows XP SP3……

2022年8月7日

    感谢推荐，刚尝试了一下，在这分享一下目前使用体验：

    我的运行环境是 Win10_Pro 连接局域网内PVE的虚拟机 Win10_Ltsc

    文档编辑类 基本使用正常 (Word剪贴板正常/PPT剪贴板无法粘贴图片)

    im通讯类 微信无法正常使用剪贴板，X掉后无法通过任务栏图标进行打开退出等操作 （需再次点击 wechat.rdp 文件呼出）

    媒体播放类 各大音乐/视频播放器使用正常（视频播放因远程主机未配置硬件解码 出现些许卡顿）

    网盘类 无法直接拖动文件上传，需点击上传文件手动选择文件路径

    工具类 远程连接工具MobaXterm使用正常

    游戏类 因机能有限只测试了 galgame 游戏使用正常

    部分软件无法打开 -----> 腾讯会议

### Windows 应用(APP)

1、Windows 桌面应用程序（desktop applications）

从 Windows 95 以来这几十年发展的 *.exe，对操作系统底层调用 Win32 API。后来引入的 VC/MFC 等框架，底层都依赖 Win32 API。通过 Win32 API，应用程序具备对 Windows 和硬件的直接访问权限，此应用类型是需要最高级别性能和直接访问系统硬件的应用程序的理想选择。这种程序对操作系统各组件的访问，在区分用户这个级别是可以用 system 权限超越的，基本不受控。

2、WPF/.Net/Windows Form 等新的框架

各种新的 API 框架，意图都是统一不同的操作系统的调用接口，应用程序只需要调用同一套接口即可直接运行。但流行程度都不如 Win32 API。这些框架本身对安全权限的限制也不多，软件想流氓起来，运行时环境也控制不了。后来这些框架打包统一起来，叫托管运行时环境(WinRT)，使用这种环境的程序成托管应用。

3、通用 Windows 平台 (UWP) 应用

类似手机的方式，在 Windows 商店下载的应用(APP)，使用 UWP 组件的方式，在操作系统的应用容器内部运行，即沙盒运行容器化。

UWP 核心 API 在所有 Windows 设备上是相同的，这时微软的目标是统一手机和PC机的操作界面。

UWP 应用在其清单中声明所需的直通设备，如访问麦克风、位置、网络摄像头、USB 设备、文件等，在应用被授予能力前，由用户确认并授权该访问。

UWP 应用可以是本机应用，也可以是托管应用：

    使用 C++/WinRT 编写的 UWP 应用可以访问属于 UWP 的 Win32 API，所有 Windows 设备都实现这些 Win32 API https://docs.microsoft.com/zh-CN/windows/uwp/get-started/universal-application-platform-guide

    托管应用就是使用 WPF/.Net/Windows Form 框架的程序。

4、合订本 - Windows应用程序(Widnows App)

<https://docs.microsoft.com/zh-cn/windows/apps/get-started/?tabs=cpp-win32#other-app-types>

Widnows App 的开发涵盖了 Windows App SDK、Windows SDK 和 .NET SDK，应该是想搞个大一统的开发平台：

    原来的 Win32 API 升级成 WinRT API，对应的使用这个 API 构建程序叫应用（APP）；

    原来的 wpf、.net、uwp 也都被大一统了 <https://docs.microsoft.com/zh-cn/windows/apps/desktop/modernize/>；

    UWP 也要迁移到 Widnows App，理论上是容器化运行 <https://docs.microsoft.com/zh-cn/windows/apps/desktop/modernize/desktop-to-uwp-extend>；

    Android 应用现在借助微软的安卓虚拟机也可以在 Windows 11 上容器化运行，应该是类似 WSL2 的思路，在 Windows 桌面可以使用其它操作系统的图形界面程序，估计是像 ConPty + WSLg 那样加了中间转换层，参见章节 [Windows 10+ 本地化 Linux 编程接口](gnu_tools.md)。

开发平台打包统一了，能再卖一波 Visual Studio，但是各类应用还是各搞各的，桌面应用的通用化没啥指望，后续看谁能流行起来再说吧。

总之，Windows 依赖在操作系统这个层面对应用程序的权限进行控制，一直做不到。目前最好的办法，只能是把操作系统包起来运行的虚拟机方式，才能完全彻底的隔离流氓软件对用户信息的侵害。

也就是说，在你的 Windows 操作系统安装完毕之后，基本的用户信息都具备了，可信赖的大公司的软件都安装了，其他zh软件，统统安装到一个虚拟机里使用，不要安装到实机里。至于是使用 Windows Sandbox 沙盒还是 hyper-v 虚机，酌情决定。

### Windows 10 S 模式

处于 S 模式的 Windows 10 是 Windows 10 的一个特定版本，该版本进行过简化处理以提升安全性和性能，并仍然提供熟悉的 Windows 体验。 为了提高安全性，它仅允许安装 Microsoft Store 提供的应用，并且要求使用 Microsoft Edge 进行安全浏览。

    https://learn.microsoft.com/zh-cn/windows-hardware/design/device-experiences/oem-10s-security

    https://support.microsoft.com/en-us/windows/windows-10-and-windows-11-in-s-mode-faq-851057d6-1ee9-b9e5-c30b-93baebeebc85

将应用程序二进制文件打包为 MSIX 程序包，然后通过 Microsoft Store 分发应用

    https://docs.microsoft.com/zh-cn/windows/deployment/s-mode#%E4%BF%9D%E6%8C%81%E4%B8%9A%E5%8A%A1%E7%BA%BF%E5%BA%94%E7%94%A8%E4%B8%8E%E6%A1%8C%E9%9D%A2%E6%A1%A5%E4%B8%80%E8%B5%B7%E8%BF%90%E8%A1%8C

### 安装双系统

给硬盘划分多个分区或使用多个硬盘，可以安装多个操作系统：

    建议先安装 Windows 10，再安装 Linux，这样主板 BIOS 的默认引导分区是 Linux 的 grub，而 grub 引导加载器能直接扫描到已存在的 Windows 10 系统，并将其添加到启动选择菜单中。这样开机时就会出现 grub 菜单，用户可以手工选择启动到哪个操作系统。

    如果 Windows 升级时重写硬盘的默认引导分区为自己，则 grub 选择菜单不会再出现，只能在开机时按 F12/F1/DEL 键调出主板 BIOS 的启动菜单列出当前硬盘的可引导分区（如果一个操作系统有多个选项说明可以选择 UEFI/BIOS 方式），手工选择启动到 Linux，然后使用相关命令重新将默认的引导分区指向 grub 。

安全性上主要是隔离

    双操作系统仍无法保护 /boot 分区，在操作系统引导阶段对木马监控程序的防护差，建议操作系统安装时开启 安全启动（Secure Boot）功能以增强抵抗力。

    为防止 Windows 上的木马病毒扫描 Linux 上的数据，建议 Linux 安装选项选择加密所在分区。

使用双硬盘，隔离性比一个硬盘用多个分区安装多个操作系统要好，且不涉及 gurb 引导菜单

    pc 中每次只安装一个硬盘分别安装 Windows 和 Linux，这样两个操作系统互相不知道对方的存在，然后把两块硬盘都安装到 pc 中。

    启动时主板一般会默认找第一块硬盘上的操作系统启动分区直接引导。

    如果需要启动第二块硬盘上的操作系统，在开机时按 F12/F1/DEL 键调出主板 BIOS 的启动菜单列出当前硬盘的可引导分区（同上），手工指定你要引导的操作系统即可。

    如果在冷机启动时先进入主板 BIOS 设置屏蔽一个硬盘，这样可以更好的隔离两个操作系统。

必须禁用“快速引导”/“快速启动”（FAST Boot）功能

    在 Windows 中禁用“快速引导”/“快速启动”FAST Boot功能

    主板的 “快速启动 FAST Boot” 也要关闭

    这个功能在关机时会保留某些硬件的状态，是给 Windows 优化下一次开机加速启动时间用的。

    如果前一次使用计算机时用的是 Windows，则关机后再次开机启动到 Linux 后，因为硬件的状态不是冷启动的重置状态，大概率文件系统会不稳定。

注意

    启动 Windows 后，可以看到 Linux 所在的硬盘分区为未格式化，这是因为 Windows 不识别 Linux 的硬盘格式，不要操作。

    启动 Linux 后，可以看到 Windows 所在的 NTFS 硬盘分区，可以挂载使用，但是强烈建议只读，因为 Linux 对 NTFS 的支持一直无法完善（M$ 未开源 NTFS）。

在每个系统内，利用虚拟机分类隔离使用你的软件，详见章节 [在虚拟机里使用你的日常软件]。

硬盘A（分区A）

    主机：安装 Windows，仅打游戏用

    客户虚拟机：家庭私密、网课等日常用途

    客户虚拟机：上网冲浪

硬盘B（分区B）

    主机：

        安装 Windows，对自己开启 Bitlocker 加密（防止硬盘A的操作系统启动后访问硬盘B，避免A上木马病毒程序的扫描和传播），只做升级维护等管理用途，不在这里做日常使用。

        或安装 Linux 系统，安装分区时选择磁盘加密，意味着你的整个系统是加密的（除了 /boot 分区）。

    客户虚拟机：开发、办公

    客户虚拟机：上网冲浪

    客户虚拟机：可以设置挂载分区 A 的操作系统临时使用，详见章节 [挂载实体机所在硬盘作为虚拟机](virtualiziation think)。

> 先装 Windows 再装 Linux

这样的方案最方便，只要在 Windows 里给 Fedora 留出一个空白未分区区域或空白磁盘，在 Fedora 安装时选择自动即可正确安装，而且自动安装 grub 在启动时出现菜单让你选择启动到 Fedora 还是 Windows

    https://linuxhitchhiker.github.io/THGLG/solution/config/dual-boot/

    https://zhuanlan.zhihu.com/p/488292819

    https://zhuanlan.zhihu.com/p/363640824

    双系统全盘加密 https://www.cnblogs.com/xuanbjut/p/11796637.html

    Fedora Silverblue使用 EFI 分区与 Windows 双启动

        https://docs.fedoraproject.org/en-US/fedora-silverblue/troubleshooting/#_unable_to_install_fedora_silverblue_on_efi_systems

    先装 Ubuntu 再装 Windows，你痛苦吗？

        https://zhuanlan.zhihu.com/p/609573337

        https://www.cnblogs.com/masbay/p/10745170.html

    适用 MBR 启动分区，UEFI 待研究

        Linux多系统并存的GRUB配置文件内容分析 http://c.biancheng.net/view/1033.html

        Linux GRUB手动安装方法详解 http://c.biancheng.net/view/1035.html

#### Linux + Windows 双系统互相挂虚拟机

第一块硬盘安装 Linux，然后虚拟机安装 Widnows，然后把该虚拟机转到第二块硬盘上作为实机可单独启动，而且在 Linux 里还可以作为虚拟机挂载使用！详见章节 [qcow2 虚拟机转为实体机]、[挂载实体机所在硬盘作为虚拟机](virtualization think)。

#### Linux + Windows 双系统时间差8个小时

如果是虚拟机中的 Windows 时间经常不准，详见章节 [虚拟机在长时间运行后时间变慢](virtualization think)。

操作系统对时间的处理，依赖计算机主板上的 RTC 时钟硬件，这个硬件在关机时也可以保持时间，从而保证了开机后操作系统即有一个准确可用的时间。

如何处理 RTC 硬件时间 Linux 跟 Windows 的机制不同：

    Linux 默认认硬件时间为 GMT+0 时间，即世界标准时间 UTC。Linux 在显示时间时，用硬件时间加上当前操作系统的时区和夏令时偏移，计算出本地时间进行显示，如中国是东八区无夏令时，为 GMT+8-0。

    而 Windows 认为硬件时间就是保存的本地时间，比如在中国，硬件时间就是北京时间 GMT+8。

因此，如果用户在一台计算机上切换使用两个操作系统，则每个操作系统的时间校准服务都会按自己的理解设置系统时间，继而修改了 RTC 时钟，二者的时间差值正好是当地时间跟零时区的差值，比如在中国，切换过 Linux 系统后，你使用 Windows 时会发现时间会比正常时间慢 8 个小时，过一阵系统的 NTP 服务才会纠正这个错误。

解决办法：

法一、让 Windows 按照 Linux 的方式管理时间

登录 Windows，打开“开始-运行”，输入 “regedit” 打开注册表。

进入 HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation\ 中添加一项类型为 REG_DWORD（64位系统为REG_QWORD）的值，名称为 RealTimeIsUniversal ，值设为 1。这样可以将 Windows 对待硬件时间的方式从 localtime 改成 utc，改完后重启计算机生效。

Windows 主机和 Windows 虚拟机都适用这个方法。

推荐使用本方法。

法二、让 Linux 按照 Windows 的方式管理时间

    Fedora 安装时，如果检测到计算机上已经安装过 Windows，会自动设置自己按照 Windows 的方式管理时间，避免 Windows 下时间错误。其实它应该给个提示，按上面的方法一修改 Windows 管理时间的方式跟自己保持一致。

Linux 可以通过 `timedatectl` 命令将系统时间同步到 RTC 硬件时间，使自己跟 Windows 的时间管理方式一致：

    # sudo timedatectl set-local-rtc 1

    $ sudo reboot

缺点是无法适应时区变化的情况，不过只要我们的计算机不在飞机上而且所在地区没有夏令时，就没有关系：

    $ timedatectl status
                Local time: 二 2023-08-08 15:30:53 +08
            Universal time: 二 2023-08-08 07:30:53 UTC
                    RTC time: 二 2023-08-08 15:30:53 <----- RTC 跟本地时间一致
                    Time zone: Asia/Singapore (+08, +0800)
    System clock synchronized: yes    <-------- 时间同步正常
                NTP service: active   <-------- 正在使用 chrony、systemd-timesyncd 等 NTP 服务
            RTC in local TZ: yes      <-------- 兼容 Windows 设置了硬件 RTC 保存本地时间，下面会显示详细的警告信息

    Warning: The system is configured to read the RTC time in the local time zone.
            This mode cannot be fully supported. It will create various problems
            with time zone changes and daylight saving time adjustments. The RTC
            time is never updated, it relies on external facilities to maintain it.
            If at all possible, use RTC in UTC by calling
            'timedatectl set-local-rtc 0'.

hwclock 命令也可以实现上述功能.

Linux 时间操作参见章节 [操作时间 timedatectl/chronyc 及 NTP 服务](gnu_tools.md) 中 '设置硬件 RTC 保存时间的标准' 部分。

### Bitlocker 加密

    https://learn.microsoft.com/zh-cn/windows/security/information-protection/bitlocker/bitlocker-overview-and-requirements-faq

使用 Bitlocker 加密的先决条件

    计算机主板硬件支持 TPM 1.2 以上

    操作系统需要有 WinRe 分区

加密体系

    数据加密密钥 DEK 用于加密驱动器上所有数据的密钥，它永远不会离开设备。它以加密格式存储在驱动器上的随机位置。如果 DEK 发生更改或擦除，则使用 DEK 加密的数据不可恢复。

    身份验证密钥 AK 用于解锁驱动器上的 DEK。 AK 的哈希存储在驱动器上，需要确认才能解密 DEK，从而可以解密驱动器。

Bitlocker 不需要输入密码的原理是利用计算机主板上的 TPM 芯片做 boot measure, 只要启动过程未被篡改, 就可以解密.

    不需要登录 Microsoft 账户，该账户可以云备份你的紧急恢复密钥

    搞出来问题可以试试 diskgenius 能否恢复出一点数据

如果 Bitlock 使用软件加密，硬盘读写速度大概 30% 的降幅，如果使用 ssd 硬件加密功能，不影响读写速度，但是不够安全(后面详述)。

基于文件夹加密的工具软件，大多数采用的是隐藏文件或者隔离文件的方式进行加密存储，但很容通过 DiskGenius 等分区工具跳过密码验证直接进行复制。

基于驱动器加密的工具有 Windows BitLocker、VeraCrypt 等，安全性有保证。

C 盘为操作系统所在盘，一般不建议加密，因为没啥用，而且降低系统运行速度。

要加密你的数据盘，数据盘里可能放有照片或者小电影、或者商业机密文件，这样在电脑送修、硬盘丢弃等场合可以使无关人员无法访问。

没有智能卡，就选 “使用密码解锁驱动器”。恢复密钥（48位纯数字）是你忘记密码需要解锁时用的，这个一定要保存好。如果你电脑登陆有微软账号就选 “保存到Microsoft账户”，这样相当保存到云端了，不容易丢。如果没有可以选择保存到文件或者打印恢复密钥。一般选择保存到文件，注意**恢复文件保存路径选择非加密磁盘**，千万别给保存到加密盘里，那就不起作用了。

已有数据的加密速度比较慢，所以数据盘加密，最好在空盘的时候就设置上，使用后写入数据，不然就只能慢慢等所有数据加密完毕，大硬盘可能得好几个小时。

加密后，磁盘驱动器上会显示一把没有上的锁，这时驱动器是可以打开的。我们需要重启电脑，驱动器锁会彻底锁上，之后的访问需要输入密码或者验证密钥才能打开。

如果要取消 Bitlocker 加密：

在Windows设置视窗中点击 [更新和安全]，左下部有个选项 [设备加密]，点击后选择右侧对应的 [关闭]。

或命令提示符(管理员)

    manage-bde -off D：

关闭设备加密功能的需要一点时间，期间请连接适配器不要关机，也请注意期间不要进入休眠或睡眠。

NOTE：ssd 硬盘不要开启厂商自带的硬件加密功能，这样 Bitlocker 基本给废了

简单说，ssd 硬盘自带硬件加密功能，微软的 Bitloker 虽然属于软件加密方案，但是会直接调用 ssd 硬盘自带的硬件加密接口。

而 ssd 硬盘居然用固件自带的密钥来加密和解密内容，用户在 Bitlocker 里认真输入和保存的密码，其实根本没用上。

    https://www.sohu.com/a/273668088_465914

理论上，ssd硬盘使用的数据加密密钥（DEK），应该以某种加密算法组合所有者的口令短语（passphrase）。没有口令短语，就没有完整的密钥。而实际上，ssd 硬盘作弊了。此外，许多SSD使用单单一个DEK用于整个闪存盘，即使它们可以使用不同密码来保护磁盘的不同部分。

这样黑客或维修人员拿到 ssd 硬盘，使用工厂模式调试接口，用 ssd 硬盘固件自带的密钥解密读取数据即可，或注入恶意代码到 ssd 的固件，绕过密钥检查。别以为谁都拿不到固件密钥，硬件厂商的安全意识都很差，索尼的 ps 游戏机固件密钥就被泄露过导致全球 ps2 游戏盗版泛滥，汽车电子设备密钥泄露更多。三星也出现过类似问题，甚至微软自己，也泄露过安全启动功能的密钥。

如何确定 BitLocker 使用了 ssd 的硬件加密功能

    如果发现自己对某个数据盘加密时没有出现漫长的等待，而是设置在瞬间完成了

解决办法：

    BitLocker 用户，更改首选项以强制执行软件加密

    Windows 10 从 18317 版本开始就默认不再使用 ssd 硬盘厂商自带的硬件加密功能(eDrive)

使用其它的全盘加密软件，在数据落盘之前就进行了加密，ssd 硬盘接触到的是加密后的数据.

    开源的 VeraCrypt

        https://www.veracrypt.fr/code/VeraCrypt/
            https://github.com/veracrypt/VeraCrypt

## 在虚拟机里使用你的日常软件

如何开启虚拟化功能参见章节 [选择开启虚拟化功能]。

如果喜欢下载各种软件，建议在 Windows Sandbox 沙盒里使用，这个是一次性的全隔离环境，不影响你的主机环境，详见章节 [用沙盒运行小工具等相对不靠谱的程序]。

主机环境除了驱动程序不安装任何软件，只做系统更新。日常在虚拟机里使用桌面应用程序，安全性最高，在这里的桌面冲浪吧。

如果你的应用有隔离需求，那就再复制一个虚拟机即可。

简单方案，用 Windows 自带的 hyper-v 安装一个 Windows 10，在这里安装各种cn软件并主力使用。

更高层级的方案，参见章节 [安全使用方案](init_a_server think)。

### Hyper-V

计算机需要虚拟化功能，如何开启虚拟化功能参见章节 [选择开启虚拟化功能]。

如何在 Windows 10 上使用 Hypver-V

    https://www.tenforums.com/tutorials/2087-hyper-v-virtualization-setup-use-Windows-10-a.html

Hyper-V 体系结构

    https://learn.microsoft.com/zh-cn/virtualization/hyper-v-on-windows/reference/hyper-v-architecture

Windows 10+ 在 2020 年代以来，体系架构类似 Xen，混合虚拟化：

    一个 hypervisor 运行在裸机（计算机硬件）上，用特权虚拟机运行操作系统核心称为根分区，提供 Windows 基本功能。

    用虚拟化技术或容器技术封装子分区，托管来宾操作系统。

    用虚拟化技术把很多软件功能隔离出来，比如 Windows 安全中心里的 “隔离浏览（WDAG）”、“内核保护” 等，这样在用户使用无感的前提下，很多容易被外部攻破的功能点都被隔离运行，操作系统整体的安全性大大提高。详见章节 [设置 Windows 安全中心]。

自 Windows 11 强制开启 TPM 2.0 和 安全启动，可以用微软和硬件厂商的密钥把计算机启动部分也进行保护，防止木马程序隐藏在系统引导区，导致开机启动就加载木马程序运行。

#### 开启 hyper-v 对宿主机的负面影响

    https://learn.microsoft.com/zh-cn/virtualization/hyper-v-on-windows/about/#limitations

依赖于特定硬件的程序不能在虚拟机中良好运行

    例如，需要使用 GPU 进行处理的游戏或应用程序可能无法良好运行。

    依赖于子 10 毫秒计时器的应用程序（如实时音乐混合应用程序或高精度时间）在虚拟机中运行时也可能会出问题。

此外，如果已启用了 Hyper-V，在主机中运行这些易受延迟影响的高精度应用程序时可能也会出问题。这是因为在启用了虚拟化后，主机操作系统也会在 Hyper-V 虚拟化层的顶部运行，就如来宾操作系统那样。但是，与来宾操作系统不同，主机操作系统在这点上很特殊，它是直接访问所有硬件，这意味着具有特殊硬件要求的应用程序仍然可以在主机操作系统中运行，而不会出问题。

开启了 Hyper-V 可能会影响待机功能，进而使笔记本电脑待机时间缩短，参见章节 [设备不是 InstantGo]。

#### 开启Hyper-V的增强会话模式策略

    https://learn.microsoft.com/zh-cn/virtualization/hyper-v-on-windows/user-guide/enhanced-session-mode
    https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/enhanced-session-mode

    https://www.tenforums.com/tutorials/57136-turn-off-hyper-v-enhanced-session-mode-windows-10-a.html

开启条件：

    打开 hyper-v 管理器，右键点击本地虚拟化服务器，选择菜单 “Hyper-V设置”，寻找 “增强会话模式” 勾选确定。

    创建虚拟机时要选择“第二代”，虚拟机操作系统安装完成后最好安装客户端代理，见章节 [Hyper-V 安装 Linux 虚拟机也要安装客户机代理工具]。

    增强会话模式要求在 VM 中启用远程桌面。 在“设置”应用或“开始”菜单中，搜索 远程桌面设置。 打开 启用远程桌面 开关。

验证：

    打开Hyper-V管理器，并连接虚拟机，终于看到修改配置的对话框。在 VMConnect 工具栏上的增强会话模式图标检查连接类型。 还可以使用此按钮在基本会话模式和增强会话模式之间切换。

    mstsc 选择要连接的虚拟机，选择“显示选项”。在增强会话模式下，VM 默认可以访问剪贴板和打印机，虚拟机被配置为将音频传输到主机的扬声器。VM 还有权在增强会话模式下访问智能卡和其他安全设备。 因此，可以从 VM 使用更安全的登录工具。 还可以共享其他设备如 USB 设备或驱动器

Hyper-V的“增强会话”功能是一项强大的技术，它极大地提升了虚拟化环境中用户与虚拟机交互的体验。这一功能特别适用于需要高效管理和操作虚拟机的场景，为管理员和终端用户提供了前所未有的便利。

在启用“增强会话”模式后，用户能够享受到一系列高级特性，这些特性显著地扩展了虚拟机与宿主机之间的互操作能力。首先，它支持拖放文件功能，这意味着用户可以简单地通过拖放操作在宿主机和虚拟机之间传输文件，无需使用额外的文件传输工具，从而大大提高了数据传输的效率和便捷性。

此外，“增强会话”还实现了剪贴板的双向共享，使得用户可以在宿主机和虚拟机之间无缝复制和粘贴文本内容。这一功能在需要频繁交换信息的场景中尤为实用，能够显著提升工作效率。

不仅如此，“增强会话”还带来了音频、打印、USB设备接入等多方面的支持。用户可以在宿主机上播放虚拟机中的声音，享受更加丰富的多媒体体验；同时，虚拟机也能访问连接到宿主机的打印机，实现打印作业的轻松完成。此外，USB设备的接入也得到了完美支持，用户可以像操作宿主机上的设备一样，方便地在虚拟机中使用这些设备。

为了实现这些高级功能，“增强会话”模式基于远程桌面协议（RDP）进行连接，并通过VMBus进行数据传输。这种连接方式不仅保证了数据传输的稳定性和高效性，还确保了虚拟机与宿主机之间的安全隔离。

正常情况下，我们启动的Hyper-V虚拟机是没有增强会话功能选项的。即使我们在设置中选择了开启，实则也没有开启。我们需要经过一些特殊手段的处理才能真正看到增强会话功能。

#### 建立 Hyper-V 虚拟机

使用比较简单，就像普通虚拟机操作，类似 VM Ware、Virtual Box

    https://docs.microsoft.com/zh-cn/virtualization/hyper-v-on-Windows/quick-start/enable-hyper-v
    https://learn.microsoft.com/zh-cn/windows-server/virtualization/hyper-v/learn-more/Generation-2-virtual-machine-security-settings-for-Hyper-V

> 虚拟机选 “二代”，开启“安全启动”

    客户机要安装支持安全启动的 Windows，选择模板 “Microsoft Windows”

    客户机要安装支持安全启动的 Linux，选择模板 “Microsoft UEFI 证书颁发机构”(Microsoft UEFI Certificate Authority) <https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-hyperv/>

    若勾选“启用防护”选项会禁用控制台连接、无法迁移虚拟机等。

> 取消勾选 “自动检查点”

    安装完成后手工建立检查点，以防 hyper-v 自动合并导致无法回到初始状态。

> 用检查点备份你的虚拟机的当前状态

    最好关机后创建建立

    在设置中选 “标准检查点”，注意关闭 “自动检查点”，安装完成后手工建立检查点，否则 Windows 总是自动把当前状态合并到你手动建立的检查点。

    建议在完全安装好操作系统后手工建立一个检查点，安装软件后再建立一个，不要再多了。这样即不会占用你大量的硬盘空间，也方便出现问题时回退到干净的系统状态。

#### Hyper-V 安装 Linux 虚拟机

普通使用 Linux 环境，在 Windows 宿主机上使用 WSL2 即可，没必要单独装 Linux 虚拟机，参见章节 [WSL 适用于 Linux 的 Windows 子系统]。

优化 hyper-v 运行 Linux

    https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/best-practices-for-running-linux-on-hyper-v

    https://documentation.ubuntu.com/server/how-to/virtualisation/ubuntu-on-hyper-v/index.html

Linux/FreeBSD 内核已经加入了做为 hyper-v 虚拟机时的驱动：

    https://learn.microsoft.com/en-gb/windows-server/virtualization/hyper-v/Supported-Linux-and-FreeBSD-virtual-machines-for-Hyper-V-on-Windows

    Linux Integration Services (LIS)

    FreeBSD Integration Services (BIS)

##### 安装客户机代理工具

如果用 Hyper-V 安装 Linux 虚拟机，则虚拟机在安装完操作系统后一定要安装客户机代理工具 hyperv-daemons，类似 vmware tools、virtualbox tools、qemu-guest-agent 等，会大大提升系统 IO 速度，改善使用体验：

    Debian：安装 hyperv-daemons 软件包

        hv_fcopy_daemon 文件拷贝服务，主机拷贝文件到虚拟机

        hv_kvp_daemon   KVP服务，主机设置虚拟机的ip网络

        hv_vss_daemon   卷影复制服务 volume shadow copy service (VSS)，主机可以在快照时冻结虚拟机的文件系统

    Fedora：安装 hyperv-daemons 软件包，还可以安装 hyperv-tools 工具包

##### Linux 虚拟机启动“增强会话模式”

    估计都在等 wayland 实现对此的支持，大概3,5年后再看吧

微软对此事并不积极，搞了一阵子放弃了，仅在 Hyper-V 的界面快速创建虚拟机”处选择微软特供版的 Ubuntu 22.04LTS 自带该功能

    https://github.com/microsoft/linux-vm-tools
        https://yanqiyu.info/2020/08/22/enhanced-hyperv-for-fedora/

    Fedora 下的自动化脚本

        https://github.com/secana/EnhancedSessionMode

        https://github.com/hu-ximing/Hyper-V-RHEL-Fedora-enhanced-session

    Ubuntu下的自动脚本

        https://github.com/Hinara/linux-vm-tools/blob/master/ubuntu/24.04/install.sh
            https://www.nakivo.com/blog/install-ubuntu-20-04-on-hyper-v-with-enhanced-session/

可以自己解决：客户机安装 xrdp 并进行一些设置，即可开通对 Hyper-V 的增强会话模式的支持。下面以 Fedora 虚拟机的设置为例：

    https://matthewsanabria.dev/posts/fedora-linux-and-hyper-v-enhanced-session-mode/

    https://nat.io/blog/fedora-enhanced-hyperv

    https://zahui.fan/posts/ssqj2c/

1、安装 xrdp：

    [使用 xrdp 服务端](gnu_tools.md)

2、修改配置文件 /etc/xrdp/xrdp.ini：

```ini
diff --git a/etc/xrdp/xrdp.ini b/etc/xrdp/xrdp.ini
index 0351650..4a7d696 100755
--- a/etc/xrdp/xrdp.ini
+++ b/etc/xrdp/xrdp.ini
@@ -20,7 +20,7 @@ fork=true
 ;   port=tcp6://:3389                           *:3389
 ;   port=tcp6://{<any ipv6 format addr>}:3389   {FC00:0:0:0:0:0:0:1}:3389
 ;   port=vsock://<cid>:<port>
-port=3389
+port=vsock://-1:3389

 ; 'port' above should be connected to with vsock instead of tcp
 ; use this only with number alone in port above
@@ -44,12 +44,12 @@ tcp_keepalive=true

 ; security layer can be 'tls', 'rdp' or 'negotiate'
 ; for client compatible layer
-security_layer=negotiate
+security_layer=rdp

 ; minimum security level allowed for client for classic RDP encryption
 ; use tls_ciphers to configure TLS encryption
 ; can be 'none', 'low', 'medium', 'high', 'fips'
-crypt_level=high
+crypt_level=none

 ; X.509 certificate and private key
 ; openssl req -x509 -newkey rsa:2048 -nodes -keyout key.pem -out cert.pem -days 365
@@ -81,7 +81,7 @@ autorun=
 allow_channels=true
 allow_multimon=true
 bitmap_cache=true
-bitmap_compression=true
+bitmap_compression=false

 bulk_compression=true
 #hidelogwindow=true

```

3、配置 xrdp 服务和放行防火墙：

    sudo systemctl enable --now xrdp
    sudo systemctl enable --now xrdp-sesman

    sudo firewall-cmd --add-port=3389/tcp --permanent
    sudo firewall-cmd --reload

4、将 Fedora 关机，以管理员身份运行 powershell

    C:\> Set-VM -VMName <your_vm_name> -EnhancedSessionTransportType HvSocket

    C:\> Get-VM <VM_NAME> | select EnhancedSessionTransportType

    EnhancedSessionTransportType
    ----------------------------
                        HvSocket

5、验证：

启动虚拟机，连接虚拟机，应该可以看到自动弹出设置分辨率的对话框，然后使用 xrdp 登录到 Linux 桌面使用即可。

可以直接从虚拟机管理器的连接里复制粘贴文件，访问

    https://webglsamples.org/aquarium/aquarium.html

看看帧数，不是 1 帧了。

##### 第 2 代虚拟机上的 GRUB 菜单超时

由于第 2 代虚拟机的仿真中删除了旧硬件，导致 grub 菜单倒计时计时器的倒计时速度太快，无法显示 grub 菜单，因而会立即加载默认条目。 在 GRUB 固定为使用 EFI 支持的计时器之前，请修改 /boot/grub/grub.conf, /etc/default/grub 或等效条目，将其修改为“timeout=100000”而不是默认的“timeout=5”。

    https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/best-practices-for-running-linux-on-hyper-v#grub-menu-timeout-on-generation-2-virtual-machines

#### Hyper-V 虚拟机直连主机USB设备

简单的方法是使用远程桌面客户端 mstsc 时点击设置本地资源，勾选相关 usb 设备即可

    https://learn.microsoft.com/zh-cn/virtualization/hyper-v-on-windows/user-guide/enhanced-session-mode

1、虚拟机需要工作在 “Hyper-V增强会话模式”

开始菜单 -> Windows管理工具 -> Hyper-v 管理器
（Start Menu\Programs\Administrative Tools）

左侧栏目选择点击你的计算机，右侧栏目出现 “Hyper-V 设置”，点击打开窗口

    定位到 “服务器 - 增强会话模式策略” ，确认已勾选 “允许增强会话模式” 。

    定位到 “用户 - 增强会话模式” ，确认已勾选 “允许增强会话模式” 。

这里是两个，一个是对全局的许可，一个是对你当前这个用户的许可，都要许可。

新建虚拟机，注意要选择 “第二代” 虚拟化，然后安装 Windows，来宾虚拟机操作系统版本至少为Windows Server 2012 或 Windows 8。

2、在宿主电脑上开启 RemoteFX(RFX) USB 重定向功能

    在宿主电脑上，按 `win+r` 组合键打开运行窗口，输入 `gpedit.msc` 打开组策略编辑器，依次点击 “计算机配置 -> 管理模板 -> Windows 组件 -> 远程桌面服务 -> 远程桌面会话客户端 -> RemoteFX USB 设备重定向”。

    双击右边的 “允许此计算机中受支持的其他 RemoteFX USB 设备的 RDP 重定向”，设置为已启用，然后将选项中的 “RemoteFX USB 重定向访问权限” 设置为 “管理员和用户”，然后重启宿主电脑使配置生效。

3、增强的会话模式要求在虚拟机中启用远程桌面

首先，使用基本模式重新登录到你新建的虚拟机，在 “设置” 应用或 “开始” 菜单中搜索 “登录选项”。

在此页面上，关闭 “需要 Windows Hello 登录 Microsoft 帐户”。

然后在 “设置” 应用或 “开始” 菜单中搜索 “远程桌面设置”，开启 “启用远程桌面”。

4、在 Hyper-v 管理器中选择连接你新建的虚拟机的时候，如果启用了增强模式，会弹出一个对话框供选择。这时因为增强模式使用RDP远程桌面的方式去连接到虚拟机。点击 “显示选项”，点击标签页 “本地资源”

    在选项框 “本地设备和资源”，点击 “更多”，然后勾选 “其他支持的RemoteFX USB设备” 或者选择自己需要的设备共享到虚拟机中。

    如果要使用摄像头，需要要添加麦克风传递（以便你可以在虚拟机上录制音频），在选项框 “远程音频”，点击 “设置”，对 “远程音频录制” 选择 “从此计算机进行录制”。

验证

    连接到虚拟机后，打开设备管理器，可以发现通用串行总线 USB 设备已经成功接入 Hyper-V 虚拟机。

> 目前我的 Windows 10 Ltsc 2021 版，总是无法使用摄像头自带的麦克风，解决方法是直接使用 “远程桌面 mstsc.exe” 而不是在 Widnows 的虚拟机管理器（Hyper-V Manager）里使用本地控制台连接到虚拟机。

    运行 `mstsc` 远程登陆你的虚拟机，计算机处填写你的虚拟机的计算机名，用户名填写你的虚拟机的登陆用户名，其它选项设置跟第 4 步相同，把主机的设备都选择共享给虚拟机即可，并选择记住密码，以后使用就不需要登陆密码了。

#### hyper-v 虚拟机访问网络需要设置 “虚拟交换机”

默认创建的虚拟机，都没有绑定网络，需要在宿主机上手动设置网络，给虚拟机的网卡分配一个虚拟交换机，使其可以访问网络

    Hyper-V 网络基础知识 https://learn.microsoft.com/zh-cn/windows-server/virtualization/hyper-v/plan/plan-hyper-v-networking-in-windows-server

    Hyper-V 虚拟交换机 https://learn.microsoft.com/zh-cn/windows-server/virtualization/hyper-v-virtual-switch/hyper-v-virtual-switch

    Hyper-V 创建和配置虚拟交换机 https://learn.microsoft.com/zh-cn/windows-server/virtualization/hyper-v/get-started/create-a-virtual-switch-for-hyper-v-virtual-machines?tabs=hyper-v-manager

    创建虚拟网络 https://learn.microsoft.com/zh-cn/virtualization/hyper-v-on-windows/quick-start/connect-to-network

    为 Hyper-V 配置虚拟局域网 https://learn.microsoft.com/zh-cn/windows-server/virtualization/hyper-v/deploy/configure-virtual-local-area-networks-for-hyper-v

    https://www.cnblogs.com/Mopee/p/14696481.html

Hyper-V 虚拟机的两种外网连接方式（网桥式与共享式）。

对此提供了三种网络交换机连接方法：

1. 内部（Internal）：此交换机类型允许在特定主机上的所有虚拟机与物理主机本身之间建立网络连接。无法连接到物理网络上的其他物理机或其他主机上的虚拟机。实现的是共享式连接。

2. 外部（External）：此交换机类型允许在完整网络拓扑中的所有虚拟机之间建立网络连接，以及在这些不同主机上的物理主机和虚拟机之间互连。实现的是网桥式连接。

3. 专用（Private）：专用交换机类型仅允许特定主机上的虚拟机之间进行网络通信，而不允许与物理主机本身进行网络通信。

Hyper-V 默认的虚拟交换机采用的是内部方法， 通过（宿）主机对相应的以太网适配器设置共享， 实现 NAT（Network Address Translator，网络地址转换）共享连接。

宿主机可以上网的有线网卡和无线网卡其设置不同。

##### 桥接模式

网桥式连接方法允许我们通过虚拟交换机桥接本地物理网络和虚拟网卡，而物理网卡和虚拟网卡在拓扑图上处于同一位置。

这种方式是将Hyper-V内部的虚拟网络与外部网络桥接。使得内部外部的IP都在一个网段上。

优点：

    就算是无线网，也可以进行桥接
    IP在一个网段，连通性好，配置方便。

缺点：

    需要占用多个IP
    安全性差

> 宿主机使用有线网卡上网

虚拟交换机设置一个就够了，所有需要访问外网的虚拟机都可以使用它

    打开 hyper-v 管理器，在右侧栏目选择 “虚拟交换机管理器”

    在弹出窗口的栏目选择 “新建虚拟网络交换机”，选择“外部”，点击创建 “创建虚拟交换机”

    在弹出窗口中，“外部网络” 默认选择的是你的有线网卡，根据实际情况选择即可，把名称改为 “有线虚拟交换机”

打开 hyper-v 管理器，选择你的各个虚拟机，右键菜单选择 “设置”，选择 “网络适配器”，选择 “有线虚拟交换机” 即可上外网了。

后遗症

    控制面板\网络和 Internet\网络连接，不能直接在你的有线网卡手工设置 ip 了，要在另一个名为 “vEthernet (有线虚拟交换机)” 的网卡上设置 ip

所以，可以在网络连接窗口添加一个网桥设备，使用桥接到有线网卡的方式

    网桥设备点击右键开源进行设置，可以将上网卡(连接INTERNET)与多个虚拟交换机桥接，分享网络

    虚拟机设置网络适配器，选择该网桥设备即可

> 宿主机使用无线网卡上网

这个使用无线网卡做桥接的方式，hyper-v 一直没做好支持，详见章节 [虚拟机打开网页卡顿甚至超时，到宿主机拷贝速度慢]。

    打开 hyper-v 管理器，在右侧栏目选择 “虚拟交换机管理器”，在弹出窗口的栏目选择 “新建虚拟网络交换机”，选择 “内部网络”，把名称改为 “无线_网桥”

    打开 hyper-v 管理器，在你的虚拟机上点击右键，选择 “设置”->“网络适配器”，窗口右侧的 “虚拟交换机” 选择刚添加的 “无线_网桥”。

    控制面板\网络和 Internet\网络连接，可以看到其中新增了一个未识别的网络，名字一般叫做 “vEthernet(无线_网桥)”，括号中的xxxxx是你刚才创建的内部网络虚拟交换机名字。

    按住 ctrl 选择无线网卡和 “vEthernet(无线_网桥)”，点击右键选择桥接，成功后将会出现一个网桥设备，默认名称就叫 “网桥”

    确认后生效，此时虚拟机即完成了桥接，可以通过无线网卡上网。

    最好重启计算机。

如果不行，尝试设置网卡共享连接的方式，我用这个办法成功了

    https://blog.csdn.net/tototuzuoquan/article/details/121025526

    控制面板\网络和 Internet\网络连接，删除上一步创建的 “网桥”

    选择可以上网的WLAN网络连接，右键 -> 属性 -> 共享选项卡，勾选允许其他网络用户通过此计算机的Internet连接来连接(N)，并在下面的家庭网络连接(H)中选择对应的、刚才新增的 “vEthernet(无线_网桥)”。

    确认后生效，此时虚拟机即完成了桥接，可以通过无线网卡上网。

    最好重启计算机。

##### NAT 模式

这种方式是将Hyper-V内部的虚拟网络与外部网络共享。使得内部是一个私有的网络。属于NAT的类型。

优点：

    相对来说属于私有网络，安全性好
    私有网络不占用公有的IP

缺点：

    只能向外连接，无法从外向内连接。
    如果要在一块网卡上同时使用网桥式方法和共享式方法，需要先添加网桥式的虚拟交换机，然后进行如下操作

默认交换机(Default Switch)的内部网络就是NAT模式，如果没有其他需求，建议直接使用。可以直接上网，利用的是主机的网络栈。

不要修改系统默认设备，最好新建一个：

    打开 hyper-v 管理器，在右侧栏目选择 “虚拟交换机管理器”，在弹出窗口的栏目选择 “新建虚拟网络交换机”，右侧窗口选择 “内部网络”，名称改为 “NAT_有线”

    控制面板\网络和 Internet\网络连接，点击宿主机当前能上网的的网卡，右键-属性-共享

        勾选 允许其他网络用户通过此计算机的internet连接来连接

        家庭网络连接： 选择刚才添加的 “NAT_有线”。

    打开 hyper-v 管理器，在你的虚拟机上点击右键，选择 “设置”->“网络适配器”，窗口右侧的 “虚拟交换机” ，选择刚添加的虚拟交换机 “NAT_有线”

    确认后生效，此时虚拟机即完成，可以通过网卡上网。

    最好重启计算机。

故障排除：

虚拟机在 cmd 窗口执行命令

    `ipconfig /all` 查看是否给分配了ip地址，一般是 192.168.0.x

    `route print` 查看接口网关的 ip 地址，一般是 192.168.0.1

    如果是 169.254.x.x 说明不成功

实在不行，清了重建

    https://www.jianshu.com/p/0338bda7d75b

    以管理员权限执行“命令提示符”，然后运行下面的命令以清理所有的网络设备，注意这将将几乎所有的网络连接都删除（除了可能有几个顽固连接无法删除）：

        netcfg -d

    打开“计算机管理”并选中左边的节点“设备管理器”，点菜单“查看”然后选中“显示隐藏的设备”，在右边找到“网络适配器”节点，并把里面所有的设备全卸载掉（正常情况下，执行上面的一步后不会有网络适配器残留，这一步只是确保会把某些顽固的设备手工移除掉）。

    重启电脑。正常情况下所有的网络适配器在电脑重启后会被自动驱动，如果有没有自动驱动的，手动安装驱动程序，并连接到各自的网络。
    这时候再去配置虚拟交换机应该就能成功了。

如果上面的方法无效，可以试下重试重置 winsock 或 TCP/UDP 堆栈，两条命令分别如下（需要管理员权限）：

    netsh winsock reset

    netsh int ip reset

这里只是提供一个可能的解决方法，因为我没办法验证上面的操作能否实际有效。

##### 虚拟机打开网页卡顿甚至超时，到宿主机拷贝速度慢

hyper-v 虚拟机，使用宿主机的无线网卡建立虚拟交换机的，都有这个情况，虚拟机里上网打开网页卡顿甚至超时、从虚拟机到宿主机拷贝文件速度特别慢等，只要用到无线网卡虚拟交换机的场景，都有这个问题，而微软至今(2025)仍未优化这个性能问题。关联问题是章节 [Windows 访问 samba 速度慢](init_a_server think)。

    解决办法是宿主机用有线连接到路由器，虚拟交换机使用有线网卡就再也不慢了。。。

开启 Hyper-V 的虚拟外部网络交换机之后的内网上传速度长时间卡死在 100 Kbps 左右，最快的时候才 1Mbps，外网上传速度大概只剩下平时的一半。这个问题从 2018 年开始用 Windows10 系统上的 Hyper-V 虚拟机时就遇到了，当时的网卡是 Intel AC9260，后面陆续用过 Intel AX200 、Intel AX211 几款无线网卡的笔记本电脑，都存在同样的问题

    https://zhuanlan.zhihu.com/p/625867441?utm_id=0

    https://learn.microsoft.com/zh-cn/troubleshoot/windows-server/networking/slow-smb-file-transfer

在电脑的设置中找到网络设置，点击高级网络设置，在在右侧界面的下方点击“更多网络设配器选项”，会打开网络连接设置窗口。

选中 Hyper-V 创建的虚拟网卡，如“vEthernet (Ethernet)”，右击网卡，查看属性，然后点击配置按钮。

如下两项设置

    Large Send Offload Version 2(IPV4)

    Large Send Offload Version 2(IPV6)

尝试将这两项设置调整为 Disabled 之后进行测试，内外网的速度都回归正常了。

这个问题的原因，其实就是因为 Hyper-V 创建出的虚拟网卡默认启用了这两个选项，但是我们的 Intel 无线网卡硬件实际上并不支持这两项功能，所以会造成这样一个副作用。可以看到 Intel 的无线网卡的配置界面并没有那两项的配置。顺便查看了台式机的有线网卡，就支持 Hyper-V 虚拟网卡需要的那两项功能。

查看当前传输速度

    任务栏右键，选择任务管理器，打开后选择“性能”选项卡，点击你的虚拟交换机，可以看到当前传输速度的详情。

#### hyper-v 虚拟机启用显卡加速

如果是远程桌面需要显卡加速，使用 mstsc 在连接时选择高速网络，会自动使用 RFX/GFX 技术。

    Windows 远程桌面 从 RemoteFX(RFX) 演进出了 GFX

        https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-rdpegfx/da5c75f9-cd99-450c-98c4-014a496942b0

        https://github.com/neutrinolabs/xrdp/wiki/On-EGFX-architecture-and-Dynamic-Monitors#architecture

    给虚拟机添加和启用 RemoteFX，2019年的文章，过时了

        https://zhuanlan.zhihu.com/p/59086305

虚拟机显卡直通 DDA 目前只支持 Windows Server

    RemoteFX vGPU 被 替换为 DDA 功能了，只支持客户机独占显卡，且主机不能休眠或关机自动保存虚拟机状态

        https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/deploy/deploying-graphics-devices-using-dda

目前看是企业级应用优先，在 Windows Sever 上才有 DDA，M$ 忙着赚 AI 云计算的钱呢。

显卡共享，极客湾介绍远程控制软件 Parsec 作者提供的脚本实现单机多用户可以 N 卡运行

    https://www.bilibili.com/video/BV1Ad4y1S7Aw/?share_source=copy_web&vd_source=05d8dc4a77ef9fa286c09977f5388ce1

        https://github.com/jamesstringerparsec/Easy-GPU-PV

        https://superuser.com/questions/1833989/how-to-share-a-single-gpu-among-multiple-vms-with-parsec-connectivity

    建立 hyper-v 虚拟机时，注意不要开启共享内存，关闭快照功能

##### 强行开启 hyper-v 虚拟机显卡直通

推荐 [在 WSL 中启用显卡加速]，目前在 hytper-v 虚拟机里直通显卡的方案，都是基于 WSL 改的非官方方案。

    https://zhuanlan.zhihu.com/p/335338558
        https://forum.cfx.re/t/running-fivem-in-a-hyper-v-vm-with-full-gpu-performance-for-testing-gpu-partitioning/1281205

首先，将显卡驱动升级到最新版。

新建一个第二代 Hyper-V 虚拟机，设置核心数和内存容量，关闭检查点，打开增强会话模式，并装好 Windows 系统。

为了不经过 Hyper-V 管理器而直接连接虚拟机，可以为以下目标创建快捷方式，今后直接通过快捷方式连接：

    C:\Windows\System32\vmconnect.exe 你的计算机名称 你的虚拟机名称

接着，新建内容如下的 Powershell 脚本，将“Your VM name” 替换成虚拟机的名称，并以管理员身份运行一次。注意，运行一次就够了，而且运行时虚拟机必须关机。

```powershell
param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

'Running with full privileges!'
'Setting GPU-PV...'

$vm = "Your VM name"
# replace the words in double quotation marks with your virtual machine's name
Add-VMGpuPartitionAdapter -VMName $vm
Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionVRAM 80000000 -MaxPartitionVRAM 100000000 -OptimalPartitionVRAM 100000000 -MinPartitionEncode 80000000 -MaxPartitionEncode 100000000 -OptimalPartitionEncode 100000000 -MinPartitionDecode 80000000 -MaxPartitionDecode 100000000 -OptimalPartitionDecode 100000000 -MinPartitionCompute 80000000 -MaxPartitionCompute 100000000 -OptimalPartitionCompute 100000000
Set-VM -GuestControlledCacheTypes $true -VMName $vm
Set-VM -LowMemoryMappedIoSpace 128MB -VMName $vm
Set-VM -HighMemoryMappedIoSpace 8GB -VMName $vm

```

关键代码复制自 Cfx.re Community，原代码最后一行写错了两个短横线，已经改正。如果提示禁止执行脚本，以管理员身份在 Powershell 中执行以下命令：

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

虚拟机开机，在宿主机的以下位置寻找显卡驱动文件夹：

    C:\Windows\System32\DriverStore\FileRepository

以 NVIDIA 为例，文件夹名为“nv_dispsi.inf_amd64_一串字符”，将它复制到虚拟机中的以下目录（如果不存在则手动创建该目录）：

    C:\Windows\System32\HostDriverStore\FileRepository

最后，关闭增强会话模式，重启虚拟机，虚拟显卡工作正常

    增强会话实际上相当于通过 rdp 连接虚拟机，rdp 是本地渲染的，会提高性能，所以叫增强，但 rdp 这个本地渲染支持非常弱，不支持游戏那种复杂 api，所以跑不了游戏，关掉增强会话就是普通 vnc 模式，反而可以运行游戏了。

##### hyper-v 安装 linux 系统，GPU显卡“直通”虚拟机

推荐 [在 WSL 中启用显卡加速]，目前在 hytper-v 虚拟机里直通显卡的方案，都是基于 WSL 改的非官方方案。

    https://zhuanlan.zhihu.com/p/3003643165

写在前面的话：

    为什么不用wsl？因为 wsl 长期使用会占用大量空间，且不易删除。同时 wsl 的某些操作和虚拟机还是有些差异，不适合开发使用。

    为什么不直接用虚拟机？虚拟机无论是vbox还是vmware都无法很好的使用显卡，尤其是在cpu没有核显的时候。

    为什么不装双系统？双系统切换麻烦，大部分时间还是喜欢用 Windows。期望 Linux 最好就是一个命令行的存在。

    为什么直通打引号？因为专业来讲是 GPU 分区方案，并不是直通。

新建二代虚拟机。按照常规方法安装虚拟机，注意设置：

    关闭动态内存

    关闭安全启动（即：不要勾选）

    关闭检查点（即：不要勾选）

配置显卡

1、宿主机查看显卡，找到设备id。设备管理器->显示适配器

如果有核显会列出多个，点击需要使用的GPU，右键选择【属性】。打开后在【详细信息】中选择【硬件Id】。再右键选择复制（后面要用到）。

2、宿主机给虚拟机设置 GPU 设备

管理员权限运行 powershell，输入 Get-VMHostPartitionableGpu 查看当前可分区的设备

```powershell
# 将这里 ubuntu 替换成 hyper-v 中虚拟机的名字（即你要使用GPU的系统）
$vm = "ubuntu"
# 将这里的路径替换成第1步复制的硬件id，或上面 Get-VMHostPartitionableGpu 列出的值
$gpu_path = "\\?\PCI#VEN_10DE&DEV_1381&SUBSYS_84C81043&REV_A2#4&1d81e16&0&0019#{064092b3-625e-43bf-9eb5-dc845897dd59}\GPUPARAV"

# 下面的依次执行即可
Remove-VMGpuPartitionAdapter -VMName $vm
Add-VMGpuPartitionAdapter -VMName $vm -InstancePath $gpu_path

Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionVRAM 80000000 -MaxPartitionVRAM 100000000 -OptimalPartitionVRAM 100000000 -MinPartitionEncode 80000000 -MaxPartitionEncode 100000000 -OptimalPartitionEncode 100000000 -MinPartitionDecode 80000000 -MaxPartitionDecode 100000000 -OptimalPartitionDecode 100000000 -MinPartitionCompute 80000000 -MaxPartitionCompute 100000000 -OptimalPartitionCompute 100000000

Set-VM -GuestControlledCacheTypes $true -VMName $vm
Set-VM -LowMemoryMappedIoSpace 1Gb -VMName $vm
Set-VM -HighMemoryMappedIoSpace 32GB -VMName $vm

```

3、启动虚拟机，验证设备安装成功

    $ sudo lspci -v
    b7f0:00:00.0 3D controller: Microsoft Corporation Basic Render Driver

应该可以看到显卡的信息

4、安装内核

其实在 Windows 更新的高级选项中，勾选“接收其它 Microsoft 产品的更新”，就可以把 wsl 内核保持最新了。

如果想手动更新内核：

    https://learn.microsoft.com/zh-cn/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package

        https://github.com/microsoft/WSL2-Linux-Kernel/releases?q=&expanded=true

搜索你的内核版本，然后下载压缩包。

备注：如果没有完全一样的版本，选一个相近的也可以。或者将内核升级到这里有的版本。

将压缩包解压

    tar -xzf linux-msft-wsl-5.15.153.1.tar.gz

创建一个文件 run.sh，内容如下：

```bash
#!/bin/bash -e
if [ "$EUID" -ne 0 ]; then
    echo "Swithing to root..."
    exec sudo $0 "$@"
fi

apt-get install -y git dkms

cd WSL2-Linux-Kernel-linux-msft-wsl-5.15.153.1
VERSION=7a924ef

cp -r drivers/hv/dxgkrnl /usr/src/dxgkrnl-$VERSION
mkdir -p /usr/src/dxgkrnl-$VERSION/inc/{uapi/misc,linux}
cp include/uapi/misc/d3dkmthk.h /usr/src/dxgkrnl-$VERSION/inc/uapi/misc/d3dkmthk.h
cp include/linux/hyperv.h /usr/src/dxgkrnl-$VERSION/inc/linux/hyperv_dxgkrnl.h
sed -i 's/\$(CONFIG_DXGKRNL)/m/' /usr/src/dxgkrnl-$VERSION/Makefile
sed -i 's#linux/hyperv.h#linux/hyperv_dxgkrnl.h#' /usr/src/dxgkrnl-$VERSION/dxgmodule.c
echo "EXTRA_CFLAGS=-I\$(PWD)/inc" >> /usr/src/dxgkrnl-$VERSION/Makefile

cat > /usr/src/dxgkrnl-$VERSION/dkms.conf <<EOF
PACKAGE_NAME="dxgkrnl"
PACKAGE_VERSION="$VERSION"
BUILT_MODULE_NAME="dxgkrnl"
DEST_MODULE_LOCATION="/kernel/drivers/hv/dxgkrnl/"
AUTOINSTALL="yes"
EOF

dkms add dxgkrnl/$VERSION
dkms build dxgkrnl/$VERSION
dkms install dxgkrnl/$VERSION

```

注意有两个地方需要替换

    WSL2-Linux-Kernel-linux-msft-wsl-5.15.153.1 替换成你解压后的目录

    VERSION 替换成 commit id

执行上面脚本

    bash run.sh

5、安装驱动

将宿主机中 C:\Windows\System32\lxss\lib 的文件拷贝到虚拟机中的 /usr/lib/wsl/lib/

将宿主机中 C:\Windows\System32\DriverStore\FileRepository 的所有子目录拷贝到虚拟机中的 /usr/lib/wsl/drivers/

然后设置权限：

    sudo chmod 555 -R /usr/lib/wsl

配置动态链接库搜索路径并更新

    echo "/usr/lib/wsl/lib" > /etc/ld.so.conf.d/ld.wsl.conf

    sudo ldconfig

如果遇到提示软链接问题，就重新生成一下

    sudo rm /usr/lib/wsl/lib/libcuda.so.1

    sudo ln -s libcuda.so /usr/lib/wsl/lib/libcuda.so.1

验证结果

完成上面步骤，没有报错的话就重启虚拟机。

在虚拟机的命令行运行如下命令：

    # 查看能否正常输出
    ls -l /dev/dxg

    # 查看 GPU 信息
    /usr/lib/wsl/lib/nvidia-smi

创建一个软连接就可以直接使用 nvidia 命令了

    sudo ln -s /usr/lib/wsl/lib/nvidia-smi /usr/local/bin/nvidia-smi

如果报错

    root@hdy-Virtual-Machine:~# nvidia-smi
    Failed to initialize NVML: GPU access blocked by the operating system
    Failed to properly shut down NVML: GPU access blocked by the operating system

说明有三个dx12的核心库缺了，先开个wsl的虚拟机，内核接近的，然后去/usr/lib/wsl/lib里找到libd3d12.so libd3d12core.so libdxcore.so三个库还有libnvoptix.so.1这四个文件，拷进hyperv对应位置就可以了

#### hyper-v 迁移虚拟机

Windows 10 下，建立了一个支持安全启动的 Windows 10 虚拟机，导出到硬盘，从别的机器上导入后，无法启动，提示找不到启动区。

让 hyper-v 帮你重建虚拟机的 UEFI 启动区：

1、关闭虚拟机。在虚拟机的检查点右键选择“设置”-->安全启动，选择  “Microsoft UEFI 证书颁发机构”，确定。

2、重新启动虚拟机，仍然无法启动，关闭虚拟机。

3、在虚拟机的检查点右键选择“设置”-->安全启动，选择  “Microsoft Windows”，确定。

4、重新启动虚拟机，可以进入操作系统正常使用了。

#### 使用 VM Ware、安卓模拟器等虚拟机提示需要关闭 Hyper-V

该问题已经在 2022 版的 Windows 10 中解决了

    开启功能：虚拟机平台 VirtualMachinePlatform 即可支持各虚拟机软件正常运行

Vmware workstation 升级到 15.5.5 版本后就可以兼容 Hyper-V 了，但有限制：必须为 Windows 10 20H1（也叫 2004 版）或更高版本。

当基于独占设计的 Hyper-V 启用后，会持续占用，造成其他基于同类技术的虚拟机将无法启动。且部分虚拟机产品在确认检测到相应情况后还要强行执行，就造成了 Windows 死机蓝屏。

在“启用或关闭 Windows 功能”中卸载 hyper-v 功能后，依旧是提示无法安装或使用虚拟机，因为通常会启用 Hyper-V 的操作有如下几项：

    Hyper-V 平台；

    Windows Defender 应用程序防护，Windows 安全中心：“应用和浏览器保护”，关闭隔离浏览；

    Windows 沙盒；

    Windows 安全中心：设备安全性模块的的内核隔离（内存完整性）；

    Visual Studio 内涉及到设备模拟的虚拟化方案；

所以必须确保以上列表内所有项目被正确关闭后，Hyper-V 平台才能被真正关闭。单纯的进入主板 BIOS 将 Intel VT-x 设为 Disabled 是解决不了问题的。

管理员身份运行命令提示符 cmd

        bcdedit 或 bcdedit /enum all 显示全部

查看校对"Windows 启动加载器"中对应项目的 hypervisorlaunchtype 值

> 没有安装 hyper-V 时

1. 管理员身份运行命令提示符 cmd（如果用 PowerShell，符号{}会导致报错）：

        bcdedit /copy {current} /d "Windows10 No Hyper-V"

2. 将上面命令得到的字符串替换掉下面{}中的 XXX 代码即可

        bcdedit /set {XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX} hypervisorlaunchtype OFF

3. 提示成功后再次输入

        bcdedit

    查看校对"Windows 启动加载器"中对应项目的 hypervisorlaunchtype 值是 Off

4. 重启计算机，出现 Windows 10 启动选择， 就能选择是否启用 Hyper-v：

    Windows10 No Hyper-V”中，可以运行 Vmware 虚拟机，而另一个启动选项运行 Hyper-v。

5. 以后想要删除，因为有了启动菜单，所以可以运行 msconfig 用图形界面来编辑选择了。

注意：这是在没有安装hyper-V时候执行的，{current}的hypervisorlaunchtype是off。

> 已经安装了 hyper-V 时

或者 hypervisorlaunchtype 是 auto

    https://www.zhihu.com/question/38841757/answer/294356882

在复制启动项的时候要注意哪一个启动项是要开启 hyper-V 的，“Windows10 no hyper-V” 是新启动项的描述，有没有 no 不要弄混了。

在执行之后会得到新启动项的标识符，如果修改当前启动项，可以用 bcdedit /set hypervisorlaunchtype off，如果修改非 current 启动项，则需要指明标识符，bcdedit /set {标识符} hypervisorlaunchtype off

Hyper-V 其实也分1代2代，tenforums 的详细说明

    https://www.tenforums.com/tutorials/139405-run-hyper-v-virtualbox-vmware-same-computer.html

### WSL 适用于 Linux 的 Windows 子系统

WSL 属于运行在操作系统上的托管的虚拟机，用户体验上注重跟主机的交互能力，类似 gnome toolbox 的交互式容器，用户可以无缝在 Windows 上运行 Linux 的程序，目前已经开始支持运行 Linux 图形化应用了。

开发工具可以使用 Virsual Studio Code，支持直接打开 WSL 虚机，就像连接 Docker 虚机或远程连接 SSH 服务器一样简单。其它开发工具如 git、docker、数据库、vGpu 加速（<https://developer.nvidia.com/cuda/wsl> ）等也都无缝支持，详见 <https://docs.microsoft.com/zh-cn/Windows/wsl/setup/environment>。

利用 [Windows 10 本地化 Linux 编程接口](gnu_tools.md)，WSL 初始实现的是最基本的命令行应用，各种终端模拟器都可以连接到本地的 WSL 实例，后来利用 WSLg 支持运行图形化应用。

Windows 10 在 2021 年后的版本更新中集成的 WSL 2 使用更方便，原来的 WSL 改名为 WSL 1，基本是被废弃了。

    https://learn.microsoft.com/zh-cn/windows/wsl/about

    https://zhuanlan.zhihu.com/p/377263437

    WSL 1 虚拟机类似于程序层面的二进制转译，没有实现完整的 Linux，但是实现了 Linux 程序可以在 Windows 上运行，但是有些功能如 GUI 实现的有限。可以理解成使用了 MingW/Cygwin 的中间模拟层思路，但不在编译时实现，而是 QEMU 这种运行时转码的实现思路。后来发现坑太大填不满，就搞了个新思路 --- WSL2

        https://learn.microsoft.com/zh-cn/Windows/wsl/compare-versions#full-system-call-compatibility

        话说纳德拉领导的微软这个转型是真好，再不搞什么系千钧于一发的大工程，各功能各自演进，渐进式迭代开发 no 大而全 no 齐头并进。像这个 WSL 其实搞砸了，但没再现当年 Windows LongHorn 式的重大失败，而是另起炉灶开搞 WSL 2，原 WSL 改名叫 WSL 1 保持兼容就完事了，对 Windows 10 的其它体系开发没有任何大影响。

    WSL 2 在底层使用虚拟机（Hyper-V）同时运行 Linux 内核和 Windows 内核，并且把 Linux 完全集成到了 Windows 中，使用起来就像在 Windows 中直接运行 Linux 程序。

    WSL 2 的兼容性比 WSL 1 好，仅 IO 性能不如 WSL 1 快，见下面章节 [混合使用 Windows 和 Linux 进行工作]。

以下讨论 WSL 术语除非特别指出，默认就是 WSL 2。

#### WSL 安装 Linux 发行版

    https://learn.microsoft.com/en-us/Windows/wsl/install

    FAQ https://learn.microsoft.com/zh-cn/windows/wsl/troubleshooting#installation-issues

    WSL 1 和 WSL2 的定制安装只适用于 Windows 10 的老旧版本

        https://learn.microsoft.com/zh-cn/Windows/wsl/install-manual

    Windows Store 图形化安装 Ubuntu 子系统 (WSL)

        https://documentation.ubuntu.com/wsl/en/stable/howto/install-ubuntu-wsl2/#method-1-microsoft-store-application

安装 WSL

1、先开启虚拟化功能，见章节 [选择开启虚拟化功能]

2、默认安装的 Linux 发行版是 Ubuntu

管理员权限打开 PowerShell 或 Windows Command Prompt，运行以下命令：

    # WSL 安装发行版，默认 ubuntu，所以不需要加参数指定 -d Ubuntu
    C:\> wsl --install

    C:\> wsl --set-version 2  # 确保使用 WSL 2

3、下次再运行 `wsl` 命令，就自动进入你安装的 wsl 实例的命令行了。

`wsl` 命令用法见章节 [使用命令行连接到你的 WSL 实例]。

可选安装其它 Linux 发行版：

WSL 下安装的 Linux 发行版比如 Ubuntu，其实是微软发布的适用于 WSL 的基于 glibc 的 Linux 版本，在 Windows 下对 Linux 提供了完全的二进制兼容，Ubuntu 等官方发布的发行版是无法直接使用的

    https://docs.microsoft.com/zh-cn/Windows/wsl/compare-versions#full-linux-kernel

    https://github.com/WhitewaterFoundry/Fedora-Remix-for-WSL

查看当前可用的版本：

    C:\> wsl --list --online
    以下是可安装的有效分发的列表。
    使用 'wsl.exe --install <Distro>' 安装。

    NAME                            FRIENDLY NAME
    AlmaLinux-8                     AlmaLinux OS 8
    AlmaLinux-9                     AlmaLinux OS 9
    AlmaLinux-Kitten-10             AlmaLinux OS Kitten 10
    Debian                          Debian GNU/Linux
    SUSE-Linux-Enterprise-15-SP5    SUSE Linux Enterprise 15 SP5
    SUSE-Linux-Enterprise-15-SP6    SUSE Linux Enterprise 15 SP6
    Ubuntu                          Ubuntu
    Ubuntu-24.04                    Ubuntu 24.04 LTS
    kali-linux                      Kali Linux Rolling
    openSUSE-Tumbleweed             openSUSE Tumbleweed
    openSUSE-Leap-15.6              openSUSE Leap 15.6
    Ubuntu-18.04                    Ubuntu 18.04 LTS
    Ubuntu-20.04                    Ubuntu 20.04 LTS
    Ubuntu-22.04                    Ubuntu 22.04 LTS
    OracleLinux_7_9                 Oracle Linux 7.9
    OracleLinux_8_7                 Oracle Linux 8.7
    OracleLinux_9_1                 Oracle Linux 9.1

如果运气不好：

    无法从“https://raw.githubusercontent.com/microsoft/WSL/master/distributions/DistributionInfo.json”中提取列表分发。操作超时。

解决办法见章节 [茄内无法访问 github 的解决方案](git_usage.md)。

> 安装遇到问题

遇到报错试试下面这个：

    启用“适用于 Linux 的 Windows 子系统”可选功能

        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    启用“虚拟机平台”可选功能

        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    要启用 WSL，请以管理员权限在 PowerShell 运行此命令：

        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

更多的问题，详见 <https://docs.microsoft.com/zh-cn/Windows/wsl/troubleshooting>

> WSL2 的 Linux 是放到当前用户目录下的，占用操作系统盘空间

注意你的 c 盘空间

    %USERPROFILE%\AppData\Local\Packages\CanonicalGroupLimited...

如果需要更改存储位置，打开“设置”->“系统”-->“存储”->“更多存储设置：更改新内容的保存位置”，选择项目“新的应用将保存到”。

##### 安装后的日常维护

Windows 在开始菜单新增了 "WSL Settings"，可以图形界面下设置你的 wsl 实例的运行参数，比如分配cpu、分配内存、网络设置等，很方便。

查看版本号

    $ wsl --version
    WSL 版本： 2.4.12.0
    内核版本： 5.15.167.4-1
    WSLg 版本： 1.0.65
    MSRDC 版本： 1.2.5716
    Direct3D 版本： 1.611.1-81528511
    DXCore 版本： 10.0.26100.1-240331-1435.ge-release
    Windows 版本： 10.0.26100.3476

更新 WSL：

    C:\> wsl --update

如果 wsl --update 进度太慢

    可能是因为默认的wsl --update 是从微软商店下载的，微软应用商店就经常出现网络的问题。在 wsl --update 后面加上 --web-download 就可以从 github 上进行下载

    或者直接手动下载 <https://github.com/microsoft/WSL/releases> 下的 .msi，运行即可安装。

更新 Linux 内核

    通过在设置应用的 Windows 更新部分中选择“检查更新”，确保你拥有最新的内核：

        Windows 更新->“高级”选项，确保启用 “更新 Windows 时接收其他 Microsoft 产品的更新”。

        然后点击“检查更新”，确保你拥有最新的内核

    用户也可以自行升级微软发布的基于 WSL 的 Linux 内核：

        https://learn.microsoft.com/zh-cn/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package

            https://github.com/microsoft/WSL2-Linux-Kernel/releases?q=&expanded=true

更新发行版的软件仓库：

    C:\> wsl
    $ sudo apt update && sudo apt upgrade -y

##### 过时： WSL2 中修改家目录为原生 ext4

目前已经是原生 ext4 文件系统了，以下内容仅供参考。

在 WSL2 中修改家目录为原生 ext4 提升文件读写效率

    https://zhuanlan.zhihu.com/p/693873421

尽管微软推出了如 DevDrive 这般专为提升开发者文件系统效率的工具，然而对于 WSL2（Windows Subsystem for Linux 2）的用户而言，唯有原生的 Linux 文件系统方能无缝处理文件执行权限等诸多问题。

本文将详细阐述在 WSL2 环境中如何利用原生的 Linux 文件系统，从而在诸如管理众多 Git 仓库等复杂场景下，实现更出色的文件读写性能。通过采用原生的 Linux 文件系统，用户不仅能够享受到更高的文件处理速度，还能更好地维护文件的权限和属性，从而提升整体的开发效率。

本文假设：

发行版: Ubuntu 22.04
用户名: yanke
映像存储位置：C:\WSL\data.img

一、以 root 身份进入 WSL2 发行版

打开 非 Windows 开发者深恶痛绝的 Powershell，执行以下命令

    # 停止所有 WSL 发行版
    wsl --shutdown

    # 直接以 root 身份进入 WSL 发行版（不可以使用默认用户进入然后切换 sudo）
    wsl -d ubuntu-22.04 --user root

二、创建一个映像文件，并格式化为 ext4 格式

    # 在 C:\WSL\data.img 位置，创建一个 128G 的文件
    mkdir -p /mnt/c/WSL
    dd if=/dev/zero bs=1M count=128000 of=/mnt/c/WSL/data.img

格式化为 ext4

    mkfs.ext4 /mnt/c/WSL/data.img

三、使用 systemd 挂载映像文件

由于 WSL2 启动顺序的特殊性，不能在 /etc/fstab 中挂载映像文件，只能用 systemd 的 mount 单元挂载

1、挂载映像文件到 /data

    # 创建挂载点
    mkdir -p /data

    # 写入 data.mount 单元文件（注意：单元文件名必须和挂载路径匹配，不然 systemd 会报错）
    cat <<-EOF > /lib/systemd/system/data.mount
    [Unit]
    Description=Mount /data
    Before=umount.target
    After=swap.target

    [Mount]
    What=/mnt/c/WSL/data.img
    Where=/data
    Type=ext4
    Options=defaults,noatime

    [Install]
    WantedBy=multi-user.target
    EOF

立即挂载

    systemctl daemon-reload
    systemctl enable --now data.mount

2、挂载用户目录 /home/yanke

鉴于各种包管理器 (npm,pip,go) 的缓存文件都在用户目录下，最省心的方法是，通过 bind-mount 直接把 /data 的子目录挂载到家目录 /home/yanke

相较于从 /data 子目录中软链接，bind-mount 更加优雅

    # 移动家目录
    mkdir -p /data/home
    mv /home/yanke /data/home/yanke

    # 写入 home-yanke.mount 文件（注意：单元文件名必须和挂载路径匹配，不然 systemd 会报错）
    cat <<-EOF > /lib/systemd/system/home-yanke.mount
    [Unit]
    Description=Mount /home/yanke
    Before=umount.target
    After=swap.target data.mount
    Requires=data.mount

    [Mount]
    Where=/home/yanke
    What=/data/home/yanke
    Type=none
    Options=bind

    [Install]
    WantedBy=multi-user.target
    EOF

立即挂载

    systemctl daemon-reload
    systemctl enable --now home-yanke.mount

四、开始使用

从此之后，使用默认用户进入 Ubuntu 22.04 WSL2 环境后，systemd会自动执行以下操作

    从 C:\WSL\data.img 文件挂载 ext4 文件系统到 /data目录
    挂载 /data/home/yanke 子目录到 /home/yanke，作为用户的家目录

#### 使用命令行连接到你的 WSL 实例

Windows 11 下彻底打通了，不需要做任何设置，在 Windows 命令提示符或 PowerShell 中，或任何其它命令行终端如 git bash(mintty) 中，运行 `wsl` 就可以连接到本机 WSL 的默认实例启动 shell 并执行登录脚本。

建议使用 [Windows Terminal](gnu_tools.md)，配置 wsl 环境使用：

    新建配置文件，从现有的配置文件 "Command Prompt" 复制即可，这个原生Windows终端的刷屏速度是目前最快的

    修改启动命令行： %SystemRoot%\System32\cmd.exe /c wsl --cd ~

    其它可以设置字体、颜色等

    点击保存即可生效

使用时新建选项卡选择 wsl 环境，就自动进入了你本机的 wsl 了。

用 vs code 点击左下角的 "><" 打开远程连接按钮，选择 “连接到 WSL”，即可操作其中的项目文件夹了，使用非常方便。把 .ssh .gnupg 目录都挪到 wsl 里，操作 github 项目也没问题。

##### wsl 命令的用法

    C:\> wsl --help

连接到本机 WSL 的默认实例启动 shell 并执行登录脚本

    C:\> wsl
    $ ls

在当前命令行终端中，直接输入 `wsl shell-command`，就是在本机 WSL 的默认实例中执行 shell-command，并把输出显示到当前的命令行终端。

查看已安装的 Linux 发行版的列表

    C:\> wsl --list 或 wsl -l -v
    Ubuntu
    Debian

直接在本机 WSL 的实例中执行命令，输出是显示在当前命令行终端的

    C:\> wsl cd $HOME;ls

    C:\> wsl cat ~/.bash_profile

切换默认发行版到 Debian，如果安装了多个实例的话

    C:\> wsl --setdefault Debian 或 wsl -s Debian

    在默认发行版 Debian 中运行 npm init 命令
    C:\> wsl npm init

停止 wsl：

    # 在命令行终端下操作
    C:\> wsl --shutdown Ubuntu

    # 在wsl实例内部操作
    $ sudo shutdown now

进入 wsl 即自动启动，很快的：

    C:\> wsl

##### 其它连接 WSL 的工具

以下内容过时了，保留仅供参考。

配置 WSL 环境

    https://github.com/hsab/WSL-config

PowerShell 通过函数包装器，实现在 Windows 命令行使用 Linux 命令，实质是指向了 WSL 虚拟机去执行

    https://devblogs.microsoft.com/commandline/integrate-linux-commands-into-windows-with-powershell-and-the-windows-subsystem-for-linux/

其它连接 WSL 的工具

    mintty 支持连接 WSL

        # https://github.com/mintty/mintty/wiki/Tips#supporting-linuxposix-subsystems
        # mintty 直接使用WSL会话，需要 MSYS2 环境的 /bin 下安装了 wslbridge2
        mintty --WSL=Ubuntu

    独立的 WSLtty，调用 Windows ConPty 接口开发的 mintty，通过 wslbridge 实现调用 WSL 会话

        https://github.com/mintty/wsltty

    ConPtyShell 使用 Windows ConPty 接口利用 PowerShell 实现的 WSL 本地终端

        https://github.com/antonioCoco/ConPtyShell

#### 混合使用 Windows 和 Linux 进行工作

WSL 不仅仅是在命令行终端可以执行 Linux 应用，对操作系统的调用也打通了，也就是说，网络、存储、文件系统等都可以通用了。

    https://learn.microsoft.com/zh-cn/windows/wsl/filesystems

借助 WSL，Windows 和 Linux 工具和命令可互换使用

    从 Linux 命令行（如 Ubuntu）运行 Windows 工具（如 notepad.exe ）

    从 Windows 命令行（如 PowerShell）运行 Linux 工具（如 grep ）

    在 Windows 与 Windows 之间共享环境变量

WSL 下的 Linux 命令区别于某些 PowerShell 下的命令

    PowerShell 对某些 linux 命令是使用了别名，而不是调用的真正的 exe 文件，有没有后缀 .exe 是有区别的！

例如，使用 curl 命令行实用程序来下载 Ubuntu 20.04 控制台命令：

    curl.exe -L -o ubuntu-2004.appx https://aka.ms/wsl-ubuntu-2004

在本示例中，将执行 curl.exe（而不仅仅是 curl），以确保在 PowerShell 中调用真正的 curl 可执行文件，而不是调用 Invoke WebRequest 的 PowerShell curl 别名。<https://docs.microsoft.com/zh-cn/Windows/wsl/install-manual#downloading-distributions>

设置->应用->应用和功能，里面有个“应用执行别名”，点击进去慢慢研究吧，微软净整些逻辑弯弯绕，真烦人啊。

详细列表参见 <https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.2>

##### 在 WSL 中访问 Windows 的本地驱动器

系统会自动为本地计算机上的硬盘驱动器创建装入点：

    /mnt/驱动器号/

通过这些装入点，在 WSL 实例中可以轻松访问 Windows 文件系统。

示例：

在 wsl 下访问你主机的 c:\

    C:\ProgramData> wsl

    $ cd /mnt/c

    $ ls

在 wsl 下显示你的当前目录，在 Linux 下访问的路径

    C:\ProgramData> wsl pwd
    /mnt/c/ProgramData

wsl 显示 WSL 实例的用户目录，在 Linux 下访问的路径

    C:\ProgramData> wsl cd $HOME;pwd
    /home/your_user

虽然在 wsl 下可以同时使用 Linux 的文件系统和 Windows 的文件系统，但是：

    NOTE: 尽量不要跨操作系统使用文件，因为 WSL 2 对跨操作系统的文件的 IO 效率低。

        https://docs.microsoft.com/zh-cn/windows/wsl/filesystems#file-storage-and-performance-across-file-systems

    使用的是 9P protocol file server 实现的两个操作系统的文件交互

        https://devblogs.microsoft.com/commandline/whats-new-for-wsl-in-windows-10-version-1903/

比如在 wsl 下存储文件时，尽量不使用 Windows 的文件系统：

    $ touch /mnt/c/Users/<user name>/Project$   # 对应 Windows 下 C:\Users\<user name>\Project

而是使用 wsl 实例自己的文件系统：

    $ touch /home/user/Project/xxx.txt

概况起来就一句话：

    wsl 下读写 Windows 文件系统，只限小量文件临时用用，复杂的项目文件、大文件还是在各自操作系统下单独挂载使用。

###### plocate 避坑

plocate 会自动在每日凌晨扫描你硬盘上的文件，但对 wsl2 环境来说，扫宿主机硬盘 io 效率低而且其默认配置没有避开 Windows 系统目录，执行 `locate wow64` 看看它收集了多少宿主机上没有用处的文件吧

    https://zhuanlan.zhihu.com/p/706874850

Debian 系单独安装 plocate 软件包，安装时会自动执行 `updatedb`，就卡死在扫描宿主机硬盘上了。

Fedora 系内置了该软件，但每日凌晨 `updatedb` 扫描宿主机硬盘，也会是个负担。

确认下数据库不会很大

    $ ls -lh /var/lib/plocate

所以，必须修改配置文件 /etc/updatedb.conf，让 `updatedb` 不要去扫描 Windows 宿主机的目录。

    PRUNEFS="drvfs NFS afs autofs binfmt_misc ..."

[20240703.4a] 这 "drvfs", 指的是 /mnt/c, /mnt/d 这些路径用的 "file system type", 敲 mount 命令查询可知. 然而, 这么写却没有效果, 稍后 sudo updatedb 一运行, Procmon 依然看到巨量的 C: 扫描动作. 不知为何, 网搜无果. 只好先用 /mnt/c  ... /mnt/z 这 26 个路径加入 `PRUNEPATH` 配置项将就着。

##### 在 Windows 下使用 wsl 实例里的文件或目录

NOTE: WSL 跟网络相关的功能都不稳定

    只传输小文本文件，可以肉眼发现文本有乱码的那种文本文件

    可以用来看视频，不在乎网络质量

    我的主机是无线连接，在 wsl 下 sftp 传输个 10GB 的 tar 包总是中断，cp -r 拷贝大批量文件到远程 nfs 各种卡住（断连了），最后用 u 盘解决的。。。

    在 wsl 里连接外网也经常不稳定

使用映射网络地址的方式

    \\wsl$\<wsl实例名>\your\directory

在资源管理器里就可以打开这个网络驱动器里的文件或目录使用了，读写都可以

    \\wsl$\ubuntu\home\<user name>\Project

###### Windows 资源管理器通过 WSL 使用远程 nfs 文件系统

    2025.4 我在 Windows 11 里大数据量拷贝，从 \\wsl$\ubuntu\mnt\nfs 到 Windows 本地驱动器，对链接文件处理不了，提示文件覆盖还是改名，如果选择改名会重复循环无穷尽的复制，我没再试选择覆盖会怎样，估计会无穷尽的覆盖。选择“跳过”，舍弃该链接文件就 ok 了。

    2025.4 我在无线连接的计算机上拷贝大数据量文件到远程 NFS，总是卡住，其实是断连了

nfs 文件系统比较特殊，虽然 Windows 原生支持挂载远程 nfs 文件系统，但是：

    Windows 操作系统自带的 `mount` 命令，只支持 2010 年的 nfs v3 版本

变通的方法，在 wsl 实例中操作，使用 Linux 自带的 `mount` 命令挂载远程 nfs 文件系统，然后在 Windows 资源管理器映射网络驱动器到 wsl 实例的路径使用：

1、进入 wsl 实例，挂载远程 nfs 路径 192.168.0.22:/remote/resource 到指定的本地目录 /mnt/22_nfs

    C:\> wsl

    $ sudo apt install nfs-common

    $ sudo mkdir -p /mnt/22_nfs

    $ sudo mount -t nfs -o vers=4,rsize=1048576,wsize=1048576 192.168.0.22:/remote/resource /mnt/22_nfs

如果挂载命令执行时报错：mount.nfs: Operation not permitted for xxx

    修改 nfs 服务器设置，给你的导出目录增加选项 insecure

原因见章节 [Window 下的 NFS 客户端](init_a_server.md think)，看来 wsl 里使用的 Linux 发行版还是微软特色版，细节上跟普通的 Linux 发行版有差异。

2、在主机 cmd 或 power shell 等终端下，获取当前 wsl 发行版的名称：

        C:\> wsl -l -v
        Ubuntu

3、打开 Windows 资源管理器，添加一个网络位置或映射网络驱动器，填写 wsl 中的路径：

    \\wsl$\Ubuntu\mnt\22_nfs

然后在 Windows 资源管理器中就可以像访问本地硬盘一样访问远程服务器上的 nfs 文件系统的内容了。

##### WSL 访问 Windows 的内网

别给自己找麻烦，虚拟机装个 Linux 用得了

    https://learn.microsoft.com/zh-cn/windows/wsl/networking

    https://www.cnblogs.com/netWild/p/18503950

默认情况下，WSL 使用基于 NAT 的体系结构，与宿主机处于不同的网段。

在 Windows 10 18945 的改进是可以使用localhost, 访问 WSL 的网络服务

    C:\> wsl

    $ python3 -m http.server
    Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...

    本机打开浏览器访问 http:\\localhost:8000 即可

这导致 WSL 无法直接访问 Windows 的内网。要将 WSL 接入局域网,并与宿主机位于同一网段内，实现局域网的其他主机上直接访问 WSL，比较麻烦

    https://blog.csdn.net/song19891121/article/details/138304972
    https://zhuanlan.zhihu.com/p/425312804

    将 WSL 的网络模式设置为 bridge，分配给 WSL 的静态 IP 地址

    配置 WSL 内部的网络设置，给内部网卡分配静态地址和路由到 Windows 主机在局域网中的 IP 地址，并把 /etc/resolv.conf 指向 Windows 主机在局域网中的 IP 地址

Windows 11+ 的 WSL 引入了镜像模式网络

    https://learn.microsoft.com/zh-cn/windows/wsl/networking#mirrored-mode-networking

启用镜像网络后，WSL 和 Windows 主机将使用相同的网络，并且可以通过 localhost 访问本机系统上的服务。实现在 WSL2 中访问本机系统上运行的应用程序，以及通过本机系统访问在 WSL2 中运行的应用程序。

    NOTE: 该方式微软实现的并不稳定，一个不高兴都能自动变回 NAT 模式，好像 WSL 跟网络相关的功能都不稳定。

目前实现的功能：

    IPv6 支持
    使用 localhost 地址 127.0.0.1 从 Linux 内部连接到 Windows 服务器。 不支持 IPv6 localhost 地址 ::1
    改进了 VPN 的网络兼容性
    多播支持
    直接从局域网 (LAN) 连接到 WSL

配置

在Windows的资源管理器的地址栏输入： %UserProfile% ，即可打开当前用户的主目录，创建文件： .wslconfig

```ini
[wsl2]
memory=4GB                        # 分配给 WSL 2 的内存大小
processors=2                      # 分配给 WSL 2 的 CPU 核心数
localhostForwarding=true          # 是否启用 localhost 转发

[experimental]
autoMemoryReclaim=gradual         # 开启自动回收内存，可在 gradual, dropcache, disabled 之间选择
networkingMode=mirrored           # 开启镜像网络
dnsTunneling=true                 # 开启 DNS Tunneling
firewall=true                     # 开启 Windows 防火墙
autoProxy=true                    # 开启自动同步代理
sparseVhd=true                    # 开启自动释放 WSL2 虚拟硬盘空间

```

重启 WSL，管理员身份运行 PowerShell：

    wsl --shutdown

    wsl

之后就可以在 wsl 中使用 localhost 的方式来访问宿主机上的服务了。

    curl http://localhost

宿主机访问 wsl服务需要配置 Hyper-V 防火墙设置，从而允许入站连接，使用管理员权限在 PowerShell 窗口中运行以下命令

    Set-NetFirewallHyperVVMSetting -Name '{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}' -DefaultInboundAction Allow

    或 New-NetFirewallHyperVRule -Name "MyWebServer" -DisplayName "My Web Server" -Direction Inbound -VMCreatorId '{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}' -Protocol TCP -LocalPorts 80。

##### 图形化 GUI 应用的混合使用

WSL 默认使用 WSLg 支持 Linux GUI 应用，简单使用的场景下不需要安装 Linux 桌面环境。

    https://learn.microsoft.com/zh-cn/windows/wsl/tutorials/gui-apps

比如，在 wsl 终端下用命令安装 firefox 后，直接运行 `firefox` 命令，即可在 Windows 桌面下使用火狐浏览器。而且还会自动在 Windows 的开始菜单创建快捷方式，方便用户使用，如：

    C:\Users\mm\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Ubuntu

        "C:\Program Files\WSL\wslg.exe" -d Ubuntu --cd "~" -- firefox

###### 运行完整的 Linux 桌面环境

如果一定要在 Windows 下使用 Gnome 桌面，安装过程如下：

更新 WSL 内核：

    wsl --update

更新并安装 GNOME

在 WSL 终端运行：

    # 更新发行版的软件仓库
    $ sudo apt update && sudo apt upgrade -y

    # 安装完整 GNOME 桌面
    $ sudo apt install ubuntu-desktop -y
    # 或最小化安装（仅核心组件）：
    # sudo apt install gnome-session gdm3 -y

配置 WSLg 自动启动 GNOME

WSLg 默认支持 GUI 应用，但 GNOME 需要额外配置：

（1）修改 ~/.bashrc 或 ~/.zshrc

    if [[ -z "$DISPLAY" && "$(tty)" == "/dev/tty1" ]]; then
    exec dbus-run-session -- gnome-session
    fi
    （这会在登录时自动启动 GNOME）

（2）启动 GNOME

方法 1：直接运行 gnome-session：

    dbus-run-session -- gnome-session

方法 2（推荐）：使用 systemd（需配置 systemd 支持，见下文）。

GNOME 依赖 systemd 管理服务（如网络、声音等），但 WSL 默认不启用 systemd。

解决方法：

（1）手动启用 systemd
在 /etc/wsl.conf 添加：

    [boot]
    systemd=true

然后重启 WSL：

    wsl --shutdown
    wsl -t <发行版名称>  # 如 Ubuntu-22.04

（2）验证 systemd

    systemctl status  # 应显示运行状态
    sudo service gdm start  # 启动 GNOME 显示管理器

运行 GNOME 桌面

（1）启动 GNOME

在 WSL 终端运行：

    dbus-run-session -- gnome-session

或（如果已启用 systemd）：

    sudo service gdm start  # 启动 GNOME 显示管理器

GNOME 桌面会自动出现在 Windows 桌面上。

（2）登录 GNOME

如果使用 gdm，会显示登录界面（需 WSLg 支持）。

默认情况下，GNOME 会直接启动。

优化体验

（1）音频支持

WSLg 默认支持 PulseAudio，但可能需要额外配置：

    sudo apt install pavucontrol -y  # 音量控制
    pavucontrol  # 调整音频设备

（2）输入法（如中文）

安装 ibus 或 fcitx：

    sudo apt install ibus ibus-libpinyin -y
    ibus-setup  # 配置输入法

（3）GPU 加速

WSLg 默认启用 OpenGL 加速，如需 Vulkan：

    sudo apt install mesa-vulkan-drivers -y
    vulkaninfo  # 验证支持

#### 在 WSL 中启用显卡加速 CUDA Toolkit

深度学习起始自 Linux 平台，nvidia 通过 CUDA Toolkit 支持训练，这样 pytorch 等才可以调用 cuda 相关函数进行加速，因为这个历史原因，很多程序都是 Linux 专有的，在 Windows 上无法运行。微软通过 WSL 在 Windows 下给 Linux 提供了运行环境，nvidia 顺势实现了在 wsl 实例中可以运行的 CUDA Toolkit，这样你就可以在 Windows 的 wsl 实例下运行那些 Linux 专有的深度学习训练程序了。

    在 WSL 中启用 NVIDIA CUDA https://learn.microsoft.com/zh-cn/windows/ai/directml/gpu-cuda-in-wsl

    适用于 Linux 的 Windows 子系统 (WSL) 上的 CUDA https://developer.nvidia.com/cuda/wsl

    WSL 上的 CUDA 社区论坛

        https://forums.developer.nvidia.com/c/accelerated-computing/cuda/cuda-on-windows-subsystem-for-linux/303

1、下载并安装支持 CUDA 的 WSL 驱动程序

目前 WSL 中默认通过 WSLg 支持 CUDA，在宿主机的 Windows 操作系统中安装过 nvidia 显卡驱动程序即可，不需要在 wsl 实例中安装了。

2、确认 WSL 实例的内核版本

安装上述驱动程序后，请确保启用 WSL 并安装基于 glibc 的分发版，例如 Ubuntu 或 Debian。

需要 Linux 5.10.43.3 或更高版本的内核版本，可以通过在 PowerShell 中运行以下命令来检查版本号：

    $ wsl cat /proc/version

3、安装 WSL 上的 NVIDIA CUDA Toolkit

    https://docs.nvidia.com/cuda/wsl-user-guide/index.html#cuda-support-for-wsl-2

    https://developer.nvidia.com/cuda/wsl/download

WSL 版下载直达

    https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_local

会列出一堆命令，在命令行终端中进入你的 wsl 实例，粘贴这些命令，执行即可。

文件比较大，下载和安装需要一定的时间，耐心等待。

3、开始使用 CUDA

在 WSL 中安装 PyTorch 或 TensorFlow

    https://pytorch.org/get-started/locally/

    https://www.tensorflow.org/install/gpu

注意事项

驱动、CUDA、cuDNN、框架四者版本必须严格匹配

    NVIDIA 驱动版本需支持目标 CUDA 版本（例如 CUDA 12.x 需要驱动版本≥525.60）。

    cuDNN 必须与 CUDA 版本对应（例如 CUDA 11.8 对应 cuDNN 8.7.x）。

    深度学习框架（如PyTorch/TensorFlow）可能仅支持特定 CUDA 版本（如 TensorFlow 2.15 仅支持CUDA 12.0）。

    访问框架官网查看支持的CUDA版本（如TensorFlow版本表）。

    通过NVIDIA文档确认CUDA与cuDNN的兼容性。

CUDA 安装路径不要包含中文或空格

    默认路径为：C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8 (11.8 为 CUDA 的版本）
自定义路径可能导致环境变量配置错误

#### WSL 下使用 NVIDIA Container Toolkit

没有官方支持，都是网友自己写的

    https://blog.csdn.net/m0_63070489/article/details/145798161

    https://zhuanlan.zhihu.com/p/694392785

1、宿主机需要安装 Docker Desktop，并配置它使用 WSL，详见章节 [使用基于 WSL2 的 Docker]。

2、在 wsl 实例中安装 NVIDIA Container Toolkit

    https://github.com/NVIDIA/nvidia-container-toolkit
        之前是 https://github.com/NVIDIA/nvidia-docker 已废弃

在 wsl 实例中的安装过程跟 Linux 中一致，参见章节 [使用 CUDA 容器 nvidia-container-toolkit](init_a_server think)。

3、在 wsl 实例中给 docker 追加 NVIDIA runtime 配置：

    $ sudo nvidia-ctk runtime configure --runtime=docker

打开宿主机 Docker Desktop 的 Settings-->Docker Engine，将 NVIDIA runtime 配置添加到 docker 的配置中，新增如下部分：

```json
{
// ...
  "runtimes": {
    "nvidia": {
      "args": [],
      "path": "nvidia-container-runtime"
    }
  }
// ...
}

```

然后重启 Docker Desktop。

4、验证：命令行终端进入你的 wsl 实例

执行以下命令，正常情况下会输出 nvidia 显卡信息【表示本机的Docker可使用GPU】，如图所示

    $ sudo docker run --rm --gpus all nvidia/cuda:12.6.3-base-ubuntu24.04 nvidia-smi

运行带 NVidia 引擎的容器

    $ sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi

另外注意 docker 拉 nvidia/cuda 镜像时，拉取的 cuda 版本不能高于本地的 cuda 版本。

    我本地的 cuda 版本是 12.7，则我无法拉取镜像 docker pull nvidia/cuda:12.8-base-ubuntu24.04，因为这个镜像的 cuda 版本是 12.8

要是各种办法都不行，则只能不使用 Docker Desktop 了，在 wsl 实例的内部安装 Docker 和 nvidia container toolkit，这样是把 wsl 当虚拟机用法了。

### 使用 Docker

    https://docs.microsoft.com/zh-cn/Windows/wsl/tutorials/wsl-containers

docker 现在可以运行在 WSL2 的 Linux 实例里：Windows 10+ 上的 docker 是基于 WSL2 或 Windows 容器模式(Hyper-V) 实现的，在 Windows 7 上 docker 是安装了 virtual box 虚拟机在其上运行的。

Windows 7 在 2023 年还提供了虚拟机使用的版本

    https://www.microsoft.com/en-us/download/details.aspx?id=11887

另外可以单独安装 podman，在 Windows 和 MacOs 上以虚拟机运行 Linux 容器，见章节 [在 Windows 或 MacOs 上运行 podman 容器](virtualization think)。

> 区分 Windows 容器和 WSL 内的 Linux 容器

1、Windows 容器

微软开发的初衷是用于企业级云部署，个人使用等于是 Windows 里装了个 Windows，不如在 WSL 下使用 Linux 容器

    https://docs.microsoft.com/zh-cn/virtualization/Windowscontainers/about/

Windows 容器提供了两种不同的运行时隔离模式：

    Hyper-V 隔离模式

    process 模式

process 模式只在 Windows server 版提供 <https://docs.microsoft.com/zh-cn/virtualization/Windowscontainers/manage-containers/hyperv-container>。

另外，Windows 容器的镜像有区别，具备完整 Windows API 的是 Windows 和 Windows Server，其它的 Windows 版本仅支持 .net，注意不同映像的区别

    https://docs.microsoft.com/zh-cn/virtualization/Windowscontainers/manage-containers/container-base-images

基于 Windows 容器的各种容器比较少，更适合企业级云部署等专用场合。

2、WSL2 内的 container 是 Linux 容器，不是 Windows 容器

对应的，在 Windows 下 docker 也有两种运行模式：

    Windows container mode

    Linux container mode，这个模式基于 WSL2 可以使用所有的 Linux 容器，兼容性满分

#### 使用基于 WSL2 的 Docker

安装使用 Docker Desktop for windows

    https://docs.docker.com/desktop/features/wsl/

1、下载安装 Docker Desktop for windows

2、确认 Docker 使用你的 wsl2

    https://docs.docker.com/desktop/features/wsl/#turn-on-docker-desktop-wsl-2

启动 Docker Desktop for Windows，点击 “设置” 按钮，设置如下几个功能。

安装后，在 cmd 或 power shell 下可以使用 `docker` 命令。

在 wsl 下可以使用 `docker` 命令：

    General：确认勾选了基于 WSL2 的引擎复选框 “Use the WSL2 based engine”

    Resources：WSL Integration，这是设置要从哪个 WSL2 发行版中可以访问 Docker，确认勾选了 “Enable integration with my default WSL distro”，还需要勾选 “Enable integration with additional distros”，选择你安装的 distro，一般是 Ubuntu

        如果 WSL integration 不可用，那就是 docker 处于 “Windows container” 模式了，右键点击任务栏的 docker 图标，选择 “Switch to Linux containers” 即可解决这个问题。

3、点击按钮 “Apply & restart”，重启 Docker desktop for Windows

重启完成后验证：

    在 Windows 终端中，执行 `docker` 命令

    在 wsl 终端中，执行 `docker` 命令

### Windows安卓子系统WSA

    https://docs.microsoft.com/en-us/windows/android/wsa/

`Windows Subsystem for Android(WSA)` 在 Windows Store 安装 apk 时会默认安装，Windows 11 自带，目前Windows 10 无法正常运行。

免美区免亚马逊安装 Windows Subsystem for Android

    https://cloud.tencent.com/developer/article/1987523
    https://zhuanlan.zhihu.com/p/437231485

## 其它常见问题

### 操作系统对旧cpu的支持

实体机 UEFI 安装 Windows 7 ，最后支持的 cpu 是 Intel i7 7700k + z170 芯片组主板，而且 Windows 安装镜像文件需要打上 usb3.1 的补丁，否则只能用 Intel i7 6700k。现在网络上改版的 Windows 8 支持到 8700k 和 9900k，只能在 CSM 模式下安装，需要适配的驱动。

Intel i7 11700k 之后的 cpu 不再支持 Windows 98 虚拟机。

12 代酷睿处理器开始引入了大小核心混合架构，需要操作系统适应，自身也要根据具体的应用程序情况进行发展，预计至少到 15 代酷睿以后才能大致稳住技术架构。

2025年更新：没有 15 代酷睿，英特尔至今只发布了笔记本专用的 酷睿 Ultra，品牌大更换，看来英特尔是要完。

### 老显卡不支持 DP 口开机显示（Nvidia Geforce 1080 系）

UEFI 启动模式下，操作显卡的方式也有变化，需要显卡支持 “UEFI GOP VBIOS”。

最简单的识别方法就是使用 gpu z 软件，查看 uefi 选项有没有打勾

GOP 是 UEFI Spec 规定的标准接口，GOP 驱动非常简单，因为不需要做 2D，3D 运算。主要就是 bitblt 动作，在 framebuffer 里面贴贴图和与显示器商量一下分辨率，现代主板的 UEFI BIOS 会内置 GOP 显卡驱动。

如果是外插的显卡，分为两种情况：

    显卡带老式 OpRom，只要主板的 UEFI BIOS 使用 CSM 模式，就可以驱动 opROM，我的 Nvidia Geforce 1080 接 HDMI 口可以安装 Windows，后来的解决方法见 [一劳永逸方案：Nvidia 显卡可以升级固件解决这个问题]。

    显卡带有新式 GOP 驱动的 VBIOS 则没有问题，开机时不会黑屏。

#### 简单方案：连接 HDMI 口安装 Windows

主板 BIOS 设置为 GPT + UEFI 的情况下只能连接 HDMI 口安装系统。

我的技嘉主板的 BIOS 设置中，默认 BOOT 选项采用的是 GPT 分区 + UEFI 引导，制作启动 u 盘时也选择一致的模式，这样才符合 Windows 11 的安装要求（用 rufus 制作 Windows 10 安装 u 盘，选择分区类型是 GPT（右侧的选项自动选择 “UEFI(非CSM)”）而不能是 MBR，这样的启动 u 盘才能顺利启动）。

有些如 Nvidia gtx 1080 时代的显卡，如果主板设置为 UEFI 模式，则连接 HDMI 口可以正常显示，而连接 DP 口则不兼容，很多主板在 UEFI 模式引导失败时会自动切换到使用 CSM 模式

    这样安装 u 盘可以启动系统，但是重新连接 DP 口在开机的时候会黑屏无显示，安装操作系统时只能连接 HDMI 口。

    这种情况出现的最大特点就是开机后长时间黑屏等待，然后才出现 Windows 开机画面。原因在于主板在 UEFI 启动引导超时后自动调整为 UEFI CSM 模式继续引导操作系统启动。所以在主板的 BIOS 设置中改为 UEFI CMS 模式后开机启动就很快，不会再出现这个现象。

    这样安装 Windows 的一个缺点是操作系统不支持 SecureBoot 功能，参见章节 [安装 Windows 启用 Secure Boot 功能]。

#### 一劳永逸方案：Nvidia 显卡可以升级固件解决这个问题

先把显卡挂到别的能显示的机器上，或先连接 HDMI 口安装 Windows，进入系统后，升级下固件，以后就可以实现连接 DP 口在 UEFI 模式下安装 Windows 10 了

    https://www.tenforums.com/graphic-cards/144258-latest-nvidia-geforce-graphics-drivers-Windows-10-2-a.html

        https://www.tenforums.com/Windows-10-news/111671-nvidia-graphics-firmware-update-tool-displayport-1-3-1-4-a.html

            Geforce 1080 系 https://www.nvidia.com/en-us/drivers/nv-uefi-update-x64/
            Geforce 3080 系 https://nvidia.custhelp.com/app/answers/detail/a_id/5233/

#### 凑合方案：主板 BIOS 设置为 CSM 方式安装 Windows 可以连接 DP 口

用 Rufus 制作 Windows 10 安装 u 盘，如果分区类型选择 MBR（右侧选项自动选择“BIOS+UEFI(CSM)”），则也只能连接 HDMI 口安装系统。

这时如果想使用 DP 口开机显示，则主板 BIOS 要更改设置，CSM 模式要选 “Enable”，并设置兼容模式：

    重启开机后按 F2 进入 bios，选 BOOT 选项卡，找到 Window 10 Features，选 “other os”

    之后下面出现了 CSM Support， 选“Enable”，

    之后下面出现的三项，除了网卡启动的那个选项不用管，其它两个关于存储和 PCIe 设备的选项要确认选的是“UEFI”，这样在“other os”模式下可以实现 DP 口的开机显示，要是还不行，那两个选项直接选非 UEFI 的选项。

这样安装 Windows 后是 CSM 模式的，不支持 UEFI SecureBoot 功能，如果是安装 Windows 11 会进行不下去。

关于主板 BIOS 设置 CSM 模式可以启动 DP 口的解释 <https://nvidia.custhelp.com/app/answers/detail/a_id/3156/kw/doom/related/1>

### 主板 Ultra Fast 启动无法再用键盘进入 BIOS 设置

很多支持 Fast Boot 的主板，在主板 BIOS 的“Fast Boot”项设置了“Ultra Fast”之后，在开机过程中不能用按F1进入 BIOS 设置了，解决办法是在操作系统的关机菜单中，重启选项中选择引导到 UEFI 固件设置，Windows 在点击重启时按住 shift 键即可。

对技嘉 B560M AORUS PRO 主板来说，实际试了一下，没感觉到 Ultra Fast 比 Fast Boot 快。
而且我的 usb 键盘鼠标网卡都挂在显示器集成的 usb hub 上，设备比较多，开机时 UEFI 加载这堆驱动没法跳过，没什么用的感觉。

UEFI 方式启动的操作系统是跟主板 BIOS 设置密切结合的，UEFI 的“Fast Boot”分几个选项，导致了初始化部分设备的限制：

    主板 BIOS 设置的“Fast Boot”项如果开启“Fast”选项，可以减少硬件自检时间，但是会存在一些功能限制，比如 Fast 模式下不能使用 USB 设备启动了，因为这个加速功能其实是在 BIOS 自检中禁止加载 USB 设备了。

    主板 BIOS 设置的“Fast Boot”项如果开启“Ultra Fast”选项，之后就不能用键盘进入 BIOS 了，估计跟 Fast 模式一样把大部分不是必须的自检过程给禁用了，所以要想进 BIOS 只能清空 CMOS 或者在操作系统里选择“重启到 UEFI”。

与此功能关联的是 Windows 电源选项中的 “快速启动”，详见章节 [开启或关闭“快速启动”]。

参考说明

    https://www.expreview.com/22043.html

    https://www.tenforums.com/tutorials/21284-enable-disable-fast-boot-uefi-firmware-settings-Windows.html

#### 在 Windows 10 中指定重启到 UEFI 固件的步骤

点击“开始”菜单—选择“设置”，点击“更新和安全”，在“更新和安全”界面中点击左侧的“恢复”选项，再在右侧的“高级启动”中点击“立即重新启动”。

Windows 10 重启之后你将会看到出现一个界面提供选项，选择“疑难解答（重置你的电脑或高级选项）”

新出现的界面选择“高级选项—>UEFI 固件设置”，重启之后就可以直接引导到 UEFI 了。因为现在的BIOS都是UEFI BIOS，也就是自动进入 BIOS 设置了。

参考 <https://docs.microsoft.com/zh-cn/Windows-hardware/manufacture/desktop/boot-to-uefi-mode-or-legacy-bios-mode>

#### Linux 指定重启到 UEFI 固件的步骤

Linux 也可以在重启时告诉系统下一次启动进入 UEFI 设置。使用 systemd 的 Linux 系统有 systemctl 工具可以设置。

    https://www.freedesktop.org/software/systemd/man/systemctl.html#--firmware-setup

可以查看帮助：

    $ systemctl --help|grep firmware-setup

    --firmware-setup Tell the firmware to show the setup menu on next boot

在命令行执行下面命令即可在下一次启动后进入 UEFI 设置:

    $ systemctl reboot --firmware-setup

### 网络唤醒功能（WOL---WAKE ON LINE）

    https://wiki.archlinux.org/title/Wake-on-LAN

家庭内网用一个低功耗 IOT 设备持续运行，响应外部指令，唤醒内网计算机。

1、主板设置 BIOS

    https://www.asus.com.cn/support/FAQ/1045950

    https://www.gigabyte.cn/Motherboard/B560M-AORUS-PRO-rev-10/support#support-dl-driver

    https://zhuanlan.zhihu.com/p/458830886

    WOL各模式说明
        https://www.zhihu.com/question/366699701/answer/3287840128

根据产品规格指出，此产品有提供网络唤醒 (Wake On LAN) 的功能，但是找不到相关设定或是开关可以启用该选项。

    注意，有些机器可能为Wake On Lan或Wake On PCI Card。Wake On Lan模式可以在完全关机状态下唤醒，而Wake On PCI Card模式要在深度休眠状态下唤醒。造成这样的区别主要是因为主板的设计不一样，现在的计算机一般都是Wake On PCI Card模式的。

首先，请在开机时进入 BIOS 设定程序，在电源管理选项中，请启用 PME EVENT WAKEUP 功能，然后储存设定退出程序，再重新启动进入 Windows 后，请开启设备管理器窗口，查看网卡设备的属性，开启唤醒功能相关设定即可。

如果使用的网络卡上有 WOL 接头，需配合主板上 WOL 接头；如果使用的网络卡上没有 WOL 接头，且它的规格是 PCI 2.3，则依上述的方法即可。

2、操作系统关闭快速启动

确认 Windows 10 快速启动功能是否关闭，见章节 [开启或关闭“快速启动”]。

3、操作系统设置网卡驱动程序的参数

有些网卡支持的网络唤醒模式较多，还需要在操作系统里设置驱动程序参数才可以

    https://www.intel.cn/content/www/cn/zh/support/articles/000059062/ethernet-products/intel-killer-ethernet-products.html

    https://zhuanlan.zhihu.com/p/29100706

Windows：

设置->系统→设备管理器→网络适配器→双击使用的网卡→选择“电源管理”标题页→

    关闭“允许计算机关闭此设备以节约电源”

    勾选“允许此设备唤醒计算机”

->驱动程序，选择“高级”选项卡→选择“魔术封包唤醒”→设置值为"开启"，此设置根据 Intel 或 RealTek 芯片不同有差别，酌情处理。

通过控制面板进入Windows Defender防火墙→点击左侧“高级设置”选项卡→选择左侧“入站规则”→点击右侧“新建规则”→选择“端口”→选择UDP，特定端口栏输入9，配置文件选择公用；

Linux：

    # 先查看网卡名称
    $ ip addr

    # 查看网卡有没有 wake 字样
    $ ethtool -S enp0s31f6

一般设置为 g 模式

    $ ethtool -s enp0s31f6 wol g

如果机器重启后，eth0 的设置又会回复到Wake-on: d 状态，则需要自行写一个 systemd 任务。

4、配置执行唤醒的软件

树莓派接入真实局域网并完成相关基础配置；

    # https://github.com/jpoliv/wakeonlan
    $ sudo apt install wakeonlan

    # https://sourceforge.net/projects/wake-on-lan/
    $ sudo dnf install wol

发送唤醒包对被控电脑进行真实局域网WOL测试

    # xx代指被控电脑MAC地址
    $ wakeonlan xx:xx:xx:xx:xx:xx

### 主板开启待机状态 USB 口供电功能和定时自动开机功能

BIOS 中的 “Erp” 节能选项，选择开启

    usb 口功能设置选择供电。

    RTC（定时开机）设置具体时间

根据戴尔的文章进行设置 <https://www.dell.com/support/kbdoc/zh-cn/000132056/shut-down-sleep-hibernate-or-change-the-power-plan-in-Windows-10>

    网络唤醒唤醒计算机：

        打开 设备管理器（控制面板）。
        单击睡眠左侧的加号 (+)。
        单击网络适配器左侧的箭头。
        右键单击无线或以太网，然后选择属性。
        单击电源管理选项卡，并确保未选中“允许此设备唤醒计算机”复选框。

        注：为无线适配器和以太网适配器均执行此操作。

    电源计划允许唤醒计时器：

        打开电源和睡眠设置（系统设置）。
        单击其他电源设置。
        单击更改计划设置。
        单击更改高级电源设置。
        单击睡眠左侧的加号 (+)。
        单击允许唤醒计时器左侧的加号 (+)
        单击使用电池，选中下拉菜单并切换至所需设置。
        单击接通电源，选中下拉菜单并切换至所需设置。

        注：在 Windows 10 中，“仅重要的唤醒计时器”选项仅在遇到重大的 Windows 系统事件时才会唤醒计算机。请尝试将您的唤醒计时器设置为“仅重要的唤醒计时器”，以查看是否能解决问题。当计算机的唤醒频率仍超过预期时，您始终可以将唤醒计时器设置为“禁用”。

确认 Windows 10 快速启动功能是否关闭，参见下面章节 [关闭“快速启动”]

    https://www.asus.com.cn/support/FAQ/1042220

    https://www.asus.com.cn/support/FAQ/1043640

### 设置带集成 usb-hub 拓展坞的显示器 Philips 346P1CRH

    https://www.philips.com.cn/c-p/346P1CRH_93/brilliance-curved-ultrawide-lcd-monitor-with-usb-c

    https://zhuanlan.zhihu.com/p/368732076

    https://zhuanlan.zhihu.com/p/405582769

Philips 346P1CRH 基本参数

    VA带鱼屏，分辨率为 3440X1440（21:9）

    刷新率 100hz，支持 HDR400

    最高亮度有 500nit，日常使用建议调到20%-25%亮度

    灰阶响应时间 9.0ms

    最大色深 8bit

    PowerSensor 睿动光感，屏幕前检测不到人时调低背光板亮度。

    环境光，夜间使用会自动调低显示器亮度，强光环境下会自动调高显示器亮度，类似手机、笔记本电脑屏幕的功能。

    自带 windows hello 摄像头，为了保证隐私安全，在摄像头工作的时候，旁边会亮起白色的LED灯。

    自带两个 5W 的音响

    拓展坞带 1Ghz 网卡接口

    OSD按键具有独立的信号源切换按键、独立的SmartImage按键、独立的自定义按键，你可以将这个自定义按键设置成切换音源、调出音量菜单、调节睿动光感灵敏度、调出亮度条、选择PIP/PBP模式、选择KVM设备。简直是效率神器，不用再OSD菜单里慢慢找了，一个按键就能完事。

以下功能，都需要连接到集成 usb-hub

90W typeC

    笔记本电脑连接只需要一根线，同时提供图像显示和供电。

USB 3.2

    显示器画面可以输出3440*1440@60Hz 8bit、3440*1440@100Hz 6bit

USB 2.0

    显示器画面才能达到满血的3440*1440@100Hz 8bit。如果你不外挂硬盘的话，那么这也不会成为缺点。

PBP 分屏

    usb-tpyec 的线连接笔记本电脑后，可以分隔一半屏幕显示笔记本电脑的桌面内容

    配合 sumsung dex 外接三星Galaxy手机，windows10下装好驱动，可以显示手机桌面

    显示器设置 kvm usb up，开启 基础的usb-hub。

PIP 功能

    画中画，另一个设备的桌面用小窗显示

KVM 功能

    显示器可以根据信号源自动调整KVM，信号源切换到笔记本，HUB上的设备也都全部切到PS5上。信号源切回电脑，HUB上的设备自然也就全部切回电脑。这个功能真的非常棒，直接将有线键鼠当成多模键鼠使用。

    也可设置在OSD中切换，一套鼠标键盘，操作笔记本和台式机，适用于PBP分屏功能

PBP 分屏的一个副作用

    如果用三星 Galaxy 手机 DEX 连接显示器集成的 usb-hub，关机会黑屏，拔下来手机之后 Windows 才能继续关机

在 Windows 操作系统的设置里不要开启 HDR 效果，即使用桌面应用不要开启 HDR 效果，只在相关视频软件和游戏内找设置开启 HDR，原因参见章节 [显示器开启 HDR 后 Win10 桌面变灰泛白的原因]。

### 使用 HDR 显示器

1、务必安装显示器对应的驱动

显示器厂家的官网一般都会提供自己品牌显示器对应的驱动程序，其实主要就是颜色配置文件。

使用显示器对应的 ICC 颜色配置文件：通常可以在显示器品牌官网中的服务与支持页面下载获取对应的 ICC 颜色配置文件，通过 “设置 —> 显示 —> 高级显示 —> 显示器 1 的适配器属性 —> 颜色管理” 来调整，切换到设备选项卡，添加并选中使用该颜色配置文件。

安装了颜色配置文件后，再使用 Windows 系统内置的“HDR显示器校准”工具（设置→系统→显示器→HDR），根据向导调整亮度平衡和色彩饱和度。

2、HDR 技术用于家庭影院很好，但不太适合做电脑显示器

    阳光照耀的自然光环境，亮度在几万 nit，HDR 技术的目标是能够还原这个自然光照的效果...

因为使用家庭电脑一般都是在室内相对偏暗的环境，27 英寸 HDR1000 显示器的亮度大概相当于近距离面对 60w 的白炽灯，会感到晃眼

    一旦进入 HDR 模式，显示器的亮度控制会自动拉至最高，显示器里设置开启的睿动光感、环境光、低蓝光模式、SmartImage 等动态对比度、自动亮度调节等可能与HDR产生冲突的功能均被关闭。

    如果是在黑暗房间中，屏幕会像个大光球，为了你的眼睛健康，显示器后面最好有个背景灯打泛光，显示器距离人眼的距离最好拉远到 1 米之外，电脑桌也不能太窄。这样的用法下，27 寸的嫌小，32 寸 4k hdr 显示器比较合适。

3、不在 Windows 桌面环境开启 HDR 模式，仅在相关应用中单独设置开启

    原因见章节 [显示器开启 HDR 后 Win10 桌面变灰泛白的原因]

开启方式：Nvidia 控制面板，打开 “RTX 视频增强” 选项：包含 “RTX视频超分辨率技术(RTX Video Super Resolution)”和 “HDR”。这样浏览器在全屏播放网络视频时可以进入 HDR 状态并增强画质：

    超分辨率技术用于把低于你显示器分辨率的视频用 GPU 的 AI 计算拉高到你显示器的分辨率

    模拟成 HDR 就是把不是 HDR 的视频用显卡处理后，在你的 HDR 显示器上呈现 HDR 效果

确保在 Windows 系统设置中，选择“屏幕”-->“显示卡”，点开 “高级图形设置” 确认勾选了 “硬件加速GPU计划”。

目前支持 HDR 模式的应用：

    edge 浏览器里，设置 --> “系统和性能”，勾选 “在可用时使用图形加速” 和 “增强 Microsoft Edge 中的视频”。

    VLC 播放器等支持 HDR 显示器的应用，在播放 HDR 内容时会自动通知显示器切换状态。

    大多数游戏都支持在自己的选项设置里开启 HDR，这样在开始游戏后会自动切换显示器模式以显示 HDR 内容

如果你的应用不支持单独设置 HDR 模式，而是跟随桌面环境的 HDR 设置，那就只能在打开应用之前在桌面开启 HDR

    Windows 设置 -> 系统 -> 屏幕 -> HDR，点击详情进行设置，这里开启的是桌面下使用 HDR 模式

    部分 HDR 显示器在自己的设置菜单预设了电影/游戏等 HDR 模式，按显示器上的菜单酌情选择即可

Windows 现在不支持在 hdr 应用程序退出后自动关闭 HDR 模式，所以在退出 hdr 应用后，需要手工调整显示器，把睿动光感、环境光、低蓝光模式、SmartImage 等功能再打开，把显示器亮度降下来歇歇眼。。。

如果是普通 sdr 显示器播放 hdr 视频太暗

    用 MPC-BE 播放器安装 MadVR 滤镜，勾选 HDR 转 SDR

    VLC Player 支持比较完善，自动在 SDR 环境下进行 HDR-SDR 转换，但效果一般

> 玩 Doom

显示器开启 hdr 模式后，进入游戏后会自动检测到，跟随调整颜色。或者在游戏应用的设置中选择开启 hdr，则在进入游戏后会自动设置显示器开启 hdr 模式。

我玩射击游戏，关垂直同步才不头晕

    解决晕 3D 最好关闭垂直同步，这个技术锁帧为你的屏幕刷新率数值会导致画面延迟，开启三重缓冲能缓解，但是偶尔会卡一下。头晕的原因可能在于相对于手的动作，屏幕的显示有延迟且随帧率波动，fps 射击游戏频繁快速的转身和视角变换导致大脑对手运动的感知和对视觉的感知不一致，进而导致头晕

把 doom 的可执行文件加到 Windows 防火墙，即可离线模式玩单机，不需要登陆 bethesda 网络

    https://steamah.com/doom-eternal-how-to-play-in-offline-mode-with-no-bethesda-net-account/

    打开 Windows Defender 防火墙：按下 Win 键在键盘上搜索 "Windows Defender"，然后单击 “具有高级安全性的 Windows Defender 防火墙”

    在防火墙中创建新规则：展开左侧树形列表，右键单击 "Outbound Rules" 并选择 "New Rule"

    配置阻止规则

        规则类型： 选择 “程序”

        程序： 选择程序路径并导航到安装位置选择 DOOMEternalx64vk.exe。 例如： C:\Program Files (x86)\Steam\steamapps\common\DOOMEternal\DOOMEternalx64vk.exe

        动作：选择 “阻止连接”

        轮廓：选中所有框。

        名称 ：为规则选择一个名称，例如 "__DOOM_Eternal_offline"。 下划线将把规则放在列表的顶部，使您的搜索更加容易。

    单击完成，就完成了。

    启动 Doom 程序，请等待几秒钟将看到弹出窗口提示无法连接 Bethesda 账户，单击 OK 即可继续了。

查看 doom 服务器状态 <https://certb-status.bethesda.net/en>。

在 Linux 上玩 doom eternal，参见章节 [steam on Linux](init_a_server think)。

#### 显示器开启 HDR 后 Win10 桌面变灰泛白的原因

在游戏或播放软件里单独设置 HDR 选项就可以了，Windows 的设置里不需要打开 HDR 选项，目前的 Windows 10 的“桌面”并没有很好的适配当前的 HDR 显示器。

简单来说，为了支持桌面上显示 HDR 软件, 桌面必须声明需求显示器的完整 HDR 亮度范围，因为桌面 UI 本身不能闪瞎人眼，所以桌面 UI 的亮度是低亮度模式。而 Display HDR400-600 的显示器的 HDR 并没有低亮度细节，所以低亮度部分就发灰了。HDR 和暗部平衡差不多，都可以把暗部细节显示出来，所以看起来就像是亮度调得很高的样子，会泛白。这个跟 HDR 显示器对 BT.2020 等色域标准的支持程度也有关系。

这个现象在 FALD/OLED 显示器上是不存在的，仅在 Display HDR400-600 的"假 HDR"显示器上存在

    原因在于 Display HDR400-600 并不是真的支持 HDR, 亮度范围根本没那么大，现有的 HDR 协议并没有体现出这一点。而 Windows 还没有对 Display HDR400 和 600 这两个"假 HDR"提供支持。

    微软也没辙，属于技术局限，只能等未来看微软打算怎么解决这个问题了。

    折衷的办法是，显示器厂商单独出 HDR 配置文件，让 Windows 自动识别实际的 HDR 亮度范围，而不是接收显示器现在汇报的这个虚假的 HDR 亮度范围。

其实现在的 HDR 标准其实是纯凑活事，显卡信号输出了剩下的全看显示器，导致 HDR 内容的显示没有任何标准，大家效果千差万别。

这点在真 HDR 显示器上也很明显，不同品牌的 FALD 显示器效果也是完全不同的，颜色亮度各种跑偏，完全是群魔乱舞。

很多游戏内置 HDR 选项，让你单独调节亮度来适应屏幕就是这个原因。

### 8GB 显卡爆显存

某些游戏把光线追踪、反锯齿等高画质功能拉满后，特别是在 4K 分辨率的显示器下，显存占用会超过 8GB，会提示显存不足，严重情况下一卡一卡的

    如果没爆显存，或游戏优化的好，画质稍微降低或切换到内存，你感觉不出来

解决办法，如果想凑合下，开启 DLSS4 功能，可以稍微降低对显存的需求，或者在游戏选项中适当降低画质即可。

4K 分辨率推荐换用 16GB+ 显存的显卡，比如 GigaByte GeForce RTX™ 5070 Ti EAGLE OC SFF 16G

    https://www.gigabyte.cn/Graphics-Card/GV-N507TEAGLE-OC-16GD

高功耗显卡的峰值功耗基本比最大功耗多50%+，但是毫秒级别波动只有用示波器能抓住，厂家从来不负责功耗超标问题。所以，xx80 xx90 系显卡务必整个不虚标大电源，用 A 卡的直接翻倍估算。一瓦一块钱这个说法不知道准不准

    https://zhuanlan.zhihu.com/p/1919343185894811317

### N 卡画质增强

#### 让你的桌面颜色更准确 --- 白色不偏色

    https://www.zhihu.com/question/279556310/answer/1070407834

Nvidia 控制面板的输出动态范围选择 “完全”：开了可以增加黑白明暗对比，增加色彩艳丽程度，白色更白黑色更黑，更鲜艳。但是如果显示器屏幕素质一般的话开着反倒不如不开柔和。我办公用的电脑反复试了，开“完全”比不开柔和，全白的时候刺眼。还有如果接电视由于信号格式问题一定要选限制。

要根据连接的显示器来调整

一般来说，显示器或者电视机例如会有“HDMI黑色水平”这样的设置选项，其实就是两种不同的明度色阶（16-235）和（0-255）：

    其中 低/Limited Range 对应显卡输出动态范围 “有限”

    正常/Full Range 对应显卡输出动态范围 “完全”

如果不对应进行设置：

    显示器设定低/Limited Range，显卡设定完全，则屏幕显得曝光过度，暗部亮部全部失去细节。这个很明显。

    显示器设定正常/Full Range，显卡设定有限，则屏幕发灰。

但不对比可能不会觉察，很多人可能被显示器“正常”这个选项误导一直在错误的显色环境下使用。两者设定“低/有限”或两者设定“正常/完全”都是正确的。

另外如显示器/电视机连接PS4或Xbox，同样要注意RGB输出动态范围与显示设备的匹配。

    VA面板，选完全，使得亮处更亮，暗处更暗，画面层次感更强

    IPS或TN面板，选有限，使得暗部细节能看的清楚，不至于糊成一团

另外，一样的显示器，插 HDMI 线或 DP 线也是效果不同，大致因为 HDMI 是电视标准而 DP 是电脑标准，自己酌情设置即可。

> 输出颜色深度

除非你的显示器支持 10bit，否则选择 8bit 即可。另外要注意连接线的规格，dp2.0、hdmi1.4 以上。

#### 让你的游戏更清晰

1、游戏设置里把胶片颗粒、电影质感、动态模糊等选项关掉。

2、以前的光栅游戏，一般是调整 LOD 对应画质细节。

4K 分辨率流行后设计原则变了，渲染分辨率用 1K 然后放大到你显示器分辨率 4K 的优化技术、DLSS 等等歪招全来了。

如果感觉你的游戏中画质有点糊，不够清晰锐利，即使在游戏设置中把贴图细节拉到最高，抗锯齿选项也拉到最高，还是没有效果

    把“锐化”相关选项拉高再看看，一般会解决问题。注意锐化数值太大会让亮处噪点明显，树皮的纹理变得不真实等，酌情调整。

    如果启用了 DLSS，则还可以调整 DLSS 的锐化选项。另外 DLSS 的档位尽量选择“DLAA”或“质量”，比“性能”档更清晰。

“锐化”可以解决大部分画质糊的问题，比如 Doom:The Dark Ages 为了优化，把大多数的材质限制在粗糙度阈值之下，总给人画面比较糊的感觉，而把“锐化”拉到 2~3 后，清晰感就跟之前的 Doom：Eternal 差不多了，跟过场动画的细节类似。

还可以试试渲染倍率到100%，看看是否可以解决糊的问题。

3、还有个驱动程序级别的覆盖设置方式（用 steam 截图会得到原图）：

使用显卡驱动自带的滤镜：

    打开 NVIDIA APP，左侧栏点击“设置”，点击打开 “NVIDIA 信息浮窗”

    运行你的游戏，进入游戏后按热键 alt+z，弹出的信息浮窗选择 “游戏滤镜”，使明朗、锐化和动态亮丽等功能都可以直接勾选启用。有个“详细信息”滤镜，把这几个选项都包括在内了，方便。

如果游戏中的运动人物或物体出现“重影”现象，就是这个滤镜的缺点，酌情调整选用。

4、显示器从 1080P 换成 4K，画质也能有明显提升

    注意有些游戏 2k 分辨率拉满设置里的抗锯齿选项，实际画面还不如 4K 显示器开 DLSS 性能档，没有抗锯齿也不影响画面体验帧数还高。

另外，开启 Nvidia DLDSR(深度学习动态超分辨率) 让你的1080P显示器秒变4K：

这个功能是显卡驱动级别的功能，不需要游戏支持，但游戏需要支持 4k 显示分辨率。DLDSR 能够以超出你的显示器的更高、更细腻的分辨率渲染游戏，然后把画面智能地缩放至显示器的原生分辨率，在任意屏幕上为玩家提供 4K (3840x2160) 画质的图形效果

    Nvidia 在 2014 年推出 DSR（虚拟超级分辨率）功能，现在升级了叫 DLDSR(深度学习动态超分辨率)，号称效果更好 DLDSR 2.25x 相当于 DSR 4x。

开启方法

    打开 NVIDIA 控制面板，从“管理 3D 设置”>“DSR因数”，然后选择“DL缩放”就可以启用 DLDSR 了，调整渲染时放大的倍数即可。旧版缩放指的是 DSR，1080P 显示器选择 4x 则分辨率变成 4K (3840x2160)。DSR 4.00x 就是 1K 显示器像素显示的内容是显卡用 4K 像素模拟计算后得出的 。

    然后 Windows 桌面进分辨率设置，分辨率选项出现 3840X2160 的选项了，说明 DSR 已经成功开启。（桌面用如果字体显示扭曲发糊考虑调整字体缩放）

    最后进入游戏，应该可以选择 3840X2160 选项了。

效果

    根据网友实测，对部分老游戏有奇效。

    在有 DLSS 的游戏里，以 4K 分辨率开启 DLSS 在保证目标帧数超过60帧的情况下，能让 1080P 显示器下游戏的显示效果获得极大的清晰度提升。

    如果开 DLDSR + DLSS 有噪点，降低锐化也不管用，则换成 DLDSR + TAA 试试，大型 3A 游戏一般都可选择 TAA。

DLSS 和 DLDSR

    这俩某种意义上说是相反的功能，一个是降低渲染分辨率提高游戏帧率，但尽量保持画质不损失太多

    一个是拉高渲染分辨率，尽可能提高画质

5、类似的，提升视频网站和直播平台的清晰度，可以利用 Nvidia RTX视频增强（Super Resolution）。

Nvidia 控制面板，打开 “RTX 视频增强” 选项：包含 “RTX视频超分辨率技术(RTX Video Super Resolution)”和 HDR。这样浏览器在全屏播放网络视频时可以进入 HDR 状态并增强画质。

    超分辨率技术用于把低于你显示器分辨率的视频用 GPU 的 AI 计算拉高到你显示器的分辨率。

    模拟成 HDR 就是把不是 HDR 的视频用 GPU 的 AI 计算展现成 HDR 的高光效果。

在 Windows 系统设置中，选择“屏幕”-->“显示卡”，点开 “高级图形设置” 确认勾选了 “硬件加速GPU计划”。

只是目前支持该技术的应用软件太少：

    edge 浏览器里，设置 --> “系统和性能”，勾选 “在可用时使用图形加速” 和 “增强 Microsoft Edge 中的视频”。

    VLC 播放器有个特殊的优化版本支持 Nvidia RTX 视频增强<https://download.videolan.org/testing/vlc-rtx-upscaler/>

#### 让你的游戏不太暗

    https://sspai.com/post/83522

光线追踪的某些游戏，对光线直射和背光混杂的视角变化处理不好，亮处很亮而暗部画面很黑，转头只看暗处又会变亮，在开启 HDR 时更明显，这个不是什么黑屋出门看强光的人眼效果，这个是光照曲线有问题，根源在于游戏的设计和调校。

    不好的例子是 赛博朋克2077 的白天场景各种物体的暗部动态死黑，在阳光部分直射的大街上转头就有想打手电筒的感觉。

    好的例子是 Doom:The dark ages，光线追踪全局光照（RTGI）调校的好高光给人冲击时暗部也有足够的亮度能看清细节，明暗过渡自然转换视角时眼睛完全不累。另外没光的山洞里也会细心的放置光源，死黑很少见，不需要打手电。

    这也是为什么 2077 玩家都喜欢秀夜景的原因，因为夜景不介意暗处黑，站个大灯底下看彩灯实在太酷炫。像 2077 这样粗暴的光污染却契合了赛博朋克风格，属于取巧了。

1、如果是游戏暗处太黑（含光线追踪），首先在游戏内设置调整“伽马值”，适当放大，达到暗处稍亮而亮处不发白即可。伽马值太高整个屏幕都会都发白，酌情调整。

如果是 HDR 显示器，游戏内一般会有个专门的 HDR 参数设置页面，可以调整亮度、色调等细节。

手调显示器亮度对比度的方式不适合现代游戏

    光线追踪的游戏，对比度亮度都是动态的，全局光照的曝光度也随着视角和环境变化，这都跟游戏的软件设置有关，单纯调节显示器的亮度没什么作用。

    而且，如果开启 HDR 显示器会自动切换到最高亮度，全靠游戏或视频每帧画面的亮度数据来动态变化明暗。

2、游戏内设置，如果支持就把光线追踪的 “路径追踪” 选项打开。这样可以利用光线的多次反射，即使物体是有粗糙度的材质也会稍微变亮。另外，火焰、灯光等自发光材质也能稍微照亮周边，这些都可以增加一点场景中物体的暗部亮度。

比如 Doom:The Dark Ages 为了优化，把大多数的材质限制在粗糙度阈值之下，以大大减少反射的计算，场景中的动态光影和阴影特效也用的非常克制，场景内反射远景的物体很少，物体的暗部维持在可以看清。试试开启 “路径追踪”，画面整体的亮度增加，清晰感更强。

光线追踪和路径追踪

    计算机图形学算法中，路径追踪是光线追踪的一个实现方式，而现实游戏届的宣传受显卡厂商影响，光线追踪和路径追踪跟光栅渲染划代了。

    N 卡 2080 时代宣传的光线追踪，其实整个画面还是使用光栅化渲染的，只有反射、环境光这些使用光追来实现。比如 Doom:Eternal 开启光线追踪后的 “邪教徒基地关卡”，各种不锈钢材质都在反射周边的灯光甚至 slayer 角色模型，城市场景里也敢于布设玻璃和镜子，二者组合的使用非常节省显卡的硬件资源，中低档显卡都能畅玩。

    N 卡 4080 时代宣传的路径追踪，就是完全抛弃光栅化渲染，完全使用光追的路径追踪算法来形成画面，极大的增加了对显卡硬件的消耗。比如 Doom:The Dark Ages 各种场景中绝大部分材质的粗糙度设置都是不反射，不敢使用不锈钢材质，不敢放置玻璃和镜子，镜面效果只见于水面和地面的水洼，功耗近 400瓦 的 5080 显卡都跑不到 4K 60 帧。

3、开启 Nvidia RTX 动态亮丽，让你的游戏暗处不再那么黑

这是驱动程序级别的覆盖设置方式（用 steam 截图会得到原图），不需要游戏支持即可开启。

开启方法：

    打开 NVIDIA APP，左侧栏点击“图形”，然后点击选择你的游戏。

    右侧栏目，在 “游戏内设置” 中找不到选项就是游戏不支持，需要在下面的 “驱动程序设置”，点击 开启RTX动态亮丽，这样就生效了，以后只要启动你的游戏显卡驱动就会自动应用该特效。

    想开这个必须把WIN11系统的自动HDR关了才行，有的还要关掉游戏自带的HDR才能用，不知道为何

还有个使用方式

    打开 NVIDIA APP，左侧栏点击“设置”，点击打开 “NVIDIA 信息浮窗”

    运行你的游戏，进入游戏后按热键 alt+z，弹出的信息浮窗选择 “游戏滤镜”，使明朗、锐化和动态亮丽等功能都可以直接勾选启用。有个“详细信息”滤镜，把这几个选项都包括在内了，方便。

### 取消动态磁盘

之前误把“动态磁盘”和“GPT 磁盘”混淆了，我的硬盘不幸改成了动态磁盘，Windows 不能操作他的各种分区了。

微软自己都废弃了这个“动态磁盘” <https://docs.microsoft.com/en-us/Windows-server/storage/disk-management/change-a-dynamic-disk-back-to-a-basic-disk>。

动态磁盘下，创建软RAID0 叫叫“带区卷”，在 Windows 跨区的条带卷叫“跨区卷”。

在 Win10 之后，微软用新的存储管理方式：“存储空间” 来取代动态磁盘，有“存储池”的概念。将多个物理磁盘组合起来，形成一个虚拟的存储池，并从中创建出一个或多个虚拟磁盘。每个虚拟硬盘可以使用不同的虚拟磁盘布局，如简单、镜像（Raid1）、条带化（Raid0），奇偶校验（Raid5）。这些虚拟硬盘其实都是“软Raid”，不但可以各不相同，而且可以托管系统。比如：3台1T磁盘组成存储池，其中每块硬盘的前100G组成总容量300G的条带化（Raid0）虚拟硬盘，安装系统，用以加快系统启动。剩余空间组成容量1.8T（900*2）的，奇偶校验（Raid5）虚拟硬盘用于保存数据。

取消步骤，需要进入 diskpart

    >list disk
    查看你要操作的那个磁盘的编号 0，1，2。

    >select disk <disknumber>

    >detail disk
    挨个查看卷 volume 的编号，需要逐个删除

        >select volume= <volumenumber>
        >delete volume

    >select disk <disknumber>
    再次选择你要操作的那个磁盘的编号

    >convert basic

注意：无法在 Windows 里操作自己的启动盘，得启动到u盘或者别的系统里操作这个磁盘，而且这个磁盘的内容会被完全清除！

### exFAT 格式的 u 盘无法存放 4GB 以上的大文件

这应该是格式化程序的 bug，重新快速格式化一次，格式还是选择 exfat，但要扩大分配单元大小，我选的 128k，格式化完成后，就能正常存放 4GB 以上文件了。

FAT32/NTFS/exFAT 的特点：

FAT32 不能存储大于 4GB 的单个文件，但因为历史悠久，设备兼容性最好。

NTFS 采用“日志式”的文件系统，需要记录详细的读写操作，不断的读写导致闪存芯片寿命变短。最大的优点是遇到断电或突然拔出 u 盘的情况，可以回滚数据，损失小。

exFAT 的设计面向 U 盘，既可以存放大于 4GB 的单个文件（单文件最大可达 16EB），又可以减少额外读写，避免伤害 U 盘的寿命。

    各大操作系统都支持这种文件系统，如果你的 u 盘要经常在 Windows、Linux、MacOS、苹果或安卓手机、平板电脑之间拷贝文件，推荐用这种格式。

    很多移动硬盘的默认文件系统是 NTFS，买到手先重新格式化为 exFAT，然后拷贝个大于 4GB 的文件试试。

用完的 U 盘不要立即拔出，要在时间栏那里选择弹出，以便操作系统同步缓存的数据，不然容易丢失数据

    Windows 10+ 对非 NTFS 文件系统的 U 盘会自动关闭写入缓存，这样用户不需要在菜单选择弹出 U 盘的繁琐操作

U 盘用什么格式，取决于插入设备的支持情况

    如果是用于 Android 的电视机：那么必须使用 FAT32 格式，且 U 盘总容量不能超过 32GB，不然会有莫名其妙的问题。

    如果只是 Windows 电脑上使用，32GB 容量以内选择 FAT32，大于 32GB 容量的 exFAT 或 NTFS 都可以。

### 如何判断 USB Type-C 口有哪些功能

    <https://www.asus.com.cn/support/FAQ/1042843>

### tp-link 免驱版无线网卡无法安装驱动程序

最流行的免驱无线网卡 TP-LINK TL-WN726N 免驱版，第一次插入 usb 接口时，在资源管理器中是一个 u 盘设备，右键选择打开，对安装程序 SetupInstall.exe 右键选择兼容模式---win8，然后即可安装。安装成功后，u 盘设备消失，系统的网络适配器中会出现一个无线网卡设备，在时间栏出点击无线网络的图标选择你的无线路由器连接即可。

当计算机重新启动后，或再次插入计算机usb端口时，已经安装过的驱动会自动切换这个设备的u盘模式为usb网卡，用户体验比较方便，不需要再次安装驱动了。

使用了若干次后，有时网卡设备会消失，又成了 u 盘设备，需要重装驱动，务必先删除原来的驱动：

    控制面板->添加删除程序：TP-LINK无线网卡产品，点击“卸载”按钮，完成后重启计算机，然后重新上面的步骤安装驱动。

### Windows 7/10 远程桌面报错的解决办法

Windows 7 之后微软把远程桌面做了比较大的变动，因为 Windows 更新自动升级，远程桌面相关的几个升级补丁包却没有安装，导致远程桌面报错无法使用，用户摸不到头脑，其实是微软没有明确告知这个变动导致的混淆。

报错：无法连接

远程服务端升级到 rdp8.0 以上版本，建议客户端也升级到这个版本。

    1.Windows6.1-KB2574819-v2-x64.msu

    2.Windows6.1-KB2857650-x64.msu

    3.Windows6.1-KB2830477-x64.msu

    4.Windows6.1-KB2592687-x64.msu

远程服务端的远程桌面设置，系统属性->允许远程桌面：勾选“仅允许使用网络级别身份验证的远程桌面计算机连接（更安全）”。

报错：“身份验证错误，要求的函数不受支持”

这是由于本地客户端或远程服务器端只有一方更新了CVE-2018-0886 的 CredSSP 补丁 KB4103718、KB4103712 ，而另外一方未安装更新的原因导致的，详见：<https://msrc.microsoft.com/update-guide/zh-cn/vulnerability/CVE-2018-0886>，其它受影响的 Windows 版本详见<https://docs.microsoft.com/en-us/troubleshoot/azure/virtual-machines/credssp-encryption-oracle-remediation>。

方法一（强烈推荐）：

本地客户端、远程服务器端都安装更新补丁，更新以后重启计算机。

KB4103718 如果运行时报告无法安装，先运行自带的那个 pciclearstalecache_264c3460a3ee95d831aa512b80bc8cc6aaa2d218.exe，然后就可以安装了。

微软搞的太乱了。。。

方法二：

强烈建议按方法一对本地客户端和远程服务器安装补丁，如果某些特殊情况远程服务器不能更新最新补丁，可按照以下方法设置本地客户端之后远程登录：

在运行里面输入gpedit.msc打开组策略，找到该路径：“计算机配置”->“管理模板”->“系统”->“凭据分配” 在右边设置名称找到 “加密 Oracle 修正”，将保护级别更改为“易受攻击”。

修改以后在运行里面输入gpupdate更新策略。

如果客户端是 Windows 7，组策略里没有 【加密 Oracle 修正】 选项，先确认方法一的两个补丁是否没装全。

如果都安装了还是没显示该选项，做如下操作：

请先创建一个add.txt文件,将如下代码添加到文件保存,保存后将txt后缀更改为reg,然后双击add.reg导入到注册表重启电脑即可。

    Windows Registry Editor Version 5.00

    [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters]

    "AllowEncryptionOracle"=dword:00000002

远程桌面的开始菜单没有关机键

    cmd窗口执行命令

        # 立刻关机
        shutdown -s -t 0

        # 立刻重启
        shutdown -r -t 0

### Windows 11 远程桌面无法使用已经保存好用户名密码的 .rdp 文件

远程桌面程序 mstsc.exe，打开已经保存好设置的 .rdp 文件，会遇到这个提示：

    Microsoft Defender Credential Guard 不允许使用已保存的凭据，请输入你的凭据。

这时只能输入用户的密码才能登录远程计算机的桌面，非常麻烦。

在 Windows 的 “设置” 中搜索 “凭据管理器”，点击 “Windows 凭据”，可以看到对端计算机远程桌面的用户名和密码已经保存了，之前使用的时候是没有问题的。

原因是你在 Windows 系统设置的安全中心，打开了基于虚拟化的安全基线。打开安全中心->设备安全性：内核隔离，可以看到 “Microsoft Defender Credential Guard” 开启了。

    https://support.microsoft.com/en-us/windows/device-security-in-the-windows-security-app-afa11526-de57-b1c5-599f-3a4c6a61c5e2#bkmk_credential-guard

解决办法就是在组策略中，设置 “Microsoft Defender Credential Guard” 允许使用已经保存的凭据

    https://www.anyviewer.com/how-to/rdp-windows-defender-credential-guard-2578.html

1、开始->运行，或直接搜索：

    gpedit.msc

2、 Computer Configuration > Administrative Templates > System > Device Guard > Turn on Virtualization Based Security.

3、双击以打开这个策略，选择 “已启用”

4、这是下方的各个选项就可以设置了。

在 “Credential Guard”，确保选择 “已禁用”。

或者编辑注册表 regedit.exe：打开 HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa，新建一个 DWORD 项目 LsaCfgFlags ，设置值为 0 。

5、重启计算机生效。

安全中心->设备安全性：内核隔离->固件保护，可以看到 “Microsoft Defender Credential Guard” 关闭了。

### Windows 下利用登录用户凭据保存你的应用的密码

目前好像这个用户凭据的用法在 Windows 11 时代不大受待见了

    https://zhuanlan.zhihu.com/p/679219628

Windows软件的话，最好的办法就是把用户密码保存到Windows的用户凭据区

下面是C++代码：

```c++
#include <windows.h>
#include <wincrypt.h>
#include <wincred.h>
#include <credentialprovider.h>
#pragma comment(lib, "Advapi32.lib")

std::wstring appName = L"yourApp";
//保存或更新用户凭据
bool Store(std::string& target)
{
    CREDENTIAL cred = { 0 };
    cred.Type = CRED_TYPE_GENERIC;
    cred.TargetName = appName.data();
    cred.CredentialBlobSize = target.size();
    cred.CredentialBlob = (LPBYTE)(target.data());
    cred.Persist = CRED_PERSIST_LOCAL_MACHINE;
    return CredWrite(&cred, 0) == TRUE;
}
//删除用户凭据
bool Remove() {
    return CredDelete(appName.data(), CRED_TYPE_GENERIC, 0) == TRUE;
}
//读取用户凭据
std::string Read()
{
    CREDENTIAL* cred;
    if (CredRead(appName.data(), CRED_TYPE_GENERIC, 0, &cred) == FALSE) {
        return "";
    }
    std::string result(reinterpret_cast<char*>(cred->CredentialBlob),cred->CredentialBlobSize);
    CredFree(cred);
    return result;
}

std::string str = "abc123";
bool flag = Store(str);
std::cout << "Store Ok" << flag << std::endl;
auto result = Read();
std::cout << "Read Ok:" << result << std::endl;
```

这个API在Windows XP 时代就有了，所以兼容性还挺好的。

密码写入用户凭据之后，本身就是加密的，而且这个密码不容易被轻易窃取，所以基本不用担心安全问题。

如果黑客入侵了目标电脑，且黑客知道你的appName，那么黑客运行一下Read方法的代码，也是可以拿到密码的，所以，你不放心的话，就把一段密文存入用户凭据，用的时候，再在内存里解密一下。这样的话，就增加了黑客窃取用户密码的成本。

注意：任何程序都无法做到绝对安全，只要能做到入侵的成本远高于收益就可以认为是安全的。

如果你不想保存任何东西，只想用一下Windows操作系统提供的加密解密方案，可以使用如下C++代码：

```c++
#include <windows.h>
#include <wincrypt.h>
#include <wincred.h>
#include <credentialprovider.h>
#pragma comment(lib, "Crypt32.lib")

//加密
bool Encrypt(const std::wstring& plaintext, std::vector<BYTE>& encryptedData)
{
    DATA_BLOB inData, outData;
    inData.pbData = reinterpret_cast<BYTE*>(const_cast<wchar_t*>(plaintext.c_str()));
    inData.cbData = (plaintext.size() + 1) * sizeof(wchar_t);
    if (!CryptProtectData(&inData, NULL, NULL, NULL, NULL, CRYPTPROTECT_LOCAL_MACHINE, &outData))
    {
        DWORD dwError = GetLastError();
        return false;
    }
    encryptedData.resize(outData.cbData);
    memcpy(encryptedData.data(), outData.pbData, outData.cbData);
    LocalFree(outData.pbData);
    return true;
}
//解密
std::wstring Decrypt(const std::vector<BYTE>& encryptedData)
{
    DATA_BLOB inData, outData;
    inData.pbData = const_cast<BYTE*>(encryptedData.data());
    inData.cbData = static_cast<DWORD>(encryptedData.size());
    outData.pbData = NULL;
    outData.cbData = 0;
    if (!CryptUnprotectData(&inData, NULL, NULL, NULL, NULL, CRYPTPROTECT_LOCAL_MACHINE, &outData))
    {
        DWORD dwError = GetLastError();
        throw std::runtime_error("Failed to decrypt data.");
    }
    std::wstring plaintext(reinterpret_cast<wchar_t*>(outData.pbData), outData.cbData / sizeof(wchar_t) - 1);
    LocalFree(outData.pbData);
    return plaintext;
}


std::vector<BYTE> encryptedBytes;
Encrypt(str, encryptedBytes);
std::string encryptedStr(reinterpret_cast<char*>(encryptedBytes.data()), encryptedBytes.size());
std::cout << "Encrypt Str:" << encryptedStr << std::endl;
std::wstring decryptedStr = Decrypt(encryptedBytes);
std::wcout << L"Decrypted str: " << decryptedStr << std::endl;
```

这里的加密解密，也用到了Windows当前登录人的用户凭据。

只有与加密数据的用户具有相同登录凭据的用户才能解密数据。

也就是说，密文失窃后，在另一台电脑上是无法解密的。

显然这种办法无法用于客户端服务端交换信息（因为服务端解密不了）。

当你客户端有加密需求，你又不想引入openssl时，也可以考虑这个方案，mac下要写其他代码。

### 乱七八糟的 .NET Framework 各版本安装

.NET Framework 4.x 号称是互相覆盖的，版本继承性可以延续。

.NET Framework 4.5 之前的 4.x 版本

M$不支持了，自求多福吧，自己挨个版本研究去 <https://docs.microsoft.com/zh-cn/dotnet/framework/install/guide-for-developers>

.NET Framework 4.5 及之后的 4.x 版本

从 .NET Framework 4 开始，所有 .NET Framework 版本都是就地更新的，因此，在系统中只能存在一个 4.x 版本。

.NET Framework 3.5 在 Windows 10 + 只能按需安装

通过 Windows 控制面板启用 .NET Framework 3.5。 此选项需要 Internet 连接。
简单点办法，安装 directx 9，Windows 自己会弹出提示要求给你安装。NET Framework 3.5。

微软自己做烂了，各个版本居然都是不兼容的 <https://docs.microsoft.com/zh-cn/dotnet/framework/install/dotnet-35-Windows> 。

警告

    如果不依赖 Windows 更新作为源来安装 .NET Framework 3.5，则必须确保严格使用来自相同的、对应的 Windows 操作系统版本的源。
    使用来自不同 Windows 操作系统版本的源将安装与 .NET Framework 3.5 不匹配的版本，或导致安装失败，使系统处于不受支持和无法提供服务的状态。

也就是说，弄个 3.5 的离线安装包，在 Windows 10 下面可能不能用。

### 解决 Intel CPU 的 Meltdown/Spectre 熔断幽灵漏洞的降速问题

这几个漏洞属于侧信道攻击(side channel)，居然覆盖了 1998 年到 2018 年的所有英特尔 cpu。。。

    https://blog.csdn.net/hbuxiaofei/article/details/115519407

    https://rtoax.blog.csdn.net/article/details/109272351

    https://zhuanlan.zhihu.com/p/348390245

    https://zhuanlan.zhihu.com/p/32784852

    虚拟机关闭这个缓解措施的方法
        https://kb.vmware.com/s/article/79832?lang=zh_cn

英特尔提供的解决方式，从 BIOS 刷新到操作系统补丁，整体降低 cpu 速度大概在 10% ~ 20%，特定应用有降速 60% 的。所以是否开启侧信道攻击缓解，需要斟酌决定

    家用电脑必须打补丁，恶意网站内嵌的 js 脚本跑几个循环就能获取你的密码了

    如果是内网使用，仅安装可信发行版和自主软件的服务器，可以不启用这个补丁

本简要指南介绍了如何通过关闭 Spectre 和 Meltdown 缓解措施使 Linux 系统在 Intel CPU 上更快地运行。

警告 :

    在实施以下解决方案之前，我必须警告你 - 这是高度不安全的，不建议这样做。这将禁用 Intel CPU 上的所有 Spectre 和 Meltdown 缓解措施，并使 Linux 系统对风险敞开大门。除非清楚地知道你在做什么，不要这样做。

如果您根本不关心安全性，请继续按照以下说明禁用缓解措施。

使 Linux 系统在 Intel CPU 上运行更快

使用你喜欢的文本编辑器编辑 grub 文件。

Debian、Ubuntu：

    sudo nano /etc/default/grub

如果你使用的是 Linux 内核版本 5.1.13 及更新版本，请添加或编辑以下内核参数，如下所示：

    GRUB_CMDLINE_LINUX="mitigations=off"

这将禁用所有可选的 CPU 缓解措施。

如果你使用的内核版本早于 5.1.13，请添加或编辑以下内容：

    GRUB_CMDLINE_LINUX="noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier mds=off tsx=on tsx_async_abort=off mitigations=off"

这些是内核参数，可用于禁用所有降低 Linux 系统速度的 Spectre/Meltdown 缓解措施。

有关每个标志的更多详细信息，请快速搜索 google。

添加内核 parameter 之后，使用命令更新 GRUB 配置：

    sudo update-grub

最后，重新启动系统：

    sudo reboot

在 CentOS 和 RHEL 这样的 RPM-based 系统上，编辑 /etc/sysconfig/grub 文件：

在 GRUB_CMDLINE_LINUX 中添加上面的参数，然后使用命令更新GRUB配置：

    sudo grub2-mkconfig

最后重新启动：

    sudo reboot

在一些 Linux 系统中，需要在 "GRUB_CMDLINE_LINUX_DEFAULT =" 中添加这些内核参数。

我们现在已禁用所有 "Spectre" 和 "Meltdown" 缓解措施。这会稍微提高系统的性能，但也可能使用户面临多个CPU漏洞。

检查 Spectre/Meltdown mitigations 是否被禁用

我们可以使用 "spectre-meltdown-checker" 工具来帮助你识别 Linux 中的 specre 和 missdown 漏洞，在一些 Linux 发行版的官方存储库中可以找到它。

Debian、Ubuntu：

    sudo apt install spectre-meltdown-checker

CentOS、RHEL：

    sudo yum install epel-release
    sudo yum install spectre-meltdown-checker

Fedora：

    sudo dnf install $ sudo apt install spectre-meltdown-checker

安装 spectre-meltdown-checker 后，以 root 用户身份或以 sudo 权限运行它，以检查是否关闭了 Spectre 和 Meltdown：

你应该看到如下所示的消息。

    [...]
    > STATUS: VULNERABLE (Vulnerable: __user pointer sanitization and usercopy barriers only; no swapgs barriers)
    [...]
    > STATUS: VULNERABLE (IBRS+IBPB or retpoline+IBPB is needed to mitigate the vulnerability)
    [...]
    > STATUS: VULNERABLE (PTI is needed to mitigate the vulnerability)

或者，你可以检查 Spectre/Meltdown 漏洞，如下所示。

    $ ls /sys/devices/system/cpu/vulnerabilities/
    itlb_multihit l1tf mds meltdown spec_store_bypass spectre_v1 spectre_v2 tsx_async_abort

还有

    $ grep . /sys/devices/system/cpu/vulnerabilities/*
    /sys/devices/system/cpu/vulnerabilities/itlb_multihit:KVM: Vulnerable
    /sys/devices/system/cpu/vulnerabilities/l1tf:Mitigation: PTE Inversion
    /sys/devices/system/cpu/vulnerabilities/mds:Vulnerable; SMT Host state unknown
    /sys/devices/system/cpu/vulnerabilities/meltdown:Vulnerable
    /sys/devices/system/cpu/vulnerabilities/spec_store_bypass:Vulnerable
    /sys/devices/system/cpu/vulnerabilities/spectre_v1:Vulnerable: __user pointer sanitization and usercopy barriers only; no swapgs barriers
    /sys/devices/system/cpu/vulnerabilities/spectre_v2:Vulnerable, STIBP: disabled
    /sys/devices/system/cpu/vulnerabilities/tsx_async_abort:Not affected

运行一些基准测试，并检查你将获得的性能，然后决定是否有必要禁用所有功能。

我已经警告过:对于家庭或单用户计算机，此技巧是一个有用且明智的选择。但不建议用于生产系统。

参考：

    什么叫旁路（Side Channel）攻击呢？就是说，在你的程序正常通讯通道之外，产生了一种边缘特征，这些特征反映了你不想产生的信息，这个信息被人拿到了，你就泄密了。这个边缘特征产生的信息通道，就叫旁路。比如你的内存在运算的时候，产生了一个电波，这个电波反映了内存中的内容的，有人用特定的手段收集到这个电波，这就产生了一个旁路了。基于旁路的攻击，就称为旁路攻击。这个论文对这种攻击有一个归纳：https://csrc.nist.gov/csrc/media/events/physical-security-testing-workshop/documents/papers/physecpaper19.pdf。读者可以体会一下可能的攻击方法：时延，异常（Fault），能耗，电磁，噪声，可见光，错误消息，频率，JTag等等，反正你运行总是有边缘特征的，一不小心这个边缘特征就成了泄密的机会。

    缓冲时延（Cache Timing）旁路是通过内存访问时间的不同来产生的旁路。假设你访问一个变量，这个变量在内存中，这需要上百个时钟周期才能完成，但如果你访问过一次，这个变量被加载到缓冲（Cache）中了，下次你再访问，可能几个时钟周期就可以完成了。这样，如果我攻击一个对象（比如一个进程，或者内核），要得到其中某个地址ptr的内容，我只要和它共享一个数组，然后诱导它用ptr的内容作为下标访问这个数组，然后我检查这个数组每个成员的访问时间，我就可以知道ptr的值了。

### 如何用本地账户安装 WINDOWS 11

WINDOWS 11 最低要求硬盘分区大于 52GB ...

安装 Windows 11 时，如果你的设备已经连接到互联网，它就会强制要求微软账户。

Windows版本（通常是Windows 10及以后的版本）允许用户使用两种不同类型的账户工作。目前默认情况下，Windows提供使用微软账户。这是一个在线账户，可以连接到微软自己的服务和应用程序，并带来额外的功能，如OneDrive，Office等。

本地账户是过去的经典账户类型，在Windows的旧版本中已经使用了多年。它不能用来与其他微软服务合作，但它可以使用空密码，不需要密码。值得注意的是，在其他方面，它对隐私的保护要好得多。一些Windows用户仍然喜欢这种传统的登录方式。

    rufus 在制作启动 U 盘时直接可以选择使用本地账户了

法一：在 Windows 安装程序开始之前就关闭互联网

启动计算机之前拔掉网线，否则安装程序会记住该连接是可用的。当互联网被禁用时，Windows 将只被迫提供你的本地账户来登录。

法二：使用应答文件来安装 WINDOWS 11，无需微软账户。

    https://schneegans.de/windows/unattend-generator/

    https://www.elevenforum.com/t/sharing-some-helpful-answer-files-to-bypass-win-11-setup-requirements-and-more.3300/

只要在你的可启动USB驱动器或镜像的根部创建这个文件 autounattend.xml 文件，它就会为你自动完成以下任务

    适用版本 Windows 11 Pro

    创建一个本地账户 User，密码 "password"

    创建本地管理员账户 Admin，密码 "password"

    跳过选择wifi网络

    隐私策略设置为严格

文件内容如下：

```xml
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
    <settings pass="offlineServicing"></settings>
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-Setup" processorArchitecture="x86" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <UserData>
                <ProductKey>
                    <Key>VK7JG-NPHTM-C97JM-9MPGT-3V66T</Key>
                </ProductKey>
                <AcceptEula>true</AcceptEula>
            </UserData>
        </component>
        <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <UserData>
                <ProductKey>
                    <Key>VK7JG-NPHTM-C97JM-9MPGT-3V66T</Key>
                </ProductKey>
                <AcceptEula>true</AcceptEula>
            </UserData>
        </component>
    </settings>
    <settings pass="generalize"></settings>
    <settings pass="specialize"></settings>
    <settings pass="auditSystem"></settings>
    <settings pass="auditUser"></settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="x86" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <UserAccounts>
                <LocalAccounts>
                    <LocalAccount wcm:action="add">
                        <Name>Admin</Name>
                        <Group>Administrators</Group>
                        <Password>
                            <Value>password</Value>
                            <PlainText>true</PlainText>
                        </Password>
                    </LocalAccount>
                    <LocalAccount wcm:action="add">
                        <Name>User</Name>
                        <Group>Users</Group>
                        <Password>
                            <Value>password</Value>
                            <PlainText>true</PlainText>
                        </Password>
                    </LocalAccount>
                </LocalAccounts>
            </UserAccounts>
            <AutoLogon></AutoLogon>
            <OOBE>
                <ProtectYourPC>3</ProtectYourPC>
                <HideEULAPage>true</HideEULAPage>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
            </OOBE>
        </component>
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <UserAccounts>
                <LocalAccounts>
                    <LocalAccount wcm:action="add">
                        <Name>Admin</Name>
                        <Group>Administrators</Group>
                        <Password>
                            <Value>password</Value>
                            <PlainText>true</PlainText>
                        </Password>
                    </LocalAccount>
                    <LocalAccount wcm:action="add">
                        <Name>User</Name>
                        <Group>Users</Group>
                        <Password>
                            <Value>password</Value>
                            <PlainText>true</PlainText>
                        </Password>
                    </LocalAccount>
                </LocalAccounts>
            </UserAccounts>
            <AutoLogon></AutoLogon>
            <OOBE>
                <ProtectYourPC>3</ProtectYourPC>
                <HideEULAPage>true</HideEULAPage>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
            </OOBE>
        </component>
    </settings>
</unattend>
```

法三：在安装过程中设置

安裝過程, 在連到無線網路階段, 請按下 "Shift+F10" 或者 "Shift+Fn+F10" , 並且輸入以下指令,就可以跳過網路連線,建立本機帳號並且使用win11囉

    oobe\bypassnro

若是有線網路已取得ip, 可以拔除網路線, 或是使用以下指令清除網路設定

    ipconfig/release

## Intel N100处理器搭建低功耗准系统

树莓派5翻车了

    https://www.zhihu.com/question/624165420/answer/3232723191

500块钱直接上英特尔准系统了

    https://zhuanlan.zhihu.com/p/617183801

适合mini主机、工控一体机等应用场合，在家里做个简易nas服务器也可以。最大的优点是功耗低，24 小时开着也没几个钱的电费。对散热要求也低，这些准系统部分配置的是笔记本级别的散热风扇，噪音不大。也有直接采用铝合金外壳散热，配合固态硬盘，整机真正做到零风噪。

缺点是，跟笔记本电脑的 cpu 一样，不管什么档次的 cpu，在桌面环境下使用中隔一阵就卡顿一下，无解。所以只适合装 Linux 的纯命令行，做个低功耗家用服务器还行，省电。

N100 性能参数：

    核心数：4C4T；
    基础频率：1.8GHz；
    单核最高睿频：3.40 GHz；
    全部核心最高睿频：3.20 GHz；
    CPU缓存：6 MB Intel® Smart Cache
    TDP功耗：6W；

N100 核心显卡参数：

    显卡型号：英特尔® 超核芯显卡
    GPU最大频率：0.75 GHz；
    运算单元：24EU单元；
    最大显存：8 GB；
    最大分辨率：4096 x 2160@60Hz

N100 内存支持参数：

    内存频率：DDR4-3200, DDR5-4800, LPDDR5-4800；
    最大内存：16 GB；
    最大内存通道：1通道，只能用一条内存；

N100 性能级别可以大概看成个奔腾 G7400 的缩水版，能干的事参考奔腾的评测就行。算是把低端 CPU 性能抬上来不少，能流畅运行 Win11 了。

N100 跑分对比 Intel 笔记本用低压 CPU，不是 hq 那种：

    跑分超越了大部分 i3 七代 CPU

    可以达到 i5 六代低压 CPU 的水平

    超越了 i7 五代所有常见的笔记本CPU，对比 i7 六代相对差一点

主板带宽不高，一共有 9 条 PCIe 3.0 通道，零刻分别把它分配给了前置 USB 两条、后置 USB 一条、Type-C 一条、2.5G 网卡两条、SATA 硬盘一条、WiFi 一条，然后 NVMe 硬盘就剩下一条了。注意很多机子外部接口过多的时候，给 M2 硬盘的带宽就只有 x1 了，系统 IO 性能会大大受限。

功耗对比

    實測功耗跑 Win11 在 20 瓦左右, 如果換成 Linux 用的 Ubuntu 22.04 LTS 會下降很多大概 10 幾出頭大概 12 瓦, 沒有負載會回落到 7 瓦, 我之前用的樹莓派 4B 跑的網站和數據庫這些服務, 正常功耗 3 瓦, 高負載 5 瓦左右, 總體來説 ARM 功耗相比 X86 優勢還是很明顯的, 不過 N100 這顆性能確實要比樹莓派的强太多了

完美兼容 x86 体系

    主要是 arm 架构编译安装很多东西都会有额外的问题，比如当时刚拿到树莓派，用来装 Nginx 和 MySQL 这些，跑一半报错然后又要去 DeBug 然后发现 arm 还需要先打上某某包，然后再重新跑，太多这样需要折腾的问题，换成 x86 基本都是闭眼装，而且 N100 比树莓派上博通那颗 soc 强大太多了，虽然说功耗可能多了两三倍但是性能的提升绝不止两三倍，再加上自带的核显也要比树莓派那个强太多太多，我还测试了装 Win11 正常去办公玩游戏，顺手测了一个 StoryTeller，能 30 帧玩。
