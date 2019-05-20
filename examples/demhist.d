import std.stdio;
import std.format;
import std.random;
import std.math;

import opencvd;

// https://docs.opencv.org/4.1.0/da/d53/samples_2cpp_2demhist_8cpp-example.html
// tested and working!

int _brightness = 100;
int _contrast = 100;
Mat image;

/* brightness/contrast callback function */
static void updateBrightnessContrast( int /*arg*/, void* )
{
    int histSize = 64;
    int brightness = _brightness - 100;
    int contrast = _contrast - 100;
    /*
     * The algorithm is by Werner D. Streidt
     * (http://visca.com/ffactory/archives/5-99/msg00021.html)
     */
    double a, b;
    if( contrast > 0 )
    {
        double delta = 127.*contrast/100;
        a = 255./(255. - delta*2);
        b = a*(brightness - delta);
    }
    else
    {
        double delta = -128.*contrast/100;
        a = (256.-delta*2)/255.;
        b = a*brightness + delta;
    }
    Mat dst = Mat(), hist = Mat();
    image.convertTo(dst, CV8U, a, b);
    imshow("image", dst);
    calcHist(dst, Mat(), hist, &histSize); // there are more overloads of this function available.
    
    Mat histImage = ones(200, 320, CV8U); 
    histImage = histImage * 255;
    
    normalize(hist, hist, double(0), double(histImage.rows), NORM_MINMAX);
    histImage = Scalar.all(255);
    int binW = cast(int)round(cast(double)histImage.cols/histSize);
    for( int i = 0; i < histSize; i++ )
        rectangle( histImage, Point(i*binW, histImage.rows),
                   Point((i+1)*binW, histImage.rows - cast(int)round(hist.at!float(i))),
                   Scalar.all(0), -1, 8, 0 );
    imshow("histogram", histImage);
}

int main( )
{
    image = imread("fruits.jpg", IMREAD_GRAYSCALE);
    if(image.isEmpty())
    {
        "Cannot read image file: ".writeln;
        return -1;
    }
    namedWindow("image", 0);
    namedWindow("histogram", 0);
    createTrackbar("brightness", "image", &_brightness, 200, cast(TrackbarCallback)&updateBrightnessContrast);
    createTrackbar("contrast", "image", &_contrast, 200, cast(TrackbarCallback)&updateBrightnessContrast);
    updateBrightnessContrast(0, null);
    waitKey(0);
    return 0;
}
