# 常用git操作及参考文档

## 参考文档

    git的几种工作流 <https://www.zhihu.com/question/20070065/answer/1174997617>
                   <https://zhuanlan.zhihu.com/p/79668697>
                   <https://www.cnblogs.com/pluto4596/p/11464819.html>

    git官方文档 <https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E5%BC%80%E5%8F%91%E5%B7%A5%E4%BD%9C%E6%B5%81>

    命令速查 <https://training.github.com/downloads/zh_CN/github-git-cheat-sheet/>
    命令参考 <https://git-scm.com/docs>

    最好的git命令教程 <https://learngitbranching.js.org/?locale=zh_CN>

    git使用教程 <https://zhuanlan.zhihu.com/p/158076293>
    git分支的使用过程 <https://zhuanlan.zhihu.com/p/22369088>
    图解 git rebase <https://zhuanlan.zhihu.com/p/198887332>

    离线Centos7环境使用Docker部署gitlab - CICD
    <https://zhuanlan.zhihu.com/p/147284555>
    <https://docs.gitlab.com/omnibus/docker/README.html>
    <https://blog.csdn.net/weixin_40816738/article/details/90052533>

    在 Linux 下搭建 Git 服务器 <https://www.cnblogs.com/dee0912/p/5815267.html>
    主力开发在Github，再同步到 Gitee 做国内网络访问的镜像 <https://www.zhihu.com/question/384541326/answer/1123864925>

## git工作流：类似svn的TrunkBased集中式工作流 remote master -- local master(开发人员工作在此)

主干仅master分支

    适用场景：适合于单一稳定产品线，迭代排期稳定，需求边界完全可控的团队。
    优点：模型简单
    缺点：

    线上修正：按照上图目前系统已经发布了12.1，下一个迭代也在开发中，线上发现了问题。由于Release分支是禁止修改的，而Trunk此时包含了新的特性代码无法发布，就造成了线上异常的修复需要在分离的hotfix分支上进行，变相的造成了多个master分支。

    需求变更：无法支持，已经提交到Trunk的内容抽离很困难。

    太多的团队同时工作在主干上，到发布的时候就可能出现灾难（尤其是多版本并行开发的情况）

0、添加远程仓库

    git remote add origin 远程仓库地址

1、上班后，先确认本地无未提交未储存等等问题，处理后再继续

    git status

2、从远程仓库同步本地仓库，以便同步hotfix进来。

    git pull （默认远程origin本地master）

3、干活，自己的代码文件各种改动。

4、下班前，提交本地仓库

    git add .

    git commit -m "提交的信息"

5、开发告一段落，可以发布时，提交远程仓库

    git pull 先把远程的master内容同步到本地
    git push （默认远程origin本地master）

## git工作流：改良版集中式工作流 remote master -- local dev(开发人员工作在此)

主干仅master分支。在本地新建其它分支，每天仅拉取远程master，更新本地dev分支。这种工作方式可以确保主干master的相对稳定。

0、添加远程仓库，从master分支新建dev分支

    git remote add origin 远程仓库地址

    git checkout master
    git pull
    git branch 分支名

1、每日工作，先确认本地无未提交未储存等等问题，处理后再继续

    git checkout master
    git status

2、从远程仓库master同步本地仓库master

    git pull （默认远程origin本地master）

3、切换本地dev分支

    git checkout 分支名

4、合并本地 master 到本地dev分支，以便同步hotfix进来。

    git merge master

本地只是远程的一个镜像，以远程为准。
所以跨分支操作比如想合并远程master分支到远程dev分支，需要先pull远程master到本地master，再merge到本地dev，再push本地dev到远程master。
或在本地dev分支fetch远程master一个临时分支然后diff/merge到本地dev分支... <https://www.jianshu.com/p/bfb4b0de7e03>

5、开发告一段落，可以发布时，提交dev分支，合并到master再上传远程仓库

    git checkout 分支名
    git add .
    git commit -m "提交的信息"

    git checkout master
    git pull

    git merge 分支名
    git push -u origin master

## git工作流： 功能分支工作流 master -- dev(开发人员工作在此)

上面的方法基础上把本地分支推送到远程，两个分支在本地和远程都存在，master分支保持稳定，开发工作放在dev分支，这俩都做主干分支。 CI/CD中持续集成部署在dev，持续交付部署在master。hotfix合并到远程的master分支和dev分支。

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

## git工作流： Gitflow工作流 master -- develop -- feature(开发人员工作在此)

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

原文 <https://nvie.com/posts/a-successful-git-branching-model/>

    汉化 <https://zhuanlan.zhihu.com/p/38772378> <https://zhuanlan.zhihu.com/p/36085631>
    抛弃 Git Flow 的 8 大理由 <https://baijiahao.baidu.com/s?id=1661688354212771172&wfr=spider&for=pc>

![Gitflow工作流](https://nvie.com/img/git-model@2x.png)

## 阿里巴巴 AoneFlow：从master上拉出feature分支，相关feature分支合并出release分支最终合入master

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

## 用法：分支的拉取和上传

本地空目录，仅拉取指定远程分支的用法：

    git clone -b dev 代码仓库地址 （dev是分支名称）

    或：
        git init
        git remote add origin git@github.com:XXXX/nothing2.git
        git fetch origin dev（dev即分支名）
        git checkout -b dev(本地分支名称) origin/dev(远程分支名称)
        git pull origin dev(远程分支名称)

push三个用法：

    远程已有dev_xxx分支并且已经关联本地分支dev_xxx，本地已经切换到dev_xxx

        git push

    远程没有remote_branch分支，本地已经切换到dev_xxx

        git push origin dev_xxx:remote_branch

    远程已有dev_xxx分支但未关联本地分支dev_xxx，本地已经切换到dev_xxx

        git push -u origin/dev_xxx

单纯建立本地分支和远程分支serverfix的对应，本地已经切换到dev_xxx

    git branch -u origin/serverfix

## 用法：git clone 获取指定指定分支的指定commit版本

git clone 默认是取回 master 分支，可以使用 -b 参数指定的分支。 -b 参数不仅支持分支名，还支持 tag 名等。

        git clone  <remote-addr:repo.git> -b <branch-or-tag-or-commit>

需求是获取commit id，没直接的办法。下面提供另一个步骤：

选择一个包含目标 commit id 的branch或tag，并指定depth=1以获得比较少的额外文件传输。

    git clone --depth 1 <remote-addr:repo.git> -b < branch-or-tag >

clone完成后，进入目录，执行

    git fetch --depth < a-numer >

不断增大步骤2的数字，直到找到你要的commit

## 用法：删除分支，远程/本地

0.先看看有多少本地和远程分支

    git branch -a

1.切换到其他分支再进行操作

    git checkout master

2.删除远程分支的指针而不是直接删分支，方便数据恢复。

    git push origin --delete serverfix

3.删除本地

    git branch -d serverfix

## 分支权限控制

Gitolite 基于ssh密钥管理的用户权限控制

    <https://github.com/sitaramc/gitolite>
    <https://gitolite.com/gitolite/basic-admin.html>

## 用法：标签相关

标签总是和某个commit挂钩。如果这个commit既出现在master分支，又出现在dev分支，那么在这两个分支上都可以看到这个标签。

1.新增标签

    git tag -a v1.1 -m "新增xxx功能"

2.查看标签

    git tag
    git show v1*

3.推送标签

    git push origin v1.1
    git push origin --tags (批量推送)

4.新增轻量化标签

    git tag v1.1-bw

5.删除标签

    git tag -d v1.1-bw

6.从指定标签检出分支

    git checkout -b fea_xxx v2.0.0

## 储藏命令stash，在分支切换时不需要做commit操作

当在一个分支的开发工作未完成，却又要切换到另外一个hotfix分支进行开发的时候，当前的分支不commit的话git不允许checkout到别的分支，而代码功能不完整随便commit是没有意义的。

    （1）git stash push -m "save message"  : 执行存储时，添加备注，方便查找。只有 git stash 也可以，但查找时不方便识别。

    （2）git stash list  ：查看stash了哪些存储

    （3）git stash show ：显示哪些文件做了改动，默认show第一个存储，如果要显示其他存贮，后面加stash@{$num}，比如第二个 git stash show stash@{1}

    （4）git stash show -p : 显示改动明细，默认show第一个存储，如果想显示其他存存储，命令：git stash show  stash@{$num}  -p ，比如第二个：git stash show  stash@{1}  -p

    （5）git stash pop ：命令恢复之前缓存的工作目录，将缓存堆栈中的对应stash删除，并将对应修改应用到当前的工作目录下,默认为第一个stash,即stash@{0}，如果要应用并删除其他stash，命令：git stash pop stash@{$num} ，比如应用并删除第二个：git stash pop stash@{1}

    （6）git stash apply :应用某个存储,但不会把存储从存储列表中删除，默认使用第一个存储,即stash@{0}，如果要使用其他个，git stash apply stash@{$num} ， 比如第二个：git stash apply stash@{1}

    （7）git stash drop stash@{$num} ：丢弃stash@{$num}存储，从列表中删除这个存储

    （8）git stash clear ：删除所有缓存的stash

一般使用，git stash和 git stash pop这两条就够了。

注意:

    新增的文件，直接执行stash是不会被存储的，因为没有在git 版本控制中的文件，是不能被git stash 存起来的，所以先执行下git add 再储存就可以了。

### 高级用法：找回误删的git stash 数据

本想 git stash pop ，但是输入成 git stash drop

1.查找所有不可访问的对象

    git fsck --unreachable

2.逐个确认该对象的代码详情，找到自己丢失的那个

    git show a923f340ua

3.恢复找到的对象

    git stash apply 95ccbd927ad4cd413ee2a28014c81454f4ede82c

## cherry-pick 针对master分支上修改过的bug，要在dev分支上也做一遍修复

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

## 掉电导致objects目录下的某些文件为空

如果保存远程gitrepo的虚拟机经常关闭或者本地机器突然掉电，会导致.git/objects目录下的某些文件为空:

    git fsck --fule, 删空文件, head重新指向上一条不空的object

    <https://segmentfault.com/a/1190000008734662>
    <https://stackoverflow.com/questions/11706215/how-to-fix-git-error-object-file-is-empty>

  简单的应对，找个本地文件不含空文件的：

    1.远程报错的，从本地拷贝远程为空的文件过去，但是如果有多个来源提交到服务器文件的话可能会出现不一致的情况。

    2.远程报错的，本地直接git clone --bare 重新搞上去得了，但是会丢历史版本信息

    3.本地报错的，把.git删掉，重新init，但是会丢历史版本信息

## 合并两个分支

方法1. merge

    git checkout dev
    git merge dev_f1

方法2. rebase 起拉直效果

    # dev_f1分支在dev分支的基础上延伸拉直，这时两分支的head位置不一样
    git checkout dev_f1
    git rebase dev

一条命令搞定：git rebase < basebranch > < topicbranch >

    git rebase dev dev_f1

然后dev分支（落后了）做合并，两分支的head位置一样了。（因为dev分支的head位于分叉点，实质二者在一条线上，所以merge做的是快进合并）

    git checkout dev
    git merge dev_f1

### 注意

    已经推送到远端仓库的提交，如果别人都拉取开发了，你再做rebase并再次提交，内容会乱，双方都得再拉取整合。

    所以，仅在本地分支做 rebase ！

## git rebase -i 交互式合并commit

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

示例

    # 先做提交或储存，保证要修改的分支没有暂存内容才能继续

    # 查看当前分支的提交commit，以便选择范围
    git log --oneline

        112bd52 (HEAD, fea_stragy) 1
        588e326 策略设置窗口完成组合列表控件的菜单操作
        a5c7c9a 策略数据库使用pandas的read_pickle()以文件的方式处理
        1ae0123 新建组合跟编辑组合统一弹出窗体

    # 第一次用需要指定分支，因为我的fea_stragy没有远程分支
    #   git rebase ：There is no tracking information for the current branch.

    git rebase fea_stragy

    # 列出该点之后的所有commit，调用vi交互式进行编辑
    git rebase  -i 1ae0123

    # 编辑 112bd52 那行，把 pick 改成 s
    # 编辑完成 :wq 退出后新出现个提示窗口
    # 让修改commit的注释，可以修改合并的commit点的注释
    # 不改就直接 :q

    # 操作完看看提示，还有什么需要解决的会提示
    [detached HEAD 9cf8ad2] 策略设置窗口完成组合列表控件的菜单操作
    Date: Wed Sep 16 13:55:16 2020 +0800
    9 files changed, 1774 insertions(+), 1752 deletions(-)
    Successfully rebased and updated refs/heads/fea_stragy.

    git status

    # 再看当前commit，合并后出现了一个新的commit
    git log  --oneline

        622c01c (HEAD) 策略设置窗口完成组合列表控件的菜单操作
        a5c7c9a 策略数据库使用pandas的read_pickle()以文件的方式处理
        1ae0123 新建组合跟编辑组合统一弹出窗体

### 遇到问题了： 622c01c没关联到 fea_stragy 分支

    $ git switch master
    Warning: you are leaving 1 commit behind, not connected to
    any of your branches:

    622c01c 策略设置窗口完成组合列表控件的菜单操作

    If you want to keep it by creating a new branch, this may be a good time
    to do so with:

    git branch <new-branch-name> 622c01c

如果忘记了刚才做的操作的commit点，用 git reflog 查看自己的操作记录

    git reflog show HEAD@{now} -10

        112bd52 (HEAD -> fea_stragy) HEAD@{Wed Sep 16 15:36:19 2020 +0800}: checkout: moving from master to fea_stragy
        55d1836 (master) HEAD@{Wed Sep 16 15:35:04 2020 +0800}: checkout: moving from 622c01cf988f0af3872daa14da3b3e5d257c5772 to master
        622c01c HEAD@{Wed Sep 16 14:54:41 2020 +0800}: rebase (squash): 策略设置窗口完成组合列表控件的菜单操作
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
