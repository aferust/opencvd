module opencvd.photo;

import opencvd.cvcore;

private extern (C){
    void DetailEnhance(Mat src, Mat dst, float sigma_s, float sigma_r);
    void EdgePreservingFilter(Mat src, Mat dst, int flags, float sigma_s, float sigma_r);
    void PencilSketch(Mat src, Mat dst1, Mat dst2, float sigma_s, float sigma_r, float shade_factor);
    void Stylization (Mat src, Mat dst, float sigma_s, float sigma_r);
    
    void ColorChange(Mat src, Mat mask, Mat dst, float red_mul, float green_mul, float blue_mul);
    void IlluminationChange(Mat src, Mat mask, Mat dst, float alpha, float beta);
    void SeamlessClone(Mat src, Mat dst, Mat mask, Point p, Mat blend, int flags);
    void TextureFlattening(Mat src, Mat mask, Mat dst, float low_threshold, float high_threshold, int kernel_size);
}

enum: int { 
    RECURS_FILTER = 1, 
    NORMCONV_FILTER = 2 
}

void detailEnhance(Mat src, Mat dst, float sigma_s=10, float sigma_r=0.15f){
    DetailEnhance(src, dst, sigma_s, sigma_r);
}

void edgePreservingFilter(Mat src, Mat dst, int flags=1, float sigma_s=60, float sigma_r=0.4f){
    EdgePreservingFilter(src, dst, flags, sigma_s, sigma_r);
}

void pencilSketch(Mat src, Mat dst1, Mat dst2, float sigma_s=60, float sigma_r=0.07f, float shade_factor=0.02f){
    PencilSketch(src, dst1, dst2, sigma_s, sigma_r, shade_factor);
}
void stylization (Mat src, Mat dst, float sigma_s=60, float sigma_r=0.45f){
    Stylization (src, dst, sigma_s, sigma_r);
}

enum: int { 
    NORMAL_CLONE = 1, 
    MIXED_CLONE = 2, 
    MONOCHROME_TRANSFER = 3 
}

void colorChange(Mat src, Mat mask, Mat dst, float red_mul=1.0f, float green_mul=1.0f, float blue_mul=1.0f){
    ColorChange(src, mask, dst, red_mul, green_mul, blue_mul);
}

void illuminationChange(Mat src, Mat mask, Mat dst, float alpha=0.2f, float beta=0.4f){
    IlluminationChange(src, mask, dst, alpha, beta);
}

void seamlessClone(Mat src, Mat dst, Mat mask, Point p, Mat blend, int flags){
    SeamlessClone(src, dst, mask, p, blend, flags);
}

void textureFlattening(Mat src, Mat mask, Mat dst, float low_threshold=30, float high_threshold=45, int kernel_size=3){
    TextureFlattening(src, mask, dst, low_threshold, high_threshold, kernel_size);
}
