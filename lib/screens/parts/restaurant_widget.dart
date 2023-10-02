import 'package:cloud_firestore/cloud_firestore.dart';
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
  final ScrollController _scrollControllerFavourite = ScrollController();

  List<Restaurant> restaurants = [];
  List<Restaurant> favouriteRestaurants = [];
  List<Restaurant> oldRestaurants = [];
  List<String> favRes = [];

  int sel = 0;

  bool isLoading = false;
  bool isFinished = false;

  bool isLoadingFavourite = false;
  bool isFinishedFavourite = false;

  int sortAction = 0;
  bool needRestartFavourite = false;
  bool needRestartMain = false;

  DocumentSnapshot? documentSnapshot;
  DocumentSnapshot? documentSnapshotFavourite;

  String? searchText;

  List<String> productsFilter = [];

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

  void setProductsFilter(String newValue) {
    setState(() {
      if (productsFilter.contains(newValue)) {
        productsFilter.remove(newValue);
      } else {
        productsFilter.add(newValue);
      }
      if (selected == 2) {
        needRestartMain = true;
      }
    });
  }

  Color checkProductsFilterColor(String product) {
    return productsFilter.contains(product) ? Colors.red : Colors.blue;
  }

  void setSortOption(int newValue) {
    setState(() {
      sortAction = newValue;
    });
  }

  void setIsFinished(bool newValue) {
    setState(() {
      isFinished = newValue;
    });
  }

  void setIsFinishedFavourite(bool newValue) {
    setState(() {
      isFinishedFavourite = newValue;
    });
  }

  void setNeedRestartFavourite(bool newValue) {
    setState(() {
      isFinishedFavourite = newValue;
    });
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      restaurants.clear();
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
      productsFilter,
    );

    if (newRestaurants.isNotEmpty) {
      setState(() {
        restaurants.clear();
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
        productsFilter,
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
          productsFilter,
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
    if (sortAction == 0 && productsFilter.isEmpty) {
      if (favouriteRestaurants.isEmpty || needRestartFavourite) {
        setState(() {
          favouriteRestaurants.clear();
        });
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
            productsFilter,
          );
          if (newRest.isNotEmpty) {
            setState(() {
              favouriteRestaurants.addAll(newRest);
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
        setState(() {
          favouriteRestaurants.clear();
        });
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
          productsFilter,
        );
        if (newRest.isNotEmpty) {
          setState(() {
            favouriteRestaurants.addAll(newRest);
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
            allOrFavourite(),
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
          IconButton(
            onPressed: () async {
              final userData = await authService.getUserData;
              // ignore: use_build_context_synchronously
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
          allOrFavourite(),
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

  Row allOrFavourite() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            setState(() {
              selected = 1;
              isFinished = false;
            });
            if (needRestartMain) {
              await _loadData();
              setState(() {
                needRestartMain = false;
              });
            }
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
            await addDataToFavourite();
            setState(() {
              selected = 2;
              isFinishedFavourite = false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: (selected != 1) ? Colors.red : Colors.blue,
          ),
          child: const Text("Omiljeni oglasi"),
        ),
      ],
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
              (action)
                  ? RestaurantFilter(
                      sortAction: sortAction,
                      isFinished: isFinished,
                      isFinishedFavourite: isFinished,
                      needRestartFavourite: needRestartFavourite,
                      loadData: _loadData,
                      addDataToFavourite: addDataToFavourite,
                      setSortAction: setSortOption,
                      setIsFinished: setIsFinished,
                      setIsFinishedFavourite: setIsFinishedFavourite,
                      setNeedRestartFavourite: setNeedRestartFavourite,
                    )
                  : Container(),
              AdditionalFilters(
                productsFilter: productsFilter,
                setProductsFilter: setProductsFilter,
                checkProductsFilterColor: checkProductsFilterColor,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    print(productsFilter);
                    setState(() {
                      restaurants = [];
                      favouriteRestaurants = [];
                      isFinished = false;
                      isFinishedFavourite = false;
                      needRestartFavourite = true;
                    });
                    (selected == 1)
                        ? await _loadData()
                        : await addDataToFavourite();
                    // ignore: use_build_context_synchronously
                    try {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Vec podignuto!');
                    }
                  },
                  child: const Text('Primeni'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget AllRestaurantsMethod() {
    return RestaurantsView(restaurants);
  }

  // ignore: non_constant_identifier_names
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

// ignore: must_be_immutable
class AdditionalFilters extends StatefulWidget {
  List<String> productsFilter;
  final Function(String) setProductsFilter;
  final Function(String) checkProductsFilterColor;
  AdditionalFilters({
    super.key,
    required this.productsFilter,
    required this.setProductsFilter,
    required this.checkProductsFilterColor,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AdditionalFiltersState createState() => _AdditionalFiltersState();
}

class _AdditionalFiltersState extends State<AdditionalFilters> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
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
                    backgroundColor: widget.checkProductsFilterColor('coffee'),
                  ),
                  onPressed: () async {
                    widget.setProductsFilter('coffee');
                    setState(() {});
                    //await _RestaurantsListState()._loadData();
                  },
                  child: const Text(
                    'Kafa',
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.checkProductsFilterColor('beer'),
                  ),
                  onPressed: () {
                    widget.setProductsFilter('beer');
                    setState(() {});
                  },
                  child: const Text(
                    'Pivo',
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.checkProductsFilterColor('juice'),
                  ),
                  onPressed: () {
                    widget.setProductsFilter('juice');
                    setState(() {});
                  },
                  child: const Text(
                    'Sokovi',
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.checkProductsFilterColor('wine'),
                  ),
                  onPressed: () {
                    widget.setProductsFilter('wine');
                    setState(() {});
                  },
                  child: const Text(
                    'Vino',
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.checkProductsFilterColor('fish'),
                  ),
                  onPressed: () {
                    widget.setProductsFilter('fish');
                    setState(() {});
                  },
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
}

// ignore: must_be_immutable
class RestaurantFilter extends StatefulWidget {
  int sortAction;
  bool isFinished;
  bool isFinishedFavourite;
  bool needRestartFavourite;
  final Function() loadData;
  final Function() addDataToFavourite;
  final Function(int) setSortAction;
  final Function(bool) setIsFinished;
  final Function(bool) setIsFinishedFavourite;
  final Function(bool) setNeedRestartFavourite;

  RestaurantFilter({
    super.key,
    required this.sortAction,
    required this.isFinished,
    required this.isFinishedFavourite,
    required this.needRestartFavourite,
    required this.loadData,
    required this.addDataToFavourite,
    required this.setSortAction,
    required this.setIsFinished,
    required this.setIsFinishedFavourite,
    required this.setNeedRestartFavourite,
  });

  @override
  State<RestaurantFilter> createState() => _RestaurantFilterState();
}

class _RestaurantFilterState extends State<RestaurantFilter> {
  void changeFunctionsValue() {
    widget.setSortAction(widget.sortAction);
    widget.setIsFinished(widget.isFinished);
    widget.setIsFinishedFavourite(widget.isFinishedFavourite);
    widget.setNeedRestartFavourite(widget.needRestartFavourite);
  }

  @override
  Widget build(BuildContext context) {
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
                        (widget.sortAction == 1) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () async {
                    setState(() {
                      widget.sortAction = 1;
                      widget.isFinished = false;
                      widget.isFinishedFavourite = false;
                      widget.needRestartFavourite = true;
                    });
                    changeFunctionsValue();
                  },
                  child: const Text('Blizini(↑)'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (widget.sortAction == 2) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () async {
                    setState(() {
                      widget.sortAction = 2;
                      widget.isFinished = false;
                      widget.isFinishedFavourite = false;
                      widget.needRestartFavourite = true;
                    });
                    changeFunctionsValue();
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
                        (widget.sortAction == 3) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () async {
                    setState(() {
                      widget.sortAction = 3;
                      widget.isFinished = false;
                      widget.isFinishedFavourite = false;
                      widget.needRestartFavourite = true;
                    });
                    changeFunctionsValue();
                  },
                  child: const Text('Oceni(↑)'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (widget.sortAction == 4) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () async {
                    setState(() {
                      widget.sortAction = 4;
                      widget.isFinished = false;
                      widget.isFinishedFavourite = false;
                      widget.needRestartFavourite = true;
                    });
                    changeFunctionsValue();
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
                        (widget.sortAction == 5) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () async {
                    setState(() {
                      widget.sortAction = 5;
                      widget.isFinished = false;
                      widget.isFinishedFavourite = false;
                      widget.needRestartFavourite = true;
                    });
                    changeFunctionsValue();
                  },
                  child: const Text('Guzvi(↑)'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (widget.sortAction == 6) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () async {
                    setState(() {
                      widget.sortAction = 6;
                      widget.isFinished = false;
                      widget.isFinishedFavourite = false;
                      widget.needRestartFavourite = true;
                    });
                    changeFunctionsValue();
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
                        (widget.sortAction == 8) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () async {
                    setState(() {
                      widget.sortAction = 8;
                      widget.isFinished = false;
                      widget.isFinishedFavourite = false;
                      widget.needRestartFavourite = true;
                    });
                    changeFunctionsValue();
                  },
                  child: const Text('Posecenosti(↑)'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (widget.sortAction == 7) ? Colors.red : Colors.blue,
                  ),
                  onPressed: () async {
                    setState(() {
                      widget.sortAction = 7;
                      widget.isFinished = false;
                      widget.isFinishedFavourite = false;
                      widget.needRestartFavourite = true;
                    });
                    changeFunctionsValue();
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
}
