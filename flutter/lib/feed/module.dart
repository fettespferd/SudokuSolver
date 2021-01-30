import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'pages/feed.dart';

final feedRoutes = Route(
  matcher: Matcher.path('feed'),
  materialBuilder: (_, result) => FeedPage(),
);
