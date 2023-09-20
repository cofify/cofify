import 'package:cofify/screens/parts/common/restaurant_card_bottom_row_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// widgets
import '../util/helper_functions.dart';
import 'parts/common/common_widget_imports.dart';

// models
import '../models/restaurants.dart';
import '../models/restaurant_route_data.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final heroContainerMargin = screenWidth * 0.1;

    final Restaurant routeData =
        ModalRoute.of(context)?.settings.arguments as Restaurant;

    ImageProvider<Object> image = NetworkImage(routeData.imageURL);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                // image
                RestaurantImage(
                  image: image,
                  screenWidth: screenWidth,
                  opened: routeData.opened,
                ),

                // Restaurant info
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Hero(
                    tag: "restaurantlist-restaurant-hero${routeData.uid}",
                    child: Container(
                      width: screenWidth - 40,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadowsFactory().boxShadowSoft()],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Name
                          IconAndText(
                            text: routeData.name,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            icon: routeData.isFavourite
                                ? "assets/icons/HeartFull.svg"
                                : "assets/icons/HeartEmpty.svg",
                            iconFirst: false,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            iconAction: () {},
                          ),

                          const SizedBox(height: 8),

                          // Description
                          Text(
                            routeData.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFADA4A6),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Location
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  IconAndText(
                                    text: routeData.location,
                                    fontSize: 18.0,
                                    icon: "assets/icons/Location.svg",
                                    iconSize: 18.0,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    iconAction: () {},
                                  ),
                                  const SizedBox(height: 2),
                                  SmallButton(
                                    onPress: () {},
                                    buttonText: "Pronadji na mapi",
                                  ),

                                  const SizedBox(height: 16),

                                  // Bottom row with info
                                  RestaurantCardBottomRowInfo(
                                      restaurant: routeData),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RestaurantImage extends StatelessWidget {
  final ImageProvider<Object> image;
  final double screenWidth;
  final bool opened;

  const RestaurantImage({
    super.key,
    required this.image,
    required this.screenWidth,
    this.opened = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ImageClipper(),
      child: (opened)
          ? Image(
              image: image,
              height: 250,
              width: screenWidth,
              fit: BoxFit.fill,
            )
          : ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              child: Image(
                image: image,
                height: 250,
                width: screenWidth,
                fit: BoxFit.fill,
              ),
            ),
    );
  }
}

class ImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // 1. (0, 0)
    path.lineTo(0, size.height); // 2.
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      size.width,
      size.height,
    ); // circle to 4.

    path.lineTo(size.width, 0); // 5.
    path.close(); // close to 1.

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
