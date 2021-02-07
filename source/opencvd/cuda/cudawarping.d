module opencvd.cuda.cudawarping;

import opencvd.cvcore;
import opencvd.cuda.cudacore;

private extern (C){
    void CudaResize(GpuMat src, GpuMat dst, Size dsize, double fx, double fy, int interp);
    void CudaPyrDown(GpuMat src, GpuMat dst);
    void CudaPyrUp(GpuMat src, GpuMat dst);
    void CudaBuildWarpAffineMaps(GpuMat M, bool inverse, Size dsize, GpuMat xmap, GpuMat ymap);
    void CudaBuildWarpPerspectiveMaps(GpuMat M, bool inverse, Size dsize, GpuMat xmap, GpuMat ymap);
    void CudaRemap(GpuMat src, GpuMat dst, GpuMat xmap, GpuMat ymap, int interp, int borderMode, Scalar borderValue);
    void CudaRotate(GpuMat src, GpuMat dst, Size dsize, double angle, double xShift, double yShift, int interp);
    void CudaWarpAffine(GpuMat src, GpuMat dst, GpuMat M, Size dsize, int flags, int borderMode, Scalar borderValue);
    void CudaWarpPerspective(GpuMat src, GpuMat dst, GpuMat M, Size dsize, int flags, int borderMode, Scalar borderValue);
}

alias cudaResize = CudaResize;
alias cudaPyrDown = CudaPyrDown;
alias cudaPyrUp = CudaPyrUp;
alias cudaBuildWarpAffineMaps = CudaBuildWarpAffineMaps;
alias cudaBuildWarpPerspectiveMaps = CudaBuildWarpPerspectiveMaps;
alias cudaRemap = CudaRemap;
alias cudaRotate = CudaRotate;
alias cudaWarpAffine = CudaWarpAffine;
alias cudaWarpPerspective = CudaWarpPerspective;
