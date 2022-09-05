function [nqmv] = compute_nqm(sr, hr)

addpath(genpath('nqm'))

if size(hr, 3) == 3
    hr = rgb2ycbcr(hr);
    hr = hr(:, :, 1);
end

if size(sr, 3) == 3
    sr = rgb2ycbcr(sr);
    sr = sr(:, :, 1);
end

nqmv = nqm(sr,hr,pi/3);
end

