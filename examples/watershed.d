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

// https://docs.opencv.org/4.0.1/d4/d40/samples_2cpp_2watershed_8cpp-example.html
// there is a bug in mouse events. X axis is not recognized.
// code does not work as expected for now.

Mat markerMask, img;
Point prevPt;

static void onMouse( int event, int x, int y, int flags, void* )
{
    
    if( x < 0 || x >= img.cols || y < 0 || y >= img.rows )
        return;
    
    if( event == EVENT_LBUTTONUP || !(flags > 0) )
        prevPt = Point(-1,-1);
    else if( event == EVENT_LBUTTONDOWN )
        prevPt = Point(x,y);
    else if( event == EVENT_MOUSEMOVE && (flags >0))
    {
        Point pt= Point(x, y);
        if( prevPt.x < 0 )
            prevPt = pt;
        line( markerMask, prevPt, pt, Scalar.all(255), 5);
        line( img, prevPt, pt, Scalar.all(255), 5);
        prevPt = pt;
        imshow("image", img);
    }
}

int main( )
{
    Mat img0 = imread("test.png", 1);
    Mat imgGray = newMat();
    if( img0.isEmpty() )
    {
        "Couldn't open image ".writeln;
        return 0;
    }
    prevPt = Point(-1, -1);
    img = newMat();
    markerMask = newMat();
    
    namedWindow( "image", 1 );
    img0.copyTo(img);
    cvtColor(img, markerMask, COLOR_BGR2GRAY);
    cvtColor(markerMask, imgGray, COLOR_GRAY2BGR);
    markerMask.setTo(Scalar.all(0));
    imshow( "image", img );
    setMouseCallback( "image", cast(MouseCallback)(&onMouse), null );
    
    for(;;)
    {
        char c = cast(char)waitKey(0);
        if( c == 27 )
            break;
        if( c == 'r' )
        {
            markerMask.setTo(Scalar.all(0));
            img0.copyTo(img);
            imshow( "image", img );
        }
        if( c == 'w' || c == ' ' )
        {
            int i, j, compCount = 0;
            
            Contours contours;
            Hierarchy hierarchy;
            
            auto c_h = findContoursWithHier(markerMask, RETR_CCOMP, CHAIN_APPROX_SIMPLE);
            contours = c_h[0];
            hierarchy = c_h[1];
            
            if( contours.length < 1)
                continue;
            Mat markers = newMatWithSize( markerMask.rows, markerMask.cols, CV32S );
            
            markers.setTo(Scalar.all(0));
            int idx = 0;
            for( ; idx >= 0; idx = cast(int)hierarchy.scalars[idx].val1, compCount++ )
                drawContours(markers, contours, idx, Scalar.all(compCount+1), -1);
            
            if( compCount == 0 )
                continue;
            
            Scalar[] colorTab; colorTab.length = compCount;
            
            auto rnd = Random(unpredictableSeed);
            
            for( i = 0; i < compCount; i++ )
            {
                double b = uniform!"[]"(0, 255, rnd);
                double g = uniform!"[]"(0, 255, rnd);
                double r = uniform!"[]"(0, 255, rnd);
                colorTab[i] = Scalar(b, g, r, 255);
            }
            double t = cast(double)getCVTickCount();
            watershed( img0, markers );
            
            t = cast(double)getCVTickCount() - t;
            writefln( "execution time = %gms", t*1000./getTickFrequency() );
            Mat wshed = newMatWithSize( markers.rows, markers.cols, CV8UC3 );
            
            // paint the watershed image
            for( i = 0; i < markers.rows; i++ )
                for( j = 0; j < markers.cols; j++ )
                {
                    int index = markers.at!int(i,j);
                    if( index == -1 )
                        wshed.setColorAt(Color(255,255,255,255), i,j);
                    else if( index <= 0 || index > compCount )
                        wshed.setColorAt(Color(0,0,0,0), i,j);
                    else
                        wshed.setColorAt(colorTab[index -1], i,j);
                }
            
            multiplyDouble(wshed, 0.5);
            multiplyDouble(imgGray, 0.5);
            add(wshed, imgGray, wshed);
            
            imshow( "watershed transform", wshed );
        }
    }
    return 0;
}
