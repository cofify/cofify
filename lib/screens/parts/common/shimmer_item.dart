import 'package:flutter/material.dart';

class ShimmerItem extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final bool expand;

  const ShimmerItem({
    super.key,
    this.height = 22,
    this.width = 100,
    this.borderRadius = 4,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: (expand) ? null : width,
        color: Colors.white,
      ),
    );
  }
}
