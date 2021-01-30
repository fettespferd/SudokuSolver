import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sudokuSolver/app/module.dart';
import 'package:sudokuSolver/content/module.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
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
