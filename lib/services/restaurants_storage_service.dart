import 'package:firebase_storage/firebase_storage.dart';

class RestaurantStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // preuzima naslovnu sliku restorana
  Future<String> downloadMainImage(String uid) async {
    try {
      Reference reference =
          _storage.ref().child('restaurants/$uid/mainImage/image.jpg');
      final url = await reference.getDownloadURL();
      return url;
    } catch (e) {
      throw Error();
    }
  }
}
