#include "photo_helper.h"

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

void ColorChange(Mat src, Mat mask, Mat dst, float red_mul, float green_mul, float blue_mul){
    cv::colorChange(*src, *mask, *dst, red_mul, green_mul, blue_mul);
}

void IlluminationChange(Mat src, Mat mask, Mat dst, float alpha, float beta){
    cv::illuminationChange (*src, *mask, *dst, alpha, beta);
}

void SeamlessClone(Mat src, Mat dst, Mat mask, Point p, Mat blend, int flags){
    cv::Point pp = {p.x, p.y};
    cv::seamlessClone(*src, *dst, *mask, pp, *blend, flags);
}

void TextureFlattening(Mat src, Mat mask, Mat dst, float low_threshold, float high_threshold, int kernel_size){
    cv::textureFlattening (*src, *mask, *dst, low_threshold, high_threshold, kernel_size);
}

