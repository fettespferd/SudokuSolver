import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'pages/profile_overview/page.dart';

final profileRoutes = Route(
  matcher: Matcher.path('profile'),
  materialBuilder: (_, __) => ProfileOverviewPage(),
);
