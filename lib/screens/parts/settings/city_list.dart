import 'package:flutter/material.dart';

import '../common/common_widget_imports.dart';

// modles
import '../../../providers/search_provider.dart';

class CityList extends StatelessWidget {
  const CityList({
    super.key,
    required this.searchDataProvider,
  });

  final ChooseCityDataProvider searchDataProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchDataProvider.filteredList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            searchDataProvider.setSelectedIndex(index);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(width: 8),
              (searchDataProvider.getCurrentIndex() == index)
                  ? const SvgIcon(
                      icon: "assets/icons/SelectedCircle.svg",
                      size: 24,
                    )
                  : const SvgIcon(
                      icon: "assets/icons/EmptyCircle.svg",
                      size: 24,
                    ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 12.0),
                  child: Text(
                    searchDataProvider.filteredList[index],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
