import 'package:cofify/screens/login.dart';
import 'package:cofify/screens/register.dart';
import 'package:cofify/screens/user_profile.dart';
import 'package:flutter/material.dart';

// screens
import '../screens/wrapper.dart';
import '../screens/choose_city.dart';
import '../screens/welecome_page.dart';
import '../screens/restaurants_view.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const Wrapper(),
  '/welcomePages': (context) => const WelecomePage(),
  '/loginScreen': (context) => const LoginView(),
  '/chooseCity': (context) => const ChooseCity(),
  '/restaurants': (context) => const RestaurantsView(),
  '/register': (context) => const RegisterView(),
  '/userProfile': (context) => const UserProfile(),
};
