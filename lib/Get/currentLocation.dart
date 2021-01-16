import 'package:faem_app/Models/CurrentLocation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

Future<CurrentLocationData> getCurrentLocation() async {
  CurrentLocationData currentLocationData;
  try {
    currentLocationData.position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    return currentLocationData;
  } catch (err) {
    print(err.message);
  }
}

