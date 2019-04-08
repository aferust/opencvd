
#ifdef __cplusplus
#include <opencv2/opencv.hpp>
extern "C" {
#endif

#include "core.h"

typedef void(*TrackbarCallback)(int pos, void* userdata);
typedef void(*MouseCallback)(int event, int x, int y, int flags, void *userdata);

void Trackbar_CreateWithCallBack(const char* trackname, const char* winname, int* value, int count, TrackbarCallback _cb, void* userdata);
void Win_setMouseCallback(const	char* winname, MouseCallback onMouse, void *userdata);
	
#ifdef __cplusplus
}
#endif
