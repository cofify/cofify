import 'package:flutter/material.dart';

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
