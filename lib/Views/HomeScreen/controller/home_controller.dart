import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_kothay/Models/google_autocomplete.dart';
import 'package:parking_kothay/Utils/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart'as http;

class HomeController extends GetxController{

  TextEditingController addressSearch = TextEditingController();

  final uuid = const Uuid();

  RxBool isLoading = false.obs;
  RxString selectedAddress = ''.obs;
  RxString selectedAddress1 = ''.obs;

  String sessionToken = '';

 late GoogleAutoComplete googleAutoComplete;

  RxList<Prediction> result = <Prediction>[].obs;


  @override
  void onInit() {
    addressSearch.addListener(() {
      autoComplete();
    });
    super.onInit();
  }

Future<void> autoComplete()async{
    isLoading.value = false;
    if(sessionToken == ''){
      sessionToken = uuid.v4();
    }

    final url = '$baseUrl?input=${addressSearch.text}&sessionToken=$sessionToken&key=$apiKey&types=parking&language=en';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      isLoading.value = false;

      final data = jsonDecode(response.body.toString());
      if(data['status'] == 'OK'){
        googleAutoComplete = GoogleAutoComplete.fromJson(data);
        result.assignAll(googleAutoComplete!.predictions);
        debugPrint('BODY - ${googleAutoComplete.toJson()}');

      }
      if(data['status'] == 'ZERO_RESULTS'){
        Get.snackbar('Error', 'Address not found',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM);
      }
    }else{
      throw Exception('Failed to load google place data');
    }


}



}