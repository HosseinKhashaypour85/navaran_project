import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../const/theme/colors.dart';

class LoadingStatesWidget extends StatelessWidget {
  const LoadingStatesWidget({super.key, required this.stuffObjectName});
  static const String screenId = 'loading_state';
  final String stuffObjectName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'درحال بارگذاری ${stuffObjectName} ...',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'kalameh',
                  fontSize: 18.sp,
                ),
              ),
              SpinKitDoubleBounce(size: 30, color: Colors.white,)
            ],
          ),
        ),
      ),
    );
  }
}
