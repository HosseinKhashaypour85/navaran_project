import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:navaran_project/const/shape/border_radius.dart';
import 'package:navaran_project/const/shape/media_query.dart';
import 'package:navaran_project/const/theme/colors.dart';

class NullLocationWidget extends StatefulWidget {
  const NullLocationWidget({super.key});

  static const String screenId = 'nullLoc';

  @override
  State<NullLocationWidget> createState() => _NullLocationWidgetState();
}

class _NullLocationWidgetState extends State<NullLocationWidget> {
  String locationError = 'لوکیشن شما یافت نشد !';

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.deniedForever:
        await Geolocator.openAppSettings();
        break;
      case LocationPermission.denied:
        await Geolocator.requestPermission();
        break;
      case LocationPermission.unableToDetermine:
        setState(() {
          locationError = 'لوکیشن غیر قابل رویت !';
        });
        break;
      case LocationPermission.whileInUse:
        break;
      case LocationPermission.always:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 80.sp),
              Image.asset(
                'assets/images/dontknow.png',
                width: getWidth(context, 0.7.sp),
              ),
              SizedBox(height: 50.sp),
              Text(
                locationError,
                style: TextStyle(fontFamily: 'peyda', fontSize: 16.sp),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 20.sp),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary2Color,
                    fixedSize: Size(
                      getAllWidth(context) - 40,
                      getHeight(context, 0.05.sp),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: getBorderRadiusFunc(10),
                    ),
                  ),
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                  },
                  child: Text(
                    'فعالسازی لوکیشن',
                    style: TextStyle(
                      fontFamily: 'kalameh',
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
