import 'package:babysitterapp/pages/homepage/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:babysitterapp/styles/colors.dart';
import 'package:babysitterapp/styles/size.dart';

import '../../components/button.dart';
import '../../models/user_model.dart';
import '../../services/current_user_service.dart';
import '../../services/location_service.dart';
import '../../services/search_service.dart';
import '../../styles/route_animation.dart';
import '../rate/rateandreviewpage.dart';

// ignore: must_be_immutable
class BabysitterViewLocation extends StatefulWidget {
  // selected babysitter ID
  String? selectedBabysitterName;
  final String? totalPayment;
  final String? duration;
  // parent info
  final String? parentName;
  BabysitterViewLocation({
    super.key,
    this.selectedBabysitterName,
    this.totalPayment,
    this.duration,
    this.parentName,
  });

  @override
  State<BabysitterViewLocation> createState() => _BabysitterViewLocationState();
}

class _BabysitterViewLocationState extends State<BabysitterViewLocation> {
  // Services
  LocationService locationService = LocationService();
  SearchService searchService = SearchService();
  CurrentUserService firestoreService = CurrentUserService();

  // Data Models
  UserModel? currentUser;

  // selected babysitter
  Map<String, dynamic>? selectedBabysitter;

  // Load user data
  Future<void> loadUserData() async {
    final user = await firestoreService.loadUserData();
    setState(() {
      currentUser = user;
    });
  }

  // directions
  final List<LatLng> routePoints = [];
  final LatLng start = const LatLng(7.300404, 125.668729);
  final LatLng end = const LatLng(7.313871, 125.671331);
  @override
  void initState() {
    super.initState();
    loadRoute();
    loadUserData();
    fetchSelectedBabysitterByName(widget.selectedBabysitterName!);
  }

  // Fetch data from the selected babysitter
  Future<void> fetchSelectedBabysitterByName(String babysitterName) async {
    try {
      // Fetch babysitter details by name
      final babysitterData =
          await searchService.fetchBabysitterByName(babysitterName);

      // Update the selected babysitter state
      setState(() {
        selectedBabysitter = babysitterData;
      });
    } catch (e) {
      print('Error fetching selected babysitter by name: $e');
    }
  }

  // text style widget
  var textStyle = const TextStyle(fontSize: 12);
  var textOverflow = TextOverflow.ellipsis;

  @override
  Widget build(BuildContext context) {
    const double leadingButtonPadding = 10.0;

    var appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      // title: appBarTitle,
      leading: Padding(
        padding: const EdgeInsets.only(left: leadingButtonPadding),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.deepPurple,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: SizedBox(
        height: sizeConfig.heightSize(context),
        child: routePoints.isEmpty || selectedBabysitter == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                        initialCenter: end, initialZoom: 14, minZoom: 14),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      // polyline for directions
                      _drawPolyline(),
                      // markers(start and end)
                      _directionsMarker(),
                    ],
                  ),
                  // info container
                  _buildInformation()
                ],
              ),
      ),
    );
  }

  // markers for directions
  Widget _directionsMarker() {
    const double widthHeight = 70;
    return MarkerLayer(
      markers: [
        Marker(
            point: start,
            width: widthHeight,
            height: widthHeight,
            child: const Icon(
              Icons.circle,
            )),
        Marker(
            point: end,
            width: widthHeight,
            height: widthHeight,
            child: const Icon(
              Icons.circle,
            )),
      ],
    );
  }

  // draw polyline layer
  Widget _drawPolyline() {
    return PolylineLayer(
      polylines: [
        Polyline(
          points: routePoints,
          strokeWidth: 4.0,
          color: primaryColor,
        ),
      ],
    );
  }

  // info container
  Widget _buildInformation() {
    if (selectedBabysitter == null) return const SizedBox.shrink();

    return currentUser!.role == 'parent'
        ? Positioned(
            left: 0,
            right: 0,
            bottom: 15,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: sizeConfig.widthSize(context),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20.0,
                      spreadRadius: 5.0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag indicator
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Profile Image Section
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: tertiaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 40,
                                  backgroundImage: AssetImage(
                                    selectedBabysitter!['img'] ?? '',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Information Section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            selectedBabysitter!['name'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        //! temporarily removed verified container
                                        // Container(
                                        //   padding: const EdgeInsets.symmetric(
                                        //     horizontal: 8,
                                        //     vertical: 4,
                                        //   ),
                                        //   decoration: BoxDecoration(
                                        //     color: Colors.green.shade50,
                                        //     borderRadius: BorderRadius.circular(12),
                                        //   ),
                                        //   child: Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: [
                                        //       Icon(
                                        //         Icons.verified,
                                        //         size: 14,
                                        //         color: Colors.green.shade700,
                                        //       ),
                                        //       const SizedBox(width: 4),
                                        //       Text(
                                        //         'Verified',
                                        //         style: TextStyle(
                                        //           fontSize: 12,
                                        //           color: Colors.green.shade700,
                                        //           fontWeight: FontWeight.w500,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
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
                                            selectedBabysitter!['address'] ??
                                                '',
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
                                          label:
                                              '${selectedBabysitter!['rating']}',
                                          iconColor: Colors.amber,
                                        ),
                                        const SizedBox(width: 8),
                                        _buildInfoChip(
                                          icon: Icons.access_time,
                                          label: '${widget.duration} hr/s',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Bottom Section with Rate and Button
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Payment',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'P${widget.totalPayment}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Inside your existing widget/page
                              Expanded(
                                child: SizedBox(
                                  height: 46,
                                  child: AppButton(
                                    text: "Complete",
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            elevation: 8,
                                            child: Container(
                                              padding: const EdgeInsets.all(24),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  // Dialog Icon
                                                  CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(0.1),
                                                    child: Icon(
                                                      Icons.star_rate_rounded,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 50,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),

                                                  // Title
                                                  Text(
                                                    'Rate Your Babysitter',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.grey.shade800,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 12),

                                                  // Subtitle
                                                  Text(
                                                    'We value your feedback! Please rate this babysitter',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 24),

                                                  // Action Buttons
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      // Yes Button
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              RouteAnimate(
                                                                0.0,
                                                                1.0,
                                                                page:
                                                                    RateAndReviewPage(
                                                                  babysitterName:
                                                                      '${widget.selectedBabysitterName}',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        12),
                                                            elevation: 4,
                                                          ),
                                                          child: const Text(
                                                            'Rate',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
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
          )
        :
        //* if the currentUser is babysitter
        Positioned(
            left: 0,
            right: 0,
            bottom: 15,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: sizeConfig.widthSize(context),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20.0,
                      spreadRadius: 5.0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag indicator
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Profile Image Section
                              // Container(
                              //   decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     border: Border.all(
                              //       color: tertiaryColor,
                              //       width: 2,
                              //     ),
                              //   ),
                              //   child: CircleAvatar(
                              //     backgroundColor: Colors.transparent,
                              //     radius: 40,
                              //     backgroundImage: AssetImage(
                              //       selectedBabysitter!['img'] ?? '',
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(width: 16),
                              // Information Section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.parentName ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        //! temporarily removed verified container
                                        // Container(
                                        //   padding: const EdgeInsets.symmetric(
                                        //     horizontal: 8,
                                        //     vertical: 4,
                                        //   ),
                                        //   decoration: BoxDecoration(
                                        //     color: Colors.green.shade50,
                                        //     borderRadius: BorderRadius.circular(12),
                                        //   ),
                                        //   child: Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: [
                                        //       Icon(
                                        //         Icons.verified,
                                        //         size: 14,
                                        //         color: Colors.green.shade700,
                                        //       ),
                                        //       const SizedBox(width: 4),
                                        //       Text(
                                        //         'Verified',
                                        //         style: TextStyle(
                                        //           fontSize: 12,
                                        //           color: Colors.green.shade700,
                                        //           fontWeight: FontWeight.w500,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Row(
                                    //   children: [
                                    //     Icon(
                                    //       Icons.location_on_outlined,
                                    //       size: 16,
                                    //       color: Colors.grey.shade600,
                                    //     ),
                                    //     const SizedBox(width: 4),
                                    //     Expanded(
                                    //       child: Text(
                                    //         selectedBabysitter!['address'] ??
                                    //             '',
                                    //         style: TextStyle(
                                    //           fontSize: 14,
                                    //           color: Colors.grey.shade600,
                                    //         ),
                                    //         maxLines: 1,
                                    //         overflow: TextOverflow.ellipsis,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // const SizedBox(height: 8),
                                    // Row(
                                    //   children: [
                                    //     _buildInfoChip(
                                    //       icon: Icons.star_rounded,
                                    //       label:
                                    //           '${selectedBabysitter!['rating']}',
                                    //       iconColor: Colors.amber,
                                    //     ),
                                    //     const SizedBox(width: 8),
                                    //     _buildInfoChip(
                                    //       icon: Icons.access_time,
                                    //       label: '${widget.duration} hr/s',
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 16),
                          // Bottom Section with Rate and Button
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Payment',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'P${widget.totalPayment}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
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

  // load route to display in map
  Future<void> loadRoute() async {
    try {
      final routePoints = await locationService.fetchRoute(
          '${start.longitude},${start.latitude}',
          '${end.longitude},${end.latitude}');
      setState(() {
        this.routePoints.clear();
        this.routePoints.addAll(routePoints);
      });
    } catch (e) {
      print('Error fetching route: $e');
    }
  }
}
