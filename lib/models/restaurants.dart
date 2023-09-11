import 'package:flutter/material.dart';

class Restaurant {
  final String uid;
  final String name;
  final String description;
  final String location;
  final List<dynamic> workTime;
  late Image mainImage;

  Restaurant({
    required this.uid,
    required this.name,
    required this.description,
    required this.location,
    required this.workTime,
  });
}
