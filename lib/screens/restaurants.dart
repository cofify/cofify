import 'package:cofify/models/restaurants.dart';
import 'package:cofify/screens/parts/restaurant_widget.dart';
import 'package:cofify/services/restaurants_database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RestaurantsView extends StatefulWidget {
  const RestaurantsView({super.key});

  @override
  State<RestaurantsView> createState() => _RestaurantsViewState();
}

class _RestaurantsViewState extends State<RestaurantsView> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Restaurant>>.value(
      value: RestaurantDatabaseService().restaurants,
      initialData: const [],
      child: const RestaurantsList(),
    );
  }
}
