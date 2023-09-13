import 'package:cofify/models/restaurants.dart';
import 'package:cofify/screens/parts/box_shadows.dart';
import 'package:cofify/screens/parts/common_app_bar.dart';
import 'package:cofify/screens/parts/search_box.dart';
import 'package:cofify/screens/parts/svg_icon.dart';
import 'package:cofify/services/restaurants_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class RestaurantsList extends StatelessWidget {
  const RestaurantsList({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurants = Provider.of<List<Restaurant>>(context);

    final double listViewPadding = MediaQuery.of(context).size.width * 0.05;
    const double imageHeight = 200;

    print("Rebuilded Restaurants");

    return Scaffold(
      appBar: const CommonAppBar(text: "Lista Kafica"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            const SearchBox(),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: RestaurantStorageService()
                        .downloadMainImage(restaurants[index].uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return RestaurantCard(
                          snapshot: snapshot,
                          listViewPadding: listViewPadding,
                          imageHeight: imageHeight,
                          restaurant: restaurants[index],
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error ${snapshot.error}");
                      } else if (!snapshot.hasData) {
                        return const Text('No image data');
                      } else {
                        return const Text('Waiting');
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final double listViewPadding;
  final double imageHeight;
  final Restaurant restaurant;

  const RestaurantCard({
    super.key,
    required this.snapshot,
    required this.listViewPadding,
    required this.imageHeight,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          RestaurantCardImage(
            image: snapshot.data?.image ??
                const AssetImage("assets/images/DobrodosliUCofify.jpg"),
            imageHeight: imageHeight,
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              children: [
                // Heading
                IconAndText(
                  text: restaurant.name,
                  icon: "assets/icons/HeartEmpty.svg",
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  iconFirst: false,
                ),

                const SizedBox(height: 4),
                // Location
                IconAndText(
                  text: restaurant.location,
                  fontSize: 18.0,
                  icon: "assets/icons/Location.svg",
                  iconSize: 18.0,
                ),

                const SizedBox(height: 4),

                // Description
                Text(
                  restaurant.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFADA4A6),
                  ),
                ),

                const SizedBox(height: 12),

                // Bottom row with info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Distance
                    IconAndText(
                      text: (restaurant.workTime.isEmpty)
                          ? "Nepoznato"
                          : '${restaurant.workTime[0].toDate().hour.toString()}:${restaurant.workTime[0].toDate().minute.toString()} - ${restaurant.workTime[1].toDate().hour.toString()}:${restaurant.workTime[1].toDate().minute.toString()}',
                      icon: "assets/icons/ManWalking.svg",
                      fontSize: 16,
                      iconSize: 16,
                    ),

                    // Open
                    IconAndText(
                      text: (restaurant.workTime.isEmpty == false)
                          ? restaurant.opened
                              ? DateFormat('HH:mm').format(
                                  restaurant.workTime[1].toDate(),
                                )
                              : DateFormat('HH:mm').format(
                                  restaurant.workTime[0].toDate(),
                                )
                          : "Nepoznato",
                      icon: restaurant.opened
                          ? "assets/icons/ActiveDot.svg"
                          : "assets/icons/NotActiveDot.svg",
                      iconSize: 7,
                      fontSize: 16,
                    ),

                    // Rating
                    IconAndText(
                      text: restaurant.averageRate.toString(),
                      icon: 'assets/icons/Star.svg',
                      fontSize: 16,
                      iconSize: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantCardImage extends StatelessWidget {
  final ImageProvider<Object> image;
  final double imageHeight;

  const RestaurantCardImage({
    super.key,
    required this.image,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double columnWidth = constraints.maxWidth;

          return Image(
            image: image,
            width: columnWidth,
            height: imageHeight,
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }
}

class IconAndText extends StatelessWidget {
  final dynamic icon;
  final double iconSize;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final TextBaseline? textBaseline;
  final bool iconFirst;

  const IconAndText({
    super.key,
    required this.text,
    this.fontSize = 18.0,
    this.fontWeight = FontWeight.normal,
    this.icon,
    this.iconSize = 18.0,
    this.spacing = 8.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.textBaseline,
    this.iconFirst = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      textBaseline: textBaseline,
      children: (iconFirst)
          ? [
              SvgIcon(
                icon: icon,
                size: iconSize,
              ),
              SizedBox(width: spacing),
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
            ]
          : [
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
              SizedBox(width: spacing),
              SvgIcon(
                icon: icon,
                size: iconSize,
              ),
            ],
    );
  }
}
