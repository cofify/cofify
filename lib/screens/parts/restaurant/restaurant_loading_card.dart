import 'package:flutter/material.dart';

// widgets
import '../common/common_widget_imports.dart';

class RestaurantLoadingCard extends StatelessWidget {
  final double listViewPadding;
  final double imageHeight;

  const RestaurantLoadingCard({
    super.key,
    required this.listViewPadding,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: listViewPadding,
        right: listViewPadding,
      ),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [
        BoxShadowsFactory().boxShadowSoft(),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 200,
              color: Colors.white,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerItem(),
                    ShimmerItem(width: 22),
                  ],
                ),

                SizedBox(height: 4),

                // Location
                ShimmerItem(width: 130),

                SizedBox(height: 4),

                // Description
                ShimmerItem(height: 66, expand: true),

                SizedBox(height: 12),

                // Bottom row with info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerItem(width: 70),
                    ShimmerItem(width: 70),
                    ShimmerItem(width: 70),
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
