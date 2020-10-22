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
