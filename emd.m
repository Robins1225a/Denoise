function [imf] = emd(x)
% EMD - Empirical Mode Decomposition (adaptive IMF count)
%   [imf] = emd(x)
%
% Input:
%   x   : 1D input signal
% Output:
%   imf : matrix of IMFs (each row is one IMF)

x = x(:)';       % Ensure row vector
N = length(x);
imf = [];

residue = x;

while true
    h = residue;
    SD = 1;
    iter = 0;
    max_sift_iter = 100;

    while SD > 0.1 && iter < max_sift_iter
        iter = iter + 1;

        [max_peaks, max_locs] = findpeaks(h);
        [min_peaks, min_locs] = findpeaks(-h);
        min_peaks = -min_peaks;

        if length(max_locs) + length(min_locs) < 3
            break;
        end

        env_upper = interp1(max_locs, max_peaks, 1:N, 'spline');
        env_lower = interp1(min_locs, min_peaks, 1:N, 'spline');

        env_upper = fillnan(env_upper);
        env_lower = fillnan(env_lower);

        m = (env_upper + env_lower) / 2;
        h1 = h - m;

        eps = 1e-10;
        SD = sum((h - h1).^2) / (sum(h.^2) + eps);

        h = h1;
    end

    imf = [imf; h];
    residue = residue - h;

    if ismonotonic(residue) || std(residue) < 0.01 * std(x)
        break;
    end
end

end

% --------- Helper functions -----------

function y = fillnan(x)
nan_idx = isnan(x);
if any(nan_idx)
    not_nan_idx = find(~nan_idx);
    y = x;
    if nan_idx(1)
        y(1:not_nan_idx(1)-1) = x(not_nan_idx(1));
    end
    if nan_idx(end)
        y(not_nan_idx(end)+1:end) = x(not_nan_idx(end));
    end
    nan_groups = bwlabel(nan_idx);
    for k = unique(nan_groups)'
        if k == 0, continue; end
        group_idx = find(nan_groups == k);
        left = group_idx(1) - 1;
        right = group_idx(end) + 1;
        if left < 1 || right > length(x)
            continue;
        end
        y(group_idx) = linspace(x(left), x(right), length(group_idx));
    end
else
    y = x;
end
end

function flag = ismonotonic(x)
flag = all(diff(x) >= 0) || all(diff(x) <= 0);
end
