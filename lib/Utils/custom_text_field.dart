import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
   CustomTextField({super.key, required this.hintText, this.controller,this.suffixIcon, this.prifixIcon});

  String hintText;
  TextEditingController? controller;
  Widget? suffixIcon;
  Widget? prifixIcon;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9.r)
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prifixIcon,
          hintStyle: TextStyle(fontSize: 16.sp),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.r),

          )
        ),
      ),
    );
  }
}
