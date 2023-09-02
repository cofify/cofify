import 'dart:developer';

import 'package:cofify/firebase_options.dart';
import 'package:cofify/models/user.dart';
import 'package:cofify/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  MyUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return MyUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<MyUser> signInAnon() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      MyUser? user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw Error();
      }
    } catch (e) {
      log(e.toString());
      throw Error();
    }
  }

  @override
  Future<MyUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      MyUser? user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw Error();
      }
    } catch (e) {
      throw Error();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw Error();
    }
  }

  MyUser _userFormFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : MyUser(uid: '');
  }

  @override
  Stream<MyUser> get user {
    return FirebaseAuth.instance
        .authStateChanges()
        .map((user) => _userFormFirebaseUser(user));
  }
}
