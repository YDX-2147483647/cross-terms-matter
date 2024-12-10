# Wigner–Ville分布中交叉项的意义——凭什么瞧不起交叉项 Cross Terms Matter

2024年11–12月“非平稳信号处理”大作业。

- [`doc/`](./doc/)

  这是个typst项目，主要[在 typst.app 编写](https://typst.app/project/ryphBqBZzGVrPAG73GgFBE)，此处仅作备份。

  <details>
  <summary>大纲</summary>

  - 0 问题的引入——第一节 意义

  - 1 WVD可以没有交叉项

      - 回顾课上WVD定义，引出随机信号WVD的定义；两个确定信号分量的WVD，随机信号可以没有交叉项
      - 构造的没有交叉项的随机信号，理论算一下期望是零，（时域图）
      - 四张图，交叉项有、若有若无、无、曲线图

  - 2 交叉项的物理意义

      - 定性 自项没相位信息，互项有相位差信息；
      - 引理：互WVD的平移性质：时间和频率同时移动；
      - 用引理论证cos
      - 动图；钟表；
      - 检测弱信号

  - 3 交叉项的几何特征

      - 振荡位置（Outer）；
      - 振荡方向；振荡疏密；

  - 4 交叉项显现到时域

      - 先说拍频；
      - 动图；

  - ∞ 意外发现

      - 谐振子薛定谔方程；
      - 词典；

  - 感谢老师和同学批评指正！

  </details>

- [MATLAB](./matlab/)

  [`slanCM/`](./matlab/slanCM/)下载自 [200 colormap - File Exchange - MATLAB Central](https://www.mathworks.com/matlabcentral/fileexchange/120088-200-colormap)（v1.1.0，2023-04-01），它提供的`slanCM`函数支持 PiYG。需要把这个目录[加到搜索路径上](https://www.mathworks.com/help/matlab/ref/addpath.html)。

- [Python](./py/)

  [安装 uv](https://docs.astral.sh/uv/getting-started/installation/)，然后运行：

    ```shell
    $ cd ./py/

    # 绘制随机相位例子中交叉项的消失过程（fig/cross_intensity.png）
    $ uv run draw_cross_intensity.py

    # 不含g的加速度
    $ uv run marimo edit g.py
    ```

    （uv 会自动创建虚拟环境，安装各种包。）
