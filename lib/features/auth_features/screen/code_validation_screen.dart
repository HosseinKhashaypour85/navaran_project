import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navaran_project/const/theme/colors.dart';
import 'package:navaran_project/features/auth_features/widget/otp_input.dart';
import 'package:navaran_project/features/home_features/screen/home_screen.dart';
import 'package:navaran_project/features/public_features/functions/navigator_animation/navigator_function.dart';
import 'package:navaran_project/features/public_features/functions/pref/save_phone_number.dart';
import 'package:navaran_project/features/public_features/screen/bottom_nav_bar_screen.dart';
import 'package:navaran_project/features/public_features/widget/snack_bar_widget.dart';

import '../../../const/shape/border_radius.dart';

class CodeValidationScreen extends StatefulWidget {
  const CodeValidationScreen({super.key});

  static const String screenId = 'code_validate';

  @override
  State<CodeValidationScreen> createState() => _CodeValidationScreenState();
}

class _CodeValidationScreenState extends State<CodeValidationScreen> {
  String phoneNum = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    loadPhoneNum();
  }

  void loadPhoneNum() async {
    String? phoneNumber = await SavePhoneNumber().getPhoneNumber();
    setState(() {
      phoneNum = phoneNumber ?? 'شماره یافت نشد';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bool isValid = controllers.every((controller)=> controller.text.isNotEmpty);
          if(isValid){
            navigateWithFadeAndRemoveAll(context, BottomNavBarScreen());
            getSnackBarWidget(context, 'ورود موفقیت آمیز بود!', Colors.green);
          } else{
            getSnackBarWidget(context, 'خطا در ورود !', Colors.red);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: getBorderRadiusFunc(100)),
        backgroundColor: primary2Color,
        child: Icon(Icons.arrow_forward , color: Colors.white,),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primary2Color,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.sp),
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: Text(
                  'کد ارسال شده به +98${phoneNum} را وارد کنید',
                  style: TextStyle(fontFamily: 'peyda', fontSize: 15.sp),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.sp),
                padding: EdgeInsets.all(5.sp),
                child: OtpInputWidget(controllers: controllers,),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ویرایش شماره همراه',
                  style: TextStyle(
                    color: primary2Color,
                    fontFamily: 'kalameh',
                    fontSize: 17.sp,
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
