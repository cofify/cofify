import 'package:flutter/material.dart';

// widgets
import 'common_widget_imports.dart';

class FatWideButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPress;
  final Color? color;
  final bool lowImportance;
  final bool showShadow;
  final bool disabled;

  const FatWideButton({
    super.key,
    required this.onPress,
    required this.buttonText,
    this.color,
    this.lowImportance = false,
    this.showShadow = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.9;

    return ElevatedButton(
      onPressed: (disabled) ? null : onPress,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(containerWidth, 0),
        foregroundColor: (lowImportance) ? Colors.black : Colors.white,
        backgroundColor: (lowImportance)
            ? const Color(0xFFDEDADA)
            : color ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
        elevation: (showShadow) ? 2 : 0,
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 20.0),
      ),
    );
  }
}

class ThinWideButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPress;
  final Color? color;
  final bool lowImportance;
  final bool showShadow;
  final bool disabled;

  const ThinWideButton({
    super.key,
    required this.onPress,
    required this.buttonText,
    this.lowImportance = false,
    this.color,
    this.showShadow = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.9;

    return ElevatedButton(
      onPressed: (disabled) ? null : onPress,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(containerWidth, 0),
        foregroundColor: (lowImportance) ? Colors.black : Colors.white,
        backgroundColor: (lowImportance)
            ? const Color(0xFFDEDADA)
            : color ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
        elevation: (showShadow) ? 2 : 0,
        shadowColor:
            (showShadow) ? const Color(0xFFDEDADA) : Colors.transparent,
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 17.0),
      ),
    );
  }
}

class RegularButton extends StatelessWidget {
  final String buttonText;
  final dynamic icon;
  final double iconSize;
  final VoidCallback onPress;
  final Color? color;
  final bool lowImportance;
  final bool showShadow;
  final bool disabled;

  const RegularButton({
    super.key,
    required this.onPress,
    required this.buttonText,
    this.lowImportance = false,
    this.color,
    this.icon,
    this.iconSize = 17.0,
    this.showShadow = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (disabled) ? null : onPress,
      style: ElevatedButton.styleFrom(
        // sa lowImportance je sivo dugme sa crnim tekstom,
        // ako nije lowImportance onda roze dugme sa belim tekstom, ili custom boja
        foregroundColor: (lowImportance) ? Colors.black : Colors.white,
        backgroundColor: (lowImportance)
            ? const Color(0xFFDEDADA)
            : color ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 34),
        elevation: (showShadow) ? 2 : 0,
        shadowColor:
            (showShadow) ? const Color(0xFFDEDADA) : Colors.transparent,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgIcon(
            icon: icon,
            size: iconSize,
            color: (lowImportance) ? Colors.black : Colors.white,
          ),
          (icon != null) ? const SizedBox(width: 8) : const SizedBox(width: 0),
          Text(
            buttonText,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPress;
  final Color? color;
  final bool lowImportance;
  final bool showShadow;
  final bool disabled;

  const SmallButton({
    super.key,
    required this.onPress,
    required this.buttonText,
    this.color,
    this.lowImportance = false,
    this.showShadow = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (disabled) ? null : onPress,
      style: ElevatedButton.styleFrom(
        foregroundColor: (lowImportance) ? Colors.black : Colors.white,
        backgroundColor: (lowImportance)
            ? const Color(0xFFDEDADA)
            : color ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
        elevation: (showShadow) ? 2 : 0,
        shadowColor:
            (showShadow) ? const Color(0xFFDEDADA) : Colors.transparent,
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
