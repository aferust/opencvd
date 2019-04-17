import std.stdio;
import std.format;
import std.random;
import std.math;

import opencvd.cvcore;
import opencvd.highgui;
import opencvd.imgcodecs;
import opencvd.imgproc;

// https://docs.opencv.org/4.1.0/d6/dc7/group__imgproc__hist.html#ga4b2b5fd75503ff9e6844cc4dcdaed35d
// tested and working

void main()
{
    Mat src, hsv = Mat();
    
    src = imread("fruits.jpg", 1);
    
    cvtColor(src, hsv, COLOR_BGR2HSV);
    
    // Quantize the hue to 30 levels
    // and the saturation to 32 levels
    int hbins = 30, sbins = 32;
    int[] histSize = [hbins, sbins];
    // hue varies from 0 to 179, see cvtColor
    float[2] hranges = [0, 180 ];
    // saturation varies from 0 (black-gray-white) to
    // 255 (pure spectrum color)
    float[2] sranges = [0, 256 ];
    float[][2] ranges = [ hranges, sranges ];
    Mat hist = Mat();
    // we compute the histogram from the 0-th and 1-st channels
    int[] channels = [0, 1];
    calcHist( hsv, 1, channels, Mat(), // do not use mask
             hist, 2, histSize, ranges,
             true, // the histogram is uniform
             false );
    double maxVal;
    double minVal;
    int minIdx, maxIdx;
    minMaxLoc(hist, &minVal, &maxVal, &minIdx, &maxIdx);
    int scale = 10;
    Mat histImg = zeros(sbins*scale, hbins*10, CV8UC3);
    for( int h = 0; h < hbins; h++ )
        for( int s = 0; s < sbins; s++ )
        {
            float binVal = hist.at!float(h, s);
            int intensity = cast(int)round(binVal*255/maxVal);
            rectangle( histImg, Point(h*scale, s*scale),
                        Point( (h+1)*scale - 1, (s+1)*scale - 1),
                        Scalar.all(intensity),
                        -1 );
        }
    namedWindow( "Source", 1 );
    imshow( "Source", src );
    namedWindow( "H-S Histogram", 1 );
    imshow( "H-S Histogram", histImg );
    waitKey(0);
}
