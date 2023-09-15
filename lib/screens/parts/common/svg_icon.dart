import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// custom svg assets to be used as icons
class SvgIcon extends StatelessWidget {
  final dynamic icon;
  final Color? color;
  final double size;

  const SvgIcon({
    super.key,
    required this.icon,
    this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    if (icon == null) {
      iconWidget = const SizedBox(height: 0, width: 0);
    } else if (icon is IconData) {
      iconWidget = Icon(icon, color: color, size: size);
    } else if (icon is String) {
      iconWidget = SvgPicture.asset(
        icon,
        // ignore: deprecated_member_use
        color: color,
        width: size,
        height: size,
      );
    } else {
      throw ArgumentError('Invalid icon type');
    }

    return iconWidget;
  }
}
