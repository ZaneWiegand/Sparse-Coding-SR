function [HP, LP] = sample_patches_dual(lIm, hIm, patch_size, patch_num)

if size(hIm, 3) == 3
    hIm_ycbcr = rgb2ycbcr(hIm);
    hIm = hIm_ycbcr(:, :, 1);
end

if size(lIm, 3) == 3
    lIm_ycbcr = rgb2ycbcr(lIm);
    lIm = lIm_ycbcr(:, :, 1);
end

lIm = imresize(lIm, size(hIm), 'bicubic');
[nrow, ncol] = size(hIm);

rng(1) % random seed
x = randperm(nrow-2*patch_size-1) + patch_size;
y = randperm(ncol-2*patch_size-1) + patch_size;

[X,Y] = meshgrid(x,y);

xrow = X(:);
ycol = Y(:);

if patch_num < length(xrow)
    xrow = xrow(1:patch_num);
    ycol = ycol(1:patch_num);
end

patch_num = length(xrow);

hIm = double(hIm);
lIm = double(lIm);

HP = zeros(patch_size^2,     length(xrow));
LP = zeros(4*patch_size^2,   length(xrow));
 
% compute the first and second order gradients
hf1 = [-1,0,1];
vf1 = [-1,0,1]';
 
lImG11 = conv2(lIm, hf1,'same');
lImG12 = conv2(lIm, vf1,'same');
 
hf2 = [1,0,-2,0,1];
vf2 = [1,0,-2,0,1]';
 
lImG21 = conv2(lIm,hf2,'same');
lImG22 = conv2(lIm,vf2,'same');

for ii = 1:patch_num
    row = xrow(ii);
    col = ycol(ii);
    
    Hpatch = hIm(row:row+patch_size-1,col:col+patch_size-1);
    
    Lpatch1 = lImG11(row:row+patch_size-1,col:col+patch_size-1);
    Lpatch2 = lImG12(row:row+patch_size-1,col:col+patch_size-1);
    Lpatch3 = lImG21(row:row+patch_size-1,col:col+patch_size-1);
    Lpatch4 = lImG22(row:row+patch_size-1,col:col+patch_size-1);
     
    Lpatch = [Lpatch1(:),Lpatch2(:),Lpatch3(:),Lpatch4(:)];
    Lpatch = Lpatch(:);
     
    HP(:,ii) = Hpatch(:)-mean(Hpatch(:));
    LP(:,ii) = Lpatch;
end
