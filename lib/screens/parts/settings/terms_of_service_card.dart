import 'package:flutter/material.dart';

class TermsOfServiceCard extends StatelessWidget {
  final int number;
  final String heading;
  final String description;

  const TermsOfServiceCard({
    super.key,
    required this.number,
    required this.heading,
    required this.description,
  });

  String formatNumber() {
    if (number < 10) {
      return "0$number";
    }

    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatNumber(),
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Razmak izmedju rednog broja i informacija
        const SizedBox(width: 30),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Text(
                heading,
                style: const TextStyle(fontSize: 20),
              ),
              // Razmak izmedju naslova informacije i opisa
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
