#include <opencv2/opencv.hpp>


using namespace std;
using namespace cv;

bool ConvertSudoku(Mat ImgSudoku);

bool ConvertSudoku(Mat ImgSudoku)
{
	Mat grayImage = ImgSudoku;
	cvtColor(ImgSudoku, grayImage, COLOR_BGR2GRAY);

	float level = 0.41;
	Mat bwImage;
	threshold(grayImage, bwImage, 50, 255, THRESH_BINARY);
	
	Mat finalImage = bwImage;
	vector<vector<Point> > contours;
	vector<Vec4i> hierarchy;
	findContours(bwImage, contours, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE);
	int idx = 0;
	
	imshow("Image_Temp", finalImage);
	cv::waitKey();
	return true;
}
