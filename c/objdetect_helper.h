#ifndef _OPENCV3_OBJDETECT_HELPER_H_
#define _OPENCV3_OBJDETECT_HELPER_H_

#include <stdbool.h>

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
extern "C" {
#endif

#include "core.h"
#include "objdetect.h"

Size HOGDescriptor_GetWinSize(HOGDescriptor hd);
void HOGDescriptor_SetWinSize(HOGDescriptor hd, Size newSize);

#ifdef __cplusplus
}
#endif

#endif //_OPENCV3_OBJDETECT_HELPER_H_
