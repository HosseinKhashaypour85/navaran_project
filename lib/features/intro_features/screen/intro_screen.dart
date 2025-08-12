import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navaran_project/const/shape/media_query.dart';
import 'package:navaran_project/const/theme/colors.dart';
import 'package:navaran_project/features/auth_features/screen/auth_screen.dart';
import 'package:navaran_project/features/public_features/functions/navigator_animation/navigator_function.dart';
import 'package:navaran_project/features/public_features/functions/pre_values/pre_values.dart';
import 'package:navaran_project/features/public_features/functions/secure_storage/secure_storage.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  static const screenId = 'intro';

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    final String welcomeText =
        'برای ورود به دنیای سفر هوشمند شماره تلفن خود را وارد کنید. ما یک تایید برایتان ارسال میکنیم تا مطمعن شویم خود شما هستید !';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: primary2Color),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30.sp),
              Text(
                'به سوپر اپلیکیشن ناوران خوش آمدید !',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'kalameh',
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 40.sp),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  welcomeText,
                  style: TextStyle(
                    fontFamily: 'peyda',
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                    color: boxColor2,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 10.sp),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: boxColors,
                    fixedSize: Size(
                      getAllWidth(context) - 50,
                      getHeight(context, 0.06),
                    ),
                  ),
                  onPressed: () {
                    SecureStorage().saveUserToken('token');
                    navigateWithFadeAndRemoveAll(context, AuthScreen());
                  },
                  child: Text(
                    'احراز هویت',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'kalameh',
                      fontSize: 18.sp,
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
