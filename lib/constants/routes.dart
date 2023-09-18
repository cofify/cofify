import 'package:flutter/material.dart';

// screens
import 'package:cofify/screens/login_page.dart';
import 'package:cofify/screens/restaurant_page.dart';
import '../screens/wrapper.dart';
import '../screens/choose_city.dart';
import '../screens/welecome_page.dart';
import '../screens/restaurants_list_page.dart';
import '../screens/account.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const Wrapper(),
  '/welcomePages': (context) => const WelecomePage(),
  '/loginScreen': (context) => const LoginScreen(),
  '/chooseCity': (context) => const ChooseCity(),
  '/restaurantsList': (context) => const RestaurantsListPage(),
  '/restaurant': (context) => const RestaurantPage(),
  '/account': (context) => const Account(),
};
