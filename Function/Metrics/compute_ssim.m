function [ssimval] = compute_ssim(sr, hr)
if size(sr, 3) == 3
    sr = rgb2ycbcr(sr);
    sr = sr(:, :, 1);
end

if size(hr, 3) == 3
    hr = rgb2ycbcr(hr);
    hr = hr(:, :, 1);
end

ssimval = ssim(sr,hr);
end

