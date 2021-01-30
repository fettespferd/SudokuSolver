import 'package:email_validator/email_validator.dart';
import 'package:flutter/widgets.dart';
import 'package:basics/basics.dart';

@immutable
class FormValidator {
  static FormFieldValidator<String> notBlank(String message) =>
      _buildValidator((value) => value.isNotBlank, message);

  static FormFieldValidator<String> email(String message) =>
      _buildValidator(EmailValidator.validate, message);

  static FormFieldValidator<String> noMatch(
          ValueGetter<String> valueGetter, String message) =>
      _buildValidator((value) => value == valueGetter(), message);

  static FormFieldValidator<String> _buildValidator(
    bool Function(String value) validator,
    String message,
  ) {
    return (value) => validator(value) ? null : message;
  }
}
