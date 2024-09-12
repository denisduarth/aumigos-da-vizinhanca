// ignore_for_file: avoid_print

import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Position? currentPosition;
  String currentAddress = '';

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }
    }
    return true;
  }

  Future<void> getCurrentLocation() async {
    final handlePermissions = await handleLocationPermission();

    if (!handlePermissions) return;

    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      timeLimit: const Duration(
        seconds: 10,
      ),
    );
    await getAddressFromLatLng();
  }

  Future<void> getAddressFromLatLng() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition!.latitude, currentPosition!.longitude);
    Placemark place = placemarks.first;
    currentAddress =
        "${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}, ${place.country}";
  }

  Position get getCurrentPosition => currentPosition!;
  String get getCurrentAddress => currentAddress;
  Future get isLocationServiceEnabled => Geolocator.isLocationServiceEnabled();
}
