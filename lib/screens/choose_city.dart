import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets
import 'parts/common/common_widget_imports.dart';
import 'parts/settings/city_list.dart';
import 'parts/common/result_not_found.dart';

// models
import '../providers/search_provider.dart';

class ChooseCity extends StatelessWidget {
  const ChooseCity({super.key});

  @override
  Widget build(BuildContext context) {
    final searchDataProvider = Provider.of<ChooseCityDataProvider>(context);

    return Scaffold(
      appBar: const CommonAppBar(
        text: 'Izaberite Grad',
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.grey[50],
                toolbarHeight: 100,
                floating: true,
                snap: true,
                flexibleSpace: Column(
                  children: [
                    const SizedBox(height: 20),
                    SearchBox(dataProvider: searchDataProvider),
                  ],
                ),
              ),
            ];
          },
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: (searchDataProvider.filteredList.isEmpty)
                          ? ResultNotFound(
                              headingText: "Grad nije pronadjen",
                              icon: 'assets/icons/City.svg',
                              paragraphText:
                                  'Proverite da li ste tacno uneli termin za pretragu.'
                                  ' U suprotnom je moguce da jos uvek ne nudimo'
                                  ' usluge u Vasem gradu.',
                              showButton: true,
                              searchDataProvider: searchDataProvider,
                            )
                          : CityList(
                              searchDataProvider: searchDataProvider,
                            ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadowsFactory().boxShadowSoftInverted(),
                    ],
                  ),
                  child: Center(
                    child: ThinWideButton(
                      onPress: () {
                        Navigator.of(context).pushNamed('/restaurantsList');
                      },
                      buttonText: "Primeni",
                      lowImportance: (searchDataProvider.filteredList.isEmpty)
                          ? true
                          : false,
                      disabled: (searchDataProvider.filteredList.isEmpty)
                          ? true
                          : false,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
