import 'package:cofify/models/user.dart';
// import 'package:cofify/screens/home.dart';
import 'package:cofify/screens/login.dart';
import 'package:cofify/screens/restaurants_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    if (user.uid == '') {
      return const LoginView();
    } else {
      return const RestaurantsView();
      //return const HomeView();
    }
  }
}
