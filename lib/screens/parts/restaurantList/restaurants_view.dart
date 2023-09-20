import 'package:cofify/models/restaurants.dart';
import 'package:cofify/screens/parts/restaurantList/restaurant_card.dart';
import 'package:flutter/material.dart';

class RestaurantsView extends StatelessWidget {
  final List<Restaurant> restaurants;

  const RestaurantsView({
    super.key,
    required this.restaurants,
  });

  @override
  Widget build(BuildContext context) {
    final double listViewPadding = MediaQuery.of(context).size.width * 0.05;
    const double imageHeight = 200;

    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(top: (index == 0) ? 20.0 : 0),
          child: RestaurantCard(
            listViewPadding: listViewPadding,
            imageHeight: imageHeight,
            restaurant: restaurants[index],
          ),
        );
      },
    );
  }
}
