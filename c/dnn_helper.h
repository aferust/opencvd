#ifndef _OPENCV3_DNN_HELPER_H_
#define _OPENCV3_DNN_HELPER_H_

#include <stdbool.h>

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>
extern "C" {
#endif

#include "core.h"
#include "cvcore_helper.h"
#include "dnn.h"

IntVector DNN_NMSBoxes(RotatedRects rects, FloatVector _scores, float score_threshold, float nms_threshold, float eta, int top_k);

#ifdef __cplusplus
}
#endif

#endif //_OPENCV3_DNN_HELPER_H_
