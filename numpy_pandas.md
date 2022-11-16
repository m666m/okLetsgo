# numpy/pandas 常用方法

- [numpy/pandas 常用方法](#numpypandas-常用方法)
  - [科学计算的几个常用库](#科学计算的几个常用库)
  - [各个库取最大最小的函数区别，以取最小min()为例](#各个库取最大最小的函数区别以取最小min为例)
    - [python.min()    如果有None会将None作为最小值](#pythonmin----如果有none会将none作为最小值)
    - [DataFrame.min() 默认排除 NA/null 值](#dataframemin-默认排除-nanull-值)
    - [DataFrame.idxmin()  最小值的索引，默认排除 NA/null 值](#dataframeidxmin--最小值的索引默认排除-nanull-值)
    - [DataFrame.sum() 求和，默认排除 NA/null 值](#dataframesum-求和默认排除-nanull-值)
    - [numpy.amin()    数组沿给定轴传播的最小值，传播任何 NaN，给出axis会返回新数组](#numpyamin----数组沿给定轴传播的最小值传播任何-nan给出axis会返回新数组)
    - [numpy.nanmin() 数组沿给定轴传播的最小值，忽略NaN值](#numpynanmin-数组沿给定轴传播的最小值忽略nan值)
    - [numpy.argmin()  返回最小值的位置（索引号）](#numpyargmin--返回最小值的位置索引号)
    - [numpy.minimum() 两数组最小值的新数组，传播NaN](#numpyminimum-两数组最小值的新数组传播nan)
    - [numpy.fmin() 两数组最小值的新数组，忽略NaN](#numpyfmin-两数组最小值的新数组忽略nan)
  - [空值判断](#空值判断)
  - [判断对象相等](#判断对象相等)
    - [python 判断对象相等](#python-判断对象相等)
  - [pandas 使用](#pandas-使用)
    - [非常依赖索引的对齐](#非常依赖索引的对齐)
      - [对df进行以下操作之后都要 reset_index()](#对df进行以下操作之后都要-reset_index)
      - [两个长度不等的df互相赋值，需要index一致](#两个长度不等的df互相赋值需要index一致)
    - [Pandas中关于reindex(), set_index()和reset_index()的用法](#pandas中关于reindex-set_index和reset_index的用法)
    - [Pandas详解五之下标存取](#pandas详解五之下标存取)
    - [apply() 和 applymap()的区别](#apply-和-applymap的区别)
    - [列（Series）accessor: 分类数据.cat、日期时间.dt、字符串.str](#列seriesaccessor-分类数据cat日期时间dt字符串str)
    - [移动窗口函数rolling() 扩张窗口expanding()](#移动窗口函数rolling-扩张窗口expanding)
      - [只有一列数值列，才可以rolling()](#只有一列数值列才可以rolling)
      - [同一列前后两行拼接字符串无法用rolling()](#同一列前后两行拼接字符串无法用rolling)
        - [解决1 - 单列用shift()](#解决1---单列用shift)
        - [解决2 - 多列就自定义df_roll()函数](#解决2---多列就自定义df_roll函数)
    - [自定义pandas的roll()](#自定义pandas的roll)
    - [GroupBy 用法](#groupby-用法)
      - [接.apply()](#接apply)
      - [时间字段汇聚](#时间字段汇聚)
        - [不用时间做索引 - groupby + rolling：df.rolling('2s').sum()](#不用时间做索引---groupby--rollingdfrolling2ssum)
        - [用时间做索引 - resample + agg](#用时间做索引---resample--agg)
  - [pandas 的拼接](#pandas-的拼接)
    - [1 merge方法](#1-merge方法)
      - [1.1 内连接](#11-内连接)
      - [1.2 外连接](#12-外连接)
      - [1.3 左连接](#13-左连接)
      - [1.4 右连接](#14-右连接)
      - [1.5 基于多列的连接算法](#15-基于多列的连接算法)
      - [1.6 基于index的连接方法](#16-基于index的连接方法)
    - [2 join方法](#2-join方法)
      - [2.1 index与index的连接](#21-index与index的连接)
      - [2.2 join也可以基于列进行连接](#22-join也可以基于列进行连接)
    - [3 concat方法](#3-concat方法)
      - [3.1 series类型的拼接方法](#31-series类型的拼接方法)
        - [行拼接](#行拼接)
        - [列拼接](#列拼接)
      - [3.2 dataframe类型的拼接方法](#32-dataframe类型的拼接方法)
        - [行拼接](#行拼接-1)
        - [列拼接](#列拼接-1)
  - [DataFrame 大规模的数据拼接，用迭代器传递给concat()](#dataframe-大规模的数据拼接用迭代器传递给concat)
  - [pandas 优化](#pandas-优化)
  - [numpy 大数据量处理使用](#numpy-大数据量处理使用)
    - [numpy ufunc 用法](#numpy-ufunc-用法)
  - [numpy常用](#numpy常用)
    - [生成全为指定值或全为空的ndarray](#生成全为指定值或全为空的ndarray)
    - [生成指定范围值的ndarray](#生成指定范围值的ndarray)
    - [生成随机值的ndarray](#生成随机值的ndarray)
    - [np数组拼接](#np数组拼接)
    - [np大规模的数据拼接，用迭代器传递给concatenate()](#np大规模的数据拼接用迭代器传递给concatenate)
  - [numpy向量化](#numpy向量化)
    - [向量化函数](#向量化函数)
      - [自定义sinc函数](#自定义sinc函数)
      - [np.vectorize() 将函数 sinc 向量化，产生一个新的函数](#npvectorize-将函数-sinc-向量化产生一个新的函数)
    - [二元运算](#二元运算)
    - [ufunc对象](#ufunc对象)
      - [np.frompyfunc() 实现自定义ufunc对象](#npfrompyfunc-实现自定义ufunc对象)
    - [数组广播机制](#数组广播机制)

## 科学计算的几个常用库

都自带绘图功能

    gnuplot http://www.gnuplot.info/
        https://sourceforge.net/projects/gnuplot/files/gnuplot/

    scilab https://www.scilab.org/

    matplotlib https://matplotlib.org/

    scipy https://scipy.org/
            https://numpy.org/
            https://pandas.pydata.org/

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

pandas numpy处理缺失值，none与nan比较 <https://www.cnblogs.com/onemorepoint/p/8966791.html> <https://github.com/m666m/jupyter_demos/tree/master/0005_None_vs_NaN>

最头疼的是，numpy的数据中含有None,会导致整个array的类型变成object，即不报错悄悄的容错了，这个后续会在别的地方计算时出错，调试困难。
所以说，程序设计，有些容错要显式的给出提示，或有个明确的参数，或有个明确的原则，就怕不吭声的做转化。

numpy

注意nan的语义：nan> 0,nan< 0和nan< nan,nan == nan都是False.

    np.isnan()判断NaN

pandas

    基于 numpy 支持 NaN，基于R语言支持 na 和 null，基于python支持 None，自己还发明了个 NaT 支持 DatetimeIndex.即pandas构建在numpy之上，而这两个函数的名称源自R的DataFrame，pandas就是试图模仿它的结构和功能。

    df.isna()和df.isnull()效果一样的，也可pd.isna(df)。
    pd.isna(arr).all() 返回唯一值确定是否全是空值
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

### 非常依赖索引的对齐

下标的批量操作，等号两边的赋值，底层都是依赖索引的对齐。

#### 对df进行以下操作之后都要 reset_index()

(drop=True/False根据自己的情况决定)

使用前要reset_index()：

    删除某些数据后的df，再跟其他df赋值，要注意索引对齐
    过滤取部分数据后的df，再跟其他df赋值，要注意索引对齐

示例：df1取部分数据，用df2的某些值赋值

    ndf = df1[(df1['stime'] >= e_time)].reset_index(drop=False)
    ndf.loc[0, 'psum'] = df2['psum'].sum()

#### 两个长度不等的df互相赋值，需要index一致

否则只有index值相等的才能赋值，但是其它原来有数据的会被置成NaN了。。。。

错误：

    df.loc[df['pname'] == pname, ['position', 'c_rate']] = ssdf[['position', 'c_rate']]

所以如果有个df的列需要从不同的df列获取，那就得明确指定索引：

    df_result = df.set_index('pname', 'stime')

    df_result['position'] = ssdf.set_index('pname', 'stime')['position']

    df_result['c_rate'] = ssdf.set_index('pname', 'stime')['c_rate']

    df_result.reset_index(drop=False, inplace=True)  # 恢复索引列到数据列

这时候用新数据替换原数据，才能只更新指定pname，而其它pname的数据实现保留的效果……

    df.loc[df['pname'] ==pname, ['position', 'c_rate']] = df_result[['position', 'c_rate']]

### Pandas中关于reindex(), set_index()和reset_index()的用法

    https://blog.csdn.net/qq_42874547/article/details/89052864
    https://www.cnblogs.com/ljhdo/p/11556410.html

### Pandas详解五之下标存取

    https://blog.csdn.net/learnstudy2/article/details/102643779

### apply() 和 applymap()的区别

apply()实际上只能穿过一个维度，就是说如果是Series，可以每个元素执行，但是DataFrame的话，其实是对每列执行函数。

对于DataFrame如果想要每个元素操作的话，应该使用applymap()。

### 列（Series）accessor: 分类数据.cat、日期时间.dt、字符串.str

DataFrame的单列和Series有cat、dt、str三种属性接口（accessors），分别对应分类数据、日期时间数据和字符串数据。

通过这几个接口的操作函数，实现单列数据的操作，比如字符串替换拼接、日期合并等处理

    sec_df['sec_fluctuation'] = sec_df['stime'].shift(1).astype(
        str).str.cat(sec_df['stime'].astype(str),
                    sep=' - ').str.cat(sec_df['diff'].round(4).astype(str),
                                        sep=': ')

<https://zhuanlan.zhihu.com/p/44256257>
其中时间类的dt详见<time_t.md>的章节“Pandas的日期时间”

    import pandas as pd
    pd.Series._accessors
    [i for i in dir(pd.Series.str) if not i.startswith('_')]

### 移动窗口函数rolling() 扩张窗口expanding()

使用滑窗（sliding windown）或呈指数降低的权重（exponentially decaying weights），
扩张窗口expanding() 扩张平均的时间窗口是从时间序列开始的地方作为开始，窗口的大小会逐渐递增，直到包含整个序列.

<http://www.sohu.com/a/341495335_809317>

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

#### 只有一列数值列，才可以rolling()

两行取值整理成一个array，才能用x[1] - x[0]，
否则只能shift(1)提上来，新建这些列，再各列做运算

    sec_df['diff'] = sec_df['net_worth'].rolling(2).apply(
        lambda x: x[1] - x[0], raw=True)

#### 同一列前后两行拼接字符串无法用rolling()

形如 '2018-10-1 - 2018-10-10' + 0.8 = '2018-10-1 - 2018-10-10: 0.8'

前后两行取值， rolling()不会传递非数值型字段，也就没法apply()，而直接sec_df.apply()是对每一个元素进行处理，无法单独针对某一列。

Wrong:

    sec_df['sec_fluctuation'] = sec_df['stime'].rolling(2).apply(
        lambda x: str(x[0]) + ' - ' + str(x[1]))

    sec_df['sec_fluctuation'] = sec_df.apply(
        lambda x: str(x['name']) + ':', axis=1)

##### 解决1 - 单列用shift()

    sec_df['previous_stime'] = sec_df['stime'].shift(1)

    sec_df['sec_fluctuation'] = sec_df['stime'].shift(1).astype(
        str).str.cat(sec_df['stime'].astype(str),
                    sep=' - ').str.cat(sec_df['diff'].round(4).astype(str),
                                        sep=': ')

##### 解决2 - 多列就自定义df_roll()函数

把入参作为dataframe可以实现处理指定列： 见下面章节 自定义pandas的roll()

### 自定义pandas的roll()

pandas 的roll()会舍弃非数值类型的字段，不支持传入完整的dataframe，而dataframe.apply()只能所有元素同一处理
<https://stackoverflow.com/questions/38878917/how-to-invoke-pandas-rolling-apply-with-parameters-from-multiple-column>

```python

def df_roll(df, w, **kwargs):
    """ 自定义pandas的roll()，实现传入完整的dataframe，方便选择指定行/列进行处理

    用递次下移的固定行数的分组来解决这个问题。

    如果只是操作一列的不同行之间运算，用 df['col1'] + df.shift(1)['col1'] 更简单

    参数
    ----
    df: pd.DataFrame
        要分组的df
    w:  int
        几行分一组

    返回
    ----
    pandas.groupby
        分组对象，内容是完整的dataframe，操作这个对象就比较方便了

    示例
    ----
        见下面的test

    说明
    ----
        pandas 的roll()会舍弃非数值类型的字段，不支持传入完整的dataframe，而dataframe.apply()只能所有元素同一处理
        https://stackoverflow.com/questions/38878917/how-to-invoke-pandas-rolling-apply-with-parameters-from-multiple-column
    """
    v = df.values
    d0, d1 = v.shape
    s0, s1 = v.strides

    a = stride(v, (d0 - (w - 1), w, d1), (s0, s0, s1))

    rolled_df = pd.concat({
        row: pd.DataFrame(values, columns=df.columns)
        for row, values in zip(df.index, a)
    })

    return rolled_df.groupby(level=0, **kwargs)


# test
np.random.seed([3, 1415])
df = pd.DataFrame(np.random.rand(5, 2).round(2), columns=['A', 'B'])
print(df, '\n------\n', df_roll(df, 2).sum())
print('\n---pipe---\n', df.pipe(df_roll, w=2).sum())
print('\n---agg---\n', df_roll(df, 2).agg(sum))

print('\n---apply1-每两行分组，两行之间操作第0列--\n',  \
  df_roll(df, 2).apply(lambda block: block.iloc[0, 0] + block.iloc[1, 0]))  # 等效df[行号：行号]

# print('\n---apply2---\n',  \
#  df_roll(df, 2).apply(lambda block: block[0:1, 1] + block[1:2, 1]))  # df[]里如果要直接引用，只能是列名。

print('\n---apply3-每两行分组，操作第0列会导致第二行丢失--\n', \
  df_roll(df, 2).apply(lambda block: block.iloc[0, 0] + block.iloc[0, 1]))  # 不连续取值用两个方括号.iloc[[1,3]]
```

### GroupBy 用法

    https://github.com/yanqiangmiffy/quincy-python-v2/blob/master/Python008-Pandas%20GroupBy%20%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B.ipynb

GroupBy的结果，理解成拼块，后续操作是对每个块的批量处理

#### 接.apply()

.apply(lambda block: block.iloc[0, 0] + block.iloc[1, 0])) 等效df[行号：行号]

    # 数据合理性检查
    mask = rdf.groupby('code', as_index=False).apply(
        lambda block: True if block.iloc[-1]['volume'] < 0 else False)

    errordf = rdf.groupby('code', as_index=False).max()[mask]

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

#### 时间字段汇聚

##### 不用时间做索引 - groupby + rolling：df.rolling('2s').sum()

<https://blog.csdn.net/wj1066/article/details/78853717>

    df_from_db_grouped.groupby('stime').rolling(
        pd.Timedelta(str(to_period) + 'minutes'),
        min_periods=2).agg({
            'open': ['first'],
            'high': ['max'],
            'low': ['min'],
            'close': ['last'],
            'volume': ['sum']
        })

<https://stackoverflow.com/questions/15297053/how-can-i-divide-single-values-of-a-dataframe-by-monthly-averages>
<https://pandas.pydata.org/pandas-docs/stable/user_guide/groupby.html#groupby-transform-window-resample>
<https://stackoverflow.com/questions/15408156/resampling-with-custom-periods>

    df.groupby(lambda x: x.strftime('%Y%m'),
            group_keys=False).apply(to_dec1, np.mean)

    df_dti = df_from_db.groupby(
        pd.Grouper(key='stime',
                freq=str(to_period) + 'T')).agg({
                    'open': ['first'],
                    'high': ['max'],
                    'low': ['min'],
                    'close': ['last'],
                    'volume': ['sum']
                })  # .ohlc()

##### 用时间做索引 - resample + agg

    https://stackoverflow.com/questions/14861023/resampling-minute-data
    https://pandas.pydata.org/pandas-docs/stable/user_guide/cookbook.html?highlight=timegroup#resampling
    http://www.cocoachina.com/articles/98719

    https://blog.csdn.net/wangshuang1631/article/details/52314944
    DataFrame.agg函数 https://www.cjavapy.com/article/282/
      https://stackoverflow.com/questions/33637312/pandas-grouper-by-frequency-with-completeness-requirement
    https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.core.groupby.DataFrameGroupBy.resample.html?highlight=timegroup
    'B': lambda x: np.std(x, ddof=1)

```python

# .ohlc()
df_dti = df_from_db.set_index('stime').resample(
    pd.Timedelta(str(to_period) + 'minutes')).agg({
        'open': ['first'],
        'high': ['max'],
        'low': ['min'],
        'close': ['last'],
        'volume': ['sum']
    }).reset_index(drop=False)  # 原来的index变成数据列，保留
```

## pandas 的拼接

<https://www.cnblogs.com/keye/p/10791705.html> <https://blog.csdn.net/sc179/article/details/108169436>

Pandas包的merge、join、concat方法可以完成数据的合并和拼接。

    merge方法主要基于两个dataframe的共同列进行合并；

    join方法主要基于两个dataframe的索引进行合并；

    concat方法是对series或dataframe进行行拼接或列拼接。

### 1 merge方法

pandas的merge方法是基于共同列，将两个dataframe连接起来。merge方法的主要参数：

#### 1.1 内连接

how=‘inner’，on=设置连接的共有列名。

    # 单列的内连接
    import pandas as pd
    import numpy as np
    # 定义df1
    df1 = pd.DataFrame({'alpha':['A','B','B','C','D','E'],
                        'feature1':[1,1,2,3,3,1],
                        'feature2':['low','medium','medium','high','low','high']})
    # 定义df2
    df2 = pd.DataFrame({'alpha':['A','A','B','F'],
                        'pazham':['apple','orange','pine','pear'],
                        'kilo':['high','low','high','medium'],
                        'price':np.array([5,6,5,7])})
    # 基于共同列alpha的内连接
    df3 = pd.merge(df1,df2,how='inner',on='alpha')

    print(df1)
    print(df2)
    print(df3)

取共同列alpha值的交集进行连接。

#### 1.2 外连接

how=‘outer’，dataframe的链接方式为外连接，我们可以理解基于共同列的并集进行连接，参数on设置连接的共有列名。

    # 单列的外连接
    # 定义df1
    df1 = pd.DataFrame({'alpha':['A','B','B','C','D','E'],
                        'feature1':[1,1,2,3,3,1],
                        'feature2':['low','medium','medium','high','low','high']})
    # 定义df2
    df2 = pd.DataFrame({'alpha':['A','A','B','F'],
                        'pazham'['apple','orange','pine','pear'],
                        'kilo':['high','low','high','medium'],
                        'price':np.array([5,6,5,7])})
    # 基于共同列alpha的外连接
    df5 = pd.merge(df1,df2,how='outer',on='alpha')

    print(df1)
    print(df2)
    print(df5)

若两个dataframe间除了on设置的连接列外并无相同列，则该列的值置为NaN。

#### 1.3 左连接

how=‘left’，dataframe的链接方式为左连接，我们可以理解基于左边位置dataframe的列进行连接，参数on设置连接的共有列名。

    # 单列的左连接
    # 定义df1
    df1 = pd.DataFrame({'alpha':['A','B','B','C','D','E'],
                        'feature1':[1,1,2,3,3,1],
                        'feature2':['low','medium','medium','high','low','high']})
    # 定义df2
    df2 = pd.DataFrame({'alpha':['A','A','B','F'],
                        'pazham':['apple','orange','pine','pear'],
                        'kilo':['high','low','high','medium'],
                        'price':np.array([5,6,5,7])})
    # 基于共同列alpha的左连接
    df5 = pd.merge(df1,df2,how='left',on='alpha')

    print(df1)
    print(df2)
    print(df5)

因为df2的连接列alpha有两个’A’值，所以左连接的df5有两个’A’值，若两个dataframe间除了on设置的连接列外并无相同列，则该列的值置为NaN。

#### 1.4 右连接

how=‘right’，dataframe的链接方式为左连接，我们可以理解基于右边位置dataframe的列进行连接，参数on设置连接的共有列名。

    # 单列的右连接
    # 定义df1
    df1 = pd.DataFrame({'alpha':['A','B','B','C','D','E'],
                        'feature1':[1,1,2,3,3,1],
                        'feature2':['low','medium','medium','high','low','high']})
    # 定义df2
    df2 = pd.DataFrame({'alpha':['A','A','B','F'],
                        'pazham':['apple','orange','pine','pear'],
                        'kilo':['high','low','high','medium'],
                        'price':np.array([5,6,5,7])})
    # 基于共同列alpha的右连接
    df6 = pd.merge(df1,df2,how='right',on='alpha')

    print(df1)
    print(df2)
    print(df6)

因为df1的连接列alpha有两个’B’值，所以右连接的df6有两个’B’值。若两个dataframe间除了on设置的连接列外并无相同列，则该列的值置为NaN。

#### 1.5 基于多列的连接算法

多列连接的算法与单列连接一致，本节只介绍基于多列的内连接和右连接，读者可自己编码并按照本文给出的图解方式去理解外连接和左连接。

多列的内连接：

    # 多列的内连接
    # 定义df1
    df1 = pd.DataFrame({'alpha':['A','B','B','C','D','E'],
                        'beta':['a','a','b','c','c','e'],
                        'feature1':[1,1,2,3,3,1],
                        'feature2':['low','medium','medium','high','low','high']})
    # 定义df2
    df2 = pd.DataFrame({'alpha':['A','A','B','F'],
                        'beta':['d','d','b','f'],
                        'pazham':['apple','orange','pine','pear'],
                        'kilo':['high','low','high','medium'],
                        'price':np.array([5,6,5,7])})
    # 基于共同列alpha和beta的内连接
    df7 = pd.merge(df1,df2,on=['alpha','beta'],how='inner')

    print(df1)
    print(df2)
    print(df7)

多列的右连接：

    # 多列的右连接
    # 定义df1
    df1 = pd.DataFrame({'alpha':['A','B','B','C','D','E'],
                        'beta':['a','a','b','c','c','e'],
                        'feature1':[1,1,2,3,3,1],
                        'feature2':['low','medium','medium','high','low','high']})
    # 定义df2
    df2 = pd.DataFrame({'alpha':['A','A','B','F'],
                        'beta':['d','d','b','f'],
                        'pazham':['apple','orange','pine','pear'],
                        'kilo':['high','low','high','medium'],
                        'price':np.array([5,6,5,7])})

    # 基于共同列alpha和beta的右连接
    df8 = pd.merge(df1,df2,on=['alpha','beta'],how='right')

    print(df1)
    print(df2)
    print(df8)

#### 1.6 基于index的连接方法

前面介绍了基于column的连接方法，merge方法亦可基于index连接dataframe。

    # 基于column和index的右连接
    # 定义df1
    df1 = pd.DataFrame({'alpha':['A','B','B','C','D','E'],
                        'beta':['a','a','b','c','c','e'],
                        'feature1':[1,1,2,3,3,1],
                        'feature2':['low','medium','medium','high','low','high']})
    # 定义df2
    df2 = pd.DataFrame({'alpha':['A','A','B','F'],
                        'pazham':['apple','orange','pine','pear'],
                        'kilo':['high','low','high','medium'],
                        'price':np.array([5,6,5,7])},
                        index=['d','d','b','f'])

    # 基于df1的beta列和df2的index连接
    df9 = pd.merge(df1,df2,how='inner',left_on='beta',right_index=True)

    print(df1)
    print(df2)
    print(df9)

index和column的内连接方法：是df1列'beta'的第2个值'b'，匹配了df2的索引列第二个值'b'，则df9把这行拼接起来得到如下：

        alpha_x beta feature1 feature2 alpha_y pazham kilo price
    2         B    b        2  medium        B   pine high     5

可以设置参数suffixes，修改除连接列外 相同列的后缀名。

    # 基于df1的alpha列和df2的index内连接
    df9 = pd.merge(df1,df2,how='inner',left_on='beta',right_index=True,suffixes=('_df1','_df2'))
    print(df9)

### 2 join方法

join方法是基于index连接dataframe，merge方法是基于column连接，连接方法有内连接，外连接，左连接和右连接，与merge一致。

#### 2.1 index与index的连接

    df1 = pd.DataFrame({'key': ['K0', 'K1', 'K2', 'K3', 'K4', 'K5'],
                        'A': ['A0', 'A1', 'A2', 'A3', 'A4', 'A5']})
    df2 = pd.DataFrame({'key': ['K0', 'K1', 'K2'],
                        'B': ['B0', 'B1', 'B2']})

    # lsuffix和rsuffix设置连接的后缀名
    df3 = df1.join(df2,lsuffix='_caller', rsuffix='_other',how='inner')

    print(df1)
    print(df2)
    print(df3)

#### 2.2 join也可以基于列进行连接

    df1 = pd.DataFrame({'key': ['K0', 'K1', 'K2', 'K3', 'K4', 'K5'],
                        'A': ['A0', 'A1', 'A2', 'A3', 'A4', 'A5']})
    df2 = pd.DataFrame({'key': ['K0', 'K1', 'K2'],
                        'B': ['B0', 'B1', 'B2']})

    # 基于key列进行连接
    df3 = df1.set_index('key').join(df2.set_index('key'),how='inner')

    print(df1)
    print(df2)
    print(df3)

### 3 concat方法

concat方法是拼接函数，有行拼接和列拼接，默认是行拼接，拼接方法默认是外拼接（并集），拼接的对象是pandas数据类型。

#### 3.1 series类型的拼接方法

##### 行拼接

    df1 = pd.Series([1.1,2.2,3.3],index=['i1','i2','i3'])
    df2 = pd.Series([4.4,5.5,6.6],index=['i2','i3','i4'])
    print(df1)
    print(df2)

    # 行拼接
    df3 = pd.concat([df1,df2])

    print(df1)
    print(df2)
    print(df3)

行拼接若有相同的索引，为了区分索引，我们在最外层定义了索引的分组情况。

    # 对行拼接分组
    pd.concat([df1,df2],keys=['fea1','fea2'])

##### 列拼接

默认以并集的方式拼接：

    # 列拼接,默认是并集
    pd.concat([df1,df2],axis=1)

以交集的方式拼接：

    # 列拼接的内连接（交）
    pd.concat([df1,df2],axis=1,join='inner')

设置列拼接的列名：

    # 列拼接的内连接（交）
    pd.concat([df1,df2],axis=1,join='inner',keys=['fea1','fea2'])

对指定的索引拼接：

    # 指定索引[i1,i2,i3]的列拼接
    pd.concat([df1,df2],axis=1,join_axes=[['i1','i2','i3']])

#### 3.2 dataframe类型的拼接方法

##### 行拼接

    df1 = pd.DataFrame({'key': ['K0', 'K1', 'K2', 'K3', 'K4', 'K5'],
                        'A': ['A0', 'A1', 'A2', 'A3', 'A4', 'A5']})

    df2 = pd.DataFrame({'key': ['K0', 'K1', 'K2'],
                        'B': ['B0', 'B1', 'B2']})

    # 行拼接
    df3 = pd.concat([df1,df2])

    print(df1)
    print(df2)
    print(df3)

##### 列拼接

    # 列拼接
    pd.concat([df1,df2], axis=1)

若列拼接或行拼接有重复的列名和行名，则报错：

    # 判断是否有重复的列名，若有则报错
    pd.concat([df1,df2],axis=1,verify_integrity = True)

    ValueError: Indexes have overlapping values: ['key']

## DataFrame 大规模的数据拼接，用迭代器传递给concat()

拼接整理批量结果，普通的for循环速度太慢：

    for code, datadf in _datadf_dict.items():
        df = pd.concat([df, datadf.df],
                        ignore_index=True,
                        copy=False)

优化速度，用迭代器生成数据传递给concat()，这样的方式速度最快。

    参见 pd.append()说明文档 pandas\core\frame.py
    <https://cloud.tencent.com/developer/article/1640799>
    <https://zhuanlan.zhihu.com/p/29362983>

    dfs = pd.concat([
        pd.DataFrame(datadf.df, columns=datadf.df.columns)
        for code, datadf in _datadf_dict.items()
    ],
    ignore_index=True)

ignore_index = True 并不意味忽略index然后连接，而是指连接后再重新赋值index(len(index))。
如果两个df有重叠的索引还是可以自动合并的。

## pandas 优化

    https://pandas.pydata.org/pandas-docs/stable/user_guide/enhancingperf.html

    Pandas进阶之提升运行效率
        https://blog.csdn.net/yangsen99/article/details/94365243

    https://blog.csdn.net/BF02jgtRS00XKtCx/article/details/90092161
    http://www.pythontip.com/blog/post/12331/

## numpy 大数据量处理使用

pandas是对numpy的封装，如果有可能，根据特点进行数据分箱，尽量直接使用nump的矢量化方法是最快的解决办法。

    如何有效地使用numpy处理大规模数据
        https://blog.csdn.net/u014448054/article/details/100903405

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

### numpy ufunc 用法

用ufunc实现向量化操作，避免遍历数组跑for循环

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

## numpy常用

基础概念

    https://zhuanlan.zhihu.com/p/370945563

    np.shape 数组的秩 (x, y)
    np.s_[1:3，2:4] 截取 从1行3列开始 2行4列结束

    np.flatten() 降维转一维

    x.T 转置 .swapaxes .T的结果是将行变成列，列变成行

    numpy.reshape(2,3) (等价于ndarray.reshape) 转秩，reshape()修改的结果没有改变数据的先后顺序
    np.transpose()

    x.flat[[1,4]] = 1  将数组重组后的一维数组小标为1,4的元素变为1

    注意numpy自带方法和ndarray方法的区别：
    >>> a=np.array([[0,1],[2,3]])
    >>> np.resize(a,(2,3))
    >>> b = np.array([[0, 1], [2, 3]])
    >>> b.resize(2, 3)

    设置列名
    fws.dtype = [('第一列', 'float'), ('第二列', 'float'), ('第三列', 'float')]

### 生成全为指定值或全为空的ndarray

    np.ones(shape[, dtype, order]): 生成全为1的ndarray。
    np.zeros(shape[, dtype, order]): 生成全为0的ndarray。
    np.full((2, 3), 2)
    np.empty((2, 3))

### 生成指定范围值的ndarray

    array_o = np.arange(1, 10, 2)
    array_p = np.linspace(0, 20, 5, retstep=True)

arange(start, stop, step[, dtype]): 给定起始值、结束值(不包含结束值)和步长，生成指定范围的一维数组，效果相当于Python内置函数range()。

linspace(start, stop[, num, endpoint, retstep, dtype, axis]): 给定起始值、结束值，生成等间隔的一维数组。start表示数组的起始值。stop表示数组的终止值。num表示生成数组中的数据个数，默认为50。endpoint表示数组中是否包含stop值，默认为Ture。retstep表示是否返回数组的步长，默认为False。dtype表示ndarray中的数据类型。linspace()中的start或stop也可以传入形似array的数据，此时可生成二维数组。axis参数此时可以派上用场，表示将array_like的数据作为行还是作为列来生成二维数组，默认为0时作为行，如果为-1则作为列。

logspace(start, stop[, num, endpoint, base, dtype, axis]): 给定起始值、结束值，生成等间隔的一维数组，数据为对数函数log的值。base表示log函数的底数，默认为10。其他参数同linspace()。

### 生成随机值的ndarray

    array_s = np.random.randint(1, 10, 5)
    array_t = np.random.rand(5)
    array_u = np.random.uniform(size=5)
    array_v = np.random.randn(5)
    array_w = np.random.normal(10, 1, 5)

np.random.randint(low, high=None, size=None, dtype=None): 给定起始值、结束值(不包含结束值)和数据个数，从指定范围内生成指定个数(每次生成一个，共size次)的整数，组成一个一维数组。

np.random.rand(): 生成一个0到1(不包含1)之间的随机数，如果传入生成的数据个数，则生成一维数组，数组中的每个值都是0到1之间的随机数。

np.random.uniform(low=0.0, high=1.0, size=None): 给定起始值、结束值(不包含结束值)和数据个数，从指定范围内生成指定个数的小数，组成一维数组。默认同rand()。

这三个函数在生成随机数组时，数据范围内的每个数概率相等，数据是均匀分布的。

np.random.randn(): 按标准正太分布(均值为0，标准差为1)生成一个随机数。如果传入生成的数据个数，则生成一维数组。

np.random.normal(loc=0.0, scale=1.0, size=None): 给定均值、标准差和数据个数，按正太分布的概率生成指定个数的数，组成一个一维数组。

randn()和normal()函数生成的随机数组中，数据是正太分布的。

### np数组拼接

    # 级联
    np.concatenate()
    np.append()  # 默认先做了np.flatten()拉平为一维

    # 堆叠 增加一个维度
    np.stack()
        # 沿行堆叠
        np.hstack()
        # 沿列堆叠
        np.vstack()
        # 2维数组沿沿着第三轴（深度方向）堆叠
        np.dstack()

### np大规模的数据拼接，用迭代器传递给concatenate()

注意用迭代器生成数据传递给concatenate()，这样的方式速度最快

        ret_arr = np.concatenate([agg_func(larr) for larr in narr])

## numpy向量化

<https://www.cnblogs.com/hg-love-dfc/p/10290187.html>
<https://github.com/lijin-THU/notes-python>

### 向量化函数

#### 自定义sinc函数

    import numpy as np

    def sinc(x):
        if x == 0.0:
            return 1.0
        else:
            w = np.pi * x
            return np.sin(w) / w

可以作用于单个数值：如sinc(0)、sinc(3.0)；但是不能作用于数组x = np.array([1,2,3])；sinc(x) 报错

#### np.vectorize() 将函数 sinc 向量化，产生一个新的函数

注：np.vectorize()只是为了方便而不是为了性能，内部实现用的for循环
    <https://numpy.org/doc/stable/reference/generated/numpy.vectorize.html>

    x = np.array([1,2,3])
    vsinc = np.vectorize(sinc)
    vsinc(x)　　#作用是为 x 中的每一个值调用 sinc 函数
    import matplotlib.pyplot as plt
    %matplotlib inline

    x = np.linspace(-5,5,101)
    plt.plot(x, vsinc(x))

真正的向量化见下面 ufunc对象 章节

### 二元运算

（1）四则运算

    1 import numpy as np
    2 a = np.array([1,2])
    3 a * 3　　#数组与标量相乘，相当于数组的每个元素乘以这个标量
    4
    5 a = np.array([1,2])
    6 b = np.array([3,4])
    7 a * b　　#数组相乘，结果为逐个元素对应相乘
    8 np.multiply(a, b)　　#使用函数
    9 np.multiply(a, b, a)　　#如果有第三个参数，表示将结果存入第三个参数中

（2）比较和逻辑运算　　//大部分逻辑操作是逐个元素运算的，返回布尔数组

    1 a = np.array([[1,2,3,4],
    2               [2,3,4,5]])
    3 b = np.array([[1,2,5,4],
    4               [1,3,4,5]])
    5 a == b　　#等于操作是对应元素逐个进行比较的，返回的是等长的布尔数组

注：如果在条件中要判断两个数组是否一样时，不能直接使用 if a==b: 需要使用 if all(a==b):

对于浮点数，由于存在精度问题，使用函数 allclose 会更好 if allclose(a,b):

### ufunc对象

（1）Numpy有两种基本对象：ndarray (N-dimensional array object) 和 ufunc (universal function object)；ndarray 是存储单一数据类型的多维数组，而 ufunc 则是能够对数组进行处理的函数。例如，我们之前所接触到的二元操作符对应的 Numpy 函数，如 add，就是一种 ufunc 对象，它可以作用于数组的每个元素。

    import numpy as np
    a = np.array([0,1,2])
    b = np.array([2,3,4])
    np.add(a, b)　　#作用于每个元素，逐个元素相加，输出array([2, 4, 6])

注：大部分能够作用于数组的数学函数如三角函数等，都是 ufunc 对象

（2）可以查看ufunc对象支持的方法，如np.add对象：dir(np.add)

reduce方法：op.reduce(a)　　将操作opp沿着某个轴应用，使得数组 a 的维数降低一维；

    a = np.array([1,2,3,4])
    np.add.reduce(a)　　#add 作用到一维数组上相当于求和（降低一维）；输出10
    a = np.array([[1,2,3],[4,5,6]])
    np.add.reduce(a)　　#多维数组默认只按照第一维进行运算；输出array([5, 7, 9])
    np.add.reduce(a, 1)　　#指定维度，输出array([ 6, 15])
    a = np.array(['ab', 'cd', 'ef'], np.object)
    np.add.reduce(a)　　#作用于字符串，输出'abcdef'

    a = np.array([1,1,0,1])　　
    np.logical_and.reduce(a)　　#逻辑与，输出False
    np.logical_or.reduce(a)　　#逻辑或，输出True

accumulate方法op.accumulate(a)：保存reduce方法每一步结果所形成的数组

    a = np.array([1,2,3,4])
    np.add.accumulate(a)　　#array([1,3,6,10],dtype=int32)

    a = np.array(['ab', 'cd', 'ef'], np.object)
    np.add.accumulate(a)　　#array(['ab','abcd','abcdef'],dtype=object)

    a = np.array([1,1,0,1])
    np.logical_and.accumulate(a)　　#array([True, True, False, False])
    np.logical_or.accumulate(a)　　#array([True, True, True, True])

reduceat方法op.recuceat(a, indices)：将操作符运用到指定的下标上，返回一个与indices大小相同的数组

    a = np.array([0, 10, 20, 30, 40, 50])
    indices = np.array([1,4])
    np.add.reduceat(a, indices)　　#输出array([60, 90])
    # 60为从下标1（包括）到下标4（不包括）的运算结果；90位下标4（包括）到结尾的操作结果

outer方法op.outer(a,b)：对于 a 中每个元素，将 op 运用到它和 b 的每一个元素上所得到的结果（结果大小为a.size*b.size）

    a = np.array([0,1])
    b = np.array([1,2,3])

    # 操作顺序有区别
    np.add.outer(a, b)　　#array([[1,2,3],[2,3,4]])
    np.add.outer(b, a)　　#array([[1,2],[2,3],[3,4]])
     choose() 函数实现条件筛选（类似switch和case操作）

    import numpy as np

    control = np.array([[1,0,1],
                        [2,1,0],
                        [1,2,2]])

    # control控制元素的对应下标，将下标0、1、2的值分别映射为10,11,12
    np.choose(control, [10, 11, 12])

    # 结果和control大小相同，为

    array([[11, 10, 11],
        [12, 11, 10],
        [11, 12, 12]])

    i0 = np.array([[0,1,2],
                   [3,4,5],
                   [6,7,8]])

    i2 = np.array([[20,21,22],
                   [23,24,25],
                   [26,27,28]])

    control = np.array([[1,0,1],
                        [2,1,0],
                        [1,2,2]])

    # 根据choose中对应下标所在位置，映射为下标对应的数组的相应位置
    np.choose(control, [i0, 10, i2])　　# 0对应i0,1对应10,2对应i2

    输出：array([[10,  1, 10],
    　　    [23, 10,  5],
        　　 [10, 27, 28]])

    # 将数组中所有小于10的值变为10
    1 a = np.array([[ 0, 1, 2],
    2               [10,11,12],
    3               [20,21,22]])
    4 np.choose(a < 10, (a, 10))　　# True=1对应于10，False=0对应于数组a（选取相应位置的值）

    1 a = np.array([[ 0, 1, 2],
    2               [10,11,12],
    3               [20,21,22]])
    4
    5 lt = a < 10
    6 gt = a > 15
    7 # 将数组中所有小于 10 的值变成了 10，大于 15 的值变成了 15
    8 choice = lt + 2 * gt　　# 0对应a，1对应10，2对应15
    9 np.choose(choice, (a, 10, 15))

#### np.frompyfunc() 实现自定义ufunc对象

以求累积加和 Y=A*X+(1-A)*Y' 为例：

    #  一维数组求累积运算，指定公式，这是个递归运算
    # 无法使用functools.reduce()函数：
    #   1.中间值要保留，直接用只有最终结果。
    #   2. 公式Y=A*X+(1-A)*Y'，无法直接对应reduce的左为历史值右为当前值做参数，
    #   规避实现的话，需要在原数组前面再加个为0的元素，算完再删掉第一个结果
    # 自定义公式，所以没法直接用np.cumsum()（等价np.add.accumulate()）,df.agg_func()也受限 df.apply(np.cumsum)
    # https://docs.scipy.org/doc/numpy/reference/ufuncs.html#methods
    # https://docs.scipy.org/doc/numpy/reference/generated/numpy.ufunc.accumulate.html

    def _pyf(y, yp, al):
        return al * y + (1 - al) * yp

    # np.vectorize()只是为了方便而不是为了性能，内部实现用的for循环
    # https://numpy.org/doc/stable/reference/generated/numpy.vectorize.html
    # _ufc = np.vectorize(_pyf,otypes=[np.float])
    # ret = _ufc(nlist, nlist.shift(1), alpha)

    _ufc = np.frompyfunc(_pyf, 3, 1)
    # ret = _ufc.accumulate(nlist, dtype=np.object).astype(np.float)
    # ufunc函数对象本身还有一些方法函数如accumulate，
    # 本来用ufunc.accumulate()是最直观的，但是
    # 这些方法只有对两个输入、一个输出的ufunc函数有效，否则会抛出ValueError
    # 而且类型默认是object，这个处理起来慢于有实际类型的对象
    # https://stackoverflow.com/questions/13828599/generalized-cumulative-functions-in-numpy-scipy
    #    import numpy as np
    #    uadd = np.frompyfunc(lambda x, y: x + y, 2, 1)
    #    uadd.accumulate([1,2,3], dtype=np.object).astype(np.int)
    #    #array([1, 3, 6])

    # _ufc多于两个参数的调用只能用如下：
    ret = _ufc(nlist, nlist.shift(1), alpha).astype(np.float)  # ufc返回的居然是dtype=object

### 数组广播机制

    import numpy as np

    a = np.array([[ 0, 0, 0],
                  [10,10,10],
                  [20,20,20],
                  [30,30,30]])

    b = np.array([[ 0, 1, 2],
                  [ 0, 1, 2],
                  [ 0, 1, 2],
                  [ 0, 1, 2]])

    a + b　　# 正常加法

    b = np.array([0,1,2])　　# b为一维数组array([0,1,2])，shape为（3,）
    a + b　　# 将b扩展为先前的数组形状

    a = np.array([0,10,20,30])　　# 此时a.shape为（4，），a+b会由于维度不匹配报错

    ValueError: operands could not be broadcast together with shapes (4,) (3,)

    a.shape = 4,1　　# 等价于a= a[:, np.newaxis]，a为一维列向量array([[0],[10],[20],[30]])，shape为（4,1）

    a+b　　# 二者均自动扩展为最初数组形状

对于 Numpy 来说，维度匹配当且仅当：

维度相同
有一个的维度是1
匹配会从最后一维开始进行，直到某一个的维度全部匹配为止

    x = np.linspace(-.5,.5, 21)　　#(21,)
    y = x[:, np.newaxis]　　#(21,1)
    radius = np.sqrt(x ** 2 + y ** 2)　　# 因为y存在一维，所以自动扩展x、y为21*21
    import matplotlib.pyplot as plt
    %matplotlib inline

    plt.imshow(radius)
