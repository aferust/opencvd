import std.stdio;

import opencvd;

// https://docs.opencv.org/4.1.0/de/dd9/samples_2cpp_2tutorial_code_2photo_2non_photorealistic_rendering_2npr_demo_8cpp-example.html

int main(string[] args)
{
    if (args.length < 2)
    {
        writeln("Example usage: " ~ args[0] ~ " lena.jpg");
        return 0;
    }
    int num,type;
    
    Mat src = imread(args[1], IMREAD_COLOR); // lena.jpg
    if(src.empty())
    {
        writeln("Could not open or find the image!");
        writeln("Usage: " ~ args[0] ~ " <Input image>");
        return 0;
    }

    "Edge Preserve Filter".writeln;
    "----------------------".writeln;
    "Options: ".writeln;
    "".writeln;
    "1) Edge Preserve Smoothing".writeln;
    "   -> Using Normalized convolution Filter".writeln;
    "   -> Using Recursive Filter".writeln;
    "2) Detail Enhancement".writeln;
    "3) Pencil sketch/Color Pencil Drawing".writeln;
    "4) Stylization".writeln;
    "".writeln;
    "Press number 1-4 to choose from above techniques: ".writeln;
    readf(" %s", &num);
    Mat img = Mat();
    if(num == 1)
    {
        "".writeln;
        "Press 1 for Normalized Convolution Filter and 2 for Recursive Filter: ".writeln;
        readf(" %s", &type);
        edgePreservingFilter(src,img,type);
        imshow("Edge Preserve Smoothing",img);
    }
    else if(num == 2)
    {
        detailEnhance(src,img);
        imshow("Detail Enhanced",img);
    }
    else if(num == 3)
    {
        Mat img1 = Mat();
        pencilSketch(src,img1, img, 10 , 0.1f, 0.03f);
        imshow("Pencil Sketch",img1);
        imshow("Color Pencil Sketch",img);
    }
    else if(num == 4)
    {
        stylization(src,img);
        imshow("Stylization",img);
    }
    waitKey(0);
    return 0;
}

