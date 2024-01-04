import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parking_kothay/Views/FindAndBookParking/Controller/find_and_book_parking_controller.dart';

class BookNowScreen extends StatefulWidget {
  BookNowScreen({super.key, required this.rating, required this.name});

  String rating;
  String name;

  @override
  State<BookNowScreen> createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {

  final _findAndBookParkingController = Get.put(FindAndBookParkingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF26AA75),
        title: Text(
          'Book Now',
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

               Obx(
            ()=> DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text(_findAndBookParkingController.selectedValue.value),
                      items: _findAndBookParkingController.lowestPrice.map((selectedType){
                        return DropdownMenuItem(
                          value: selectedType,
                            child: Text(selectedType));
                      }).toList(),
                      onChanged: (value){
                        _findAndBookParkingController.setSelectedValue('$value');
                        switch(value){
                          case "Lowest price":{
                            Text('5');
                          }
                          break;
                          case "Best rated":{
                            Text('10');
                          }
                          break;
                        }
                      },
                    ),

              ),
               ),


            Text(widget.name),
            SizedBox(height: 20.h,),
            Row(
              children: [
                RatingBar.builder(
                  initialRating: 0.0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemSize: 20.sp,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, index) =>  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15.sp,
                  ),
                  onRatingUpdate: (rating) {
                    _findAndBookParkingController.setRating(rating);
                  },
                ),
                SizedBox(width: 5.w,),
                Text(widget.rating.toString())
              ],
            ),

          ],
        ),
      ),
    );
  }
}
