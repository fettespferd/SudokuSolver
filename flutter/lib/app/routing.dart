import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart' hide Route, Router;
import 'package:flutter_deep_linking/flutter_deep_linking.dart';
import 'package:sudokuSolver/auth/module.dart';
import 'package:sudokuSolver/challenge/module.dart';
import 'package:sudokuSolver/creation/module.dart';
import 'package:sudokuSolver/feed/module.dart';
import 'package:sudokuSolver/profile/module.dart';
import 'package:sudokuSolver/settings/module.dart';

import 'pages/main.dart';
import 'services.dart';
import 'utils.dart';

String appSchemeUrl(String path) =>
    'app://${services.packageInfo.packageName}/$path';

final _hostRegExp = RegExp('(?:www\.)?sudokuSolver\.app');

final router = Router(
  routes: [
    Route(
      matcher: Matcher.scheme('app'),
      routes: [
        Route(
          matcher: Matcher.path('main'),
          materialBuilder: (_, result) => MainPage(),
        ),
      ],
    ),
    Route(
      matcher: Matcher.webHost(_hostRegExp, isOptional: true),
      routes: [
        authRoutes,
        challengeRoutes,
        creationRoutes,
        feedRoutes,
        settingsRoutes,
        profileRoutes,
      ],
    ),
    Route(materialBuilder: (_, result) => NotFoundPage(result.uri)),
  ],
);

class NotFoundPage extends StatelessWidget {
  const NotFoundPage(this.uri) : assert(uri != null);

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.s.app_error_pageNotFound)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                context.s.app_error_pageNotFound_message(uri),
                textAlign: TextAlign.center,
              ),
            ),
            // TODO(JonasWanke): remove this button when we have a proper way to sign-out
            ElevatedButton(
              child: Text('Ausloggen'),
              onPressed: () async {
                await services.firebaseAuth.signOut();
                await context.rootNavigator.pushReplacementNamed('/login');
              },
            ),
            // TODO(JonasWanke): remove this button when we have a proper way to open the settings
            ElevatedButton(
              child: Text('Einstellungen'),
              onPressed: () => context.rootNavigator.pushNamed('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}
