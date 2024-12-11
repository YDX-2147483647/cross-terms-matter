import marimo

__generated_with = "0.9.30"
app = marimo.App(width="medium")


@app.cell(hide_code=True)
def __(mo):
    mo.md(r"""# 不含 g 的加速度""")
    return


@app.cell
def __():
    import marimo as mo
    return (mo,)


@app.cell
def __():
    import numpy as np
    return (np,)


@app.cell
def __():
    from matplotlib import pyplot as plt

    plt.rcParams["figure.constrained_layout.use"] = True
    plt.rcParams["image.aspect"] = "auto"
    return (plt,)


@app.cell
def __():
    import polars as pl
    return (pl,)


@app.cell
def __(__file__):
    from pathlib import Path

    ROOT_DIR = Path(__file__).parent.parent
    return Path, ROOT_DIR


@app.cell
def __(mo):
    should_save = mo.ui.checkbox(label="Save figures")
    should_save
    return (should_save,)


@app.cell
def __(ROOT_DIR, plt, should_save):
    fig_dir = ROOT_DIR / "fig"
    fig_dir.mkdir(exist_ok=True)


    def savefig(fig: plt.Figure, name: str) -> plt.Figure:
        if should_save.value:
            fig.savefig(fig_dir / f"g-{name}.png")
        return fig
    return fig_dir, savefig


@app.cell(hide_code=True)
def __(mo):
    mo.md(r"""## 读取数据""")
    return


@app.cell
def __(ROOT_DIR, pl):
    df = pl.read_csv(ROOT_DIR / "py/data/Raw Data.csv").select(
        [
            pl.col("Time (s)").alias("时间 / s"),
            pl.col("Linear Acceleration y (m/s^2)").alias("加速度 / (m/s²)"),
        ]
    )
    return (df,)


@app.cell
def __(df):
    df.plot.line(x="时间 / s", y="加速度 / (m/s²)")
    return


@app.cell
def __(df):
    df.get_column("时间 / s").diff().describe()
    return


@app.cell
def __(df, mo):
    fs = 1 / df.get_column("时间 / s").diff(null_behavior="drop").mean()  # Hz
    mo.md(f"标准差远小于均值，可认为采样均匀。\n\n采样率：{fs:.1f} Hz。")
    return (fs,)


@app.cell
def __(df):
    time = df.get_column("时间 / s")
    data = df.get_column("加速度 / (m/s²)")
    data.len()
    return data, time


@app.cell(hide_code=True)
def __(mo):
    mo.md(r"""## 频域""")
    return


@app.cell
def __():
    from scipy import signal
    return (signal,)


@app.cell(hide_code=True)
def __(data, fs, peak_freqs, plt, savefig, signal):
    _fig, _ax = plt.subplots()
    _ax.semilogy(*signal.periodogram(data, fs=fs), "+", label="原始")
    _ax.semilogy(
        *signal.welch(data, fs=fs, nfft=2 * data.len()), label="Welch平均"
    )
    _ax.set(
        xlabel=r"频率 / $\text{Hz}$",
        ylabel=r"加速度功率谱密度 / ($\left(\text{m} / \text{s}^2\right)^2 / \text{Hz})$",
        ylim=[1e-7, None],
    )
    _ax.grid()
    _ax.legend()

    for _i, _f in enumerate(peak_freqs):
        _ax.axvline(x=_f, color="red")
        _ax.text(
            x=_f + 5 * _i - 4.5,
            y=0.05 * (1 + 2 * _i),
            s=f"{_f:.1f} Hz",
            color="red",
        )

    savefig(_fig, "periodogram")
    return


@app.cell(hide_code=True)
def __(data, fs, pl, signal):
    _f, _p = signal.periodogram(data, fs=fs)
    _peaks, _props = signal.find_peaks(
        _p,
        height=1e-4,
        distance=1 / fs * data.len(),
        prominence=0.02,
    )
    peak_freqs = _f[_peaks]

    pl.concat(
        [
            pl.DataFrame({"频点号": _peaks, "频率 / Hz": peak_freqs}),
            pl.DataFrame(_props).rename(
                {"peak_heights": "功率谱密度 / ((m/s²)² / Hz)"}
            ),
        ],
        how="horizontal",
    )
    return (peak_freqs,)


@app.cell
def __(peak_freqs):
    assert peak_freqs.size == 2
    return


@app.cell(hide_code=True)
def __(data, fs, np, peak_freqs, plt, savefig, signal):
    _fig, _ax = plt.subplots()
    _ax.semilogy(*signal.periodogram(data, fs=fs), "+", label="原始")
    _ax.semilogy(
        *signal.welch(data, fs=fs, nfft=2 * data.len()), label="Welch平均"
    )
    _ax.set(
        xlabel=r"频率 / $\text{Hz}$",
        xlim=np.array([[2, -1], [-1, 2]] @ peak_freqs),
        ylabel=r"加速度功率谱密度 / ($\left(\text{m} / \text{s}^2\right)^2 / \text{Hz})$",
        ylim=[1e-7, None],
    )
    _ax.grid()
    _ax.legend()

    for _i, _f in enumerate(peak_freqs):
        _ax.axvline(x=_f, color="red")
        _ax.text(
            x=_f + 0.05,
            y=0.05 * (1 + 2 * _i),
            s=f"{_f:.2f} Hz",
            color="red",
        )

    savefig(_fig, "periodogram-zoom")
    return


@app.cell
def __(mo, peak_freqs):
    mo.md(f"拍频：{peak_freqs[1] - peak_freqs[0]:.2f} Hz")
    return


@app.cell(hide_code=True)
def __(mo):
    mo.md(r"""## 时域""")
    return


@app.cell
def __(data, plt, signal, time):
    _peaks, _props = signal.find_peaks(data, prominence=1, width=1)
    _times = time[_peaks]
    print(f"{1 / (_times[3:].mean() - _times[:3].mean()):.1f} Hz")

    plt.plot(time, data)
    for _t in _times:
        plt.axvline(x=_t, color="red")
    plt.grid()
    plt.gca()
    return


@app.cell(hide_code=True)
def __(mo):
    mo.md(r"""## STFT""")
    return


@app.cell
def __():
    from scipy.signal import ShortTimeFFT
    from scipy.signal.windows import gaussian
    return ShortTimeFFT, gaussian


@app.cell(hide_code=True)
def __(mo):
    win_std = mo.ui.radio(
        options={f"{t} s": t for t in [0.1, 0.3, 1]}, value="0.3 s", label="窗的σ"
    )
    win_std
    return (win_std,)


@app.cell(hide_code=True)
def __(
    Bbox,
    ShortTimeFFT,
    add_fancy_patch_around,
    data,
    fs,
    gaussian,
    np,
    peak_freqs,
    plt,
    savefig,
    time,
    win_std,
):
    _win = gaussian(int(6 * win_std.value * fs), std=win_std.value * fs, sym=True)
    _stft = ShortTimeFFT(_win, hop=2, fs=fs, scale_to="psd")
    _sx2 = _stft.spectrogram(data.to_numpy())

    _fig, _ax = plt.subplots()
    _ax.set(
        title=rf"|STFT|² 谱图（窗的 $σ = {win_std.value} \text{{ s}}$）",
        xlabel=time.name,
        xlim=(time[0], time[-1]),  # 忽略STFT扩充的部分
        ylabel="频率 / Hz",
        ylim=np.array([[3, -2], [-4, 5]]) @ peak_freqs,
    )
    _c = _ax.imshow(_sx2, origin="lower", extent=_stft.extent(data.len()))
    _fig.colorbar(_c)

    for _f in peak_freqs:
        add_fancy_patch_around(
            _ax,
            Bbox([[4.8, _f - 0.1], [12, _f + 0.1]]),
            boxstyle="round,pad=0.1",
            fill=False,
            edgecolor="red",
        )
        _ax.text(x=3, y=_f - 0.1, s=f"{_f:.1f} Hz", color="red")

    savefig(_fig, f"stft-spectrogram-{win_std.value}")
    return


@app.cell(hide_code=True)
def __(mo):
    mo.md(r"""## WVD""")
    return


@app.cell(hide_code=True)
def __(mo):
    mo.md(
        r"""
        查到以下若干实现。

        - ❌[`tftb.processing.cohen.WignerVilleDistribution(signal)` — pytftb 0.0.1 documentation](https://tftb.readthedocs.io/en/latest/apiref/tftb.processing.html#tftb.processing.cohen.WignerVilleDistribution)

            - 😦没有双倍上采样。
            - 😵要求信号点数是偶数。
            - 🐢用`for`循环计算自相关。
            - 💀从十年前维护到两年前。尽管在 scikit-signal 名下，但[未适配 SciPy v1.1 (#180)](https://github.com/scikit-signal/tftb/pull/180)。

        - ❓[`wigner(psi, xvec)` — QuTiP 5.0 Documentation](https://qutip.readthedocs.io/en/qutip-5.0.x/apidoc/functions.html#qutip.wigner.wigner)

            - 👍从十四年前维护至今。
            - 😦[首页](https://qutip.org/)表示“some features may not be available under Windows”。
            - 😦“QuTiP: Quantum Toolbox in Python”，只有一小部分是我们需要的。

        - ✅[`wignerdpy.wigner_distribution(x)` - ljbkusters/python-wigner-distribution (pywigner) - GitHub](https://github.com/ljbkusters/python-wigner-distribution)

            - 😦从三年前维护到去年。
            - 😃默认用解析信号。
            - 🐇向量化计算。
        """
    )
    return


@app.cell
def __():
    from wignerdpy import wigner_distribution
    return (wigner_distribution,)


@app.cell(hide_code=True)
def __():
    from matplotlib.patches import FancyBboxPatch
    from matplotlib.transforms import Bbox


    def add_fancy_patch_around(ax, bb, **kwargs):
        """
        https://matplotlib.org/stable/gallery/shapes_and_collections/fancybox_demo.html#parameters-for-modifying-the-box
        """
        kwargs = {
            "facecolor": (1, 0.8, 1, 0.5),
            "edgecolor": (1, 0.5, 1, 0.5),
            **kwargs,
        }
        fancy = FancyBboxPatch(bb.p0, bb.width, bb.height, **kwargs)
        ax.add_patch(fancy)
        return fancy
    return Bbox, FancyBboxPatch, add_fancy_patch_around


@app.cell
def __(data, fs, wigner_distribution):
    spec, spec_max_freq = wigner_distribution(data, sample_frequency=fs)

    assert spec.min() < 0
    max_spec = abs(spec).max()
    return max_spec, spec, spec_max_freq


@app.cell(hide_code=True)
def __(
    Bbox,
    add_fancy_patch_around,
    max_spec,
    np,
    peak_freqs,
    plt,
    savefig,
    spec,
    spec_max_freq,
    time,
):
    _fig, _ax = plt.subplots()
    _ax.set(
        title="WVD",
        xlabel=time.name,
        ylabel="频率 / Hz",
        ylim=np.array([[2, -1], [-1, 2]]) @ peak_freqs,
    )
    _c = _ax.imshow(
        spec,
        cmap="PiYG",
        vmin=-max_spec,
        vmax=max_spec,
        extent=(time[0], time[-1], 0, spec_max_freq),
    )
    _fig.colorbar(_c)

    for _f in peak_freqs:
        add_fancy_patch_around(
            _ax,
            Bbox([[4.8, _f - 0.1], [12, _f + 0.1]]),
            boxstyle="round,pad=0.1",
            fill=False,
            edgecolor="red",
        )
        _ax.text(x=3, y=_f - 0.1, s=f"{_f:.1f} Hz", color="red")

    savefig(_fig, "wvd-spectrogram")
    return


@app.cell(hide_code=True)
def __(
    data,
    max_spec,
    np,
    peak_freqs,
    plt,
    savefig,
    spec,
    spec_max_freq,
    time,
):
    _fig, _axs = plt.subplots(nrows=2, sharex=True, layout="constrained")

    _axs[0].set(
        title="WVD",
        ylabel="频率 / Hz",
        ylim=np.array([[1.5, -0.5], [-0.5, 1.5]]) @ peak_freqs,
    )
    _c = _axs[0].imshow(
        spec,
        cmap="PiYG",
        vmin=-max_spec,
        vmax=max_spec,
        extent=(time[0], time[-1], 0, spec_max_freq),
    )
    _fig.colorbar(_c)

    _axs[1].set(title="时域", ylabel=r"加速度 / ($\text{m/s^2}$)")
    _axs[1].plot(time, data, label="实测")
    _axs[1].plot(
        time,
        0.5 * np.sin(2 * np.pi * (peak_freqs[1] - peak_freqs[0]) / 2 * time - 1.2),
        label=f"{peak_freqs[1] - peak_freqs[0]:.2f} Hz 拍频",
        linestyle="dashed",
    )
    _axs[1].legend()

    for _ax in _axs:
        _ax.grid()
    _axs[-1].set(xlabel=time.name, xlim=(4.5, 8))

    savefig(_fig, "wvd-compare")
    return


if __name__ == "__main__":
    app.run()
