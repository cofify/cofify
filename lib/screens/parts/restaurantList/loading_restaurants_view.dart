import 'package:cofify/screens/parts/common/common_widget_imports.dart';
import 'package:cofify/screens/parts/restaurantList/restaurant_loading_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingRestaurantsView extends StatelessWidget {
  const LoadingRestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final double listViewPadding = MediaQuery.of(context).size.width * 0.05;
    const double imageHeight = 200;

    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(top: (index == 0) ? 20.0 : 0),
          child: Container(
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
              ],
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[100]!,
              highlightColor: Colors.grey[300]!,
              child: RestaurantLoadingCard(
                imageHeight: imageHeight,
                listViewPadding: listViewPadding,
              ),
            ),
          ),
        );
      },
    );
  }
}
