#ifndef _OPENCV3_PHOTO_H_
#define _OPENCV3_PHOTO_H_

#include <stdbool.h>

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
extern "C" {
#endif

#include "core.h"

void DetailEnhance(Mat src, Mat dst, float sigma_s, float sigma_r);
void EdgePreservingFilter(Mat src, Mat dst, int flags, float sigma_s, float sigma_r);
void PencilSketch(Mat src, Mat dst1, Mat dst2, float sigma_s, float sigma_r, float shade_factor);
void Stylization (Mat src, Mat dst, float sigma_s, float sigma_r);

#ifdef __cplusplus
}
#endif

#endif //_OPENCV3_PHOTO_H_
