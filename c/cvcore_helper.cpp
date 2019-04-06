#include "core.h"
#include "cvcore_helper.h"

#include <string>

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

Mat Mat_FromArrayPtr(int rows, int cols, int type, void* data){
    return new cv::Mat(rows, cols, type, data);
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

    char * cstr = new char [r.length()+1];
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
