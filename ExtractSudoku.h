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
	for (; idx >= 0; idx = hierarchy[idx][0])
	{
		Scalar color(rand() & 255, rand() & 255, rand() & 255);
		drawContours(finalImage, contours, idx, color, FILLED, 8, hierarchy);
	}
	namedWindow("Image_Temp", 1);
	imshow("Image_Temp", finalImage);
	cv::waitKey();
	return true;
}
