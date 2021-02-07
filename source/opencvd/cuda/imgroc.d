module opencvd.cuda.imgroc;

import opencvd.cuda.cudacore;

private extern (C){
    void GpuCvtColor(GpuMat src, GpuMat dst, int code);
    void GpuThreshold(GpuMat src, GpuMat dst, double thresh, double maxval, int typ);

    CannyEdgeDetector CreateCannyEdgeDetector(double lowThresh, double highThresh, int appertureSize, bool L2gradient);
    GpuMat CannyEdgeDetector_Detect(CannyEdgeDetector det, GpuMat img);
    int CannyEdgeDetector_GetAppertureSize(CannyEdgeDetector det);
    double CannyEdgeDetector_GetHighThreshold(CannyEdgeDetector det);
    bool CannyEdgeDetector_GetL2Gradient(CannyEdgeDetector det);
    double CannyEdgeDetector_GetLowThreshold(CannyEdgeDetector det);
    void CannyEdgeDetector_SetAppertureSize(CannyEdgeDetector det, int appertureSize);
    void CannyEdgeDetector_SetHighThreshold(CannyEdgeDetector det, double highThresh);
    void CannyEdgeDetector_SetL2Gradient(CannyEdgeDetector det, bool L2gradient);
    void CannyEdgeDetector_SetLowThreshold(CannyEdgeDetector det, double lowThresh);
}

struct CannyEdgeDetector {
    void* p;

    @disable this();

    static CannyEdgeDetector opCall(double lowThresh, double highThresh, int appertureSize, bool L2gradient){
        return CreateCannyEdgeDetector(lowThresh, highThresh, appertureSize, L2gradient);
    }

    GpuMat detect(GpuMat img){
        return CannyEdgeDetector_Detect(this, img);
    }

    int getAppertureSize(){
        return CannyEdgeDetector_GetAppertureSize(this);
    }

    double getHighThreshold(){
        return CannyEdgeDetector_GetHighThreshold(this);
    }

    bool getL2Gradient(){
        return CannyEdgeDetector_GetL2Gradient(this);
    }

    double getLowThreshold(){
        return CannyEdgeDetector_GetLowThreshold(this);
    }

    void setAppertureSize(int appertureSize){
        CannyEdgeDetector_SetAppertureSize(this, appertureSize);
    }

    void setHighThreshold(double highThresh){
        CannyEdgeDetector_SetHighThreshold(this, highThresh);
    }

    void setL2Gradient(bool L2gradient){
        CannyEdgeDetector_SetL2Gradient(this, L2gradient);
    }

    void setLowThreshold(double lowThresh){
        CannyEdgeDetector_SetLowThreshold(this, lowThresh);
    }

}

alias gpuCvtColor = GpuCvtColor;
alias gpuThreshold = GpuThreshold;

