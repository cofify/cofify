import 'package:cofify/screens/parts/restaurantList/loading_restaurants_view.dart';
import 'package:cofify/screens/parts/restaurantList/pill_buttons.dart';
import 'package:cofify/screens/parts/restaurantList/restaurant_card.dart';
import 'package:cofify/screens/parts/restaurantList/restaurants_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// widgets

// models
import 'package:cofify/models/restaurants.dart';

// services
import 'package:cofify/services/auth_service.dart';
import 'package:cofify/services/user_database_service.dart';

import '../../../providers/page_track_provider.dart';
import '../common/common_widget_imports.dart';
import 'restaurant_loading_card.dart';

class RestaurantList extends StatelessWidget {
  final GlobalKey<PillButtonsFrontClippedTextState> pillKey =
      GlobalKey<PillButtonsFrontClippedTextState>();

  RestaurantList({super.key});
  // ignore: prefer_typing_uninitialized_variables

  @override
  Widget build(BuildContext context) {
    final restaurants = Provider.of<List<Restaurant>>(context);
    final pageController = Provider.of<PillButtonPageTracker>(context);

    final authService = AuthService.firebase();
    DatabaseService dbService =
        DatabaseService(uid: authService.currentUser!.uid);

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.grey[50],
                toolbarHeight: 240,
                floating: true,
                snap: true,
                flexibleSpace: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SearchBox(
                          withFilters: true,
                          widthPercentage: 0.7,
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/account');
                          },
                          child: const Hero(
                            tag: 'restaurant-settings-UserAvatar',
                            child: UserAvatar(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    PillButtons(
                        pillKey: pillKey, pageController: pageController),
                    const SizedBox(height: 20.0),
                    // const Test(),
                  ],
                ),
              ),
            ];
          },
          body: PageView(
            controller: pageController.pageController,
            onPageChanged: (int numPage) {
              pageController.setCurrentPageDontNotifySelf(numPage);
            },
            scrollDirection: Axis.horizontal,
            children: [
              FavouriteRestourantsWrapper(allRestaurants: restaurants),
              AllRestaurantsWrapper(restaurants: restaurants),
            ],
          ),
        ),
      ),
    );
  }
}

class AllRestaurantsWrapper extends StatelessWidget {
  final List<Restaurant> restaurants;

  const AllRestaurantsWrapper({
    super.key,
    required this.restaurants,
  });

  @override
  Widget build(BuildContext context) {
    return (restaurants.isNotEmpty)
        ? RestaurantsView(restaurants: restaurants)
        : const LoadingRestaurantsView();
  }
}

class FavouriteRestourantsWrapper extends StatelessWidget {
  final List<Restaurant> allRestaurants;

  const FavouriteRestourantsWrapper({
    super.key,
    required this.allRestaurants,
  });

  @override
  Widget build(BuildContext context) {
    List<Restaurant> restaurants = [];

    // Filter favourite restaurants
    for (var element in allRestaurants) {
      if (element.isFavourite) restaurants.add(element);
    }

    return (restaurants.isNotEmpty)
        ? RestaurantsView(restaurants: restaurants)
        : const LoadingRestaurantsView();
  }
}
