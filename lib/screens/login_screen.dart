import 'package:flutter/material.dart';

import 'parts/common/common_widget_imports.dart';

// widgets
import 'parts/common/text_divider.dart';

// other
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService.firebase();
    final double svgIconSize = MediaQuery.of(context).size.width * 0.6;
    final double centerTextSize = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      appBar: const CommonAppBar(text: 'Ulogujte se'),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RegularButton(
                  onPress: () async {
                    await auth.signInWithGoogle();
                  },
                  buttonText: "Google",
                  icon: "assets/icons/GoogleLogo.svg",
                  iconSize: 25,
                ),
                const SizedBox(height: 20),
                CrossedText(text: 'ili', centerTextSize: centerTextSize),
                const SizedBox(height: 20),
                RegularButton(
                  onPress: () async {
                    await auth.signInAnon();
                    // Navigator.of(context).pushNamed('/chooseCity');
                  },
                  buttonText: "Nastavite kao gost",
                ),
                const SizedBox(height: 20),
              ],
            ),

            // Devojka ova, zakucana je za dno ekrana
            Positioned(
              bottom: 20,
              left: -20,
              right: 0,
              child: SvgIcon(
                icon: "assets/icons/LoginGirl.svg",
                size: svgIconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class LoginScreen extends StatelessWidget {
//   final AuthService _auth = AuthService.firebase();
//   LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final double svgIconSize = MediaQuery.of(context).size.width * 0.6;
//     final double centerTextSize = MediaQuery.of(context).size.width * 0.5;

//     return Scaffold(
//       appBar: const CommonAppBar(text: 'Ulogujte se'),
//       body: Center(
//         child: Stack(
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 RegularButton(
//                   onPress: () async {
//                     await _auth.signInWithGoogle();
//                   },
//                   buttonText: "Google",
//                   icon: "assets/icons/GoogleLogo.svg",
//                   iconSize: 25,
//                 ),
//                 const SizedBox(height: 20),
//                 CrossedText(text: 'ili', centerTextSize: centerTextSize),
//                 const SizedBox(height: 20),
//                 RegularButton(
//                   onPress: () async {
//                     await _auth.signInAnon();
//                     // Navigator.of(context).pushNamed('/chooseCity');
//                   },
//                   buttonText: "Nastavite kao gost",
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),

//             // Devojka ova, zakucana je za dno ekrana
//             Positioned(
//               bottom: 20,
//               left: -20,
//               right: 0,
//               child: SvgIcon(
//                 icon: "assets/icons/LoginGirl.svg",
//                 size: svgIconSize,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
