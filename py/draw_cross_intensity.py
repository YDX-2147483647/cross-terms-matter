"""绘制随机相位例子中交叉项的消失过程"""

from pathlib import Path

import numpy as np
import polars as pl
from scipy.io import loadmat
from seaborn import lineplot

ROOT_DIR = Path(__file__).parent.parent

# %% Load data

mat = loadmat(ROOT_DIR / "matlab/data/cross_intensity.mat")

# 信号宽度
sigma: float = mat["sigma"].squeeze().item()
# 初始时间点数，也等于频率点数
n_time: int = mat["n_time"].squeeze().item()

# [#n_sample]
n_sample_list = mat["n_sample_list"].squeeze()
# [#repeat, #n_sample]
cross_intensity = mat["cross_intensity"]

assert n_sample_list.ndim == 1
assert cross_intensity.ndim == 2
assert cross_intensity.shape[1] == n_sample_list.shape[0]

data = pl.DataFrame(
    {
        "cross_intensity": cross_intensity.ravel(),
        "n_sample": np.broadcast_to(n_sample_list, cross_intensity.shape).ravel(),
    }
)

print(
    data.group_by("n_sample")
    .agg(
        [
            pl.all().mean().alias("mean"),
            (pl.all() ** 2).mean().sqrt().alias("root mean squared"),
            pl.all().std().alias("std"),
            pl.all().min().alias("min"),
            pl.all().max().alias("max"),
            pl.all().count().alias("count"),
        ]
    )
    .sort("n_sample")
)

# %% Plot

ax = lineplot(data, x="n_sample", y="cross_intensity", label="仿真")
ax.plot(
    n_sample_list,
    # - 互WVD幅度：`√2 σ`；
    # - MATLAB把瞬时自相关`fft`为WVD时，可能归一化有问题，倍数等于FFT点数，即`n_time`；
    # - 随机相位导致平方平均值除以`2 n_sample_list`；
    np.sqrt(2) * sigma * n_time / np.sqrt(2 * n_sample_list),
    label="理论",
    linestyle="--",
)
ax.set(
    xlabel="样本量",
    xscale="log",
    ylabel="交叉项的幅度",
    yscale="log",
)
ax.grid(which="major")
ax.grid(which="minor", alpha=0.2)
ax.legend()

ax.get_figure().savefig(ROOT_DIR / "fig/cross_intensity.png")
