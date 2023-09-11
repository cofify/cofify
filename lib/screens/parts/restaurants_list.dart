import 'package:cofify/models/restaurants.dart';
import 'package:cofify/services/restaurants_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantsList extends StatefulWidget {
  const RestaurantsList({super.key});

  @override
  State<RestaurantsList> createState() => _RestaurantsListState();
}

class _RestaurantsListState extends State<RestaurantsList> {
  @override
  Widget build(BuildContext context) {
    final restaurants = Provider.of<List<Restaurant>>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Kafica'),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              FutureBuilder(
                future: RestaurantStorageService()
                    .downloadMainImage(restaurants[index].uid),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return SizedBox(
                        width: 300,
                        height: 300,
                        child:
                            snapshot.data ?? const Text('Slika nije ucitana'),
                      );
                    // return snapshot.data ?? const Text('Slika nije ucitana');
                    default:
                      return const Text('Waithing');
                  }
                },
              ),
              Text(restaurants[index].name),
              Text(restaurants[index].description),
              Text(restaurants[index].workTime[0]),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.black,
              )
            ],
          );
        },
      ),
    );
  }
}
