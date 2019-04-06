#include "imgproc_helper.h"

void Watershed(Mat src, Mat markers ){
    cv::watershed( *src, *markers );
}

int FloodFill(  Mat 	image,
                Mat 	mask,
                Point 	seedPoint,
                Scalar 	newVal,
                Rect 	rect,
                Scalar 	loDiff,
                Scalar 	upDiff,
                int 	flags 
                ){
    cv::Point sp = {seedPoint.x, seedPoint.y};
    cv::Scalar nv = cv::Scalar(newVal.val1, newVal.val2, newVal.val3, newVal.val4);
    cv::Rect r = {rect.x, rect.y, rect.width, rect.height};
    cv::Scalar lo = {loDiff.val1, loDiff.val2, loDiff.val3, loDiff.val4};
    cv::Scalar up = {upDiff.val1, upDiff.val2, upDiff.val3, upDiff.val4};
    
    return cv::floodFill(*image, *mask, sp, nv, &r, lo, up, flags);
}
