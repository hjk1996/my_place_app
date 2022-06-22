import 'package:flutter/material.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';

class Places with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  Future<void> addPlace(
      String placeImagePath, String title, PlaceLocation location) async {
    _places.add(
      Place(
        placeImage: placeImagePath,
        title: title,
        location: location,
      ),
    );

    try {
      await DbHelper.addPlace("places", {
        "id": DateTime.now().toIso8601String(),
        "imagePath": placeImagePath,
        "title": title,
        "loc_lat": location.latitude,
        "loc_lng": location.longtitude,
        "address": location.address,
      });
    } catch (error) {
      print("Failed to insert a data into the database");
      rethrow;
    }
    notifyListeners();
  }

  Place findPlaceById(String id) {
    return _places.firstWhere((place) => place.id == id);
  }

  Future<void> deletePlace(String id) async {
    try {
      await DbHelper.removePlace(id);
      _places.removeWhere((place) => place.id == id);
      notifyListeners();
    } catch (error) {
      print("Failed to delete a place in the database");
      rethrow;
    }
  }

  Future<void> fetchPlacesFromDb() async {
    final loadedPlaces = await DbHelper.getPlaces();
    _places = loadedPlaces
        .map((place) => Place(
            placeImage: place['imagePath'],
            title: place['title'],
            location: PlaceLocation(
                latitude: place['latitude'],
                longtitude: place['longtitude'],
                address: place['address'])))
        .toList();
  }
}
