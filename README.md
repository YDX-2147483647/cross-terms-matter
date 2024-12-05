# Wigner–Ville分布中交叉项的意义——凭什么瞧不起交叉项 Cross Terms Matter

2024年11–12月“非平稳信号处理”大作业。

- [`doc/`](./doc/)

  这是个typst项目，主要[在 typst.app 编写](https://typst.app/project/ryphBqBZzGVrPAG73GgFBE)，此处仅作备份。

- [MATLAB](./matlab/)

  [`slanCM/`](./matlab/slanCM/)下载自 [200 colormap - File Exchange - MATLAB Central](https://www.mathworks.com/matlabcentral/fileexchange/120088-200-colormap)（v1.1.0，2023-04-01），它提供的`slanCM`函数支持 PiYG。需要把这个目录[加到搜索路径上](https://www.mathworks.com/help/matlab/ref/addpath.html)。

## 大纲

```
1 ✅问题的引入——第一节 意义

2 WVD可以没有交叉项

    2.1 回顾课上WVD定义，引出随机信号WVD的定义，
         两个确定信号分量的WVD，随机信号可以没有交叉项；
    2.2 构造的没有交叉项的随机信号，理论算一下期望是零，（时域图）
    2.3 四张图，交叉项有、若有若无、无、曲线图

3 交叉项的物理意义
    3.1 定性 自项没相位信息，互项有相位差信息；
    3.2 引理：互WVD的平移性质：时间和频率同时移动；
    3.3 用引理论证cos
    3.4 动图；钟表；
    3.5 检测弱信号

4 交叉项的几何特征
    振荡位置（Outer）；
    振荡方向；振荡疏密；


5 交叉项显现到时域
    先说拍频；
    动图；

6 意外发现
    谐振子薛定谔方程；
    词典；

感谢老师和同学批评指正！
```

