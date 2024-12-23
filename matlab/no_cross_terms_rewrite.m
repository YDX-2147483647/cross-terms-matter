%% 一个信号是确定信号，另一个信号是随机信号——利用Monte Carlo仿真去做
% 反复计算WVD太慢，改为提前算好分量，之后线性组合。

% 计算WVD用的样本量
n_sample_list = [1, 10, 100, 500, 1000, 2000, 5000];
% 测量交叉项时的重复次数
n_repeat = 100;

random_seed = 42;
% 每节使用前都重置随机数生成器。

%% 构造信号

t0 = 0.2; % 时间偏移
f0 = 50; % 频率偏移
t1 = 0.3;
f1 = 100;
fs = 1000; % 采样率
T = 1; % 信号持续时间
t = 0:1 / fs:T - 1 / fs; % 时间序列
sigma = 0.01 * sqrt(2 * pi);
x1 = exp(2 * pi * (- ((t - t0) / sigma) .^ 2/2 + 1i * f0 * (t - t0)));
x2 = exp(2 * pi * (- ((t - t1) / sigma) .^ 2/2 + 1i * f1 * (t - t1)));

%% 准备WVD分量

% 因MATLAB算法问题，这里统一用`xwvd`，并区分顺序。
% 1. `wvd(x)`与`xwvd(x, x)`、`xwvd(x, y)`与`conj(xwvd(y, x))`等有不是特别大但不容忽视的差别。
% 2. `xwvd`的文档中写的是第一个参数不共轭，第二个参数共轭，但实际似乎是反的。
% 3. 对于短的复信号，`xwvd`明显偏离双线性，例如`xwvd([1, 0, 0], [j, 0, 0]) - j * xwvd([1, 0, 0], [1, 0, 0])`均方根为 0.16。
%
% 在MATLAB运行以下命令可查看源代码。
%     edit wvd
%     edit signalwavelet.internal.wvd.wvdImpl
%     edit xwvd
%     edit signalwavelet.internal.wvd.xwvdImpl
% MATLAB会给WVD结果的时间上采样：自相关中，平均时刻可取半整数，时间差只取整数。
% 平均时刻为整数时，自相关用 x(t) x(t)' + x(t-1) x(t+1)' + …，然后直接`fft`存到`wvdMat`；
% 平均时刻为半整数时，自相关改用 x(t-1/2) x(t+1/2)' + …（这样宗量仍是整数）间接推测，用十几行才存进`wvdMat`。


wvd_1 = real(xwvd(x1, x1, fs));
wvd_2 = real(xwvd(x2, x2, fs));
wvd_12 = xwvd(x1, x2, fs);
[wvd_21, f, t] = xwvd(x2, x1, fs);

%% 验证计算误差足够小

c = 1 + 2j;

by_wvd = wvd(x1 + c * x2, fs);
by_xwvd = real(xwvd(x1 + c * x2, x1 + c * x2, fs));
by_composition = real(wvd_1 + abs(c) ^ 2 * wvd_2 + c * wvd_12 + conj(c) * wvd_21);

layout = tiledlayout("flow");
nexttile;
diverging_imagesc(t, f, by_wvd);
title("By “wvd”")
nexttile;
diverging_imagesc(t, f, by_xwvd);
title("By “xwvd”")
nexttile;
diverging_imagesc(t, f, by_composition);
title("By composition")
nexttile;
diverging_imagesc(t, f, by_composition - by_wvd);
title("Difference (by composition - by “wvd”)")

% layout.Children 还含 ColorBar，要去掉
axs = layout.Children(arrayfun(@(ax) isa(ax, 'matlab.graphics.axis.Axes'), layout.Children))';

linkaxes(axs)
axs(1).XLim = [0.15, 0.35];
axs(1).YLim = [20, 130];

for ax = axs
    xlabel(ax, "时间");
    ylabel(ax, "频率");
end

assert(max(abs(by_composition - by_xwvd), [], "all") < 1e-6);
fprintf("Max difference (by composition - by “wvd”): %.1f.\n", max(abs(by_composition - by_wvd), [], "all"));

%% 仿真Wigner分布

rng(random_seed);

tiledlayout("flow")

for n = n_sample_list
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

%% 仿真并测量交叉项强度——以交叉项时频中心为原点框定矩形区域
f_cross = (f0 + f1) / 2;
t_cross = (t0 + t1) / 2;

df_cross = 25;
dt_cross = 0.01;
f_cross_range = (f_cross + [-1, 1] * df_cross) / fs;
t_cross_range = (t_cross + [-1, 1] * dt_cross) / T;

f_cross_index_range = round(f_cross_range * length(f));
t_cross_index_range = round(t_cross_range * length(t));

%% 仿真并测量交叉项强度——为更准确，多次测量取平均
% （仿真Wigner分布不能多次测量取平均）

rng(random_seed);

% [#repeat, #n_sample]
cross_intensity = zeros(n_repeat, length(n_sample_list));

for i = 1:length(n_sample_list)
    n_sample = n_sample_list(i);
    fprintf("Simulating for %d samples.\n", n_sample);

    % [#repeat, #sample]
    c = exp(2j * pi * rand(n_repeat, n_sample));

    % c的函数对`n_sample`平均，形状本来是 [#repeat, -]；
    % `wvd_*`的形状是 [#f, #t]，
    % 为与之相乘，再进一步转换为 [#repeat, -, -]
    mean_abs_c_2 = reshape(mean(abs(c) .^ 2, 2), [n_repeat, 1, 1]);
    mean_c = reshape(mean(c, 2), [n_repeat, 1, 1]);
    mean_conj_c = reshape(mean(conj(c), 2), [n_repeat, 1, 1]);

    % d[#repeat, #f, #t] ⇐ ∑ c[#repeat, -, -] .* wvd_*[-, #f, #t]
    wvd_size = [1, size(wvd_1)];
    d = real( ...
        reshape(wvd_1, wvd_size) ...
        + mean_abs_c_2 .* reshape(wvd_2, wvd_size) ...
        + mean_c .* reshape(wvd_12, wvd_size) ...
        + mean_conj_c .* reshape(wvd_21, wvd_size) ...
    );

    % 截取交叉项所在区域
    % [#repeat, #f, #t]
    d = d(:, f_cross_index_range(1):f_cross_index_range(2), t_cross_index_range(1):t_cross_index_range(2));

    % max over [#f, #t]
    cross_intensity(:, i) = max(abs(d), [], [2, 3]);
end

save("data/cross_intensity.mat", "n_sample_list", "cross_intensity")

%% 仿真并测量交叉项强度——绘图

% See ../py/draw_cross_intensity.py

% mean/std over #repeat
mu = mean(cross_intensity, 1);
sigma = std(cross_intensity, 1);
loglog(n_sample_list, mu, "DisplayName", "μ");
hold on
loglog(n_sample_list, mu + sigma, "DisplayName", "μ + σ", "LineStyle", "--");
loglog(n_sample_list, mu - sigma, "DisplayName", "μ - σ", "LineStyle", "--");
hold off
grid
legend
xlabel("样本量")
ylabel("交叉项的幅度")
