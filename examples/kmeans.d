import std.stdio;
import std.math;
import std.random;
import std.conv;
import std.algorithm.comparison: MIN = min;
import std.algorithm.comparison: MAX = max;

import opencvd;

// https://docs.opencv.org/4.1.0/d9/dde/samples_2cpp_2kmeans_8cpp-example.html
// works like a charm!

int erosion_elem = 2;
int erosion_size = 4;
Mat element;

int main()
{
    const int MAX_CLUSTERS = 5;
    Scalar[] colorTab =
    [
        Scalar(0, 0, 255),
        Scalar(0,255,0),
        Scalar(255,100,100),
        Scalar(255,0,255),
        Scalar(0,255,255)
    ];
    Mat img = Mat(500, 500, CV_8UC3);
    
    auto rnd = Random(unpredictableSeed);
    ulong rndState = 12345;
    for(;;)
    {
        int k, clusterCount = uniform!"[]"(2, MAX_CLUSTERS, rnd);
        int i, sampleCount = uniform!"[]"(1, 1001, rnd);
        Mat points = Mat(sampleCount, 1, CV_MAKETYPE(CV_32F, 2));
        Mat labels = Mat();
        clusterCount = MIN(clusterCount, sampleCount);
        Point2f[] centers;
        /* generate random sample from multigaussian distribution */
        for( k = 0; k < clusterCount; k++ )
        {
            Point center;
            center.x = uniform!"[]"(0, img.cols, rnd);
            center.y = uniform!"[]"(0, img.rows, rnd);
            Mat pointChunk = points.rowRange(k*sampleCount/clusterCount,
                                             k == clusterCount - 1 ? sampleCount :
                                             (k+1)*sampleCount/clusterCount);
            
            fillRandom(rndState++, pointChunk, RNG_NORMAL, Scalar(center.x, center.y), Scalar(img.cols*0.05, img.rows*0.05));
        }
        rndState -= clusterCount;
        randShuffle(rndState, points, 1);
        
        double compactness = kmeans(points, clusterCount, labels,
            TermCriteria( TermCriteria.EPS+TermCriteria.COUNT, 10, 1.0),
               3, KMEANS_PP_CENTERS, centers);
        
        img = Scalar.all(0);
        for( i = 0; i < sampleCount; i++ )
        {
            int clusterIdx = labels.at!int(i,0);
            float px = points.at!float(i,0);
            float py = points.at!float(i,1);
            Point ipt = Point(px.to!int, py.to!int);
            circle( img, ipt, 2, colorTab[clusterIdx], FILLED, LINE_AA );
        }
        for (i = 0; i < centers.length; ++i)
        {
            Point2f c = centers[i];
            circle( img, c.asInt, 40, colorTab[i], 1, LINE_AA );
        }
        writeln("Compactness: " ~ compactness.to!string);
        imshow("clusters", img);
        char key = cast(char)waitKey();
        if( key == 27 || key == 'q' || key == 'Q' ) // 'ESC'
            break;
    }
    return 0;
}
