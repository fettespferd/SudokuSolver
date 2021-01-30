import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:basics/basics.dart';
import 'package:smusy_v2/generated/l10n.dart';

import 'logger.dart';

extension ContextWithLocalization on BuildContext {
  S get s => S.of(this);
}

typedef L10nStringGetter = String Function(S);

bool get isInDebugMode {
  var inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Tries launching a url.
Future<bool> tryLaunchingUrl(String url) async {
  logger.i("Trying to launch url '$url'…");

  if (await canLaunch(url)) {
    await launch(url);
    return true;
  }
  return false;
}

extension ScaffoldKeyShowSnackBar on GlobalKey<ScaffoldState> {
  void showSimpleSnackBar(String message) =>
      currentState.showSnackBar(SnackBar(content: Text(message)));
}

extension DoubleMapping on double {
  double mapRange(double min, double max, double targetMin, double targetMax) =>
      targetMin + (targetMax - targetMin) / (max - min) * (this - min);
}

extension TimestampToInstant on Timestamp {
  Instant get asInstant =>
      Instant.epochTime(Time(seconds: seconds, nanoseconds: nanoseconds));
}

extension InstantToTimestamp on Instant {
  Timestamp get asTimestamp =>
      Timestamp(epochSeconds, timeSinceEpoch.nanosecondOfSecond);
}

extension StringToColor on String {
  Color parseHexColor() =>
      Color(int.parse(withoutPrefix('#').padLeft(8, 'f'), radix: 16));
}

extension ColorToString on Color {
  String toHexString() {
    String convertChannel(int channel) =>
        channel.toRadixString(16).padLeft(2, '0');

    return '#${convertChannel(red)}'
        '${convertChannel(green)}'
        '${convertChannel(blue)}';
  }
}
