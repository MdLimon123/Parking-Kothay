import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
   CustomTextField({super.key, required this.hintText, this.controller,this.suffixIcon, this.prifixIcon, this.onTap, this.onChanged});

  String hintText;
  TextEditingController? controller;
  Widget? suffixIcon;
  Widget? prifixIcon;
  void Function()? onTap;
   void Function(String)? onChanged;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9.r)
      ),
      child: TextFormField(
        controller: controller,
        onChanged:onChanged,
        onTap:onTap ,
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
