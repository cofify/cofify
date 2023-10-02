import 'package:cofify/providers/auth_exceptions.dart';
import 'package:cofify/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  String error = '';

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService.firebase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prijava'),
      ),
      body: Center(
        child: ListView(padding: const EdgeInsets.all(16.0), children: [
          Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email adresa',
                  hintText: 'petar.petrovic@gmail.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Lozinka',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text;
                    final password = passwordController.text;
                    if (email.isEmpty) {
                      error = 'Email adresa je obavezna';
                      setState(() {});
                      return;
                    } else if (password.isEmpty) {
                      error = 'Lozinka je obavezna';
                      setState(() {});
                      return;
                    }
                    try {
                      await auth.signInEmailPass(
                        email,
                        password,
                      );
                      Navigator.of(context).pop();
                    } catch (e) {
                      if (e is UserNotFoundAuthException) {
                        error = 'Korisnik sa unetim podacima ne postoji!.';
                      } else if (e is WrongPasswordAuthException) {
                        error = 'Pogresna loznika';
                      } else {
                        error = 'Doslo je do greske, molimo pokusajte kasnije';
                      }
                      setState(() {});
                    }
                  },
                  child: const Text('Prijavi se'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                error,
              ),
              TextButton(
                onPressed: () async {
                  final email = emailController.text;
                  if (email.isEmpty) {
                    error = 'Morate uneti email adresu';
                    setState(() {});
                    return;
                  }
                  try {
                    await auth.resetPassword(
                      email,
                    );
                    error =
                        'Na vas email je poslat link za resetovanje lozinke';
                    setState(() {});
                  } catch (e) {
                    if (e is InvalidEmailAuthException) {
                      error = 'Neispravna email adresa';
                    } else if (e is UserNotFoundAuthException) {
                      error = 'Korisnik nije pronadjen';
                    } else {
                      error = 'Doslo je do greske, pokusajte kasnije';
                    }
                    setState(() {});
                  }
                },
                child: const Text(
                  'Zaboravljena lozinka?',
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
