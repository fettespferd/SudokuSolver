import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'pages/manualInput/page.dart';

final manualRoutes = Route(
  matcher: Matcher.path('input'),
  materialBuilder: (_, __) => ManualInputPage(),
);
