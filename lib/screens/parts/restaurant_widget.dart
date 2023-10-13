import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofify/models/restaurants.dart';
import 'package:cofify/services/auth_service.dart';
import 'package:cofify/services/location_service.dart';
import 'package:cofify/services/restaurants_database_service.dart';
import 'package:cofify/services/user_database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../providers/page_track_provider.dart';
import 'common/common_widget_imports.dart';
import 'restaurantList/loading_restaurants_view.dart';
import 'restaurantList/pill_buttons.dart';
import 'restaurantList/restaurants_view.dart';

class RestaurantsList extends StatefulWidget {
  const RestaurantsList({super.key});

  @override
  State<RestaurantsList> createState() => _RestaurantsListState();
}

class _RestaurantsListState extends State<RestaurantsList> {
  final GlobalKey<PillButtonsFrontClippedTextState> pillKey =
      GlobalKey<PillButtonsFrontClippedTextState>();

  final authService = AuthService.firebase();
  // ignore: prefer_typing_uninitialized_variables
  var dbService;
  var selected = 1;
  var restaurantDatabaseService = RestaurantDatabaseService();

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerFavourite = ScrollController();

  List<Restaurant> restaurants = [];
  List<Restaurant> favouriteRestaurants = [];
  List<Restaurant> oldRestaurants = [];
  List<String> favRes = [];

  bool isLoading = false;
  bool isFinished = false;

  bool isLoadingFavourite = false;
  bool isFinishedFavourite = false;

  int sortAction = 0;
  bool needRestartFavourite = false;

  DocumentSnapshot? documentSnapshot;
  DocumentSnapshot? documentSnapshotFavourite;

  List<String> productFilters = [];

  String? searchText;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollControllerFavourite.addListener(_onScrollFavourite);
    isLoading = false;
    isFinished = false;
    isLoadingFavourite = false;
    isFinishedFavourite = false;
    sortAction = 0;
    restaurants = [];
    favouriteRestaurants = [];
    documentSnapshot = null;
    documentSnapshotFavourite = null;
    searchText = null;
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      restaurants = [];
    });

    if (restaurants.isNotEmpty) {
      documentSnapshot = await RestaurantDatabaseService()
          .getDocumentSnapshot(restaurants.last.uid);
    } else {
      documentSnapshot = null;
    }

    //await RestaurantDatabaseService().getRestaurants(-1, false, null, 0);
    final newRestaurants = await RestaurantDatabaseService().getRestaurants(
      sortAction,
      (selected == 1) ? false : true,
      documentSnapshot,
      3,
    );

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
        !isFinished) {
      setState(() {
        isLoading = true;
        needRestartFavourite = true;
      });

      documentSnapshot = await RestaurantDatabaseService()
          .getDocumentSnapshot(restaurants.last.uid);

      final newRestaurants = await RestaurantDatabaseService().getRestaurants(
        sortAction,
        (selected == 1) ? false : true,
        documentSnapshot,
        3,
      );
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
    }
  }

  Future<void> _onScrollFavourite() async {
    if (!isLoadingFavourite &&
        _scrollControllerFavourite.position.pixels >=
            _scrollControllerFavourite.position.maxScrollExtent -
                _scrollControllerFavourite.position.maxScrollExtent * 0.5 &&
        _scrollControllerFavourite.position.pixels <=
            _scrollControllerFavourite.position.maxScrollExtent + 10 &&
        !isFinishedFavourite) {
      setState(() {
        isLoadingFavourite = true;
      });
      if (favRes.isEmpty || needRestartFavourite) {
        favRes = await dbService.getFavouriteRestourants();
      }

      documentSnapshotFavourite = await RestaurantDatabaseService()
          .getDocumentSnapshot(favouriteRestaurants.last.uid);

      if (restaurants.length > favouriteRestaurants.length) {
        List<Restaurant> newRestaurants = restaurants
            .where((restaurant) {
              return favRes.contains(restaurant.uid);
            })
            .skipWhile(
                (restaurant) => restaurant.uid != documentSnapshotFavourite!.id)
            .skip(1)
            .take(3)
            .toList();

        if (newRestaurants.isNotEmpty) {
          favouriteRestaurants.addAll(newRestaurants);
          setState(() {
            isLoadingFavourite = false;
            isFinishedFavourite = false;
          });
        } else {
          setState(() {
            isLoadingFavourite = false;
            isFinishedFavourite = true;
          });
        }
      } else {
        final newRest = await RestaurantDatabaseService().getRestaurants(
          sortAction,
          true,
          documentSnapshotFavourite,
          3,
        );
        if (newRest.isNotEmpty) {
          favouriteRestaurants.addAll(newRest);
          setState(() {
            isLoadingFavourite = false;
            isFinishedFavourite = false;
          });
        } else {
          setState(() {
            isLoadingFavourite = false;
            isFinishedFavourite = true;
          });
        }
      }
    }
  }

  // Future<void> searchRestaurants(String text) async {
  //   if (oldRestaurants.isEmpty) {
  //     setState(() {
  //       (selected == 1)
  //           ? oldRestaurants.addAll(restaurants)
  //           : oldRestaurants.addAll(favouriteRestaurants);
  //     });
  //   }
  //   if (text.length > 2) {
  //     final newRestaurants =
  //         await RestaurantDatabaseService().getRestaurantsSearch(
  //       text,
  //       (selected == 1) ? false : true,
  //     );
  //     log(newRestaurants.toString());
  //     setState(() {
  //       (selected == 1) ? restaurants.clear() : favouriteRestaurants.clear();
  //       (selected == 1)
  //           ? restaurants.addAll(newRestaurants)
  //           : favouriteRestaurants.addAll(newRestaurants);
  //       (selected == 1) ? isFinished = true : isFinishedFavourite = true;
  //     });
  //   }
  //   if (text.isEmpty) {
  //     setState(() {
  //       searchText = null;
  //       (selected == 1) ? restaurants.clear() : favouriteRestaurants.clear();
  //       (selected == 1) ? isLoading = false : isLoadingFavourite = false;
  //       (selected == 1) ? isFinished = false : isFinishedFavourite = false;
  //       sortAction = 0;
  //       sortAction = 0;
  //       (selected == 1)
  //           ? documentSnapshot = null
  //           : documentSnapshotFavourite = null;
  //     });
  //     if (oldRestaurants.isEmpty) {
  //       (selected == 1) ? await _loadData() : await addDataToFavourite();
  //     } else {
  //       setState(() {
  //         (selected == 1)
  //             ? restaurants.addAll(oldRestaurants)
  //             : favouriteRestaurants.addAll(oldRestaurants);
  //       });
  //     }
  //   }
  // }

  Future<void> addDataToFavourite() async {
    if (sortAction == 0) {
      if (favouriteRestaurants.isEmpty || needRestartFavourite) {
        favouriteRestaurants = List.empty();
        if (favRes.isEmpty || needRestartFavourite) {
          favRes = await dbService.getFavouriteRestourants();
        }
        favouriteRestaurants = restaurants
            .where((restaurant) {
              return favRes.contains(restaurant.uid);
            })
            .take(3)
            .toList();
        needRestartFavourite = false;
        if (favouriteRestaurants.isNotEmpty) {
          documentSnapshotFavourite = await RestaurantDatabaseService()
              .getDocumentSnapshot(favouriteRestaurants.last.uid);
        } else {
          documentSnapshotFavourite = null;
        }
        if (favouriteRestaurants.length < 3) {
          final newRest = await RestaurantDatabaseService().getRestaurants(
            sortAction,
            true,
            documentSnapshotFavourite,
            3 - favouriteRestaurants.length,
          );
          if (newRest.isNotEmpty) {
            favouriteRestaurants.addAll(newRest);
            setState(() {
              isLoadingFavourite = false;
              isFinishedFavourite = false;
            });
          } else {
            setState(() {
              isLoadingFavourite = false;
              isFinishedFavourite = true;
            });
          }
        }
      }
    } else {
      if (needRestartFavourite) {
        favouriteRestaurants = [];
        if (favRes.isEmpty || needRestartFavourite) {
          favRes = await dbService.getFavouriteRestourants();
        }
        if (favouriteRestaurants.isNotEmpty) {
          documentSnapshotFavourite = await RestaurantDatabaseService()
              .getDocumentSnapshot(favouriteRestaurants.last.uid);
        } else {
          documentSnapshotFavourite = null;
        }
        final newRest = await RestaurantDatabaseService().getRestaurants(
          sortAction,
          true,
          documentSnapshotFavourite,
          3,
        );
        if (newRest.isNotEmpty) {
          favouriteRestaurants.addAll(newRest);
          setState(() {
            isLoadingFavourite = false;
            isFinishedFavourite = false;
          });
        } else {
          setState(() {
            isLoadingFavourite = false;
            isFinishedFavourite = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    restaurants = Provider.of<List<Restaurant>>(context);
    final pageController = Provider.of<PillButtonPageTracker>(context);

    dbService = DatabaseService(uid: authService.currentUser!.uid);

    if (restaurants.length == 1 && restaurants[0].uid.isEmpty) {
      print("First");
      return Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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

      // u trenutku ucitavanja
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
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person),
            ),
          ],
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Ukoliko nije pronadjen nijedan restoran
    else if (restaurants.isEmpty && !isLoading) {
      print("Second");

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
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Pretrazi restorane',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) async {
                  //await searchRestaurants(text);
                },
              ),
            ),
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
                    await LocationService().checkAndRequestLocationPermission();
                    setState(() {
                      selected = 2;
                      isFinishedFavourite = false;
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

    print("Third");

    // lista sa restoranima
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
          IconButton(
            onPressed: () async {
              final userData = await authService.getUserData;
              Navigator.of(context)
                  .pushNamed('/userProfile', arguments: userData);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            child: TextFormField(
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                hintText: 'Pretrazi restorane',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) async {
                //await searchRestaurants(text);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    selected = 1;
                    isFinished = false;
                  });
                  //await _loadData();
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
                  await addDataToFavourite();
                  setState(() {
                    selected = 2;
                    isFinishedFavourite = false;
                  });
                  //await _loadData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: (selected != 1) ? Colors.red : Colors.blue,
                ),
                child: const Text("Omiljeni oglasi"),
              ),
            ],
          ),
          (selected == 1)
              ? AllRestaurantsMethod()
              : FavouriteRestaurantsMethod(),
          (isLoading && selected == 1 || isLoadingFavourite && selected != 1)
              ? const CircularProgressIndicator()
              : Container(),
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
          height: (action) ? 500 : 100, // Visina Bottom Sheeta
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
                                isFinishedFavourite = false;
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
                      isFinishedFavourite = false;
                      needRestartFavourite = true;
                    });
                    (selected == 1) ? _loadData() : addDataToFavourite();
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
                      isFinishedFavourite = false;
                      needRestartFavourite = true;
                    });
                    (selected == 1) ? _loadData() : addDataToFavourite();
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
                      isFinishedFavourite = false;
                      needRestartFavourite = true;
                    });
                    (selected == 1) ? _loadData() : addDataToFavourite();
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
                      isFinishedFavourite = false;
                      needRestartFavourite = true;
                    });
                    (selected == 1) ? _loadData() : addDataToFavourite();
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
                      isFinishedFavourite = false;
                      needRestartFavourite = true;
                    });
                    (selected == 1) ? _loadData() : addDataToFavourite();
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
                      isFinishedFavourite = false;
                      needRestartFavourite = true;
                    });
                    (selected == 1) ? _loadData() : addDataToFavourite();
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
                  onPressed: () {
                    setState(() {
                      sortAction = 8;
                      isFinished = false;
                      isFinishedFavourite = false;
                      needRestartFavourite = true;
                    });
                    (selected == 1) ? _loadData() : addDataToFavourite();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Posecenosti(↑)'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (sortAction == 7) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      sortAction = 7;
                      isFinished = false;
                      isFinishedFavourite = false;
                      needRestartFavourite = true;
                    });
                    (selected == 1) ? _loadData() : addDataToFavourite();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Posecenosti(↓)'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text('Tipovi hrane i pica'),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (productFilters.contains('Kafa'))
                        ? Colors.red
                        : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      if (productFilters.contains('Kafa')) {
                        productFilters.remove('Kafa');
                      } else {
                        productFilters.add('Kafa');
                      }
                    });
                  },
                  child: const Text(
                    'Kafa',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Pivo',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Sokovi',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Vino',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Ribe',
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget AllRestaurantsMethod() {
    return RestaurantsView(restaurants);
  }

  Widget FavouriteRestaurantsMethod() {
    return RestaurantsView(favouriteRestaurants);
  }

  // ignore: non_constant_identifier_names
  Expanded RestaurantsView(List<Restaurant> restaurants) {
    return Expanded(
      child: ListView.builder(
        itemCount: restaurants.length,
        controller:
            (selected == 1) ? _scrollController : _scrollControllerFavourite,
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
                      needRestartFavourite = true;
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

// TODO OVDE SI STAO pokusavas da rekreiras sve sto je dj imao da radi sa tvoj frontend
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
