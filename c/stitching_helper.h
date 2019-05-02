#ifndef _OPENCV3_STITCHING_H_
#define _OPENCV3_STITCHING_H_

#include <stdbool.h>

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
extern "C" {
#endif

#include "core.h"

#ifdef __cplusplus
typedef cv::Ptr<cv::Stitcher>* Stitcher;
#else
typedef void* Stitcher;
#endif

void Stitcher_Close(Stitcher st);
Stitcher Stitcher_Create(int mode);
int Stitcher_Stitch(Stitcher st, Mats images, Mat pano);

#ifdef __cplusplus
}
#endif

#endif //_OPENCV3_STITCHING_H_
