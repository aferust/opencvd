#include "calib3d_helper.h"

Mat FindHomography1(Point2fs srcPoints, Point2fs dstPoints, int method,
    double ransacReprojThreshold, Mat mask, int maxIters, double confidence){
    
    std::vector< cv::Point2f > srcpv;
    for( size_t i = 0; i < srcPoints.length; i++ ){
        Point2f pp = srcPoints.points[i];
        cv::Point2f p = {pp.x, pp.y};
        srcpv.push_back(p);
    }
    
    std::vector< cv::Point2f > dstpv;
    for( size_t i = 0; i < dstPoints.length; i++ ){
        Point2f pp = dstPoints.points[i];
        cv::Point2f p = {pp.x, pp.y};
        dstpv.push_back(p);
    }
    
    return new cv::Mat(cv::findHomography(srcpv, dstpv, method, ransacReprojThreshold, *mask, maxIters, confidence));
}

