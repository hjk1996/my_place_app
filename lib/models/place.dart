import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longtitude;
  final String address;

  PlaceLocation(
      {required this.latitude,
      required this.longtitude,
      required this.address});
}

class Place {
  late String id;
  final String placeImage;
  final String title;
  final PlaceLocation location;

  Place(
      {required this.placeImage, required this.title, required this.location}) {
    id = DateTime.now().toIso8601String();
  }
}
