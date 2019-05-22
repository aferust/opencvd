import std.stdio;
import std.conv;
import std.format;
import std.random;
import std.math;

import opencvd;

// https://docs.opencv.org/4.1.0/df/dee/samples_2cpp_2minarea_8cpp-example.html

int main()
{
    Mat img = zeros(500, 500, CV_8UC3);
    auto rnd = Random(unpredictableSeed);
    while(true)
    {
        int i, count = uniform!"[]"(1, 101, rnd);
        Point[] points;
        // Generate a random set of points
        for( i = 0; i < count; i++ )
        {
            int x = uniform!"[]"(img.cols/4, img.cols*3/4, rnd);
            int y = uniform!"[]"(img.rows/4, img.rows*3/4, rnd);
            points ~= Point(x, y);
        }
        // Find the minimum area enclosing bounding box
        Point2f[4] vtx;
        RotatedRect box = minAreaRect(points);
        vtx = box.points.asFloat;
        // Find the minimum area enclosing triangle
        Point2f[] triangle;
        minEnclosingTriangle(points, triangle);
        // Find the minimum area enclosing circle
        Point2f center;
        float radius = 0; 
        minEnclosingCircle(points, &center, &radius);
        img = Scalar.all(0);
        // Draw the points
        for( i = 0; i < count; i++ )
            circle( img, points[i], 3, Scalar(0, 0, 255), FILLED, LINE_AA );
        // Draw the bounding box
        for( i = 0; i < 4; i++ )
            line(img, vtx[i].asInt, vtx[(i+1)%4].asInt, Scalar(0, 255, 0), 1, LINE_AA);
        // Draw the triangle
        for( i = 0; i < 3; i++ )
            line(img, triangle[i].asInt, triangle[(i+1)%3].asInt, Scalar(255, 255, 0), 1, LINE_AA);
        // Draw the circle
        circle(img, center.asInt, round(radius).to!int, Scalar(0, 255, 255), 1, LINE_AA);
        imshow( "Rectangle, triangle & circle", img );
        char key = cast(char)waitKey();
        if( key == 27 || key == 'q' || key == 'Q' ) // 'ESC'
            break;
    }
    return 0;
}
