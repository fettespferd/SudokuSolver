import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sudokuSolver/app/module.dart';

import 'user/models.dart';

part 'models.freezed.dart';

@freezed
abstract class Metadata implements _$Metadata {
  const factory Metadata({
    // This is only `null` before the first upload.
    Instant createdAt,
    // This is only `null` before the first upload.
    Instant updatedAt,
  }) = _Metadata;
  const Metadata._();

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      createdAt: (json['createdAt'] as Timestamp).asInstant,
      updatedAt: (json['updatedAt'] as Timestamp).asInstant,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'createdAt': createdAt?.asTimestamp ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

@freezed
abstract class Content extends Entity implements _$Content {
  const factory Content({
    @Default(Metadata()) Metadata metadata,
    @required Id<User> authorId,
    @required ContentMedia media,
    // @required Company company,
    // @required Job job,
  }) = _Content;
  const Content._();

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
      authorId: Id<User>(json['authorId'] as String),
      media: ContentMedia.fromJson(json['media'] as Map<String, dynamic>),
    );
  }

  static final collection = services.firebaseFirestore.collection('contents');

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'metadata': metadata.toJson(),
      'authorId': authorId.value,
      'media': media.toJson(),
    };
  }
}

@freezed
abstract class ContentMedia implements _$ContentMedia {
  const factory ContentMedia({
    @required MediaBackground background,
    @Default(<TextOverlay>[]) List<TextOverlay> textOverlays,
  }) = _ContentMedia;
  const ContentMedia._();

  factory ContentMedia.fromJson(Map<String, dynamic> json) {
    return ContentMedia(
      background:
          MediaBackground.fromJson(json['background'] as Map<String, dynamic>),
      textOverlays: json.containsKey('textOverlays')
          ? (json['textOverlays'] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map((e) => TextOverlay.fromJson(e))
              .toList()
          : <TextOverlay>[],
    );
  }

  static const aspectRatio = 9 / 16;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'background': background.toJson(),
        'textOverlays': textOverlays.map((e) => e.toJson()).toList(),
      };
}

@freezed
abstract class MediaBackground implements _$MediaBackground {
  /// The actual image is stored in Firebase Cloud Storage.
  ///
  /// See also: [getImageStorageRef], [getImageDownloadUrl]
  const factory MediaBackground.image() = ImageMediaBackground;

  /// Must contain at least one color.
  const factory MediaBackground.gradient(List<Color> colors) =
      GradientMediaBackground;
  const MediaBackground._();

  factory MediaBackground.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'image':
        return MediaBackground.image();
      case 'gradient':
        return MediaBackground.gradient(
          (json['colors'] as List<dynamic>)
              .cast<String>()
              .map((it) => it.parseHexColor())
              .toList(),
        );
      default:
        throw FormatException('Unknown MediaBackground type: $type.');
    }
  }

  static final storageBase = services.firebaseStorage.ref().child('contents');

  static Reference getImageStorageRef(Id<Content> contentId) =>
      storageBase.child(contentId.value).child('background.jpg');
  static Future<String> getImageDownloadUrl(Id<Content> contentId) =>
      getImageStorageRef(contentId).getDownloadURL();

  Map<String, dynamic> toJson() {
    return when(
      image: () => <String, dynamic>{'type': 'image'},
      gradient: (colors) => <String, dynamic>{
        'type': 'gradient',
        'colors': colors.map((it) => it.toHexString()).toList(),
      },
    );
  }
}

@freezed
abstract class TextOverlay implements _$TextOverlay {
  const factory TextOverlay(String text, double x, double y) = _TextOverlay;
  const TextOverlay._();

  factory TextOverlay.fromJson(Map<String, dynamic> json) {
    return TextOverlay(
      json['text'] as String,
      json['x'] as double,
      json['y'] as double,
    );
  }

  static final baseTextStyle = TextStyle(
    inherit: false,
    color: Colors.white,
    fontSize: 16,
    textBaseline: TextBaseline.alphabetic,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
  );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'text': text, 'x': x, 'y': y};
}
