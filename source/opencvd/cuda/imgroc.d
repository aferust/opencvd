module opencvd.cuda.imgroc;

import opencvd.cuda.cudacore;

private extern (C){
    void GpuCvtColor(GpuMat src, GpuMat dst, int code);
    void GpuThreshold(GpuMat src, GpuMat dst, double thresh, double maxval, int typ);
}

void gpuCvtColor(GpuMat src, GpuMat dst, int code){
    GpuCvtColor(src, dst, code);
}

void gpuThreshold(GpuMat src, GpuMat dst, double thresh, double maxval, int typ){
    GpuThreshold(src, dst, thresh, maxval, typ);
}