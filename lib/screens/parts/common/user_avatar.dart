import 'package:flutter/material.dart';

// widgets
import 'svg_icon.dart';

class UserAvatar extends StatelessWidget {
  final double size;

  const UserAvatar({
    super.key,
    this.size = 45,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: SvgIcon(
        icon: "assets/icons/AnonimusUser.svg",
        size: size,
      ),
    );
  }
}
