#include "dnn_helper.h"

IntVector DNN_NMSBoxes(RotatedRects* rects, FloatVector* _scores, float score_threshold, float nms_threshold, float eta, int top_k){
    std::vector<cv::RotatedRect> boxes;
    std::vector<float> scores;
    std::vector<int> indices;
    
    cv::dnn::NMSBoxes(boxes, scores, score_threshold, nms_threshold, indices, eta, top_k );
    
    RotatedRect *cboxes = (RotatedRect*)malloc(boxes.size()*sizeof(RotatedRect));
    
    for (size_t i = 0; i < boxes.size(); ++i){
        cv::RotatedRect cvrect =  boxes[i];
        
        Point* rpts = new Point[4];
        cv::Point2f* pts4 = new cv::Point2f[4];
        cvrect.points(pts4);

        for (size_t j = 0; j < 4; j++) {
            Point pt = {int(lroundf(pts4[j].x)), int(lroundf(pts4[j].y))};
            rpts[j] = pt;
        }

        delete[] pts4;

        cv::Rect bRect = cvrect.boundingRect();
        Rect r = {bRect.x, bRect.y, bRect.width, bRect.height};
        Point centrpt = {int(lroundf(cvrect.center.x)), int(lroundf(cvrect.center.y))};
        Size szsz = {int(lroundf(cvrect.size.width)), int(lroundf(cvrect.size.height))};
        
        Contour c = {rpts, 4};
        RotatedRect retrect = {c, r, centrpt, szsz, cvrect.angle};
        
        cboxes[i] = retrect;
    }
    rects->rects = cboxes;
    rects->length = boxes.size();
    
    /////
    float *val = new float[scores.size()];
    for (size_t i = 0; i < scores.size(); ++i){
        val[i] = scores[i];
    }
    _scores->val = val;
    _scores->length = (int)scores.size();
    /////
    
    int* ival = new int[indices.size()];
    for (size_t i = 0; i < indices.size(); ++i){
        ival[i] = indices[i];
    }
    
    IntVector ivec = {ival, (int)indices.size()};
    return ivec;
}
