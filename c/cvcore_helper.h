#include "core.h"

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
extern "C" {
#endif

Mat Mat_ZerosFromRC(int rows, int cols, int type);
Mat Mat_ZerosFromSize(Size sz, int type);
Mat Mat_OnesFromRC(int rows, int cols, int type);
Mat Mat_OnesFromSize(Size sz, int type);
Mat Mat_FromArrayPtr(int rows, int cols, int type, void* data);
char* _type2str(int type);
void Mat_CompareWithScalar(Mat src1, Scalar src2, Mat dst, int ct);
double Mat_Dot(Mat m1, Mat m2);
Mat Mat_Diag(Mat src, int d);
Mat Mat_EyeFromRC(int rows, int cols, int type);
int Mat_FlatLength(Mat src);
void* Mat_DataPtrNoCast(Mat src);

#ifdef __cplusplus
}
#endif
