import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RestaurantStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // preuzima naslovnu sliku restorana
  Future<Image> downloadMainImage(String uid) async {
    try {
      Reference reference =
          _storage.ref().child('restaurants/$uid/mainImage/image.jpg');
      final url = await reference.getDownloadURL();
      return Image.network(url);
    } catch (e) {
      throw Error();
    }
  }
}
