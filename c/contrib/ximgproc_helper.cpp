#include "ximgproc_helper.h"

void FourierDescriptor(Contour spoints, Mat dst, int nbElt, int nbFD){
    
    std::vector<cv::Point> pts;

    for (size_t i = 0; i < spoints.length; i++) {
        pts.push_back(cv::Point(spoints.points[i].x, spoints.points[i].y));
    }
    
    cv::ximgproc::fourierDescriptor(pts, *dst, nbElt, nbFD);
}

void Thinning(Mat input, Mat output, int thinningType){
    cv::ximgproc::thinning(*input, *output, thinningType);
}
