import 'package:cofify/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthService _auth = AuthService.firebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prijavi se'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await _auth.signInAnon();
            },
            child: const Text('Anonimus'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _auth.signInWithGoogle();
            },
            child: const Text('Google'),
          ),
        ],
      ),
    );
  }
}
