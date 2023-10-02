import 'dart:developer';

import 'package:cofify/firebase_options.dart';
import 'package:cofify/models/user.dart';
import 'package:cofify/providers/auth_exceptions.dart';
import 'package:cofify/providers/auth_provider.dart';
import 'package:cofify/services/user_database_service.dart';
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
        await DatabaseService(uid: user.uid).updateUserData(
          gUser.displayName,
          gUser.email,
          gUser.photoUrl,
        );
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
    return user != null
        ? MyUser(
            uid: user.uid,
            isVerified: user.emailVerified,
          )
        : MyUser(
            uid: '',
            isVerified: false,
          );
  }

  @override
  Stream<MyUser> get user {
    return FirebaseAuth.instance.authStateChanges().map((user) {
      return _userFormFirebaseUser(user);
    });
  }

  @override
  Future<MyUser> signUpEmailPass(
    String email,
    String password,
    String name,
    String surname,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      MyUser? user = currentUser;
      if (user != null) {
        await DatabaseService(uid: user.uid)
            .updateUserData("$name $surname", email, null);
        await sendEmailVerification();
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<MyUser> signInEmailPass(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      MyUser? user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.sendEmailVerification();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          throw UserNotFoundAuthException();
        } else {
          throw GenericAuthException();
        }
      }
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> resetPassword(
    String email,
  ) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<UserData?> get getUserData async {
    if (FirebaseAuth.instance.currentUser != null) {
      return await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .getUserData();
    } else {
      throw UserNotFoundAuthException();
    }
  }
}
