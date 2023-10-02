import 'dart:io';
import 'package:cofify/services/auth_service.dart';
import 'package:cofify/services/user_database_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String?> uploadMainImage(String imagePath, String fileName) async {
    try {
      final uid = AuthService.firebase().currentUser?.uid;
      if (uid != null) {
        await deleteAllImagesInFolder('users/$uid/mainImage');
        final Reference storageReference =
            _storage.ref().child('users/$uid/mainImage/$fileName');
        final UploadTask uploadTask = storageReference.putFile(File(imagePath));
        String? result;
        await uploadTask.whenComplete(() async {
          await storageReference.getDownloadURL().then((imageUrl) async {
            try {
              await DatabaseService(uid: uid).updateProfileImage(imageUrl);
              result = imageUrl;
            } catch (e) {
              if (e is Error) {
                throw Error();
              }
            }
          });
        });
        return result;
      } else {
        throw Error();
      }
    } catch (e) {
      throw Error();
    }
  }

  Future<void> deleteAllImagesInFolder(String folderPath) async {
    final storage = FirebaseStorage.instance;
    final ListResult result = await storage.ref().child(folderPath).listAll();

    for (final Reference ref in result.items) {
      try {
        await ref.delete();
      } catch (e) {
        throw Error();
      }
    }
  }
}
