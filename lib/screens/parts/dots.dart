import 'package:flutter/material.dart';

import '../../providers/dots_track_provider.dart';

/// Reusable komponenta, prikazuje tri tacke kao indikator
/// selektovane komponente
class Dots extends StatelessWidget {
  /// Broj tacaka
  final int dotNumber;
  final double dotSize;
  final double dotRadius;
  final double dotSpacing;
  final double activeDotSize;

  /// Prosledi provajdera kog ce widget da koristi
  final DotsTrackProvider dotsTrackProvider;

  const Dots({
    super.key,
    required this.dotNumber,
    required this.dotsTrackProvider,
    this.dotSize = 12,
    this.dotRadius = 12,
    this.dotSpacing = 5,
    this.activeDotSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final activeIndex = dotsTrackProvider.selectedIndex;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        dotNumber,
        (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            width: (index == activeIndex) ? activeDotSize : dotSize,

            // default settings
            margin: EdgeInsets.only(
              right: dotSpacing,
            ),
            height: dotSize,
            decoration: BoxDecoration(
              color: (index == activeIndex)
                  ? Theme.of(context).primaryColor
                  : const Color(0xFFDEDADA),
              borderRadius: BorderRadius.circular(dotRadius),
            ),
          );
        },
      ),
    );
  }
}
