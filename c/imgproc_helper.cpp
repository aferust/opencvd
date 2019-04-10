#include "imgproc_helper.h"
//#include <cstdlib>

void Watershed(Mat src, Mat markers ){
    cv::watershed( *src, *markers );
}

int FloodFill(  Mat 	image,
                Mat 	mask,
                Point 	seedPoint,
                Scalar 	newVal,
                Rect 	rect,
                Scalar 	loDiff,
                Scalar 	upDiff,
                int 	flags 
                ){
    cv::Point sp = {seedPoint.x, seedPoint.y};
    cv::Scalar nv = cv::Scalar(newVal.val1, newVal.val2, newVal.val3, newVal.val4);
    cv::Rect r = {rect.x, rect.y, rect.width, rect.height};
    cv::Scalar lo = {loDiff.val1, loDiff.val2, loDiff.val3, loDiff.val4};
    cv::Scalar up = {upDiff.val1, upDiff.val2, upDiff.val3, upDiff.val4};
    
    return cv::floodFill(*image, *mask, sp, nv, &r, lo, up, flags);
}

struct Contours FindContoursWithHier(Mat src, Hierarchy **chierarchy, int mode, int method) { 
    std::vector<std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
    
    cv::findContours(*src, contours, hierarchy, mode, method);
    
    Scalar *scalars = new Scalar[hierarchy.size()]; //(Hierarchy*)malloc(sizeof(Hierarchy));
    
    for (size_t i = 0; i < hierarchy.size(); i++){
        Scalar s = {(double)hierarchy[i][0], (double)hierarchy[i][1], (double)hierarchy[i][2], (double)hierarchy[i][3]};
        scalars[i] = s;
    }
    Hierarchy retHie = {scalars, (int)hierarchy.size()};
    *chierarchy = &retHie;
    
    Contour* points = new Contour[contours.size()];

    for (size_t i = 0; i < contours.size(); i++) {
        Point* pts = new Point[contours[i].size()];

        for (size_t j = 0; j < contours[i].size(); j++) {
            Point pt = {contours[i][j].x, contours[i][j].y};
            pts[j] = pt;
        }
        
        Contour c = {pts, (int)contours[i].size()};
        points[i] = c;
    }

    Contours cons = {points, (int)contours.size()};
    return cons;
}

void Canny2(Mat dx, Mat dy, Mat edges, double threshold1, double threshold2, bool L2gradient){
    cv::Canny(*dx, *dy, *edges, threshold1, threshold2, L2gradient);
}

Mat GetStructuringElementWithAnchor(int shape, Size ksize, Point anchor){
    cv::Point p1(anchor.x, anchor.y);
    cv::Size sz(ksize.width, ksize.height);
    return new cv::Mat(cv::getStructuringElement(shape, sz, p1));
}
