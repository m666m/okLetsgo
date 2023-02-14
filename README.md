# 常用内容收集整理，放在github上方便随时查阅

## 做技术的态度

所谓“工程师文化”，就是充分尊重工程的特点与规律，尊重工程师的创新性劳动和协同合作，
崇尚解决重大工程问题的科学性与严谨性，重视工程技术应用的集成、优化与权衡。--波音飞机公司

## 分析设计方向的选择

OOP的思维模式，是大一统的；C的思维模式，是分离的。前者方便但容易造成高耦合，后者灵活但开发开发太累。用 C开发，应该刻意强调 “简单” 和 “可拆分”。一个个象搭积木一样的把基础系统搭建出来，哪个模块出问题，局部替换即可。

纯 C代码所带来的 “美感” ，即简单性和可拆分性。代码是自底向上构造，一个模块只做好一个模块的事情，任意拆分组合。对于有参考的 OOP系统建模，自顶向下的构造代码抽象方法是有效率的，是方便的，对于新领域，没有任何参考时，刻意抽象会带来额外负担，并进一步增加系统耦合性，设计调整，往往需要大面积修改代码。

而大一统设计，你一开始用 UML画出整套系统的类结构，然后再开工设计。这种思维习惯，如果是参考已有系统做一个类似的设计，问题不大，全新设计的话，他总有一个前提，就是 “你能完整认识整个大自然”，就像人类一开始就要认识捕猎和筑巢还有取火一样。否则每次对世界有了新认识，OOP的自顶向下设计方法都能给你带来巨大的负担。

所以有些人才会说：OOP设计习惯会依赖一系列设计灵巧的 BaseObject，然而过段时间后再来看你的项目，当其中某个基础抽象类出现问题是，往往面临大范围的代码调整。这其实就是他们使用自顶向下思维方法，在逐步进入新世界时候，所带来的困惑。

当然也有人批判这种强调简单性和可拆分性的 Unix思维。认为世界不是总能保持简单和可拆分的，他们之间是有各种千丝万缕联系的，你一味的保持简单性和可拆分性，你会让别人很累。

这里给你个药方，底层系统，基础组建，尽量用 C的方法，很好的设计成模块，随着你编程的积累，这些模块象积木一样越来越多，而彼此都无太大关系，甚至不少 .c文件都能独立运行，并没有一个一统天下的 common.h让大家去 include，接口其他语言也方便。
然后在你做到具体应用时根据不同的需求，用C++或者其他语言，将他们象胶水一样粘合起来。这时候，再把你的 common.h，写到你的 C++或者其他语言里面去。当然，作为胶水的语言不一定非要是 C++了，也可以是其他语言。

作者：韦易笑
链接：<https://www.zhihu.com/question/30567850/answer/48645759>
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

## 怎样用通俗的语言解释REST，以及RESTful

    看Url就知道要什么
    看http method就知道干什么
    看http status code就知道结果如何

## 公司c位程序员不愿使用git,怎么办

程墨Morgan 给题主一些建议：

    不光要只说svn的问题，要说git能够解决svn的问题
    要看git在解决svn的问题的同时，有没有增加新的问题
    不要只看技术问题，也要看历史问题和人工问题
    要了解到底是c位程序员为什么不愿意使用git
    要了解还有什么力量支持不使用git，支持的人担心什么问题
    会有多少人支持解决svn的问题
    如果你只知道提出问题却提不出解法，你自己就已经成为了问题

## 别人的速查手册

python

    <https://gto76.github.io/python-cheatsheet/>
        <https://github.com/gto76/python-cheatsheet>

<https://www.technologyreview.com/>
<https://www.forbes.com/science/?sh=1b6787035738>
