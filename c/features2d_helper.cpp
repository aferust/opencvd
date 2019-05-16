#include "features2d_helper.h"

FlannBasedMatcher FlannBasedMatcher_Create1(){
    // TODO: wrap more constructors
    return new cv::FlannBasedMatcher();
}

void FlannBasedMatcher_Close(FlannBasedMatcher fbm){
    delete fbm;
}

struct MultiDMatches FlannBasedMatcher_KnnMatch(FlannBasedMatcher fbm,
    Mat queryDescriptors, Mat trainDescriptors, int k, Mat mask, bool compactResult){
    std::vector< std::vector<cv::DMatch> > matches;
    fbm->knnMatch(*queryDescriptors, *trainDescriptors, matches, k, *mask, compactResult);

    DMatches *dms = new DMatches[matches.size()];
    for (size_t i = 0; i < matches.size(); ++i) {
        DMatch *dmatches = new DMatch[matches[i].size()];
        for (size_t j = 0; j < matches[i].size(); ++j) {
            DMatch dmatch = {matches[i][j].queryIdx, matches[i][j].trainIdx, matches[i][j].imgIdx,
                             matches[i][j].distance};
            dmatches[j] = dmatch;
        }
        dms[i] = {dmatches, (int) matches[i].size()};
    }
    MultiDMatches ret = {dms, (int) matches.size()};
    return ret;
}


void DrawMatches1(Mat img1,
                KeyPoints kp1,
                Mat img2,
                KeyPoints kp2,
                DMatches matches1to2,
                Mat outImg,
                Scalar matchColor,
                Scalar singlePointColor,
                CharVector matchesMask,
                int flags){
    std::vector<cv::KeyPoint> keypts1;
    cv::KeyPoint keypt1;
    for (int i = 0; i < kp1.length; ++i) {
            keypt1 = cv::KeyPoint((float)kp1.keypoints[i].x, (float)kp1.keypoints[i].y,
                            (float)kp1.keypoints[i].size, (float)kp1.keypoints[i].angle, (float)kp1.keypoints[i].response,
                            kp1.keypoints[i].octave, kp1.keypoints[i].classID);
            keypts1.push_back(keypt1);
    }
    
    std::vector<cv::KeyPoint> keypts2;
    cv::KeyPoint keypt2;
    for (int i = 0; i < kp2.length; ++i) {
            keypt2 = cv::KeyPoint((float)kp2.keypoints[i].x, (float)kp2.keypoints[i].y,
                            (float)kp2.keypoints[i].size, (float)kp2.keypoints[i].angle, (float)kp2.keypoints[i].response,
                            kp2.keypoints[i].octave, kp2.keypoints[i].classID);
            keypts2.push_back(keypt2);
    }
    
    cv::Scalar mcolor = cv::Scalar(matchColor.val1, matchColor.val2, matchColor.val3, matchColor.val4);
    cv::Scalar spcolor = cv::Scalar(singlePointColor.val1, singlePointColor.val2, singlePointColor.val3, singlePointColor.val4);
    
    std::vector<cv::DMatch> dmcs;
    for (int i = 0; i < matches1to2.length; i++) {
        cv::DMatch cvdm = cv::DMatch(matches1to2.dmatches[i].queryIdx, matches1to2.dmatches[i].trainIdx, matches1to2.dmatches[i].imgIdx,
                             matches1to2.dmatches[i].distance);
        dmcs.push_back(cvdm);
    }
    
    std::vector< char > chvec;
    for (int i = 0; i < matchesMask.length; i++) {
        chvec.push_back(matchesMask.val[i]);
    }
    
    cv::drawMatches(*img1, keypts1, *img2, keypts2, dmcs, *outImg, mcolor, spcolor, chvec, static_cast<cv::DrawMatchesFlags>(flags));
}
