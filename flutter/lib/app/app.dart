import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smusy_v2/generated/l10n.dart';
import 'package:smusy_v2/settings/module.dart';

import 'brand/theme.dart';
import 'logger.dart';
import 'routing.dart';
import 'services.dart';

class SmusyApp extends StatelessWidget {
  const SmusyApp({@required this.isSignedInInitially})
      : assert(isSignedInInitially != null);

  final bool isSignedInInitially;

  @override
  Widget build(BuildContext context) {
    return PreferenceBuilder<ThemeMode>(
      preference: services.preferences.themeMode,
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'smusy.',
          theme: AppTheme.primary(Brightness.light),
          darkTheme: AppTheme.primary(Brightness.dark),
          themeMode: themeMode,
          initialRoute: isSignedInInitially ? appSchemeUrl('main') : 'login',
          onGenerateRoute: router.onGenerateRoute,
          navigatorObservers: [createLoggingNavigatorObserver()],
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
        );
      },
    );
  }
}
