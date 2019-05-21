import std.stdio;
import std.format;
import std.random;

import opencvd;
import tesseractd;

/*  text recognition (OCR) with tesseract
    you need this wrapper to run the example: https://github.com/aferust/tesseract-d-wrapper
    
    I could not test it on any OS other than Ubuntu.
    Actually, I had linking problems with the tesseract on windows.
    
*/    

int main()
{
    TessBaseAPI ocr = TessBaseAPI();
    
    ocr.Init(null, "eng", OEM_DEFAULT); // set your target language here: "eng"
    ocr.SetPageSegMode(PSM_SINGLE_BLOCK);
    
    Mat img = imread("bursa.jpeg", IMREAD_COLOR); // read an image that includes some text
    
    namedWindow( "orig", WINDOW_AUTOSIZE );
    imshow("orig", img);
    
    ocr.SetImage(img.ptr, img.cols, img.rows, 3, img.step);
    
    string outText = ocr.GetUTF8Text();
    
    outText.writeln;
    
    Destroy(ocr);
    
    waitKey();
    return 0;
}
