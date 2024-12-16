import 'package:babysitterapp/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../models/user_model.dart';
import '../../services/babysitter_service.dart';
import '../../services/current_user_service.dart';
import '../../styles/colors.dart';
import '../../styles/route_animation.dart';
import '../../styles/size.dart';
import '../profile/babysitterprofilepage.dart';

class UserViewLocation extends StatefulWidget {
  const UserViewLocation({super.key});

  @override
  State<UserViewLocation> createState() => _UserViewLocationState();
}

class _UserViewLocationState extends State<UserViewLocation> {
  // call firestore services
  CurrentUserService firestoreService = CurrentUserService();
  final BabysitterService babysitterService = BabysitterService();
  // get data from firestore using the model
  UserModel? currentUser;
  // store babysitter list data
  List<UserModel> _babysitters = [];
  // Selected babysitter details
  UserModel? selectedBabysitter;
  // Show info container
  bool showContainer = false;

  // Locations
  final LatLng center = const LatLng(7.306836, 125.680799);
  // Radius for geofence
  double _geofenceRadius = 500;
  // load user data
  Future<void> loadUserData() async {
    final user = await firestoreService.loadUserData();
    setState(() {
      currentUser = user;
    });
  }

  // load babysitter data
  Future<void> loadBabysitters() async {
    final babysitters = await babysitterService.getBabysitters();
    setState(() {
      _babysitters = babysitters;
    });
  }

  // Show/hide info container
  void _showContainer(UserModel babysitter) {
    setState(() {
      selectedBabysitter = babysitter;
      showContainer = true;
    });
  }

  // Function to calculate distance
  // Function to calculate distance between two LatLng points
  double _calculateDistance(LatLng start, LatLng end) {
    var distance = const Distance();
    return distance.as(
        LengthUnit.Meter, start, end); // Returns the distance in meters
  }

  // Function to update geofence radius (for testing)
  void _updateRadius(double newRadius) {
    setState(() {
      _geofenceRadius = newRadius;
    });
  }

  // initiate load
  @override
  void initState() {
    super.initState();
    loadUserData();
    loadBabysitters();
  }

  // styles widgets
  var textStyle = const TextStyle(fontSize: 12);
  var textOverflow = TextOverflow.ellipsis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: sizeConfig.heightSize(context),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                  initialCenter: center,
                  initialZoom: 14,
                  minZoom: 14,
                  maxZoom: 14),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                _buildCircleLayer(),
                _buildMarkers(),
              ],
            ),
            showContainer == false
                ? _buildGeofenceRadiusSlider()
                : _buildInformation(),
          ],
        ),
      ),
    );
  }

  // Adjustable radius slider
  Widget _buildGeofenceRadiusSlider() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Radius Display with Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  color: primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Distance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            // Radius Value with Animated Counter
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                '${_geofenceRadius.toStringAsFixed(0)} meters',
                key: ValueKey(_geofenceRadius),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),

            // Enhanced Slider
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: primaryColor,
                inactiveTrackColor: Colors.grey[300],
                thumbColor: primaryColor,
                overlayColor: primaryColor.withOpacity(0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              ),
              child: Slider(
                value: _geofenceRadius,
                min: 500,
                max: 2000,
                divisions: 15,
                onChanged: (newRadius) {
                  _updateRadius(newRadius);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CircleLayer with dynamic radius
  Widget _buildCircleLayer() {
    return CircleLayer(
      circles: [
        CircleMarker(
          point: center,
          color: primaryColor.withOpacity(0.3),
          borderColor: primaryColor,
          borderStrokeWidth: 2,
          radius: _geofenceRadius / 10, // Adjust this conversion factor
        ),
      ],
    );
  }

  // Map markers with geofencing
  Widget _buildMarkers() {
    final List<Marker> markers = _babysitters.where((babysitter) {
      // Create LatLng for babysitter location
      final babysitterLocation =
          LatLng(babysitter.location!.latitude, babysitter.location!.longitude);

      // Calculate exact distance
      final distanceToCenter = _calculateDistance(babysitterLocation, center);

      // Only include markers within geofence radius
      return distanceToCenter <= _geofenceRadius;
    }).map((babysitter) {
      return Marker(
        point: LatLng(
            babysitter.location!.latitude, babysitter.location!.longitude),
        width: 100,
        height: 80,
        child: GestureDetector(
          onTap: () {
            _showContainer(babysitter); // Use the show container method
            print("Tapped on ${babysitter.name}");
          },
          child: _buildBabysitterCard(babysitter),
        ),
      );
    }).toList();

    return MarkerLayer(markers: markers);
  }

  // Babysitter card widget for marker
  Widget _buildBabysitterCard(UserModel? babysitter) {
    return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 1),
          ],
        ),
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: babysitter!.img != ""
                        ? AssetImage(babysitter.img!)
                        : const AssetImage('assets/images/default_user.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              babysitter.name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, size: 10, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  '${babysitter.rating}',
                  style: const TextStyle(fontSize: 8),
                ),
              ],
            ),
            Text(
              "P${babysitter.rate}/hour",
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
            ),
          ],
        ));
  }

  Widget _buildInformation() {
    if (selectedBabysitter == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 20, // Adjusts visibility
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            showContainer = false; // Hide the container
            selectedBabysitter = null; // Clear selected babysitter
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Indicator
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Profile Image Section
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 30,
                            backgroundImage: selectedBabysitter!.img != ""
                                ? AssetImage(selectedBabysitter!.img!)
                                : const AssetImage(
                                    'assets/images/default_user.png'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedBabysitter!.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        selectedBabysitter!.address ?? '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildInfoChip(
                                      icon: Icons.star_rounded,
                                      label: '${selectedBabysitter!.rating}',
                                      iconColor: Colors.amber,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildInfoChip(
                                      icon: Icons.cases_outlined,
                                      label: "3 yrs exp",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rate per hour',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'P${selectedBabysitter!.rate}/hr',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: AppButton(
                                text: "Book Now",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    RouteAnimate(0.0, 1.0,
                                        page: BabysitterProfilePage(
                                          babysitterID:
                                              selectedBabysitter!.email,
                                          currentUserID: currentUser!.email,
                                        )),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: iconColor ?? Colors.grey.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
