import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

// widgets
import '../screens/parts/common/common_widget_imports.dart';

// services
import '../services/auth_service.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService.firebase();

    return Scaffold(
      appBar: const CommonAppBar(text: 'Nalog'),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UserSection(authService: authService),
                const OptionsSection(),
              ],
            ),
            InkWell(
              onTap: () {
                CommonFunctions().termsOfServiceBottomSheet(context);
              },
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Uslovi koriscenja"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionsSection extends StatelessWidget {
  const OptionsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: SvgIcon(icon: "assets/icons/lunch_dining.svg"),
              title: Text(
                "Istorija Narudzbina",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: SvgIcon(icon: "assets/icons/switch_account.svg"),
              title: Text(
                "Promeni nalog",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: SvgIcon(icon: "assets/icons/settings.svg"),
              title: Text(
                "Postavke",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserSection extends StatelessWidget {
  const UserSection({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadowsFactory().boxShadowSoft()],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Hero(
              tag: 'restaurant-settings-UserAvatar',
              child: UserAvatar(size: 70),
            ),
            const SizedBox(height: 10),
            const Text(
              "Anonimus user",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () {
                authService.signOut();
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Izloguj se",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF007EF2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
