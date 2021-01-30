import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sudokuSolver/app/module.dart';
import 'package:enum_to_string/enum_to_string.dart';

part 'models.freezed.dart';

enum Difficulty { easy, medium, hard }

@freezed
abstract class Question extends Entity implements _$Question {
  const factory Question({
    @required L10nString text,
    @required List<L10nString> answers,
    @nullable int solutionIndex,
    @required Id<Topic> topicId,
    @required Difficulty difficulty,
  }) = _Question;

  const Question._();

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: L10nString.fromJson(
          (json['text'] as Map<dynamic, dynamic>).cast<String, dynamic>()),
      answers: (json['answers'] as List<dynamic>)
          .map((dynamic e) => L10nString.fromJson(
              (e as Map<dynamic, dynamic>).cast<String, dynamic>()))
          .toList(),
      solutionIndex: json['solutionIndex'] as int,
      topicId: Id<Topic>(json['topicId'] as String),
      difficulty: EnumToString.fromString(
          Difficulty.values, json['difficulty'] as String),
    );
  }
  static final collection = services.firebaseFirestore.collection('questions');

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'text': text,
      'answers': answers,
      'solutionIndex': solutionIndex,
      'topicId': topicId.value,
      'difficulty': describeEnum(difficulty),
    };
  }
}

@freezed
abstract class Topic extends Entity implements _$Topic {
  const factory Topic({
    @required L10nString title,
    @required Color color,
  }) = _Topic;

  const Topic._();

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      title: L10nString.fromJson(json['title'] as Map<String, dynamic>),
      color: (json['color'] as String).parseHexColor(),
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'color': color.toHexString(),
    };
  }

  static final collection = services.firebaseFirestore.collection('topics');

  static Stream<List<Id<Topic>>> sortedByTitle(Locale locale) {
    return Topic.collection
        .orderBy(FieldPath(['title', locale.languageCode]))
        .snapshots()
        .map((it) => it.docs.map((it) => Id<Topic>(it.id)).toList());
  }

  static final _storageBase = services.firebaseStorage.ref().child('topics');
  static Reference _getPreviewStorageRef(Id<Topic> topicId) =>
      _storageBase.child(topicId.value).child('preview.svg');
  static Future<String> getPreviewDownloadUrl(Id<Topic> topicId) =>
      _getPreviewStorageRef(topicId).getDownloadURL();
}
