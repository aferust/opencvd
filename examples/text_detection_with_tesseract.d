import std.stdio;
import std.format;
import std.math;
import std.conv;
import std.getopt;

import opencvd;
import tesseractd; // you need this wrapper to run the example: https://github.com/aferust/tesseract-d-wrapper

// https://docs.opencv.org/4.1.0/db/da4/samples_2dnn_2text_detection_8cpp-example.html

// you can download frozen_east_text_detection.pb from https://github.com/oyyd/frozen_east_text_detection.pb
// create those empty folders next to your executable:
// feature_fusion/Conv_7/Sigmoid/
// feature_fusion/concat_3/

string keys =
    "{ help  h     | | Print help message. }" ~ "\n" ~
    "{ input i     | | Path to input image or video file. Skip this argument to capture frames from a camera.}" ~ "\n" ~
    "{ model m     | | Path to a binary .pb file contains trained network.}" ~ "\n" ~
    "{ width       | 320 | Preprocess input image by resizing to a specific width. It should be multiple by 32. }" ~ "\n" ~
    "{ height      | 320 | Preprocess input image by resizing to a specific height. It should be multiple by 32. }" ~ "\n" ~
    "{ thr         | 0.5 | Confidence threshold. }" ~ "\n" ~
    "{ nms         | 0.4 | Non-maximum suppression threshold. }";

int main(string[] args)
{
    // Parse command line arguments.
    
    if (args.length == 1)
    {
        writeln("Use this script to run TensorFlow implementation (https://github.com/argman/EAST) of " ~
                  "EAST: An Efficient and Accurate Scene Text Detector (https://arxiv.org/abs/1704.03155v2)");
        writeln("
        Example usage: <executable> --model=frozen_east_text_detection.pb
        ");
        return 1;
    }
    
    float confThreshold = 0.5f;
    float nmsThreshold = 0.4f;
    int inpWidth = 320;
    int inpHeight = 320;
    string model = "frozen_east_text_detection.pb";
    string input = "";
    
    auto helpInformation = getopt(args,
            "thr", &confThreshold,
            "nms", &nmsThreshold,
            "width", &inpWidth,
            "height", &inpHeight,
            "model", &model,
            "input", &input
    );
    
    if (helpInformation.helpWanted)
    {
        defaultGetoptPrinter(keys, helpInformation.options);
        return 1;
    }
    
    TessBaseAPI ocr = TessBaseAPI();
    ocr.Init(null, "tur", OEM_DEFAULT); // set your target language here: "eng"
    ocr.SetPageSegMode(PSM_SINGLE_BLOCK);
    
    // Load network.
    Net net = readNet(model);
    // Open a video file or an image file or a camera stream.
    VideoCapture cap = newVideoCapture();
    if (input != "")
        cap.fromFile(input);
    else
        cap.fromDevice(0);
    string kWinName = "EAST: An Efficient and Accurate Scene Text Detector";
    namedWindow(kWinName, WINDOW_NORMAL);
    //namedWindow("sub", WINDOW_AUTOSIZE);
    Mat[] outs;
    string[] outNames;
    outNames ~= "feature_fusion/Conv_7/Sigmoid";
    outNames ~= "feature_fusion/concat_3";
    Mat frame = Mat(), blob = Mat();
    while (waitKey(1) < 0)
    {
        cap.read(frame);
        if (frame.empty())
        {
            waitKey();
            break;
        }
        
        blob = blobFromImage(frame, 1.0, Size(inpWidth, inpHeight), Scalar(123.68, 116.78, 103.94), true, false);
        net.setInput(blob);
        Destroy(blob);
        net.forward(outs, outNames);
        Mat scores = outs[0]; 
        Mat geometry = outs[1];
        
        // Decode predicted bounding boxes.
        RotatedRect[] boxes;
        float[] confidences;
        decode(scores, geometry, confThreshold, boxes, confidences);
        Destroy(scores);
        Destroy(geometry);
        // Apply non-maximum suppression procedure.
        int[] indices = NMSBoxes(boxes, confidences, confThreshold, nmsThreshold);
        // Render detections.
        Point2f ratio = {float(frame.cols) / float(inpWidth), float(frame.rows) / float(inpHeight)};
        for (size_t i = 0; i < indices.length; ++i)
        {
            RotatedRect box = boxes[indices[i]];
            Point2f[4] vertices = box.points.asFloat;
            
            for (int j = 0; j < 4; ++j)
            {
                vertices[j].x *= ratio.x;
                vertices[j].y *= ratio.y;
            }
            
            const int margin = 10; // needs bounds check if this is set to a non-zero val. too lazy to do :D
            Rect roi = {vertices[1].x.to!int, vertices[1].y.to!int,
                to!int(vertices[3].x-vertices[1].x) + margin, to!int(vertices[3].y-vertices[1].y + margin)};
            parseText(ocr, frame, roi);
            
            for (int j = 0; j < 4; ++j)
                line(frame, vertices[j].asInt, vertices[(j + 1) % 4].asInt, Scalar(0, 255, 0), 1);
        }
        // Put efficiency information.
        double freq = getTickFrequency() / 1000;
        double t = net.getPerfProfile() / freq;
        string label = format("Inference time: %.2f ms", t);
        putText(frame, label, Point(0, 15), FONT_HERSHEY_SIMPLEX, 0.5, Scalar(0, 255, 0));
        imshow(kWinName, frame);
    }
    return 0;
}
void decode(Mat scores, Mat geometry, float scoreThresh,
            ref RotatedRect[] detections, ref float[] confidences)
{
    detections.length = 0;
    assert(scores.dims == 4); assert(geometry.dims == 4);
    
    const int height = scores.size(2);
    const int width = scores.size(3);
    for (int y = 0; y < height; ++y)
    {
        float* scoresData = cast(float*)scores.ptr(0, 0, y);
        float* x0_data = cast(float*)geometry.ptr(0, 0, y);
        float* x1_data = cast(float*)geometry.ptr(0, 1, y);
        float* x2_data = cast(float*)geometry.ptr(0, 2, y);
        float* x3_data = cast(float*)geometry.ptr(0, 3, y);
        float* anglesData = cast(float*)geometry.ptr(0, 4, y);
        for (int x = 0; x < width; ++x)
        {
            float score = scoresData[x];
            if (score < scoreThresh)
                continue;
            // Decode a prediction.
            // Multiple by 4 because feature maps are 4 time less than input image.
            float offsetX = x * 4.0f, offsetY = y * 4.0f;
            float angle = anglesData[x];
            float cosA = cos(angle);
            float sinA = sin(angle);
            float h = x0_data[x] + x2_data[x];
            float w = x1_data[x] + x3_data[x];
            Point2f offset = Point2f(offsetX + cosA * x1_data[x] + sinA * x2_data[x],
                           offsetY - sinA * x1_data[x] + cosA * x2_data[x]);
            Point2f p1 = Point2f(-sinA * h, -cosA * h) + offset;
            Point2f p3 = Point2f(-cosA * w, sinA * w) + offset;
            RotatedRect r = RotatedRect((0.5f * (p1 + p3)).asInt, Size(w.to!int, h.to!int), cast(double)(-angle * 180.0f / PI));
            detections ~= r;
            confidences ~= score;
        }
    }
}

void parseText(TessBaseAPI ocr, Mat parentIm, Rect roi)
{
    Mat subIm = parentIm(roi).clone;
    
    ocr.SetImage(subIm.ptr, subIm.cols, subIm.rows, 3, subIm.step);
    
    string outText = ocr.GetUTF8Text();
    
    outText.writeln;
    
    //imshow("sub", subIm);
    
    Destroy(subIm);
}
