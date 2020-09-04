# 常用git操作及参考文档

## 参考文档

    git官方文档  <https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E5%BC%80%E5%8F%91%E5%B7%A5%E4%BD%9C%E6%B5%81>

    git分支的使用过程 <https://zhuanlan.zhihu.com/p/22369088>
    图解 git rebase <https://zhuanlan.zhihu.com/p/198887332>

    【Git】远程仓库基础教程
    <https://blog.csdn.net/weixin_31866177/article/details/107945573>
    <https://blog.csdn.net/weixin_31866177/article/details/108043965>

## git中用分支进行工作的一般步骤

新建其它分支，将项目push到新建的分支上，后期再进行merge

(1)新建分支

    git branch 分支名

(2)切换分支

    git checkout 分支名

(3)进行项目上传

    git add .

    git commit -m "提交的信息"

    git remote add origin 远程仓库地址

    git push -u origin 分支名

## 常见git工作日程： 两级分支管理体系 master -- dev(开发人员工作在此)

### remote master上的内容merge 到自己的开发分支上 (上班第一件事)

0.查看当前在git的哪个位置，是否有未提交未更新未暂存的，确保是干净的再继续

    git status

1.切换到local master分支，并查看状态

    git checkout master
    git status

2.将remote master同步到local master

    git pull origin master

3.切换到的local开发分支，并查看状态

    git checkout dev_xxx
    git status

4.合并 local master 到 local的开发分支

    git merge master

5.推送更新到gitlab，使gitlab同步更新显示

    git push origin dev_xxx

### 将自己分支的内容merge到remote master上 (下班最后一件事)

0.查看当前在git的哪个位置，是否有未提交未更新未暂存的，确保是干净的再继续

    git status

1.切换到 local 开发分支, 查看状态并提交到 local 开发分支

    git checkout dev_xxx

    git status

    git add .

    git commit -m "@@@"

2.切换到local master，查看状态并拉取 remote master

    git checkout master
    git status

    git pull origin master

3.将 local 开发分支merge到 local master

     git merge dev_xxx

4.将 local master 推送更新到gitlab，使gitlab同步更新显示

    git push origin master

5.将 local dev_xxx  推送更新到gitlab，使gitlab同步更新显示

    git checkout dev_xxx

    git push origin dev_xxx

PS:

    每个git status后，根据实际情况进行处理，然后再做下一步。

## 三级分支管理体系 master -- develop -- feature(开发人员工作在此)

这个流程适合长期稳定的商用项目。

master分支很少变动，head始终对应生产环境代码。由master分支拉出来develop分支（打tag），每个人在develop分支基础上做自己的feature分支，发布时由develop分支拉出release分支（打tag），大家把自己的feature分支合并入release分支（打tag），测试发布（打tag）都完成后release分支合并入develop分支（打tag）和master分支（打tag），然后可以删除相关的feature分支和release分支。
<https://zhuanlan.zhihu.com/p/36085631>

## git clone 获取指定指定分支的指定commit版本

git clone 默认是取回 master 分支，可以使用 -b 参数指定的分支。 -b 参数不仅支持分支名，还支持 tag 名等。

        git clone  <remote-addr:repo.git> -b <branch-or-tag-or-commit>

需求是获取commit id，没直接的办法。下面提供另一个步骤：

选择一个包含目标 commit id 的branch或tag，并指定depth=1以获得比较少的额外文件传输。

    git clone --depth 1 <remote-addr:repo.git> -b < branch-or-tag >

clone完成后，进入目录，执行

    git fetch --depth < a-numer >

不断增大步骤2的数字，直到找到你要的commit
