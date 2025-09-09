import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navaran_project/const/shape/border_radius.dart';
import 'package:navaran_project/const/shape/media_query.dart';
import 'package:navaran_project/const/theme/colors.dart';
import 'package:navaran_project/features/driver_founded_info/screen/driver_founded_screen.dart';
import 'package:navaran_project/features/map_features/screen/map_screen.dart';
import 'package:navaran_project/features/public_features/functions/pre_values/pre_values.dart';
import 'package:navaran_project/features/public_features/widget/snack_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../driver_founded_info/function/drivers_id_list_func.dart';
import '../../driver_founded_info/model/driver_model.dart';

class FindingDriverScreen extends StatefulWidget {
  const FindingDriverScreen({super.key});

  static const String screenId = 'finding_driver';

  @override
  State<FindingDriverScreen> createState() => _FindingDriverScreenState();
}

class _FindingDriverScreenState extends State<FindingDriverScreen> {
  bool isLoading = false;
  DriversIdListFunc driversIdListFunc = DriversIdListFunc();

  void selectTheDriver() async {
    DriverModel? randomDriver = await driversIdListFunc.selectRandomDriver();
    if (randomDriver == null) {
      print('راننده ای در دسترس نیست');
    } else {
      print(
        'name : ${randomDriver.name} , phone : ${randomDriver.phone} , car : ${randomDriver.carModel} , plate : ${randomDriver.licensePlate} , code : ${randomDriver.cityCode} , alphabet : ${randomDriver.cityCode}',
      );
    }
  }

  // save driver info
  Future<void> _saveDriverInfo(DriverModel driver) async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('driver_id', driver.id.toString());
    await prefs.setString('driver_name', driver.name);
    await prefs.setString('driver_phone', driver.phone);
    await prefs.setString('driver_carModel', driver.carModel);
    await prefs.setString('driver_plate', driver.licensePlate);
    await prefs.setString('driver_cityCode', driver.cityCode);
    await prefs.setString('driver_alphaBet', driver.alphaBet);
  }

  // get driver Info
  Future<DriverModel?> getDriverInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final driverName = prefs.getString('driver_name');
    final driverPhone = prefs.getString('driver_phone');
    final driverCar = prefs.getString('driver_carModel');
    final driverCity = prefs.getString('driver_cityCode');
    final driverAlphaBet = prefs.getString('driver_alphaBet');
    final driverPlate = prefs.getString('driver_plate');

    // بررسی کنید که تمام فیلدهای مورد نیاز غیر null باشند
    if (driverName != null &&
        driverPhone != null &&
        driverCar != null &&
        driverCity != null &&
        driverAlphaBet != null &&
        driverPlate != null) {
      return DriverModel(
        id: 1,
        // اگر ID از SharedPreferences دریافت نمی‌شود، مقدار پیش‌فرض
        name: driverName,
        phone: driverPhone,
        carModel: driverCar,
        licensePlate: driverPlate,
        cityCode: driverCity,
        alphaBet: driverAlphaBet,
      );
    }
    return null;
  }

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
                      () {
                        getSnackBarWidget(
                          context,
                          'درحال درخواست برای لغو سفر',
                          Colors.redAccent,
                        );
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            MapScreen.screenId,
                            (route) => false,
                          );
                        });
                      },
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

  Future<void> navigate() async {
    setState(() {
      isLoading = true;
    });

    DriverModel? randomDriver = await DriversIdListFunc().selectRandomDriver();

    if (randomDriver == null) {
      setState(() {
        isLoading = false;
      });
      getSnackBarWidget(context, "راننده‌ای یافت نشد", Colors.red);
      return;
    }

    await _saveDriverInfo(randomDriver);

    if (!mounted) {
      print('Widget is not mounted, navigation cancelled');
      return;
    }
    print('Navigating to DriverFoundedScreen');
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushNamed(
        context,
        DriverFoundedScreen.screenId,
        arguments: {'driverInfo': randomDriver},
      );
    });
  }

  @override
  void initState() {
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final normalMoneyCost = arguments!['NormalMoneyCost'] ?? 0;
    final vipMoneyCost = arguments!['VipMoneyCost'] ?? 0;
    print(normalMoneyCost);
    print(vipMoneyCost);
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
