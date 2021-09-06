# Opencvd

## Unofficial OpenCV binding for D programming language
This is an initial attempt to create an opencv binding for dlang. The C interface
was borrowed from [gocv](https://github.com/hybridgroup/gocv), and the implementation
has been highly influenced by it.

## Contributions
* Found a bug or missing feature? open an issue or it is better you fix/wrap it and make a pull request.
* If you think that some implementation would be rewritten in a more d-idiomatic way, please implement it and make a pull request.

## Some notes
* It does not wrap c++ code directly, it uses a c wrapper around c++ code.
* All instances of Mat and some types are allocated by C++. They must be free-ed using Destroy(). There may be some examples that I forgot to call Destroy. To be sure please take a look at the cpp files. If there are "new"s or "malloc"s, you have to call Destroy() explicitly.
* Please always use git repo (~master) which is up to date. The library on the dub repo only exists for increasing the visibility
of the library.


## Requirements
Opencvd requires the following packages to build:

* OpenCV ~>4.3 ( must be built with contrib repo)
* cmake (version 3.10.2 seems working)

## Tested Systems
- Ubuntu 18.04.2 LTS 64 bit - ldc2-1.8.0
- Windows 10 64 bit - ldc2-1.19.0-windows-x64 - Visual Studio 2017 community Ed.
- Raspberry Pi 3
    (https://www.pyimagesearch.com/2018/09/26/install-opencv-4-on-your-raspberry-pi/)
- NVIDIA Jetson Nano
- OSX Sierra 10.12.5

## Notable features
- opencv c++ syntax has been tried to imitate as much as the d language allows.
- Uses d arrays when it is possible like: uses Point[][] to wrap std::vector<std::vector<cv::Point> >
Please take a look at examples folder to understand how it looks like and available functionality
- CUDA support is WIP

## Current limitations:
- There may be unwrapped opencv features.
- No documentation.
- Most of the functionality has not been tested yet.
- No unittests.

## How to build
use -D OPENCVD_CUDA:BOOL=ON for cuda support
### Ubuntu - Raspbian - Jetson Nano
First, compile opencv4 + opencv_contrib for your machine. Clone opencv and opencv_contrib repositories and execute:

```
cd <opencv_source_root>
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=RELEASE -DOPENCV_GENERATE_PKGCONFIG=YES -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules/ ..
make -j4
sudo make -j4 install
sudo ldconfig
```

Then, you have to compile C/C++ interface files:
```
cd opencvd/c && mkdir build
cd build
cmake ..
make // or cmake --build .
```
Then use dub to build the library.

In your app's dub.json, you may need to set linker flags like:
```
"dependencies": {
        "opencvd": "~>0.0.7"
},
"lflags": ["-L/home/user/.dub/packages/opencvd", "-lopencvcapi", "-lopencvcapi_contrib"]
```
and add following to dub.json of your test app:

```

"libs": [
    "opencv", // this is handled by pkgconfig. You may set it as "opencv4" depending on the name of your pkgconfig file.
    "opencvcapi",
    "opencvcapi_contrib",
]
```

Your build experience may vary. On Raspbian, you may want to use RP Official Camera, so you
have to register the camera device to be /dev/video0:
```
sudo nano /etc/modules
```
and add this line to the end of the file and reboot:
```
bcm2835-v4l2
```

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
- Open the solution with VS2017.
- Go to: Configuration Properties -> C/C++ -> Code Generation -> Runtime Library
- Change it from /MDd to /MT for both opencvcapi and opencvcapi_contrib (This is only working solution I've found so far). It looks like we cannot debug on windows yet.
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
        "opencvd": "~>0.0.7"
},
"libs": [
    "opencv_world451",
    "opencv_img_hash451",
    "opencvcapi",
    "opencvcapi_contrib"
]
```
While compiling your test app, you must always run dub or ldc2 commands in x64 Native Tools Command Prompt for VS 2017.
And note that we have built opencvd against shared libs of opencv4. So, Compiled executables will need opencv dlls in the PATH.

### OSX
- Build opencv using one of the guides found on internet such as:
https://www.learnopencv.com/install-opencv-4-on-macos/
- Before compiling any code or running your test app, set required env-vars like:
```
export PKG_CONFIG_PATH=/Users/user/opencv4-dev/installation/OpenCV-master/lib/pkgconfig/
export DYLD_LIBRARY_PATH=/Users/user/opencv4-dev/installation/OpenCV-master/lib/
```
- Build opencvcapi and opencvcapi_contrib using cmake and make commands following the ubuntu guide.

Copy libopencvcapi_contrib.a and libopencvcapi.a to the root of your example app. This is an example dub.json for test app:
```
{
	"description": "A minimal D application.",
    "dependencies": {
        "opencvd": "~>0.0.7"
	},
	"authors": [
		"Ferhat Kurtulmuş"
	],
	"copyright": "Copyright © 2019, Ferhat Kurtulmuş",
	"license": "Boost",
	"name": "testapp",
    "lflags": ["-L/Users/user/opencv4-dev/installation/OpenCV-master/lib/", "-L/Users/user/Desktop/testapp/"],
    "libs": [
        "opencv4",
        "opencvcapi",
        "opencvcapi_contrib"
    ]
}
```
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

import opencvd;

void main()
{
    Mat img = imread("test.png", 0);
    
    Mat subIm1 = img[0..$, 200..300]; // no copy, just new Mat header to windowed data
    
    auto roi = Rect(0, 0, 100, 200 );
    Mat subIm2 = img(roi); // no copy, just new Mat header to windowed data
    
    img[200..$-50, 50..200] = Scalar.all(255);
    
    ubyte[] my_ubyte_array = img.array!ubyte; // access flat array of Mat as ubyte
    // my_ubyte_array.writeln;
    
    double[] my_double_array = img.array!double; // as double
    // my_double_array.writeln;
    
    ubyte val = img.at!ubyte(50, 30);
    
    Color color = img.at(20, 62); // or img[20, 62];
    
    // img[20, 20] = Color(25, 26, 27); // assign like this if it is a 3 channel mat
    img[20, 20] = ubyte(255); // assign like this if it is a single-channel mat
    
    namedWindow("res", 0);
    Mat imres = Mat();
    
    compare(img, Scalar(200, 0, 0, 0), imres, CMP_LT);
    
    imshow("res", imres);
    
    blur(img, img, Size(3, 3));
    
    foreach(int i; 100..200)
        foreach(int j; 100..200)
            img.set!ubyte(i, j, 125);
    
    writeln(img.type2str());
    writeln(img.getSize());
    writeln(img.type());
    writeln(img.width);
    writeln(img.channels);
    writeln(img.step);


    auto cnts = findContours(img, RETR_LIST, CHAIN_APPROX_SIMPLE);
    writeln(cnts[0][0]);
    // or :
    Point[][] contours;
    Scalar[] hierarchy;
    auto c_h = findContoursWithHier(img, RETR_CCOMP, CHAIN_APPROX_SIMPLE);
    contours = c_h[0];
    contours.writeln;
    hierarchy = c_h[1];
    hierarchy.writeln;
    
    namedWindow("hello", 0);
    imshow("hello", img);

    writeln(img.isEmpty());
    
    Mat m = Mat();
    writeln(m.isEmpty());
    
    Destroy(img);
    
    auto mt = Mat(20, 20, CV_8UC3);
    
    mt[2, 3] = Color(5,6,7,255);
    mt[2, 3].writeln;
    
    ubyte[] data = [1, 2, 3,
                    4, 5, 6,
                    10,2, 3,
                    1, 1, 1
    ];
    
    Mat mymat = Mat(4, 3, CV_8U, data.ptr);
    
    mymat = mymat * 2;
    mymat = mymat + 3;
    
    ubyte[] mtdata = mymat.array!ubyte;
    mtdata.writeln;
    
    waitKey(0);
    
}

```

## Some screenshots
![alt text](examples/shots/text_detectionshot.png?raw=true)
![alt text](examples/shots/facedetectshot.png?raw=true)
![alt text](examples/shots/trackbarexampleshot.png?raw=true)


