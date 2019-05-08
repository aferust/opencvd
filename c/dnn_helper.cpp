#include "dnn_helper.h"

IntVector DNN_NMSBoxes(RotatedRects rects, FloatVector _scores, float score_threshold, float nms_threshold, float eta, int top_k){
    
    std::vector<float> scores;
    for (size_t i = 0; i < _scores.length; ++i){
        scores.push_back(_scores.val[i]);
    }
    
    
    
    std::vector<cv::RotatedRect> boxes;
    for (size_t i = 0; i < rects.length; ++i){
        RotatedRect rect = rects.rects[i];
        cv::Point2f centerPt((float)rect.center.x , (float)rect.center.y);
        cv::Size2f rSize((float)rect.size.width, (float)rect.size.height);
        cv::RotatedRect rotatedRectangle(centerPt, rSize, (float)rect.angle);
        
        boxes.push_back(rotatedRectangle);
    
    }
    std::vector<int> indices;
    cv::dnn::NMSBoxes(boxes, scores, score_threshold, nms_threshold, indices, eta, top_k );
    
    int* ival = new int[indices.size()];
    for (size_t i = 0; i < indices.size(); ++i){
        ival[i] = indices[i];
    }
    
    IntVector ivec = {ival, (int)indices.size()};
    return ivec;
}
