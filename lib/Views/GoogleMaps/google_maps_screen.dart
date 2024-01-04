import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:parking_kothay/Models/parking_space_model.dart';
import 'package:parking_kothay/Utils/constants.dart';
import 'package:parking_kothay/Views/FindAndBookParking/Controller/find_and_book_parking_controller.dart';
import 'package:parking_kothay/marker_services.dart';

class GoogleMapsScreen extends StatefulWidget {
    GoogleMapsScreen({super.key, required this.lat, required this.lng});

double lat;
double lng;

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  
   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
 late GoogleMapController mapController;

 final _findAndBookingController = Get.put(FindAndBookParkingController());
  
  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(23.8041, 90.4152),
  zoom: 15);

  Position? currentLocation;



  List<ParkingSpace> parkingSpace = [
    ParkingSpace(id: 1, location: const LatLng(23.8041, 90.4152),soldOut: true),
  ParkingSpace(id: 2, location: const LatLng(23.87438393146338, 90.38940308939185), soldOut: true),
  ParkingSpace(id: 3, location: const LatLng(23.787072032053537, 90.41503065048066),soldOut: true),
  ParkingSpace(id: 4, location: const LatLng(23.77780648149767, 90.40508022903357),soldOut: true)
  ];

  final List<Marker> myMarker = [];
 final location.Location  _location = location.Location();
 LatLng? _currentLocation;
 final List<Marker> _parkingMarkers = [];

 final places = GoogleMapsPlaces(apiKey: apiKey);

   final List<Marker> markerList = const[
     Marker(markerId: MarkerId('First'),
      position: LatLng(23.8041, 90.4152),
      infoWindow: InfoWindow(
        title: 'My Position'
      ),

    ),

    //  Marker(markerId: MarkerId('Second'),
    //   position: LatLng(23.87438393146338, 90.38940308939185),
    //   infoWindow: InfoWindow(
    //       title: 'Uttara'
    //   ),
    //
    // ),
    // Marker(markerId: MarkerId('Third'),
    //   position: LatLng(23.787072032053537, 90.41503065048066),
    //   infoWindow: InfoWindow(
    //       title: 'Gulshan-1'
    //   ),
    //
    // ),
    // Marker(markerId: MarkerId('Four'),
    //   position: LatLng(23.77780648149767, 90.40508022903357),
    //   infoWindow: InfoWindow(
    //       title: 'Mohakhali'
    //   ),
    //
    // ),


   ];

   Set<Circle> _circles = {};


   void _createCircle(){
     _circles = {
       Circle(
         circleId: CircleId('First'),
         radius: 500,
         fillColor: Colors.blue.withOpacity(0.3),
         strokeColor: Colors.blue,
         strokeWidth: 2
       )
     };
   }

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
                 const Text('Availability: Open 24/7'),
                 SizedBox(height: 10.h,),
                 const Text('Distance: 12 min')

               ],
             ),
             actions: [
               TextButton(onPressed: (){
                 Navigator.pop(context);
               },
                   child: const Text('Book Now')),
               TextButton(onPressed: (){
                 Navigator.pop(context);
               },
                   child: const Text('Cancel')),
             ],
           );
         });
   }

   Future<void> _fetchParkingLocations()async{
     final place = GoogleMapsPlaces(apiKey: apiKey);
     final response = await place.searchNearbyWithRadius(
        Location(lat: widget.lat, lng: widget.lng),
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
             Marker(markerId: MarkerId(widget.lat.toString()+widget.lng.toString()),
             position: LatLng(widget.lat, widget.lng),
             infoWindow: InfoWindow(title: marketTitle, snippet: 'Tap to view details'),
             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
               onTap: (){

               _showParkingDetailsDialog(marketTitle, parkingPrice);

               }

             )
           );
         }
         _circles = {
           Circle(
             circleId:  CircleId(widget.lat.toString()+widget.lng.toString()),
             center: LatLng(widget.lat,widget.lng),
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


 final Set<Marker> _markers = {};

   final markerService = MarkerService();

   Future<void> findParkingSport(Position currentLocation)async{
     final response = await places.searchNearbyWithRadius(
         Location(lat: currentLocation.latitude, lng: currentLocation.longitude),
         500,
       type: 'parking'
     );

     if(response.status == 'OK'){
       for(PlacesSearchResult result in response.results){

         final location = result.geometry!.location;
         final parkingSpot = LatLng(location.lat, location.lng);

         setState(() {
           _markers.add(
             Marker(markerId: MarkerId(result.placeId),
             position: parkingSpot,
             infoWindow: InfoWindow(title: result.name, snippet: 'Parking Spot'),
             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
               onTap: (){}
             ),

           );
         });
       }
     }

   }

  @override
  void initState() {

    super.initState();
    _getLocation();
   myMarker.addAll(markerList);

  }
  
  
  void _addMarkerForNearestParkingSpace(Position currentLocation){
     ParkingSpace parkingSpace = findNearestParkingSpace(currentLocation);

     _markers.clear();
     _circles.clear();

     _markers.add(
       Marker(markerId: MarkerId(parkingSpace.id.toString()),
         position: parkingSpace.location,
         infoWindow: InfoWindow(
           title: 'Parking Space ${parkingSpace.id}',
           snippet:parkingSpace.soldOut? 'Sold Out': 'Available'
         ),
         icon:parkingSpace.soldOut? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
             :BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
       )
     );

     // Add circle

    _circles.add(
      Circle(circleId: CircleId(parkingSpace.id.toString()),
        center: parkingSpace.location,
        radius: 500.0,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.green,
        strokeWidth: 2
      )
    );

  }

  void _onMapCreated(GoogleMapController controller){
     setState(() {
       mapController = controller;

       if(currentLocation !=null){
         _addMarkerForNearestParkingSpace(currentLocation!);
       }
     });
  }
  
  ParkingSpace findNearestParkingSpace(Position currentLocation){
     ParkingSpace nearestSpace = parkingSpace[0];
     double minDistance = double.infinity;
     
     for(var space in parkingSpace){
       double distance = Geolocator.distanceBetween(
           currentLocation.latitude,
           currentLocation.longitude,
           space.location.latitude, 
           space.location.longitude);
       
       if(distance < minDistance){
         minDistance = distance;
         nearestSpace = space;
       }
     }
     
     return nearestSpace;
     
  }
  
  void _getCurrentLocation()async{
     try{
       Position position = await Geolocator.getCurrentPosition();
       setState(() {
         currentLocation = position;
       });
     }catch(e){
       print('Error getting location $e');
     }
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
            icon: const Icon(Icons.arrow_back, color: Colors.white,)),
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
                  //target: LatLng(_currentLocation?.latitude ?? 0.0, _currentLocation?.longitude ?? 0.0),
                 target: LatLng(widget.lat, widget.lng),
                  zoom: 15
                ),
              zoomControlsEnabled: false,
              compassEnabled: false,
              indoorViewEnabled: true,
              mapToolbarEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(0,16),
              onMapCreated:

                  (GoogleMapController controller){
                setState(() {
                  _controller.complete(controller);
                  _fetchParkingLocations();
                });},
                // markers: {
                // Marker(markerId: MarkerId('1'),
                //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
                // )
                // },
              circles:_circles
            ),
          )

          // Obx((){
          //   if(_findAndBookingController.searchResult.isEmpty){
          //     return const Center(child: Text('No Parking slot'),);
          //   }else{
          //     return Expanded(
          //       child: GoogleMap(
          //           initialCameraPosition: CameraPosition(
          //             target: LatLng(
          //               _findAndBookingController.searchResult[0].geometry.location.lat,
          //               _findAndBookingController.searchResult[0].geometry.location.lng
          //             ),
          //             zoom: 14.0
          //           ),
          //         markers: _findAndBookingController.getMarkers(),
          //
          //       ),
          //     );
          //   }
          // })

        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching),
        onPressed: ()async{
          // GoogleMapController controller = await _controller.future;
          // controller.animateCamera(CameraUpdate.newCameraPosition(
          //    CameraPosition(target: LatLng(widget.lat, widget.lng),
          //       zoom: 15)
          // ));
          // setState(() {
          //   print(widget.lat);
          //   print(widget.lng);
          //
          // });
          // setState(() {
          //   findParkingSport(_kGooglePlex);
          //
          // });



        },
      ),
    );
  }
}
