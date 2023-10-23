import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const CommonAppBar({
    super.key,
    required this.text,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Colors.black,
      elevation: 0.0,
      title: Text(text),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}
