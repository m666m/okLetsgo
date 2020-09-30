# 时间计算速查——从 c 到 python 到 sql

时间计算，由unix系统在70年代定义，操作系统储存的是自1970年1月1日0点（UTC）开始的秒数

## C标准库

在标准c库中使用结构 time_t 和 tm，及操作这2个结构的几个函数，提供到字符串之间的转换（cpu时间的略）。
注意：各种静态的对象满天飞的，用起来先想想这个函数用的啥对象实现的这功能，多线程躲着这块点。

参考
    C标准库头文件 <https://zh.cppreference.com/w/c/header>
    日期和时间工具 <https://en.cppreference.com/w/c/chrono>
    time.h <https://www.tutorialspoint.com/c_standard_library/time_h.htm>

    你看不到我 <https://en.wikipedia.org/wiki/Unix_time>

### time_t typedef

在 POSIX 系统上，time_t 以秒计量，自1970年1月1日0点（UTC）开始的秒数 <https://zh.cppreference.com/w/c/chrono/time_t>

注意这些操作函数的入参和返回值类型，有的修改入参值，有的是返回值类型变，用法没规律，死记：

time() <time.h> <https://zh.cppreference.com/w/c/chrono/time>
    取当前时间

    入参 time_t
    返回纪元1970年1月1日0点（UTC）开始经过的当前系统日历时间。如果提供了入参，函数修改这个time_t的值。

    下面的那些显示为字符串函数依赖这个值进行显示，
    所以取系统时间并打印的过程，就是先time()一个time_t，然后调用各种字符串输出函数

tzset() <https://pubs.opengroup.org/onlinepubs/9699919799/functions/tzset.html>

    设置时区，读取环境变量 TZ，下面的几个字符串函数都偷偷调它一把。

    <time.h>

    操作了外部变量 tzname tzname[0] = "std"; tzname[1] = "dst";
                    daylight 夏令时偏离秒数
                    timezone 相对零时区偏离秒数

    设置环境变量参见 <https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html#tag_08>

localtime()

    将从纪元开始的时间转换成以本地时间表示的日历时间。

    <time.h>
    入参 time_t
    返回 struct tm。

    提供从 time_t 到 struct tm 的转换

gmtime()

    将从纪元开始的时间转换成以协调世界时（UTC）表示的日历时间。

    <time.h>
    入参 time_t
    返回 struct tm

    提供从 time_t 到 struct tm 的转换

~~ctime()~~

    转换从纪元起的给定时间为历法本地时间，再转换为文本表示，如同通过调用 asctime(localtime(ltime))

    <time.h>
    入参 time_t
    返回 字符串

    POSIX 标记此函数为过时并推荐 strftime() 代替。

strftime() <https://zh.cppreference.com/w/c/chrono/strftime>

    按照格式字符串 format ，转换来自给定的日历时间 time 的日期和时间信息

    <time.h>
    入参 struct tm
    输出 字符串

    这个字符串转换函数是推荐使用的，代替 ctime() 和 asctime()
    format格式参见 <https://zh.cppreference.com/w/c/chrono/strftime>

difftime()

    以秒数计算二个作为 time_t 对象的日历时间的差（ time_end - time_beg ）。若 time_end 代表先于 time_beg 的时间点，则结果为负。

    入参 time_t
    返回 差值秒数

    计算两个日期之间的差值，只能用秒数

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

### tm struct 注意是系统静态对象，在 gmtime 、 localtime 及 ctime 间共享

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

操作函数，注意返回值类型：

mktime() <https://zh.cppreference.com/w/c/chrono/mktime>

    重整化表示成 struct tm 的本地日历时间，并将其转化成从纪元开始经过时间的 time_t 对象格式。

    <time.h>
    入参 struct tm
    返回 time_t

    提供从 tm 到 time_t 的转换，
    一般指定时间的操作都是从tm结构或者字符串来的，转成time_t后再供其它时间计算函数调用。

~~asctime()~~

    转换日历时间 tm 为以下固定的 25 字符表示形式： Www Mmm dd hh:mm:ss yyyy\n

    <time.h>
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

### timestamp 术语

    文档中没有专门描述，注意这个timestamp类型就是类似c标准库中的time_t的一个秒数，
    一般是从 epoch 开始的秒数。

    python中对于时间的运算本质上都被转成timestamp类型了，注意函数返回值类型！

### 库datetime <https://docs.python.org/zh-cn/3/library/datetime.html>

    在支持日期时间数学运算，实现的关注点更着重于如何能够更有效地解析其属性用于格式化输出和数据操作。

    注意这个库的很多对象和操作是时间转换自C标准库的。

#### class datetime.time 对象

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

time对象没有获取当前系统时间的功能，在date对象里实现，time对象一般就是字符串操作

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

#### class datetime.date 对象

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

ctime()

    返回一个表示日期的字符串

    # d.ctime() 等效于:
    time.ctime(time.mktime(d.timetuple()))

strftime(format)

    返回一个由显式格式字符串所指明的代表日期的字符串。

    格式参数 <https://docs.python.org/zh-cn/3/library/datetime.html#strftime-strptime-behavior>

timetuple()

    类型转换，把date对象，返回成库 time 用的 struct_time 结构了，方便后续运算。

    注意 跨 库 了！

    返回一个 time.struct_time，这里的 time 是 库 time 不是 库 datetime 的 time 对象

    # d.timetuple() 等价于:
    time.struct_time((d.year, d.month, d.day, 0, 0, 0, d.weekday(), yday, -1))

示例代码

    ``` Python

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

    ```

#### class datetime.datetime 对象

包含来自 date 对象和 time 对象的所有信息的单一对象。

属性：year, month, day, hour, minute, second, microsecond, tzinfo.

完整的日期时间表示一般用这个对象。

注意区别

    import datetime 和 import datetime.datetime

    datetime.time()用起来不一样。

构造方法

    # 实质就是 date 对象和 time 对象的组合
    import datetime
    datetime.datetime(year, month, day, hour=0, minute=0, second=0, microsecond=0)

now() 等价today()

    返回表示当前地方时的 datetime 对象

    # 当前 UTC 时间
    datetime.now(timezone.utc)

fromtimestamp()

    返回对应于 POSIX 时间戳例如 库time.time() 的返回值的本地日期和时间。

    >>> import time
    >>> from datetime import datetime
    >>> datetime.fromtimestamp(time.time())
    datetime.datetime(2020, 9, 30, 18, 42, 25, 9402)

combine()

    组合date对象和time对象为datetime对象

    d == datetime.combine(d.date(), d.time(), d.tzinfo)

fromisoformat()

    目的只是作为 datetime.isoformat() 的逆操作。
    格式见 <https://docs.python.org/zh-cn/3/library/datetime.html#datetime.datetime.fromisoformat>

    >>> from datetime import datetime
    >>> datetime.fromisoformat('2011-11-04')
    datetime.datetime(2011, 11, 4, 0, 0)

strptime()

    返回一个对应于 date_string，根据 format 进行解析得到的 datetime 对象。

    字符串格式见 <https://docs.python.org/zh-cn/3/library/datetime.html#strftime-strptime-behavior>

    等价于 datetime(*(time.strptime(date_string, format)[0:6]))

实例方法

date()

    返回库datetime的date对象

time()

    返回库datetime的time对象，无tzinfo对象

timetz()

    返回库datetime的time对象，有tzinfo对象

timestamp()

    类型转换，返回对应于 datetime 实例的 POSIX 时间戳，方便后续运算。

timetuple()

    类型转换，把datetime对象，返回成库 time 用的 struct_time 结构了，方便后续运算。

    注意 跨 库 了！

    返回一个 time.struct_time，这里的 time 是 库 time 不是 库 datetime 的 time 对象

    # d.timetuple() 等价于:
    time.struct_time((d.year, d.month, d.day,
                  d.hour, d.minute, d.second,
                  d.weekday(), yday, dst))

isoformat()

    回一个以 ISO 8601 格式表示的日期和时间字符串：

    >>> from datetime import datetime, timezone
    >>> datetime(2019, 5, 18, 15, 17, 8, 132263).isoformat()
    '2019-05-18T15:17:08.132263'
    >>> datetime(2019, 5, 18, 15, 17, tzinfo=timezone.utc).isoformat()
    '2019-05-18T15:17:00+00:00'

__str__()
    同上

ctime()

    返回一个表示日期和时间的字符串

    >>> from datetime import datetime
    >>> datetime(2002, 12, 4, 20, 30, 40).ctime()
    'Wed Dec  4 20:30:40 2002'

    等价于 time.ctime(time.mktime(d.timetuple()))

strftime()

    返回一个表示日期和时间的字符串

    格式参考 <https://docs.python.org/3/library/datetime.html#strftime-strptime-behavior>

#### class datetime.timedelta 对象

    表示两个 date 对象或者 time 对象,或者 datetime 对象之间的时间间隔，精确到微秒。

#### class datetime.tzinfo 对象

一个描述时区信息对象的抽象基类。在 datetime 对象 和 time 对象构造的时候实例化。

用来给 datetime 和 time 类提供自定义的时间调整概念（例如处理时区和/或夏令时）。

它的实例方法都是基于入参 datetime 对象 和 time 对象的计算，返回值一般都是 timedelta 对象

tzname(dt)

    入参  datetime 对象
    返回  时区名字符串

#### class datetime.timezone 对象

    一个实现了 tzinfo 抽象基类的子类，用于表示相对于 世界标准时间（UTC）的偏移量。

示例代码

    ``` Python

    import datetime
    import time

    t = time.ctime()

    datetime.datetime.strptime(time.ctime(), "%a %b %d %H:%M:%S %Y")

    ```

### 库time <https://docs.python.org/zh-cn/3/library/time.html>

时间的访问和转换，依赖库datetime。

注意这个库的很多对象和操作是时间转换自C标准库的。

这个库的很多函数返回值是不一样的，注意区别

#### 内置数据类型

能传递给别的库如datatime使用的数据结构是 timestamp

class time.struct_time

    给函数gmtime(), localtime(), strptime()的返回值交换数据方便使用的

    time.struct_time(tm_year=2019, tm_mon=12, tm_mday=2, tm_hour=17, tm_min=25, tm_sec=0, tm_wday=0, tm_yday=336, tm_isdst=0)

#### 内置函数，不需要对象直接用

time.time() → float

    返回当前时间，POSIX 时间戳数据类型，以浮点数表示的从 epoch 开始的秒数的时间值，即 timestamp 。
    不是一般的整数哦，有意义的。

time.asctime()

time.ctime()

    直接调用C标准库的ctime()

time.strptime()

    将字符串日期转换成 struct_time

    格式参考跟strftime()一样 <https://docs.python.org/zh-cn/3/library/time.html#time.strftime>

time.gmtime()

time.localtime()

time.mktime()

time.sleep()

time.strftime()

    将 struct_time 转换成字符串

    格式参考 <https://docs.python.org/zh-cn/3/library/time.html#time.strftime>

    >>> from time import gmtime, strftime
    >>> strftime("%a, %d %b %Y %H:%M:%S +0000", gmtime())
    'Thu, 28 Jun 2001 14:17:15 +0000'

## Numpy的日期时间

## Pandas的日期时间

pdt = pd.to_datetime()

pdt.dt对象可以引用各种方法了 <https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.dt.day.html>
