import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.padding});

  final String label;
  final EdgeInsets padding;
  final String groupValue;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(value !=groupValue){
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Transform.scale(
              scale: 1.1.w,
              child: Radio<String>(
                  value: value,
                  activeColor: const Color(0xFFCD0274),
                  groupValue: groupValue,
                  onChanged: (String? newValue){
                onChanged(newValue!);
                  }),
            ),
            SizedBox(height: 10.h,),

            Text(label,
            style: TextStyle(fontSize: 15.sp,
            fontWeight: FontWeight.w400),)
          ],
        ),
      ),
    );
  }
}
