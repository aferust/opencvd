# Opencvd

## Unofficial OpenCV binding for D programming language
This is an initial attempt to create an opencv binding for dlang. The C interface
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

## Tested Systems
- Ubuntu 18.04.2 LTS 64 bit - ldc2-1.8.0 - Opencv 4.0.0 built from source
- Windows 10 64 bit - ldc2-1.14.0-windows-x64 - OpenCV-master (4.10.0 AFAIK) - Visual Studio 2017 community Ed.

## Current limitations:
- There may be unwrapped opencv features.
- No documentation yet.
- Most of the functionality has not been tested yet. (need help)
- No unittests yet.
- It may be better to rewrite somethings in a more D way (use d arrays etc.).

## How to build
### Ubuntu
First, you have to compile C/C++ interface files:
```
cd opencvd/c && mkdir build
cd build
cmake ..
make // or cmake --build .
```
Then use dub to build the library.

In your app's dub.json, you may need to set linker flags like:
```
"lflags": ["-L/home/user/.dub/packages/opencvd", "-lopencvcapi", "-lopencvcapi_contrib"]
```
Your build experience may vary. I also need help for automating this.

### Windows 10 64 bit:
- Build OpenCV from source following this guide: https://docs.opencv.org/master/d3/d52/tutorial_windows_install.html
- Open x64 Native Tools Command Prompt for VS 2017 or 2015. (I will assume you use 2017).
If it is not on path already, add your ldc compiler's bin folder to path. And create an env-var to point your opencv build:
```
set PATH=%PATH%;C:\your-compilers-bin-folder\
set OpenCV_DIR=C:\your-opencv-root-folder
```
your-opencv-root-folder must contain a file named OpenCVConfig.cmake.

- cd into opencvd/c/, create a build folder, and run cmake:
```
cd opencvd/c
mkdir build
cd build
cmake .. -G "Visual Studio 15 2017 Win64"
```
This will create Visual Studio solution files in opencvd/c/build. 
- Open the solution with VS2007.
- Go to: Configuration Properties -> C/C++ -> Code Generation -> Runtime Library
- Change it from /MDd to /MT for both opencvcapi and opencvcapi_contrib (This is only working solution I've found so far).
- Build opencvcapi and opencvcapi_contrib in Visual Studio, or go back to the command prompt and type:
```
cmake --build .
```
- And finally in the cmd prompt:
```
cd opencvd
dub
```
Now you have *.lib files in opencvd folder.
- Copy thoose lib files to your test app's root next to dub.json.
- Add following to your dub.json of your test app:

```
"dependencies": {
        "opencvd": "~>0.0.1"
},
"libs": [
    "opencv_world410d",
    "opencv_img_hash410d",
    "opencvcapi",
    "opencvcapi_contrib",
    "opencvd"
]
```
While compiling your test app, you must always run dub or ldc2 commands in x64 Native Tools Command Prompt for VS 2017.
And note that we have built opencvd against shared libs of opencv4. So, Compiled executabled will need them in the PATH.

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
    
    Color color = img.at(20, 62);
    
    img.setColorAt(Color(25, 26, 27, 255), 150, 150);
    
    namedWindow("res", 0);
    Mat imres = newMat();
    
    compare(img, Scalar(200, 0, 0, 0), imres, CMP_LT);
    
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
    // or :
    Contours contours;
    Hierarchy hierarchy;
    auto c_h = findContoursWithHier(img, RETR_CCOMP, CHAIN_APPROX_SIMPLE);
    contours = c_h[0];
    hierarchy = c_h[1];
    hierarchy.scalars[0].writeln;
    
    namedWindow("hello", 0);
    imshow("hello", img);
    waitKey(0);

    writeln(img.isEmpty());

    auto m = newMat();
    writeln(m.isEmpty());
    
    Destroy(img);
    
}

```
Translation of [trackbar example](https://docs.opencv.org/4.0.0/dc/dbc/samples_2cpp_2tutorial_code_2HighGUI_2AddingImagesTrackbar_8cpp-example.html) in opencv docs:
it is very similar to C++ version.

```d
import std.stdio;
import std.format;

import opencvd.cvcore;
import opencvd.highgui;
import opencvd.imgcodecs;
import opencvd.videoio;
import opencvd.imgproc;
import opencvd.objdetect;
import opencvd.ocvversion;
import opencvd.contrib.ximgproc;

const int alpha_slider_max = 100;
int alpha_slider;
double alpha;
double beta;

/// Matrices to store images
Mat src1;
Mat src2;
Mat dst;

void on_trackbar( int, void*)
{
    
    alpha = cast(double) alpha_slider/alpha_slider_max ;
    beta = ( 1.0 - alpha );
    
    addWeighted( src1, alpha, src2, beta, 0.0, dst);

    imshow( "Linear Blend", dst );
}

int main( )
{
    /// Read image ( same size, same type )
    src1 = imread("dlanglogo.png", 1);
    src2 = imread("ocvlogo.png", 1);
    
    dst = newMat();
    
    if( src1.isEmpty ) { writeln("Error loading src1 \n"); return -1; }
    if( src2.isEmpty ) { writeln("Error loading src2 \n"); return -1; }

    /// Initialize values
    alpha_slider = 0;

    /// Create Windows
    namedWindow("Linear Blend", 1);
    imshow( "Linear Blend", src1 );
    /// Create Trackbars
    
    string trackbarName = format("Alpha x %d", alpha_slider_max );
    
    TrackbarCallback cb = cast(TrackbarCallback)(&on_trackbar);
    
    auto myTb = TrackBar(trackbarName, "Linear Blend", &alpha_slider, alpha_slider_max, cb);

    /// Show some stuff
    on_trackbar( alpha_slider, null );

    /// Wait until user press some key
    waitKey(0);
    return 0;
}

```
![alt text](trackbarexampleshot.png?raw=true)

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
