import 'package:flutter/material.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';

import 'colors.dart';
import 'theme.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({@required this.child}) : assert(child != null);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = context.theme.brightness;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary(brightness),
            AppColors.secondary(brightness),
          ],
        ),
      ),
      child: Theme(data: AppTheme.secondary(brightness), child: child),
    );
  }
}
