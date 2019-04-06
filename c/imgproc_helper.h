#include <stdbool.h>

// functions not wrapped in gocv

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
extern "C" {
#endif

#include "core.h"


void Watershed(Mat src, Mat markers );

#ifdef __cplusplus
}
#endif
