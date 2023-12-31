import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingSpace{

  final int id;
  final LatLng location;
  final bool soldOut;

  ParkingSpace({required this.id, required this.location, required this.soldOut});
}