// ignore_for_file: unused_import

import 'package:cofify/models/user.dart';
import 'package:cofify/screens/account.dart';
import 'package:cofify/screens/choose_city.dart';
import 'package:cofify/screens/loadingScreen.dart';
// import 'package:cofify/screens/home.dart';
import 'package:cofify/screens/login_page.dart';
import 'package:cofify/screens/register.dart';
import 'package:cofify/screens/restaurants_list_page.dart';
import 'package:cofify/screens/welecome_page.dart';
import 'dart:developer';

import 'package:cofify/models/user.dart';
import 'package:cofify/screens/choose_city.dart';
import 'package:cofify/screens/email_verification.dart';
// import 'package:cofify/screens/home.dart';
import 'package:cofify/screens/login.dart';
import 'package:cofify/screens/restaurants_view.dart';
import 'package:cofify/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets

// models

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    if (user.uid == '') {
      log("ovde sam");
      // return const LoginScreen();
      // return const WelecomePage();
      return const RegisterView();
    } else {
      // if (user.isVerified) {
      //   //return const UserProfile();
      //   return const RestaurantsListPage();
      //   //return const HomeView();
      // } else {
      //   return const EmailVerification();
      // }

      //return const HomePage();
      // return const RestaurantsView();
      return const Account();
      //return const ChooseCity();
    }
  }
}
