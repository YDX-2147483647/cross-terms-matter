"""绘制随机相位例子中交叉项的消失过程"""

from pathlib import Path

import numpy as np
import polars as pl
from scipy.io import loadmat
from seaborn import lineplot

ROOT_DIR = Path(__file__).parent.parent

# %% Load data

mat = loadmat(ROOT_DIR / "matlab/data/cross_intensity.mat")

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
# TODO：这理论的系数还有问题
ax.plot(n_sample_list, 1 / np.sqrt(n_sample_list), label="理论", linestyle="--")
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
