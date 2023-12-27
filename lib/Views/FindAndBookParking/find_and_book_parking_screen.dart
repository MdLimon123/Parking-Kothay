import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parking_kothay/Utils/custom_text_field.dart';
import 'package:parking_kothay/Views/FindAndBookParking/Controller/find_and_book_parking_controller.dart';
import 'package:parking_kothay/Views/GoogleMaps/google_maps_screen.dart';



class FindAndBookParkingScreen extends StatefulWidget {
  const FindAndBookParkingScreen({super.key});

  @override
  State<FindAndBookParkingScreen> createState() => _FindAndBookParkingScreenState();
}

class _FindAndBookParkingScreenState extends State<FindAndBookParkingScreen> {

  final _findAndBookController = Get.put(FindAndBookParkingController());
  final _locationController = TextEditingController();

  DateTime? selectedStartDateTime;

  DateTime? selectedEndDateTime;

  Future<void> _selectStartDate(BuildContext context)async{
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050),

    );

    if(picked !=null && picked != selectedStartDateTime){
      setState(() {
        selectedStartDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
            selectedStartDateTime?.hour ?? 0,
            selectedStartDateTime?.minute ?? 0
        );
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context)async{
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now());

    if(picked !=null && selectedStartDateTime !=null){
      setState(() {
        selectedStartDateTime = DateTime(
          selectedStartDateTime!.year,
          selectedStartDateTime!.month,
          selectedStartDateTime!.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }


  Future<void> _selectEndDate(BuildContext context)async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),

    );

    if(picked !=null && picked != selectedEndDateTime){
      setState(() {
        selectedEndDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            selectedEndDateTime?.hour ?? 0,
            selectedEndDateTime?.minute ?? 0
        );
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context)async{
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now());

    if(picked !=null && selectedEndDateTime !=null){
      setState(() {
        selectedEndDateTime = DateTime(
          selectedEndDateTime!.year,
          selectedEndDateTime!.month,
          selectedEndDateTime!.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF26AA75),
        title: Text('Find and Book Parking',
        style: TextStyle(fontSize: 20.sp,
        fontWeight: FontWeight.w800),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            children: [
              Text('Find and book parking in seconds',
              style: TextStyle(fontSize: 18.sp,
              fontWeight: FontWeight.w600),),

              SizedBox(height: 15.h,),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(()=> Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildButton(text:'Monthly',onTap: (){
                          _findAndBookController.selectOption.value=true;
                        },textColor:_findAndBookController.selectOption.value?Colors.white:const Color(0xFF1A1A1A),buttonColor:_findAndBookController.selectOption.value?const Color(0xFF13C33E):Colors.white)
                        , buildButton(text:'Hourly/Daily',onTap: (){
                          _findAndBookController.selectOption.value=false;
                        },textColor :_findAndBookController.selectOption.value?const Color(0xFF1A1A1A):Colors.white,buttonColor:_findAndBookController.selectOption.value?Colors.white:const Color(0xFF13C33E)),

                      ],
                    ),
                    SizedBox(height: 10.h,),
                    Text(_findAndBookController.selectOption.value? 'Book a parking space on a rolling monthly subscription':'Book a parking space on a one-off basis. Starting from half an hour.',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14.sp,
                      color: Colors.grey
                    ),),
                    SizedBox(height: 15.h,),
                    CustomTextField(
                      controller: _locationController,
                        hintText: 'Where would you like to park?',
                    prifixIcon: const Icon(Icons.location_on,
                    color: Colors.grey,),
                    suffixIcon: const Icon(Icons.directions,color: Color(0xFF26AA75),),),

                    SizedBox(height: 20.h,),
                    TextFormField(
                      readOnly: true,
                      decoration:  InputDecoration(
                        labelText:_findAndBookController.selectOption.value? 'Start parking form':'Enter after',
                        hintText: 'Start parking form',
                        border: const OutlineInputBorder()
                      ),
                      onTap: ()async{
                        await _selectStartDate(context);
                        await _selectStartTime(context);
                      },
                      controller: TextEditingController(
                        text: selectedStartDateTime !=null?
                            DateFormat('yyyy-MM-dd - HH:mm').format(selectedStartDateTime!):''
                      ),

                    ),
                    SizedBox(height: 20.h,),
                    TextFormField(
                      readOnly: true,
                      decoration:  InputDecoration(
                          labelText:_findAndBookController.selectOption.value? 'End parking form':'Exit before',
                          hintText: 'End parking form',
                          border: const OutlineInputBorder()
                      ),
                      onTap: ()async{
                        await _selectEndDate(context);
                        await _selectEndTime(context);
                      },
                      controller: TextEditingController(
                          text: selectedEndDateTime !=null?
                          DateFormat('yyyy-MM-dd - HH:mm').format(selectedEndDateTime!):''
                      ),

                    ),
                    
                    SizedBox(height: 30.h,),
                    
                    InkWell(
                      onTap: (){
                        Get.to(GoogleMapsScreen());
                      },
                      child: Container(
                        height: 50.h,
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF13C33E),
                          borderRadius: BorderRadius.circular(8.r)
                        ),
                        child: Text(_findAndBookController.selectOption.value?'Show paring spaces':'Search the best parking deals',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),),
                      ),
                    )

                  ],
                ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton({required String text,required Function() onTap,required Color textColor,buttonColor}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40.h,
        width: 120.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(
                color: const Color(0xFF13C33E)
            ),
            borderRadius: BorderRadius.circular(9.r)),
        child: Text(text,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: textColor)),
      ),
    );
  }
}
