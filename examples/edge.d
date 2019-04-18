module app;
import std.stdio;
import std.format;
import std.random;

import opencvd.cvcore;
import opencvd.highgui;
import opencvd.imgcodecs;
import opencvd.videoio;
import opencvd.imgproc;
import opencvd.objdetect;
import opencvd.ocvversion;
import opencvd.contrib.ximgproc;

int edgeThresh = 1;
int edgeThreshScharr=1;
Mat image, gray, blurImage, edge1, edge2, cedge;
string window_name1 = "Edge map : Canny default (Sobel gradient)";
string window_name2 = "Edge map : Canny with custom gradient (Scharr)";
// define a trackbar callback
static void onTrackbar(int, void*)
{
    blur(gray, blurImage, Size(3,3));
    // Run the edge detector on grayscale
    canny(blurImage, edge1, edgeThresh, edgeThresh*3);
    cedge = Scalar.all(0);
    copyToWithMask(image, cedge, edge1);
    imshow(window_name1, cedge);
    Mat dx = newMat(), dy = newMat();
    scharr(blurImage, dx, CV16S, 1, 0, 1, 0, 0);
    scharr(blurImage, dy, CV16S, 0, 1, 1, 0, 0);
    canny( dx, dy, edge2, edgeThreshScharr, edgeThreshScharr*3 );
    cedge = Scalar.all(0);
    copyToWithMask(image, cedge, edge2);
    imshow(window_name2, cedge);
}

int main()
{
    //image = newMat();
    gray = newMat();
    blurImage = newMat();
    edge1 = newMat();
    edge2 = newMat();
    cedge = newMat();
    
    image = imread("fruits.jpg", 1);
    if(image.isEmpty())
    {
        writeln("Cannot read image file");
        return -1;
    }
    cedge = newMatWithSize(image.rows, image.cols, image.type());
    cvtColor(image, gray, COLOR_BGR2GRAY);
    // Create a window
    namedWindow(window_name1, 1);
    namedWindow(window_name2, 1);
    // create a toolbar
    auto tb1 = TrackBar("Canny threshold default", window_name1, &edgeThresh, 100, cast(TrackbarCallback)&onTrackbar);
    auto tb2 = TrackBar("Canny threshold Scharr", window_name2, &edgeThreshScharr, 400, cast(TrackbarCallback)&onTrackbar);
    // Show the image
    onTrackbar(0, null);
    // Wait for a key stroke; the same function arranges events processing
    waitKey(0);
    return 0;
}
