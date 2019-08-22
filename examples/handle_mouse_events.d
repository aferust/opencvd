import std.stdio;

import opencvd;

// original C++ source: https://www.opencv-srf.com/2011/11/mouse-events.html

// !!!! please don't forget making the cb function extern (C). otherwise you get strange bugs !!!!
extern (C) void CallBackFunc(int event, int x, int y, int flags, void* userdata)
{
     if  ( event == EVENT_LBUTTONDOWN )
     {
          writeln("Left button of the mouse is clicked - position (", x,  ", ", y, ")");
     }
     else if  ( event == EVENT_RBUTTONDOWN )
     {
          writeln("Right button of the mouse is clicked - position (", x, ", ", y, ")");
     }
     else if  ( event == EVENT_MBUTTONDOWN )
     {
          writeln("Middle button of the mouse is clicked - position (", x, ", ", y,  ")");
     }
     else if ( event == EVENT_MOUSEMOVE )
     {
          writeln("Mouse move over the window - position (", x, ", ", y, ")");

     }
     
     writeln("This is your optional data: ", (cast(int*)userdata)[0..4]);
}

int main()
{
    // Read image from file 
    Mat img = imread("lena.jpg");

    //if fail to read the image
    if ( img.empty() ) 
    { 
        writeln("Error loading the image");
        return -1; 
    }

    //Create a window
    namedWindow("My Window", 1);

    //set the callback function for any mouse event
    int[4] yourData = [1,2,3,4]; // optional userdata. you may pass null instead.
    setMouseCallback("My Window", cast(MouseCallback)(&CallBackFunc), yourData.ptr);

    //show the image
    imshow("My Window", img);

    // Wait until user press some key
    waitKey(0);

    return 0;

}

