// ignore_for_file: avoid_print

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  late Position currentPosition;
  String currentAddress = '';

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<void> getCurrentLocation() async {
    final handlePermissions = await _handleLocationPermission();

    if (!handlePermissions) return;

    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(
        seconds: 5,
      ),
    );
    await _getAddressFromLatLng();
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = placemarks[0];
      currentAddress =
          "${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      print(e);
    }
  }

  Position get getCurrentPosition => currentPosition;
  String get getCurrentAddress => currentAddress;
  Future<bool> get isLocationServiceEnabled => Geolocator.isLocationServiceEnabled();
}
