# Sparse-Coding-SR
 
## Reference
* J. Yang et al. Image super-resolution as sparse representation of raw image patches. CVPR 2008.
* J. Yang et al. Image super-resolution via sparse representation. IEEE Transactions on Image Processing, Vol 19, Issue 11, pp2861-2873, 2010.

## Data
* Used for training dictionaries.
* I use T91 super-resolution dataset for training dictionaty.
* You can use your own dataset by creating a new folder in *Data*.

## Dictionary
* Save dictionary training results.

## Function
* *Metrics* contains psnr, ssim and nqm for SR image quality evaluation.
* *SparseSR* contains functions used in *Demo_SR.m*.
* *TrainDict* contains functions used in *Demo_Dictionary_Training.m*.

## Test
* *Test* contains *input.bmp* and *gnd.bmp*.
* *Demo_SR.m* outputs *result.bmp*.

## *Demo_SR.m*
* Used for sparse coding image super-resolution.

## *Demo_Dictionary_Training.m*
* Used for training dictionaries.