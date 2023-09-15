import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'parts/common/common_widget_imports.dart';

// widget imports
import 'parts/common/dots.dart';
import 'parts/home/scrollable_pages.dart';

import '../providers/page_track_provider.dart';

class WelecomePage extends StatelessWidget {
  const WelecomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageTracker = Provider.of<PageTracker>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: <Widget>[
              const ScrollablePages(),

              // bottom item
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    boxShadow: [
                      BoxShadowsFactory().boxShadowSoftInverted(),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 0.0,
                        ),
                        child: SizedBox(
                          height: 10,
                          child: Center(
                            child: Dots(
                              dotNumber: 3,
                              dotsTrackProvider: pageTracker,
                              dotSize: 10.0,
                            ),
                          ),
                        ),
                      ),
                      // bottom button
                      FatWideButton(
                        onPress: () {
                          if (pageTracker.selectedIndex != 2) {
                            pageTracker
                                .setCurrentPage(pageTracker.selectedIndex + 1);
                          } else {
                            Navigator.of(context).pushNamed('/loginScreen');
                          }
                        },
                        buttonText: (pageTracker.selectedIndex != 2)
                            ? 'Dalje'
                            : 'Krenimo',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
