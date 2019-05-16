#ifndef _OPENCV3_CALIB_HELPER_H_
#define _OPENCV3_CALIB_HELPER_H_

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
#include <opencv2/calib3d.hpp>


extern "C" {
#endif

#include "core.h"
#include "cvcore_helper.h"

Mat FindHomography1(Point2fs srcPoints, Point2fs dstPoints, int method,
    double ransacReprojThreshold, Mat mask, int maxIters, double confidence);

#ifdef __cplusplus
}
#endif

#endif //_OPENCV3_CALIB_HELPER_H_
