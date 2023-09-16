import 'package:flutter/material.dart';
import 'svg_icon.dart';

// widgets
import 'box_shadows.dart';

// models
import '../../../providers/search_provider.dart';

/// Koristi se za pretragu elementa neke liste
/// SearchProvider odlucuje koj provajder ce da se koristi u pretrazu
class SearchBox extends StatelessWidget {
  /// Da li da se prikaze dugme sa filterima
  final bool withFilters;

  /// Funkcija koja se poziva pri kliku na dugme sa filterima
  final VoidCallback? function;

  /// Provajder koji se koristi pri pretrazi
  final SearchProvider? dataProvider;

  /// Velicina u procentima zauzetog dela ekrana, default 0.8
  final double widthPercentage;

  const SearchBox(
      {super.key,
      this.dataProvider,
      this.withFilters = false,
      this.function,
      this.widthPercentage = 0.8});

  @override
  Widget build(BuildContext context) {
    final double widgetSize =
        MediaQuery.of(context).size.width * widthPercentage;

    return Container(
      width: widgetSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadowsFactory().boxShadowSoft(),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          dataProvider?.updateSearchQuery(value);
        },
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          // text
          hintText: "Pretraga",
          hintStyle: TextStyle(
            fontSize: 18,
            color: const Color(0xFFDEDADA),
            decorationColor: Theme.of(context).primaryColor,
          ),

          // icons
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: SvgIcon(
              icon: "assets/icons/SearchIcon.svg",
            ),
          ),
          // prefixIconConstraints: BoxConstraints.tight(const Size.square(50)),
          // check if filter icon should be displayed
          suffixIcon: (withFilters)
              ? GestureDetector(
                  onTap: function,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 16),
                    child: SvgIcon(
                      icon: "assets/icons/Tune.svg",
                    ),
                  ),
                )
              : null,

          // other
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
