import 'package:cofify/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService.firebase();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prijavi se'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await auth.signInAnon();
            },
            child: const Text('Anonimus'),
          ),
          ElevatedButton(
            onPressed: () async {
              await auth.signInWithGoogle();
            },
            child: const Text('Google'),
          ),
        ],
      ),
    );
  }
}
