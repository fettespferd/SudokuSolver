import 'package:sudokuSolver/app/module.dart';
import 'package:sudokuSolver/auth/module.dart';

import '../models.dart';

part 'models.freezed.dart';

extension UserAuthService on AuthService {
  Stream<User> get user {
    return User.collection
        .doc(userId.value)
        .snapshots()
        .map((it) => User.fromJson(it.data()));
  }
}

/// Information about a signed-up user.
///
/// Missing fields from the old app: `school`, `bookmarkedArticles`,
/// `likedArticles`.
@freezed
abstract class User extends Entity implements _$User {
  const factory User({
    @Default(Metadata()) Metadata metadata,
    @required String firstName,
    @required String lastName,
    @required LocalDate birthday,
  }) = _User;

  const User._();
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      birthday: _decodeDate(json['birthdate']),
    );
  }

  static final collection = services.firebaseFirestore.collection('users');
  static final storageBase = services.firebaseStorage.ref().child('users');

  static LocalDate _decodeDate(dynamic value) =>
      LocalDateTimePattern.generalIso.parse(value as String).value.calendarDate;
  static String _encodeDate(LocalDate value) =>
      LocalDateTimePattern.generalIso.format(value.atMidnight());

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'metadata': metadata.toJson(),
      'firstname': firstName,
      'lastname': lastName,
      'birthdate': _encodeDate(birthday),
    };
  }
}
