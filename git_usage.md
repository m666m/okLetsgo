# 常用git操作及参考文档

- [常用git操作及参考文档](#常用git操作及参考文档)
  - [参考文档](#参考文档)
    - [git工作流：类似svn的TrunkBased集中式工作流 remote master -- local master(开发人员工作在此)](#git工作流类似svn的trunkbased集中式工作流-remote-master----local-master开发人员工作在此)
    - [git工作流：改良版集中式工作流 remote master -- local dev(开发人员工作在此)](#git工作流改良版集中式工作流-remote-master----local-dev开发人员工作在此)
    - [git工作流： 功能分支工作流 master -- dev(开发人员工作在此)](#git工作流-功能分支工作流-master----dev开发人员工作在此)
    - [git工作流： Gitflow工作流 master -- develop -- feature(开发人员工作在此)](#git工作流-gitflow工作流-master----develop----feature开发人员工作在此)
    - [阿里巴巴 AoneFlow：从master上拉出feature分支，相关feature分支合并出release分支最终合入master](#阿里巴巴-aoneflow从master上拉出feature分支相关feature分支合并出release分支最终合入master)
  - [git 安装和github（服务器端）设置](#git-安装和github服务器端设置)
    - [git初次使用](#git初次使用)
    - [使用ssh验证登陆](#使用ssh验证登陆)
    - [使用 GPG 签名 Git 提交](#使用-gpg-签名-git-提交)
  - [分支权限控制 及 轻量化git服务](#分支权限控制-及-轻量化git服务)
  - [分支的拉取和上传](#分支的拉取和上传)
    - [每日工作第一件事 拉取合并（含标签，变基）](#每日工作第一件事-拉取合并含标签变基)
    - [远程拉取合并本地的pull用法](#远程拉取合并本地的pull用法)
    - [git fetch 和 git pull的区别](#git-fetch-和-git-pull的区别)
      - [本地的两份代码--本地仓库和远程仓库](#本地的两份代码--本地仓库和远程仓库)
      - [git pull把2个过程合并，减少了操作](#git-pull把2个过程合并减少了操作)
    - [添加多个远程仓库](#添加多个远程仓库)
    - [从远程空白裸仓库拉取的步骤](#从远程空白裸仓库拉取的步骤)
    - [拉取指定版本](#拉取指定版本)
    - [git clone 获取指定分支的指定commit版本](#git-clone-获取指定分支的指定commit版本)
    - [删除分支，远程/本地](#删除分支远程本地)
    - [从远程git拉取指定分支](#从远程git拉取指定分支)
    - [本地空目录，仅拉取指定远程分支的用法](#本地空目录仅拉取指定远程分支的用法)
    - [本地非空目录，远程空的push三个用法](#本地非空目录远程空的push三个用法)
    - [本地非空，远程是裸仓库](#本地非空远程是裸仓库)
    - [git clone之后的第一次pull和push调试](#git-clone之后的第一次pull和push调试)
    - [git clone支持多种协议](#git-clone支持多种协议)
    - [git checkout 切换其他分支](#git-checkout-切换其他分支)
  - [两个分支合并的merge常用方法](#两个分支合并的merge常用方法)
    - [方法一. merge 默认的快进合并，需要合入分支的接续点就是分叉点](#方法一-merge-默认的快进合并需要合入分支的接续点就是分叉点)
    - [方法二. 大的分支合入要保留菱形分叉，便于管理](#方法二-大的分支合入要保留菱形分叉便于管理)
      - [压缩合并，只作为一个commit点合入](#压缩合并只作为一个commit点合入)
    - [方法三. 类似merge默认快进效果的rebase，不制造新commit点](#方法三-类似merge默认快进效果的rebase不制造新commit点)
    - [综述：合并两分支时的原则，如何选择菱形还是拉直](#综述合并两分支时的原则如何选择菱形还是拉直)
  - [本地开发分支，提交比较琐碎，用 --amend 压缩，不要多制作commit点](#本地开发分支提交比较琐碎用---amend-压缩不要多制作commit点)
  - [git rebase -i 交互式合并commit](#git-rebase--i-交互式合并commit)
    - [注意【仅在本地分支 尚未推送或合并过的代码上做 合并commit 的操作】](#注意仅在本地分支-尚未推送或合并过的代码上做-合并commit-的操作)
    - [示例](#示例)
    - [第一次做的时候遇到问题了： 622c01c没关联到 fea_stragy 分支](#第一次做的时候遇到问题了-622c01c没关联到-fea_stragy-分支)
  - [总结 rebase 变基在日常工作的用途](#总结-rebase-变基在日常工作的用途)
    - [一.你的功能分支拉取远程时要做变基](#一你的功能分支拉取远程时要做变基)
    - [二. 两分支合并，出现菱形分叉，需要拉直时，用rebase](#二-两分支合并出现菱形分叉需要拉直时用rebase)
    - [三.本地功能分支在合并到别的分支前压扁提交](#三本地功能分支在合并到别的分支前压扁提交)
  - [用法：标签相关](#用法标签相关)
  - [用法：stash储藏命令](#用法stash储藏命令)
    - [高级用法：找回误删的git stash 数据](#高级用法找回误删的git-stash-数据)
  - [用法：补丁神器cherry-pick](#用法补丁神器cherry-pick)
  - [用法：git diff的各个用法示例](#用法git-diff的各个用法示例)
  - [常见问题](#常见问题)
    - [Your branch and 'origin/xxx' have diverged](#your-branch-and-originxxx-have-diverged)
      - [情况1： Git fetch 、merge以后出现分叉（或没有先git pull直接push，原创已经有人提交修改）](#情况1-git-fetch-merge以后出现分叉或没有先git-pull直接push原创已经有人提交修改)
      - [情况2：rebase以后提示同样的错误](#情况2rebase以后提示同样的错误)
  - [版本回退的操作步骤](#版本回退的操作步骤)
    - [自己的分支硬回退例子](#自己的分支硬回退例子)
    - [远程仓库上有B先生新增提交了，然后你却回退了远程仓库到A1](#远程仓库上有b先生新增提交了然后你却回退了远程仓库到a1)
  - [彻底删除git中的大文件](#彻底删除git中的大文件)
  - [掉电导致objects目录下的某些文件为空](#掉电导致objects目录下的某些文件为空)

## 参考文档

    git的几种工作流 <https://www.zhihu.com/question/20070065/answer/1174997617>
                   <https://zhuanlan.zhihu.com/p/79668697>
                   <https://www.cnblogs.com/pluto4596/p/11464819.html>

    git官方文档 <https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E5%BC%80%E5%8F%91%E5%B7%A5%E4%BD%9C%E6%B5%81>

    命令速查 <https://training.github.com/downloads/zh_CN/github-git-cheat-sheet/>
    命令参考 <https://git-scm.com/docs>

    git命令教程
        <https://learngitbranching.js.org/?locale=zh_CN>
        <https://www.yiibai.com/git/git_branch.html>

    git使用教程 <https://zhuanlan.zhihu.com/p/158076293>
    git分支的使用过程 <https://zhuanlan.zhihu.com/p/22369088>
    Git 之 merge 与 rebase 的区别 <https://www.cnblogs.com/zhangzhang-y/p/13682281.html>

    离线Centos7环境使用Docker部署gitlab - CICD
    <https://zhuanlan.zhihu.com/p/147284555>
    <https://docs.gitlab.com/omnibus/docker/README.html>
    <https://blog.csdn.net/weixin_40816738/article/details/90052533>

    在 Linux 下搭建 Git 服务器 <https://www.cnblogs.com/dee0912/p/5815267.html>
    主力开发在Github，再同步到 Gitee 做国内网络访问的镜像 <https://www.zhihu.com/question/384541326/answer/1123864925>

### git工作流：类似svn的TrunkBased集中式工作流 remote master -- local master(开发人员工作在此)

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
    git pull （默认 orgin master 合到当前分支）

    # 标签也同步过来，不分叉的合并
    # git pull --tags --rebase origin master

4、干活，自己的代码文件各种改动。

5、下班前，提交本地仓库

    git add .

    git commit -m "提交的信息"

6、开发告一段落，可以发布时，提交远程仓库

    git pull --rebase
    git push （默认远程origin本地master）

### git工作流：改良版集中式工作流 remote master -- local dev(开发人员工作在此)

主干仅master分支。在本地新建其它分支，每天仅拉取远程master，更新本地dev分支。这种工作方式可以确保主干master的相对稳定。

0、添加远程仓库，从master分支新建dev分支

    git remote add origin 远程仓库地址

    git checkout master
    git pull
    git branch 分支名

1、每日工作，先确认本地无未提交未储存等等问题，处理后再继续

    git status

2、从远程仓库master同步本地仓库master

    git pull （默认远程origin本地master）

3、切换本地dev分支

    git checkout 分支名

4、合并本地 master 到本地dev分支，以便同步hotfix进来。

    git merge master

本地只是远程的一个镜像，以远程为准。
所以跨分支操作比如想合并远程master分支到远程dev分支，需要先pull远程master到本地master，再merge到本地dev，再push本地dev到远程master。
或在本地dev分支fetch远程master一个临时分支然后diff/merge到本地dev分支 <https://www.jianshu.com/p/bfb4b0de7e03>

5、开发告一段落，可以发布时，提交dev分支，合并到master再上传远程仓库

    git checkout 分支名
    git add .
    git commit -m "提交的信息"

    git checkout master
    git pull

    git merge 分支名
    git push -u origin master

### git工作流： 功能分支工作流 master -- dev(开发人员工作在此)

在上面的工作流基础上改良，把本地分支推送到远程，两个分支在本地和远程都存在，master分支保持稳定，开发工作放在dev分支，这俩都做主干分支。 CI/CD中持续集成部署在dev，持续交付部署在master。hotfix合并到远程的master分支和dev分支。

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

        git pull origin dev_xxx

工作告一段落，推送自己dev_xxx分支到远程dev_xxx，以便大家拉取测试：

    0、查看当前在git的哪个位置，是否有未提交未更新未暂存的，确保是干净的再继续

        git status

    1、将远程的 dev_xxx 同步到本地，以保持跟大家的同步及hotfeix及时更新。

        git checkout dev_xxx
        git status

        git pull origin dev_xxx

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

        git pull origin master

    3、将本地的dev_xxx合并到本地master

        git merge dev_xxx

    4、本地master推送到远程master

        git push origin master

    PS:

        每个git status后，根据实际情况进行处理，然后再做下一步。

        只在关键tag点，把dev分支合并到master分支，平时的操作仅限dev分支。

### git工作流： Gitflow工作流 master -- develop -- feature(开发人员工作在此)

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

### 阿里巴巴 AoneFlow：从master上拉出feature分支，相关feature分支合并出release分支最终合入master

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

## git 安装和github（服务器端）设置

### git初次使用

需要先设置用户名和邮箱

    git config user.name "m666m"
    git config user.email "m666m@github.com"

    #  设置gpg程序的路径，见下面的章节 <使用 GPG 签名 Git 提交>
    $ where gpg
        E:\Git\usr\bin\gpg.exe  # 这个是 Git for windows 自带的
        E:\GnuPG\bin\gpg.exe    # 这个才是我们要用的
    $ git config --global gpg.program "E:\GnuPG\bin\gpg.exe"
    done

在用户目录的~/.ssh目录下，执行如下操作

    # 设置.ssh目录权限
    chmod 700 -R .ssh

    # 生成ssh key文件，默认回答都是一路回车
    ssh-keygen -t rsa

### 使用ssh验证登陆

如果超时，就多试几次，国内的网络环境太差

    $ ssh -T git@github.com
    Received disconnect from 20.205.243.166 port 22:11: Bye Bye
    Disconnected from 20.205.243.166 port 22

    $ ssh -T git@github.com
    Hi m666m! You've successfully authenticated, but GitHub does not provide shell access.

### 使用 GPG 签名 Git 提交

<https://cloud.tencent.com/developer/article/1656009?from=article.detail.1531457>

本地控制台下执行命令，先导出该 ID 的公钥，见<gnu_tools.md>的相关章节

复制公钥并将其添加到 GitLab 个人资料的设置中：

   Gitlab 页面右上角，单击你的头像，Settings—> GPG keys，然后粘贴 GPG key。

本地控制台下执行命令，将 GPG 密钥与 Git 关联：

    git config --global user.signingkey 66DD4800155F7A2B
    # 或者
    git config user.signingkey 66DD4800155F7A2B

签名提交

Git 提交时，使用 -S 标记进行 GPG 签名：

    git commit -S -m “commit message"

懒得打 -S 参数，设置默认使用 GPG 签名提交：

    git config --global commit.gpgsign true
    # 或者
    git config commit.gpgsign true

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

撤销（revoke）或删除 GPG key

    撤销密钥将取消验证已签名的提交，通过使用此密钥验证的提交将变为未验证状态。如果你的密钥已被盗用，则应使用此操作。

    删除密钥不会取消验证已签名的提交。使用此密钥验证的提交将保持验证状态。

## 分支权限控制 及 轻量化git服务

Gitolite 基于ssh密钥管理的用户权限控制

    <https://github.com/sitaramc/gitolite>
    <https://gitolite.com/gitolite/basic-admin.html>
    <https://zhuanlan.zhihu.com/p/100834900>

轻量化Git服务

    goso  + Jenkins <https://github.com/gogs/gogs/blob/master/README_ZH.md>
    gitea + Jenkins <https://github.com/go-gitea/>

## 分支的拉取和上传

### 每日工作第一件事 拉取合并（含标签，变基）

严重注意

    千万别一上来就 git pull ！！！
    用 git fetch + git status 不变动本地工作目录的内容查看远程
    详见下面章节<git fetch 和 git pull的区别>

先看看分支的远程库有没有别人新增，然后再git status才能看出来门道

    # 先看看有无未提交的，跟现有的本地远程代码比对没差别，不代表远程仓库的代码没差别，别人可能有更新
    git status

    # 本地git branch -a看不到时，一般需要在本地使用git remote update 或 git fetch --all更新
    # 从远程下载，这个不会跟本地现有文件冲突，下载的是本地的那个对应远程仓库的目录
    # 下载当前分支可以简写为： git fetch
    git fetch origin master

    # 查看本地代码跟远程仓库代码（已下载到本地）的差异
    # 简单的：
    git status  # 如果有本地未提交的，先stash暂存才能继续下面的代码合并
    # 详细的：
    git diff ..origin/master

    # 酌情合并代码到本地
    git merge 或 git rebase
    # 解决冲突
    git add 冲突文件
    git rebase –continue 或 git merge

    # 再确认下没问题了
    git status

整合到一个命令：

    # 拉取远程加合并本地，连带标签，-r是rebase，否则是merge，最好指定要fetch的remote和分支名。
    # 详见下面章节[远程拉取合并本地的pull用法]

    git pull --tags -r origin master

没点，俩点，仨点的区别，慢慢研究吧

<https://stackoverflow.com/questions/4944376/how-to-check-real-git-diff-before-merging-from-remote-branch>

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

2.大家分别提交自己的代码，e点的先提交，他pull+push，这时候远程仓库上直接接上了

    a---b---c ---d---e
                别人的

3.你的g点要提交，先pull，这时git会提示输入新建commit点的注释了。。。

git pull = git fetch + git merge后的效果，看起来像个菱形，提交的人越多，这个环越多

              h--i 又一个人的。。。
             /     \
            ...     ...
              d---e 别人的
             /     \
    a---b---c       new commit 由git制造
             \     /
              f---g  你的

git pull --rebase = git fetch + git rebase 去掉多余的分叉：

    a---b---c ---d---e  ---f---g
              别人      你的

通过 --rebase 方式，你的提交重新拼接在远端新增提交的最后，这样看起来更简洁，找自己的提交点也方便。

虽然可能要解决一些合并冲突，但是一条直线，看起来舒服多了，最重要的是后期合并commit就方便了。

对别人来说，你推送后新增的 f-g 两个提交是新增在他的 d-e 上的，他在你的 f-g 后面继续线性追加，逻辑更清晰。
最终用rebase实现大家都是在线性的增长master分支，不搞分叉。

    -a-b-c -d-e  -f-g  -h-i  -j-k  ...
           别人   你的  别人  你的   ...

### git fetch 和 git pull的区别

通常的工作流程是，先用 git fetch 拉取远程分支，然后用 git merge 把拉取的内容合并到本地分支，
因为这二者都是连用的，所有有个简化版就是 git pull，大多数情况下直接用 git pull 就够用了，
但是要记住，正规的分支拉取操作是 fetch 和 merge 两个步骤完成的。

最完整的操作，是先fetch下来然后diff看看，然后再决定是否merge或rebase，图省事才pull。

    $git fetch <远程主机名> <分支名> # 注意之间有空格

    # 取回特定分支的更新
    $git fetch origin master

    # 可简写，默认拉取所有分支，如果有很多分支，就比较慢了
    $git fetch

    # 查看fetch下来的远程代码跟本地的区别
    git diff ..origin/master

#### 本地的两份代码--本地仓库和远程仓库

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

#### git pull把2个过程合并，减少了操作

将远程主机的某个分支的更新取回，并与本地指定的分支合并 ：

    git pull <远程主机名> <远程分支名>:<本地分支名>

    # 如果远程分支是与当前分支合并，则冒号后面的部分可以省略
    git pull origin master

    # 如果远程主机名origin，分支就是当前分支，可简写
    git pull

    # 拉取后，用rebase进行拉直合并
    git pull --rebase

分支的合并，如上所述的是fetch下来一份远程合并到本地，
这个操作，跟本地有两个分支进行合并，没什么区别。

分支合并的详细用法见下面的章节 [两个分支合并的merge常用方法]

### 添加多个远程仓库

方法一、推送命令只会推送到默认的origin地址，其他的各个server1，2，3得再挨个执行push命令

    git remote add server1 ssh://git@x.x.x.x:12345/gitrepo/project_name.git
    git remote add server2 ssh://git@x.x.x.x:12345/gitrepo/project_name.git
    git remote add server3 ssh://git@x.x.x.x:12345/gitrepo/project_name.git

    git push server1 master
    git push server1 developer

方法二、省事的方法，给origin添加多个远程地址，默认fetch还是origin最早添加的地址，push地址变成了多个

    git remote set-url --add origin ssh://git@x.x.x.x:12345/gitrepo/project_name.git

    $ git remote show origin
    * remote origin
    Fetch URL: git@github.com:m666m/af_monitor.git
    Push  URL: git@github.com:m666m/af_monitor.git
    Push  URL: ssh://git@x.x.x.x:12345/gitrepo/af_monitor.git
    HEAD branch: main
    Remote branch:
        main tracked
    Local branch configured for 'git pull':
        main merges with remote main
    Local ref configured for 'git push':
        main pushes to main (up to date)

如果想删除

    git remote set-url --delete origin --push origin ssh://git@x.x.x.x:12345/gitrepo/project_name.git

### 从远程空白裸仓库拉取的步骤

远程仓库里有文件，随便哪个机器 git clone命令都可以正常拉取的。而刚建好的裸仓库是空白的，直接用clone拉，后面做pull和push会报错，需要先给远程仓库上传个文件。

    git clone ssh://git@x.x.x.x:12345/gitrepo/tea.git

0.先保证ssh连接远程仓库的用户时可以使用本机用户的密钥文件，免密登陆

    添加sshkey 略

除了github这样的，私有仓库都需要用户鉴权才能读取文件。

1.远程操作

    git 新建远程仓库
    git init --bare tea.git

2.本地操作，新建文件夹，git初始化，添加远程仓库地址

    $ mkdir tea

    $ cd tea

    $ git init
    Initialized empty Git repository in C://tea/.git/

    $ git remote add origin ssh://git@x.x.x.x:12345/gitrepo/tea.git

3.本地操作，先提交个文件，推送远程，否则直接pull会各种报错

    echo '# aaa' > mmm.py
    git add mmm.py
    git commit -m 'a'
    git push origin master

4.本地操作，拉取文件，先绑定远程

    $ git branch --set-upstream-to=origin/master master
    Branch 'master' set up to track remote branch 'master' from 'origin'.

    $ git pull
    Already up to date.

5.本地操作，正常了，看下origin设置，是不是pull和push都有配置了：

    $ git remote show origin
    * remote origin
      Fetch URL: ssh://git@x.x.x.x:12345/gitrepo/tea.git
      Push  URL: ssh://git@x.x.x.x:12345/gitrepo/tea.git
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

### 拉取指定版本

    git clone 下载源码

    git tag　列出所有版本号

    git checkout　+某版本号　

你当前文件夹下的源码会变成这个版本号的源码．比起一个个下，这种切换比较方便

### git clone 获取指定分支的指定commit版本

git clone 默认是取回 master 分支，可以使用 -b 参数指定的分支。 -b 参数不仅支持分支名，还支持 tag 名等。

        git clone  <remote-addr:repo.git> -b <branch-or-tag-or-commit>

需求是获取commit id，没直接的办法。下面提供另一个步骤：

选择一个包含目标 commit id 的branch或tag，并指定depth=1以获得比较少的额外文件传输。

    git clone --depth 1 <remote-addr:repo.git> -b < branch-or-tag >

clone完成后，进入目录，执行

    git fetch --depth < a-numer >

不断增大步骤2的数字，直到找到你要的commit

### 删除分支，远程/本地

0.先看看有多少本地和远程分支

    git branch -a

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

    git branch -a # 查看

    git fetch origin -p  # git remote prune

4.删除本地

    git branch -d fea_xxx

### 从远程git拉取指定分支

    git fetch origin dev_xxx
    git branch -a -v
    git checkout -b newBranch origin/dev_xxx

### 本地空目录，仅拉取指定远程分支的用法

    git clone -b dev 代码仓库地址 （dev是分支名称）

    或：
        git init
        git remote add origin git@github.com:XXXX/nothing2.git
        git fetch origin dev（dev即分支名）
        git checkout -b dev(本地分支名称) origin/dev(远程分支名称)
        git pull origin dev(远程分支名称)

### 本地非空目录，远程空的push三个用法

    远程已有dev_xxx分支并且已经关联本地分支dev_xxx，本地已经切换到dev_xxx

        git push

    远程没有remote_branch分支，本地已经切换到dev_xxx

        git push origin dev_xxx:remote_branch

    远程已有dev_xxx分支但未关联本地分支dev_xxx，本地已经切换到dev_xxx

        git push -u origin/dev_xxx

### 本地非空，远程是裸仓库

本地先 git init，然后

    git remote add origin ssh://git@x.x.x.x:12345/uspace/gitrepo/af_monitor.git

这时显示结果

    $ git remote show origin
    * remote origin
    Fetch URL: ssh://git@x.x.x.x:12345/uspace/gitrepo/af_monitor.git
    Push  URL: ssh://git@x.x.x.x:12345/uspace/gitrepo/af_monitor.git
    HEAD branch: (unknown)

把文件都push上去，会提示没有上游分支，直接推。

这时显示结果，正常了

    $ git remote show origin
    * remote origin
    Fetch URL: ssh://git@x.x.x.x:12345/uspace/gitrepo/af_monitor.git
    Push  URL: ssh://git@x.x.x.x:12345/uspace/gitrepo/af_monitor.git
    HEAD branch: master
    Remote branch:
        master tracked
    Local branch configured for 'git pull':
        master merges with remote master
    Local ref configured for 'git push':
        master pushes to master (up to date)

### git clone之后的第一次pull和push调试

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

远程仓库格式

    ssh://git@xx.xx.xx.xx:12345/gitrepo/myproj.git
    git@github.com:m666m/okLetsgo.git
    https://github.com/m666m/myproj

### git clone支持多种协议

<https://www.w3cschool.cn/git/git-uroc2pow.html>
Git协议下载速度最快，SSH协议用于需要用户认证的场合。

    git clone git://example.com/path/to/repo.git
    git clone [user@]example.com:port/path/to/repo.git

    git clone ssh://[user@]example.com/path/to/repo.git

    git clone http[s]://example.com/path/to/repo.git
    git clone http://git.oschina.net/yiibai/sample.git

    git clone /opt/git/project.git
    git clone file:///opt/git/project.git
    git clone ftp[s]://example.com/path/to/repo.git
    git clone rsync://example.com/path/to/repo.git

### git checkout 切换其他分支

1.查看远程分支

    $ git branch -a
    我在mxnet根目录下运行以上命令：

    ~/mxnet$ git branch -a
    * master
    remotes/origin/HEAD -> origin/master
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

## 两个分支合并的merge常用方法

能做合并的基础是两个分支有相交点，如果三分支合并无直接交点需要用rebase <https://git-scm.com/docs/git-rebase>

                          d---e  hotfix分支
                         /
    master主干  a---b---c
                         \
                          f---g  feature分支

### 方法一. merge 默认的快进合并，需要合入分支的接续点就是分叉点

merge默认做的是快进，即不新增commit点，走一条线的效果，跟上面的单分支拉取的合并思路相反：

hotfix分支先合并到主干分支 master

    git checkout master
    git pull
    git merge hotfix

形成的master分支：

    master分支  a---b---c ---d---e
                          先合入的分支，直接接c点，git默认做快进，不制造新commit点

    git reset HEAD^ --hard 回退是到d

feature分支后合并到master分支：

    git checkout master
    git pull
    git merge feature

因为不是接续c点，所以git会制作新commit点，形成菱形分叉：

                          d---e  hotfix分支
                         /      \
    master分支  a---b---c         new(HEAD) 由git制造
                         \      /
                          f---g  feature分支

    git reset HEAD^ --hard 回退是到e

merge 操作遇到冲突的时候，当前merge不能继续进行下去。手动修改冲突内容后，add 修改，commit 就可以了。

如果遇到多人合并分支，都是在c点后，不想出现很多环状提交，拉直见下面的方法三。

### 方法二. 大的分支合入要保留菱形分叉，便于管理

feature 分支是用来开发特性的，上面会存在许多零碎的提交。
如果出现接续分叉点合并，默认的快进式合并会把 feature 分支的提交历史混入到 master 中，
这样 master 的提交历史就不够简洁了，所以分支合并到主干时，保留菱形分叉的效果更好。

    git merge feature --no-ff -m"本次合并添加的注释信息"

                              f---g---h---i  feature分支
                             /             \
        master主干  a---b---c -------------- new(HEAD) 由git制造

这样如果主干版本回退，很容易就可以退到feature合并之前的位置

    git reset HEAD^ --hard 的效果是回到c点

对hotfix分支，再合入就在它后面又一个菱形，所以最好用rebase合入master，实现拉直（参见方法三）

                              f---g  feature分支
                             /     \
        master主干  a---b---c ------- new ---d---e
                                          hotfix分支用rebase合入，不制造commit点

#### 压缩合并，只作为一个commit点合入

用于 feature 分支的commit太多了，合入主干时简单粗暴的精简处理

    git checkout master

    git merge --squash feature -m"fgmix 只有我这一个提交点，原来的commit历史不要了"

效果

                          d---e  hotfix 分支先合并，git默认做快进
                         /     \
    master主干  a---b---c        newP(HEAD) 由git在后合入分叉时生成
                         \     /
                          fgmix
                          feature分支只有一个commit点，后合并

不推荐用压缩合并

    如果是最先合并，即紧接着分叉点c合入主干，有可能被快进合并，不能制造新commit点形成菱形。

    功能分支的commit合并应该在合入主干之前，由开发组内部自行整理，不能简单粗暴的一把压缩合并。

### 方法三. 类似merge默认快进效果的rebase，不制造新commit点

初始状态是两条分叉：

          A---B---C feature分支
         /
    D---E---F---G   master分支先合入了hotfix，默认快进合并
        *
        hotfix分支和feature分支的分叉点在E

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

### 综述：合并两分支时的原则，如何选择菱形还是拉直

    两分支合并，用merge -no-ff做菱形分叉，用rebase做拉直。

    主分支合并功能分支，要做菱形分叉，合入hotfix要拉直。

以一个功能分支 fea 合并到主干分支 master 为例（对主从分支开发模式，fea分支就是从分支）：

0. 项目发版本，最好单独开一个目录，跟自己做开发的该项目目录独立，以便开发归开发，版本发布归版本发布。
   以下操作都是在版本发布的这个目录下做。
   这个步骤可以省略。

1. [本地]fea分支在合入[本地]主分支之前，拉取[远程]，保证是最新的内容。
    git checkout fea
    git pull --rebase  # 不制造环形
   注意：远程的fea分支必须是可以通过测试的，不然后续合并代码后，问题更不好界定。

2. [本地]fea分支在合入[本地]主分支之前，内部先整理合并commit，保证简洁再合入主分支。
    git rebase -i HEAD~50
   这个步骤可以省略。

3. 在[本地]建立[合并用]分支 meg_for_v1，名称要体现出版本计划。
    git checkout -b meg_for_v1
   上面整理过的[本地]fea分支，压缩合并的内容只是合入主分支用的，所以不要推送[远程]。
   锁定远程fea分支的写入，防止开发人员继续提交。
   这个步骤可以省略。

4. [本地][合并用]meg_for_v1分支推送[远程]。
   之后的一段时间，走测试流程，开发人员拉取该分支，以此分支为准，修改冲突和解决bug。
    git push
   注：
   如果第二步没做压缩合并等工作，那么这个[合并用]分支就是fea分支。

5. 直到上面的整合工作完成后，再继续下面的步骤。

6. [本地]主分支拉取[远程]，保证是最新的内容。
    git checkout master
    git pull --rebase  # 不制造环形

7. [本地]主分支合并[本地]meg_for_v1分支，制造环形。
    git merge meg_for_v1 --no-ff -m"版本v1，新增xxx功能"
   注意：制造环形后，主分支多出来一个commit点。在这里做标记，打版本标签，便于各版本切换

8. [本地]主分支推送[远程]。
    git push

9. [本地]主分支打标签，并推送远程。
    git tag -a v1.1 -m"版本v1，新增xxx功能"
    git push origin v1.1

10. 收尾工作，分两种。
    如果做了第二步和第三步，则可以删除fea分支，删除meg_for_v1分支，这俩已经完成历史使命了。
        具体操作见前面的<用法：删除分支>章节
    如果没做第二步和第三步，持续使用fea分支，则fea分支需要从远程主分支拉取合并代码，并解决合并冲突：
        git checkout master
        git pull --rebase  # 不制造环形
        git checkout fea
        git pull --rebase  # 不制造环形
        git rebase master  # 不制造环形
        git push

11. 新的功能分支，从[远程]的主分支拉取建立，开始新的一轮循环。

## 本地开发分支，提交比较琐碎，用 --amend 压缩，不要多制作commit点

提交但是不制作新的commit点（上次的变一下），适合本次和上次提交内容相近的场景

    git add .
    git commit --amend  # 等价于 git rebase -i HEAD~2

## git rebase -i 交互式合并commit

### 注意【仅在本地分支 尚未推送或合并过的代码上做 合并commit 的操作】

    已经推送到远端仓库的提交，如果别人都拉取开发了，你再做rebase并再次提交，之前别人拉取的内容变了，双方都得再做拉取整合。如果时间线已经是很长的了，会导致很大的混乱。

    拉取到本地的最新代码，不要对之前的内容做commit合并。不然，如果推送到服务器上，之前别人拉取的内容变了，需要再次合并你的改那块内容，又是在制造混乱。

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

## 总结 rebase 变基在日常工作的用途

<https://zhuanlan.zhihu.com/p/249231960> <https://opensource.com/article/20/7/git-best-practices>

### 一.你的功能分支拉取远程时要做变基

当你持续地开发你的功能分支时，请经常对它做 变基(rebase)：

    1. 本地dev分支拉取远程dev分支的时候做rebase
    git checkout dev_xxx
    git pull --rebase

### 二. 两分支合并，出现菱形分叉，需要拉直时，用rebase

菱形分叉会制造新的commit点，根据具体情况考虑是否需要，如果不需要，尽量变基拉直。

    大版本合并，功能分支合并master分支这种，需要菱形分叉(功能分支合并master时用rebase，master分支合并功能分支时用merge)
    hotfix在主干上的接续，一般rebase拉直
    本地功能分支拉取同步远程代码，一般rebase拉直

举例:

1.本地dev分支拉取远程dev分支用rebase拉直

    git checkout feature-xyz
    git pull --rebase

2.本地dev分支合并master分支的时候做rebase拉直

    git checkout master
    git pull --rebase

    git checkout feature-xyz  # 假设的功能分支名称
    git rebase master  # 可能需要解决  feature-xyz 上的合并冲突

这些步骤会在你的功能分支上重写历史（这并不是件坏事）。

首先，它会使你的功能分支获得 master 分支上当前的所有更新。

其次，你在功能分支上的所有提交都会在该分支历史的顶部重写，因此它们会顺序地出现在日志中。

你可能需要一路解决遇到的合并冲突，这也许是个挑战。但是，这是解决冲突最好的时机，因为它只影响你的功能分支。

3.在解决完所有冲突并进行回归测试后，如果你准备好将dev分支合并回 master，那么就可以在再次执行上述的变基步骤几次后进行合并，这次的合并应该用菱形分叉

    git checkout master
    # ... 如果改动时间长master可能有变化，需要重复上面第2步
    git merge feature-xyz -no-ff

    git push

在此期间，如果其他人也将和你有冲突的更改推送到 master，那么 Git 合并将再次发生冲突。你需要解决它们并重新进行回归测试。

还有一些其他的合并哲学（例如，只使用合并而不使用变基以防止重写历史），其中一些甚至可能更简单易用。但是，master 分支的历史将穿插着所有同时开发的功能的提交，这样混乱的历史很难回顾。

定期的变基是一个干净可靠的策略，因为提交历史日志将以有意义的功能序列进行排列（每个人的commit都是分段但是线性的排列）。

### 三.本地功能分支在合并到别的分支前压扁提交

【注意】

    仅在本地分支尚未推送或合并过的代码上做rebase合并commit 的操作

当你在功能分支上开发时，即使再小的修改也可以作为一个提交。

但是，如果每个功能分支都要产生五十个提交，那么随着不断地增添新功能，master 分支的提交数终将无谓地膨胀。

通常来说，每个功能分支只应该往 master 中增加一个或几个提交。

为此，你需要将多个提交 压扁(Squash)成一个或者几个带有更详细信息的提交中。

通常使用以下命令来完成：

    git rebase -i HEAD~20  # 查看可进行压扁的二十个提交

当这条命令执行后，将弹出一个提交列表的编辑器，你可以通过包括 遴选(pick)或 压扁(squash)在内的数种方式编辑它。

“遴选”一个提交即保留这个提交。“压扁”一个提交则是将这个提交合并到前一个之中。

使用这些方法，你就可以将多个提交合并到一个提交之中，对其进行编辑和清理。

这也是一个清理不重要的提交信息的机会（例如，带错字的提交）。

总之，保留所有与提交相关的操作，但在合并到 master 分支前，合并并编辑相关信息以明确意图。

注意，不要在变基的过程中不小心删掉提交。

在执行完诸如变基之类的操作后，我会再次看看 git log 并做最终的修改：

    git log --graph --oneline

    # 提交但是不制作新的commit点（上次的变一下），适合本次和上次提交内容相近的场景
    git commit --amend  # 等价于 git rebase -i HEAD~2

最后，由于重写了分支的 Git 提交历史，必须强制更新远程分支：

    git push -f

## 用法：标签相关

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

## 用法：stash储藏命令

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

### 高级用法：找回误删的git stash 数据

本想 git stash pop ，但是输入成 git stash drop

1.查找所有不可访问的对象

    git fsck --unreachable

2.逐个确认该对象的代码详情，找到自己丢失的那个

    git show a923f340ua

3.恢复找到的对象

    git stash apply 95ccbd927ad4cd413ee2a28014c81454f4ede82c

## 用法：补丁神器cherry-pick

针对master分支上修改过的bug，要在dev分支上也做一遍修复

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

## 用法：git diff的各个用法示例

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

## 常见问题

### Your branch and 'origin/xxx' have diverged

<https://blog.csdn.net/d6619309/article/details/52711035>

当前工作的git仓库模型为:

    upstream
      |
    origin
      |
    local copy

#### 情况1： Git fetch 、merge以后出现分叉（或没有先git pull直接push，原创已经有人提交修改）

git fetch upstream上游代码后执行git merge，然后git status发现Git分支出现分叉。

出现分叉的原因是存在两种独立的提交(每种可能有多个提交):
一种是来自你本地分支副本的提交，另外的提交来自远程分支副本。

这种情况，通常是由于另外一个人在上游相同的分支做了提交。

解决的华，在本地分支上，执行:

    git fetch
    git rebase

rebase以后的git提交历史树为:

    ... o ---- o ---- A ---- B  origin/branch_xxx (upstream work)
                              \
                               C`  branch_xxx (your work)

#### 情况2：rebase以后提示同样的错误

这是因为你在执行rebase之前，已经往你的origin上面push了提交。由于rebase会重写历史提交记录，因此你的本地和你的origin的历史提交状态是不同的，同样产生了分叉:

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

我的想法是，不用 git push -f，用 git merge 是否可以解决？

## 版本回退的操作步骤

如果发现最近的提交不对路，回退到上个提交，以便修改

    # 先保留下现场以便反悔救命，窗口别关啊！
    git reflog

    # 差异放在工作区域，最常用
    git reset HEAD~1

    # 差异放在在储藏（stage）区域
    git reset --soft HEAD~1

    # 差异全扔，楞回到某个commit
    git reset --hard HEAD~1

### 自己的分支硬回退例子

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

### 远程仓库上有B先生新增提交了，然后你却回退了远程仓库到A1

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

## 彻底删除git中的大文件

git 如果提交一个文件，然后删除他，继续提交，那么这个文件是存在 git 中，需要使用特殊的命令才可以删除。.git主要记录每次提交变动，当我们的项目越来越大的时候，我们发现 .git文件越来越大

很大的可能是因为提交了大文件，如果你提交了大文件，那么即使你在之后的版本中将其删除，但是，
实际上，记录中的大文件仍然存在。

虽然你在后面的版本中删除了大文件，但是Git是有版本倒退功能的吧，那么如果大文件不记录下来，
git拿什么来给你回退呢？但是，.git文件越来越大导致的问题是： 每次拉项目都要耗费大量的时间，并且每个人都要花费
那么多的时间。

git给出了解决方案，使用git branch-filter来遍历git history tree, 可以永久删除history中的大文件，达到让.git文件瘦身的目的。
<https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/removing-sensitive-data-from-a-repository>

## 掉电导致objects目录下的某些文件为空

如果保存远程gitrepo的虚拟机经常关闭或者本地机器突然掉电，会导致.git/objects目录下的某些文件为空:

    git fsck --fule, 删空文件, head重新指向上一条不空的object

    <https://segmentfault.com/a/1190000008734662>
    <https://stackoverflow.com/questions/11706215/how-to-fix-git-error-object-file-is-empty>

  简单的应对，找个本地文件不含空文件的：

    1.远程报错的，从本地拷贝远程为空的文件过去，但是如果有多个来源提交到服务器文件的话可能会出现不一致的情况。

    2.远程报错的，本地直接git clone --bare 重新搞上去得了，但是会丢历史版本信息

    3.本地报错的，把.git删掉，重新init，但是会丢历史版本信息
