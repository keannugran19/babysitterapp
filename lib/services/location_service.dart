import 'dart:convert';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
// import 'package:latlong2/latlong.dart';

class LocationService {
  // allow location permissions and get users current location
  Future<Position> determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  // get address from longitude and latitude via nominatim api of openstreetmap
  Future<String> getAddressFromCoordinates(LatLng? location) async {
    if (location == null) return 'Unknown Location';
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?lat=${location.latitude}&lon=${location.longitude}&format=json&addressdetails=1',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];

        final barangay = address['suburb'] ?? address['village'] ?? '';
        final city =
            address['city'] ?? address['town'] ?? address['municipality'] ?? '';

        return '${barangay.isNotEmpty ? 'Brgy. $barangay, ' : ''}'
            '$city City';
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Unknown Location';
    }
  }

  // openrouteservice API
  Future<List<LatLng>> fetchRoute(String start, String end) async {
    const baseUrl =
        'https://api.openrouteservice.org/v2/directions/driving-car';
    const apiKey = '5b3ce3597851110001cf6248c50a353dddcd4db7b26fd2067ea4f046';
    final url = Uri.parse('$baseUrl?api_key=$apiKey&start=$start&end=$end');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['features'] != null && data['features'].isNotEmpty) {
        final coordinates = data['features'][0]['geometry']['coordinates'];

        return coordinates.map<LatLng>((coord) {
          return LatLng(coord[1], coord[0]);
        }).toList();
      } else {
        throw Exception('No route data found in response');
      }
    } else {
      print('Error response body: ${response.body}');
      throw Exception('Failed to load route: ${response.statusCode}');
    }
  }
}
