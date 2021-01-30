import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';

class FancyText extends StatefulWidget {
  const FancyText(
    this.data, {
    Key key,
    this.maxLines,
    this.showRichText = false,
    this.estimatedWidth,
    this.style,
    this.emphasis,
    this.textAlign,
  })  : assert(maxLines == null || maxLines >= 1),
        assert(showRichText != null),
        assert(!showRichText || maxLines == null,
            "maxLines isn't supported in combination with showRichText."),
        assert(estimatedWidth == null || estimatedWidth > 0),
        assert(!showRichText || textAlign == null,
            "textAlign isn't supported in combination with showRichText."),
        super(key: key);

  const FancyText.rich(
    String data, {
    Key key,
    double estimatedWidth,
    TextStyle style,
    TextEmphasis emphasis,
  }) : this(
          data,
          key: key,
          showRichText: true,
          estimatedWidth: estimatedWidth,
          style: style,
          emphasis: emphasis,
        );

  const FancyText.preview(
    String data, {
    Key key,
    int maxLines = 1,
    double estimatedWidth,
    TextStyle style,
  }) : this(
          data,
          key: key,
          maxLines: maxLines,
          showRichText: false,
          estimatedWidth: estimatedWidth,
          style: style,
          emphasis: TextEmphasis.medium,
        );

  final String data;
  final int maxLines;
  final bool showRichText;
  final double estimatedWidth;
  final TextStyle style;
  final TextEmphasis emphasis;
  final TextAlign textAlign;

  @override
  _FancyTextState createState() => _FancyTextState();
}

class _FancyTextState extends State<FancyText> {
  double lastLineWidthFactor;

  @override
  void initState() {
    super.initState();

    if (widget.estimatedWidth == null) {
      lastLineWidthFactor = lerpDouble(0.2, 0.9, Random().nextDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.style ?? TextStyle();
    if (widget.emphasis != null) {
      final theme = context.theme;
      Color color;
      if (widget.emphasis == TextEmphasis.high) {
        color = theme.highEmphasisOnBackground;
      } else if (widget.emphasis == TextEmphasis.medium) {
        color = theme.mediumEmphasisOnBackground;
      } else if (widget.emphasis == TextEmphasis.disabled) {
        color = theme.disabledOnBackground;
      } else {
        assert(false, 'Unknown emphasis: ${widget.emphasis}.');
      }
      style = style.copyWith(color: color);
    }

    Widget child;
    if (widget.data == null) {
      child = _buildLoading(context, style);
    } else {
      child = widget.showRichText
          ? _buildRichText(context, style)
          : _buildPlainText(style);
    }

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      layoutBuilder: (current, previous) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            ...previous,
            if (current != null) current,
          ],
        );
      },
      child: child,
    );
  }

  Widget _buildLoading(BuildContext context, TextStyle style) {
    final theme = context.theme;
    final resolvedStyle = context.defaultTextStyle.style.merge(style);
    final color = context.theme.isDark ? theme.disabledColor : Colors.black38;

    Widget buildBar({double width, double widthFactor}) {
      assert((width == null) != (widthFactor == null));

      return Row(
        children: [
          Text('', style: style),
          Material(
            shape: StadiumBorder(),
            color: color,
            child: FractionallySizedBox(
              widthFactor: widthFactor,
              child: SizedBox(
                width: width,
                height: resolvedStyle.fontSize *
                    (resolvedStyle.height ?? 1) *
                    context.mediaQuery.textScaleFactor,
              ),
            ),
          ),
        ],
      );
    }

    assert(widget.estimatedWidth == null || lastLineWidthFactor == null);
    final fullLines = widget.maxLines != null ? widget.maxLines - 1 : 0;
    final lineSpacing =
        ((resolvedStyle.height ?? 1.5) - 1) * resolvedStyle.fontSize;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var i = 0; i < fullLines; i++) ...[
          buildBar(widthFactor: 1),
          SizedBox(height: lineSpacing)
        ],
        buildBar(
          width: widget.estimatedWidth,
          widthFactor: lastLineWidthFactor,
        ),
      ],
    );
  }

  Widget _buildPlainText(TextStyle style) {
    var data = widget.data;

    // 2. Collapse whitespace.
    data = data
        .replaceAll(RegExp('[\r\n\t]+'), ' ')
        // Collapes simple and non-breaking spaces
        .replaceAll(RegExp('[ \u00A0]+'), ' ')
        .trim();

    return Text(
      data,
      maxLines: widget.maxLines,
      overflow: widget.maxLines == null ? null : TextOverflow.ellipsis,
      style: style,
      textAlign: widget.textAlign,
    );
  }

  Widget _buildRichText(BuildContext context, TextStyle style) {
    return Text(widget.data, style: style);
  }
}

enum TextEmphasis {
  high,
  medium,
  disabled,
}
