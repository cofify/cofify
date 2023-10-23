import 'package:cofify/screens/parts/restaurantList/loading_restaurants_view.dart';
import 'package:cofify/screens/parts/restaurantList/pill_buttons.dart';
import 'package:cofify/screens/parts/restaurantList/restaurants_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets

// models
import 'package:cofify/models/restaurants.dart';

// services

import '../../../providers/page_track_provider.dart';
import '../common/common_widget_imports.dart';

class RestaurantList extends StatelessWidget {
  final GlobalKey<PillButtonsFrontClippedTextState> pillKey =
      GlobalKey<PillButtonsFrontClippedTextState>();

  RestaurantList({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurants = Provider.of<List<Restaurant>>(context);
    final pageController = Provider.of<PillButtonPageTracker>(context);

    return Scaffold(
      body: SafeArea(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SearchBox(
                          withFilters: true,
                          widthPercentage: 0.7,
                          function: () {},
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/account');
                          },
                          child: Hero(
                            flightShuttleBuilder: (
                              flightContext,
                              animation,
                              flightDirection,
                              fromHeroContext,
                              toHeroContext,
                            ) {
                              switch (flightDirection) {
                                // when push to new page
                                case HeroFlightDirection.push:
                                  return Material(
                                    color: Colors.transparent,
                                    child: ScaleTransition(
                                      scale: animation.drive(
                                        Tween<double>(begin: 0, end: 1).chain(
                                          CurveTween(
                                            curve: Curves.fastOutSlowIn,
                                          ),
                                        ),
                                      ),
                                      child: toHeroContext.widget,
                                    ),
                                  );

                                // when return from new page
                                case HeroFlightDirection.pop:
                                  return Material(
                                    color: Colors.transparent,
                                    child: fromHeroContext.widget,
                                  );
                              }
                            },
                            tag: 'restaurant-settings-UserAvatar',
                            child: const UserAvatar(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    PillButtons(
                        pillKey: pillKey, pageController: pageController),
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
