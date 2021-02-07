module opencvd.cuda.cudacore;

import opencvd.cvcore;

private extern (C) {
    GpuMat GpuMat_New();
    GpuMat GpuMat_NewFromMat(Mat mat);
    void GpuMat_Upload(GpuMat m,Mat data);
    void GpuMat_Download(GpuMat m,Mat dst);
    void GpuMat_Close(GpuMat m);
    int GpuMat_Empty(GpuMat m);
    void GpuMat_ConvertTo(GpuMat m, GpuMat dst, int type);

    void PrintCudaDeviceInfo(int device);
    void PrintShortCudaDeviceInfo(int device);
    int GetCudaEnabledDeviceCount();
}

struct GpuMat {
    void* p;

    static GpuMat opCall(){
        return GpuMat_New();
    }

    static GpuMat opCall(Mat mat){
        return GpuMat_NewFromMat(mat);
    }

    void upload(Mat data){
        GpuMat_Upload(this, data);
    }

    void download(Mat dst){
        GpuMat_Download(this, dst);
    }

    void convertTo(GpuMat dst, int type){
        GpuMat_ConvertTo(this, dst, type);
    }
}

void Destroy(GpuMat m){
    GpuMat_Close(m);
}

int empty(GpuMat m){
    return GpuMat_Empty(m);
}