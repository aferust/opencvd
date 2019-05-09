import std.stdio;
import std.format;

import opencvd.cvcore;
import opencvd.highgui;
import opencvd.imgcodecs;
import opencvd.videoio;
import opencvd.imgproc;
import opencvd.objdetect;
import opencvd.ocvversion;
import opencvd.contrib.ximgproc;

// https://docs.opencv.org/4.0.0/dc/dbc/samples_2cpp_2tutorial_code_2HighGUI_2AddingImagesTrackbar_8cpp-example.html 

const int alpha_slider_max = 100;
int alpha_slider;
double alpha;
double beta;

/// Matrices to store images
Mat src1;
Mat src2;
Mat dst;

void on_trackbar( int, void*)
{
    
    alpha = cast(double) alpha_slider/alpha_slider_max ;
    beta = ( 1.0 - alpha );
    
    addWeighted( src1, alpha, src2, beta, 0.0, dst);

    imshow( "Linear Blend", dst );
}

int main( )
{
    /// Read image ( same size, same type )
    src1 = imread("dlanglogo.png", 1);
    src2 = imread("ocvlogo.png", 1);
    
    dst = Mat();
    
    if( src1.isEmpty ) { writeln("Error loading src1 \n"); return -1; }
    if( src2.isEmpty ) { writeln("Error loading src2 \n"); return -1; }

    /// Initialize values
    alpha_slider = 0;

    /// Create Windows
    namedWindow("Linear Blend", 1);
    imshow( "Linear Blend", src1 );
    /// Create Trackbars
    
    string trackbarName = format("Alpha x %d", alpha_slider_max );
    
    TrackbarCallback cb = cast(TrackbarCallback)(&on_trackbar);
    
    auto myTb = TrackBar(trackbarName, "Linear Blend", &alpha_slider, alpha_slider_max, cb);

    /// Show some stuff
    on_trackbar( alpha_slider, null );

    /// Wait until user press some key
    waitKey(0);
    return 0;
}