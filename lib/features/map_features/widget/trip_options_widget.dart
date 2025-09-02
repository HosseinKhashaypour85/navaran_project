import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navaran_project/const/shape/border_radius.dart';

Widget buildTripOptionsWidget(IconData icon, String title, VoidCallback onTap ) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: getBorderRadiusFunc(5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 5.sp,
            children: [
              Icon(icon , color: Colors.white, size: 20.sp,),
              Text(title, style: TextStyle(fontFamily: 'peyda', fontSize: 15.sp , color: Colors.white)),
            ],
          ),
        ],
      ),
    ),
  );
}
