import 'dart:ui';

import 'package:flutter/material.dart';

//This is a generic pop up Dialog for that you can provide the arguments below. The background will be blurred.
class BlurryDialog extends StatelessWidget {
  const BlurryDialog._({
    @required this.title,
    @required this.content,
    @required this.buttonMessage,
    @required this.onButtonPressed,
  })  : assert(title != null),
        assert(content != null),
        assert(buttonMessage != null),
        assert(onButtonPressed != null);

  final String title;
  final String content;
  final String buttonMessage;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text(buttonMessage),
            onPressed: onButtonPressed,
          )
        ],
      ),
    );
  }
}

extension ShowBlurryDialog on BuildContext {
  Future<void> showBlurryDialog({
    @required String title,
    @required String content,
    @required String buttonMessage,
    @required VoidCallback onButtonPressed,
  }) {
    return showDialog<dynamic>(
      context: this,
      builder: (context) {
        return BlurryDialog._(
          title: title,
          content: content,
          buttonMessage: buttonMessage,
          onButtonPressed: onButtonPressed,
        );
      },
    );
  }
}
