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
          return FutureBuilder(
            future: RestaurantStorageService()
                .downloadMainImage(restaurants[index].uid),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    children: [
                      snapshot.data ?? const Text('Slika nije ucitana'),
                      Text(restaurants[index].name),
                      Text(restaurants[index].location),
                      Text(restaurants[index].description),
                      Text(
                        '${restaurants[index].workTime[0].toDate().hour.toString()}:${restaurants[index].workTime[0].toDate().minute.toString()} - ${restaurants[index].workTime[1].toDate().hour.toString()}:${restaurants[index].workTime[1].toDate().minute.toString()}',
                      ),
                      restaurants[index].opened
                          ? const Text('Otvoreno')
                          : const Text('Zatvoreno'),
                      Text(restaurants[index].averageRate.toString()),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  );
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return const Text('Waithing');
              }
            },
          );
        },
      ),
    );
  }
}
