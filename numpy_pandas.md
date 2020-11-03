# numpy/pandas 常用方法

## 各个库取最大最小的函数区别，以取最小min()为例

### python.min()    如果有None会将None作为最小值

    只要是可迭代对象，list/dict啥的，包括pd和np的对象，都执行同一判断规则

### DataFrame.min() 默认排除 NA/null 值

Series也是一样
<https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.min.html>

    df.min()
    df.min(skipna=True)

### DataFrame.idxmin()  最小值的索引，默认排除 NA/null 值

Series也是一样

### DataFrame.sum() 求和，默认排除 NA/null 值

Series也是一样

### numpy.amin()    数组沿给定轴传播的最小值，传播任何 NaN，给出axis会返回新数组

<https://numpy.org/doc/stable/reference/generated/numpy.amin.html>

    >>>a = np.arange(4).reshape((2,2))
    a
    array([[0, 1],
           [2, 3]])

    >>>np.amin(a)           # Minimum of the flattened array
    0

    >>>np.amin(a, axis=0)   # Minima along the first axis
    array([0, 1])

    >>>np.amin(a, axis=1)   # Minima along the second axis
    array([0, 2])

    >>>np.amin(a, where=[False, True], initial=10, axis=0)
    array([10,  1])

### numpy.nanmin() 数组沿给定轴传播的最小值，忽略NaN值

全NaN会打印屏幕警告，这样用：

    with warnings.catch_warnings():
        warnings.filterwarnings('ignore',
                                r'All-NaN (slice|axis) encountered')
        minY = np.nanmin(minYset)

### numpy.argmin()  返回最小值的位置（索引号）

    >>>a = np.arange(6).reshape(2,3) + 10
    >>>a
    array([[10, 11, 12],
        [13, 14, 15]])

    >>>np.argmin(a)
    0

    >>>np.argmin(a, axis=0)
    array([0, 0, 0])

    >>>np.argmin(a, axis=1)
    array([0, 0])

### numpy.minimum() 两数组最小值的新数组，传播NaN

比较两个数组并返回一个包含元素上最小值的新数组。如果要比较的元素之一是 NaN，则返回该元素。如果两个元素都是 NaN，则返回第一个元素。

    >>>np.minimum([2, 3, 4], [1, 5, 2])
    array([1, 3, 2])

    >>>np.minimum([np.nan, 0, np.nan],[0, np.nan, np.nan])
    array([nan, nan, nan])

### numpy.fmin() 两数组最小值的新数组，忽略NaN

比较两个数组并返回一个包含元素上最小值的新数组。如果要比较的元素之一是 NaN，则返回非 nan 元素。如果两个元素都是 NaN，则返回第一个元素。

    >>>np.fmin([np.nan, 0, np.nan],[0, np.nan, np.nan])
    array([ 0.,  0., nan])

## 空值判断

numpy

    np.isnan()判断NaN

pandas

    基于 numpy 支持 NaN，基于R语言支持 na 和 null，基于python支持 None，自己还发明了个 NaT 支持 DatetimeIndex.即pandas构建在numpy之上，而这两个函数的名称源自R的DataFrame，pandas就是试图模仿它的结构和功能。

    df.isna()和df.isnull()效果一样的，也可pd.isna(df)。
    pd.isnull() 只用于标量数组

python

    None, False, 空字符串"", 0, 空列表[], 空字典{}, 空元组()都相当于False

        1. 对sss=None或''[]等等，如果判断有值才计算，可以用
                if ssss:
                    ....
                else:
                    print('empty or None导致sss不能用')
            这样最方便

        2. 但是在该值为空值或为None需要分别处理时，
        不能用 if not sss（不知道是空字符串或者None值），必须分开明确写：
                if sss is None:
                    ...
                if len(sss)>0:
                    ...

                # 这样写就不好
                if sss is not None:
                    # 里面还得嵌套个对空的判断
                    if sss:
                        ...

        https://www.cnblogs.com/lincappu/p/8305763.html

举例

    >>>pd.isna('dog')
    False

    >>>pd.isna(pd.NA)
    True

    >>>pd.isna(np.nan)
    True

## 判断对象相等

### python 判断对象相等

    # 是否同一个对象
    if ui_form is signal_form:

    # 两个类型是否相同，子类是等于父类的
    if isinstance(B(), A):

    # 判断类型相等，子类是不等于父类的
    type(B()) == A

    # 比较运算符，用于比较两个对象的value(值)是否相同
    # 实质调用该对象的比较运算符进行数值比较，大于小于等于都是这种规则
    if A==B:
        ...

## pandas 使用

Pandas v0.23.4手册汉化

    https://www.cnblogs.com/chenxygx/p/9542299.html
    https://blog.csdn.net/hhtnan/article/details/80080240
    http://pandas.pydata.org/pandas-docs/stable/user_guide/computation.html

移动窗口函数rolling() 使用滑窗（sliding windown）或呈指数降低的权重（exponentially decaying weights），
扩张窗口expanding() 扩张平均的时间窗口是从时间序列开始的地方作为开始，窗口的大小会逐渐递增，直到包含整个序列

    http://www.sohu.com/a/341495335_809317

    rolling() 简单的移动窗口函数
    rolling()后，可以接mean、count、sum、median、std等聚合函数，
    相当于之前版本的rolling_mean()、rolling_count()、rolling_sum()、rolling_median()、rolling_std()

    ewm() 指数加权的移动窗口函数
    若根据跨度指定衰减，即α=2/(span+1)，则需要指定参数span；
    若根据质心指定衰减，即α=1/(com+1)，则需要指定参数com；
    若根据半衰期指定衰减，即α=1−exp(log(0.5)/halflife), for halflife>0，则需要指定参数halflife。
    ewm()后，可以接mean、corr、std等聚合函数，相当于ewma()、ewmcorr()、ewmstd()，但count、sum等聚合函数没有对应的特定函数

    对数值列转为新的指数列
    df[retColName] = np.around(np.power(10, df[srcCloName]), decimals=2)

    self.__df[colname] 是 Series对象，调用 .values() .to_numpy() .array()
    得到 pandas.array:([a,d,...]) numpy.ndarray

pandas 优化

    https://blog.csdn.net/BF02jgtRS00XKtCx/article/details/90092161
    http://www.pythontip.com/blog/post/12331/

Pandas中关于reindex(), set_index()和reset_index()的用法

    https://blog.csdn.net/qq_42874547/article/details/89052864
    https://www.cnblogs.com/ljhdo/p/11556410.html

Pandas详解五之下标存取

    https://blog.csdn.net/learnstudy2/article/details/102643779

### apply() 和 applymap()的区别

    apply()实际上只能穿过一个维度，就是说如果是Series，可以每个元素执行，但是DataFrame的话，其实是对每列执行函数。
    对于DataFrame如果想要每个元素操作的话，应该使用applymap()。

### GroupBy 用法

    https://github.com/yanqiangmiffy/quincy-python-v2/blob/master/Python008-Pandas%20GroupBy%20%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B.ipynb
    将分组后的字符拼接
        df.groupby('content_id')['tag'].apply(lambda x:','.join(x)).to_frame()
    分组，取每组的前几行
        grouped = df.groupby(['class']).head(2)
        df.sort_values(['stime','code'],ascending=[1,0],inplace=True)
    统计每个content_id有多少个不同的用户
        df.groupby("content_id")["user_id"].unique().to_frame()

    分组结果排序
        df.groupby('product')['value'].sum().to_frame().reset_index().sort_values(by='value')

    按'A'列分组，给组内元素排序号(从0开始，降序)
        df.groupby('A').cumcount(ascending=False)

    带有条件A的行，取他的id列
    arr_A = df.loc[df['condition'] == 'A','id'].values

    按商店和产品分组,同时对销售额进行总计和计数,同时采用评分的平均值
        dfg = df.groupby(['store', 'product']).agg({'sales': ['sum', 'count'],
                                                    'rating': 'mean'})
    在每个组中保留评分最高的两个行
        g = df_from_db.groupby(
                        level=0,
                        group_keys=False).apply(lambda x: x.sort_values(
                            ('rating', 'mean'), ascending=False).head(2))

#### 示例

    # 用时间做索引，直接resample
    df_dti = df_from_db.set_index('stime').resample(
                    pd.Timedelta(str(to_period) + 'minutes')).agg({
                        'open': ['first'],
                        'high': ['max'],
                        'low': ['min'],
                        'close': ['last'],
                        'volume': ['sum']
                    })  # .ohlc()

    # 不用时间做索引，则需要 groupby+rolling：df.rolling('2s').sum()
    # https://blog.csdn.net/wj1066/article/details/78853717
    df_from_db_grouped.groupby('stime').rolling(
            pd.Timedelta(str(to_period) + 'minutes'),
            min_periods=2).agg({
                'open': ['first'],
                'high': ['max'],
                'low': ['min'],
                'close': ['last'],
                'volume': ['sum']
            })

## numpy 使用

    如何有效地使用numpy处理大规模数据
        https://blog.csdn.net/u014448054/article/details/100903405

    Pandas进阶之提升运行效率
        https://blog.csdn.net/yangsen99/article/details/94365243

    Numpy快速处理数据--ufunc运算
        https://blog.csdn.net/kezunhai/article/details/46127845
        https://blog.csdn.net/pipisorry/article/details/39235753

    frompyfunc和vectorize之间的差异
        http://www.voidcn.com/article/p-arkwadpr-btb.html
        https://stackoverflow.com/questions/6768245/difference-between-frompyfunc-and-vectorize-in-numpy
    np.frompyfunc+向量法等
        https://blog.csdn.net/u012421852/article/details/80246289

    自定义ufunc函数 将单值计算函数转换成数组计算函数
        https://docs.scipy.org/doc/numpy/reference/generated/numpy.frompyfunc.html

        https://blog.csdn.net/u012421852/article/details/79698599
            func_ = np.frompyfunc(_num2str, 1, 1)
            ret = func_(nums).tolist()  # np.ndarray

### ufunc 用法

用ufunc实现向量化操作，避免遍历数组跑循环

    ```python

    # np.vectorize()只是为了方便而不是为了性能，内部实现用的for循环
    # https://numpy.org/doc/stable/reference/generated/numpy.vectorize.html
    _ufc = np.vectorize(_pyf,otypes=[np.float])
    ret = _ufc(nlist, nlist.shift(1), alpha)


    def _pyf(y, yp, al):
        return al * y + (1 - al) * yp
    _ufc = np.frompyfunc(_pyf, 3, 1)

    # 如果是累积求和，直接调用 np.cumsum()即可
    #
    # ufunc函数对象本身还有一些方法函数如accumulate，
    #   ret = _ufc.accumulate(nlist, dtype=np.object).astype(np.float)
    # 本来用ufunc.accumulate()是最直观的，
    # 但是这些方法只有对两个输入、一个输出的ufunc函数有效，否则会抛出ValueError，
    # 而且类型默认是object，这个处理起来慢于有实际类型的对象
    # https://stackoverflow.com/questions/13828599/generalized-cumulative-functions-in-numpy-scipy
    #    import numpy as np
    #    uadd = np.frompyfunc(lambda x, y: x + y, 2, 1)
    #    uadd.accumulate([1,2,3], dtype=np.object).astype(np.int)
    #    #array([1, 3, 6])

    # 对于求累积，_ufc多于两个参数的调用只能用如下：
    ret = _ufc(nlist, nlist.shift(1), alpha).astype(np.float)  # ufc返回的居然是dtype=object

    ```
