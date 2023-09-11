import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofify/models/restaurants.dart';

class RestaurantDatabaseService {
  final CollectionReference restaurantsCollection =
      FirebaseFirestore.instance.collection('bars');

  // pravi listu restorana od podataka vracenih iz firestore
  List<Restaurant> _restaurantListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Restaurant(
        uid: doc.id,
        name: doc['name'] ?? '',
        description: doc['description'] ?? '',
        location: doc['location'] ?? '',
        workTime: doc['workTime'] ?? '',
      );
    }).toList();
  }

  // vraca stream liste restorana
  Stream<List<Restaurant>> get restaurants {
    return restaurantsCollection.snapshots().map(_restaurantListFromSnapshot);
  }
}
