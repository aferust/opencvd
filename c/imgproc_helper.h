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
void Canny3(Mat image, Mat edges, double threshold1, double threshold2, int apertureSize, bool L2gradient);

Mat GetStructuringElementWithAnchor(int shape, Size ksize, Point anchor);

void DrawContours2(
            Mat image,
            Contours contours,
            int contourIdx,
            Scalar color,
            int thickness,
            int lineType,
            Hierarchy hierarchy,
            int maxLevel,
            Point offset);

struct Points ConvexHull2(Contour points, bool clockwise);
struct IntVector ConvexHull3(Contour points, bool clockwise);

void CalcHist1(Mat images, int nimages, int* channels,
    Mat mask, Mat hist, int dims, int* histSize, const float** ranges, bool uniform, bool accumulate);

void CalcHist2(Mat dst, Mat mask, Mat hist, int* histSize);

void Rectangle2(Mat img, Point pt1, Point pt2, Scalar color, int thickness, int lineType, int shift);	

Vec3fs HoughCircles3(Mat image, int method, double dp,
                  double minDist, double param1, double param2, int minRadius, int maxRadius);

void Circle2(Mat img, Point center, int radius, Scalar color, int thickness, int shift);

void HoughLines2(Mat image, Vec2fs **lines, double rho, double theta,
            int threshold, double srn, double stn, double min_theta, double max_theta);

void HoughLinesP2(Mat image, Vec4is **lines, double rho, double theta,
            int threshold, double minLineLength, double maxLineGap);
void Line2(Mat img, Point pt1, Point pt2, Scalar color, int thickness, int lineType, int shift);

void DistanceTransform(Mat src, Mat dst, Mat labels, int distanceType,
            int maskSize, int labelType);

void DistanceTransform2(Mat src, Mat dst, int distanceType, int maskSize, int dstType);

#ifdef __cplusplus
}
#endif
