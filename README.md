# Opencvd

## Unofficial OpenCV binding for D programming language
This is an initial attempt to create an opencv binding for dlang. C interfacing
was taken from [gocv](https://github.com/hybridgroup/gocv), and the implementation
has been highly influenced by it.

## Disclaimer
I don't describe myself as the most brillant d programmmer around. I am still learning.
Pull requests are welcome for growing and enhancing the binding. I am willing to add more
contributors to the project. Let's make it a complete binding to opencv.

## Requirements
Opencvd requires the following packeges to build:

* OpenCV ~>4.0 ( must be built with contrib repo)
* cmake (version of 3.10.2 is installed in my system)

## Current limitations:
- Tested only on Ubuntu (Ubuntu 18.04.2 LTS 64 bit) using ldc2-1.8.0 (I need help for windows builds)
- There may be unwrapped opencv features.
- No documentation yet.
- Most of the functionality has not been tested yet. (need help)
- No unittests yet.
- It may be better to rewrite somethings in a more D way (use d arrays etc.).

## How to build
First, you have to compile C/C++ interface files:
```
cd opencvd/c && mkdir build
cd build
cmake ..
make // or cmake --build .
```
Then use dub to build the library.

In your app's dub.json, you need to set linker flags like:
```
"lflags": ["-L/home/user/.dub/packages/opencvd", "-lopencvcapi", "-lopencvcapi_contrib"]
```
Your build experience may vary. I also need help for automating this.

## Some notes about C interface (C++ functions with C externs)
Gocv does not wrap some important functionality of opencv.
Opencvd will cover some of those wrapping them in c++ sources with
appropriate naming such as core -> core_helper, imgproc -> imgproc_helper.
Thus, differences from gocv can be tracked easily. This should be a
temporary solution untill a clear roadmap of opencvd project is
determined by its community.

## Some examples to show how it looks like:

```d
import std.stdio;

import opencvd.cvcore;
import opencvd.imgcodecs;
import opencvd.highgui;
import opencvd.videoio;
import opencvd.imgproc;
import opencvd.objdetect;
import opencvd.ocvversion;

void main()
{
    Mat img = imread("test.png", 0);
    
    ubyte[] my_ubyte_array = img.array!ubyte; // access flat array of Mat as ubyte
    my_ubyte_array.writeln;
    
    double[] my_double_array = img.array!double; // as double
    my_double_array.writeln;
    
    ubyte val = img.at!ubyte(50, 30);
    
    Scalar color = img.at(20, 62);
    
    namedWindow("res", 0);
    Mat imbin = newMat();
    
    compare(img, Scalar(200, 0, 0, 0), imbin, CMP_LT); // a way of manual thresholding
    
    imshow("res", imbin);
    
    blur(img, img, Size(3, 3));
    
    foreach(int i; 100..200)
        foreach(int j; 100..200)
            img.setUCharAt(i, j, 125);
    
    writeln(img.type2str());
    writeln(img.getSize());
    writeln(img.type());
    writeln(img.width);
    writeln(img.channels);
    writeln(img.step);


    auto cnts = findContours(img, RETR_LIST, CHAIN_APPROX_SIMPLE);
    writeln(cnts.contours[0].points[0]);

    namedWindow("hello", 0);
    imshow("hello", img);
    waitKey(0);

    writeln(img.isEmpty());

    auto m = newMat();
    writeln(m.isEmpty());
    
    Destroy(img);
    
}

```

Face detection with webcam (translated from https://www.geeksforgeeks.org/opencv-c-program-face-detection/)
```d
import std.stdio;

import opencvd.cvcore;
import opencvd.highgui;
import opencvd.videoio;
import opencvd.imgproc;
import opencvd.objdetect;
import opencvd.ocvversion;

void main()
{
    auto cap = newVideoCapture();
    cap.fromDevice(0);

    namedWindow("mywin", WND_PROP_AUTOSIZE);
    setWindowTitle("mywin", "süper pencere / 超级窗口");
    
    // PreDefined trained XML classifiers with facial features 
    CascadeClassifier cascade, nestedCascade;
    cascade = newCascadeClassifier();
    nestedCascade = newCascadeClassifier();
    
    double scale=1; 
  
    // Load classifiers from "opencv/data/haarcascades" directory  
    nestedCascade.load( "/home/user/Desktop/opencv_d/test_data/haarcascade_eye_tree_eyeglasses.xml" ) ;
    
    // Change path before execution  
    cascade.load( "/home/user/Desktop/opencv_d/test_data/haarcascade_frontalcatface.xml" ) ; 
    if( cap.isOpened() )
    while(true)
    {
        Mat frame = newMat();

        cap.read(frame);
        
        //cvtColor(frame, frame, COLOR_BGR2GRAY);
        
        //imshow("mywin", frame);
        Mat frame1 = frame.clone();
            detectAndDraw( frame1, cascade, nestedCascade, scale );
        
        if (waitKey(10) == 27) break;
        
        Destroy(frame);
        Destroy(frame1);
    }
    opencvVersion().writeln;
    cap.close();
    
}

void detectAndDraw( Mat img, CascadeClassifier cascade, 
                    CascadeClassifier nestedCascade, 
                    double scale)
{ 
    import std.math;
    
    Rects faces, faces2; 
    Mat gray, smallImg; 
    gray = newMat(); smallImg = newMat();
    
    cvtColor( img, gray, COLOR_BGR2GRAY ); // Convert to Gray Scale
    
    double fx = 1 / scale; 
  
    // Resize the Grayscale Image  
    resize( gray, smallImg, Size(), fx, fx, 0 );  
    equalizeHist( smallImg, smallImg ); 
  
    // Detect faces of different sizes using cascade classifier  
    faces = cascade.detectMultiScale(smallImg);
    // Draw circles around the faces 
    for ( int i = 0; i < faces.length; i++ ) 
    { 
        Rect r = faces.rects[i];
        Mat smallImgROI; 
        Rects nestedObjects;
        Point center; 
        Scalar color = Scalar(255, 0, 0, 0); // Color for Drawing tool 
        int radius; 
  
        double aspect_ratio = cast(double)r.width/r.height; 
        if( 0.75 < aspect_ratio && aspect_ratio < 1.3 ) 
        { 
            center.x = cast(int)round((r.x + r.width*0.5)*scale); 
            center.y = cast(int)round((r.y + r.height*0.5)*scale); 
            radius = cast(int)round((r.width + r.height)*0.25*scale); 
            circle( img, center, radius, color, 3 );
        } 
        else
            rectangle( img, Rect(cast(int)round(r.x*scale), cast(int)round(r.y*scale), 50, 50), color, 3 );
        if( !nestedCascade ) 
            continue; 
        smallImgROI = matFromRect(smallImg, r);
        
        // Detection of eyes int the input image 
        nestedObjects = nestedCascade.detectMultiScale(smallImgROI);
          
        // Draw circles around eyes 
        for ( int j = 0; j < nestedObjects.length; j++ )  
        { 
            Rect nr = nestedObjects.rects[j]; 
            center.x = cast(int)round((r.x + nr.x + nr.width*0.5)*scale); 
            center.y = cast(int)round((r.y + nr.y + nr.height*0.5)*scale); 
            radius = cast(int)round((nr.width + nr.height)*0.25*scale); 
            circle( img, center, radius, color, 3); 
        } 
    } 
  
    // Show Processed Image with detected faces 
    imshow( "mywin", img );  
}
```
![alt text](facedetectshot.png?raw=true)
