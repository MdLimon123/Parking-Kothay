import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:parking_kothay/Utils/constants.dart';

class GoogleMapsScreen extends StatefulWidget {
   GoogleMapsScreen({super.key, required this.lat, required this.lng});

   double lat;
   double lng;

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  
  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(23.8041, 90.4152),
  zoom: 15);

  final List<Marker> myMarker = [];
 location.Location  _location = location.Location();
 LatLng? _currentLocation;
  List<Marker> _parkingMarkers = [];

   final List<Marker> markerList = const[
     Marker(markerId: MarkerId('First'),
      position: LatLng(23.8041, 90.4152),
      infoWindow: InfoWindow(
        title: 'My Position'
      ),

    ),
     Marker(markerId: MarkerId('Second'),
      position: LatLng(23.87438393146338, 90.38940308939185),
      infoWindow: InfoWindow(
          title: 'Uttara'
      ),

    ),

    Marker(markerId: MarkerId('Third'),
      position: LatLng(23.787072032053537, 90.41503065048066),
      infoWindow: InfoWindow(
          title: 'Gulshan-1'
      ),

    ),
    Marker(markerId: MarkerId('Four'),
      position: LatLng(23.77780648149767, 90.40508022903357),
      infoWindow: InfoWindow(
          title: 'Mohakhali'
      ),

    ),
  ];

   Set<Circle> _circles = {};
   double _radius = 5000;

   // void _createCircle(){
   //   _circles = {
   //     Circle(
   //       circleId: CircleId('First'),
   //       radius: _radius,
   //       fillColor: Colors.blue.withOpacity(0.3),
   //       strokeColor: Colors.blue,
   //       strokeWidth: 2
   //     )
   //   };
   // }

   Future<void> _getLocation()async{
    location.LocationData locationData = await _location.getLocation();
     setState(() {
       _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
     });

   }

   Future<void> _showParkingDetailsDialog(String title, String price)async{



     return showDialog(
         context: context,
         builder: (BuildContext context){
           return AlertDialog(
             title: Text(title),
             content: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisSize: MainAxisSize.min,
               children: [
                 Row(
                   children: [
                     Text(price),
                   ],
                 ),
                 SizedBox(height: 10.h,),
                 const Text('Availbility: Open 24/7'),
                 SizedBox(height: 10.h,),
                 const Text('Distance: 12 mins')

               ],
             ),
             actions: [
               TextButton(onPressed: (){
                 Navigator.pop(context);
               },
                   child: Text('Book Now')),
               TextButton(onPressed: (){
                 Navigator.pop(context);
               },
                   child: Text('Cancel')),
             ],
           );
         });
   }

   Future<void> _fetchParkingLocations()async{
     final place = GoogleMapsPlaces(apiKey: apiKey);
     final response = await place.searchNearbyWithRadius(
        Location(lat: _currentLocation!.latitude, lng: _currentLocation!.longitude),
         500,
     type: 'parking');

     if(response.status == 'OK'){
       setState(() {
         _parkingMarkers.clear();
         List<PlacesSearchResult> sortedList = List.from(response.results);
         sortedList.sort((a,b){
           double distanceToA = _calculatedDistance(_currentLocation!, LatLng(a.geometry!.location.lat, a.geometry!.location.lng));
           double distanceToB = _calculatedDistance(_currentLocation!, LatLng(b.geometry!.location.lat, b.geometry!.location.lng));
         return distanceToA.compareTo(distanceToB);
         });
         for(PlacesSearchResult place in response.results){
           String parkingPrice = 'Parking price: \$5.00';
           String marketTitle = place.name;
           String infoWindowText = '$marketTitle\n$parkingPrice';
           _parkingMarkers.add(
             Marker(markerId: MarkerId(place.placeId),
             position: LatLng(place.geometry!.location.lat, place.geometry!.location.lng),
             infoWindow: InfoWindow(title: marketTitle, snippet: 'Tap to view details'),
             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
               onTap: (){

               _showParkingDetailsDialog(marketTitle, parkingPrice);

               }

             )
           );
         }
         _circles = {
           Circle(
             circleId: const CircleId('ParkingRadius'),
             center: _currentLocation!,
             radius: 500,
             fillColor: const Color(0xFF26AA75).withOpacity(0.3),
             strokeWidth: 2,
             strokeColor: const Color(0xFF26AA75)
           )
         };

       });
     }else{
       print('Error fetching parking locations: ${response.errorMessage}');
     }
   }

   double _calculatedDistance(LatLng start, LatLng end){
     return Geolocator.distanceBetween(
         start.latitude, start.longitude,
         end.latitude, end.longitude);
   }

  @override
  void initState() {

    super.initState();
    _getLocation();
    myMarker.addAll(markerList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF26AA75),
        leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text('Pick Parking slot',style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w800
        ),),
        centerTitle: true,
      ),
      body: Column(
        children: [
         _currentLocation == null?const Center(child: CircularProgressIndicator(),): SizedBox(
            height: 400.h,
            child: GoogleMap(
              mapType: MapType.normal,
                markers: Set.from(_parkingMarkers),
                initialCameraPosition: CameraPosition(
                  target: _currentLocation!,
                  zoom: 15
                ),
              onMapCreated: (GoogleMapController controller){
                setState(() {
                  _controller.complete(controller);
                  _fetchParkingLocations();
                });


              },
              circles:_circles
            ),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching),
        onPressed: ()async{
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
             CameraPosition(target: LatLng(widget.lat, widget.lng),
                zoom: 15)
          ));
          setState(() {
            print(widget.lat);
            print(widget.lng);

          });
        },
      ),
    );
  }
}
