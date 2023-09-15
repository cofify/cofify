import 'package:flutter/material.dart';

class CrossedText extends StatelessWidget {
  final String text;

  /// Velicina kontejnera za prikaz
  final double centerTextSize;

  const CrossedText({
    super.key,
    required this.text,
    required this.centerTextSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: centerTextSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFADA4A6),
                borderRadius: BorderRadius.circular(2),
              ),
              height: 1.5,
              width: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFADA4A6),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFADA4A6),
                borderRadius: BorderRadius.circular(2),
              ),
              height: 1.5,
              width: 50,
            ),
          ),
        ],
      ),
    );
  }
}
