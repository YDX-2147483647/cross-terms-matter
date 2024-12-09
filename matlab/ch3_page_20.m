% Download `slanCM` from https://ww2.mathworks.cn/matlabcentral/fileexchange/120088-200-colormap

%%
T = 2;
Delta_f = 2;
fs = Delta_f * 5;
k = Delta_f / T;
dt = 1 / fs;
n = round(T / dt);
t1 = (-n:-1) * dt;
t2 = (0:n - 1) * dt;
f0 = k * T / 2;

st1 = exp(- 1i * pi * k * t1 .^ 2) .* exp(1i * 2 * pi * f0 * t1);
st2 = exp(1i * pi * k * t2 .^ 2) .* exp(1i * 2 * pi * f0 * t2);

NN = 5;
sig = zeros(length(st1) + length(st2), NN);

for ii = 1:NN
    sig(1:length(st1), ii) = st1;
    sig(length(st1) + 1:end, ii) = st2;
end

sig = sig(:);

%%
n_sig = length(sig);
t = (0:n_sig - 1) * dt;
figure
plot(t, real(sig))
xlabel('时间（s）'); ylabel('幅度');
title('信号的波形');
df = fs / n_sig;
f_sig = ((0:n_sig - 1) - n_sig / 2) * df;
sig_fft = fftshift(fft(sig));
figure
plot(f_sig, abs(sig_fft));
xlabel('频率（Hz）'); ylabel('幅度');
title('信号的频谱');

%%
[sig_spwvd, F, T] = wvd(sig, fs, 'smoothedPseudo');
figure;
imagesc(T, F, sig_spwvd);
xlabel('$t$', 'interpreter', 'latex')
ylabel('$f$', 'interpreter', 'latex')
colorbar
title('SPWVD');

%%
[sig_wvd, F, T] = wvd(sig, fs);

tiledlayout(2, 1);
color_range = max(abs(sig_wvd), [], "all");

ax1 = nexttile;
imagesc(T, F, abs(sig_wvd), [-1, 1] * color_range);
xlabel('$t$', 'interpreter', 'latex')
ylabel('$f$', 'interpreter', 'latex')
colorbar
colormap(slanCM("PiYG"))
title('WVD (abs)');

ax2 = nexttile;
imagesc(T, F, sig_wvd, [-1, 1] * color_range);
xlabel('$t$', 'interpreter', 'latex')
ylabel('$f$', 'interpreter', 'latex')
colorbar
colormap(slanCM("PiYG"))
title('WVD');

linkaxes([ax1, ax2], "xy");

%%
sig_scf = abs(fftshift(fft(sig_wvd, n_sig * 2, 2), 2));
alpha = ((0:n_sig - 1) - n_sig / 2) * fs / (n_sig * 2);
figure;
imagesc(alpha, F, sig_scf(:, n_sig / 2 + 1:n_sig + n_sig / 2));
xlabel('$\alpha$', 'interpreter', 'latex')
ylabel('$f$', 'interpreter', 'latex')
title('SCF');
