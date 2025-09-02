import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/shape/border_radius.dart';
import '../../../const/shape/media_query.dart';
import '../../../const/theme/colors.dart';



class SignInErrorWidget extends StatefulWidget {
  const SignInErrorWidget({super.key});

  @override
  State<SignInErrorWidget> createState() => _SignInErrorWidgetState();
}

class _SignInErrorWidgetState extends State<SignInErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary2Color,
      body: Stack(
        children: [
          // موج بالای صفحه
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              height: 120.sp,
              color: Colors.orange,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/dontknow.png',
                  width: getWidth(context, 0.5),
                ),
                SizedBox(height: 10.sp), // فاصله بین عناصر
                Text(
                  'کاربر گرامی ! شما وارد حساب کاربری نشده اید !',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'irs',
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  'لطفا ابتدا وارد حساب کاربری خود شوید',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'irs',
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(
                  height: 20.sp,
                ),
                Padding(
                  padding:  EdgeInsets.all(10.sp),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      fixedSize: Size(
                        getAllWidth(context) - 10,
                        getHeight(context, 0.05),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: getBorderRadiusFunc(5)),
                    ),
                    onPressed: () {
                      // BlocProvider.of<TokenCheckCubit>(context).tokenChecker();
                      setState(() {});
                    },
                    child: Text(
                      'بررسی حساب کاربری',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'irs',
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
