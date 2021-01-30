import 'package:flutter/material.dart';
import 'package:smusy_v2/app/module.dart';

class BlackButton extends StatelessWidget {
  const BlackButton({
    Key key,
    @required this.isLoading,
    @required this.onPressed,
    @required this.borderRadius,
    @required this.child,
  })  : assert(isLoading != null),
        assert(onPressed != null),
        assert(borderRadius != null),
        assert(child != null),
        super(key: key);

  final bool isLoading;
  final VoidCallback onPressed;
  final BorderRadiusGeometry borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ButtonTheme(
        disabledColor: Colors.white.disabledOnColor,
        child: FancyRaisedButton(
          isLoading: isLoading,
          onPressed: onPressed,
          color: Colors.black,
          textColor: MaterialStateColor.resolveWith((states) {
            return states.contains(MaterialState.disabled)
                ? Colors.black.disabledOnColor
                : Colors.black.highEmphasisOnColor;
          }),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          child: child,
        ),
      ),
    );
  }
}
