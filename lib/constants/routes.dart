import 'package:cofify/screens/login_page.dart';
import 'package:flutter/material.dart';

// screens
import '../screens/wrapper.dart';
import '../screens/choose_city.dart';
import '../screens/welecome_page.dart';
import '../screens/restaurants_page.dart';
import '../screens/account.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const Wrapper(),
  '/welcomePages': (context) => const WelecomePage(),
  '/loginScreen': (context) => const LoginScreen(),
  '/chooseCity': (context) => const ChooseCity(),
  '/restaurants': (context) => const RestaurantsPage(),
  '/account': (context) => const Account(),
};
