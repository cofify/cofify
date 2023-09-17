// ignore_for_file: unused_import

import 'package:cofify/models/user.dart';
import 'package:cofify/screens/choose_city.dart';
import 'package:cofify/screens/loadingScreen.dart';
// import 'package:cofify/screens/home.dart';
import 'package:cofify/screens/login_page.dart';
import 'package:cofify/screens/restaurants_page.dart';
import 'package:cofify/screens/welecome_page.dart';
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
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      return const WelecomePage();
      // return const LoginScreen();
    } else {
      // return const LoadingScreen();
      // return const HomeView();

      // Clear all routes from the stack
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      return const ChooseCity();
      // return const RestaurantsPage();
    }
  }
}
