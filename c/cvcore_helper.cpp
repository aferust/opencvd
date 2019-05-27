#include "core.h"
#include "cvcore_helper.h"

#include <string>

void Mat_SetToWithMask(Mat m, Scalar value, Mat mask){
    cv::Scalar c_value(value.val1, value.val2, value.val3, value.val4);
    m->setTo(c_value, *mask);
}

RotatedRect New_RotatedRect(Point center, Size size, double angle){
    cv::Size2f rSize((float)size.width, (float)size.height);
    cv::Point2f centerPt = {(float)center.x, (float)center.y};
    cv::RotatedRect cvrect(centerPt, rSize, (float)angle);
    
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

void Close_Vec6fs(struct Vec6fs vec6fs){
    delete[] vec6fs.vec6fs;
}

void Close_Vec4fs(struct Vec4fs vec4fs){
    delete[] vec4fs.vec4fs;
}

void Close_Vec3fs(struct Vec3fs vec3fs){
    delete[] vec3fs.vec3fs;
}

void Close_Vec2fs(struct Vec2fs vec2fs){
    delete[] vec2fs.vec2fs;
}

void Close_Vec4is(struct Vec4is vec4is){
    delete[] vec4is.vec4is;
}

void Close_Vec3is(struct Vec3is vec3is){
    delete[] vec3is.vec3is;
}

void Close_IntVector(struct IntVector iv){
    delete[] iv.val;
}

void Close_FloatVector(struct FloatVector iv){
    delete[] iv.val;
}

void Close_DoubleVector(struct DoubleVector iv){
    delete[] iv.val;
}

void Close_CharVector(struct CharVector chv){
    delete[] chv.val;
}

int Mat_Dims(Mat m){
    return m->dims;
}

uchar* Mat_RowPtr(Mat m, int i){
    return (*m).ptr(i);
}

uchar* Mat_RowPtr2(Mat m, int row, int col){
    return (*m).ptr(row, col);
}

void* Mat_RowPtr3(Mat m, int i0, int i1, int i2){
    return (*m).ptr(i0, i1, i2);
}

void Mat_MultiplyInt(Mat m, int val){
    *m *= val;
}

void Mat_DivideInt(Mat m, int val){
    *m /= val;
}

void Mat_AddDouble(Mat m, double val){
    *m += val;
}

void Mat_SubtractDouble(Mat m, double val){
    *m -= val;
}

void Mat_AddInt(Mat m, int val) {
    *m += val;
}

void Mat_SubtractInt(Mat m, int val) {
    *m -= val;
}

void Mat_AddScalar(Mat m, Scalar s){
    cv::Scalar scalar = cv::Scalar(s.val1, s.val2, s.val3, s.val4);
    *m += scalar;
}

Mat Mat_EQInt(Mat m, int a){
    return new cv::Mat(*m == a);
}

Mat Mat_GTInt(Mat m, int a){
    return new cv::Mat(*m > a);
}

Mat Mat_GEInt(Mat m, int a){
    return new cv::Mat(*m >= a);
}

Mat Mat_LTInt(Mat m, int a){
    return new cv::Mat(*m < a);
}

Mat Mat_LEInt(Mat m, int a){
    return new cv::Mat(*m <= a);
}

Mat Mat_NEInt(Mat m, int a){
    return new cv::Mat(*m != a);
}

Mat Mat_EQDouble(Mat m, double a){
    return new cv::Mat(*m == a);
}

Mat Mat_GTDouble(Mat m, double a){
    return new cv::Mat(*m > a);
}

Mat Mat_GEDouble(Mat m, double a){
    return new cv::Mat(*m >= a);
}

Mat Mat_LTDouble(Mat m, double a){
    return new cv::Mat(*m < a);
}

Mat Mat_LEDouble(Mat m, double a){
    return new cv::Mat(*m <= a);
}

Mat Mat_NEDouble(Mat m, double a){
    return new cv::Mat(*m != a);
}

Mat Mat_ZerosFromRC(int rows, int cols, int type){
    auto out = cv::Mat::zeros(rows, cols, type);
    return new cv::Mat(out);
}

Mat Mat_ZerosFromSize(Size _sz, int type){
    cv::Size sz = {_sz.width, _sz.height};
    auto out = cv::Mat::zeros(sz, type);
    return new cv::Mat(out);
}

Mat Mat_OnesFromRC(int rows, int cols, int type){
    auto out = cv::Mat::ones(rows, cols, type);
    return new cv::Mat(out);
}

Mat Mat_OnesFromSize(Size _sz, int type){
    cv::Size sz = {_sz.width, _sz.height};
    auto out = cv::Mat::ones(sz, type);
    return new cv::Mat(out);
}

int Mat_FlatLength(Mat src){
    return static_cast<int>(src->total() * src->elemSize());
}

void* Mat_DataPtrNoCast(Mat src){
    return src->data;
}

Mat Mat_FromArrayPtr(int rows, int cols, int type, void* data){
    return new cv::Mat(rows, cols, type, data);
}

Mat Mat_FromFloatVector(FloatVector vec){
    std::vector<float> fvec;
    
    for(int i = 0; i<vec.length; i++){
        fvec.push_back(vec.val[i]);
    }
    
    return new cv::Mat(fvec, true);
        
}

Mat Mat_FromIntVector(IntVector vec){
    std::vector<int> fvec;
    
    for(int i = 0; i<vec.length; i++){
        fvec.push_back(vec.val[i]);
    }
    
    return new cv::Mat(fvec, true);
        
}

Mat Mat_HeaderFromRow(Mat src, int y){
    return new cv::Mat( src->row(y) );
}

Mat Mat_HeaderFromCol(Mat src, int x){
    return new cv::Mat( src->row(x) );
}

char* _type2str(int type){
    std::string r;

    uchar depth = type & CV_MAT_DEPTH_MASK;
    uchar chans = 1 + (type >> CV_CN_SHIFT);

    switch ( depth ) {
        case CV_8U:  r = "8U"; break;
        case CV_8S:  r = "8S"; break;
        case CV_16U: r = "16U"; break;
        case CV_16S: r = "16S"; break;
        case CV_32S: r = "32S"; break;
        case CV_32F: r = "32F"; break;
        case CV_64F: r = "64F"; break;
        default:     r = "User"; break;
    }

    r += "C";
    r += (chans+'0');

    char * cstr = (char*)malloc((r.length()+1)*sizeof(char));
    std::strcpy (cstr, r.c_str());

    return cstr;

}

void Mat_CompareWithScalar(Mat src1, Scalar src2, Mat dst, int ct) {
    cv::Scalar c_value(src2.val1, src2.val2, src2.val3, src2.val4);
    cv::compare(*src1, c_value, *dst, ct);
}

double Mat_Dot(Mat m1, Mat m2){
    return m1->dot(*m2);
}

Mat Mat_Diag(Mat src, int d){
    return new cv::Mat(src->diag(d));
}

Mat Mat_EyeFromRC(int rows, int cols, int type){
    auto out = cv::Mat::eye(rows, cols, type);
    return new cv::Mat(out);
}

Scalar Mat_ColorAt(Mat src, int row, int col){
    cv::Vec4b color = src->at<cv::Vec4b>(row, col);
    Scalar s = {(double)color[0], (double)color[1], (double)color[2], (double)color[3]};
    return s;
}

void Mat_SetColorAt(Mat src, Scalar color, int row, int col){
    cv::Vec3b c_value(color.val1, color.val2, color.val3);
    src->at<cv::Vec3b>(row, col) = c_value;
}

void Mat_MultiplyDouble(Mat m, double val) {
    *m *= val;
}

void Mat_convertTo2(Mat m, Mat dst, int rtype, double alpha, double beta){
    m->convertTo(*dst, rtype, alpha, beta);
}

void Mat_MinMaxLoc2(Mat a, double* minVal, double* maxVal, int* minIdx, int* maxIdx){
    cv::minMaxLoc(cv::SparseMat(*a), minVal, maxVal, minIdx, maxIdx);
}

void Mat_Merge2(struct Mats mats, int count, Mat dst){
    cv::merge(*mats.mats, (size_t)count, *dst);
}

struct Mats Mat_Split2(Mat src){
    std::vector<cv::Mat> channels;
    cv::split(*src, channels);
    
    Mat *_mats = new Mat[channels.size()];

    for (size_t i = 0; i < channels.size(); ++i) {
        _mats[i] = new cv::Mat(channels[i]);
    }
    
    Mats ret = {_mats, (int)channels.size()};
    return ret;
}

int Mat_SizeFromInd(Mat m, int i){
    return m->size[i];
}

int Mat_CV_MAKETYPE(int depth, int cn){
    return CV_MAKETYPE(depth, cn);
}

bool Rect_Contains(Rect r, Point p){
    cv::Rect rect = {r.x, r.y, r.width, r.height};
    cv::Point _p = {p.x, p.y};
    return rect.contains(_p);
}

Mat Mat_FromContour(Contour points){
    std::vector<cv::Point> pts;
    for (int i = 0; i < points.length; ++i){
        cv::Point pt = {points.points[i].x, points.points[i].y};
        pts.push_back(pt);
    }
    return new cv::Mat(pts);
}

PCA PCA_New(){
    return new cv::PCA();
}

PCA PCA_NewWithMaxComp(Mat data, Mat mean, int flags, int maxComponents){
    return new cv::PCA(*data, *mean, flags, maxComponents);
}

PCA PCA_NewWithRetVar(Mat data, Mat mean, int flags, double retainedVariance){
    return new cv::PCA(*data, *mean, flags, retainedVariance);
}

void PCA_BackProject(PCA pca, Mat vec, Mat result){
    pca->backProject(*vec, *result);
}

void PCA_Project(PCA pca, Mat vec, Mat result){
    pca->project(*vec, *result);
}

Mat PCA_Eigenvalues(PCA pca){
    return new cv::Mat(pca->eigenvalues);
}

Mat PCA_Eigenvectors(PCA pca){
    return new cv::Mat(pca->eigenvectors);
}
Mat PCA_Mean(PCA pca){
    return new cv::Mat(pca->mean);
}

double Get_TermCriteria_Epsilon(TermCriteria tc){
    return tc->epsilon;
}

int Get_TermCriteria_MaxCount(TermCriteria tc){
    return tc->maxCount;
}

int Get_TermCriteria_Type(TermCriteria tc){
    return tc->type;
}

void TermCriteria_Close(TermCriteria tc){
    delete tc;
}

double Kmeans(Mat data, int K, Mat bestLabels,
    TermCriteria criteria, int attempts, int flags, Mat centers){
    return cv::kmeans(*data, K, *bestLabels, *criteria, attempts, flags, *centers);
}

double Kmeans2(Mat data, int K, Mat bestLabels,
    TermCriteria criteria, int attempts, int flags, Point2fs* centers){
    
    std::vector<cv::Point2f> _centers;
    double ret = cv::kmeans(*data, K, *bestLabels, *criteria, attempts, flags, _centers);
    
    Point2f* points = (Point2f*)malloc(_centers.size()*sizeof(Point2f));
    for(int i = 0; i < _centers.size(); i++){
        Point2f p = {_centers[i].x, _centers[i].y};
        points[i] = p;
    }
    centers->points = points;
    centers->length = (int)_centers.size();
    
    return ret;
}

Mat Mat_RowRange1(Mat src, int startrow, int endrow){
    return new cv::Mat(src->rowRange(startrow, endrow));
}

void Mat_Fill_Random(uint64_t state, Mat mat, int distType, Scalar a, Scalar b, bool saturateRange){
    cv::RNG rng(state);
    cv::Scalar aa = cv::Scalar(a.val1, a.val2, a.val3, a.val4);
    cv::Scalar bb = cv::Scalar(b.val1, b.val2, b.val3, b.val4);
    rng.fill(*mat, distType, aa, bb, saturateRange);
}

void Mat_RandShuffle(uint64_t state, Mat dst, double iterFactor){
    cv::RNG rng(state);
    cv::randShuffle(*dst, iterFactor, &rng);
}

Range Range_New(){
    return new cv::Range();
}

Range Range_NewWithParams(int _start, int _end){
    return new cv::Range(_start, _end);
}

Range Range_All(){
    return new cv::Range(cv::Range::all());
}
bool Range_Empty(Range rng){
    return rng->empty();
}

int Range_Size(Range rng){
    return rng->size();
}

int Range_GetStart(Range rng){
    return rng->start;
}

int Range_GetEnd(Range rng){
    return rng->end;
}

Mat Mat_FromRanges(Mat src, Range rowRange, Range colRange){
    int st1 = Range_GetStart(rowRange);
    int en1 = Range_GetEnd(rowRange);
    int st2 = Range_GetStart(colRange);
    int en2 = Range_GetEnd(colRange);
    return new cv::Mat(*src, cv::Range(st1, en1), cv::Range(st2, en2));
}

Mat Mat_FromMultiRanges(Mat src, RangeVector rngs){
    
    std::vector<cv::Range> ranges;
    
    for(int i = 0; i < rngs.length; i++){
        Range r = rngs.ranges[i];
        int st = Range_GetStart(r);
        int en = Range_GetEnd(r);
        ranges.push_back(cv::Range(st, en));
    }
    
    return new cv::Mat(*src, ranges);
}

bool Mat_IsContinuous(Mat src){
    return src->isContinuous();
}

bool Mat_IsSubmatrix(Mat src){
    return src->isSubmatrix();
}


void Mat_LocateROI(Mat src, Size* wholeSize, Point* ofs){
    cv::Size sz;
    cv::Point p;
    src->locateROI(sz, p);
    wholeSize->height = sz.height;
    wholeSize->width = sz.width;
    ofs->x = p.x;
    ofs->y = p.y;
}
