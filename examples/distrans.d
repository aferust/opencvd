import std.stdio;
import std.conv;
import std.math;

import opencvd;

// https://docs.opencv.org/4.1.0/d4/dc6/samples_2cpp_2distrans_8cpp-example.html
// tested and working

int maskSize0 = DIST_MASK_5;
int voronoiType = -1;
int edgeThresh = 100;
int distType0 = DIST_L1;
// The output and temporary images
Mat gray;
// threshold trackbar callback
static void onTrackbar( int, void* )
{
    Scalar[] colors =
    [
        Scalar(0,0,0),
        Scalar(255,0,0),
        Scalar(255,128,0),
        Scalar(255,255,0),
        Scalar(0,255,0),
        Scalar(0,128,255),
        Scalar(0,255,255),
        Scalar(0,0,255),
        Scalar(255,0,255)
    ];
    int maskSize = voronoiType >= 0 ? DIST_MASK_5 : maskSize0;
    int distType = voronoiType >= 0 ? DIST_L2 : distType0;
    Mat edge = gray.GEInt(edgeThresh), dist = Mat(), labels = Mat(), dist8u = Mat();
    if( voronoiType < 0 )
        distanceTransform( edge, dist, distType, maskSize );
    else
        distanceTransform( edge, dist, labels, distType, maskSize, voronoiType );
    if( voronoiType < 0 )
    {
        // begin "painting" the distance transform result
        dist = dist * 5000;
        matPow(dist, 0.5, dist);
        Mat dist32s = Mat(), dist8u1 = Mat(), dist8u2 = Mat();
        dist.convertTo(dist32s, CV32S, 1, 0.5);
        dist32s = Scalar.all(255);
        dist32s.convertTo(dist8u1, CV8U, 1, 0);
        dist32s = dist32s * -1;
        dist32s = dist32s + Scalar.all(255);
        dist32s.convertTo(dist8u2, CV8U);
        Mat[] planes = [dist8u1, dist8u2, dist8u2];
        merge(planes, dist8u);
    }
    else
    {
        dist8u = Mat(labels.rows, labels.cols, CV8UC3);
        for( int i = 0; i < labels.rows; i++ )
        {
            const int* ll = cast(const int*)labels.ptr(i);
            const float* dd = cast(const float*)dist.ptr(i);
            ubyte* d = cast(ubyte*)dist8u.ptr(i);
            for( int j = 0; j < labels.cols; j++ )
            {
                int idx = ll[j] == 0 || dd[j] == 0 ? 0 : (ll[j]-1)%8 + 1;
                float scale = 1.0f/(1 + dd[j]*dd[j]*0.0004f);
                int b = cast(int)round(colors[idx][0]*scale);
                int g = cast(int)round(colors[idx][1]*scale);
                int r = cast(int)round(colors[idx][2]*scale);
                d[j*3] = cast(ubyte)b;
                d[j*3+1] = cast(ubyte)g;
                d[j*3+2] = cast(ubyte)r;
            }
        }
    }
    imshow("Distance Map", dist8u );
}

int main( )
{
    gray = imread("stuff.jpg", 0);
    if(gray.empty())
    {
        writeln("Cannot read image file");
        return -1;
    }
    namedWindow("Distance Map", 1);
    createTrackbar("Brightness Threshold", "Distance Map", &edgeThresh, 255, cast(TrackbarCallback)&onTrackbar);
    for(;;)
    {
        // Call to update the view
        onTrackbar(0, null);
        char c = cast(char)waitKey(0);
        if( c == 27 )
            break;
        if( c == 'c' || c == 'C' || c == '1' || c == '2' ||
            c == '3' || c == '5' || c == '0' )
            voronoiType = -1;
        if( c == 'c' || c == 'C' )
            distType0 = DIST_C;
        else if( c == '1' )
            distType0 = DIST_L1;
        else if( c == '2' )
            distType0 = DIST_L2;
        else if( c == '3' )
            maskSize0 = DIST_MASK_3;
        else if( c == '5' )
            maskSize0 = DIST_MASK_5;
        else if( c == '0' )
            maskSize0 = DIST_MASK_PRECISE;
        else if( c == 'v' )
            voronoiType = 0;
        else if( c == 'p' )
            voronoiType = 1;
        else if( c == ' ' )
        {
            if( voronoiType == 0 )
                voronoiType = 1;
            else if( voronoiType == 1 )
            {
                voronoiType = -1;
                maskSize0 = DIST_MASK_3;
                distType0 = DIST_C;
            }
            else if( distType0 == DIST_C )
                distType0 = DIST_L1;
            else if( distType0 == DIST_L1 )
                distType0 = DIST_L2;
            else if( maskSize0 == DIST_MASK_3 )
                maskSize0 = DIST_MASK_5;
            else if( maskSize0 == DIST_MASK_5 )
                maskSize0 = DIST_MASK_PRECISE;
            else if( maskSize0 == DIST_MASK_PRECISE )
                voronoiType = 0;
        }
    }
    return 0;
}
