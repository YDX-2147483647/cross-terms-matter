%% 仿真一种没有交叉项的情况
% x(t)=c1x1(t)+c2x2(t)
% c1是常系数;
% x1(t)是确定信号;
% c2是一个随机变量,c2=exp(j*theta);theta在[0,2pi]服从均匀分布;
% x2(t)是确知信号;

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

%% 两个信号都是高斯包络的确定信号
[tfr, fx, tx] = wvd(x1 + x2, fs);
figure(1);
color_range = max(abs(tfr), [], "all");
imagesc(tx, fx, tfr, [-1, 1] * color_range);
colorbar
colormap(slanCM("PiYG"))
box on;
set(gca, 'LineWidth', 2);
xlabel('时间 (秒)');
ylabel('频率 (Hz)');
xlim([0.15 0.35]);
ylim([20 130]);
title('利用积分的定义求信号的WVD');
set(gca, 'FontName', 'Microsoft YaHei', 'FontSize', 14, 'FontWeight', 'bold'); % 字体设置
set(gca, 'XGrid', 'on', 'YGrid', 'on', ... % 坐标轴
    'GridAlpha', 0.2);
pictureSize = [200, 200, 800, 600];
set(gcf, 'Position', pictureSize) % 设置图片出现的位置
% imagesc(tx, fx, tfr);
% xlabel('时间 (秒)');
% ylabel('频率 (Hz)');
% title('两个信号都是高斯包络的确定信号时的WVD');
% xlim([0.15 0.35]);
% ylim([20 130]);
% colorbar;

%% 一个信号是确定信号，另一个信号是随机信号——利用积分的定义做
c1 = 1; % 系数c1的振幅，其相位为0
c2 = 1; % 系数c2的振幅
N = 5; % 概率密度函数区间划分大小
sum = 0; % 用于求信号的期望
m = 0;

for n = 1:N
    d_theta = 2 * pi / N;
    i_theta = (n - 1) * d_theta;
    x = c1 * x1 + c2 * exp(1i * i_theta) * x2;
    [tfr, fx, tx] = wvd(x, fs);
    sum = sum + tfr;
    % m = m + exp(1i * i_theta);
end

sum = sum / (2 * pi);
figure(2);
color_range = max(abs(sum), [], "all");
imagesc(tx, fx, sum, [-1, 1] * color_range);
colorbar
colormap(slanCM("PiYG"))
box on;
set(gca, 'LineWidth', 2);
xlabel('时间 (秒)');
ylabel('频率 (Hz)');
xlim([0.15 0.35]);
ylim([20 130]);
title('利用积分的定义求信号的WVD');
set(gca, 'FontName', 'Microsoft YaHei', 'FontSize', 14, 'FontWeight', 'bold'); % 字体设置
set(gca, 'XGrid', 'on', 'YGrid', 'on', ... % 坐标轴
    'GridAlpha', 0.2);
pictureSize = [200, 200, 800, 600];
set(gcf, 'Position', pictureSize) % 设置图片出现的位置

%% 一个信号是确定信号，另一个信号是随机信号——利用Monte Carlo仿真去做
N_list = [10, 100, 500, 1000, 2000]; % 随机生成的样本数量分别进行
WVD_MonteCarlo = cell(length(N_list), 2); % 储存仿真结果
Cross_max_value = zeros(1, length(N_list));
tf = cell(2, 1);

% 以交叉项时频中心为原点框定矩形区域
f_cross = (f0 + f1) / 2;
t_cross = (t0 + t1) / 2;
df_cross = 25;
dt_cross = 0.01;
f_cross_min = (f_cross - df_cross) / fs;
f_cross_max = (f_cross + df_cross) / fs;
t_cross_min = (t_cross - dt_cross) / T;
t_cross_max = (t_cross + dt_cross) / T;

for i = 1:length(N_list)
    Nl = N_list(1, i);
    WVD_MonteCarlo{i, 1} = Nl;
    % Nl=1000;
    theta = 2 * pi * rand(1, Nl); % 在[0,2pi]服从均匀分布随机生成10个数

    sum = 0;

    for nl = 1:Nl
        x = c1 * x1 + c2 * exp(1i * theta(1, nl)) * x2;
        [tfr, fx, tx] = wvd(x, fs);
        sum = sum + tfr;
    end

    sum = sum / Nl;
    WVD_MonteCarlo{i, 2} = sum;
    % 求取交叉项的最大值
    % 框定的矩形区域：
    f_cross_start = round(f_cross_min * length(fx));
    f_cross_end = round(f_cross_max * length(fx));
    t_cross_start = round(t_cross_min * length(tx));
    t_cross_end = round(t_cross_max * length(tx));
    Cross_terms = sum(f_cross_start:f_cross_end, t_cross_start:t_cross_end);
    Cross_max_value(1, i) = max(abs(Cross_terms), [], "all");

    figure;
    color_range = max(abs(sum), [], "all");
    imagesc(tx, fx, sum, [-1, 1] * color_range);
    colorbar
    colormap(slanCM("PiYG"))
    xlabel('时间 (秒)');
    ylabel('频率 (Hz)');
    title(strcat("样本数量：", num2str(Nl)));
    xlim([0.15 0.35]);
    ylim([20 130]);
end

tf{1, 1} = tx;
tf{2, 1} = fx;

% 保存Monte Carlo仿真结果
save("data/WVD_MonteCarlo.mat", "WVD_MonteCarlo");
save("data/Cross_max_value.mat", "Cross_max_value");
save("data/tf.mat", "tf");

%% 再次加载数据进行绘制图像
tf = load("data/tf.mat").tf; % 时间轴和频率轴
WVD_MonteCarlo = load("data/WVD_MonteCarlo.mat").WVD_MonteCarlo; % 样本数量和WVD
Cross_max_value = load("data/Cross_max_value.mat").Cross_max_value; % 交叉项最大值
Nl = length(WVD_MonteCarlo);
Sample_num = zeros(1, Nl);

for nl = 1:Nl
    Sample_num(1, nl) = WVD_MonteCarlo{nl, 1};
    sum = WVD_MonteCarlo{nl, 2};
    tx = tf{1, 1};
    fx = tf{2, 1};
    figure;
    color_range = max(abs(sum), [], "all");
    imagesc(tx, fx, sum, [-1, 1] * color_range);
    colorbar
    colormap(slanCM("PiYG"))
    box on;
    set(gca, 'LineWidth', 2);

    xlabel('时间 (s)');
    ylabel('频率 (Hz)');
    title(strcat("样本数量：", num2str(WVD_MonteCarlo{nl, 1})));
    xlim([0.15 0.35]);
    ylim([20 130]);
    set(gca, 'FontName', 'Microsoft YaHei', 'FontSize', 14, 'FontWeight', 'bold'); % 字体设置
    set(gca, 'XGrid', 'on', 'YGrid', 'on', ... % 坐标轴
        'GridAlpha', 0.2);
    pictureSize = [200, 200, 800, 600];
    set(gcf, 'Position', pictureSize) % 设置图片出现的位置

end

% 绘制交叉项最大值与样本数量曲线
figure;
p1 = plot(log10(Sample_num), log10(Cross_max_value));
set(p1, 'LineWidth', 2, 'Color', 'b', 'LineStyle', '-', 'Marker', 'v', 'MarkerIndices', 1:1:N);
box on;
set(gca, 'LineWidth', 2);
xlabel('样本数量 (log_1_0)');
ylabel('交叉项最大模值 (log_1_0)');
set(gca, 'FontName', 'Microsoft YaHei', 'FontSize', 14, 'FontWeight', 'bold'); % 字体设置
set(gca, 'XGrid', 'on', 'YGrid', 'on', ... % 坐标轴
    'GridAlpha', 0.2);
pictureSize = [200, 200, 800, 600];
set(gcf, 'Position', pictureSize) % 设置图片出现的位置
