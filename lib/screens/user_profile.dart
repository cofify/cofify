import 'dart:developer';
import 'package:cofify/models/user.dart';
import 'package:cofify/services/auth_service.dart';
import 'package:cofify/services/user_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthService auth = AuthService.firebase();
  ImagePicker picker = ImagePicker();
  String? profileImage;

  bool isLoading = false;

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          isLoading = true;
        });
        final imagePath = pickedFile.path;
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        String? imageURL = await UserStorageService().uploadMainImage(
          imagePath,
          fileName,
        );
        setState(() {
          profileImage = imageURL;
          isLoading = false;
        });
      } else {
        log('Slika nije izabrana');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log('Doslo je do greske prilikom pamcenja slike: $e');
    }
  }

  Future<void> _takePicture() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          isLoading = true;
        });
        final imagePath = pickedFile.path;
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        String? imageURL = await UserStorageService().uploadMainImage(
          imagePath,
          fileName,
        );
        setState(() {
          profileImage = imageURL;
          isLoading = false;
        });
      } else {
        log('Slika nije izabrana');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log('Doslo je do greske prilikom pamcenja slike: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ModalRoute.of(context)!.settings.arguments as UserData;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moj Profil'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: (isLoading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (userData.profileImage == null)
                    ? const Center(
                        child: Text('Nema slike'),
                      )
                    : (profileImage == null)
                        ? Image.network(userData.profileImage!)
                        : Image.network(profileImage!),
          ),
          //_buildProfileImage(userData.profileImage),
          Text('Ime I Prezime: ${userData.displayName}'),
          Text('Email Adresa: ${userData.email}'),
          const SizedBox(height: 20),
          const Text('Promeni profilnu sliku'),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _pickImageFromGallery();
                  setState(() {});
                },
                child: const Text('Galerija'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _takePicture,
                child: const Text('Kamera'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String? imageUrl) {
    //log(imageUrl.toString());
    if (!isLoading) {
      return (imageUrl != null)
          ? SizedBox(
              width: 300,
              height: 300,
              child: Image.network(imageUrl),
            )
          : const Text('Profile Image Is NULL');
    } else {
      return const SizedBox(
        height: 300,
        width: 300,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
