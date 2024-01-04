import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_kothay/Models/location_model.dart';
import 'package:http/http.dart' as http;


class FindAndBookParkingController extends GetxController{

  var selectOption = false.obs;
  RxDouble rating = 0.0.obs;

  final TextEditingController searchController = TextEditingController();

  RxList<Result> searchResult = <Result>[].obs;
  Rx<Result?> selectedParking = Rx<Result?>(null);

  RxList<Result> searchPlaces = <Result>[].obs;
  final apiKey = "AIzaSyAnV5DJ0BUbVV0TwsrsJUyVeLKePmXs1YI";


  void setRating(double value){
    rating.value = value;
  }

  @override
 void onInit(){
    super.onInit();

  }


  var selectedValue = 'selected'.obs;
  var lowestPrice = [

    'Lowest price',
    'Best rated'

  ];

  void setSelectedValue(String value){
    selectedValue.value = value;
  }


  Future<void> searchParkingSlot( String query)async{
    final apiUrl = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=23.6850,90.3563&type=parking&rankby=distance&key=AIzaSyAnV5DJ0BUbVV0TwsrsJUyVeLKePmXs1YI&keyword=$query');

    try {
      final response = await http.get(apiUrl);
      if(response.statusCode == 200){
        final decodedResponse = json.decode(response.body);
        final location = LocationModel.fromJson(decodedResponse);
        searchResult.assignAll(location.results);
      }else{
        print("Error: ${response.statusCode}");
      }
    } on Exception catch (e) {
     print('Error $e');
    }
  }


  late BitmapDescriptor customMarkerIcon;
  Set<Marker> getMarkers(){

    return searchResult.map((result)=>
      Marker(
        markerId: MarkerId(result.geometry.location.lat.toString() + result.geometry.location.lng.toString()),
        position: LatLng(result.geometry.location.lat,result.geometry.location.lng),
        infoWindow: InfoWindow(
          title: "Parking Space ${result.name}",
          snippet:"Available",
          
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        onTap: (){
          selectedParking.value = result;
          // _showParkingDetailsDialog(
          //     result.name,
          //
          // result.rating.toString(),
          //     result.vicinity);

        }
      )


    ).toSet();


  }




  // void _showParkingDetailsDialog(, String? rating, String name)async{
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context){
  //         return AlertDialog(
  //           title: Text(title),
  //           content: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Row(
  //                 children: [
  //
  //                 ],
  //               ),
  //               SizedBox(height: 10.h,),
  //               const Text('Availability: Open 24/7'),
  //               SizedBox(height: 10.h,),
  //               const Text('Distance: 12 min')
  //
  //             ],
  //           ),
  //           actions: [
  //             TextButton(onPressed: (){
  //               Get.to(BookNowScreen(
  //                 rating: rating.toString(),
  //                 name: name
  //               ));
  //             },
  //                 child: const Text('Book Now')),
  //             TextButton(onPressed: (){
  //               Navigator.pop(context);
  //             },
  //                 child: const Text('Cancel')),
  //           ],
  //         );
  //       });
  // }

  // void searchPlace(String parkingPlace){
  //   List<Result> result = <Result>[].obs;
  //
  //   if(parkingPlace.isEmpty){
  //     result = searchResult;
  //   }else{
  //     result = searchResult.where((element) => element.name.toString().
  //     toLowerCase().contains(parkingPlace.toLowerCase())).toList();
  //   }
  //   searchPlaces.value = result;
  // }

}