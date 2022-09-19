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

对 tomcat 来说，web 容器化部署就是把 将war包放置到webapps目录下，从而实现网页的自动发布。

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

## web server：Apache服务器和tomcat服务器区别

    https://zhuanlan.zhihu.com/p/116605973

Apache是Web服务器，而Tomcat是Java应用服务器，Tomcat是Java开发的一个符合JavaEE的Servlet规范的JSP服务器（Servlet容器），是 Apache 的扩展。Apache服务器只处理静态 HTML；tomcat服务器对静态 HTML、动态 JSP、Servlet 都能处理。

一般是把 Apache服务器与tomcat服务器 搭配在一起用。Apache服务器负责处理所有静态的页面/图片等信息，Tomcat只处理动态的部分。Tomcat本身也内置了一个HTTP服务器用于支持静态内容，可以通过Tomcat的配置管理工具实现与Apache整合。两者整合后优点：如果请求是静态网页则由Apache处理，并将结果返回；如果是动态请求，Apache会将解析工作转发给Tomcat处理，Tomcat处理后将结果通过Apache返回。这样可以达到分工合作，实现负载远衡，提高系统的性能。

### tomcat

    http://www.tomcat.org.cn/category/install/apache

    https://tomcat.apache.org/tomcat-8.5-doc/index.html

Tomcat的缺省端口是多少，怎么修改?

找到Tomcat目录下的conf文件夹
进入conf文件夹里面找到server.xml文件
打开server.xml文件
在server.xml文件里面找到下列信息
把Connector标签的8080端口改成你想要的端口

    <Service name="Catalina">
    <Connector port="8080" protocol="HTTP/1.1"
                connectionTimeout="20000"
                redirectPort="8443" />

Tomcat Connector的三种运行模式

Connector最底层使用的是Socket来进行连接的，Request和Response是按照HTTP协议来封装的，所以Connector同时需要实现TCP/IP协议和HTTP协议.

BIO：同步并阻塞 一个线程处理一个请求。缺点：并发量高时，线程数较多，浪费资源。Tomcat7或以下，在Linux系统中默认使用这种方式。 ​ 配制项：protocol=”HTTP/1.1”

NIO：同步非阻塞IO

利用Java的异步IO处理，可以通过少量的线程处理大量的请求，可以复用同一个线程处理多个connection(多路复用)。Tomcat8在Linux系统中默认使用这种方式。

Tomcat7必须修改Connector配置来启动。

    配制项：protocol=”org.apache.coyote.http11.Http11NioProtocol”

备注：我们常用的Jetty，Mina，ZooKeeper等都是基于java nio实现.

APR：即Apache Portable Runtime，从操作系统层面解决io阻塞问题。

AIO:异步非阻塞IO(Java NIO2又叫AIO)

主要与NIO的区别主要是操作系统的底层区别.可以做个比喻:比作快递，NIO就是网购后要自己到官网查下快递是否已经到了(可能是多次)，然后自己去取快递；AIO就是快递员送货上门了(不用关注快递进度)。

    配制项：protocol=”org.apache.coyote.http11.Http11AprProtocol”

备注：需在本地服务器安装APR库。Tomcat7或Tomcat8在Win7或以上的系统中启动默认使用这种方式。Linux如果安装了apr和native，Tomcat直接启动就支持apr。

在Tomcat中部署Web应用的方式主要有如下几种：

利用Tomcat的自动部署

    把web应用拷贝到webapps目录。Tomcat在启动时会加载目录下的应用，并将编译后的结果放入work目录下。

使用Manager App控制台部署

    在tomcat主页点击“Manager App” 进入应用管理控制台，可以指定一个web应用的路径或war文件。

修改conf/server.xml文件部署

    修改conf/server.xml文件，增加Context节点可以部署应用。

增加自定义的Web部署文件

    在conf/Catalina/localhost/ 路径下增加 xyz.xml文件，内容是Context节点，可以部署应用。

tomcat容器是如何创建servlet类实例？用到了什么原理？

当容器启动时，会读取在webapps目录下所有的web应用中的web.xml文件，然后对 xml文件进行解析，并读取servlet注册信息。

然后，将每个应用中注册的servlet类都进行加载，并通过 反射的方式实例化。（有时候也是在第一次请求时实例化） 在servlet注册时加上1如果为正数，则在一开始就实例化，如果不写或为负数，则第一次请求实例化。

Tomcat作为servlet容器，有三种工作模式：

1、独立的servlet容器，servlet容器是web服务器的一部分；

2、进程内的servlet容器，servlet容器是作为web服务器的插件和java容器的实现，web服务器插件在内部地址空间打开一个jvm使得java容器在内部得以运行。反应速度快但伸缩性不足；

3、进程外的servlet容器，servlet容器运行于web服务器之外的地址空间，并作为web服务器的插件和java容器实现的结合。反应时间不如进程内但伸缩性和稳定性比进程内优；

进入Tomcat的请求可以根据Tomcat的工作模式分为如下两类：

    Tomcat作为应用程序服务器：请求来自于前端的web服务器，这可能是Apache, IIS, Nginx等；

    Tomcat作为独立服务器：请求来自于web浏览器；

Tomcat顶层架构

Tomcat中最顶层的容器是Server，代表着整个服务器，从上图中可以看出，一个Server可以包含至少一个Service，即可以包含多个Service，用于具体提供服务。

Service主要包含两个部分：Connector和Container。

Tomcat 的心脏就是这两个组件，他们的作用如下：

    Connector用于处理连接相关的事情，并提供Socket与Request请求和Response响应相关的转化;

    Container用于封装和管理Servlet，以及具体处理Request请求；

一个Tomcat中只有一个Server，一个Server可以包含多个Service，一个Service只有一个Container，但是可以有多个Connectors，这是因为一个服务可以有多个连接，如同时提供Http和Https链接，也可以提供向相同协议不同端口的连接。整个 Tomcat 的生命周期由 Server 控制。上述的包含关系或者说是父子关系，都可以在tomcat的conf目录下的server.xml配置文件中看出。Tomcat 配置文件详解 <https://www.cnblogs.com/54chensongxia/p/13255055.html>

Container用于封装和管理Servlet，以及具体处理Request请求，在Container内部包含了4个子容器作用分别是：

    Engine：引擎，用来管理多个站点，一个Service最多只能有一个Engine；

    Host：代表一个站点，也可以叫虚拟主机，通过配置Host就可以添加站点；

    Context：代表一个应用程序，对应着平时开发的一套程序，或者一个WEB-INF目录以及下面的web.xml文件；

    Wrapper：每一Wrapper封装着一个Servlet；

### 常见的Spring MVC的执行流程，一个URL的完整调用链路
