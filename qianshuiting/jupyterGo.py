# -*- coding: utf-8 -*-
'test under py3 ok'

import numpy as np
import pandas as pd

# import matplotlib as mpl
import matplotlib.pyplot as plt


def helloGo():
    x = np.linspace(0, 20, 100)
    plt.plot(x, np.sin(x))
    plt.show()

    x = np.arange(0, 5, 0.1)
    y = np.sin(x)
    plt.plot(x, y)
    plt.show()


################################################################
# https://blog.csdn.net/youmayangguang/article/details/53609919


def xGo():
    df = pd.DataFrame(np.random.randn(10, 6))
    # Make a few areas have NaN values
    df.iloc[1:3, 1] = np.nan
    df.iloc[5, 3] = np.nan
    df.iloc[7:9, 5] = np.nan
    df[df.isnull().values == True]


################################################################
if __name__ == '__main__':
    pass
