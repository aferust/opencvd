#include "core.h"

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
extern "C" {
#endif

Mat ZerosFromRC(int rows, int cols, int type);
Mat ZerosFromSize(Size sz, int type);
Mat OnesFromRC(int rows, int cols, int type);
Mat OnesFromSize(Size sz, int type);
Mat Mat_FromArrayPtr(int rows, int cols, int type, void* data);
char* _type2str(int type);
void Mat_CompareWithScalar(Mat src1, Scalar src2, Mat dst, int ct);

#ifdef __cplusplus
}
#endif
