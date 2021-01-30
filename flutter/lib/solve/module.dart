import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'pages/solve.dart';
import '../creation/pages/camera/page.dart';

final solveRoutes = Route(
  matcher: Matcher.path('solve'),
  materialBuilder: (_, result) => CameraPage(),
);
