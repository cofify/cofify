import 'package:cloud_firestore/cloud_firestore.dart';

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
}
