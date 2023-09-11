import 'package:flutter/material.dart';

// screens
import '../screens/choose_city.dart';
import '../screens/welecome_page.dart';
import '../screens/login_screen.dart';
import '../screens/wrapper.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const Wrapper(),
  '/welcomePages': (context) => const WelecomePage(),
  '/loginScreen': (context) => const LoginScreen(),
  '/chooseCity': (context) => const ChooseCity(),
};
