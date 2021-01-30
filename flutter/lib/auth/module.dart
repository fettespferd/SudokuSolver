import 'package:flutter_deep_linking/flutter_deep_linking.dart';
import 'package:sudokuSolver/app/module.dart';

import 'pages/password_reset/page.dart';
import 'pages/sign_in/page.dart';
import 'pages/sign_up/page.dart';
import 'service.dart';

export 'service.dart';
export 'widgets/blurry_dialog.dart';

void initAuth() {
  services.registerSingleton(AuthService());
}

final authRoutes = Route(
  routes: [
    Route(
      matcher: Matcher.path('login'),
      materialBuilder: (_, result) => SignInPage(),
    ),
    Route(
      matcher: Matcher.path('passwordReset'),
      materialBuilder: (_, result) => PasswordResetPage(),
    ),
    Route(
      matcher: Matcher.path('signUp'),
      materialBuilder: (_, result) => SignUpPage(),
    )
  ],
);
