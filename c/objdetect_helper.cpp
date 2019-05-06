#include "objdetect_helper.h"

Size HOGDescriptor_GetWinSize(HOGDescriptor hd){
    cv::Size csz = hd->winSize;
    Size sz = {csz.width, csz.height};
    return sz;
}

void HOGDescriptor_SetWinSize(HOGDescriptor hd, Size newSize){
    cv::Size csz = {newSize.width, newSize.height};
    hd->winSize = csz;
}
