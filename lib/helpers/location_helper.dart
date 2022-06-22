import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter/material.dart';

const API_KEY = "AIzaSyCfzrrycBzdrOydQRLrYOLHtlaekNUJNrA";

class LocationHelper {
  static Future<LocationData?> getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    try {
      return location.getLocation();
    } catch (error) {
      print("Faield to load current location");
      rethrow;
    }
  }

  static Future<NetworkImage?> getCurrentLocationMapImage() async {
    final currentLocation = await LocationHelper.getCurrentLocation();

    final requestUrl =
        "https://maps.googleapis.com/maps/api/staticmap?center=${currentLocation!.latitude},${currentLocation.longitude}&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C${currentLocation.latitude},${currentLocation.longitude}&key=$API_KEY";

    try {
      return NetworkImage(requestUrl);
    } catch (error) {
      print("Failed to load current location map image");
    }
  }

  static Future<NetworkImage?> getLocationMapImage(
      double lat, double lng) async {
    final requestUrl =
        "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C$lat,$lng&key=$API_KEY";

    try {
      return NetworkImage(requestUrl);
    } catch (error) {
      print("Failed to get locaion map image");
    }
  }

  static Future<String?> getLocationAdress(double lat, double lng) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$API_KEY");

    try {
      final res = await http.get(url);

      final resBody = json.decode(res.body);

      return resBody['results'][3]["formatted_address"];
    } catch (error) {
      print("Failed to get location address");
      rethrow;
    }
  }
}
