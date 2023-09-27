import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofify/utilities/errors/errors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cofify/models/latlng.dart';
import 'package:cofify/models/restaurants.dart';
import 'package:cofify/models/review.dart';
import 'package:cofify/services/auth_service.dart';
import 'package:cofify/services/location_service.dart';
import 'package:cofify/services/restaurants_storage_service.dart';
import 'package:cofify/services/user_database_service.dart';

class RestaurantDatabaseService {
  final CollectionReference restaurantsCollection =
      FirebaseFirestore.instance.collection('bars');
  final AuthService _auth = AuthService.firebase();

  // Vraca radno vreme
  List<dynamic> _getDaySchedule(Map<String, dynamic> workTimeMap) {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;
    final daySchedule = workTimeMap.containsKey((dayOfWeek - 1).toString())
        ? workTimeMap[(dayOfWeek - 1).toString()]
        : [];
    return daySchedule;
  }

  // Proverava da li je kafic otvoren
  bool _checkIsBarOpen(
    Map<String, dynamic> workTimeMap,
    List<dynamic> daySchedule,
  ) {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;
    if (workTimeMap.containsKey((dayOfWeek - 1).toString())) {
      daySchedule = workTimeMap[(dayOfWeek - 1).toString()];
      if ((now.hour > daySchedule[0].toDate().hour ||
              (now.hour == daySchedule[0].toDate().hour &&
                  now.minute >= daySchedule[0].toDate().minute)) &&
          (now.hour < daySchedule[1].toDate().hour ||
              (now.hour == daySchedule[1].toDate().hour &&
                  now.minute <= daySchedule[1].toDate().minute))) {
        return true;
      }
    }
    return false;
  }

  // Fech-uje review-e restorana
  Future<List<Review>> _getReviews(DocumentSnapshot doc) async {
    final reviewCollection = doc.reference.collection('reviews');
    final reviewSnapshot = await reviewCollection.get();
    final reviews = reviewSnapshot.docs.map((reviewDoc) {
      return Review(
        id: reviewDoc.id,
        text: reviewDoc['comment'] ?? '',
        rating: (reviewDoc['rate'] ?? 0).toDouble(),
      );
    }).toList();
    return reviews;
  }

  // Izracunava i vraca prosecnu ocenu restorana
  double _averageRate(List<Review> reviews) {
    double averageRate = 0.0;
    for (var review in reviews) {
      averageRate += review.rating;
    }
    averageRate /= reviews.isNotEmpty ? reviews.length : 1;
    return averageRate;
  }

  // Preuzima i vraca URL nasloven slike restorana
  Future<String> _getRestaurantImage(String uid) async {
    return await RestaurantStorageService().downloadMainImage(uid);
  }

  // Izracunava i vraca udaljenost izmedju korisnika i restorana
  Future<double> _getDistance(GeoPoint geoPoint) async {
    final myLocation = await LocationService().getMyLocation();
    double dist = 0;
    if (myLocation != null) {
      dist = LocationService().calculateDistance(
        geoPoint.latitude,
        geoPoint.longitude,
        myLocation.latitude,
        myLocation.longitude,
      );
    }
    return dist;
  }

  Future<DocumentSnapshot?> getDocumentSnapshot(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('bars').doc(uid).get();
      return documentSnapshot;
    } catch (e) {
      log(e.toString());
      throw Error();
    }
  }

  // Kreira instancu resorana
  Future<Restaurant> _createRestaurantInstance(
    DocumentSnapshot doc,
  ) async {
    final daySchedule = _getDaySchedule(doc['workTime']);
    final isOpen = _checkIsBarOpen(doc['workTime'], daySchedule);
    final reviews = await _getReviews(doc);
    final averageRate = _averageRate(reviews);
    final favouriteBars = _auth.currentUser!.uid != ''
        ? await DatabaseService(uid: _auth.currentUser!.uid)
            .getFavouriteRestourants()
        : <String>[];
    final imageUrl = await _getRestaurantImage(doc.id);
    final geoPoint = doc['latlng'];
    final dist = await _getDistance(geoPoint);

    return Restaurant(
      uid: doc.id,
      name: doc['name'] ?? '',
      description: doc['description'] ?? '',
      location: doc['location'] ?? '',
      opened: isOpen,
      workTime: daySchedule,
      reviews: reviews,
      averageRate: averageRate,
      isFavourite:
          favouriteBars.isNotEmpty ? favouriteBars.contains(doc.id) : false,
      imageURL: imageUrl,
      latlng: LatLng(
        latitude: geoPoint.latitude,
        longitude: geoPoint.longitude,
      ),
      distance: dist,
      crowd: doc['crowd'],
      visits: doc['visits'],
    );
  }

  // vraca listu restorana na osnovu prosledjenog query-a
  Future<List<Restaurant>> _getSelectedRestauratns(
    Query query,
    int action,
  ) async {
    final restaurants = <Restaurant>[];
    final snapshot = await query.get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      restaurants.add(await _createRestaurantInstance(doc));
    }
    return restaurants;
  }

  // Vraca listu sortiranih restorana
  Future<List<Restaurant>> getRestaurants(
    int action,
    bool favourite,
    DocumentSnapshot? documentSnapshot,
    int restaurantsPerPage,
  ) async {
    try {
      if (action == -1) {
        documentSnapshot = null;
        return [];
      }
      final userCity = await getSelectedCity();

      Query query = restaurantsCollection.where(
        'city',
        isEqualTo: userCity,
      );
      if (favourite) {
        List<String> myFavouriteRestaurants =
            await DatabaseService(uid: _auth.currentUser!.uid)
                .getFavouriteRestourants();
        if (myFavouriteRestaurants.isNotEmpty) {
          query = query.where(
            'id',
            whereIn: myFavouriteRestaurants,
          );
        } else {
          return [];
        }
      }
      switch (action) {
        case 1:
          final userLocation = await LocationService().myGeoPoint();
          if (userLocation != null) {
            query = query
                .orderBy('latlng', descending: false)
                .startAt([userLocation]);
          }
          break;
        case 2:
          final userLocation = await LocationService().myGeoPoint();
          if (userLocation != null) {
            query =
                query.orderBy('latlng', descending: true).endAt([userLocation]);
          }
          break;
        case 3:
          await updateRestaurantAverageRating();
          query = query.orderBy('averageRating', descending: false);
          break;
        case 4:
          await updateRestaurantAverageRating();
          query = query.orderBy('averageRating', descending: true);
          break;
        case 5:
          query = query.orderBy('crowd', descending: false);
          break;
        case 6:
          query = query.orderBy('crowd', descending: true);
          break;
        case 7:
          query = query.orderBy('visits', descending: true);
          break;
        case 8:
          query = query.orderBy('visits', descending: false);
          break;
        default:
          break;
      }

      query = query.limit(restaurantsPerPage);
      if (documentSnapshot != null) {
        query = query.startAfterDocument(documentSnapshot);
      }
      return await _getSelectedRestauratns(query, 1);
    } catch (e) {
      throw LoadingRestaurantsException();
    }
  }

  // Azurira prosecnu ocenu restorana
  Future<void> updateRestaurantAverageRating() async {
    final QuerySnapshot allRestaurants = await restaurantsCollection.get();
    for (QueryDocumentSnapshot restaurantDoc in allRestaurants.docs) {
      final restaurantId = restaurantDoc.id;
      final ratingsCollection =
          restaurantsCollection.doc(restaurantId).collection('reviews');

      final QuerySnapshot ratingsSnapshot = await ratingsCollection.get();
      double totalRating = 0;

      for (QueryDocumentSnapshot ratingDoc in ratingsSnapshot.docs) {
        final ratingData = ratingDoc.data() as Map<String, dynamic>;
        final rating = ratingData['rate'];
        totalRating += rating;
      }

      final int numRatings = ratingsSnapshot.docs.length;
      final double averageRating =
          numRatings > 0 ? totalRating / numRatings : 0;

      // Ažurirajte prosečnu ocenu u dokumentu restorana
      await restaurantsCollection.doc(restaurantId).update({
        'averageRating': averageRating,
      });
    }
  }

  // Preuzima i vraca selektovani grad iz lokalne memorije
  Future<String?> getSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('city');
    return city;
  }

  // Stream liste restorana
  Stream<List<Restaurant>> get restaurants {
    return restaurantsCollection.snapshots().asyncMap((snapshot) async {
      return await getRestaurants(0, false, null, 3);
    });
  }
}
