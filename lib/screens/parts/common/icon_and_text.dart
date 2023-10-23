import 'package:flutter/material.dart';

import 'svg_icon.dart';

class IconAndText extends StatelessWidget {
  final dynamic icon;
  final double iconSize;
  final VoidCallback iconAction;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final TextBaseline? textBaseline;
  final bool iconFirst;

  const IconAndText({
    super.key,
    required this.text,
    required this.icon,
    required this.iconAction,
    this.fontSize = 18.0,
    this.fontWeight = FontWeight.normal,
    this.iconSize = 18.0,
    this.spacing = 8.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.textBaseline,
    this.iconFirst = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      textBaseline: textBaseline,
      children: (iconFirst)
          ? [
              InkWell(
                onTap: iconAction,
                child: SvgIcon(
                  icon: icon,
                  size: iconSize,
                ),
              ),
              SizedBox(width: spacing),
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
            ]
          : [
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
              SizedBox(width: spacing),
              GestureDetector(
                onTap: iconAction,
                child: SvgIcon(
                  icon: icon,
                  size: iconSize,
                ),
              ),
            ],
    );
  }
}
