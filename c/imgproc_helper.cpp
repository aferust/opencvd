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

struct Contours FindContoursWithHier(Mat src, Hierarchy* chierarchy, int mode, int method) { 
    std::vector<std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
    
    cv::findContours(*src, contours, hierarchy, mode, method);
    
    Scalar *scalars = (Scalar*)malloc(hierarchy.size()*sizeof(Scalar));
    
    for (size_t i = 0; i < hierarchy.size(); i++){
        Scalar s = {(double)hierarchy[i][0], (double)hierarchy[i][1], (double)hierarchy[i][2], (double)hierarchy[i][3]};
        scalars[i] = s;
    }
    
    chierarchy->scalars = scalars;
    chierarchy->length = (int)hierarchy.size();
    
    Contour* points = (Contour*)malloc(contours.size()*sizeof(Contour));

    for (size_t i = 0; i < contours.size(); i++) {
        Point* pts = (Point*)malloc(contours[i].size()*sizeof(Point));

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
    
    Vec3f* ccs = (Vec3f*)malloc(circles.size()*sizeof(Vec3f));
    
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

void HoughLines2(Mat image, Vec2fs* _lines, double rho, double theta,
            int threshold, double srn, double stn, double min_theta, double max_theta){
    std::vector<cv::Vec2f> lines;
    HoughLines(*image, lines, rho, theta, threshold, srn, stn, min_theta, max_theta);
    
    Vec2f* lns = (Vec2f*)malloc(lines.size()*sizeof(Vec2f));
    
    for (size_t i = 0; i < lines.size(); i++) {
        Vec2f vc2f = {lines[i][0], lines[i][1]};
        lns[i] = vc2f;
    }
    
    _lines->vec2fs = lns;
    _lines->length = (int)lines.size();
}

void HoughLinesP2(Mat image, Vec4is* _lines, double rho, double theta,
            int threshold, double minLineLength, double maxLineGap){
    std::vector<cv::Vec4i> lines;
    HoughLinesP(*image, lines, rho, theta, threshold, minLineLength, maxLineGap);
    
    Vec4i* lns = (Vec4i*)malloc(lines.size()*sizeof(Vec4i));
    
    for (size_t i = 0; i < lines.size(); i++) {
        Vec4i vc4i = {lines[i][0], lines[i][1]};
        lns[i] = vc4i;
    }
    
    _lines->vec4is = lns;
    _lines->length = (int)lines.size();
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

Subdiv2D Subdiv2d_New(){
    return new cv::Subdiv2D();
}

Subdiv2D Subdiv2d_NewFromRect(Rect r){
    return new cv::Subdiv2D(cv::Rect(r.x, r.y, r.width, r.height));
}

void Subdiv2D_Close(Subdiv2D sd){
    delete sd;
}

void Subdiv2D_Insert(Subdiv2D sd, Point2f p){
    sd->insert(cv::Point2f(p.x, p.y));
}

void Subdiv2D_InsertMultiple(Subdiv2D sd, Point2fs ptvec){
     std::vector< cv::Point2f > pv;
     for( size_t i = 0; i < ptvec.length; i++ ){
         Point2f pp = ptvec.points[i];
         cv::Point2f p = {pp.x, pp.y};
         pv.push_back(p);
     }
     sd->insert(pv);
}

struct Vec6fs Subdiv2D_GetTriangleList(Subdiv2D sd){
    std::vector<cv::Vec6f> triangleList;
    sd->getTriangleList(triangleList);
    
    Vec6f* v6ptr = new Vec6f[triangleList.size()];
    
    for( size_t i = 0; i < triangleList.size(); i++ ){
        cv::Vec6f t = triangleList[i];
        Vec6f v6 = {t[0], t[1], t[2], t[3], t[4], t[5]};
        v6ptr[i] = v6;
    }
    
    Vec6fs ret = {v6ptr, (int)triangleList.size()};
    return ret;
}

Point2fss Subdiv2D_GetVoronoiFacetList(Subdiv2D sd, IntVector idx, Point2fs* faceCenters){
    std::vector<std::vector<cv::Point2f> > facets;
    std::vector<cv::Point2f> centers;
    
    std::vector<int> cidx;
    for(size_t k = 0; k < idx.length; k++) cidx.push_back(idx.val[k]);
    
    sd->getVoronoiFacetList(cidx, facets, centers);
    
    Point2fs* elemFacetList = (Point2fs*)malloc(facets.size()*sizeof(Point2fs));
    
    for( size_t i = 0; i < facets.size(); i++ ){
        
        std::vector<cv::Point2f> vp2f = facets[i];
        
        Point2f* points = (Point2f*)malloc(vp2f.size()*sizeof(Point2f));
        for( size_t j = 0; j < vp2f.size(); j++ ){
            Point2f point = {vp2f[j].x, vp2f[j].y};
            points[j] = point;
        }
        
        Point2fs p2fs = {points, (int)vp2f.size()};
        
        elemFacetList[i] = p2fs;
    }
    
    Point2f* centersPtr = (Point2f*)malloc(centers.size()*sizeof(Point2f));
    for( size_t i = 0; i < centers.size(); i++ ){
        cv::Point2f fc = centers[i];
        Point2f _fc = {fc.x, fc.y};
        centersPtr[i] = _fc ;
    }
    
    //Point2fs _ret2 = {centersPtr, (int)centers.size()};
    faceCenters->points = centersPtr;
    faceCenters->length = (int)centers.size();
    
    Point2fss _ret1 = {elemFacetList, (int)facets.size()};
    return _ret1;
}

int Subdiv2D_Locate(Subdiv2D sd, Point2f _pt, int &edge, int &vertex){
    cv::Point2f pt = {_pt.x, _pt.y};
    return sd->locate(pt, edge, vertex);
}

int Subdiv2D_EdgeOrg(Subdiv2D sd, int edge, Point2f** orgpt){
    cv::Point2f op;
    int retInt = sd->edgeOrg(edge, &op);
    Point2f opp = {op.x, op.y};
    *orgpt = &opp;
    return retInt;
}

int Subdiv2D_EdgeDst(Subdiv2D sd, int edge, Point2f** dstpt){
    cv::Point2f op;
    int retInt = sd->edgeDst(edge, &op);
    Point2f opp = {op.x, op.y};
    *dstpt = &opp;
    return retInt;
}

int Subdiv2D_GetEdge(Subdiv2D sd, int edge, int nextEdgeType){
    return sd->getEdge(edge, nextEdgeType);
}

int Subdiv2D_NextEdge(Subdiv2D sd, int edge){
    return sd->nextEdge(edge);
}

int Subdiv2D_RotateEdge(Subdiv2D sd, int edge, int rotate){
    return sd->rotateEdge(edge, rotate);
}

int Subdiv2D_SymEdge(Subdiv2D sd, int edge){
    return sd->symEdge(edge);
}

int Subdiv2D_FindNearest(Subdiv2D sd, Point2f pt, Point2f** _nearestPt){
    cv::Point2f p = {pt.x, pt.y};
    cv::Point2f np;
    int retInt = sd->findNearest(p, &np);
    Point2f rp = {np.x, np.y};
    *_nearestPt = &rp;
    return retInt;
}

struct Vec4fs Subdiv2D_GetEdgeList(Subdiv2D sd){
    std::vector<cv::Vec4f> v4;
    sd->getEdgeList(v4);
    
    Vec4f *v4fs = (Vec4f*)malloc(v4.size()*sizeof(Vec4f));
    for(size_t i=0; i < v4.size(); i++){
        Vec4f v4c = {v4[i][0], v4[i][1], v4[i][2], v4[i][3]};
        v4fs[i] = v4c;
    }
    Vec4fs v4s = {v4fs, (int)v4.size()};
    return v4s;
};

struct IntVector Subdiv2D_GetLeadingEdgeList(Subdiv2D sd){
    std::vector<int> iv;
    sd->getLeadingEdgeList(iv);
    int *cintv = new int[iv.size()];
    for(size_t i=0; i < iv.size(); i++){
        cintv[i] = iv[i];
    }
    IntVector ret = {cintv, (int)iv.size()};
    return ret;
};


Point2f Subdiv2D_GetVertex(Subdiv2D sd, int vertex, int* firstEdge){
    cv::Point2f vx = sd->getVertex(vertex, firstEdge);
    Point2f cvx = {vx.x, vx.y};
    return cvx;
}

void Subdiv2D_InitDelaunay(Subdiv2D sd, Rect bRect){
    cv::Rect r = {bRect.x, bRect.y, bRect.width, bRect.height};
    sd->initDelaunay(r);
}

void FillConvexPoly(Mat img, Points points, Scalar color, int lineType, int shift){
    std::vector<cv::Point> pts;
    for(int i=0; i < points.length; i++){
        cv::Point p = {points.points[i].x, points.points[i].y};
        pts.push_back(p);
    }
    cv::Scalar c = cv::Scalar(color.val1, color.val2, color.val3, color.val4);
    cv::fillConvexPoly(*img, pts, c, lineType, shift);
}

void Polylines(Mat img, Points _pts, bool isClosed, Scalar color, int thickness, int lineType, int shift){
    std::vector<cv::Point> pts;
    for(int i=0; i < _pts.length; i++){
        cv::Point p = {_pts.points[i].x, _pts.points[i].y};
        pts.push_back(p);
    }
    cv::Scalar c = cv::Scalar(color.val1, color.val2, color.val3, color.val4);
    cv::polylines(*img, pts, isClosed, c, thickness, lineType, shift);
}

void Polylines2ss(Mat img, Pointss flist, bool isClosed, Scalar color, int thickness, int lineType, int shift){
    std::vector<std::vector<cv::Point>> pts;
    for(int i=0; i < flist.length; i++){
        std::vector<cv::Point> inner;
        for(int j=0; j < flist.pointss[i].length; j++){
            cv::Point inp = {flist.pointss[i].points[j].x, flist.pointss[i].points[j].y};
            inner.push_back(inp);
        }
        pts.push_back(inner);
    }
    cv::Scalar c = cv::Scalar(color.val1, color.val2, color.val3, color.val4);
    cv::polylines(*img, pts, isClosed, c, thickness, lineType, shift);
}

struct RotatedRect FitEllipse(Points points){
    std::vector<cv::Point> pts;

    for (size_t i = 0; i < points.length; i++) {
        pts.push_back(cv::Point(points.points[i].x, points.points[i].y));
    }

    cv::RotatedRect cvrect = cv::fitEllipse(pts);

    Point* rpts = new Point[4];
    cv::Point2f* pts4 = new cv::Point2f[4];
    cvrect.points(pts4);

    for (size_t j = 0; j < 4; j++) {
        Point pt = {int(lroundf(pts4[j].x)), int(lroundf(pts4[j].y))};
        rpts[j] = pt;
    }

    delete[] pts4;

    cv::Rect bRect = cvrect.boundingRect();
    Rect r = {bRect.x, bRect.y, bRect.width, bRect.height};
    Point centrpt = {int(lroundf(cvrect.center.x)), int(lroundf(cvrect.center.y))};
    Size szsz = {int(lroundf(cvrect.size.width)), int(lroundf(cvrect.size.height))};
    
    Contour c = {rpts, 4};
    RotatedRect retrect = {c, r, centrpt, szsz, cvrect.angle};
    return retrect;
}

struct RotatedRect FitEllipse2(Mat points){
    cv::RotatedRect cvrect = cv::fitEllipse(*points);

    Point* rpts = new Point[4];
    cv::Point2f* pts4 = new cv::Point2f[4];
    cvrect.points(pts4);

    for (size_t j = 0; j < 4; j++) {
        Point pt = {int(lroundf(pts4[j].x)), int(lroundf(pts4[j].y))};
        rpts[j] = pt;
    }

    delete[] pts4;

    cv::Rect bRect = cvrect.boundingRect();
    Rect r = {bRect.x, bRect.y, bRect.width, bRect.height};
    Point centrpt = {int(lroundf(cvrect.center.x)), int(lroundf(cvrect.center.y))};
    Size szsz = {int(lroundf(cvrect.size.width)), int(lroundf(cvrect.size.height))};
    
    Contour c = {rpts, 4};
    RotatedRect retrect = {c, r, centrpt, szsz, cvrect.angle};
    return retrect;
}

struct RotatedRect FitEllipseAMS(Points points){
    std::vector<cv::Point> pts;

    for (size_t i = 0; i < points.length; i++) {
        pts.push_back(cv::Point(points.points[i].x, points.points[i].y));
    }

    cv::RotatedRect cvrect = cv::fitEllipseAMS(pts);

    Point* rpts = new Point[4];
    cv::Point2f* pts4 = new cv::Point2f[4];
    cvrect.points(pts4);

    for (size_t j = 0; j < 4; j++) {
        Point pt = {int(lroundf(pts4[j].x)), int(lroundf(pts4[j].y))};
        rpts[j] = pt;
    }

    delete[] pts4;

    cv::Rect bRect = cvrect.boundingRect();
    Rect r = {bRect.x, bRect.y, bRect.width, bRect.height};
    Point centrpt = {int(lroundf(cvrect.center.x)), int(lroundf(cvrect.center.y))};
    Size szsz = {int(lroundf(cvrect.size.width)), int(lroundf(cvrect.size.height))};
    
    Contour c = {rpts, 4};
    RotatedRect retrect = {c, r, centrpt, szsz, cvrect.angle};
    return retrect;
}

struct RotatedRect FitEllipseAMS2(Mat points){
    cv::RotatedRect cvrect = cv::fitEllipseAMS(*points);

    Point* rpts = new Point[4];
    cv::Point2f* pts4 = new cv::Point2f[4];
    cvrect.points(pts4);

    for (size_t j = 0; j < 4; j++) {
        Point pt = {int(lroundf(pts4[j].x)), int(lroundf(pts4[j].y))};
        rpts[j] = pt;
    }

    delete[] pts4;

    cv::Rect bRect = cvrect.boundingRect();
    Rect r = {bRect.x, bRect.y, bRect.width, bRect.height};
    Point centrpt = {int(lroundf(cvrect.center.x)), int(lroundf(cvrect.center.y))};
    Size szsz = {int(lroundf(cvrect.size.width)), int(lroundf(cvrect.size.height))};
    
    Contour c = {rpts, 4};
    RotatedRect retrect = {c, r, centrpt, szsz, cvrect.angle};
    return retrect;
}

struct RotatedRect FitEllipseDirect(Points points){
    std::vector<cv::Point> pts;

    for (size_t i = 0; i < points.length; i++) {
        pts.push_back(cv::Point(points.points[i].x, points.points[i].y));
    }

    cv::RotatedRect cvrect = cv::fitEllipseDirect(pts);

    Point* rpts = new Point[4];
    cv::Point2f* pts4 = new cv::Point2f[4];
    cvrect.points(pts4);

    for (size_t j = 0; j < 4; j++) {
        Point pt = {int(lroundf(pts4[j].x)), int(lroundf(pts4[j].y))};
        rpts[j] = pt;
    }

    delete[] pts4;

    cv::Rect bRect = cvrect.boundingRect();
    Rect r = {bRect.x, bRect.y, bRect.width, bRect.height};
    Point centrpt = {int(lroundf(cvrect.center.x)), int(lroundf(cvrect.center.y))};
    Size szsz = {int(lroundf(cvrect.size.width)), int(lroundf(cvrect.size.height))};
    
    Contour c = {rpts, 4};
    RotatedRect retrect = {c, r, centrpt, szsz, cvrect.angle};
    return retrect;
}

struct RotatedRect FitEllipseDirect2(Mat points){
    cv::RotatedRect cvrect = cv::fitEllipseDirect(*points);

    Point* rpts = new Point[4];
    cv::Point2f* pts4 = new cv::Point2f[4];
    cvrect.points(pts4);

    for (size_t j = 0; j < 4; j++) {
        Point pt = {int(lroundf(pts4[j].x)), int(lroundf(pts4[j].y))};
        rpts[j] = pt;
    }

    delete[] pts4;

    cv::Rect bRect = cvrect.boundingRect();
    Rect r = {bRect.x, bRect.y, bRect.width, bRect.height};
    Point centrpt = {int(lroundf(cvrect.center.x)), int(lroundf(cvrect.center.y))};
    Size szsz = {int(lroundf(cvrect.size.width)), int(lroundf(cvrect.size.height))};
    
    Contour c = {rpts, 4};
    RotatedRect retrect = {c, r, centrpt, szsz, cvrect.angle};
    return retrect;
}

void Ellipse2(Mat img, RotatedRect box, Scalar color, int thickness, int lineType){
    cv::Size sz = {box.size.width, box.size.height};
    cv::Point center = {box.center.x, box.center.y};
    cv::RotatedRect cvrect = cv::RotatedRect(center, sz, float(box.angle));
    cv::Scalar c = cv::Scalar(color.val1, color.val2, color.val3, color.val4);
    
    cv::ellipse(*img, cvrect, c, thickness, lineType);
}

void PyrMeanShiftFiltering(Mat src, Mat dst, double sp, double sr, int maxLevel, TermCriteria termcrit){
    cv::pyrMeanShiftFiltering(*src, *dst, sp, sr, maxLevel, *termcrit);
}

double CLAHE_GetClipLimit(CLAHE c){
    return (*c)->getClipLimit();
} 

Size CLAHE_GetTilesGridSize(CLAHE c){
    cv::Size sz = (*c)->getTilesGridSize();
    Size _sz = {sz.width, sz.height};
    return _sz;
} 

void CLAHE_SetClipLimit(CLAHE c, double clipLimit){
    (*c)->setClipLimit(clipLimit);
}

void CLAHE_SetTilesGridSize (CLAHE c, Size tileGridSize){
    cv::Size cvSize(tileGridSize.width, tileGridSize.height);
    (*c)->setTilesGridSize(cvSize);
}
