import 'package:get_it/get_it.dart';
import 'package:sudokuSolver/app/module.dart';
import 'package:sudokuSolver/content/module.dart';

class AuthService {
  bool get isSignedIn => services.firebaseAuth.currentUser != null;
  Id<User> get userId {
    assert(isSignedIn);
    return Id<User>(services.firebaseAuth.currentUser.uid);
  }
}

extension AuthServiceGetIt on GetIt {
  AuthService get auth => get<AuthService>();
}
