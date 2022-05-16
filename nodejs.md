# 服务器端的java应用

java发展到现在，因为版权命名问题，逐步过渡到 ECMA、 ECMAScript的叫法，标准化工作慢慢的剥离某商业公司，由业界共同指定，新的 java script 标准称呼是 ECMAScript 了。

java对面向对象编程最大的贡献就是完美且方便的实现“接口”这个抽象概念的落地，继80年代的 C++ Corba 对象共享之后，java开发者可以自由的配置包来对接口编程，很简单就可以实现逻辑分离：抽象和实体的分离，接口与实现的分离，数据与呈现的分离，逻辑与控制的分离等等。

java在客户端（前端）的使用，主要是浏览器展现网页的java script。在实现浏览器与用户交互的过程中，引入了一个重要的 XMLHttpRequest 对象，来实现异步的与服务器（后端）交换数据。

随着前端JavaScript开发的盛行，很多套路化的操作，被封装出了各种框架，其中 jQuery 框架可以大大简化 java script 的开发，AJAX 框架在浏览器端异步数据与呈现的分离，其封装的异步控制接口简单易用。前端的其它流行框架还有如 vue、bootstrap 等。

Node.js 利用了可以在浏览器之外运行的 V8 JavaScript 引擎（Google Chrome 的内核），封装为组件的方式，利用异步IO处理的便利，跨界到服务器端实现功能的组件化开发。

由此衍生出的 npm 仓库开源包可以实现常见的所有开发功能，生态系统越来越完善。

随着npm相关开发在服务器端盛行，本来是作为客户端设计用的java script，随着各种框架的发展，在服务器端开发也非常方便了，跟早期的java语言开发LAMP相比，门槛越来越低，开枝散叶发展很快。

对语言运行的引擎来说，如果说 java 在服务器端的运行速度和标准依赖 jdk 的发展，那么 java script 在服务器端运行的速度和标准依赖 google V8 的发展，在手机端特殊一些，安卓设备本地运行使用 java，客户端框架用 HTML 5 实现数据、处理、呈现的逻辑分离。

## 从框架到架构

在java语言中，灵魂是接口分离，所以在语言基础上的接口框架封装，大量的实践了“模型-视图-控制器”MVC设计模式

    MVC 设计架构 https://docs.microsoft.com/zh-cn/aspnet/core/mvc/overview?view=aspnetcore-2.2#mvc-pattern

    领域驱动设计 https://www.yuque.com/liberty/rf322x

对项目开发来说，不同的CI流程，用各级子目录目录来对应不同的功能

    一个基于 DDD 领域驱动设计的项目目录结构

    app
    ├── common
    │   └── adapter     # 外部服务调用
    ├── core
    │   ├── entity      # 核心模型，实现业务行为
    │   ├── event       # 异步事件定义，以及消费，串联业务
    │   ├── service     # 核心业务逻辑
    │   └── util
    ├── repository
    │   └── model      # ORM 模型，数据定义
    ├── port
    │   └── controller # HTTP Controller
    ├── schedule       # 定时任务
    └── test           # 单测

    目录结构强约束的基于koa的框架Egg https://cnodejs.org/topic/580a6a7e541dfb7b50f40a60

### 一个项目的开发框架搭建

    作者：知乎用户
    链接：https://www.zhihu.com/question/50526101/answer/144976947
    来源：知乎
    著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

    用koa2也干过类似的东西：目录结构也是约定好routers, apis, services, middlewares等，也集成了http://socket.io的“路由”，所有service挂在在ctx上，然后ctx.$serviceName可以调用service，就一个json用于配置路由和中间件，使用者初始化完可以直接开始写逻辑，然后配置一下路由就行了搞定，有几个默认中间件比如parser，jwt等，parser也是像egg里面那样exports = require('koa-parser')的 2333，jwt的话自己用jsonwebtoken简单的写了一下，因为koa-jwt的2.x版本貌似有问题永不了...，也可以自行添加中间件module.exports = async midw(ctx, next) => {...}，“框架”会通过名字去自动加载内置一些的全局函数和对象：比如生成uuid的UUID()；NOW()获取当前时间戳；DB用来调用数据库，DB上又挂载了集合对象，不管在哪儿都可以DB.User.find()；自定义异常AppError；配置CONF；requireDir用于require多层目录异常之类的按照koa文档的try{ await next(); }catch(e){ ctx.body = {xxx} }在catch语句中自己写个统一的返回格式，自己封装一个异常类就统一搞定，返回值也是弄了个ctx.OK(data)统一返回格式模板渲染和日志单元测试就没做，因为前后端分离，后端基本只返回json和小公司野蛮开发习惯。不过基本都有成熟的第三方库，整合进去作为“框架”的一部分也不算麻烦，最后还然后加了eslint来规范编码不过我就没有重写koa(水平太菜)，只是把koa和一些常用中间件预装好，把项目结构和“框架”的基础设施放进去，在入口文件做一些初始化工作，目录建好放在公司内网的git上让人克隆着用，内容大概就上面那些，功能相对egg来说还是少很多的，称不上什么“框架”

## jQuery

## Node.js

    https://nodejs.org/
        https://cnodejs.org/

    https://www.zhihu.com/column/eggjs
