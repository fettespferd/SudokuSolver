#include <iostream>
#include <opencv2/opencv.hpp>
#include <C:\Users\faube\source\repos\SudokuCamera\SudokuCamera\SudokuSolver\ExtractSudoku.h>
#include <C:\Users\faube\source\repos\SudokuCamera\SudokuCamera\SudokuSolver\sudoku.h>
using namespace cv;
using namespace std;
int main()
{
	Mat ImgSudoku = imread("C:\\Users\\faube\\source\\repos\\SudokuSolver\\SudokuSolver\\src\\TestSudoku2.jpg");
	
	bool ConversionSuccess = ConvertSudoku(ImgSudoku);
	int exampleSudoku[N][N] = { {3, 0, 6, 5, 0, 8, 4, 0, 0},
						   {5, 2, 0, 0, 0, 0, 0, 0, 0},
						   {0, 8, 7, 0, 0, 0, 0, 3, 1},
						   {0, 0, 3, 0, 1, 0, 0, 8, 0},
						   {9, 0, 0, 8, 6, 3, 0, 0, 5},
						   {0, 5, 0, 0, 9, 0, 6, 0, 0},
						   {1, 3, 0, 0, 0, 0, 2, 5, 0},
						   {0, 0, 0, 0, 0, 0, 0, 7, 4},
						   {0, 0, 5, 2, 0, 6, 3, 0, 0} };
	if (SolveSudoku(exampleSudoku))
	{
		cout << "The Sudoku was solved: " << endl;
		printSudoku(exampleSudoku);
	}
	else
	{
		cout << "The Sudoku could not be solved: ";
	}
	return 0;
}