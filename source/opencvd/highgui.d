/*
Copyright (c) 2019 Ferhat Kurtulmuş
Boost Software License - Version 1.0 - August 17th, 2003
Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:
The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

module opencvd.highgui;

import std.string;

import opencvd.cvcore;

// function pointers
extern (C) @nogc nothrow {
    alias TrackbarCallback = void function(int, void*);
    alias MouseCallback = void function(int, int, int, int, void*);
}

enum: int {
    EVENT_MOUSEMOVE      = 0, //!< indicates that the mouse pointer has moved over the window.
    EVENT_LBUTTONDOWN    = 1, //!< indicates that the left mouse button is pressed.
    EVENT_RBUTTONDOWN    = 2, //!< indicates that the right mouse button is pressed.
    EVENT_MBUTTONDOWN    = 3, //!< indicates that the middle mouse button is pressed.
    EVENT_LBUTTONUP      = 4, //!< indicates that left mouse button is released.
    EVENT_RBUTTONUP      = 5, //!< indicates that right mouse button is released.
    EVENT_MBUTTONUP      = 6, //!< indicates that middle mouse button is released.
    EVENT_LBUTTONDBLCLK  = 7, //!< indicates that left mouse button is double clicked.
    EVENT_RBUTTONDBLCLK  = 8, //!< indicates that right mouse button is double clicked.
    EVENT_MBUTTONDBLCLK  = 9, //!< indicates that middle mouse button is double clicked.
    EVENT_MOUSEWHEEL     = 10,//!< positive and negative values mean forward and backward scrolling, respectively.
    EVENT_MOUSEHWHEEL    = 11 //!< positive and negative values mean right and left scrolling, respectively.
}

enum: int {
    EVENT_FLAG_LBUTTON   = 1, //!< indicates that the left mouse button is down.
    EVENT_FLAG_RBUTTON   = 2, //!< indicates that the right mouse button is down.
    EVENT_FLAG_MBUTTON   = 4, //!< indicates that the middle mouse button is down.
    EVENT_FLAG_CTRLKEY   = 8, //!< indicates that CTRL Key is pressed.
    EVENT_FLAG_SHIFTKEY  = 16,//!< indicates that SHIFT Key is pressed.
    EVENT_FLAG_ALTKEY    = 32 //!< indicates that ALT Key is pressed.
}
private extern (C) @nogc nothrow {
    // Window
    void Window_New(const char* winname, int flags);
    void Window_Close(const char* winname);
    void Window_IMShow(const char* winname, Mat mat);
    double Window_GetProperty(const char* winname, int flag);
    void Window_SetProperty(const char* winname, int flag, double value);
    void Window_SetTitle(const char* winname, const char* title);
    int Window_WaitKey(int);
    void Window_Move(const char* winname, int x, int y);
    void Window_Resize(const char* winname, int width, int height);
    Rect Window_SelectROI(const char* winname, Mat img);
    Rects Window_SelectROIs(const char* winname, Mat img);

    // Trackbar
    void Trackbar_CreateWithCallBack(const char* winname, const char* trackname, int* value, int count, TrackbarCallback on_trackbar, void* userdata);
    
    void Trackbar_Create(const char* winname, const char* trackname, int max);
    int Trackbar_GetPos(const char* winname, const char* trackname);
    void Trackbar_SetPos(const char* winname, const char* trackname, int pos);
    void Trackbar_SetMin(const char* winname, const char* trackname, int pos);
    void Trackbar_SetMax(const char* winname, const char* trackname, int pos);
    
    void Win_setMouseCallback(const	char* winname, MouseCallback onMouse, void *userdata);
}

enum: int { // cv::WindowFlags
       WINDOW_NORMAL     = 0x00000000, //!< the user can resize the window (no constraint) / also use to switch a fullscreen window to a normal size.
       WINDOW_AUTOSIZE   = 0x00000001, //!< the user cannot resize the window, the size is constrainted by the image displayed.
       WINDOW_OPENGL     = 0x00001000, //!< window with opengl support.
       WINDOW_FULLSCREEN = 1,          //!< change the window to fullscreen.
       WINDOW_FREERATIO  = 0x00000100, //!< the image expends as much as it can (no ratio constraint).
       WINDOW_KEEPRATIO  = 0x00000000, //!< the ratio of the image is respected.
       WINDOW_GUI_EXPANDED=0x00000000, //!< status bar and tool bar
       WINDOW_GUI_NORMAL = 0x00000010, //!< old fashious way
}

void namedWindow(string winname, int flags = 0) @nogc nothrow {
    Window_New(winname.ptr, flags);
}

int waitKey(int val = 0) @nogc nothrow {
    return Window_WaitKey(val);
}

void destroyWindow(string winname) @nogc nothrow {
    Window_Close(winname.ptr);
}

void imshow(string winname, Mat mat) @nogc nothrow {
    Window_IMShow(winname.ptr, mat);
}

enum: int {
    WND_PROP_FULLSCREEN = 0,
    WND_PROP_AUTOSIZE = 1,
    WND_PROP_ASPECT_RATIO = 2,
    WND_PROP_OPENGL = 3
}


double getWindowProperty(string winname, int flag) @nogc nothrow {
    return Window_GetProperty(winname.ptr, flag);
}

void setWindowProperty(string winname, int flag, double value) @nogc nothrow {
    Window_SetProperty(winname.ptr, flag, value);
}

void setWindowTitle(string winname, string title) @nogc nothrow {
    Window_SetTitle(winname.ptr, title.ptr);
}

void moveWindow(string winname, int x, int y) @nogc nothrow {
    Window_Move(winname.ptr, x, y);
}

void resizeWindow(string winname, int width, int height) @nogc nothrow {
    Window_Resize(winname.ptr, width, height);
}

Rect selectROI(string winname, Mat img) @nogc nothrow {
    return Window_SelectROI(winname.ptr, img);
}

Rects selectROIs(string winname, Mat img){
    return Window_SelectROIs(winname.ptr, img);
}

struct TrackBar {
	string name;
	string winname;
    int max;
    
    this(string _name, string _winname, int _max) @nogc nothrow {
       name = _name;
       winname = _winname;
       max = _max;
       
       Trackbar_Create(winname.ptr, name.ptr, _max);
    }
    
    this(string _name, string _winname, int* value, int count, TrackbarCallback on_trackbar, void* userdata = null) @nogc nothrow {
        name = _name;
        winname = _winname;
        max = count;
        Trackbar_CreateWithCallBack(name.ptr, winname.ptr, value, count, on_trackbar, userdata);
    }
    
    int getPos() @nogc nothrow {
        return Trackbar_GetPos(winname.ptr, name.ptr);
    }
    
    void setPos(int pos) @nogc nothrow {
        Trackbar_SetPos(winname.ptr, name.ptr, pos);
    }
    
    void setMin(int pos) @nogc nothrow {
        Trackbar_SetMin(winname.ptr, name.ptr, pos);
    }
    
    void setMax(int pos) @nogc nothrow {
        Trackbar_SetMax(winname.ptr, name.ptr, pos);
    }
}

void setMouseCallback(string winname, MouseCallback onMouse, void *userdata = null) @nogc nothrow {
    Win_setMouseCallback(winname.ptr, onMouse, userdata);
}

void createTrackbar(string trackname, string winname, int* value, int count, TrackbarCallback on_trackbar, void* userdata = null) @nogc nothrow {
    Trackbar_CreateWithCallBack(trackname.ptr, winname.ptr, value, count, on_trackbar, userdata);
}
