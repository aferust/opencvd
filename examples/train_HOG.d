import std.stdio;
import std.conv;
import std.typecons;
import std.math;
import std.algorithm.comparison;
import std.ascii;
import std.random;
import std.getopt;
import core.stdc.string;

import opencvd;

// https://docs.opencv.org/4.1.0/d0/df8/samples_2cpp_2train_HOG_8cpp-example.html

// not tested!

string[] listdir(string pathname)
{
    import std.algorithm;
    import std.array;
    import std.file;
    import std.path;

    return std.file.dirEntries(pathname, SpanMode.shallow)
        .filter!(a => a.isFile)
        .filter!(f => f.name.endsWith(".png"))
        .map!(a => baseName(a.name))
        .array;
}

float[] get_svm_detector( SVM svm )
{
    // get the support vectors
    Mat sv = svm.getSupportVectors();
    const int sv_total = sv.rows;
    // get the decision function
    Mat alpha = Mat(), svidx = Mat();
    double rho = svm.getDecisionFunction( 0, alpha, svidx );
    assert( alpha.total() == 1 && svidx.total() == 1 && sv_total == 1 );
    assert( (alpha.type() == CV_64F && alpha.at!double(0) == 1.) ||
               (alpha.type() == CV_32F && alpha.at!float(0) == 1.0f) );
    assert( sv.type() == CV_32F );
    //float[] hog_detector; hog_detector.length = sv.cols + 1;
    float[] hog_detector = (cast(float*)sv.ptr())[0..sv.cols]; hog_detector ~= cast(float)-rho;
    //memcpy( hog_detector.ptr[0], sv.ptr(), sv.cols*sizeof( hog_detector.ptr[0] ) );
    //hog_detector[sv.cols] = cast(float)-rho;
    return hog_detector;
}
/*
* Convert training/testing set to be used by OpenCV Machine Learning algorithms.
* TrainData is a matrix of size (#samples x max(#cols,#rows) per samples), in 32FC1.
* Transposition of samples are made if needed.
*/
void convert_to_ml( Mat[] train_samples, Mat trainData )
{
    //--Convert data
    const int rows = cast(int)train_samples.length;
    const int cols = cast(int)max( train_samples[0].cols, train_samples[0].rows );
    Mat tmp = Mat( 1, cols, CV_32F ); //< used for transposition if needed
    trainData = Mat( rows, cols, CV_32F );
    for( size_t i = 0 ; i < train_samples.length; ++i )
    {
        assert( train_samples[i].cols == 1 || train_samples[i].rows == 1 );
        if( train_samples[i].cols == 1 )
        {
            transpose( train_samples[i], tmp );
            tmp.copyTo( trainData.row( cast(int)i ) );
        }
        else if( train_samples[i].rows == 1 )
        {
            train_samples[i].copyTo( trainData.row( cast(int)i ) );
        }
    }
}
void load_images( string dirname, ref Mat[] img_lst, bool showImages = false )
{
    string[] files = listdir(dirname);
    for ( size_t i = 0; i < files.length; ++i )
    {
        Mat img = imread( dirname ~ "/" ~ files[i] ); // load the image
        if ( img.empty() )            // invalid image, skip it.
        {
            writeln(files[i] ~ " is invalid!");
            continue;
        }
        if ( showImages )
        {
            imshow( "image", img );
            waitKey( 1 );
        }
        img_lst ~= img;
    }
}
void sample_neg( Mat[] full_neg_lst, ref Mat[] neg_lst, Size size )
{
    Rect box;
    box.width = size.width;
    box.height = size.height;
    const int size_x = box.width;
    const int size_y = box.height;
    auto rnd = Random(unpredictableSeed);
    for ( size_t i = 0; i < full_neg_lst.length; i++ )
        if ( full_neg_lst[i].cols > box.width && full_neg_lst[i].rows > box.height )
        {
            box.x = uniform!"[]"(0, full_neg_lst[i].cols - size_x, rnd).to!int;
            box.y = uniform!"[]"(0, full_neg_lst[i].rows - size_y, rnd).to!int;
            Mat roi = full_neg_lst[i]( box );
            neg_lst ~= roi.clone();
        }
}
void computeHOGs( Size wsize, Mat[] img_lst, ref Mat[] gradient_lst, bool use_flip )
{
    HOGDescriptor hog = HOGDescriptor();
    hog.winSize = wsize;
    Mat gray = Mat();
    float[] descriptors;
    for( size_t i = 0 ; i < img_lst.length; i++ )
    {
        if ( img_lst[i].cols >= wsize.width && img_lst[i].rows >= wsize.height )
        {
            Rect r = Rect(( img_lst[i].cols - wsize.width ) / 2,
                          ( img_lst[i].rows - wsize.height ) / 2,
                          wsize.width,
                          wsize.height);
            cvtColor( img_lst[i](r), gray, COLOR_BGR2GRAY );
            hog.compute( gray, descriptors, Size( 8, 8 ), Size( 0, 0 ) );
            gradient_lst ~= Mat( descriptors ); //.clone();
            if ( use_flip )
            {
                flip( gray, gray, 1 );
                hog.compute( gray, descriptors, Size( 8, 8 ), Size( 0, 0 ) );
                gradient_lst ~= Mat( descriptors ).clone();
            }
        }
    }
}
void test_trained_detector( string obj_det_filename, string test_dir, string videofilename )
{
    "Testing trained detector...".writeln;
    HOGDescriptor hog = HOGDescriptor();
    hog.load( obj_det_filename );
    string[] files = listdir(test_dir);
    int delay = 0;
    VideoCapture cap = newVideoCapture();
    if ( videofilename != "" )
    {
        /*if ( videofilename.length == 1 && isDigit( videofilename[0] ) )
            cap.fromFile( videofilename[0] - '0' );
        else*/
            cap.fromFile( videofilename );
    }
    obj_det_filename = "testing " ~ obj_det_filename;
    namedWindow( obj_det_filename, WINDOW_NORMAL );
    for( size_t i=0;; i++ )
    {
        Mat img = Mat();
        if ( cap.isOpened() )
        {
            cap.read(img);
            delay = 1;
        }
        else if( i < files.length )
        {
            img = imread( files[i] );
        }
        if ( img.empty() )
        {
            return;
        }
        
        auto d_f = hog.detectMultiScale( img );
        Rect[] detections = d_f[0];
        double[] foundWeights = d_f[1];
        
        
        for ( size_t j = 0; j < detections.length; j++ )
        {
            Scalar color = Scalar( 0, foundWeights[j] * foundWeights[j] * 200, 0 );
            rectangle( img, detections[j], color, img.cols / 400 + 1 );
        }
        imshow( obj_det_filename, img );
        if( waitKey( delay ) == 27 )
        {
            return;
        }
    }
}
int main(string[] args)
{
    
    string keys =
        "{pd    |     | path of directory contains positive images}" ~ "\n" ~
        "{nd    |     | path of directory contains negative images}" ~ "\n" ~
        "{td    |     | path of directory contains test images}" ~ "\n" ~
        "{tv    |     | test video file name}" ~ "\n" ~
        "{dw    |     | width of the detector}" ~ "\n" ~
        "{dh    |     | height of the detector}" ~ "\n" ~
        "{f     |false| indicates if the program will generate and use mirrored samples or not}" ~ "\n" ~
        "{d     |false| train twice}" ~ "\n" ~
        "{t     |false| test a trained detector}" ~ "\n" ~
        "{v     |false| visualize training steps}" ~ "\n" ~
        "{fn    |my_detector.yml| file name of trained SVM}";
    
    string pos_dir = ""; //parser.get< String >( "pd" );
    string neg_dir = ""; //parser.get< String >( "nd" );
    string test_dir = ""; //parser.get< String >( "td" );
    string obj_det_filename = "";// parser.get< String >( "fn" );
    string videofilename = ""; // parser.get< String >( "tv" );
    int detector_width = 100; // parser.get< int >( "dw" );
    int detector_height = 100; // parser.get< int >( "dh" );
    bool test_detector = false; //parser.get< bool >( "t" );
    bool train_twice = false; // parser.get< bool >( "d" );
    bool visualization = false; // parser.get< bool >( "v" );
    bool flip_samples = false; //parser.get< bool >( "f" );
    
    auto helpInformation = getopt(args,
            "pd", &pos_dir,
            "nd", &neg_dir,
            "td", &test_dir,
            "fn", &obj_det_filename,
            "tv", &videofilename,
            "dw", &detector_width,
            "dh", &detector_height,
            "t", &test_detector,
            "d", &train_twice,
            "v", &visualization,
            "f", &flip_samples,
    );
    
      if (helpInformation.helpWanted)
      {
        defaultGetoptPrinter(keys, helpInformation.options);
        return 1;
      }
    
    if ( test_detector )
    {
        test_trained_detector( obj_det_filename, test_dir, videofilename );
        return 0;
    }
    if( pos_dir == "" || neg_dir == "" )
    {
        "Wrong number of parameters.\n\n".writeln;
        "Example command line:\n".writeln;
        args[0].write; " --dw=64 --dh=128 --pd=/INRIAPerson/96X160H96/Train/pos --nd=/INRIAPerson/Train/neg --td=/INRIAPerson/Test/pos --fn=HOGpedestrian64x128.xml --d".writeln;
        "\nExample command line for testing trained detector:\n".writeln; args[0].write;" --t --fn=HOGpedestrian64x128.xml --td=/INRIAPerson/Test/pos".writeln;
        return 1;
    }
    Mat[] pos_lst, full_neg_lst, neg_lst, gradient_lst;
    int* _labels;
    int[] labels;
    "Positive images are being loaded...".writeln ;
    load_images( pos_dir, pos_lst, visualization );
    if ( pos_lst.length > 0 )
    {
        "...[done]".writeln;
    }
    else
    {
        writeln("no image in " ~ pos_dir);
        return 1;
    }
    Size pos_image_size = pos_lst[0].size();
    if ( detector_width && detector_height )
    {
        pos_image_size = Size( detector_width, detector_height );
    }
    else
    {
        for ( size_t i = 0; i < pos_lst.length; ++i )
        {
            if(!(( pos_lst[i].size().width == pos_image_size.width) && ( pos_lst[i].size().height == pos_image_size.height)) )
            {
                "All positive images should be same size!".writeln;
                return 1;
            }
        }
        pos_image_size = Size(pos_image_size.width / 8 * 8, pos_image_size.height / 8 * 8);
    }
    "Negative images are being loaded...".writeln;
    load_images( neg_dir, full_neg_lst, false );
    sample_neg( full_neg_lst, neg_lst, pos_image_size );
    "...[done]".writeln;
    "Histogram of Gradients are being calculated for positive images...".writeln;
    computeHOGs( pos_image_size, pos_lst, gradient_lst, flip_samples );
    size_t positive_count = gradient_lst.length;
    _labels[0..positive_count] = +1 ;
    labels = _labels[0..positive_count];
    writeln("...[done] ( positive count : " ~ positive_count.to!string ~ " )");
    "Histogram of Gradients are being calculated for negative images...".writeln;
    computeHOGs( pos_image_size, neg_lst, gradient_lst, flip_samples );
    size_t negative_count = gradient_lst.length - positive_count;
    import std.array;
    labels.insertInPlace( negative_count, -1 );
    assert( positive_count < labels.length );
    writeln("...[done] ( negative count : " ~ negative_count.to!string ~ " )");
    Mat train_data = Mat();
    convert_to_ml( gradient_lst, train_data );
    "Training SVM...".writeln;
    SVM svm = SVM.create();
    /* Default values to train SVM */
    svm.setCoef0( 0.0 );
    svm.setDegree( 3 );
    svm.setTermCriteria( TermCriteria(TermCriteria.MAX_ITER + TermCriteria.EPS, 1000, 1e-3 ) );
    svm.setGamma( 0 );
    svm.setKernel( SVM.LINEAR );
    svm.setNu( 0.5 );
    svm.setP( 0.1 ); // for EPSILON_SVR, epsilon in loss function?
    svm.setC( 0.01 ); // From paper, soft classifier
    svm.setType( SVM.EPS_SVR ); // C_SVC; // EPSILON_SVR; // may be also NU_SVR; // do regression task
    svm.trainAuto( train_data, ROW_SAMPLE, Mat(labels) );
    "...[done]".writeln;
    if ( train_twice )
    {
        "Testing trained detector on negative images. This may take a few minutes...".writeln;
        HOGDescriptor my_hog = HOGDescriptor();
        my_hog.winSize = pos_image_size;
        // Set the trained svm to my_hog
        my_hog.setSVMDetector( Mat(get_svm_detector( svm )) );
        Rect[] detections;
        double[] foundWeights;
        for ( size_t i = 0; i < full_neg_lst.length; i++ )
        {
            if ( full_neg_lst[i].cols >= pos_image_size.width && full_neg_lst[i].rows >= pos_image_size.height )
            {
                auto d_f = my_hog.detectMultiScale( full_neg_lst[i] );
                detections = d_f[0];
                foundWeights = d_f[1];
            }
            else
                detections = [];
            for ( size_t j = 0; j < detections.length; j++ )
            {
                Mat detection = full_neg_lst[i]( detections[j] ).clone();
                resize( detection, detection, pos_image_size, 0, 0, INTER_LINEAR_EXACT);
                neg_lst ~= detection;
            }
            if ( visualization )
            {
                for ( size_t j = 0; j < detections.length; j++ )
                {
                    rectangle( full_neg_lst[i], detections[j], Scalar( 0, 255, 0 ), 2 );
                }
                imshow( "testing trained detector on negative images", full_neg_lst[i] );
                waitKey( 5 );
            }
        }
        "...[done]".writeln;
        
        gradient_lst = [];
        "Histogram of Gradients are being calculated for positive images...".writeln;
        computeHOGs( pos_image_size, pos_lst, gradient_lst, flip_samples );
        positive_count = gradient_lst.length;
        writeln("...[done] ( positive count : " ~ positive_count.to!string ~ " )");
        "Histogram of Gradients are being calculated for negative images...".writeln;
        computeHOGs( pos_image_size, neg_lst, gradient_lst, flip_samples );
        negative_count = gradient_lst.length - positive_count;
        writeln("...[done] ( negative count : " ~ negative_count.to!string ~ " )");
        labels = [];
        _labels[0..positive_count] = +1 ;
        labels = _labels[0..positive_count];
        labels.insertInPlace(negative_count, -1);
        "Training SVM again...".writeln;
        convert_to_ml( gradient_lst, train_data );
        svm.trainAuto( train_data, ROW_SAMPLE, Mat(labels) );
        "...[done]".writeln;
    }
    HOGDescriptor hog = HOGDescriptor();
    hog.winSize = pos_image_size;
    hog.setSVMDetector( Mat(get_svm_detector( svm )) );
    hog.save( obj_det_filename );
    test_trained_detector( obj_det_filename, test_dir, videofilename );
    return 0;
}
