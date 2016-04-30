# HOG features

This is some description on the HOG feature defined in [VLFeat](http://www.vlfeat.org/).



## What's done in each C function

According to <http://www.vlfeat.org/api/hog.html>, the following C functions should be called to extract HOG features.

~~~c
VlHog * hog = vl_hog_new(VlHogVariantDalalTriggs, numOrientations, VL_FALSE) ;
vl_hog_put_image(hog, image, height, width, numChannels, cellSize) ;
hogWidth = vl_hog_get_width(hog) ;
hogHeight = vl_hog_get_height(hog) ;
hogDimenison = vl_hog_get_dimension(hog) ;
hogArray = vl_malloc(hogWidth*hogHeight*hogDimension*sizeof(float)) ;
vl_hog_extract(hog, hogArray) ;
vl_hog_delete(hog) ;
~~~

* **vl\_hog\_new** just does some preparation.
* **vl\_hog\_put\_image** will compute the gradient histogram for each **cell**. Notice that by default of MATLAB API, there's no linear interpolation on binning. So only bilinear interpolation on space is done. You can use `BilinearOrientations` option to use interpolation on bins as well.
* **vl\_hog\_extract** will compute the final HOG feature. Here, for each cell, the norms of its surrounding 4 blocks are computed, and the 4 normalized versions of this cell is concatenated to form the final HOG feature for this cell. Notice that in this implementation, border cells (which don't get 4 different normalizations) are still used. Check lines starting from <https://github.com/vlfeat/vlfeat/blob/edc378a722ea0d79e29f4648a54bb62f32b22568/vl/hog.c#L939>.


## `DirectedPolarField` vs `UndirectedPolarField` in MATLAB API

By checking the underlying C code that should be called by MATLAB API when using these two options (<https://github.com/vlfeat/vlfeat/blob/edc378a722ea0d79e29f4648a54bb62f32b22568/vl/hog.c#L742>), the only difference seems to be that when using `DirectedPolarField`, bins for all directions (all 360 range) will get some accumulation; when using `UndirectedPolarField`, bins for 0-180 only will be accumulated. But this won't be very noticeable in final result, since in two variants of HOG, either only undirected bins, or a mixture of undirected and directed is used.

## Difference from MATLAB's own `extractHOGFeatures`

MATLAB has a HOG feature function <http://www.mathworks.com/help/vision/ref/extracthogfeatures.html>. Notice that this one is more like a block based version of HOG. For each block, after computing the 4 (by default, which is changeable) normalized cells falling in this block, they are simply stored together in the final output, rather than putting the histograms for the same cell together, as in VLFeat's implementation.
