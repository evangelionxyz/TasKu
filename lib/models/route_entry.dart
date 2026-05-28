import 'package:latlong2/latlong.dart';

class RouteEntry {
  const RouteEntry({
    required this.timestamp,
    required this.address,
    required this.latLng,
  });

  final DateTime timestamp;
  final String address;
  final LatLng latLng;
}
