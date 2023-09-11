import 'package:flutter/material.dart';

// widgets
import 'shared_widget_imports.dart';
import '../../providers/search_provider.dart';

class ResultNotFound extends StatelessWidget {
  final String icon;
  final String headingText;
  final String paragraphText;
  final double? iconWidth;
  final double? textWidth;

  /// Da li da se prikaze dugme uposte
  final bool showButton;

  /// Provajder kog treba pozvati na klik na dugme
  final SearchProvider? searchDataProvider;

  const ResultNotFound({
    super.key,
    required this.icon,
    required this.headingText,
    required this.paragraphText,
    this.searchDataProvider,
    this.showButton = false,
    this.iconWidth,
    this.textWidth,
  });

  @override
  Widget build(BuildContext context) {
    final double displayedIconWidth;
    final double displayedTextWidth;

    displayedIconWidth = iconWidth ?? MediaQuery.of(context).size.width * 0.35;
    displayedTextWidth = textWidth ?? MediaQuery.of(context).size.width * 0.75;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgIcon(
          icon: icon,
          size: displayedIconWidth,
        ),
        const SizedBox(height: 30),
        Text(
          headingText,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: displayedTextWidth,
          child: Text(
            paragraphText,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (showButton)
          SmallButton(
            // TODO probaj da skontas kako da izbrises text iz searchBox
            onPress: () {
              searchDataProvider?.clearSearchQuery();
            },
            buttonText: "Odustani",
            lowImportance: true,
            showShadow: true,
          ),
      ],
    );
  }
}
