% --- Complete EMD demo with all IMFs plotted ---

clear; clc; close all;

% Load ECG data
load('m103.mat');  % assumes variable 'val'

Fs = 360;
T = 10;
ecg_sig = val(1:T*Fs) - 1024;

% Add noise (SNR = 10 dB)
sig_power = var(ecg_sig);
SNR = 10;
noise_std = sqrt(sig_power / (10^(SNR/10)));
ecg_noisy = ecg_sig + noise_std * randn(size(ecg_sig));

t = linspace(0, T, length(ecg_noisy));

% Run EMD decomposition (make sure emd.m is on path)
[imf] = emd(ecg_noisy);

% Plot all IMFs
figure('Name','All IMFs from EMD','NumberTitle','off');
num_imfs = size(imf, 1);
for k = 1:num_imfs
    subplot(num_imfs,1,k);
    plot(t, imf(k,:));
    ylabel(['IMF ', num2str(k)]);
    if k == 1
        title('Intrinsic Mode Functions (IMFs)');
    end
    if k < num_imfs
        set(gca, 'XTickLabel', []);
    else
        xlabel('Time (seconds)');
    end
end

% Assume you already have:
% imf = [IMFs from emd]
% ecg_noisy = original noisy signal
% t = time vector

% Number of IMFs to remove (usually first 1 or 2 contain noise)
num_noisy_imfs = 2;

% Reconstruct the denoised signal by summing IMFs except first noisy ones
ecg_denoised = sum(imf(num_noisy_imfs+1:end, :), 1);

% Plot noisy vs denoised signals
figure;
subplot(3,1,1);
plot(t, ecg_noisy);
title('Noisy ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, ecg_denoised);
title(['Denoised ECG Signal (Removed first ', num2str(num_noisy_imfs), ' IMFs)']);
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(t, ecg_sig);
title('Original Clean ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

