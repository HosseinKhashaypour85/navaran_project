import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesTypeWidget extends StatelessWidget {
  final String label;
  final String imagePath;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ServicesTypeWidget({
    super.key,
    required this.label,
    required this.imagePath,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: SizedBox(
              height: 100.h,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Image.asset(
                      imagePath,
                      height: 60.h,
                      width: 60.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      label,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'kalameh',
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20.sp),
                  SizedBox(width: 16.w),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
