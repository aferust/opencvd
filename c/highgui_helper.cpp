#include "highgui_helper.h"

void Trackbar_CreateWithCallBack(const char* trackname, const char* winname, int* value, int count, TrackbarCallback on_trackbar, void* userdata){
    
    cv::createTrackbar( trackname, winname, value, count, on_trackbar, userdata );

}
