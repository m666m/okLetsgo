
# okLetsgo
https://github.com/watching

https://stackoverflow.com/search?q=plotitem
https://www.runoob.com/python3/python3-built-in-functions.html
https://www.liaoxuefeng.com/wiki/1016959663602400/1017628290184064
www.xdbcb8.com/archives/1550.html

http://strftime.org/
https://docs.python.org/zh-cn/3/library/datetime.html#strftime-strptime-behavior
https://docs.python.org/zh-cn/3.7/library/multiprocessing.html

http://www.pyqtgraph.org/documentation/graphicsItems/plotitem.html
https://doc-snapshots.qt.io/4.8/qsplitter.html

https://docs.scipy.org/doc/numpy/user/quickstart.html
https://docs.scipy.org/doc/scipy/reference/index.html
http://pandas.pydata.org/pandas-docs/stable/reference/frame.html
https://matplotlib.org/tutorials/index.html
http://www.statsmodels.org/stable/regression.html

https://scratch.mit.edu/projects/editor/?tutorial=getStarted


Python社区以NumPy和SciPy为基石，pandas和statsmodels支撑起Python数据分析的大业。pandas提供数据清洗与整理功能，statsmodels则提供了比较完整的计量与统计分析的功能。这与百花齐放的R社区不同，Python数据分析相关的包更为统一。Python做数据分析时，主要计量与统计分析模块都指望这个包呢。Seaborn作为一个带着定制主题和高级界面控制的Matplotlib扩展包，能让绘图变得更轻松.Seaborn将matplotlib参数分成两个独立的组。第一组设定了美学风格，第二组则是不同的度量元素，这样就可以很容易地添加到代码当中了。
用Scipy的scipy.stats中的统计函数分析随机数
1 求出考试分数的以下值：

均值          中位数       众数        极差          方差  
标准差        变异系数(均值/方差)       偏度          峰度

def calStatValue(score):
    #集中趋势度量
    print('均值')
    print(np.mean(score))
    print('中位数')
    print(np.median(score))
    print('众数')
    print(stats.mode(score))
    #离散趋势度量
    print('极差')
    print(np.ptp(score))
    print('方差')
    print(np.var(score))
    print('标准差')
    print(np.std(score))
    print('变异系数')
    print(np.mean(score)/np.std(score))
    #偏度与峰度的度量
    (skewness,pvalue1)
    =
    stats.skewtest(score)
    print('偏度')
    print(stats.skewness(score))
    (Kurtosistest,pvalue2)
    =
    stats.kurtosistest(arr)
    print('峰度')
    print(stats.Kurtosis(score))
    return
