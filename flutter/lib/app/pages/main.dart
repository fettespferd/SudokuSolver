import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:navigation_patterns/navigation_patterns.dart';

import '../logger.dart';
import '../routing.dart';
import '../utils.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final barColor = context.theme.bottomNavigationBarTheme.backgroundColor;

    return BottomNavigationPattern(
      tabCount: _BottomTab.values.length,
      navigatorBuilder: (_, tabIndex, navigatorKey) {
        return Navigator(
          key: navigatorKey,
          initialRoute: _BottomTab.values[tabIndex].initialRoute,
          onGenerateRoute: router.onGenerateRoute,
          observers: [createLoggingNavigatorObserver()],
        );
      },
      scaffoldBuilder: (_, body, selectedTabIndex, onTabSelected) {
        return Scaffold(
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            currentIndex: selectedTabIndex,
            onTap: onTabSelected,
            items: [
              for (final tab in _BottomTab.values)
                BottomNavigationBarItem(
                  icon: Icon(tab.icon, key: tab.key),
                  label: tab.title(context.s),
                  backgroundColor: barColor,
                ),
            ],
          ),
        );
      },
    );
  }
}

@immutable
class _BottomTab {
  const _BottomTab({
    this.key,
    @required this.icon,
    @required this.title,
    @required this.initialRoute,
  })  : assert(icon != null),
        assert(title != null),
        assert(initialRoute != null);

  final ValueKey<String> key;
  final IconData icon;
  final L10nStringGetter title;
  final String initialRoute;

  static final values = [feed, discover, challenge, favorite];

  // We don't use relative URLs as they would start with a '/' and hence the
  // navigator automatically populates our initial back stack with '/'.
  static final feed = _BottomTab(
    icon: Icons.dashboard_outlined,
    title: (s) => s.app_bottomNav_stream,
    initialRoute: webUrl('feed'),
  );
  static final discover = _BottomTab(
    key: ValueKey<String>('navigation-discover'),
    icon: Icons.search_outlined,
    title: (s) => s.app_bottomNav_discover,
    initialRoute: webUrl('discover'),
  );
  static final challenge = _BottomTab(
    key: ValueKey<String>('navigation-challenge'),
    icon: Icons.flash_on_outlined,
    title: (s) => s.app_bottomNav_challenge,
    initialRoute: webUrl('challenges'),
  );
  static final favorite = _BottomTab(
    key: ValueKey<String>('navigation-profile'),
    icon: Icons.person,
    title: (s) => s.app_bottomNav_profile,
    initialRoute: webUrl('profile'),
  );
}
