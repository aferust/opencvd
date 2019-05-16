#include "xfeatures2d_helper.h"

SURF SURF_CreateWithParams(double hessianThreshold, int nOctaves, int nOctaveLayers, bool extended, bool upright){
    return new cv::Ptr<cv::xfeatures2d::SURF>(cv::xfeatures2d::SURF::create(hessianThreshold, nOctaves, nOctaveLayers, extended, upright));
}

bool SURF_GetExtended(SURF s){
    return (*s)->getExtended();
}

double SURF_GetHessianThreshold(SURF s){
    return (*s)->getHessianThreshold();
}

int SURF_GetNOctaveLayers(SURF s){
    return (*s)->getNOctaveLayers();
}

int SURF_GetNOctaves(SURF s){
    return (*s)->getNOctaves();
}

bool SURF_GetUpright(SURF s){
    return (*s)->getUpright();
}

void SURF_SetExtended(SURF s, bool extended){
    (*s)->setExtended(extended);
}
 
void SURF_SetHessianThreshold (SURF s, double hessianThreshold){
    (*s)->setHessianThreshold(hessianThreshold);
}
 
void SURF_SetNOctaveLayers (SURF s, int nOctaveLayers){
    (*s)->setNOctaveLayers(nOctaveLayers);
}
 
void SURF_SetNOctaves (SURF s, int nOctaves){
    (*s)->setNOctaves(nOctaves);
}
 
void SURF_SetUpright (SURF s, bool upright){
    (*s)->setUpright(upright);
}

KeyPoints SURF_DetectAndCompute2(SURF s, Mat image, Mat mask, Mat descriptors, bool useProvidedKeypoints){
    std::vector<cv::KeyPoint> detected;
    (*s)->detectAndCompute(*image, *mask, detected, *descriptors, useProvidedKeypoints);

    KeyPoint* kps = new KeyPoint[detected.size()];

    for (size_t i = 0; i < detected.size(); ++i) {
        KeyPoint k = {detected[i].pt.x, detected[i].pt.y, detected[i].size, detected[i].angle,
                      detected[i].response, detected[i].octave, detected[i].class_id
                     };
        kps[i] = k;
    }

    KeyPoints ret = {kps, (int)detected.size()};
    return ret;
}
