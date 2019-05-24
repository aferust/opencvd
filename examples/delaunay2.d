import std.stdio;
import std.format;
import std.random;
import std.math;
import std.conv;

import opencvd;

// https://github.com/opencv/opencv/blob/master/samples/cpp/delaunay2.cpp

static void draw_subdiv_point( Mat img, Point2f fp, Scalar color )
{
    circle( img, fp.asInt, 3, color, CV_FILLED, LINE_8);
}

static void draw_subdiv( Mat img, Subdiv2D subdiv, Scalar delaunay_color )
{
    Vec6f[] triangleList = subdiv.getTriangleList();
    
    Point[] pt; pt.length = 3;

    for( size_t i = 0; i < triangleList.length; i++ )
    {
        Vec6f t = triangleList[i];
        pt[0] = Point(round(t[0]).to!int, round(t[1]).to!int);
        pt[1] = Point(round(t[2]).to!int, round(t[3]).to!int);
        pt[2] = Point(round(t[4]).to!int, round(t[5]).to!int);
        line(img, pt[0], pt[1], delaunay_color, 1, LINE_AA, 0);
        line(img, pt[1], pt[2], delaunay_color, 1, LINE_AA, 0);
        line(img, pt[2], pt[0], delaunay_color, 1, LINE_AA, 0);
    }
}


static void locate_point( Mat img, Subdiv2D subdiv, Point2f fp, Scalar active_color )
{
    int e0=0, vertex=0;

    subdiv.locate(fp, e0, vertex);

    if( e0 > 0 )
    {
        int e = e0;
        do
        {
            Point2f org, dst;
            if( subdiv.edgeOrg(e, org) > 0 && subdiv.edgeDst(e, dst) > 0 )
                line( img, org.asInt, dst.asInt, active_color, 3, LINE_AA, 0 );

            e = subdiv.getEdge(e, Subdiv2D.NEXT_AROUND_LEFT);
        }
        while( e != e0 );
    }

    draw_subdiv_point( img, fp, active_color );
}

static void paint_voronoi( Mat img, Subdiv2D subdiv )
{
    auto fl_fc = subdiv.getVoronoiFacetList();
    
    Point2f[][] facets = fl_fc[0];
    Point2f[] centers = fl_fc[1];
    
    auto rnd = Random(unpredictableSeed);
    
    for( size_t i = 0; i < facets.length; i++ )
    {
        Scalar color;
        color[0] = uniform!"[]"(0, 255, rnd).to!double;
        color[1] = uniform!"[]"(0, 255, rnd).to!double;
        color[2] = uniform!"[]"(0, 255, rnd).to!double;
        fillConvexPoly(img, facets[i].asInt, color, 8, 0);
        
        polylines(img, facets.asInt, true, Scalar(255,255,255), 1, LINE_AA, 0);
        circle(img, centers[i].asInt, 3, Scalar(255,255,255), CV_FILLED, CV_AA);
    }
}

int main()
{
    auto active_facet_color = Scalar(0, 0, 255);
    auto delaunay_color = Scalar(255,255,255);
    Rect rect = Rect(0, 0, 600, 600);

    Subdiv2D subdiv = Subdiv2D(rect);
    Mat img = Mat(rect.height, rect.width, CV8UC3);

    img = Scalar.all(0);
    string win = "Delaunay Demo";
    imshow(win, img);
    
    auto rnd = Random(unpredictableSeed);
    for( int i = 0; i < 200; i++ )
    {
        float x = uniform!"[]"(0, rect.width-10, rnd)+5;
        float y = uniform!"[]"(0, rect.height-10, rnd)+5;
        auto fp = Point2f(x, y);

        locate_point( img, subdiv, fp, active_facet_color );
        imshow( win, img );

        if( waitKey( 100 ) >= 0 )
            break;

        subdiv.insert(fp);

        img = Scalar.all(0);
        draw_subdiv( img, subdiv, delaunay_color );
        imshow( win, img );

        if( waitKey( 100 ) >= 0 )
            break;
    }

    img = Scalar.all(0);
    paint_voronoi( img, subdiv );
    imshow( win, img );

    waitKey(0);

    return 0;
}
