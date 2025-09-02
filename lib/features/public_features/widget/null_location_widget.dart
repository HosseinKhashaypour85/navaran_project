import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:navaran_project/const/shape/border_radius.dart';
import 'package:navaran_project/const/shape/media_query.dart';
import 'package:navaran_project/const/theme/colors.dart';
import 'package:navaran_project/features/public_features/screen/bottom_nav_bar_screen.dart';

class NullLocationWidget extends StatefulWidget {
  const NullLocationWidget({super.key});

  static const String screenId = 'nullLoc';

  @override
  State<NullLocationWidget> createState() => _NullLocationWidgetState();
}

class _NullLocationWidgetState extends State<NullLocationWidget>
    with WidgetsBindingObserver {
  String locationError = 'لوکیشن شما یافت نشد !';
  bool _navigate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLocation();
    }
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
        print('location not found');
        setState(() {
          locationError = 'لوکیشن غیر قابل رویت !';
        });
        break;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        if (!_navigate && mounted) {
          _navigate = true;
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomNavBarScreen.screenId,
            (route) => false,
          );
        }
        setState(() {
          locationError = 'لوکیشن شما فعال شد !';
        });
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
                    _checkLocation();
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
