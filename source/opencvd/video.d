/*
Copyright (c) 2019 Ferhat Kurtulmuş
Boost Software License - Version 1.0 - August 17th, 2003
Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:
The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

module opencvd.video;

import opencvd.cvcore;

private {
    extern (C){
        BackgroundSubtractorMOG2 BackgroundSubtractorMOG2_Create();
        void BackgroundSubtractorMOG2_Close(BackgroundSubtractorMOG2 b);
        void BackgroundSubtractorMOG2_Apply(BackgroundSubtractorMOG2 b, Mat src, Mat dst);

        BackgroundSubtractorKNN BackgroundSubtractorKNN_Create();
        void BackgroundSubtractorKNN_Close(BackgroundSubtractorKNN b);
        void BackgroundSubtractorKNN_Apply(BackgroundSubtractorKNN b, Mat src, Mat dst);

        void CalcOpticalFlowPyrLK(Mat prevImg, Mat nextImg, Mat prevPts, Mat nextPts, Mat status, Mat err);
        void CalcOpticalFlowFarneback(Mat prevImg, Mat nextImg, Mat flow, double pyrScale, int levels,
                                      int winsize, int iterations, int polyN, double polySigma, int flags);
    }
}

struct _BackgroundSubtractorMOG2 {
    void* p;
    
    void close(){
        BackgroundSubtractorMOG2_Close(&this);
    }
    void apply(Mat src, Mat dst){
        BackgroundSubtractorMOG2_Apply(&this, src, dst);
    }
}

alias BackgroundSubtractorMOG2 = _BackgroundSubtractorMOG2*;

BackgroundSubtractorMOG2 newBackgroundSubtractorMOG2(){
    return BackgroundSubtractorMOG2_Create();
}

struct _BackgroundSubtractorKNN {
    void*p;
    
    void close(){
        BackgroundSubtractorKNN_Close(&this);
    }
    
    void apply(Mat src, Mat dst){
        BackgroundSubtractorKNN_Apply(&this, src, dst);
    }
}

alias BackgroundSubtractorKNN = _BackgroundSubtractorKNN*;

BackgroundSubtractorKNN newBackgroundSubtractorKNN(){
    return BackgroundSubtractorKNN_Create();
}

void calcOpticalFlowPyrLK(Mat prevImg, Mat nextImg, Mat prevPts, Mat nextPts, Mat status, Mat err){
    CalcOpticalFlowPyrLK(prevImg, nextImg, prevPts, nextPts, status, err);
}

void calcOpticalFlowFarneback(Mat prevImg, Mat nextImg, Mat flow, double pyrScale, int levels,
                              int winsize, int iterations, int polyN, double polySigma, int flags){
    CalcOpticalFlowFarneback(prevImg, nextImg, flow, pyrScale, levels,
                              winsize, iterations, polyN, polySigma, flags);
}
