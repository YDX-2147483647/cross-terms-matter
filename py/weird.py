import marimo

__generated_with = "0.9.30"
app = marimo.App(width="medium")


@app.cell
def __():
    from matplotlib import pyplot as plt
    from numpy.fft import fft, fftshift
    return fft, fftshift, plt


@app.cell
def __():
    from wignerdpy import wigner_distribution
    return (wigner_distribution,)


@app.cell
def __(__file__):
    from pathlib import Path
    from scipy.io import loadmat

    data = loadmat(Path(__file__).parent / "data/weird.mat")["target"].squeeze()
    data.shape
    return Path, data, loadmat


@app.cell
def __(data):
    data.shape, data.dtype
    return


@app.cell
def __(data, wigner_distribution):
    spec, spec_max_freq = wigner_distribution(data, use_analytic=False)
    return spec, spec_max_freq


@app.cell
def __(spec):
    spec.max()
    return


@app.cell
def __(spec):
    max_spec = abs(spec).max()
    max_spec
    return (max_spec,)


@app.cell
def __(data, fft, plt):
    plt.plot(abs(fft(data)))
    return


@app.cell(hide_code=True)
def __(data, fftshift, max_spec, plt, spec, spec_max_freq):
    _fig, _ax = plt.subplots()
    _ax.set(
        title="WVD",
        xlabel="时间",
        ylabel="频率",
    )
    _c = _ax.imshow(
        fftshift(spec, axes=0),
        cmap="PiYG",
        aspect="auto",
        vmin=-max_spec,
        vmax=max_spec,
        extent=(0, data.size, -spec_max_freq / 2, spec_max_freq / 2),
    )
    _fig.colorbar(_c)
    _fig
    return


@app.cell
def __(data, fftshift, max_spec, plt, spec, spec_max_freq):
    _fig, _ax = plt.subplots()
    _ax.set(
        title="WVD",
        xlabel="时间",
        ylabel="频率",
        ylim=(-30, -20),
        xlim=(240, 300),
    )
    _c = _ax.imshow(
        fftshift(spec, axes=0),
        cmap="PiYG",
        aspect="auto",
        vmin=-max_spec,
        vmax=max_spec,
        extent=(0, data.size, -spec_max_freq / 2, spec_max_freq / 2),
    )
    _fig.colorbar(_c)
    _fig
    return


if __name__ == "__main__":
    app.run()
