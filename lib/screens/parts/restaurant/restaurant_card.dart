import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// widgets
import '../../../services/auth_service.dart';
import '../common/common_widget_imports.dart';
import 'restaurant_card_image.dart';

// models
import '../../../models/restaurants.dart';

// services
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

    return Container(
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
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          RestaurantCardImage(
            image: image,
            imageHeight: widget.imageHeight,
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
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
                        await dbService
                            .addRestourantToFavourite(widget.restaurant.uid);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Distance
                    IconAndText(
                      text: (widget.restaurant.workTime.isEmpty)
                          ? "Nepoznato"
                          : '${widget.restaurant.workTime[0].toDate().hour.toString()}:${widget.restaurant.workTime[0].toDate().minute.toString()} - ${widget.restaurant.workTime[1].toDate().hour.toString()}:${widget.restaurant.workTime[1].toDate().minute.toString()}',
                      icon: "assets/icons/ManWalking.svg",
                      fontSize: 16,
                      iconSize: 16,
                      iconAction: () {},
                    ),

                    // Open
                    IconAndText(
                      text: (widget.restaurant.workTime.isEmpty == false)
                          ? widget.restaurant.opened
                              ? DateFormat('HH:mm').format(
                                  widget.restaurant.workTime[1].toDate(),
                                )
                              : DateFormat('HH:mm').format(
                                  widget.restaurant.workTime[0].toDate(),
                                )
                          : "Nepoznato",
                      icon: widget.restaurant.opened
                          ? "assets/icons/ActiveDot.svg"
                          : "assets/icons/NotActiveDot.svg",
                      iconSize: 7,
                      fontSize: 16,
                      iconAction: () {},
                    ),

                    // Rating
                    IconAndText(
                      text: widget.restaurant.averageRate.toString(),
                      icon: 'assets/icons/Star.svg',
                      fontSize: 16,
                      iconSize: 16,
                      iconAction: () {},
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
