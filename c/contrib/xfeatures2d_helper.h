#ifndef _OPENCV3_XFEATURES2D_HELPER_H_
#define _OPENCV3_XFEATURES2D_HELPER_H_

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
#include <opencv2/xfeatures2d.hpp>
extern "C" {
#endif

#include "../core.h"
#include "xfeatures2d.h"

SURF SURF_CreateWithParams(double hessianThreshold, int nOctaves, int nOctaveLayers, bool extended, bool upright);
bool SURF_GetExtended(SURF s);
double SURF_GetHessianThreshold(SURF s);
int SURF_GetNOctaveLayers(SURF s);
int SURF_GetNOctaves(SURF s);
bool SURF_GetUpright(SURF s);
void SURF_SetExtended(SURF s, bool extended);
void SURF_SetHessianThreshold (SURF s, double hessianThreshold);
void SURF_SetNOctaveLayers (SURF s, int nOctaveLayers);
void SURF_SetNOctaves (SURF s, int nOctaves);
void SURF_SetUpright (SURF s, bool upright);
KeyPoints SURF_DetectAndCompute2(SURF s, Mat image, Mat mask, Mat descriptors, bool useProvidedKeypoints);

#ifdef __cplusplus
}
#endif

#endif //_OPENCV3_XFEATURES2D_HELPER_H_
