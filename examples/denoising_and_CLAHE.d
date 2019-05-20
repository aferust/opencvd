import std.stdio;
import std.format;
import std.random;
import std.math;

import opencvd;

// idea is from Freddie Honohan

static void applyContrastLimitedAdaptiveHistogramEqualisation(Mat src)
{
    auto clahe = CLAHE();
    auto claheCustom = CLAHE(10.0, Size(100,100));
    
    Mat dst = Mat();
    clahe.apply(src, dst);
    imshow("clahe1",dst);

    Mat dst2 = Mat();
    claheCustom.apply(src, dst2);
    imshow("clahe2", dst2);

    Destroy(clahe);
    Destroy(claheCustom);
}

/* denoising function */
static void removeNoise(Mat src)
{
    Mat dst = Mat();
    
    fastNlMeansDenoising(src, src);
    
    imshow("denoised",src);
}

int main( )
{
    Mat image = imread("sudoku.png", IMREAD_GRAYSCALE);
    
    if(image.empty())
    {
        "Cannot read image file: ".writeln;
        return -1;
    }
    
    removeNoise(image);
    applyContrastLimitedAdaptiveHistogramEqualisation(image);
    
    waitKey(0);
    return 0;
} 
