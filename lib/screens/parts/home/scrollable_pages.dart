import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'big_paragraph_text.dart';
import 'big_heading_text.dart';

// models
import '../../../providers/page_track_provider.dart';

class ScrollablePages extends StatelessWidget {
  const ScrollablePages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pageNumberTrack = Provider.of<PageTracker>(context);

    return PageView(
      controller: pageNumberTrack.pageController,
      onPageChanged: (int pageNumber) {
        pageNumberTrack.setCurrentPage(pageNumber);
      },
      scrollDirection: Axis.horizontal,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: const Image(
                  image: AssetImage('assets/images/DobrodosliZena1.jpg'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              const BigHeadingText(
                widgetText: 'Dobrodosli u Cofify',
                customWidgetWidthPercentage: 0.85,
              ),
              const BigParagraphText(
                widgetText:
                    "Pronadjite hranu koju volite, porucite ono sto zelite sa jednim klikom, i uzivajte u hrani spremnoj za samo par minuta.",
                customWidgetWidthPercentage: 0.85,
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: const Image(
                  image: AssetImage('assets/images/DobrodosliZena2.jpg'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              const BigHeadingText(
                widgetText: 'Najbrzi nacin da narucite sta god pozelite',
                customWidgetWidthPercentage: 0.85,
              ),
              const BigParagraphText(
                widgetText:
                    "Zaboravite na bespotrebno cekanje prilikom porucivanja. Cofify Vam omogucava da narucite direktno iz restorana, bez dodatnog cekanja na konobare.",
                customWidgetWidthPercentage: 0.85,
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: const Image(
                  image: AssetImage('assets/images/DobrodosliZena3.jpg'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              const BigHeadingText(
                widgetText:
                    'Budite uvek u toku sa svim novostima vezanih za Vas omiljeni kafic',
                customWidgetWidthPercentage: 0.85,
              ),
              const BigParagraphText(
                widgetText:
                    "Budite uvek u toku sa svim novostima vezanih za Vas omiljeni kafic. Pratite akcije, popuste, kao i ostale pogodnosti, sve sa jednog mesta.",
                customWidgetWidthPercentage: 0.85,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
