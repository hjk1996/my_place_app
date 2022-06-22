import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:my_place_app/models/place.dart';
import 'package:provider/provider.dart';

import '../screens/map_screen.dart';
import '../providers/places.dart';
import '../helpers/location_helper.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  XFile? _image;
  NetworkImage? _mapImage;
  PlaceLocation? _location;

  bool get readyToSubmit {
    return _titleController.text.isNotEmpty &&
        _image != null &&
        _mapImage != null &&
        _location != null;
  }

  Future<void> _onSubmit(BuildContext ctx) async {
    if (!readyToSubmit) {
      return;
    }

    await Provider.of<Places>(context, listen: false).addPlace(
      _image!.path,
      _titleController.text,
      _location!,
    );
    if (!mounted) {
      return;
    }
    Navigator.of(ctx).pop();
  }

  Future<void> _getCurrentLocationAndMapImage() async {
    try {
      final currentLocation = await LocationHelper.getCurrentLocation();

      final lat = currentLocation!.latitude!;
      final lng = currentLocation.longitude!;

      print(lat);
      print(lng);

      final address = await LocationHelper.getLocationAdress(lat, lng);

      _location =
          PlaceLocation(latitude: lat, longtitude: lng, address: address!);

      _mapImage = await LocationHelper.getLocationMapImage(lat, lng);

      setState(() {});
    } catch (error) {
      print("Failed to load the image");
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Place"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: _image == null
                          ? null
                          : DecorationImage(
                              image: FileImage(
                                File(_image!.path),
                              ),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: _image == null
                        ? const Center(
                            child: Text("No Image"),
                          )
                        : null,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final imagePicker = ImagePicker();
                        _image = await imagePicker.pickImage(
                            source: ImageSource.camera);

                        setState(() {});
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.camera),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Take Picture")
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  image: _mapImage == null
                      ? null
                      : DecorationImage(image: _mapImage!, fit: BoxFit.cover),
                ),
                child: _mapImage == null
                    ? const Center(child: Text("No Place Chosen"))
                    : null,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButtonWithDescription(
                    const Icon(Icons.place),
                    "Current Location",
                    _getCurrentLocationAndMapImage,
                  ),
                  IconButtonWithDescription(
                    const Icon(Icons.select_all),
                    "Choose Location",
                    () {
                      final data = Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MapScreen()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: readyToSubmit
            ? () async {
                await _onSubmit(context);
              }
            : null,
        child: Text("Submit"),
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50)),
      ),
    );
  }
}

Widget IconButtonWithDescription(Icon icon, String desc, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        icon,
        const SizedBox(height: 5),
        Text(desc),
      ],
    ),
  );
}
