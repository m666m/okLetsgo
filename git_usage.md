# 常用git操作及参考文档

## 参考文档

    git的几种工作流 <https://www.zhihu.com/question/20070065/answer/1174997617>

    最好的git命令教程 <https://learngitbranching.js.org/?locale=zh_CN>

    git官方文档  <https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E5%BC%80%E5%8F%91%E5%B7%A5%E4%BD%9C%E6%B5%81>

    【Git】远程仓库基础教程
    <https://blog.csdn.net/weixin_31866177/article/details/107945573>
    <https://blog.csdn.net/weixin_31866177/article/details/108043965>

    git使用教程 <https://zhuanlan.zhihu.com/p/158076293>
    git分支的使用过程 <https://zhuanlan.zhihu.com/p/22369088>
    图解 git rebase <https://zhuanlan.zhihu.com/p/198887332>

    离线Centos7环境使用Docker部署gitlab-CICD <https://zhuanlan.zhihu.com/p/147284555>

## git工作流：类似svn的集中式工作流 remote master -- local master(开发人员工作在此)

0、添加远程仓库

    git remote add origin 远程仓库地址

1、上班后，先确认本地无未提交未储存等等问题，处理后再继续

    git status

2、从远程仓库同步本地仓库

    git pull （默认远程origin本地master）

3、干活，自己的代码文件各种改动。

4、下班前，提交本地仓库

    git add .

    git commit -m "提交的信息"

5、开发告一段落时，提交远程仓库

    git push （默认远程origin本地master）

## git工作流：改良版集中式工作流 remote master -- local dev(开发人员工作在此)

在本地新建其它分支，这种工作方式可以确保主干master的相对稳定。

0、添加远程仓库，新建dev分支

    git remote add origin 远程仓库地址
    git branch 分支名

1、每日工作，先确认本地无未提交未储存等等问题，处理后再继续

    git status

2、从远程仓库master同步本地仓库master

    git pull （默认远程origin本地master）

3、切换本地dev分支

    git checkout 分支名

4、合并本地 master 到 本地dev分支

本地只是远程的一个镜像，以远程为准。
所以跨分支操作比如想合并远程master分支到远程dev分支，需要先pull远程master到本地master，再merge到本地dev，再push本地dev到远程master。
或在本地dev分支fetch远程master一个临时分支然后diff/merge到本地dev分支... <https://www.jianshu.com/p/bfb4b0de7e03>

    git merge master

5、每日本地dev分支的代码改动，提交本地仓库

    git add .
    git commit -m "提交的信息"

6、开发告一段落时，dev分支合并master再上传远程仓库

    git checkout master
    git pull
    git merge 分支名
    git push -u origin master

    或可直接 git push -u o/master dev ?

## git工作流： 功能分支工作流 master -- dev(开发人员工作在此)

master分支保持稳定，开发工作放在dev分支，这俩都做主干分支。 CI/CD中持续集成部署在dev，持续交付部署在master。

大家每日同步远程的dev分支即可工作：

    每人的本地dev各自开发一个功能点，每天只拉取，每隔几天完成一部分之后，上传到远程dev以便别人可以拉取，并进行测试。

这种工作流适合多人交互式工作的复杂项目，每天dev分支都在变动，大家做完一个阶段后，就同步到远程dev分支 。

下面是每人一个分支，仅master做主干的例子，对master的操作太多导致源代码状态不稳定：

    remote master上的内容merge 到自己的开发分支上 (上班第一件事)

    0、查看当前在git的哪个位置，是否有未提交未更新未暂存的，确保是干净的再继续

        git status

    1、切换到local master分支，并查看状态

        git checkout master
        git status

    2、将remote master同步到local master

        git pull origin master

    3、切换到的local开发分支，并查看状态

        git checkout dev_xxx
        git status

    4、合并 local master 到 local的开发分支

        git merge master

    5、将 local dev_xxx 推送更新到gitlab，使gitlab同步更新显示

        git push origin dev_xxx


    将自己分支的内容merge到remote master上 (下班最后一件事)

    0、查看当前在git的哪个位置，是否有未提交未更新未暂存的，确保是干净的再继续

        git status

    1、切换到 local 开发分支, 查看状态并提交到 local 开发分支

        git checkout dev_xxx

        git status

        git add .

        git commit -m "@@@"

    2、切换到local master，查看状态并拉取 remote master

        git checkout master
        git status

        git pull origin master

    3、将 local 开发分支merge到 local master

        git merge dev_xxx

    4、将 local master 推送更新到gitlab，使gitlab同步更新显示

        git push origin master

    5、将 local dev_xxx 推送更新到gitlab，使gitlab同步更新显示

        git checkout dev_xxx

        git push origin dev_xxx

    PS:

        每个git status后，根据实际情况进行处理，然后再做下一步。

        如果master分支需要保持稳定，每日步骤中对master分支的拉取合并都省略，只在关键tag点，把dev分支合并到master分支，平时的操作仅限dev分支。

## git工作流： Gitflow工作流 master -- develop -- feature(开发人员工作在此)

这个流程是功能分支工作流的进一步扩展，适合长期稳定的商用项目。

master分支很少变动，head始终对应生产环境代码。由master分支拉出来develop分支（打tag），每个开发组在develop分支基础上做自己的feature分支。

开发状态是，每人只负责合并自己的feature分支（打tag），功能组把自己的feature分支合并入develop分支（打tag），发布时由集成组把develop分支拉出release分支（打tag），测试除虫（打tag）阶段合并入develop分支，都完成后release分支合并入develop分支（打tag）和master分支（打tag），然后可以删除相关的feature分支和release分支。这个对CI/CD的定制化要求就比较高了。

hotfix需要合入master和develop两个分支。

原文 <https://nvie.com/posts/a-successful-git-branching-model/>

    汉化 <https://zhuanlan.zhihu.com/p/38772378> <https://zhuanlan.zhihu.com/p/36085631>

![Gitflow工作流](https://nvie.com/img/git-model@2x.png)

## git clone 获取指定指定分支的指定commit版本

git clone 默认是取回 master 分支，可以使用 -b 参数指定的分支。 -b 参数不仅支持分支名，还支持 tag 名等。

        git clone  <remote-addr:repo.git> -b <branch-or-tag-or-commit>

需求是获取commit id，没直接的办法。下面提供另一个步骤：

选择一个包含目标 commit id 的branch或tag，并指定depth=1以获得比较少的额外文件传输。

    git clone --depth 1 <remote-addr:repo.git> -b < branch-or-tag >

clone完成后，进入目录，执行

    git fetch --depth < a-numer >

不断增大步骤2的数字，直到找到你要的commit
