import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LicensePlateWidget extends StatelessWidget {
  final String licensePlate;
  final String cityCode;
  final String alphaBet;

  const LicensePlateWidget({
    Key? key,
    required this.licensePlate,
    required this.cityCode,
    required this.alphaBet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue.shade800, width: 2.sp),
        borderRadius: BorderRadius.circular(10.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.sp,
            offset: Offset(0, 3.sp),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // City code (blue box)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 6.sp),
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
              borderRadius: BorderRadius.circular(6.sp),
            ),
            child: Text(
              cityCode,
              style: TextStyle(
                fontFamily: 'peyda',
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10.sp),
          // Iran flag text
          Text(
            'ایران',
            style: TextStyle(
              fontFamily: 'peyda',
              fontSize: 16.sp,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10.sp),
          // Alphabet
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 4.sp),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4.sp),
            ),
            child: Text(
              alphaBet,
              style: TextStyle(
                fontFamily: 'peyda',
                fontSize: 16.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10.sp),
          // License plate number
          Text(
            licensePlate,
            style: TextStyle(
              fontFamily: 'peyda',
              fontSize: 18.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
