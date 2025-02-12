import 'package:cofify/models/latlng.dart';
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
  final int crowd;
  final int visits;

  factory Restaurant.createDefault() => Restaurant(
        uid: "",
        name: "name",
        description: "description",
        location: "location",
        opened: false,
        workTime: [],
        reviews: [],
        averageRate: 0,
        isFavourite: false,
        imageURL: "imageURL",
        latlng: LatLng(latitude: 0, longitude: 0),
        distance: 0,
        crowd: 0,
        visits: 0,
      );

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
    required this.crowd,
    required this.visits,
  });
}
