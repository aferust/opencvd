import std.stdio;
import std.conv;
import std.algorithm.comparison: MIN = min;
import std.algorithm.comparison: MAX = max;

import opencvd;

// https://docs.opencv.org/4.1.0/d9/d73/samples_2cpp_2fitellipse_8cpp-example.html
// runs well. But legend text does not look Ok.

class canvas{
public:
    bool setupQ;
    Point origin;
    Point corner;
    int minDims,maxDims;
    double scale;
    int rows, cols;
    Mat img;
    void init(int minD, int maxD){
        // Initialise the canvas with minimum and maximum rows and column sizes.
        minDims = minD; maxDims = maxD;
        origin = Point(0,0);
        corner = Point(0,0);
        scale = 1.0;
        rows = 0;
        cols = 0;
        setupQ = false;
        img = Mat();
    }
    void stretch(Point2f min, Point2f max){
        // Stretch the canvas to include the points min and max.
        if(setupQ){
            if(corner.x < max.x){corner.x = cast(int)(max.x + 1.0);}
            if(corner.y < max.y){corner.y = cast(int)(max.y + 1.0);}
            if(origin.x > min.x){origin.x = cast(int) min.x;}
            if(origin.y > min.y){origin.y = cast(int) min.y;}
        } else {
            origin = Point(cast(int)min.x, cast(int)min.y);
            corner = Point(cast(int)(max.x + 1.0), cast(int)(max.y + 1.0));
        }
        int c = cast(int)(scale*((corner.x + 1.0) - origin.x));
        if(c<minDims){
            scale = scale * cast(double)minDims/cast(double)c;
        } else {
            if(c>maxDims){
                scale = scale * cast(double)maxDims/cast(double)c;
            }
        }
        int r = cast(int)(scale*((corner.y + 1.0) - origin.y));
        if(r<minDims){
            scale = scale * cast(double)minDims/cast(double)r;
        } else {
            if(r>maxDims){
                scale = scale * cast(double)maxDims/cast(double)r;
            }
        }
        cols = cast(int)(scale*((corner.x + 1.0) - origin.x));
        rows = cast(int)(scale*((corner.y + 1.0) - origin.y));
        setupQ = true;
    }
    void stretch(Point2f[] pts)
    {   // Stretch the canvas so all the points pts are on the canvas.
        Point2f min = pts[0];
        Point2f max = pts[0];
        for(size_t i=1; i < pts.length; i++){
            Point2f pnt = pts[i];
            if(max.x < pnt.x){max.x = pnt.x;}
            if(max.y < pnt.y){max.y = pnt.y;}
            if(min.x > pnt.x){min.x = pnt.x;}
            if(min.y > pnt.y){min.y = pnt.y;}
        }
        stretch(min, max);
    }
    void stretch(RotatedRect box)
    {   // Stretch the canvas so that the rectangle box is on the canvas.
        Point2f min = box.center.asFloat;
        Point2f max = box.center.asFloat;
        Point2f[4] vtx = box.points.asFloat;
        for( int i = 0; i < 4; i++ ){
            Point2f pnt = vtx[i];
            if(max.x < pnt.x){max.x = pnt.x;}
            if(max.y < pnt.y){max.y = pnt.y;}
            if(min.x > pnt.x){min.x = pnt.x;}
            if(min.y > pnt.y){min.y = pnt.y;}
        }
        stretch(min, max);
    }
    void drawEllipseWithBox(RotatedRect box, Scalar color, int lineThickness)
    {
        if(img.empty()){
            stretch(box);
            img = zeros(rows, cols, CV8UC3);
        }
        box.center = (scale * Point2f(box.center.x - origin.x, box.center.y - origin.y)).asInt;
        box.size.width  = cast(int)(scale * box.size.width);
        box.size.height = cast(int)(scale * box.size.height);
        ellipse(img, box, color, lineThickness, LINE_AA);
        Point2f[4] vtx = box.points.asFloat;
        for( int j = 0; j < 4; j++ ){
            line(img, vtx[j].asInt, vtx[(j+1)%4].asInt, color, lineThickness, LINE_AA);
        }
    }
    void drawPoints(Point2f[] pts, Scalar color)
    {
        if(img.empty()){
            stretch(pts);
            img = zeros(rows,cols,CV8UC3);
        }
        for(size_t i=0; i < pts.length; i++){
            Point2f pnt = scale * Point2f(pts[i].x - origin.x, pts[i].y - origin.y);
            img[cast(int)pnt.y, cast(int)pnt.x] = color;
        }
    }
    void drawLabels( string[] text, Scalar[] colors)
    {
        if(img.empty()){
            img = zeros(rows,cols,CV8UC3);
        }
        int vPos = 0;
        for (size_t i=0; i < text.length; i++) {
            Scalar color = colors[i];
            string txt = text[i];
            Size textsize = getTextSize(txt, FONT_HERSHEY_COMPLEX, 1, 1);
            vPos += cast(int)(1.3 * textsize.height);
            Point org = {(img.cols - textsize.width), vPos};
            putText(img, txt, org, FONT_HERSHEY_COMPLEX, 1, color, 1);
        }
    }
}

int sliderPos = 70;
Mat image;
bool fitEllipseQ, fitEllipseAMSQ, fitEllipseDirectQ;
Scalar fitEllipseColor       = Scalar(255,  0,  0);
Scalar fitEllipseAMSColor    = Scalar(  0,255,  0);
Scalar fitEllipseDirectColor = Scalar(  0,  0,255);
Scalar fitEllipseTrueColor   = Scalar(255,255,255);

int main( )
{
    fitEllipseQ       = true;
    fitEllipseAMSQ    = true;
    fitEllipseDirectQ = true;
    
    image = imread("ellipses.jpg", 0);
    if( image.empty() )
    {
        "Couldn't open image ".writeln;
        return 0;
    }
    imshow("source", image);
    namedWindow("result", WINDOW_NORMAL );
    // Create toolbars. HighGUI use.
    createTrackbar( "threshold", "result", &sliderPos, 255, cast(TrackbarCallback)(&processImage) );
    processImage(0, null);
    // Wait for a key stroke; the same function arranges events processing
    waitKey();
    return 0;
}
// Define trackbar callback function. This function finds contours,
// draws them, and approximates by ellipses.
void processImage(int /*h*/, void*)
{
    RotatedRect box, boxAMS, boxDirect;
    
    Mat bimage = Mat();
    bimage = image.GEInt(sliderPos); // thresholding
    
    Point[][] contours = findContours(bimage, RETR_CCOMP, CHAIN_APPROX_SIMPLE);
    
    canvas paper = new canvas();
    paper.init(cast(int)(0.8*MIN(bimage.rows, bimage.cols)), cast(int)(1.2*MAX(bimage.rows, bimage.cols)));
    paper.stretch(Point2f(0.0f, 0.0f), Point2f(cast(float)(bimage.cols+2.0), cast(float)(bimage.rows+2.0)));
    string[] text;
    Scalar[] color;
    if (fitEllipseQ) {
        text ~= "OpenCV";
        color ~= fitEllipseColor;
    }
    if (fitEllipseAMSQ) {
        text ~= "AMS";
        color ~= fitEllipseAMSColor;
    }
    if (fitEllipseDirectQ) {
        text ~= "Direct";
        color ~= fitEllipseDirectColor;
    }
    paper.drawLabels(text, color);
    int margin = 2;
    Point2f[][] points;
    for(size_t i = 0; i < contours.length; i++)
    {
        size_t count = contours[i].length;
        if( count < 6 )
            continue;
        
        Point[] pf = contours[i];
        
        Point2f[] pts;
        for (int j = 0; j < pf.length; j++) {
            Point2f pnt = pf[j].asFloat;
            if ((pnt.x > margin && pnt.y > margin && pnt.x < bimage.cols-margin && pnt.y < bimage.rows-margin)) {
                if(j%20==0){
                    pts ~= pnt;
                }
            }
        }
        points ~= pts; 
    }
    
    for(size_t i = 0; i < points.length; i++)
    {
        Point2f[] pts = points[i];
        if ( pts.length <=5 ) {
            continue;
        }
        if (fitEllipseQ) {
            box = fitEllipse(pts.asInt);
            if( MAX(box.size.width, box.size.height) > MIN(box.size.width, box.size.height)*30 ||
               MAX(box.size.width, box.size.height) <= 0 ||
               MIN(box.size.width, box.size.height) <= 0){continue;}
        }
        if (fitEllipseAMSQ) {
            boxAMS = fitEllipseAMS(pts.asInt);
            if( MAX(boxAMS.size.width, boxAMS.size.height) > MIN(boxAMS.size.width, boxAMS.size.height)*30 ||
               MAX(box.size.width, box.size.height) <= 0 ||
               MIN(box.size.width, box.size.height) <= 0){continue;}
        }
        if (fitEllipseDirectQ) {
            boxDirect = fitEllipseDirect(pts.asInt);
            if( MAX(boxDirect.size.width, boxDirect.size.height) > MIN(boxDirect.size.width, boxDirect.size.height)*30 ||
               MAX(box.size.width, box.size.height) <= 0 ||
               MIN(box.size.width, box.size.height) <= 0 ){continue;}
        }
        if (fitEllipseQ) {
            paper.drawEllipseWithBox(box, fitEllipseColor, 3);
        }
        if (fitEllipseAMSQ) {
            paper.drawEllipseWithBox(boxAMS, fitEllipseAMSColor, 2);
        }
        if (fitEllipseDirectQ) {
            paper.drawEllipseWithBox(boxDirect, fitEllipseDirectColor, 1);
        }
        paper.drawPoints(pts, Scalar(255,255,255));
    }
    imshow("result", paper.img);
}
