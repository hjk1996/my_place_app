import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';

class MapScreen extends StatefulWidget {
  static const routeName = "/map-screen";

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double? _latitude;
  double? _longtitude;

  @override
  Widget build(BuildContext context) {
    final _initialLocation =
        ModalRoute.of(context)!.settings.arguments as LocationData;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Map"),
          actions: [
            IconButton(
                onPressed: _latitude == null || _longtitude == null
                    ? null
                    : () {
                        Navigator.of(context)
                            .pop<LatLng>(LatLng(_latitude!, _longtitude!));
                      },
                icon: const Icon(Icons.check))
          ],
        ),
        body: GoogleMap(
          onTap: (latlng) {
            setState(() {
              _latitude = latlng.latitude;
              _longtitude = latlng.longitude;
            });
          },
          markers: _latitude == null || _longtitude == null
              ? {}
              : {
                  Marker(
                      markerId: const MarkerId("Target"),
                      position: LatLng(_latitude!, _longtitude!))
                },
          initialCameraPosition: CameraPosition(
            zoom: 16,
            target:
                LatLng(_initialLocation.latitude!, _initialLocation.longitude!),
          ),
        ));
  }
}
