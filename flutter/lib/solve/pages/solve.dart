import 'package:flutter/material.dart';
import 'package:sudokuSolver/app/module.dart';

class SolvePage extends StatefulWidget {
  @override
  _SolvePageState createState() => _SolvePageState();
}

class _SolvePageState extends State<SolvePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('sudokuSolver.')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.rootNavigator.pushNamed('/creation/camera'),
          child: Icon(Icons.add_outlined),
        ),
        body: Container());
  }
}
