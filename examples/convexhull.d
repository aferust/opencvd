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

// https://docs.opencv.org/4.1.0/d5/d04/samples_2cpp_2convexhull_8cpp-example.html
// tested and working.

int main()
{
    Mat img = newMatWithSize(500, 500, CV8UC3);
    
    auto rnd = Random(unpredictableSeed);
    
    for(;;)
    {
        int i, count = uniform!"[]"(0, 100, rnd) + 1;
        
        Point[] _pts;
        for( i = 0; i < count; i++ )
        {
            
            int x = uniform!"[]"(img.cols/4, img.cols*3/4, rnd);
            int y = uniform!"[]"(img.rows/4, img.rows*3/4, rnd);
            
            _pts ~= Point(x, y);
        }
        Points points = Points(_pts.ptr, cast(int)_pts.length);
        
        IntVector hull = convexHullIdx(points, true);
        
        img.setTo(Scalar.all(0));
        for( i = 0; i < count; i++ )
            circle(img, points[i], 3, Scalar(0, 0, 255, 255), 1);
        int hullcount = hull.length;
        Point pt0 = points[hull[hullcount-1]];
        for( i = 0; i < hullcount; i++ )
        {
            Point pt = points[hull[i]];
            line(img, pt0, pt, Scalar(0, 255, 0, 255), 1);
            pt0 = pt;
        }
        imshow("hull", img);
        char key = cast(char)waitKey(0);
        if( key == 27 || key == 'q' || key == 'Q' ) // 'ESC'
            break;
    }
    return 0;
}
