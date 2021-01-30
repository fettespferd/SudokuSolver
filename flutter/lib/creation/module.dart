import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'pages/camera/page.dart';
import 'pages/edit/page.dart';

final creationRoutes = Route(
  matcher: Matcher.path('creation'),
  routes: [
    Route(
      matcher: Matcher.path('camera'),
      materialBuilder: (_, __) => CameraPage(),
    ),
    Route(
      matcher: Matcher.path('edit'),
      materialBuilder: (_, result) {
        return EditPage(
          backgroundType: result.uri.queryParameters['backgroundType'],
          picturePath: result.uri.queryParameters['picturePath'],
        );
      },
    ),
  ],
);
