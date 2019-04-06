#include "imgproc_helper.h"

void Watershed(Mat src, Mat markers ){
    cv::watershed( *src, *markers );
}
