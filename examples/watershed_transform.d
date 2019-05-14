import std.stdio;
import std.math;
import std.conv;
import std.algorithm.searching;
import std.algorithm.iteration;
import std.algorithm.comparison : equal;
import std.algorithm.mutation : copy;
import std.algorithm.sorting;

import opencvd.cvcore;
import opencvd.highgui;
import opencvd.imgcodecs;
import opencvd.imgproc;

// based on https://www.pyimagesearch.com/2015/11/02/watershed-opencv/

int erosion_elem = 2;
int erosion_size = 4;
Mat element;

int main() {
    
    element = getStructuringElement( MORPH_RECT,
                       Size( 2*erosion_size + 1, 2*erosion_size+1 ),
                       Point( erosion_size, erosion_size ) );
    
    //Read input image from the disk
    Mat input = imread("watershed_coins_01.jpg", IMREAD_COLOR );
    if(input.empty()) {
        "Image Not Found".writeln;
        return -1;
    }
 
    //show original image
    imshow("Original Image", input);
    
    Mat shifted = Mat();
    pyrMeanShiftFiltering(input, shifted, 21, 51);
    imshow("Shifted Image", shifted);
    
    Mat gray = Mat();
    cvtColor(shifted, gray, COLOR_BGR2GRAY);
    
    Mat thresh = Mat();
    threshold(gray, thresh, 100, 255, THRESH_BINARY);
    //imshow("thresh", thresh);
    
    // remove small regions with morphological opening
    Mat opened_im = imOpen(thresh);
    imshow("opened_im", opened_im);
    
    Mat dist = Mat();
    distanceTransform( opened_im, dist, DIST_L1, DIST_MASK_3 );
    normalize(dist, dist, 0, 1.0, NORM_MINMAX);
    threshold(dist, dist, 0.5, 1.0, THRESH_BINARY);
    Mat dist_8u = Mat();
    dist.convertTo(dist_8u, CV_8U);
    //imshow("dist_8u", dist_8u.clone*255); 
    
    auto contours = findContours(dist_8u, RETR_CCOMP, CHAIN_APPROX_SIMPLE);
    
    Mat markers = zeros(dist_8u.size(), CV_32S);
    
    foreach(int i; 0..contours.length.to!int)
        drawContours(markers, contours, i, Scalar.all(i+1), CV_FILLED);
        
    circle(markers, Point(3,3), 3, Scalar.all(255), CV_FILLED);
    
    Mat eroded = Mat();
    erode( input, eroded, element ); // they are still touching? so this is the final fix. 
    
    watershed(eroded, markers);
    
    Mat sheds = Mat(markers.size, CV_8UC1);
    sheds = Scalar.all(0);
    /*
    //int[] labels; // just for debugging
    foreach(int i; 0..markers.rows)
        foreach(int j; 0..markers.cols){
            //labels ~= markers.getIntAt(i,j);
            if ((markers.getIntAt(i,j) != 255) && (markers.getIntAt(i,j) != -1)){
                sheds.setUCharAt(i,j,255);
            }
        }
    //labels.length -= labels.sort.uniq().copy(labels).length;
    */
    bitwiseAnd(markers.NEInt(255), markers.NEInt(-1), sheds); // better without loops :)
    
    imshow("sheds", sheds);
      
    
    auto contours2 = findContours(sheds, RETR_LIST, CHAIN_APPROX_SIMPLE);
    
    foreach(i; 0..contours2.length){ // draw final detections
        Point2f center;
        float radius;
        minEnclosingCircle(contours2[i], &center, &radius);
        circle(input, center.asInt, round(radius).to!int, Scalar(0,255,0), 3);
    }
    
    imshow("result", input);
    
    waitKey(0);
    return 0;
}

Mat imOpen(Mat src) // Morphological Opening
{
    Mat erosion_dst = Mat();
    Mat dilation_dst = Mat();
                      
    erode( src, erosion_dst, element );
    dilate( erosion_dst, dilation_dst, element );
    
    return dilation_dst;
}
