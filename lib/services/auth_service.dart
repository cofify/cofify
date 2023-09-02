import 'package:cofify/models/user.dart';
import 'package:cofify/providers/auth_provider.dart';
import 'package:cofify/providers/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService({required this.provider});

  factory AuthService.firebase() =>
      AuthService(provider: FirebaseAuthProvider());

  @override
  MyUser? get currentUser => provider.currentUser;

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<MyUser> signInAnon() => provider.signInAnon();

  @override
  Future<MyUser> signInWithGoogle() => provider.signInWithGoogle();

  @override
  Future<void> signOut() => provider.signOut();

  @override
  Stream<MyUser> get user => provider.user;
}
