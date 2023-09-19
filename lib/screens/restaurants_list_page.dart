import 'package:cofify/models/restaurants.dart';
import 'package:cofify/screens/parts/restaurant/restaurant_list.dart';
import 'package:cofify/services/location_service.dart';
import 'package:cofify/services/restaurants_database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RestaurantsListPage extends StatelessWidget {
  const RestaurantsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocationService().checkAndRequestLocationPermission(),
      builder: (context, snapshot) {
        return StreamProvider<List<Restaurant>>.value(
          value: RestaurantDatabaseService().restaurants,
          initialData: const [],
          child: const RestaurantList(),
        );
      },
    );
  }
}
