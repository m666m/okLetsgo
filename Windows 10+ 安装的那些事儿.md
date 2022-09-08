
# Windows 10+ 安装的那些事儿

## 必须了解的关键概念

### 应用/APP

跟以前的 application 区别，那个是 Windows 桌面版的 exe 程序，俗称应用程序。

现在的 app 来自于安卓的称呼，专用于手机，俗称应用。

微软的 Windows 10+为了打通手机和桌面操作系统，把 app 商店这一套都移植到 Windows 了
（而且开发工具也在打通，一套 API 可以在多个 os 平台无缝自适应运行），
所以现在的 Windows 里的“应用”这个词，特指商店里安装的那些“app”。

### 目标系统类型 UEFI/CSM

UEFI 模式是 Windows 7 之后出现的新型操作系统启动引导方式，跳过很多硬件自检，加速了开机步骤，缺点是跟 Windows 7 之前的系统启动过程不兼容。

固件加载操作系统的方式在经典 BIOS（或 CSM 模式下的 UEFI）和原生 UEFI 之间完全不同。为区别于新式的 UEFI，主板 BIOS 设置中提供了兼容老的启动方式的选项“CSM 模式”，CSM 模式从 BIOS 引导设备，用于在引导时检查兼容性模式，适用于不兼容 UEFI 方式启动的老显卡等设备能正常的显示。

具体来说，CSM 模式提供硬盘 MBR 引导和传统 PCI opROM 加载支持，后者可以让没有 GOP 的显卡在操作系统启动前（例如 bios 设置和 OS 引导器）可以使用并固定使用 VGA 分辨率。只要用到其中一个功能就需要打开 CSM。

早期的 Windows 7 无法很好地支持 UEFI，因此需要 CSM 来检测 UEFI 功能是否已完全启用。也就是说，主板 BIOS 在 CSM 模式下，对 UEFI 进行支持（甚至提供选项使用非 UEFI 的最古老方式），但是这跟 Windows 10 的那种开机后直接 UEFI 引导操作系统快速进入桌面有区别。

有些如 Nvidia gtx 1080 时代的显卡，用 HDMI 口可以用 UEFI 方式显示画面，而 DP 口则不兼容（只能通过 CSM 模式下的 UEFI 进行显示），需要根据连接该口开机后显示器是否出现画面来设置 BIOS 的上述选项。

在 Windows 10/11 安装之前，如果要享受快速启动进入桌面，则需要在主板的 BIOS 设置中明确开启 UEFI 选项，在主板 BIOS 设置中，启动模式选项（Windows 10 Features）要选择“Windows 10”而不是“other os”，CMS 模式选择“关闭”。

技嘉主板要注意，CMS 模式开启时，关于存储和 PCIe 设备的选项要保证是 UEFI 模式，然后再关闭 CSM 模式。原因详见下面章节 [技嘉主板 BIOS 设置 UEFI + GPT 模式启动 Windows]

### 硬盘分区类型 GPT/MBR

经典 BIOS（或 CSM 模式下的 UEFI）和原生 UEFI 之间完全不同。一个主要的区别是，硬盘分区在硬盘上的记录方式。虽然经典的 BIOS 和 UEFI 在 CSM 模式下使用 DOS 分区表，但是原生 UEFI 使用不同的分区方案，称为 “GUID分区表”（GPT）。在单个磁盘上，为了所有的实际目的，只能使用两个中的一个，并且在一个磁盘上使用不同操作系统的多引导设置的情况下，所有系统都必须使用相同类型的分区表。使用 GPT 从磁盘引导只能在原生 UEFI 模式下进行<https://www.debian.org/releases/stable/amd64/ch03s06.zh-cn.html#UEFI>。

MBR 是 Windows 10/7 之前老的硬盘分区方式， GPT 是 Win7 之后新的硬盘分区方式，使用不同的硬盘分区类型，Windows 引导启动的方式是不同的。

在 Windows 安装时，有个步骤是划分硬盘分区，自动使用的是 GPT 方式，默认把启动硬盘上划分了 3 个分区（如果是一块新的未划分分区的硬盘），其中两个特殊的小分区在 Windows 安装完成后默认是隐藏看不到的，这里其实放置了存储设备的 UEFI 引导信息。
所以如果只想用一个分区，需要提前把硬盘挂到别的电脑上用 Windows 管理或其他软件分区，明确选择类型为 MBR，或者在Windows安装程序界面按 Shift+F10 调出命令行，使用命令行 diskpart 程序。

目前发现 Windows 10 安装程序根据 BIOS 设置里把存储设备设为 UEFI 才会给硬盘用 GPT 类型分区，否则会用 MBR 类型分区，但是安装的时候是不给出任何提示的。

这样用 MBR 类型的硬盘安装好的 Windows 10，虽然也像 GPT 类型的硬盘一样分成了 3 个区，其实只是保持在 CSM 模式下的 UEFI 方式的兼容而已，系统启动其实是走的主板 CSM 模式，存储设备 leagcy，不会绕开 bios 引导自检那些耗时过程。即使这时进入主板 BIOS 设置里，把存储设备改为 UEFI，该 MBR 硬盘启动系统的时候会转主板的 CMS 模式下的 UEFI 方式，利用 Windows 安装时的 UEFI 分区引导系统，这样还是绕不开系统 bios 引导自检步骤的，无法实现 Windows 10 真正的 UEFI 方式启动系统那样秒进桌面。详见下面章节 [技嘉主板 BIOS 设置 UEFI + GPT 模式启动 Windows] 中的踩坑经历。

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

    UEFI 标准 2.x，推出了一个叫做 SecureBoot 的功能。开了 SecureBoot 功能之后，主板会验证即将加载的 efi 文件的签名，如果开发者不是受信任的开发者，就会拒绝加载。所以主板厂商需要提前在主板里内置微软的公钥，设备商想做 efi 文件需要去微软做认证取得签名，这样主板加载 efi 的时候会用内置的微软的公钥验证设备商 efi 文件里的签名，通过了才加载。这个过程从头到位都得微软认证，满满的对 linux 不友好啊。

    目前Debian包含一个由Microsoft签名的“shim”启动加载程序，因此可以在启用了安全引导的系统上正常工作<https://www.debian.org/releases/stable/amd64/ch03s06.en.html#secure-boot>。

首先各种 PCI-E 的设备，比如显卡，比如 PCI-E 的 NVMe 固态硬盘，都有固件。其中支持 UEFI 的设备，比如 10 系列的 Nvidia 显卡，固件里就会有对应的 UEFI 的驱动。

UEFI 启动后，进入了 DXE 阶段，就开始加载设备驱动，然后 UEFI 就会有设备列表了。启动过程中的 DXE 阶段，全称叫 Driver eXecution Environment，就是加载驱动用的。

对于其中的磁盘，UEFI 会加载对应的驱动解析其中的分区表（GPT 和 MBR）。
然后 UEFI 就会有所有分区的列表了。然后 UEFI 就会用内置的文件系统驱动，解析每个分区。UEFI 标准里，钦定的文件系统，FAT32.efi 是每个主板都会带的。所有 UEFI 的主板都认识 FAT32 分区。这就是 UEFI 的 Windows 安装盘为啥非得是 FAT32 的，UEFI 模式安装好的的 Windows 操作系统，也会有个默认的 FAT32 格式的 EFI 分区，就是保存的这个信息以便主板读取加载。苹果的主板还会支持 hfs 分区，linux 如果有专用主板，那应该会支持 EXT4.efi 分区。

然后 UEFI 就会认识分区里的文件了。比如“\EFI\Boot\bootX64.efi”。UEFI 规范里，在 GPT 分区表的基础上，规定了一个 EFI 系统分区（EFI System Partition，ESP），ESP 要格式化成 FAT32，EFI 启动文件要放在“\EFI\<厂商>”文件夹下面。比如 Windows 的 UEFI 启动文件，都在“\EFI\Microsoft”下面。

如同 Windows 可以安装驱动一样，UEFI 也能在后期加载驱动。比如 CloverX64.efi 启动之后，会加载、EFI\Clover\drivers64UEFI 下的所有驱动。包括 VboxHFS.efi 等各种 efi。网上你也能搜到 NTFS.efi。再比如，UEFIShell 下，你可以手动执行命令加载驱动。

根据 UEFI 标准里说的，你可以把启动u盘里的“\EFI\Clover”文件夹，拷贝到硬盘里的 ESP 对应的路径下。然后把“\EFI\Clover\CloverX64.efi”添加为 UEFI 的文件启动项就行了。Windows 的 BCD 命令，其实也可以添加 UEFI 启动项。

EFI 分区中的“\EFI\Boot”这个文件夹，放谁家的程序都行。无论是“\EFI\Microsoft\Boot\Bootmgfw.efi”，还是“\EFI\Clover\CloverX64.efi”，只要放到“\EFI\Boot”下并且改名“bootX64.efi”，就能在没添加文件启动项的情况下，默认加载对应的系统。

BIOS 下：

    BIOS 加载某个磁盘 MBR 的启动代码，这里特指 Windows 的引导代码，这段代码会查找活动分区（BIOS 不认识活动分区，但这段代码认识活动分区）的位置，加载并执行活动分区的 PBR（另一段引导程序）。

    Windows 的 PBR 认识 FAT32 和 NTFS 两种分区，找到分区根目录的 bootmgr 文件，加载、执行 bootmgr。

    bootmgr 没了 MBR 和 PBR 的大小限制，可以做更多的事。它会加载并分析 BCD 启动项存储。而且 bootmgr 可以跨越磁盘读取文件了。所以无论你有几个磁盘，你在多少块磁盘上装了 Windows，一个电脑只需要一个 bootmgr 就行了。bootmgr 会去加载某磁盘某 NTFS 分区的“\Windows\System32\WinLoad.exe”，后面启动 Windows 的事就由 WinLoad.exe 来完成了。

UEFI 下：

    “UEFI 下，启动盘是 ESP 分区，跟 Windows 不是同一个分区”。

    主板 UEFI 初始化，在 EFI 系统分区（ESP）找到了默认启动项“Windows Boot Manager”，里面写了 bootmgfw.efi 的位置。固件加载 bootmgfw.efi。bootmgfw.efi 根据 BCD 启动项存储，找到装 Windows 的那个磁盘的具体分区，加载其中的 WinLoad.efi。由 WinLoad.efi 完成剩下的启动工作。

#### UEFI 之后真的没法 Ghost 了么

【Windows 10 下使用“系统映像备份”备份到别的硬盘，以后可以选择重启到WinRe进行恢复，不需要用ghost了】，详见下面章节[系统映像备份]。

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

    参考自 <https://zhuanlan.zhihu.com/p/149099252>

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

主板 BIOS 设置 UEFI 启动如果没找到 GPT 分区，就会自动转 CSM 模式，通过 MBR 分区表引导 UEFI 模式的 Windows 进行启动。

#### 参考

    本文来源 https://zhuanlan.zhihu.com/p/31365115

    BCDBoot 命令行选项 https://docs.microsoft.com/zh-cn/Windows-hardware/manufacture/desktop/bcdboot-command-line-options-techref-di

    BCDEdit 命令行选项 https://docs.microsoft.com/zh-cn/Windows-hardware/manufacture/desktop/bcdedit-command-line-options

## 技嘉 B560M AORUS PRO 主板（BIOS 版本 F7） + Intel 11600KF CPU + DDR4 3600 内存的初始 BIOS 设置

1. HDMI 口连接显示器（防止老显卡的 DP 口不支持默认的 UEFI），开机按 Del 键进入主板 BIOS 设置。

2. F7 装载系统默认优化设置：BOOT->Load optimized defaults，F10 保存设置并立刻重启计算机。然后再重新进入主板 BIOS 设置做进一步设置。如果连续改一堆设置，在BIOS里就死机，估计是bios系统没初始化好。改的太多它自己就乱了或bios电池没激活导致的。所以如果有很多功能要调整，别连续改，改一个系列的就保存设置重启计算机一次。

3. 注意这之后引导操作系统默认是 UEFI 的，存储设备选项需要手动打开 CSM 后切换，详见后面的章节 [技嘉主板 BIOS 设置 UEFI + GPT 模式启动 Windows]。

4. 内存：TWEAKS->Memory， 选择 X.M.P profiles，以启用 3600MHz 最优频率，这个版本的 BIOS 也已经自动放开了，我的这个内存默认 1.2v 跑到了 3900MHz。

5. AVX512: Advanced CPU settings-> AVX settings，选 custom，出现的 avx512 选项选择 disable，关闭这个无用功能，可以降低 20%的 cpu 整体功耗。

6. 虚拟化：Advanced CPU settings-> Hyper Threading 选项打开英特尔 CPU 超线程； Settings-> MISC-> VT-d 选项打开虚拟机。

7. F6 风扇设置：对各个风扇选静音模式，或手动，先选全速看看最大转速多少，再切换手动，先拉曲线到最低转速，然后再横向找不同的温度调整风扇转速挡位。

8. BIOS开启UEFI + GPT 和 Secure Boot： 先 F10 保存设置并重启计算机，然后再进行设置，详见下面相关章节[Windows 启用 Secure Boot 功能]

9. 开启“UEFI Fast Boot”，这样关机后的再次开机很快。参见下面章节 [开启或关闭“快速启动”]

### 电源功耗 PL1/PL2

不用设了，这个版本的 BIOS 已经全放开了。开机默认就是 4.6GHz

先默认状态烤个机：在 AIDA 的 FPU 烤机测试中，我们可以看到 10700K 最终在接近70℃左右的温度下运行在了 4.5GHz 左右，功耗保持在 125W 左右。通过对记录文件的分析，开启测试后 10700K 频率保持在 4.7G Hz全核心（140W），3 分钟之后掉到了 4.5GHz~4.6GHz 之间跳动。通过这一点判断，B560M AORUS PRO AX 一阶段功耗控制约 140W，二阶段功耗控制在 125W。

其实你只需要在BIOS里面设置一下就可以让他不降频。我把CPU的核心电压降低到1.25v，其他不动然后再进行烤机。这个时候我们的10700K就可以工作再65摄氏度4.7GHz左右了，功耗只有121W。也就是说只要不突破它的功耗限制就不会发生降频。

如果我拿一个10900K装到这个主板上再降压都会被限制睿频的提升？没错，但是还有其他办法，那就是解锁功耗墙。

在BIOS中找到“进阶处理器设置”，然后找到“TurboPower限制”，然后把功耗限制1/功耗限制2都设置到较高的值，对于10代酷睿 220W以上就足够了，当然也可以直接设置到最高，然后再把电流极限也拉高，可以直接到256。

那么这个时候也是可以稳定运行在4.7GHz的，只不过功耗和温度都有所提升。如果各位使用的是10900K或者11900K/11700K的话可以参考以上两种方法进行设置，解锁功耗墙的同时适当降压获得更低的功耗和温度。

有人肯定会担心降压会影响稳定性和单核心最高睿频，这个是没有错的，所以我说“适当降压”，大家可以0.01的幅度降压然后反复测试找到自己CPU的“甜蜜点”（每个CPU体质不尽相同）。我降压1.25v时单核心性能时稍稍有点落后，但是多核心相差很少的：降压1.24v

参考 <https://zhuanlan.zhihu.com/p/359307098> <https://zhuanlan.zhihu.com/p/403675380>

### 内存超频大于3600MHz会分频实际效果变差

3200MHz、3600MHz频率内存最适合于B560主板+11代酷睿平台。这样的频率下并没有分频。当超频至4000MHz时，虽然内存带宽有所增加，但是延迟却比3600MHz高出不少，这是Gear2分频模式下带来的弊端。除非将内存超至4400MHz或以上高频，同时保持较好的时序。那内存带宽提升的同时，延迟也会降下来。

## Windows 启用 Secure Boot 功能

    https://docs.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-secure-boot
    https://docs.microsoft.com/zh-cn/windows-hardware/design/device-experiences/oem-secure-boot

下面几点，是 Windows 的安装程序确认可以启用 Secure Boot 功能的前提。如果设置不正确，它不会给出提示，只是默默的换用兼容的CSM模式进行安装。在Windows安装完才能验证是否启用了 Secure Boot 功能。

### 一、启动 Windows安装程序前，主板 BIOS 设置 UEFI + GPT 模式

“UEFI + GPT”模式结合“快速启动（Fast Boot）”功能打开后，关机之后的开机，都是直接厂商 logo 转一圈就直接进系统的，不会再有主板自检启动画面和 Windows 启动的画面。

UEFI 引导会直接跳过硬件检测。过程如下：引导→UEFI 初始化→加载系统→进入系统。传统的 BIOS 在加载系统之前需要进行一系列的硬件检查。

#### 1. 确保“启动模式”、“存储”和 “PCIe 设备” 都是 UEFI 模式

重启开机后按 F2 进入 bios，选 BOOT 选项卡：

    启动模式选项（Windows 10 Features）要选择“Windows 10”而不是“other os”。

    选项 “CSM Support”， 先选“Enable”，之后下面出现的三项，除了网卡启动的那个选项不用管，其它两个关于“存储”和“PCIe 设备”的选项要确认选的是“UEFI”。

    然后选项 “CSM Support”， 再选“Disable”关闭 CMS 模式。

    CMS 模式关闭后，当前系统内的 PCIe 设备应该是出现了一些选项可以进行设置，比如“Advanced”界面 PCI  Subsystem setting 下 RX30 系列显卡的支持 Resize Bar 等

这样系统才能默认用 Windows 的 UEFI 模式快速启动（HDMI线安装无视CSM模式开启，好神奇），安装后的 Windows 会开启Secure Boot功能。

为什么要 CSM 模式又开又关这样操作呢？Windows 10 安装的时候我踩了个坑

因为我的老显卡不支持UEFI下DP口开机显示，初次安装用了HDMI线，而且为了兼容使用了CSM模式安装的：BIOS 设置里“Windows 10 Features”选择“other os”，“CSM Support”选“Enable”，存储和 PCIe 设备都选择“UEFI” 安装了 Windows 10。而且，用HDMI线安装 Windows 10 即使是CSM模式，也能开机秒进桌面，应该是Windows默认开启了FAST BOOT。见章节[老显卡不支持 DP 口开机显示（Nvidia Geforce 1080 系）]。

后来显卡升级了 BIOS，又关闭主板 CMS 模式，重新安装了 Windows 10 21H1，在主板 BIOS 设置里装载默认值“Load optimized defaults”（默认把存储设备换回了 legacy），然后设置“Windows 10 Features”选择“Windows 10”，“CSM Support”选“Disable”，但是忘记把存储设备换回 UEFI 类型了，Windows 安装程序自动把硬盘格式化为 MBR 类型了。

这样装完 Windows 开机启动后，估计是主板尝试 UEFI 没有引导成功，自动转为 CSM 模式走 bios+UEFI 的过程，导致Windows下无法开启Secure Boot功能。

    后来升级了显卡bios支持UEFI下的DP口显示后，我重装了Windows，在主板 BIOS 设置中启动模式选项（Windows 10 Features）选择“Windows 10”，“CSM Support”选项选择“Disable”后下面的三个选项自动隐藏了，我以为都是自动 UEFI 了，其实技嘉主板只是把选项隐藏了，硬盘模式保持了上次安装 Windows 时设置的 legacy 不是 UEFI……

    这样导致我的 Windows 引导还是走的老模式，UEFI 引导硬盘其实没用上，装完后 Windows 启动没有实现秒进桌面才发现的这个问题。

    原因在于，Windows 安装程序是根据当前 BIOS 设置的引导方式，来决定对硬盘格式化为哪个分区类型，只有 BIOS 里把“CSM Support”模式 enable 后出现的存储设备类型设为 UEFI 才会默认用 GPT 类型，设为 legacy 就会默认用 MBR 类型，设好后还得把“CSM Support”禁用选 disable 才行。

总结来说，Windows 10 的安装兼容各种老设备，最古老的一种是主板 BIOS 设置里“Windows 10 Features”选择“other os”，“CSM Support”选“Enable”，存储和 PCIe 设备都选择“leagcy”，也可以安装 Windows 10，但是就无法享受真正 UEFI FAST BOOT 引导系统的秒进桌面了。

总之，完美的做法，应该在 BIOS 设置中“Windows 10 Features”选择“Windows 10”，“CSM Support”选项选择“Enable”后出现的存储和 PCIe 设备的选项都选择“UEFI”，然后再把“CSM Support”选项选择“Disable”。在使用 Rufus 制作安装u盘时也要选择“GPT+UEFI”方式，再用这样的u盘启动计算机安装Windows。这样安装后的 Windows 才能实现开启Secure Boot功能。

UEFI 模式DP口刚开机时，屏幕自动使用显示器的物理分辨率，出现的主板厂商 logo 画面应该是比较小的原始图片尺寸，没有经过拉伸等分辨率调整。

我的 Nvidia 1080 显卡目前只能在 HDMI 口连接时实现这个效果，DP 口连接时主板厂商 logo 画面被自动拉伸了，暂无法确定是否在显示器的物理分辨率下。

#### 2.SATA 硬盘使用“AHCI”模式

确认下主板 BIOS 的“settings”界面中，“SATA And RST configuration”的选项，硬盘模式为“AHCI”，这个一般主板都是默认开启的。如果硬盘不是这个模式，后续的 Windows 安装程序会默认把Windows的启动模式转为CSM模式。。。

#### 验证

启动 Windows 后运行 msinfo32，在“系统摘要”界面找“BIOS 模式”选项，看到结果是“UEFI”。

### 二、主板 BIOS 开启 Secure Boot 功能

其实 Secure Boot 是 UEIF 设置中的一个子规格，简单的来说就是一个参数设置选项，它的作用是主板UEFI启动时只加载经过认证的操作系统或者硬件驱动程序，从而防止恶意软件侵入。

1.先开启 UEFI 功能

    见前面的章节 [确保“启动模式”、“存储”和 “PCIe 设备” 都是 UEFI 模式]

2.设置“Secure Boot”为“Enable”并导入设备商出厂密钥

在 BIOS 中，仅仅设置“Secure Boot”项为“Enable”还不够，这个只是开启，并没有激活。

选择进入“Secure Boot”界面，这时可以看到，“Secure Boot”为“Enable”，但是出现“Not Active”字样。

如果是“Not Active”，则需要导入出厂密钥：

    选择“Secure Boot Mode”为“custom”，打开用户模式

    下面的灰色选项“Restore Factory keys”可以点击了，敲一下，弹出画面选择确认，以安装出厂默认密钥。

    这时的“Secure Boot”下面会出现“Active”字样

    F10 储存并退出重启系统。

确认

    在“Settings”界面中的“IO Ports”选项里，查看对应的 PCIe 设备，比如网卡、nvme硬盘等。能正确显示设备名称，可以选择查看信息或设置选项。这表示 PCIe 设备的带数字签名的 UEFI 驱动，已经被BIOS正确加载了。

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

3.“Secure Boot Mode”导入出厂密钥后，要再改回“Standard”

在主板 BIOS 底部显示的操作提示是再改回“Standard”。

F10保存重启计算机，再次进入 BIOS 设置，把“Secure Boot Mode”改回“Standard”，这时“Secure Boot”依然是“Active”字样，说明密钥都导入成功了。

不大明白为嘛技嘉没提供个详细的操作说明呢？

### 三、Windows安装u盘使用 UEFI 模式启动计算机

对 Rufus 制作的 Windows 安装u盘来说，制作时要选择“gpt+UEFI（非 CSM)”。

主板 BIOS 在启动选择菜单，对u盘有两个选项，注意要选择带有“UEFI”字样的那个u盘启动。

这两样都符合了，Windows 安装程序才会认为计算机是完全的 UEFI 模式，对硬盘的操作默认采用 GPT 类型。

验证：

    cmd 管理员模式，进入 diskpart

    >list disk

    查看对应磁盘的 Gpt 那一列，是否有星号，有就是确认 GPT 磁盘了

Debian包含一个由Microsoft签名的“shim”启动加载程序，因此可以在启用了安全引导的系统上正常工作<https://www.debian.org/releases/stable/amd64/ch03s06.en.html#secure-boot>。

### 四、确保硬盘格式化为 GPT 类型

因为 Windows 安装程序遇到不满足条件就会无提示转为CSM模式安装，所以不管新老硬盘，都建议把硬盘分区全删后新建安装。

验证

    Windows安装后，在控制面板进入磁盘管理，在磁盘 0 上点击右键，看看“转换成 GPT 磁盘”是可用的而不是灰色的不可用？如果是，那么说明当前磁盘的分区格式不是 GPT 类型，大概率是 MBR 类型。真正的 GPT 磁盘，只提供“转换成 MBR 磁盘”选项。

参考 <https://www.163.com/dy/article/FTJ5LN090531NEQA.html>

另外：三星 SSD 硬盘的管理程序 Samsung Magican 里，不要设置 Over Provisioning 功能。原因参见上面第一节的踩坑经历。

### 验证

启动 Windows 后运行 msinfo32，在“系统摘要”界面找“安全启动”选项，看到结果是“开启”。

## 用 Rufus 制作启动u盘安装 Windows11

建议使用英文版 Windows iso 文件制作启动u盘，安装时区域选择“新加坡”，然后系统语言切换为简体中文，或英文版用美国安装后添加中文语言包再更改界面提示语言为简体中文，原因不解释了。

安装 Windows11 除了硬件要求之外，还有 2 个必要条件：

1.主板 BIOS 开启 TPM2.0

    进入主板 BIOS 设置的“Settings”，选择“Intel Platform Trust Technology(PTT)”，选择“Enable”，下面的选项“Trusted Computing”回车，进入的设置界面，找“Security Device Support”选择“Enable”。

2.主板 BIOS 开启安全启动（Secure Boot）

    见前面的章节 [主板 BIOS 开启 Secure Boot 功能]

用 Rufus 制作启动u盘时，分区类型要选择 GPT（这时目标系统类型自动选择 UEFI），这样的开机过程直接可以跳过 BIOS 自检等一堆耗时过程，U 盘启动用 UEFI+GPT，秒进引导系统，也符合 Windows 11 的启动要求（如果u盘用 MBR 模式启动，那主板 BIOS 也得设置存储设备为非 UEFI，则 Windows 11 安装程序默认的格式化硬盘就不是 GPT 类型了……）。

特殊之处在于 Rufus 3.17 版之前制作的启动u盘，初始引导启动需要临时关闭“Secure Boot”（3.17 之后的版本不用了，已经取得 Windows 的签名了）：

    一、根据 Rufus 的要求 <https://github.com/pbatard/Rufus/wiki/FAQ#Windows_11_and_Secure_Boot>，见下面的章节 [老显卡不支持 DP 口开机显示（Nvidia Geforce 1080 系）] 中的 [凑合方案：主板 BIOS 设置为 CSM 方式安装 Windows 可以连接 DP 口]。

    用 Rufus 制作的启动u盘（制作时的选项是“分区类型 GPT+目标系统类型 UEFI”）启动计算机，Windows 安装程序自动启动，按提示点选下一步，注意原硬盘分区建议全删，这时 Windows 安装程序开始拷贝文件，并未实质进入配置计算机硬件系统的过程，这时的 Windows 安装过程并不要求 Secure Boot。

    注：觉得 Secure Boot 关闭就不安全了？ 不，它本来就不是什么安全措施，只是名字叫安全，其实做的工作就是数字签名验证，而且微软的密钥已经在 2016 年就泄露了…… 参见<https://github.com/pbatard/Rufus/wiki/FAQ#Why_do_I_need_to_disable_Secure_Boot_to_use_UEFINTFS>。至于 linux，没参与微软的这个步骤的话，主板厂商不会内置它的公钥到主板中，估计安装的时候就不能开启这个选项。

    二、在 Windows 安装程序拷贝完文件，提示进行第一次重启的时候，重新打开 BIOS 的“Secure Boot”选项：

    重启后按 F2 进入 bios 设置，选 BOOT 选项卡，

        找到“Windows 10 Features” 设置为 “Windows 10”

        之后下面的选项“CSM Support”会消失，故其原来设置的 Disabled 或 Enable 没啥用了，同时下面的三个选项也会消失，都不需要了

        之后下面出现的是“Secure Boot”选项，选择 Enable，按 F10 保存退出，主板重启后自动引导硬盘上的 Windows 安装程序进行后续的安装配置工作

        注意：主板 BIOS 的选项 Windows 10 feature 设置为“win10”后，原来用 MBR 方式安装的 win7 或 win10 就进不了系统了，除非还原为“other os”

## 使用 Rufus 制作 ghost 启动盘

制作时引导类型选择“FreeDos”就行了，完成后把 ghost 拷贝到u盘上，以后用它开机引导直接进入 dos 命令行方式，运行命令 ghost 即可。

<https://qastack.cn/superuser/1228136/what-version-of-ms-dos-does-rufus-use-to-make-bootable-usbs>

如果引导类型选择“grub”，那你得准备 menu.list 文件，引导到对应的 img 文件上。

对 Windows 10 + 来说，推荐直接使用 Windows 自带的系统映像备份，参见下面章节[系统映像备份]。

## 主板 BIOS 打开网络唤醒功能

根据产品规格指出，此产品有提供网络唤醒 (Wake On LAN) 的功能，但是找不到相关设定或是开关可以启用该选项。

首先，请在开机时进入 BIOS 设定程序，在电源管理选项中，请启用 PME EVENT WAKEUP 功能，然后储存设定退出程序，再重新启动进入 Windows 后，请开启设备管理器窗口，检查网络卡内容并开启唤醒功能相关设定即可。
如果使用的网络卡上有 WOL 接头，需配合主板上 WOL 接头；如果使用的网络卡上没有 WOL 接头，且它的规格是 PCI 2.3，则依上述的方法即可。

<https://www.gigabyte.cn/Motherboard/B560M-AORUS-PRO-rev-10/support#support-dl-driver>

注意：确认 Windows 10 快速启动功能是否关闭，参见下面章节 [开启或关闭“快速启动”]  <https://www.asus.com.cn/support/FAQ/1045950>

## 主板开启待机状态 USB 口供电功能和定时自动开机功能

BIOS 中的“Erp”(ErP 为 Energy-related Products 欧洲能耗有关联的产品节能要求）选项选择开启，

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

    <https://www.asus.com.cn/support/FAQ/1042220> <https://www.asus.com.cn/support/FAQ/1043640>

## 设置带集成 usb-hub 拓展坞的显示器

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

    自带的两个 5W 的音响

    拓展坞带 1Ghz 网卡接口

    OSD按键具有独立的信号源切换按键、独立的SmartImage按键、独立的自定义按键，你可以将这个自定义按键设置成切换音源、调出音量菜单、调节睿动光感灵敏度、调出亮度条、选择PIP/PBP模式、选择KVM设备。简直是效率神器，不用再OSD菜单里慢慢找了，一个按键就能完事。

以下功能，都需要连接到集成 usb-hub

90W typeC

    笔记本电脑连接只需要一根线，同时提供图像显示和供电。

USB 3.2

    显示器画面可以输出3440*1440@60Hz 8bit、3440*1440@100Hz 6bit

USB 2.0

    显示器画面才能达到满血的3440*1440@100Hz 8bit。如果你不外挂硬盘的话，那么这也不会成为缺点。

PBP分屏

    usb-tpyec 的线连接笔记本电脑后，可以分隔一半屏幕显示笔记本电脑的桌面内容

    配合 sumsung dex 外接三星Galaxy手机，windows10下装好驱动，可以显示手机桌面

    显示器设置 kvm usb up，开启 基础的usb-hub。

PIP功能

    画中画，另一个设备的桌面用小窗显示

KVM功能

    显示器可以根据信号源自动调整KVM，信号源切换到笔记本，HUB上的设备也都全部切到PS5上。信号源切回电脑，HUB上的设备自然也就全部切回电脑。这个功能真的非常棒，直接将有线键鼠当成多模键鼠使用。

    也可设置在OSD中切换，一套鼠标键盘，操作笔记本和台式机，适用于PBP分屏功能

PBP分屏注意

     关机黑屏，三星 Galaxy 手机 DEX 连接显示器集成的 usb-hub

    拔下来之后 Windows 才能继续关机。。。

在 Windows 下不要开启 HDR 效果，只在相关软件和游戏内设置开启HDR，参见章节 [显示器在 Win10 开启 HDR 变灰泛白的原因]。

### 开启 HDR 玩 Doom

显示器分辨率切换到 60hz，全屏使用最佳，不然游戏容易死机。

开启HDR时，显示器的睿动光感、环境光、低蓝光模式、SmartImage等等功能均不可用

    如果游戏设置了开启 HDR，在进入游戏时显示器会自动切换到标准模式，打完游戏需要手工调整，切换回节能模式。

## 装完 Windows 10 后的一些设置

    先激活

    Windows 安装后，先把电源计划调整为“高性能”或“卓越性能”，省的它各种乱省电，系统反应不正常的时候你根本猜不出啥原因导致的。

    关闭 Windows 搜索，这玩意非常没用，但是总是在闲时扫描硬盘，太浪费硬盘和电了。

    设置：设备->自动播放->关闭自动运行。

    设置：系统->多任务处理，按 ALT+TAB 将显示“仅打开的窗口”，不然开了一堆 edge 窗口都给你切换上，太乱了。

    设置：个性化->任务栏，合并任务栏按钮，选择“任务栏已满时”，不然多开窗口非常不方便在任务栏上选择切换。

    设置：轻松使用->键盘，那些“粘滞键”、“切换键”啥的热键统统关掉

    设置：隐私策略各种关闭，这个大部分都是针对 app 商店里的应用，有空的时候挨个琢磨吧

打开 Windows store，菜单选择“settings”，把“App updates”的“Update apps automatically”选项抓紧关闭了，太烦人了！

Windows 商店应用默认不提供卸载选项，解决办法见下面章节 [删除无关占用 cpu 时间的项目]

如果有程序开机就启动挺烦人的，运行“msconfig”，在启动选项卡进行筛选

命令行查看各功能是否开启:

    dism /online /get-features

更多的定制化见 tenforums 的各种教程 <https://www.tenforums.com/tutorials/id-Customization/>

### 选择开启虚拟化功能

Windows 10 系统安全的基础目前有向虚拟化方面加强的趋势，所以本章节跟下面的‘设置Windows安全中心’并列。

如果主板 BIOS 设置中关于 Intel CPU 虚拟化选项如 vt-d、hyper-threading 的设置没有打开，则可能有些依赖虚拟机的隔离浏览的选项不可用，需要去主板 BIOS 设置中打开。

Windows 10 默认的虚拟化功能开放的较少，增强功能需要手动安装：设置->应用->应用和功能->可选功能，点击右侧的“更多 Windows 功能”，弹出窗口选择“启用和关闭 Windows 功能”：

    Hyper-V (Windows Hypervisor)

    Windows 虚拟机监控程序平台 (Windows Hypervisor Platform)

    虚拟机平台 (Virtual Machine Platform)

    适用于 Linux 的 Windows 子系统（这个是WSL安装 Linux 用的，不是安全必备，顺手装上吧）

关于这几个功能的解释

    Hyper-V: is Microsoft's Hypervisor.

    Windows Hypervisor Platform - "Enables virtualization software to run on the Windows hypervisor" and at one time was required for Docker on Windows. The Hypervisor platform is an API that third-party developers can use in order to use Hyper-V. Oracle VirtualBox, Docker, and QEMU are examples of these projects.

    Virtual Machine Platform - "Enables platform support for virtual machines" and is required for WSL2. Virtual Machine Platform can be used to create MSIX Application packages for an App-V or MSI.

    https://superuser.com/questions/1510172/hyper-v-vs-virtual-machine-platform-vs-Windows-hypervisor-platform-settings-in-p
    https://zhuanlan.zhihu.com/p/381969738
    https://superuser.com/questions/1556521/virtual-machine-platform-in-win-10-2004-is-hyper-v

### 设置 Windows 安全中心

开始->运行：msinfo32，在“系统摘要”页面，查看状态是“关闭”的那些安全相关选项，逐个解决。

Windows 10 默认没有安装的某些增强性安全功能组件是依赖虚拟化的，需要先手动安装虚拟化功能，见章节[选择开启虚拟化功能]。

+ 手动安装单独的安全组件：

    设置->应用->应用和功能->可选功能，点击右侧的“更多 Windows 功能”，弹出窗口选择“启用和关闭 Windows 功能”：

        Microsoft Defender 应用程序防护

        Windows 沙盒(Windows Sandbox)

+ 设置 Windows安全中心

  设置->更新和安全->Windows 安全中心，左侧页面点击“打开 Windows 安全中心”

    ->应用和浏览器控制，打开“隔离浏览（WDAG）”
        <https://docs.microsoft.com/zh-cn/Windows/security/threat-protection/microsoft-defender-application-guard/install-md-app-guard>

    ->设备安全性->内核隔离，手动开启“内存完整性”
        <https://support.microsoft.com/zh-cn/Windows/afa11526-de57-b1c5-599f-3a4c6a61c5e2>

        <https://go.microsoft.com/fwlink/?linkid=866348>

    在“设备安全性”屏幕的底部，如果显示“你的设备满足增强型硬件安全性要求”，那就是基本都打开了。

    如果“内核隔离”类别中缺少“内核 DMA 保护”、“固件保护”等选项，在主板BIOS (IOMMU) 中启用 Hyper-V 虚拟化，并在 Windows 功能中安装Hyper-V。
        <https://docs.microsoft.com/en-us/Windows/security/information-protection/kernel-dma-protection-for-thunderbolt#using-system-information>

        <https://docs.microsoft.com/zh-cn/Windows-hardware/design/device-experiences/oem-kernel-dma-protection>

    如果想显示“你的设备超出增强的硬件安全性要求”，需要在下面的页面慢慢研究如何开启。
        <https://docs.microsoft.com/zh-cn/Windows/security/information-protection/kernel-dma-protection-for-thunderbolt>

        <https://docs.microsoft.com/zh-cn/Windows/security/threat-protection/Windows-defender-system-guard/system-guard-secure-launch-and-smm-protection>

验证：启动 Windows 后以管理员权限运行 msinfo32，在“系统摘要”界面查看

    “内核 DMA 保护”选项，“启用”
    “基于虚拟化的安全 xxx”等选项，有详细描述信息

更多关于 Windows10 安全性要求的选项参见各个子目录章节 <https://docs.microsoft.com/zh-cn/Windows-hardware/design/device-experiences/oem-highly-secure#what-makes-a-secured-core-pc>

基于虚拟化的安全 Virtualization Based Security(VBS) 详细介绍 <https://docs.microsoft.com/zh-cn/Windows-hardware/design/device-experiences/oem-vbs>

整个 Windows 安全体系，挨个看吧 <https://docs.microsoft.com/zh-cn/Windows/security/>

### 默认键盘设置为英文

中文版 Windows 10 默认唯一键盘是中文，而且中文键盘的默认输入法是微软拼音的中文状态。原 Windows 7 之前“Ctrl+空格”切换中英文的热键被微软拼音输入法使用了，而且按 shift 键就切换中英文，默认还是各个应用的窗口统一使用的。

问题是 桌面/资源管理器/炒股/游戏/网页浏览器 等软件的默认状态是响应英文输入，应该仅对文本编辑软件启用中文输入。在实际使用中，各个软件只要切换窗口，或者输入个字母就弹出中文候选字对话框，按个 shift 键就来回切换中英文，非常非常非常的繁琐。尤其在有些游戏中，一按 shift 就切出来中文输入法，再按 asdw 就变成打字到中文输入法的输入栏了。

所以需要再添加一个“英文键盘”，使用它的英文输入法状态，并把这个键盘作为默认状态。两种键盘间切换使用热键“Win+空格”。这样做的好处是，切换键盘的同时中英文输入法也跟着切换了（不需要依赖在中文键盘下微软拼音输入法的 shift 键切换），而且不同的窗口还可以选择记住不同的输入法状态，非常方便。

设置->搜索“语言”，选择"英语"，添加确认，注意取消选择“设置为默认的界面语言”。

点击右侧按钮“拼写、键入和键盘设置”（设置->设备->输入），把输入提示、输入建议什么的都去掉，不然你按 Ctrl+空格的时候会给你好看。

点击下面的“高级键盘设置”（设置->搜索“keyboard”，“高级键盘设置”），操作如下步骤：

    替换默认输入法，选择“英语”，而不是微软拼音输入法。这样对 Windows 桌面/资源管理器/炒股/游戏等软件的默认状态是英文按键的正确状态。

    勾选“允许我为每个应用窗口使用不同的输入法”，这个非常重要，可以实现有的窗口是英文键盘状态，有的编辑软件窗口保持是切换到中文键盘的微软拼音输入法状态。

    注意这两种键盘的切换热键是“Win+空格”，以后中英文输入的切换就切换键盘就行了，除非中文输入状态下临时输入英文按下 shift 键切换。

    取消勾选“使用桌面语言栏”，这个也很重要，某些全屏 HDR 游戏不兼容这个工具栏，一旦出来输入法条，显示器的 HDR 状态就跟着来回黑屏切换……

    选择“语言栏选项”，勾选“在任务栏中显示其他语言栏图标”，方便鼠标点选切换中英文键盘。

    选择“语言栏选项”，点击“高级键设置”：在“输入语言的热键”列表，点击“输入法/非输入法切换  Ctrl+空格”，点击“更改按键顺序”，取消勾选“启用按键顺序”可以禁用微软拼音输入法的中英文切换使用此按键，因为现在用 shift 键就够了。

### 切换黑暗模式（夜间模式）

次选：设置->系统->显示：选择打开“夜间模式”，Windows 只是把色温降成黄色，显示器亮度还是很晃眼。

优选：设置->轻松使用->颜色滤镜：选择“打开颜色滤镜”，选择“灰度”按钮，显示器变成黑白效果，失去了彩色，也不舒服。

最优选：设置->个性化->颜色：下面有个“更多选项”，对“选择默认应用模式”选择“暗”，整个 Windows 的配色方案都变成了暗色，各个软件窗口也跟着变了。这个办法最舒服，白天切换回去也很方便。写到注册表里，在桌面点击右键实现方便切换

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

edge 浏览器->设置->外观->整体外观：选择“系统默认”则跟随 Windows 系统的主题颜色变换，缺点是仅窗口标签外观变换。如果需要对网页内容开启夜间模式，需要强制开启：

    在浏览器地址栏输入 edge://flags/

    在搜索栏输入“Force Dark Mode for Web Contents”

    选择 enable，点击选择重启浏览器，除图片以外的所有部分进入夜间模式

### 安装 Microsoft Edge 浏览器插件

注意设置右键插件图标，选择扩展在哪些网站生效，尽量缩小插件的生效范围。

    uBlock Origin

    最终启用右键单击：“读取和更改站点数据”配置为“单击扩展时”

    Git Master 在 github web页面添加导航树：“读取和更改站点数据”配置仅读取 github、gitee、gitlab 站点
        https://github.com/ineo6/git-master
    同类还有 https://github.com/ovity/octotree

    smartUp 手势：配置中增加“摇杆手势”
        https://github.com/zimocode/smartup
    同类有个 clean crxMouse Gestures 但是没有开源且不更新了。

    Aria2 for Edge：“读取和更改站点数据”配置为“单击扩展时”，配合开源的使用aria2的下载程序[Motrix](https://github.com/agalwood/Motrix/)，打开rpc，端口统一16800，设置相同的api key。

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

2022年的 Windows 10 已经默认打开了。

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

重启 explorer.exe

### 为 Windows 10 Enterprise LTSC 增加应用商店

    只有2019版 https://github.com/kkkgo/LTSC-Add-MicrosoftStore
        这个已经更新到2021LTSC版了 https://github.com/GFOXSH/LTSC-Add-MicrosoftStore

要开始安装，请打包下载 LTSC-Add-MicrosoftStore-2019.zip 后用右键管理员运行 Add-Store.cmd

如果您不想安装 App Installer / Purchase App / Xbox，请在运行安装之前删除对应的。appxbundle 后缀的文件。但是，如果您计划安装游戏，或带有购买选项的应用，则不要删除。

如果装完之后商店仍然打不开，请先重启试试。如果仍然不行，请以管理员身份打开命令提示符并运行以下命令之后，然后再重启试试。
PowerShell -ExecutionPolicy Unrestricted -Command "& {$manifest = (Get-AppxPackage Microsoft.WindowsStore).InstallLocation + '\AppxManifest.xml' ; Add-AppxPackage -DisableDevelopmentMode -Register $manifest}"

商店修复
Win+R 打开运行，输入 WSReset.exe 回车。
该命令会清空并重置 Windows Store 商店的所有缓存。

该脚本由 abbodi1406 贡献：
<https://forums.mydigitallife.net/threads/add-store-to-Windows-10-enterprise-ltsc-LTSC.70741/page-30#post-1468779>

### 关闭 Windows 自带的压缩文件夹（zip folder）

Windows 10 下发现取消这个组件，居然有 Windows 更新的安装包报错的情况，建议用开源的 7-zip 软件替换 zip 文件的打开方式，不要取消Windows的zip组件。

    管理员身份运行 7-zip 软件，菜单“工具”->“选项”，弹出的窗口选择“系统”选项卡，列出的类型中，zip 选择“7-zip”

### 开启网络邻居

如果你的计算机连接的是家庭网络或办公网络，则Windows 10的默认网络类型需要更改，不然无法在网络邻居中被别的计算机发现。

在Windows10、Windows11与windows7、xp、2000共享文件中，设置网络邻居

在资源管理器地址栏通过【双左斜杠+ip】即可进行快速访问。如共享文件的旧电脑ip为【192.168.1.100】，在新电脑上资源管理器地址栏输入【\\192.168.1.100\c$】

防火墙【公网】场景导致的无法ping通或网络邻居看不到：“网络和Internet设置-属性-网络配置文件”将网络场景改为【专用】

网络和共享中心\高级共享设置：将“专用”场景的“文件和打印共享”、“网络发现”选项都开启。

### 关闭 Windows defender杀毒软件

[方法失效]

### 系统信息中，“设备加密支持”选项的结果有“失败”字样

以管理员权限运行 msinfo32，在“系统摘要”界面查看，根据具体描述进行调整

#### 不允许使用的DMA设备

参见 <https://docs.microsoft.com/zh-cn/Windows-hardware/design/device-experiences/oem-bitlocker#un-allowed-dma-capable-busdevices-detected>

#### 设备不是 InstantGo

待机(S0 低电量待机)功能比较新，截至2022年仅部分笔记本电脑实现该功能了，而且功能不稳定，耗电情况不如之前的睡眠模式好。

S0 新式待机（Modern Standby），可实现类似手机锁屏后的秒开机。在最初，它叫做Instant-on，Windows 8上市的时候叫做Connected Standby，后改名叫做InstantGo，在Windows 10为了包容性，改名Modern Standby（现代待机），包含Connected Standby和Disconnected Standby两种模式。<https://docs.microsoft.com/en-us/Windows-hardware/design/device-experiences/modern-standby-vs-s3>

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

为防止待机时有黑客手工把硬件接入计算机，connected standby这个功能需要TPM2.0的支持，并进行一系列的加密防护，所以，这些功能都跟安全加密功能有关联。

如果在Windows安全里启用了内核保护的内存完整性，则它的虚拟机程序会禁用混合睡眠，因为内存隔离区不允许复制。参见 <https://forums.tomshardware.com/threads/hybrid-sleep-and-Windows-10-hypervisor.3699339/> 下面这个提问者直接关闭了虚拟机，其实是通过关闭内存完整性保护实现了混合睡眠，意义不大。相关的类似有
使用 WSL2 的虚拟化开启后，Windows10 无法睡眠，合盖后自动睡眠但无法唤醒系统，只能通过电源键强制重启来重启系统等。<https://support.microsoft.com/en-us/topic/connected-standby-is-not-available-when-the-hyper-v-role-is-enabled-4af35556-6065-35aa-ed01-f8aef90f2027>

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

“快速启动”跟上面的两个条目讨论的 InstantGo 和 WinRe 有依赖关系，所以不单独开章节。

这功能是 Windows 关机后操作系统暂存挂起功能，类似休眠+睡眠，而且他跟主板 BIOS 设置中的 UEFI Fast Boot 功能关联，二者互相起作用，实现关机后的再次开机非常快。

原理

    快速启动设计初衷是，「如果用户关机只是想要电脑回到初始化状态，为什么我们不将这种状态存储到「休眠文件」中，以实现更快的开机速度呢？」

    引入原来的“休眠”功能，先结束掉所有用户进程（比如你开的word，浏览器之类的），内存里保留内核及系统相关的模块，还有一部分驱动。然后把它们写到硬盘里的一个文件里，这样下次开机直接把它们加载进内存。

    为了秒开，又引入原来的“睡眠”功能，在操作系统把内存里的内核部分写入休眠文件后，计算机进入「混合睡眠」模式，其实是低功耗待机状态。

快速启动意味着你上次的关机并不是完全关机，所以笔记本电脑用户会发现关机的电脑没几天电池就没电了；有些人的电脑开机后需要重启一次才能恢复正常，因为上一次关机并不是真正的关机，而重启时执行的关机才是真正的关机。

对添加或更换硬件的计算机来说，因为 bios 和 Windows 会综合判断这次开机是否可以启用上次的快速启动文件和系统状态，但是不保证判断失误。所以在更换硬件之前，关机后务必关闭电源拔掉电池，以防止操作系统因为不兼容这个硬件的状态判断错了，导致开机之后的 Windows 不稳定或不识别你的新硬件。

晕了没？

验证：

    打开任务管理器，查看[性能]选项卡，“正常运行时间”中显示的是你上次重启后到现在的运行时间。如果你关机时快速启动功能是打开的，这个时间就不会清零。
    在[启动]选项卡里的“上次bios所用时间”，也会不一样，快速启动功能开启后会减小。

缺陷

它使 BIOS 里定时自动开机失效，并跟很多 usb 设备不兼容，导致关机下次启动以后 usb 设备不可用，需要重新插拔。

比如我的无线网卡、我的显示器集成的 usb-hub 连接的鼠标键盘网卡显示器等等，开机或重启后偶发无响应需要重新插拔……

影响linux双引导：<https://www.debian.org/releases/stable/amd64/ch03s06.zh-cn.html#disable-fast-boot>

如果启用了快速启动，你真正需要重启计算机的时候，操作不能是关机，需要热键，具体说明如下：

    点关机按钮，执行的是休眠+睡眠，下次开机会秒开。

    点重启按钮，执行的是注销并登陆Windows，会秒重启完。 注意通过这种重启你无法按F8进入「恢复模式」。

    按住 Shift 点关机按钮，此次关机后的再次开机将不使用快速启动。

    按住 Shift 点重启按钮，会让电脑重启进入「恢复模式」的WinRe。

或者使用命令行关机

    shutdown /r     完全关闭并重启计算机。
    shutdown /r /o  完全关闭转到WinRe高级启动选项菜单并重新启动计算机。

关闭“快速启动”

    打开 设置-系统-电源和睡眠-其他电源设置（或右击开始菜单 (win+x)，选择“电源选项”，弹出窗口的右侧选择“其它电源设置”），

    点击“选择电源按钮的功能”，选择“更改当前不可用的设置”，

    去掉勾选“启用快速启动（推荐）”，然后点击保存修改。

    主板BIOS中的FAST BOOT选项也要关闭。

## 备份和恢复选项

详见 Windows 中的恢复选项 <https://support.microsoft.com/zh-cn/Windows/Windows-%E4%B8%AD%E7%9A%84%E6%81%A2%E5%A4%8D%E9%80%89%E9%A1%B9-31ce2444-7de3-818c-d626-e3b5a3024da5>

### 备份

Windows 10 继承和扩展了 Win7 的各种级别的备份和恢复，概念比较多，注意区别。

#### 系统还原

设置-系统-关于：点开右上角的“系统信息”，系统保护-系统还原

在 Windows 操作系统安装更新补丁/驱动程序/应用等对系统稳定性可能有影响的改动时，对操作系统的文件做的还原点备份，出现问题时可以通过回退解决。一般只设置操作系统所在的c盘开启这个功能，其它盘不需要。

对注册表庞大系统变慢了，电脑用久了各种垃圾文件一大堆，导致的系统变慢，解决不了。

#### 文件历史记录

设置-更新和安全-备份：

这个是按时间同步复制你的用户home文件夹到别的硬盘，因为现在有很多应用和数据是安装到用户的home文件夹的，计算机使用久了这个目录会变得硕大无比。

如果home文件夹里的内容有误删除，可以恢复。

如果是装的东西太多，导致系统变慢，反安装软件后系统还是有垃圾文件，解决不了。

#### 恢复驱动器

Windows 搜索 “恢复驱动器”，或选择“控制面板”>“恢复”。

恢复驱动器不是系统映像，其中不包含你的个人文件(home目录)、设置和程序。

安装到u盘上的WinRe，可备份系统文件（可选择不备份，则只有WinRe了），不备份个人文件(home目录)和自行安装的应用程序。

这个功能目前还是用的 Win7 的，用于无法启动计算机的时候，重新初始化你的Windows系统到刚安装完的状态，可以选择保留你的个人文件(home目录)。

#### 系统映像备份

按文件备份你的C盘到别的存储盘，可以替代用 ghost 按硬盘扇区做系统镜像进行备份的方式。

在你的Windows安装完各种软件，做完各种设置后，备份一个系统映像最方便，他会在你指定的硬盘（恢复驱动器）自动用一个目录保留各种安装好的程序和设置。

这个功能目前还是用的 Win7 的，设置-更新和安全-备份：点击“转到备份和还原 (Windows 7)”。

或在任务栏上的搜索框中键入控制面板。 然后依次选择“控制面板”>“系统和安全”>“备份和还原 (Windows 7)”。

创建系统映像的官方文档：恢复 Windows 到备份时点的状态 <https://support.microsoft.com/zh-cn/Windows/%E5%A4%87%E4%BB%BD%E5%92%8C%E8%BF%98%E5%8E%9FWindows-352091d2-bb9d-3ea3-ed18-52ef2b88cbef#WindowsVersion=Windows_10>

### 恢复

重置此电脑（初始化此电脑）

    恢复 Windows 到刚安装完的状态，只保留你的个人文件(home目录)，删除你安装的应用和驱动程序，选项“预安装的应用”指OEM厂商随机的软件是否保留。 跟前面的“恢复驱动器”U盘做的事儿是一样的。

高级启动

    就是不使用“快速启动”模式的关机再开机初始化的过程，下次开机会进入 WinRe 环境，在WinRe里面选择对前面章节中各种备份的恢复。

这两个恢复选项，其实都是启动到你的计算机本地c盘的WinRe保留区。

如果计算机彻底无法启动，则需要使用上面章节“恢复驱动器”制作的u盘来启动，使用u盘上的WinRe。

### Windows RE

Windows RE(简称 WinRe)的全称为 Windows Recovery Environment，即 Windows 恢复环境。

Windows RE实质上是提供了一些恢复工具的 Windows PE，预安装了「系统还原」、「命令提示符」、「系统重置」等CMD实用工具，以Winre.wim镜像文件的形式，储存于操作系统安装分区的「C:\Recovery\WindowsRE」中。

磁盘管理器中的c盘，默认有个恢复分区500MB是WinRE隐藏分区，另外还有个EFI启动区100MB。

#### WinRe 的功能

重置此电脑（初始化此电脑）

    就是上面的恢复选项对应的内容。

启动修复

    使用“启动修复”功能时，WinRe 会自动监测当前操作系统存在什么问题，并自动予以修复。例如，如果MBR被修改，该功能可以帮助恢复MBR。应该是利用c盘的保留分区恢复操作系统的引导信息。

系统还原

    对应前面章节[系统还原]。如果已经自动创建过系统还原点，可以用 WinRe 还原系统到当时的状态。

系统映像恢复

    对应前面章节[系统映像备份]，可以利用 WinRe 恢复你的c盘到备份时的状态。

    疑难解答-高级选项-更多-系统映像恢复

Windows内存诊断

    该功能与启动Windows时在“工具”菜单中选择Windows内存诊断功能相同，可以诊断内存硬件的问题。

命令提示符

    WinRe 命令提示符相当于 Windows PE 命令提示符，执行某些系统修复命令如 bcdedit 等。

#### WinRe 的使用

进入 WinRe 的几个方法

    在开始菜单的"电源"按钮，按住shift点击重启。

    或在设置-更新和安全-恢复，选择“高级启动”。

    命令行模式执行：

        shutdown /r /o  完全关闭转到WinRe高级启动选项菜单并重新启动计算机。

    在开启计算机电源后的Windows加载界面狂按F8。

    最极端的方法：在Windows开机画面按住计算机的电源开关，直到关机，重复3次，Windows 引导会自动进入WinRe环境了。。。

你的电脑将重启到 Windows 恢复环境 (WinRE) 环境中，在“选择一个选项”屏幕上，选择“疑难解答”，然后在表格中选择一个功能。

## 安全的使用你的 Windows 10

+ 信息盗窃已经渗透到了驱动程序、操作系统组件、根证书级别

    制作安装u盘时，Windows iso的版本选择英文版，安装时区域选择“新加坡”，然后系统语言切换为简体中文，或英文版区域选美国安装后添加中文语言包再更改界面提示语言为简体中文，原因不解释。

    实机只安装开源的应用程序。

    淘宝等杂货铺来源的外接设备，提供的各种国内国外小公司的驱动程序，安装后**务必检查当前操作系统的证书，预期目的是<所有>**。

    cn程序特别是 QQ、微信、钉钉、360、网络游戏等安装操作系统级别的驱动程序，或支付宝、银行、12306这样安装好几个不相关的根证书，而且证书的预期目的是“所有”的，统统在虚机里安装运行。

    如果有浏览器下载的不明来源程序，虚机里都不要用，防止它偷qq密码等，这种程序只能放在Windows沙盒里运行。

    迷惑性比较强的是国外大公司出品的cn本地化版本，其实是跟cn公司合作开发出来的软件，也不要在实机里运行。

    微软中国研究院出品的cn特供版的应用，比如打着edge工具的名号等，慎用！

    Flash已转让给cn私企，禁用或Windows沙盒使用！

    中文版的FireFox等浏览器由cn公司开发，禁用！只在mozila网站下载英文版使用！

确保 Windows 安全中心的相关设置都开启，参见上面的章节 [装完Windows10后的一些设置] 里的“设置 Windows 安全中心”部分。

### 务必检查当前操作系统的证书

当今世界，普遍采用非对称加密算法对文件进行签名和验签，而非对称加密无法防御“中间人攻击”，目前的解决办法是通过建立CA认证体系，由大家公认的大机构对各公钥提供签名的方式，实现公钥交换阶段的互相认可。各厂家的浏览器、各操作系统，在出厂设置时都会内置一些CA证书，以保证连接其它CA认证的网站时可以互相验证签名，操作系统发布的程序或包，也有很多使用CA证书来验证是否原厂签发的文件，所谓保真。

数字证书保真问题在近10年非常混乱，微软在2020年后的Windows 10、11上比较多的关注这个问题，比如第三方的驱动程序自签名也能加载到操作系统内核，特别是很多小厂商的电脑部件，用户买了之后安装个驱动，不明不白的就安装了厂商自己的根证书。

如果某个不良厂商申请了CA认证，申请了“ALL”权限，则只要他的程序可以对操作系统或通信中加密的文件进行截获，比如伪装到驱动程序中的间谍软件，在网关或路由器层级设置代理的中间人攻击方式，扫描用户的本地硬盘，或网络上拦截用户发送的信息包，只要该信息是被CA认证的公钥加密的，都可以被不良厂商使用自己的对应私钥解密为明文查看。

根证书预期目的是“所有”的危险性，比如写一个Windows程序，签名用假造的证书名叫微软公司，Windows操作系统会认可为正确。<https://www.zhihu.com/question/50919835>。

现实中，大量的淘宝等杂货铺来源的usb/pcie/雷电接口的外接设备，提供的各种国内国外小公司的驱动程序，都在安装一个test证书，权限是“ALL”。对这种驱动程序，只能建议在虚拟机中隔离使用，千万不能为了方便跟你的常用电脑环境混在一起。

如果证书有问题，通信加密是完全没有作用的，对方可以随便使用一个伪造的网站如邮箱网站引导你登陆，而你的浏览器会视为真实网站，不会做任何提示。对网络通信的封包来说，如果证书有问题，在网关或路由器层面隐藏的中间人代理，完全可以使用他的私钥解密任何你发送的数据包的内容。

运行：certmgr.msc，逐个检查“受信任的根证书颁发机构”目录，重点看**预期目的是<所有 ALL>的**。

    不明来源、声誉不好的公司出品的软件，尽量在虚拟机安装使用。

    删除所有疑似跟cn相关的证书，即使来源注明是美国注册的公司，但是只要有cn投资的，统统删除，这个之前出过几次丑闻了，搜“Firefox CNNIC MCS wosign starcom OSCCA 证书” <https://zhuanlan.zhihu.com/p/34391770> <https://www.zhihu.com/question/49291684> <https://www.landian.vip/archives/15656.html>。

    Mozilla Firefox 自己维护一套可信任的 CA 证书列表；而 Chrome 使用操作系统厂商维护的可信任 CA 证书列表。Firefox Fusion 甚至用洋葱，但是，Mozilla 的 CA 认证出事不止一次了（搜“Firefox 证书” <https://wiki.mozilla.org/CA%3AWoSign_Issues>）。

Windows 10的1607版本之后，内核模式代码似乎使用了独立的信任证书库，可防止第三方的驱动程序只要有自签名就可以加载到操作系统<https://github.com/HyperSine/Windows10-CustomKernelSigners/blob/master/README.zh-CN.md>。

Windows证书的使用说明 <https://docs.microsoft.com/zh-cn/windows-hardware/drivers/install/local-machine-and-current-user-certificate-stores>

微软官方操作系统根证书列表 <https://docs.microsoft.com/zh-cn/troubleshoot/windows-server/identity/trusted-root-certificates-are-required>

Apple 操作系统中可用的受信任根证书 <https://support.apple.com/zh-cn/HT209143> <https://support.apple.com/en-us/HT209143>

Mozilla浏览器的信任列表 <https://ccadb-public.secure.force.com/mozilla/IncludedCACertificateReport>

验证

    打开地址 https://www1.cnnic.cn/，如果浏览器提示不是安全连接，则你的浏览器没有使用cnnic伪造的证书或操作系统中没有该证书。

### 1. 浏览网页时防止网页偷偷改浏览器主页等坏行为

在 edge 浏览器，点击菜单，选择“应用程序防护窗口”，这样新开的一个 edge 窗口，是在虚拟机进程启动的，任何网页操作都不会侵入到正常使用的 Windows 中。

在 Windows 安全中心里可以设置，能否从这里复制粘贴内容到正常使用的 Windows 中等各种功能。

### 2. 用沙盒运行小工具等相对不靠谱的程序

开始菜单，选择“Windows sandbox”程序，将新开一个虚拟的 Windows 窗口，把你觉得危险的程序复制粘贴到这个虚拟的 Windows 系统里运行，格式化这里的硬盘都没关系，在这个系统里可以正常上网。

这个虚拟的 Windows 窗口一旦关闭，里面的任何操作都会清零，所以可以提前把运行结果复制粘贴到正常使用的 Windows 中。

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

其中，MappedFolder 可以有多个，默认映射到桌面，也可以单独指定。关于 Windows 沙盒的详细介绍，参见 <https://docs.microsoft.com/zh-cn/Windows/security/threat-protection/Windows-sandbox/Windows-sandbox-overview>

### 3. 开源的轻量化沙盒工具

    https://github.com/sandboxie-plus/Sandboxie

QQ、微信、钉钉、360啥的很多cn软件很多都添加到系统级驱动，在这种容器化沙盒里防不住，老老实实的用虚拟机吧。

### 4. Windows 应用(APP)

1、Windows 桌面应用程序（desktop applications）

从 Windows 95 以来这几十年发展的*.exe，对操作系统底层调用 Win32 API。后来引入的VC/MFC等框架，底层都依赖Win32 API。具备对 Windows 和硬件的直接访问权限，此应用类型是需要最高级别性能和直接访问系统硬件的应用程序的理想选择。这种程序对操作系统各组件的访问，在区分用户这个级别是可以用system权限超越的，基本不受控。

2、WPF/.Net/Windows Form等新的框架

各种新的API框架，意图是统一不同硬件的操作系统，流行程度都不如 Win32 API。后来这些打包搞了个托管运行时环境(WinRT)。这种软件想流氓起来，运行时环境也控制不了。

3、通用 Windows 平台 (UWP) 应用

类似手机的方式，在 Windows 商店下载的应用(APP)，使用 UWP 组件的方式，在应用容器内部运行。

UWP 应用在其清单中声明所需的设备能力，如访问麦克风、位置、网络摄像头、USB 设备、文件等，在应用被授予能力前，由用户确认并授权该访问。UWP 核心 API 在所有 Windows 设备上是相同的。

UWP 应用可以是本机应用，也可以是托管应用。使用 C++/WinRT 编写的 UWP 应用可以访问属于 UWP 的 Win32 API。 所有 Windows 设备都实现这些 Win32 API。<https://docs.microsoft.com/zh-CN/windows/uwp/get-started/universal-application-platform-guide>

4、合订本 - Windows应用程序(Widnows App)

<https://docs.microsoft.com/zh-cn/windows/apps/get-started/?tabs=cpp-win32#other-app-types>

Widnows App 的开发涵盖了 Windows App SDK、Windows SDK 和 .NET SDK。这次好像是想搞个大一统的开发平台：原来的 Win32 API 升级成 WinRT API，对应的称呼就是变成了应用（APP）；原来的 wpf、.net、uwp 也都被大一统了。 <https://docs.microsoft.com/zh-cn/windows/apps/desktop/modernize/>；UWP 也要迁移到 Widnows App，理论上还是容器化运行。<https://docs.microsoft.com/zh-cn/windows/apps/desktop/modernize/desktop-to-uwp-extend>；安卓应用现在也可以在Windows上容器化运行。开发平台打包统一了，能再卖一波 Visual Studio，但是各类应用还是各搞各的，桌面应用的通用化没啥指望，后续看谁能流行起来再说吧。

总之，依赖在操作系统这个层面对应用程序的权限进行控制，一直做不到。目前最好的办法，只能是把操作系统包起来运行的虚拟机方式，才能完全彻底的隔离流氓软件对用户信息的侵害。也就是说，在你的 Windows 操作系统安装完毕之后，基本的用户信息都具备了，可信赖的大公司的软件都安装了，其他zh软件，统统安装到一个虚拟机里使用，不要安装到实机里。至于是使用沙盒还是hyper-v虚机，酌情决定。

### Windows S Mode

只能在设备上使用 Microsoft Store 中的应用

    https://support.microsoft.com/en-us/windows/windows-10-and-windows-11-in-s-mode-faq-851057d6-1ee9-b9e5-c30b-93baebeebc85

将应用程序二进制文件打包为 MSIX 程序包，然后通过 Microsoft Store 分发应用

    https://docs.microsoft.com/zh-cn/windows/deployment/s-mode#%E4%BF%9D%E6%8C%81%E4%B8%9A%E5%8A%A1%E7%BA%BF%E5%BA%94%E7%94%A8%E4%B8%8E%E6%A1%8C%E9%9D%A2%E6%A1%A5%E4%B8%80%E8%B5%B7%E8%BF%90%E8%A1%8C

### 神秘的 Intel 操作系统 Minix 及相关的 ME 技术

    https://www.pingwest.com/a/145461

    https://www.codenong.com/f-fact-intel-minix-case/

    https://www.elecfans.com/emb/dsp/20171113578678.html

对 IBM、Sun、HP 这些老牌计算机厂商来说，由于从芯片到主板，从编译系统到操作系统到应用软件，计算机整机的软硬件是一条龙做下来的，很多范式或做法是我们不熟悉的，比如：机房有1000台服务器需要打同一个补丁，网管如何处理？ 公司全部门办公电脑今夜统一更新固件，网管如何处理？

服务器主板一般都有一个独立的处理系统，专门为主机故障死机后操作系统无响应准备的，维护人员可以在控制台登陆，用这个简易的系统来管理基本的系统硬件或恢复操作系统，有些处理系统还支持网络连接。对服务器来说，你的操作系统启动不起来或者内存坏了硬盘挂了都没关系，用这个系统可以让维护人员很方便的处理故障。这个系统的高级点的用法，就是支持集群式的远程管理。

对x86台式机或笔记本电脑来说，一开始的时候并没有内置这么强大的服务器功能。直到2006年之后，Intel 在所有的cpu上普及了一个功能叫主动管理技术AMT，现在叫 ME 技术。

Intel 的主板芯片中有一个独立于CPU和操作系统的微处理器，而且它的电源状态与主机 OS 电源状态无关，但是深度绑定cpu，开机必须有它参与，但是你的操作系统完全看不到它的存在。ME里面有用于远程管理的功能，在出现严重漏洞的时可以在不受用户操控下远程管理企业计算机。比如：公司各部门的电脑，即使关机了，在凌晨也可以响应网管的调度统一更新计算机的固件。

我们日常的程序权限级别都是Ring 3，操作系统内核运行在Ring 0，这也是一般用户能够接触到的最低权限，MINIX则竟然深入到了Ring -3。

实际上，它不仅仅是一个微处理器：它是具有自己的处理器，内存和 I/O 的微控制器，真的就像是一台小型计算机一样。 这个小计算机系统，目前固化了一个 5MB 大小的操作系统在硬件里，据推测是基于 Andrew Tanenbaum 开发的 MINIX 3 OS，目前有文件系统、usb驱动、网卡驱动、显卡驱动等，甚至还有 tls 通信栈和一个 web 服务器...

根据设计，Intel ME可以访问主板的其他子系统。 包括RAM，网络设备和加密引擎。 而且只要主板上电即可。 此外，它可以使用主板总线的专用链接直接访问网络接口以进行带外通信，因此，即使使用Wireshark或tcpdump之类的工具监视流量，也不一定会看到Intel ME发送的数据包。

如果说只是为了方便管理，引入这么高大上的功能也无可厚非，不过管的是不是太多了

    读取硬盘上的所有文件、记录键盘和鼠标、获取截图、联网上传和下载数据、查看所有运行中的程序、分配资源、打开和关闭程序、在防火墙打开/软件断网时通过物理网线/ WiFi 传输资料、开机和关机、在关机状态下提取缓存数据、重写处理器内核等等等等……

所以有个老外急了，写了个去除AMT固件中过分干涉隐私的功能的工具，用这个工具刷机后，AMT 的固件尺寸从几 MB 降低到了 300K 左右

    https://github.com/corna/me_cleaner

另外： AMD 也有类似技术，叫PSP，全称 Platform Security Processor，逻辑不同，功能近似——一句话概括：没比英特尔强多少……

## Windows 10 使用虚拟机的几个途径

WSL2 内的 container 是 linux 提供的，不算 Windows 的容器。Windows 容器提供了两种不同的运行时隔离模式：process 和 Hyper-V 隔离，process 只在 server 版提供
<https://docs.microsoft.com/zh-cn/virtualization/Windowscontainers/manage-containers/hyperv-container>

### Hyper-V

就像普通虚拟机操作，类似 VM Ware、Virtual Box
<https://docs.microsoft.com/zh-cn/virtualization/hyper-v-on-Windows/quick-start/enable-hyper-v>

如何在 Windows 10 上使用 Hypver-V
    <https://www.tenforums.com/tutorials/2087-hyper-v-virtualization-setup-use-Windows-10-a.html>

如果启用了 Hyper-V，则这些对延迟敏感（小于10毫秒）的高精度应用程序也可能在主机中运行时出现问题。这是因为启用虚拟化后，主机操作系统也会在 Hyper-V 虚拟化层之上运行，就像来宾操作系统一样。但是，与来宾不同，主机操作系统的特殊之处在于它可以直接访问所有硬件，这意味着具有特殊硬件要求的应用程序仍然可以在主机操作系统中正常运行而不会出现问题。

### docker (Hyper-V)

Windows 10+ 上的 docker 是  WSL 2 或 Hyper-V 实现的，之前的 Windows 7 上的 docker 是安装了 virtual box 虚拟机。

    https://docs.microsoft.com/zh-cn/virtualization/Windowscontainers/about/

    https://docs.docker.com/desktop/Windows/wsl/

完整 Windows api 的是 Windows 和 Windows server，其它的是仅支持 .net，注意不同映像的区别 <https://docs.microsoft.com/zh-cn/virtualization/Windowscontainers/manage-containers/container-base-images>

### WSL 适用于 Linux 的 Windows 子系统 - 命令行安装 Ubuntu

WSL 1 虚拟机类似于程序层面的二进制转译，没有实现完整的linux，但是实现了linux程序可以在Windows上运行，但是有些功能如GUI实现的有限制。可以理解成 MingW/Cygwin 的中间层思路，但不是编译时实现，而是运行时转码这种QEMU的实现思路。 <https://docs.microsoft.com/zh-cn/Windows/wsl/compare-versions#full-system-call-compatibility>

WSL 2 在底层使用虚拟机（Hyper-V）同时运行linux内核和Windows内核，并且把Linux 完全集成到了 Windows 中，即使用起来就像在 Windows 中直接运行 linux 程序。

缺点是IO不如 WSL 1 快，见下面章节[混合使用 Windows 和 Linux 进行工作]。

开发工具可以使用 Virsual Studio Code，支持直接打开 WSL 虚机，就像连接 Docker 虚机或远程连接 SSH 服务器一样简单。其它开发工具如 git、docker、数据库、vGpu 加速（<https://developer.nvidia.com/cuda/wsl> ）等也都无缝支持，详见 <https://docs.microsoft.com/zh-cn/Windows/wsl/setup/environment>。

简单使用 Ubuntu 就一条命令

    # 安装 ubuntu，已经安装过了忽略这条
    # 详见 <https://docs.microsoft.com/Windows/wsl/install>
    wsl --install   # -d Ubuntu 默认不需要打

在 Windows 命令提示符或 PowerShell 中，可以在当前命令行中使用默认的 Linux 发行版，直接输入 bash 或 ubuntu 回车就可以了。

    # 提供 Linux 系统中的日期。
    wsl date

    查看已安装的 Linux 发行版的列表
    wsl --list 或 wsl -l -v

    # 将默认发行版设置为 Debian
    wsl --setdefault Debian 或 wsl -s Debian
    # 在 Debian 中运行 npm init 命令
    wsl npm init

#### 在 WSL 中如何访问我的 C: 驱动器

系统会自动为本地计算机上的硬盘驱动器创建装入点，通过这些装入点可以轻松访问 Windows 文件系统。

    /mnt/驱动器号>/

示例：

    运行 cd /mnt/c 访问 c:\

#### 混合使用 Windows 和 Linux 进行工作

<https://docs.microsoft.com/zh-cn/windows/wsl/filesystems>

借助 WSL，Windows 和 Linux 工具和命令可互换使用

    从 Linux 命令行（如 Ubuntu）运行 Windows 工具（如 notepad.exe ）。
    从 Windows 命令行（如 PowerShell）运行 Linux 工具（如 grep ）。
    在 Windows 与 Windows 之间共享环境变量。

不要跨操作系统使用文件，比如在存储 WSL 项目文件时：

    使用 Linux 文件系统根目录：\\wsl$\Ubuntu-18.04\home\<user name>\Project

    而不使用 Windows 文件系统根目录：/mnt/c/Users/<user name>/Project$ 或 C:\Users\<user name>\Project

<https://docs.microsoft.com/zh-cn/windows/wsl/filesystems#file-storage-and-performance-across-file-systems>

#### WSL 1 和 WSL 2 的定制安装

    <https://docs.microsoft.com/zh-cn/Windows/wsl/install-manual>

1、开启功能： WSL

首选：
Windows 设置->应用和功能，点击右侧的“程序和功能”，弹出窗口选择“启用或关闭 Windows 功能”，
在列表勾选“适用于 Linux 的 Windows 子系统”，确定。

或

```powershell

    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

```

验证

```powershell

    Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

```

到这里已经安装了 WSL 1，如果只想安装 WSL 1，现在可以重新启动计算机，然后继续执行步骤5下载安装Linux发行版了。
下面的描述都是为了安装 WSL 2 的。

2、开启功能： 虚拟机平台

```powershell

    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

```

3、下载 Linux 内核更新包，双击提权安装即可。

<https://wslstorestorage.blob.core.Windows.net/wslblob/wsl_update_x64.msi>

```powershell

    wsl --update

```

4.将 WSL 2 设置为默认版本

```powershell

    wsl --set-default-version 2

```

5.下载 Linux 发行版并安装

详见 <https://docs.microsoft.com/zh-cn/Windows/wsl/install-manual#downloading-distributions>

    <https://aka.ms/wslubuntu2004>
    <https://aka.ms/wsl-ubuntu-1604>

```powershell

    Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing

```

或

```cmd

    curl.exe -L -o ubuntu-2004.appx https://aka.ms/wsl-ubuntu-2004

```

安装：

```powershell

    Add-AppxPackage .\app_name.appx

```

注销并卸载 WSL 发行版：

```powershell

    wsl --unregister <DistributionName>

```

6.验证

```powershell

    # 更新 WSL 内核，需要管理员权限
    wsl --update

    # 查看当前 wsl 安装的版本及默认 linux 系统
    wsl --status
    默认分发：Ubuntu
    默认版本：2

    # 进入 ubuntu 系统
    wsl 或 bash

```

```shell

    # 更新下包
    sudo apt update
    # 建议更换国内源之后再做 apt-get update | apt-get upgrade

    # 看看安装的什么版本的 linux
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
```

7.配置多个 linux 系统

详见 <https://docs.microsoft.com/zh-cn/Windows/wsl/wsl-config>

8.导入任何 Linux 发行版

详见 <https://docs.microsoft.com/zh-cn/Windows/wsl/use-custom-distro>

9.WSL 命令行参考

详见 <https://docs.microsoft.com/zh-cn/Windows/wsl/basic-commands>

#### 使用了 WSL2 就只能用微软发布的 Linux 版本

<https://docs.microsoft.com/zh-cn/Windows/wsl/compare-versions#full-linux-kernel>，它提供了完全的二进制兼容，用户可以自行升级 linux 内核。

#### 可以在WSL 2的linux里再运行 docker

这个 docker 也需要是微软发布的 <https://docs.microsoft.com/zh-cn/Windows/wsl/tutorials/wsl-containers> 。

#### WSL 2的linux是放到当前用户目录下的，比较占用系统盘空间

类似于：USERPROFILE%\AppData\Local\Packages\CanonicalGroupLimited...，所以注意你的 c 盘空间。

如果需要更改存储位置，打开“设置”->“系统”-->“存储”->“更多存储设置：更改新内容的保存位置”，选择项目“新的应用将保存到”。

#### Linux 下的 GUI 应用的安装和使用

    详见 <https://docs.microsoft.com/zh-cn/Windows/wsl/tutorials/gui-apps>

#### 安装遇到问题

遇到报错试试下面这个：

    启用“适用于 Linux 的 Windows 子系统”可选功能

        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    启用“虚拟机平台”可选功能

        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    要启用 WSL，请在 PowerShell 提示符下以具有管理员权限的身份运行此命令：

        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

更多的问题，详见 <https://docs.microsoft.com/zh-cn/Windows/wsl/troubleshooting>

#### 注意：WSL 下的 Linux 命令区别于某些 PowerShell 下的命令

注意 PowerShell 对某些 linux 命令是使用了别名，而不是调用的真正的 exe 文件，有没有后缀 .exe 是有区别的！

例如，使用 curl 命令行实用程序来下载 Ubuntu 20.04 控制台命令：

    curl.exe -L -o ubuntu-2004.appx https://aka.ms/wsl-ubuntu-2004

在本示例中，将执行 curl.exe（而不仅仅是 curl），以确保在 PowerShell 中调用真正的 curl 可执行文件，而不是调用 Invoke WebRequest 的 PowerShell curl 别名。<https://docs.microsoft.com/zh-cn/Windows/wsl/install-manual#downloading-distributions>

设置->应用->应用和功能，里面有个“应用执行别名”，点击进去慢慢研究吧，微软净整些逻辑弯弯绕，真烦人啊。

详细列表参见 <https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.2>

#### Windows Store 图形化安装 Ubuntu 子系统 (WSL)

win10+ubuntu 双系统见 <https://www.cnblogs.com/masbay/p/10745170.html>

1.首先点击开始，然后点击设置

2.选择更新和安全

3.在左边点击开发者选项

4.点击开发人员模式，选择打开

5.会出现正在安装开发人员模式程序包

6.稍等片刻，大概 2 分钟左右就可以安装成功

7.然后返回，点击应用

8.在应用和功能界面，选择程序和功能

9.点击启用或关闭 Windows 功能

10.弹出的窗口中拉到最下面，勾选上适用于 Linux 的 Windows 子系统

11.然后会自动安装所需要的库

12.大约 5 秒，安装完毕后需要重启电脑

【废弃】13. 重启电脑后并没有安装 linux 系统，还需要输入 lxrun /install /y 来进行系统的下载 （win10 2020 版已经弃用此命令）

13.在 Windows 搜索框中输入网址 <https://aka.ms/wslstore> ，然后回车，之后会先打开 edge 浏览器，然后自动跳转到 win10 应用商店。
打开微软商店应用，在搜索框中输入“Linux”然后搜索，选择一个你喜欢的 Linux 发行版本然后安装。

14.然后会弹出一个 shell 窗口，正在安装。

15.安装完会提示输入用户名和密码，输入自己的就可以。

16.然后安装完成后点击打开，等待启动

17.初次使用 ubuntu

打开 cmd，输入 bash。

输入 sudo apt update 检测更新

输入 sudo apt install sl 安装小火车

输入 sl 出现火车，说明安装成功

最后要说明的一点是，这个系统是安装在 C:\Users\%user_name%\AppData\Local\lxss 中的，所以会占用 c 盘的空间，所以最好把数据之类的都保存在其他盘中，这样不至于使 c 盘急剧膨胀。

后续关于如何更换国内源、配置 ubuntu 桌面并进行 vnc 连接，参见 <https://sspai.com/post/43813>

### 使用 VM Ware、安卓模拟器等虚拟机提示需要关闭 Hyper-V

    貌似该问题已经在2022版的 Windows 10 中解决了，开启功能：虚拟机平台VirtualMachinePlatform

Vmware workstation 升级到 15.5.5 版本后就可以兼容 Hyper-V 了，但有限制：必须为 Windows 10 20H1（也叫 2004 版）或更高版本。

当基于独占设计的 Hyper-V 启用后，会持续占用，造成其他基于同类技术的虚拟机将无法启动。且部分虚拟机产品在确认检测到相应情况后还要强行执行，就造成了 Windows 死机蓝屏。

在“启用或关闭 Windows 功能”中卸载 hyper-v 功能后，依旧是提示无法安装或使用虚拟机，因为通常会启用 Hyper-V 的操作有如下几项：

    Hyper-V 平台；

    Windows Defender 应用程序防护，Windows 安全中心：“应用和浏览器保护”，关闭隔离浏览；

    Windows 沙盒；

    Windows 安全中心：设备安全性模块的的内核隔离（内存完整性）；

    Visual Studio 内涉及到设备模拟的虚拟化方案；

所以必须确保以上列表内所有项目被正确关闭后，Hyper-V 平台才能被真正关闭。据说进入主板 BIOS 将 Intel VT-x 设为 Disabled 都不行.

管理员身份运行命令提示符 cmd

        bcdedit 或 bcdedit /enum all 显示全部

查看校对"Windows 启动加载器"中对应项目的 hypervisorlaunchtype 值

#### 没有安装 hyper-V 时执行

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

#### 已经安装了hyper-V，或者 hypervisorlaunchtype 是 auto

在复制启动项的时候要注意哪一个启动项是要开启hyper-V的，“Windows10 no hyper-V”是新启动项的描述，有没有no不要弄混了。

在执行之后会得到新启动项的标识符，如果修改当前启动项，可以用bcdedit /set hypervisorlaunchtype off，
如果修改非current启动项，则需要指明标识符，bcdedit /set {标识符} hypervisorlaunchtype off

作者：风吹来的瓜
链接：<https://www.zhihu.com/question/38841757/answer/294356882>
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

Hyper-V 其实也分1代2代，tenforums 的详细说明

    <https://www.tenforums.com/tutorials/139405-run-hyper-v-virtualbox-vmware-same-computer.html>

### Windows安卓子系统WSA

Windows Subsystem for Android 在Windows Store[安装apk时默认安装](https://docs.microsoft.com/en-us/windows/android/wsa/)，Windows 11自带，目前Windows 10无法正常运行。

免美区免亚马逊安装 Windows Subsystem for Android

    https://cloud.tencent.com/developer/article/1987523
    https://zhuanlan.zhihu.com/p/437231485

## 其它常见问题

### 老显卡不支持 DP 口开机显示（Nvidia Geforce 1080 系）

#### 简单方案：连接 HDMI 口安装 Windows

主板 BIOS 设置为 GPT + UEFI 的情况下只能连接 HDMI 口安装系统。

新出技嘉主板的 BIOS 设置中，默认 BOOT 选项采用的是 GPT 分区+UEFI 引导，这样的启动u盘制作时也要选择一致的模式，这样才符合 Windows 11 的安装要求。

用 Rufus 制作 Windows 10 安装u盘，选择分区类型是 GPT（右侧的选项自动选择“UEFI(非CSM)”）而不能是 MBR，这样的启动u盘才能顺利启动。

有些如 Nvidia gtx 1080 时代的显卡，连接 HDMI 口可以兼容 UEFI 方式，而 DP 口则不兼容，应该是主板的UEFI兼容CSM模式。这样制作的安装u盘可以启动系统，但是 DP 口在开机的时候不显示，只能连接 HDMI 口安装系统。这样安装 Windows 的一个缺点是操作系统不支持 SecureBoot 功能。

#### 一劳永逸方案：Nvidia 显卡可以升级固件解决这个问题

先把显卡挂到别的能显示的机器上（或先连接 HDMI 口安装 Windows 能进入系统后），升级下固件，以后就可以实现连接 DP 口安装 Windows 10 了

    <https://www.tenforums.com/graphic-cards/144258-latest-nvidia-geforce-graphics-drivers-Windows-10-2-a.html>
        <https://www.tenforums.com/Windows-10-news/111671-nvidia-graphics-firmware-update-tool-displayport-1-3-1-4-a.html>
            Geforce 1080 系 <https://www.nvidia.com/en-us/drivers/nv-uefi-update-x64/>
            Geforce 3080 系 <https://nvidia.custhelp.com/app/answers/detail/a_id/5233/>

#### 凑合方案：主板 BIOS 设置为 CSM 方式安装 Windows 可以连接 DP 口

用 Rufus 制作 Windows 10 安装u盘，如果分区类型选择 MBR（右侧选项自动选择“BIOS+UEFI(CSM)”），则也只能连接 HDMI 口安装系统。

这时如果想使用 DP 口开机显示，则主板 BIOS 要更改设置，CSM Support（Windows 10 之前 Windows 版本安装的兼容模式，事关识别 usb 键盘鼠标和 UEFI 显卡）要选“Enable”，并设置兼容模式：

    重启开机后按 F2 进入 bios，选 BOOT 选项卡，找到 Window 10 Features，选“other os”

    之后下面出现了 CSM Support， 选“Enable”，
    之后下面出现的三项，除了网卡启动的那个选项不用管，其它两个关于存储和 PCIe 设备的选项要确认选的是“UEFI”，这样在“other os”模式下可以实现 DP 口的开机显示，要是还不行，那两个选项直接选非 UEFI 的选项。

这样安装 Windows 的一个缺点是操作系统不支持 SecureBoot 功能。

关于主板 BIOS 设置 CSM 模式可以启动 DP 口的解释 <https://nvidia.custhelp.com/app/answers/detail/a_id/3156/kw/doom/related/1>

### 主板 Ultra Fast 启动无法再用键盘进入 BIOS 设置

在操作系统中引导到 UEFI 固件设置。

很多支持 Fast Boot 的主板，在主板 BIOS 的“Fast Boot”项设置了“Ultra Fast”之后，开机过程中不能用键盘进入 BIOS 了，解决办法是在操作系统中指定下一次重启进入 BIOS。

对技嘉 B560M AORUS PRO 主板来说，实际试了一下，没感觉到 Ultra Fast 比 Fast Boot 快。
而且我的 usb 键盘鼠标网卡都挂在显示器集成的 usb hub 上，设备比较多，开机时 UEFI 加载这堆驱动没法跳过，没什么用的感觉。

UEFI 方式启动的操作系统是跟主板 BIOS 设置密切结合的，UEFI 的“Fast Boot”分几个选项，导致了初始化部分设备的限制：

    主板 BIOS 设置的“Fast Boot”项如果开启“Fast”选项，可以减少硬件自检时间，但是会存在一些功能限制，比如 Fast 模式下不能使用 USB 设备启动了，因为这个加速功能其实是在 BIOS 自检中禁止加载 USB 设备了。

    主板 BIOS 设置的“Fast Boot”项如果开启“Ultra Fast”选项，之后就不能用键盘进入 BIOS 了，估计跟 Fast 模式一样把大部分不是必须的自检过程给禁用了，所以要想进 BIOS 只能清空 CMOS 或者在操作系统里选择“重启到 UEFI”。

与此功能关联的是Windows 电源选项中的“快速启动” 见前面的章节 [开启或关闭“快速启动”]

参考说明

    <https://www.expreview.com/22043.html>
    <https://www.tenforums.com/tutorials/21284-enable-disable-fast-boot-uefi-firmware-settings-Windows.html>

#### 在 Windows 10 中指定重启到 UEFI 固件的步骤

点击“开始”菜单—选择“设置”，点击“更新和安全”，在“更新和安全”界面中点击左侧的“恢复”选项，再在右侧的“高级启动”中点击“立即重新启动”。

Windows 10 重启之后你将会看到出现一个界面提供选项，选择“疑难解答（重置你的电脑或高级选项）”

新出现的界面选择“高级选项—>UEFI 固件设置”，重启之后就可以直接引导到 UEFI 了。因为现在的BIOS都是UEFI BIOS，也就是自动进入 BIOS 设置了。

参考 <https://docs.microsoft.com/zh-cn/Windows-hardware/manufacture/desktop/boot-to-uefi-mode-or-legacy-bios-mode>

#### Linux 指定重启到 UEFI 固件的步骤

    Linux 也可以在重启时告诉系统下一次启动进入 UEFI 设置。使用 systemd 的 Linux 系统有 systemctl 工具可以设置。

    可以查看帮助：systemctl --help|grep firmware-setup

    --firmware-setup Tell the firmware to show the setup menu on next boot
    直接在命令行执行下面命令即可在下一次启动后进入 UEFI 设置。

    systemctl reboot --firmware-setup
    参考资料：https://www.freedesktop.org/software/systemd/man/systemctl.html#--firmware-setup

### 显示器在 Win10 开启 HDR 变灰泛白的原因

在游戏或播放软件里单独设置 HDR 选项就可以了，Windows 操作系统不需要打开 HDR 选项，目前的 Windows 10/11 的桌面并没有很好的适配当前的 HDR 显示器。

简单来说，为了支持桌面上显示 HDR 软件, 桌面必须声明需求显示器的完整 HDR 亮度范围，因为桌面 UI 本身不能闪瞎人眼，所以桌面 UI 的亮度是低亮度模式。而 Display HDR400-600 的显示器的 HDR 并没有低亮度细节，所以低亮度部分就发灰了。HDR 和暗部平衡差不多，都可以把暗部细节显示出来，所以看起来就像是亮度调得很高的样子，会泛白。

这个现象在 FALD/OLED 显示器上是不存在的，仅在 Display HDR400-600 的"假 HDR"显示器上存在。

原因在于 Display HDR400-600 并不是真的支持 HDR, 亮度范围根本没那么大，现有的 HDR 协议并没有体现出这一点。而 Windows 还没有对 Display HDR400 和 600 这两个"假 HDR"提供支持。微软也没辙，属于技术局限，只能等未来看微软打算怎么解决这个问题了。

折衷的办法是，显示器厂商单独出 HDR 配置文件，让 Windows 自动识别实际的 HDR 亮度范围，而不是接收显示器现在汇报的这个虚假的 HDR 亮度范围。

其实现在的 HDR 标准其实是纯凑活事，显卡信号输出了剩下的全看显示器，导致 HDR 内容的显示没有任何标准，大家效果千差万别。
这点在真 HDR 显示器上也很明显，不同品牌的 FALD 显示器效果也是完全不同的，颜色亮度各种跑偏，完全是群魔乱舞。

很多游戏内置 HDR 选项，让你单独调节亮度来适应屏幕就是这个原因。

### 取消动态磁盘

之前误把“动态磁盘”和“GPT 磁盘”混淆了，我的硬盘不幸改成了动态磁盘，Windows 不能操作他的各种分区了。

微软自己都废弃了这个“动态磁盘” <https://docs.microsoft.com/en-us/Windows-server/storage/disk-management/change-a-dynamic-disk-back-to-a-basic-disk>

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

### 如何判断 USB Type-C 口有哪些功能

    <https://www.asus.com.cn/support/FAQ/1042843>

### Windows 7/10 远程桌面报错的解决办法

Windows 7 之后微软把远程桌面做了比较大的变动

因为Windows更新自动升级，有几个补丁包不是必需安装，导致远程桌面报错无法使用，用户摸不到头脑，其实是微软没有明确告知这个变动导致的混淆。

#### 报错：无法连接

远程服务端升级到 rdp8.0 以上版本，建议客户端也升级到这个版本。

    1.Windows6.1-KB2574819-v2-x64.msu

    2.Windows6.1-KB2857650-x64.msu

    3.Windows6.1-KB2830477-x64.msu

    4.Windows6.1-KB2592687-x64.msu

远程服务端的远程桌面设置，系统属性->允许远程桌面：勾选“仅允许使用网络级别身份验证的远程桌面计算机连接（更安全）”。

#### “身份验证错误，要求的函数不受支持”

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

#### 远程桌面的开始菜单没有关机键

cmd窗口执行命令

    # 立刻关机
    shutdown -s -t 0

    # 立刻重启
    shutdown -r -t 0

### 乱七八糟的 .NET Framework 各版本安装

.NET Framework 4.x 号称是互相覆盖的，版本继承性可以延续。

#### .NET Framework 4.5 之前的 4.x 版本

M$不支持了，自求多福吧，自己挨个版本研究去 <https://docs.microsoft.com/zh-cn/dotnet/framework/install/guide-for-developers>

#### .NET Framework 4.5 及之后的 4.x 版本

从 .NET Framework 4 开始，所有 .NET Framework 版本都是就地更新的，因此，在系统中只能存在一个 4.x 版本。

#### .NET Framework 3.5 在 Windows 10 + 只能按需安装

通过 Windows 控制面板启用 .NET Framework 3.5。 此选项需要 Internet 连接。
简单点办法，安装 directx 9，Windows 自己会弹出提示要求给你安装。NET Framework 3.5。

微软自己做烂了，各个版本居然都是不兼容的 <https://docs.microsoft.com/zh-cn/dotnet/framework/install/dotnet-35-Windows> 。

警告

    如果不依赖 Windows 更新作为源来安装 .NET Framework 3.5，则必须确保严格使用来自相同的、对应的 Windows 操作系统版本的源。
    使用来自不同 Windows 操作系统版本的源将安装与 .NET Framework 3.5 不匹配的版本，或导致安装失败，使系统处于不受支持和无法提供服务的状态。

也就是说，弄个 3.5 的离线安装包，在 Windows 10 下面可能不能用。
