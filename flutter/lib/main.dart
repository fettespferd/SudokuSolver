import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudokuSolver/app/module.dart';
import 'package:sudokuSolver/auth/module.dart';
import 'package:sudokuSolver/settings/module.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  _showLoadingPage();
  await initApp();
  initAuth();
  await initSettings();
  await services.allReady();

  final isSignedIn = services.auth.isSignedIn;
  logger.i('User is signed in already: $isSignedIn.');
  runApp(SudokuSolverApp(isSignedInInitially: isSignedIn));
}

void _showLoadingPage() {
  runApp(Container(
    color: Colors.white,
    alignment: Alignment.center,
    child: CircularProgressIndicator(),
  ));
}
