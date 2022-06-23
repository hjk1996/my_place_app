import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
    final _arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final _initialLatLng = _arguments['latlng'] as LatLng;
    final _isReadOnly = _arguments['readOnly'] as bool;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Map"),
          actions: [
            if (!_isReadOnly)
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
            if (_isReadOnly) {
              return;
            }

            setState(() {
              _latitude = latlng.latitude;
              _longtitude = latlng.longitude;
            });
          },
          markers: _latitude == null || _longtitude == null || _isReadOnly
              ? {}
              : {
                  Marker(
                      markerId: const MarkerId("Target"),
                      position: LatLng(_latitude!, _longtitude!))
                },
          initialCameraPosition: CameraPosition(
            zoom: 16,
            target: LatLng(_initialLatLng.latitude, _initialLatLng.longitude),
          ),
        ));
  }
}
