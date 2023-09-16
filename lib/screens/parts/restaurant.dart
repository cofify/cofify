import 'package:cofify/screens/parts/restaurant/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      body: MyNestedScrollView(),
    );
  }
}

class MyNestedScrollView extends StatelessWidget {
  const MyNestedScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurants = Provider.of<List<Restaurant>>(context);
    final pageController = Provider.of<PillButtonPageTracker>(context);

    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.grey[50],
              toolbarHeight: 180,
              floating: true,
              snap: true,
              flexibleSpace: Column(
                children: [
                  const SizedBox(height: 20.0),
                  const SearchBox(withFilters: true),
                  const SizedBox(height: 20.0),
                  PillButtons(pageController: pageController),
                ],
              ),
            ),
          ];
        },
        body: PageView(
          controller: pageController.pageController,
          children: [
            FavouriteRestourants(allRestaurants: restaurants),
            AllRestaurants(restaurants: restaurants),
          ],
        ),
      ),
    );
  }
}

class PillButtons extends StatelessWidget {
  final PillButtonPageTracker pageController;

  const PillButtons({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 240,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadowsFactory().boxShadowSoft()],
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  pageController.setCurrentPage(0);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                  width: 120,
                  alignment: Alignment.center,
                  child: const Text(
                    "Omiljeni",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  pageController.setCurrentPage(1);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 16,
                  ),
                  width: 120,
                  alignment: Alignment.center,
                  child: const Text(
                    "Svi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          left: (pageController.selectedIndex == 0) ? 0 : 120,
          child: Container(
            width: 120,
            height: 53,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ],
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

class LoadingRestaurantsView extends StatelessWidget {
  const LoadingRestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final double listViewPadding = MediaQuery.of(context).size.width * 0.05;
    const double imageHeight = 200;

    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(top: (index == 0) ? 20.0 : 0),
          child: Container(
            margin: EdgeInsets.only(
              bottom: 16,
              left: listViewPadding,
              right: listViewPadding,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadowsFactory().boxShadowSoft(),
              ],
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[100]!,
              highlightColor: Colors.grey[300]!,
              child: RestaurantLoadingCard(
                imageHeight: imageHeight,
                listViewPadding: listViewPadding,
              ),
            ),
          ),
        );
      },
    );
  }
}
