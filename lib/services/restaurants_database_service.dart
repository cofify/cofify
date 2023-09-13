import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofify/models/latlng.dart';
import 'package:cofify/models/restaurants.dart';
import 'package:cofify/models/review.dart';
import 'package:cofify/services/auth_service.dart';
import 'package:cofify/services/location_service.dart';
import 'package:cofify/services/restaurants_storage_service.dart';
import 'package:cofify/services/user_database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantDatabaseService {
  final CollectionReference restaurantsCollection =
      FirebaseFirestore.instance.collection('bars');
  final AuthService _auth = AuthService.firebase();

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
    String? userCity = await getSelectedCity();

    if (userCity != null) {
      QuerySnapshot snapshot = await restaurantsCollection.get();
      List<Restaurant> restaurants = [];

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        if (userCity == doc['city']) {
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

          List<String> favouriteBars = List.empty();
          if (_auth.currentUser!.uid != '') {
            favouriteBars = await DatabaseService(uid: _auth.currentUser!.uid)
                .getFavouriteRestourants();
          }
          final imageUrl =
              await RestaurantStorageService().downloadMainImage(doc.id);

          GeoPoint geoPoint = doc['latlng'];
          LatLng? myLocation = await LocationService().getMyLocation();
          double dist = 0;
          if (myLocation != null) {
            dist = LocationService().calculateDistance(
              geoPoint.latitude,
              geoPoint.longitude,
              myLocation.latitude,
              myLocation.longitude,
            );
          }
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
              isFavourite: (favouriteBars.isNotEmpty)
                  ? favouriteBars.contains(doc.id)
                  : false,
              imageURL: imageUrl,
              latlng: LatLng(
                latitude: geoPoint.latitude,
                longitude: geoPoint.longitude,
              ),
              distance: dist,
              crowd: doc['crowd'],
              visits: doc['visits'],
            ),
          );
        }
      }
      return restaurants;
    }
    return [];
  }

  // vraca grad koji je korisnik izabrao
  Future<String?> getSelectedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? city = prefs.getString('city');
    return city;
  }

  // vraca stream liste restorana
  Stream<List<Restaurant>> get restaurants {
    return restaurantsCollection.snapshots().asyncMap((snapshot) async {
      return await getRestaurants();
    });
  }

  // delegat funkcija za sortiranje
  void sortRestaurants(
    void Function(List<Restaurant>, bool) sorting,
    List<Restaurant> restaurants,
    bool desc,
  ) {
    return sorting(restaurants, desc);
  }

  // sortira restorane po blizini
  void proximitySort(List<Restaurant> restaurants, bool desc) {
    (!desc)
        ? restaurants.sort((a, b) => a.distance.compareTo(b.distance))
        : restaurants.sort((a, b) => b.distance.compareTo(a.distance));
  }

  // sortira restorane po oceni
  void rateSort(List<Restaurant> restaurants, bool desc) {
    (!desc)
        ? restaurants.sort((a, b) => a.averageRate.compareTo(b.averageRate))
        : restaurants.sort((a, b) => b.averageRate.compareTo(a.averageRate));
  }

  // sortira restorane po guzvi
  void crowdSort(List<Restaurant> restaurants, bool desc) {
    (!desc)
        ? restaurants.sort((a, b) => a.crowd.compareTo(b.crowd))
        : restaurants.sort((a, b) => b.crowd.compareTo(a.crowd));
  }

  // sortiraj restorane po posetama
  void visitsSort(List<Restaurant> restaurants, bool desc) {
    (!desc)
        ? restaurants.sort((a, b) => a.visits.compareTo(b.visits))
        : restaurants.sort((a, b) => b.visits.compareTo(a.visits));
  }
}
