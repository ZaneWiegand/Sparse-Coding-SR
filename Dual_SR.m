clear;

addpath(genpath('Function/SparseSR'))
addpath(genpath('Function/Metrics'))
addpath(genpath('Function/CreateData'))
addpath(genpath('Function/TrainDict'))

% set file parameters
lr_path = 'Test/2-input-2x.jpeg';
hr_path = 'Test/2-GT.jpeg';
sr_path = 'Test/2-result-2x.jpeg';

% sparse sr parameters
lambda = 0.2;                   % sparsity regularization
overlap = 4;                    % the more overlap the better (patch size 5x5)
maxIter = 20;                   % if 0, do not use backprojection

% dictionary parameters
dic_size = 512;
lmbd = 0.15;
patch_size = 5;
upscale = 2;

% New dictionary training parameters
new_dict_size   = 512;          % dictionary size
nSmp        = 5000;        % number of patches to sample
cut_perent  = 10;
epoch       = 10;
% =========================================================================
% load dictionary
dic_path = ['Dictionary/D_',num2str(dic_size),'_',num2str(lmbd),'_',num2str(patch_size),'_s',num2str(upscale),'.mat'];
load(dic_path);

% read ground truth image
im_hr = imread(hr_path);

% read test image
im_lr = imread(lr_path);
tic
% change color space, work on illuminance only
im_lr_ycbcr = rgb2ycbcr(im_lr);
im_lr_y = im_lr_ycbcr(:, :, 1);
im_lr_cb = im_lr_ycbcr(:, :, 2);
im_lr_cr = im_lr_ycbcr(:, :, 3);

% image super-resolution based on sparse representation
[im_sr_y] = ScSR(im_lr_y, upscale, Dh, Dl, lambda, overlap);
[im_sr_y] = backprojection(im_sr_y, im_lr_y, maxIter);


im_sr_patch_size = get_even(size(im_sr_y)/(upscale));
im_sr_patch = extract_patch(im_sr_y, im_sr_patch_size);

im_long = extract_patch(im_hr, im_sr_patch_size);

[H, L] = sample_patches_dual(im_sr_patch, im_long, patch_size, nSmp);
[H, L] = patch_pruning(H, L, cut_perent);
% joint sparse coding 
[Dh, Dl] = train_coupled_dict(H, L, new_dict_size, lmbd, epoch);

[im_sr_y] = ScSR(im_sr_y, 1, Dh, Dl, lambda, overlap);
[im_sr_y] = backprojection(im_sr_y, im_lr_y, maxIter);


% upscale the chrominance simply by "bicubic" 
[nrow, ncol] = size(im_sr_y);
im_sr_cb = imresize(im_lr_cb, [nrow, ncol], 'bicubic');
im_sr_cr = imresize(im_lr_cr, [nrow, ncol], 'bicubic');

im_sr_ycbcr = zeros([nrow, ncol, 3]);
im_sr_ycbcr(:, :, 1) = im_sr_y;
im_sr_ycbcr(:, :, 2) = im_sr_cb;
im_sr_ycbcr(:, :, 3) = im_sr_cr;
im_sr = ycbcr2rgb(uint8(im_sr_ycbcr));
toc

% bicubic interpolation for reference
im_bc = imresize(im_lr, [nrow, ncol], 'bicubic');

% compute PSNR for the illuminance channel
bc_psnr = compute_psnr(im_bc, im_hr);
sr_psnr = compute_psnr(im_sr, im_hr);
fprintf('PSNR for Bicubic Interpolation: %f dB\n', bc_psnr);
fprintf('PSNR for Sparse Representation Recovery: %f dB\n', sr_psnr);

% compute SSIM for the illuminance channel
bc_ssim = compute_ssim(im_bc, im_hr);
sr_ssim = compute_ssim(im_sr, im_hr);
fprintf('SSIM for Bicubic Interpolation: %f\n', bc_ssim);
fprintf('SSIM for Sparse Representation Recovery: %f\n', sr_ssim);

% compute NQM for the illuminance channel
bc_nqm = compute_nqm(im_bc, im_hr);
sr_nqm = compute_nqm(im_sr, im_hr);
fprintf('NQM for Bicubic Interpolation: %f dB\n', bc_nqm);
fprintf('NQM for Sparse Representation Recovery: %f dB\n', sr_nqm);

imwrite(im_sr, sr_path);

% show the images
figure, imshow(im_sr);
title('Sparse Recovery');
figure, imshow(im_bc);
title('Bicubic Interpolation');