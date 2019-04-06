module opencvd.contrib.ximgproc;

import opencvd.cvcore;

private extern (C){
    void Thinning(Mat input, Mat output, int thinningType);
    void FourierDescriptor(Contour src, Mat dst, int nbElt, int nbFD);
    
}

void fourierDescriptor(Contour src, Mat dst, int nbElt = -1, int nbFD = -1){
    FourierDescriptor(src, dst, nbElt, nbFD);
}

enum: int {
    // cv::ximgproc::ThinningTypes
    THINNING_ZHANGSUEN,
    THINNING_GUOHALL
}

void thinning(Mat input, Mat output, int thinningType){
    Thinning(input, output, thinningType);
}
