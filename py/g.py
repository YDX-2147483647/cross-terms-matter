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
    return (plt,)


@app.cell
def __():
    import polars as pl
    return (pl,)


@app.cell
def __(pl):
    df = pl.read_csv("data/Raw Data.csv").select(
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
def __(data, fs, peak_freqs, plt, signal):
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


    _fig
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
def __(data, fs, np, peak_freqs, plt, signal):
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


    _fig
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
    ShortTimeFFT,
    data,
    fs,
    gaussian,
    np,
    peak_freqs,
    plt,
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
    _c = _ax.imshow(
        _sx2,
        origin="lower",
        aspect="auto",
        extent=_stft.extent(data.len()),
    )
    _fig.colorbar(_c)

    for _f in peak_freqs:
        _ax.axhline(y=_f, color="red", linestyle="dashed")
        _ax.text(x=1, y=_f + 0.1, s=f"{_f:.1f} Hz", color="red")

    _fig
    return


if __name__ == "__main__":
    app.run()
