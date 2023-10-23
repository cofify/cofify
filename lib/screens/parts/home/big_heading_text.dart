import 'package:flutter/material.dart';

class BigHeadingText extends StatelessWidget {
  final String widgetText;
  final Color? color;
  final double? fontSize;
  final double? customWidgetWidthPx;
  final double? customWidgetWidthPercentage;

  const BigHeadingText({
    super.key,
    required this.widgetText,
    this.color,
    this.fontSize,
    this.customWidgetWidthPx,
    this.customWidgetWidthPercentage,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * (customWidgetWidthPercentage ?? 0.75);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: (customWidgetWidthPx != null)
            ? customWidgetWidthPx
            : containerWidth,
        child: Text(
          widgetText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: (fontSize != null) ? fontSize : 28,
            fontWeight: FontWeight.bold,
            color: (color != null) ? color : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
