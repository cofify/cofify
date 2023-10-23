import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// widgets
import 'package:cofify/screens/parts/common/common_widget_imports.dart';

// models
import 'package:cofify/models/restaurants.dart';

// other
import 'package:cofify/util/helper_functions.dart';

class RestaurantCardBottomRowInfo extends StatelessWidget {
  const RestaurantCardBottomRowInfo({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Distance
        IconAndText(
          text: HelperFunctionsFactory().formatDuration(restaurant.distance),
          icon: "assets/icons/ManWalking.svg",
          fontSize: 16,
          iconSize: 16,
          spacing: 4,
          iconAction: () {},
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
          spacing: 4,
          iconAction: () {},
        ),

        // Rating
        IconAndText(
          text: restaurant.averageRate.toString(),
          icon: 'assets/icons/Star.svg',
          fontSize: 16,
          iconSize: 16,
          spacing: 4,
          iconAction: () {},
        ),
      ],
    );
  }
}
