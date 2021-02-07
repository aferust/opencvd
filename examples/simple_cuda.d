/+

- compile c/c++ sources with cmake parameter `-DOPENCVD_CUDA=ON`

- and don't forget linking with the library file "opencvcapi_cuda"

- in your dub.json set cuda configuration like

"subConfigurations": {
    "opencvd": "cuda"
}
+/

import opencvd;

Mat testfunction(ref Mat h_original){

    Mat h_result = Mat(h_original.size(), h_original.type());

    GpuMat d_original = GpuMat(h_original);

    GpuMat d_result = GpuMat(h_original);

    d_original.upload(h_original);

    gpuThreshold(d_original, d_result, 128.0, 255.0, THRESH_BINARY);

    d_result.download(h_result);

    return h_result;
}

int main()
{
    Mat imrgb = imread("lena.png");
    Mat imgray = Mat();

    cvtColor(imrgb, imgray, COLOR_BGR2GRAY);

    Mat newimage = testfunction(imgray);

    namedWindow("original image", WINDOW_AUTOSIZE);
    namedWindow("modified image", WINDOW_AUTOSIZE);
  
    imshow("original image", imgray);
    imshow("modified image", newimage);
    waitKey(0);

    return 0;
}