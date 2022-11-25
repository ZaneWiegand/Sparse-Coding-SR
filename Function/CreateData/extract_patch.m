function patch = extract_patch(img,patch_size)
img_size = size(img,1);
img_dim = size(img);
patch_size = patch_size(1);
im_start = (img_size-patch_size)/2+1;
im_end = (img_size+patch_size)/2;
if length(img_dim)==3
    patch = img(im_start:im_end,im_start:im_end,:);
else
    patch = img(im_start:im_end,im_start:im_end);
end

