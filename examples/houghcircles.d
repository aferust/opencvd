import std.stdio;
import std.conv;

import opencvd.cvcore;
import opencvd.highgui;
import opencvd.imgcodecs;
import opencvd.imgproc;

// https://docs.opencv.org/4.1.0/d1/de6/samples_2cpp_2tutorial_code_2ImgTrans_2houghcircles_8cpp-example.html
// tested and working!

int main()
{
    // Loads an image
    Mat src = imread( "smarties.png", IMREAD_COLOR );
    // Check if image is loaded fine
    if(src.empty()){
        writeln(" Error opening image");
        return -1;
    }
    Mat gray = Mat();
    cvtColor(src, gray, COLOR_BGR2GRAY);
    medianBlur(gray, gray, 5);
    Vec3f[] circles;
    houghCircles(gray, circles, HOUGH_GRADIENT, 1,
                 gray.rows/16,  // change this value to detect circles with different distances to each other
                 100, 30, 1, 30 // change the last two parameters
            // (min_radius & max_radius) to detect larger circles
    );
    
    for( size_t i = 0; i < circles.length; i++ )
    {
        
        Vec3f c = circles[i];
        Point center = Point(c[0].to!int, c[1].to!int);
        // circle center
        circle( src, center, 1, Scalar(0,100,100), 3, LINE_AA);
        // circle outline
        int radius = c[2].to!int;
        circle( src, center, radius, Scalar(255,0,255), 3, LINE_AA);
    }
    imshow("detected circles", src);
    waitKey();
    return 0;
}