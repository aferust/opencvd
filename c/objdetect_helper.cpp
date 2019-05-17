#include "objdetect_helper.h"

bool CascadeClassifier_Empty(CascadeClassifier cs) {
    return cs->empty();
}

Size HOGDescriptor_GetWinSize(HOGDescriptor hd){
    cv::Size csz = hd->winSize;
    Size sz = {csz.width, csz.height};
    return sz;
}

void HOGDescriptor_SetWinSize(HOGDescriptor hd, Size newSize){
    cv::Size csz = {newSize.width, newSize.height};
    hd->winSize = csz;
}

void HOGDescriptor_Compute(HOGDescriptor hd, Mat img, FloatVector descriptors, Size winStride, Size padding, Points locations){
    std::vector<float> fvec;
    
    for(int i = 0; i<descriptors.length; i++){
        fvec.push_back(descriptors.val[i]);
    }
    
    cv::Size ws = {winStride.width, winStride.height};
    cv::Size pd = {padding.width, padding.height};
    
    std::vector< cv::Point > loc;
    for(int i = 0; i<locations.length; i++){
        cv::Point p = {locations.points[i].x, locations.points[i].y};
        loc.push_back(p);
    }
    
    hd->compute(*img, fvec, ws, pd, loc);
}

void HOGDescriptor_DetectMultiScale2(HOGDescriptor hd,
                                    Mat img,
                                    Rects* foundLocations,
                                    DoubleVector* foundWeights,
                                    double hitThreshold,
                                    Size winStride,
                                    Size padding,
                                    double scale,
                                    double finalThreshold,
                                    bool useMeanshiftGrouping){
    std::vector<cv::Rect> fLoc;
    std::vector<double> fw;
    cv::Size ws = {winStride.width, winStride.height};
    cv::Size pd = {padding.width, padding.height};
    
    hd->detectMultiScale(*img, fLoc, fw, hitThreshold, ws, pd, scale, finalThreshold, useMeanshiftGrouping );
    
    Rect* fl = new Rect[fLoc.size()];
    for(size_t i = 0; i<fLoc.size(); i++){
        Rect rc = {fLoc[i].x, fLoc[i].y, fLoc[i].width, fLoc[i].height};
        fl[i] = rc;
    }
    foundLocations->rects = fl;
    foundLocations->length = (int)fLoc.size();
    
    double* fwei = new double[fw.size()];
    for(size_t i = 0; i<fw.size(); i++){
        fwei[i] = fw[i];
    }
    
    foundWeights->val = fwei;
    foundWeights->length = (int)fw.size();
}

void HOGDescriptor_Save(HOGDescriptor hd, const char* filename){
    hd->save(filename);
}
