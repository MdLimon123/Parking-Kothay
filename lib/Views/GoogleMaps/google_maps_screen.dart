import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  
  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(23.8041, 90.4152),
  zoom: 15);
  
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
          Container(
            height: 300.h,
            child: GoogleMap(
              mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
              },
            ),
          )
        ],
      ),
    );
  }
}
