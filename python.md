# python

## conda pip

首先切换到你的环境 venv/conda

conda 有很多频道，在网页版频道列表里有对应的版本，找合适自己的安装
注意不是名字对了就能装，版本不一定是新的！

    conda install -c conda-forge pyqtgraph

pip用之前先which pip 看看位置，防止不是你的环境的pip，用了就装到别的地方了

    yourenv/Scripts/pip.exe install pyqt5-tools~=5.15

<https://pypi.org/project/pyqt5-tools/>
The ~=5.15 specifies a release compatible with 5.15 which will be
the latest version of pyqt5-tools built for PyQt5 5.15.
If you are using a different PyQt5 version, specify it instead of 5.15.
