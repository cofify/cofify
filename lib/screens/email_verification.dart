import 'package:cofify/providers/auth_exceptions.dart';
import 'package:cofify/services/auth_service.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final AuthService auth = AuthService.firebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikacija Naloga'),
      ),
      body: Column(
        children: [
          const Text(
            'Na Vasu email adresu smo poslali verifikacioni link. Proverite prijemno sanduce!',
          ),
          const Text(
            'Nakon sto verifikujete nalog molimo vas da se prijavite na vas nalog',
          ),
          TextButton(
            onPressed: () async {
              try {
                await auth.sendEmailVerification();
              } catch (e) {
                if (e is UserNotFoundAuthException) {
                  Navigator.of(context).pushNamed('/loginScreen');
                }
              }
            },
            child: const Text('Posalji verifikacioni link ponovo'),
          ),
          ElevatedButton(
            onPressed: () async {
              await auth.signOut();
              //Navigator.of(context).pushNamed('/loginScreen');
            },
            child: const Text('Prijavi se'),
          ),
          ElevatedButton(
            onPressed: () async {
              await auth.signOut();
              //Navigator.of(context).pushNamed('/loginScreen');
            },
            child: const Text('Predji u drugi nalog'),
          )
        ],
      ),
    );
  }
}
