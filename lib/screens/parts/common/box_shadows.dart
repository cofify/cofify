import 'package:flutter/material.dart';

class BoxShadowsFactory {
  static final BoxShadowsFactory _instance = BoxShadowsFactory._internal();

  BoxShadowsFactory._internal();

  // getter za factory
  factory BoxShadowsFactory() {
    return _instance;
  }

  BoxShadow boxShadowSoftInverted() {
    return BoxShadow(
      color: const Color(0xFFADA4A6).withOpacity(0.15),
      blurRadius: 10,
      spreadRadius: 6,
      offset: const Offset(0, -2),
    );
  }

  BoxShadow boxShadowSoft() {
    return BoxShadow(
      color: const Color(0xFFADA4A6).withOpacity(0.15),
      blurRadius: 10,
      spreadRadius: 6,
      offset: const Offset(0, 2),
    );
  }
}
