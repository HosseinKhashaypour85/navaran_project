import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navaran_project/const/shape/media_query.dart';
import 'package:navaran_project/const/theme/colors.dart';
import 'package:navaran_project/features/public_features/functions/pref/save_phone_number.dart';

import '../../auth_features/screen/auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String screenId = "profile";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient background
            Container(
              height: 180.h,
              width: getAllWidth(context),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3.w),
                    ),
                    child: CircleAvatar(
                      radius: 45.r,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person,
                          size: 50.sp,
                          color: Colors.blue.shade700),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  FutureBuilder<String?>(
                    future: SavePhoneNumber().getPhoneNumber(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'درحال بارگذاری...',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'peyda',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'خطا در بارگذاری',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'peyda',
                            fontSize: 14.sp,
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final phoneNumber = snapshot.data;
                        return Text(
                          phoneNumber != null ? '۰${phoneNumber}' : 'شماره یافت نشد',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'peyda',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Phone number card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.phone_android, color: Colors.blue.shade700, size: 22.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FutureBuilder<String?>(
                      future: SavePhoneNumber().getPhoneNumber(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(
                            'درحال بارگذاری شماره تلفن...',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontFamily: 'peyda',
                              fontSize: 14.sp,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'خطا در بارگذاری',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontFamily: 'peyda',
                              fontSize: 14.sp,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final phoneNumber = snapshot.data;
                          return Text(
                            phoneNumber != null ? '۰${phoneNumber}' : 'شماره یافت نشد',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontFamily: 'peyda',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  Icon(Icons.check_circle, color: Colors.green.shade600, size: 22.sp),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Menu buttons
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  _buildMenuButton(
                    title: "تخفیف ها و جایزه ها",
                    icon: Icons.local_offer_outlined,
                    color: Colors.orange.shade600,
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuButton(
                    title: "کیف پول",
                    icon: Icons.account_balance_wallet_outlined,
                    color: Colors.green.shade600,
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuButton(
                    title: "مسیر های منتخب",
                    icon: Icons.star_border_rounded,
                    color: Colors.purple.shade600,
                  ),
                ],
              ),
            ),

            // Logout button
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red.shade700,
                  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: Colors.red.shade300, width: 1.2),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  SavePhoneNumber().clearPhoneNumber();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AuthScreen.screenId,
                        (route) => false,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      "خروج از حساب کاربری",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'peyda',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menu button widget
  Widget _buildMenuButton({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {},
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22.sp),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'peyda',
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18.sp,
          color: Colors.grey.shade500,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        minLeadingWidth: 0,
      ),
    );
  }
}