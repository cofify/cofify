import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets
import 'parts/shared_widget_imports.dart';
import 'parts/city_list.dart';
import 'parts/result_not_found.dart';

// models
import '../providers/search_provider.dart';

class ChooseCity extends StatelessWidget {
  const ChooseCity({super.key});

  @override
  Widget build(BuildContext context) {
    final searchDataProvider = Provider.of<ChooseCityDataProvider>(context);

    return Scaffold(
      appBar: const CommonAppBar(text: "Izaberite Grad"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SearchBox(dataProvider: searchDataProvider),
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
                        Navigator.of(context).pushNamed('/restaurants');
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
