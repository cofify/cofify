import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cofify/models/restaurant_route_data.dart';
import 'package:cofify/util/helper_functions.dart';

// widgets
import '../common/restaurant_card_bottom_row_info.dart';
import '../common/common_widget_imports.dart';
import 'restaurant_card_image.dart';

// models
import '../../../models/restaurants.dart';

// services
import '../../../services/auth_service.dart';
import '../../../services/user_database_service.dart';

class RestaurantCard extends StatefulWidget {
  // final AsyncSnapshot snapshot;
  final Restaurant restaurant;
  final double listViewPadding;
  final double imageHeight;

  const RestaurantCard({
    super.key,
    // required this.snapshot,
    required this.restaurant,
    required this.listViewPadding,
    required this.imageHeight,
  });

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> image = NetworkImage(widget.restaurant.imageURL);
    final authService = AuthService.firebase();

    var dbService = DatabaseService(uid: authService.currentUser!.uid);

    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(
        //   '/restaurant',
        //   arguments: RestaurantRouteData(
        //     uid: widget.restaurant.uid,
        //     image: image,
        //   ),
        // );
        Navigator.of(context).pushNamed(
          '/restaurant',
          arguments: widget.restaurant,
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
          left: widget.listViewPadding,
          right: widget.listViewPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadowsFactory().boxShadowSoft(),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            RestaurantCardImage(
              image: image,
              imageHeight: widget.imageHeight,
              opened: widget.restaurant.opened,
            ),

            Hero(
              tag: "restaurantlist-restaurant-hero${widget.restaurant.uid}",
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      // Heading
                      IconAndText(
                        text: widget.restaurant.name,
                        icon: widget.restaurant.isFavourite
                            ? "assets/icons/HeartFull.svg"
                            : "assets/icons/HeartEmpty.svg",
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        iconFirst: false,
                        iconAction: () async {
                          if (authService.currentUser!.uid.isNotEmpty) {
                            if (widget.restaurant.isFavourite) {
                              await dbService.removeRestaurantFromFavourite(
                                  widget.restaurant.uid);
                            } else {
                              await dbService.addRestourantToFavourite(
                                  widget.restaurant.uid);
                            }
                            setState(() {
                              widget.restaurant.isFavourite =
                                  !widget.restaurant.isFavourite;
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
                      ),

                      const SizedBox(height: 4),

                      // Location
                      IconAndText(
                        text: widget.restaurant.location,
                        fontSize: 18.0,
                        icon: "assets/icons/Location.svg",
                        iconSize: 18.0,
                        iconAction: () {},
                      ),

                      const SizedBox(height: 4),

                      // Description
                      Text(
                        widget.restaurant.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFADA4A6),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Bottom row with info
                      RestaurantCardBottomRowInfo(
                          restaurant: widget.restaurant),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
