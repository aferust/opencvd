#include "core.h"
#include "cvcore_helper.h"

#include <string>

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

uchar* Mat_RowPtr(Mat m, int i){
    return (*m).ptr(i);
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
    cv::Size sz = {_sz.height, _sz.width};
    auto out = cv::Mat::zeros(sz, type);
    return new cv::Mat(out);
}

Mat Mat_OnesFromRC(int rows, int cols, int type){
    auto out = cv::Mat::ones(rows, cols, type);
    return new cv::Mat(out);
}

Mat Mat_OnesFromSize(Size _sz, int type){
    cv::Size sz = {_sz.height, _sz.width};
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
    cv::Scalar c_value(color.val1, color.val2, color.val3, color.val4);
    src->at<cv::Vec4b>(row, col) = c_value;
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
