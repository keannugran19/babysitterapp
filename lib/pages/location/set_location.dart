import 'package:babysitterapp/components/button.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:babysitterapp/styles/size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../models/user_model.dart';
import '../../services/current_user_service.dart';
import '../../services/location_service.dart';

class SetLocation extends StatefulWidget {
  const SetLocation({super.key});

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  // call firestore service
  CurrentUserService firestoreService = CurrentUserService();
  // get data from firestore using the model
  UserModel? currentUser;
  LocationService locationService = LocationService();

  double latitude = 0;
  double longitude = 0;

  final double initialCenterLat = 7.30215;
  final double initialCenterLon = 125.68145;

  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    currentUser = await firestoreService.loadUserData();
    setState(() {});
  }

  // save new data when save is clicked
  Future<void> _saveUserData() async {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data is not available.')),
      );
      return; // Early exit if no user data is found.
    }

    try {
      // Save latitude and longitude to the 'address' field
      currentUser =
          currentUser!.copyWith(location: GeoPoint(latitude, longitude));

      // Get a human-readable address
      final readableAddress = await locationService.getAddressFromCoordinates(
        LatLng(latitude, longitude),
      );

      // Save human-readable address to the 'location' field
      currentUser = currentUser!.copyWith(address: readableAddress);

      // Save updated data to Firestore
      await firestoreService.saveUserData(currentUser!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Set Location"),
        actions: [
          TextButton(
            onPressed: _saveUserData,
            child: const Text(
              'Save',
              style: TextStyle(color: backgroundColor),
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: sizeConfig.heightSize(context),
        child: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                  initialCenter: LatLng(initialCenterLat, initialCenterLon),
                  initialZoom: 14,
                  minZoom: 14),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    // use location marker
                    Marker(
                      point: LatLng(latitude, longitude),
                      width: 125,
                      height: 125,
                      child: Tooltip(
                        message: "You are here!",
                        triggerMode: TooltipTriggerMode.tap,
                        verticalOffset: 20,
                        preferBelow: false,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset('assets/images/location.png'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 320,
                    child: AppButton(
                      text: "Set Location",
                      onPressed: _getUserLocation,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // tag users location
  Future<void> _getUserLocation() async {
    final pos = await locationService.determinePosition();
    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
      mapController.move(LatLng(latitude, longitude), 14);
    });
  }
}
