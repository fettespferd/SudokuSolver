#include <iostream>
#include <cstdlib>

using namespace std;

#define N 9
#define Unassigned 0

bool FindUnassignedLocation(int grid[N][N], int& row, int& col);
bool IsSafe(int grid[N][N], int row, int col, int number);
void printSudoku(int grid[N][N]);

bool SolveSudoku(int grid[N][N])
{
	int row, col;
	if (!FindUnassignedLocation(grid, row, col))
	{
		return true;
	}

	for (int number = 1; number <= 9; number++)
	{
		if (IsSafe(grid, row, col, number))
		{
			grid[row][col] = number;
			//printSudoku(grid);
			if (SolveSudoku(grid))
			{
				return true;
			}
			grid[row][col] = Unassigned;
		}
	}
	return false;
}

//Look if the Sudoku has no Unassigned Cells. Then return true. Otherwise the row and col is stored for following step
bool FindUnassignedLocation(int grid[N][N], int& row, int& col)
{
	for (row = 0; row < N; row++)
	{
		for (col = 0; col < N; col++)
		{
			if (grid[row][col] == Unassigned)
			{
				return true;
			}
		}
	}
	return false;
}

//Searches the input number in the given Col
bool NumberInCol(int grid[N][N], int col, int number)
{
	for (int row = 0; row < N; row++)
	{
		if (grid[row][col] == number)
		{
			return true;
		}
	}
	return false;
}

//Searches the input number in the given Row
bool NumberInRow(int grid[N][N], int row, int number)
{
	for (int col = 0; col < N; col++)
	{
		if (grid[row][col] == number)
		{
			return true;
		}
	}
	return false;
}

//Searches the input number in a 3x3 environment
bool NumberInSquare(int grid[N][N], int StartRow, int StartCol, int number)
{
	for (int rowtest = 0; rowtest < 3; rowtest++)
	{
		for (int coltest = 0; coltest < 3; coltest++)
		{
			if (grid[rowtest + StartRow][coltest + StartCol] == number)
			{
				return true;
			}
		}
	}
	return false;
}

//Checks if the number can be placed in the cell
bool IsSafe(int grid[N][N], int row, int col, int number)
{
	return !NumberInRow(grid, row, number) && !NumberInCol(grid, col, number) && !NumberInSquare(grid, row - row % 3, col - col % 3, number) && grid[row][col] == Unassigned;
}

void printSudoku(int grid[N][N])
{
	for (int row = 0; row < 9; row++)
	{
		for (int col = 0; col < 9; col++)
		{
			cout << grid[row][col] << " ";
		}
		cout << endl;
	}
	cout << endl;
}

