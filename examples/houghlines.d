import std.stdio;
import std.random;
import std.math;
import std.conv;

import opencvd.cvcore;
import opencvd.highgui;
import opencvd.imgcodecs;
import opencvd.imgproc;

// https://docs.opencv.org/4.1.0/d5/df9/samples_2cpp_2tutorial_code_2ImgTrans_2houghlines_8cpp-example.html
// tested and working!

int main()
{
    // Declare the output variables
    Mat dst = Mat(), cdst = Mat(), cdstP = Mat();
    
    // Loads an image
    Mat src = imread( "sudoku.png", IMREAD_GRAYSCALE );
    // Check if image is loaded fine
    if(src.empty()){
        writeln(" Error opening image");
        return -1;
    }
    // Edge detection
    canny(src, dst, 50, 200, 3);
    // Copy edges to the images that will display the results in BGR
    cvtColor(dst, cdst, COLOR_GRAY2BGR);
    cdstP = cdst.clone();
    // Standard Hough Line Transform
    Vec2f[] lines; // will hold the results of the detection
    houghLines(dst, lines, 1, PI/180.0, 150, 0, 0 ); // runs the actual detection
    // Draw the lines
    for( size_t i = 0; i < lines.length; i++ )
    {
        float rho = lines[i][0], theta = lines[i][1];
        Point pt1, pt2;
        double a = cos(theta), b = sin(theta);
        double x0 = a*rho, y0 = b*rho;
        pt1.x = cast(int)round(x0 + 1000*(-b));
        pt1.y = cast(int)round(y0 + 1000*(a));
        pt2.x = cast(int)round(x0 - 1000*(-b));
        pt2.y = cast(int)round(y0 - 1000*(a));
        line( cdst, pt1, pt2, Scalar(0,0,255), 3, LINE_AA);
    }
    
    // Probabilistic Line Transform
    Vec4i[] linesP; // will hold the results of the detection
    houghLinesP(dst, linesP, 1, PI/180, 50, 50, 10 ); // runs the actual detection
    
    // Draw the lines
    for( size_t i = 0; i < linesP.length; i++ )
    {
        Vec4i l = linesP[i];
        line( cdstP, Point(l[0], l[1]), Point(l[2], l[3]), Scalar(0,0,255), 3, LINE_AA);
    }
    // Show results
    imshow("Source", src);
    imshow("Detected Lines (in red) - Standard Hough Line Transform", cdst);
    imshow("Detected Lines (in red) - Probabilistic Line Transform", cdstP);
    // Wait and Exit
    waitKey();
    return 0;
}
