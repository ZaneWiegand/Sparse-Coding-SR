function [psnr] = compute_psnr(sr, hr)
addpath(genpath('psnr'))

if size(sr, 3) == 3
    sr = rgb2ycbcr(sr);
    sr = sr(:, :, 1);
end

if size(hr, 3) == 3
    hr = rgb2ycbcr(hr);
    hr = hr(:, :, 1);
end

rmse = compute_rmse(sr, hr);
psnr = 20*log10(255/rmse);
end

