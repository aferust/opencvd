#ifndef _OPENCV3_FEATURES2D_H_
#define _OPENCV3_FEATURES2D_H_

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
extern "C" {
#endif

#include "core.h"
#include "cvcore_helper.h"
#include "features2d.h"

#ifdef __cplusplus
typedef cv::FlannBasedMatcher* FlannBasedMatcher;
#else
typedef void* FlannBasedMatcher;
#endif

FlannBasedMatcher FlannBasedMatcher_Create1();
void FlannBasedMatcher_Close(FlannBasedMatcher fbm);
struct MultiDMatches FlannBasedMatcher_KnnMatch(FlannBasedMatcher fbm,
    Mat queryDescriptors, Mat trainDescriptors, int k, Mat mask, bool compactResult);

void DrawMatches1(Mat img1,
                KeyPoints kp1,
                Mat img2,
                KeyPoints kp2,
                DMatches matches1to2,
                Mat outImg,
                Scalar matchColor,
                Scalar singlePointColor,
                CharVector matchesMask,
                int flags);

#ifdef __cplusplus
}
#endif

#endif //_OPENCV3_FEATURES2D_H_
