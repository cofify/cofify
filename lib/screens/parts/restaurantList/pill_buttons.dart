import 'package:cofify/providers/page_track_provider.dart';
import 'package:flutter/material.dart';

import '../common/box_shadows.dart';

class PillButtons extends StatelessWidget {
  final PillButtonPageTracker pageController;
  final GlobalKey<PillButtonsFrontClippedTextState> pillKey;

  const PillButtons({
    super.key,
    required this.pageController,
    required this.pillKey,
  });

  @override
  Widget build(BuildContext context) {
    if (pageController.selectedIndex == 0) {
      pillKey.currentState?.forward();
    } else {
      pillKey.currentState?.reverse();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadowsFactory().boxShadowSoft()],
                borderRadius: BorderRadius.circular(50),
              ),
              child: PillButtonsContent(pageController: pageController),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: (pageController.selectedIndex == 0) ? 0 : 120,
              child: Container(
                width: 120,
                height: 53,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ),
        PillButtonsFrontClippedText(key: pillKey),
      ],
    );
  }
}

class PillButtonsFrontClippedText extends StatefulWidget {
  const PillButtonsFrontClippedText({
    super.key,
  });

  @override
  State<PillButtonsFrontClippedText> createState() =>
      PillButtonsFrontClippedTextState();
}

class PillButtonsFrontClippedTextState
    extends State<PillButtonsFrontClippedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late CurvedAnimation _curvedAnimation;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _animation = Tween<double>(begin: 120, end: 0).animate(_curvedAnimation);
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void reverse() {
    _animationController.reverse();
  }

  void forward() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 240,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return ClipPath(
                clipper: SviOmiljeniClipper(left: _animation.value, width: 120),
                child: const PillButtonsClipperContent(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PillButtonsContent extends StatelessWidget {
  final PillButtonPageTracker pageController;
  final Color color;

  const PillButtonsContent({
    super.key,
    required this.pageController,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            pageController.setCurrentPage(0);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            width: 120,
            alignment: Alignment.center,
            child: Text(
              "Omiljeni",
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            pageController.setCurrentPage(1);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 16,
            ),
            width: 120,
            alignment: Alignment.center,
            child: Text(
              "Svi",
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class PillButtonsClipperContent extends StatelessWidget {
  const PillButtonsClipperContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Center(
            child: Text(
              "Omiljeni",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Center(
            child: Text(
              "Svi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SviOmiljeniClipper extends CustomClipper<Path> {
  final double width;
  final double left;

  const SviOmiljeniClipper({
    required this.left,
    required this.width,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(Offset(left, 0), Offset(width + left, size.height)),
        const Radius.circular(60),
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
