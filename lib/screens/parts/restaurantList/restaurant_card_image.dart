import 'package:flutter/material.dart';

class RestaurantCardImage extends StatelessWidget {
  final ImageProvider<Object> image;
  final double imageHeight;
  final bool opened;

  const RestaurantCardImage({
    super.key,
    required this.image,
    required this.imageHeight,
    this.opened = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double columnWidth = constraints.maxWidth;

          if (opened) {
            return Image(
              image: image,
              width: columnWidth,
              height: imageHeight,
              fit: BoxFit.fill,
            );
          }

          return ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.saturation,
            ),
            child: Image(
              image: image,
              width: columnWidth,
              height: imageHeight,
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}
