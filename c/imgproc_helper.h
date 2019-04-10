#include <stdbool.h>

// functions not wrapped in gocv

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
extern "C" {
#endif

#include "core.h"
#include "cvcore_helper.h"

void Watershed(Mat src, Mat markers );

int FloodFill(  Mat 	image,
                Mat 	mask,
                Point 	seedPoint,
                Scalar 	newVal,
                Rect 	rect,
                Scalar 	loDiff,
                Scalar 	upDiff,
                int 	flags 
                );

struct Contours FindContoursWithHier(Mat src, Hierarchy **chierarchy, int mode, int method);

void Canny2(Mat dx, Mat dy, Mat edges, double threshold1, double threshold2, bool L2gradient);

#ifdef __cplusplus
}
#endif
