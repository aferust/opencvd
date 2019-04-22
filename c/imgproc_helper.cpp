#include "imgproc_helper.h"

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

int FloodFill2(Mat image, Point seedPoint, Scalar newVal, Rect rect, Scalar loDiff, Scalar upDiff, int flags){
    cv::Point sp = {seedPoint.x, seedPoint.y};
    cv::Scalar nv = cv::Scalar(newVal.val1, newVal.val2, newVal.val3, newVal.val4);
    cv::Rect r = {rect.x, rect.y, rect.width, rect.height};
    cv::Scalar lo = {loDiff.val1, loDiff.val2, loDiff.val3, loDiff.val4};
    cv::Scalar up = {upDiff.val1, upDiff.val2, upDiff.val3, upDiff.val4};
    return cv::floodFill(*image, sp, nv, &r, lo, up, flags);
}

struct Contours FindContoursWithHier(Mat src, Hierarchy **chierarchy, int mode, int method) { 
    std::vector<std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
    
    cv::findContours(*src, contours, hierarchy, mode, method);
    
    Scalar *scalars = new Scalar[hierarchy.size()];
    
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

void Canny3(Mat image, Mat edges, double threshold1, double threshold2, int apertureSize, bool L2gradient){
    cv::Canny(*image, *edges, threshold1, threshold2, apertureSize, L2gradient);
}

Mat GetStructuringElementWithAnchor(int shape, Size ksize, Point anchor){
    cv::Point p1(anchor.x, anchor.y);
    cv::Size sz(ksize.width, ksize.height);
    return new cv::Mat(cv::getStructuringElement(shape, sz, p1));
}

void DrawContours2(
            Mat image,
            Contours points,
            int contourIdx,
            Scalar color,
            int thickness,
            int lineType,
            Hierarchy hierarchy,
            int maxLevel,
            Point offset){
                
    std::vector<cv::Vec4i> cvhierarchy;
    for (size_t i = 0; i < hierarchy.length; i++) {
        cv::Vec4i colr = cv::Vec4i((int)hierarchy.scalars[i].val1, (int)hierarchy.scalars[i].val2, (int)hierarchy.scalars[i].val3, (int)hierarchy.scalars[i].val4);
        cvhierarchy.push_back(colr);
    }
    
    std::vector<std::vector<cv::Point> > cpts;

    for (size_t i = 0; i < points.length; i++) {
        Contour contour = points.contours[i];

        std::vector<cv::Point> cntr;

        for (size_t i = 0; i < contour.length; i++) {
            cntr.push_back(cv::Point(contour.points[i].x, contour.points[i].y));
        }

        cpts.push_back(cntr);
    }
    cv::Scalar cvsclr = cv::Scalar(color.val1, color.val2, color.val3, color.val4);
    cv::Point p = cv::Point(offset.x, offset.y);
    cv::drawContours(*image, cpts, contourIdx, cvsclr, thickness, lineType, cvhierarchy, maxLevel, p); 	
}

struct Points ConvexHull2(Contour points, bool clockwise) {
    std::vector<cv::Point> pts;

    for (size_t i = 0; i < points.length; i++) {
        pts.push_back(cv::Point(points.points[i].x, points.points[i].y));
    }
    
    std::vector<cv::Point> _retHull;
    
    cv::convexHull(pts, _retHull, clockwise, true);
    
    Point* _pts = new Point[_retHull.size()];
    
    for (size_t i = 0; i < _retHull.size(); i++) {
        Point tmp = {_retHull[i].x, _retHull[i].y};
        _pts[i] = tmp;
    }
    
    Points con = {_pts, (int)_retHull.size()};
    return con;
}

struct IntVector ConvexHull3(Contour points, bool clockwise) {
    std::vector<cv::Point> pts;

    for (size_t i = 0; i < points.length; i++) {
        pts.push_back(cv::Point(points.points[i].x, points.points[i].y));
    }
    
    std::vector<int> _retHull;
    
    cv::convexHull(pts, _retHull, clockwise, false);
    
    int* _pts = new int[_retHull.size()];
    
    for (size_t i = 0; i < _retHull.size(); i++) {
        _pts[i] = _retHull[i];
    }
    
    IntVector con = {_pts, (int)_retHull.size()};
    return con;
}

void CalcHist1(Mat dst, int nimages, int* channels,
    Mat mask, Mat hist, int dims, int* histSize, const float** ranges, bool uniform, bool accumulate){
    
    cv::calcHist(dst, nimages, channels, *mask, *hist, dims, histSize, ranges, uniform, accumulate);   
}

void CalcHist2(Mat dst, Mat mask, Mat hist, int* histSize){
    cv::calcHist(dst, 1, 0, *mask, *hist, 1, histSize, 0);
}

void Rectangle2(Mat img, Point _pt1, Point _pt2, Scalar color, int thickness, int lineType, int shift){
    cv::Point pt1 = cv::Point(_pt1.x, _pt1.y);
    cv::Point pt2 = cv::Point(_pt2.x, _pt2.y);
    cv::Scalar c = cv::Scalar(color.val1, color.val2, color.val3, color.val4);
    cv::rectangle(
        *img,
        pt1,
        pt2,
        c,
        thickness,
        lineType,
        shift
    );
}

Vec3fs HoughCircles3(Mat image, int method, double dp,
                  double minDist, double param1, double param2, int minRadius, int maxRadius){
    std::vector<cv::Vec3f> circles;
    HoughCircles(*image, circles, method, dp, minDist, param1, param2, minRadius, maxRadius);
    
    Vec3f* ccs = new Vec3f[circles.size()];
    
    for (size_t i = 0; i < circles.size(); i++) {
        Vec3f vc3f = {circles[i][0], circles[i][1], circles[i][2]};
        ccs[i] = vc3f;
    }
    
    Vec3fs retCircles = {ccs, (int)circles.size()};
    
    return retCircles;
}

void Circle2(Mat img, Point center, int radius, Scalar color, int thickness, int shift){
    cv::Point p1(center.x, center.y);
    cv::Scalar c = cv::Scalar(color.val1, color.val2, color.val3, color.val4);

    cv::circle(*img, p1, radius, c, thickness, shift);
}

void HoughLines2(Mat image, Vec2fs **_lines, double rho, double theta,
            int threshold, double srn, double stn, double min_theta, double max_theta){
    std::vector<cv::Vec2f> lines;
    HoughLines(*image, lines, rho, theta, threshold, srn, stn, min_theta, max_theta);
    
    Vec2f* lns = new Vec2f[lines.size()];
    
    for (size_t i = 0; i < lines.size(); i++) {
        Vec2f vc2f = {lines[i][0], lines[i][1]};
        lns[i] = vc2f;
    }
    
    Vec2fs retLines = {lns, (int)lines.size()};
    *_lines = &retLines;
    
    //delete lns;
}

void HoughLinesP2(Mat image, Vec4is **_lines, double rho, double theta,
            int threshold, double minLineLength, double maxLineGap){
    std::vector<cv::Vec4i> lines;
    HoughLinesP(*image, lines, rho, theta, threshold, minLineLength, maxLineGap);
    
    Vec4i* lns = new Vec4i[lines.size()];
    
    for (size_t i = 0; i < lines.size(); i++) {
        Vec4i vc4i = {lines[i][0], lines[i][1]};
        lns[i] = vc4i;
    }
    
    Vec4is retLines = {lns, (int)lines.size()};
    *_lines = &retLines;
    
    //delete lns;
}

void Line2(Mat img, Point pt1, Point pt2, Scalar color, int thickness, int lineType, int shift){
    cv::Point p1(pt1.x, pt1.y);
    cv::Point p2(pt2.x, pt2.y);
    cv::Scalar c = cv::Scalar(color.val1, color.val2, color.val3, color.val4);

    cv::line(*img, p1, p2, c, thickness, lineType, shift);
}

void DistanceTransform(Mat src, Mat dst, Mat labels, int distanceType,
            int maskSize, int labelType){
    distanceTransform(*src, *dst, *labels, distanceType, maskSize, labelType);
}

void DistanceTransform2(Mat src, Mat dst, int distanceType, int maskSize, int dstType){
    distanceTransform(*src, *dst, distanceType, maskSize, dstType);
}
