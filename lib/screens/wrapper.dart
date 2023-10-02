import 'dart:developer';

import 'package:cofify/models/user.dart';
import 'package:cofify/screens/choose_city.dart';
import 'package:cofify/screens/email_verification.dart';
import 'package:cofify/screens/home_old.dart';
// import 'package:cofify/screens/home.dart';
import 'package:cofify/screens/login_screen.dart';
import 'package:cofify/screens/restaurants_view.dart';
import 'package:cofify/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets
import 'package:cofify/screens/home.dart';

// models
import 'package:cofify/models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    if (user.uid == '') {
      log("ovde sam");
      return const LoginScreen();
      // return const HomePage();
    } else {
      if (user.isVerified) {
        //return const UserProfile();
        return const ChooseCity();
        //return const HomeView();
      } else {
        return const EmailVerification();
      }

      //return const HomePage();
      // return const RestaurantsView();
      //return const ChooseCity();
    }
  }
}
