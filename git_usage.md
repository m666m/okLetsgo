# git 源代码分支管理

程序开发，大部分都是在处理源代码这种文本文档，期间会对同一文件反复修改，为记录变更，便于回溯或多次修改、同步变更等操作，版本控制软件专门处理这种工作，git 是以文本文件的文字差异为基准进行差异比对的，再此基础上衍生出分支管理等功能。

所以，使用 git 这种文件比对的分支管理

    目录结构和文件名尽量不删不改

    按功能点组织代码，可拆分多个文件

    尽量不删文件，更不要删除目录

有个竞品 pijul

    基于文件差异的补丁式源代码管理系统，可以随意加入、撤销、重排历史上任意没有依赖关系的改动，并且保持单个 Commit（Change）的 Hash 以及得到的结果不变。

    https://pijul.org/
        原理 https://jneem.github.io/merging/
            https://segmentfault.com/a/1190000013648329

## 参考文档

善用 git 帮助查找命令 `git help branch`

    使用 Git hub <http://www.cnblogs.com/zhangjianbin/category/934478.html>

    git的几种工作流 <https://www.zhihu.com/question/20070065/answer/1174997617>
                   <https://zhuanlan.zhihu.com/p/79668697>
                   <https://www.cnblogs.com/pluto4596/p/11464819.html>

    git官方文档 <https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E5%BC%80%E5%8F%91%E5%B7%A5%E4%BD%9C%E6%B5%81>

    命令参考 https://git-scm.com/docs

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

## 何时使用git而不是svn

因为git就是给开源准备的，适合开源方式开发的就适合用git。

    源代码、配置文件等文本文件占比大的项目，用git，少量的二进制文件可以用 git-lfs 管理。

    二进制文件较多的项目，比如游戏、艺术、摄影等，用svn更合适。

    如果是一个较大的项目，目录众多，管理权限设置分门别类，人员权限各有不同，用svn。

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

有了这一套完整的流程工具，整个开发流程涉及到人员都可以无阻碍的进行协调工作了，开发每天到公司，先看看jira,看看线上日志，出了问题看看监控日志，运营同学反馈问题不着急的去JIRA，着急的群里吆喝，产品和UI的图直接蓝湖看，运维关注监控着大盘，改革春风开满地，互联网人民真高兴~

## git 客户端初始化

git通过ssh客户端连接github。除了github这样的，私有仓库都需要用户鉴权才能读取文件。

    https://git-scm.com/download/win
        https://github.com/git-for-windows/git/

### 1.ssh客户端的设置

生成 ssh key 文件，默认回答都是一路回车

    ssh-keygen -t ed25519

如果 ~/.ssh 目录是手工复制的，需要设置权限

    cd ~

    # 设置.ssh目录权限
    chmod 700 -R .ssh

添加本机用户的公钥到远程仓库git用户的认证密钥文件中，以便后续ssh免密登陆

    ssh-copy-id -i ~/.ssh/id_ed25519.pub -p 2345 git@xx.xx.xx.xx

### 2.设置 gitub 使用 ssh 密钥方式管理代码库

登陆你的github帐户，点击你的头像，然后 Settings。

-> 左栏点击 Emails -> 右侧页面勾选 “Keep my email addresses private”、 “Block command line pushes that expose my email”、“Only receive account related emails, and those I subscribe to.”。 复制页面中提示的 noreply 电邮地址，后面要用。

-> 左栏点击 SSH and GPG keys -> 点击 New SSH key

在你本地机器登陆账户的主目录下的 ~/.ssh 目录，复制下面的文件内容粘贴进去

    cat ~/.ssh/id_ed25519.pub

git colne一个项目，然后查看是否此项目是使用https协议

    git remote -v

    # 改为 git 协议
    git remote set-url origin git@github.com:m666m/yourproject.git

验证：

    # 如果超时，就多试几次，国内的网络环境太差
    $ ssh -T git@github.com
    Received disconnect from 20.205.243.166 port 22:11: Bye Bye
    Disconnected from 20.205.243.166 port 22

    # 如果你在已有的github项目目录下，是这个提示
    $ ssh -T git@github.com
    Hi m666m! You've successfully authenticated, but GitHub does not provide shell access.

    # 登陆问题排查
    ssh -v git@github.com

如果未设置过git用户名和邮箱，注意填写前面复制的 github 的 noreply 电邮地址。

    # 查看 git config --global --list
    git config --global user.name "m666m"
    git config --global user.email "31643783+m666m@users.noreply.github.com"

如果是在已有的项目文件夹里，注意检查是否需要更新用户名和电邮地址

    git config user.name

    git config  user.email

图形化的 git 客户端

    Git GUI 的 Visualize All Branches History 功能可以图形化的方便查看提交历史

    https://www.sourcetreeapp.com/

## git仓库初始设置

### 建立本地仓库：Git 工作区、暂存区和版本库

你的文件有3种存在：仓库区 ----> 暂存区 ----> 工作区

    初始状态工作区的文件就版本库的文件，暂存区是空的，版本库没变化

    当你修改了文件，则工作区文件的状态是修改，暂存区是空的，版本库没变化

    当你执行了 git add，修改的文件添加到了暂存区，这时你在工作区的文件和暂存区是一致的，版本库没变化。

    所有修改都验证无误之后，git commit提交到版本库，这时三个区的文件都一致了。

    文件每添加到一个区域，有对应的回退步骤，见章节[如何回退]

git 的很多命令操作都是区分这几个区的，如git fetch、git diff，参数不同意义不同，使用时注意区分。一般执行一个操作之后运行 git status 查看当前状态，git也会出下一步操作的建议。

工作区 work space：就是你建立的源代码目录

    mkdir my_proj

版本库或本地仓库 Repository ：在工作区执行 git init 命令就会建立隐藏目录 .git，就是Git的版本库。

    cd my_proj

    git init

暂存区 stage 或 index：一般存放在 .git 目录下的index文件（.git/index）中，所以我们把暂存区有时也叫作索引（index）。新增的文件，需要git进行管理了，执行 git add 命令添加。

    cd my_proj
    touch abc.txt

    git add .

引入暂存区的目的，是你的修改方便使用 git diff 查看跟之前提交的对比，检验是否正确修改了，而且便于修改回退。详见章节 [如何回退版本]。

git做操作之前或操作之后，查看当前的git状态

    git status

确认所有的修改都正确之后，提交到版本库

    git commit -m '初始化提交'

版本库推送远程仓库见章节 [远程仓库拉取和推送的各种情况]

### 修改本地仓库的远程仓库地址

github.com获取仓库默认给的是https地址，但是在国内的网络下经常连接超时，使用不变，改成git协议或ssh协议的地址格式相对好些

    # 删除远程origin
    git remote rm origin

    # 重新添加远程origin
    # git remote add origin sqt@180.169.33.117:repositores/ZSKPad.git
    git remote add origin git@github.com:m666m/raspi-info.git

    # 非 github 的 ssh 地址，需要用户名
    git remote add origin ssh://git@<ip>:<port>/your_path/xxx.git
    git branch --set-upstream-to=origin/<branch> master

    # 第一次push的时候要 -u
    git push -u origin master

其实，执行添加了 -u 参数的命令 git push -u origin master就相当于是执行了

    git push origin master

    和

    git branch --set-upstream master origin/master

所以，在进行推送代码到远端分支，且之后希望持续向该远程分支推送，则可以在推送命令中添加 -u 参数，简化之后的推送命令输入。

### 从本地仓库推送多个远程仓库

1、一般使用中，可以默认fetch/push一个远程仓库，添加多个push远程仓库地址，这样可以实现代码的多处备份，而且默认的origin还存在。

远程仓库地址格式

    ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/myproj.git

    git@github.com:m666m/okLetsgo.git

    https://github.com/m666m/myproj

方法一、推送命令只会推送到默认的origin地址，其他的各个server1，2，3得再挨个执行push命令

    git remote add server1 ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/project_name.git

    git remote add server2 ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/project_name.git

    git remote add server3 ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/project_name.git

    git push server1 master

    git push server1 developer

方法二、省事的方法，给origin添加多个push远程地址(upstream)，默认fetch还是origin最早添加的地址

    git remote set-url --add origin ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/project_name.git

    $ git remote show origin
    * remote origin
    Fetch URL: git@github.com:m666m/project_name.git
    Push  URL: git@github.com:m666m/project_name.git
    Push  URL: ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/project_name.git
    HEAD branch: main
    Remote branch:
        main tracked
    Local branch configured for 'git pull':
        main merges with remote main
    Local ref configured for 'git push':
        main pushes to main (up to date)

    $ git remote -v
    origin  git@github.com:m666m//project_name.git (fetch)
    origin  git@github.com:m666m//project_name.git (push)
    origin  ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/project_name.git (push)

添加后，本地项目中的.git/config 对应内容如下

    [remote "origin"]
        url = git@github.com:m666m/project_name.git
        fetch = +refs/heads/*:refs/remotes/origin/*
        # url = https://github.com/m666m/project_name.git
        url = ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/project_name.git

如果想删除

    git remote set-url --delete origin ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/project_name.git

2、一个本地库同步到另外两个远程库，不使用origin

    https://www.runoob.com/git/git-gitee.html

真正的多套远程地址

    git remote rm origin

    # 远程库的名称叫 gitee 和 github，没有 origin 了。
    git remote add github git@github.com:tianqixin/runoob-git-test.git
    git remote add gitee git@gitee.com:imnoob/runoob-test.git

使用起来比较麻烦，fetch/push需要多次操作，需要支持远程仓库的名称和分支名称

    git push github master

    git push gitee master

### 从远程仓库下载到本地仓库 git clone

    https://www.w3cschool.cn/git/git-uroc2pow.html

支持多种协议，Git 协议下载速度最快，SSH 协议用于需要用户认证的场合。

Git

    git clone git://example.com/path/to/repo.git [默认当前目录]

    # 特殊，对 “git@github.com” 开头，默认用git协议，在冒号后是用户名
    git clone git@github.com:user_name/repo.git

    $ ssh -T git@github.com
    > Hi username! You've successfully authenticated...

SSH

    # 对 “用户名@地址” 开头，默认 ssh 22 端口
    git clone [user@]example.com:/path/to/repo.git

    # 非标准22端口要写明确写协议名
    git clone ssh://[user@]example.com:port/path/to/repo.git

    # github网站提供基于https的ssh连接方式 https://docs.github.com/zh/authentication/troubleshooting-ssh/using-ssh-over-the-https-port
    git clone ssh://git@ssh.github.com:443/YOUR-USERNAME/YOUR-REPOSITORY.git

    # 对ipv6地址加[]即可
    git clone ssh://user@[20:40:d:9f::1]:22122/path/to/repo.git

Http、Https

    git clone http[s]://example.com/path/to/repo.git
    git clone http://git.oschina.net/yiibai/sample.git

File

    git clone /opt/git/project.git
    git clone file:///opt/git/project.git

其它

    git clone ftp[s]://example.com/path/to/repo.git
    git clone rsync://example.com/path/to/repo.git

#### git clone之后的第一次pull和push

先看有几个远程

    git remote show

查看远程，配置

    $ git remote show origin

    Warning: Permanently added the RSA host key for IP address '1xx.1xx.1xx.1xx' to the list of known hosts.
    * remote origin
    Fetch URL: git@github.com:m666m/okLetsgo.git
    Push  URL: git@github.com:m666m/okLetsgo.git
    HEAD branch: master
    Remote branch:
        master tracked
    Local branch configured for 'git pull':
        master merges with remote master
    Local ref configured for 'git push':
        master pushes to master (up to date)

如果pull和push未关联，需要关联

    # 将本地的master分支推送到origin主机，同时指定origin为默认主机
    git push -u origin master

#### 本地空目录，远程裸仓库里有文件

git clone 命令正常拉取

    git clone ssh://git@xx.xx.xx.xx:2345/gitrepo/tea.git [新目录名字]

    # Ipv6 用标准的中括号方式：
    #
    $ git clone ssh://git@[299:4c:c:8da::2]:2345/ghcode/gitrepo/tea.git
    Cloning into tea...
    warning: You appear to have cloned an empty repository.

这样本地目录里就会多了个tea的目录，这个目录已经是git管理的仓库了，远端服务器的信息都已经配置了。

#### 本地空目录，拉取远程刚建好的空白裸仓库

刚建好的裸仓库无内容，直接用clone拉是可以的，但是后续做pull和push会报错

解决办法是，先在本地目录 git init，设置远程推送地址，给远程仓库上传个文件，然后再拉取。

0.远程服务器建立裸仓库，略

1.本地操作，新建文件夹，git初始化，添加远程仓库地址

    $ mkdir tea

    $ cd tea

    $ git init
    Initialized empty Git repository in C://tea/.git/

    $ git remote add origin ssh://git@xx.xx.xx.xx:2345/gitrepo/tea.git

3.本地操作，先提交个文件，推送远程，否则直接pull会各种报错

    echo 'init bare git repo, add a file' > readme.md
    git add readme.md
    git commit -m 'init bare git repo'

    git push origin master

4.本地操作，拉取文件，先绑定远程

    # git pull --rebase origin master

    $ git branch --set-upstream-to=origin/master master
    Branch 'master' set up to track remote branch 'master' from 'origin'.

    $ git pull
    Already up to date.

5.本地操作，正常了，看下origin设置，是不是pull和push都有配置了：

    $ git remote show origin
    * remote origin
      Fetch URL: ssh://git@xx.xx.xx.xx:2345/gitrepo/tea.git
      Push  URL: ssh://git@xx.xx.xx.xx:2345/gitrepo/tea.git
      HEAD branch: master
      Remote branch:
        master tracked
      Local branch configured for 'git pull':
        master merges with remote master
      Local ref configured for 'git push':
        master pushes to master (up to date)

    $ git status
    On branch master
    Your branch is up to date with 'origin/master'.

    nothing to commit, working tree clean

#### 本地空目录，仅拉取指定远程分支的用法

    git clone -b dev 代码仓库地址 （dev是分支名称）

或fetch下来再建个本地分支

    git init
    git remote add origin git@github.com:m666m/nothing2.git

    git fetch origin dev（dev即分支名）

    $ git branch -av
    * master                 8d96022 3
    remotes/origin/HEAD    -> origin/master
    remotes/origin/dev        b414ac9 功能3
    remotes/origin/master  8d96022 3

    git checkout -b dev(本地分支名称) origin/dev(远程分支名称)
    git pull --rebase origin dev(远程分支名称)

又一个方法

    只想要fetch其他的分支，比如dev：

    git remote set-branches origin dev
    git fetch --depth 1 origin dev
    git checkout -b dev origin/dev

#### 本地非空目录，拉取远程非空裸仓库

本地先 git init，然后

    git remote add origin ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/okletgo.git

这时显示结果

    $ git remote show origin
    * remote origin
    Fetch URL: ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/okletgo.git
    Push  URL: ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/okletgo.git
    HEAD branch: (unknown)

把文件都push上去，会提示没有上游分支，直接推。

这时显示结果，正常了

    $ git remote show origin
    * remote origin
    Fetch URL: ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/okletgo.git
    Push  URL: ssh://git@xx.xx.xx.xx:2345/ghcode/gitrepo/okletgo.git
    HEAD branch: master
    Remote branch:
        master tracked
    Local branch configured for 'git pull':
        master merges with remote master
    Local ref configured for 'git push':
        master pushes to master (up to date)

#### 本地非空目录，远程仓库无本地分支的push用法

    远程没有remote_branch分支，本地已经切换到dev_xxx

        git push origin dev_xxx:remote_branch

    远程已有dev_xxx分支但未关联本地分支dev_xxx，本地已经切换到dev_xxx

        git push -u origin/dev_xxx

    远程已有dev_xxx分支并且已经关联本地分支dev_xxx，本地已经切换到dev_xxx

        git push

#### 大仓库非全量拉取（shallow clone）

对比较大且未清理的大仓库，克隆仓库这个仓库，会把所有的历史协作记录都clone下来。其实对于我们直接使用仓库，而不是参与仓库工作的人来说，只要把最近的一次commit给clone下来就好了。

适合用 git clone --depth=1 的场景：你只是想clone最新版本来使用或学习，而不是参与整个项目的开发工作

    git clone --depth 1

进一步精简，拉取指定分支的最近一次提交的版本

    git clone --depth 1  --branch dev_xxx

这样clone的仓库，如果你只是用来查看最新内容或者直接编译那无所谓，但是如果是要像正常仓库一样操作还是有些区别的

    使用了--depth克隆的仓库就是一个浅克隆的仓库，并不完整，只包含远程仓库的HEAD分支。

    没有远程仓库的tags。

    不fetch子仓库(submodules)。

    即使你使用gi fetch，也不能把完整仓库fetch下来(config文件可以看到,remote.origin.fetch的值是+refs/heads/master:refs/remotes/origin/master)

#### 拉取指定目录（稀疏检出sparsecheckout）

git的指定目录拉取，对于灵活选取仓库资源非常有帮助

    https://zhuanlan.zhihu.com/p/602129987

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

    两个分支的 examples 目录的位置不同，分别检出

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

对于目录中多余的文件，在稀疏检查时不会去处理，类似切换分支对非git管理文件的处理效果。

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

## 使用git的各种工作流程方案

思路太灵活了，大家根据自己实际情况，用法各有不同。

### git工作流：类似svn的TrunkBased集中式工作流

    remote master -- local master(开发人员工作在此)

主干仅master分支

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

### git工作流：改良版集中式工作流

    remote master -- local dev(开发人员工作在此)

主干仅master分支。在本地新建其它分支，每天仅拉取远程master，更新本地dev分支。这种工作方式可以确保主干master的相对稳定。

0、添加远程仓库，从master分支新建dev分支

    git remote add origin 远程仓库地址

    git checkout master
    git pull --rebase
    git branch 分支名

1、每日工作，先确认本地无未提交未储存等等问题，处理后再继续

    git status

2、从远程仓库master同步本地仓库master

    git pull --rebase （默认远程origin本地master）

3、切换本地dev分支

    git checkout dev

4、合并本地 master 到本地dev分支，以便同步hotfix进来。

    git merge master

本地只是远程的一个镜像，以远程为准。
所以跨分支操作比如想合并远程master分支到远程dev分支，需要先pull远程master到本地master，再merge到本地dev，再push本地dev到远程master。
或在本地dev分支fetch远程master一个临时分支然后diff/merge到本地dev分支 <https://www.jianshu.com/p/bfb4b0de7e03>

5、开发告一段落，可以发布时，提交dev分支，合并到master再上传远程仓库

    git checkout dev
    git add .
    git commit -m "提交的信息"

    git checkout master
    git pull --rebase

    git merge dev
    git push -u origin master

### git工作流： 功能分支工作流

    master -- dev(开发人员工作在此)

在上面的工作流基础上改良，把本地分支推送到远程，两个分支在本地和远程都存在，master分支保持稳定，开发工作放在dev分支，这俩都做主干分支。 CI/CD中持续集成部署在dev，持续交付部署在master。hotfix合并到远程的master分支和dev分支。主干分支和功能分支的合并原则，见下面章节[合并两分支时的原则：如何选择菱形还是拉直]。

大家每日同步远程的dev分支即可工作：

    每人的本地dev各自开发一个功能点，每天只拉取dev分支，完成一部分之后，上传到远程dev以便别人可以拉取，并进行测试。

这种工作流适合多人交互式工作的复杂项目，每天dev分支都在变动，大家本地dev完成一个阶段后，就同步到远程dev分支。这样在dev分支上就可以实现每日集成测试，master分支和dev分支都可以保持相对稳定。

上班第一件事：远程 dev_xxx上的内容merge 到自己的开发分支上

    0、查看当前在git的哪个位置，是否有未提交未更新未暂存的，确保是干净的再继续

        git status

    1、切换到的local开发分支，并查看状态

        git checkout dev_xxx
        git status

    2、将远程的 dev_xxx 同步到本地

        git pull --rebase origin dev_xxx

工作告一段落，推送自己dev_xxx分支到远程dev_xxx，以便大家拉取测试：

    0、查看当前在git的哪个位置，是否有未提交未更新未暂存的，确保是干净的再继续

        git status

    1、将远程的 dev_xxx 同步到本地，以保持跟大家的同步及hotfeix及时更新。

        git checkout dev_xxx
        git status

        git pull --rebase origin dev_xxx

    2、提交到 local 开发分支

        git add .

        git commit -m "@@@"

    3、将本地的多次提交合并为一个，以简化提交历史

        git rebase -i

    4、将 local dev_xxx 推送更新到gitlab，使gitlab同步更新显示

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

            （dev起点标签)
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

### git工作流： Gitflow工作流

    master -- develop -- feature(开发人员工作在此)

这个流程是功能分支工作流的进一步扩展，适合长期稳定的商用项目。

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

原文 <https://nvie.com/posts/a-successful-git-branching-model/> 流程图片<https://nvie.com/img/git-model@2x.png>

    汉化 <https://zhuanlan.zhihu.com/p/38772378> <https://zhuanlan.zhihu.com/p/36085631>

    抛弃 Git Flow 的 8 大理由 <https://baijiahao.baidu.com/s?id=1661688354212771172&wfr=spider&for=pc>

### 阿里巴巴 AoneFlow

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

## 分支的拉取和上传

### 每日工作第一件事 拉取合并（含标签，变基）

严重注意

    别一上来就 git pull ，用 git fetch + git status 不变动本地工作目录的内容查看远程，详见下面章节<git fetch 和 git pull的区别>。

    git pull的合并原则，见下面章节[合并两分支时的原则：如何选择菱形还是拉直]

先看看分支的远程库有没有别人新增，然后再git status才能看出来门道

    # 先看看有无未提交的，跟现有的本地远程代码比对没差别，不代表远程仓库的代码没差别，别人可能有更新
    git status

    # 本地git branch -av 看不到时，一般需要在本地使用git remote update 或 git fetch --all更新
    # 从远程下载，这个不会跟本地现有文件冲突，下载的是本地的那个对应远程仓库的目录
    # 下载当前分支可以简写为： git fetch
    git fetch origin master

    # 查看本地代码跟远程仓库代码（已下载到本地）的差异
    # 简单的：
    git status  # 如果有本地未提交的，先stash暂存才能继续下面的代码合并
    # 详细的：
    git diff ..origin/master

    # 酌情合并代码到本地
    git rebaseg 或 it merge
    # 如果提示有冲突，不建议直接 git merge，会导致本地菱形分叉
        git add -u 冲突文件
        git commit --amend

        git rebase -–continue

    # 再确认下没问题了
    git status

整合到一个命令：

    # 拉取远程加合并本地，连带标签，-r是rebase，否则是merge，最好指定要fetch的remote和分支名。
    # 详见下面章节[远程拉取合并本地的pull用法]

    git pull --rebase --tags -r origin master

### 远程拉取合并本地的pull用法

先看看原理：

    git pull          = git fetch + git merge
    git pull --rebase = git fetch + git rebase

如果多人同时操作一个分支，merge的时候会结合多个提交的最新位置新建一个提交点（不是快进合并就这样），形成了一个菱形：

1.初始状态，在c点大家pull了最新代码，开始自己的编辑提交，还未push：

                d---e  别人的master
              /
     a---b---c  远程仓库的master分支
              \
                f---g  你的master

2.大家分别提交自己的代码，e点的先提交，他pull+push，这时候远程仓库上没有其它提交，git会自动拉直接上

    a---b---c ---d---e
                别人的

3.你的g点要提交，先pull，这时git会提示输入新建commit点的注释了，因为c点已经有人接续上了，你也申请从c点接续，git需要新建个结合点给你俩的提交结合上

git pull = git fetch + git merge后的效果，看起来像个菱形，从c点拉取后提交的人越多，这个环越多

              h--i 又一个人的。。。
             /     \
              d---e 别人的
             /     \
    a---b---c       new commit 由git制造
             \     /
              f---g  你的

git pull --rebase = git fetch + git rebase 去掉多余的分叉，你的提交放到别人的后面，实现拉直：

    a---b---c ---d---e  ---f---g
               别人的     你的

通过 --rebase 方式，你的提交重新拼接在远端新增提交的最后，这样看起来更简洁，找自己的提交点也方便。

虽然可能要解决一些合并冲突，但是一条直线，看起来舒服多了，最重要的是后期合并commit就方便了。

对别人来说，你推送后新增的 f-g 两个提交是新增在他的 d-e 上的，他在你的 f-g 后面继续线性追加，逻辑更清晰。
最终用rebase实现大家都是在线性的增长master分支，不搞分叉。

    -a-b-c -d-e  -f-g  -h-i  -j-k  ...
           别人   你的  别人  你的   ...

### fetch 和 pull 的区别

git fetch 实际上将本地仓库中的远程分支更新成了远程仓库相应分支最新的状态。

git fetch 并不会改变你本地仓库的状态。它不会更新你的 master 分支，也不会修改你磁盘上的文件。

所以 git fetch 是十分安全的，你不用担心这个命令破坏你的工作区或暂存区，它下载的远程分支到本地，但是并不做任何的合并工作，然后可以执行以下命令合并到本地仓库

    git diff  # 对比下本地的远程分支和本地的本地分支的差异
    git merge o/master 或 git rebase o/master
    git cherry-pick o/master

通常的工作流程是，先用 git fetch 拉取远程分支，然后用 git merge 把拉取的内容合并到本地分支。

因为这二者都是连用的，所有有个简化版就是 git pull，大多数情况下直接用 git pull 就够用了，
但是要记住，正规的分支拉取操作是 fetch 和 merge（或rebase） 两个步骤完成的。

最完整的操作，是先fetch下来然后diff看看，然后再决定是否merge或rebase，简略操作用 pull。

    $git fetch <远程主机名> <分支名> # 注意之间有空格

    # 取回特定分支的更新
    $git fetch origin master

    # 可简写，默认拉取所有分支，如果有很多分支，就比较慢了
    $git fetch

    # 查看fetch下来的远程代码跟本地的区别
    git diff ..origin/master

#### 本地有两份代码--本地仓库和远程仓库

我们本地的git文件夹里面对应也存储了git本地仓库master分支的commit ID 和 跟踪的远程分支orign/master的commit ID（可以有多个远程仓库）。那什么是跟踪的远程分支呢，打开git文件夹可以看到如下文件：

    .git/refs/head/[本地分支]
    .git/refs/remotes/[正在跟踪的分支]

其中head就是本地分支，remotes是跟踪的远程分支，这个类型的分支在某种类型上是十分相似的，他们都是表示提交的SHA1校验和（就是commitID）。
我们无法直接对远程跟踪分支操作，我们必须先切回本地分支然后创建一个新的commit提交。
更改远端跟踪分支只能用git fetch，或者是git push后作为副产品（side-effect）来改变。

取回更新后，会返回一个FETCH_HEAD ，指的是某个branch在服务器上的最新状态，我们可以在本地通过它查看刚取回的更新信息：

    git log -p FETCH_HEAD

可以看到返回的信息包括更新的文件名，更新的作者和时间，以及更新的代码（x行红色[删除]和绿色[新增]部分）。
我们可以通过这些信息来判断是否产生冲突，以确定是否将更新merge到当前分支。

这时候我们本地相当于存储了两个代码的版本号，可以通过 git merge 去合并这两个不同的代码版本， git merge做的就是把拉取下来的远程最新 commit 跟本地最新 commit 合并。如果不用merge，用rebase也是可以的。

    git merge FETCH_HEAD

    git merge origin/master

    # 或者，不使用merge，用rebase
    $ git rebase origin/master

也可以在它的基础上，使用git checkout命令创建一个新的分支并切换过去。

    git checkout -b newBrach origin/master
    # 这个不自动切换
    git branch newBrach a9c146a09505837ec03b

#### git pull 把2个过程合并，减少了操作

git pull 的操作默认是 fetch + merge，可以设置成 fetch + rebase。

将远程主机的某个分支的更新取回，并与本地指定的分支合并 ：

    # 远程拉取下列同步到本地一般显式的写明用拉直
    git pull --rebase <远程主机名> <远程分支名>:<本地分支名>

    # 如果远程分支是与当前分支合并，则冒号后面的部分可以省略
    git pull --rebase origin master

    # 如果远程主机名origin，分支就是当前分支，可简写
    git pull --rebase

分支的合并，如上所述的是fetch下来一份远程合并到本地，这个操作于本地的两个分支进行合并，没什么区别。

分支合并的详细用法见下面的章节 [两个分支合并的merge常用方法]

### 切换到指定的提交点

切换到的提交点可以是分支名、标签tag、commit id（hash）

    # 先下载完整的git代码
    git clone xxxx

    # 查看当前有多少分支
    git branch -av

    # 切换到master分支
    git checkout master

    # 查找指定的commit点的hash值并复制
    git log --oneline

    # 从当前分支直接切换到指定的commit点
    git checkout 93890e9

#### 拉取指定分支的指定commit版本

git clone 默认是取回 master 分支，可以使用 -b 参数指定的分支。 -b 参数不仅支持分支名，还支持 tag 名等。

        git clone  <remote-addr:repo.git> -b <branch-or-tag-or-commit>

需求是获取commit id，没直接的办法。下面提供另一个步骤：

选择一个包含目标 commit id 的branch或tag，并指定depth=1以获得比较少的额外文件传输。

    git clone --depth 1 <remote-addr:repo.git> -b < branch-or-tag >

clone完成后，进入目录，执行

    git fetch --depth < a-numer >

不断增大步骤2的数字，直到找到你要的commit

## 合并两分支的原则：merge菱形还是rebase拉直

两个分支合并的 merge/rebase 效果

    Git 之 merge 与 rebase 的区别 https://www.cnblogs.com/zhangzhang-y/p/13682281.html

能做合并的基础是两个分支有相交点，如果三分支合并无直接交点需要用rebase <https://git-scm.com/docs/git-rebase>。

merge菱形分叉会制造新的commit点，根据具体情况考虑是否需要，一般情况下尽量用变基拉直。

对一个分支定期的变基是一个干净可靠的策略，因为提交历史日志将以有意义的功能序列进行排列（每个人的commit都是分段但是线性的排列）。

还有一些其他的合并哲学（例如，只使用合并而不使用变基以防止重写历史），其中一些甚至可能更简单易用。

但是，master 分支的历史将穿插着所有同时开发的功能的提交，这样混乱的历史很难回顾。

原则：

    何时采用分叉或拉直的形态，以能清晰区分各新增功能为目的

    本地主干分支master，拉取同步远程，做拉直

    本地功能分支dev，拉取同步远程，做拉直

    主干分支master合入hotfix， 应该是在主干分支上的接续，做拉直

    功能分支dev合入主干分支master，做拉直

    主干分支master合入功能分支dev，做菱形分叉

两分支合并方法

    git merge -no-ff 做菱形分叉

    git rebase 做拉直

以下讨论以此为例

                          d---e  hotfix分支
                         /
    master主干  a---b---c
                         \
                          f---g---h---i  feature分支

### merge 合并默认做快进（Fast Forward） 取拉直效果

需要合入分支的接续点就是分叉点。

merge默认做的是快进，即不新增commit点，走一条线的效果，执行 git status 会提示可以做快进。

NOTE: 如果merge不能做快进，就会分叉制作菱形，但并无提示，这个地方最容易让人糊涂。

所以最保险的方法是，git merge之前，先git status 看看 git merge 是否会提示快进。

1.hotfix分支先合并到主干分支 master

    git checkout master
    git pull
    git merge hotfix

形成的master分支：

    master分支  a---b---c ---d---e(HEAD)
                            先合入的分支，直接接c点，git默认做快进，不制造新commit点
                            git reset HEAD^ --hard 回退是到d

2.feature分支后合并到master分支：

merge发现不能做快进，就会制作分叉，并无提示，这个地方最容易让人糊涂。

    git checkout master
    git pull
    git merge feature

因为不是接续c点，所以git会制作新commit点，形成菱形分叉：

                          d---e          hotfix分支
                         /              \
    master分支  a---b---c                  new(HEAD) 由git制造
                         \              /
                          f---g---h---i  feature分支

    git reset HEAD^ --hard 回退是到e

如果 merge 操作遇到冲突，不能继续进行下去会提示解决冲突。手动修改冲突内容后，add . 修改，再次 commit 就可以了。

如果遇到多人合并分支，都是在c点后，不想出现很多环状提交，拉直见下面的方法三。

### merge --no-ff 强行保留菱形分叉

大的分支合入用菱形，便于管理。

feature 分支是用来开发特性的，上面会存在许多零碎的提交。
如果feature 分支先合并到主干分支 master，出现接续分叉点合并，默认的快进式合并会把 feature 分支的提交历史混入到 master 中，这样 master 的提交历史就不够简洁了，所以分支合并到主干时，保留菱形分叉的效果更好。

    git merge feature --no-ff -m"本次合并添加的注释信息"

                          f---g---h---i  feature分支
                         /             \
    master主干  a---b---c -------------- new(HEAD) 由git制造
                                          *
                       git reset HEAD^ --hard 的效果是回到c点

菱形分叉最大的好处，除了便于观察之外，如果需要版本回退，很容易就可以退到feature合并之前的位置。

对hotfix分支，再合入就在它后面又一个菱形，所以最好用rebase合入master，实现拉直（参见方法三）

                              f---g---h---i  feature分支
                             /              \
        master主干  a---b---c ---------------- new ---d---e
                                                *   hotfix分支用rebase合入，不制造commit点

### merge --squash压缩为一个commit点合并

用于 feature 分支的commit太多了，合入主干时简单粗暴的精简处理

    git checkout master

    git merge --squash feature -m"fgmix 只有我这一个提交点，原来的commit历史不要了"

效果

                          d---e      hotfix 分支先合并，git默认做快进
                         /        \
    master主干  a---b---c            newP(HEAD) 由git在后合入分叉时生成
                         \        /
                            fghi     feature分支压缩为只有一个commit点，后合并

慎用压缩合并

    如果是最先合并，即紧接着分叉点c合入主干，有可能被快进合并，不能制造新commit点形成菱形。

    功能分支的commit合并应该在合入主干之前，由开发组内部自行整理，不能简单粗暴的一把压缩合并。

### 分叉的强行拉直用变基 rebase，不制造新commit点

初始状态是两条分叉，master分支先合入了hotfix，默认快进合并：

               f---g---h---i feature分支
             /
    a---b---c---d---e
            *
            hotfix分支和feature分支的分叉点在c

为了合入不制造菱形，feature 分支在 master 分支的基础上延伸拉直，这时两分支的head位置不一样

    git checkout feature
    git rebase master

一条命令搞定：git rebase < basebranch > < topicbranch >

    git rebase master feature

rebase的拉直效果，虽然需要付出一些合并冲突解决的代价，但是清晰多了：

                  A'--B'--C' feature
                 /
    D---E---F---G master

然后 master 分支（落后了）做合并，两分支的head位置一样了。（因为 master 分支的head位于分叉点，实质二者在一条线上，所以merge做的是快进合并）

    git checkout master
    git merge feature

最终效果，大家都同步到一条直线的最末端：

    D---E---F---G---A'--B'--C' master
                               feature

rebase 操作遇到冲突的时候，会中断rebase，同时会提示去解决冲突。
解决冲突后,将修改add，执行git rebase –continue继续操作，或者git rebase –skip忽略冲突，或者git rebase --abort终止这次rebase。

一个本地分支拉取远程时，二者的合并做变基，起到拉直效果

    # 本地dev分支拉取远程dev分支的时候做rebase
    git checkout dev_xxx

    # 实质是 fetch + rebase
    git pull --rebase

    fetch远程仓库，然后跟本地做rebase，详见章节 [git pull 把2个过程合并，减少了操作]

在本质上，这跟两个分支合并时用rebase 强行拉直，是一样的。

### 建立合并专用分支的好处

两分支合并，因为分支的 commit 点的重整比较繁琐，而且容易搞乱，很多人都因此放弃整理，直接合入。

如果不整理，太多的commit点使得分支形态不够简洁

               fea_1 -- fea_2 -- fea1_fix1 -- fea2_fix1 --...
             /                                              \
    master  -- ...                                         -- v1.1 ...

建立合并专用分支是一个非常好的习惯

    在自己的比较乱的分支，需要合并到大家共用的分支之前

    在功能分支合并到主干之前

    使用文件比对工具，可大大简化合并 commit 点的复杂度

方法

    合并用分支从功能分支在主干上拉取时的同一个起点拉取

    使用 beyondcompare 比对两个分支的文件，即可方便的合入代码，按功能点形成提交点

    如果可以统一形成一个commit点，那么直接使用 squash 压缩即可

这样最终的形态就比较完美了：

               fea_1 -- fea_2 -- fea3 -- ...
             /                              \
    master  -- ...                         -- v1.1 ...

### 示例：功能分支合并到主干分支

以开发人员做版本发布的角色，把功能分支 fea 合并到主干分支 master （对主从分支开发模式来说，fea分支就是从分支）：

0.通知开发人员fea分支版本锁定，不要再推送远程了。

锁定远程fea分支的写入，防止开发人员继续提交。

或在远程打标签，便于确定锁定的位置，后续fea分支仅获取到这里，再有谁推送需要单独cherrypick，或后续测试版本期间走bug单自行合入。

1.[本地]fea分支、master分支拉取[远程]

保证[本地]master分支在合并之前是最新的

    git checkout master
    git pull --rebase  # 不制造菱形分叉

[本地]fea分支在合入[本地]master分支之前，要保证是最新的

    git checkout fea
    git pull --rebase  # 不制造菱形分叉

注意：远程的fea分支必须是可以通过测试的，不然后续合并代码后，问题更不好界定。

2.[本地]fea分支合并master分支

这里需要拉直合入，防止别的开发组的功能分支或hotfix已经合入master分支，即fea分支初创时引用的主干内容已经更新了

    git checkout fea
    git rebase master  # 不制造菱形分叉

这时本地fea分支应该是最新的了。如果master分支一直没改动过，这个步骤可以省掉。

第1、2步会在你的功能分支上重写历史（这并不是件坏事）。

首先，它会使你的功能分支获得主干分支上当前的所有更新。

其次，你在功能分支上的所有提交都会在该分支历史的顶部重写，因此它们会顺序地出现在日志中。

你可能需要一路解决遇到的合并冲突，这也许是个挑战。但是，这是解决冲突最好的时机，因为它只影响你的功能分支。

3.这个步骤可以省略：[本地]fea分支整理合并commit

[本地]fea分支在合入[本地]master分支之前，保证一定的简洁，然后再合入master分支。

    git checkout fea
    git rebase -i HEAD~50

合并commit的原则是便于区分查找功能点、cherrypick提交点，不要过分宽范围的合并，这样就没有意义了。这一步建议各个开发人员在合入fea分支之前就做好，让fea分支本身就是清爽的。

4.这个步骤可以省略：在[本地]建立合并专用分支 meg_for_v1，名称要体现出版本计划

    git checkout fea  # 基于fea分支
    git checkout -b meg_for_v1

上面整理过的[本地]fea分支，压缩合并的内容只是合入master分支用的，所以不要推送[远程]。

5.把[本地]合并专用分支 meg_for_v1 分支推送[远程]。

    git push

如果忽略了第 3、4步，压缩合并等工作，那么这个合并专用分支就是fea分支，直接使用即可。

6.基于合并专用分支走集成测试流程

之后的一段时间，开发人员拉取该合并专用分支，验证功能、修改冲突、解决bug等。

直到所有的整合工作全部完成并进行回归测试后，确认可以合入主干分支后，再继续下面的步骤。

8.合入前的同步：[本地]各分支拉取[远程]

[远程]master分支、[远程]合并专用分支都锁定（server端仓库做git hook脚本），开始版本合并的步骤。

保证[本地]master分支在合并之前是最新的，以防改动时间长master分支有变化如hotfix等新增合入

    git checkout master
    git pull --rebase  # 不制造菱形分叉

在此期间，如果其他人也将和你有冲突的更改推送到 master，那么 Git 合并将再次发生冲突。你需要解决它们并重新进行回归测试。

[本地]合并专用分支在合入[本地]master分支之前，要保证是最新的

    git checkout meg_for_v1
    git pull --rebase  # 不制造菱形分叉

9.[本地]master分支合入合并专用分支，这次要制造菱形分叉

    git checkout master

    git merge meg_for_v1 --no-ff -m"版本v1，新增xxx功能"

注意：制造菱形分叉后，master分支多出来一个commit点。要在这里做标记，打版本标签，便于各版本切换

10.[本地]master分支推送[远程]

    git push

11.[本地]master分支打标签，并推送远程

    git tag -a v1.1 -m"版本v1，新增xxx功能"
    git push origin v1.1

[远程]master分支可以解锁，版本合并工作结束。

10.收尾工作，分两种。

如果做了第 3、4 步，则可以删除fea分支，删除meg_for_v1分支，这俩已经完成历史使命了。具体操作见前面的[删除分支，远程/本地]章节

如果忽略了第 3、4 步，持续使用fea分支，则fea分支需要从远程master分支拉取合并代码，如果有合并冲突就解决掉：

        git checkout master
        git pull --rebase  # 不制造菱形分叉

        git checkout fea
        git pull --rebase  # 不制造菱形分叉

        # 至少会合入主干分支上的刚生成的那个合并点
        git rebase master  # 不制造菱形分叉

        git push

11.新的功能分支，从[远程]的主分支拉取建立，开始新的一轮循环。

## 对一个分支做变基：交互式压缩提交点

    https://zhuanlan.zhihu.com/p/249231960
        https://opensource.com/article/20/7/git-best-practices

当你在功能分支上开发时，即使再小的修改也可以作为一个提交。

但是，如果每个功能分支都要产生五十个提交，那么随着不断地增添新功能，master 分支的提交数终将无谓地膨胀。

通常来说，每个功能分支只应该往 master 中增加一个或几个提交。

为此，你需要将多个提交压扁(Squash)成一个或者几个带有更详细信息的提交，然后才可以推送远程，或合并到master分支。

本地的commit合并，不要把所有的commit合并成一个，酌情适量的原则：

    合并后，可以单独查找某个功能点或便于cherrypick某功能点

通常使用以下命令来完成：

    git rebase -i HEAD~20  # 查看最近二十个提交

当这条命令执行后，将弹出一个提交列表的编辑器，你可以通过包括 遴选(pick)或 压扁(squash)在内的数种方式编辑它。

“遴选”一个提交即保留这个提交。“压扁”一个提交则是将这个提交合并到前一个之中。

使用这些方法，你就可以将多个提交合并到一个提交之中，对其进行编辑和清理。

这也是一个清理不重要的提交信息的机会（例如，带错字的提交）。

总之，保留所有与提交相关的操作，但在合并到 master 分支前，合并并编辑相关信息以明确意图。

注意：不要在变基的过程中不小心删掉提交。

在执行完诸如变基之类的操作后，我会再次看看 git log 并做最终的修改：

    git log --graph --oneline

    # 提交但是不制作新的commit点（上次的变一下），适合本次和上次提交内容相近的场景
    git commit --amend  # 等价于 git rebase -i HEAD~2

参考

    <https://blog.csdn.net/lucky9322/article/details/72790034>
    <https://blog.csdn.net/raykwok1150/article/details/106572935>

格式：

    git rebase -i <after-this-commit>

进入vi后的命令：

    pick：保留该commit（缩写:p）

    reword：保留该commit，但我需要修改该commit的注释（缩写:r）

    edit：保留该commit, 但我要停下来修改该提交(不仅仅修改注释)（缩写:e）

    squash：将该commit和前一个commit合并（缩写:s）

    fixup：将该commit和前一个commit合并，但我不要保留该提交的注释信息（缩写:f）

    exec：执行shell命令（缩写:x）

    drop：我要丢弃该commit（缩写:d）

做压缩提交变基的限制

    只能在本地分支未推送远程仓库**之前**做 rebase。

    只能在合并到别的分支**之前**做 rebase。

    别处合并过来的 commit **不要**做 rebase。

    参见章节[重要：git推送远程时的大忌]。

### 示例

    # 先做提交或储存，保证要修改的分支没有暂存内容才能继续

    # 查看当前分支的提交commit，以便选择范围
    git log --oneline

        112bd52 (HEAD, fea_stragy) 1
        588e326 一般性的一些注释
        a5c7c9a 又一些注释
        1ae0123 最初的一些注释

    # 第一次用需要指定分支，因为我的fea_stragy没有远程分支
    #   git rebase ：There is no tracking information for the current branch.

    git rebase fea_stragy

    # 列出该点之后的所有commit，调用vi交互式进行编辑
    git rebase  -i 1ae0123
    # 简单的话，从近20个开始看： git rebase -i HEAD~20

    # 编辑 112bd52 那行，把 pick 改成 s
    # 编辑完成 :wq 退出后新出现个提示窗口
    # 让修改commit的注释，可以修改合并的commit点的注释
    # 不改就直接 :q

    # 操作完看看提示，还有什么需要解决的会提示
    [detached HEAD 9cf8ad2] 一般性的一些注释
    Date: Wed Sep 16 13:55:16 2020 +0800
    9 files changed, 1774 insertions(+), 1752 deletions(-)
    Successfully rebased and updated refs/heads/fea_stragy.

    git status

    # 再看当前commit，合并后出现了一个新的commit取代了压缩的那几个
    git log  --oneline

        9cf8ad2 (HEAD) 一般性的一些注释
        a5c7c9a 又一些注释
        1ae0123 最初的一些注释

    # 最后，由于重写了分支的 Git 提交历史，必须强制更新远程分支（如果有的话）：

    git push -f

### 第一次做的时候遇到问题了： 622c01c没关联到 fea_stragy 分支

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

## 重要：git推送远程时的大忌

无论是代码回退，还是对分支变基，牢记一个原则：**不要变更远程仓库已存在的 commit；分支合并过来的远程其它分支的commit也不要变更**

宁可新增修改也不回退或变基，如果rebase或回退了已经在远程存在的commit

    如果别人拉取并基于此开发，你再做rebase并再次提交，之前别人拉取的内容变了，双方都得再做拉取整合。如果时间线已经是很长的了，会导致很大的混乱。

    你拉取到本地的最新代码，不要对之前的内容做变基合并commit或回退。不然，如果推送到服务器上，之前别人拉取的内容变了，需要再次合并你改的那块内容，又是在制造混乱。

如果你真的重写了分支的 Git 提交历史，推送远程会失败，只能强制更新远程分支：`git push -f`，所有之前拉取过相关代码的人员，你需要挨个通知重新拉取合并。。。

更糟糕的是，如果你发现自己重写了git提交历史并推送到了远程，回退解决并再次推送远程，你以为成功解决了失误：

    如果有别人已经从远程仓库拉取了最新变化，分布式存储了你的修改，你怎么回退都没用了，他的本地有你之前推送的代码，只要他执行push，你的变更就改回去了。这种混乱，如果项目组人数多，那是鸡飞狗跳。解决方案很复杂，见下面章节[远程仓库上有B先生新增提交了，然后你却回退了远程仓库到A1]。

如果幸运，没有人新增提交，把自己的代码手工修改为最终正确的结果，作为一个新的commit再次push上去，你就装作啥也没发生。如果有人已经在你的提交基础上新增了提交，工作已经展开了，挨个给受你影响的人打电话道歉，然后通知大家再次根据你的最新代码合并分支，如果大家因此集体加班，你请大家喝咖啡，如果项目因此延期，及时通知项目经理报备。

如何尽量缩小这种情况的影响范围，见章节 [开发分支的组织管理] 。

### 遇到提示 push -f 的时候多想想

    https://www.jianshu.com/p/b03bb5f75250

在推送时，尽量避免git push -f的操作，或者说git push -f是一个需要谨慎的操作，它是将本地历史覆盖到远端仓库的行为。

刚才的测试中，b开发者在a进行git push -f前已经进行git pull操作，所以历史上的commit2是可以查找到，但是如果没有任何其他开发者进行pull，a再改变历史并强制推送，这部分数据就会丢失。

当然也并非禁止，有时，如果代码组内review后，确认代码正确无误，保证大家未pull的情况下，强制推送后，可以保持目录树清洁。

只有自己一个人使用的分支，可以自由 git push -f

## git worktree 多分支目录共用一个仓库

    https://minsonlee.github.io/2020/05/git-worktree

git checkout 命令是在同一个文件夹中切换不同分支，当一个分支正在开发，有另一个分支需要紧急处理bug，有两种解决方案

    `git stash` 当前内容，然后切换分支修改bug，提交后再切换回来， `git stash pop` 继续

    新建个目录拉取仓库，在那个目录里切换分支修改bug，极端情况下每个分支一个目录，都克隆同一个仓库，但是这样占用容量太大了

一个 git 仓库可以支持多个工作树，允许你在同一时间检出多个分支。通过 git worktree add 将一个新的工作目录和一个仓库进行关联。 这个新的工作目录被称为 “linked working tree（链接工作树）”。不同于通过 git init 或 git clone 产生的主工作树，这个目录只保存了静态内容，容量相对小很多，在这个目录下切换分支操作即可。

一个仓库只有一个主工作树(裸仓库是没有工作树的），可以有零个或多个链接工作树. 当你在链接工作树已经完成了工作，使用 git worktree remove 就可以移除它了。

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

示例

保留当前分支代码现状，基于 master 分支创建一个 hotfix 分支修复问题

    # 基于 master 分支头指针，在目录同级创建一个 hotfix 的工作树，并检出一个本地分支hotfix以便后期合入
    # git worktree add ../hotfix --detach master 如果分离式检出，切换到目录后手工创建分支 `git checkout -b hotfix`
    # git worktree add -b hotfix ../hotfix master
    git worktree add ../hotfix  # 创建目录并自动检出一个同名的本地分支

    # 进入 hotfix 工作树
    cd ../hotfix

    # 在该工作树下处理bug

    # 切换回主分支合并
    cd -
    git rebase hotfix

## git 项目包含子项目

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
    git pull --rebase

    git submodule sync --recursive

    # git submodule init
    # git submodule update
    git submodule update --init --recursive

子模块更新后，此时对主项目来说子模块的状态是有修改的，注意切换回主项目的目录，执行 git add/commit/push 提交这个修改即可。

对于子模块而言，并不需要知道引用自己的主项目的存在，子模块本身就是一个完整的 Git 仓库，按照正常的 Git 代码管理规范操作即可。通常的操作都需要进入子模块文件夹，按照子模块内部的版本控制体系更新、提交代码。比如更换远程仓库也只需进入子模块目录后执行命令 `git remote set-url origin xx.git` 即可。

对子模块远程仓库有更新的情况，主项目下运行 `git status` 不会有提示，需要进入子模块的目录后手动执行更新`git pull --rebase`，当主项目的子模块特别多时，可以使用批量命令：`git submodule foreach 'git pull --rebase'`。然后回到主项目的目录，执行 git add/commit/push 提交这个修改。

删除子模块

    git submodule deinit your_sub_project

    git rm your_sub_project

    git commit -m "delete submodule your_sub_project"

    git push

## git 常用法

### 切换分支checkout

1.查看远程分支

    $ git branch -av
    我在mxnet根目录下运行以上命令：

    ~/mxnet$ git branch -av
    * master                                7cabce4 [ahead 1] res me
    remotes/origin/HEAD -> origin/master    下略
    remotes/origin/master
    remotes/origin/nnvm
    remotes/origin/piiswrong-patch-1
    remotes/origin/v0.9rc1
    可以看到，我们现在在master分支下

2.查看本地分支

    ~/mxnet$ git branch
    * master

3.切换分支，注意这里是在本地新建了一个分支，对应远程的某个分支名

    $ git checkout -b v0.9rc1 origin/v0.9rc1
    Branch v0.9rc1 set up to track remote branch v0.9rc1 from origin.
    Switched to a new branch 'v0.9rc1'

    ＃已经切换到v0.9rc1分支了
    $ git branch
    master
    * v0.9rc1

    ＃切换回master分支
    $ git checkout master
    Switched to branch 'master'
    Your branch is up-to-date with 'origin/master'.

### 删除分支，远程/本地

0.先看看有多少本地和远程分支

    git branch -av

1.切换到其他分支再进行操作

    git checkout master

2.删除远程分支的指针而不是直接删分支，方便数据恢复。

    git push origin --delete fea_xxx

如果省略本地分支名，则表示删除指定的远程分支，因为这等同于推送一个空的本地分支到远程分支

    git push origin :refs/fea_xxx

用本地分支fea_-2覆盖远程分支fea_-1

    git push -f origin fea_-2:refs/fea_-1

对追踪分支，git push origin --delete 该命令也会删除本地-远程的追踪分支，等于还做了个

    # 如果只删除追踪分支，则还需要 git remote prune 来删除追踪分支
    git branch --delete --remotes <remote>/<branch>

3.其它人的机器上还有该远程分支，清理无效远程分支

    git branch -av  # 查看

    git fetch origin -p  # git remote prune

4.删除本地

    git branch -d fea_xxx

### 开发分支常用 commit --amend 压缩多余的提交点

注意这个要在 git push 推送远程之前做，已经推送远程的就不要改了！

提交但是不制作新的commit点（上次的变一下），适合本次和上次提交内容相近的场景

    git add .
    git commit --amend  # 等价于 git rebase -i HEAD~2

### 使用标签 tag

标签总是和某个commit挂钩。如果这个commit既出现在master分支，又出现在dev分支，那么在这两个分支上都可以看到这个标签。

1.新增标签

    git tag -a v1.1 -m"新增xxx功能"

2.查看标签

    git tag
    git show v1*

3.不要忘记将标签显式推送到远程

    git push origin v1.1

    # 批量推送
    git push origin --tags

4.新增轻量化标签

    git tag v1.1-bw

5.删除标签

    git tag -d v1.1-bw
    git push origin :refs/tags/v1.1-bw

6.从指定标签检出分支

假如某个历史版本需要重建，排除bug，从标签位置拉分支

    git checkout milestone-id        # 切换到分发给客户的标签
    git checkout -b new-branch-name  # 创建新的分支用于重现 bug

或一行命令

    git checkout -b fea_xxx v2.0.0

### 使用储藏 stash

当在一个分支的开发工作未完成，却又要切换到另外一个hotfix分支进行开发的时候，当前的分支不commit的话git不允许checkout到别的分支，而代码功能不完整随便commit是没有意义的。

一般使用，git stash push 和 git stash pop这两条就够了。

注意

    新增的文件，直接执行stash是不会被存储的，
    因为没有在git 版本控制中的文件，是不能被git stash 存起来的，
    所以先执行下git add 再储存就可以了。

详细用法

    （1）git stash push -m "save message"  : 执行存储时，添加备注，方便查找。只有 git stash 也可以，但查找时不方便识别。

    （2）git stash list  ：查看stash了哪些存储

    （3）git stash show ：显示哪些文件做了改动，默认show第一个存储，如果要显示其他存贮，后面加stash@{$num}，比如第二个 git stash show stash@{1}

    （4）git stash show -p : 显示改动明细，默认show第一个存储，如果想显示其他存存储，命令：git stash show  stash@{$num}  -p ，比如第二个：git stash show  stash@{1}  -p

    （5）git stash pop ：命令恢复之前缓存的工作目录，将缓存堆栈中的对应stash删除，并将对应修改应用到当前的工作目录下,默认为第一个stash,即stash@{0}，如果要应用并删除其他stash，命令：git stash pop stash@{$num} ，比如应用并删除第二个：git stash pop stash@{1}

    （6）git stash apply :应用某个存储,但不会把存储从存储列表中删除，默认使用第一个存储,即stash@{0}，如果要使用其他个，git stash apply stash@{$num} ， 比如第二个：git stash apply stash@{1}

    （7）git stash drop stash@{$num} ：丢弃stash@{$num}存储，从列表中删除这个存储

    （8）git stash clear ：删除所有缓存的stash

#### 找回误删的 stash 数据

本想 git stash pop ，但是输入成 git stash drop

1.查找所有不可访问的对象

    git fsck --unreachable

2.逐个确认该对象的代码详情，找到自己丢失的那个

    git show a923f340ua

3.恢复找到的对象

    git stash apply 95ccbd927ad4cd413ee2a28014c81454f4ede82c

### 补丁神器 cherry-pick

git、svn、hg 等基于 snapshot 的版本控制系统，以 snapshot 的方式存储当前版本。虽然这一类版本控制系统也会用到 patch，不过它们只有在需要时才计算出 patch 文件来。patch 是这一类版本控制系统的产物，而非基石。（注意：切勿混淆 commit 和 snapshot 的概念，两者并不等价。Git 显然不会在每个 commit 中存储对整个仓库的 snapshot，这么做太占空间。事实上，Git 的 commit 只包含指向 snapshot tree 的指针，参见：Git-内部原理-Git-对象 <https://git-scm.com/book/en/v2/Git-Internals-Git-Objects>）

git diff 输出格式就是个 patch 文件，git cherry-pick 会把摘取的修改以 patch 的形式应用到目标分支上。

应用场景：master分支上修改过的bug，要在dev分支上也做一遍修复

1.先确定master分支上的commit id

    git log  --graph --pretty=oneline --abbrev-commit

我们只需要把4c805e2 fix bug 101这个提交所做的修改“复制”到dev分支。

注意：我们只想复制 4c805e2 fix bug 101这个提交所做的修改，并不是把整个master分支merge过来。

为了方便操作，Git专门提供了一个cherry-pick命令，让我们能复制一个特定的提交到当前分支：

    $ git branch
    * dev
    master

    $ git cherry-pick 4c805e2
    [master 1d4b803] fix bug 101
    1 file changed, 1 insertion(+), 1 deletion(-)

Git自动给dev分支做了一次提交，注意这次提交的commit是 1d4b803，它并不同于master分支的 4c805e2，因为这两个commit只是改动相同，但确实是两个不同的commit。用git cherry-pick，我们就不需要在dev分支上手动再把修bug的过程重复一遍。

### 变更比对 diff 的多种用法

git diff 主要的应用场景：

    尚未缓存的改动：git diff
    查看已缓存的改动： git diff --cached
    查看已缓存的与未缓存的所有改动：git diff HEAD
    显示摘要而非整个 diff：git diff --stat

示例 -

    git diff <file> # 比较当前文件和暂存区文件差异 git diff

    git diff <id1><id1><id2> # 比较两次提交之间的差异

    git diff <branch1> <branch2> # 在两个分支之间比较
    git diff --staged # 比较暂存区和版本库差异

    git diff --cached # 比较暂存区和版本库差异

    git diff --stat # 仅仅比较统计信息

    # 查看另一个分支上文件与当前分支上文件的差异
    git diff <another_branch> some-filename.js

·检查工作树的几种方式

    git diff            #(1)
    git diff --cached   #(2)
    git diff HEAD       #(3)

工作树中的更改尚未分段进行下一次提交。索引和最后一次提交之间的变化; 查看已经git add ，但没有git commit 的改动。自上次提交以来工作树中的更改；如果运行“git commit -a”，查看将会提交什么。

·查看尚未暂存的文件更新了哪些部分，不加参数直接输入

    git diff

此命令比较的是工作目录(Working tree)和暂存区域快照(index)之间的差异也就是修改之后还没有暂存起来的变化内容。

·查看已经暂存起来的文件(staged)和上次提交时的快照之间(HEAD)的差异

    git diff --cached
    git diff --staged

显示的是下一次提交时会提交到HEAD的内容(不带-a情况下)

·显示工作版本(Working tree)和HEAD的差别

    git diff HEAD

·直接将两个分支上最新的提交做diff

    git diff topic master
    # 或
    git diff topic..master

·输出自topic和master分别开发以来，master分支上的变更。

    git diff topic...master

·查看简单的diff结果，可以加上--stat参数

    git diff --stat

·查看当前目录和另外一个分支(test)的差别

    git diff test

·显示当前目录和另一个叫’test‘分支的差别

    git diff HEAD -- ./lib

·显示当前目录下的lib目录和上次提交之间的差别(更准确的说是在当前分支下)比较上次提交和上上次提交

    git diff HEAD^ HEAD

·比较两个历史版本之间的差异

    git diff SHA1 SHA2

制作补丁

    git diff xxx > your.patch

在其它的机器上应用补丁

    # 先检查这个补丁操作是否会报错
    git apply --check your.patch

    # 部分打上补丁也可以接受，保留冲突部分，冲突的会生成.rej文件供手工分析
    git apply --reject your.patch

    # 没问题，完全打上补丁
    git apply your.patch

#### 没点，俩点，仨点的区别

<https://stackoverflow.com/questions/4944376/how-to-check-real-git-diff-before-merging-from-remote-branch>

<https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E9%80%89%E6%8B%A9%E4%BF%AE%E8%AE%A2%E7%89%88%E6%9C%AC>

You can use various combinations of specifiers to git to see your diffs as you desire (the following examples use the local working copy as the implicit first commit):

假设某人在远程存储库中进行更改，即修改了分支并提交到远程库，下述3个使用方法有不同的效果

1.您在本地可能不会看到任何更改

    git diff remote/origin

This shows the incoming remote additions as deletions; any additions in your local
repository are shown as additions.

2.可以看到更改

    git diff ..remote/origin

Shows incoming remote additions as additions; the double-dot includes changes
committed to your local repository as deletions (since they are not yet pushed).

For info on ".." vs "..." see as well as the excellent documentation at [git-scm revision selection: commit ranges Briefly] <https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection#Commit-Ranges>, for the examples above, double-dot syntax shows all commits reachable from origin/master but not your working copy. Likewise, the triple-dot syntax shows all the commits reachable from either commit (implicit working copy, remote/origin) but not from both.git help diff

例如

    git fetch; git diff ..origin/master

您将看到本地git存储库的内容与远程存储库中的不同之处。您将看不到本地文件系统中或索引中的任何更改。

3.三点语法显示从任一提交（隐式工作副本、远程/原点）可以到达的所有提交，但不能同时来自两个提交。git help diff

    git diff ...remote/origin

Shows incoming remote additions as additions; the triple-dot excludes changes
committed to your local repository.

### HEAD、HEAD^、HEAD~ 的含义

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

^ 是用来切换父级提交路径的修饰符。当我们始终在一个分支比如 dev 开发/提交代码时，每个 commit 都只会有一个父级提交，就是上一次提交，但当并行多个分支开发，feat1, feat2, feat3，完成后 merge feat1 feat2 feat3 回 dev 分支后，此次的 merge commit 就会有多个父级提交。

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

示例

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

### 如何回退

    https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified

FailSafe: 在你回退之前务必要做

    如果是已经 git commit的操作，首先保留下现场以便反悔救命，这个窗口千万别关啊！
    # 最好用 tmux 保留这个命令的输出，救命用的
    git log --graph --oneline

    如果你有修改保存在暂存区和工作区，或者提交，或者stash，然后再做回退的操作。git 的回退弯弯绕比较多，回退之前务必清理下暂存区和工作区，千万小心，有好几种情况会无提示清理。

工作区

    你的修改在这里。

暂存区(index)的意义

    当你修改了很多还没改完，想临时性的保存下，不应该形成一个 commit 保存到仓库区。

    继续改，担心把之前正确的弄乱，那就先暂存这部分修改内容，然后继续在工作区修改。

    万一你越改越乱，把之前的修改也变动了，工作区里改动的内容很多不好复原，咋办？

    前一阶段的内容在暂存区，可以用 git diff 很方便的比较暂存区和工作区的差异，轻松调整为你想要的内容。

    如果你长时间在做一份内容修改，分阶段的保存一下，非常必要。

养成一个习惯吧，大批量的修改，感觉这一部分差不多了，就顺手 `git add .` 在暂存区固定这部分修改，后续如果工作区改乱了可以用 `git diff` 轻松调整，最后完全没问题了就可以形成一个 commit 提交了。

仓库区(head)

    你的commit提交在这里，分布式存储，需要你push才能到远程。

用户修改文件，文件的变更路径是

    工作区 ----> 暂存区 ----> 仓库区

修改的文件要撤回，跟上面的过程相反

    仓库区 ----> 暂存区 ----> 工作区

git的实际工作，修改的文件进入每个区域，都需要专门的命令

                              HEAD    Index    Workdir    WD Safe?

    Commit Level
    reset --soft [commit]     REF    NO    NO    YES
    reset [commit]    REF     YES    NO    YES
    reset --hard [commit]     REF    YES    YES    NO
    checkout <commit>         HEAD    YES    YES    YES

    File Level
    reset [commit] <paths>     NO    YES    NO    YES
    checkout [commit] <paths>  NO    YES    YES    NO

git reset 主要关注已经提交的修改的 commit 的回退，分几种回退情形

    git reset --soft HEAD~ 重置 head 的位置，指向本地仓库里的提交点，回退的commit内容放到暂存区，HEAD~表示只回退上一步的commit，如果是间隔多个commit，回退会累积起来，类似 squash 的效果。

        如果暂存区有修改，则丢弃该commit的内容。不过你可以用 git reflog 查看 commit 往回cherry-pick。

    git reset HEAD~ 这个会先做上面的步骤，然后再加一步，丢弃暂存区的修改，把回退的 commit 重置到工作区

        如果工作区有修改，则丢弃该 commit 的内容。不过你可以用 git reflog 查看 commit 往回cherry-pick。

    git reset HEAD 把暂存区的内容回退到工作区，是 git add 的逆过程。

        如果工作区有修改，则丢弃暂存区的变更。

    git reset <commit> <file> 把工作区的文件回滚到指定的commit版本，如果没有 commid 就是暂存区的内容回退到工作区。

    git reset --hard [commitid] 这个会先做上面的步骤，然后再加一步，把当前head指向的commit重置到工作区

    注： 这个“有修改”，指文件中相同位置的内容有变更，如果不是相同位置，会自动合并内容

git checkout 主要关注未提交的修改的撤回，分几种回退情形

    暂存区有修改，工作区无修改：无变化

    暂存区无修改，工作区有修改：丢弃工作区的修改

    暂存区有修改，工作区有修改：丢弃工作区的修改，暂存区保持不动

git restore 代替 `git checkout` 关于撤回的几个用法

    暂存区有修改，工作区无修改： `git restore <file>` 无变化
                            `git restore --staged <file>` 暂存区的内容撤回到工作区

    暂存区无修改，工作区有修改：`git restore <file>` 丢弃工作区的修改

    暂存区有修改，工作区有修改：`git restore <file>` 丢弃工作区的修改，暂存区保持不动
                           `"git restore --staged <file>` 丢弃暂存区的修改，工作区保持不动

git rm 移除git对该文件的跟踪，跟 git add 相对，分几种回退情形

    暂存区无修改，工作区无修改：移除该文件 `git rm <file>`。移除文件但保留到工作区 `git rm --cached <file>`

    暂存区有修改，工作区无修改：丢弃暂存区的修改，移除该文件 `git rm -f <file>`

    暂存区无修改，工作区有修改：丢弃工作区的修改，移除该文件 `git rm -f <file>`

    暂存区有修改，工作区有修改：丢弃暂存区的修改，丢弃工作区的修改，移除该文件 `git rm -f <file>`

    如果没有做commit提交变更，想恢复该文件，要两步 `git reset HEAD <file>` 先恢复到暂存区，然后再 ` git checkout <file>` 解除删除状态，该文件恢复到版本库的状态，不会恢复原暂存区和工作区被删除的内容。

示例

情况1.修改了工作区文件，没有任何 git 操作，需要从版本库HEAD指向的那个提交覆盖到工作区

撤销工作区指定文件的修改

    git checkout -- aaa.txt

撤销所有修改

    # git checkout HEAD .
    git checkout .

从暂存区删除指定文件，跟git add对应

    git rm --cached <file>

情况2.修改了文件，已经 git add 提交到暂存区了，需要回退到版本库的状态

    # 1. 先撤销暂存区的修改，这样文件的变更体现在工作区了
    git reset HEAD

    # 2. 再撤销工作区的修改，这时文件的内容就跟版本库一致了。
    git checkout -- aaa.txt

情况2.1 修改了文件，已经 git add 提交到暂存区了，又做了些修改在工作区

    # 取消工作区的变更，暂存区的不变
    git checkout aaa.txt

    # 直接reset会提示无法继续
    # git reset HEAD

情况3.修改了文件，已经 git commit 提交到仓库区了

如果是已经git commit的操作，首先保留下现场以便反悔救命，窗口千万别关啊！

    git log --graph --oneline

然后回退，也是先到暂存区，然后到工作区的两步操作

    # 1. 先撤销暂存区修改，这样文件的变更仅体现在工作区了
    # git reset --soft HEAD~1 差异放在在储藏（stage）区域
    git reset HEAD^

    # 2. 再撤销工作区的修改，这时文件的内容就跟版本库一致了。
    git checkout -- aaa.txt

直接回撤到版本库的某个commit点，之前的修改全抛弃（没做git push）

    git reset --hard HEAD~1

情况4.不仅提交到仓库区了，还 git push 到远程仓库了

不要直接回退！参见章节[重要：git推送远程时的大忌]

#### 签出指定文件

如果在一个提交中，你只想取消某些文件在本地的变更，而同时保留另外一些文件在本地的变更

    git checkout forget-my-changes.js

从其他分支或者之前的提交中签出文件的不同版本：

    git checkout some-branch-name file-name.js

    git checkout {{some-commit-hash}} file-name.js

签出的文件处于“暂存并准备提交”的状态。

如果不想要上面的状态，想回退并签出到未暂存的状态，需要执行一下

    git reset HEAD file-name.js

然后再次执行

    git checkout file-name.js

这样文件回到了初始状态。

#### 使用 git revert 进行分支硬回退

以master分支为例，A2提交不用了，需要回退到A1

    A1 -- A2

1.查看版本号：

    git log --graph --oneline
    或 git reflog 查看更多的操作

2.将版本回退到指定的提交点：

    git reset --hard 指定的commitId

3.更新远程仓库端的版本也进行同步的回退

    git push -f

如果远程仓库不允许 push -f，先使用 rebase 把多个提交合并成一个提交，再使用 revert 产生一次反提交

    <https://zhuanlan.zhihu.com/p/104806087>
    # 从master 分支建立新分支 tmp_re ，使用 git log 查询一下要回退到的 commit 版本 N
    git log --graph --oneline

    # 使用命令 git rebase -i N 将这些 commits 都合并到最旧的 commit1 上
    git rebase -i commit1
    # 这个时候，master 分支上的提交记录是 older, commit1, commit2, commit3, commit4，而 tmp_re 分支上的提交记录是 older, commit_rebase，二者的内容其实是一样的

    # tmp_re 分支合并master分支，多了一个 commit_merge。
    git merge master

    合并前
    master分支  older---commit1---commit2---commit3---commit4
    tmp_re分支  older---commit_rebase

    合并后：
    tmp_re分支  older---commit_rebase---------------------commit_merge---commit_revert
                    \                                    /
                     commit1---commit2---commit3---commit4

    # 再在 tmp_re 分支上对 commit_merge 进行一次 revert 反提交，就实现了把 commit1 到 commit4 的提交全部回退。

    git log --graph --oneline # 注意merge出现分叉，回退需要指定分支，先用git log看好了
    git revert HEAD^ -m 1  # 退有rebase提交的那一支

    # 最终tmp_re分支的内容回退掉了commit1-4的内容，commit历史都在：

    tmp_re分支  older---commit_rebase---------------------commit_merge---commit_revert
                    \                                    /
                     commit1---commit2---commit3---commit4

#### 远程仓库上有B先生新增提交了，然后你却回退了远程仓库到A1

这种情况，操作就比较繁琐了 <https://www.cnblogs.com/Super-scarlett/p/8183348.html>

先通知所有人都做回退，A2后没有提交的本地master分支就回到A1了。

    git reset --hard origin/master

但是B先生已经提交了B1-B2

    他的本地 master 分支是 A1 - A2 - B1 - B2
    他的本地 开发   分支是 A1 - A2 - B1 - B2 - B3

只要他再次提交，A2还是会出现在远程仓库，你的回退对分布式来说无用。

所以需要B先生找出新增的B1，B2，cherry-pick到 master 分支

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

### 创建常用命令的别名

常用的较长的git命令应该使用git或者bash别名

例如，在我的.bashrc文件中有下面的词条：

Alias glog=”git log –oneline -graph”，允许我使用glog代替长命令

### 查看尚未合并的变更

如果你曾经与很多小伙伴工作在同一个持久分支上，也许会有这样的经历，父分支（例如：master）上的大量合并同步到你当前的分支。这使得我们很难分辨哪些变更时发生主分支，哪些变更发生在当前分支，尚未合并到master分支。

    git log --no-merges master..

--no-merges 标志意味着只显示没有合并到任何分支的变更，
master..选项，意思是指显示没有合并到master分支的变更（在master后面必须有..）。

查看一下尚未合并的文件变更

    git show --no-merges master..
    # 输出结果相同
    git log -p --no-merges master..

### 快速定位故障版本

git bisect 使用分治算法查找出错版本号。

假设休假一周回来，你看了一下最新代码，发现走之前完全正常的代码现在出问题了。

你查看了一下休假之前最后一次提交的代码，功能尚且正常。不幸的是，你离开的这段时间，已经有上百次提交记录，你无法找到那一次提交导致了这个问题。

这时你或许想找到破坏功能的bug，然后对该文件使用git blame 命令，找出并指责破坏者。

如果bug很难定位，那么或许你可以去看一下提交历史，试一下看能不能找到出问题的版本。

另一种快捷的方式则是使用git bisect，可以快速找到出问题的版本。

那么git bitsect是如何做的呢？

指定了已知的正常版本和问题版本之后，git bisectit bisect会把指定范围内的提交信息从中间一分为二，并会根据最中间的提交信息创建一个新的分支， 你可以检查这个版本是否有问题。

假设这个中间版本依然可以正常运行。你可以通过git bisect good命令告诉git。然后，你就只有剩下的一半的版本需要测试。

Git会继续分割剩下的版本，将中间版本再次到处让你测试。

Git bisect会继续用相似的方式缩小版本查找范围，直到第一个出问题的版本被找到。

因为你每次将版本分为两半，所以可以用log(n)次查找到问题版本（时间复杂度为“big O”，非常快）。

运行整个git bisect的过程中你会用到的所有命令如下：

 1. git bisect start ——通知git你开始二分查找。
 2. git bisect good {{some-commit-hash}} ——反馈给git 这个版本是没有问题的（例如：你休假之前的最后一个版本）。
 3. git bisect bad {{some-commit-hash}} ——告诉git 已知的有问题的版本（例如master分支中的HEAD）。git bisect bad HEAD （HEAD 代表最新版本）。
 4. 这时git 会签出中间版本，并告诉你去测试这个版本。
 5. git bisect bad ——通知git当前版本是问题版本。
 6. git bisect good ——通知git当前签出的版本没有问题。
 7. 当找到第一个问题版本后，git会告诉你。这时， git bisect 结束了。
 8. git bisect reset——返回到 git bisect进程的初始状态（例如，master分支的HEAD版本）。
 9. git bisect log ——显示最后一次完全成功的 git bisect日志。

你也可以给git bisect提供一个脚本，自动执行这一过程 <http://git-scm.com/docs/git-bisect#_bisect_run>

### 从远程库删除某些文件但保留本地的文件

有时我们会误把一些不必要的文件（如目标文件、log 日志等）提交并推送到了远程库，现在希望从远程库删除这些文件但保留本地的文件，可以像这样 执行：

    git rm -r --cached dir1
    git rm --cached dir2/*.pyc

    git commit -m "remove irrelated files"
    git push origin branch1

### 彻底删除git中的大文件

git 如果提交一个文件，然后删除他，继续提交，那么这个文件是存在 git 中，需要使用特殊的命令才可以删除。.git主要记录每次提交变动，当我们的项目越来越大的时候，我们发现 .git文件越来越大

很大的可能是因为提交了大文件，如果你提交了大文件，那么即使你在之后的版本中将其删除，但是，
实际上，记录中的大文件仍然存在。

虽然你在后面的版本中删除了大文件，但是Git是有版本倒退功能的吧，那么如果大文件不记录下来，git拿什么来给你回退呢？但是，.git文件越来越大导致的问题是： 每次拉项目都要耗费大量的时间，并且每个人都要花费
那么多的时间。

git给出了解决方案，使用git branch-filter来遍历git history tree, 可以永久删除history中的大文件，达到让.git文件瘦身的目的。 <https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/removing-sensitive-data-from-a-repository>

### 暂存区大文件导致推送远程失败

直接剔除那个大文件，再重新上传。但此时暂存区已经被修改，无法执行git push，需要重建目录树。

查看对象库：

    $ ls -l .git/objects/pack
    -r--r--r--  1 xxxsun  staff    54K Feb 20 20:30 pack-f49501cbd6851d3cbdf8ad44028263e2b1526b32.idx
    -r--r--r--  1 xxxsun  staff   118M Feb 20 20:30 pack-f49501cbd6851d3cbdf8ad44028263e2b1526b32.pack

查看最大的N个文件sha1：

    $ git verify-pack -v .git/objects/pack/pack-f49501cbd6851d3cbdf8ad44028263e2b1526b32.idx | sort -k 3 -n | tail -n 10
    5f466dec2fc24624d09790c369e5ad1e5343ec61 blob   8377466 8351646 110662168
    8c915661c66e9b3a9ec9e17c9b55fb4bdaf152fc blob   9162783 6558772 101211526
    8533ba160d286563df5b7bd774b2814a46b64857 blob   20848460 16287722 8254071
    0b98ac11ba523cc7c58459548dc52c68135e3862 blob   20876763 3485525 94296622
    b56c8f61a3c9f153a9064ef3c888fb6051307212 blob   39627800 25196894 69099728

查看sha1对应文件名：

    $ git rev-list --objects --all | grep b56c8f61a3c9f153a9064ef3c888fb6051307212
    b56c8f61a3c9f153a9064ef3c888fb6051307212 产品文档/xxx系统-产品团队补充部分v2.2.pdf

发现比较大的几个文件均为*.pdf，从暂存区删除：

    git filter-branch --index-filter 'git rm --cached --ignore-unmatch *.docx' -- --all
    rm -Rf .git/refs/original
    rm -Rf .git/logs/
    git gc --aggressive --prune=now

验证：

    git count-objects -v

重新提交成功

### 配置git的编辑器和比较工具

配置 Beyond Compare 4 作为 git mergetool

    https://blog.csdn.net/albertsh/article/details/106294095
    https://blog.csdn.net/LeonSUST/article/details/103565031

建议使用开源的 meld 替换，基于python的

    https://meldmerge.org/
        https://gitlab.gnome.org/GNOME/meld
        https://gitlab.gnome.org/GNOME/meld/-/wikis/home

配置git的默认编辑器为 vscode

    https://blog.csdn.net/ShuSheng0007/article/details/115449596

    git config --global core.editor "code --wait"

如果想恢复使用 Vim，使用下面命令即可

    git config --global --unset core.editor

也可直接编辑配置文件

    git config --global --edit

配置git的difftool与mergetool为VsCode

执行如下命令git将使用上一部分配置好的vscode打开配置文件

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

## 常见问题

Ubuntu克隆下源码后对其操作时git报错 fatal: unsafe repository

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

### Your branch and 'origin/xxx' have diverged

<https://blog.csdn.net/d6619309/article/details/52711035>

当前工作的git仓库模型为:

    upstream
      |
    origin
      |
    local copy

#### 情况1： Git fetch 、merge以后出现分叉

git fetch upstream上游代码后执行git merge，然后git status发现Git分支出现分叉。

出现分叉的原因是本地和远程的共同节点之后，出现了两种独立的提交(每种可能有多个提交)：一种是你在本地分支新增的提交，另外是远程分支新增的提交。

这种情况，通常是由于另外一个人在上游相同的分支做了提交，或是你在本地修改之前没有先git pull同步远程代码，直接修改然后提交再push远程，不巧的是远程已经有人提交了新的修改，git这时候要提示你分叉了，这两个提交需要你手工确认做融合。

解决的话，在本地分支上，执行:

    git fetch
    git rebase

rebase以后的git提交历史树为:

    ... o ---- o ---- A ---- B  origin/branch_xxx (upstream work)
                              \
                               C`  branch_xxx (your work)

#### 情况2：rebase以后提示同样的错误

这是因为你在执行rebase之前，已经往你的远程上面push了提交。由于rebase会重写历史提交记录，因此你的本地和你的远程的历史提交状态是不同的，同样产生了分叉:

rebase之前的git提交历史树:

    ... o ---- o ---- A ---- B  master, origin/master
                       \
                        C  branch_xxx, origin/branch_xxx

执行rebase之后的git提交历史树:

    ... o ---- o ---- A ---------------------- B  master, origin/master
                       \                        \
                        C  origin/branch_xxx     C` branch_xxx

这时候，你必须确定你是处于上面描述的情况，解决方案就是强制push到你的origin上游，执行下面命令可以解决:

    git push origin branch_xxx -f

XXX:我的想法是，不用 git push -f，用 git merge 是否可以解决？

### fatal: does not appear to a git repository

先确认下，已经有 origin 远程库，没有也需要重新建立连接

    $ git remote show
    origin

一般都是因为 remote 端目录变更导致

    $ git remote -v
    origin  ssh://git@xx.xx.xx.xx:22/download/tea (fetch)
    origin  ssh://git@xx.xx.xx.xx:22/download/tea (push)

删除 origin 重建

    git remote rm origin

    git remote add origin ssh://git@xx.xx.xx.xx:22/gitrepo/tea.git

建立origin 和 master 的联系

    git push -u origin master

如果上一步报错，因为本地跟远程库新的提交冲突了，需要先拉取下来做merge

    git pull --rebase origin master

### 掉电导致objects目录下的某些文件为空

如果保存远程gitrepo的虚拟机经常关闭或者本地机器突然掉电，会导致.git/objects目录下的某些文件为空的报错:

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

    https://www.zackwu.com/posts/2019-08-04-how-to-use-gpg-on-github/

    https://cloud.tencent.com/developer/article/1656009?from=article.detail.1531457

    https://docs.github.com/cn/authentication/managing-commit-signature-verification/generating-a-new-gpg-key

### 1.github网页端添加gpg公钥

github要求，gpg密钥的电邮地址应该使用github页面提示给出的（对于隐藏自己邮件地址）对外电邮。查看该电邮地址，登陆github，菜单“settings-emails：Primary email address的说明文字里有对外电邮地址”，操作说明见<https://docs.github.com/cn/authentication/managing-commit-signature-verification/generating-a-new-gpg-key>，所以单独给这个电邮地址新建个github专用的gpg密钥即可，uid设为github用户名'm666m'。为提高使用安全性，新建个有签名功能的子密钥使用，提交到github和本地git存储的设置中使用。

显示当前的gpg公钥，本地控制台下执行命令

    # FBB74XXXXXXXAE51 是之前gpg生成的uid的密钥指纹，也可以直接写uid如'm666m'
    gpg --armor --export FBB74XXXXXXXAE51

找到你的电邮地址对应的那个公钥，复制将其添加到 github 个人资料的设置中：

   github 页面右上角，单击你的头像，Settings—> GPG keys，然后粘贴 GPG key。

#### github不发布公钥

GitHub 只维护用户自行上传的公钥，不会去查找 Pubkey Server 的，所以不需要担心第三方的影响。

    吊销密钥将取消验证已签名的提交，通过使用此密钥验证的提交将变为未验证状态。如果你的密钥已被盗用，则应使用此操作。

    删除密钥不会取消验证已签名的提交。使用此密钥验证的提交将保持验证状态。

### 2.将 GPG 密钥与 Git 关联

    # FBB74XXXXXXXAE51 是之前gpg生成的uid的密钥指纹，也可以直接写uid如'm666m'
    # 如果有签名功能的子密钥，设置为该子密钥的keyid即可。
    git config --global user.signingkey FBB74XXXXXXXAE51
    # 或者
    git config user.signingkey FBB74XXXXXXXAE51

如果是在已有的项目文件夹里，注意检查是否需要更新用户名和电邮地址

    git config user.name

    git config  user.email

### 3.设置gpg程序的路径

    $ where gpg
        E:\Git\usr\bin\gpg.exe  # 这个是 Git for windows 自带的
        E:\GnuPG\bin\gpg.exe    # 这个是Gpg4Win安装的

    $ git config --global gpg.program "E:\GnuPG\bin\gpg.exe"
    done

### 4.签名提交

git commit 使用 -S 参数进行 GPG 签名：

    # 每次都得给 git commit 操作（包括 --amend）传递 -S。
    git commit -S -m “commit message"

建议始终使用签名提交，设置默认使用 GPG 签名提交：

    git config --global commit.gpgsign true
    # 或者
    git config commit.gpgsign true

验证签名的提交

    git verify-commit [hash]

在 Git 中通过命令行验证相关提交的签名

    $ git log --show-signature -1
    commit 374010d1af1de40fdf8f1f6f5cca0c0c60e4fe9d (HEAD -> master, origin/master, origin/HEAD)
    gpg: 签名建立于 四 10/31 11:24:16 2019 CST
    gpg:               使用 RSA 密钥 39033F321A83635ECD7FC8DA66DD4800155F7A2B
    gpg: 完好的签名，来自于 “admin <admin@example.com>” [绝对]
    Author: admin <admin@example.com>
    Date:   Thu Oct 31 11:24:16 2019 +0800

        update README.md

在 GitLab 验证提交

    1、在 GitLab 提交选项卡，签名的提交将显示包含“ Verified”或“ Unverified”的徽章，具体取决于 GPG 签名的验证状态。
    2、通过单击 GPG 徽章，将显示签名的详细信息。

### 5. 给标签签名

tag命令后跟 -s 参数即可

    git tag -s [tagname]

对带注释的标签，每次都传递一个 -s 开关：

    git tag -asm "Tag message" tagname

建议始终对 git 标签签名，设置始终签名带注释的标签

    git config --global tag.forceSignAnnotated true

验证一个签名的标签

    git verify-tag [tagname]

如果你要验证其他人的 git 标签，需要你导入他的 gpg 公钥。

### 6.合并时强制进行签名检查

需要项目的所有成员都签名了他们的提交，否则只要有一个提交没有签名或验证失败，都会导致合并操作失败。

    git merge --verify-signatures -S merged-branch

### 7.可选步骤：给Github的GPG公钥签名

在Github网页端进行的操作，比如创建仓库。这些commit是由Github代为签名的。

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

注意网页端的提交导致“gpg: Can't check signature: No public key”。

为了解决这个问题，我们需要导入Github所用的GPG密钥并签名。

先是导入：

    $ curl https://github.com/web-flow.gpg | gpg --import
    # curl's output is omitted
    gpg: key 4AEE18F83AFDEB23: public key "GitHub (web-flow commit signing) <noreply@github.com>" imported
    gpg: Total number processed: 1
    gpg:               imported: 1

查看刚导入后的有效性是  [ unknown]

    $ gpg -k
    /c/Users/XXXXX/.gnupg/pubring.kbx
    -------------------------------------
    pub   rsa2048 2017-08-16 [SC]
        5DE3E0509C47EA3CF04A42D34AEE18F83AFDEB23
    uid           [ unknown] GitHub (web-flow commit signing) <noreply@github.com>

导入后不签名，git log显示签名时gpg验证提示会有警告性信息

    gpg: Good signature from "..." [unknown]
    gpg: WARNING: This key is not certified with a trusted signature!
    gpg:          There is no indication that the signature belongs to the owner.

用自己的密钥为其签名

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

确认签名生效，有效性validity变为 full了

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

查看现在的有效性是  [ full]

    $ gpg -k
    /c/Users/XXXXX/.gnupg/pubring.kbx
    -------------------------------------
    pub   rsa2048 2017-08-16 [SC]
        5DE3E0509C47EA3CF04A42D34AEE18F83AFDEB23
    uid           [  full  ] GitHub (web-flow commit signing) <noreply@github.com>

至此，再尝试查看本地仓库的commit签名信息，则会发现所有的commit签名都已得到验证：

    $ git log --show-signature
    # some output is omitted
    commit 6937d638d950362f73bfbf28bc4a39d1700bf26b
    gpg: Signature made 2019年07月24日 15:58:46
    gpg:                using RSA key 4AEE18F83AFDEB23
    gpg: Good signature from "GitHub (web-flow commit signing) <noreply@github.com>" [full]
    Author: Keith Null <20233656+keithnull@users.noreply.github.com>
    Date:   Wed Jul 24 15:58:46 2019 +0800

        Initial commit

## Github 创建 Pull Request

Pull Request 是开发者使用 GitHub 进行协作的利器。这个功能为用户提供了友好的页面，让提议的更改在并入官方项目之前，可以得到充分的讨论。

最简单地来说，Pull Request 是一种机制，让开发者告诉项目成员一个功能已经完成。一旦 feature 分支开发完毕，
开发者使用 GitHub 账号提交一个 Pull Request。它告诉所有参与者，他们需要审查代码，并将代码并入 master 分支。

Pull Request 不只是一个通知，还是一个专注于某个提议功能的讨论版

### Pull Request是如何工作的

Pull Request 需要两个不同的分支或是两个不同的仓库,

    1.开发者在他们的本地仓库中为某个功能创建一个专门的分支。
    2.开发者将分支推送到公共的 GitHub 仓库。
    3.开发者用 GitHub 发起一个 Pull Request。
    4.其余的团队成员审查代码，讨论并且做出修改。
    5.项目维护者将这个功能并入官方的仓库，然后关闭这个 Pull Request。

### 例子

如何将 Pull Request 用在 Fork 工作流中。小团队中的开发和向一个开源项目贡献代码都可以这样做。

Mary 是一位开发者，John 是项目的维护者。他们都有自己公开的 GitHub 仓库，John 的仓库之一便是下面的官方项目。

为了参与这个项目，Mary 首先要做的是 fork 属于 John 的 GitHub 仓库。她需要注册登录 GitHub，找到 John 的仓库，点击 Fork 按钮。

选好 fork 的目标位置之后，她在服务端就有了一个项目的副本.

接下来，Mary 需要将她刚刚 fork 的 GitHub 仓库克隆下来.她在本地会有一份项目的副本。她需要运行下面这个命令：

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

#### Mary创建了一个Pull Request

GitHub 上已经有了她的 feature 分支之后，Mary 可以找到被她 fork 的仓库，点击项目简介下的 New Pull Request 按钮，用她的 GitHub 账号创建一个 Pull Request。Mary 的仓库会被默认设置为源仓库（head fork），询问她指定源分支（compare）、目标仓库（base fork）和目标分支（base）。

Mary 想要将她的功能并入主代码库，所以源分支就是她的 feature 分支，目标仓库就是 John 的公开仓库，目标分支为 master。她还需要提供一个 Pull Request 的标题和简介。

在她创建了 Pull Request 之后，GitHub 会给 John 发送一条通知。

#### John审查了这个Pull Request

John 可以在他自己的 GitHub 仓库下的 Pull Request 选项卡中看到所有的 Pull Request。点击 Mary 的 Pull Request 会显示这个 Pull Request 的简介、feature 分支的提交历史，以及包含的更改。

如果他认为 feature 分支已经可以合并了，他只需点击 Merge Pull Request 按钮来通过这个 Pull Request，将 Mary 的 feature分支并入他的 master 分支.

但是，在这里例子中，假设 John 发现了 Mary 代码中的一个小 bug，需要她在合并前修复。他可以评论整个 Pull Request，也可以评论 feature 分支中某个特定的提交。

为了修复错误，Mary 在她的 feature 分支后面添加了另一个提交，并将它推送到了她的 GitHub 仓库，就像她之前做的一样。这个提交被自动添加到原来的 Pull Request 后面，John 可以在他的评论下方再次审查这些修改。

#### John 接受了 Pull Request

最后，John 接受了这些修改，将 feature 分支并入了 master 分支，关闭了这个 Pull Request。功能现在已经整合到了项目中，其他在 master 分支上工作的开发者可以使用标准的 git pull 命令将这些修改拉取到自己的本地仓库。
