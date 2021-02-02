import 'package:sudokuSolver/app/module.dart';

part 'cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState.initial());
  bool solve(List<List<int>> currentSudoku) {
    SudokuCell currentCell;

    if (!_emptyCellExists(currentSudoku, currentCell)) {
      return true;
    } else {
      for (var number = 1; number <= 9; number++) {
        if (_isSafe(currentSudoku, currentCell.row, currentCell.col, number)) {
          currentSudoku[currentCell.row][currentCell.col] = number;
          print(currentSudoku);
          if (solve(currentSudoku)) {
            return true;
          }
          currentSudoku[currentCell.row][currentCell.col] = 0;
        }
      }
    }
    return false;
  }

  bool _emptyCellExists(List<List<int>> currentSudoku, SudokuCell currentCell) {
    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 9; col++) {
        if (currentSudoku[row][col] == 0) {
          currentCell.row = row;
          currentCell.col = col;
          return true;
        }
      }
    }
    return false;
  }

  //Checks if the number can be placed in the cell
  bool _isSafe(List<List<int>> currentSudoku, int row, int col, int number) {
    return !numberInRow(currentSudoku, row, number) &&
        !numberInCol(currentSudoku, col, number) &&
        !numberInSquare(currentSudoku, row - row % 3, col - col % 3, number) &&
        currentSudoku[row][col] == 0;
  }

  //Searches the input number in the given Col
  bool numberInCol(List<List<int>> currentSudoku, int col, int number) {
    for (var row = 0; row < 9; row++) {
      if (currentSudoku[row][col] == number) {
        return true;
      }
    }
    return false;
  }

//Searches the input number in the given Row
  bool numberInRow(List<List<int>> currentSudoku, int row, int number) {
    for (var col = 0; col < 9; col++) {
      if (currentSudoku[row][col] == number) {
        return true;
      }
    }
    return false;
  }

//Searches the input number in a 3x3 environment
  bool numberInSquare(
      List<List<int>> currentSudoku, int startRow, int startCol, int number) {
    for (var rowtest = 0; rowtest < 3; rowtest++) {
      for (var coltest = 0; coltest < 3; coltest++) {
        if (currentSudoku[rowtest + startRow][coltest + startCol] == number) {
          return true;
        }
      }
    }
    return false;
  }
}

class SudokuCell {
  SudokuCell(this.row, this.col);

  int row;
  int col;
}

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _InitialState;
  const factory ProfileState.isUploading() = _UploadingState;
  const factory ProfileState.noPermission() = _NoPermissionState;
  const factory ProfileState.success() = _SuccessState;
  const factory ProfileState.error() = _ErrorState;
}
