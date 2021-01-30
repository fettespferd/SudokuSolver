import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'models.dart';
import 'pages/overview.dart';
import 'pages/question/page.dart';
import 'pages/topics.dart';

final challengeRoutes = Route(
  matcher: Matcher.path('challenges'),
  materialBuilder: (_, __) => OverviewPage(),
  routes: [
    Route(
      matcher: Matcher.path('quickplay'),
      materialBuilder: (_, __) => QuestionPage(ChallengeMode.quickplay()),
    ),
    Route(
      matcher: Matcher.path('schoolDuel'),
      materialBuilder: (_, __) => QuestionPage(ChallengeMode.schoolDuel()),
    ),
    Route(
      matcher: Matcher.path('topics'),
      materialBuilder: (_, result) => TopicsPage(),
      routes: [
        Route(
          matcher: Matcher.path('{topic}'),
          materialBuilder: (_, result) =>
              QuestionPage(ChallengeMode.topic(result['topic'])),
        ),
      ],
    ),
  ],
);
