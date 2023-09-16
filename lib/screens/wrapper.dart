import 'package:cofify/models/user.dart';
// import 'package:cofify/screens/home.dart';
import 'package:cofify/screens/login_page.dart';
import 'package:cofify/screens/restaurants_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets

// models

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    if (user.uid == '') {
      return const LoginScreen();
      // return const HomePage();
    } else {
      // return const HomePage();
      // return const HomeView();
      return const RestaurantsView();
    }
  }
}
