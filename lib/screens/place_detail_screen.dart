import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import '../screens/map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';

  @override
  Widget build(BuildContext context) {
    final placeId = ModalRoute.of(context)!.settings.arguments as String;
    final place =
        Provider.of<Places>(context, listen: false).findPlaceById(placeId);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(
                        File(place.placeImage),
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              place.location.address,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      MapScreen.routeName,
                      arguments: {
                        "latlng": LatLng(
                          place.location.latitude,
                          place.location.longtitude,
                        ),
                        "readOnly": true
                      },
                    );
                  },
                  icon: const Icon(Icons.place),
                ),
                const Text("Show the place on the map")
              ],
            )
          ],
        ),
      ),
    );
  }
}
