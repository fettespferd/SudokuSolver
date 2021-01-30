import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smusy_v2/app/module.dart';
import 'package:smusy_v2/content/module.dart';

/// Previews the camera feed while indicating the portion that's visible after
/// cropping.
///
/// This widget determines the largest possible usable portion, based on
/// [ContentMedia.aspectRatio], and adds a grey, translucent overlay over the
/// rest.
///
/// It then sizes the camera preview to cover that usable portion, possibly
/// extending behind display cutouts/etc.
class CroppedCameraPreview extends StatelessWidget {
  const CroppedCameraPreview(this.controller) : assert(controller != null);

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final padding = context.mediaQuery.viewInsets.clamp(
      context.mediaQuery.viewPadding,
      EdgeInsets.all(double.infinity),
    ) as EdgeInsets;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final visibleSize = padding.deflateSize(size);

        const contentAspectRatio = ContentMedia.aspectRatio;
        final contentWidth = math.min(
            visibleSize.width, visibleSize.height * contentAspectRatio);
        final contentHeight = contentWidth / contentAspectRatio;

        final previewAspectRatio = controller.value.aspectRatio;
        var previewWidth = contentWidth;
        var previewHeight = previewWidth / previewAspectRatio;
        if (previewHeight < contentHeight) {
          previewHeight = contentHeight;
          previewWidth = previewHeight * previewAspectRatio;
        }
        final verticalPreviewInset = size.height - previewHeight;
        final horizontalPreviewInset = size.width - previewWidth;

        return Stack(
          children: [
            Positioned(
              left: (horizontalPreviewInset - padding.horizontal) / 2 +
                  padding.left,
              top: (verticalPreviewInset - padding.vertical) / 2 + padding.top,
              right: (horizontalPreviewInset - padding.horizontal) / 2 +
                  padding.right,
              bottom: (verticalPreviewInset - padding.vertical) / 2 +
                  padding.bottom,
              child: CustomPaint(
                foregroundPainter: _OverlayPainter(
                  Rect.fromCenter(
                    center: Offset(previewWidth, previewHeight) / 2,
                    width: contentWidth,
                    height: contentHeight,
                  ),
                ),
                child: controller.buildPreview(),
              ),
            ),
            // Make sure that we fill the whole screen.
            SizedBox.expand(),
          ],
        );
      },
    );
  }
}

class _OverlayPainter extends CustomPainter {
  _OverlayPainter(this.relevantArea)
      : assert(relevantArea != null),
        _paint = Paint()..color = Colors.black.withOpacity(0.5);

  final Paint _paint;
  final Rect relevantArea;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addRect(relevantArea),
    );
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter oldDelegate) =>
      oldDelegate._paint != _paint || oldDelegate.relevantArea != relevantArea;
}
