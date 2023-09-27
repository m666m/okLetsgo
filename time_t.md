# 时间计算速查——从 c 到 python 到 pandas

- [时间计算速查——从 c 到 python 到 pandas](#时间计算速查从-c-到-python-到-pandas)
  - [定义术语 epoch](#定义术语-epoch)
  - [timestamp 类型](#timestamp-类型)
  - [时区标准tzinfo](#时区标准tzinfo)
  - [C标准库 \<time.h\>](#c标准库-timeh)
    - [在标准C/C++中，最小的计时单位是一毫秒](#在标准cc中最小的计时单位是一毫秒)
    - [tm struct  及相关操作函数](#tm-struct--及相关操作函数)
      - [mktime()   struct tm → time\_t](#mktime---struct-tm--time_t)
      - [~~asctime()~~](#asctime)
    - [time\_t typedef 及相关操作函数](#time_t-typedef-及相关操作函数)
      - [time()     time\_t → time\_t](#time-----time_t--time_t)
      - [strftime()     struct tm → 字符串日期时间](#strftime-----struct-tm--字符串日期时间)
      - [gmtime()       time\_t → struct tm UTC](#gmtime-------time_t--struct-tm-utc)
      - [localtime()    time\_t → struct tm](#localtime----time_t--struct-tm)
      - [tzset()](#tzset)
      - [difftime()  time\_t, time\_t → int](#difftime--time_t-time_t--int)
      - [~~ctime()~~](#ctime)
  - [Python标准库](#python标准库)
    - [Timestamp 类型](#timestamp-类型-1)
    - [库time https://docs.python.org/zh-cn/3/library/time.html](#库time-httpsdocspythonorgzh-cn3librarytimehtml)
      - [内置数据类型](#内置数据类型)
        - [timestamp     对应 c 标准库的 time\_t](#timestamp-----对应-c-标准库的-time_t)
        - [struct\_time   对应 c 标准库的struct tm](#struct_time---对应-c-标准库的struct-tm)
      - [格式字符串 strftime() 方法速查](#格式字符串-strftime-方法速查)
      - [内置函数，不需要实例化对象直接用](#内置函数不需要实例化对象直接用)
        - [time.tzname 当前时区名](#timetzname-当前时区名)
        - [time.time()       → timestamp](#timetime--------timestamp)
        - [time.strftime()   struct\_time → 字符串日期时间](#timestrftime---struct_time--字符串日期时间)
        - [打印当前时区名称](#打印当前时区名称)
        - [time.strptime()   字符串日期时间 → struct\_time](#timestrptime---字符串日期时间--struct_time)
        - [time.mktime()     struct\_time → timestamp](#timemktime-----struct_time--timestamp)
        - [time.gmtime()     timestamp → struct\_time](#timegmtime-----timestamp--struct_time)
        - [time.localtime()  timestamp → struct\_time](#timelocaltime--timestamp--struct_time)
        - [time.sleep()](#timesleep)
        - [~~time.asctime()~~](#timeasctime)
        - [~~time.ctime()~~](#timectime)
      - [获取当前时区的偏移](#获取当前时区的偏移)
    - [库datetime https://docs.python.org/zh-cn/3/library/datetime.html](#库datetime-httpsdocspythonorgzh-cn3librarydatetimehtml)
      - [class datetime.time 时间对象](#class-datetimetime-时间对象)
      - [class datetime.date 日期对象](#class-datetimedate-日期对象)
        - [strftime()    date → 字符串日期时间](#strftime----date--字符串日期时间)
        - [timetuple()   date → struct\_time](#timetuple---date--struct_time)
      - [库datetime的日期时间对象datetime](#库datetime的日期时间对象datetime)
        - [now()     → datetime](#now------datetime)
        - [fromtimestamp()   timestamp → datetime](#fromtimestamp---timestamp--datetime)
        - [combine()   date + time → datetime](#combine---date--time--datetime)
        - [fromisoformat()     iso标准的日期时间字符串 → datetime](#fromisoformat-----iso标准的日期时间字符串--datetime)
        - [strptime()  字符串日期时间 → datetime](#strptime--字符串日期时间--datetime)
        - [strftime()    datetime → 字符串日期时间](#strftime----datetime--字符串日期时间)
        - [timestamp()     datetime → timestamp](#timestamp-----datetime--timestamp)
        - [timetuple()     datetime → struct\_time](#timetuple-----datetime--struct_time)
        - [date()    datetime → date](#date----datetime--date)
        - [time()    datetime → time](#time----datetime--time)
        - [timetz()  datetime → time有tzinfo](#timetz--datetime--time有tzinfo)
        - [isoformat()   datetime → iso标准的日期时间字符串](#isoformat---datetime--iso标准的日期时间字符串)
        - [tzname(dt) datetime -\> 字符串时区名](#tznamedt-datetime---字符串时区名)
        - [class datetime.timedelta 日期时间运算对象](#class-datetimetimedelta-日期时间运算对象)
        - [class datetime.tzinfo 对象](#class-datetimetzinfo-对象)
        - [class datetime.timezone 对象](#class-datetimetimezone-对象)
    - [库 calendar](#库-calendar)
      - [calendar.timegm(tuple)     struct\_time → timestamp](#calendartimegmtuple-----struct_time--timestamp)
      - [calendar.isleap(year)      → bool](#calendarisleapyear-------bool)
      - [calendar.weekday(year, month, day)     → int](#calendarweekdayyear-month-day------int)
      - [calendar.setfirstweekday(weekday)](#calendarsetfirstweekdayweekday)
      - [calendar.firstweekday()](#calendarfirstweekday)
    - [库 dateutil 包](#库-dateutil-包)
  - [Numpy的日期时间](#numpy的日期时间)
    - [numpy.datetime64 相关转换函数](#numpydatetime64-相关转换函数)
      - [数组初始化时指定dtype类型  字符串日期时间 → datetime64](#数组初始化时指定dtype类型--字符串日期时间--datetime64)
      - [np.datetime64()  字符串日期时间 → datetime64](#npdatetime64--字符串日期时间--datetime64)
      - [np.datetime64()  datetime → datetime64](#npdatetime64--datetime--datetime64)
      - [astype()   datetime64 → datetime](#astype---datetime64--datetime)
      - [np.datetime\_as\_string()  datetime64 → 字符串日期时间](#npdatetime_as_string--datetime64--字符串日期时间)
      - [上例基础上，指定时间的起止范围     字符串日期时间 → datetime64](#上例基础上指定时间的起止范围-----字符串日期时间--datetime64)
      - [datetime64 -\> datetime.datetime](#datetime64---datetimedatetime)
      - [split() 字符串创建datetime64数组](#split-字符串创建datetime64数组)
    - [numpy.timedelta64 时间运算对象](#numpytimedelta64-时间运算对象)
      - [两个日期的差值转换精度为天，用它除以一天的时间增量即可](#两个日期的差值转换精度为天用它除以一天的时间增量即可)
      - [datetime64 → datetime.datetime time\_t timestamp](#datetime64--datetimedatetime-time_t-timestamp)
  - [Pandas的日期时间](#pandas的日期时间)
    - [索引很重要](#索引很重要)
    - [日期时间对应的对象和操作函数](#日期时间对应的对象和操作函数)
      - [pd.date\_range()    → DatetimeIndex](#pddate_range-----datetimeindex)
      - [pd.to\_datetime() 这里搞了个3义性 !   → datetime DatetimeIndex Timestamp](#pdto_datetime-这里搞了个3义性-----datetime-datetimeindex-timestamp)
      - [Unix时间戳 -\> Timestamp np.datetime64](#unix时间戳---timestamp-npdatetime64)
      - [用Series.dt操作DataFrame的一列Timestamp类型数据，最常用的日期时间操作都通过它进行](#用seriesdt操作dataframe的一列timestamp类型数据最常用的日期时间操作都通过它进行)
        - [.dt 取指定日期等](#dt-取指定日期等)
        - [.dt 时区转换](#dt-时区转换)
        - [.dt 转换为字符串日期时间](#dt-转换为字符串日期时间)
    - [Timestamp()，对标 python datetime.datetime](#timestamp对标-python-datetimedatetime)
      - [timetuple() pd.Timestamp -\> struct\_time](#timetuple-pdtimestamp---struct_time)
    - [Period 对应一段时间](#period-对应一段时间)
      - [pd.period\_range()  → PeriodIndex](#pdperiod_range---periodindex)
    - [Interval 对应一段间隔](#interval-对应一段间隔)
      - [pd.interval\_range()  → IntervalIndex](#pdinterval_range---intervalindex)
    - [DateOffset 日期的加减一段范围，有各种方法](#dateoffset-日期的加减一段范围有各种方法)
    - [timedeltas，对标python标准库的 datetime.timedelta](#timedeltas对标python标准库的-datetimetimedelta)
      - [pd.Timedelta()  → timedelta](#pdtimedelta---timedelta)
      - [pd.to\_timedelta()  → Timedelta TimedeltaIndex](#pdto_timedelta---timedelta-timedeltaindex)
      - [pd.timedelta\_range()  → TimedeltaIndex](#pdtimedelta_range---timedeltaindex)
      - [访问属性 days, seconds, microseconds, nanoseconds](#访问属性-days-seconds-microseconds-nanoseconds)
      - [timedelta运算 datetime64 datetime →](#timedelta运算-datetime64-datetime-)
      - [改周期](#改周期)
      - [索引使用 DatetimeIndex PeriodIndex TimedeltaIndex](#索引使用-datetimeindex-periodindex-timedeltaindex)
    - [pd.to\_datetime() 三义性的详细说明](#pdto_datetime-三义性的详细说明)
      - [1.用 Series.dt.tz\_convert(None) 转换为 UTC 并删除时区信息](#1用-seriesdttz_convertnone-转换为-utc-并删除时区信息)
      - [2.用Series的dt对象的tz\_localize('Europe/Moscow')方法，转换时区](#2用series的dt对象的tz_localizeeuropemoscow方法转换时区)
      - [把人搞糊涂的原因](#把人搞糊涂的原因)
      - [yfinance源代码分析](#yfinance源代码分析)
    - [pandas 时区转换](#pandas-时区转换)
    - [最好封装时区设置函数](#最好封装时区设置函数)

## 定义术语 epoch

epoch：时间点。 时间计算，按unix系统在70年代定义，操作系统储存的是自1970年1月1日0点（UTC）开始的秒数。

UTC: 世界标准时间，也称格林威治标准时间(GMT)，作为零时区。其它时区相对零时区加减相应的小时，然后再叠加自己的夏令时，得当地时间。英国在夏季采用夏令制，时间拨快一小时，为UTC+1。我国在东八区，不使用夏令时，故一直是UTC+8。

Calendar Time：日历时间，“从一个标准时间点到此时的时间经过的秒数”来表示的时间，一般都是用 epoch 时间点，由编译系统自行决定。

## timestamp 类型

    文档中没有专门描述，注意这个 timestamp 类型就是c标准库中的time_t的一个秒数，一般是从 epoch 开始的秒数。

    对于时间的运算本质上都被转成 timestamp 类型了，注意函数返回值类型！

## 时区标准tzinfo

    时区名称 https://timezonedb.com/time-zones

    世界地图时区分布
        https://www.timeanddate.com/time/map/
        https://greenwichmeantime.com/time-zone/

    Time Zone Database
    https://www.iana.org/time-zones
        http://ftp.iana.org/tz/releases/

## C标准库 <time.h>

在标准c库中使用结构 time_t 和 tm，及操作这2个结构的几个函数，提供到字符串之间的转换（cpu时间的略）。

NOTE: 各种静态对象满天飞，各函数有隐含的依赖。多线程一定要躲着这块。

NOTE: time.h里各操作函数的入参和返回值类型，有的修改入参值，有的是返回值类型改变，用法没规律，死记。

参考

    C标准库头文件 <https://zh.cppreference.com/w/c/header>

    日期和时间工具 <https://en.cppreference.com/w/c/chrono>

    time.h <https://www.tutorialspoint.com/c_standard_library/time_h.htm>

    你看不到我 <https://en.wikipedia.org/wiki/Unix_time>

### 在标准C/C++中，最小的计时单位是一毫秒

clock tick：时钟周期，是C/C++的一个基本计时单位，区别于cpu的计时周期。这是函数clock_t clock( void )使用的单位，时长转换倚赖一个常量。

    在time.h文件中，常量CLOCKS_PER_SEC，它用来表示一秒钟会有多少个时钟计时单元：
    #define CLOCKS_PER_SEC ((clock_t)1000)
    说明每过千分之一秒（1毫秒），调用clock（）函数返回的值就加1

    printf("Elapsed time:%u secs.\n",clock()/CLOCKS_PER_SEC);

### tm struct  及相关操作函数

注意是系统静态对象，在 gmtime() 、 localtime() 及 ctime() 间共享

保有拆分成其组分的日历日期和时间的结构体。<https://zh.cppreference.com/w/c/chrono/tm>

成员对象：

    int tm_sec      分后之秒 – [0, 61] (C99 前)[0, 60] (C99 起)
    int tm_min      时后之分 – [0, 59]
    int tm_hour     自午夜起的小时 – [0, 23]
    int tm_mday     月之日 – [1, 31]
    int tm_mon      自 1 月起的月 – [0, 11]
    int tm_year     自 1900 年起的年
    int tm_wday     自星期日起的星期 – [0, 6]
    int tm_yday     从 1 月 1 日起的日 – [0, 365]
    int tm_isdst    夏时令标签。若夏时令有效则此值为正，若无效则为零，若无可用信息则为负。

操作函数，注意返回值类型。

#### mktime()   struct tm → time_t

提供从 tm 到 time_t 的转换，用的是本地时间进行的计算，不是 UTC!

NOTE: 手动设置 tm 要注意，你的输入会被认为是本地时间进行处理，不是 UTC。

<https://zh.cppreference.com/w/c/chrono/mktime>

入参 struct tm
返回 time_t

一般指定时间的操作都是从tm结构或者字符串来的，转成time_t后再供其它时间计算函数调用。

``` c
time_t t1, t3;
struct tm *t2;

t1 = time(NULL);
t2 = localtime(&t1);
t2 -> tm_mday += 40;
t2 -> tm_hour += 16;
t3 = mktime(t2);
```

如果想设置标准的 UTC 1970-01-01 00:00:00 咋办呢？

    time_t mkgmtime(struct tm* utc0date)

    实际上这个函数在linux上是有的，windows上是用了_mkgmtime()来代替

#### ~~asctime()~~

转换结构 tm 为以下固定的 25 字符表示形式： Www Mmm dd hh:mm:ss yyyy\n

入参 struct tm
返回 字符串

将 struct tm 对象转换成文本表示，格式固定不够灵活。
POSIX 标记此函数为过时并推荐用 strftime() 代替。

示例代码

``` c
#include <stdio.h>
#include <time.h>
#include <locale.h>

char buff[70];
struct tm my_time = { .tm_year=2012-1900, // = 2012年
                        .tm_mon=9,    // = 10月
                        .tm_mday=9,   // = 9日
                        .tm_hour=8,   // = 8时
                        .tm_min=10,   // = 10分
                        .tm_sec=20    // = 20秒
};

if (strftime(buff, sizeof buff, "%A %c", &my_time)) {
    puts(buff);
} else {
    puts("strftime failed");
}

setlocale(LC_TIME, "el_GR.utf8");

if (strftime(buff, sizeof buff, "%Y-%m-%d %H:%M:%S", &my_time)) {
    puts(buff);
} else {
    puts("strftime failed");
}
```

### time_t typedef 及相关操作函数

在 POSIX 系统上，time_t 以秒计量，自1970年1月1日0点（UTC）开始的秒数 <https://zh.cppreference.com/w/c/chrono/time_t>

#### time()     time_t → time_t

    取当前时间

    <https://zh.cppreference.com/w/c/chrono/time>

    入参 time_t
    返回纪元1970年1月1日0点（UTC）开始经过的当前系统日历时间。如果提供了入参，函数修改这个time_t的值。

    下面的那些显示为字符串函数依赖这个值进行显示，
    所以取系统时间并打印的过程，就是先time()一个time_t，然后调用各种字符串输出函数

#### strftime()     struct tm → 字符串日期时间

    按照格式字符串 format ，转换来自给定的日历时间 time 的日期和时间信息

    <https://zh.cppreference.com/w/c/chrono/strftime>

    入参 struct tm
    输出 字符串日期时间

    这个字符串转换函数是推荐使用的，代替 ctime() 和 asctime()
    format格式参见 <https://zh.cppreference.com/w/c/chrono/strftime>

#### gmtime()       time_t → struct tm UTC

    将从纪元开始的时间转换成以协调世界时（UTC）表示的日历时间。

    入参 time_t
    返回 struct tm

    提供从 time_t 到 struct tm 的转换

#### localtime()    time_t → struct tm

    将从纪元开始的时间转换成以本地时间表示的日历时间。

    入参 time_t
    返回 struct tm。

    提供从 time_t 到 struct tm 的转换

#### tzset()

    设置时区，读取环境变量 TZ，时间相关的几个函数都调用它。

    <https://pubs.opengroup.org/onlinepubs/9699919799/functions/tzset.html>

    操作了外部变量 tzname tzname[0] = "std"; tzname[1] = "dst";
                    daylight 夏令时偏离秒数
                    timezone 相对零时区偏离秒数

    设置环境变量参见 <https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html#tag_08>

#### difftime()  time_t, time_t → int

    以秒数计算二个作为 time_t 对象的日历时间的差（ time_end - time_beg ）。若 time_end 代表先于 time_beg 的时间点，则结果为负。

    入参 time_t
    返回 差值秒数

    计算两个日期之间的差值，只能用秒数

#### ~~ctime()~~

转换从纪元起的给定时间为历法本地时间，再转换为固定格式文本表示，如同通过调用 asctime(localtime(ltime))

字符串拥有下列格式： Www Mmm dd hh:mm:ss yyyy\n

入参 time_t
返回 字符串

POSIX 标记此函数为过时并推荐 strftime() 代替。

示例代码

``` c

#include <time.h>
#include <stdint.h>
#include <stdio.h>

time_t ltime = time(NULL);

time( &ltime );

printf("%jd seconds since the epoch (UTC 1/1/70) began\n", (intmax_t)ltime);

printf("UTC:   %s", asctime(localtime(&ltime)));
printf("local: %s", asctime(gmtime(&ltime)));
printf("ctime local: %s", ctime(&ltime));

```

## Python标准库

库 datetime 和 库 time 处理日期时间的运算，对应的数据结构和操作方式本质是c标准库的。

    <https://docs.python.org/zh-cn/3/library/calendar.html>
    <https://dateutil.readthedocs.io/en/stable/>

1. 常用的当前时间获取，时间转换字符串等操作，在库 time 里有现成的函数直接引用即可。

2. 库 datetime 的对象 datetime 是最常用的，这个才是完整的日期时间对象，那个date对象和time对象是它为了组合datetime对象细分的，操作方法单一。

3. 库datetime里面操作的方法，有时候就转到库time上了，注意哦，虽然用的时候没有import time，但是实际返回值可能是库time的。

4. 实际代码操作中，注意

    务必分清导入的是库还是库对象 import datetime 和 import datetime.datetime

    datetime.time() 意义不一样，一个是datetime库里的time对象，一个是datetime库里datetime对象的time方法，名字来回重复，就怕你不晕！

    datetime.datetime.time.time() 你能看懂返回值类型是啥不

### Timestamp 类型

    文档中没有专门描述，注意这个timestamp类型就是c标准库中的time_t的一个秒数，
    一般是从 epoch 开始的秒数。

    python中对于时间的运算本质上都被转成Timestamp类型了，注意函数返回值类型！

### 库time <https://docs.python.org/zh-cn/3/library/time.html>

时间的访问和转换，依赖库datetime。

注意这个库的很多对象和操作是时间转换自C标准库的。

这个库的很多函数返回值是不一样的，注意区别

字符串格式化为本库用的时间格式，格式跟库datetime的不同 <https://docs.python.org/zh-cn/3/library/time.html#time.strftime>

术语解释

    epoch 是时间开始的点，并且取决于平台。对于Unix， epoch 是1970年1月1日00:00:00（UTC）。要找出给定平台上的 epoch ，请查看 time.gmtime(0) 。

    术语 Unix 纪元秒数 是指自国际标准时间 1970 年 1 月 1 日零时以来经过的总秒数，通常不包括 闰秒。 在所有符合 POSIX 标准的平台上，闰秒都会从总秒数中被扣除。

    此模块中的功能可能无法处理纪元之前或将来的远期日期和时间。未来的截止点由C库决定；对于32位系统，它通常在2038年。

    函数 strptime() 在接收到 %y 格式代码时可以解析 2 位数的年份。 当解析 2 位数年份时，会按照 POSIX 和 ISO C 标准进行转换：数值 69--99 映射为 1969--1999，而数值 0--68 被映射为 2000--2068。

    UTC是协调世界时（以前称为格林威治标准时间，或GMT）。缩写UTC不是错误，而是英语和法语之间的妥协。

    DST是夏令时，在一年中的一部分时间（通常）调整时区一小时。 DST规则很神奇（由当地法律确定），并且每年都会发生变化。 C 库有一个包含本地规则的表（通常是从系统文件中读取以获得灵活性），并且在这方面是True Wisdom的唯一来源。

    各种实时函数的精度可能低于表示其值或参数的单位所建议的精度。例如，在大多数Unix系统上，时钟 "ticks" 仅为每秒50或100次。

    另一方面， time() 和 sleep() 的精度优于它们的Unix等价物：时间表示为浮点数，time() 返回最准确的时间 （使用Unix gettimeofday() 如果可用），并且 sleep() 将接受非零分数的时间（Unix select() 用于实现此功能，如果可用）。

    时间值由 gmtime()，localtime() 和 strptime() 返回，并被 asctime()， mktime() 和 strftime() 接受，是一个 9 个整数的序列。 gmtime()， localtime() 和 strptime() 的返回值还提供各个字段的属性名称。

#### 内置数据类型

添加了一点我的注解，timestamp类型是epoch点以来的秒数，很多函数返回的都是这样的秒数，如果单独说是整型或浮点型，体现不出时间意义。

##### timestamp     对应 c 标准库的 time_t

这是个能传递给别的库如库 datatime 使用的数据结构，其实就是个秒数，主要存在价值是在各个库直接传递方便。

##### struct_time   对应 c 标准库的struct tm

class time.struct_time

    请注意，与C结构不同，月份值是 [1,12] 的范围，而不是 [0,11] 。

    给函数gmtime(), localtime(), strptime()的返回值交换数据方便使用的

    time.struct_time(tm_year=2019, tm_mon=12, tm_mday=2, tm_hour=17, tm_min=25, tm_sec=0, tm_wday=0, tm_yday=336, tm_isdst=0)

    可访问对象参见 <https://docs.python.org/zh-cn/3/library/time.html#time.struct_time>

时区常量

    time.altzone

        本地DST时区的偏移量，以UTC为单位的秒数，如果已定义。如果当地DST时区在UTC以东（如在西欧，包括英国），则是负数。 只有当 daylight 非零时才使用它。 见下面的注释。

    time.daylight

        如果定义了DST时区，则为非零。 见下面的注释。

    time.timezone

        本地（非DST）时区的偏移量，UTC以西的秒数（西欧大部分地区为负，美国为正，英国为零）。 见下面的注释。

    time.tzname

        两个字符串的元组：第一个是本地非DST时区的名称，第二个是本地DST时区的名称。 如果未定义DST时区，则不应使用第二个字符串。 见下面的注释。

注解 对于上述时区常量（ altzone 、 daylight 、 timezone 和 tzname ），该值由模块加载时有效的时区规则确定，或者最后一次 tzset() 被调用时，并且在过去的时间可能不正确。建议使用来自 localtime() 结果的 tm_gmtoff 和 tm_zone 来获取时区信息。

#### 格式字符串 strftime() 方法速查

    http://strftime.org/

    datetime、date、time都提供了strftime()方法，该方法接收一个格式字符串，输出日期时间的字符串表示。
    下表是从python手册中拉过来的，我对些进行了简单的翻译（翻译的有点噢口~~）。

格式字符  意义

    %a  星期的简写。如 星期三为Web
    %A  星期的全写。如 星期三为Wednesday
    %b  月份的简写。如4月份为Apr
    %B  月份的全写。如4月份为April
    %c  日期时间的字符串表示。（如： 04/07/10 10:43:39）
    %d  日在这个月中的天数（是这个月的第几天）
    %f  微秒（范围[0,999999]）
    %H  小时（24小时制，[0, 23]）
    %I  小时（12小时制，[0, 11]）
    %j  日在年中的天数 [001,366]（是当年的第几天）
    %m  月份（[01,12]）
    %M  分钟（[00,59]）
    %p  AM或者PM
    %S  秒（范围为[00,61]，为什么不是[00, 59]，参考python手册~_~）
    %U  周在当年的周数当年的第几周），星期天作为周的第一天
    %w  今天在这周的天数，范围为[0, 6]，6表示星期天
    %W  周在当年的周数（是当年的第几周），星期一作为周的第一天
    %x  日期字符串（如：04/07/10）
    %X  时间字符串（如：10:43:39）
    %y  2个数字表示的年份
    %Y  4个数字表示的年份
    %z  与utc时间的间隔 （如果是本地时间，返回空字符串）
    %Z  时区名称（如果是本地时间，返回空字符串）
    %%  %% => %

#### 内置函数，不需要实例化对象直接用

##### time.tzname 当前时区名

    >>> import time
    >>> time.tzname
    # 中文windows下返回的居然是中文 ('中国标准时间', '中国夏令时')
    ('CST', 'CST')

    >>> import time
    >>> time.strftime('%Z', time.localtime())
    'CST'

##### time.time()       → timestamp

返回当前时间 timestamp

数据类型是 timestamp ，即POSIX 时间戳数据类型，以浮点数表示的从 epoch 开始的秒数的时间值。
不是一般的整数哦，有意义的。

##### time.strftime()   struct_time → 字符串日期时间

将 struct_time 转换成字符串

格式参考 <https://docs.python.org/zh-cn/3/library/time.html#time.strftime>

入参 struct_time
返回 字符串日期时间

    >>> from time import gmtime, strftime
    >>> strftime("%a, %d %b %Y %H:%M:%S +0000", gmtime())
    'Thu, 28 Jun 2001 14:17:15 +0000'

##### 打印当前时区名称

    import time
    time.strftime('%Z', time.localtime())

##### time.strptime()   字符串日期时间 → struct_time

    将字符串日期转换成 struct_time

    格式参考跟strftime()一样 <https://docs.python.org/zh-cn/3/library/time.html#time.strftime>

    入参 字符串日期时间
    返回 struct_time

##### time.mktime()     struct_time → timestamp

同c标准库的mktime()，提供从 struct_time 到 timestamp 的转换

入参 struct_time
返回 timestamp

NOTE: mktime 输入的日期是带时区的，返回的值才是不带时区的。

    time.gmtime(0)
    >>> time.struct_time(tm_year=1970, tm_mon=1, tm_mday=1, tm_hour=0, tm_min=0, tm_sec=0, tm_wday=3, tm_yday=1, tm_isdst=0)

    # 中国地区输入0会报错，因为又倒减了8个小时……
    time.mktime(time.gmtime(0))
        Traceback (most recent call last):
        File "<string>", line 1, in <module>
        OverflowError: mktime argument out of range

    # 这个才是中国地区（东8区）真正的0秒输入……
    a = (1970, 1, 1, 8, 0, 0, 3, 1, 0)
    >>> time.mktime(a)
    0.0

如果想设置标准的 UTC 1970-01-01 00:00:00 咋办呢？

    # 法1： timestamp → struct_time
    time.gmtime(0)  # int秒数即可

    # 法2： struct_time → timestamp
    calendar.timegm(datetime.datetime(1970, 1, 1, 0, 0, 0).timetuple())

    #验证可得 把输入的本地时间当0时区操作了
    time.gmtime( calendar.timegm(datetime.datetime.now().timetuple()) )

    或直接置秒数：
            if start is None:
            start = -2208989082  # UTC 1900年1月1日 00:01:01
        elif isinstance(start, _datetime.datetime):
            start = int(_time.mktime(start.timetuple()))
        else:
            start = int(_time.mktime(
                _time.strptime(str(start), '%Y-%m-%d')))

##### time.gmtime()     timestamp → struct_time

    同c标准库的gmtime()， UTC时间。 dst 标志始终为零。

    入参 timestamp
    返回 struct_time

有个相反的函数在库calendar.timegm()

##### time.localtime()  timestamp → struct_time

    同c标准库的localtime()，当地时间。dst标志设置为 1 。

    入参 timestamp
    返回 struct_time

##### time.sleep()

    暂停执行调用线程达到给定的秒数。

##### ~~time.asctime()~~

    同c标准库的asctime()，转换为以下形式的字符串: 'Sun Jun 20 23:21:05 1993'。

    入参 struct_time
    返回 字符串时间

##### ~~time.ctime()~~

    同c标准库的ctime()，转换为以下形式的字符串: 'Sun Jun 20 23:21:05 1993'

    入参 timestamp
    返回 字符串时间

#### 获取当前时区的偏移

    >>> import time
    >>> time.timezone
    -28800
    >>> time.timezone / 3600.0
    -8.0

### 库datetime <https://docs.python.org/zh-cn/3/library/datetime.html>

在支持日期时间数学运算，实现的关注点更着重于如何能够更有效地解析其属性用于格式化输出和数据操作。

注意这个库的很多对象和操作是时间转换自C标准库的。

字符串格式化为本库用的时间格式，格式跟库time的不同 <https://docs.python.org/zh-cn/3/library/datetime.html#strftime-and-strptime-behavior>

#### class datetime.time 时间对象

一个独立于任何特定日期的（本地）时间，它假设每一天都恰好等于 24*60*60 秒，并可通过 tzinfo 对象来调整。

注意

    这里只有时间，没有日期！

    time 对象并不支持算术运算。

属性: hour, minute, second, microsecond 和 tzinfo。

支持的运算：

    # time 对象并不支持算术运算。

    # 当 a 时间在 b 之前时，则认为 a 小于 b。
    time1 < time2

构造方法：

    入参：时 分 秒 毫秒 整数

    from datetime import time
    time(23, 59, 59, 999999)

    import datetime
    datetime.time(23, 59, 59, 999999)

time.time() 只表示零点零分零秒，不是当前系统时间！

fromisoformat()

    入参：时分秒字符串

    >>> from datetime import time
    >>> time.fromisoformat('04:23:01')
    datetime.time(4, 23, 1)
    >>> time.fromisoformat('04:23:01.000384')
    datetime.time(4, 23, 1, 384)
    >>> time.fromisoformat('04:23:01+04:00')
    datetime.time(4, 23, 1, tzinfo=datetime.timezone(datetime.timedelta(seconds=14400)))

实例方法：

time对象没有获取当前系统日期时间的功能

    在datetime对象用now()实现，time对象一般就是字符串操作，date对象只有取日期的today()

    在库time里用time()实现取当前时间，返回值类型是 timestamp

isoformat()

    返回：时间字符串

    入参格式见 <https://docs.python.org/zh-cn/3/library/datetime.html#datetime.time.isoformat>

    >>> time(hour=12, minute=34, second=56, microsecond=123456).isoformat(timespec='minutes')
    '12:34'
    >>> dt = time(hour=12, minute=34, second=56, microsecond=0)
    >>> dt.isoformat(timespec='microseconds')
    '12:34:56.000000'
    >>> dt.isoformat(timespec='auto')
    '12:34:56'

__str__()

    等价于 t.isoformat()。

strftime(format)

    返回一个由显式格式字符串所指明的代表日期的字符串。

    格式参数 <https://docs.python.org/zh-cn/3/library/datetime.html#strftime-strptime-behavior>

utcoffset()

    将本地时间与 UTC 时差(含夏令时) 返回为一个 timedelta 对象

dst()

    返回当前夏令时 timedelta 对象

tzname()

    返回当前时区名 作为字符串

#### class datetime.date 日期对象

一个理想化的简单型日期，它假设当今的公历在过去和未来永远有效。时间默认是0点0分0秒。

属性: year, month, day。

支持的运算：

    # date2 等于从 date1 减去 timedelta.days 天。
    date2 = date1 + timedelta

    # 计算 date2 的值使得 date2 + timedelta == date1
    date2 = date1 - timedelta

    timedelta = date1 - date2

    # 如果 date1 的时间在 date2 之前则认为 date1 小于 date2
    date1 < date2

构造方法

    from datetime import date
    date(2018, 2, 1)

    import datetime
    datetime.date(2018, 2, 1)

today()

    返回当前的本地日期，时间默认是0点0分0秒。

    等价于 date.fromtimestamp(time.time())。

    注意，跟后面的库datetime对象datetime的today()/now()不一样的 ！

fromtimestamp()

    从时间戳构建日期

__str__()

    返回一个以 ISO 8601 格式 YYYY-MM-DD 来表示日期的字符串

常用实例方法：

~~ctime()~~

    返回一个固定格式字符串，格式同c标准库ctime()

    # d.ctime() 等效于:
    time.ctime(time.mktime(d.timetuple()))

    >>> from datetime import date
    >>> date(2002, 12, 4).ctime()
    'Wed Dec  4 00:00:00 2002'

##### strftime()    date → 字符串日期时间

    返回一个由显式格式字符串所指明的代表日期的字符串。

    格式参数 <https://docs.python.org/zh-cn/3/library/datetime.html#strftime-strptime-behavior>

##### timetuple()   date → struct_time

    类型转换，把date对象，返回成库 time 用的 struct_time 结构了，方便后续运算。

    注意 跨 库 了！

    返回一个 time.struct_time，这里的 time 是 库 time 不是 库 datetime 的 time 对象

    # d.timetuple() 等价于:
    time.struct_time((d.year, d.month, d.day, 0, 0, 0, d.weekday(), yday, -1))

示例

    >>> from datetime import date
    >>> today = date.today()
    >>> today
    datetime.date(2007, 12, 5)
    >>> today == date.fromtimestamp(time.time())
    True
    >>> my_birthday = date(today.year, 6, 24)
    >>> if my_birthday < today:
    ...     my_birthday = my_birthday.replace(year=today.year + 1)
    >>> my_birthday
    datetime.date(2008, 6, 24)
    >>> time_to_birthday = abs(my_birthday - today)
    >>> time_to_birthday.days
    202

#### 库datetime的日期时间对象datetime

注意，是库里有个与库同名的共享对象，在 import 的时候写出来容易混淆，注意区别

    import datetime         # 导入库
    datetime.date.today()   # 引用 date 对象的方法
    datetime.datetime.now() # 引用 datetime 对象的方法

    from datetime import datetime  # 导入库里的同名对象！
    datetime.now()          # 引用 datetime 对象的方法

datetime 实质就是 date 对象和 time 对象的组合，表示完整的日期时间一般用这个对象。

    https://docs.python.org/zh-cn/3/library/datetime.html#datetime-objects

属性：year, month, day, hour, minute, second, microsecond, tzinfo.

##### now()     → datetime

    返回表示当前地方时的 datetime 对象

    # 当前 UTC 时间 不要使用 utcnow() 而是传入timezone对象
    import datetime
    from datetime import timezone
    datetime.datetime.now(tz=timezone.utc)
    type(datetime.datetime.now())

##### fromtimestamp()   timestamp → datetime

    返回对应于 POSIX 时间戳例如 库time.time() 的返回值的本地日期和时间。

    >>> import time
    >>> from datetime import timezone
    >>> from datetime import datetime
    >>> datetime.fromtimestamp(time.time())
    datetime.datetime(2020, 9, 30, 18, 42, 25, 9402)

    # 这样才能返回utc时间 不要使用 utcfromtimestamp() 而是传入timezone对象
    >>> datetime.fromtimestamp(1571595618.0, tz=timezone.utc)

##### combine()   date + time → datetime

    组合date对象和time对象为datetime对象

    d == datetime.combine(d.date(), d.time(), d.tzinfo)

##### fromisoformat()     iso标准的日期时间字符串 → datetime

    目的只是作为 datetime.isoformat() 的逆操作。
    格式见 <https://docs.python.org/zh-cn/3/library/datetime.html#datetime.datetime.fromisoformat>

    >>> from datetime import datetime
    >>> datetime.fromisoformat('2011-11-04')
    datetime.datetime(2011, 11, 4, 0, 0)

##### strptime()  字符串日期时间 → datetime

    date, datetime 和 time 对象都支持 strftime(format) 方法，最常用的是 .strftime('%Y-%m-%d %H:%M:%S')

    返回一个对应于 date_string，根据 format 进行解析得到的 datetime 对象。

    字符串格式见 <https://docs.python.org/zh-cn/3/library/datetime.html#strftime-strptime-behavior>

    等价于 datetime(*(time.strptime(date_string, format)[0:6]))

实例方法

##### strftime()    datetime → 字符串日期时间

    返回一个表示日期和时间的字符串

    格式参考 <https://docs.python.org/3/library/datetime.html#strftime-strptime-behavior>

##### timestamp()     datetime → timestamp

    类型转换，返回对应于 datetime 实例的 POSIX 时间戳，方便后续运算。

##### timetuple()     datetime → struct_time

    类型转换，把datetime对象，返回成库 time 用的 struct_time 结构了，方便后续运算。

    注意 跨 库 了！

    返回一个 time.struct_time，这里的 time 是 库 time 不是 库 datetime 的 time 对象

    # d.timetuple() 等价于:
    time.struct_time((d.year, d.month, d.day,
                  d.hour, d.minute, d.second,
                  d.weekday(), yday, dst))

##### date()    datetime → date

    返回库datetime的date对象

##### time()    datetime → time

    返回库datetime的time对象，无tzinfo对象

##### timetz()  datetime → time有tzinfo

    返回库datetime的time对象，有tzinfo对象

##### isoformat()   datetime → iso标准的日期时间字符串

    返回一个以 ISO 8601 格式表示的日期和时间字符串：

    >>> from datetime import datetime, timezone
    >>> datetime(2019, 5, 18, 15, 17, 8, 132263).isoformat()
    '2019-05-18T15:17:08.132263'
    >>> datetime(2019, 5, 18, 15, 17, tzinfo=timezone.utc).isoformat()
    '2019-05-18T15:17:00+00:00'

__str__()
    同上

~~ctime()~~

    返回一个表示日期和时间的字符串，格式固定不够灵活

    >>> from datetime import datetime
    >>> datetime(2002, 12, 4, 20, 30, 40).ctime()
    'Wed Dec  4 20:30:40 2002'

    等价于 time.ctime(time.mktime(d.timetuple()))

##### tzname(dt) datetime -> 字符串时区名

入参  datetime 对象
返回  时区名字符串

    datetime.tzname(datetime.now())

##### class datetime.timedelta 日期时间运算对象

表示时间间隔，精确到微秒，两个 date 对象或者 time 对象,或者 datetime 对象之间的。

    today = datetime.date.today()
    yesterday = today - datetime.timedelta(days=1)

    >>> delta = timedelta(
    ...     days=50,
    ...     seconds=27,
    ...     microseconds=10,
    ...     milliseconds=29000,
    ...     minutes=5,
    ...     hours=8,
    ...     weeks=2
    ... )
    >>> # Only days, seconds, and microseconds remain
    >>> delta
    datetime.timedelta(days=64, seconds=29156, microseconds=10)
    >>>
    >>> d = timedelta(microseconds=-1)
    >>> (d.days, d.seconds, d.microseconds)
    (-1, 86399, 999999)

支持的运算：

    timedelta 对象支持与 date 和 datetime 对象进行特定的相加和相减运算

    支持 timedelta 对象与另一个 timedelta 对象相整除或相除，包括求余运算和 divmod() 函数。 现在也支持 timedelta 对象加上或乘以一个 float 对象。

    支持 timedelta 对象进行比较运算

        == 或 != 比较 总是 返回一个 bool 对象，无论被比较的对象是什么类型

        所有其他比较 (例如 < 和 >)，当一个 timedelta 对象与其他类型的对象比较时，将引发 TypeError:

        布尔运算中，timedelta 对象当且仅当其不等于 timedelta(0) 时则会被视为真值。

    t1 = t2 + t3    t2 和 t3 的和。 运算后 t1-t2 == t3 and t1-t3 == t2 必为真值。(1)

    t1 = t2 - t3  t2 减 t3 的差。 运算后 t1 == t2 - t3 and t2 == t1 + t3 必为真值。 (1)(6)

    t1 = t2 * i or t1 = i * t2 乘以一个整数。运算后假如 i != 0 则 t1 // i == t2 必为真值。 In general, t1 * i == t1 * (i-1) + t1 is true. (1)

    t1 = t2 * f or t1 = f * t2  乘以一个浮点数，结果会被舍入到 timedelta 最接近的整数倍。 精度使用四舍五偶入奇不入规则。

    f = t2 / t3     总时间 t2 除以间隔单位 t3 (3)。 返回一个 float 对象。

    t1 = t2 / f or t1 = t2 / i  除以一个浮点数或整数。 结果会被舍入到 timedelta 最接近的整数倍。 精度使用四舍五偶入奇不入规则。

    t1 = t2 // i or t1 = t2 // t3   计算底数，其余部分（如果有）将被丢弃。在第二种情况下，将返回整数。 （3）

    t1 = t2 % t3 余数为一个 timedelta 对象。(3)

    q, r = divmod(t1, t2) 通过 : q = t1 // t2 (3) and r = t1 % t2 计算出商和余数。q是一个整数，r是一个 timedelta 对象。

    +t1 返回一个相同数值的 timedelta 对象。

    -t1 等价于 timedelta(-t1.days, -t1.seconds, -t1.microseconds), 和 t1* -1. (1)(4)

    abs(t) 当 t.days >= 0``时等于 +\ *t*, 当 ``t.days < 0 时 -t 。 (2)

    str(t) 返回一个形如 [D day[s], ][H]H:MM:SS[.UUUUUU] 的字符串，当 t 为负数的时候， D 也为负数。 (5)

    repr(t) 返回一个 timedelta 对象的字符串表示形式，作为附带正规属性值的构造器调用。

实例方法

total_seconds()

    返回时间间隔包含了多少秒。

    >>> from datetime import timedelta
    >>> year = timedelta(days=365)
    >>> another_year = timedelta(weeks=40, days=84, hours=23,
    ...                          minutes=50, seconds=600)
    >>> year == another_year
    True
    >>> year.total_seconds()
    31536000.0

    >>> year = timedelta(days=365)
    >>> ten_years = 10 * year
    >>> ten_years
    datetime.timedelta(days=3650)
    >>> ten_years.days // 365
    10
    >>> nine_years = ten_years - year
    >>> nine_years
    datetime.timedelta(days=3285)
    >>> three_years = nine_years // 3
    >>> three_years, three_years.days // 365
    (datetime.timedelta(days=1095), 3)

##### class datetime.tzinfo 对象

一个描述时区信息对象的抽象基类。在 datetime 对象 和 time 对象构造的时候实例化。

用来给 datetime 和 time 类提供自定义的时间调整概念（例如处理时区和/或夏令时）。

它的实例方法都是基于入参 datetime 对象 和 time 对象的计算，返回值一般都是 timedelta 对象

##### class datetime.timezone 对象

    一个实现了 tzinfo 抽象基类的子类，用于表示相对于 世界标准时间（UTC）的偏移量。

    每个实例都代表一个以与 UTC 的固定时差来定义的时区

### 库 calendar

输出像 Unix cal 那样的日历，它还提供了其它与日历相关的实用函数。

<https://docs.python.org/zh-cn/3/library/calendar.html>

常用方法：

#### calendar.timegm(tuple)     struct_time → timestamp

    由struct_time结构的数组生成timestamp，与 time 模块time.gmtime() 是彼此相反的。

    入参 struct_time
    返回 timestamp

#### calendar.isleap(year)      → bool

    如果 year 是闰年则返回 True ,否则返回 False。

#### calendar.weekday(year, month, day)     → int

    返回某年（ 1970 -- ...），某月（ 1 -- 12 ），某日（ 1 -- 31 ）是星期几（ 0 是星期一）。

#### calendar.setfirstweekday(weekday)

    设置每周的第一天为星期天
    import calendar
    calendar.setfirstweekday(calendar.SUNDAY)

#### calendar.firstweekday()

    返回当前设置的每星期的第一天的数值。 0 是星期一

### 库 dateutil 包

具有扩展时区和解析支持的第三方库 <https://dateutil.readthedocs.io/en/stable/>

## Numpy的日期时间

在NumPy 1.7版本开始，它的核心数组（ndarray）对象支持datetime相关功能，由于’datetime’这个数据类型名称已经在Python自带的datetime模块中使用了， NumPy中时间数据的类型称为’datetime64’。

<https://numpy.org.cn/reference/arrays/datetime.html>
<https://numpy.org/doc/stable/reference/arrays.datetime.html>

### numpy.datetime64 相关转换函数

时间格式字符串转换为numpy的datetime对象，可使用datetime64实例化一个对象，可以指定单位datetime64[M] datetime64[ms]等

#### 数组初始化时指定dtype类型  字符串日期时间 → datetime64

给出字符串，指定数据类型，由系统自行转换，如果字符串时间的单位不一致，取最小的

    a = np.array(['2019-01-05','2019-01-02','2019-01-03 20:01'], dtype='datetime64')
    print(a, a.dtype)
    # ['2019-01-05T00:00' '2019-01-02T00:00' '2019-01-03T20:01'] datetime64[m]

#### np.datetime64()  字符串日期时间 → datetime64

    a = np.datetime64('2019-10-01')  # dtype='datetime64[D]'
    a = np.datetime64('2019-10-01 20:00:05')  # dtype='datetime64[s]'
    print(type(a))  # <class 'numpy.datetime64'>
    print(a.dtype)  # dtype='datetime64[s]'

    datetime_array = np.arange('2018-01-01','2020-01-01', dtype='datetime64[Y]')
    print(datetime_array)  # ['2018' '2019']

    datetime_array = np.arange('2019-01-01','2019-10-01', dtype='datetime64[M]')
    print(datetime_array)  # ['2019-01' '2019-02' '2019-03' '2019-04' '2019-05' '2019-06' '2019-07' '2019-08' '2019-09']

    datetime_array = np.arange('2019-01-05','2019-01-10', dtype='datetime64[ms]')
    print(datetime_array)
    ['2019-01-05T00:00:00.000' '2019-01-05T00:00:00.001'
     '2019-01-05T00:00:00.002' ... '2019-01-09T23:59:59.997'
     '2019-01-09T23:59:59.998' '2019-01-09T23:59:59.999']

#### np.datetime64()  datetime → datetime64

    import datetime
    import numpy as np

    dt = datetime.datetime(year=2020, month=6, day=1, hour=20, minute=15, second=33)
    dt64 = np.datetime64(dt, 's')
    print(dt64, dt64.dtype)
    # 2020-06-01T20:15:33 datetime64[s]

#### astype()   datetime64 → datetime

将numpy.datetime64转化为datetime格式，可使用astype()方法转换数据类型，如下所示：

    # numpy.datetime64转化为datetime格式
    dt64_arr = np.array(['2019-01-05','2019-01-02','2019-01-03 20:01'], dtype='datetime64')
    dt_arr = dt64_arr.astype(datetime.datetime)  # <class 'datetime.date'>

#### np.datetime_as_string()  datetime64 → 字符串日期时间

    datetime_str=np.datetime_as_string(datetime_nd)  # <class 'numpy.str_'>

#### 上例基础上，指定时间的起止范围     字符串日期时间 → datetime64

    datetime_array = np.arange('2019-01-05','2019-01-10', dtype='datetime64')

#### datetime64 -> datetime.datetime

    # dt64为datetime64类型的变量
    (dt64 - np.datetime64('1970-01-01T00:00:00Z')) / np.timedelta64(1, 's')

    # 另一个写法
    dt64.astype(datetime.datetime)

#### split() 字符串创建datetime64数组

    # np.fromstring('2020-01-01,2020-01-02,2020-01-03', dtype='datetime64', sep=',')

    # 这个函数的返回值居然是narray(list())
    narr = np.char.split('2020-01-01,2020-01-02,2020-01-03', sep=',')

    # 这个函数的返回值才是narray()
    narr = np.array(['2007-07-13', '2006-01-13', '2010-08-13'])  # , dtype='datetime64'

    # narr.astype('M8[D]')
    # narr.astype('datetime64')
    # narr.astype(np.datetime64)

### numpy.timedelta64 时间运算对象

numpy也提供了datetime.timedelta类的功能，支持两个时间对象的运算，得到一个时间单位形式的数值。datetime和timedelta结合提供了更简单的datetime计算方法。如果两个时间的单位不一致，运算后取最小单位。

    # numpy.datetime64 calculations
    _d1 = np.datetime64('2009-01-01') - np.datetime64('2008-01-01')
    print(_d1)  # 366 days
    print(type(_d1))  # <class 'numpy.timedelta64'>

    _d2 = np.datetime64('2009') + np.timedelta64(20, 'D')
    print(_d2)  # 2009-01-21

    _d3 = np.datetime64('2011-06-15T00:00') + np.timedelta64(12, 'h')
    print(_d3)  # 2011-06-15T12:00

    _d4 = np.timedelta64(1,'W') / np.timedelta64(1,'D')
    print(_d4)  # 7.0

#### 两个日期的差值转换精度为天，用它除以一天的时间增量即可

    s = _d3 - _d2  # np.timedelta64(1260720, 'ns')
    days = s.astype('timedelta64[D]')
    days / np.timedelta64(1, 'D')

#### datetime64 → datetime.datetime time_t timestamp

    (dt64_arr - np.datetime64('1970-01-01T00:00:00Z')) / np.timedelta64(1, 's')

## Pandas的日期时间

    操作的类型是 numpy 的 datetime64 timedelta64，python的 datetime, timestamp

    Series对象和DataFrame的列数据提供了cat、dt、str三种属性接口（accessors），
    分别对应分类数据、日期时间数据和字符串数据，通过这几个接口可以快速实现特定的功能，非常快捷。
    <https://zhuanlan.zhihu.com/p/44256257>

### 索引很重要

很多操作都依赖索引，比如数组的连接，默认是对索引的。
在删除/排序等操作后，需要手动 reset_index()，不然后序操作会乱了。

### 日期时间对应的对象和操作函数

<https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html>

pandas captures 4 general time related concepts:

1.Date times: A specific date and time with timezone support. Similar to datetime.datetime from the standard library.

2.Time deltas: An absolute time duration. Similar to datetime.timedelta from the standard library.

3.Time spans: A span of time defined by a point in time and its associated frequency.

4.Date offsets: A relative time duration that respects calendar arithmetic. Similar to dateutil.relativedelta.relativedelta from the dateutil package.

    Concept         Scalar Class    Array Class     pandas Data Type        Primary Creation Method
    -------------------------------------------------------------------------------------------------
    Date times      Timestamp       DatetimeIndex   datetime64[ns] or       to_datetime() or date_range()
                                                    datetime64[ns, tz]

    Time deltas     Timedelta       TimedeltaIndex  timedelta64[ns]         to_timedelta() or timedelta_range()

    Time spans      Period          PeriodIndex     period[freq]            Period() or period_range()

    Date offsets    DateOffset      None            None                    DateOffset()

#### pd.date_range()    → DatetimeIndex

#### pd.to_datetime() 这里搞了个3义性 !   → datetime DatetimeIndex Timestamp

<https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.to_datetime.html>
<https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#timeseries>

to_datetime() Return type depends on input:

    list-like: DatetimeIndex
    Series: Series of datetime64 dtype
    scalar: Timestamp

#### Unix时间戳 -> Timestamp np.datetime64

    # unix时间戳转为 np.datetime64[ns]
    >pd.to_datetime(df['timest'], unit='s')
    1539561600  ->  datetime64[ns]

#### 用Series.dt操作DataFrame的一列Timestamp类型数据，最常用的日期时间操作都通过它进行

    .dt简介         <https://pandas.pydata.org/pandas-docs/stable/user_guide/basics.html#basics-dt-accessors>
    .dt完整方法列表   <https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.dt.html>

np.datetime64 转换为字符串的pd用法很特殊，实际应用中，都是转成series以方便取小时分钟啥的拆分操作

来个例子，看看别扭不:

    strtime =
        df.loc[df['name'] ==pname, 'create_time'].dt.strftime('%Y-%m-%d %H:%M:%S').to_numpy()[0]

官方示例

    In [272]: s = pd.Series(pd.date_range('20130101 09:10:12', periods=4))

    In [273]: s
    Out[273]:
    0   2013-01-01 09:10:12
    1   2013-01-02 09:10:12
    2   2013-01-03 09:10:12
    3   2013-01-04 09:10:12
    dtype: datetime64[ns]

    In [274]: s.dt.hour
    Out[274]:
    0    9
    1    9
    2    9
    3    9
    dtype: int64

##### .dt 取指定日期等

    In [277]: s[s.dt.day == 2]
    Out[277]:
    1   2013-01-02 09:10:12
    dtype: datetime64[ns]

##### .dt 时区转换

    In [281]: s.dt.tz_localize('UTC').dt.tz_convert('US/Eastern')
    Out[281]:
    0   2013-01-01 04:10:12-05:00
    1   2013-01-02 04:10:12-05:00
    2   2013-01-03 04:10:12-05:00
    3   2013-01-04 04:10:12-05:00
    dtype: datetime64[ns, US/Eastern]

##### .dt 转换为字符串日期时间

    In [284]: s.dt.strftime('%Y/%m/%d')
    Out[284]:
    0    2013/01/01
    1    2013/01/02
    2    2013/01/03
    3    2013/01/04
    dtype: object

取整为日期

    s['stimeday'] = pd.to_datetime(s['stime'].dt.strftime('%Y-%m-%d'), format='%Y-%m-%d')

### Timestamp()，对标 python datetime.datetime

<https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Timestamp.html>

pd.Timestamp.fromtimestamp(1569081600.0)=Timestamp('2019-09-22 00:00:00')

Timestamp对象常用的操作方法有：

    .timestamp()：转换为一个浮点数表示的POSIX时间戳；POSIX时间戳也称Unix时间戳(Unix timestamp)，是一种时间表示方式，定义为从格林威治时间1970年01月01日00时00分00秒起至现在的总秒数。和其对应的是fromtimestamp()；如 pd.Timestamp.fromtimestamp(1569081600.0)=Timestamp('2019-09-22 00:00:00')；

    .strftime()：转为特定格式的字符串；如 pd.Timestamp('2019-9-22 14:12:13').strftime('%Y/%m/%d')='2019/9/22'；

    .strptime(string, format)：和strftime()相反，从特定格式字符串转时间戳， pd.Timestamp.strptime('2019-9-22 14:12:13','%Y-%m-%d %H:%M:%S')；关于各种字母代表哪个个时间元素（如m代表month而M代码minute）看datetime的文档；

    .date()：把时间戳转为一个日期类型的对象，只有年月日， pd.Timestamp('2019-9-22 14:12:13').date()=datetime.date(2019,9,22)；

    .combine(date, time)：把一个date类型和一个time类型合并为datetime类型；

    .to_datetime64()：把时间戳转为一个numpy.datetime64类型；

#### timetuple() pd.Timestamp -> struct_time

    把pandas的Timestamp转换为python的struct_time类型

### Period 对应一段时间

<https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Period.html>

#### pd.period_range()  → PeriodIndex

### Interval 对应一段间隔

<https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Interval.html>

#### pd.interval_range()  → IntervalIndex

### DateOffset 日期的加减一段范围，有各种方法

<https://pandas.pydata.org/pandas-docs/stable/reference/offset_frequency.html>

<https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#dateoffset-objects>

    from pandas.tseries.offsets import DateOffset
    ts = pd.Timestamp('2017-01-01 09:10:11')
    ts + DateOffset(months=3, days=5)
    Timestamp('2017-04-06 09:10:11')

特别是 timedeltas 不支持月份的情况，只能用 DateOffset 加 x 个月。

### timedeltas，对标python标准库的 datetime.timedelta

日期时间计算对应的对象和操作函数
<https://pandas.pydata.org/pandas-docs/stable/user_guide/timedeltas.html>

不支持月份，见 DateOffset

#### pd.Timedelta()  → timedelta

    In [6]: pd.Timedelta(days=1, seconds=1)
    Out[6]: Timedelta('1 days 00:00:01')

    In [15]: pd.Timedelta(pd.offsets.Second(2))
    Out[15]: Timedelta('0 days 00:00:02')

#### pd.to_timedelta()  → Timedelta TimedeltaIndex

    In [17]: pd.to_timedelta('1 days 06:05:01.00003')
    Out[17]: Timedelta('1 days 06:05:01.000030')

    In [18]: pd.to_timedelta('15.5us')
    Out[18]: Timedelta('0 days 00:00:00.000015500')

    In [19]: pd.to_timedelta(['1 days 06:05:01.00003', '15.5us', 'nan'])
    Out[19]: TimedeltaIndex(['1 days 06:05:01.000030', '0 days 00:00:00.000015500', NaT], dtype='timedelta64[ns]', freq=None)

#### pd.timedelta_range()  → TimedeltaIndex

    In [98]: pd.TimedeltaIndex(['1 days', '1 days, 00:00:05', np.timedelta64(2, 'D'),
    ....:                    datetime.timedelta(days=2, seconds=2)])
    ....:
    Out[98]:
    TimedeltaIndex(['1 days 00:00:00', '1 days 00:00:05', '2 days 00:00:00',
                    '2 days 00:00:02'],
                dtype='timedelta64[ns]', freq=None)

#### 访问属性 days, seconds, microseconds, nanoseconds

其实是访问的datetime.timedelta，所以对Series可以直接使用.dt访问

    In [95]: td.dt.components
    Out[95]:
    days  hours  minutes  seconds  milliseconds  microseconds  nanoseconds
    0  31.0    0.0      0.0      0.0           0.0           0.0          0.0
    1  31.0    0.0      0.0      0.0           0.0           0.0          0.0
    2  31.0    0.0      5.0      3.0           0.0           0.0          0.0
    3   NaN    NaN      NaN      NaN           NaN           NaN          NaN

    In [89]: td.dt.days
    Out[89]:
    0    31.0
    1    31.0
    2    31.0
    3     NaN
    dtype: float64

    In [90]: td.dt.seconds
    Out[90]:
    0      0.0
    1      0.0
    2    303.0
    3      NaN
    dtype: float64


    In [91]: tds = pd.Timedelta('31 days 5 min 3 sec')

    In [92]: tds.days
    Out[92]: 31

    In [93]: tds.seconds
    Out[93]: 303

    In [94]: (-tds).seconds
    Out[94]: 86097

#### timedelta运算 datetime64 datetime →

    s = pd.Series(pd.date_range('2012-1-1', periods=3, freq='D'))  # datetime64
    td = pd.Series([pd.Timedelta(days=i) for i in range(3)])       # timedelta64
    df = pd.DataFrame({'A': s, 'B': td})
    df['C'] = df['A'] + df['B']

    In [30]: df.dtypes
    Out[30]:
    A     datetime64[ns]
    B     timedelta64[ns]
    C     datetime64[ns]
    dtype: object

    In [32]: s - datetime.datetime(2011, 1, 1, 3, 5)
    Out[32]:
    0   364 days 20:55:00
    1   365 days 20:55:00
    2   366 days 20:55:00
    dtype: timedelta64[ns]

    In [33]: s + datetime.timedelta(minutes=5)
    Out[33]:
    0   2012-01-01 00:05:00
    1   2012-01-02 00:05:00
    2   2012-01-03 00:05:00
    dtype: datetime64[ns]

    In [34]: s + pd.offsets.Minute(5)
    Out[34]:
    0   2012-01-01 00:05:00
    1   2012-01-02 00:05:00
    2   2012-01-03 00:05:00
    dtype: datetime64[ns]

    In [58]: y.fillna(pd.Timedelta(10, unit='s'))
    Out[58]:
    0   0 days 00:00:10
    1   0 days 00:00:10
    2   1 days 00:00:00
    dtype: timedelta64[ns]

#### 改周期

    # to days
    In [77]: td / np.timedelta64(1, 'D')
    Out[77]:
    0    31.000000
    1    31.000000
    2    31.003507
    3          NaN
    dtype: float64

    In [78]: td.astype('timedelta64[D]')
    Out[78]:
    0    31.0
    1    31.0
    2    31.0
    3     NaN
    dtype: float64

    In [83]: td * pd.Series([1, 2, 3, 4])
    Out[83]:
    0   31 days 00:00:00
    1   62 days 00:00:00
    2   93 days 00:15:09
    3                NaT
    dtype: timedelta64[ns]

#### 索引使用 DatetimeIndex PeriodIndex TimedeltaIndex

    In [113]: tdi = pd.TimedeltaIndex(['1 days', pd.NaT, '2 days'])

    In [114]: tdi.to_list()
    Out[114]: [Timedelta('1 days 00:00:00'), NaT, Timedelta('2 days 00:00:00')]

    In [107]: s = pd.Series(np.arange(100),
    .....:               index=pd.timedelta_range('1 days', periods=100, freq='h'))
    .....:

    In [108]: s
    Out[108]:
    1 days 00:00:00     0
    1 days 01:00:00     1
    1 days 02:00:00     2
    ...
    5 days 02:00:00    98
    5 days 03:00:00    99
    Freq: H, Length: 100, dtype: int64

### pd.to_datetime() 三义性的详细说明

目前的pandas的时区操作，只能操作一列！用列的.dt方法！
其它什么指定某个字段astype() 到datetime64啥的统统不好使！

文档说的不够清楚，在时间索引的dateframe或series上进行，
<https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#timeseries>

目前找到的DataFrame去除时区的方法都是操作DatetimeIndex的，也就是说：
对Dataframe.tz_convert()，必须是日期时间做索引（DatetimeIndex）才能做时区转换。

    DataFrame的这俩函数操作的是DataFrame的索引，所以其他的列是没法直接处理的。
    https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.tz_convert.html
    https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.tz_localize.html

如果操作DataFrame单列，即Series，类型也是DatetimeIndex，这样就可以用.dt的转换时区方法了，下面两个:

#### 1.用 Series.dt.tz_convert(None) 转换为 UTC 并删除时区信息

data['date_column'].dt.date

    https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DatetimeIndex.tz_convert.html
    https://pandas.pydata.org/pandas-docs/stable/reference/series.html#datetime-properties

问题：
    我有个df表格里面有好几个字段都是带时区的日期时间，我想做转换怎么办啊？？？
答：
    一个列（Series类型）一个列的操作，用Series类型里特殊的dt对象的方法操作。

    ts.dt.tz_convert('UTC')
    ts.dt.tz_convert(None) "无"tz将转换为 UTC 并删除时区信息。
    https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DatetimeIndex.tz_convert.htm
    其它什么指定某个字段astype() 到datetime64啥的统统不好使！

或者直接

    .date
        Returns numpy array of python datetime.date objects (namely, the date part of
        Timestamps without timezone information).

    .time
        Returns numpy array of datetime.time.

    .timetz
        Returns numpy array of datetime.time also containing timezone information.

参考

    https://pandas.pydata.org/pandas-docs/stable/reference/general_utility_functions.html#data-types-related-functionality

    https://blog.csdn.net/weixin_38168620/article/details/79596564
    https://blog.csdn.net/tcy23456/article/details/86513728
    https://blog.csdn.net/bqw18744018044/article/details/80934542

例子

    https://pandas.pydata.org/pandas-docs/stable/getting_started/10min.html?highlight=tz_convert

    # dtype: datetime64[ns, UTC]
    ts = pd.Series(pd.date_range('3/9/2018 22:29',periods=5,freq='D', tz='Europe/Moscow'))
    ts.tz_convert('US/Eastern') 不是时间类型索引报错给你看！！！

    ts.dt.date
    ts.dt.time
    ts.dt.tz_convert(None)

#### 2.用Series的dt对象的tz_localize('Europe/Moscow')方法，转换时区

    https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DatetimeIndex.tz_localize.html
    https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.dt.date.html?highlight=dt#pandas.Series.dt.date
    https://pandas.pydata.org/pandas-docs/stable/reference/series.html#datetime-methods

Series.tz_localize This operation localizes the Index.
Series.dt.tz_localize()  localize the values in a timezone-naive Series

    tz_naive = pd.date_range('2018-03-01 09:00', periods=3)  # 默认是本地时间，无时区信息
    tz_aware = tz_naive.tz_localize(tz='US/Eastern')  # 从本地时间转换到美东时区
    tz_aware.tz_localize(None)  # 删除时区信息，恢复为默认的本地时间

    td = pd.DataFrame(data=pd.to_datetime(['2015 -03-30 20:12:32','2015-03-12 00:11:11']),
                    columns=['stime'])
    td.tz_convert(tz=None,axis=1) 不是时间类型索引报错给你看！！！！！！
    td['stime'].tz_localize('US/Eastern') 不是时间类型索引报错给你看！！！！！！
    pd.to_datetime(td['stime']).tz_convert(None) 不是时间类型索引报错给你看！！！！！！

<https://stackoverflow.com/questions/49198068/how-to-remove-timezone-from-a-timestamp-column-in-a-pandas-dataframe>

Timestamp

    testdata['stime'].dt.tz_localize(None)

    idx = ['2011-08-05 00:00:00-04:00', '2011-08-05 01:00:00-04:00',
        '2011-08-05 02:00:00-04:00', '2011-08-05 03:00:00-04:00']
    idx = pd.DatetimeIndex(idx).tz_localize('UTC').tz_convert('America/New_York')
    print (idx)
    DatetimeIndex(['2011-08-05 00:00:00-04:00', '2011-08-05 01:00:00-04:00',
                '2011-08-05 02:00:00-04:00', '2011-08-05 03:00:00-04:00'],
                dtype='datetime64[ns, America/New_York]', freq=None)

    idx = idx.tz_convert(None) + pd.offsets.Hour(16)
    print (idx)
    DatetimeIndex(['2011-08-05 20:00:00', '2011-08-05 21:00:00',
                '2011-08-05 22:00:00', '2011-08-05 23:00:00'],
                dtype='datetime64[ns]', freq='H')

#### 把人搞糊涂的原因

pd.datetime()用数字字符串默认是UTC时间无时区信息，而返回值有三义性！！！

<https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#timeseries>
根据你输入的类型不同：如果是dateframe或seris对象，只找索引去做时间转换的！！！

    pd.to_datetime('2010/11/12', format='%Y/%m/%d') 输入是单字符串，
        返回的是Timestamp('2010-11-12 00:00:00') !
        这个是你的当地时间，但是无时区信息，但是pd是理解为UTC时间。

    pd.to_datetime(['2012-11-21 10:00'])
        返回值是 DatetimeIndex ！ 这个是你的当地时间，但是无时区信息，但是pd是理解为UTC时间。

    pd.to_datetime(['2005/11/23', '2010.12.31'])
        返回值是 DatetimeIndex ！ 这个是你的当地时间，但是无时区信息，但是pd是理解为UTC时间。

    tpp = pd.to_datetime(pd.Series(['Jul 31, 2009', '2010-01-10', None]))
    # 注意：
        tpp是一个Series！数据类型是datetime64[ns] ! 这个是你的当地时间，但是无时区信息

    df = pd.DataFrame({'year': [2015, 2016],\
                    'month': [2, 3],\
                    'day': [4, 5],\
                    'hour': [2, 3]})
    # 严重注意：
    pd.to_datetime(df) 生成的是一个Series！数据类型是datetime64[ns] 这个是你的当地时间，但是无时区信息

    dti = pd.date_range(start='2014-08-01 09:00',
                        freq='H', periods=3, tz='Europe/Berlin')
    # dti是DatetimeIndex！！！ 有时区信息 09:00:00+02:00
    dti.tz_convert('US/Central')
    # 转为当地时间02:00:00-05:00，时区信息也变了

df.reset_index(drop=False)把Data字段从索引里还原回来，默认索引就是个RangedIndex
但是：Date字段数据类型自动转成了DatetimeArray？没文档
不是np.datetime64，转换不知道怎么做……

以前还是pd.Timestamp类型
    <http://www.mamicode.com/info-detail-2559533.html>
    <https://cloud.tencent.com/developer/ask/29186>

pandas 如果把类似datetime的列定为index 会被转型成TimeStamp。
还可以显式设置为DateTimeIndex，这还不算完

最坑的地方是：  如果我这样 [idx for idx in df.index]

遍历出来的是 pd.TimeStamp型

但如果 [idx for  list(df.index.to_numpy())]

得到的却是numpy.datetime64型。

最大的区别就是timezone。

#### yfinance源代码分析

quotes = _pd.DataFrame({"Open": opens,
                        "High": highs,
                        "Low": lows,
                        "Close": closes,
                        "Adj Close": adjclose,
                        "Volume": volumes})

quotes.index = _pd.to_datetime(timestamps, unit="s")
    # to_datetime() Return type depends on input:
    # 这里搞了个3义性
    #     list-like: DatetimeIndex
    #     Series: Series of datetime64 dtype
    #     scalar: Timestamp
quotes.sort_index(inplace=True)
return quotes

<https://pandas.pydata.org/pandas-docs/stable/reference/arrays.html#datetime-data>
numpy.datetime64本质上是一个瘦包装器int64.它几乎没有日期/时间特定功能.

pd.Timestamp是numpy.datetime64的包装器.它由相同的int64值支持,
但支持整个pd.datetime.datetime接口,以及有用的特定于pd的功能.

这两者的数组内表示是相同的 – 它是一个连续的int64数组. pd.Timestamp是一个标量框,可以更轻松地处理单个值.
而DatetimeIndex的to_numpy()方法可以很方便的转换为numpy数组，实现 更短,更快的时间比较:
%timeit (df.index.to_numpy() >= pd.Timestamp('2011-01-02').to_datetime64()) & \
        (df.index.to_numpy() < pd.Timestamp('2011-01-03').to_datetime64())

        >= np.datetime64(datetime.strptime("2011-01-02", '%Y-%m-%d')

### pandas 时区转换

Pandas 时间对象默认不支持时区信息，你可以直接使用各种时间运算，他其实是当作UTC操作的。

只支持Series，通过它的dt对象提供的一些函数来操作，也就是说，改时区，只能单独一列一列的操作。

在Pandas的底层，所有 Timestamp/ DatetimeIndex 都存储为 UTC，时区信息是单独的字段保存。
想转别的时区，用 .dt.tz_convert('Europe/Berlin'), 'Asia/Shanghai', 'UTC' 等。
想删除时区信息，要考虑去除时区信息后时间字段的意义，是UTC时间还是本地时间，操作见下面例子。

坑 1 在于：

    DataFrame的索引列操作时区的语法，跟普通列操作时区的语法，不 一 样：
    普通时间列 Series(dtype: datetime64)    用 .dt.tz_convert()操作，
    时间索引列 DatetimeIndex or PeriodIndex 用 tz_convert()操作。

    # 你觉得这是一个Series吗？ 不，这是一个 DatetimeIndex
    tz_naive = pd.date_range('2018-03-01 09:00', periods=3)

    # 你觉得这是啥？ 数据类型有三种可能哦，你慢慢猜吧
    pd.to_datetime(pd.Series(['3/11/2000']))
    pd.to_datetime(['3/11/2000'])
    pd.to_datetime(pd.DataFrame({'year': [2015, 2016],'month': [2, 3],'day': [4, 5]}))
    pd.to_datetime('13000101', format='%Y%m%d', errors='ignore')
    pd.to_datetime('3/11/2000')
    pd.to_datetime(1490195805, unit='s')

坑 2 在于：

    pd.to_datetime()/date_range()等填入的字符串时间，你指定了时区信息才有意义，
    不然的话，把他当 utc 或 本地时间 或 某个时区的时间，完全在于你自己的理解。

比如，输入时间时没有指定时区（你觉得是UTC时间，比较各种时间运算的时候pandas就把它当作UTC时间的），
但是，后来用tz_localize()设置了下时区，这个时间的UTC值，他 变 了！

    # tz_localize() 设置时区，会把你原来的没指定时区的那个时间，
    # 当作你指定时区的时间，然后得出储存的UTC时间

    # 你觉得自己输入的是UTC时间吗？ 或者你觉得这是自己所在的北京时间？
    tz_naive = pd.date_range('2018-03-01 09:00', periods=3)

    # 我说这是柏林时间
    tz_naive.tz_localize('Europe/Berlin')
    DatetimeIndex(['2018-03-01 09:00:00+01:00', '2018-03-02 09:00:00+01:00',
            '2018-03-03 09:00:00+01:00'],
            dtype='datetime64[ns, Europe/Berlin]', freq='D')

    # 把你原来以为UTC的那个时间，按柏林时间处理，转成了UTC时间8:00，
    # 而你一开始输入的时间是 9:00
    tz_naive.tz_localize('Europe/Berlin').tz_convert('UTC')
    DatetimeIndex(['2018-03-01 08:00:00+00:00', '2018-03-02 08:00:00+00:00',
            '2018-03-03 08:00:00+00:00'],
            dtype='datetime64[ns, UTC]', freq='D')

    # 有了时区信息之后的各种时区转换，就顺理成章了
    tz_naive.tz_localize('Europe/Berlin').tz_convert('Asia/Shanghai')
    DatetimeIndex(['2018-03-01 16:00:00+08:00', '2018-03-02 16:00:00+08:00',
            '2018-03-03 16:00:00+08:00'],
            dtype='datetime64[ns, Asia/Shanghai]', freq='D')

如果DataFrame的某列或索引有别的时区信息，而打印时候不想显示这个时区信息，
则需要去除时区信息，这个列的时间要先转到个具体的时区，哪怕是 UTC ！

注意：

    1.去除时区信息，或者转为本地时间，或者转为UTC，是两个不同的函数。
    2.想转本地时间且没有时区信息，不能直接去除时区信息，要先转本地时间然后再去除。

坑 3 在于：

    这两个时区转换函数，臭毛病很多
    tz_localize() 用于没有时区信息的Series，如果已经有时区信息，会抛异常
    tz_convert()  用于有时区信息的Series，如果没有时区信息，会抛异常

这就是为嘛得搞个函数包装下的原因，恶心死你。

例子：

    # 时间字段不是UTC，不是本地时区，先从东一区转北京时间
    #   tz_convert('Asia/Shanghai')
    # 然后再去除时区信息：
    #   存为本地时间 tz_localize(None)
    #   存为UTC时间 tz_convert(None)
    # https://www.jianshu.com/p/ab7514dc6190
    if df[dt_column].dt.tz is not None:
        df[dt_column] = df[dt_column].dt.tz_convert('Asia/Shanghai').dt.tz_localize(None)

参考

    https://www.jianshu.com/p/ab7514dc6190

### 最好封装时区设置函数

```python

# id列是unix时间戳，先按utc处理，然后转换为北京时间，然后去除时区
df['stime'] = pd.to_datetime(df['id'], unit='s')  # 这个是当UTC处理了
df['stime'] = change_series_tz(df['stime'], origin_tz='UTC', target_tz='Asia/Shanghai')
df['stime'] = remove_series_tz(df['stime'], remove_only=True)

def change_series_tz(date_series, origin_tz='UTC', target_tz='UTC'):
    r""" 把pd.series，从别的时区或UTC或没有时区，转换为指定的时区

    NOTE: 如果原来没有时区信息，添加时区后，原来的时间就当作你指定的时区的时间，而不是UTC时间。

    Parameters
    ----------
    date_series : Timestamp/DatetimeIndex
        the date(s) to be converted

    origin_tz : str
        'UTC', 'Europe/Berlin', 'Asia/Shanghai', 'Asia/Singapore', 'US/Eastern'等
        这个可以用默认值UTC，因为源数据无时区信息时就是按UTC计算，有时区信息时转成UTC计算，
        最终结果是相同的，转到了目的时区。

    target_tz : str
        'UTC', 'Europe/Berlin', 'Asia/Shanghai', 'Asia/Singapore', 'US/Eastern'等

    Returns
    -------
    same type as input
        date(s) converted to UTC

    参考：　lib\site-packages\empyrical\utils.py
    """
    if target_tz is None:
        raise RuntimeError('没这么简单！用 remove_series_tz() 删除时区信息')

    date_series = pd.to_datetime(date_series)  # 这样返回什么数据类型，其实看运气的哦

    # 为嘛这么麻烦呢：
    #   tz_localize()只能用于没有时区信息的Series，如果已经有时区信息，会抛异常
    #   tz_convert() 只能用于有时区信息的Series，如果没有时区信息，会抛异常
    try:
        # 先尝试数据没有时区的情况，把当前时间作为为指定时区
        date_series = date_series.dt.tz_localize(origin_tz)
    except TypeError:
        # 数据本身自带时区信息，先转为指定的源时区
        date_series = date_series.dt.tz_convert(origin_tz)

    date_series = date_series.dt.tz_convert(target_tz)

    return date_series


def remove_series_tz(date_series, remove_only=True):
    """ 去除 pandas 的 Series 的时区信息

    Parameters
    ----------
    date_series : Timestamp/DatetimeIndex
        the date(s) to be converted

    remove_only :  删除时区信息后，原时间如何转换
        True 仅删除时区信息，原时间保留不做转换（其实pandas自己储存的UTC时间变了）
        False 原时间根据自己的时区信息转换为UTC时间

    Returns
    -------
    same type as input
        date(s) converted to no timezone info.

    """
    date_series = pd.to_datetime(date_series)  # 这样返回什么数据类型，其实看运气的哦

    if date_series.dt.tz is None:
        return date_series

    if remove_only:
        return date_series.dt.tz_localize(None)  # None 仅删除时区信息，原时间不变
    else:
        return date_series.dt.tz_convert(None)  # None 删除时区信息，且把原时间转换为UTC时间

```
