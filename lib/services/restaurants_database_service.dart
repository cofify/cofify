import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofify/models/restaurants.dart';
import 'package:cofify/models/review.dart';

class RestaurantDatabaseService {
  final CollectionReference restaurantsCollection =
      FirebaseFirestore.instance.collection('bars');

  // vraca radno vreme
  List<dynamic> _getDaySchedule(Map<String, dynamic> workTimeMap) {
    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday;
    List<dynamic> daySchedule = [];
    if (workTimeMap.containsKey((dayOfWeek - 1).toString())) {
      daySchedule = workTimeMap[(dayOfWeek - 1).toString()];
    }
    return daySchedule;
  }

  // proverava da li je kafic otvoren
  bool _checkIsBarOpen(
    Map<String, dynamic> workTimeMap,
    List<dynamic> daySchedule,
  ) {
    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday;
    bool isOpen = false;
    if (workTimeMap.containsKey((dayOfWeek - 1).toString())) {
      daySchedule = workTimeMap[(dayOfWeek - 1).toString()];

      if ((now.hour > daySchedule[0].toDate().hour ||
              (now.hour == daySchedule[0].toDate().hour &&
                  now.minute >= daySchedule[0].toDate().minute)) &&
          (now.hour < daySchedule[1].toDate().hour ||
              (now.hour == daySchedule[1].toDate().hour &&
                  now.minute <= daySchedule[1].toDate().minute))) {
        isOpen = true;
      }
    }
    return isOpen;
  }

  // pravi listu restorana od podataka vracenih iz firestore
  Future<List<Restaurant>> getRestaurants() async {
    QuerySnapshot snapshot = await restaurantsCollection.get();
    List<Restaurant> restaurants = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      List<dynamic> daySchedule = _getDaySchedule(doc['workTime']);
      bool isOpen = _checkIsBarOpen(doc['workTime'], daySchedule);

      final reviewCollection = doc.reference.collection('reviews');
      QuerySnapshot reviewSnapshot = await reviewCollection.get();

      List<Review> reviews = reviewSnapshot.docs.map((reviewDoc) {
        return Review(
          id: reviewDoc.id,
          text: reviewDoc['comment'] ?? '',
          rating: (reviewDoc['rate'] ?? 0).toDouble(),
        );
      }).toList();

      double averageRate = 0.0;
      for (var review in reviews) {
        averageRate += review.rating;
      }
      averageRate /= (reviews.isNotEmpty) ? reviews.length : 1;

      restaurants.add(
        Restaurant(
          uid: doc.id,
          name: doc['name'] ?? '',
          description: doc['description'] ?? '',
          location: doc['location'] ?? '',
          opened: isOpen,
          workTime: daySchedule,
          reviews: reviews,
          averageRate: averageRate,
        ),
      );
    }

    return restaurants;
  }

  // vraca stream liste restorana
  Stream<List<Restaurant>> get restaurants {
    return restaurantsCollection.snapshots().asyncMap((snapshot) async {
      return await getRestaurants();
    });
  }
}
