
#ifdef __cplusplus
#include <opencv2/opencv.hpp>
extern "C" {
#endif

#include "core.h"

typedef void(*TrackbarCallback)(int pos, void* userdata);

void Trackbar_CreateWithCallBack(const char* trackname, const char* winname, int* value, int count, TrackbarCallback _cb, void* userdata);

#ifdef __cplusplus
}
#endif
