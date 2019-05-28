import std.stdio;
import std.conv;
import std.math;

import opencvd;

// https://docs.opencv.org/4.1.0/da/d94/samples_2cpp_2tutorial_code_2ml_2introduction_to_pca_2introduction_to_pca_8cpp-example.html

void drawAxis(Mat img, Point p, Point q, Scalar colour, const float scale = 0.2)
{
    double angle = atan2( cast(double) p.y - q.y, cast(double) p.x - q.x ); // angle in radians
    double hypotenuse = sqrt( cast(double) (p.y - q.y) * (p.y - q.y) + (p.x - q.x) * (p.x - q.x));
    // Here we lengthen the arrow by a factor of scale
    q.x = cast(int) (p.x - scale * hypotenuse * cos(angle));
    q.y = cast(int) (p.y - scale * hypotenuse * sin(angle));
    line(img, p, q, colour, 1, LINE_AA);
    // create the arrow hooks
    p.x = cast(int) (q.x + 9 * cos(angle + PI / 4));
    p.y = cast(int) (q.y + 9 * sin(angle + PI / 4));
    line(img, p, q, colour, 1, LINE_AA);
    p.x = cast(int) (q.x + 9 * cos(angle - PI / 4));
    p.y = cast(int) (q.y + 9 * sin(angle - PI / 4));
    line(img, p, q, colour, 1, LINE_AA);
}
double getOrientation(Point[] pts, Mat img)
{
    //Construct a buffer used by the pca analysis
    int sz = cast(int)(pts.length);
    Mat data_pts = Mat(sz, 2, CV_64F);
    for (int i = 0; i < data_pts.rows; i++)
    {
        data_pts[i, 0] = double(pts[i].x); // data_pts.setDoubleAt(i, 0, pts[i].x.to!double); 
        data_pts[i, 1] = double(pts[i].y); // data_pts.setDoubleAt(i, 1, pts[i].y.to!double);
    }
    
    //Perform PCA analysis
    PCA pca_analysis = PCA(data_pts, Mat(), PCA.DATA_AS_ROW);
    //Store the center of the object
    Point cntr = Point(cast(int)(pca_analysis.mean.at!double(0, 0)),
                       cast(int)(pca_analysis.mean.at!double(0, 1)));
    //Store the eigenvalues and eigenvectors
    Point2d[2] eigen_vecs;
    double[2] eigen_val;
    for (int i = 0; i < 2; i++)
    {
        eigen_vecs[i] = Point2d(pca_analysis.eigenvectors.at!double(i, 0),
                                pca_analysis.eigenvectors.at!double(i, 1));
        eigen_val[i] = pca_analysis.eigenvalues.at!double(i);
    }
    // Draw the principal components
    circle(img, cntr, 3, Scalar(255, 0, 255), 2);
    Point p1 = cntr + 0.02 * Point(cast(int)(eigen_vecs[0].x * eigen_val[0]), cast(int)(eigen_vecs[0].y * eigen_val[0]));
    Point p2 = cntr - 0.02 * Point(cast(int)(eigen_vecs[1].x * eigen_val[1]), cast(int)(eigen_vecs[1].y * eigen_val[1]));
    drawAxis(img, cntr, p1, Scalar(0, 255, 0), 1);
    drawAxis(img, cntr, p2, Scalar(255, 255, 0), 5);
    double angle = atan2(eigen_vecs[0].y, eigen_vecs[0].x); // orientation in radians
    return angle;
}
int main()
{
    // Load image
    Mat src = imread("pca_test1.jpg");
    // Check if image is loaded successfully
    if(src.empty())
    {
        "Problem loading image!!!".writeln;
        return -1;
    }
    imshow("src", src);
    // Convert image to grayscale
    Mat gray = Mat();
    cvtColor(src, gray, COLOR_BGR2GRAY);
    // Convert image to binary
    Mat bw = Mat();
    threshold(gray, bw, 50, 255, THRESH_BINARY);
    // Find all the contours in the thresholded image
    auto c_h = findContoursWithHier(bw, RETR_CCOMP, CHAIN_APPROX_SIMPLE);
    auto contours = c_h[0];
    
    for (size_t i = 0; i < contours.length; i++)
    {
        // Calculate the area of each contour
        double area = contourArea(contours[i]);
        // Ignore contours that are too small or too large
        if (area < 1e2 || 1e5 < area) continue;
        // Draw each contour only for visualisation purposes
        drawContours(src, contours, cast(int)(i), Scalar(0, 0, 255), 2);
        // Find the orientation of each shape
        getOrientation(contours[i], src);
    }
    imshow("bw", bw);
    imshow("output", src);
    waitKey();
    return 0;
}
