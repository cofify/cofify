import 'package:flutter/material.dart';

class BigParagraphText extends StatelessWidget {
  final String widgetText;
  final Color? color;
  final double? fontSize;
  final double? customWidgetWidthPx;
  final double? customWidgetWidthPercentage;

  const BigParagraphText({
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
          style: TextStyle(
            color: (color != null) ? color : Colors.black,
            fontSize: (fontSize != null) ? fontSize : 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
