import 'package:flutter/material.dart';

import 'parts/home/big_heading_text.dart';
import 'parts/home/big_paragraph_text.dart';

// TODO Razmisli kako ovaj ekran funckionise uopste
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/welcomePages');
        },
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/DobrodosliUCofify.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BigHeadingText(
                  widgetText: "Dobrodosli u Cofify",
                  color: Colors.white,
                  fontSize: 48,
                ),
                SizedBox(
                  height: 20,
                ),
                BigParagraphText(
                  widgetText: "Narucite sta god pozelite uz pomoc jednog klika",
                  color: Colors.white,
                  fontSize: 18,
                ),
                SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
