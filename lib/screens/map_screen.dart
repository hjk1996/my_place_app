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
  late LocationData? currentLocation;

  Future<void> _setCurreuntLocation() async {
    currentLocation = await LocationHelper.getCurrentLocation();
    print(currentLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.check))],
      ),
      body: FutureBuilder(
          future: _setCurreuntLocation(),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        zoom: 16,
                        target: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                      ),
                    )),
    );
  }
}
