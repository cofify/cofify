import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyUser extends ChangeNotifier {
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

class UserData {
  final String name;
  final String lastName;
  final String location;

  UserData({
    required this.name,
    required this.lastName,
    required this.location,
  });
}
