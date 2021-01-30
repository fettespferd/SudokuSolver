import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smusy_v2/app/module.dart';

typedef PasswordInputBuilder = Widget Function(
  bool isVisible,
  VoidCallback toggleVisibility,
);

class PasswordInputWrapper extends StatefulWidget {
  const PasswordInputWrapper({@required this.builder})
      : assert(builder != null);

  final PasswordInputBuilder builder;

  @override
  _PasswordInputWrapperState createState() => _PasswordInputWrapperState();
}

class _PasswordInputWrapperState extends State<PasswordInputWrapper> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      _isVisible,
      () => setState(() => _isVisible = !_isVisible),
    );
  }
}

class SignInTextField extends StatelessWidget {
  const SignInTextField({
    @required this.controller,
    this.padding = EdgeInsets.zero,
    @required this.label,
    @required this.icon,
    this.isEnabled = true,
    @required this.focusNode,
    @required this.textInputAction,
    @required this.keyboardType,
    this.inputFormatters = const [],
    @required this.onFieldSubmitted,
    @required this.validators,
    this.obscureText = false,
    this.borderRadius = InputWrapper.defaultBorderRadius,
  })  : assert(controller != null),
        assert(padding != null),
        assert(label != null),
        assert(icon != null),
        assert(isEnabled != null),
        assert(focusNode != null),
        assert(textInputAction != null),
        assert(keyboardType != null),
        assert(inputFormatters != null),
        assert(onFieldSubmitted != null),
        assert(validators != null),
        assert(obscureText != null),
        assert(borderRadius != null);

  final TextEditingController controller;
  final EdgeInsetsGeometry padding;
  final String label;
  final Widget icon;
  final bool isEnabled;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String> onFieldSubmitted;
  final List<FormFieldValidator<String>> validators;
  final bool obscureText;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.primary(context.theme.brightness),
      child: InputWrapper(
        color: context.theme.colorScheme.surface,
        borderRadius: borderRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6).add(padding),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: TextCapitalization.none,
            textInputAction: textInputAction,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: label,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              suffixIcon: icon,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: borderRadius,
              ),
            ),
            inputFormatters: inputFormatters,
            obscureText: obscureText,
            onFieldSubmitted: onFieldSubmitted,
            validator: (value) => validators
                .map((v) => v(value))
                .firstWhere((r) => r != null, orElse: () => null),
            enabled: isEnabled,
          ),
        ),
      ),
    );
  }
}

class InputWrapper extends StatelessWidget {
  const InputWrapper({
    @required this.color,
    @required this.child,
    @required this.borderRadius,
  })  : assert(color != null),
        assert(child != null),
        assert(borderRadius != null);

  // The big number gets coerced down to form a semicircle, but
  // [double.infinity] isn't allowed.
  static const defaultBorderRadius =
      BorderRadius.horizontal(right: Radius.circular(10000));
  final Color color;
  final Widget child;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: borderRadius,
      child: Align(alignment: Alignment.centerLeft, child: child),
    );
  }
}
