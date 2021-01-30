import 'package:flutter/material.dart';
import 'package:sudokuSolver/app/module.dart';

import '../models.dart';

class ContentMediaWidget extends StatelessWidget {
  const ContentMediaWidget(this.contentId, this.media)
      : assert(contentId != null),
        assert(media != null);

  final Id<Content> contentId;
  final ContentMedia media;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ContentMedia.aspectRatio,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _buildBackground(),
            for (final textOverlay in media.textOverlays)
              Align(
                alignment: Alignment(textOverlay.x, textOverlay.y),
                child: Text(textOverlay.text, style: TextOverlay.baseTextStyle),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return media.background.when(
      image: () {
        return FutureBuilder<String>(
          future: MediaBackground.getImageDownloadUrl(contentId),
          builder: (context, snapshot) {
            if (snapshot.hasNoData) {
              return Center(
                child: snapshot.hasError
                    ? Text('Es ist ein Fehler aufgetreten:\n${snapshot.error}')
                    : CircularProgressIndicator(),
              );
            }

            final url = snapshot.data;
            return Image.network(url, fit: BoxFit.cover);
          },
        );
      },
      gradient: (colors) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SizedBox.expand(),
        );
      },
    );
  }
}
