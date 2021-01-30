import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smusy_v2/app/module.dart';

part 'cubit.freezed.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInState.initial());

  final _googleSignIn = GoogleSignIn();
  final _facebookSignIn = FacebookLogin();

  Future<void> signInWithGoogle() async {
    logger.i('Signing in with Google');
    emit(SignInState.isSigningIn());

    final result = await _googleSignIn.signIn();
    if (result == null) {
      emit(SignInState.error(SignInError.userAbort));
      return;
    }

    final googleAuth = await result.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _signInWithCredential(credential);
  }

  Future<void> signInWithFacebook() async {
    logger.i('Signing in with Facebook');
    emit(SignInState.isSigningIn());

    final result = await _facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credentialFacebook =
            FacebookAuthProvider.credential(result.accessToken.token);
        await _signInWithCredential(credentialFacebook);
        break;
      case FacebookLoginStatus.cancelledByUser:
        emit(SignInState.error(SignInError.userAbort));
        break;
      case FacebookLoginStatus.error:
        emit(SignInState.error(SignInError.notWorking));
        break;
    }
  }

  Future<void> _signInWithCredential(AuthCredential credential) async {
    try {
      await services.firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          emit(SignInState.error(SignInError.credentialsWrong));
          return;
        case 'user-disabled':
          emit(SignInState.error(SignInError.userDisabled));
          return;
        case 'invalid-credential':
          emit(SignInState.error(SignInError.credentialsInvalid));
          return;
        case 'account-exists-with-different-credential':
          emit(SignInState.error(SignInError.accountExists));
          return;
        case 'operation-not-allowed':
          logger.e(
            'Got "operation-not-allowed" when signing in with provider "${credential.providerId}".',
          );
          emit(SignInState.error(SignInError.operationNotAllowed));
          return;
        case 'unknown':
          if (e.message
              .startsWith('com.google.firebase.FirebaseNetworkException')) {
            emit(SignInState.error(SignInError.offline));
            return;
          }
          rethrow;
      }
    }
    logger.i('Sign in with Credentials was successful');
    emit(SignInState.success());
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    logger.i('Signing in as $email…');
    emit(SignInState.isSigningIn());
    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    await _signInWithCredential(credential);
  }
}

@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState.initial() = _InitialState;
  const factory SignInState.isSigningIn() = _SigningInState;
  const factory SignInState.error(SignInError error) = _ErrorState;
  const factory SignInState.success() = _SuccessState;
}

enum SignInError {
  offline,
  credentialsInvalid,
  credentialsWrong,
  accountExists,
  userDisabled,
  userAbort,
  notWorking,
  operationNotAllowed,
}
