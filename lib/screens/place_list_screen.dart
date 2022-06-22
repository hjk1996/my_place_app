import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import '../screens/add_place_screen.dart';

class PlaceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Great Places"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future:
              Provider.of<Places>(context, listen: false).fetchPlacesFromDb(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<Places>(
                builder: (context, places, child) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: places.places.isEmpty
                        ? const Center(
                            child: Text("No Item in the List"),
                          )
                        : ListView.builder(
                            itemCount: places.places.length,
                            itemBuilder: (ctx, idx) {
                              return ListTile(
                                leading: CircleAvatar(
                                    backgroundImage: FileImage(
                                        File(places.places[idx].placeImage))),
                                title: Text(places.places[idx].title),
                                subtitle:
                                    Text(places.places[idx].location.address),
                                trailing: IconButton(
                                    onPressed: () async {
                                      await places
                                          .deletePlace(places.places[idx].id);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              );
                            },
                          ),
                  );
                },
              );
            }
          }),
    );
  }
}
