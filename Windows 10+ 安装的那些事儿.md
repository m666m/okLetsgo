
# Windows 10+ 安装的那些事儿

## 关键词 应用/APP

跟以前的 application 区别，那个是 Windows 桌面版的 exe 程序，俗称应用程序。

现在的 app 来自于安卓的称呼，专用于手机，俗称应用。

微软的 Windows 10+为了打通手机和桌面操作系统，把 app 商店这一套都移植到 Windows 了
（而且开发工具也在打通，一套 API 可以在多个 os 平台无缝自适应运行），
所以现在的 Windows 里的“应用”这个词，特指商店里安装的那些“app”。

## 关键词 UEFI/CSM、GPT/MBR

### 目标系统类型 UEFI/CSM

UEFI 模式是 Windows 7 之后出现的新型操作系统启动引导方式，跳过很多硬件自检，加速了开机步骤，缺点是跟 Windows 7 之前的系统启动过程不兼容。

为区别于新式的 UEFI，主板 BIOS 设置中提供了兼容老的启动方式的选项“CSM 模式”，CSM 模式从 BIOS 引导设备，用于在引导时检查兼容性模式，适用于不兼容 UEFI 方式启动的老显卡等设备能正常的显示。

具体来说，CSM 模式提供硬盘 MBR 引导和传统 PCI opROM 加载支持，后者可以让没有 GOP 的显卡在操作系统启动前（例如 bios 设置和 OS 引导器）可以使用并固定使用 VGA 分辨率。只要用到其中一个功能就需要打开 CSM。

早期的 Windows 7 无法很好地支持 UEFI，因此需要 CSM 来检测 UEFI 功能是否已完全启用。也就是说，主板 BIOS 在 CSM 模式下，对 UEFI 进行支持（甚至提供选项使用非 UEFI 的最古老方式），但是这跟 Windows 10 的那种开机后直接 UEFI 引导操作系统快速进入桌面有区别。

有些如 Nvidia gtx 1080 时代的显卡，用 HDMI 口可以用 UEFI 方式显示画面，而 DP 口则不兼容（只能通过 CSM 模式下的 UEFI 进行显示），需要根据连接该口开机后显示器是否出现画面来设置 BIOS 的上述选项。

在 Windows 10/11 安装之前，如果要享受快速启动进入桌面，则需要在主板的 BIOS 设置中明确开启 UEFI 选项，在主板 BIOS 设置中，启动模式选项（Windows 10 Features）要选择“Windows 10”而不是“other os”，CMS 模式选择“关闭”。

技嘉主板要注意，CMS 模式开启时，关于存储和 PCIe 设备的选项要保证是 UEFI 模式，然后再关闭 CSM 模式。原因详见下面章节 [技嘉主板 BIOS 设置 UEFI + GPT 模式启动 Windows]

### 硬盘分区类型 GPT/MBR

MBR 是 Windows 10/7 之前老的硬盘分区方式， GPT 是 Win7 之后新的硬盘分区方式，使用不同的硬盘分区类型，Windows 引导启动的方式是不同的。

在 Windows 安装时，有个步骤是划分硬盘分区，自动使用的是 GPT 方式，默认把启动硬盘上划分了 3 个分区（如果是一块新的未划分分区的硬盘），其中两个特殊的小分区在 Windows 安装完成后默认是隐藏看不到的，这里其实放置了存储设备的 UEFI 引导信息。
所以如果只想用一个分区，需要提前把硬盘挂到别的电脑上用 Windows 管理或其他软件分区，明确选择类型为 MBR，或者按 Shift+F10 调出命令行，使用命令行 diskpart 程序。

目前发现 Windows 10 安装程序根据 BIOS 设置里把存储设备设为 UEFI 才会给硬盘用 GPT 类型分区，否则会用 MBR 类型分区，但是安装的时候是不给出任何提示的。

这样用 MBR 类型的硬盘安装好的 Windows 10，虽然也像 GPT 类型的硬盘一样分成了 3 个区，其实只是保持在 CSM 模式下的 UEFI 方式的兼容而已，系统启动其实是走的主板 CSM 模式，存储设备 leagcy，不会绕开 bios 引导自检那些耗时过程。

即使这时进入主板 BIOS 设置里，把存储设备改为 UEFI，该 MBR 硬盘启动系统的时候会转主板的 CMS 模式下的 UEFI 方式，利用 Windows 安装时的 UEFI 分区引导系统，这样还是绕不开系统 bios 引导自检步骤的，无法实现 Windows 10 真正的 UEFI 方式启动系统那样秒进桌面。详见下面章节 [技嘉主板 BIOS 设置 UEFI + GPT 模式启动 Windows] 中的踩坑经历。

### EFI 方式加载设备驱动程序

BIOS 启动的时候，按照 CMOS 设置里的顺序，挨个存储设备看：（此处不讨论 PXE 和光盘）
    这个存储设备的前 512 字节是不是以 0x55 0xAA 结尾？
    不是，那就跳过。找下一个设备。
    是的话，嗯，这个磁盘可以启动，加载这 512 字节里的代码，然后执行。
执行之后，后面的事，几乎就跟 BIOS 没啥关系了。

UEFI 启动的时候，经过一系列初始化阶段（SEC、CAR、DXE 等），然后按照设置里的顺序，找启动项。
启动项分两种，设备启动项和文件启动项：

  ·文件启动项，大约记录的是某个磁盘的某个分区的某个路径下的某个文件。对于文件启动项，固件会直接加载这个 EFI 文件，并执行。类似于 DOS 下你敲了个 win.com 就执行了 Windows 3.2/95/98 的启动。文件不存在则失败。

  ·设备启动项，大约记录的就是“某个 U 盘”、“某个硬盘”。（此处只讨论 U 盘、硬盘）对于设备启动项，UEFI 标准规定了默认的路径“\EFI\Boot\bootX64.efi”。UEFI 会加载磁盘上的这个文件。文件不存在则失败。UEFI 标准 2.x，推出了一个叫做 SecureBoot 的功能。开了 SecureBoot 功能之后，主板会验证即将加载的 efi 文件的签名，如果开发者不是受信任的开发者，就会拒绝加载。所以主板厂商需要提前在主板里内置微软的公钥，设备商想做 efi 文件需要去微软做认证取得签名，这样主板加载 efi 的时候会用内置的微软的公钥验证设备商 efi 文件里的签名，通过了才加载。这个过程从头到位都得微软认证，满满的对 linux 不友好啊。

首先各种 PCI-E 的设备，比如显卡，比如 PCI-E 的 NVMe 固态硬盘，都有固件。其中支持 UEFI 的设备，比如 10 系列的 Nvidia 显卡，固件里就会有对应的 UEFI 的驱动。

UEFI 启动后，进入了 DXE 阶段，就开始加载设备驱动，然后 UEFI 就会有设备列表了。启动过程中的 DXE 阶段，全称叫 Driver eXecution Environment，就是加载驱动用的。

对于其中的磁盘，UEFI 会加载对应的驱动解析其中的分区表（GPT 和 MBR）。
然后 UEFI 就会有所有分区的列表了。然后 UEFI 就会用内置的文件系统驱动，解析每个分区。UEFI 标准里，钦定的文件系统，FAT32.efi 是每个主板都会带的。所有 UEFI 的主板都认识 FAT32 分区。这就是 UEFI 的 Windows 安装盘为啥非得是 FAT32 的，UEFI 模式安装好的的 Windows 操作系统，也会有个默认的 FAT32 格式的 EFI 分区，就是保存的这个信息以便主板读取加载。苹果的主板还会支持 hfs 分区，linux 如果有专用主板，那应该会支持 EXT4.efi 分区。

然后 UEFI 就会认识分区里的文件了。比如“\EFI\Boot\bootX64.efi”。UEFI 规范里，在 GPT 分区表的基础上，规定了一个 EFI 系统分区（EFI System Partition，ESP），ESP 要格式化成 FAT32，EFI 启动文件要放在“\EFI\<厂商>”文件夹下面。比如 Windows 的 UEFI 启动文件，都在“\EFI\Microsoft”下面。

如同 Windows 可以安装驱动一样，UEFI 也能在后期加载驱动。比如 CloverX64.efi 启动之后，会加载、EFI\Clover\drivers64UEFI 下的所有驱动。包括 VboxHFS.efi 等各种 efi。网上你也能搜到 NTFS.efi。再比如，UEFIShell 下，你可以手动执行命令加载驱动。

根据 UEFI 标准里说的，你可以把启动 u 盘里的“\EFI\Clover”文件夹，拷贝到硬盘里的 ESP 对应的路径下。然后把“\EFI\Clover\CloverX64.efi”添加为 UEFI 的文件启动项就行了。Windows 的 BCD 命令，其实也可以添加 UEFI 启动项。

EFI 分区中的“\EFI\Boot”这个文件夹，放谁家的程序都行。无论是“\EFI\Microsoft\Boot\Bootmgfw.efi”，还是“\EFI\Clover\CloverX64.efi”，只要放到“\EFI\Boot”下并且改名“bootX64.efi”，就能在没添加文件启动项的情况下，默认加载对应的系统。

BIOS 下：

    BIOS 加载某个磁盘 MBR 的启动代码，这里特指 Windows 的引导代码，这段代码会查找活动分区（BIOS 不认识活动分区，但这段代码认识活动分区）的位置，加载并执行活动分区的 PBR（另一段引导程序）。

    Windows 的 PBR 认识 FAT32 和 NTFS 两种分区，找到分区根目录的 bootmgr 文件，加载、执行 bootmgr。

    bootmgr 没了 MBR 和 PBR 的大小限制，可以做更多的事。它会加载并分析 BCD 启动项存储。而且 bootmgr 可以跨越磁盘读取文件了。所以无论你有几个磁盘，你在多少块磁盘上装了 Windows，一个电脑只需要一个 bootmgr 就行了。bootmgr 会去加载某磁盘某 NTFS 分区的“\Windows\System32\WinLoad.exe”，后面启动 Windows 的事就由 WinLoad.exe 来完成了。

UEFI 下：

    “UEFI 下，启动盘是 ESP 分区，跟 Windows 不是同一个分区”。

    主板 UEFI 初始化，在 EFI 系统分区（ESP）找到了默认启动项“Windows Boot Manager”，里面写了 bootmgfw.efi 的位置。固件加载 bootmgfw.efi。bootmgfw.efi 根据 BCD 启动项存储，找到装 Windows 的那个磁盘的具体分区，加载其中的 WinLoad.efi。由 WinLoad.efi 完成剩下的启动工作。

#### UEFI 之后真的没法 Ghost 了么

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

UEFI 下用 diskpart 进行分区的详细资料见<https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions>

#### 不需要第三方工具就能做 UEFI 下的 Windows 安装盘？

U 盘，格式化成 FAT32，然后把 Windows 安装盘的 ISO 里面的东西提取到 U 盘就行了。（适用于 Win8/8.1/10 以及 WinServer2012/2012R2/2016。WinVista x64/Win7x64 以及 WinServer2008x64/2008R2 需要额外操作，WinVista x86/Win7x86/WinServer2008x86 不支持 UEFI）

#### 电脑是 UEFI 的，想装 Linux，但我手头没优盘，听说也能搞定

硬盘搞个 FAT32 的分区，把 Linux 安装盘的 iso 镜像里面的文件/EFI/BOOT/下的 BOOTx64.efi、grubx64.efi 拷贝进去，然后在 Windows 下，用工具给那个分区的 BOOTx64.efi，添加为 UEFI 文件启动项，开机时候选那个启动项，就能启动到 Linux 安装盘了。
如果你要装的 Linux 不支持 SecureBoot，记得关掉主板 BIOS 的 SecureBoot 设置。

事实上，MBR 分区表，也能启动 UEFI 模式下的 Windows，只是 Windows 安装程序提示不允许罢了。主板 BIOS 设置 UEFI 启动如果没找到 GPT 分区，就是自动转 CSM 模式，通过 MBR 分区表引导了 UEFI 模式的 Windows。

参考

    本文来源 <https://zhuanlan.zhihu.com/p/31365115>

    BCDBoot 命令行选项 <https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/bcdboot-command-line-options-techref-di>

    BCDEdit 命令行选项 <https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/bcdedit-command-line-options>

## 技嘉 B560M AORUS PRO 主板（BIOS 版本 F7） + Intel 11600KF CPU + DDR4 3600 内存的初始 BIOS 设置

1. HDMI 口连接显示器（防止老显卡的 DP 口不支持默认的 UEFI），开机按 Del 键进入主板 BIOS 设置。

2. F7 装载系统默认优化设置：BOOT->Load optimized defaults，注意这之后引导操作系统默认是 UEFI 的，存储设备选项需要手动打开 CSM 后切换，详见后面的章节 [技嘉主板 BIOS 设置 UEFI + GPT 模式启动 Windows]。

3. F10 保存设置并重启计算机，让 optimized defaults 生效，然后再重新进入主板 BIOS 设置做后续设置。我一开始连续改东西，BIOS 里居然都死机，估计是太乱。

4. 内存：TWEAKS->Memory， 选择 X.M.P profiles，以启用 3600MHz 最优频率，这个版本的 BIOS 也已经自动放开了，我的这个内存默认 1.2v 跑到了 3900MHz。

5. AVX512: Advanced CPU settings-> AVX settings，选 custom，出现的 avx512 选项选择 disable，关闭这个无用功能，可以降低 20%的 cpu 整体功耗。电源功耗 PL1/PL2 不用设了，这个版本的 BIOS 已经全放开了。

6. 虚拟化：Advanced CPU settings-> Hyper Threading 选项打开英特尔 CPU 超线程； Settings-> MISC-> VT-d 选项打开虚拟机。

7. F6 风扇设置：对各个风扇选静音模式，或手动，先选全速看看最大转速多少，再切换手动，先拉曲线到最低转速，然后再横向找不同的温度调整风扇转速挡位。

8. UEFI + GPT + Secure Boot： 先 F10 保存设置并重启计算机，后续再设置，详见下面相关章节

## 技嘉主板 BIOS 设置 UEFI + GPT 模式启动 Windows

### 1. 确保主板 BIOS 设置中，关于启动的项目，存储和 PCIe 设备选的是 UEFI 模式

UEFI + GPT 模式一开，都是直接厂商 logo 转一圈就直接进系统的，不会再有主板启动画面和 Windows 启动的画面。

UEFI 引导会直接跳过硬件检测。过程如下：引导→UEFI 初始化→加载系统→进入系统。传统的 BIOS 在加载系统之前需要进行一系列的硬件检查。

主板 BIOS 设置中，启动模式选项（Windows 10 Features）要选择“Windows 10”而不是“other os”，CSM 模式选关闭，UEFI 硬盘和 PCIe 设备是 UEFI 模式，这样系统才能默认用 Windows 的 UEFI 模式快速启动。

重启开机后按 F2 进入 bios，选 BOOT 选项卡：

    启动模式选项（Windows 10 Features）要选择“Windows 10”而不是“other os”。

    选项 “CSM Support”， 先选“Enable”，
    之后下面出现的三项，除了网卡启动的那个选项不用管，其它两个关于存储和 PCIe 设备的选项要确认选的是“UEFI”。

    然后选项 “CSM Support”， 再选“Disable”，再关闭 CMS 模式。

    CMS 模式关闭后，当前系统内的 PCIe 设备应该是出现了一些选项可以进行设置，比如“Advanced”界面 PCI  Subsystem setting 下 RX30 系列显卡的支持 Resize Bar 等

#### 为什么要 CSM 模式又开又关这样操作呢？ Windows 10 安装的时候我踩了个坑

    我在主板 BIOS 设置中启动模式选项（Windows 10 Features）选择“Windows 10”，“CSM Support”选项选择“Disable”后下面的三个选项自动隐藏了，我以为都是自动 UEFI 了，其实技嘉主板只是把选项隐藏了，硬盘模式保持了上次安装 Windows 时设置的 legacy 不是 UEFI……

    这样导致我的 Windows 引导还是走的老模式，UEFI 引导硬盘其实没用上，装完后 Windows 启动没有实现秒进桌面才发现的这个问题。

    原因在于，Windows 安装程序是根据当前 BIOS 设置的引导方式，来决定对硬盘格式化为哪个分区类型，只有 BIOS 里把“CSM Support”模式 enable 后出现的存储设备类型设为 UEFI 才会默认用 GPT 类型，设为 legacy 就会默认用 MBR 类型，设好后还得把“CSM Support”禁用选 disable 才行。

总结来说，Windows 10 的安装兼容各种老设备，最古老的一种是主板 BIOS 设置里“Windows 10 Features”选择“other os”，“CSM Support”选“Enable”，存储和 PCIe 设备都选择“leagcy”，也可以安装 Windows 10，但是就无法享受真正 UEFI 引导系统的秒进桌面了。

我的显卡因为用 DP 口不兼容，BIOS 设置里“Windows 10 Features”选择“other os”，“CSM Support”选“Enable”，存储和 PCIe 设备都选择“UEFI”安装了 Windows 10 2019 LTSC。

后来显卡升级了 BIOS，又关闭主板 CMS 模式，重新安装了 Windows 10 21H1，在主板 BIOS 设置里装载默认值“Load optimized defaults”（默认把存储设备换回了 legacy），然后设置“Windows 10 Features”选择“Windows 10”，“CSM Support”选“Disable”，但是忘记把存储设备换回 UEFI 类型了，导致硬盘被 Windows 安装程序格式化为 MBR 类型。这样装完 Windows 开机启动后，估计是主板尝试 UEFI 没有引导成功，自动转为 CSM 模式走 bios+UEFI 的过程，导致无法秒进桌面。

总之，完美的做法，应该在 BIOS 设置中“Windows 10 Features”选择“Windows 10”，“CSM Support”选项选择“Enable”后出现的存储和 PCIe 设备的选项都选择“UEFI”，然后再把“CSM Support”选项选择“Disable”，使用 Rufus 制作安装 u 盘时也需要选择 GPT+UEFI 方式，这样 u 盘可以正常启动，这样安装好的 Windows 才能实现秒进桌面。

#### 验证主板 BIOS 设置的 UEFI 模式

    启动 Windows 后运行 msinfo32，在“系统摘要”界面找“BIOS 模式”选项，看到结果是“UEFI”。

### 2.SATA 硬盘使用“AHCI”模式

    确认下主板 BIOS 的“settings”界面中，“SATA And RST configuration”的选项，硬盘模式为“AHCI”，这个一般主板都是默认开启的。

### 3.确保 u 盘使用 UEFI 模式启动计算机，然后安装 windows

默认的，主板 BIOS 启动菜单，对 u 盘是有两个选项，注意要选择带有 UEFI 字样的那个 u 盘启动。这样的 Windows 程序才会认为是完全的 UEFI 模式，对硬盘的操作就是默认 GPT 类型了。
对 Rufus 制作的 Windows 安装 u 盘来说，制作时要选择“gpt+UEFI（非 CSM)”。

验证：

    cmd 管理员模式，进入 diskpart

    >list disk

    查看对应磁盘的 Gpt 那一列，是否有星号，有就是确认 GPT 磁盘了

### 4.确保硬盘格式化为 GPT 类型

如果你的 BIOS 设置已经选择了“UEFI”，但开机后不是直接秒进 Windows 的，那就怀疑是 Windows 安装的时候，没有把你的硬盘格式化为 GPT 模式。

    进入磁盘管理，在磁盘 0 上点击右键，看看“转换成 GPT 磁盘”是可用的而不是灰色的不可用？如果是，那么说明当前磁盘的分区格式不是 GPT 类型，而是 MBR 类型。
    真正的 GPT 磁盘，只提供“转换成 MBR 磁盘”选项。

    三星 SSD 硬盘的管理程序 Samsung Magican 里，暂时不要设置 Over Provisioning 功能。

原因参见上面第一节的踩坑经历。

参考 <https://www.163.com/dy/article/FTJ5LN090531NEQA.html>

## 技嘉主板 BIOS 设置 Secure Boot 功能

其实 secure boot 是 uefi 设置中的一个子规格，简单的来说就是一个参数设置选项，它的作用体现在主板上只能加载经过认证过的操作系统或者硬件驱动程序，从而防止恶意软件侵入。

1. 开启 UEFI 功能

    见前面的章节 [技嘉主板 BIOS 设置 UEFI + GPT 模式启动 Windows] 中的第一项“确保存储和 PCIe 设备是 UEFI 模式”

2.设置“Secure Boot”为“Enable”并导入设备商出厂密钥

在 BIOS 中，仅仅设置“Secure Boot”为“Enable”还不够，选择进入“Secure Boot”界面，这时可以看到，“Secure Boot”为“Enable”，但是出现“Not Active”字样。

如果是，则需要导入出厂密钥：

    选择“Secure Boot Mode”为“custom”，打开用户模式

    下面的灰色选项“Restore Factory keys”可以点击了，敲一下，弹出画面选择确认，以安装出厂默认密钥。

    这时的“Secure Boot”下面会出现“Active”字样

    F10 储存并退出重启系统。

注意要确认下“Settings”界面中的“IO Ports”选项里，查看对应的 PCIe 设备，比如网卡等能正确显示名称可以点击进去设置或查看信息，这表示 PCIe 卡中有带数字签名的 UEFI 驱动，否则不会被加载。

验证：启动 Windows 后运行 msinfo32，在“系统摘要”界面找“安全启动”选项，看到结果是“开启”。

补充：从华为服务器的一篇说明 <https://support.huawei.com/enterprise/zh/doc/EDOC1000039566/596b9d40>中看到，
“Secure Boot Mode”选“custom”后，在“Key Management”界面，设置“Provision Factory Default keys”为 “Enable”，打开出厂默认密钥开关，这个不知道是否必须做，也是导入密钥的操作，
看主板 BIOS 下面的说明是“Secure Boot Mode”改回“Standard”，也能让“Secure Boot”依然是“Active”。
我是按这个做的，进入 BIOS 设置，把“Secure Boot Mode”改回“Standard”，这时“Secure Boot”依然是“Active”字样，说明密钥都导入成功了

不大明白为嘛技嘉没提供个详细的操作说明呢？

## 用 Rufus 制作启动 u 盘安装 Windows11

WIN11 除了硬件要求之外，还有 2 个必要条件：

    1.主板 BIOS 开启 TPM2.0

    进入主板 BIOS 设置的“Settings”，选择“Intel Platform Trust Technology(PTT)”，选择“Enable”，下面的选项“Trusted Computing”回车，进入的设置界面，找“Security Device Support”选择“Enable”。

    2.主板 BIOS 开启安全启动（Secure Boot）

    见前面的章节 [技嘉主板 BIOS 设置 UEFI 模式下 Secure Boot 功能]

用 Rufus 制作启动 u 盘时，分区类型要选择 GPT（这时目标系统类型自动选择 UEFI），这样的开机过程直接可以跳过 BIOS 自检等一堆耗时过程，U 盘启动用 UEFI+GPT，秒进引导系统，也符合 Windows 11 的启动要求（如果 u 盘用 MBR 模式启动，那主板 BIOS 也得设置存储设备为非 UEFI，则 Windows 11 安装程序默认的格式化硬盘就不是 GPT 类型了……）。

特殊之处在于 Rufus 3.17 版之前制作的启动 u 盘，初始引导启动需要临时关闭“Secure Boot”（3.17 之后的版本不用了，已经取得 Windows 的签名了）：

    一、根据 Rufus 的要求 <https://github.com/pbatard/Rufus/wiki/FAQ#Windows_11_and_Secure_Boot>，见下面的章节 [老显卡不支持 DP 口开机显示（Nvidia Geforce 1080 系）] 中的 [凑合方案：主板 BIOS 设置为 CSM 方式安装 Windows 可以连接 DP 口]。

    用 Rufus 制作的启动 u 盘（制作时的选项是“分区类型 GPT+目标系统类型 UEFI”）启动计算机，Windows 安装程序自动启动，按提示点选下一步，注意原硬盘分区建议全删，这时 Windows 安装程序开始拷贝文件，并未实质进入配置计算机硬件系统的过程，这时的 Windows 安装过程并不要求 Secure Boot。

    注：觉得 Secure Boot 关闭就不安全了？ 不，它本来就不是什么安全措施，只是名字叫安全，其实做的工作就是数字签名验证，而且微软的密钥已经在 2016 年就泄露了…… 参见<https://github.com/pbatard/Rufus/wiki/FAQ#Why_do_I_need_to_disable_Secure_Boot_to_use_UEFINTFS>。至于 linux，没参与微软的这个步骤的话，主板厂商不会内置它的公钥到主板中，估计安装的时候就不能开启这个选项。

    二、在 Windows 安装程序拷贝完文件，提示进行第一次重启的时候，重新打开 BIOS 的“Secure Boot”选项：

    重启后按 F2 进入 bios 设置，选 BOOT 选项卡，

        找到“Windows 10 Features” 设置为 “Windows 10”

        之后下面的选项“CSM Support”会消失，故其原来设置的 Disabled 或 Enable 没啥用了，同时下面的三个选项也会消失，都不需要了

        之后下面出现的是“Secure Boot”选项，选择 Enable，按 F10 保存退出，主板重启后自动引导硬盘上的 Windows 安装程序进行后续的安装配置工作

        注意：主板 BIOS 的选项 Windows 10 feature 设置为“win10”后，原来用 MBR 方式安装的 win7 或 win10 就进不了系统了，除非还原为“other os”

## 使用 Rufus 制作 ghost 启动盘

制作时引导类型选择“FreeDos”就行了，完成后把 ghost 拷贝到 u 盘上，以后用它开机引导直接进入 dos 命令行方式，运行命令 ghost 即可。

<https://qastack.cn/superuser/1228136/what-version-of-ms-dos-does-rufus-use-to-make-bootable-usbs>

如果引导类型选择“grub”，那你得准备 menu.list 文件，引导到对应的 img 文件上。

对 Windows 10 + 来说，推荐直接使用 Windows PE 的 u 盘，在 Windows PE 里直接使用 ghost 等工具。

待研究

## 技嘉 B560M AORUS PRO 主板 BIOS 打开网络唤醒功能

根据产品规格指出，此产品有提供网络唤醒 (Wake On LAN) 的功能，但是找不到相关设定或是开关可以启用该选项。

首先，请在开机时进入 BIOS 设定程序，在电源管理选项中，请启用 PME EVENT WAKEUP 功能，然后储存设定退出程序，再重新启动进入 Windows 后，请开启设备管理器窗口，检查网络卡内容并开启唤醒功能相关设定即可。
如果使用的网络卡上有 WOL 接头，需配合主板上 WOL 接头；如果使用的网络卡上没有 WOL 接头，且它的规格是 PCI 2.3，则依上述的方法即可。

<https://www.gigabyte.cn/Motherboard/B560M-AORUS-PRO-rev-10/support#support-dl-driver>

注意：确认 Windows 10 快速启动功能是否关闭，参见下面章节 [关闭“快速启动”]  <https://www.asus.com.cn/support/FAQ/1045950>

## 技嘉 B560M AORUS PRO 主板开启待机状态 USB 口供电功能和定时自动开机功能

BIOS 中的“Erp”(ErP 为 Energy-related Products 欧洲能耗有关联的产品节能要求）选项选择开启，

    usb 口功能设置选择供电。
    RTC（定时开机）设置具体时间

注意：确认 Windows 10 快速启动功能是否关闭，参见下面章节 [关闭“快速启动”]  <https://www.asus.com.cn/support/FAQ/1042220> <https://www.asus.com.cn/support/FAQ/1043640>

## 老显卡不支持 DP 口开机显示（Nvidia Geforce 1080 系）

### 一劳永逸方案：Nvidia 显卡可以升级固件解决这个问题

先把显卡挂到别的能显示的机器上（或先连接 HDMI 口安装 Windows 能进入系统后），升级下固件，以后就可以实现连接 DP 口安装 Windows 10 了

    <https://www.tenforums.com/graphic-cards/144258-latest-nvidia-geforce-graphics-drivers-Windows-10-2-a.html>
        <https://www.tenforums.com/Windows-10-news/111671-nvidia-graphics-firmware-update-tool-displayport-1-3-1-4-a.html>
            Geforce 1080 系 <https://www.nvidia.com/en-us/drivers/nv-uefi-update-x64/>
            Geforce 3080 系 <https://nvidia.custhelp.com/app/answers/detail/a_id/5233/>

### 简单方案：连接 HDMI 口安装 Windows 就行了

主板 BIOS 设置为 GPT + UEFI 的情况下只能连接 HDMI 口安装系统

新出技嘉主板的 BIOS 设置中，默认 BOOT 选项采用的是 GPT 分区+UEFI 引导，这样的启动 u 盘注意选择对应模式才能顺利启动，而且这样的 BIOS 设置才符合 Windows 11 的安装要求。

用 Rufus 制作 Windows 10 安装 u 盘，选择分区类型是 GPT（右侧的选项自动选择“UEFI（非 CSM)”，估计是 UEFI 也有版本更替）而不能是 MBR，这样的启动 u 盘才能顺利启动。
有些如 Nvidia gtx 1080 时代的显卡，连接 HDMI 口可以兼容 UEFI 方式，而 DP 口则不兼容，这样制作的安装 u 盘可以启动系统但是 DP 口在开机的时候不显示，只能连接 HDMI 口安装系统。

### 凑合方案：主板 BIOS 设置为 CSM 方式安装 Windows 可以连接 DP 口

用 Rufus 制作 Windows 10 安装 u 盘，如果分区类型选择 MBR（右侧选项自动选择“BIOS+UEFI(CSM)”），则也只能连接 HDMI 口安装系统。
这时如果想使用 DP 口开机显示，则主板 BIOS 要更改设置，CSM Support（Windows 10 之前 Windows 版本安装的兼容模式，事关识别 usb 键盘鼠标和 UEFI 显卡）要选“Enable”，并设置兼容模式：

    重启开机后按 F2 进入 bios，选 BOOT 选项卡，找到 Window 10 Features，选“other os”

    之后下面出现了 CSM Support， 选“Enable”，
    之后下面出现的三项，除了网卡启动的那个选项不用管，其它两个关于存储和 PCIe 设备的选项要确认选的是“UEFI”，这样在“other os”模式下可以实现 DP 口的开机显示，要是还不行，那两个选项直接选非 UEFI 的选项。

关于主板 BIOS 设置 CSM 模式可以启动 DP 口的解释 <https://nvidia.custhelp.com/app/answers/detail/a_id/3156/kw/doom/related/1>

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
商店应用默认不提供卸载选项，解决办法见下面章节 [删除无关占用 cpu 时间的项目]

如果有程序开机就启动挺烦人的，运行“msconfig”，在启动选项卡进行筛选

### 设置 Windows 安全中心

开始->运行：msinfo32，在“系统摘要”页面，查看状态是“关闭”的那些安全相关选项，逐个解决。

如果主板 BIOS 设置中关于 Intel CPU 虚拟化选项如 vt-d、hyper-threading 的设置没有打开，则可能有些依赖虚拟机的隔离浏览的选项不可用，需要去主板 BIOS 设置中打开。

某些 Windows 默认没有安装的组件是增强安全功能依赖的，需要单独安装：设置->应用->应用和功能->可选功能，点击右侧的“更多 Windows 功能”，弹出窗口选择“启用和关闭 Windows 功能”：

    Hyper-V
    Microsoft Defender 应用程序防护
    Windows 沙盒
    Windows 虚拟机监控程序平台
    适用于 Linux 的 Windows 子系统（这个是安装 Linux 用的，不是安全必备，顺手装上吧）
    虚拟机平台

设置->更新和安全->Windows 安全中心，左侧页面点击“打开 Windows 安全中心”

    ->应用和浏览器控制，打开“隔离浏览（WDAG）” <https://docs.microsoft.com/zh-cn/Windows/security/threat-protection/microsoft-defender-application-guard/install-md-app-guard>

    ->设备安全性->内核隔离，手动开启“核心隔离”、“内存完整性”  <https://support.microsoft.com/zh-cn/Windows/afa11526-de57-b1c5-599f-3a4c6a61c5e2> <https://go.microsoft.com/fwlink/?linkid=866348>

    在“设备安全性”屏幕的底部，如果显示“你的设备满足增强型硬件安全性要求”，那就是基本都打开了。
    目前发现 Windows 10 21H1 版本的“核心隔离”类别中缺少“内核 DMA 保护”、“固件保护”等选项，而 Windows 2019 LTSC 版本是有的，
    如果想显示“你的设备超出增强的硬件安全性要求”，需要在下面的页面慢慢研究如何开启。
    <https://docs.microsoft.com/zh-cn/windows/security/information-protection/kernel-dma-protection-for-thunderbolt>
    <https://docs.microsoft.com/zh-cn/windows/security/threat-protection/windows-defender-system-guard/system-guard-secure-launch-and-smm-protection>

验证：启动 Windows 后运行 msinfo32，在“系统摘要”界面查看

    “内核 DMA 保护”选项，“启用”
    “基于虚拟化的安全 xxx”等选项，有详细描述信息
    “设备加密支持”选项，不是“失败”

更多关于 Windows10 安全性要求的选项参见各个子目录章节 <https://docs.microsoft.com/zh-cn/Windows-hardware/design/device-experiences/oem-highly-secure#what-makes-a-secured-core-pc>

基于虚拟化的安全 Virtualization Based Security(VBS) 详细介绍 <https://docs.microsoft.com/zh-cn/windows-hardware/design/device-experiences/oem-vbs>

整个 Windows 安全体系，挨个看吧 <https://docs.microsoft.com/zh-cn/windows/security/>

### 关闭“快速启动”

这傻逼功能不是主板 BIOS 设置里的 UEFI Fast Boot，只是 Windows 关机后系统状态暂存挂起功能，类似休眠。

但是，它使 BIOS 里定时自动开机失效，并跟很多 usb 设备不兼容，导致关机下次启动以后 usb 设备不可用，需要重新插拔。
而且跟主板 BIOS 中 FAST BOOT 也关联上了，二者互相起作用，目的是让你以为能快速开机，其实，很多时候是根本就转了个休眠。

比如我的无线网卡、我的显示器集成的 usb-hub 连接的鼠标键盘网卡显示器等等，开机或重启后偶发报错无响应……

关关关：

    打开设置-系统-电源和睡眠-其他电源设置（或右击开始菜单 (win+x)，选择“电源选项”，弹出窗口的右侧选择“其它电源设置”），

    点击“选择电源按钮的功能”，选择“更改当前不可用的设置”，

    去掉勾选“启用快速启动（推荐）”，然后点击保存修改。

如果启用了快速启动，你真正需要重启计算机的时候，你是不知道 Windows 到底选择了哪种重启方案，
很多时候你选的重启，其实就是注销并重新登陆到 Windows：

    点击关机按钮时按住 shift，此次关机就不使用快速启动

### 默认键盘设置为英文

中文版 Windows 10 默认唯一键盘是中文，而且中文键盘的默认输入法是微软拼音的中文状态。原 Windows 7 之前“Ctrl+空格”切换中英文的热键被微软拼音输入法使用了，而且按 shift 键就切换中英文，默认还是各个应用的窗口统一使用的。

问题是 Windows 桌面/资源管理器/炒股游戏等软件的默认状态是响应英文输入，仅对文本编辑软件才应该默认用中文输入。如果只有默认的中文键盘，则微软拼音输入法按一下 shift 键，中英文状态就切换，非常容易误触。在实际使用中，各个软件窗口一变，或者输入个字母就弹出中文候选字对话框，按个 shift 键，微软拼音输入法就来回切换中英文，非常非常非常的繁琐。尤其在有些游戏中，一按 shift 就切出来中文输入法，再按 asdf 就变成打字到中文输入法的输入栏了。

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

### 关闭 Windows 自带的压缩文件夹（zip folder）

Windows 10 下发现取消这个组件，居然有 Windows 更新的安装包报错的情况，建议用 用开源的 7-zip 软件替换 zip 文件的打开方式

    管理员身份运行 7-zip 软件，菜单“工具”->“选项”，弹出的窗口选择“系统”选项卡，列出的类型中，zip 选择“7-zip”

废弃：

    从 Windows XP 开始，之后的每一代操作系统（如 Vista、7、8、10），都有一个默认开启的功能：能将压缩文件当作普通文件夹来管理。

    在资源管理器左侧的文件夹树视图中，展开一个包含压缩文件（zip 或 cab 格式）的文件夹时，就能看见这些压缩文件如同普通的子文件夹一样，可以直接展开。展开它们，就能很方便地浏览压缩文件中所有文件的信息，同时还能方便地解压。

    但是一般用户通常都有自己喜爱的压缩软件，例如 WinRAR、7-Zip 等，他们往往不常使用系统自带的这个压缩文件管理方式，更倾向于使用压缩软件提供的右键菜单功能来压缩或解压文件。而且还会抱怨系统自带的压缩文件夹功 能消耗系统资源，每次打开文件夹时的延迟更让人觉得系统变得缓慢。

    Windows XP 关闭 zip folder 功能

        打开命令提示符窗口，输入“regsvr32 /u %windir%\system32\zipfldr.dll” （不含引号），回车后提示成功即可关闭。

        开启功能：
        打开命令提示符窗口，输入“regsvr32 %windir%\system32\zipfldr.dll”（不含引号），回车后提示成功即可打开。

    提示：以上操作可能只关闭了 ZIP 文件的文件夹显示，可能 CAB 文件没有关闭。未测试。

    Windows Vista、7、8、10 关闭 zip folder 功能

    需要删除或更名两个注册表键：

    对于 ZIP 文件：HKEY_CLASSES_ROOT\CLSID\{E88DCCE0-B7B3-11d1-A9F0-00AA0060FA31}

    对于 CAB 文件：HKEY_CLASSES_ROOT\CLSID\{0CD7A5C0-9F37-11CE-AE65-08002B2E1262}

    由于涉及到权限问题，无法直接删除，需按照以下步骤来操作：（注册表操作有风险，要小心谨慎，并切记要备份。）

        按 Win-R，在运行窗口输入“regedit” 并回车，打开注册表编辑器。

        找到要操作的第一个注册表键 HKEY_CLASSES_ROOT\CLSID\{E88DCCE0-B7B3-11d1-A9F0-00AA0060FA31}

        右键单击它，从弹出菜单中单击“导出 (E)”，将该注册表键的原始信息备份到安全位置，以便遇到不测时恢复。

        导出备份完成后，再右键单击该键，从弹出菜单中单击“权限 (P)...”

        单击“高级 (V)”按钮

        单击“所有者”选项卡

        在“将所有者更改为 (O):”框中，选中你当前的用户名

        勾选“替换子容器和对象的所有者 (R)”

        单击“应用 (A)”按钮

        单击“确定”

        在“安全”选项卡下，在上框中选中你的用户名，然后 在下框中勾选“完全控制”的“允许”

        单击“应用 (A)”和“确定”按钮

        现在，你可以自由选择删除或重命名这个注册表键了。注意：请确定你在正确的注册表键上操作！

        好，重复以上步骤来为 第二个注册表键进行重命名或删除。

        重启计算机，压缩文件夹是不是都消失啦？

    开启功能：

    恢复的话，只需将关闭时建立的两个备份文件导入注册表，重启即可。万一备份不见了，可以从另外的电脑中导出，当然前题是操作系统的版本要一致。

    权限恢复的时候，依次反向操作，注意：添加所有者要输入“NT SERVICE\TrustedInstaller”，选择“检查名称”。

### 切换黑暗模式（夜间模式）

次选：设置->系统->显示：选择打开“夜间模式”，Windows 只是把色温降成黄色，显示器亮度还是很晃眼。

优选：设置->轻松使用->颜色滤镜：选择“打开颜色滤镜”，选择“灰度”按钮，显示器变成黑白效果，失去了彩色，也不舒服。

最优选：设置->个性化->颜色：下面有个“更多选项”，对“选择默认应用模式”选择“暗”，整个 Windows 的配色方案都变成了暗色，各个软件窗口也跟着变了。
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

edge 浏览器->设置->外观->整体外观：选择“系统默认”则跟随 Windows 系统的主题颜色变换，缺点是仅窗口标签外观变换。如果需要对网页内容开启夜间模式，需要强制开启：

    在浏览器地址栏输入 edge://flags/

    在搜索栏输入“Force Dark Mode for Web Contents”

    选择 enable，点击选择重启浏览器，除图片以外的所有部分进入夜间模式

### 关闭附件管理器检查

为什么要关闭？ 浏览器我正常下载的没签名的文件，在有些软件调用的时候就打不开，也没有任何提示，总是报错，让人抓狂。
之前遇到过技嘉制作 u 盘启动的工具，添加了下载的 zip 文件，总是制作失败，直到把下载的文件点击右键，选择属性，勾选解除限制，才能正常读取。整个过程中没有任何提示性信息。其它还有 zip 解压文件，读取 zip 压缩包，悄悄的失败，也没有任何提示，从 Windows 7 到 Windows 11，一直如此。

有两种方法： 第一种是修改组策略中的配置：

“运行”中输入 gpedit.msc，然后选择“用户配置”-“管理模板”-“Windows 组件”-“附件管理器”。

    1. 文件附件值中不保留区域信息，设置为“启用” （光这步就够了）

    2. 文件类型的默认风险级别，设置为“启用”，“低风险”。
    3. 低风险文件类型的包含列表，设置为“启用”，扩展名增加比如：.docx;.doc;.xls;.xlsx

第二种是增加一个全局的环境变量 SEE_MASK_NOZONECHECKS，设置值为 1.

    [HKEY_CURRENT_USER \Environment]
    SEE_MASK_NOZONECHECKS = "1"

### 删除无关占用 cpu 时间的项目

有了 Windows store 后，商店应用由单独的 wsappx.exe 运行的 UWP 运行环境，甚至 appx 的保存目录 C:\Program Files\WindowsApps 都是默认锁定的。

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

<https://github.com/kkkgo/LTSC-Add-MicrosoftStore>

要开始安装，请打包下载 LTSC-Add-MicrosoftStore-2019.zip 后用右键管理员运行 Add-Store.cmd

如果您不想安装 App Installer / Purchase App / Xbox，请在运行安装之前删除对应的。appxbundle 后缀的文件。但是，如果您计划安装游戏，或带有购买选项的应用，则不要删除。

如果装完之后商店仍然打不开，请先重启试试。如果仍然不行，请以管理员身份打开命令提示符并运行以下命令之后，然后再重启试试。
PowerShell -ExecutionPolicy Unrestricted -Command "& {$manifest = (Get-AppxPackage Microsoft.WindowsStore).InstallLocation + '\AppxManifest.xml' ; Add-AppxPackage -DisableDevelopmentMode -Register $manifest}"

商店修复
Win+R 打开运行，输入 WSReset.exe 回车。
该命令会清空并重置 Windows Store 商店的所有缓存。

该脚本由 abbodi1406 贡献：
<https://forums.mydigitallife.net/threads/add-store-to-Windows-10-enterprise-ltsc-LTSC.70741/page-30#post-1468779>

## 安全的使用你的 Windows 10

确保 Windows 安全中心中的相关设置都开启，参见上面的章节 [刚装完 Windows 10 后的一些设置] 里的“设置 Windows 安全中心”部分。

### 1. 浏览网页时防止网页偷偷改浏览器主页等坏行为

在 edge 浏览器，点击菜单，选择“应用程序防护窗口”，这样新开的一个 edge 窗口，是在虚拟机进程启动的，任何网页操作都不会侵入到正常使用的 Windows 中。

在 Windows 安全中心里可以设置，是否从这里复制粘贴内容到正常使用的 Windows 中等各种功能。

### 2. 用沙盒运行小工具等相对不靠谱的程序

开始菜单，选择“Windows sandbox”程序，将新开一个虚拟的 Windows 窗口，把你觉得危险的程序复制粘贴到这个虚拟的 Windows 系统里运行，格式化这里的硬盘都没关系，在这个系统里还可以正常上网。

这个虚拟的 Windows 窗口一旦关闭，里面的任何操作都会清零，所以可以把运行结果复制粘贴到正常使用的 Windows 中。

Windows 沙盒可以用配置文件的方式设置共享目录，并设置只读权限，方便使用。比如把 c:\tools 目录映射到 Windows 沙盒里运行网络下载的小程序，或者把 download 目录映射到沙盒的 download 目录以便在沙盒里浏览网页并下载程序。

Windows 沙盒使用 WDAGUtilityAccount 本地帐户，所以共享文件夹也保存在这个用户目录的 desktop 目录下。

tools.wsb 示例：

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

MappedFolder 可以有多个，默认映射到桌面，也可以单独指定，关于 Windows 沙盒的详细介绍，参见 <https://docs.microsoft.com/zh-cn/windows/security/threat-protection/windows-sandbox/windows-sandbox-overview>

## Windows 10 使用虚拟机的几个途径

WSL2 内的 container 是 linux 提供的，不算 Windows 的容器。
Windows 容器提供了两种不同的运行时隔离模式：process 和 Hyper-V 隔离，process 只在 server 版提供
<https://docs.microsoft.com/zh-cn/virtualization/windowscontainers/manage-containers/hyperv-container>

### Hyper-V

这个方法就像普通虚拟机操作了，类似 VM Ware、Virtual Box
<https://docs.microsoft.com/zh-cn/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v>

### docker (Hyper-V)

Windows 10+ 上的 docker 是  WSL 2 或 Hyper-V 实现的，之前的 Windows 7 上的 docker 是安装了 virtual box。

    https://docs.microsoft.com/zh-cn/virtualization/windowscontainers/about/

    https://docs.docker.com/desktop/windows/wsl/

需要注意不同映像的区别，完整 Windows api 的是 Windows 和 Windows server，其它的是仅支持 .net
<https://docs.microsoft.com/zh-cn/virtualization/windowscontainers/manage-containers/container-base-images>

### 适用于 Linux 的 Windows 子系统（WSL）- 命令行安装 Ubuntu

WSL 2 的底层还是使用了虚拟机（Hyper-V），但是他使用的 Linux 完全集成到了 Windows 中，即使用起来就像在 Windows 中直接运行 linux 程序。

开发工具可以使用 Virsual Studio Code，支持直接打开 WSL 虚机，就像连接 Docker 虚机或远程连接 SSH 服务器一样简单。其它开发工具如 git、docker、数据库、vGpu 加速（<https://developer.nvidia.com/cuda/wsl> ）等也都无缝支持，详见 <https://docs.microsoft.com/zh-cn/windows/wsl/setup/environment>

1.开启 WSL 功能： Windows 设置->应用和功能，点击右侧的“程序和功能”，弹出窗口选择“启用或关闭 Windows 功能”，在列表勾选“适用于 Linux 的 Windows 子系统”，确定。

2.power shell 下就执行几个命令：

    # 安装 ubuntu，已经安装过了忽略这条
    # 详见 <https://docs.microsoft.com/windows/wsl/install>
    wsl --install -d Ubuntu

    # 更新 WSL 内核，需要管理员权限
    wsl --update

    # 查看当前 wsl 安装的版本及默认 linux 系统
    wsl --status
    默认分发：Ubuntu
    默认版本：2

    # 进入 ubuntu 系统
    wsl 或 bash

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

3.Linux 下的 GUI 应用的安装和使用

    详见 <https://docs.microsoft.com/zh-cn/windows/wsl/tutorials/gui-apps>

4.手动下载安装 linux 的微软发行版

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

    使用了 WSL2 就只能用微软发布的 Linux 版本<https://docs.microsoft.com/zh-cn/windows/wsl/compare-versions#full-linux-kernel>，但是提供了完全的二进制兼容，用户可以自行升级 linux 内核。

    甚至可以在上面再运行 docker，这个 docker 也需要是微软发布的 <https://docs.microsoft.com/zh-cn/windows/wsl/tutorials/wsl-containers> 。

    这个虚拟机是放到当前用户目录下的，类似于：USERPROFILE%\AppData\Local\Packages\CanonicalGroupLimited...，所以注意你的 c 盘空间。如果需要更改存储位置，打开“设置”->“系统”-->“存储”->“更多存储设置：更改新内容的保存位置”，选择项目“新的应用将保存到：”

### 图形化安装 - Windows Store 安装 Ubuntu 子系统 (WSL)

win10+ubuntu 双系统见<https://www.cnblogs.com/masbay/p/10745170.html>

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

## 使用 VM Ware、安卓模拟器等虚拟机提示需要关闭 Hyper-V

Vmware workstation 升级到 15.5.5 版本后就可以兼容 Hyper-V 了，但有限制：必须为 Windows 10 20H1（也叫 2004 版）或更高版本。

当基于独占设计的 Hyper-V 启用后，会持续占用，造成其他基于同类技术的虚拟机将无法启动。且部分虚拟机产品在确认检测到相应情况后还要强行执行，就造成了 Windows 死机蓝屏。

在“启用或关闭 Windows 功能”中卸载 hyper-v 功能后，依旧是提示无法安装或使用虚拟机，因为通常会启用 Hyper-V 的操作有如下几项：

    Hyper-V 平台；

    Windows Defender 应用程序防护，Windows 安全中心：“应用和浏览器保护”，关闭隔离浏览；

    Windows 沙盒；

    Windows 安全中心：设备安全性模块的的内核隔离（内存完整性）；

    Visual Studio 内涉及到设备模拟的虚拟化方案；

1. 必须确保以上列表内所有项目被正确关闭后，Hyper-V 平台才能被真正关闭。

   据说进入主板 BIOS 将 Intel VT-x 设为 Disabled 都不行

2. 管理员身份运行命令提示符 cmd（如果用 PowerShell，符号{}会导致报错）：

    bcdedit /copy {current} /d "Windows 10 without Hyper-V"

    将上面命令得到的字符串替换掉下面{}中的 XXX 代码即可

    bcdedit /set {XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX} hypervisorlaunchtype OFF

    提示成功后再次输入
    bcdedit
    查看校对"Windows 启动加载器"中对应项目的 hypervisorlaunchtype 值是 Off

3. 重启计算机，出现 Windows 10 启动选择， 就能选择是否启用 Hyper-v：

    在“no Hyper-V”中，可以运行 Vmware 虚拟机，而另一个启动选项运行 Hyper-v。

4. 以后想要删除可以用运行 msconfig 跳出图形界面来操作

作者：知乎用户
链接：<https://www.zhihu.com/question/38841757/answer/95947785>
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

## 使用中要注意，WSL 下的 Linux 命令区别于某些 PowerShell 下的命令

注意 PowerShell 对某些 linux 命令是使用了别名，而不是调用的真正的 exe 文件，有没有后缀。exe 是有区别的！

下面是个例子 ：

    # <https://docs.microsoft.com/zh-cn/windows/wsl/install-manual#downloading-distributions>
    使用 curl 命令行实用程序来下载 Ubuntu 20.04 ：

    控制台

        curl.exe -L -o ubuntu-2004.appx https://aka.ms/wsl-ubuntu-2004

    在本示例中，将执行 curl.exe（而不仅仅是 curl），以确保在 PowerShell 中调用真正的 curl 可执行文件，而不是调用 Invoke WebRequest 的 PowerShell curl 别名。详细列表参见 <https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.2>

设置->应用->应用和功能，里面有个“应用执行别名”，点击进去慢慢研究吧，真烦人啊，估计整些逻辑弯弯绕。

## 离线下载安装 Microsoft Store 中的应用

很奇怪吧，LTSC 版本号称是去掉了 Windows Store 的，但是实质上 UWP 程序一点不少，都在系统里运行着，后台的 AppXSVC、ClipSVC 根本不停。有些程序装完了，但是少了啥组件，这俩服务还玩命的跑，狂吃 cpu……

为嘛狂吃 cpu 呢？

    UWP 文件下载这个玩法，最大的问题就是商店是分区域的，而万能的墙会让非 cn 的下载非常不稳定，特别是你的一个 uwp 程序依赖比较多的包的时候，说不定有的源在其它外网服务器上，间或会下载不到。不是啥非法的玩意，甚至可能微软的更新包，挂在 github 上的或者啥开源服务器上的东西，都不排除掉线。这就是为嘛有时候 Windows 更新都报告失败要多重试几次的原因。 好吧，程序表面上装好了，其实需要的库不全，后台 AppXSVC 进程就一根筋的不断重试，微软的三哥程序员估计写循环时候没加 sleep(0.001)，cpu 就得受点累。这个费电的过程，只能是你把那个 uwp 程序卸载掉，或者手动安装上缺失的库（Windows 没有任何提示你咋知道），才算完。

我的电脑里哪些是 uwp 应用呢？

    设置：应用和功能->应用

uwp 权限配置

    设置：隐私->应用

如果遇到不能安装的情况，需要检查一下系统设置：
    右键点击开始按钮>设置>应用>选择获取应用的位置：选择“任何来源”

    UWP 离线安装，需要去设置中打开开发者模式

### 离线下载 uwp 步骤

    首先知道你需要的应用名称，如：Microsoft 便笺

    打开 https://www.microsoft.com/zh-cn/Store 或 https://www.microsoft.com/en-us/Store，点击搜索，直接输入应用名称比如：Microsoft 便笺 或 Instagram 啥的，在弹出菜单选择对应软件。

    新开的页面会显示该商品的详细信息，直接复制地址栏的地址，以 Microsoft 便笺为例：https://www.microsoft.com/zh-cn/p/microsoft-sticky-notes/9nblggh4qghw?activetab=pivot:overviewtab

    打开这个网站 https://store.rg-adguard.net/

    将上面复制的链接粘贴到搜索栏中，左侧的搜索类型使用默认的 URL(link)。
    如果搜不到，搜索类型换成 ProductId 试试，本例中搜索 url 中软件名称段后面的参数“9nblggh4qghw”。

    搜索到的结果通常会比较多，包含了不同的版本以及和这个应用依赖的运行环境安装包。

    建议往下翻页，找到名称匹配一致的最高版本（版本数字最大）的链接，注意后缀应该是 .appxbundle 的链接 (bundle 表示包含所有相关文件），
    如果不选择 .appxbundle，那就得挨个下载 .appx 文件逐个安装了。
    比如这个：Microsoft.MicrosoftStickyNotes_3.7.78.0_neutral_~_8wekyb3d8bbwe.appxbundle。

    后面对应的有个 Expire 过期时间 (GMT 时间），这是由于微软服务器上每次下载的时候生成的链接都是有有效期的，所以这个链接在到期后就失效了。
    也正是因此，才需要通过这个网站提供的搜索工具来获取最新的下载链接。

    点击这个链接后将 .appxbundle 文件下载到本地。
    如果 edge 浏览器禁止下载，复制下载链接到下载工具比如 motrix 里下载即可。

    将下载好的 .appxbundle 文件复制到没有网络链接的电脑上，和普通的安装程序一样，正常情况下直接双击就可以打开进行安装了。
    或者打开 powershell，输入命令： Add-AppxPackage -Path <离线包文件路径>

### 补充 Windows 10 LTSC 2021 版几个 UWP 应用缺失问题

自己到 Windows Store 中搜索下载，参见上面的章节 [离线下载安装 Microsoft Store 中的应用]。

VCLibs 库文件，修复输入法等 appx 等库关联问题

    Microsoft.VCLibs.140.00_14.0.30704.0_x64__8wekyb3d8bbwe.Appx

VP9 视频扩展 VP9VideoExtensions 库文件，修复设置->应用->视频播放中的预览错误

    https://www.microsoft.com/zh-cn/p/vp9-%e8%a7%86%e9%a2%91%e6%89%a9%e5%b1%95/9n4d0msmp0pt#activetab=pivot:overviewtab

安装下载好的离线文件，打开 powershell，输入命令：

    Add-AppxPackage -Path <离线包文件路径>

### DCH 驱动的那些事

DCH 驱动号称只安装驱动，相关的控制界面应用由 Windows Store 用 UWP 安装。
也就是说，驱动 inf 安装之后，Windows 更新时才会下载对应的面板程序，这个需要厂商提前给微软对应的 uwp 程序。
比如部分型号的显卡控制面板、声卡面板、雷柏鼠标面板等等。

时间大概在 2015 年之后，Intel CPU 的 i7-7700k 这一代之后，硬件有 uwd 驱动 (DCH 驱动）。

假如你的 Nvidia 显卡安装了 dch 版驱动，是没有 Nvidia 控制面板。
Windows 更新会自动在后台搜索下载，或者用户自己到 Windows Store 中搜索下载，参见上面的章节 [离线下载安装 Microsoft Store 中的应用]。

如果这个 uwp（DCH）的面板依赖 Microsoft.VCLibs，所以系统也自动装了。

而没有 uwd 驱动 (DCH 驱动）的老硬件，不会自动安装 uwp 面板，也就没有 Microsoft.VCLibs 了，有可能 wsappx 继续 cpu 占用高。

参考 <https://bbs.pcbeta.com/forum.php?mod=viewthread&tid=1912450>

### good news and bad news

1.good news

听说过 NuGet 吗？以后会废掉这个坑爹的 uwp 玩法。

Windows App SDK 提供了一套统一的 API 和工具，它们与操作系统分离并通过 NuGet 包发布给开发人员。
Windows 10 版本 1809 至 Windows 11 即支持了，并且同时提供 WinRT API 和本机 C API。

主推 WinUI 3, 以前的 WinUI 2 和 UWP 也废了 <https://docs.microsoft.com/zh-cn/windows/apps/windows-app-sdk/migrate-to-windows-app-sdk/migrate-to-windows-app-sdk-ovw#topics-in-this-section>

2.bad news

uwp 迁移到 NuGet，估计换汤不换药。

以后想用个程序，你就得联网，就得登陆受管控的商店。

应用的底层都给你封装了一堆依赖，美其名曰软件底层解耦、组件共享。

实际用起来呢，各种墙让你下载不全，到处找加速。

下载一个安装包就能让你舒舒服服用软件的日子，不会再有了。

参见

    <https://docs.microsoft.com/zh-cn/windows/msix/desktop/powershell-msix-cmdlets>

    <https://docs.microsoft.com/en-us/powershell/module/appx/?view=windowsserver2019-ps>

    <https://docs.microsoft.com/zh-cn/windows/uwp/get-started/universal-application-platform-guide#how-the-universal-windows-platform-relates-to-windows-runtime-apis>

### 得认真考虑下，肉身 xx 的问题了，以后老死在外面，是不是可以接受？

你一个搞 it 的，离开了联网，怎么继续下去？

## 手动下载 Windows 更新包

    参考 https://zhuanlan.zhihu.com/p/104547677

脚本获取网站 UUPdump 网址：<http://uupdump.ml/>

在搜索框中输入所需版本号并搜索

相对于微软官网下载的优势：

    自由选择版本
    多线程下载速度更快

相对于 MSDN I Tell You 的优势：

    下载源稳定（从微软官方服务器下载而非 P2P 网络）
    可设置为 esd 格式压缩，单个文件均不超过 4G，对于 UEFI 启动的主板可以直接将安装文件复制到 FAT32 格式 U 盘作为启动盘。

分类中的信息，其中：

    Fast 为快速预览通道中最新版本对应的版本号
    Slow 为慢速预览通道中最新版本对应的版本号
    Preview 为最新的预览对应版的版本号
    Targeted 为 Windows 更新设置中半年频道（定向）中最新版本对应的版本号，
    Board 为 Windows 更新设置中半年频道中最新版本对应的版本号
    LTSC 为长期支持的企业版的最新版本对应的版本号

各个版本说明

    Cumulative Update 为累积更新版本，是将补丁直接集成到系统中
    Feture Update 为功能更新，是正式发布的大版本+补丁的模式，在安装之后自动打补丁至最新版本

选择基准版本所需的基准版本

选择了所需要的版本后，点击下一步（以“全部版本”为例）创建下载包

在此页面我们有以下几点需要注意：

1）选择“使用 aria2 下载并转换”时，生成的安装镜像在全新安装时只能选择其中包含的基准版本，其对应关系为：

基准版本为“全部版本”可选专业版，家庭版，中文家庭版
基准版本为“Windows 10 Home”可选家庭版
基准版本为“Windows 10 Home China”可选家庭中文版
基准版本为“Windows 10 Pro”可选专业版

2）若需要刻录至 U 盘进行安装，请勾选上“使用 install.esd 而非 install.wim 创建 ISO”，否则会因单个文件大于 4G 而无法使用 FAT32 格式。

点击“创建下载包“，这时我们会下载一个压缩包，解压后如下图所示

以管理员权限运行“aria2_download_windows.cmd “即可开始下载并创建 ISO 安装镜像，下载过程中请耐心等待，下载过程中基本可以保持满带宽下载，而且每个文件下载完成后会自动校验文件，以保证文件的完整及正确。

## 主板 Ultra Fast 启动无法再用键盘进入 BIOS 设置

在操作系统中引导到 UEFI 固件设置。

很多支持 Fast Boot 的主板，在主板 BIOS 的“Fast Boot”项设置了“Ultra Fast”之后，开机过程中不能用键盘进入 BIOS 了，解决办法是进入 Windows 指定下一次重启进入 BIOS。

对技嘉 B560M AORUS PRO 主板来说，可以对 usb 等各个细分选项分别设置是否在初始化的时候跳过，可以避免这个问题。

实际试了一下，没感觉到 Ultra Fast 比 Fast Boot 快。
而且我的 usb 键盘鼠标网卡都挂在 usb hub 上，设备比较多，开机时 UEFI 加载这堆驱动没法跳过，还是不用了。

### 在 Windows 10 中指定重启到 UEFI 固件的步骤

    点击“开始”菜单—选择“设置”

    点击“更新和安全”

    在“更新和安全”界面中点击左侧的“恢复”选项，再在右侧的“高级启动”中点击“立即重新启动”

    Windows 10 重启之后你将会看到出现一个界面提供选项，选择“疑难解答（重置你的电脑或高级选项）”

    新出现的界面选择“高级选项—>UEFI 固件设置”，重启之后就可以直接引导到 UEFI 了。

    参考 <https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/boot-to-uefi-mode-or-legacy-bios-mode>

### Linux 指定重启到 UEFI 固件的步骤

    Linux 也可以在重启时告诉系统下一次启动进入 UEFI 设置。使用 systemd 的 Linux 系统有 systemctl 工具可以设置。

    可以查看帮助：systemctl --help|grep firmware-setup

    --firmware-setup Tell the firmware to show the setup menu on next boot
    直接在命令行执行下面命令即可在下一次启动后进入 UEFI 设置。

    systemctl reboot --firmware-setup
    参考资料：https://www.freedesktop.org/software/systemd/man/systemctl.html#--firmware-setup

### UEFI 的“Fast Boot”不给机会进主板 BIOS 啥意思

UEFI 启动的操作系统是跟主板 BIOS 设置密切结合的，UEFI 的“Fast Boot”分几个选项，导致了初始化部分设备的限制：

    主板 BIOS 设置的“Fast Boot”项如果开启“Fast”选项，可以减少硬件自检时间，但是会存在一些功能限制，比如 Fast 模式下不能使用 USB 设备启动了，因为这个加速功能其实是在 BIOS 自检中禁止扫描 USB 设备了。

    主板 BIOS 设置的“Fast Boot”项如果开启“Ultra Fast”选项，之后就不能用键盘进入 BIOS 了，估计跟 Fast 模式一样把大部分不是必须的自检过程给禁用了，所以要想进 BIOS 只能清空 CMOS 或者在操作系统里选择“重启到 UEFI”。

参考说明
    <https://www.expreview.com/22043.html>
    <https://www.tenforums.com/tutorials/21284-enable-disable-fast-boot-uefi-firmware-settings-windows.html>

### Windows 电源选项中的“快速启动”

这个功能是跟主板 BIOS 中 UEFI FAST BOOT 选项类似的，但是更高级，在设备休眠这一层级实现复用，也就是说，你在关机菜单选择的重新启动，Windows 可能只是注销并重新登陆。

还是关了吧，这个噱头实在让人混淆太多东西了，见前面的章节 [关闭“快速启动”]

## 常见问题

### 如何判断 USB Type-C 口有哪些功能

    <https://www.asus.com.cn/support/FAQ/1042843>

### 显示器在 Win10 开启 HDR 变灰泛白的原因

在游戏或播放软件里单独设置 HDR 选项就可以了，Windows 系统不需要打开 HDR 选项，目前的 Windows 10 并没有很好的适配 HDR 显示器。

原因很简单，你的显示器并不真正提供 HDR 显示 (OLED/FALD), 而 Windows 还没有对 Display HDR400 和 600 这两个"假 HDR"提供支持。
Windows 现在的偏灰，是在输出 HDR 信号的情况下自动降低 UI 亮度的被 Display HDR400 误显示的结果。这些显示器的 HDR 并没有低亮度细节，所以低亮度部分就发灰了。HDR 和暗部平衡差不多，都可以把暗部系列显示出来，所以看起来就像是亮度调得很高的样子，会泛白。
这个问题在 FALD/OLED 显示器上是不存在的。仅在 Display HDR400-600 的"假 HDR"显示器上存在。
简单来说就是为了支持桌面 HDR 软件 App, 桌面必须声明需求显示器的完整 HDR 亮度范围。然而显然桌面 UI 本身不能闪瞎人眼，所以桌面 UI 的亮度是低亮度模式。Display HDR400-600 的显示器并不能显示完整的 HDR 内容，自然这种为真 HDR 设计的模式就会出现显示错误。
因为其实问题是 Display HDR400-600 并不是真的支持 HDR, 亮度范围根本没那么大，现有的协议并没有体现出这一点微软也没辙，属于技术局限，只能等未来看微软打算怎么解决这个问题了。
最好是显示器厂商单独出 HDR 配置文件，让 Windows 自动识别实际的 HDR 亮度范围，而不是接收显示器现在汇报的这个虚假的 HDR 亮度范围。
现在的 HDR 标准其实是纯凑活事的，信号输出了剩下的全看显示器，导致 HDR 内容的显示没有任何标准，大家效果千差万别。这在真 HDR 显示器上也很明显，不同品牌的 FALD 显示器效果也是完全不同的。颜色亮度各种跑偏。完全是群魔乱舞。
很多游戏内置 HDR 选项，让你单独调节亮度来适应屏幕就是这个原因。

### 取消动态磁盘

之前误把“动态磁盘”和“GPT 磁盘”混淆了，我的硬盘不幸变成了动态磁盘，Windows 不能操作他的各种分区了。

微软自己都废弃了这个“动态磁盘” <https://docs.microsoft.com/en-us/windows-server/storage/disk-management/change-a-dynamic-disk-back-to-a-basic-disk>

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

注意：无法在 Windows 里操作自己的启动盘，得启动到 u 盘或者别的系统里，操作这个磁盘，这个磁盘的内容是完全给清除的！

### 乱七八糟的。NET Framework 各版本安装

.NET Framework 4.x 号称是互相覆盖的，版本继承性可以延续。

#### .NET Framework 4.5 之前的 4.x 版本

M$不支持了，自求多福吧，自己挨个版本研究去 <https://docs.microsoft.com/zh-cn/dotnet/framework/install/guide-for-developers>

#### .NET Framework 4.5 及之后的 4.x 版本

从 .NET Framework 4 开始，所有 .NET Framework 版本都是就地更新的，因此，在系统中只能存在一个 4.x 版本。

#### .NET Framework 3.5 在 Windows 10 + 只能按需安装

通过 Windows 控制面板启用 .NET Framework 3.5。 此选项需要 Internet 连接。
简单点办法，安装 directx 9，Windows 自己会弹出提示要求给你安装。NET Framework 3.5。

微软自己做烂了，各个版本居然都是不兼容的 <https://docs.microsoft.com/zh-cn/dotnet/framework/install/dotnet-35-windows> 。

警告

    如果不依赖 Windows 更新作为源来安装 .NET Framework 3.5，则必须确保严格使用来自相同的、对应的 Windows 操作系统版本的源。
    使用来自不同 Windows 操作系统版本的源将安装与 .NET Framework 3.5 不匹配的版本，或导致安装失败，使系统处于不受支持和无法提供服务的状态。

也就是说，弄个 3.5 的离线安装包，在 Windows 10 下面可能不能用。
