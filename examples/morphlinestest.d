import std.stdio;
import std.format;
import std.random;
import std.math;

import opencvd;

//https://docs.opencv.org/3.2.0/d1/dee/tutorial_moprh_lines_detection.html (http://archive.is/bISmZ)
static void morphLinesTest(Mat src)
{
    // Show source image
    imshow("src", src);
    // Transform source image to gray if it is not
    Mat gray;
    if (src.channels() == 3)
    {
        cvtColor(src, gray, COLOR_BGR2GRAY);
    }
    else
    {
        gray = src;
    }
    // Show gray image
    imshow("gray", gray);
    // Apply adaptiveThreshold at the bitwise_not of gray, notice the ~ symbol
    Mat bw = Mat();
    bitwiseNot(gray, gray);
    adaptiveThreshold(gray, bw, 255, ADAPTIVE_THRESH_MEAN_C, THRESH_BINARY, 15, -2);
    // Show binary image
    imshow("binary", bw);
    // Create the images that will use to extract the horizontal and vertical lines
    Mat horizontal = bw.clone();
    Mat vertical = bw.clone();
    // Specify size on horizontal axis
    int horizontalsize = horizontal.cols / 30;
    // Create structure element for extracting horizontal lines through morphology operations
    Mat horizontalStructure = getStructuringElement(MORPH_RECT, Size(horizontalsize,1));
    // Apply morphology operations
    erode(horizontal, horizontal, horizontalStructure);
    dilate(horizontal, horizontal, horizontalStructure);
    // Show extracted horizontal lines
    imshow("horizontal", horizontal);
    // Specify size on vertical axis
    int verticalsize = vertical.rows / 30;
    // Create structure element for extracting vertical lines through morphology operations
    Mat verticalStructure = getStructuringElement(MORPH_RECT, Size( 1,verticalsize));
    // Apply morphology operations
    erode(vertical, vertical, verticalStructure);
    dilate(vertical, vertical, verticalStructure);
    // Show extracted vertical lines
    imshow("vertical", vertical);
    // Inverse vertical image
    bitwiseNot(vertical, vertical);
    imshow("vertical_bit", vertical);
    // Extract edges and smooth image according to the logic
    // 1. extract edges
    // 2. dilate(edges)
    // 3. src.copyTo(smooth)
    // 4. blur smooth img
    // 5. smooth.copyTo(src, edges)
    // Step 1
    Mat edges = Mat();
    adaptiveThreshold(vertical, edges, 255, ADAPTIVE_THRESH_MEAN_C, THRESH_BINARY, 3, -2);
    imshow("edges", edges);
    // Step 2
    Mat kernel = ones(2, 2, CV_8UC1);
    dilate(edges, edges, kernel);
    imshow("dilate", edges);
    // Step 3
    Mat smooth = Mat();
    vertical.copyTo(smooth);
    // Step 4
    blur(smooth, smooth, Size(2, 2));
    // Step 5
    smooth.copyToWithMask(vertical, edges);
    // Show final result
    imshow("smooth", vertical);
}

int main( )
{
    Mat image = imread("morphlines.png", IMREAD_GRAYSCALE);
    if(image.empty())
    {
        "Cannot read image file: ".writeln;
        return -1;
    }
    
    morphLinesTest(image);
    waitKey(0);
    return 0;
} 
