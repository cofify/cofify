import 'package:cofify/models/user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  MyUser? get currentUser;
  Future<MyUser> signInAnon();
  Future<MyUser> signInWithGoogle();
  Future<void> signOut();
  Stream<MyUser> get user;
}
