import 'package:cofify/models/LatLng.dart';
import 'package:cofify/models/review.dart';

class Restaurant {
  final String uid;
  final String name;
  final String description;
  final String location;
  final bool opened;
  final List<dynamic> workTime;
  final List<Review> reviews;
  final double averageRate;
  bool isFavourite;
  final String imageURL;
  final LatLng latlng;
  final double distance;

  Restaurant({
    required this.uid,
    required this.name,
    required this.description,
    required this.location,
    required this.opened,
    required this.workTime,
    required this.reviews,
    required this.averageRate,
    required this.isFavourite,
    required this.imageURL,
    required this.latlng,
    required this.distance,
  });
}
