#include "photo.h"

void DetailEnhance(Mat src, Mat dst, float sigma_s, float sigma_r){
    cv::detailEnhance(*src, *dst, sigma_s, sigma_r);
}

void EdgePreservingFilter(Mat src, Mat dst, int flags, float sigma_s, float sigma_r){
    cv::edgePreservingFilter(*src, *dst, flags, sigma_s, sigma_r);
}

void PencilSketch(Mat src, Mat dst1, Mat dst2, float sigma_s, float sigma_r, float shade_factor){
    cv::pencilSketch (*src, *dst1, *dst2, sigma_s, sigma_r, shade_factor);
}

void Stylization (Mat src, Mat dst, float sigma_s, float sigma_r){
    cv::stylization (*src, *dst, sigma_s, sigma_r);
}
