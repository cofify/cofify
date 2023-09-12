import 'package:cofify/models/restaurants.dart';
import 'package:cofify/services/auth_service.dart';
import 'package:cofify/services/user_database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    dbService = DatabaseService(uid: authService.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = Provider.of<List<Restaurant>>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Kafica'),
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
                onPressed: () {
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

  // ignore: non_constant_identifier_names
  Widget AllRestaurantsMethod(List<Restaurant> restaurants) {
    return (restaurants.isNotEmpty)
        ? RestaurantsView(restaurants)
        : const Text('Nema restorana za prikazivanje');
  }

  // ignore: non_constant_identifier_names
  Widget FavouriteRestaurantsMethod(List<Restaurant> restaurants2) {
    List<Restaurant> restaurants = [];
    for (var element in restaurants2) {
      if (element.isFavourite) restaurants.add(element);
    }
    return (restaurants.isNotEmpty)
        ? RestaurantsView(restaurants)
        : const Text('Nema omiljenih restorana');
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
                Image.network(restaurant.imageURL)
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
