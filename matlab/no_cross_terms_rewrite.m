%% 一个信号是确定信号，另一个信号是随机信号——利用Monte Carlo仿真去做
% 反复计算WVD太慢，改为提前算好分量，之后线性组合。

%% 构造信号

t0 = 0.2; % 时间偏移
f0 = 50; % 频率偏移
t1 = 0.3;
f1 = 100;
fs = 1000; % 采样率
T = 1; % 信号持续时间
t = 0:1 / fs:T - 1 / fs; % 时间序列
sigma = 0.01;
x1 = exp(- (t - t0) .^ 2 / (2 * sigma ^ 2)) .* exp(1i * 2 * pi * f0 * (t - t0));
x2 = exp(- (t - t1) .^ 2 / (2 * sigma ^ 2)) .* exp(1i * 2 * pi * f1 * (t - t1));

%% 准备WVD分量

% 因MATLAB算法问题，这里统一用`xwvd`，并区分顺序。
% 1. `wvd(x)`与`xwvd(x, x)`、`xwvd(x, y)`与`conj(xwvd(y, x))`等有不是特别大但不容忽视的差别。
% 2. `xwvd`的文档中写的是第一个参数不共轭，第二个参数共轭，但实际似乎是反的。
% 3. 对于短的复信号，`xwvd`明显偏离双线性，例如`xwvd([1, 0, 0], [j, 0, 0]) - j * xwvd([1, 0, 0], [1, 0, 0])`均方根为 0.16。

wvd_1 = real(xwvd(x1, x1, fs));
wvd_2 = real(xwvd(x2, x2, fs));
wvd_12 = xwvd(x1, x2, fs);
[wvd_21, f, t] = xwvd(x2, x1, fs);

%% 验证计算误差足够小

c = 1 + 2j;
difference = real(xwvd(x1 + c * x2, x1 + c * x2, fs)) - real( ...
    wvd_1 + abs(c) ^ 2 * wvd_2 + c * wvd_12 + conj(c) * wvd_21 ...
);
diverging_imagesc(t, f, difference);

assert(max(abs(difference), [], "all") < 1e-6);

%% 仿真

rng(42);

n_samples_list = [10, 100, 500, 1000, 2000, 5000];

tiledlayout("flow")
for n = n_samples_list
    c = exp(2j * pi * rand(1, n));
    d_mean = real(wvd_1 + mean(abs(c) .^ 2) * wvd_2 + mean(c) * wvd_12 + mean(conj(c)) * wvd_21);
    
    nexttile;
    diverging_imagesc(t, f, d_mean);
    title(sprintf("%d samples", n))
    % 可能不用标单位？这样暗示有一般性？
    xlabel('时间');
    ylabel('频率');
    xlim([0.15, 0.35]);
    ylim([20 130]);
end
