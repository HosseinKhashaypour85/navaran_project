import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navaran_project/const/shape/border_radius.dart';
import 'package:navaran_project/const/shape/media_query.dart';
import 'package:navaran_project/const/theme/colors.dart';
import 'package:navaran_project/features/public_features/functions/pre_values/pre_values.dart';

class FindingDriverScreen extends StatefulWidget {
  const FindingDriverScreen({super.key});

  static const String screenId = 'finding_driver';
  @override
  State<FindingDriverScreen> createState() => _FindingDriverScreenState();
}

class _FindingDriverScreenState extends State<FindingDriverScreen> {
  Future<void> showModalBottomSheetWidget(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 24.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40.sp,
                height: 4.sp,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.sp),
                ),
              ),
              SizedBox(height: 24.sp),

              // Icon
              Container(
                width: 80.sp,
                height: 80.sp,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 40.sp,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 20.sp),

              // Title
              Text(
                'لغو درخواست',
                style: TextStyle(
                  fontFamily: 'peyda',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8.sp),

              // Description
              Text(
                'آیا از لغو درخواست اطمینان دارید؟',
                style: TextStyle(
                  fontFamily: 'peyda',
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.sp),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: _outlinedButton(
                      'بازگشت',
                      () => Navigator.pop(context),
                      Colors.white,
                      context,
                    ),
                  ),
                  SizedBox(width: 5.sp),
                  Expanded(
                    child: _outlinedButton(
                      'لغو درخواست',
                      () => Navigator.pop(context),
                      Colors.red,
                      context,
                    ),
                  ),
                  SizedBox(width: 12.sp),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Improved button widgets
  Widget _elevatedButton(
    String text,
    Function() onPressed,
    Color color,
    BuildContext context,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.sp),
        fixedSize: Size(getWidth(context, 0.4.sp), getHeight(context, 0.06.sp)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.sp),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'peyda',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _outlinedButton(
    String text,
    Function() onPressed,
    Color? color,
    BuildContext context,
  ) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: color!,
        foregroundColor: Colors.grey[800],
        padding: EdgeInsets.symmetric(vertical: 16.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.sp),
        ),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'peyda',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String , dynamic>?;
    final tripId = arguments!['id'];
    print(tripId);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: getBorderRadiusFunc(100),
                    child: Image.asset(
                      PreValues().logoUrl,
                      width: getWidth(context, 0.4.sp),
                    ),
                  ),
                  SizedBox(height: 10.sp),
                  Text(
                    'درحال پیدا کردن نزدیک ترین راننده اطراف شما',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'peyda', fontSize: 16.sp),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.sp),
              child: Wrap(
                spacing: 8,
                children: [
                  _elevatedButton(
                    'لغو درخواست',
                    () {
                      showModalBottomSheetWidget(context);
                    },
                    Colors.red,
                    context,
                  ),
                  _elevatedButton('عجله دارم!', () {}, primary2Color, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
