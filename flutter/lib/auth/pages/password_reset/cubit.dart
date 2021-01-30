import 'package:firebase_auth/firebase_auth.dart';
import 'package:smusy_v2/app/module.dart';

part 'cubit.freezed.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit() : super(PasswordResetState.initial());

  Future<void> passwordReset(String email) async {
    logger.i('Reset for $email ');
    emit(PasswordResetState.isResetting());
    try {
      await services.firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          emit(PasswordResetState.error(PasswordResetError.emailInvalid));
          return;
        case 'user-not-found':
          emit(PasswordResetState.error(PasswordResetError.userNotFound));
          return;
        case 'unknown':
          if (e.message
              .startsWith('com.google.firebase.FirebaseNetworkException')) {
            emit(PasswordResetState.error(PasswordResetError.offline));
            return;
          }
      }
      rethrow;
    }
    logger.i('Reset email was sent successfully!');
    emit(PasswordResetState.success());
  }
}

@freezed
abstract class PasswordResetState with _$PasswordResetState {
  const factory PasswordResetState.initial() = _PasswordInitialState;
  const factory PasswordResetState.isResetting() = _PasswordResettingState;
  const factory PasswordResetState.error(PasswordResetError error) =
      _PasswordErrorState;
  const factory PasswordResetState.success() = _PasswordSuccessState;
}

enum PasswordResetError { offline, emailInvalid, userNotFound }
