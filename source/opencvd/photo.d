module opencvd.photo;

import opencvd.cvcore;

private extern (C){
    void DetailEnhance(Mat src, Mat dst, float sigma_s, float sigma_r);
    void EdgePreservingFilter(Mat src, Mat dst, int flags, float sigma_s, float sigma_r);
    void PencilSketch(Mat src, Mat dst1, Mat dst2, float sigma_s, float sigma_r, float shade_factor);
    void Stylization (Mat src, Mat dst, float sigma_s, float sigma_r);
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
