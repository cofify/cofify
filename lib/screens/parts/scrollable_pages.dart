import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'big_paragraph_text.dart';
import 'big_heading_text.dart';

// models
import '../../providers/dots_track_provider.dart';

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
                widgetText: 'Najbrzi nacin da narucite sta god pozelite',
                customWidgetWidthPercentage: 0.85,
              ),
              const BigParagraphText(
                widgetText:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
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
                widgetText: 'Naruci bilo sta samo jednim klikom',
                customWidgetWidthPercentage: 0.85,
              ),
              const BigParagraphText(
                widgetText:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
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
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
                customWidgetWidthPercentage: 0.85,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
