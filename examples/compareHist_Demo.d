import std.stdio;
import std.conv;
import std.format;
import std.random;
import std.math;

import opencvd;

// https://docs.opencv.org/2.4/doc/tutorials/imgproc/histograms/histogram_comparison/histogram_comparison.html

int main( )
{
    Mat src_base = Mat(), hsv_base = Mat();
    Mat src_test1 = Mat(), hsv_test1 = Mat();
    Mat src_test2 = Mat(), hsv_test2 = Mat();
    Mat hsv_half_down = Mat();

    /// Load three images with different environment settings
    src_base = imread( "im1.jpg", 1 );
    src_test1 = imread("im2.jpg", 1 );
    src_test2 = imread("im3.jpg", 1 );

    /// Convert to HSV
    cvtColor( src_base, hsv_base, COLOR_BGR2HSV );
    cvtColor( src_test1, hsv_test1, COLOR_BGR2HSV );
    cvtColor( src_test2, hsv_test2, COLOR_BGR2HSV );

    hsv_half_down = hsv_base[hsv_base.rows/2 .. hsv_base.rows - 1, 0 .. hsv_base.cols - 1]; // multidim slicing

    /// Using 50 bins for hue and 60 for saturation
    int h_bins = 50; int s_bins = 60;
    int[] histSize = [h_bins, s_bins];

    // hue varies from 0 to 179, saturation from 0 to 255
    float[2] h_ranges = [ 0, 180 ];
    float[2] s_ranges = [ 0, 256 ];

    float[][2] ranges = [ h_ranges, s_ranges ];

    // Use the o-th and 1-st channels
    int[] channels = [ 0, 1 ];


    /// Histograms
    Mat hist_base = Mat();
    Mat hist_half_down = Mat();
    Mat hist_test1 = Mat();
    Mat hist_test2 = Mat();

    /// Calculate the histograms for the HSV images
    calcHist( hsv_base, 1, channels, Mat(), hist_base, 2, histSize, ranges, true, false );
    normalize( hist_base, hist_base, double(0), double(1), NORM_MINMAX);

    calcHist( hsv_half_down, 1, channels, Mat(), hist_half_down, 2, histSize, ranges, true, false );
    normalize( hist_half_down, hist_half_down, 0, 1, NORM_MINMAX );

    calcHist( hsv_test1, 1, channels, Mat(), hist_test1, 2, histSize, ranges, true, false );
    normalize( hist_test1, hist_test1, 0, 1, NORM_MINMAX);

    calcHist( hsv_test2, 1, channels, Mat(), hist_test2, 2, histSize, ranges, true, false );
    normalize( hist_test2, hist_test2, 0, 1, NORM_MINMAX );

    string[6] methods;
    methods[0] = "HISTCMP_CORREL";
    methods[1] = "HISTCMP_CHISQR";
    methods[2] = "HISTCMP_INTERSECT";
    methods[3] = "HISTCMP_BHATTACHARYYA/HISTCMP_HELLINGER";
    methods[4] = "HISTCMP_CHISQR_ALT";
    methods[5] = "HISTCMP_KL_DIV";
    
    /// Apply the histogram comparison methods
    for( int i = 0; i < 4; i++ )
    {
        int compare_method = i;
        double base_base = compareHist( hist_base, hist_base, compare_method );
        double base_half = compareHist( hist_base, hist_half_down, compare_method );
        double base_test1 = compareHist( hist_base, hist_test1, compare_method );
        double base_test2 = compareHist( hist_base, hist_test2, compare_method );

        writefln( " Method [%s] Perfect, Base-Half, Base-Test(1), Base-Test(2) : %f, %f, %f, %f \n", methods[i], base_base, base_half , base_test1, base_test2 );
    }

    writeln( "Done \n" );

    return 0;
}
