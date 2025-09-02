import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navaran_project/const/theme/colors.dart';

Widget buildLocationInput({
  required IconData icon,
  required String hint,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8.sp),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: primary2Color),
                SizedBox(width: 8.sp),
                Expanded(
                  child: Text(
                    hint,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14.sp , fontFamily: 'peyda'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
