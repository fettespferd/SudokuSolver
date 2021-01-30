import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

class L10nString {
  const L10nString(this.data) : assert(data != null);

  factory L10nString.fromJson(Map<String, dynamic> json) {
    return L10nString(
      // TODO(JonasWanke): We store locales with languageCode only. As soon as we want to support countryCodes, this needs to be updated!
      json.map(
        (locale, dynamic text) => MapEntry(Locale(locale), text as String),
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return data.map<String, dynamic>(
      (locale, text) => MapEntry<String, dynamic>(locale.toLanguageTag(), text),
    );
  }

  final Map<Locale, String> data;

  String getValue(BuildContext context) {
    return data[Localizations.localeOf(context)] ??
        data[Locale('en')] ??
        data.values.firstOrNull;
  }
}
