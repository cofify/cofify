import 'package:cofify/firebase_options.dart';
import 'package:cofify/models/user.dart';
import 'package:cofify/screens/wrapper.dart';
import 'package:cofify/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _auth = AuthService.firebase();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      value: _auth.user,
      initialData: MyUser(uid: ''),
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
