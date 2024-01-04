import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_kothay/Models/location_model.dart';

class MarkerService{

  List<Marker> getMarkersList(List<Result> places){
    var markers = <Marker>[];

    places.forEach((place) {
      Marker marker = Marker(markerId: MarkerId(place.name),
      draggable: false,
      infoWindow: InfoWindow(title: place.name, snippet: place.vicinity),
      position: LatLng(place.geometry.location.lat, place.geometry.location.lng));

      markers.add(marker);
    });
    return markers;
  }

}