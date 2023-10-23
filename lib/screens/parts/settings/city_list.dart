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
        return CityListTile(
            searchDataProvider: searchDataProvider, index: index);
      },
    );
  }
}

class CityListTile extends StatelessWidget {
  final int index;

  const CityListTile({
    super.key,
    required this.searchDataProvider,
    required this.index,
  });

  final ChooseCityDataProvider searchDataProvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        searchDataProvider.setSelectedIndex(index);
      },
      child: ListTile(
        leading: (searchDataProvider.getCurrentIndex() == index)
            ? const SvgIcon(
                icon: "assets/icons/SelectedCircle.svg",
                size: 24,
              )
            : const SvgIcon(
                icon: "assets/icons/EmptyCircle.svg",
                size: 24,
              ),
        title: Text(
          searchDataProvider.filteredList[index],
          style: const TextStyle(fontSize: 18),
        ),
        dense: true,
        horizontalTitleGap: 0.0,
      ),
    );
  }
}
