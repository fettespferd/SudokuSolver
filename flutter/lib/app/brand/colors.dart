import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class AppColors {
  static MaterialColor primary(Brightness brightness) =>
      brightness.isLight ? primaryLight : primaryDark;
  static const primaryLight = MaterialColor(0xFFD72E8B, {
    50: Color(0xFFE782B9),
    100: Color(0xFFE36CAE),
    200: Color(0xFFDF58A2),
    300: Color(0xFFDB4296),
    400: Color(0xFFD72E8B),
    500: Color(0xFFC2297D),
    600: Color(0xFFAC256F),
    700: Color(0xFF972062),
    800: Color(0xFF811C53),
    900: Color(0xFF6C1746),
  });
  static const primaryDark = MaterialColor(0xFF962061, {
    50: Color(0xFFA15A81),
    100: Color(0xFF9E4B79),
    200: Color(0xFF9B3D71),
    300: Color(0xFF982E68),
    400: Color(0xFF962061),
    500: Color(0xFF871C57),
    600: Color(0xFF78194D),
    700: Color(0xFF691644),
    800: Color(0xFF5A1339),
    900: Color(0xFF4B1030),
  });
  static Color primaryVariant(Brightness brightness) =>
      brightness.isLight ? primaryVariantLight : primaryVariantDark;
  static const primaryVariantLight = Color(0xFFA1005E);
  static const primaryVariantDark = Color(0xFF4B1030);

  static MaterialColor secondary(Brightness brightness) =>
      brightness.isLight ? secondaryLight : secondaryLight;
  static const secondaryLight = MaterialColor(0xFFA32B82, {
    50: Color(0xFFC880B4),
    100: Color(0xFFBE6AA7),
    200: Color(0xFFB5559B),
    300: Color(0xFFAC408E),
    400: Color(0xFFA32B82),
    500: Color(0xFF932775),
    600: Color(0xFF822268),
    700: Color(0xFF721E5B),
    800: Color(0xFF621A4E),
    900: Color(0xFF521641),
  });
  static const secondaryDark = MaterialColor(0xFF711E5A, {
    50: Color(0xFF8B597D),
    100: Color(0xFF844974),
    200: Color(0xFF7E3B6C),
    300: Color(0xFF782C63),
    400: Color(0xFF711E5A),
    500: Color(0xFF661B51),
    600: Color(0xFF5A1748),
    700: Color(0xFF4F143F),
    800: Color(0xFF441236),
    900: Color(0xFF390F2D),
  });
  static Color secondaryVariant(Brightness brightness) =>
      brightness.isLight ? secondaryVariantLight : secondaryVariantLight;
  static const secondaryVariantLight = Color(0xFF710055);
  static const secondaryVariantDark = Color(0xFF4E003B);

  static Color surface(Brightness brightness) =>
      brightness.isLight ? surfaceLight : surfaceDark;
  static const surfaceLight = Colors.white;
  static const surfaceDark = Color(0xFF121212);

  static Color background(Brightness brightness) =>
      brightness.isLight ? backgroundLight : backgroundDark;
  static const backgroundLight = Color(0xFFEFEFEF);
  static const backgroundDark = Color(0xFF303030);

  static Color error(Brightness brightness) =>
      brightness.isLight ? errorLight : errorDark;
  static const errorLight = Color(0xFFB00020);
  static const errorDark = Color(0xFFCF6679);

  static ColorScheme primaryScheme(Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: primary(brightness),
      primaryVariant: primaryVariant(brightness),
      onPrimary: primary(brightness).highEmphasisOnColor,
      secondary: brightness.isDark ? Colors.white : secondary(brightness),
      secondaryVariant:
          brightness.isDark ? Colors.white : secondaryVariant(brightness),
      onSecondary: brightness.isDark
          ? Colors.black
          : secondary(brightness).highEmphasisOnColor,
      surface: surface(brightness),
      onSurface: surface(brightness).highEmphasisOnColor,
      background: background(brightness),
      onBackground: background(brightness).highEmphasisOnColor,
      error: error(brightness),
      onError: error(brightness).highEmphasisOnColor,
    );
  }

  static ColorScheme secondaryScheme(Brightness brightness) {
    final secondary = AppColors.secondary(brightness);
    final primary = secondary.highEmphasisOnColor;
    return ColorScheme(
      brightness: brightness,
      primary: MaterialColor(primary.value, {
        50: primary,
        100: primary,
        200: primary,
        300: primary,
        400: primary,
        500: primary,
        600: primary,
        700: primary,
        800: primary,
        900: primary,
      }),
      primaryVariant: secondary.highEmphasisOnColor,
      onPrimary: secondary.estimatedBrightness.highEmphasisColor,
      secondary: secondary.highEmphasisOnColor,
      secondaryVariant: secondary.highEmphasisOnColor,
      onSecondary: secondary.estimatedBrightness.highEmphasisColor,
      surface: surface(brightness),
      onSurface: surface(brightness).highEmphasisOnColor,
      background: secondary,
      onBackground: secondary.highEmphasisOnColor,
      error: error(brightness),
      onError: error(brightness).highEmphasisOnColor,
    );
  }
}
