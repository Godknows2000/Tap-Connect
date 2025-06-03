import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddVenueScreen extends StatefulWidget {
  const AddVenueScreen({super.key});

  @override
  State<AddVenueScreen> createState() => _AddVenueScreenState();
}

class _AddVenueScreenState extends State<AddVenueScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController operatingHoursController = TextEditingController();
  final TextEditingController beersController = TextEditingController();
  final TextEditingController foodController = TextEditingController();
  final TextEditingController winesController = TextEditingController();
  final TextEditingController menuItemController = TextEditingController();

  List<Map<String, dynamic>> menuItems = [];
  bool isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitudeController.text = position.latitude.toString();
        longitudeController.text = position.longitude.toString();
        isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        isLoadingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  Future<void> _pickLocationOnMap() async {
    final LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(
          initialPosition: LatLng(
            double.tryParse(latitudeController.text) ?? 51.5074,
            double.tryParse(longitudeController.text) ?? -0.1278,
          ),
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        latitudeController.text = selectedLocation.latitude.toString();
        longitudeController.text = selectedLocation.longitude.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Add New Venue',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Venue Name'),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: latitudeController,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  suffixIcon: isLoadingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.my_location, color: Colors.white70),
                          onPressed: _getUserLocation,
                        ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: longitudeController,
                decoration: InputDecoration(
                  labelText: 'Longitude',
                  suffixIcon: isLoadingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.my_location, color: Colors.white70),
                          onPressed: _getUserLocation,
                        ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                onPressed: _pickLocationOnMap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Pick Location on Map'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: operatingHoursController,
                decoration: const InputDecoration(labelText: 'Operating Hours (e.g., Open Today • 8AM - 6PM)'),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: beersController,
                decoration: const InputDecoration(labelText: 'Number of Beers'),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: foodController,
                decoration: const InputDecoration(labelText: 'Number of Food Items'),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: winesController,
                decoration: const InputDecoration(labelText: 'Number of Wines'),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: menuItemController,
                decoration: const InputDecoration(labelText: 'Add Menu Item (e.g., Beer Name)'),
                style: const TextStyle(color: Colors.white),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      menuItems.add({'name': value, 'type': 'Beer', 'rating': 0.0});
                      menuItemController.clear();
                    });
                  }
                },
              ),
              const SizedBox(height: 8),
              Wrap(
                children: menuItems.map((item) => Chip(
                  label: Text(item['name']),
                  onDeleted: () {
                    setState(() {
                      menuItems.remove(item);
                    });
                  },
                )).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('venues').add({
                    'name': nameController.text,
                    'latitude': double.tryParse(latitudeController.text),
                    'longitude': double.tryParse(longitudeController.text),
                    'address': addressController.text,
                    'operatingHours': operatingHoursController.text,
                    'beersCount': int.tryParse(beersController.text) ?? 0,
                    'foodItemsCount': int.tryParse(foodController.text) ?? 0,
                    'winesCount': int.tryParse(winesController.text) ?? 0,
                    'menuItems': menuItems,
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Add Venue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapPickerScreen extends StatefulWidget {
  final LatLng initialPosition;

  const MapPickerScreen({super.key, required this.initialPosition});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late GoogleMapController mapController;
  LatLng? selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          if (selectedPosition != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, selectedPosition);
              },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.initialPosition,
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        onTap: (LatLng position) {
          setState(() {
            selectedPosition = position;
          });
        },
        markers: selectedPosition != null
            ? {
                Marker(
                  markerId: const MarkerId('selected-location'),
                  position: selectedPosition!,
                ),
              }
            : {},
      ),
    );
  }
}