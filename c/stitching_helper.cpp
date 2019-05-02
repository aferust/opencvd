#include "stitching_helper.h"

void Stitcher_Close(Stitcher st){
    delete st;
}

Stitcher Stitcher_Create(int mode){
    return new cv::Ptr<cv::Stitcher>(cv::Stitcher::create(cv::Stitcher::Mode(mode)));
}

int Stitcher_Stitch(Stitcher st, Mats images, Mat pano){
    std::vector<cv::Mat> imgs;
    for(int i = 0; i < images.length; i++){
        imgs.push_back(*images.mats[i]);
    } 
    cv::Stitcher::Status status = (*st)->stitch(imgs, *pano);
    return status;
}
