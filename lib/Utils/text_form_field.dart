
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Widget textFormField({ String? hintText,
TextEditingController? controller,
Function(String)? onChanged, validation}){



  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.text,
    validator: validation,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0.w),
        borderRadius: BorderRadius.circular(5.r)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2.0.w),
        borderRadius: BorderRadius.circular(5.r)
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey,width: 2.0.w),
        borderRadius: BorderRadius.circular(5.r)
      ),
      errorStyle: TextStyle(
        fontSize: 14.sp,
        color: Colors.red
      )
    ),
  );
}