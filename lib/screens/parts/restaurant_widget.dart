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

  final ScrollController _scrollController = ScrollController();

  List<Restaurant> restaurants = List.empty();
  List<Restaurant> favouriteRestaurants = List.empty();

  bool isLoading = false;
  bool isFinished = false;
  int sortAction = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    isLoading = false;
    isFinished = false;
    sortAction = 0;
    restaurants = List.empty();
    favouriteRestaurants = List.empty();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      restaurants.clear();
    });
    await RestaurantDatabaseService().getRestaurants(-1, false);
    final newRestaurants = await RestaurantDatabaseService()
        .getRestaurants(sortAction, (selected == 1) ? false : true);

    if (newRestaurants.isNotEmpty) {
      setState(() {
        restaurants.addAll(newRestaurants);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onScroll() async {
    if (!isLoading &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent -
                _scrollController.position.maxScrollExtent * 0.5 &&
        _scrollController.position.pixels <=
            _scrollController.position.maxScrollExtent &&
        isFinished) {
      setState(() {
        isLoading = true;
      });

      final newRestaurants = await RestaurantDatabaseService()
          .getRestaurants(sortAction, (selected == 1) ? false : true);
      if (newRestaurants.isNotEmpty) {
        restaurants.addAll(newRestaurants);
        setState(() {
          isLoading = false;
          isFinished = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isFinished = true;
        });
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) {
    restaurants = Provider.of<List<Restaurant>>(context);

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
    } else if (restaurants.isEmpty && !isLoading) {
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
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      selected = 1;
                      isFinished = false;
                    });
                    await _loadData();
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
                      isFinished = false;
                    });
                    await _loadData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (selected != 1) ? Colors.red : Colors.blue,
                  ),
                  child: const Text("Omiljeni oglasi"),
                ),
              ],
            ),
            Center(
              child: Text(
                (selected == 1)
                    ? 'Nije pronadjen nijedan restoran u izabranom gradu!'
                    : 'Nema omiljenih oglasa',
              ),
            ),
          ],
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
                onPressed: () async {
                  setState(() {
                    selected = 1;
                    isFinished = false;
                  });
                  await _loadData();
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
                    isFinished = false;
                  });
                  await _loadData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: (selected != 1) ? Colors.red : Colors.blue,
                ),
                child: const Text("Omiljeni oglasi"),
              ),
            ],
          ),
          AllRestaurantsMethod(restaurants),
          (isLoading) ? const CircularProgressIndicator() : Container(),
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
          height: (action) ? 300 : 100, // Visina Bottom Sheeta
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
                              setState(() {
                                sortAction = 0;
                                selected = 1;
                                isFinished = false;
                              });
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
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (sortAction == 1) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      sortAction = 1;
                      isFinished = false;
                    });
                    _loadData();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Blizini(↑)'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (sortAction == 2) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      sortAction = 2;
                      isFinished = false;
                    });
                    _loadData();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Blizini(↓)'),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (sortAction == 3) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      sortAction = 3;
                      isFinished = false;
                    });
                    _loadData();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Oceni(↑)'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (sortAction == 4) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      sortAction = 4;
                      isFinished = false;
                    });
                    _loadData();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Oceni(↓)'),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (sortAction == 5) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      sortAction = 5;
                      isFinished = false;
                    });
                    _loadData();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guzvi(↑)'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (sortAction == 6) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      sortAction = 6;
                      isFinished = false;
                    });
                    _loadData();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guzvi(↓)'),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (sortAction == 8) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () async {
                    setState(() {
                      sortAction = 8;
                      isFinished = false;
                    });
                    _loadData();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Posecenosti(↑)'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (sortAction == 7) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () async {
                    setState(() {
                      sortAction = 7;
                      isFinished = false;
                    });
                    _loadData();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Posecenosti(↓)'),
                ),
              ],
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
  Expanded RestaurantsView(List<Restaurant> restaurants) {
    return Expanded(
      child: ListView.builder(
        itemCount: restaurants.length,
        controller: _scrollController,
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
                    if (selected != 1) {
                      setState(() {
                        restaurants.remove(restaurant);
                      });
                    }
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
