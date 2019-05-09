import std.stdio;

import opencvd.cvcore;
import opencvd.highgui;
import opencvd.videoio;
import opencvd.imgproc;
import opencvd.objdetect;
import opencvd.ocvversion;

// https://www.geeksforgeeks.org/opencv-c-program-face-detection

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
    nestedCascade.load( "haarcascade_eye_tree_eyeglasses.xml" ) ;
    
    // Change path before execution  
    cascade.load( "haarcascade_frontalcatface.xml" ) ; 
    if( cap.isOpened() )
    while(true)
    {
        Mat frame = Mat();

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
    gray = Mat(); smallImg = Mat();
    
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
        Rect r = faces[i];
        Mat smallImgROI; 
        Rects nestedObjects;
        Point center; 
        Scalar color = Scalar(255, 0, 0); // Color for Drawing tool 
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
        smallImgROI = smallImg(r);
        
        // Detection of eyes int the input image 
        nestedObjects = nestedCascade.detectMultiScale(smallImgROI);
          
        // Draw circles around eyes 
        for ( int j = 0; j < nestedObjects.length; j++ )  
        { 
            Rect nr = nestedObjects[j]; 
            center.x = cast(int)round((r.x + nr.x + nr.width*0.5)*scale); 
            center.y = cast(int)round((r.y + nr.y + nr.height*0.5)*scale); 
            radius = cast(int)round((nr.width + nr.height)*0.25*scale); 
            circle( img, center, radius, color, 3); 
        } 
    } 
  
    // Show Processed Image with detected faces 
    imshow( "mywin", img );  
}
