import 'dart:developer';

import 'package:cofify/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kreira MyUser objekat na osnovu FirebaseUser
  MyUser _userFormFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : MyUser(uid: '');
  }

  // Stream za promenu korisnika
  Stream<MyUser> get user {
    return _auth.authStateChanges().map((user) => _userFormFirebaseUser(user));
  }

  // Prijavi se kao ANONIMUS
  Future signInAnon() async {
    try {
      UserCredential credential = await _auth.signInAnonymously();
      User? user = credential.user;
      return _userFormFirebaseUser(user);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Prijavi se preko GOOGLE-a
  Future signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Odjavi se
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
