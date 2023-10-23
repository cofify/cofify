import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

// widgets
import 'buttons.dart';
import '../settings/terms_of_service_card.dart';

class CommonFunctions {
  static final CommonFunctions _instance = CommonFunctions._internal();

  CommonFunctions._internal();

  factory CommonFunctions() {
    return _instance;
  }

  Future<dynamic> termsOfServiceBottomSheet(BuildContext context) {
    return showSlidingBottomSheet(
      context,
      builder: (context) => SlidingSheetDialog(
        cornerRadius: 16,
        avoidStatusBar: true,
        color: Colors.grey[50],
        snapSpec: const SnapSpec(
          snap: true,
          initialSnap: 0.4,
          snappings: [0.4, 0.7, 1],
        ),
        headerBuilder: (context, state) {
          return Material(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          );
        },
        // footerBuilder: (context, state) {
        //   return Material(
        //     child: RegularButton(onPress: () {}, buttonText: "Zatvori"),
        //   );
        // },
        builder: (context, state) {
          return Material(
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        "Uslovi Koriscenja",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  // Razmak izmedju Naslova i prvog reda
                  const SizedBox(height: 20),
                  const TermsOfServiceCard(
                    number: 1,
                    heading: "Nase Usluge",
                    description:
                        "Informacije koje se pružaju kada se koriste usluge nisu namenjene distribuciji ili upotrebi bilo kog fizičkog ili pravnog lica u bilo kojoj jurisdikciji ili zemlji u kojoj je takva distribucija ili upotreba bilo u suprotnosti sa zakonom ili propisima ili koji bi nas izložili bilo kakvim zahtevima za registraciju u takvoj jurisdikciji ili zemlji. Shodno tome, oni pojedinci koji odluče da pristupe uslugama iz na drugim mestima, to rade na sopstvenu inicijativu i isključivo su odgovorni za sprovođenje lokalnih zakona ako i u meri u kojoj se primenjuju lokalni zakoni.",
                  ),
                  const SizedBox(height: 16),
                  const TermsOfServiceCard(
                      number: 2,
                      heading: "Prava Intelektualne Svojine",
                      description:
                          "Mi smo vlasnik ili licencirani vlasnik svih prava intelektualne svojine na naše usluge, uključujući sav izvorni kod, baze podataka, funkcionalnost, softver, dizajn veb stranice, audio, video, text, fotografije i grafike u Uslugama (zajednički nazvane \"sadržaji\"), kao i zaštitni znaci, servisni znakovi i logotipi sadržani u njima (\"znakovi\"). Naš sadržaj i znakovi zaštićeni su zakonima o autorskim pravima i zaštitnim znakovima (kao i raznim drugim zakonima o pravima intelektualne svojine i nelojalnoj konkurenciji) i ugovorima u Sjedinjenim Državama i oko sveta. Sadržaj i znakovi se pružaju u Uslugama ili preko njih \"onakvi kakvi jesu\" samo za vašu ličnu, nekomercijalnu upotrebu."),
                  const TermsOfServiceCard(
                      number: 2,
                      heading: "Prava Intelektualne Svojine",
                      description:
                          "Mi smo vlasnik ili licencirani vlasnik svih prava intelektualne svojine na naše usluge, uključujući sav izvorni kod, baze podataka, funkcionalnost, softver, dizajn veb stranice, audio, video, text, fotografije i grafike u Uslugama (zajednički nazvane \"sadržaji\"), kao i zaštitni znaci, servisni znakovi i logotipi sadržani u njima (\"znakovi\"). Naš sadržaj i znakovi zaštićeni su zakonima o autorskim pravima i zaštitnim znakovima (kao i raznim drugim zakonima o pravima intelektualne svojine i nelojalnoj konkurenciji) i ugovorima u Sjedinjenim Državama i oko sveta. Sadržaj i znakovi se pružaju u Uslugama ili preko njih \"onakvi kakvi jesu\" samo za vašu ličnu, nekomercijalnu upotrebu."),
                  const SizedBox(height: 20),
                  RegularButton(
                    onPress: () {
                      Navigator.of(context).pop();
                    },
                    buttonText: "Zatvori",
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
