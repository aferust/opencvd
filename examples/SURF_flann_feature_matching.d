import std.stdio;
import std.conv;
import std.math;
import std.algorithm.comparison;

import opencvd.cvcore;
import opencvd.imgcodecs;
import opencvd.highgui;
import opencvd.imgproc;
import opencvd.features2d;
import opencvd.contrib.xfeatures2d;
import opencvd.calib3d;

// http://www.coldvision.io/2016/06/27/object-detection-surf-knn-flann-opencv-3-x-cuda/

/**
 * It searches for on object inside an scene using the SURF for keypoints and descriptors detection, and FLANN+KNN for matching them.
 */
 
 /* !!! WARNING !!!
 * Your opencv must be compiled with this cmake parameter to use this
 * module: -DOPENCV_ENABLE_NONFREE:BOOL=ON
 * Otherwise you will encounter crashes!!!
 */

void main()
{
    
    string objectInputFile = "box.png";
    string sceneInputFile = "box_in_scene.png";
    string outputFile = "result.jpg";
    int minHessian = 100;
    
	// Load the image from the disk
	Mat img_object = imread( objectInputFile, IMREAD_GRAYSCALE ); // surf works only with grayscale images
	Mat img_scene = imread( sceneInputFile, IMREAD_GRAYSCALE );

	if( img_object.empty || img_scene.empty ) {
		"Error reading images.".writeln;
		return;
	}

	KeyPoint[] keypoints_object, keypoints_scene; // keypoints
	Mat descriptors_object = Mat(), descriptors_scene = Mat(); // descriptors (features)

	//-- Steps 1 + 2, detect the keypoints and compute descriptors, both in one method
	SURF surf = SURF(minHessian); 
	keypoints_object = surf.detectAndCompute( img_object, Mat(), descriptors_object );
	keypoints_scene = surf.detectAndCompute( img_scene, Mat(), descriptors_scene );

	//-- Step 3: Matching descriptor vectors using FLANN matcher
	FlannBasedMatcher matcher = FlannBasedMatcher(); // FLANN - Fast Library for Approximate Nearest Neighbors
	
	DMatch[][] matches = matcher.knnMatch( descriptors_object, descriptors_scene, 2 ); // find the best 2 matches of each descriptor
    
	//-- Step 4: Select only goot matches
	DMatch[] good_matches;
	for (int k = 0; k < min(descriptors_scene.rows - 1, cast(int)matches.length); k++)
	{
		if ( (matches[k][0].distance < 0.6*(matches[k][1].distance)) &&
				(cast(int)matches[k].length <= 2 && cast(int)matches[k].length>0) )
		{
			// take the first result only if its distance is smaller than 0.6*second_best_dist
			// that means this descriptor is ignored if the second distance is bigger or of similar
			good_matches ~= matches[k][0];
		}
	}

	//-- Step 5: Draw lines between the good matching points
	Mat img_matches = Mat();
	drawMatches( img_object, keypoints_object, img_scene, keypoints_scene,
			good_matches, img_matches, Scalar.all(-1), Scalar.all(-1),
			[], DrawMatchesFlags_DEFAULT);
    
	//-- Step 6: Localize the object inside the scene image with a square
	localizeInImage( good_matches, keypoints_object, keypoints_scene, img_object, img_matches );

	//-- Step 7: Show/save matches
	imshow("Good Matches & Object detection", img_matches);
	waitKey(0);
	//imwrite(outputFile, img_matches);
}

// It searches for the right position, orientation and scale of the object in the scene based on the good_matches.
void localizeInImage(DMatch[] good_matches,
		KeyPoint[] keypoints_object,
		KeyPoint[] keypoints_scene, Mat img_object,
		Mat img_matches)
{
	//-- Localize the object
	Point2f[] obj;
	Point2f[] scene;
	for (int i = 0; i < good_matches.length; i++) {
		//-- Get the keypoints from the good matches
		obj ~= keypoints_object[good_matches[i].queryIdx].pt;
		scene ~= keypoints_scene[good_matches[i].trainIdx].pt;
	}
 
	
    Mat H = findHomography(obj, scene, RANSAC);
    //-- Get the corners from the image_1 ( the object to be "detected" )
    Point2f[] obj_corners; obj_corners.length = 4;
    obj_corners[0] = Point2f(0.0f, 0.0f);
    obj_corners[1] = Point2f(img_object.cols.to!float, 0.0f);
    obj_corners[2] = Point2f(img_object.cols.to!float, img_object.rows.to!float);
    obj_corners[3] = Point2f(0.0f, img_object.rows.to!float);
    
    Point2f[] scene_corners;

    perspectiveTransform(obj_corners, scene_corners, H);
    
    // Draw lines between the corners (the mapped object in the scene - image_2 )
    line(img_matches, scene_corners[0].asInt + Point2f(img_object.cols, 0).asInt,
            scene_corners[1].asInt + Point2f(img_object.cols, 0).asInt,
            Scalar(255, 0, 0), 4);
    line(img_matches, scene_corners[1].asInt + Point2f(img_object.cols, 0).asInt,
            scene_corners[2].asInt + Point2f(img_object.cols, 0).asInt,
            Scalar(255, 0, 0), 4);
    line(img_matches, scene_corners[2].asInt + Point2f(img_object.cols, 0).asInt,
            scene_corners[3].asInt + Point2f(img_object.cols, 0).asInt,
            Scalar(255, 0, 0), 4);
    line(img_matches, scene_corners[3].asInt + Point2f(img_object.cols, 0).asInt,
            scene_corners[0].asInt + Point2f(img_object.cols, 0).asInt,
            Scalar(255, 0, 0), 4);
	
}
