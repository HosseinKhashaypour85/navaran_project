import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navaran_project/const/theme/colors.dart';
import 'package:navaran_project/features/home_features/widget/services_type_widget.dart';
import 'package:navaran_project/features/intro_features/screen/splash_screen.dart';
import 'package:navaran_project/features/public_features/functions/navigator_animation/navigator_function.dart';

import '../../map_features/screen/map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String screenId = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'سرویس‌ها',
          style: TextStyle(
            fontFamily: 'kalameh',
            fontSize: 20.sp,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 22.sp,
              child: IconButton(
                icon: Icon(Icons.settings, color: Colors.grey.shade700),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 24.h),
          ServicesTypeWidget(
            label: 'درخواست سرویس',
            imagePath: 'assets/images/car.png',
            backgroundColor: Colors.blue,
            onTap: () {
              navigateWithFadeAndRemoveAll(context, MapScreen());
            },
          ),
          ServicesTypeWidget(
            label: 'درخواست بلیط هواپیما',
            imagePath: 'assets/images/plane.png',
            backgroundColor: boxColor3,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
