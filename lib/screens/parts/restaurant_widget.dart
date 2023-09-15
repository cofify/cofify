import 'package:cofify/screens/parts/restaurant/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// widgets

// models
import 'package:cofify/models/restaurants.dart';

// services
import 'package:cofify/services/auth_service.dart';
import 'package:cofify/services/user_database_service.dart';

import '../../providers/page_track_provider.dart';
import 'common/common_widget_imports.dart';
import 'restaurant/restaurant_loading_card.dart';

class RestaurantsList extends StatefulWidget {
  const RestaurantsList({super.key});

  @override
  State<RestaurantsList> createState() => _RestaurantsListState();
}

class _RestaurantsListState extends State<RestaurantsList> {
  final authService = AuthService.firebase();
  // ignore: prefer_typing_uninitialized_variables
  var dbService;

  @override
  Widget build(BuildContext context) {
    dbService = DatabaseService(uid: authService.currentUser!.uid);

    return const Scaffold(
      appBar: CommonAppBar(text: "Lista Kafica"),
      body: MyNestedScrollView(),
    );
  }
}

class MyNestedScrollView extends StatelessWidget {
  const MyNestedScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurants = Provider.of<List<Restaurant>>(context);
    final pageController = Provider.of<PageTracker>(context);

    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            toolbarHeight: 200,
            floating: true,
            snap: true,
            flexibleSpace: Column(
              children: [
                const SizedBox(height: 20.0),
                const SearchBox(),
                const SizedBox(height: 20.0),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SmallButton(
                      onPress: () {
                        pageController.setCurrentPage(0);
                      },
                      buttonText: "Svi",
                    ),
                    Positioned(
                      child: SmallButton(
                        onPress: () {
                          pageController.setCurrentPage(1);
                        },
                        buttonText: "Omiljeni",
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ];
      },
      body: PageView(
        controller: pageController.pageController,
        children: [
          AllRestaurants(restaurants: restaurants),
          FavouriteRestourants(allRestaurants: restaurants),
        ],
      ),
    );
  }
}

class AllRestaurants extends StatelessWidget {
  final List<Restaurant> restaurants;

  const AllRestaurants({
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

class FavouriteRestourants extends StatelessWidget {
  final List<Restaurant> allRestaurants;

  const FavouriteRestourants({
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
        return RestaurantCard(
          listViewPadding: listViewPadding,
          imageHeight: imageHeight,
          restaurant: restaurants[index],
        );
      },
    );
  }
}

class LoadingRestaurantsView extends StatelessWidget {
  const LoadingRestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final double listViewPadding = MediaQuery.of(context).size.width * 0.05;
    const double imageHeight = 200;

    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[400]!,
            child: RestaurantLoadingCard(
              imageHeight: imageHeight,
              listViewPadding: listViewPadding,
            ),
          ),
        );
      },
    );
  }
}
