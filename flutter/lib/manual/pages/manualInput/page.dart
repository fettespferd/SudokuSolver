import 'package:flutter/material.dart';
import 'package:sudokuSolver/app/module.dart';

import 'cubit.dart';

class ManualInputPage extends StatefulWidget {
  @override
  _ManualInputPageState createState() => _ManualInputPageState();
}

class _ManualInputPageState extends State<ManualInputPage>
    with StateWithCubit<ProfileCubit, ProfileState, ManualInputPage> {
  @override
  ProfileCubit cubit = ProfileCubit();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _sudokuController = TextEditingController();
  final _sudokuFocusNode = FocusNode();

  List<List<int>> currentSudoku = [
    [0, 3, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 0, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 0],
    [4, 0, 0, 8, 0, 0, 0, 0, 1],
    [0, 0, 0, 0, 2, 0, 0, 0, 0],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 0, 0, 0, 7, 0]
  ];

  @override
  void onCubitData(ProfileState state) {
    state.maybeWhen(
      isUploading: () {},
      noPermission: () {
        _scaffoldKey.showSimpleSnackBar(
          context.s.profile_error_noPermission,
        );
      },
      error: () {
        _scaffoldKey.showSimpleSnackBar(
          context.s.general_error_unknown,
        );
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(35),
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Sudoku(sudoku: currentSudoku),
          ElevatedButton(
            child: Text('Sudoku prüfen'),
            onPressed: () async {},
          ),
          ElevatedButton(
            child: Text('Sudoku lösen'),
            onPressed: () {
              cubit.solve(currentSudoku);
            },
          ),
        ],
      )),
    );
  }
}

class Sudoku extends StatelessWidget {
  const Sudoku({
    @required this.sudoku,
  }) : assert(sudoku != null);

  final List<List<int>> sudoku;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9,
          ),
          itemBuilder: _buildGridItems,
          itemCount: 81,
        ),
      ),
    );
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int x, y = 0;
    x = (index / 9).floor();
    y = index % 9;
    return GestureDetector(
      onTap: () {},
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Center(
            child: _buildGridItem(x, y),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int x, int y) {
    switch (sudoku[x][y]) {
      case 0:
        return Center(
          child: InputField(x, y, sudoku),
        );
      default:
        return Text(sudoku[x][y].toString());
    }
  }
}

class InputField extends StatelessWidget {
  const InputField(this.row, this.col, this.sudoku);

  final int row;
  final int col;
  final List<List<int>> sudoku;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
        ),
        style: TextStyle(color: Colors.red),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onSaved: (input) {
          sudoku[row][col] = int.parse(input);
        });
  }
}
