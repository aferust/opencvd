module opencvd.contrib.ximgproc;

import std.conv;

import opencvd.cvcore;

private extern (C){
    void Thinning(Mat input, Mat output, int thinningType);
    void FourierDescriptor(Contour src, Mat dst, int nbElt, int nbFD);
    
}

void fourierDescriptor(Point[] src, Mat dst, int nbElt = -1, int nbFD = -1){
    FourierDescriptor(Contour(src.ptr, src.length.to!int), dst, nbElt, nbFD);
}

enum: int {
    // cv::ximgproc::ThinningTypes
    THINNING_ZHANGSUEN,
    THINNING_GUOHALL
}

void thinning(Mat input, Mat output, int thinningType){
    Thinning(input, output, thinningType);
}
