#ifndef _OPENCV3_OBJDETECT_HELPER_H_
#define _OPENCV3_OBJDETECT_HELPER_H_

#include <stdbool.h>

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
extern "C" {
#endif

#include "core.h"
#include "cvcore_helper.h"
#include "objdetect.h"

Size HOGDescriptor_GetWinSize(HOGDescriptor hd);
void HOGDescriptor_SetWinSize(HOGDescriptor hd, Size newSize);
void HOGDescriptor_Compute(HOGDescriptor hd, Mat img, FloatVector descriptors, Size winStride, Size padding, Points locations);
void HOGDescriptor_DetectMultiScale2(HOGDescriptor hd,
                                    Mat img,
                                    Rects* foundLocations,
                                    DoubleVector* foundWeights,
                                    double hitThreshold,
                                    Size winStride,
                                    Size padding,
                                    double scale,
                                    double finalThreshold,
                                    bool useMeanshiftGrouping);	
#ifdef __cplusplus
}
#endif

#endif //_OPENCV3_OBJDETECT_HELPER_H_
