import 'package:cofify/providers/auth_exceptions.dart';
import 'package:cofify/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController repeatedPasswordController;

  final AuthService auth = AuthService.firebase();

  String error = '';

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    repeatedPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    surnameController.dispose();
    repeatedPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registracija'),
      ),
      body: Center(
        child: ListView(padding: const EdgeInsets.all(16.0), children: [
          Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Ime',
                  hintText: 'Petar',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: surnameController,
                decoration: const InputDecoration(
                  labelText: 'Prezime',
                  hintText: 'Petrovic',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
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
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: repeatedPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Ponovite lozinku',
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
                    final name = nameController.text;
                    final surname = surnameController.text;
                    final repeated = repeatedPasswordController.text;

                    if (name.isEmpty) {
                      error = 'Ime je obavezno!';
                      setState(() {});
                      return;
                    } else if (surname.isEmpty) {
                      error = 'Prezime je obavezno';
                      setState(() {});
                      return;
                    } else if (email.isEmpty) {
                      error = 'Email adresa je obavezna';
                      setState(() {});
                      return;
                    } else if (password.isEmpty) {
                      error = 'Lozinka je obavezna';
                      setState(() {});
                      return;
                    } else if (repeated.isEmpty) {
                      error = 'Morate ponovo uneti lozinku';
                      setState(() {});
                      return;
                    } else if (repeated != password) {
                      error = 'Lozinke se moraju poklapati';
                      setState(() {});
                      return;
                    }
                    try {
                      await auth.signUpEmailPass(
                        email,
                        password,
                        name,
                        surname,
                      );
                      Navigator.of(context).pop();
                    } catch (e) {
                      if (e is WeakPasswordAuthException) {
                        error = 'Slaba lozinka';
                      } else if (e is EmailAlreadyInUseAuthException) {
                        error = 'Vec postoji nalog sa ovom email adresom.';
                      } else if (e is InvalidEmailAuthException) {
                        error = 'Neispravna email adresa';
                      } else {
                        error = 'Doslo je do greske, molimo pokusajte kasnije';
                      }
                      setState(() {});
                    }
                  },
                  child: const Text('Registracija'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                error,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
