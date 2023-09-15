import 'package:cofify/models/restaurants.dart';
import 'package:cofify/services/auth_service.dart';
import 'package:cofify/services/restaurants_database_service.dart';
import 'package:cofify/services/user_database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RestaurantsList extends StatefulWidget {
  const RestaurantsList({super.key});

  @override
  State<RestaurantsList> createState() => _RestaurantsListState();
}

class _RestaurantsListState extends State<RestaurantsList> {
  final authService = AuthService.firebase();
  // ignore: prefer_typing_uninitialized_variables
  var dbService;
  var selected = 1;
  var restaurantDatabaseService = RestaurantDatabaseService();

  @override
  Widget build(BuildContext context) {
    List<Restaurant> restaurants = Provider.of<List<Restaurant>>(context);
    dbService = DatabaseService(uid: authService.currentUser!.uid);
    if (restaurants.length == 1 && restaurants[0].uid.isEmpty) {
      // loading
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lista Kafica'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                _showSortOptions(context, restaurants, true);
              },
            ),
          ],
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (restaurants.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lista Kafica'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                _showSortOptions(context, restaurants, false);
              },
            ),
          ],
        ),
        body: const Center(
          child: Text('Nije pronadjen nijedan restoran u izabranom gradu!'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Kafica'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showSortOptions(context, restaurants, true);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selected = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: (selected == 1) ? Colors.red : Colors.blue,
                ),
                child: const Text("Svi oglasi"),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  //await LocationService().checkAndRequestLocationPermission();
                  setState(() {
                    selected = 2;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: (selected != 1) ? Colors.red : Colors.blue,
                ),
                child: const Text("Omiljeni oglasi"),
              ),
            ],
          ),
          (selected == 1)
              ? AllRestaurantsMethod(restaurants)
              : FavouriteRestaurantsMethod(restaurants),
        ],
      ),
    );
  }

  void _showSortOptions(
      BuildContext context, List<Restaurant> restaurants, bool action) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: (action) ? 200 : 100, // Visina Bottom Sheeta
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: RestaurantDatabaseService().getSelectedCity(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Column(
                        children: [
                          Text(
                            snapshot.data != null
                                ? snapshot.data.toString()
                                : "Doslo je do greske",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/chooseCity');
                            },
                            child: const Text('Izaberi drugi grad'),
                          )
                        ],
                      );
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              ),
              (action) ? RestaurantFilter(restaurants) : Container(),
            ],
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget RestaurantFilter(List<Restaurant> restaurants) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text('Sortiraj prema'),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  restaurantDatabaseService.sortRestaurants(
                    restaurantDatabaseService.proximitySort,
                    restaurants,
                    false, // od najblize ka najdalje
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Blizini'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  restaurantDatabaseService.sortRestaurants(
                    restaurantDatabaseService.rateSort,
                    restaurants,
                    true, // od najvise ka najnizoj
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Oceni'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  restaurantDatabaseService.sortRestaurants(
                    restaurantDatabaseService.crowdSort,
                    restaurants,
                    false, // od najmanje na najvecoj
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guzvi'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  restaurantDatabaseService.sortRestaurants(
                    restaurantDatabaseService.visitsSort,
                    restaurants,
                    true, // od najvise do najmanje
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Posecenosti'),
            ),
          ],
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget AllRestaurantsMethod(List<Restaurant> restaurants) {
    return RestaurantsView(restaurants);
  }

  // ignore: non_constant_identifier_names
  Widget FavouriteRestaurantsMethod(List<Restaurant> restaurants2) {
    List<Restaurant> restaurants = [];
    for (var element in restaurants2) {
      if (element.isFavourite) restaurants.add(element);
    }
    return RestaurantsView(restaurants);
  }

  // ignore: non_constant_identifier_names
  Expanded RestaurantsView(List<Restaurant> restaurants) {
    return Expanded(
      child: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];

          return Column(
            children: [
              if (restaurant.imageURL.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: restaurant.imageURL,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              else
                const Text('Slika nije ucitana'),
              Text(restaurant.name),
              Text(restaurant.location),
              Text(restaurant.description),
              Text(
                '${restaurant.workTime[0].toDate().hour}:${restaurant.workTime[0].toDate().minute} - ${restaurant.workTime[1].toDate().hour}:${restaurant.workTime[1].toDate().minute}',
              ),
              Text(restaurant.opened ? 'Otvoreno' : 'Zatvoreno'),
              Text(restaurant.averageRate.toString()),
              Text("${double.parse(restaurant.distance.toStringAsFixed(1))}m"),
              Text(
                (restaurant.crowd <= 3)
                    ? 'Nema Guzve'
                    : (restaurant.crowd <= 7)
                        ? 'Umerena Guzva'
                        : 'Velika Guzva',
              ),
              ElevatedButton(
                onPressed: () async {
                  if (authService.currentUser!.uid.isNotEmpty) {
                    if (restaurant.isFavourite) {
                      await dbService
                          .removeRestaurantFromFavourite(restaurant.uid);
                    } else {
                      await dbService.addRestourantToFavourite(restaurant.uid);
                    }
                    setState(() {
                      restaurant.isFavourite = !restaurant.isFavourite;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Morate biti prijavljeni da bi dodali restoran u omiljene'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (restaurant.isFavourite) ? Colors.red : Colors.blue,
                ),
                child: Text(restaurant.isFavourite
                    ? 'Ukloni iz omiljeno'
                    : 'Dodaj u omiljeno'),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
