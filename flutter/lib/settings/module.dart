import 'package:flutter_deep_linking/flutter_deep_linking.dart';
import 'package:smusy_v2/app/module.dart';

import 'pages/settings.dart';
import 'preferences.dart';

export 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

export 'preferences.dart';
export 'widgets/legal_bar.dart';

Future<void> initSettings() async {
  services.registerSingletonAsync(Preferences.create);
}

final settingsRoutes = Route(
  matcher: Matcher.path('settings'),
  materialBuilder: (_, result) => SettingsPage(),
);
