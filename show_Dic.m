% dictionary parameters
dic_size = 512;
lmdb = 0.15;
patch_size = 5;
upscale = 2;

% =========================================================================
% load dictionary
dic_path = ['Dictionary/D_',num2str(dic_size),'_',num2str(lmdb),'_',num2str(patch_size),'_s',num2str(upscale),'.mat'];
load(dic_path);

len_num = 23;
patch_size = 5*2;
show_pic = zeros([len_num*patch_size,len_num*patch_size]);
%
for i=1:size(Dl,2)
    % pat = reshape(Dl(:,i),[patch_size,patch_size]);
    pat = zeros([10,10]);
    pat(1:5,1:5) = reshape(Dl(1:25,i),[5,5]);
    pat(1:5,6:10) = reshape(Dl(26:50,i),[5,5]);
    pat(6:10,1:5) = reshape(Dl(51:75,i),[5,5]);
    pat(6:10,6:10) = reshape(Dl(76:100,i),[5,5]);
    
    m = floor(i/len_num);
    n = mod(i,len_num);
    show_pic(m*patch_size+1:(m+1)*patch_size,n*patch_size+1:(n+1)*patch_size) = pat;
end

imshow(show_pic,[])