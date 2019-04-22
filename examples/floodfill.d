import std.stdio;
import std.conv;

import opencvd.cvcore;
import opencvd.highgui;
import opencvd.imgcodecs;
import opencvd.imgproc;

// https://www.learnopencv.com/filling-holes-in-an-image-using-opencv-python-c/
// tested and working!

int main()
{
    // Read image. Source: https://raw.githubusercontent.com/spmallick/learnopencv/master/Holes/nickel.jpg
    Mat im_in = imread("nickel.jpg", IMREAD_GRAYSCALE);
 
   
    // Threshold.
    // Set values equal to or above 220 to 0.
    // Set values below 220 to 255.
    Mat im_th = Mat();
    
    threshold(im_in, im_th, 220, 255, THRESH_BINARY_INV);
     
    // Floodfill from point (0, 0)
    Mat im_floodfill = im_th.clone();
    floodFill(im_floodfill, Point(0,0), Scalar.all(255));
     
    // Invert floodfilled image
    Mat im_floodfill_inv = Mat();
    bitwiseNot(im_floodfill, im_floodfill_inv);
     
    // Combine the two images to get the foreground.
    Mat im_out = Mat();
    bitwiseOr(im_th, im_floodfill_inv, im_out);
 
    // Display images
    imshow("Thresholded Image", im_th);
    imshow("Floodfilled Image", im_floodfill);
    imshow("Inverted Floodfilled Image", im_floodfill_inv);
    imshow("Foreground", im_out);
    waitKey(0);
    
    return 0;
     
}
