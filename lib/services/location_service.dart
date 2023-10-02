import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofify/models/latlng.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  // vraca trenutnu lokaciju
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double latitude = position.latitude;
      double longitude = position.longitude;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('myLatitude', latitude);
      await prefs.setDouble('myLongitude', longitude);
    } catch (e) {
      throw Error();
    }
  }

  Future<GeoPoint?> myGeoPoint() async {
    LatLng? latLng = await getMyLocation();
    if (latLng == null) {
      return null;
    }
    return GeoPoint(latLng.latitude, latLng.longitude);
  }

  Future<LatLng?> getMyLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('myLatitude');
    double? longitude = prefs.getDouble('myLongitude');
    if (latitude != null && longitude != null) {
      return LatLng(latitude: latitude, longitude: longitude);
    }
    return null;
  }

  Future<void> checkAndRequestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      await _getCurrentLocation();
    } else if (status.isDenied) {
      //Korisnik odbio
    }
  }

  double calculateDistance(
      double startLat, double startLon, double endLat, double endLon) {
    const double earthRadius = 6371.0;

    double startLatRad = _radians(startLat);
    double endLatRad = _radians(endLat);
    double deltaLat = _radians(endLat - startLat);
    double deltaLon = _radians(endLon - startLon);

    double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(startLatRad) *
            cos(endLatRad) *
            sin(deltaLon / 2) *
            sin(deltaLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distanceInKilometers = earthRadius * c;
    double distanceInMeters = distanceInKilometers * 1000;

    return distanceInMeters;
  }

  double _radians(double degrees) {
    return degrees * (pi / 180);
  }
}
