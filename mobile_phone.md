# 安全的使用你的手机

安卓系统权限管理的 Google 官方说明

    <https://developer.android.google.cn/guide/topics/permissions/overview?hl=zh-cn>

安卓系统应用程序对用户数据发送给第三方的现状

    <https://zhuanlan.zhihu.com/p/397453757>

## 安全使用的背景

手机 app 出于各种目的，非必要获取用户的设备数据如通话联系人，用户安装了哪些应用程序，用户剪贴板里有什么，甚至扫描硬盘查找用户是否保存了某些文件，为了确定用户身份生成设备相关的唯一id给广告商使用(虽然是匿名)，这样的功能让人不得不屏蔽。

安卓的权限是归类的，用户看到的是 app 申请一个权限，其实安卓系统给它开放的是一个类别的全部权限。而没有 app 会明确向你解释它到底读了些啥，又发给了谁。

如果在安卓系统的权限提示中选择禁用该权限，有些比较下作的软件，比如微信、QQ 等会拒绝运行。

安卓系统的权限提示，有些无法选择动态使用（用到的时候提示）。比如你使用时给了某个 app 存储照片时访问系统根目录的许可，但是这个 app 过会儿自己在后台扫描系统目录，你能得到任何提示吗？它的联网上传功能默认都是放开的，不可能随时随地给你弹窗提示你联网吧？

安卓默认把你截屏和除了明确的复制之外的某些操作文字，都放到系统剪贴板里，这个是所有软件都可以读取写入的共享空间。c国手机的各大流行软件启动时都在读取系统剪贴板，你是否相信它只是在搜自己商品的链接，又传给了不会泄露用户信息的广告商？

### 一个腐烂的例子

你花钱买的东西，使用起来要听某米公司的安排，你能接受吗

    比如某米牌手机，某打车软件因故被应用商店下架，你在这之前已经安装使用了，现在是否还能点开运行？由某米公司直接禁止用户使用自己手机上的软件，这个你怎么解决？

    你的某米牌智能家电，他要是给你远程禁用或启用某功能了，你如何知道，知道了又能咋样？

    某米手机在你使用手机时各种位置各种时间弹出广告，你能选择一键关闭全部吗？

    著名的某米手机广告链，你打开任何app，在首页广告闪现的时候，该手机会使用自己的广告链广告覆盖别人软件首屏app的广告，你感觉不到吧？跟不用该品牌手机的用户一起打开该软件对比对比就知道了。

    某米的智能家电，除了他明面上告诉你的某些记录功能，如果在后台悄悄的记录你的谈话关键字特征码、行动轨迹，发送给广告商，他会告诉你吗？

这样明显的侵犯用户个人权利，请问如何解决落实？

### 如果有人觉得苹果手机安全

苹果总裁能拒绝米国司法机关要求，不解锁毒贩子的 iphone。注意这种操作仅限于对米国。人家跟钱没仇，其它国家要求啥就是啥，赚钱就行。

苹果非常配合各国市场的不同国情，r 国的苹果和米国的苹果其实是完全不一样的：前几天，r 国苹果下线了反对派的某软件，据说又上线了一个该国国家机构的同款软件（疑似钓鱼），不知道 r 国反对派那些政党咋办。请自行搜索如下新闻：

    2021 年 09 月 17 日 俄罗斯的"Smart Voting"选举应用程序已从 App Store 和 Google Play 中删除，反对派发言人称这是"政治审查"。在俄罗斯要求苹果和 Google 删除该应用程序，然后威胁罚款之后，苹果和 Google 已经在该国下架了这一应用程序。
    <https://new.qq.com/rain/a/20210918a00gc400>
    <https://www.cnbeta.com/articles/tech/1180405.htm>

目前c国苹果手机卖的好，一个原因是没得选，想不看广告，不被骚扰，免除私人活动的不安全感，沉默的大多数只能用钱投票。

据信，苹果虽然把数据加密存放到贵州云中心，但是可以根据司法要求，提供查看的子密钥，这个是为了国内的合规，跟米国不同的。

### 某些山寨机，深度修改安卓系统的权限申请控制

有些权限比如读取应用列表等，根本不会在用户界面给出提示，摆明了给某些特殊 app 比如广告程序调用，详见下面章节[验证方法] 的 java 代码。

### 反炸

    https://www.zhihu.com/question/507934297/answer/2676942838

首先，我们在获取apk文件后，使用 apktool 解包

    arch -x86_64 brew install apktool
    apktool -d ~/downloads/gjfzzx.apk

我们来看 一下AndroidManifest.xml，我们着重观察下receiver。

```xml

<!--OPPO手机 查看你收到的短信-->
<receiver android:name="receiver.SmsReceiver">
  <intent-filter android:priority="1000">
    <action android:name="android.provider.OppoSpeechAssist.SMS_RECEIVED"/>
    <action android:name="android.provider.Telephony.SMS_RECEIVED"/>
  </intent-filter>
</receiver>

<!--查看播出的电话-->
<!--嗅探TCP和UDP连接-->
<!--阅读通信记录-->
<!--阅读短信-->
<!--阅读浏览记录-->
<!--阅读手机状态（手机号，设备ID，拨打种的电话）-->
<!--获取当前位置-->
<!--分析来源：JoeSandbox-->
<receiver android:enabled="true" android:exported="false" android:name="receiver.AVLAlarmReceiver"/>

<!--淘宝提供的接口，用于检测你的购买行为-->
<receiver android:name="com.taobao.accs.EventReceiver" android:process=":channel">
  <intent-filter>
    <action android:name="android.intent.action.BOOT_COMPLETED"/>
  </intent-filter>
  <intent-filter>
    <action android:name="android.net.conn.CONNECTIVITY_CHANGE"/>
  </intent-filter>
  <intent-filter>
    <action android:name="android.intent.action.PACKAGE_REMOVED"/>
    <data android:scheme="package"/>
  </intent-filter>
  <intent-filter>
    <action android:name="android.intent.action.USER_PRESENT"/>
  </intent-filter>
</receiver>

<!--友盟提供的接口，用于检测你收到的推送信息-->
<service android:exported="true" android:name="com.umeng.message.UmengMessageIntentReceiverService" android:process=":channel">
  <intent-filter>
    <action android:name="org.android.agoo.client.MessageReceiverService"/>
  </intent-filter>
</service>
<receiver android:exported="false" android:name="com.umeng.message.NotificationProxyBroadcastReceiver"/>

<!--魅族提供的接口，用于检测各种存在于魅族系统上的信息-->
<receiver android:name="receiver.UMMeizuReceiver">
  <intent-filter>
    <action android:name="com.meizu.flyme.push.intent.MESSAGE"/>
    <action android:name="com.meizu.flyme.push.intent.REGISTER.FEEDBACK"/>
    <action android:name="com.meizu.flyme.push.intent.UNREGISTER.FEEDBACK"/>
    <action android:name="com.meizu.c2dm.intent.REGISTRATION"/>
    <action android:name="com.meizu.c2dm.intent.RECEIVE"/>
    <category android:name="com.hicorenational.antifraud"/>
  </intent-filter>
</receiver>

<!--华为提供的接口，用于检测推送消息-->
<receiver android:name="org.android.agoo.huawei.HuaweiPushReceiver">
  <intent-filter>
    <action android:name="com.huawei.android.push.intent.REGISTRATION"/>
    <action android:name="com.huawei.android.push.intent.RECEIVE"/>
    <action android:name="com.huawei.android.push.intent.CLICK"/>
    <action android:name="com.huawei.intent.action.PUSH_STATE"/>
  </intent-filter>
</receiver>

<!--华为提供的服务，猜测是用于升级华为内置的API服务（这个猛）-->
<service android:exported="false" android:name="com.huawei.updatesdk.service.deamon.download.DownloadService"/>

<!--VIVO提供的接口，用于检测推送消息-->
<receiver android:name="org.android.agoo.vivo.PushMessageReceiverImpl">
  <intent-filter>
    <action android:name="com.vivo.pushclient.action.RECEIVE"/>
  </intent-filter>
</receiver>

<!--小米提供的接口，用于检测推送消息-->
<service android:enabled="true" android:name="com.xiaomi.push.service.XMPushService" android:process=":pushservice"/>
<service android:enabled="true" android:exported="false" android:name="com.xiaomi.push.service.XMJobService" android:permission="android.permission.BIND_JOB_SERVICE" android:process=":pushservice"/>
<service android:enabled="true" android:exported="true" android:name="com.xiaomi.mipush.sdk.PushMessageHandler"/>
<service android:enabled="true" android:name="com.xiaomi.mipush.sdk.MessageHandleService"/>
<receiver android:exported="false" android:name="com.xiaomi.push.service.receivers.PingReceiver" android:process=":pushservice">
  <intent-filter>
    <action android:name="com.xiaomi.push.PING_TIMER"/>
  </intent-filter>
</receiver>
<receiver android:exported="true" android:name="org.android.agoo.xiaomi.MiPushBroadcastReceiver">
  <intent-filter>
    <action android:name="com.xiaomi.mipush.RECEIVE_MESSAGE"/>
  </intent-filter>
  <intent-filter>
    <action android:name="com.xiaomi.mipush.MESSAGE_ARRIVED"/>
  </intent-filter>
  <intent-filter>
    <action android:name="com.xiaomi.mipush.ERROR"/>
  </intent-filter>
</receiver>

```

然后，我们再看看包含了哪些so库

    libcwlive.so (嗅探某些直播软件？)
    libumeng-spy.so (友盟放出的侦测sdk？)
    liburldetectorsys.so (探测浏览记录相关的sdk？)
    libweibosdkcore.so (探测微博信息？)

我们再看看资源文件包括了哪些值得注意的东西？

file_path.xml 似乎列出了各种path，疑似扫描目录，位于以下路径的文件可能都会被扫描

```xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <paths>
        <external-path name="download" path="" />
        <external-path name="files_root" path="Android/data/com.hicorenational.antifraud/" />
        <external-path name="external_storage_root" path="." />
        <cache-path name="downloads" path="downloads" />
        <external-path name="beta_external_path" path="Download/" />
        <external-path name="beta_external_files_path" path="Android/data/" />
        <external-files-path name="umeng_cache" path="umeng_cache" />
        <root-path name="opensdk_root" path="" />
        <external-files-path name="opensdk_external" path="Images/tmp" />
        <external-files-path name="share_files" path="." />
    </paths>
</resources>

```

接下来应该没什么可以看到的了，代码明显被加固过，使用的是腾讯的加固服务。

### eSim 卡

    https://www.zhihu.com/question/382792603/answer/1132731375

    https://www.zhihu.com/question/382792603/answer/1118995003

    https://www.zhihu.com/question/382792603/answer/1110143670

sim卡的安全性是由私钥只可写入不可读出来保证的，在实体sim卡的方案中，sim卡的生产是把握在运营商手中的，硬件上可以保证这一点。而esim方案，sim芯片取代了实体sim卡的位置，私钥不可读出需要终端保证。

比如你买到支持eSIM的手机后，想办中国联通的号，那就在手机内置应用里选择联通的套餐，然后手机号这些运行商数据会以空中写卡的方式下载到你的eSIM卡里，而这个下载过程才是后续所有安全保障的根源所在，如果你能安全地完成远程写卡，那eSIM的安全性就相当于普通SIM卡，反之，如果写卡过程被破解了，那万事休矣。

相比传统的SIM卡eSIM面临的安全风险只多不少。终端需要远程获取eSIM文件，光这一个设计就面临一堆风险：数据传输的中间人问题；远程管理平台的传统安全问题；对外开放接口、端口方面的安全问题；eSIM文件丢失、盗用问题；如果单独在盗用方面细化，比如：终端层面的非法访问；恶意软件的非法窃取；鉴权过程中服务器到终端需要多方介入，人为盗用风险；从服务器端通过接口可以向芯片或存储区写入内容，本身就要面临很多威胁 。

保证不被复制一个是存储安全，也就是说硬件里不要有能被读出来可能性。这个通过设计和生产流程安全保障。第二是使用安全，也就是使用过程中可以防止被猜到。防侧信道攻击。设计生产安全。第三是通信安全，在公开的信道上无人可以读到。3gpp协议保障。第四是管理安全，esim卡上开卡之类的管理流程安全。gsma协议保障。目前，设计方面都有安全认证，一般在eal4或5级认证，保障第一二。运行安全采用安全算法和协议也没问题。

### 打电话时拨号界面弹出视频广告

拨打电话后的等待过程中，手机拨号界面会弹出小视频或视频广告，这个业务叫视频彩铃。

要命的地方在于，当你拨号完毕看到手机出现了拨号画面，刚把手机放到耳边，突然响起了雷鸣般的欢呼“唔哇！xxx夺冠啦！xxxx！xxxxxxx！”，或者突然一阵炸响的鞭炮声“欢欢喜喜过大年！啊过大年！”惊魂未定的你，发现通话背景变成了一段欢腾的视频广告，声音还巨响。吓得气抖冷的你，怪谁好呢？

原因解释：

这种情况是由于被叫方（对方）开通了视频彩铃功能，主叫方（用户）界面没有关闭按钮。关键在于，通信运营商默认给用户开通这个业务，手机默认支持这个功能，而用户自己一般是不知道的。

当您的手机满足下列三点条件时，就可以看到被叫方（对方）的视频彩铃：

1. 双方都开通了4G网络通信，且支持视频彩铃业务。
2. 主叫方（用户）设备支持播放视频彩铃。
3. 被叫方（对方）开通视频彩铃业务。

4G模式下，当被叫方（对方）开通视频彩铃业务后，无论被叫方（对方）是否关闭VoLTE，主叫方（用户）打开VoLTE就可以显示视频彩铃，关闭VoLTE则不可显示。

5G模式下，当5G手机打开5G功能时，手机默认支持VoLTE通话功能。当关闭5G开关后，VoLTE高清通话开关会显示出来，关闭VoLTE高清通话即可。

+ 如果您不想看到别人的视频彩铃

    “Volte 高清通话”功能其实可以细分为“Volte 高清语音”和“Volte 高清视频”两类，只是手机或运营商给的设置未必分这么细。我们需要的其实是关闭“Volte 高清视频”这个功能。

    你是移动用户

        关闭“Volte 通话”功能，以三星手机为例：设置->连接->移动网络，关闭“Volte 通话”。
        缺点是不看广告的同时会失去4G手机的高清语音功能，不过你在3G时代打电话遇到过语音不清嘛？

    你是联通用户

        目前无解，手机下载联通营业厅app，在“业务->办理”选择关闭“Volte 通话”功能，提示套餐禁止关闭该功能。
        拨打10010联系不上话务员，只能去本地营业厅问。

+ 如果你不想用自己的视频彩铃吓到打电话给你的人

    你是移动用户

        拨打10086，告知话务员关闭自己的视频彩铃业务。

    你是联通用户

        手机下载联通营业厅app，在“我的业务“里面找到视频彩铃，选择关闭。

## app 隔离的解决方案

要求

    可以正常使用手机各项功能，又能够限制 app 乱读取发送用户数据，甚至越界操作用户的其它 app。

重点就是虚拟环境内运行的 app，看不到外部的应用、应用列表、数据等。

当前常见的轻量化的实现方式是：

    应用程序容器化运行 --- 给流氓软件一个干净的系统环境让他随便折腾。

    另外优先安装使用开源的app，参见章节 [安卓的开源软件商店F-Droid]。

Android 提供了 "Work Profile" 功能来提供一个隔离的空间，用户可以在其中安装应用程序或把当前手机环境中的应用添加到其中

    https://learn.microsoft.com/zh-cn/mem/intune/user-help/what-happens-when-you-create-a-work-profile-android

    https://blog.csdn.net/qq_35501560/article/details/105976660

开启 Work Profile 之后，系统分为了两个空间，为方便描述，我们把安装普通应用的空间称为 personal profile（个人空间），安装图标上带有公文包徽章的应用的空间称为 work profile（工作空间）。

两个空间相互独立，例如 “工作空间” 不能调用 “个人空间” 的相机，“个人空间” 也不能读取 “工作空间” 保存的文件。

除了显而易见的双开、数据安全独立之外，开启 “工作空间” 的宿主机拥有这个 “工作空间” 的 profile owner 权限，用户可以利用这个权限对 “工作空间” 里面的应用进行管理：

    设置密码、禁止安装、禁止截图、禁止拍照等

    在 “工作空间” 中添加应用：把宿主机里的应用添加到 “工作空间”，这大大方便了工作。

    用户也可以在两个空间之间互相移动文件，实现数据的交换。

宿主机里的应用添加到 “工作空间”，实际使用起来很方便而且是隔离的：

    在实体机环境安装的 app 默认不会被添加到 “工作空间”，如果单独选择某个 app “添加到工作空间运行”，app 在打开时是初始安装完毕的状态，实体机内用户使用生成的 app 的配置文件和数据信息不会被添加进去。

    不用担心 app 被复制两次占用系统存储，容器化技术可以保证只需要安装一次 app。在多个工作空间运行的 app，利用了已安装的 app 的可执行部分，在系统中用多个进程隔离运行，而且各个 “工作空间” 的数据存储也是互相隔离的。

    区分同一个 app 的两个图标，哪个位于 “工作空间”，就是观察图标上是否带有公文包徽章。

手机的应用程序节能策略，是全局不区分实机虚机的。“工作空间” 内的 app都在实体机内被系统设置管理，可以设置进入深度休眠不乱发系统通知。

"Work Profile" 功能可以被信任的安全保证的逻辑链条：

    如果 google 开源的安卓系统照顾到用户个人权利，那么它进行权限控制是可信的；

    如果手机厂商的订制版安卓系统是按照 google 的安卓系统标准扩展开发的，并没有把权限控制等功能变成用户无感知或越界，那么手机厂商的安卓系统也是可信的。

    在此基础上的手机厂商提供的 “Work Profile” 功能，也是可信的。

安全限制：

    在 “工作空间” 内部运行的 app，都受到 “工作空间” 权限控制的管理，读取到的是虚拟环境的裸机状态，不会读取到实机的应用和数据。除非该 app 利用安卓操作系统的漏洞，越权跨进程操作，但这是“黑客”行为，一般大公司没脸这么干，拼多多例外，参见章节 [沙箱隔离运行的安全局限性]。

    “工作空间” 提供的安全保证不可能超越实体机环境，即你的手机操作系统如果有安全问题比如获取你的隐私，你使用的 “工作空间” 是管控不了的。

“Work Profile(工作空间)” 详见下面的章节 [Work Profile 隔离 ---- 三星 knox 安全文件夹] 和 [Work Profile 隔离 --- 开源的 Shelter]。

如果自己搞定制的容器化，详见章节 [深度定制虚拟机套娃]。

### Work Profile 隔离 ---- 三星 knox 安全文件夹

    https://zhuanlan.zhihu.com/p/66659414

    https://www.v2ex.com/t/377512

三星 knox 技术的 “安全文件夹”，就是利用的安卓系统的 “工作空间(Work Profile)”，把 app 添加到 “安全文件夹”，就可以在单独的虚拟环境运行了。

因为是容器化运行，跟实体机环境相比，在 “安全文件夹” 中的环境是手机出厂时的状态，电话簿相机相册跟实体机全是独立的。

在 “安全文件夹” 内运行的 app 看来，当前的环境就是个刚买的裸机状态，本地存储、软件如联系人等都跟实机分离，应用程序的安装和权限设置也是单独的。

这样可以实现同一 app 在手机里运行两份，一个是当前的实体机下安装运行的，一个是 “安全文件夹” 里运行的，互不干扰。

实际使用起来很方便，而且数据也是隔离的，常用的相册、笔记等软件的内容都可以手工选择 “添加到安全文件夹” 或 “移出安全文件夹”。

三星的本意是把需要保密的 app 装到 “安全文件夹” 里运行，鉴于当前国内安卓 app 的混乱情况，只能倒用：

    把不安全的 app 装到这个 “安全文件夹” 里，让他对着一份干净的安卓系统环境随意折腾去吧。

验证：

    在 “安全文件夹” 里安装 “拼多多“，看他弹窗的力度，然后系统设置里把它设置为深度休眠，再看它弹窗的力度。

### Work Profile 隔离 --- 开源的 Shelter

Shelter：利用安卓的 "Work Profile" 功能实现应用程序的套娃运行。

    https://f-droid.org/packages/net.typeblog.shelter/

    源代码 https://gitea.angry.im/PeterCxy/Shelter
            https://github.com/PeterCxy/Shelter

    原理 https://support.google.com/work/android/answer/6191949?hl=en

Shelter 是一款免费开源（FOSS）应用程序，它利用安卓系统的 "Work Profile" 功能来提供一个隔离的空间，用户可以在其中安装应用程序或把当前手机环境中的应用添加到其中。Shelter 的安全性只能与 "Work Profile" 的实施一样，不会超越宿主机。

Shelter 的主要用例包括：

    在工作配置文件中安装应用程序以进行隔离

    在工作配置文件中“冻结”应用程序，以防止它们在您不主动使用它们时运行或被唤醒

    在一个手机上安装运行同一应用程序的两个副本

请注意：Shelter 依赖于安卓系统的 "Work Profile" 功能，因此与您手机使用的安卓衍生系统中的 "Work Profile"相关的任何错误都会影响 Shelter，也就是说，主机操作系统的安全漏洞，用 shelter 是规避不了的。

有关完整的说明，请阅读 Shelter 的 Git 存储库。

### xposed --- 强大的钩子框架

    https://zhuanlan.zhihu.com/p/88028353

xposed 的工作原理就是 hack --- 修改系统的关键文件，使得 app 调用系统API时，首先经过 xposed 框架。

这样基于 xposed 的自定义模块就实现了拦截 app 的请求，自己干一些 “其它” 的事情，或者修改返回的结果，这样 app 在运行的时候效果就会改变。例如：修改微信的界面，自动抢红包模块，自定义程序的文本，防止微信消息撤回，防止BAT三大流氓的全家桶相互唤醒 等等。

app 本身并没有被破坏，只是在调用系统 api 的时候，Android 系统的表现发生了变化，这就是钩子，专业术语 hook。

利用 xposed 框架搞的所谓虚拟运行环境，其实属于 hack 当前安卓系统，再此基础上实现定制化的改变安卓系统的 API。

如果你想要安全运行流氓软件

    不存在的，xposed 限制不了你安装的应用程序的流氓行为，只能拦截指定的 api，利用自定义模块实现自己的行为。

### 深度定制虚拟机套娃

如何虚拟化运行安卓 app，并检查它到底使用了啥权限

    https://www.jianshu.com/p/84127032d15a
        https://github.com/android-hacker/VirtualXposed
        https://github.com/sgl890226/HookLoginDemo

    TODO: 自己写个申请各种权限的 app，装到手机里挨个检查。

    两仪

        一个轻量级的 Android 容器。它可以在 Android 系统上以一个普通 App 的身份（免ROOT）来运行一个相对完整的 Android 系统。

            https://github.com/twoyi/twoyi/blob/main/README_CN.md

    该作者还有个“太极”

        基于 xposed 的深度定制 https://github.com/taichi-framework/TaiChi

在当前的手机系统（宿主机）上再运行个虚拟机系统，这个虚拟机系统完整照搬当前手机的原始安卓系统状态，软件系统和数据都是原始系统的，就像一个新买的手机系统。

把 app 装到这个虚拟机系统的安卓里，这样它无法越界到宿主机，读取甚至控制宿主机的应用程序。

在虚拟机中，系统的环境是初始安装状态，即硬件和系统软件为出厂状态，看不到主机环境的相册联系人等。

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

### 验证虚拟化隔离app

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

### 沙箱隔离运行的安全局限性

google 自称安卓 app 都是在 java 沙箱运行，可以保证是隔离环境。但是，安卓给沙箱环境留足了系统接口，而且各个应用都放在同一个隔离环境中，应用可以经权限申请甚至利用漏洞越权，读取整个系统的任意信息，跟没限制啥区别。

安卓操作系统是开源的，但是各大手机厂商都自己深度修改了安卓的权限控制，用户怎么知道？ 人家卖广告数据赚钱的，都是走后台。比如小米手机，直接替换各应用 app 首页的开屏广告为小米广告链上的广告，它还宣传自己最重视用户隐私，各种屏蔽别人的广告，作为各大应用的开发商，你不交钱上小米广告链，还能咋办？

“拼多多”组织了100多人的开发团队，专门研发超越系统控制，利用安卓漏洞获取系统权限，在你的手机里各种弹窗、发消息。最初只针对农村乡镇，无人发现，2023年4月才被披露

    https://www.zhihu.com/question/590996457/answer/2957126967

    https://github.com/davinci1010/pinduoduo_backdoor

现在国内的安卓手机应用的安全现状，只能靠各大手机厂商软件商 “要脸”，至于多大程度上 “要脸”，不大好说。

## 安卓手机选择

目前最优是三星手机，开启 knox 功能，把 cn 软件放到安全文件夹里，在外面安装 F-Droid 软件商店。

次选 google 的 Pixel 手机，除了它家的全家桶，还真不收集你其它隐私了。。。

开源 rom

    spark-os 适配小米手机比较多

        https://sourceforge.net/projects/sparkosofficial/
            https://spark-os.live/team
                文档 https://github.com/Spark-Devices/Documentation
                rom https://github.com/Spark-Rom

    需要明确开发者是否独立，另外小米手机硬件是否有独立于 rom 不受控制的功能？千万不要高估它的下限。

开源手机及操作系统，见章节 [全开源自由软件的手机平台]。

### 全开源自由软件的手机平台

    https://bbs.letitfly.me/d/1058

    https://zhuanlan.zhihu.com/p/402700739

    https://itsfoss.com/open-source-alternatives-android/

Android 自己就不怎么干净，哪怕是开放源代码的 Android Open Source Project，也有不少私有成分（例如 Linux 内核里到处乱飞的厂商 Blob，通常是一堆没有源代码只有二进制文件的部份，通常是固件和微码什么的）。

虽然核心操作系统仍然作为 Android 开源项目的一部分发布，但大多数核心应用程序都没有开源。 情况变得更糟：越来越多的库和 API 仅在预装运行各种 Google 应用程序的手机上可用，有效地将第三方应用锁定在谷歌生态系统中。

真正算得上完全自由的 Android 发行版大概只有 [Replicant](https://replicant.us/) 了，虽然到现在只支持到 Android 6.0 ，支持的设备也有限（最新的大概也只是 Galaxy S3/ Note 2那个时期的），已经有构建的设备的支持也很是问题（不少缺 WiFi 固件于是不能用 WiFi，图形性能也很糟糕……）。

要使用开源的安卓操作系统替代品，你得自己刷机

        https://sspai.com/post/43338

    LineageOS 缺点是 Google 服务几乎全都没法用了 https://lineageos.org/

        https://forum.xda-developers.com/c/android-development-and-hacking.564/LineageOS

        国内有个玩家论坛 https://www.lineageos.org.cn/

        基于LineageOS
            https://resurrectionremix.com/
            https://aicp-rom.com/

    OmniROM  基于AOSP的第三方
        https://omnirom.org/

    microg 尽力在替换 Google专有核心库和应用程序的开源实现
        https://microg.org/

硬件上可以关闭 Modem，有 coreboot 安全启动的 Linux 手机

     Librem 5 https://puri.sm/posts/privacy-in-depth/

        使用了开源操作系统 PureOS（基于Debian + Purism 的 phosh、phoc、libhandy、Calls 和 Chats），只预装自由软件
            https://pureos.net/
                https://puri.sm/posts/what-is-mobile-pureos/

    PinePhone https://www.pine64.org/pinephone/

        使用开源的操作系统 Major Linux Phone Projects，支持其它很多开源的 Linux 手机版

    Fairphone https://shop.fairphone.com/en/

        使用定制版的安卓系统，即 Fairphone OS

    fxtec https://www.fxtec.com/

        支持 Ubuntu Touch、Lineage OS 和安卓

魔改电脑和手机，有些通过了Qubes认证

    https://www.nitrokey.com/

## 安卓的开源软件商店F-Droid

    优先在 Fdoriod 软件仓库安装开源版的手机应用软件

F-Droid 是一个 Android 应用程序的软件资源库（或应用商店）；其功能类似于 Google Play 商店，但只包含自由及开放源代码软件，即所谓免费开源（FOSS）。应用可从 F-Droid 网站或直接从 F-Droid 客户端应用浏览及安装。

    https://f-droid.org/

        https://f-droid.org/zh_Hans/contribute/
            https://gitlab.com/fdroid/fdroidclient

        https://f-droid.org/zh_Hans/docs/

F-Droid的软件虽然不多，但是很实用。

F-Droid 最大的特点在与其与Linux软件包管理高度吻合，采用的是源安装，和 Linux 必须添加软件源是一个道理。这些 repositories 源，类似于我们在 Linux 平台上在 /etc/apt/sources.list.d/（Debian 或 Ubuntu 系）或 /etc/yum.repos.d/（Fedora 系）放入源一样， 表示从此信任这个来源/市集/repository 里面的软件。

F-Droid 会把这些 repositories 所提供的软体信息存储一份清单在手机里。这个清单需要不时更新。当我们发现有些 App 或某些版本看得见却无法安装的时候，很可能就是因为我们手机上的清单过时了，需要更新，这跟 Debian 的 apt update 或 Fedora 的 yum update 意思一样。当然，我们也可以在手机客户端中设置 automatic update interval（自动更新间隔）。

优点一、

应用源代码看得见，用户自己可以审核。大家从可靠的 repositories 下载软件，这些repositories由长期帮助人类编译源代码的热心人士共享。至于哪些 repositories 是可信任的？没有人帮你决定，你有权利也有义务自己判断。

优点二、

商店接受应用上架时的审查原则：[Anti-Features（负特征）](https://f-droid.org/zh_Hans/docs/Inclusion_Policy)。

F-Droid 首先会从用户的角度出发，基于开源软件和用户控制原则的严格的收录标准。 应用的某些内容可能不会阻止它被收录，但许多用户也许不想接受它们。 为了处理这类情况，F-Droid制定了一系列明确的负特征来标记应用，以便用户选择是否仍要接受该应用。包括应用调用的第三方库的可疑之处，如广告、跟踪用户行为的活动、使用的加密算法不够公开等。

最严重的情况是很多开源应用程序需要安装私有组件或google的专有库（程序员只要能用现成的库省事，一般都不会自己去开发）。

例如 Telegram 的官方客户端有私有组建，服务端还是私有的，默认情况下不会在列表里显示。汝可以在设置中的应用兼容性选项中打开“显示需要 anti-feature 的应用”选项来显示那些包含 anti-feature 的程序。

### F-Droid 安装和添加仓库

    https://forum.f-droid.org/t/known-repositories/721

1、先用 apk 方式下载安装 F-droid 仓库

    https://f-droid.org/F-Droid.apk

2、启用 F-Droid 内置的 Guardian Project 仓库，，点选开启即可

也可手工添加

        https://guardianproject.info/fdroid/

用 F-Droid 客户端打开此链接：

    https://guardianproject.info/fdroid/repo?fingerprint=B7C2EEFD8DAC7806AF67DFCD92EB18126BC08312A7F2D6F3862E46013C7A6135

使用 F-Droid 打开上面的长链接，在弹出界面中点击添加镜像。也可以复制长链接，在应用⚙设置 - 存储库中，点击右上角的加号手动添加。添加完成后，还需要反选择存储库中的二个 F-Droid 库，只保留刚才添加的用户镜像，其他镜像悉数关闭，保证软件只从国内镜像站获取更新。

3、也可添加清华源

    https://mirrors.tuna.tsinghua.edu.cn/help/fdroid/

如果需要添加清华源的 Archive 库，可以使用如下链接：

    https://mirrors.tuna.tsinghua.edu.cn/fdroid/archive?fingerprint=43238D512C1E5EB2D6569F4A3AFBF5523418B82E0A3ED1552770ABB9A9C9CCAB

其它的源速度很慢，不加也罢。

### 手机软件开源化应用

    https://bbs.letitfly.me/d/1058

安装应用软件，优先在 F-droid 开源软件仓库安装，没有的软件在应用商店安装，最次选才是下载 apk 文件安装。

对商业闭源软件，务必在三星手机在 “安全文件夹” 中安装，或者用 Shelter 运行，详见章节 [安卓虚拟机 Shelter]。

电话、短信和拍照的话，用系统自带的大概就够用了。（LineageOS 内置的应该也是自由的吧……）

文件管理器：

    Amaze

        https://f-droid.org/en/packages/com.amaze.filemanager

媒体播放：

    VLC

        https://f-droid.org/zh_Hant/packages/org.videolan.vlc/

    mpv-android

        https://f-droid.org/en/packages/is.xyz.mpv/

密钥管理:

    2FA 应用：Aegis

        https://f-droid.org/en/packages/com.beemdevelopment.aegis/

    OpenKeyChain：支持 gpg 用于邮件签名和加解密的开源应用，主要与 K-9 Mail 集成

        https://f-droid.org/en/packages/org.sufficientlysecure.keychain/
            https://www.openkeychain.org

    OkcAgent：让你的 Termux 可以使用 OpenKeychain 里的 ssh 密钥，相当于密钥代理。

        https://f-droid.org/en/packages/org.ddosolitary.okcagent/

阅读和发送电子邮件：

    K-9 Mail

        https://f-droid.org/en/packages/com.fsck.k9
            https://github.com/k9mail/k-9

        如果你在电脑上经常用邮件客户端的话你可以使用 [Thunderbird](https://www.thunderbird.net/en-US/)。在电脑上生成好的 “加密E” 和 “签名S” 功能的子密钥，导出子私钥到文件，然后导入到 OpenKeychain，这样 K-9 Mail 就可以调用了。详见章节 [安装支持 gpg 签名的电子邮件软件](gpg think)。

        如果你用 Android 收发邮件比较多的话，建议你直接用 OpenKeychain 生成密钥对然后发布公钥，使用 K-9 Mail 就好了，电脑端如果需要使用，可以从 OpenKeychain 导出私钥到电脑端，由 Thunderbird 导入使用。

   FairMail

        https://f-droid.org/packages/eu.faircode.email/

        也能与 OpenKeyChain 配合，发送和解密 GPG 加密的邮件。

浏览器：

    Fennic 重新编译过的 Firefox

        https://f-droid.org/en/packages/org.mozilla.fennec_fdroid/

    Guardian Project 也有 Tor Browser

        https://guardianproject.info/apps/org.torproject.torbrowser/

            用于 Orbot，基于 Tor 浏览器的改进 https://guardianproject.info/apps/info.guardianproject.orfox/

聊天：

    Telegram-FOSS：自由化处理过的 Telegram

        https://f-droid.org/en/packages/org.telegram.messenger/

    XMPP 的话有 Xabber 和 Conversations （为啥咱会用两个呢，因为前者支持 XMPP 中最常见的端到端加密协议 OTR，另一个支持比较新的 OMEMO 和 openPGP…… （其实 Conversations 一开始也是支持 OTR 的，就是行为有些奇怪而且后来砍掉了……）😂）。

    IRC：WeeChat for Android

        https://f-droid.org/en/packages/com.ubergeek42.WeechatAndroid

        连上咱 VPS 上的 WeeChat 好了（别和某微幕搞混！）

    Matrix：Riot.im

        https://f-droid.org/en/packages/im.vector.alpha

    Mattermost： Mattermost

        https://f-droid.org/en/packages/com.mattermost.rnbeta

    Tox: 简易点对点DHT网络通信，无法在家庭内网独立运行，客户端功能简单，特别是在手机端。

        aTox

            https://f-droid.org/en/packages/ltd.evilcorp.atox/
                https://github.com/evilcorpltd/aTox/

            https://wiki.tox.chat/clients

视频会议

    Jitsi Meet

        https://f-droid.org/en/packages/org.jitsi.meet/

网盘：Nextcloud 服务器搭建自己的 Nextcloud 实例，支持各种客户端

    https://f-droid.org/en/packages/com.nextcloud.client/

    F-Droid 上也有不少可以和 Nextcloud 协作的应用，例如:

    RSS 阅读器 Nextcloud News Reader

        https://f-droid.org/en/packages/de.luhmer.owncloudnewsreader/

    笔记辅助软件 Notes

        https://f-droid.org/en/packages/it.niedermann.owncloud.notes

    Notes 以外也可以试试 Markor

        https://f-droid.org/en/packages/net.gsantner.markor/

输入法：

    TRIME：基于 Rime

        https://f-droid.org/en/packages/com.osfans.trime/

工具箱:

    termux 在 Android 上运行 ssh 等 GNU/Linux 工具

        https://f-droid.org/en/packages/com.termux/

        详见章节 [安卓神器 Termux]。

    BusyBox 工具箱，集成了三百多个最常用Linux命令和工具的软件，也包含了 Android 系统的自带的 shell。

        https://busybox.net/

            https://www.cnblogs.com/xiaowenji/archive/2011/03/12/1982309.html

            https://www.zhihu.com/question/26190694

        适合改造老久手机替代树莓派，性价比超级高。缺点是需要root手机，优点是安装到安卓的linux系统里了，给系统增强了非常多的linux命令。

远程桌面：

    aFreeRDP

        https://f-droid.org/zh_Hant/packages/com.freerdp.afreerdp/

监视器：

    Haven 在你离开时，把你的手机变成监视器

        https://guardianproject.info/apps/org.havenapp.main/
            https://github.com/guardianproject/haven

        https://www.ctocio.com/ccnews/25688.html

紧急时刻：

    Ripple：支持 F-Droid、OpenKeyChain、Aegis

        https://guardianproject.info/apps/info.guardianproject.ripple/

    Duress 直接擦除设备

        https://f-droid.org/zh_Hans/packages/me.lucky.duress/

    Wasted 自毁，支持 Telegram

        https://f-droid.org/zh_Hans/packages/me.lucky.wasted/

行情查看 [都是闭源的，在应用商店安装]

    TradingView

    CoinMarketCap Binance

    OpenSea MetaMask

自媒体 [都是闭源的，在应用商店安装]

    Twitter Reddit  Mastodon  Instagram

    Telegram

    YouTube

    Spotify 网络电台，比 google radio 好

新闻聚合 RSS

    Inoreader

    BuzzFeed

## 使用商业闭源软件

最好在应用商店安装，不要单独下载为本地 apk 文件安装，可控程度不如在应用商店安装，只能由手机操作系统保证。

NOTE：最好在虚拟机内安装运行，比如三星手机的 “安全文件夹”，或使用 Shelter，详见章节 [安卓虚拟机 Shelter]。

如果你使用的软件不断提醒你升级，点击确认后，不是跳转到应用商店的页面，而是在程序内部自行下载并提示你点击确定进行安装，注意安全，这时候已经是下载到本地 apk 文件的方式安装了，绕过了软件商店的权限检查，只能依赖手机操作系统了。

    微信  qq  钉钉  支付宝  美团  腾讯会议  京东  淘宝  拼多多  知乎  微博轻享版  抖音  界面新闻  澎湃新闻  同花顺  西南金点子  西南期货  淘股吧  雪球  高德地图  滴滴出行  携程旅行  铁路12306  哔哩哔哩  酷狗音乐  掌上生活  招商银行  中国工商银行  中国建设银行  个人所得税  中国联通  小天才  学而思  天眼查  贝壳找房  货拉拉  momo

## 安卓神器 Termux -- 运行在 Android 上的开源linux模拟器

开源且不需要root，基于chroot技术的运行在android上的容器，内部是linux，内核一部分被砍了，不能安装docker。支持apt管理软件包，支持python,ruby,go,nodejs…甚至可以手机作为反向代理、或Web服务器。

    https://wiki.termux.com/wiki/Main_Page
    https://github.com/termux/termux-app#github

    https://blog.csdn.net/weixin_42599499/article/details/111185609

    Termux各种玩法专栏 https://zhuanlan.zhihu.com/c_1208079877376901120

busybox跟它比，简直就是小弟 <https://stackoverflow.com/questions/40140533/android-busybox-termux-test-envionment>

在Android的通知栏中也可以看到当前Termux运行的会话数，点击可切换进入。

屏幕左上角，左划弹出菜单选择新建会话，跟全面屏手势冲突，耐心点多试几次。。。

扩展功能按键（常用键是 PC 端常用的按键如: ESC键、Tab 键、CTR 键、ALT 键）打开和隐藏这个目前有下面两种方法：

    方法一 从左向右滑动，显示隐藏式导航栏，长按左下角的KEYBOARD

    方法二 使用Termux快捷键:音量++Q键 或者 音量++K键

觉得虚拟键盘操作不方便的话可以尝试有方向键和功能键的 [Hacker's Keyboard](https://f-droid.org/en/packages/org.pocketworkstation.pckeyboard/)。

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

    apt update # && apt upgrade -y

清华镜像站还提供了如下社区维护的源，如需使用请自行添加：

    https://mirrors.tuna.tsinghua.edu.cn/termux/x11-packages
    https://mirrors.tuna.tsinghua.edu.cn/termux/unstable-packages
    https://mirrors.tuna.tsinghua.edu.cn/termux/termux-root-packages-24

### Termux 安装常用包

Termux 初步使用和设置

    https://zhuanlan.zhihu.com/p/92664273
    https://cloud.tencent.com/developer/article/2136450#3.3
    http://wwj718.github.io/post/%E5%B7%A5%E5%85%B7/termux-hello-world/

Android 应用都是在沙盒中运行的，每个应用都有自己的 Linux 用户 id 和 SELinux 标签。Termux 也不例外，Termux 中的所有程序都使用和 Termux 同样的用户 id 运行，用户 id 也许是 u0_a231 这种格式，并且不能更改。

所有的包（除了必须 Root 才能用的包），都被去掉了 多用户，setuid/getuid 和其它类似的功能。同时 ftpd, httpd 和 sshd 的默认端口也分别被修改为 8021, 8080 和 8022 。

Termux 支持 pkg、apt 管理软件包

    # pkg的底层就是apt，只是运行前会执行一次apt update，保证安装的是最新版本。

    pkg install sl
    # 测试包sl 小火车
    sl

    pkg install vim curl wget git tree unzip tmux fish -y

    # Python3
    pkg install python -y
    # pip 换清华源
    python -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

    # c/c++
    pkg install clang
    # 可以复制代码到子目录shared里面然后进行编译，如c++，但是要注意的是，在手机内存中的文件无法通过chmod进行更改权限，进而无法运行。 必须将文件放在home 目录下，且非storage目录下(可以是home/test/test1)才能使用chmod更改权限

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

    # 取得sd卡权限，需授权
    # 在手机中设置给予 termux 所有文件系统访问权限即可
    pkg install termux-tools
    termux-setup-storage
    # 当前目录下出现了storage这个目录，下面在子目录分别对应了手机当中的部分目录
    # 子目录shared，共享了手机中的内部存储
    # https://wiki.termux.com/wiki/Internal_and_external_storage

    # 对 安卓系统目录下的 /Andriod/data/com.xxx/ 的读取只能先 root
    # su、sudo 命令封装
    pkg install tsu
    sudo su

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

    cat id_ed25519.pub >> $HOME/.ssh/authorized_keys

#### 公网访问手机

我们如何把手机中的端口暴露到公网呢，有两种方式都很方便:

    使用ssh反向代理(使用autossh解决隧道的稳定性问题)

    使用ngrok（使用ngrok arm版本）

如此一来手机中运行的网站你就可以在公网访问它，当然你也可以把ssh端口暴露到外网，这样你可以在任何有网络连接的地方连接到你的手机里，前提是Termux处于运行状态。

### Termux 上安装linux

    极致安卓之—Termux安装完整版Linux <https://zhuanlan.zhihu.com/p/95865982>

    <https://wiki.termux.com/wiki/PRoot#Installing_Linux_distributions>

PRoot 是一个 chroot, mount –bind, 和 binfmt_misc 的用户空间实现。这意味着，用户不需要任何特殊权限和设置就可以使用任意目录作为新的根文件系统或者通过QEMU运行为其它CPU架构构建的程序。PRoot 通过伪造系统调用的参数和返回值，可以使程序看起来像运行在root用户下，但它并不提供任何方法来真正的提权。确实需要root权限去修改内核或硬件状态的程序将无法工作。

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

    pkg install termux-api

之后就可以在terminal中操控手机硬件，这样一来我们可以以编程的方式来控制手机

    # 获取手机剪贴板内容
    termux-clipboard-get

    # 给10010发短信 hello:
    termux-sms-send -n 10010 hello

python包装了一下termux:api: <https://github.com/wwj718/termux_python>

### Termux 高级终端安装使用配置教程

转自 <https://www.sqlsec.com/2018/05/termux.html>，感谢作者的持续付出。

基本命令

Termux 除了支持 apt 命令外，还在此基础上封装了pkg命令，pkg 命令向下兼容 apt 命令。

apt命令大家应该都比较熟悉了，这里直接简单的介绍下pkg命令:

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

软件安装

除了通过上述的 pkg 命令安装软件以外，如果我们有 .deb 软件包文件，也可以使用 dpkg 进行安装。

    bash
    dpkg -i ./package.de         # 安装 deb 包
    dpkg --remove [package name] # 卸载软件包
    dpkg -l                      # 查看已安装的包
    man dpkg                     # 查看详细文档

目录结构

    bash
    echo $HOME
    /data/data/com.termux/files/home

    echo $PREFIX
    /data/data/com.termux/files/usr

    echo $TMPPREFIX
    /data/data/com.termux/files/usr/tmp/zsh

长期使用 Linux 的朋友可能会发现，这个 HOME 路径看上去和我们电脑端的不太一样，这是为了方便 Termux 提供的特殊的环境变量。

#### Termux:API

## TODO: postmarketos 旧手机的新生

postmarketos 把你的旧手机作为一个低功耗平台

    https://postmarketos.org/
        https://wiki.postmarketos.org/wiki/Installation_guide

    https://ivonblog.com/posts/postmarketos-general-installation/

    https://ivonblog.com/posts/postmarketos-multiple-des/
