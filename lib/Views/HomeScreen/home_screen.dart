import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parking_kothay/Utils/text_form_field.dart';
import 'package:parking_kothay/Views/HomeScreen/controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xFF26AA75),
        title: const Text('Search Your Parking location',
        style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.w),
          child: Column(
            children: [

              textFormField(
                controller: _homeController.addressSearch,
                onChanged: (String value){
                  _homeController.selectedAddress1.value = value;
                  debugPrint(value.toString());
                }
              ),

              ListView.separated(
                itemCount: _homeController.result !=null?
                    _homeController.result.length : 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                  return ListTile(
                    onTap: (){},
                    title: Text(_homeController.result[index].description),
                  );
        },
                  separatorBuilder:(context, index){
                  return Divider();
                  },
                  )
            ],
          ),
        ),
      ),
    );
  }
}
