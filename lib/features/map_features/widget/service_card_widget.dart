import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/shape/border_radius.dart';
import '../../../const/shape/media_query.dart';
import '../../../const/theme/colors.dart';
import '../../public_features/functions/price_format/price_format_function.dart';

Widget buildServiceCard({
  required String title,
  required String imagePath,
  required double price,
  required bool isSelected,
  required VoidCallback onTap,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: isSelected ? primary2Color.withOpacity(0.2) : Colors.grey.shade300,
        borderRadius: getBorderRadiusFunc(10),
        border: isSelected ? Border.all(color: primary2Color, width: 2) : null,
      ),
      padding: EdgeInsets.all(10.sp),
      margin: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            imagePath,
            width: getWidth(context, 0.19.sp),
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'kalameh',
              fontSize: 17.sp,
              color: isSelected ? primary2Color : Colors.black,
            ),
          ),
          Container(
            width: getWidth(context, 0.4.sp),
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: isSelected ? primary2Color : Colors.grey.shade400,
              borderRadius: getBorderRadiusFunc(10),
            ),
            child: Text(
              getPriceFormat(price.toStringAsFixed(0)),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'peyda',
                  fontSize: 15.sp
              ),
            ),
          ),
        ],
      ),
    ),
  );
}