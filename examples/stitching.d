import std.stdio;
import std.conv;

import opencvd.cvcore;
import opencvd.highgui;
import opencvd.imgcodecs;
import opencvd.imgproc;
import opencvd.stitching;

// based on: https://docs.opencv.org/4.1.0/db/db4/samples_2cpp_2stitching_8cpp-example.html

int main(string[] args)
{
    int mode = Stitcher.PANORAMA;
    
    Mat pan1 = imread("pan1.jpg", IMREAD_COLOR);
    Mat pan2 = imread("pan2.jpg", IMREAD_COLOR);
    
    Mat[] imgs = [pan1, pan2];
    
    Mat pano = Mat();
    Stitcher stitcher = Stitcher.create(mode);
    
    int status = stitcher.stitch(imgs, pano);
    
    Destroy(stitcher);
    
    if (status != Stitcher.OK)
    {
        writeln("Can't stitch images, error code = " ~ status.to!string);
        return -1;
    }
    
    "stitching completed successfully\n".writeln;
    
    imshow("panorama", pano);
    
    waitKey();
    return 0;
}
