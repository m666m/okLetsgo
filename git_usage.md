# git 源代码分支管理

善用 git 帮助查找命令 `git help branch`

    使用 Git hub http://www.cnblogs.com/zhangjianbin/category/934478.html

    git的几种工作流
        https://www.zhihu.com/question/20070065/answer/1174997617
        https://zhuanlan.zhihu.com/p/79668697
        https://www.cnblogs.com/pluto4596/p/11464819.html

    git官方文档
        https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E5%BC%80%E5%8F%91%E5%B7%A5%E4%BD%9C%E6%B5%81

    vs code 使用 git
        https://code.visualstudio.com/docs/sourcecontrol/intro-to-git

    命令参考 https://git-scm.com/docs

        `git help xxx`

    命令速查

        https://github.com/k88hudson/git-flight-rules/blob/master/README_zh-CN.md

        https://training.github.com/downloads/zh_CN/github-git-cheat-sheet/

    git使用教程
        https://zhuanlan.zhihu.com/p/158076293
        https://www.liaoxuefeng.com/wiki/896043488029600

    git命令教程
        https://learngitbranching.js.org/?locale=zh_CN
        https://www.yiibai.com/git/git_branch.html

    git分支的使用过程 https://zhuanlan.zhihu.com/p/22369088

## git 的基本概念

程序开发，大部分都是在处理源代码这种文本文档，期间会对同一文件反复修改，为记录变更，便于回溯或多次修改、同步变更等操作，我们使用版本控制软件专门处理这种工作。

git 是以文件修改前后的差异为基准进行比对的，在此基础上衍生出分支管理等功能，它的工作方式基于 snapshot 快照，并进行分布式存储。

你的文件有3种存在：仓库区 ----> 暂存区 stage 或 index ----> 工作区 work space

    初始状态工作区的文件就版本库的文件，暂存区是空的，版本库没变化

    当你修改了文件，则工作区文件的状态是修改，暂存区是空的，版本库没变化

    当你执行了 git add，修改的文件添加到了暂存区，这时你在工作区的文件和暂存区是一致的，版本库没变化。

    所有修改都验证无误之后，git commit提交到版本库，这时三个区的文件都一致了。

    文件每添加到一个区域，有对应的回退步骤，见章节[如何回退]

详见章节 [基本概念：工作区、暂存区和版本库]。

git 的很多命令操作都是区分这几个区的，如 git fetch、git diff，参数不同意义不同，使用时注意区分。

一般在执行一个操作之后都要运行 git status 查看下当前状态，git 也会出下一步操作的建议。

git 对文件内容的修改，在撤销和重做方面有些使用不便，详见章节 [竞品 -- 基于文件差异(patch)的源代码管理系统]。

### 何时使用git而不是svn

因为git就是给开源准备的，适合开源方式开发的就适合用 git。

    源代码、配置文件等文本文件占比大的项目，用 git，少量的二进制文件可以用 git-lfs 管理。

    二进制文件较多的项目，比如游戏、艺术、摄影等，用 svn 更合适。

    如果是一个较大的项目，目录众多，管理权限设置分门别类，人员权限各有不同，用 svn。

## git 客户端使用仓库设置身份验证

除了 github 这样的开源代码网站，git 私有仓库都需要用户身份验证才能拉取和推送，github用户也是一样，如果想修改自己的仓库内容，需要使用 git 协议通过调用 ssh 客户端操作 github 的远程仓库。

    github 登陆身份验证

        https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup

    如果使用 https 身份验证，可使用 Credential 提高使用方便
        https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage

    常见问题 https://github.com/git-for-windows/git/wiki/FAQ

    在 cmd 或 powershell 下运行要设置环境变量
        https://github.com/git-for-windows/git/wiki/FAQ#running-without-git-bash

    图形化客户端

        https://www.sourcetreeapp.com/
        https://tortoisegit.org/

下载

    https://git-scm.com/download/win
        https://github.com/git-for-windows/git/

命令 `git config` 操作的配置文件，在各个 Git 仓库里的 .git/config 文件

命令 `git config --glboal` 修改 Git 的全局配置文件，在 ~/.gitconfig 文件

### 1、设置用户名和电邮

如果未设置过 git 用户名和邮箱，设置个默认的全局使用，如果是主用办公，设为办公用户名和电邮，个人自用，按自己的习惯设置即可。

    # 查看
    git config --global --list

    # 设置
    git config --global user.name "m666m"
    git config --global user.email "31643783+m666m@users.noreply.github.com"

如果是在已有的项目文件夹里，注意检查是否需要更新用户名和电邮地址。比如 github 项目使用 github 用户名和电邮，填写前面复制的 github 的 noreply 电邮地址。

    # 查看
    git config user.name
    git config  user.email

    # 设置
    git config user.name "m666m"
    git config user.email "31643783+m666m@users.noreply.github.com"

### 2、设置 ssh 客户端

    https://docs.github.com/zh/authentication

生成 ssh 密钥文件，默认回答都是一路回车

    ssh-keygen -t ed25519

如何生成 ssh 密钥参见章节 [ssh登录验证使用密钥文件](ssh think)。

将 github 以下 ssh 密钥条目添加到你本地的 ~/.ssh/known_hosts 文件中，可以避免第一次连接时手动验证 GitHub 主机：

    # https://docs.github.com/zh/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
    github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
    github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
    github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==

如果是私有仓库，可以添加本机用户的公钥到远程仓库git用户的认证密钥文件中，以便后续ssh免密登陆

    ssh-copy-id -i ~/.ssh/id_ed25519.pub -p 2345 git@11.22.33.44

### 3、设置使用 ssh 密钥方式管理你的 gitub 代码库

    https://docs.github.com/zh/authentication/connecting-to-github-with-ssh

登陆你的github帐户，点击你的头像，然后 Settings。

-> 左栏点击 Emails -> 右侧页面勾选 “Keep my email addresses private”、 “Block command line pushes that expose my email”、“Only receive account related emails, and those I subscribe to.”。 复制页面中提示的 noreply 电邮地址，后面要用。

-> 左栏点击 SSH and GPG keys -> 点击 New SSH key

在你本地机器登陆账户的主目录下的 ~/.ssh 目录，复制下面的文件内容粘贴进去

    # 使用命令 `ssh-keygen -t ed25519` 即可生成，详见章节 [配置 ssh 客户端使用密钥文件登录](ssh think)。
    cat ~/.ssh/id_ed25519.pub

验证：

    # 如果超时，就多试几次，国内的网络环境太差
    $ ssh -T git@github.com
    Received disconnect from ... port 22:11: Bye Bye
    Disconnected from ... port 22

    # 成功
    $ ssh -T git@github.com
    Hi m666m! You've successfully authenticated, but GitHub does not provide shell access.

    # 登陆问题排查
    ssh -vvv git@github.com

你的 GitHub 密钥是公开的，可以直接查看自己的公钥

    # ssh
    https://github.com/m666m.keys

    # gpg，参见章节 [使用 GPG 签名 Github 提交]
    https://github.com/m666m.gpg

    # https://words.filippo.io/dispatches/whoami-updated/
    执行 ssh whoami.filippo.io，它能根据你的公钥查到你的 github 用户名

然后就可以 ssh 方式使用 github 了：

    先拉取远程仓库，在本地建立项目

        git clone https://xxx.git

    查看是否此项目使用 https 协议

        $ git remote -v
        origin  https://github.com:m666m/okLetsgo.git (fetch)
        origin  https://github.com:m666m/okLetsgo.git (push)

        # 可改为使用 git 协议
        git remote set-url origin git@github.com:m666m/okLetsgo.git

    在拉取远程时直接使用 git 协议，就不用修改了

        git clone git@github.com:m666m/okLetsgo.git

    因为本地持有 ssh 密钥，你可以编辑这个仓库的文件，然后提交推送到 github 上的远程仓库，然后可以刷新 github 的网页看是否有变动了。

#### github 提供基于 https 端口的 ssh 连接方式

    https://docs.github.com/zh/authentication/troubleshooting-ssh/using-ssh-over-the-https-port

主要用于办公室内网封禁对外使用 22 端口，但是开放 443 端口的场合。

先试试能否在 443 端口连接

    $ ssh -T -p 443 git@ssh.github.com
    Hi m666m! You've successfully authenticated, but GitHub does not provide shell access.

配置你的项目地址在该端口使用 ssh 协议即可

    git clone ssh://git@ssh.github.com:443/YOUR-USERNAME/YOUR-REPOSITORY.git

还可以编辑 ~/.ssh/config 文件，并添加以下部分：

   Host github.com
       Hostname ssh.github.com
       Port 443
       User git

之后的项目地址可以简写

    git clone ssh://git@github.com/YOUR-USERNAME/YOUR-REPOSITORY.git

### 4、设置代理

    https://hugueliu.github.io/2019/12/25/config_git_proxy_with_v2ray_in_win10/

    https://ericclose.github.io/git-proxy-config.html

国内经常连不上 github，需要多次重试，不如用代理。

#### http 代理

注意：该方法只适用于 http 方式，即执行 `git clone https://github.com` 用的 https 下载的方式，不适用于 ssh 方式。

1、设置 scoks 代理

在“参数设置-Core:基础设置”中可以查看本地socks端口号，一般为1080。

在命令行中使用以下命令设置 socks 代理：

    git config --global http.proxy socks5://127.0.0.1:1080
    git config --global https.proxy socks5://127.0.0.1:1080

2、设置 http 代理

在命令行中使用以下命令设置 http 代理：

    git config --global http.proxy http://127.0.0.1:1081
    git config --global https.proxy https://127.0.0.1:1081

3、取消代理设置

    git config --global --unset http.proxy
    git config --global --unset https.proxy

针对特定域名仓库走代理的做法，此处以 GitHub 为例:

    当我们在 GitHub 仓库使用 HTTPS 传输协议克隆源码时，我们往往是这么做的的：

        git clone https://github.com/<user>/<repository>.git

    根据你的代理软件支持的代理协议选取其中一种即可：

        git config --global http.https://github.com.proxy http://127.0.0.1:7890

        git config --global http.https://github.com.proxy socks5://127.0.0.1:7891

#### ssh 代理

如果你的 git 仓库为了身份认证，使用 git 协议或 ssh 协议。因为 Git 依靠 ssh 程序处理连接，所以您必须在 ~/.ssh/config 配置文件中指定你的主机

    为其设置 ProxyJump 选项，通过跳板机建立连接，参见章节 [ssh 配置跳板 --- 使用 ProxyJump](ssh think)。

    或为其设置 ProxyCommand 选项，通过代理建立连接，参见章节 [通过 socks/http 代理连接 ssh](ssh think)。

#### GitHub 多帐号 SSH 密钥设置

    https://p3terx.com/archives/github-multiaccount-ssh-key-settings.html

生成第二个密钥

    $ ssh-keygen -t rsa -C "name@email.com" //填写你的邮箱
    Enter file in which to save the key (/Users/you/.ssh/id_rsa): /c/Users/P3TERX/.ssh/id_rsa_github2 // 这里不要 Enter ，手动填写保存路径

    <剩下两个直接回车>

完成之后，我们可以看到 ~/.ssh 目录下多了两个文件 ：

    id_rsa_github2

    id_rsa_github2.pub

配置 ~/.ssh/config 文件添加一个主机别名配置：

    Host github2
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_rsa_github2

添加完成后，测试一下：

    $ ssh -T github2

使用时，将 GitHub SSH 仓库地址中的 <git@github.com> 替换成新建的 Host 别名

    如原地址是：git@github.com:abc/xyz.git，替换后应该是：github2:abc/xyz.git

如果是新建的仓库，直接使用替换后的 URL 克隆即可：

    git clone github2:abc/xyz.git

如果已经使用原地址克隆过了，可以使用命令修改：

    git remote set-url origin github2:abc/xyz.git

如果之前设置过全局用户名和邮箱，那么你需要将新添加的账户管理的 repos­i­tory 下设置局部用户名和邮箱。

    git config user.name "yourname"
    git config user.email "youremail"

否则虽然能 push ，但 push 上去会显示你之前添加的全局用户的用户名，这可能会导致不必要的麻烦。

或者 un­set 全局设置，把每个 repos­i­tory 分别设置局部用户名和邮箱。

    git config --global --unset user.name
    git config --global --unset user.email

### 配置git的编辑器和比较工具

    https://git-scm.com/docs/git-config

git 默认使用 vim 作为编辑工具，diff 作为比较工具，但我们可以选择使用其它的工具。

    使用 vs code 作为你的代码编辑器的好处是合并工具等图形化更直观，解决起来更方便。

比较工具

    不使用 diff，使用 diff3

        git config --global merge.conflictstyle diff3

    diff3 的使用，详见章节 [使用 diff3 处理合并冲突]。

合并工具 mergetool

    配置 Beyond Compare 4 作为

        https://blog.csdn.net/albertsh/article/details/106294095
        https://blog.csdn.net/LeonSUST/article/details/103565031

    建议使用开源的 meld，基于 python，参见章节 [给资源管理器添加 meld 右键菜单](gnu_tools.md)。

配置 git 的默认编辑器为 vscode

    https://blog.csdn.net/ShuSheng0007/article/details/115449596

        git config --global core.editor "code --wait"

    如果想恢复使用 Vim，使用下面命令即可

        git config --global --unset core.editor

也可直接编辑配置文件

    git config --global --edit

    将下面的配置粘贴上去，保存，关闭即可

        [diff]
            tool = vscode-diff
        [difftool]
            prompt = false
        [difftool "vscode-diff"]
            cmd = code --wait --diff $LOCAL $REMOTE
        [merge]
            tool = vscode-merge
        [mergetool "vscode-merge"]
            cmd = code --wait $MERGED

git revert 在合并冲突时使用`core.editor`的设置，没有单独的设置选项。

## 日常使用

    https://git-scm.com/docs/giteveryday

### 日常工作：分支工作 --- 更新本地分支等

简单来说，如果是开发分支需要同步远程库内容，可以简单点操作，使用变基合并即可，整合到一个命令：

    # 更新本地分支，连带标签
    # -r是rebase，否则是merge，最好指定要fetch的remote和分支名。
    git pull --rebase --tags origin master

如果你在做两个功能分支的合并：合入其它分支功能之前从远程更新，或多人共享开发一个分支经常出现合并冲突，则不能直接 git pull，详见章节 [更新本地分支的操作步骤]。

如果你需要把功能分支合并主干分支，详见章节 [功能分支合并到主干分支的操作流程]。

建立仓库，详见章节 [git仓库]。

如果需要对分支进行各种操作，详见章节 [分支管理：针对已经提交的历史记录链条的折腾] 下面的各个章节，随用随查即可。

### 日常工作：编辑工作 --- 修改、添加、提交

文件修改，添加到暂存，然后提交

    要养成习惯：感觉修改的比较多了，内容固定了，就顺手 `git add .` ，先在暂存区固定这部分修改。

    放在暂存区方便比对，详见章节 [显示差异 diff]。

    如果要切换到其它分支工作，临时保留现场，详见章节 [使用储藏 stash]。

    如发现修改有误，可以撤销，详见章节 [如何回退]。

    完全没问题了，形成一个 commit 提交，这里只是提交到本地

        # 用 -u 只添加已跟踪的修改文件，用 . 表示当前所有修改的文件，包括新添加的文件
        git add .

        git commit -m '你的提交说明'

        上面2条可以合并称一条命令：git commit -am '你的提交说明'

    发现有遗漏，先改内容，再补到本次提交里（没推送远程才能这么做）

        git add .

        git commit --amend

    其它的各种操作，参见章节 [日常编辑常用] 下面的各个章节，随用随查即可。

精简本地新增的提交记录，如果太多太琐碎，不利于查看历史提交记录，详见章节 [分支变基rebase：交互式压缩提交点]。

确定一切没有问题了，把你的提交记录推送到远程，详见章节 [分支推送 push]

    # 先看看远程是不是又有新增提交了
    git fetch
    git status

    如果看到远程有新增提交，别急着推送了，先更新本地，见章节 [更新本地分支的操作步骤]

    # 远程跟本地是同步的，可以推送
    # git push

### git 使用的一些原则习惯

1、文件和目录的组织原则

    git 是以文本文件的文字差异为基准进行差异比对的，以下都据此理解

    git 不支持空目录，无法 add，目录下至少放个 readme.txt

    目录结构和文件名不要使用操作系统提供的 rm、mv 等命令进行操作，使用 git 自带命令 `git mv`，否则对应的提交记录全丢

    按功能点组织代码，拆分多个文件比一个文件多个章节更能避免合并冲突

    创建的文件名、分支名尽量别跟 git 常用的关键字重复，文件名和分支名也尽量别相同，否则运行普通的 git 命令会提示混淆，需要在命令的末尾加 '--'。

        文件不要叫 dev、hotfix

        分支名不要叫 feature、release、origin、branch 等

2、在本地库更改远程仓库已有的提交记录，就是你的不对

    日常使用，只需要关注自己本地的工作区，最多修改到你的提交记录（未推送远程）

    如果做变基操作，尽量只修改你的提交记录（未推送远程）

    合并分支，也不要改动其它分支的提交记录，如需修改，尽量文件操作，这样只是添加了一个提交记录

    万一真的需要修改远程仓库的提交记录，必须是在项目级别的统一修改，只有这种情况下，才可以使用 git push -f，参见章节 [遇到提示 push -f 的时候多想想]

如果推送或提交时 git 提示冲突，一般都是本地库跟远程库的提交记录 hash 值对不上导致的

    git 对每个操作都有唯一的 commit 记录，多人交替编辑相同的文件，本地和远程的分离，cherry-pick 做相同的操作但是会生成不同的 commit hash，这样潜在的分歧点较多，使用的时候会让人感觉文件内容没变，或者相同的变化，怎么 git 就不认。

注意跟合并冲突的区别，合并冲突是合理的，说明有多人同时修改了文件的同一行，git 需要人工区分保留哪个结果。

3、能用文件操作解决内容问题，就别用一系列的 git 操作来解决，哪个办法简洁用哪个

    你的项目关注的是文件内容，而不是源代码管理系统使用的提交点，不要拘泥于用提交点来区别文件内容的修改。

    优先关注文件内容的差异，而不是提交记录点的来回使用和更新修改。如果有内容需要修改，能直接改就直接改，不要拘泥于必须用 git 的操作方式才更专业。

如果使用者的注意力集中在用提交点解决合并冲突，很容易会把简单问题复杂化：更新提交点、转换提交点等等操作，改的多了一个不注意，你的本地库跟远程库的提交记录对不上了。回头再找也是麻烦事，git 提交记录不是基于文件内容比对的。

如果你想重新过一遍提交记录核查下，哪怕相同的修改，提交点只要被重新生成过了，hash 值都变化了跟引入的那个提交点的 hash 值是不一致的。所以核查到底做了哪些修改，只能依赖看提交时候的注释，再加上逐个 commit 点看差异对比了。。。

参见章节 [基于文件的撤销大法] 直接替换文件的方法更快捷，解决问题更清晰。

4、 git 的一个痛点是跟内容的关联性弱，它是基于文件内容差异的跟操作有关的 hash 值的区别方式

    取消过的补丁，被其它分支又合并进来（二者hash不同），不容易发现，埋雷。

        假如有个提交点是撤回某 hotfix 的，你合入的分叉是有这个 hotfix 的，两分支都被 rebase 精简过，在提交记录里没有任何提醒，或两分支都有大量的 hotfix 提交记录混杂。只要你做合并，这个 hotfix 就又给加进去了，你如何能发现这里搞错了？

    你删除了某行代码，推送远程，可能被其他人的推送又送回来，如果提交记录很多，不容易发现，这雷就埋下了。

也就是说，git 对文件内容的操作并不敏感，相同的改动，cherry-pick 或 rebase 后生成的 hash 是不同的。因为使用者只能看到文件内容有没有区别，而 git 值关注每次操作的 hash，理解起来很别扭。

在撤销和回退的场景下，只要合并其它分支，非常容易把撤销和回退的部分又合并回来，而 git 无法感知这种内容的变化，不会给出合并冲突的提示。在 git 下解决这种问题，只能都是通过代码核查、测试等管理手段才能发现。

解决参见章节 [竞品 -- 基于文件差异(patch)的源代码管理系统]。

## git仓库

远程服务器建立裸仓库，参见章节 [服务器建立git仓库](git_repo thinking)。

### 基本概念：工作区、暂存区和版本库

1、工作区（work space）：

就是你建立的源代码目录

    mkdir my_proj

你对文件的任何改动在此操作。

2、本地仓库或版本库（Repository）：

在工作区执行 git init 命令就会建立隐藏目录 .git，这就是 Git 的版本库。

    cd my_proj

    git init

建立了本地仓库之后，你就可以管理本目录的所有文件和目录了

    使用 `git add .` 添加到暂存区

    然后使用 `git commit` 提交到本地仓库

    可以使用 `git log` 查看你的提交记录

之后任何在工作区的修改，都会被 git 识别，需要重复上面的过程提交到本地仓库。

注：git 会默认创建一个分支名为 'master'，但是这名称居然废弃了，以后的 git 版本可能改用 'main'

    设置默认分支名

        git config --global init.defaultBranch <name>

    把刚创建的分支改名

        git branch -m <name>

3、暂存区（stage 或 index）：暂存区实质是 .git 目录下的 index 文件，所以暂存区也称为索引（index）。

记住 “索引(index)”、“暂存区(stage)” 和 -cached 是一回事：

    git 在提示信息的时候，对暂存区的称呼比较乱，估计是因为开源项目多人开发交替演进留下的毛病。

    当你使用 git add 命令来暂存文件时，Git 在后台将文件添加到其对象数据库（在 .git/objects 目录下），并更新一个名为 .git/index 的文件以引用新添加的文件。

    Git 中的这个“暂存区”事实上有 3 种不同的名称，但它们都指的是同一个东西（即 .git/index 文件）：

        git diff --cached
        git diff --staged
        .git/index 文件

有了本地仓库之后，在工作区对文件的修改，都需要先添加到暂存区，然后才能提交到本地仓库。

    cd my_proj
    touch abc.txt

    git add .

    新增的文件需要 git 进行管理，执行 `git add` 命令即可添加到暂存区

    被 git 管理的文件进行了修改，也是使用 `git add` 命令来添加到暂存区

善用暂存区，你的修改可以使用 `git diff` 查看跟之前提交的对比，检验是否正确修改了，而且便于修改回退。

如果使用 vscode，建议使用 “时间线” 功能，每次保存和git提交都有快照，点击即可查看跟当前工作区的差异，更方便。

git做操作之前或操作之后，查看当前的git状态

    git status

确认所有的修改都正确之后，提交到版本库

    git commit -m '初始化提交'

版本库推送到远程仓库见章节 [同步远程仓库 push、pull、clone]

### 同步远程仓库 push、pull、clone

    https://www.w3cschool.cn/git/git-uroc2pow.html

    https://docs.github.com/zh/get-started/getting-started-with-git/managing-remote-repositories

本地的远程仓库（remote）有个特殊的远程仓库对象 origin，如果本地仓库需要和服务器上的裸仓库建立联系，本地仓库首先要添加 origin 对象，然后设置本地分支和远程仓库上分支的关联，有了跟踪分支，才可以推送和拉取。

通常的 git clone 用法见章节 [本地空目录，远程裸仓库里有文件]。

#### git 使用的远程协议

git 支持多种协议，Git 协议下载速度最快，SSH 协议用于需要用户认证的场合。

Git 协议：实质就是 ssh 协议的变体，格式为 “用户名@地址:仓库名”

    # 对 “git://” 开头，表示用 git 协议
    git clone git://example.com/path/to/repo.git [默认当前目录]

    # Github 特殊：对 “git@github.com” 开头，默认用 git 协议，在冒号后是仓库集名(注册用户名)
    # 格式：git@地址:仓库名
    # git clone git@github.com:repositores/repo.git
    git clone git@github.com:m666m/okletsgo.git

    # 用 ssh 测试
    $ ssh -T git@github.com
    > Hi m666m! You've successfully authenticated...

SSH 协议：一般用于需要用户身份验证的 git 仓库。

    # 对 “用户名@地址” 开头，默认 ssh 22 端口
    git clone [user@]example.com/path/to/repo.git

    # 开头最好明确写 “ssh://” 以防混淆，一般服务器上会建立专用的 git 用户
    git clone ssh://git@<ip>:<port>/your_path/xxx.git

    # 非标准22端口要写明确写协议名，地址后面用冒号分隔端口名，第一个/后面是路径
    git clone ssh://[user@]example.com:port/path/to/repo.git

    # 对ipv6地址加[]即可
    git clone ssh://user@[20:40:d:9f::1]:22122/path/to/repo.git

    # Github 特殊：提供基于 https 端口 443 的 ssh 连接方式
    #   https://docs.github.com/zh/authentication/troubleshooting-ssh/using-ssh-over-the-https-port
    git clone ssh://git@ssh.github.com:443/YOUR-USERNAME/YOUR-REPOSITORY.git

Http、Https 协议，一般用于公众开放无需身份验证的项目

    # git clone http[s]://example.com/path/to/repo.git
    git clone http://git.oschina.net/yiibai/sample.git

File 协议

    git clone /opt/git/project.git

    git clone file:///opt/git/project.git

其它协议

    git clone ftp[s]://example.com/path/to/repo.git

    git clone rsync://example.com/path/to/repo.git

#### 查看远程配置

先确认下，已经有远程库对象 origin

    $ git remote show
    origin

没有的话需要重新建立，参见章节 [修改本地仓库的远程设置]。

显示该远程库对象的详细信息，git 会测试该地址连通性

    $ git remote show origin
    * remote origin
    Fetch URL: git@github.com:m666m/okLetsgo.git
    Push  URL: git@github.com:m666m/okLetsgo.git
    HEAD branch: master
    Remote branch:
        master tracked：有跟踪分支
    Local branch configured for 'git pull':  未关联pull就没有这两行
        master merges with remote master
    Local ref configured for 'git push':     未关联push就没有这两行
        master pushes to master (up to date)

查看远程仓库地址，这个地址格式可以给 git clone 直接使用

    $ git remote -v
    origin  git@github.com:m666m/okLetsgo.git (fetch)
    origin  git@github.com:m666m/okLetsgo.git (push)

查看全部分支及跟踪关系、最近提交及注释

    # 需要执行过 git pull
    $ git branch -avv
    * master                 3384fb2 [origin/master] tea2 再改2
    remotes/origin/def_xxx b414ac9 功能3
    remotes/origin/hotfix  7cabce4 res me
    remotes/origin/master  3384fb2 tea2 再改2

#### 本地仓库关联远程仓库（本地分支关联远程分支）

    如果只是建立本地仓库，只需要在一个目录下执行命令 `git init` 就可以以本地仓库的方式使用 git 了。

    在远程服务器建立裸仓库，参见章节 [服务器建立git仓库](git_repo thinking)。

如果本地仓库需要关联远程仓库，跟其它人共享开发，有两种方法：

法一：远程服务器上已有仓库，直接用 `git clone` 命令复制到本地即可。这样就在本地建立了 “本地仓库” 和 “本地的远程仓库”，关联关系也不需要配置，这样最省事。参见章节 [本地空目录，远程裸仓库里有文件]。

法二：手工把本地仓库建立的分支跟远程服务器上的仓库的分支关联起来。

1、如果本地还不是 git 仓库，先建立

    git init

2、如果本地还没有远程库对象 origin，先建立

    # git 协议
    git remote add origin git_user@180.169.33.106:repositores/repository.git

    # Github 的 git 协议
    git remote add origin git@github.com:m666m/okletsgo.git

    # ssh 协议
    git remote add origin ssh://user@11.22.33.44:2345/gitrepo/tea.git

3、如果未设置远程库分支跟本地分支的关联，执行 git pull 或 git push 都会提示

    $ git pull
    There is no tracking information for the current branch.
    Please specify which branch you want to merge with.
    See git-pull(1) for details.

        git pull <remote> <branch>

    If you wish to set tracking information for this branch you can do so with:

        git branch --set-upstream-to=origin/<branch> master

    $ git push
    fatal: The current branch master has no upstream branch.
    To push the current branch and set the remote as upstream, use

        git push --set-upstream origin master

    To have this happen automatically for branches without a tracking
    upstream, see 'push.autoSetupRemote' in 'git help config'.

初次拉取远程仓库后本地默认只有 master 分支，如需使用其它分支也会遇到这种情况，参见章节 [从远程库的某个分支建立一个本地分支]。

4、设置本地分支和远程库关联，先把 master 分支搞好。

    # 将本地的 master 分支推送到 origin 主机，同时指定 origin 为默认主机
    # -u 即 --set-upstream
    git push -u origin master
    ...
    To ssh://11.22.33.44：2345/gitrepo/tea.git
    * [new branch]      master -> master
    branch 'master' set up to track 'origin/master'.

该命令等效于执行下面的一系列操作：

    推送本地分支 master 到远程主机 origin 的 master 分支

        git push origin master

    跟踪远程分支，远程没有master就自动创建一个

        git branch --set-upstream-to=origin/master master

        作用：跟踪远程分支 origin/master 到本地分支 master，如果远程没有分支会报错，需要先创建远程分支

    设置 origin 为默认主机

如果远程仓库是空的，需要先推送个文件上去，参见章节 [本地空目录，远程刚建好空白裸仓库]。

3、默认操作的是 master 分支，设置好之后才可以拉取其它分支。

    git fetch

    git push

#### 修改本地仓库的远程设置

直接修改：

    git remote set-url origin xxx.git

适用场景：本地新建的分支，远程仓库没有该分支，无法推送本地的新分支的情况，参见章节 [本地非空目录，远程裸仓库无本地分支]。

删除重建：

github.com 获取仓库用 git clone 默认给的是 https 地址，但是在国内的网络下经常连接超时，改成 git 协议或 ssh 协议的地址格式相对好些。各种地址格式参见章节 [git 使用的远程协议]。

1、先删除远程仓库对象 origin

    git remote rm origin

2、重新添加远程仓库对象 origin

    git remote add origin ssh://user@11.22.33.44:2345/gitrepo/tea.git

3、建立 origin 和 master 的联系

    git push -u origin master

3、执行 git pull 和 git push 验证是否正常。

#### 从本地仓库推送多个远程仓库

有时候需要项目同时推送多个远程仓库，而且地址格式也不相同。

远程仓库地址格式

    ssh://git@11.22.33.44:2345/gitrepo/myproj.git

    git@github.com:m666m/okLetsgo.git

    https://github.com/m666m/myproj

##### 默认的远程库对象添加多个 push 远程地址

在一般使用中，保持默认的远程库对象 origin 的 fetch/push 地址，但添加多个 push 远程仓库地址(upstream)。

这样的好处是，默认的远程库对象 origin 照常 fetch、push，只是增加了多个 push 地址，可以实现代码的多处备份。

给 origin 增加多个 push 地址

    git remote set-url --push --add origin ssh://git@11.22.33.44:2345/gitrepo/project_name.git

添加后验证

    $ git remote show origin
    * remote origin
    Fetch URL: git@github.com:m666m/project_name.git  <-- 默认的 fetch 地址
    Push  URL: git@github.com:m666m/project_name.git  <-- 默认的 push 地址
    Push  URL: ssh://git@11.22.33.44:2345/gitrepo/project_name.git  <-- 多个 push 地址
    HEAD branch: main
    Remote branch:
        main tracked
    Local branch configured for 'git pull':
        main merges with remote main <-- 当前分支的 pull 不变
    Local ref configured for 'git push':
        main pushes to main (up to date) <-- 当前分支的 push 不变

    $ git remote -v
    origin  git@github.com:m666m//project_name.git (fetch)  <-- 默认的 fetch 地址
    origin  git@github.com:m666m//project_name.git (push)   <-- 默认的 push 地址
    origin  ssh://git@11.22.33.44:2345/gitrepo/project_name.git (push)  <-- 多个 push 地址

    本地项目中的 .git/config 对应内容也会变化。

日常使用中，在执行 `git fetch` 或 `git pull` 命令时，只从默认的 fetch 地址拉取代码，而在执行 `git push` 时会推送到多个 push 地址。

如果想删除多余的 push 地址

    git remote set-url --delete origin ssh://git@11.22.33.44:2345/gitrepo/project_name.git

##### 添加多个远程库对象

一般用于仓库备份、代码发布到专门的测试服务器等需要明确手工指定的场合

    https://www.runoob.com/git/git-gitee.html

除了 origin，再添加多个远程库对象

    git remote add server1 ssh://git@11.22.33.44:2345/gitrepo/project_name.git

    git remote add server2 ssh://git@11.22.33.44:2345/gitrepo/project_name.git

    git remote add server3 ssh://git@11.22.33.44:2345/gitrepo/project_name.git

在执行 `git push` 时，只会推送到默认的 origin 地址。

如果需要推送到其他的各个 server1，2，3 ，需要明确给出参数挨个执行 push 命令

    git push server1 master

    git push server1 developer

    ...

这样便于控制发布节奏，比如在某些时间节点才把开发分支推送到test_server，平时的默认推送都是推到 origin。

添加多个远程库对象后，还可以删除默认的 origin 对象，只使用自己添加的那些远程库对象

    git remote rm origin

#### 示例：本地空目录，远程裸仓库里有文件

git clone 命令正常拉取即可

    git clone ssh://git@11.22.33.44:2345/gitrepo/tea.git [新目录名字]

    # Ipv6 用标准的中括号方式：
    #
    $ git clone ssh://git@[2199:4c:c:8da::2]:2345/gitrepo/tea.git
    Cloning into tea...
    warning: You appear to have cloned an empty repository.

这样本地目录里就会多了个名为 tea 的目录，这个目录已经是 git 管理的仓库了。

git clone 命令会自动创建了 origin 远程仓库对象，配置服务器的信息，默认创建本地分支HEAD（master）并设置远程跟踪分支。

因为初次拉取后，本地默认只有 master 分支，如需使用其它分支，参见章节 [从远程库的某个分支建立一个本地分支]。

执行 `git clone` 之后的第一次 pull 和 push：先执行 `git pull` 和 `git push`，看是否报错。可执行章节 [查看远程配置]，如果报错没有关联跟踪分支，可参见章节 [本地仓库关联远程仓库] 的第 4 步。

#### 示例：本地空目录，远程刚建好空白裸仓库

刚建好的裸仓库无内容，直接用 clone 拉是可以的，但是后续做pull和push会报错。

解决办法是，先在本地目录 git init，设置远程推送地址，给远程仓库上传个文件，然后再拉取。

1、本地操作，新建文件夹，创建 git 仓库，并添加远程仓库对象。

    $ mkdir tea

    $ cd tea

    $ git init
    Initialized empty Git repository in C://tea/.git/

    $ git remote add origin ssh://git@11.22.33.44:2345/gitrepo/tea.git

2、本地操作，先提交个文件，否则直接 pull 会报错

    echo 'init my git repo, add a file' > readme.md
    git add readme.md
    git commit -m 'init.'

后续操作参见章节 [本地非空目录，远程服务器的裸仓库是空的] 的第 3、4、5 步。

#### 示例：本地非空目录，远程服务器的裸仓库是非空的

用于同一个的项目，只是提交记录步调不一致。比如下载了一份源代码，需要从远程仓库同步的场景。

1、在本地目录下初始化为 git 仓库

    git init

2、添加 origin 远程库对象

    # git 协议
    git remote add origin git_user@180.169.33.106:repositores/repository.git

    # Github 的 git 协议
    git remote add origin git@github.com:m666m/okletsgo.git

    # ssh 协议
    git remote add origin ssh://user@11.22.33.44:2345/gitrepo/tea.git

3、拉取远程代码以让git获取分支相关信息

    # 先获取主干分支，把 master 分支的 HEAD 配置上
    $ git pull origin master
    From ssh://11.22.33.44:2345/gitrepo/tea
    * branch            master     -> FETCH_HEAD

    # 再获取所有分支的信息
    $ git pull
    remote: Enumerating objects: 16, done.
    remote: Counting ... done.
    From ssh://11.22.33.44:2345/gitrepo/tea
    * [new branch]      def_xxx    -> origin/def_xxx
    * [new branch]      hotfix     -> origin/hotfix
    * [new branch]      t3_fea     -> origin/t3_fea
    * [new tag]         v1.2.3.4   -> v1.2.3.4

这时还未设置远程库分支跟本地分支的关联，执行 git pull 或 git push 都会提示报错。

4、设置分支关联设置本地分支和远程库关联。

    git push -u origin master

5、执行 git pull 和 git push 验证是否正常

#### 示例：本地非空目录，远程服务器的裸仓库是空的

比如本地仓库开发的项目，后来需要多人共享，则在服务器建立裸仓库，远程服务器的裸仓库是空的，需要先把本地推送上去。

1、本地先建立 git 仓库

    $ git init

    $ git add .

    $ git commit -m 'init 1st'
    [master (root-commit) 34827c0] init 1st

2、添加远程库对象 origin

    git remote add origin ssh://git@11.22.33.44:2345/gitrepo/okletgo.git

这时显示结果 HEAD 是 unknown

    $ git remote show origin
    * remote origin
    Fetch URL: ssh://git@11.22.33.44:2345/gitrepo/okletgo.git
    Push  URL: ssh://git@11.22.33.44:2345/gitrepo/okletgo.git
    HEAD branch: (unknown)

3、这是因为没有上游分支，需要建立关联关系

    git push -u origin master

4、验证，查看看远程的信息，提示 tracked

    $ git remote show origin
    * remote origin
    Fetch URL: ssh://git@11.22.33.44:2345/gitrepo/okletgo.git
    Push  URL: ssh://git@11.22.33.44:2345/gitrepo/okletgo.git
    HEAD branch: master
    Remote branch:
        master tracked <--------- 有跟踪分支了
    Local branch configured for 'git pull':
        master merges with remote master  <--------- 拉取有了
    Local ref configured for 'git push':
        master pushes to master (up to date)  <--------- 推送也有了

5、执行 git pull 和 git push 同步数据，应该不会有报错提示。

#### 示例：本地非空目录，远程裸仓库无本地分支

常见场景：本地新建的分支 t3_fea， 这时远程仓库没有该分支，无法直接推送。

前提

    本地仓库的 master 分支可以正常的执行 pull、push，否则先关联远程仓库，见章节 [本地仓库关联远程仓库]。

要推送到远程仓库，实现 push 和 pull，需要先设置关联。

    $ git push -u origin t3_fea
    Everything up-to-date
    branch 't3_fea' set up to track 'origin/t3_fea'.

设置后可以看到关联跟踪分支了

    $ git branch -avv
    master                 3384fb2 [origin/master] tea2 再改2
    * t3_fea               f6aeb75 [origin/t3_fea] t3_fea 分支自己添加  <-- 对应的远程分支
    remotes/origin/HEAD    -> origin/master
    remotes/origin/def_xxx b414ac9 功能3
    remotes/origin/hotfix  7cabce4 res me
    remotes/origin/master  3384fb2 tea2 再改2
    remotes/origin/t3_fea  f6aeb75 t3_fea 分支自己添加

    $ git remote show origin
    * remote origin
    Fetch URL: ssh://git@11.22.33.44:2345/gitrepo/tea.git
    Push  URL: ssh://git@11.22.33.44:2345/gitrepo/tea.git
    HEAD branch: master
    Remote branches:
        def_xxx tracked
        hotfix  tracked
        master  tracked
        t3_fea  tracked <---- 添加了跟踪分支
    Local branches configured for 'git pull':
        master merges with remote master
        t3_fea merges with remote t3_fea <---- 关联了 fetch 命令
    Local refs configured for 'git push':
        master pushes to master (up to date)
        t3_fea pushes to t3_fea (up to date) <---- 关联了 push 命令

其它机器需要重新拉取远程分支

    $ git fetch
    * [new branch]    t3_fea  -> origin/t3_fea  <--- 提示本地的远程库下载了新的分支

    $ git branch -avv
    * master                 3384fb2d33 [origin/master] tea2 再改2
    remotes/origin/def_xxx b414ac95d4 功能3
    remotes/origin/hotfix  7cabce404f res me
    remotes/origin/master  3384fb2d33 tea2 再改2
    remotes/origin/t3_fea  f6aeb75474 t3_fea 分支自己添加 <---本地的远程库的分支

这样就可以创建本地分支了，注意分支名称最好保持一致

    $ git switch -c t3_fea origin/t3_fea
    Switched to a new branch 't3_fea'
    branch 't3_fea' set up to track 'origin/t3_fea'.

尽量不要设置不同的分支名称：

如果你本地新建分支名称和远程服务器上的分支名称不一致，甚至不使用默认的 origin 对象

    git push origin local_branch:remote_branch

    git branch --set-upstream-to=origin/remote_branch local_branch

    git push origin HEAD:remote_branch

    git push -u origin/local_branch

那么之后的 `git push` 和 `git fentch` 操作都要加参数，比较麻烦，跟随 `git status` 的提示即可。

### 定制化拉取远程仓库

通常的 git clone 用法见章节 [本地空目录，远程裸仓库里有文件]。

#### 仅拉取指定远程分支

假设分支名称dev

    git clone -b dev

或用 fetch 只下载指定分支如 dev：

    $ git init

    $ git remote add origin git@github.com:m666m/okletsgo.git

    $ git remote set-branches origin dev

    $ git fetch --depth 1 origin dev

    # 如果 git branch -avv 看不到远程分支，使用 `git remote update` 更新下

    $ git checkout -b dev(本地分支名称) origin/dev(远程分支名称)

    $ git pull origin dev(远程分支名称)

##### 拉取指定分支的指定commit版本

git clone 默认是取回 master 分支，可以使用 -b 参数指定分支。

-b 参数不仅支持分支名，还支持 tag 名等。

    git clone  <remote-addr:repo.git> -b <branch-or-tag-or-commit>

需求是获取 commit id，没直接的办法，下面提供另一个步骤：

选择一个包含目标 commit id 的 branch 或 tag，并指定 depth=1 以获得比较少的额外文件传输。

    git clone --depth 1 <remote-addr:repo.git> -b < branch-or-tag >

clone 完成后，进入目录，执行

    git fetch --depth < a-numer >

不断增大步骤2的数字，直到找到你要的commit

#### 浅克隆(shallow clone) --- 大仓库非全量拉取

适用场景：你只是想 clone 最新版本来使用，而不是参与项目的开发

git cole 命令默认会把所有的提交记录都 clone 下来，对比较大且未清理的大仓库，这个过程耗时长而且占用空间大。

其实对于我们直接使用仓库的内容，而不是参与其开发工作的人来说，只根据最近的一次的提交记录把相关内容给 clone 下来就好了。

只拉取最近一次提交记录相关内容

    git clone --depth 1

如果想限制只下载指定分支，参见章节 [仅拉取指定远程分支]。

这样 clone 下来的仓库，如果你只是用来查看最新内容或者直接编译是没问题的。

但是，如果是要像正常仓库一样操作还是有些区别的

    使用了--depth 克隆的仓库就是一个浅克隆的仓库，并不完整，只包含远程仓库的 HEAD 分支。

    没有远程仓库的 tags。

    不 fetch 子仓库(submodules)。

    即使你再使用 git fetch，也不能把完整仓库 fetch 下来，从 config 文件可以看 config remote.origin.fetch

    $ git config remote.origin.fetch
    +refs/heads/main:refs/remotes/origin/main

使用时注意其缺失功能

    无法查看历史 commit、无法切换到历史 commit

    无法切换到其它分支

当你有一天需要完整的提交记录的时，可以弥补

    git pull --unshallow

当你需要切换到其它分支的时候

    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

    git pull

然后就可以正常使用了。

#### 部分克隆(Partial clone) --- 减少下载提交记录的部分对象

适用于大项目，浅克隆拉取都耗时很久，部分克隆更有效。

仓库中的提交记录由三者组合：commit对象、tree对象、blob对象。部分克隆通过只下载部分对象的方式，在首次克隆时减轻了需要传输的数据量，降低了克隆需要的时间。

1、blobless 模式

    # 我只看看代码，不下载 blob 对象
    git clone --filter=blob:none xxxx

这样的克隆不影响 git merge、git rebase、git log 等命令，我们可以正常使用。

2、treeless 模式

    # 我只看看代码，不下载 tree 对象
    git clone --filter=tree:0 xxxx

需要下载的对象更少，克隆时间会更短，磁盘占用空间也会更少。但是在后续的工作中，treeless 模式的克隆会更加频繁的触发数据的下载。treeless 克隆更加适用于自动构建的场景，快速的克隆仓库，构建，然后删除。

在后续使用中如果涉及到这些历史数据，就会触发对象的按需下载。

可手工查找缺失对象，通过管道传递给下面的git fetch进程，实现缺失对象的批量获取：

    git rev-list --objects --missing=print v1.0.0..v2.0.0 | grep "^?" |\
    git -c fetch.negotiationAlgorithm=noop \
        fetch origin \
        --no-tags \
        --no-write-fetch-head \
        --recurse-submodules=no \
        --filter=blob:none \
        --stdin

如果项目中二进制文件较多，建议配置 Git LFS。

#### 稀疏检出(sparsecheckout) --- 只拉取指定目录

git的指定目录拉取，对于灵活选取仓库资源非常有帮助

    https://zhuanlan.zhihu.com/p/602129987

    https://zhuanlan.zhihu.com/p/54581830

NOTE：只在单个项目的目录里设置稀疏检出，不要变更全局配置。

1）在本地创建目录，初始化仓库

    mkdir pg_examples

    cd pg_examples

    git init

完成初始化之后，添加远程仓库

    git remote add origin git@github.com:pyqtgraph/pyqtgraph.git

2）设置本项目使用稀疏检出功能

这里可以先查看一下本项目的git配置

    $ git config --local -l
    core.repositoryformatversion=0
    core.filemode=false
    core.bare=false
    core.logallrefupdates=true
    core.symlinks=false
    core.ignorecase=true
    remote.origin.url=git@github.com:pyqtgraph/pyqtgraph.git
    remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*

此时可以看到并没有关于 core.sparsecheckout 的配置

配置稀疏检出

    # 注意要用参数 --local 指定为仅此项目
    git config --local core.sparsecheckout true

3）拉取目录

配置稀疏检查的目录

    # 注意路径格式
    #   pyqtgraph/pyqtgraph.git examples/
    #   romkatv/zsh4humans.git sc/
    git sparse-checkout set 'examples/'

    # 实际修改的是文件 .git/info/sparse-checkout
    # 由于该文件的匹配规则比较怪异，git 展开后的结果不确定，
    # 务必 cat 该文件确认下
    cat .git/info/sparse-checkout

执行拉取操作，由于 pyqtgraph 的主分支是 master，因此命令如下

    git pull origin master

4）切换分支

以上只是拉取了仓库的一个分支，所以查看本地分支和远程分支也就只显示这个分支

    $ git branch -a
    * master
    remotes/origin/master

fetch 远程仓库，会拉取到其它分支的信息

    git fetch origin

    $ git branch -a
    * develop
    master
    remotes/origin/dependabot/pip/doc/pydata-sphinx-theme-0.12.0
    remotes/origin/dependabot/pip/doc/sphinx-6.1.3
    remotes/origin/develop
    remotes/origin/master

切换到其他分支，本地建立新分支，跟该远程分支关联，则稀疏检出的代码会切换到该分支

    git checkout -b develop origin/develop

总结：

把稀疏检出，理解为跟随分支切换后，git做的一个是否显示目录或文件的匹配。

对于目录中不是git管理的文件，在git切换分支和做稀疏检出时都不会去处理，相对的目录结构在切换分支后会保留。

验证：

对不同结构的目录，切换分支后，稀疏检出会跟随分支情况变化

    示例 git@github.com:pyqtgraph/pyqtgraph.git
        git sparse-checkout set 'examples/'

    $ git checkout develop
    $ tree /ghcode/pg_examples
    /ghcode/pg_examples
    └── examples
        ├── Arrow.py
        ├── BarGraphItem.py
        ├── beeswarm.py
        ├── CLIexample.py
       ...
        └── ViewLimits.py

    $ git checkout master
    $ tree /ghcode/pg_examples
    /ghcode/pg_examples
    └── pyqtgraph
        └── examples
            ├── Arrow.py
            ├── BarGraphItem.py
            ├── beeswarm.py
            ├── CLIexample.py
            ...
            └── ViewLimits.py

对同名目录，切换分支后，稀疏检出会跟随分支情况变化

    示例 git@github.com:romkatv/zsh4humans.git
        git sparse-checkout set 'sc/'

    $ git checkout v5
    $ tree /ghcode/zsh4_sc
    /ghcode/zsh4_sc
    └── sc
        ├── exec-zsh-i
        ├── install-tmux
        ├── setup
        └── ssh-bootstrap

    $ git checkout v4
    $ tree /ghcode/zsh4_sc
    /ghcode/zsh4_sc
    └── sc
        ├── exec-zsh-i
        ├── setup
        └── ssh-bootstrap

##### 本地已clone了仓库

    https://www.jianshu.com/p/680f2c6c84de

对于目录中多余的文件，在稀疏检查时不会去处理，类似分支切换时对非 git 管理文件的处理方式。

1、打开 sparse checkout 功能

进入版本库的目录，执行以下命令

    git config --local core.sparsecheckout true

使用文本编辑打开 .git/info/sparse-checkout 文件 (没有这个文件可以手动创建一个)
添加如下列表

    /*
    !/add_on/native_addon/kylinv4_ft1500a/*
    !/add_on/native_addon/neokylin_lib/*
    !/add_on/native_addon/ubuntu_lib/*
    !/add_on/native_addon/uos_arm_lib/*
    !*.so

3、 重新checkout

    $ git checkout [branch]

    or

    $ git read-tree -mu HEAD

sparse-checkout 文件设置

    https://www.git-scm.com/docs/git-sparse-checkout/2.39.0#_internalsnon_cone_problems

    子目录的匹配

        目录名称前带斜杠，如 /docs/，将只匹配项目根目录下的 docs目录

        目录名称前不带斜杠，如 docs/，其他目录下如果也有这个名称的目录，如 test/docs/ 也能被匹配

        多级目录，如 docs/05/，则不管前面是否带有斜杠，都只匹配项目根目录下的目录，如 test/docs/05/ 不能被匹配

    通配符 ““ (星号)匹配

        docs/
        index.
        *.so

    排除项 “!” (感叹号)匹配

        /*
        !unwanted

    关闭sparsecheckout

        关闭sparsecheckout功能，全取整个项目库，可以写一个”“号，但如果有排除项，必须写”/“，同时排除项要写在通配符后面。

    比如，命令 `git sparse-checkout set A/B/C` 会被展开成

        /*
        !/*/
        /A/
        !/A/*/
        /A/B/
        !/A/B/*/
        /A/B/C/

#### 组合使用：部分克隆+稀疏检出

只对大项目的某个部分感兴趣时的代码检出，大项目用这个方法最精简

    https://help.aliyun.com/document_detail/309002.html

开源的大项目在公司内网服务器做镜像参见章节 [迁移仓库](git_repo think)。

1、先部分克隆，并配置克隆完成后不执行自动检出

    git clone --filter=blob:none --no-checkout

2、然后对该项目配置稀疏检出

    git config core.sparsecheckout true

3、指定稀疏检出的目录为 backend

    echo "backend/*" > .git/info/sparse-checkout

4、然后再拉取文件

    git checkout

测试：150 GB 的大项目，此存储库中有许多（~2k）子模块

    # https://github.com/romkatv/powerlevel10k/issues/1608
    git clone --recurse-submodules https://android.googlesource.com/platform/superproject/

### git submodule 包含子项目

    https://zhuanlan.zhihu.com/p/87053283

    https://zhuanlan.zhihu.com/p/404615843

    git的submodule体验太痛苦 https://www.zhihu.com/question/267292008/answer/2389876457

当项目依赖并跟踪一个开源的第三方库，或主项目对子模块有依赖关系，却又并不关心子模块的内部开发流程细节。

这种情况下，通常不会把所有源码都放在同一个 Git 仓库中。

有一种比较简单的方式，是在当前工作目录下，将子模块文件夹加入到 .gitignore 文件内容中，这样主项目就能够无视子项目的存在。这样做有一个弊端就是，使用主项目的人需要有一个先验知识：需要在当前目录下放置一份某版本的子模块代码。

还有另外一种方式可供借鉴，可以使用 Git 的 submodule 功能。

增加子项目，或称子模块

    # 进入主项目的目录
    git submodule add https://your_sub_project

    # 提交一次，表示引入了某个子模块。提交后，在主项目仓库中，会显示出子模块文件夹，并带上其所在仓库的版本号。
    git commit -m "add submodule xxx"
    git push

对于后续使用者而言，对于主项目使用普通的 clone 操作并不会拉取到子模块中的实际代码，只有一个空目录，除非显式指定拉取子模块

    # git clone --recursive
    git clone --recurse-submodules https://github.com/username/project-main.git

更新子模块需要手动，在当前主项目中执行

    cd your_main_project
    git pull

    git submodule sync --recursive

    # git submodule init
    # git submodule update
    git submodule update --init --recursive

子模块更新后，此时对主项目来说子模块的状态是有修改的，注意切换回主项目的目录，执行 git add/commit/push 提交这个修改即可。

对于子模块而言，并不需要知道引用自己的主项目的存在，子模块本身就是一个完整的 Git 仓库，按照正常的 Git 代码管理规范操作即可。

通常的操作都需要进入子模块文件夹，按照子模块内部的版本控制体系更新、提交代码。

比如更换远程仓库也只需进入子模块目录后执行命令 `git remote set-url origin xx.git` 即可。

对子模块远程仓库有更新的情况，主项目下运行 `git status` 不会有提示，需要进入子模块的目录后手动执行更新 `git pull`，当主项目的子模块特别多时，可以使用批量命令：`git submodule foreach 'git pull'`。然后回到主项目的目录，执行 git add/commit/push 提交这个修改。

删除子模块

    git submodule deinit your_sub_project

    git rm your_sub_project

    git commit -m "delete submodule your_sub_project"

    git push

### git worktree 多分支目录共用一个仓库

    https://minsonlee.github.io/2020/05/git-worktree

git checkout 命令是在同一个文件夹中切换不同分支，当一个分支正在开发，有另一个分支需要紧急处理bug，有两种解决方案

    `git stash` 当前内容，然后切换分支修改bug，提交后再切换回来， `git stash pop` 继续原开发。

    新建个目录拉取仓库，在那个目录里切换分支修改bug，极端情况下每个分支一个目录，都克隆同一个仓库，但是这样占用容量太大了。

一个 git 仓库可以支持多个工作树，允许你在同一时间检出多个分支。通过 git worktree add 将一个新的工作目录和一个仓库进行关联。 这个新的工作目录被称为 “linked working tree（链接工作树）”。不同于通过 git init 或 git clone 产生的主工作树，这个目录只保存了静态内容，容量相对小很多，在这个目录下切换分支操作即可。

一个仓库只有一个主工作树（裸仓库是没有工作树的），可以有零个或多个链接工作树. 当你在链接工作树已经完成了工作，使用 git worktree remove 就可以移除它了。

    # 查看当前仓库所有的 "linked working tree"
    $ git worktree list
    /ghcode/pycode/tea  7cabce4 [master]

创建 worktree

    # 基于已存在分支创建 `worktree`
    git worktree add <new-workpath> <existing-branch/commit-id/remote-branch-name>

    # 基于当前 commit 新建一个分支并创建 `worktree`
    git worktree <new-wokpath> -b <new-branch>

    # 基于指定 commit 创建一个 worktree
    git worktree <new-workpath> --detach <commit-hash>

移动 worktree

    git worktree move <worktree> <new-path>/<new-worktree>

清理 worktree

    # 删除存在的 worktree
    git worktree remove <worktree>

    # 清理失去关联的 worktree
    git worktree prune

示例：

保留当前分支代码现状，基于 master 分支创建一个 hotfix 分支修复问题

    # 基于 master 分支的 HEAD，在目录同级创建一个 hotfix 的工作树，并检出一个本地分支 hotfix 以便后期合入
    # git worktree add ../hotfix --detach master 如果分离式检出，切换到目录后手工创建分支 `git checkout -b hotfix`
    # git worktree add -b hotfix ../hotfix master
    git worktree add ../hotfix  # 创建目录并自动检出一个同名的本地分支

    # 进入 hotfix 工作树
    cd ../hotfix

    # 在该工作树下处理bug
    ...

    # 切换回主分支合并该分支的内容
    cd -
    git rebase hotfix

### 合并两个不相干的本地仓库

    https://www.morfans.cn/archives/3373

不使用拷贝文件的方式，目的是能够保留提交记录，让一个仓库合并另一个仓库的文件和提交记录。

方法是添加一个远程对象，地址是另一个仓库，然后把它拉取下来，以此创建一个分支，然后合并到主干，使用参数允许不相关历史。

假设仓库 A 要合并仓库 B，仓库 B 使用本地地 “..\repo_b”，如果你的是远程，把这里改成网址即可

    cd repo_a

    git remote -v

添加远程对象，地址是仓库 B

    git remote add repob ..\repo_b\

拉取远程 repob 地址的内容

    git fetch repob

分支操作

    $ git branch -a
    *master
    remotes/origin/master

创建新分支 tobe

    git checkout -b tobe repob/master

合并到主干分支 master

    git checkout master

    git merge --allow-unrelated-histories tobe

这样仓库 A 的主干分支 master 里就有了仓库 B 的内容，并且提交记录也合并进来了。

## -------- 分支管理：针对已经提交的历史记录链条的折腾 --------

## 分支切换 switch

先下载完整的git代码

    git clone xxxx

查看分支情况

    # 为防止看不到全部分支，先更新下先使用
    # git remote update
    git fetch --all

    $ git branch -avv
    hotfix                 7cabce4 [origin/hotfix] res me
    * master                 494c93b [origin/master] fea 添加第三次
    remotes/origin/HEAD    -> origin/master
    remotes/origin/def_xxx b414ac9 功能3
    remotes/origin/hotfix  7cabce4 res me
    remotes/origin/master  494c93b fea 添加第三次

    默认只显示本地分支、工作树
    -a 显示所有（含远程分支、工作树）。带 remotes 开头的是远程分支。
    -v 参数标注了分支当前最新提交记录的注释信息；
    从 * 号的位置可以看到，我们现在在 master 本地分支下。

git 用 switch 命令替代了 checkout 命令中关于分支切换的功能

    https://git-scm.com/docs/git-switch

分支切换的目标是分支名

    # 切换到 master 分支
    # git checkout master
    git switch master

### 直接切换到指定的提交记录

这时进入不关联分支的 detached HEAD 分离状态。如果暂存区或工作区有内容，会报错无法切换，但是我遇到过丢弃暂存区直接切换的情况，没搞明白为啥。

直接切换到某个提交记录后，如果对文件内容做了修改，需要你建立新的分支或切换回现有分支，才能提交你当前的工作，否则这种分离 detached HEAD 情况下做的修改 git 不知道往何处保存。

注： “有内容”，指文件中相同位置的内容有变更，如果不是相同位置，无影响。

分支切换的目标是提交点commit id（hash或tag）

    # 从当前分支直接切换到指定的 commit 点，使用其 hash 值即可
    # git checkout A9380e9
    git switch --detach A9380e9

    # 切换到指定标签
    # git checkout v1.23
    git switch --detach v1.23

### 在指定提交点建立分支

目前推荐的用法：在某个提交点就地建立分支

    # 为防止看不到全部分支，先更新下
    # git remote update
    git fetch --all

    git switch -c new_branch <commit>

废弃的过时用法：

    # 切换到某个提交点后就地建立分支
    git checkout A9380e9
    git branch new_branch
    # 上面的这个命令只是创建，如果要使用需要手工切换
    git checkout new_branch

    如果在参数里加上提交点的 hash，可以节省步骤

        git checkout -b new_branch <commit>

        或

        git branch new_branch A9380e9

NOTE: 本地新建的分支没有对应到远程仓库，无法推送到远程，如何建立关联，参见章节 [本地非空目录，远程裸仓库无本地分支]。

### 从远程库的某个分支建立一个本地分支

前提

    master 分支可以正常从远程库 pull 和 push

因为 git clone 默认建立的本地库只有 master 这一个分支，想切换到其它分支，需要先在本地的远程库建立该分支，有点别扭是吧，这事儿貌似应该对用户透明啊

    # 先看看本地和远程都有什么分支
    $ git branch -avv

本地和远程分支的名称做好默认保持一致，否则以后的 git push 命令要加参数才能用，太麻烦了

    # 废弃： git checkout -b hotfix origin/hotfix

    # 先建立远程仓库分支的本地分支
    $ git switch -c hotfix origin/hotfix
    Switched to a new branch 'hotfix'
    branch 'hotfix' set up to track 'origin/hotfix'.

    # 或 只建立不切换过去
    # git branch newBrach a9c146a09505837ec03b

如果 master 分支都跟远程仓库关联好了，那么这个分支不需要再手工建立与远程仓库的关联。

如果只执行创建本地分支，则需要手工关联本地分支和远程分支，参见章节 [本地仓库关联远程仓库（本地分支关联远程分支）]

    $ git switch -c hotfix

    $ git branch --set-upstream-to=origin/hotfix hotfix

验证：

    切换到新建的本地分支，执行 git pull、git push 命令看是否正常

## 删除分支，远程/本地

0、先看看有多少本地和远程分支

    # 看不到完整输出时，则使用 git remote update 或 git fetch --all 先更新下
    $ git branch -avv

1、切换到其他分支再进行操作

    $ git switch master

2、删除远程服务器仓库中的远程分支及本地的跟踪分支

    $ git push origin --delete fea_xxx
    To ssh://11.22.33.44:2345/gitrepo/tea.git
    - [deleted]               fea_xxx

该命令也会删除本地远程库对象 origin 中的跟踪分支 origin/fea_xxx。

    如果省略本地分支名，则表示只删除指定的远程分支，因为这等同于推送一个空的本地分支到远程分支

        $ git push origin :refs/fea_xxx

        甚至可以用本地分支 fea_-2 覆盖远程分支 fea_-1

            $ git push -f origin fea_-2:refs/fea_-1

如果只删除本地的跟踪分支

    $ git branch --delete --remotes <remote>/<branch>

    则还需要删除本地远程的跟踪分支

        $ git remote prune origin

执行 git status、git remote show origin 看提示操作即可。

3、从本地库删除该分支

    $ git branch -d fea_xxx
    Deleted branch fea_xxx (was af83d).

4、你删除远程后，其它人计算机的本地库也记录着这个远程分支

其他人在自己计算机上的操作

    # 先更新
    $ git fetch

    $ git remote show origin
    Remote branches:
        dev                            tracked
        master                         tracked
        refs/remotes/origin/fea_xxx stale (use 'git remote prune' to remove)  <--- 本地的远程分支在远程仓库上已经删除了

可以看到提示：stale (use ‘git remote prune’ to remove)

这代表远程服务器上已经删除当前这条分支 但是本地代码库和本地远程库并未同步这个状态。

需要清理本地远程库对象 origin 中这些无效的跟踪分支

    $ git remote prune origin
    Pruning origin
    URL: ssh://
    * [pruned] origin/fea_xxx

如果本地也建立了 fea_xx 分支，可以删除掉

    $ git branch -d fea_xxx
    Deleted branch fea_xxx (was 25e8f5a).

5、确认是否干净了

    git fetch

    git remote show origin

    git branch -avv

## 分支推送 push

前提

    本地分支推送到远程，需要有远程库 origin 对象及跟踪分支，参见章节 [同步远程仓库 push、pull、clone]。

推送分支

    $ git push origin refs/heads/branch:refs/heads/branch

        # 一般用简写
        $ git push origin local_branch:remote_branch

        # 如果当前的本地分支和远程分支同名，分支名参数可以省略写
        $ git push origin branch

        # 如果远程库对象是默认的 origin，该参数也可省略
        $ git push

如果是本地建立的功能分支，第一次推送到远程时注意带参数 -u 设置远程分支关联

    $ git push --set-upstream origin feature_name

详见章节 [本地仓库关联远程仓库]。

### 重要：推送远程前的检查

NOTE:如果你修改了远程仓库的提交记录，git 会提示你使用 `git push -f` 来强行推送，不要这么做！参见章节 [遇到提示 push -f 的时候多想想]。

牢记：**远程仓库已有的提交记录，只做追加，不要修改、不要回退**

    压缩式提交 `git commit --amend`、回退 reset、变基 rebase 等操作，都应该只限于操作本地未推送远程的提交记录。

    本分支分叉合并过来的远程其它分支的提交记录也不要做修改，任何内容上的修改，体现到提交记录上的都应该是追加，千万不要在历史提交记录上开倒车。

如果必须修改，则不要变动已经在远程存在的提交记录，只在文件内容上做比对变更，新增提交点把你的修改提交上去，以避免 push -f 强行更改远程库的提交记录。

#### 遇到提示 push -f 的时候多想想

    https://www.jianshu.com/p/b03bb5f75250

TODO: 坑：在推送时，git 发现本地提交跟远程库的提交记录 hash 值有冲突就会提醒你执行 git push -f。

尽量避免 git push -f 的操作，或者说 git push -f 是一个需要谨慎的操作，它是将本地历史覆盖到远端仓库的行为。

    如果别人拉取并基于此开发，你再做 rebase 并再次提交，之前别人拉取的内容变了，双方都得再做拉取整合。如果时间线已经是很长的了，会导致很大的混乱。

    整理本地的代码，尽量做文件操作，而不要用 git 对别人的提交记录（来自拉取远程库）做变基合并 commit 或回退。不然，如果推送到服务器上，之前别人拉取的内容变了，需要再次合并你改的那块内容，又是在制造混乱。

    建议本地新建分支保留这个差异，从分叉点开始分析是哪里跟远程库对不上了，如果需要回退，直接使用 [基于文件的撤销大法]。

比如，开发者 b 在开发者 a 进行 git push -f 前已经进行 git pull 操作，b 新增了 commit2 在本地是可以查找到。当 a 执行了 git push -f 后，b 执行了 git pull --rebase，则 b 的 commit 就会丢失。

    恢复被强制推送 push 失踪的代码 <https://cloud.tencent.com/developer/article/1546926>

    在常规的开发流程中，难免有时因为各种原因（例如需要使用git rebase）会需要使用到git push -f，也就是强制推送，该命令会覆盖远程分支。

    但如果操作不当，会容易把小伙伴的之前提交的commit给覆盖掉，不要慌，这并不代表你小伙伴的commit已经永远找不回来了，大部分情况下，他们还是可以被找回的。

    git reflog 可以查看所有分支的所有操作记录（包括（包括commit和reset的操作），包括已经被删除的commit记录，git log则不能查看已经删除了的commit记录

    虽然有reflog这跟救命稻草，但由于Git会定时gc（回收），清理掉reflog，所以被人覆盖后不要等待太久才进行恢复操作，不然可能就真的找不回了。

当然也并非禁止，例外情况

    有时，如果代码组内 review 后，确认代码正确无误，保证大家未 pull 的情况下，强制推送后，可以保持目录树清洁。

    只有自己一个人使用的分支，可以自由 git push -f

比如：你的修改已经提交到远程库了，后来发现有错，需要回退到之前的某个提交点。

如果使用 git push -f 强行切换到某个提交点，总是会引起很大的混乱：其他人也在同步你的变化，即使你回退了并强行 push -f，而其他人不知道的话，只要他做push，你的回退又被他本地保存的你提交的变化覆盖回去了。。。

git push -f 制造混乱的过程

    以 master 分支为例，A2 提交不用了，需要回退到 A1

        A1 -- A2

    1.查看版本号：

        git log --graph --oneline
        或 git reflog 查看更多的操作

    2.将版本回退到指定的提交点：

        git reset --hard A1

    3.更新远程仓库端的版本也进行同步的回退

        git push -f

    远程库提交记录的历史也会跟着丢，其他人的修改都只能依赖本地的提交记录了

    4. 其它人已经同步 A2 到自己的本地了，他自己的工作是提交点 A3，然后也 push 到远程库，你撤销 A2 的企图没有实现

        A1 -- A2 -- A3

如果你真的重写了分支的 Git 提交历史，推送远程会失败，只能强制更新远程分支：`git push -f`，所有之前拉取过相关代码的人员，你需要挨个通知重新拉取合并。。。

更糟糕的是，如果你发现自己重写了git提交历史并推送到了远程，回退解决并再次推送远程，你以为成功解决了失误：

    如果有别人已经从远程仓库拉取了最新变化，分布式存储了你的修改，你怎么回退都没用了，他的本地有你之前推送的代码，只要他执行push，你的变更就改回去了。这种混乱，如果项目组人数多，那是鸡飞狗跳。

    解决方案很复杂，见章节 [远程仓库上有B先生新增提交了，然后你却回退了远程仓库到A1]。

如果幸运，没有人新增提交，把自己的代码手工修改为最终正确的结果，作为一个新的commit再次push上去，你就装作啥也没发生。如果有人已经在你的提交基础上新增了提交，工作已经展开了，挨个给受你影响的人打电话道歉，然后通知大家再次根据你的最新代码合并分支，如果大家因此集体加班，你请大家喝咖啡，如果项目因此延期，及时通知项目经理报备。

如何尽量缩小这种情况的影响范围，见章节 [使用合并专用分支进行拉直] 。

##### 远程仓库上有B先生新增提交了，然后你却回退了远程仓库到A1

    https://www.cnblogs.com/Super-scarlett/p/8183348.html

这种情况，操作就比较繁琐了

    远程仓库 A1 --- A2 强行回退到 A1

先通知所有人都做回退，A2 后没有提交的本地 master 分支就回到 A1 了。

    git reset --hard origin/master

但是 B 先生已经提交了 B1-B2

    他的本地 master  分支是  A1 - A2 - B1 - B2

    他的本地 feature 分支是  A1 - A2 - B1 - B2 - B3

只要他再次提交，A2还是会出现在远程仓库，你的回退对分布式来说无用。

所以需要B先生找出新增的 B1，B2，cherry-pick 到 master 分支

    # 切到自己的开发分支，记录下需要新增到主干的commit点，B1 B2
    git checkout b_branch
    git log  --graph --oneline
    或 git reflog 查看更多的操作

    # 备份开发分支 内容是 A1 - A2 - B1 - B2 - B3
    git checkout -b b_backup

    # 开发分支回滚到A1
    git reset --hard A1

    # cherry-pick到 开发分支，内容是 A1 - B1 - B2
    git cherry-pick B1 B2

    # 开发分支做冲突合并，测试正常，不受A2消失的影响等一堆工作，然后继续下面的

    # 更新master分支，做回滚到 A1，然后合并开发分支
    git checkout master
    git reset --hard origin/master
    git merge b_branch

    # 这时B先生的 master 分支，可以推送到远程仓库了，内容是A1 – B1 - B2
    git push

    # 最后，开发分支把自己最新的B3之类部分从备份分支cherry-pick过来
    git checkout b_branch
    git cherry-pick B3

    # 最终的开发分支内容是 A1 - B1 - B2 - B3

## ---- 更新本地分支的操作步骤----

本地分支的更新，就是先 fetch --- 从服务器上的远程裸仓库拉取到本地的远程库，然后再从本地的远程库合并到本地库。这个合并与合并本地的两个分支没什么区别。

简单应用场景下只需要一条命令即可

    本地开发分支从远程更新，一般要保持拉直状态不能添加分叉，则执行 `git pull --rebase`，强行给本地变基以拉直的方式合并远程代码到本地。如果没有不许分叉的限制，则执行 `git pull`，让 merge 自动选择即可。

但是，在以下场景就需要酌情选择从远程更新本地代码时的合并策略了：

    你在做两个分支的合并，合入其它分支功能之前从远程更新

    多人共享开发一个分支经常出现合并冲突

    本地主干分支从远程更新，一般做分叉合并，原因见章节 [功能分支合并到主干分支的操作流程]。

这样就不能直接做 `git pull` 或 `git pull --rebase`，把拉取和合并分开做。先把远程拉取 `git fetch` 下来先看看内容，然后才能明确选择做何种合并。

合并策略的讨论详见章节 [分支合并：分叉还是拉直]。

操作过程如下：

1、拉取远程，对比本地库和本地的远程库，先看看是不是远程有别人提交了，防止互相 merge 新增 commit。

    # git fetch origin master
    # 下载当前分支可以简写
    git fetch

章节 [分支更新 fetch/pull]。

2、分支合并：

先决定合并策略

    # 是否有合并冲突，是否可以做快进合并
    # 根据提示才能选择接下来如何做
    git status

        # 详细查看本地代码跟远程仓库代码（已下载到本地）的差异

        # 如果有分叉的提示，对比 fetch 下来的本地远程库跟本地库的提交记录，看看对方新增了什么
        git log ..origin/master --graph --oneline

        # 如果有合并冲突的提示，查看 fetch 下来的本地远程库跟本地库的文件内容的具体差异
        git diff ..origin/master

    如果有本地未提交的，先 git stash 暂存才能继续下面的代码合并

这里的合并做的是当前分支的本地库和本地的远程库进行合并，酌情选择自己的合并策略，用分叉还是拉直，参见章节 [分支合并：分叉还是拉直]。

大多数使用场景中，本地提交记录的 hash 值都是无所谓变化的，所以直接用变基 `git rebase` 合并远程库内容，这样可以保证把这些提交推送到远程仓库也能保持拉直的效果，参见章节 [分支变基rebase：交互式压缩提交点]。

做如下之一即可

    git merge（先尝试快进合并失败则分叉合并） 或 git merge -noff（强行分叉合并） 或 git rebase（强行拉直合并）

    或 git pull（fetch + merge） 或 git pull --rebase（fetch + rebase）

    或 git cherry-pick origin/master 单独选取本地远程库的提交记录

merge/rebase 的原理参见章节 [分支合并的策略选择]。

查看合并后的提示

    git status

3、如果合并过程中提示有合并冲突需要处理，操作参见章节 [解决合并冲突conflicts] 的示例。

原因解释：

    直接执行 `git pull` 或 `git pull --rebase` 的话，你可能无法确定使用哪种合并策略更合适

    如果出现合并冲突的提示，git 会进入 merge conflict 或 rebase conflict 过程，冲突文件都给你准备好了。你可以用 git merge --abort 或 git rebase --abort 终止这个过程，回到执行 git pull 之前的状态。

    如果在做 push 时发现提示合并冲突了，git 只是提示下，没有进入 merge 或 rebase 的过程中，你可以选择合并策略，具体操作参见章节 [解决合并冲突conflicts]

        $ git push
        To git://
        ! [rejected]        master -> master (fetch first)
        error: failed to push some refs to 'git://'
        hint: Updates were rejected because the remote contains work that you do
        hint: not have locally. This is usually caused by another repository pushing
        hint: to the same ref. You may want to first integrate the remote changes
        hint: (e.g., 'git pull ...') before pushing again.
        hint: See the 'Note about fast-forwards' in 'git push --help' for details.

        可以先更新下本地的远程库，然后对比它跟本地库提交记录的差异

            git fetch

            git log ..origin/master --graph --oneline

本地分支更新合并没有问题后，可以选择推送到远程，无需多言。

## 分支更新 fetch/pull

前提

    先 git clone 过一次或建立了与远程仓库的的关联，不然 git 不知道本地代码如何对应远程分支。

### 你的代码在本地有两份--本地仓库和本地的远程仓库

我们本地的 .git 文件夹里存储的本地分支的 commit ID 和跟踪的远程分支 orign/master 的 commit ID（可以有多个远程仓库）。

那什么是跟踪的远程分支呢，打开 .git 文件夹可以看到如下文件：

    .git/refs/head/[本地分支] 又称版本库

    .git/refs/remotes/[正在跟踪的分支]

其中 head 就是本地分支，remotes 是跟踪的远程分支，这个类型的分支在某种类型上是十分相似的，他们都是表示提交的 SHA1 校验和（就是 commit ID）。

本地分支在执行 git push 后会改变本地的远程跟踪分支。

我们无法直接对远程跟踪分支操作，除了 push 操作，更新远端跟踪分支只能用 fetch

    git fetch

取回更新后，会返回一个 FETCH_HEAD ，指的是某个 branch 在服务器上的最新状态，我们可以在本地通过它查看刚取回的更新信息：

    git log -p FETCH_HEAD

    可以看到返回的信息包括更新的文件名，更新的作者和时间，以及更新的代码（x行红色[删除]和绿色[新增]部分）。

    我们可以通过这些信息来判断是否产生冲突，以确定是否将更新合并到当前分支。

注意：

    执行了 `gi fetch` 之后，我们本地相当于存储了代码的两个版本，然后需要合并这两个不同的版本。

    merge 做的就是把本地的远程库 “origin/<分支名>” 跟本地库 “<分支名>” 进行分支合并。如果不用 merge，用 rebase 也是可以的。

        git merge FETCH_HEAD

        git merge origin/master

        # 或者，不使用 merge，用 rebase，二者的区别见章节 [分支合并的策略选择]
        $ git rebase origin/master

    也可以在本地远程库的基础上，创建一个新的本地分支并切换过去

            git switch -c newBrach origin/master

### fetch 只更新本地的远程仓库

git fetch 实际上将本地仓库中的远程分支更新成了远程仓库相应分支最新的状态，并不会改变你本地仓库的状态。

它既不会更新你的本地分支，也不会修改你工作区上的文件。

所以 git fetch 是十分安全的，你不用担心这个命令破坏你的工作区或暂存区，它下载的远程分支到本地的远程仓库分支，但是并不做任何的合并工作，然后可以执行以下命令合并到本地仓库

    git fetch <远程主机名> <分支名> # 注意之间有空格

    可简写，默认拉取所有分支，如果有很多分支，就比较慢了
    git fetch

    拉取指定分支的更新
    git fetch origin master

### pull 还做了 merge 合并操作

    大多数情况下，我们日常使用只需要执行 `git pull` 就够了，实际执行的是 ` git fetch && git merge master origin/master`

将远程主机的某个分支的更新取回，并与本地指定的分支合并：

    # 远程拉取下列同步到本地一般显式的写明用拉直
    git pull <远程主机名> <远程分支名>:<本地分支名>

    # 如果远程分支是与当前本地分支合并，则冒号后面的部分可以省略
    git pull origin master

    # 如果远程主机名 origin，分支就是当前分支，可简写
    git pull

    # 因为默认是 fetch + merge，所以需要用 rebase 的话，需要明确指定参数 --rebase
    git pull --rebase

如果你介意合并策略，特别是执行 git pull 时会出现合并冲突，那么最好研究下 pull 如何处理合并策略。

更新本地仓库需要两个操作：fetch 从远程拉取到本地的远程仓库，再做 merge 或 rebase 以合并到本地仓库。

后来就引入了 pull 命令，把这两个操作过程合并了，以简化用户输入。

所以 pull 实际上执行：拉取+合并

    git pull          = git fetch + git merge

    git pull --rebase = git fetch + git rebase

git pull 的操作默认是 fetch + merge，可以在 git 的设置中设置成 fetch + rebase。

如果可以做快进合并，那么执行 merge/rebase 的效果相同，只接续，不会更新那部分提交记录的 hash 值

merge 默认的操作不一定选择那种合并策略，参见章节 [merge 默认参数有二义性，分叉或拉直]。

详细的关于分支合并的策略选择，参见章节 [分支合并：分叉还是拉直]。

## 分支合并：分叉还是拉直

    Git 之 merge 与 rebase 的区别 https://www.cnblogs.com/zhangzhang-y/p/13682281.html

能做合并的基础是两个分支有相交点，如果是三个分支合并无直接交点则需要用 rebase。

两分支合并方法

    # 不带参数的 merge 有二义性，分叉或拉直，参见章节 [merge 默认参数有二义性，分叉或拉直]
    git merge

    # 尝试快进合并，否则不做，参见章节 [merge --ff-only 只做快进合并的拉直]
    merge --ff-only

    # 强制做分叉，参见章节 [merge --no-ff 强行分叉]
    git merge -no-ff

    # 强制做拉直，参见章节 [`rebase <branch>`  拉直]
    git rebase

### 分支合并的策略选择

merge 菱形分叉会制造一个新的提交记录，而 rebase 拉直会更新接续点之后所有提交记录的hash值

    使用菱形分叉，这样在查看历史提交记录时，方便区分主干和功能分支，不让功能分支的众多提交记录混入主干分支。

    使用 merge 菱形分叉而不使用 rebase 拉直以防止重写历史，其中一些甚至可能更简单易用。但是，master 分支的历史将穿插着所有同时开发的功能的提交，缺点是这样混乱的历史很难回顾。

    拉直效果最大的优点时避免很多分叉交错导致的混乱历史。

    快进合并的拉直不会像 rebase 变基合并那样修改提交记录的 hash 值。

基本原则：

    尽可能多建分支进行开发，而不是在一个开发分支上过多的人操作

    何时采用分叉或拉直的形态，以能清晰区分各新增功能为目的，日后的分支管理可以方便的回溯历史提交，查找对应功能点

时效性原则：

    合并代码的时候按照最新分支优先合并为原则

    要经常从上游分支更新代码，如果长时间不更新上游分支代码容易出现大量冲突

酌情考虑如下合并策略：

    主干分支合入 hotfix， 属于主干分支上的接续，做变基合并拉直。这是因为 hotfix 分支只是本地分支，变基合并更新本地的提交记录无不良影响。

    本地分支从远程更新，要区分情况

        本地开发分支从远程更新，做 rebase 变基合并拉直。

        本地主干分支从远程更新，做 merge 自动选择快进或分叉合并。这是因为远程的主干分支可能已经合入了其它功能，以及各种 hotfix。

        其它情况详见章节 [更新本地分支的操作步骤]

    功能分支合并到主干分支较复杂，详见章节 [功能分支合并到主干分支的操作流程]。

#### TODO:主干分支修复bug 的hotfix分支合并用rebase拉直

简单来说两步：

1、功能分支用分叉合并主干分支，如果功能分支的提交记录的 hash 值变更不会引起混乱（远程多分支变更导致其他人的混乱，缺陷管理对应不到提交记录），可以使用变基合并做拉直（变基合并见章节 [变基合并有远程分支要先合并到自身]）。

2、然后主干分支合并功能分支，用分叉方式合并到主干分支。详见章节 [功能分支合并到主干分支的操作流程]章节

#### 功能分支合并到主干分支的操作流程

适用于主干分支和开发分支并行的工作流，参见章节 [git工作流： 功能分支工作流]。

下面举例详细说明：

主干在 c 点后出现 2 个分支各自延续，以下讨论以此为例：

                            ---d---e  分支 hotfix
                        /
    master主干  a---b---c
                        \
                            ---f---g  分支 feature1

> 开发分支建立自主干分支的节点 c，在此基础上延续，开发人员日常更新本地开发分支时要采取变基合并策略进行拉直：

更新本地开发分支只使用 `git pull --rebase` 的方式，这样变更的只是开发人员本地的提交记录的 hash 值，远程的提交记录 hash 值保持不变，以此来保持开发分支是拉直延续的。参见章节 [更新本地分支的操作步骤]。

    feature1分支 a---b---c
                          \
                            ---f---g  分支feature1 自己的提交记录

> 主干分支修复bug，单独建立分支 hostfix，改完后使用变基合并的方式合入主干分支，主干分支的节点延续到了 e。参见章节 [变基合并有远程分支要先合并到自身]。

                            ---d---e  分支 hotfix
                        /
    master主干  a---b---c

> 开发分支在开发中不断更新合入主干分支的内容：

先让本地主干分支从远程更新，使用命令 `git pull` 让 git 自动选择快进合并或分叉合并，注意不要做强行拉直 `git pull --rebase` 。这样的好处是不会修改本地主干分支的提交记录。一般来说，主干分支上拉直合入都是 hotfix，分叉的合入是各个功能点。

然后开发分支使用 `git merge --no-ff` 强制分叉的方式合并主干分支的内容，这样的好处是不修改两个分支的提交记录，而且用菱形分叉便于区分合入的功能分支的提交记录。

                          ---d---e 主干分支合入的 hotfix
                         /        \
    feature1分支 a---b---c          new1(HEAD) 由`git merge --no-ff`建立
                         \        /
                          ---f---g  分支feature1 自己的提交记录

因为开发分支最终也是分叉合入主干分支，两分支只会形成一个菱形，所有的提交记录都不会被修改，完美。

> 开发分支告一段落，主干分支使用 `git merge --ff-only` 把开发分支的内容合并进来

因为之前开发分支一直在分叉合并主干分支的内容，所以二者有共同的主干分支的内容。这样开发分支在合并到主干分支时是快进合并，不会变更两分支的任何提交记录。

最终的形态，两分支只是一个菱形的分叉，便于区分各分支，特别是在同时有多个功能分支分叉的情况下，主干分支可以保持不乱

                          ---d---e ---e2---e...主干分支合入的 hotfix
                         /                      \
    主干分支     a---b---c                          new1(HEAD) 由`git merge --no-ff`建立
                         \                      /                           \
                          ---f---g ---g2---g... 分支feature1 自己的提交记录
                         \                                                  /
                          ---m1--m2---m3---m...              分支mmm 的提交记录

    feature1 分支的形态跟上面完全一致，两分支的提交记录的 hash 值也是一致的，完美。

### 分支合并的各个命令及效果

#### merge 默认参数有二义性，分叉或拉直

命令 `git merge` 的执行结果有不确定性：

    默认做快进合并 fast-forward，直接接续在目标分支的最新提交点后面，取拉直效果。

    如果无法做快进合并，则创建菱形分叉，新建一个提交点。

    merge 会在做完给你个提示性信息，如果你后悔了，可以用 `git reset --hard HEAD^` 强行回退，参见章节 [git reset]。

总之，在多人都操作同一个分支各自有提交的情况下，在分支合并时执行不带参数的 `git merge` 命令，可能会快进合并，也可能会结合多个提交的最新位置新建一个提交点（无法快进合并），形成了一个菱形。

举例说明：

主干在 c 点后出现 3 个分支各自延续，以下讨论以此为例：

                            ---d---e  分支 hotfix
                        /
    master主干  a---b---c    ---f---g  分支 feature1
                        \
                            ---h---i  分支 feature2

在主干分支 master 合并这三个分支时，会出现多种形态的提交记录。

假设我们每次做合并，merge 命令不带参数，只执行 `git merge`，让它自动选择合并策略。

1、准备环境，切换到主干分支 master 并更新

    git switch master

    git pull

2、先把 hotfix 分支合并到主干分支 master

    git merge hotfix

第一个合入的分支，可以直接在c点接续，`git merge` 默认做快进，不制造新commit点，做完会给个提示性信息

    master分支  a---b---c ---d---e(HEAD)

                            git reset --hard HEAD^ 回退是到d

这样主干分支就延续到了 e 点。

3、然后再把分支 feature1 合并到主干分支 master

    git merge feature1

因为 feature1 的基础节点是 c 点，而主干分支已经延续到了 e 点，无法做快进合并就会制作分叉，`git merge` 并无提示，这个地方最容易让人糊涂。

因为无法接续在c点，所以会制作新commit点，形成菱形分叉：

                          d---e     分支hotfix
                         /         \
    master分支  a---b---c             new1(HEAD) 由`git merge`建立
                         \         /
                          f---g  分支feature1

    git reset --hard HEAD^ 回退是到e

4、主干分支再合并分支 feature2，菱形分叉更多了

    master分支  a---b---c ---d---e  分支hotfix --- new1 --- new2 (HEAD)
                         \                        /        /
                            f---g 分支feature1 ---/        /
                         \                               /
                            h---g  分支feature2 -------- /

    这次又添加了一个 new2 提交点。

如果两分支修改了相同的文件，合并时会提示解决合并冲突，详见章节 [解决合并冲突conflicts]。

如果不想要菱形分叉强行拉直，参见章节 [`rebase <branch>`  拉直]。

##### merge --squash 压缩为一个commit点合并

如果提交记录太多了，在合入主干时简单粗暴的精简处理

    git checkout master

    git merge --squash -m '分支feature1合入主干分支，压缩掉自己的提交记录' feature1

受 merge 二义性的影响，默认快进，否则分叉。

示例：

主干在 c 点后出现 3 个分支各自延续，以下讨论以此为例：

                            ---d---e  分支 hotfix
                        /
    master主干  a---b---c    ---f---g  分支 feature1
                        \
                            ---h---i  分支 feature2

先 hotfix 快进合并到主干分支

    master分支  a---b---c ---d---e(HEAD)

然后 feature1 压缩合入主干分支

                           ---d---e   分支hotfix先合入，git默认做快进
                         /          \
    master主干  a---b---c             new1(HEAD) 由git在后合入分叉时生成
                         \          /
                            fg        分支feature1压缩为只有一个commit点，后合入

因为分支只作为一个提交记录合入了主干分支，要查历史提交只能在原 feature1 分支上查，慎用。

#### merge --ff-only 拉直

因为执行 `git merge` 不带参数有二义性，而且并不让用户选择，只是合并后告诉你一下。所以你不喜欢这样的默认做法，那么可以使用命令 `merge --ff-only` 强制只做快进合并

    git switch master

    git merge --ff-only -m "feature分支合入主干分支" feature

强制只做快进，否则报错退出，这样可以防止 `git merge` 默认的无法做快进时使用分叉。

快进合并的好处是不新增 commit 点，提交记录时拉直的一条线的效果，而且可以避免用 rebase 拉直导致的变更提交记录 hash 值。

#### merge --no-ff 分叉

为强制分叉，可以明确指定不做快进合并，用于需要分叉，阻止 `git merge` 默认做快进合并的场景

    git switch master

    git merge --no-ff -m "分支feature1合入主干分支" feature1

主要用于大的功能分支合并到主干分支：不使用快进合并而用菱形分叉，这样在查看历史提交记录时，方便区分主干和功能分支，不让功能分支的众多提交记录混入主干分支。对功能分支合并主干分支的场景，更新本地主干分支也应该用分叉，参见章节 [功能分支合并到主干分支的操作流程]。

示例：

主干在 c 点后出现 3 个分支各自延续，以下讨论以此为例：

                            ---d---e  分支 hotfix
                        /
    master主干  a---b---c    ---f---g  分支 feature1
                        \
                            ---h---i  分支 feature2

如果主干分支执行 `git merge feature1`，因为有共同的基点 c，会做快进，把 f、g 点接续在 c 点的后面，形成拉直效果，但是这样不便于我们区分主干上合入的功能分支。

所以把分支 feature1 强行分叉的方式合入主干，效果如下

                          f---g------- 分支feature1
                         /             \
    master主干  a---b---c -------------- new(HEAD) 由git制造
                                          *
                       git reset --hard HEAD^ 的效果是回到c点

菱形分叉最大的好处，除了便于观察之外，如果需要版本回退，很容易就可以退到feature合并之前的位置。


#### `rebase <branch>` 拉直

变基合并，修改你本地的提交记录的 hash 值，强行拉直，适用于大多数从远程仓库拉取到本地的场景。

如果 git 提示会做快进合并 Fast-forward，那么执行 `git merge` 或 `git rebase` 的效果相同都是拉直，都不会变更提交记录的 hash 值。

变基合并的前提是两个分支有共同的祖先，一个分支通过更新自己分支提交记录的 hash 值的方式，不制造分叉点而直接接续在另一个分支的最新记录后面，使自己分支获取拉直效果。

    # 将 feature1 分支中的修改变基到 feature2 分支上，
    # 被变基合并修改的是 feature1 的提交记录，相关 hash 值全变
    # git rebase [basebranch] [topicbranch]
    git rebase feature2 feature1

    相当于

    git switch feature1
    git rebase feature2

一般本地分支更新自己的远程分支，用变基合并拉直提交记录，是完全没有问题的。

但是如果本地分支要合并到别的分支，两分支有远程跟踪分支，则有很多限制

    NOTE: 变基合并两个分支时，一定要先想清楚哪个分支的提交记录 hash 值不许变，哪个分支的可以变，然后再做。

这是因为 rebase 会变更提交记录的 hash 值，对远程分支做变基会使得其它共享开发的人混乱，参见章节 [遇到提示 push -f 的时候多想想]。

所以能做变基合并的几种情况是：

    两个本地分支合并，没有远程跟踪分支，提交记录 hash 值变更无影响，可以做变基合并。这种场景一般是开发人员在本地搞了多个分支做不同的开发，最后要合并到一起。

    本地开发分支更新，拉取自己的远程分支，需要拉直提交记录，可以做变基合并。这个场景最常用，参见章节 [更新本地分支的操作步骤]。

    一个本地分支做修改，另一个有远程分支跟多人同步，因为本地分支的 hash 值变更不会影响他人，可以做变基合并，方法见章节 [变基合并有远程分支要先合并到自身]。这个场景一般是用 hotfix 分支修复主干分支的缺陷，用变基合并保持提交记录的拉直状态。因为 hotfix 分支在合并到主干分支后就废弃了，所以在合并主干分支内容时用变基合并，变更它的提交记录的 hash 值没有影响。

    两个分支都有远程分支，但是被变基合并的分变更 hash 值不会造成混乱，也可以做变基合并。一般只用于开发分支结束，精简开发分支的提交记录，合入主干分支后废弃开发分支的场景，参见章节 [使用合并专用分支进行拉直]。

    两个分支都有远程分支，都不能 push -f 强行变更，则不能做变基合并，只能用分叉合并。

如果不想被 rebase 修改提交记录的 hash 值，应该选分叉合并

    开发过程中可能会往复应用、撤销提交点等情况，如果变基修改了分支提交记录的hash值，只能人工看提交记录的注释了，而且缺陷管理系统也无法对应提交记录了。git 对内容的修改无法依赖提交点的 hash值，是无法处理内容差异的。

    被变基合并的分支的提交记录的 hash 值变更涉及远程跟踪分支，则使用变基合并会造成混乱：比如功能分支更新合并主干分支，如果用 rebase 合入主干分支的内容，则功能分支的提交记录的 hash 值就全变了，如果功能分支还在持续开发，缺陷管理系统无法对应提交记录，多人共享的环境下大家都要重新拉取功能分支，总会带来一些混乱。所以大多数情况下，功能分支项目组往往选择用 merge 分叉合入主干的内容。

##### 变基合并有远程分支要先合并到自身

    https://git-scm.com/book/en/v2/Git-Branching-Rebasing

    https://github.com/k88hudson/git-flight-rules/blob/master/README.md#i-rebased-but-i-dont-want-to-force-push

因为变基合并会修改提交记录的 hash 值，所以对有远程跟踪分支的本地分支来说，如果想做变基合并，要想清楚哪个分支的提交记录 hash 值不许变，哪个分支的可以变，然后才可以做拉直合并

    如果两个分支都有远程跟踪分支，除非可以强制做 push -f，否则不要做变基合并，老老实实做分叉合并。

    慎用强制推送，参见章节 [遇到提示 push -f 的时候多想想]。

简单情况：

如果被变基合并的分支不涉及远程分支、缺陷管理等依赖提交记录 hash 值的场景，比如你做的修改还没有推送到远程，或你的本地分支还没从远程更新拉取过他人的提交记录，那这样的变基做就没有任何问题

    # 你的本地分支，变基合并 feature1 的内容
    git rebase feature1 your_branch

复杂情况：常见的就是给主干分支合并 hotfix 分支

如果被变基合并的分支有远程分支，在你的分支拉取远程分支后，有人又推送了新的提交。这时无法做快进合并拉直，也无法直接做变基合并。

比如，妄想直接给主干分支变基合并 hotfix 分支的内容

    # 这样变基修改主干分支，你考虑过远程分支会不一致么
    git rebase hotfix master

这样做变基合并，变更主干分支的提交记录的 hash 值，推送远程会报错，强推 push -f 会更乱，缺陷管理系统也无法跟踪主干分支的提交记录了。（慎用强制推送，参见章节 [遇到提示 push -f 的时候多想想]）。

所以，要避免变更被变基的分支提交记录的 hash 值，看看能否变更另一个分支的提交记录的 hash 值。

解决方案如下：

    # 先把主干分支变基合并到 hotfix 分支，这样变更的是 hotfix 分支提交记录的 hash 值
    git rebase master hotfix

    # 然后再把 hotfix 分支合并到 master 分支，这时变成快进合并了，对 master 分支无任何影响。
    git switch master
    git merge hotfix

当然如果 hotfix 分支的提交记录 hash 值也不许变更，，比如是某个多人远程共享的功能分支，则无法做变基合并，老老实实做分叉合并。

下面举例详细说明：

主干在 c 点后出现 3 个分支各自延续

                            ---d---e  分支 hotfix
                        /
    master主干  a---b---c    ---f---g  分支 feature1
                        \
                            ---h---i  分支 feature2

假设我们的要求是主干分支不出现分叉，拉直合并其它分支，那么只能使用 rebase 变基合并.

现在分支 feature1 要合并到主干分支里，但是主干分支已经合入了分支 hotfix，提交点已经延续到了 e。这时两分支的 head 位置不一样，执行 `git merge` 会制造菱形分叉，不符合要求。

    master主干  a---b---c ---d---e

                         ---f---g  分支 feature1

                         ---h---i  分支 feature2

如果直接把 feature1 的内容变基合并到主干分支 master

    # 相当于 `git switch master; git rebase feature1`
    git rebase feature1 master

这样会导致主干分支的提交记录 d、e 的 hash 值变更，这是绝对要避免的行为

    master主干  a---b---c ---f---g ---d'---e'

这样做了之后，执行 push 推送远程时也会报错，强行推送 push -f 会更乱，参见章节 [遇到提示 push -f 的时候多想想]。

所以，稳妥的方案是两步：

1、先切换到分支 feature1，变基合并主干分支的内容，使得 feature1 分支在 master 分支的基础上延续拉直。

    # 分支 feature1 变基合并主干分支

    # git switch feature1
    # git rebase master
    git rebase master feature1

这时 d、e 点被合并进来，feature1 分支的 f、g 点在后面接续，但 hash 值变更，成为 f'、g'。

分支 feature1 变基合并主干分支后的拉直效果如下：

                                    f'---g' 重写 feature1 分支的提交记录，hash 值变更
                                   /
    feature1分支 a---b---c ---d---e
                                  在 e 点变基
                        在分叉点 c 后面接续 master 的提交记录

可以看到 f' 被调整指向了 e，虽然可能需要付出一些合并冲突解决的代价，但是提交记录直线延续清晰多了。

先用分支 feature1 变基合并主干分支的目的是：在分支 feature1 上做 rebase，变更的是自己的提交记录f、g 的 hash 值，不会变更合并进来的主干分支的 d、e 点的 hash 值。即便需要处理合并冲突，也都是更新分支 feature1 的提交记录 f、g，主干分支的提交记录 d、e 的 hash 值保持不变。

注意

    做 rebase 之后，feature1 分支的提交记录 f、g 点的 hash 值全变了。如果推送 feature1 分支会报错提示用 'push -f'。如果无法接受 feature1 分支造成其它共享人员的混乱，或缺陷追踪系统无法对应提交记录，就不要使用变基合并了。

    所以，一般在开发周期结束不需要再依赖 feature1 分支的场合，才变基合并 master 分支。平时项目组对功能分支合并主干分支，都是用分叉的策略，而不是变基合并，详见章节 [功能分支合并到主干分支的操作流程]。

    如果你的分支管理依赖这个 hash 值，那么就不要用 rebase，这种情况下只能使用 merge，在合并后 feature 分支会出现菱形。

2、然后就可以把分支 feature1 快进合并到主干分支。

feature1 分支的 f'、g' 已经接续在 d、e 的后面了，master 分支这时落后于 feature 分支了，可以做快进合并：

    master主干    a---b---c ---d---e

    feature1分支  a---b---c ---d---e ---f'---g'

这是因为两分支在分叉点 c 之前有共同的祖先，实质二者在一条线上，所以 master 主干分支合入 feature 分支时，git 会做的是快进合并，执行 `git merge` 或 `git rebase` 效果相同，这种情况下不会修改任何提交记录的hash值。

    # 主干分支合并分支feature1

    git switch master
    git merge feature  # 如果不放心就做 merge --ff-only

3、最终效果，大家都同步到一条直线的最末端：

    a---b---c---d---e---f'---g' master
                                feature

如果 rebase 操作遇到合并冲突，会中断 rebase，同时提示你解决冲突，解决参见章节 [解决合并冲突conflicts]。

##### 使用合并专用分支进行拉直

如果开发分支本身就是用拉直策略延续的，并不需要使用合并专用分支，参见章节 [功能分支合并到主干分支的操作流程]。

开发分支在合并到主干分支前进行拉直，适用于开发分支使用完即废弃不再追踪的场景

    如果缺陷管理系统对应开发分支的提交记录，则拉直后bug清单会失去对应效果，这样就不能做拉直。

主要用于以下场景：开发分支要合并到主干分支前，因为开发分支的 commit 点的重整比较繁琐，而且容易搞乱，很多人都因此放弃整理，直接合入。如果不做精简，太多的 commit 点使得分支形态不够简洁，而且有各种分叉。

这样的直接合入主干会使主干不够简洁

    开发分支 a---b---c ---d---e hotfix ------ new1 --- new2 (HEAD)
                    \                         /        /
                    \ ---f---g feature1 --- /        /
                    \                                /
                    \ ---h---i feature2 --------- /

我们需要的是开发分支拉直后，再合入主干

                    feature1 --- feature2 ---...
                    /                           \
    主干分支 a---b---c --- ...                  --- v1.1 --- ...

解决：建立合并专用分支，把提交记录整理成拉直形态

    在自己本地使用的比较乱的分支，需要合并到大家共用的分支之前

    在功能分支合并到主干之前

可能会付出大量的解决冲突合并的工作。如果使用文件比对工具合并到专用分支，不再依赖提交记录的 hash 值，这样可以大大缩小工作量。

方法

    合并用分支从功能分支在主干上拉取时的同一个起点拉取

    开发人员把自己负责的代码，从功能分支合并到合并专用分支。这时如果能使用文件比对工具 beyondcompare 比对两个分支的文件，即可方便的合入代码，按功能点形成提交点。

    如果可以统一形成一个commit点，那么直接使用 squash 压缩即可

### 解决合并冲突conflicts：Your branch and 'origin/xxx' have diverged

    https://blog.csdn.net/qq_44536533/article/details/123412327

    https://blog.csdn.net/d6619309/article/details/52711035

合并冲突是指：在共同节点之后，出现了两种独立的提交(每种可能有多个提交)。两个分支合并，或本地合并远程时，都有可能出现合并冲突。

比如你的本地开发分支推送远程被拒绝

    $ git push
    To ssh://
    ! [rejected]              master -> master (fetch first)
    error: failed to push some refs to 'ssh://7'
    hint: Updates were rejected because the remote contains work that you do
    hint: not have locally. This is usually caused by another repository pushing
    hint: to the same ref. You may want to first integrate the remote changes
    hint: (e.g., 'git pull ...') before pushing again.
    hint: See the 'Note about fast-forwards' in 'git push --help' for details.

    $ git fetch 先拉下远程

    $ git status 看看提示
    On branch master
    Your branch and 'origin/master' have diverged,
    and have 2 and 2 different commits each, respectively.
    (use "git pull" to merge the remote branch into yours)

    # 对比看看提交记录的差异
    $ git log ..origin/master --graph --oneline

这种情况，通常是由于另外一个人在上游相同的分支做了提交，你俩在之前的提交记录历史中有功能的起点，但是现在分歧了。比如你的本地有了新的提交记录后推送远程，不巧的是远程已经有人推送了新的提交记录，因为你俩的分支相同，但是在某个提交点之后，各自延续发展了提交点，导致 push 操作报错。

一般来说，只要不是同文件同行的修改，git 会根据你的合并策略选择分叉或拉直自动接续提交点。所以只要你运行 `git pull` 或 `git pull --rebase` 命令，会自动把最新的远程合并到你的本地，提示信息会告诉你合并的内容，然后你可以继续推送。

但是git无法完全解决合并冲突，有时候出现需要手工解决的情况：比如，文件有一行内容 '123456'，你修改为 '123'，别人修改为 '456'，谁先提交无所谓，后面的人在推送或拉取的时候就会被提示处理该合并冲突。

最差的情况是：对方把自己的本地远程库重新rebase并推送到了远程，或你把已经推送远程库的代码，在本地分支重新rebase了，再次推送就报错了，见章节 [拉shi往回缩：rebase本地分支以后报错了]。

所以，如果多人共享开发经常出现合并冲突，更新分支应该先 `git fetch` 再操作，详见章节 [更新本地分支的操作步骤]。

两个分支合并，也会出现合并冲突：

    本地分支 A 合入 本地分支 B，二者对同一文件的同一行的都进行了修改，则出现冲突。

    你在功能分支合并主干分支时，没有先更新本地的主干分支，而主干分支的远程已经有新的提交了，而你把功能分支合并到本地的这个旧的主干分支，在推送到远程的主干分支时会发现提示冲突。这种情况你只能先回退到自己功能分支的最新提交点，更新主干分支之后再重新做合并。

    或者，即使你更新了本地的主干分支，但是没有锁定远程主干分支的合入，在你做本地的合并工作时，有人在远程的主干分支新增了提交，这样在你推送合并后的新主干分支到远程时，也会提示冲突。

    在这种情况下，先对比查看下两个分支的提交记录的差异

        git log --graph --oneline master...feature1

两分支合并该分叉还是拉直，参考章节 [分支合并：分叉还是拉直]，选择 merge 对冲突的处理是分叉，选择 rebase 对冲突的处理是重写自己的提交点接续拉直。

在你手工解决了所有的冲突文件后，提交的命令稍有区别，最好每一步都运行 git status 看看提示再做

    如果是 merge 时提示冲突，解决后

        git add .  # 注意这是把所有文件都添加了，确保没有无关文件

        git commit

    如果是 rebase 时提示冲突，解决后

        git add .  # 注意这是把所有文件都添加了，确保没有无关文件

        git rebase --continue

        随后弹出提交注释，默认用你本地的提交记录的

        如果 rebase 多个提交记录，可能会提示多次修改，需要重复这个过程，
        或根据提示直接编辑 "git rebase --edit-todo" 把多个提交压缩到一个简单处理。

    如果是 revert 时提示冲突了，解决后

        git add . # 注意这时把所有文件都添加了，确保没有无关文件

        git revert --continue

然后看看 git log，看到你的提交就新增成功了，可以继续推送流程了。

如果想跳过这个提交，会导致以原提交为准，新增提交丢弃

    git rebase --skip

    或 git revert --skip

如果想放弃合并，重新编辑

    git merge --abort

    或 git rebase --abort

    或 git revert --abort

可以使用图形化的合并工具 git merge tool，它会将找到一份两个分支的祖先代码作为base也就是基准，然后再将两个分支的改动都列举出来作为对比，显示的是三个窗口，让我们在git编辑器当中决定要留下什么。如果使用 vs code 的话，它的显示效果更友好，而且还可以切换比对。

#### 冲突文件的格式

NOTE: 冲突文件区分 rebase、merge 时的 HEAD 指针，当前和合入的意义不同

基本如下

    [不冲突的内容]
    <<<<<<<< HEAD
    [
        冲突代码：
        从 <<<<<<<< HEAD 到 ======== ，是 HEAD 指针指向的节点的代码，属于当前内容。

        如果是 merge，这里是本地的。

        如果是 rebase，这里是远程的。应该是优先保留远程hash值不变的考虑。
    ]
    =======
    [
        冲突部分：
        从 ======= 到 >>>>>>> '提交时的注释'，是要合并进分支的代码，属于要合入的，

        如果是 merge，这里是远程的，相对上面的本地。

        如果是 rebase，这里是本地的，相对上面的远程。应该是优先保留远程hash值不变的考虑，更新本地hash追加在远程提交记录的后面。
    ]
    >>>>>>> 94950e8 ("提交点注释")
    [不冲突的内容]

git 修改了冲突文件的内容，同时列出的两种版本，是为了方便你修改的时候对比酌情编辑，比如删除一个保留另一个等，其实全删了重新写也可以。只要你删除了冲突标记符号保存文件，git 就把它当作你指定的无冲突的版本，即的再次 git status 看提示。

总之，你的最终修改结果，使文件内容是你想要的样子，记得要删除冲突标记符号所在行，然后保存退出。

因为进入合并冲突的过程了，这时执行 `git diff` 可以对比查看合并差别，前面的 a 表示当前本地内容，后面的 b 表示要合入的内容

    $ git diff
    diff --cc mmm.py
    index 3988649e86,51def895e0..0000000000
    --- a/mmm.py
    +++ b/mmm.py
    @@@ -1,5 -1,5 +1,10 @@@
    + mod1conf
    # aaa
    ++<<<<<<< HEAD
    +0000000000# b2222222222222b mod conflict
    +ooooooooooooo mod conflict
    ++=======
    +mod1 for conflict
    ++>>>>>>> 411165b222debbb155d331326689726c0e254396
    # ccc
    - # fff
    + mod1 conf ori
    + # fff ggggggggggggggg mod1 conf

如果想重新检出然后生成冲突文件

    git checkout --conflict hello.txt

##### 使用 diff3 处理合并冲突

    https://git-scm.com/book/en/v2/Git-Tools-Advanced-Merging#_checking_out_conflicts

    https://blog.nilbus.com/take-the-pain-out-of-git-conflict-resolution-use-diff3/

不使用 diff，使用 diff3

    git config --global merge.conflictstyle diff3

在冲突文件中，会新增类似 `||||||| merged common ancestor=======` 的行来指出合并前的共同祖先 base，这样便于使用者更容易的区分保留哪个。

用如下行包围功能祖先的内容

    ||||||| merged common ancestor      <-------这里开始
    <<<<<<< Temporary merge branch 1    <-------分支1
    ...
    ...
    ...
    =======
    >>>>>>> Temporary merge branch 2    <-------分支2 这里结束

示例

    # 在命令行用参数指定
    git checkout --conflict=diff3 hello.txt

    <<<<<<< HEAD
    bbbbbbbbb.yyyyyyyy
    ||||||| merged common ancestor
    aaaaaaaaa.yyyyyyyy
    =======
    aaaaaaaaa.xxxxxxxx
    >>>>>>> merged-branch

使用 diff3 的缺点是处理交叉合并（criss-cross merge）会变复杂

    https://blog.nilbus.com/temporary-merge-branch-in-diff3-conflict-markers/

    出现的如下格式

        <<<<<<< HEAD
            aaaaaa
        ||||||| merged common ancestors
        <<<<<<< Temporary merge branch 1
            bbbbbb
        =======
            cccccc
        >>>>>>> mybranch
            dddddd
        <<<<<<< HEAD
            eeeeee
        ||||||| merged common ancestors
            ffffff
        ||||||| merged common ancestors
            gggggg
        =======
        >>>>>>> Temporary merge branch 2
        =======
            hhhhhh
        >>>>>>> mybranch

    其中 `<<<<<<< Temporary merge branch` 和 `>>>>>>> Temporary merge branch` 包围的部分是交叉合并导致的diff3的一些输出，可以无视，删除后的内容跟不使用 diff3 的结果一致

        <<<<<<< HEAD
            aaaaaa
        =======
            hhhhhh
        >>>>>>> mybranch

可以用 sed 进行这个精简过程

    # 显示精简后的结果
    sed -n '/||||||| merged common ancestor/,/>>>>>>> Temporary merge branch/!p' your_conflict_file

    # 直接修改到文件
    sed -i '/||||||| merged common ancestor/,/>>>>>>> Temporary merge branch/d' your_conflict_file

#### merge 对冲突的解决方式是分叉

    本地分支拉取或推送远程时，远程库上有新的提交，与本地的提交，在某个 commit 点之后出现了两种提交的延续，如果直接 git pull，会默认执行 merge，如果有冲突则自动进入一个 merge conflict 过程状态，需要手工解决冲突。

    两分支合并同上。

merge 如果可以做分叉合入，会直接提示新增提交点的注释，这种不需要手动干预

    $ git pull
    merge: Merge branch 'master' of git://...

merge 如果自动解决不了冲突，会提示需要手工解决冲突

    $ git pull
    Auto-merging mmm.py
    CONFLICT (content): Merge conflict in mmm.py
    Automatic merge failed; fix conflicts and then commit the result.

    $ git status
    On branch master
    Your branch and 'origin/master' have diverged,
    and have 1 and 1 different commits each, respectively.
    (use "git pull" to merge the remote branch into yours)

    You have unmerged paths.
    (fix conflicts and run "git commit")
    (use "git merge --abort" to abort the merge)

    Unmerged paths:
    (use "git add <file>..." to mark resolution)
            both modified:   mmm.py

    no changes added to commit (use "git add" and/or "git commit -a")

git pull 自动使用 merge，发现冲突后，会进入 merge confict 状态，给你准备好冲突文件，直接编辑解决冲突，详见下面章节 [示例：merge 处理合并冲突]。

##### 示例：merge 处理合并冲突

本地从远程更新代码，操作步骤根据章节 [更新本地分支的操作步骤]，不直接 git pull，以便可以根据情况来选择合并策略。

先拉取远程

    git fetch

查看当前状态，提示有冲突，并建议用pull，其实上一步已经fetch下来了，直接执行 merge 即可。

    $ git status
    On branch master
    Your branch and 'origin/master' have diverged,
    and have 1 and 1 different commits each, respectively.
    (use "git pull" to merge the remote branch into yours)

    nothing to commit, working tree clean

查看具体差异，对比下本地和远程，其中 a 是本地，b 是远程，减号表示本地相对远程被删除的内容，+表示远程相对本地新增的内容，没有加减号的表示无差异。

    $ git diff ..origin/master
    diff --git a/nbranch.py b/nbranch.py
    index 9b9041b..db1d997 100644
    --- a/nbranch.py
    +++ b/nbranch.py
    @@ -1,7 +1,9 @@
    -# 11addaddadd111
    +先推送到远程的占优先2dd
    +# 1112add11
    +2add
    +2add
    # 22222
    -1add# 33333add1
    -1add
    -1add
    -
    +2add

    +2add
    +2add

执行 merge，git 会修改冲突的文件内容，同时列出二者并标记差异，便于你直接编辑

    $ git merge
    Auto-merging nbranch.py
    CONFLICT (content): Merge conflict in nbranch.py
    Automatic merge failed; fix conflicts and then commit the result.

再看看提示，会提示冲突详情

    $ git status
    On branch master
    Your branch and 'origin/master' have diverged,
    and have 1 and 1 different commits each, respectively.
    (use "git pull" to merge the remote branch into yours)

    You have unmerged paths.
    (fix conflicts and run "git commit")
    (use "git merge --abort" to abort the merge)

    Unmerged paths:
    (use "git add <file>..." to mark resolution)
            both modified:   nbranch.py

    no changes added to commit (use "git add" and/or "git commit -a")

其中 “Unmerged paths” 会提示冲突文件，需要手工编辑该文件解决冲突，方法参见上面章节 [冲突文件的格式]

    $ cat nbranch.py
    <<<<<<< HEAD
    # 11addaddadd111 这后面是本地的
    # 22222
    1add# 33333add1
    1add
    1add


    =======
    先推送到远程的占优先2dd 这后面是远程的
    # 1112add11
    2add
    2add
    # 22222
    2add

    2add
    2add 至此结束
    >>>>>>> refs/remotes/origin/master

标记改完了，添加该文件以便rebase可以更新进度

    git add .  # 注意如果有无关文件就别用 . 通配了，还是指定具体文件名比较好

这次提示没有冲突了，可以直接提交

    $ git status
    On branch master
    Your branch and 'origin/master' have diverged,
    and have 1 and 1 different commits each, respectively.
    (use "git pull" to merge the remote branch into yours)

    All conflicts fixed but you are still merging.
    (use "git commit" to conclude merge)

    Changes to be committed:
            modified:   nbranch.py

然后提交新建的分叉点，查看状态，提示可以推送远程了

    $ git commit

    $ git status
    On branch master
    Your branch is ahead of 'origin/master' by 2 commits.
    (use "git push" to publish your local commits)

因为 git 会把你整理后的结果新建 commit 作为分叉，所以整套操作下来，保留本地commit + 接收远程的commit + 新建一个分叉点，相对远程合计新增了 2 个commit点。

确认下历史提交的情况

    原本地

        $ git log --oneline --graph
        * 177d0d0 (HEAD -> master) 要想 1add 历史能记下，用merge解决冲突
        * 134a0ad rebase update 2add for conflict
        * e7f51c5 111mod 111add

    原远程

        $ git log --oneline --graph
        * 67a69c9 (HEAD -> master, origin/master) 2add 占先
        * 134a0ad rebase update 2add for conflict
        * e7f51c5 111mod 111add

可以看到，保留了原远程和原本地的commit，新建了分叉点保留合并后的结果

        $ git log --oneline --graph
        *   03ea730 (HEAD -> master) 解决了冲突，应该是分叉合并了 Merge remote-tracking branch 'refs/remotes/origin/master'
        |\
        | * 67a69c9 (origin/master, origin/HEAD) 2add 占先
        * | 177d0d0 要想 1add 历史能记下，用merge解决冲突
        |/
        * 134a0ad rebase update 2add for conflict
        * e7f51c5 111mod 111add

没问题，推送远程

    $ git push
    Enumerating objects: 10, done.
    Counting objects: 100% (10/10), done.

#### rebase 对冲突的解决方式是重写提交点

    本地分支拉取或推送远程时，远程库上有新的提交，与本地的提交，在某个 commit 点之后出现了两种提交的延续，如果直接选择变基 git pull --rebase，会执行 rebase，如果有冲突则自动进入一个 rebase conflict 状态，需要手工解决冲突。

    两分支合并同上。

rebase 如果没有冲突，会有提示信息，但无需任何操作，直接 push 即可。

    $ git pull --rebase
    From  git://...
    First, rewinding head to replay your work on top of it ...
    Applying:1

rebase 如果自动解决不了冲突，会提示需要手工解决冲突才能继续你当前的提交

    $ git pull --rebase
    Auto-merging band.py
    CONFLICT (content): Merge conflict in band.py
    error: could not apply 94950e8... "提交点注释"
    hint: Resolve all conflicts manually, mark them as resolved with
    hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
    hint: You can instead skip this commit: run "git rebase --skip".
    hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
    Could not apply 94950e8... "提交点注释"

git pull --rebase 自动使用 rebase，发现冲突后，会进入 rebase confict 状态，给你准备好冲突文件，直接编辑解决冲突吧，详见下面章节 [示例：rebase 处理合并冲突]。

##### 示例：rebase 处理合并冲突

本地从远程更新代码，操作步骤根据章节 [更新本地分支的操作步骤]，不直接 git pull --rebase，以便可以根据情况来选择合并策略。

先拉取远程

    git fetch

查看当前状态，提示有冲突，并建议用 pull

    $ git status
    On branch master
    Your branch and 'origin/master' have diverged,
    and have 1 and 1 different commits each, respectively.
    (use "git pull" to merge the remote branch into yours)

    nothing to commit, working tree clean

pull 是使用 merge 方法分叉合并，这里我们不用。先查看具体差异，对比下本地和远程，其中 a 是本地，b 是远程，减号表示本地相对远程被删除的内容，+表示远程相对本地新增的内容，没有加减号的表示无差异

    $ git diff ..origin/master
    diff --git a/newhot.txt b/newhot.txt
    index 15cd1bb637..c4af76e0e4 100644
    --- a/newhot.txt
    +++ b/newhot.txt
    @@ -1,14 +1,15 @@
    -2add
    -newhostfix
    +eee
    +111add
    iiiii
    +111add
    kk
    -llllllllll2add  注意：diff发现有区别，但是后面的rebase认为可以直接追加不是冲突
    +llllllllll
    mmm
    -
    -2dd
    +111add

执行 rebase，git 会修改冲突的文件内容，同时列出二者并标记差异，便于你直接编辑

    $ git rebase
    Auto-merging newhot.txt
    CONFLICT (content): Merge conflict in newhot.txt
    error: could not apply 57d79f7ec7... 2add for conflict
    hint: Resolve all conflicts manually, mark them as resolved with
    hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
    hint: You can instead skip this commit: run "git rebase --skip".
    hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
    Could not apply 57d79f7ec7... 2add for conflict

再看看状态，会提示冲突详情

    $ git status
    interactive rebase in progress; onto e7f51c588e
    Last command done (1 command done):
    pick 57d79f7ec7 2add for conflict
    No commands remaining.
    You are currently rebasing branch 'master' on 'e7f51c588e'.
    (fix conflicts and then run "git rebase --continue")
    (use "git rebase --skip" to skip this patch)
    (use "git rebase --abort" to check out the original branch)

    Unmerged paths:
    (use "git restore --staged <file>..." to unstage)
    (use "git add <file>..." to mark resolution)
            both modified:   newhot.txt

    no changes added to commit (use "git add" and/or "git commit -a")

其中 “Unmerged paths” 会提示冲突文件，需要手工编辑该文件解决冲突，方法参见章节 [冲突文件的格式]

    $ cat newhot.txt
    <<<<<<< HEAD  这后面是远程的
    bbbbbb
    c111modecc
    eee
    =======  这后面是本地的
    2add
    newhostfix
    aaaaa
    2add
    >>>>>>> 57d79f7ec7 (2add for conflict) 至此结束
    kk                                     \
    llllllllll2add                         ---- 这三行没冲突
    mmm                                    /
    <<<<<<< HEAD  HEAD  这后面是远程的
    111add
    =======  这后面是本地的

    2dd
    >>>>>>> 57d79f7ec7 (2add for conflict) 至此结束

改完了，diff 看看区别，一个是合并列出了本地commit和远程commit的内容，一个是列出的你当前做的修改，加号表示保留的内容，减号表示删除的内容，没有符号表示保持原样。

    $ git diff
    diff --cc newhot.txt
    index c4af76e0e4,15cd1bb637..0000000000
    --- a/newhot.txt
    +++ b/newhot.txt
    @@@ -1,15 -1,14 +1,5 @@@
    - bbbbbb
    - c111modecc
    - eee
    - 111add
    -llllllllll2add
    --mmm
    - 111add
    -
    -2dd
    ++小孩子才做选择题，我选择全都不要
    ++啊啊啊啊
    ++吧吧吧吧
    ++从从从从
    ++的的的的

冲突解决后，添加该文件以便 rebase 可以更新进度

    git add .  # 注意如果有无关文件就别用 . 通配了，还是指定具体文件名比较好

这次提示没有冲突了，会提示 rebase 的下一步操作

    $ git status
    interactive rebase in progress; onto e7f51c588e
    Last command done (1 command done):
    pick 57d79f7ec7 2add for conflict
    No commands remaining.
    You are currently rebasing branch 'master' on 'e7f51c588e'.
    (all conflicts fixed: run "git rebase --continue")

    Changes to be committed:
    (use "git restore --staged <file>..." to unstage)
            modified:   newhot.txt

按提示执行命令，会直接提示更新提交点，给出的是原来的注释，但是 commit id 已经变更了

    $ git rebase --continue
    [detached HEAD 134a0adfe1] tea2我删掉了123，应该会冲突,看看到底把谁的 commit id 给更新了
    1 file changed, 2 insertions(+)
    Successfully rebased and updated refs/heads/master.

    $ git log --oneline --graph
    * 134a0adfe1 (HEAD -> master) rebase update 2add for conflict
    * e7f51c588e (origin/master) 111mod 111add
    * 3982bb09ba suibianshashi

也就是说，rebase 更新了你本地的提交点（之前的提交点丢弃，搞了个新的提交点），把这个提交点连接到你拉取下来的远程的提交点了。所以，如果你希望保留本地 commit id 以便查看历史，那么应该选择分叉合并的策略。

查看状态，提示可以推送远程了

    $ git status
    On branch master
    Your branch is ahead of 'origin/master' by 1 commit.
    (use "git push" to publish your local commits)

    nothing to commit, working tree clean

你的本地提交点被rebase更新，直接连接到原远程的提交点，起到了拉直效果，所以只是新增了1个commit。

没问题，推送远程

    $ git push
    Enumerating objects: 10, done.
    Counting objects: 100% (10/10), done.

#### 拉shi往回缩：rebase本地分支以后报错了

    在本地库更改远程仓库已有的提交记录，就是你的不对

简单点，参见章节 [基于文件的撤销大法]。

你的本地分支已经推送了远程，但是你又重新 rebase 了本地的几个提交，然后不管你想再 push 还是 pull，都会被远程库拒绝。

    git 会提示做 `push -f` 强行变更远程库，如果有队友也在同步远程库，这样做麻烦就大了，参见章节 [遇到提示 push -f 的时候多想想]。

由于 rebase 会重写历史提交记录，因此你的本地和你的远程的历史提交记录是不同的，同样产生了分叉:

rebase之前的git提交历史树:

    ... ---- A ---- B  master, origin/master
              \
               C  branch_xxx, origin/branch_xxx

执行rebase之后的git提交历史树:

    ... ---- A ---------------------- B  master, origin/master
              \                        \
               C  origin/branch_xxx     C` branch_xxx

这时候，你必须确定你是处于上面描述的情况，不好的解决方案就是强制push到你的origin上游

    git push -f origin branch_xxx

这样直接连接指定的提交点，之前的那些提交记录被忽略掉。但是，只要别人也同步了远程库，他的本地是有你的提交的，他只要推送就会再覆盖回去，而且你的 push -f 会覆盖掉他的提交点，导致他莫名的发现自己的提交消失了。参见章节 [遇到提示 push -f 的时候多想想]。

没有隐患的解决办法就是不要强行推送，回退你的rebase，参见章节 [远程库也有的提交记录，如何回退]。

## 分支变基rebase：交互式压缩提交点

    变基会改变合并进来的提交记录的 hash 值，而 git 识别提交记录是以 hash 值为准的，务必要确认你改变的提交记录，没有别人依赖。

    通常情况下，不要变更远程分支的提交记录，否则会制造混乱，参见章节 [遇到提示 push -f 的时候多想想]

rebase 除了合并多个分支外，还有个整理单个分支提交记录的功能。

    https://zhuanlan.zhihu.com/p/249231960
        https://opensource.com/article/20/7/git-best-practices

    https://blog.csdn.net/lucky9322/article/details/72790034

    https://blog.csdn.net/raykwok1150/article/details/106572935

变基 rebase 一般用于，开发分支保留所有提交点，但在合并到主干分支前，精简合并相关提交点以明确意图，最终合并到主干分支后，使提交记录不显得那么混乱

    因为在功能分支上开发时，即使再小的修改也可以作为一个提交。但是，如果每个功能分支都要产生几十个提交，那么随着不断地增添新功能，master 分支的提交数终将无谓地膨胀，查看提交记录非常不方便。

    通常来说，每个功能分支只应该往 master 中增加一个或几个提交。为此，你需要将多个提交压扁（Squash）成一个或者几个带有更详细信息的提交，然后才可以推送远程，或合并到 master 分支。

    开发分支合入主干分支的内容，一般选择 rebase，但是如果项目组无法接受开发分支提交记录的hash全变，则只能选择分叉合入。

不适用 rebase 的场景

    rebase 会改变变基点提交记录之后所有提交记录的 hash 值：它把你本地的提交记录接续在来自远程的提交记录之后，会改变你本地提交记录的hash值。

    在实际工作中，分支的重整、合并、cherry-pick 经常发生，有时候还会撤销修改。对开发组来说，提交记录的 hash 值改变，大家都改动同一文件会经常出现合并冲突，如果会带来管理混乱，那就尽量缩小 rebase 的范围，暂时用 merge 的默认操作，期间大家的修改以文件内容为准，各种菱形分叉可能比较难读。等到到开发稳定后，管理可控时再对提交记录做精简整合，在测试分支或合入主干前清理提交记录。

    如果只是想更改提交记录的注释信息，但是又不想变更它的 hash 值，用 git notes 命令而不是 git rebase

        git notes add -m 'Your can see me in git show command' 72a144e2

NOTE: git rebase 切忌修改已经记录在远程库的提交记录！

+ 做压缩提交变基的限制：

    只能在本地分支未推送远程仓库**之前**做 rebase，参见章节[重要：推送远程前的检查]。

    只能在合并到别的分支**之前**做 rebase。

    别的分支合并过来的 commit **不要**做 rebase。

合并本地的提交记录，酌情适量的原则：

    合并后，可以单独查找某个功能点或便于 cherrypick 某功能点

命令：

    # 对该点之后的所有 commit 进行变基
    git rebase -i <after-this-commit>

    NOTE: rebase 变基注意尽量不要删提交点，只做压缩合并

    NOTE: rebase 范围要精确，不许用大致范围：

        # 起点是最近二十个提交
        git rebase -i HEAD~20

    否则即使你只改动了最近的2个提交点，但是近 20 个提交记录都会被 git 更新（默认的pick操作），可能导致出现不必要的合并冲突要解决。

操作：

当这条命令执行后，将自动调用 vi 编辑器打开一个提交列表，每行一个提交记录（用 # 开头的行是注释，空行不需要操作）。

提交记录行的首列单词，控制了 rebase 如何进行处理：

    缩写 p --- pick：保留该commit

    缩写 r --- reword：保留该commit，但我需要修改该commit的注释

    缩写 e --- edit：保留该commit, 但我要停下来修改该提交(不仅仅修改注释)

    缩写 s --- squash：将该commit和前一个commit合并，也就是说远的提交无法被压缩合并

    缩写 f --- fixup：将该commit和前一个commit合并，但我不要保留该提交的注释信息

    缩写 x --- exec：执行shell命令

    缩写 d --- drop：我要丢弃该commit

    首列单词默认都是 pick，修改时使用缩写替换即可

最常用的操作包括遴选（pick）或压扁（squash）在内的数种方式编辑它

    “pick” 缩写 p     保留这个提交

    “squash” 缩写 s   将这个提交合并到前一个提交

使用这些方法，你就可以将多个提交合并到**前一个提交**之中。所以最近的一个提交不能是 s，之前的多个提交任意 p 或 s 皆可。
这通常用于清理不重要的提交信息的机会（例如，带错字的提交），当然，前提是这些提交都没有在远程服务器上存在。

编辑器保存退出后，git 会再自动打开 vi 进行注释信息的编写，默认是你合并的几个提交记录的注释，其它用 # 号开头的行和空行不需要处理。

再次保存退出，就完成了 rebase 操作。

先再次看看提交记录并做最终的修改：

    git log --graph --oneline

然后再做推送。

### 示例

先做提交或储存，保证要修改的分支没有暂存内容才能继续

查看当前分支的提交commit，以便选择范围

    git log --oneline --graph

        * cf83e50 (HEAD -> master, origin/master, origin/HEAD) 第四次添加开始回退‘ ’ ;
        * 61ce6d7 第三次添加也是要丢
        * b263d60 第二次添加作为要丢的
        * 0a2883c 第一次添加作为基础
        * a952e5b mod cpp

第一次用需要指定分支，因为我的fea_stragy没有远程分支

    # git rebase ：There is no tracking information for the current branch.
    git rebase fea_stragy

列出该点之后的所有commit，调用 vi 交互式进行编辑

    git rebase  -i a952e5b

git会自动调用 vim 等编辑器打开一个文本文件，显示顺序是从老到新，最新的在下面，示例内容如下

    pick 0a2883c 第一次添加作为基础
    pick b263d60 第二次添加作为要丢的
    pick 61ce6d7 第三次添加也是要丢
    pick cf83e50 第四次添加开始回退

    # 只编辑上面的提交记录行的首列单词即可，比如 pick 改成 s 等
    # 后面是大段的说明，用 # 开头的行、空行的都不用管
    # ...
    # ...

注意：最老的 0a2883c 这行不能 squash，否则 error: cannot 'squash' without a previous commit

编辑 b263d60 和 61ce6d7 那行，把 'pick' 改成 's'

    pick 0a2883c 第一次添加作为基础
    s b263d60 第二次添加作为要丢的
    s 61ce6d7 第三次添加也是要丢
    pick cf83e50 第四次添加开始回退

    # 后面是大段的说明，用 # 开头的、空行的都不用管
    # ...
    # ...

编辑完成 :wq 退出，

然后 git 会自动再打开个 vim 窗口，让你修改合并后的提交点的注释，默认是把合并的几个提交点的注释都摆上了（用 # 开头的行、空行都不用管），可以酌情修改，不改就直接 :q，示例如下：

    # This is a combination of 3 commits.
    # This is the 1st commit message:

    第一次添加作为基础

    # This is the commit message #2:

    第二次添加作为要丢的

    # This is the commit message #3:

    第三次添加也是要丢

    # Please enter the commit message for your changes. Lines starting
    # with '#' will be ignored, and an empty message aborts the commit.
    # ...

操作完会提示新的commit点的hash值

    $ git rebase -i a952e5b
    [detached HEAD 75cc2d9] 第一次添加作为基础
    Date: Wed Feb 15 16:53:13 2023 +0800
    1 file changed, 4 insertions(+)
    Successfully rebased and updated refs/heads/master.

再看提交记录，对照之前会看到rebase列出的那些提交点的 hash 值都变了

    git log --oneline --graph

    * 20a28f0 (HEAD -> master) 第四次添加开始回退
    * 75cc2d9 第一次添加作为基础
    * a952e5b mod cpp

git status 看看提示，还有什么需要解决的会提示

    $ git status
    On branch master
    Your branch and 'origin/master' have diverged,  提示冲突了，因为你的远程库的提交记录跟你本地的对不上了
    and have 2 and 4 different commits each, respectively.
    (use "git pull" to merge the remote branch into yours)

你当前的分支无法再推送或拉取远程了。

解决办法

    见章节 [如何回退]，效果就是退回原样

    见章节 [解决合并冲突conflicts]，效果就是文件内容没变，你的提交记录再精简的基础上又变多了

所以，rebase的一个前提：不要改动远程已经存在的提交记录。

如果有人告诉你 git push -f，麻烦更多，参见章节 [远程库也有的提交记录，如何回退]。

### 本地分支多 commit --amend 压缩多余的提交点

NOTE: amend 要在 git push 推送远程之前做，已经推送远程的 commit 就不要追加！

追加你的修改到最近的commit，不制作新的commit（其实commit已经变了），适合本次和上次提交内容相近的场景

    git add .
    git commit --amend  # 等价于 git rebase -i HEAD~2

### 第一次做rebase的时候遇到问题了： 622c01c没关联到 fea_stragy 分支

    $ git switch master
    Warning: you are leaving 1 commit behind, not connected to
    any of your branches:

    622c01c 一般性的一些注释

    If you want to keep it by creating a new branch, this may be a good time
    to do so with:

    git branch <new-branch-name> 622c01c

如果忘记了刚才做的操作的commit点，用 git reflog 查看自己的操作记录

    git reflog show HEAD@{now} -10

        112bd52 (HEAD -> fea_stragy) HEAD@{Wed Sep 16 15:36:19 2020 +0800}: checkout: moving from master to fea_stragy
        55d1836 (master) HEAD@{Wed Sep 16 15:35:04 2020 +0800}: checkout: moving from 622c01cf988f0af3872daa14da3b3e5d257c5772 to master
        622c01c HEAD@{Wed Sep 16 14:54:41 2020 +0800}: rebase (squash): 一般性的一些注释
        588e326 HEAD@{Wed Sep 16 14:54:41 2020 +0800}: rebase (start): checkout 1ae0123
        112bd52 (HEAD -> fea_stragy) HEAD@{Wed Sep 16 14:29:16 2020 +0800}: rebase (start): checkout 112bd52
        112bd52 (HEAD -> fea_stragy) HEAD@{Wed Sep 16 14:26:46 2020 +0800}: rebase (finish): returning to refs/heads/fea_stragy
        112bd52 (HEAD -> fea_stragy) HEAD@{Wed Sep 16 14:26:46 2020 +0800}: rebase (start): checkout fea_stragy
        112bd52 (HEAD -> fea_stragy) HEAD@{Wed Sep 16 14:25:31 2020 +0800}: commit: 1
        588e326 HEAD@{Wed Sep 16 14:24:40 2020 +0800}: checkout: moving from master to fea_stragy

解决办法1：新建个临时分支合并进来

    git branch tmp_branch 622c01c
    git checkout fea_stragy
    git merge tmp_branch
    git branch -d tmp_branch

解决办法2：cherry-pick

    git checkout fea_stragy
    git cherry-pick 622c01c

解决办法3：git reset

    git reset --hard 622c01c

解决办法4： git merge 合并被删除的记录

    git merge 622c01c

## 补丁神器 cherry-pick

git、svn、hg 等基于 snapshot 的版本控制系统，以 snapshot 的方式存储当前版本。虽然这一类版本控制系统也会用到 patch，不过它们只有在需要时才计算出 patch 文件来。

patch 是这一类版本控制系统的产物，而非基石。（注意：切勿混淆 commit 和 snapshot 的概念，两者并不等价。Git 显然不会在每个 commit 中存储对整个仓库的 snapshot，这么做太占空间。）

事实上，Git 的 commit 只包含指向 snapshot tree 的指针，参见：Git-内部原理-Git-对象 <https://git-scm.com/book/en/v2/Git-Internals-Git-Objects>）

git diff 输出格式就是个 patch 文件，参见章节 [制作补丁]，git cherry-pick 则会把指定的提交点所作的修改以 patch 的形式应用到目标分支上。

示例：master 分支上修改了一个 bug，要在 dev 分支上也做一遍修复

当前分支情况如下

    $ git branch -avv
    master                 4c805e2 [origin/master: behind 1] ddd 333
    * dev                  b22c20fc8d hotfix2
    remotes/origin/def_xxx b414ac95d4 功能3
    remotes/origin/hotfix  7cabce404f res me
    remotes/origin/master  881ccdca75 ddd.txt 444

先确定 master 分支上哪个修改的提交记录的 commit id

    git log --graph --oneline master

假设是 4c805e2 fix bug 101 这个提交，我们只需要把 4c805e2 所做的 “修改” 复制到 dev 分支。

因为我们只想复制 4c805e2 这个提交所做的 “修改”，既不是合并这个提交点，也不是把整个 master 分支 merge 过来。为了方便操作，Git 专门提供了一个 cherry-pick 命令，让我们能复制一个特定的提交的操作到当前分支：

    $ git cherry-pick 4c805e2
    [master 1d4b803] fix bug 101
    1 file changed, 1 insertion(+), 1 deletion(-)

Git 自动给 dev 分支做了一次提交，注意这次提交的commit是 1d4b803，它并不同于master分支的 4c805e2，因为这两个commit只是改动相同，但确实是两个不同的commit。用 git cherry-pick，我们就不需要在 dev 分支上手动再把修bug的过程重复一遍。

潜在问题来了：

    相同的 cherry-pick，在每个分支上操作后的 hashid 是不一样的。如果有分支应用后又 revert 过这个补丁，只要合入另一个应用了这个补丁的分支，这补丁就又回来了，这分支还不知道。。。

这是 git 的一个痛点，参见章节 [竞品 -- 基于文件差异(patch)的源代码管理系统]。

## 使用标签 tag

标签总是和某个提交记录commit挂钩，默认操作的标签都是指的本地。

如果这个commit既出现在master分支，又出现在dev分支，那么在这两个分支上都可以看到这个标签。

新增附注标签（annotated）

    git tag -a v1.1 -m"新增xxx功能"

    # 在某次提交上创建标签
    git tag v0.2 -m "version 0.2" a9f5115

新增轻量标签（lightweight）

    git tag v1.1-bw

查看标签

    git tag

查看标签对应提交记录的信息

    git show v1*

删除标签

    git tag -d v1.1-bw

删除远程标签

    git push origin --delete tag v1.1-bw

    git push origin :refs/tags/v1.1-bw

    远程仓库的标签删除后，本地仓库无法通过命令获取到删除的信息，只能通过 `git ls-remote` 获取到远程仓库的标签，与本地仓库的标签比对找到多余的标签，然后手动执行 `git tag -d [标签名]` 进行删除。

标签推送远程需要显式声明，推送标签并不会区分轻量标签和附注标签

    # 推送指定标签
    git push origin v1.1

    # 推送全部标签
    git push origin --tags

    # 推送，包括标签
    git push origin master --tags

标签拉取自远程时包括需要显式声明，拉取标签并不会区分轻量标签和附注标签

    # 拉取远程全部标签
    git fetch origin --tags

    # 拉取远程全部标签
    git pull --tags

    # 拉取，包括标签
    git pull origin master --tags

查看远程仓库的标签

    git ls-remote --tags

标签的一大用途，是从指定标签位置检出分支

    比如某历史版本需要重建，排除bug，我们就从标签位置拉分支

        # 切换到标签位置的提交记录，此时属于 detached 状态，无法保存修改
        git checkout milestone-v1.2.3

        # 从这个提交记录的位置创建一个新分支
        git checkout -b new-branch-name

       一行命令搞定:

        git checkout -b new-branch-name milestone-v1.2.3

## -------- 日常编辑常用 --------

## 文件改名/移动

Git 管理仓库中的文件，是根据文件名来跟踪文件的

    如果你在本地直接用操作系统的 `mv` 命令改名一个文件，git 会认为你删掉了一个文件，新增了一个文件。运行命令 `git status` 会看到 deleted 了原文件， untracked 新文件。

    如果你提交了这个修改，你会发现新文件没有之前源文件的提交记录，历史记录全丢了！

所以，在 git 中重命名文件或文件夹应该使用 `git mv` 命令，这样才会保留你的提交记录

    git mv -v oldfile newfile

    $ git status
    Changes to be committed:
    (use "git reset HEAD <file>..." to unstage)

            renamed:    oldfile -> newfile

    # 重命名之后正常 commit push 就可以了
    $ git commit -m "rename oldfile to newfile"

## 使用储藏 stash

当在一个分支的开发工作未完成，却又要切换到另外一个 hotfix 分支进行开发的时候，当前的分支不 commit 的话 git 不允许 checkout 到别的分支，而代码功能不完整随便 commit 是没有意义的。

一般使用，`git stash push` 和 `git stash pop` 这两条就够了。

如果是新增的文件，直接执行 stash 是不会被存储的，因为没有在 git 版本控制中的文件，是不能被 git stash 存起来的，所以先执行下 `git add` 再储存就可以了。

详细用法

    （1）git stash push -m "save message"  : 执行存储时，添加备注，方便查找。只有 git stash 也可以，但查找时不方便识别。

    （2）git stash list  ：查看stash了哪些存储

    （3）git stash show ：显示哪些文件做了改动，默认show第一个存储，如果要显示其他存贮，后面加stash@{$num}，比如第二个 git stash show stash@{1}

    （4）git stash show -p : 显示改动明细，默认show第一个存储，如果想显示其他存存储，命令：git stash show  stash@{$num}  -p ，比如第二个：git stash show  stash@{1}  -p

    （5）git stash pop ：命令恢复之前缓存的工作目录，将缓存堆栈中的对应stash删除，并将对应修改应用到当前的工作目录下,默认为第一个stash,即stash@{0}，如果要应用并删除其他stash，命令：git stash pop stash@{$num} ，比如应用并删除第二个：git stash pop stash@{1}

    （6）git stash apply :应用某个存储,但不会把存储从存储列表中删除，默认使用第一个存储,即stash@{0}，如果要使用其他个，git stash apply stash@{$num} ， 比如第二个：git stash apply stash@{1}

    （7）git stash drop stash@{$num} ：丢弃stash@{$num}存储，从列表中删除这个存储

    （8）git stash clear ：删除所有缓存的stash

当你运行 git stash 命令时，Git 会根据你的更改创建一些提交，并用一个名为 mystash 的引用来标记它们（在 .git/refs/stash 目录下），查看 mystash 引用的日志：

    $ git log mystash --oneline

### 找回误删的 stash 数据

本想 git stash pop ，但是输入成 git stash drop

1.查找所有不可访问的对象

    git fsck --unreachable

2.逐个确认该对象的代码详情，找到自己丢失的那个

    git show a923f340ua

3.恢复找到的对象

    git stash apply 95ccbd927ad4cd413ee2a28014c81454f4ede82c

## 查看提交记录

    https://www.cnblogs.com/bellkosmos/p/5923439.html

注意：

    git log 的很多用法也适用于 git diff，参见章节 [显示差异 diff]。

    查日志做对比之前，可以先拉取所有分支的远程库，以保证数据最新

        git fetch -all

查看 <指定文件、分支的> 提交记录

    git log <file/branch> --graph --oneline

    查看所有最近的提交记录，不在本分支上的也显示，经常用于改动之前的保留现场
    git reflog

显示提交记录跟之前一条的差异diff

    git log -p

查看在此提交点之前的所有记录

    git log <commit id>

    # 指定这个提交点，也可同时限定文件
    git show <commit id> <file>

查看本地远程库的提交记录，用于本地库从远程更新代码前查看是否有合并冲突

    # 显示远程库的完整提交记录
    # hash 太长用 --abbrev-commit
    git log origin/master --graph --oneline

    # 查看分歧点以来的提交记录
    #git log HEAD..origin/master --graph --oneline
    git log ..origin/master --graph --oneline

对比查看两个分支的提交记录的差异，用于两分支合并查看差异

    # 注意分支名的顺序，这里是求前者比后者少的部分
    git log master..feat --graph --oneline

    # 效果等同，但是顺序倒过来了，这里是求前者比后者多的部分
    git log feat ^master --graph --oneline

    # 不知道谁提交的多谁提交的少，单纯显示两分支的差
    # git log feat...master --graph --oneline
    # 加个方向标识 < 开头的是左边的，> 开头的是右边的
    git log --left-right feat...master --graph --oneline

某个提交记录归属于哪些分支

    git branch --contains <commit> --all

## 显示差异 diff

`git diff` 默认 -p 参数就是生成补丁格式，因为调用的 diff 工具，相当于 `diff -u`。

    显示摘要加参数 --stat

用于工作区(Working tree)、暂存区(staged)、仓库区(HEAD)三个区域的交叉对比，主要的应用场景：

    工作区中的更改尚未进行下一次提交

    暂存区和最后一次提交之间的变化

    查看已经 git add ，但没有 git commit 的改动

    自上次提交以来工作区中的更改

比对工作区与暂存区的差异

    git diff

    在 vs code 里，就是你点击源代码管理树中 '更改' 项目下的文件，列出来的差异。

比对工作区与仓库的差异

    git diff HEAD

比对暂存区与仓库的差异

    git diff --staged 或 git diff --cached

    显示即将被提交的内容，就是在你做了 `git add` 后，预测如果要做 `git commit` 时会提交的内容有哪些。

    在 vs code 里，就是你点击源代码管理树中 '暂存的更改' 项目下的文件，列出来的差异。

    只要你没有做 `git commit`，当前的所有改动（含暂存区的）都会体现在工作区，直接跟仓库（HEAD）对比可以看看你的修改的总体效果。

可以看出，修改完成后还没有执行 `git add`，做 `git diff HEAD` 显示的结果，跟执行了 `git add` 后行 `git diff --staged`，看到的结果是一样的。

注意：单独存在工作区或暂存区时，这些命令的显示效果有相同之处，见下。

容易理解的情况

    暂存区有内容，工作区有内容：

        git diff 显示工作区和暂存区的差异

        git diff HEAD 显示工作区和仓库区的差异

        git diff --staged 显示暂存区和仓库区的差异。

不容易理解的情况

    暂存区有内容，工作区无内容：

        git diff 无差异

        git diff HEAD 的结果与 git diff --staged 一致，是暂存区和仓库区的差异

        原因在于“工作区与暂存区的内容一致”

    暂存区无内容，工作区有内容：

        git diff 的结果与 git diff HEAD 一致，是工作区和仓库区的差异

        git diff --stage 无差异

        原因在于“暂存区与仓库区的内容一致”

### 示例

比较两个分支（上最新的提交）的差别

    # 或 git diff topic..master
    git diff topic master

    # 对比本地库和远程库
    git diff ..origin/master

比较指定文件的最新版本与旧提交中的版本之间的差异

    git diff <commit_id> <file_path>

对比最近的两次提交记录

    git diff HEAD^ HEAD

    # 也可以让 git log 显示提交记录跟之前一条的差异diff
    git log -p <commit id>

比较两个提交记录之间的差异

    git diff SHA1 SHA2

比较自 topic 和 master 分别开发以来，master 分支上的变更。

    git diff topic...master

    就是说两个分支分叉延续了，看看差异，一般用于合并之前查看情况。

查看当前分支和另一个叫’test‘分支的差别

    git diff test

显示当前分支的子目录 lib 与上次提交之间的差别

    git diff HEAD -- ./lib

查看另一个分支上文件与当前分支上文件的差异

    git diff <another_branch> some-filename.js

### 查看尚未合并的变更

如果你曾经与很多小伙伴工作在同一个持久分支上，也许会有这样的经历，父分支（例如：master）上的大量合并同步到你当前的分支。这使得我们很难分辨哪些变更发生在主分支，哪些变更发生在当前分支，尚未合并到 master 分支。

    git log --no-merges master..

    --no-merges 标志意味着只显示没有合并到任何分支的变更

    master.. 选项，意思是指显示没有合并到master分支的变更（在master后面必须有..）。

查看一下尚未合并的文件变更

    git show --no-merges master..

    # 输出结果相同
    git log -p --no-merges master..

### 没点，俩点，仨点的区别

    https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection#_triple_dot

    https://stackoverflow.com/questions/4944376/how-to-check-real-git-diff-before-merging-from-remote-branch

You can use various combinations of specifiers to git to see your diffs as you desire (the following examples use the local working copy as the implicit first commit):

假设某人在远程存储库中进行更改，即修改了分支并提交到远程库，下述3个使用方法有不同的效果

1.您在本地可能不会看到任何更改

    git diff origin/master

This shows the incoming remote additions as deletions; any additions in your local repository are shown as additions.

2.可以看到更改，俩点让 Git 选出在一个分支中而不在另一个分支中的提交

    # 完整写法是 gid diff <本地分支>..<远程分支>
    git diff ..origin/master

Shows incoming remote additions as additions; the double-dot includes changes
committed to your local repository as deletions (since they are not yet pushed).

For info on ".." vs "..." see as well as the excellent documentation at [git-scm revision selection: commit ranges Briefly] <https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection#Commit-Ranges>, for the examples above, double-dot syntax shows all commits reachable from origin/master but not your working copy. Likewise, the triple-dot syntax shows all the commits reachable from either commit (implicit working copy, remote/origin) but not from both.

例如

    git fetch; git diff ..origin/master

    # 简单点看提交记录的差别，以下二者结果不同
    git log --left-right --oneline dev..master
    git log --left-right --oneline master..dev

您将看到本地git存储库的内容与远程存储库中的不同之处。您将看不到本地文件系统中或索引中的任何更改。

3.三点语法显示从任一提交（隐式工作副本、远程/原点）可以到达的所有提交，但不能同时来自两个提交。选择出被两个引用之一包含但又不被两者同时包含的提交。

这将区分来自远程/分支的更改，并忽略来自当前 HEAD 的更改。

    git diff ...origin/master

    # 简单点看提交记录的差别，以下二者结果相同
    git log --left-right --oneline dev...master
    git log --left-right --oneline master...dev

Shows incoming remote additions as additions; the triple-dot excludes changes committed to your local repository.

### HEAD、HEAD^、HEAD~ 的含义

    https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection#_ancestry_references

HEAD^ 和 HEAD~ 有区别，但不是 merge 多个分支的情况下无差别

    https://stackoverflow.com/questions/57938466/git-what-is-difference-between-tilde-and-caret

#### HEAD

HEAD 指向当前所在分支提交至仓库的最新一次的 commit

    # 使用最新一次提交重制暂存区
    git reset HEAD -- filename

    # 使用最新一次提交重制暂存区和工作区
    git reset --hard HEAD

    # 将 commit log 回滚一次 暂存区和工作区代码不变
    git reset --soft HEAD~1

#### HEAD~{n}

~ 是用来在当前提交路径上回溯的修饰符.

HEAD~{n} 表示当前所在的提交路径上的前 n 个提交（n >= 0）：

    HEAD = HEAD~0
    HEAD~ = HEAD~1
    HEAD~~ = HEAD~2
    HEAD{n个~} = HEAD~n

#### HEAD^n

^ 是用来切换父级提交路径的修饰符。

当我们始终在一个分支比如 dev 开发/提交代码时，每个 commit 都只会有一个父级提交，就是上一次提交。

但当并行多个分支开发，feat1, feat2, feat3，完成后 merge feat1 feat2 feat3 回 dev 分支后，此次的 merge commit 就会有多个父级提交。

父级 一词本身就代表回溯了 1 次

HEAD 的 第一个父级

    # 第一个父级提交 即 feat1 的最近第1次的提交
    $ git show HEAD^
    feat1 3 foo_feat1

    # 第一个父级提交的上1次提交 即 feat1 的最近第2次的提交
    $ git show HEAD^~1 / git show HEAD^^
    feat1 2 foo_feat1

    # 第一个父级提交的上2次提交 即 feat1 的最近第3次的提交
    $ git show HEAD^~2 / git show HEAD^^^
    feat1 1 foo_feat1

HEAD 的 第二个父级

    # 第二个父级提交 即 feat2 的最近第1次的提交
    $ git show HEAD^2
    feat2 2 foo_feat2

    # 第二个父级提交的上1次提交 即 feat2 的最近第2次的提交
    $ git show HEAD^2~1 / git show HEAD^2^
    feat2 1 foo_feat2

    # 第二个父级提交的上2次提交 即 feat2 的最近第3次的提交
    $ git show HEAD^2~2 / git show HEAD^2^^
    feat2 add foo_feat2

HEAD 的 第三个父级

    # 第三个父级提交 即 feat3 的最近第1次的提交
    $ git show HEAD^3
    feat3 2 foo_feat3

    # 第三个父级提交的上1次提交 即 feat3 的最近第2次的提交
    $ git show HEAD^3~1 / git show HEAD^3^
    feat3 1 foo_feat3

    # 第三个父级提交的上2次提交 feat3 的最近第3次的提交回归到了主线上
    $ git show HEAD^3~2 / git show HEAD^3^^
    master foo 2

一般用于指向两分支分叉的合并点之前的某分支的点，参见章节 [git reset commit] 中的 --hard 部分内容。

#### 示例

    # 当前提交
    HEAD = HEAD~0 = HEAD^0

    # 主线回溯
    HEAD~1 = HEAD^ 主线的上一次提交
    HEAD~2 = HEAD^^ 主线的上二次提交
    HEAD~3 = HEAD^^^ 主线的上三次提交

    # 如果某个节点有其他分支并入
    HEAD^1 主线提交（第一个父提交）
    HEAD^2 切换到了第2个并入的分支并得到最近一次的提交
    HEAD^2~3 切换到了第2个并入的分支并得到最近第 4 次的提交
    HEAD^3~2 切换到了第3个并入的分支并得到最近第 3 次的提交

    # ^{n} 和 ^ 重复 n 次的区别
    HEAD~1 = HEAD^
    HEAD~2 = HEAD^^
    HEAD~3 = HEAD^^^

    # 切换父级
    HEAD^1~3 = HEAD~4
    HEAD^2~3 = HEAD^2^^^
    HEAD^3~3 = HEAD^3^^^

## 制作和应用补丁

    https://cloud.tencent.com/developer/article/1423939

    https://www.jianshu.com/p/ec04de3f95cc

最简单的方式：在现有分支基础上，换个目录生成新的分支进行修改，两个分支分别位于两个目录下，运行 GNU diff 命令即可生成差异文件作为补丁，应用补丁使用 GNU patch 命令即可。

Git 提供了两种补丁方式

    一种是通过 git diff 生成的 .diff 文件，这个其实就是调用的 GNU diff 命令，生成的就是 unix 标准的 diff 格式文件。

    第二种是通过 git format-patch 生成的 .patch 文件。

也就是说，章节 [显示差异 diff] 里用到的各种输出，都是可以作为补丁的。

一、git diff

通过 git diff 生成的 .diff 文件只是记录文件改变的内容，不带有提交记录的信息

    # 修改没有提交，只是在暂存区
    git diff Test.java >your.diff  # 单个文件的修改生成补丁
    git diff           >your.diff  # 所有文件的修改生成补丁

    # 修改提交了：指定对比两个 commit id 的差异生成补丁
    git diff commit_id_source commit_id_target >your.diff

二、git format-patch

比对两个分支生成补丁。

通过 git format-patch 生成的 .patch 文件除了改变的内容，还带有提交记录的信息。每个提交记录对应一个补丁文件

    # 某次提交（含）之前的几次提交，如果时 -1 就是仅针对某个提交生成补丁
    git format-patch [commit id] -n >your.patch

    # 某两次提交之间的所有差异生成补丁
    git format-patch commit_id_start..commit_id_end >your.patch

    # 当前分支所有超前 master 分支的提交
    git format-patch -M master

    # 某次提交以后的所有提交
    git format-patch [commit id]

    # 从根到指定提交的所有提交
    git format-patch --root [commit id]

git format-patch 生成的补丁文件默认从1开始顺序编号，并使用对应提交信息中的第一行作为文件名。如果使用了-- numbered-files 选项，则文件名只有编号，不包含提交信息；如果指定了–stdout选项，可指定输出位置，如当所有patch输出到一个文件；可指定 -o 参数。

三、在其它的机器上应用补丁

    # 检查patch文件
    git apply --stat   xxx.patch

    # 先检查这个补丁操作是否会报错，主要关注合并冲突
    git apply --check /path/to/your.patch

    # 有合并冲突，则先合入 patch 中不冲突的代码，同时保留冲突的部分
    # 冲突的部分会生成 .rej 文件供手工解决冲突
    git apply --reject /path/to/your.patch

        后缀为 .rej 的文件，保存没有合并进去的部分的内容，可以参考这个进行冲突解决。
        解决完冲突后删除后缀为 .rej 的文件，并执行git add.添加改动到暂存区.
        接着执行git am --resolved 或者 git am --continue

没问题，完全打上补丁

    git apply /path/to/your.patch

    或

    # 使用-s或–signoff选项，可以commit信息中加入Signed-off-by信息
    git am --signoff </path/to/your.patch

应用补丁时，使用使用 git 图形工具更方便，因为一旦产生冲突，处理起来比较直观，比较常用的 git 工具有 sourceTree， TortoiseGit 等。

另有 git am 命令，略。

另可从不同分支上摘取指定的提交记录，参见章节 [补丁神器 cherry-pick]。

## 如何回退

    https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified

NOTE: git 的回退弯弯绕比较多，有好几种情况会无提示清理暂存区或工作区。

先做好 FailSafe:

    如果是已经 git commit 的操作，首先保留下现场以便反悔救命，这个窗口千万别关啊！

        # 最好用 tmux 保留这个命令的输出，救命用的
        git log --graph --oneline

    如果暂存区或工作区有修改，或者提交，或者stash，然后再做回退的操作。

    最好不要修改远程库已有的提交记录，一定要修改，参见章节 [远程库也有的提交记录，如何回退]。

工作区

    你的修改，没有提交的都在这里。即使做了 git add，内容还没提交，整体还是在这里。

暂存区(stage/index)的意义

    当你修改了很多还没改完，想临时性的保存下，不应该形成一个 commit 保存到仓库区。

    继续改，担心把之前正确的弄乱，那就先暂存这部分修改内容，然后继续在工作区修改。

    万一你越改越乱，把之前的修改也变动了，工作区里改动的内容很多不好复原，咋办？因为前一阶段的修改内容保存在暂存区，可以用 git diff 很方便的比较暂存区和工作区的差异，轻松调整为你想要的内容。

    所以，如果你长时间在做一份内容修改，经常性的保存，分阶段的添加到暂存区，非常必要。

仓库区(head)

    你执行 commit 后的提交在这里，分布式存储，需要你 push 才能到远程库。

用户修改文件，文件的变更路径是

    工作区 ---------> 暂存区 ------------> 仓库区 ---------------->
           git add          git commit          git push 到远程

修改的文件要撤回，跟上面的过程相反

    仓库区 ----> 暂存区 ----> 工作区

git的实际工作，修改的文件进入每个区域，都需要专门的命令

                             HEAD      Index  Workdir   WD Safe?

    Commit Level
    reset --soft [commit]     REF       NO      NO      YES
    reset [commit]            REF       YES     NO      YES
    reset --hard [commit]     REF       YES     YES     NO
    checkout <commit>         HEAD      YES     YES     YES

    File Level
    reset [commit] <paths>     NO       YES     NO      YES
    checkout [commit] <paths>  NO       YES     YES     NO

### 从使用角度的快速总结

丢弃工作区内容

    # git checkout <file>
    git restore <file>

丢弃暂存区内容，暂存区内容回退到工作区，工作区内容优先保留

    # git reset HEAD <file>
    git restore --staged <file>

丢弃刚添加到仓库的提交记录

    # git reset --soft HEAD~1 差异放在在储藏（stage）区域
    git reset HEAD^

直接回撤到版本库的某个commit点，之前的修改全抛弃（没做 git push）

    git reset --hard HEAD~1

    git reset --hard commitXXX

不仅提交到仓库区了，还 git push 到远程仓库了

    如果强制执行 `git reset --hard commitXXX` 那么会提示 `git push -f` 把远程仓库覆盖掉，
    参见章节 [远程仓库上有B先生新增提交了，然后你却回退了远程仓库到A1]

从其他分支或者之前的提交中签出文件的不同版本：

    git checkout <branch/commit> file.js

    先查找指定文件的相关提交记录
    $ git log --oneline zhyc.txt
    [树形提交记录]
    * cf83e50 第四次添加开始回退‘ ’ ;
    * 61ce6d7 第三次添加也是要丢
    * b263d60 第二次添加作为要丢的
    * 0a2883c 第一次添加作为基础
    * f6e4075 tea2我删掉了123，应该会冲突,看看到底把谁的 commit id 给更新了
    * a928649 我删掉了456
    * b224511 zhyc.txt

    然后直接签出
    $ git checkout a928649 zhyc.txt
    Updated 1 path from e53b7d8

    签出的文件处于“暂存并准备提交”的状态。

    如果不想要上面的状态，想回退并签出到未暂存的工作区状态，需要执行一下

        git reset HEAD file-name.js

    不想看了，回到最新提交

        git checkout file-name.js

### git restore [file]

    https://git-scm.com/docs/git-restore

关于撤回文件的用途很明晰：恢复一个区域的文件版本

    git restore --source <commit> <file>

        丢弃工作区，保留暂存区，工作区内容恢复为指定提交记录的内容。

    git restore <file> 是上面命令的简写，利用默认值 --source HEAD

        丢弃工作区，保留暂存区，如果暂存区无内容，则工作区内容恢复为 HEAD 的内容，否则是暂存区的内容。

        用于替换 `git checkout [file]` 。

    git restore --staged <file>

        暂存区内容回退到工作区，优先保留工作区内容。

        用于替换 `git reset [file]`

示例

    暂存区无内容，工作区有内容：

        `git restore <file>` 丢弃工作区，工作区内容恢复为 HEAD 的内容。

        `git restore --staged <file>` 无变化

    暂存区有内容，工作区有内容：

        `git restore <file>` 丢弃工作区，保留暂存区内容

        `git restore --staged <file>` 丢弃暂存区，保留工作区内容

    暂存区有内容，工作区无内容：

        `git restore <file>` 无变化

        `git restore --staged <file>` 丢弃暂存区，暂存区内容回退到工作区

注： “有内容”，指文件中相同位置的内容有变更，如果不是相同位置，会自动合并内容

### git checkout [commit] [file]

    https://git-scm.com/docs/git-checkout

丢弃工作区，丢弃暂存区，恢复指定提交记录时的文内容到暂存区。

    暂存区无内容，工作区无内容：指定提交点的内容恢复到暂存区

    暂存区无内容，工作区有内容：指定提交点的内容恢复到暂存区，丢弃工作区

    暂存区有内容，工作区有内容：丢弃暂存区，指定提交点的内容恢复到暂存区，丢弃工作区

    暂存区有内容，工作区无内容：丢弃暂存区，指定提交点的内容恢复到暂存区

如：

    git checkout b22c20fc8d -- abc.txt

HEAD特殊：

    git checkout HEAD [file]

        暂存区无内容，工作区无内容：文件维持 HEAD 状态

        暂存区无内容，工作区有内容：丢弃工作区，文件恢复到 HEAD 状态

        暂存区有内容，工作区有内容：丢弃暂存区，丢弃工作区，文件恢复到 HEAD 状态

        暂存区有内容，工作区无内容：丢弃暂存区，文件恢复到 HEAD 状态

    # 恢复到仓库的状态
    git checkout HEAD -- abc.txt

注： “有内容”，指文件中相同位置的内容有变更，如果不是相同位置，无影响。

### 废弃---git checkout [file]

丢弃工作区，保留暂存区。

也就是说，如果没有暂存区，则工作区内容恢复为 HEAD 的内容，否则是暂存区的内容。

注意：与 `git checkout HEAD [file]` 有区别。太乱，换 `git restore <file>`命令。

示例

    丢弃工作区内指定文件的修改

        git checkout -- aaa.txt

    丢弃工作区内所有文件的修改

        # git checkout HEAD .
        git checkout .

注： “有内容”，指文件中相同位置的内容有变更，如果不是相同位置，无影响。

### 废弃 git checkout [commit]

git 用 switch 命令替代了 checkout 命令中关于分支切换的功能，详见章节 [分支切换 switch]。

### git reset [commit] [file]

丢弃暂存区，把指定提交点的文件内容回退到暂存区，优先保留工作区。

    暂存区无内容，工作区无内容：指定提交点的内容回退到暂存区，工作区变为未添加状态！

    暂存区无内容，工作区有内容：指定提交点的内容回退到暂存区，保留工作区

    暂存区有内容，工作区有内容：丢弃暂存区，指定提交点的内容回退到暂存区，保留工作区

    暂存区有内容，工作区无内容：丢弃暂存区，指定提交点的内容回退到暂存区

与 `git checkout [commit] [file]` 的区别是优先保留工作区内容。

HEAD特殊：

    git reset HEAD [file]

        暂存区无内容，工作区无内容：无变化

        暂存区无内容，工作区有内容：暂存区无内容，保留工作区

        暂存区有内容，工作区有内容：丢弃暂存区，保留工作区

        暂存区有内容，工作区无内容：暂存区内容回退到工作区

注： “有内容”，指文件中相同位置的内容有变更，如果不是相同位置，会自动合并内容

### 废弃---git reset [file]

暂存区内容回退到工作区，优先保留工作区内容。

是 `git reset HEAD [file]` 的简写。太乱，换 `git restore --staged <file>` 命令。

### git reset [commit]

    https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified#_the_role_of_reset

主要关注回退提交记录，并且重置 HEAD 的位置为你指定的提交点。

注意

    如果你想回退远程库已有的提交记录，比如你已经推送到远程了，或者你的本地代码都是从远程拉取的，不要用 `git reset` 进行回退，详见章节 [远程库也有的提交记录，如何回退] 的办法。

查看历史记录，参见章节 [查看提交记录]。

分几种回退情形

    git reset --soft <commit>

        重置 HEAD 的位置为你指定的提交点，把回退的commit的内容恢复到暂存区，优先保留暂存区内容。如果是间隔多个提交记录，回退会累积到暂存区，类似 squash 的效果。

        git reset --soft HEAD~

            同上，只回退上一步的提交记录的方便写法。

    git reset <commit>

        重置 head 的位置为你指定的提交点，把暂存区内容回退到工作区，优先保留工作区。

            如果暂存区有内容，则丢弃回退的commit的内容，把暂存区内容回退到工作区。

            如果暂存区和工作区都有内容，则丢弃回退的commit的内容，丢弃暂存区，保留工作区。

        git reset HEAD

            相当于是 git add 的逆过程。

    git reset --hard <commit>

        重置 head 的位置为你指定的提交点，丢弃暂存区，丢弃工作区，工作区恢复为该提交点的内容

        git reset --hard HEAD

            丢弃暂存区、丢弃工作区，工作区恢复为当前仓库 HEAD 指针指向的内容。

        TODO:对两分支分叉的合并点，如果执行 git reset --hard HEAD^，会退回到第一个分支的最后一个提交记录，参见章节 [HEAD^n]。

如果用 git reset 回退提交记录后，后悔还想使用原来 HEAD 指向的远程库最新的提交点

    可以用 git reflog 查看近期的提交记录往回cherry-pick，或简单点，直接从远程库 origin/master 合并回来：运行 `git merge` 即可。参见章节 [原理：你的代码在本地有两份--本地仓库和远程仓库]。

### git rm

移除 git 对该文件的跟踪，跟 git add 相对。

git rm [file]

    删除该文件，取消对该文件的跟踪。该操作被加入暂存区等待提交。

    如果暂存区或工作区有该文件的修改，则会报错，提示使用 `git rm -f`。

    撤销该操作：

        未提交：用 `git restore --staged <file>` 恢复到暂存区，然后用 `git restore <file>` 解除删除状态。

        已提交：用 `git reset --hard HEAD~` 进行恢复，或用本地远程库 `git reset --hard origin/HEAD` 也可以恢复。

        本地提交记录还做了回退，导致 HEAD 也没法用：用合并本地远程库的方式恢复，先对比下提交记录 `git log --graph --oneline ..origin/master --`，然后合并即可 `git merge`。详见章节 [分支更新]。

        不止上面这样，还推送远程了：用 `git reflog` 看看之前的该文件相关的提交记录是否还在，用 `git cherry-pick` 捡回来，作为新的提交点再加回去。

        不止上面这样，过了100天才发现不该删除，本地的提交记录清理过无用的了：找备份文件吧。

git rm --cached [file]

    取消对该文件的跟踪，文件保留到工作区

git rm -f [file]

    删除该文件，取消对该文件的跟踪。丢弃暂存区和工作区中该文件的修改。

#### 从远程库删除某些文件但保留本地的文件

有时我们会误把一些不必要的文件（如目标文件、log 日志等）提交并推送到了远程库，现在希望从远程库删除这些文件但保留本地的文件，可以像这样执行：

    # 目录
    git rm -r --cached dir1
    # 或文件也可以
    git rm --cached dir2/*.pyc

    # 提交并推送远程
    git commit -m "remove irrelated files"
    git push origin branch1

### 不推荐：git revert

    git revert 的隐患太多，建议直接使用章节 [基于文件的撤销大法]。

git revert 反做你指定的提交点的操作，新增一个提交点。

    # 撤销指定的版本，撤销也会作为一次提交进行保存
    git revert commit

    # 撤销前一次 commit
    git revert HEAD

    # 撤销前前一次 commit
    git revert HEAD^

    # 倒回从B到D点范围的提交记录，用 -n 只生成一个提交点
    git revert B^…D

如果在 revert 中发现冲突，git 会提示解决冲突，格式参见章节 [冲突文件的格式]，解决后执行 `git add . ; git revert --continue` 继续。如果想终止，可以执行 `git revert --abort`。

特殊：

对于分叉合并形成的交叉点的那个提交记录，如果回退，需要指明主线分支：用 -m 选项，接收的参数是一个数字，数字取值为 1 和 2，也就是你在做 merge 时提示行里面列出来的第一个还是第二个，这谁记得住？参见 <https://git-scm.com/book/en/v2/Git-Tools-Advanced-Merging#reverse_the_commit>、<https://git-scm.com/docs/howto/revert-a-faulty-merge>。其实这是 git 的一个痛点，参见 <https://jneem.github.io/pijul/> 的 [Case study 1: reverting an old commit]。

    git revert HEAD^ -m 1

接上步：如果被 revert 掉的分支修改了错误，重新提交，不能直接 merge，应该把之前 revert 掉自己的那个提交点也再 revert 掉，然后再 merge。（其实这是 git 的一个痛点，参见章节 [竞品 -- 基于文件差异(patch)的源代码管理系统]）

    https://blog.csdn.net/allanGold/article/details/111372750

        https://stackoverflow.com/questions/9059335/how-can-i-get-the-parents-of-a-merge-commit-in-git

这种骚操作只会越搞越乱，不如直接使用 [基于文件的撤销大法]。

### 远程库也有的提交记录，如何回退

因为远程库要避免用 push -f 重写提交记录（原因见章节 [遇到提示 push -f 的时候多想想]），所以只能在文件内容的回退上想办法。也就是说，着眼点不是提交记录，不要撤回到某个提交点上，而是想办法把文件内容重置到要撤回的那个提交点的内容上即可

    文件内容回退到之前的某个提交点的样子，但在提交记录上是新增一个提交点，这样的办法是最妥当的。

#### 基于文件的撤销大法

    https://zhuanlan.zhihu.com/p/104806087

习惯上来说，git 的问题应该用一系列的 git 操作来解决，这样可以保留提交记录。但是，如果这一系列的操作太繁琐，特别是多人团队开发历史久远的项目，如果要回退，用 git 来操作反而更难搞。

解决方法是：保留原有的提交记录，直接用文件操作解决内容问题，这样短平快。

这种操作是基于文件操作的办法，最终实现了只是在提交记录上新增一个提交点，文件内容回退到之前指定的提交点，确保了提交记录是向前延展的，所有人都不受影响。

以本地库和远程库的提交记录hash对不上为例。

也许只是为了 cherry-pick 某个分支的提交、也许只是为了整理下自己的提交记录，也许只是为了文件内容合并时不冲突，你用一系列骚操作 rebase，revert、merge，把本地的提交记录搞了个底朝天，远程跟本地各种提交记录冲突，没法推送没法拉取，玩不下去了。

后悔了吧：明明是只改几个文件内容，甚至文件内容压根没动，当初为嘛非得更新提交记录呢？

解决也简单，先拷贝当前的所有文件到其它目录，然后恢复现场到之前的某个没有冲突的提交点，然后直接拷贝文件往回覆盖，你自己要改动的文件内容自己最清楚。

法一：使用本地的远程库恢复现场

    1、保存暂存区、工作区的修改。或者干脆直接另存文件到别的目录先。

    2、 git reset --hard origin/master 用远程库恢复原样。

    3、把你第一步备份的修改再恢复回来，仔细检查是不是就是你想要的内容。

    4、然后，执行`git commit -a` 只新增一个了提交点，然后清清爽爽走推送流程。

法二：使用用某个提交点的文件内容替换当前内容：

    假设在 master 分支上，需要回退到 A1 的文件内容

    1、保存暂存区、工作区的修改。或者干脆直接另存文件到别的目录先。

    2、先对提交点 A1 新建分支 `git checkout -b A1`

    3、切换到新建的分支，除了 .git 目录，挪走所有文件和目录到临时目录

    4、切换回 master 分支，除了 .git 目录，删除的所有文件和目录

    5、把你在第三步挪走的文件挪回本目录，仔细检查是不是就是你想要的内容。

    6、把你第一步备份的修改再恢复回来，仔细检查是不是就是你想要的内容。

    7、然后，执行`git commit -a` 只新增一个了提交点，然后清清爽爽走推送流程。

#### 组合使用 revert + rebase 进行回退

利用两个特点

    git revert 命令反做你上一步的提交，通过在提交记录上新增一个提交点，实现文件内容的回退。

    git rebase 压缩你所有要回撤的提交点为一个提交点。

方案

    先使用 rebase 把多个提交合并成一个提交

    再使用 revert 反做这个提交

git revert 新增的提交点，是对 rebase 那个提交点的反向执行，从而实现了修改内容的回退。这样在提交记录里新增了一个提交点，但是提交记录是向前延展的，所有人都不受影响。

示例：

    从 master 分支建立新分支 tmp_re ，使用 git log 查询一下要回退到的 commit 版本 N

        git checkout -b tmp_re
        git log --graph --oneline

    使用命令 git rebase -i N 将这些 commits 都合并到最旧的 commit1 上

        git rebase -i commit1

    合并前：
                        起点       修改1        修改2        修改3
        [master分支] --- older --- commit1 --- commit2 --- commit3

                        起点       所有的修改合并
        [tmp_re分支] --- older --- commit_rebase

    这个时候，master 分支上的提交记录是跟 tmp_re 分支上的提交记录不同，但两个分支的文件的内容其实是一样的。

    tmp_re 分支用分叉合并 master 分支（只能进度落后的合并进度领先的，倒过来合并 git 会报错），新增一个分叉合并的提交点

        git merge master

    合并后：
                        起点       所有的修改合并             分叉点
        [tmp_re分支] --- older --- commit_rebase --------- commit_merge
                    \                                /
                      commit1 --- commit2 --- commit3
                       修改1        修改2        修改3

    再在 tmp_re 分支上对 commit_merge 进行一次 revert 反提交。

    这样就实现了在文件内容上，把 commit1 到 commit3 提交做的修改全部撤回，但是提交记录是向前延展的。

    merge 有分叉，做 revert 时需要指定分支，先用 git log 看好了

        git log --graph --oneline

    回退选择有 rebase 提交的那一支。

    NOTE: git revert 的 m 参数指定 mainline，如果是功能分支合并功能分支，就不好判断了！

        git revert HEAD^ -m 1

    这样，tmp_re 分支的文件内容回退掉了 commit1-3 修改的内容，但是提交记录没有任何删除，一直向前延展

        [tmp_re分支] --- older --- commit_rebase ---- commit_merge --- commit_revert（其实回到 older 的内容了）
                          \                           /
                           commit1---commit2---commit3

    最后，把 tmp_re 分支合并到 master 分支，覆盖 master 分支上的差异，使 master 分支上的文件内容也回到了点 older 点的样子。

## git 常用法

    https://git-scm.com/docs/gitfaq

### Windows 直接拷贝代码目录到 Linux 下使用

如果你从 windows 下拷贝了一个 git 仓库到 Linux 下使用，所有文件都被 git 视作修改了，要求提交，用图形化的文本编辑器看不出文件内容的差异。

用 `git diff xxx.py` 可以看到每行都多出了特殊字符 ^M，用 vi 打开一个文件能看到提示是 dos 文件格式：

    Windows 下默认的文件格式是 dos（CRLF）

    Linux 下默认的文件格式是 unix（LF）

简单快捷的处理办法不是使用命令 dos2unix 逐个转换，在代码目录下运行命令 `git restore .` 即可。

在windows主機上，掛載Linux目錄後，接著準備將資料push到git server，豈料出現一大堆檔案呈現已修改狀態，提示我這些檔案要commit，但是實際上這些檔案沒有任何異動修改；我追查了一下，發現是換行字元搞的鬼，Linux換行只有\n ，windows則為\r\n；

windows掛載Linux檔案，因為換行字元不同，當然會被誤認檔案被修改過。

解決方式，在windows掛載linux情況下，執行以下git指令，就可以解決了。

    $ git config --global core.autocrlf true
    $ git config core.filemode false
    $ git status

> 在 Git 中正确设置 CRLF、LF 换行符转换

    https://p3terx.com/archives/how-to-choose-crlf-lf.html

CRLF、LF 是用来表示文本换行的方式。CR (Car­riage Re­turn) 代表回车，对应字符 \r，LF (Line Feed) 代表换行，对应字符 \n。由于历史原因，不同的操作系统文本使用的换行符各不相同。主流的操作系统一般使用 CRLF 或者 LF 作为其文本的换行符。其中，Win­dows 系统使用的是 CRLF, Unix 系统 (包括 Linux、Ma­cOS 近些年的版本) 使用的是 LF。

Git 提供了一个名为 core.autocrlf 的配置，可以自动完成标准化与转换。它的设置方式如下：

    $ git config --global core.autocrlf  [true | input | false]  # 全局设置
    $ git config --local core.autocrlf  [true | input | false] # 针对本项目设置

    true 提交时转换为LF，检出时转换为CRLF
    input 提交时转换为LF，检出时不转换
    false 提交与检出的代码都保持文件原有的换行符不变（不转换）

CRLF 与 LF 混合的文本文件不受此配置控制。

Git 安装后默认为 false。

由于没有一个绝对有效的算法来判断一个文件是否为文本，所以 Git 提供了一项禁止 / 警告不可逆转换的配置来防止错误的标准化与转换。它主要是影响到多种换行符混合的文件，我们可以手动将其转换为同一种换行符：

    $ git config --global core.safecrlf [true | false | warn]

    true 禁止提交混合换行符的文本文件(git add 的时候会被拦截，提示异常)
    warn 提交混合换行符的文本文件的时候发出警告，但是不会阻止 git add 操作
    false 不禁止提交混合换行符的文本文件（默认配置）

### 快速定位故障版本

git bisect 使用分治算法查找出错版本号。

假设休假一周回来，你看了一下最新代码，发现走之前完全正常的代码现在出问题了。

你查看了一下休假之前最后一次提交的代码，功能尚且正常。不幸的是，你离开的这段时间，已经有上百次提交记录，你无法找到那一次提交导致了这个问题。

这时你或许想找到破坏功能的 bug，然后对该文件使用 git blame 命令，找出并指责破坏者。

如果 bug 很难定位，那么或许你可以去看一下提交历史，试一下看能不能找到出问题的版本。

另一种快捷的方式则是使用 git bisect，可以快速找到出问题的版本。

那么 git bisect 是如何做的呢？

指定了已知的正常版本和问题版本之后，git bisectit bisect 会把指定范围内的提交信息从中间一分为二，并会根据最中间的提交信息创建一个新的分支， 你可以检查这个版本是否有问题。

假设这个中间版本依然可以正常运行。你可以通过git bisect good 命令告诉 git。然后，你就只有剩下的一半的版本需要测试。

Git 会继续分割剩下的版本，将中间版本再次到处让你测试。

Git bisect 会继续用相似的方式缩小版本查找范围，直到第一个出问题的版本被找到。

因为你每次将版本分为两半，所以可以用 log(n) 次查找到问题版本（时间复杂度为 “big O”，非常快）。

运行整个 git bisect 的过程中你会用到的所有命令如下：

 1. git bisect start ——通知git你开始二分查找。
 2. git bisect good {{some-commit-hash}} ——反馈给git 这个版本是没有问题的（例如：你休假之前的最后一个版本）。
 3. git bisect bad {{some-commit-hash}} ——告诉git 已知的有问题的版本（例如master分支中的HEAD）。git bisect bad HEAD （HEAD 代表最新版本）。
 4. 这时git 会签出中间版本，并告诉你去测试这个版本。
 5. git bisect bad ——通知git当前版本是问题版本。
 6. git bisect good ——通知git当前签出的版本没有问题。
 7. 当找到第一个问题版本后，git会告诉你。这时， git bisect 结束了。
 8. git bisect reset——返回到 git bisect进程的初始状态（例如，master分支的HEAD版本）。
 9. git bisect log ——显示最后一次完全成功的 git bisect日志。

你也可以给 git bisect 提供一个脚本，自动执行这一过程 <http://git-scm.com/docs/git-bisect#_bisect_run>

### 彻底删除git中的大文件

本地的.git 目录主要记录每次提交变动，当我们的项目越来越大的时候，我们发现 .git 目录越来越大。原因在于，git 如果提交一个文件，然后删除他，继续提交，即使你在之后的版本中将其删除，在 .git 目录中仍然有该文件的提交记录，以备你找回提交记录。这种用不到的大文件的提交记录的清理，需要使用特殊的命令才可以删除。

git给出了解决方案，使用 git branch-filter 来遍历 git history tree, 可以永久删除 history 中的大文件，达到让 .git 文件瘦身的目的。

    https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/removing-sensitive-data-from-a-repository

### 暂存区大文件导致推送远程失败

直接剔除那个大文件，再重新推送，但此时暂存区已经被修改，无法执行 git push，需要重建目录树。

查看对象库的文件名：

    $ ls -l .git/objects/pack
    -r--r--r--  1 xxxsun  staff    54K Feb 20 20:30 pack-f49501cbd6851d3cbdf8ad44028263e2b1526b32.idx
    -r--r--r--  1 xxxsun  staff   118M Feb 20 20:30 pack-f49501cbd6851d3cbdf8ad44028263e2b1526b32.pack

查看对象库的索引文件，排序第三段，找最大的N个文件sha1：

    $ git verify-pack -v .git/objects/pack/pack-f49501cbd6851d3cbdf8ad44028263e2b1526b32.idx |grep blob| sort -k 3 -n | tail -n 10
    5f466dec2fc24624d09790c369e5ad1e5343ec61 blob   8377466 8351646 110662168
    8c915661c66e9b3a9ec9e17c9b55fb4bdaf152fc blob   9162783 6558772 101211526
    8533ba160d286563df5b7bd774b2814a46b64857 blob   20848460 16287722 8254071

查看sha1对应文件名：

    $ git rev-list --objects --all | grep b56c8f61a3c9f153a9064ef3c888fb6051307212
    b56c8f61a3c9f153a9064ef3c888fb6051307212 产品文档/xxx系统-产品团队补充部分v2.2.pdf

发现比较大的几个文件均为 *.pdf，从暂存区删除：

    git filter-branch --index-filter 'git rm --cached --ignore-unmatch *.docx' -- --all
    rm -Rf .git/refs/original
    rm -Rf .git/logs/
    git gc --aggressive --prune=now

验证，看下大小：

    git count-objects -vH

重新提交成功

### fatal: unsafe repository

Ubuntu克隆下源码后对其操作时git报错

     https://blog.csdn.net/guoyihaoguoyihao/article/details/124868059

并提示可以

    git config --global --add safe.directory /目录

解决思路：

按提示执行确实可以短暂避免该问题，但治标不治本，且文件很多时需要一个个敲命令。产生这一问题的本质原因是下载代码的所有权没有转移，即你下载了别人的代码，别人声明该代码所有权。所以，在修改代码时会报以上问题。

因此，我们需要做的并不是声称哪目录是安全的，而是要将代码所有权转移。

解决方法：

在你下载的文件目录下打开terminal

    whoami

    chown -R 用户名：用户组 .

第一行是查看本机用户名，用户组与用户名一般一致；

第二行将该目录下的文件所有权转移给该用户名。

P.S 第二行最后有个"."

### fatal: does not appear to a git repository

参见章节 [修改本地仓库的远程仓库地址]。

先确认下，已经有 origin 远程库，没有也需要重新建立连接

    $ git remote show
    origin

一般都是因为 remote 端目录变更导致

    $ git remote -v
    origin  ssh://git@11.22.33.44:2345/gitrepo/af_monitor.git (fetch)
    origin  ssh://git@11.22.33.44:2345/gitrepo/af_monitor.git (push)

删除 origin 重建

    git remote rm origin

    git remote add origin ssh://git@11.22.33.44:22/gitrepo/tea.git

建立origin 和 master 的联系

    git push -u origin master

如果上一步报错，因为本地跟远程库新的提交冲突了，需要先拉取下来做merge

    git pull --rebase origin master

### 掉电导致objects目录下的某些文件为空

如果保存远程 gitrepo 的虚拟机非正常关闭或者本地机器突然掉电，会导致 .git/objects 目录下的某些文件为空的报错:

    error: object file .git/objects/31/65329bb680e30595f242b7c4d8406ca63eeab0 is empty
fatal: loose object 3165329bb680e30595f242b7c4d8406ca63eeab0 (stored in .git/objects/31/65329bb680e30595f242b7c4d8406ca63eeab0) is corrupt

    <https://segmentfault.com/a/1190000008734662>
    <https://stackoverflow.com/questions/11706215/how-to-fix-git-error-object-file-is-empty>

最优解决方案是删除空文件，然后想办法把head重新指向上一条不空的object，操作步骤如下

    git fsck --full

    cd .git; find . -type f -empty -delete -print

    再次运行 git fsck --full，还有就再删

所有空文件删除完毕，再运行 git fsck --full，还是有错，head指向元素不存在，是之前的一个空文件，我们已经删了

    $ git fsck --full
    Checking object directories: 100% (256/256), done.
    Checking objects: 100% (103719/103719), done.
    error: HEAD: invalid sha1 pointer c6492f7ad72197e2fb247dcb7d9215035acdca7f
    error: refs/heads/ia does not point to a valid object!

手动获得最后两条reflog

    $ tail -n 2 .git/logs/refs/heads/master
    3a0ecb6511eb0815eb49a0939073ee8ac8674f8a
    99cb711e331e1a2f9b0d2b1d27b3cdff8bbe0ba5 xxx <aaa@bbb.com> 1477039998 +0800    commit: nested into app

head当前是指向最新的那一条记录，所以我们看一下parent commit 即倒数第二条提交

    $ git show 99cb711e331e1a2f9b0d2b1d27b3cdff8bbe0ba5
    Date:   Fri Oct 21 16:53:18 2016 +0800

        nested into app

    diff --git a/pzbm/templates/pzbm/base.html b/pzbm/templates/pzbm/base.html
    index 70331c5..c96d12c 100644
    --- a/pzbm/templates/pzbm/base.html
    +++ b/pzbm/templates/pzbm/base.html
    @@ -6,7 +6,7 @@

可以看到内容，是好的，就把HEAD指向这个。

    git update-ref HEAD 99cb711e331e1a2f9b0d2b1d27b3cdff8bbe0ba5

    git commit

简单的应对，找个本地文件不含空文件的：

    1.远程报错的，从本地拷贝远程为空的文件过去，但是如果有多个来源提交到服务器文件的话可能会出现不一致的情况。

    2.远程报错的，本地直接git clone --bare 重新搞上去得了，但是会丢历史版本信息

    3.本地报错的，把.git删掉，重新init，但是会丢历史版本信息

## 使用 GPG 签名 Github 提交

    https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work

    https://docs.github.com/cn/authentication/managing-commit-signature-verification/generating-a-new-gpg-key

    https://blog.dejavu.moe/posts/gpg-verified-github/

    https://www.zackwu.com/posts/2019-08-04-how-to-use-gpg-on-github/

    https://cloud.tencent.com/developer/article/1656009?from=article.detail.1531457

验证签名

    git log --show-signature -1

### 1、在github网页端添加自己的gpg公钥

github 要求，gpg 密钥的电邮地址应该使用 github 页面提示给出的（对于隐藏自己邮件地址）对外电邮。

查看该电邮地址，登陆 github，菜单 “settings-emails：Primary email address的说明文字里有对外电邮地址”，操作说明见 <https://docs.github.com/cn/authentication/managing-commit-signature-verification/generating-a-new-gpg-key>。

单独给这个电邮地址新建个 github 专用的 gpg 密钥，其 uid 设为 github 用户名 'm666m'。

为提高使用安全性，新建的主密钥仅具有签发功能，再签发一个有签名功能的子密钥，把子密钥提交到 github 和本地 git 存储的设置中使用。

显示当前的 gpg 公钥，本地控制台下执行命令

    # FBB74XXXXXXXAE51 是之前gpg生成的uid的密钥指纹，也可以直接写uid如'm666m'
    gpg --armor --export FBB74XXXXXXXAE51

复制你的电邮地址对应的那个公钥，将其添加到 github 个人资料的设置中：

   github 页面右上角，单击你的头像，Settings—> GPG keys，然后粘贴 GPG key。

这时自己的 github 公钥就可以公开访问了

    https://github.com/m666m.gpg

#### github不在 Pubkey Server 发布公钥

GitHub 不去查找 Pubkey Server，只维护用户自行上传的公钥

    吊销密钥将取消验证已签名的提交，通过使用此密钥验证的提交将变为未验证状态。如果你的密钥已被盗用，则应使用此操作。

    删除密钥不会取消验证已签名的提交。使用此密钥验证的提交将保持验证状态。

### 2、设置 git 中使用的 gpg 密钥

    # 如果有 Yubikey 这种智能卡，插入
    #   gpg --card-status
    #   找到用于签名应用的子密钥 ID，比如 FBB74XXXXXXXAE51

    # FBB74XXXXXXXAE51 是之前gpg生成的uid的密钥指纹，也可以直接写uid如'm666m'
    # 如果有签名功能的子密钥，设置为该子密钥的keyid即可。
    #
    # 分项目设置，全局使用加 --global
    git config user.signingkey FBB74XXXXXXXAE51

要确保用户名和电邮跟 github中 设置的一致

    # 分项目设置，全局使用加 --global
    git config user.name
    git config  user.email

### 3、设置gpg程序的路径

    $ where gpg
        E:\Git\usr\bin\gpg.exe  # 这个是 Git for windows 自带的
        E:\GnuPG\bin\gpg.exe    # 这个是Gpg4Win安装的

    $ git config --global gpg.program "E:\GnuPG\bin\gpg.exe"
    done

### 4、设置始终签名提交

git commit 使用 -S 参数进行 GPG 签名：

    # 每次都得给 git commit 操作（包括 --amend）传递 -S。
    git commit -S -m “commit message"

建议始终使用签名提交，设置默认使用 GPG 签名提交，这样 git commit 命令不需要加 -S 了

    # 分项目设置，全局使用加 --global
    git config commit.gpgsign true

验证签名的提交

    git verify-commit [hash]

在 git 中通过命令行验证相关提交记录的签名

    $ git log --show-signature -1
    commit 374010d1af1de40fdf8f1f6f5cca0c0c60e4fe9d (HEAD -> master, origin/master, origin/HEAD)
    gpg: 签名建立于 四 10/31 11:24:16 2019 CST
    gpg:               使用 RSA 密钥 39033F321A83635ECD7FC8DA66DD4800155F7A2B
    gpg: 完好的签名，来自于 “admin <admin@example.com>” [绝对]
    Author: admin <admin@example.com>
    Date:   Thu Oct 31 11:24:16 2019 +0800

        update README.md

在 github 验证提交

    1、在 github 提交选项卡，签名的提交将显示包含“ Verified”或“ Unverified”的徽章，具体取决于 GPG 签名的验证状态。
    2、通过单击 GPG 徽章，将显示签名的详细信息。

### 5、设置始终给标签签名

tag命令后跟 -s 参数即可

    git tag -s [tagname]

对带注释的标签，每次都传递一个 -s 开关：

    git tag -asm "Tag message" tagname

建议始终对 git 标签签名，设置始终签名带注释的标签

    # 分项目设置，全局使用加 --global
    git config tag.forceSignAnnotated true

验证一个签名的标签

    git verify-tag [tagname]

如果你要验证其他人的 git 标签，需要你导入他的 gpg 公钥。

### 6、合并时强制进行签名检查

需要项目的所有成员都签名了他们的提交，否则只要有一个提交没有签名或验证失败，都会导致合并操作失败。

    git merge --verify-signatures -S merged-branch

### 7、可选步骤：给Github的GPG公钥签名

在 Github 网页端进行的操作，比如创建仓库。这些 commit 是由 Github 代为签名的

    $ git log --show-signature
    # some output is omitted
    commit ec37d4af120a69dafa077052cfdf4f5e33fa1ef3 (HEAD -> master)
    gpg: Signature made 2019年08月 4日 12:52:29
    gpg:                using RSA key 1BA074F113915706D141348CDC3DB5873563E6B2
    gpg: Good signature from "fortest <test@test.com>" [ultimate]
    Author: keithnull <keith1126@126.com>
    Date:   Sun Aug 4 12:52:29 2019 +0800

        test GPG

    commit 6937d638d950362f73bfbf28bc4a39d1700bf26b
    gpg: Signature made 2019年07月24日 15:58:46
    gpg:                using RSA key 4AEE18F83AFDEB23
    gpg: Can't check signature: No public key
    Author: Keith Null <20233656+keithnull@users.noreply.github.com>
    Date:   Wed Jul 24 15:58:46 2019 +0800

        Initial commit

注意网页端的提交导致 “gpg: Can't check signature: No public key”。

为了解决这个问题，我们需要导入 Github 所用的 GPG 密钥并签名。

先导入：

    $ curl https://github.com/web-flow.gpg | gpg --import
    # curl's output is omitted
    gpg: key 4AEE18F83AFDEB23: public key "GitHub (web-flow commit signing) <noreply@github.com>" imported
    gpg: Total number processed: 1
    gpg:               imported: 1

查看刚导入后的有效性是 [unknown]

    $ gpg -k
    /c/Users/XXXXX/.gnupg/pubring.kbx
    -------------------------------------
    pub   rsa2048 2017-08-16 [SC]
        5DE3E0509C47EA3CF04A42D34AEE18F83AFDEB23
    uid           [ unknown] GitHub (web-flow commit signing) <noreply@github.com>

导入后不签名，git log 显示签名时 gpg 验证提示会有警告性信息

    $ git log --show-signature -1
    gpg: Good signature from "..." [unknown]
    gpg: WARNING: This key is not certified with a trusted signature!
    gpg:          There is no indication that the signature belongs to the owner.

所以，用自己的密钥为其签名

    $ gpg --sign-key 4AEE18F83AFDEB23

    pub  rsa2048/4AEE18F83AFDEB23
        created: 2017-08-16  expires: never       usage: SC
        trust: unknown       validity: unknown
    [ unknown] (1). GitHub (web-flow commit signing) <noreply@github.com>


    pub  rsa2048/4AEE18F83AFDEB23
        created: 2017-08-16  expires: never       usage: SC
        trust: unknown       validity: unknown
    Primary key fingerprint: 5DE3 E050 9C47 EA3C F04A  42D3 4AEE 18F8 3AFD EB23

        GitHub (web-flow commit signing) <noreply@github.com>

    Are you sure that you want to sign this key with your
    key "m666m (for github use) <31643783+m666m@users.noreply.github.com>" (FBB74XXXXXXXAE51)

    Really sign? (y/N) y

确认签名生效，有效性validity 变为 full 了

    $ gpg --edit-key 4AEE18F83AFDEB23
    gpg (GnuPG) 2.2.29-unknown; Copyright (C) 2021 Free Software Foundation, Inc.
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.


    gpg: checking the trustdb
    gpg: marginals needed: 3  completes needed: 1  trust model: pgp
    gpg: depth: 0  valid:   1  signed:   1  trust: 0-, 0q, 0n, 0m, 0f, 1u
    gpg: depth: 1  valid:   1  signed:   0  trust: 1-, 0q, 0n, 0m, 0f, 0u
    pub  rsa2048/4AEE18F83AFDEB23
        created: 2017-08-16  expires: never       usage: SC
        trust: unknown       validity: full
    [  full  ] (1). GitHub (web-flow commit signing) <noreply@github.com>

    gpg> quit

查看现在的有效性是 [full]

    $ gpg -k
    /c/Users/XXXXX/.gnupg/pubring.kbx
    -------------------------------------
    pub   rsa2048 2017-08-16 [SC]
        5DE3E0509C47EA3CF04A42D34AEE18F83AFDEB23
    uid           [  full  ] GitHub (web-flow commit signing) <noreply@github.com>

再次尝试验证本地仓库的提交记录的签名信息，则会发现所有的 commit 签名都已得到验证：

    $ git log --show-signature
    # some output is omitted
    commit 6937d638d950362f73bfbf28bc4a39d1700bf26b
    gpg: Signature made 2019年07月24日 15:58:46
    gpg:                using RSA key 4AEE18F83AFDEB23
    gpg: Good signature from "GitHub (web-flow commit signing) <noreply@github.com>" [full]
    Author: Keith Null <20233656+keithnull@users.noreply.github.com>
    Date:   Wed Jul 24 15:58:46 2019 +0800

        Initial commit

## 无法访问 github 的解决方案

主要针对阻断域名的情况，用 ip 地址解析到 dns 即可

    https://zhuanlan.zhihu.com/p/667649956

    https://www.cnblogs.com/PeterJXL/p/18432978

被 x 大体有两种：DNS污染，封杀IP。

DNS污染则无法通过域名直接访问，一种方法就是修改DNS，这个最简单的就是修改 hosts文件。如果IP被封杀的话，就只能通过 “蕃茄” 来解决了。

一般情况下，修改 hosts 文件，使得本机知晓 github 的 dns 就可以使用 github 了。

hosts 文件在每个系统的位置不一：

    Windows 系统：C:\Windows\System32\drivers\etc\hosts​

    Linux 系统：/etc/hosts​

    Mac（苹果电脑）系统：/etc/hosts​

    Android（安卓）系统：/system/etc/hosts​

    iPhone（iOS）系统：/etc/hosts​

文件修改需要权限：

    Windows 需要管理员权限运行记事本打开文件

    Linux、Mac 使用 Root 权限：sudo vi /etc/hosts。

    iPhone、iPad 须越狱、Android 必须要 root。

1、访问以下网址，逐个查询 github 的可用ip

    https://tool.chinaz.com/dns

把该ip更新到 /etc/hosts 文件：

    20.205.243.166 github.com
    185.199.108.133 raw.githubusercontent.com

这两个地址就基本满足使用要求了。

解决 VSCODE 设置同步network Error 问题

    185.199.110.153 vscode-auth.github.com
    20.205.243.168 api.github.com
    140.82.114.22 education.github.com

2、为了使 github 的的各个功能都可用，有很多 ip 地址需要替换，而全套替换比较麻烦，好在 github 上有自动化项目，直接拉取他们每日更新的文件内容填充到 hosts里即可：

    全 https://github.com/maxiaof/github-hosts/blob/master/hosts
        查询网址 https://tools.tutorialspoint.com/ip_lookup_ajax.php?host=github.com

    全 https://github.com/jianboy/github-host/blob/master/hosts
        查询网址 https://whatismyipaddress.com//hostname-ip

    代码使用简单，可惜不更新了 https://github.com/ovenx/github-hosts

    缺点是调用的国外网站查询的ip地址，不是针对国内优化速度的

执行以下代码

```bash
echo "[更新本地 hosts 文件的 github.com 地址]";
local tfile=$(mktemp);
curl -o $tfile https://raw.githubusercontent.com/maxiaof/github-hosts/master/hosts;
[[ ! -s $tfile ]] && echo '获取 github 地址列表失败！' && return 0;
$(grep 'Github Hosts Start' /etc/hosts > /dev/null 2>&1);
if [[ "$?" = "0" ]]; then
    sed '/#Github Hosts Start/,/#Github Hosts End/ {
            /#Github Hosts Start/ {
                r '"$tfile"'
                d
            }
            /#Github Hosts End/!d
        }' /etc/hosts | awk '!a[$0]++' | sudo tee /etc/hosts;
else
    cat $tfile | sudo tee -a /etc/hosts;
fi;
rm $tfile

```

3、修改完 hosts 文件后，如果还不能正常访问，那就试试刷新下 DNS 缓存，在命令行里执行：

    Linux: sudo systemctl restart network

    Windows: 在 CMD 窗口输入：ipconfig /flushdns

    Macos: sudo killall -HUP mDNSResponder

如果上述方法无效，那就再试试重启机器。

如果还不行，那就只能换个方法了。

## 如果 Github 完蛋了

    https://gitlab.com/

    https://bitbucket.org/

    https://sourceforge.net/

    https://codeberg.org/

## github 使用 2FA

启用2FA之后，每次在不同设备上登录github都要输入验证码（密钥方式命令行 ssh 不受影响），建议在手机上安装【totp应用】。

    https://www.cnblogs.com/johnnyzen/p/17880870.html

1、手机【totp应用】软件安装，参见章节 [手机端客户端使用 Google 身份验证器的替代方案](init_a_server.md)。

2、浏览器操作，先在 github 网站登录你的账户。

然后在 Github 菜单路径：Github->Personal Center->Settings-Password and Authentication，点击按钮: Enable Two-Factor Authentication

    对应地址 https://github.com/settings/security

    操作说明 https://github.com/settings/two_factor_authentication/setup/intro

    https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/about-two-factor-authentication

从【Two-factor authentication】区域中选择 “Authenticator app”。

选择【Edit】，就会打开一个页面显示 QR 码（二维码）， 请勿关闭此页面。

打开手机【totp应用】，从右上角的【+】号添加帐户， (Google、Facebook 等) 选择其他帐户。

选择扫描二维码，扫一扫 github 页面上 QR 码

    如果不止一个设备需要添加，最好保存此 QR 码的图片，以备后用。

    关闭页面后，github 页面不会再展示这个 QR 码了，只能新建。

    忘记保存也没有关系，totp 应用都有展示现有账户 QR 码的功能，用其他设备扫描即可添加。

    提示的应急恢复码最好也保存备查

扫描完成之后，帐号就添加到手机的 Authenticator 软件中了，下次打开切到即可展示 github 的动态验证码。

如果想生成新的 QR 码，再次到这个页面下：Github->Personal Center->Settings-Password and Authentication

    查看 Two-factor methods 栏目，下面有个 Authenticator app，点击 edit 即可查看新 QR 码，用 2FA 应用扫描添加后，把计算出的一次性密码填入下面的输入框，即可点击保存生效了。

    之前的 QR 码就被替换了，注意在所有你使用 totp 应用的软件里更新新的 QR 码，不然无法用它计算登录 github 的验证码了。

## Github 创建 Pull Request

Pull Request 是开发者使用 GitHub 进行协作的利器。这个功能为用户提供了友好的页面，让提议的更改在并入官方项目之前，可以得到充分的讨论。

最简单地来说，Pull Request 是一种机制，让开发者告诉项目成员一个功能已经完成。一旦 feature 分支开发完毕，
开发者使用 GitHub 账号提交一个 Pull Request。它告诉所有参与者，他们需要审查代码，并将代码并入 master 分支。

Pull Request 不只是一个通知，还是一个专注于某个提议功能的讨论版

### Pull Request是如何工作的

Pull Request 需要两个不同的分支或是两个不同的仓库

    1.开发者在他们的本地仓库中为某个功能创建一个专门的分支

    2.开发者将分支推送到公共的 GitHub 仓库

    3.开发者用 GitHub 发起一个 Pull Request

    4.其余的团队成员审查代码，讨论并且做出修改

    5.项目维护者将这个功能并入官方的仓库，然后关闭这个 Pull Request

### 例子

如何将 Pull Request 用在 Fork 工作流中。小团队中的开发和向一个开源项目贡献代码都可以这样做。

Mary 是一位开发者，John 是项目的维护者。他们都有自己公开的 GitHub 仓库，John 的仓库之一便是下面的官方项目。

为了参与这个项目，Mary 首先要做的是 fork 属于 John 的 GitHub 仓库。她需要注册登录 GitHub，找到 John 的仓库，点击 Fork 按钮。

选好 fork 的目标位置之后，她在服务端就有了一个项目的副本.

接下来，Mary 需要将她刚刚 fork 的 GitHub 仓库克隆到本地，这样她在本地会有一份项目的副本

    git clone https://github.com/user/repo.git

请记住，git clone 自动创建了一个名为 origin 的远端连接，指向 Mary 所 fork 的仓库。

在她写任何代码之前，Mary 需要为这个功能创建一个新的分支。这个分支将是她随后发起 Pull Request 时要用到的源分支。

    # 创建新分支
    git checkout -b some-feature

    # 编辑一些代码

    git commit -a -m "新功能的一些草稿"

为了完成这个新功能，Mary 想创建多少个提交都可以。如果 feature 分支的历史有些乱，她可以使用交互式的 rebase 来移除或者拼接不必要的提交。对于大项目来说，清理 feature 的项目历史使得项目维护者更容易看清楚 Pull Request 的所处的进展。

在功能完成后，Mary 使用简单的 git push 将 feature 分支推送到了她自己的 GitHub 仓库上（不是官方的仓库）：

    git push origin some-branch

这样她的更改就可以被项目维护者看到了（或者任何有权限的协作者）。

#### Mary 创建了一个Pull Request

GitHub 上已经有了她的 feature 分支之后，Mary 可以找到被她 fork 的仓库，点击项目简介下的 New Pull Request 按钮，用她的 GitHub 账号创建一个 Pull Request。

Mary 的仓库会被默认设置为源仓库（head fork），询问她指定源分支（compare）、目标仓库（base fork）和目标分支（base）。

Mary 想要将她的功能并入主代码库，所以源分支就是她的 feature 分支，目标仓库就是 John 的公开仓库，目标分支为 master。她还需要提供一个 Pull Request 的标题和简介。

在她创建了 Pull Request 之后，GitHub 会给 John 发送一条通知。

#### John 审查了这个 Pull Request

John 可以在他自己的 GitHub 仓库下的 Pull Request 选项卡中看到所有的 Pull Request。点击 Mary 的 Pull Request 会显示这个 Pull Request 的简介、feature 分支的提交历史，以及包含的更改。

如果他认为 feature 分支已经可以合并了，他只需点击 Merge Pull Request 按钮来通过这个 Pull Request，将 Mary 的 feature分支并入他的 master 分支.

但是，在这里例子中，假设 John 发现了 Mary 代码中的一个小 bug，需要她在合并前修复。他可以评论整个 Pull Request，也可以评论 feature 分支中某个特定的提交。

为了修复错误，Mary 在她的 feature 分支后面添加了另一个提交，并将它推送到了她的 GitHub 仓库，就像她之前做的一样。这个提交被自动添加到原来的 Pull Request 后面，John 可以在他的评论下方再次审查这些修改。

#### John 接受了 Pull Request

最后，John 接受了这些修改，将 feature 分支并入了 master 分支，关闭了这个 Pull Request。功能现在已经整合到了项目中，其他在 master 分支上工作的开发者可以使用标准的 git pull 命令将这些修改拉取到自己的本地仓库。

## 配置 vs code

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

分类显示常见的 TODO/FIXME 为标签，缺点是在粘贴文本的时候 vscode 响应慢。

    Gruntfuggly.todo-tree

```json
    "todo-tree.general.tags": [
        "TODO:",
        "FIXME",
        "XXX",
        "NOTE"
    ],
    "todo-tree.highlights.customHighlight": {
        "TODO": {
            "icon": "tasklist",
            "iconColour": "magenta",
            "background": "#D0FFFF",
            "type": "tag"
        },
        "FIXME": {
            "icon": "eye",
            "iconColour": "red",
            "background": "#D0FFFF",
            "type": "tag"
        },
        "XXX": {
            "icon": "beaker",
            "iconColour": "pink",
            "background": "#D0FFFF",
            "type": "tag"
        },
        "NOTE": {
            "icon": "info",
            "iconColour": "blue",
            "background": "#D0FFFF",
            "type": "tag"
        }
    },
    "todo-tree.general.statusBar": "tags",
    "todo-tree.tree.grouped": true,
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

markdownlint 语法检查、格式化，缺点是在粘贴文本的时候 vscode 响应慢。

    DavidAnson.vscode-markdownlint

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

autoDocstring - Python Docstring Generator

    njpwerner.autodocstring

可配置文本风格

    "autoDocstring.docstringFormat": "numpy",

#### 完整模拟了 vim 的各种操作

懒得用鼠标，就它了，缺点是偶尔会乱，常按 esc 吧。。。

    vscodevim.vim

    这个插件还可以配置模拟几个著名的插件

        https://github.com/VSCodeVim/Vim#vim-airline

vim 脚本语言语法高亮

    XadillaX.viml

#### hex 颜色代码下用底色显示该颜色

vs code 1.76 之后内置了这个功能

Color Highlight

    naumovs.color-highlight

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

##### use typestub for VSCode pylance

Let pyqtgraph use PyQt6's .pyi file

    https://github.com/microsoft/pylance-release/issues/4823
        https://github.com/pyqtgraph/pyqtgraph/issues/2409

    其它的流行的库的 typestub https://github.com/microsoft/python-type-stubs/tree/main/stubs

1.Copy "QtCore.pyi/QtGui.pyi/QtWidgets.pyi" from

    ~/anaconda3/envs/p310/lib/python3.10/site-packages/PyQt6

to

    <your workspace root>/typings/pyqtgraph/Qt

or make a link for the .pyi files

You can set a separated dir for your environment in VSCode :

    "python.analysis.stubPath":"your custom dir"

2.To make aliasing work:

    import pyqtgraph as pg
    pg.Qt.QtWidgets.QPushButton('hello')

add the following:

typings\pyqtgraph\__init__.pyi:

    from . import Qt as Qt

typings\pyqtgraph\Qt\__init__.pyi:

    from . import QtWidgets as QtWidgets

3.bash shell for all above

```bash
# https://github.com/microsoft/pylance-release/issues/4823
# Modify here with your envs
ENV_BASE="${HOME}/anaconda3/envs"
ENV_DIR="${ENV_BASE}/p311"

TYPINGS_BASE="${ENV_DIR}_typestub/typings"
mkdir -p  $TYPINGS_BASE

function typestub_for_pg {
    # Modify here with your pyqtgraph pkgs
    Env_pkgs_pyqtgraph="${ENV_DIR}/lib/python3.11/site-packages/PyQt6"

    Typings_pyqtgraph="${TYPINGS_BASE}/pyqtgraph/Qt"
    mkdir -p $Typings_pyqtgraph

    cd $Typings_pyqtgraph

    echo "from . import Qt as Qt" > ../__init__.pyi

    for fname in $(ls ${Env_pkgs_pyqtgraph}/*.pyi); do
        ln -s $fname
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

#### GitHub 用 cdn 加速

jsdelivr  <https://cdn.jsdelivr.net/gh/xxx>

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

    使用 Windows 10 自带的 OpenSSH，启用服务 SSH-AGENT 的自动运行，设置 vscode 使用 Windows 10 自带的 OpenSSH，而不要用自行安装的 Git for Windows 的 ssh。开机后在 power shell 提示窗口执行一次 `ssh-add` 缓存你的密钥，后续也不会被提示输入密码了。

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

## ------------ 基于 git 分支的各种工作流 ------------

    https://www.zhihu.com/question/379545619/answer/1862411356

根据自己实际情况，用法各有不同。

### git工作流：类似 svn 的 TrunkBased 集中式工作流

    remote master -- local master(开发人员工作在此)

开发都在主干分支，拉出新的分支进行开发部署、修复BUG。

主干仅 master 分支

    适用场景：适合于单一稳定产品线，迭代排期稳定，需求边界完全可控的团队。
    优点：模型简单
    缺点：

    线上修正：假设目前系统已经发布了12.1，下一个迭代也在开发中，线上发现了问题。由于Release分支是禁止修改的，而Trunk此时包含了新的特性代码无法发布，就造成了线上异常的修复需要在分离的hotfix分支上进行，变相的造成了多个master分支。

    需求变更：无法支持，已经提交到Trunk的内容抽离很困难。

    太多的团队同时工作在主干上，到发布的时候就可能出现灾难（尤其是多版本并行开发的情况）

0、添加远程仓库

    git remote add origin 远程仓库地址

1、上班后，先确认本地无未提交未储存等等问题，处理后再继续

    git status

2、拉取远程，先看看是不是有别人提交了远程，防止互相merge新增commit

    git fetch
    git diff ..origin/master

    git status

3、从远程仓库同步本地仓库，以便同步hotfix进来。

    # git pull <远程主机> <远程分支>:<本地分支>
    git pull --rebase（从远程拉取到本地默认都是用拉直合并）

    # 标签也同步过来，不分叉的合并
    # git pull --tags --rebase origin master

4、干活，自己的代码文件各种改动。

5、下班前，提交本地仓库

    git add .

    git commit -m "提交的信息"

6、开发告一段落，可以发布时，提交远程仓库

    git pull --rebase
    git push （默认远程origin本地master）

### git工作流：改良版集中式工作流 master---dev

    remote master -- local dev(开发人员工作在此)

主干仅master分支。在本地新建其它分支，每天仅拉取远程master，更新本地dev分支。这种工作方式可以确保主干master的相对稳定。也可考虑单独添加远程 dev 分支以多人工作，参见章节 [分支推送 push]。

0、添加远程仓库，从master分支新建dev分支

    # git checkout master
    git switch master

    git pull --rebase

    git switch -c dev

1、每日工作，先确认本地无未提交未储存等等问题，处理后再继续

    git status

2、从远程仓库master同步本地仓库master

    git pull --rebase （默认远程origin本地master）

3、切换本地dev分支

    # git checkout dev
    git switch dev

4、合并本地 master 到本地dev分支，以便同步hotfix进来。

    git merge master

本地只是远程的一个镜像，以远程为准。

5、开发告一段落，可以发布时，提交dev分支，合并到master再上传远程仓库

    git checkout dev
    git add .
    git commit -m "提交的信息"

    git checkout master
    git pull --rebase

    git merge dev

    git push -u origin master

### 【推荐】git工作流： 功能分支工作流

    master --- dev(开发人员工作在此)

在上面的工作流基础上改良，把本地分支推送到远程，两个分支在本地和远程都存在，master分支保持稳定，开发工作放在dev分支，这俩都做主干分支。 CI/CD中持续集成部署在dev，持续交付部署在master。hotfix合并到远程的master分支和dev分支。

主干分支和功能分支的合并原则，见章节 [分支合并：分叉还是拉直]。

大家每日同步远程的dev分支即可工作：

    每人的本地dev各自开发一个功能点，每天只拉取dev分支，完成一部分之后，上传到远程dev以便别人可以拉取，并进行测试。

这种工作流适合多人交互式工作的复杂项目，每天dev分支都在变动，大家本地dev完成一个阶段后，就同步到远程dev分支。这样在dev分支上就可以实现每日集成测试，master分支和dev分支都可以保持相对稳定。

上班第一件事：远程 dev_xxx上的内容merge 到自己的开发分支上

    0、查看当前在git的哪个位置，是否有未提交未更新未暂存的，确保是干净的再继续

        git status

    1、切换到的本地开发分支，并查看状态

        git checkout dev_xxx
        git status

    2、将远程的 dev_xxx 同步到本地

        git pull --rebase origin dev_xxx

工作告一段落（自测通过），推送本地 dev_xxx 分支到远程 dev_xxx，以便大家拉取测试：

    0、查看当前在 git 的哪个位置，是否有未提交未更新未暂存的，确保是干净的再继续

        git status

    1、将远程的 dev_xxx 同步到本地，以保持跟大家的同步及hotfeix及时更新。

        git checkout dev_xxx
        git status

        git pull --rebase origin dev_xxx

    2、本地的修改都要做提交

        git add .

        git commit -m "@@@"

       可将本地的多次提交合并为一个，以简化提交历史

        git rebase -i

    3、将本地 dev_xxx 推送到远程

        git push origin dev_xxx

dev代码测试完毕，合并到master，正式发布：

    1、做上面的操作，先同步远程 dev_xxx

    2、将远程的 master 同步到本地。

        git checkout master
        git status

        git pull --rebase origin master

    3、将本地的dev_xxx合并到本地master

        git merge dev_xxx

    4、本地master推送到远程master

        git push origin master

    PS:

        每个git status后，根据实际情况进行处理，然后再做下一步。

        只在关键tag点，把dev分支合并到master分支，平时的操作仅限dev分支。

#### 开发分支的组织管理

服务器

    git 仓库服务器

        master 主干分支，锁定尽量少的人可以提交的权限

        dev_project_code 开发分支，开发人员自测通过的功能代码提交到这里，供测试服务器 TEST_DEV_QA 使用

        name1_dev 开发人员个人代码的分支，每日工作代码提交一次，用于备份代码、度量工作量等

    TEST_DEV 测试服务器，开发人员本机或一个单独的服务器，给开发人员自测使用，这里的 CI/CD 报告的变动是最大的

    TEST_DEV_QA 联调测试服务器，单独的产品环境，定期拉取开发分支，CI/CD 的相关报告用于整体把控

    TEST_MA_QA 产品测试服务器，单独的产品环境，定期拉取主干分支，CI/CD 的相关报告用于整体把控

分支管理

    在主干分支上选取一个节点，拉取开发分支

           这里要打个起点标签，对应主干分支的commitid，如 ma_84F663B
           dev -- ...
        master -- ...

主干分支除了合入新增功能点用菱形合并，日常只合并新的hotfix做拉直合并，如果之前的功能点又发现bug，走 hotfix 或者把问题列入版本引入bug清单，等下个版本再改。

开发工作过程描述

    在管理层级上，把代码变化缩小在个人：开发人员从开发分支拉取新建本地分支（在git仓库服务器建立 name1_dev 的远程分支），个人代码在本机虚拟机测试或TEST_DEV服务器测试，工作围绕 TEST_DEV 测试服务器的 CI/CD 流程。

    如果各功能点互相有依赖，则初始的功能点的接口优先写好提交开发分支，先返回约定内容，以大家能正常开发本地代码、联调测试服务器不会出现接口错误报告为目标即可。

    如果有依赖它人功能的需求，cherry-pick 个人分支 name2_dev 的变更到自己的分支，尽量缩小变化范围，自己的功能可以开发即可，其它留待后期的集成测试。

    开发人员负责的功能点开发完成，自测通过后，建立本地的合并分支:

        按功能点压缩 commit （必要时squash），拉直合并到开发分支，推送远程。各开发人员提交的功能点可以进行验证和联调，工作围绕 TEST_DEV_QA 测试服务器的 CI/CD 流程。

        这一步用 beyondcompare 比对合入代码比较方便，目的是精简commit点，以功能点为单位提交，方便后续的维护。

    开发分支的延展情况一般是如下形态

        （起点标签）
        dev -- fea1 -- _fea2 -- ... -- fea1_fix -- fea2_fix --...

    所有人的功能点都开发完成，产品的集成测试通过后，锁定开发分支，建立合并分支：

        由 QA 人员从开发分支的起点拉取一个单独合并用的分支 dev_merge，所有的开发人员从已经锁定的开发分支，按功能点压缩 commit （必要时squash），拉直合入。

        这一步用 beyondcompare 比对合入代码比较方便，目的是精简commit点，以功能点为单位提交，方便后续的维护。

            （dev起点标签）
            dev_merge   -- fea_1 -- fea_2 -- fea_3 -- fea4 -- ...

    开发人员以合并分支 dev_merge 作为基础，再次进行集成测试的修改工作，这个过程应该不耗费多少时间，因为需要做的修改已经很少了。

    在完整的 CI/CD 流程走完后，由专人负责整理合并(菱形合并)到上层主干分支，发布版本

                             fea_1 -- fea_2 -- patch1 -- ...
                            /                               \
        master --（起点标签） -- ...                         -- v1.1 -- hotfix -- ...

    版本发布后，当前开发分支可以废弃，后续还是从主干分支选取节点拉开发分支，进行新的开发工作的循环

如果功能众多

    敏捷开发的迭代过程追求快速追求变化，最好不要太多功能，这样会把迭代周期拉长

    可以把各功能点根据人力分配情况，按周划分完成点，从一个项目拆解成细化周期的多个项目的集合。

    如果真的是一个人数众多的大工程，在管理层级上，把开发分支的变动分布在各功能小组：

        各小组从开发分支（起点标签）拉取为小组级别的分支，各小组有自测服务器，套娃上面的开发过程

### git工作流：开源代码

如果一个代码经常重构，要考虑个问题

    一个分支目录结构的稳定非常重要，配置文件的位置也不要经常变化

开源代码由于参与人众多，虽然主要功能不变，但是项目的架构可能变化，适用条件和目录结构也会经常发生很大变化。

而 git 的初始拉取操作，都是操作 master（main），即使你需要其它分支，git 初始目录建立后默认就是 master 分支，在 git clone 后再手工切换其它。

通常的 master 分支用法，变动都在 master 分支，一直保持面向用户的最新。如果有大变化，就从 master 分支分叉出单独分支如老版本v1，稳定版本单独分支stable，测试版本单独分支testing。每次要搞新架构，master 分支就再分叉出一个老版本分支v2，而 master 分支自己一直保持最新。

这样的 master 分支其实已经是另起炉灶，甚至整个代码的组织结构都可能变了。

一年下来这么搞几次，master 分支的代码其实没有任何延续性可言了：当前代码跟 3 个月前的完全不一样，3 个月前的跟 6 个月前的也完全不一样…… 原因就在于 master 版本一直保持最新，虽然分叉后的老版本 v1、v2、v3 分支的变化相对稳定，但是他们之前的所有变化都在 master 分支里，实质上使得 master 分支的后向兼容基本没有，前后对比的可读性非常差。

这样重复几次，master 分支的目录结构和配置文件**经常**发生较大变化，不仅使其它开发者混淆，而且会使之前引用该项目 master 分支的其他项目出现问题。而打标签tag的方法只适用于一条分支上的变更跟踪，不能直观的依赖其他分支的变化。对新手来说，使用起来更是一头雾水，半年前 git clone 还能直接使用的项目，现在怎么就不行了，怎么有些文件保存的位置变了，本地多出来相同的好几份？

解决办法是：

main 分支不保存主干代码，只存放 Redadme、License、安装脚本等稳定不变的文件，随时间延续带来的变化，把程序的主代码分离到并行的 v1、v2、v3 的分支上，这些分支都是主干，主要区别就是目录结构和文件位置等，其中有一个是最新的主打分支如v3。主代码放到非 master 分支的主要目的是把本分支的变化稳定住，可以随时间变迁而变化，但是基本组织结构一直不变，用法习惯一直不变。如果最新的 v3 分支需要做大的结构变动，直接分叉一个干净的 v4 分支。v3 分支成为老版本，v4 分支保持最新。

一个分支本身尽量后向兼容，使本分支代码的延续性好，便于开发和使用者理解。不仅使老版本对老用户的友好度非常大，对新手使用也简单方便，对项目版本升级也更容易理解。开发方面，版本bug管理也非常方便，参与者 git colne 拉取代码后，想修改哪个版本的代码直接 git checkout 即可。

参见 zsh4humans 的分支组织

    https://github.com/romkatv/zsh4humans

在线安装脚本中指定分支即可

    if command -v curl >/dev/null 2>&1; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
    else
      sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
    fi

写在 master 分支的 Readme.md 中如有大版本升级只需要变更几个字母，非常方便引导用户使用，也方便开发人员维护。

或在 master 分支摆放安装、升级脚本，在脚本内部判断版本进行引导，只需要各分支代码都有一个专门的标识文件，标明自己的软件名称、分支、版本，便于安装脚本判断是否已经存在、是否需要升级。

### git工作流： Gitflow工作流

    汉化 https://zhuanlan.zhihu.com/p/38772378
        https://zhuanlan.zhihu.com/p/36085631
        原文 https://nvie.com/posts/a-successful-git-branching-model/

    流程图片 https://nvie.com/img/git-model@2x.png

    改进：抛弃 Git Flow 的 8 大理由 https://baijiahao.baidu.com/s?id=1661688354212771172&wfr=spider&for=pc

这个流程是功能分支工作流的进一步扩展，适合长期稳定的商用项目，适合的是需要『多个版本并存』的场景。

    master -- develop -- feature(开发人员工作在此)

适用场景：处于前中期的大型项目，人员较多管理场景较复杂，但是迭代相对稳定，周期内不会频繁的变更需求，尽量不要开长需求分支。

缺点

    需求变更：不够灵活，由于主分支实际上是基于develop，那意味着一旦代码提交上去，一段时间后需要撤销（本次迭代不发布）就比较困难

    Git flow 导致团队产生大量的、集中的 Pull request merge ，非常有限的优秀工程师把时间都浪费在了处理这些 merge 上面。

    适合传统企业集中开发的情况，项目周期几个月的那种。对互联网企业的持续交付快速迭代，每天产生大量新代码，测试还没做几个，下一个版本的的部署又开始了，会应对不过来。

版本格式：主版本号.次版本号.修订号，版本号递增规则如下：

    主版本号：当你做了不兼容的 API 修改，
    次版本号：当你做了向下兼容的功能性新增，
    修订号：当你做了向下兼容的问题修正。
    先行版本号及版本编译信息可以加到“主版本号.次版本号.修订号”的后面，作为延伸。

master分支很少变动，head始终对应生产环境代码。由master分支v0.1拉出来develop分支v0.1（打tag），每个开发组在develop分支v0.1基础上做自己的feature分支v0.1。 版本演进策略是master上的修改用0.1，0.2……，小版本修改用0.1.x,0.2.x……感觉x可以用整个版本周期的第几周第几天小时分钟做编码。

    开发状态时，功能组每人只负责feature分支v0.1.x（打tag），hotfix合并到master分支和develop分支，打tag v0.2。

    功能开发完成时feature分支v0.1.x冻结，功能组把feature分支v0.1.x合并入develop分支v0.2.x，打tag v0.3，拉出release分支tag v0.3。可以删除相关的feature分支v0.1.x 。

    这时就进入了测试除虫阶段，此时功能调整在release分支v0.3.x上，bug解决同时合并入release分支和develop分支（注意这里dev和release代码是有差异了），hotfix合并到master分支v0.4和develop分支v0.4（打tag）。

    在这个阶段，如果有新功能需要在develop分支上演进，则从release分支v0.4.x合并入develop分支打tag v0.5，再拉出新feature分支v0.5，以保证当前release分支0.4.x不混入新feature。hotfix合并到master分支v0.6和develop分支v0.6（打tag）。

    都完成后release分支v0.4.x合并入develop分支v0.6和master分支v.0.6，打tag v1，然后可以删除相关的release分支v0.4.x。

    之前新feature分支v0.5.y已经开发一段时间了，到版本点的时候进入下一个v1.x的工作流程循环。这个对CI/CD的定制化要求就比较高了。

注意 hotfix需要合入master和develop两个分支，其他分支只要同步这俩，就要更新大版本号。

### git工作量：阿里巴巴 AoneFlow

    从master上拉出feature分支，相关feature分支合并出release分支最终合入master

只使用三种分支类型：主干master、特性分支feature、发布分支release，以及三条基本规则。

    开始工作前，从master创建各个feature分支。

    从master创建release分支，合并相关的feature分支。

    发布到线上正式环境后，合并release分支到master，在master添加标签，同时删除该release分支关联的feature分支。

![AoneFlow工作流](https://pic3.zhimg.com/80/v2-583eeedc612c4e0700a4e4dc003afd5e_720w.jpg)

保证master分支可用和随时可发布，其他可能都是临时分支，所以取名的时候应该是Ali-One-Flow。临时分支的组装就有很多种玩法了，需要企业根据自己的需要来定制处理。

master分支上的最新版本始终与线上版本一致，如果要回溯历史版本，只需在master分支上找到相应的版本标签即可。

上线后的 Hotfix，正常的处理方法应该是，创建一条新的发布分支，对应线上环境（相当于 Hotfix 分支），同时为这个分支创建临时流水线，以保障必要的发布前检查和冒烟测试能够自动执行。但其实还有一种简便方法是，将线上正式环境对应的发布分支上关联的特性分支全部清退掉，在这个发布分支上直接进行修改，改完利用现成的流水线自动发布。如果非得修一个历史版本的 Bug 怎么办呢？那就老老实实的在主干分支找到版本标签位置，然后从那个位置创建 Hotfix 分支吧。

优点

    应对敏捷开发的功能删减等大变动，重建release非常简单，删除原release分支，重新合并多个feature分支即可。不需要从release分支逐个查找回退代码。

    发布分支之间是松耦合的，这样就可以有多个集成环境分别进行不同的特性组合的集成测试，也能方便的管理各个特性进入到不同环境上部署的时机。

    可用多release分支对应测试环境/生产环境/开发自测环境等，或一个release分支对应多个环境。

    按迭代演进的计划，串联多个feature分支，实现流水线组装式的release分支，CI/CD在每个阶段都能顺利做起来。

缺点

    特性分支与发布分支的关联关系维护有点复杂。最好是在一个整体流程的自动化的平台下管理维护，该平台实现从需求提出，功能拆分，创建feature分支，组合release分支，生成部署环境，创建测试流水线，代码审查流水线，安全检查，在线部署等一系列步骤的自动化，最终实现端到端交付的研发自动化体系。

## DevOps

    https://www.zhihu.com/question/58702398

一个软件从零开始到最终交付，大概包括以下几个阶段：产品规划、开发编码、构建、QA测试、发布、部署和维护。 对庞大项目的快速开发、快速部署、快速维护，使用敏捷开发快速迭代，在生命周期的各个阶段进行闭环处理流程，需要拆解各个过程，还得使之互相促进，实现一个端到端的自动化的联合流程，从而催生出了 DevOps。

敏捷开发的闭环流程，在开发阶段即引入了运维过程，开发、测试、部署、运维持续优化。为需要将原来黑盒化的一个整体产品进行拆分（解耦），从一个提供多种服务的整体，拆成各自提供不同服务的多个个体，所以特别适合虚拟化、容器、微服务。

拆分解耦是最终的出路，将项目拆成一个个小的服务单独部署，以电商项目为例，将整个项目拆分为用户服务，商品服务，订单服务，积分服务......每个服务单独部署，之间通过互相调用的方式来交互，而且可以将一些基础服务例如上传图片，发送短信等很多服务都需要的基础东西，抽象到一个单独的服务，也就是前些年流行的‘中台服务’。

在DevOps的流程下，运维人员会在项目开发期间就介入到开发过程中，了解开发人员使用的系统架构和技术路线，从而制定适当的运维方案。而开发人员也会在运维的初期参与到系统部署中，并提供系统部署的优化建议。

微服务: 微服务（英语：Microservices）是一种软件架构风格，它是以专注于单一责任与功能的小型功能区块 (Small Building Blocks) 为基础，利用模块化的方式组合出复杂的大型应用程序，各功能区块使用与语言无关 (Language-Independent/Language agnostic）的API集相互通信。对api的调用管理设计了专用的网关服务器，甚至还有路由功能哦。。。

在微服务架构下，不同的工程师可以对各自负责的模块进行处理，例如开发、测试、部署、迭代。虚拟化，其实就是一种敏捷的云计算服务。它从硬件上，将一个系统“划分”为多个系统，系统之间相互隔离，为微服务提供便利。容器化就更彻底了，不是划分为不同的操作系统，而是在操作系统上划分为不同的“运行环境”（Container），占用资源更少，部署速度更快。开发、测试、部署的几个部分都可以非常快速的实现交互测试和闭环处理流程。

这种架构下的开发模式DEVOPS，运维需要做的上线工作，主要就是将代码部署到对应的机器里面，微服务有那么多的服务，每个大点的公司几百个服务不算多，而且还可能随时搞一个服务出来，如果还按照原始的脚本部署方式，可能最后连是哪个脚本都找不到。

运维需要做的事情，慢慢的都沉淀到了各个平台上面，例如监控，有专门的监控组件和可视化，基础服务例如服务器，CDN，负载均衡等基础服务可以外包到云服务厂商，日志也有专门的日志工具，链路追踪也有专门的组件和可视化，还有负责api调用指向的网关等，渐渐的，只要这些都配置好了，开发也可以做运维的部分工作，毕竟开发才是最了解代码的人，哪里出了问题看看监控日志，可以最快速度定位到问题，于是DEVOPS开发模式诞生了，开发也是运维。

devops平台搭建工具

    项目管理（PM）：jira + bitbucket。运营可以上去提问题，可以看到各个问题的完整的工作流，待解决未解决等；

    代码管理：gitlab。jenkins或者K8S都可以集成gitlab，进行代码管理，上线，回滚等；集成了代码检测扫描，自动化测试，灰度，上线这一系列的操作。

    持续集成CI（Continuous Integration）：gitlab ci。开发人员提交了新代码之后，立刻进行构建、（单元）测试。根据测试结果，我们可以确定新代码和原有代码能否正确地集成在一起。

    持续交付CD（Continuous Delivery）：gitlab cd。完成单元测试后，可以把代码部署到连接数据库的 Staging 环境中更多的测试。如果代码没有问题，可以继续手动部署到生产环境中。

    镜像仓库：VMware Harbor，私服nexus

    容器：Docker

    编排：K8S

    服务治理：Consul、zookeeper、etcd

    脚本语言：Python

    日志管理：Cat+Sentry、ELK(Elasticsearch + Logstash + Kibana )

    系统监控：Prometheus + 仪表盘 Grafana

    负载均衡：Nginx。

    API网关：Kong

    链路追踪：Zipkin

    产品和UI图：figma、蓝湖，Balsamiq、Mockplus和Axure RP的 原型设计派系、Sketch、Adobe XD、墨刀 组件细节派系。

    公司内部文档：Confluence。

    报警：推送到工作群。

    上面的组件都是分离的，可以考虑微服务架构体系的组件合集 Spring Cloud: Eureka、Ribbon、Feign、Hystrix、Zuul

有了这一套完整的流程工具，整个开发流程涉及到人员都可以无阻碍的进行协调工作了，开发每天到公司，先看看 jira,看看线上日志，出了问题看看监控日志，运营同学反馈问题不着急的去 jira，着急的群里吆喝，产品和 UI 的图直接蓝湖看，运维关注监控着大盘，改革春风开满地，互联网人民真高兴~。

## 竞品 -- 基于文件差异(patch)的源代码管理系统

当前流行的 svn/git/hg，都是基于 snapshot 而不是基于 patch 的。

基于文件差异(patch)的源代码管理系统，可以随意加入、撤销、重排历史上任意没有依赖关系的改动，并且保持单个 Commit（Change）的 Hash 以及得到的结果不变。

    pijul https://pijul.org/

    darcs 不如 pijul http://darcs.net/

    原理 https://jneem.github.io/merging/
            https://arxiv.org/abs/1311.3903

        https://segmentfault.com/a/1190000013648329

处理方式不同，某些 git 上很繁琐的事情在这里就简化了。

1、假设以下的场景：在开发 feature 分支上，发现 master 分支上有一个 bug，影响到新功能的开发，所以在 feature 分支上修了，然后 cherry-pick 到 master 分支上来。后来由于业务上的变动，master 分支去掉了这个修复。当我们合并 feature 分支后，这个修复又会重新出现在 master 分支。

在基于 patch 的版本控制系统没有这个问题，在它们眼里，无论在哪个分支上，同样的修改都是同一个 patch。在合并时，它们比较的是 patch 的多寡，而非 snapshot 的异同。同样的道理，基于 patch 的版本控制系统，在处理 cherry-pick，revert 和 blame 时，也会更加简单。

参见 <https://jneem.github.io/pijul/> 的 [Case study 1: reverting an old commit]。

2、基于 snapshot 的版本控制系统，在合并时采用三路合并（three-way merge）。比如 Git 中合并就是采用递归三路合并。所谓的三路合并，就是 theirs(A) 和 ours(B) 两个版本先计算出公共祖先 merge_base(C)，接着分别做 theirs-merge_base 和 ours-merge_base 的 diff，然后合并这两个 diff。当两个 diff 修改了同样的地方时，就会产生合并冲突。

如果是基于 patch 的版本控制系统，会把对方分支上多出来的 patch 添加到当前分支上，效果看上去就像 git rebase 一样。也就是说，某些在 git 中会出现冲突的合并，在 pijul 中不会出现。

参见 <https://jneem.github.io/pijul/> 中 [Case study 2: parallel development]。

3、如果添加过程中发生了冲突怎么办？

patch 有两个重要的属性：

    假设 patch B 依赖于 patch A，patch C 依赖于 patch B，B 可以在 A 和 C 之间自由移动而不改变最终结果。这种移动操作称之为 commute。

    每个 patch 都有一个对应的 inverse patch，可以把这个 path 引入的修改去掉。

darcs 在处理合并冲突时，会先添加若干个 inverse patch，回退到可以直接添加 patch 的时候。额外添加的 inverse patch 和之前有冲突的 patch 合并在一起，成为一个新的 patch。这其中可能还会有 commute 操作来移动 patch 到适当的位置。

通常对于差别较大的 Git 分支，不建议用 rebase 操作，因为 rebase 过程中，可能会发生因为修复冲突带来的往后更多的冲突 - 冲突的滚雪球效应。darcs 的合并，也会有同样的问题，一个合并操作耗费的时间可能会遇上指数爆炸。

pijul 通过引入名为有向图文件（directed graph file，以下简称为 digle）的数据结构，解决了这个问题。由 digle 表示的数据结构能够保证不会发生合并冲突。这意味着，我们可以用 digle 作为 patch 的内部实现，这样两个 patch 的合并就是两个 digle 的合并，而 digle 的合并是不会产生冲突的。这么一来，合并过程中就不会有滚雪球效应了，我们可以在最后把 digle 具象成实际的 patch 的时候，才开始解决合并冲突。

pijul 的 merge 有两个优点：

    最终结果跟用了 git rebase 一样，能够保证历史是单线条的。

    由于 merge 过程中能够参考中间各个 patch 的信息，合并的效果理论上应该比简单粗暴的三路合并要好。
