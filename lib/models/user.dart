import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  final String uid;
  final bool isVerified;
  MyUser({
    required this.uid,
    required this.isVerified,
  });
  factory MyUser.fromFirebase(User user) => MyUser(
        uid: user.uid,
        isVerified: user.emailVerified,
      );
}

class UserData extends MyUser {
  final String displayName;
  final String? profileImage;
  final String email;

  UserData({
    required super.uid,
    required super.isVerified,
    required this.displayName,
    required this.profileImage,
    required this.email,
  });
}
