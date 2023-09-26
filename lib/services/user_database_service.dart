import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // azuriraj ili dodaj novog korisnika
  Future<void> updateUserData(
    String? displayName,
    String? email,
    String? photoURL,
  ) async {
    return await userCollection.doc(uid).set({
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
    });
  }

  // dodaj restoran kao omiljen
  Future<void> addRestourantToFavourite(String restaurantUID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('restartFavouriteRestaurants', true);
    return await userCollection
        .doc(uid)
        .collection('favouriteBars')
        .doc(restaurantUID)
        .set({
      'dateTime': DateTime.now(),
    });
  }

  // ukloni restoran iz omiljenih
  Future<void> removeRestaurantFromFavourite(String restaurantUID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('restartFavouriteRestaurants', true);
    try {
      await userCollection
          .doc(uid)
          .collection('favouriteBars')
          .doc(restaurantUID)
          .delete();
    } catch (e) {
      throw Error();
    }
  }

  // vrati sve uid-ove omiljenih restorana
  Future<List<String>> getFavouriteRestourants() async {
    final favouriteCollection =
        userCollection.doc(uid).collection('favouriteBars');
    QuerySnapshot favouriteSnapshot = await favouriteCollection.get();
    List<String> result = favouriteSnapshot.docs.map((value) {
      return value.id;
    }).toList();
    return result;
  }

  // pamti korisnikov izabrani grad lokalno
  Future<void> saveCityLocaly(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('city', city);
  }
}
