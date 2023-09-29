import 'package:cofify/models/user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  MyUser? get currentUser;
  Future<MyUser> signInAnon();
  Future<MyUser> signUpEmailPass(
    String email,
    String password,
    String name,
    String surname,
  );
  Future<MyUser> signInEmailPass(
    String email,
    String password,
  );
  Future<MyUser> signInWithGoogle();
  Future<void> signOut();
  Stream<MyUser> get user;
  Future<void> sendEmailVerification();
  Future<void> resetPassword(
    String email,
  );
}
